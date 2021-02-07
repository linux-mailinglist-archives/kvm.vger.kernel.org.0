Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DE4312213
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 08:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBGG6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 01:58:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:48424 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBGG5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 01:57:51 -0500
IronPort-SDR: hJYpfRV30A7tFSWcGNfSambzgxq9/rErYeJDsRk1DKVVcQXullxhJbVr29lilSVGqjkEAhUpBZ
 9qfqwuBKnE7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="245660850"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="245660850"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 22:54:49 -0800
IronPort-SDR: aRct6Cqwi7ee/arxBAwtLS2aC5khR69VTHXzmEHPHsglW9rSfj38j6SaEkqLGNvhGEyxezT2VO
 38vgxqvckLxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="410376585"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2021 22:54:47 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
Date:   Sun,  7 Feb 2021 10:42:52 -0500
Message-Id: <20210207154256.52850-4-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210207154256.52850-1-jing2.liu@linux.intel.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

XFD allows the kernel to enable a feature state in XCR0 and to
receive a #NM trap when a task uses instructions accessing that state.
Kernel defines "struct fpu.state_mask" to indicate the saved xstate and
interact with the XFD hardware when needed via a simple conversion.
Once a dynamic feature is detected, "state_mask" is expanded and
"state_ptr" is dynamically allocated to hold the whole state. Meanwhile
once the state is not in INIT state, the corresponding XFD bit should
not be armed anymore.

In KVM, "guest_fpu" serves for any guest task working on this vcpu
during vmexit and vmenter. We provide a pre-allocated guest_fpu space
and entire "guest_fpu.state_mask" to avoid each dynamic features
detection on each vcpu task. Meanwhile, to ensure correctly
xsaves/xrstors guest state, set IA32_XFD as zero during vmexit and
vmenter.

For "current->thread.fpu", since host and guest probably have different
state and mask, it also need be switched to the right context when fpu
load and put.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kernel/fpu/init.c      |  1 +
 arch/x86/kernel/fpu/xstate.c    |  2 +
 arch/x86/kvm/vmx/vmx.c          | 76 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  1 +
 arch/x86/kvm/x86.c              | 69 +++++++++++++++++++++++++-----
 6 files changed, 141 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e5f33a0d0e2..6dedf3d22659 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1203,6 +1203,9 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
+	void (*xfd_load)(struct kvm_vcpu *vcpu);
+	void (*xfd_put)(struct kvm_vcpu *vcpu);
+
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 7e0c68043ce3..fbb761fc13ec 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -145,6 +145,7 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_min_size);
  * can be dynamically expanded to include some states up to this size.
  */
 unsigned int fpu_kernel_xstate_max_size;
+EXPORT_SYMBOL_GPL(fpu_kernel_xstate_max_size);
 
 /* Get alignment of the TYPE. */
 #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 080f3be9a5e6..9c471a0364e2 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -77,12 +77,14 @@ static struct xfeature_capflag_info xfeature_capflags[] __initdata = {
  * XSAVE buffer, both supervisor and user xstates.
  */
 u64 xfeatures_mask_all __read_mostly;
+EXPORT_SYMBOL_GPL(xfeatures_mask_all);
 
 /*
  * This represents user xstates, a subset of xfeatures_mask_all, saved in a
  * dynamic kernel XSAVE buffer.
  */
 u64 xfeatures_mask_user_dynamic __read_mostly;
