Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8341D46BEDE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238795AbhLGPNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:5602 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhLGPN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821237"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821237"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289995"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:53 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 13/19] kvm: x86: Disable WRMSR interception for IA32_XFD on demand
Date:   Tue,  7 Dec 2021 19:03:53 -0500
Message-Id: <20211208000359.2853257-14-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Always intercepting IA32_XFD causes non-negligible overhead when
this register is updated frequently in the guest.

Disable WRMSR interception to IA32_XFD after fpstate reallocation
is completed. There are three options for when to disable the
interception:

  1) When emulating the 1st WRMSR which requires reallocation,
     disable interception before exiting to userapce with the
     assumption that the userspace VMM should not bounch back to
     the kernel if reallocation fails. However it's not good to
     design kernel based on application behavior. If due to bug
     the vCPU thread comes back to the kernel after reallocation
     fails, XFD passthrough may lead to host memory corruption
     when doing XSAVES for guest fpstate which has a smaller size
     than what guest XFD allows.

  2) Disable interception when coming back from the userspace VMM
     (for the 1st WRMSR which triggers reallocation). Re-check
     whether fpstate size can serve the new guest XFD value. Disable
     interception only when the check succeeds. This requires KVM
     to store guest XFD value in some place and then compare it
     to guest_fpu::user_xfeatures in the completion handler.

  3) Disable interception at the 2nd WRMSR which enables dynamic
     XSTATE features. If guest_fpu::user_xfeatures already includes
     bits for dynamic features set in guest XFD value, disable
     interception.

Currently 3) is implemented, with a flow like below:

    (G) WRMSR(IA32_XFD) which enables AMX for the FIRST time
    --trap to host--
    (HK) Emulate WRMSR and find fpstate size too small
    (HK) Reallocate fpstate
    --exit to userspace--
    (HU) do nothing
    --back to kernel via kvm_run--
    (HK) complete WRMSR emulation
    --enter guest--
    (G) do something
    (G) WRMSR(IA32_XFD) which disables AMX
    --trap to host--
    (HK) Emulate WRMSR and disable AMX in IA32_XFD
    --enter guest--
    (G) do something
    (G) WRMSR(IA32_XFD) which enables AMX for the SECOND time
    --trap to host--
    (HK) Emulate WRMSR and find fpstate size sufficient for AMX
    (HK) Disable WRMSR interception for IA32_XFD
    --enter guest--
    (G) WRMSR(IA32_XFD)
    (G) WRMSR(IA32_XFD)
    (G) WRMSR(IA32_XFD)
    ...

After disabling WRMSR interception, the guest directly updates
IA32_XFD which becomes out-of-sync with the host-side software
state (guest_fpstate::xfd and per-cpu xfd cache). This requires
KVM to call xfd_sync_state() to bring the software state in
sync with IA32_XFD register after VM-exit (before preemption
happens or exiting to userspace).

p.s. We have confirmed that SDM is being revised to say that
when setting IA32_XFD[18] the AMX register state is not
guaranteed to be preserved. This clarification avoids adding
mess for a creative guest which sets IA32_XFD[18]=1 before saving
active AMX state to its own storage.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.h             |  2 +-
 arch/x86/kvm/x86.c                 |  7 +++++++
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..60c27f9990e9 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -30,6 +30,7 @@ KVM_X86_OP(update_exception_bitmap)
 KVM_X86_OP(get_msr)
 KVM_X86_OP(set_msr)
 KVM_X86_OP(get_segment_base)
+KVM_X86_OP_NULL(set_xfd_passthrough)
 KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
 KVM_X86_OP(set_segment)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ac61f85e07b..7c97cc1fea89 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -640,6 +640,7 @@ struct kvm_vcpu_arch {
 	u64 smi_count;
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
+	bool xfd_out_of_sync;
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
@@ -1328,6 +1329,7 @@ struct kvm_x86_ops {
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	void (*set_xfd_passthrough)(struct kvm_vcpu *vcpu);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 971d60980d5b..6198b13c4846 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -160,6 +160,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_FS_BASE,
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
+	MSR_IA32_XFD,
 #endif
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_ESP,
@@ -1924,6 +1925,14 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 	return debugctl;
 }
 
+#ifdef CONFIG_X86_64
+static void vmx_set_xfd_passthrough(struct kvm_vcpu *vcpu)
+{
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
+	vcpu->arch.xfd_out_of_sync = true;
+}
+#endif
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -7657,6 +7666,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,
 	.cancel_hv_timer = vmx_cancel_hv_timer,
+	.set_xfd_passthrough = vmx_set_xfd_passthrough,
 #endif
 
 	.setup_mce = vmx_setup_mce,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4df2ac24ffc1..bf9d3051cd6c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -340,7 +340,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	13
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	14
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b195f4fa888f..d127b229dd29 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -974,6 +974,10 @@ bool kvm_check_guest_realloc_fpstate(struct kvm_vcpu *vcpu, u64 xfd)
 			vcpu->arch.guest_fpu.realloc_request = request;
 			return true;
 		}
+
+		/* Disable WRMSR interception if possible */
+		if (kvm_x86_ops.set_xfd_passthrough)
+			static_call(kvm_x86_set_xfd_passthrough)(vcpu);
 	}
 
 	return false;
@@ -10002,6 +10006,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (hw_breakpoint_active())
 		hw_breakpoint_restore();
 
+	if (vcpu->arch.xfd_out_of_sync)
+		xfd_sync_state();
+
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