+EXPORT_SYMBOL_GPL(xfeatures_mask_user_dynamic);
 
 static unsigned int xstate_offsets[XFEATURE_MAX] = { [ 0 ... XFEATURE_MAX - 1] = -1};
 static unsigned int xstate_sizes[XFEATURE_MAX]   = { [ 0 ... XFEATURE_MAX - 1] = -1};
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7fa54e78c45c..be3cc0f3ec6d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1167,6 +1167,75 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
+static void vmx_xfd_load(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_XFD)) {
+		vmx->host_ia32_xfd = xfirstuse_not_detected(vcpu->arch.user_fpu);
+		/*
+		 * Keep IA32_XFD as zero in hypervisor.
+		 * Guest non-zero IA32_XFD is restored until kvm_x86_ops.run
+		 */
+		if (vmx->host_ia32_xfd)
+			wrmsrl(MSR_IA32_XFD, 0);
+	}
+}
+
+static void vmx_xfd_put(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_XFD)) {
+		/* IA32_XFD register is kept as zero in hypervisor. */
+		if (vmx->host_ia32_xfd)
+			wrmsrl(MSR_IA32_XFD, vmx->host_ia32_xfd);
+		/* User (qemu) IA32_XFD_ERR should be zero. */
+		if (vmx->msr_ia32_xfd_err)
+			wrmsrl(MSR_IA32_XFD_ERR, 0);
+	}
+}
+
+/* Load guest XFD MSRs before entering. */
+static void xfd_guest_enter(struct vcpu_vmx *vmx)
+{
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_XFD)) {
+		if (vmx->msr_ia32_xfd)
+			wrmsrl(MSR_IA32_XFD, vmx->msr_ia32_xfd);
+		/*
+		 * We do not rdmsr here since in most cases
+		 * IA32_XFD_ERR is zero. One rare exception is that,
+		 * this vmenter follows a vmexit with non-zero
+		 * MSR_IA32_XFD_ERR and it doesn't change during
+		 * this interval.
+		 *
+		 * So just simply load the non-zero guest value.
+		 */
+		if (vmx->msr_ia32_xfd_err)
+			wrmsrl(MSR_IA32_XFD_ERR, vmx->msr_ia32_xfd_err);
+	}
+}
+
+/*
+ * Save guest XFD MSRs once vmexit since the registers may be changed
+ * when control is transferred out of KVM, e.g. preemption.
+ */
+static void xfd_guest_exit(struct vcpu_vmx *vmx)
+{
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_XFD)) {
+		rdmsrl(MSR_IA32_XFD, vmx->msr_ia32_xfd);
+		rdmsrl(MSR_IA32_XFD_ERR, vmx->msr_ia32_xfd_err);
+		/*
+		 * Clear the MSR_IA32_XFD to ensure correctly protect guest
+		 * fpu context in hypervisor.
+		 * No need to reset MSR_IA32_XFD_ERR in hypervisor since it
+		 * has no impact on others.
+		 */
+		if (vmx->msr_ia32_xfd)
+			wrmsrl(MSR_IA32_XFD, 0);
+	}
+}
+
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base)
 {
@@ -6735,6 +6804,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_guest_xsave_state(vcpu);
 
+	xfd_guest_enter(vmx);
+
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
@@ -6804,6 +6875,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_exit(vmx);
 
+	xfd_guest_exit(vmx);
+
 	kvm_load_host_xsave_state(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
@@ -7644,6 +7717,9 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
+	.xfd_load = vmx_xfd_load,
+	.xfd_put = vmx_xfd_put,
+
 	.update_exception_bitmap = update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d487f5a53a08..9a9ea37a29b1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -288,6 +288,7 @@ struct vcpu_vmx {
 	} shadow_msr_intercept;
 
 	/* eXtended Feature Disabling (XFD) MSRs */
+	u64 host_ia32_xfd;
 	u64 msr_ia32_xfd;
 	u64 msr_ia32_xfd_err;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9ca8b1e58afa..15908bc65d1c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9220,22 +9220,44 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 
 static void kvm_save_current_fpu(struct fpu *fpu)
 {
-	struct fpu *src_fpu = &current->thread.fpu;
+	struct fpu *cur_fpu = &current->thread.fpu;
 
+	fpu->state_ptr = cur_fpu->state_ptr;
+	fpu->state_mask = cur_fpu->state_mask;
 	/*
 	 * If the target FPU state is not resident in the CPU registers, just
 	 * memcpy() from current, else save CPU state directly to the target.
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
-		memcpy(&fpu->state, &src_fpu->state,
-		       fpu_kernel_xstate_min_size);
+		/*
+		 * No need to copy if dynamic feature is used, because
+		 * they just simply point to the same recent state.
+		 */
+		if (!cur_fpu->state_ptr)
+			memcpy(&fpu->state, &cur_fpu->state,
+			       fpu_kernel_xstate_min_size);
 	} else {
-		if (fpu->state_mask != src_fpu->state_mask)
-			fpu->state_mask = src_fpu->state_mask;
 		copy_fpregs_to_fpstate(fpu);
 	}
 }
 
+/*
+ * Swap fpu context to next fpu role.
+ *
+ * "current" fpu acts two roles: user contexts and guest contexts.
+ * Swap "current" fpu to next role to ensure correctly handle
+ * dynamic state buffers, e.g. in preemption case.
+ */
+static void kvm_load_next_fpu(struct fpu *next_fpu, u64 mask)
+{
+	struct fpu *cur_fpu = &current->thread.fpu;
+
+	cur_fpu->state_ptr = next_fpu->state_ptr;
+	cur_fpu->state_mask = next_fpu->state_mask;
+
+	__copy_kernel_to_fpregs(__xstate(next_fpu), mask);
+}
+
 /* Swap (qemu) user FPU context for the guest FPU context. */
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
@@ -9243,9 +9265,11 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.user_fpu);
 
+	if (static_cpu_has(X86_FEATURE_XFD) && kvm_x86_ops.xfd_load)
+		kvm_x86_ops.xfd_load(vcpu);
+
 	/* PKRU is separately restored in kvm_x86_ops.run.  */
-	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
-				~XFEATURE_MASK_PKRU);
+	kvm_load_next_fpu(vcpu->arch.guest_fpu, ~XFEATURE_MASK_PKRU);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -9260,7 +9284,10 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
-	copy_kernel_to_fpregs(vcpu->arch.user_fpu);
+	if (static_cpu_has(X86_FEATURE_XFD) && kvm_x86_ops.xfd_put)
+		kvm_x86_ops.xfd_put(vcpu);
+
+	kvm_load_next_fpu(vcpu->arch.user_fpu, -1);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -9840,11 +9867,13 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
+	struct xregs_state *xsave;
+
+	xsave = __xsave(vcpu->arch.guest_fpu);
 	fpstate_init(vcpu->arch.guest_fpu);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
+		xsave->header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
-
 	/*
 	 * Ensure guest xcr0 is valid for loading
 	 */
@@ -9920,6 +9949,21 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		pr_err("kvm: failed to allocate vcpu's fpu\n");
 		goto free_user_fpu;
 	}
+
+	vcpu->arch.guest_fpu->state_mask = xfeatures_mask_all &
+				~xfeatures_mask_user_dynamic;
+
+	/* If have dynamic features, initialize full context. */
+	if (xfeatures_mask_user_dynamic) {
+		vcpu->arch.guest_fpu->state_ptr =
+			kmalloc(fpu_kernel_xstate_max_size, GFP_KERNEL);
+		if (!vcpu->arch.guest_fpu->state_ptr)
+			goto free_guest_fpu;
+
+		vcpu->arch.guest_fpu->state_mask |=
+			xfeatures_mask_user_dynamic;
+	}
+
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
@@ -9936,7 +9980,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	r = kvm_x86_ops.vcpu_create(vcpu);
 	if (r)
-		goto free_guest_fpu;
+		goto free_guest_fpu_exp;
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -9947,6 +9991,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 	return 0;
 
+free_guest_fpu_exp:
+	kfree(vcpu->arch.guest_fpu->state_ptr);
 free_guest_fpu:
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 free_user_fpu:
@@ -10002,6 +10048,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+	kfree(vcpu->arch.guest_fpu->state_ptr);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 
 	kvm_hv_vcpu_uninit(vcpu);
-- 
2.18.4

