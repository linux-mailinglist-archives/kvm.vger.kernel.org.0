Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74E146BEE5
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbhLGPNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:5619 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238765AbhLGPNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821291"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821291"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:10:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461290108"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:10:02 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Date:   Tue,  7 Dec 2021 19:03:55 -0500
Message-Id: <20211208000359.2853257-16-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM needs to save the guest XFD_ERR value before this register
might be accessed by the host and restore it before entering the
guest.

This implementation saves guest XFD_ERR in two transition points:

  - When the vCPU thread exits to the userspace VMM;
  - When the vCPU thread is preempted;

XFD_ERR is cleared to ZERO right after saving the previous guest
value. Otherwise a stale guest value may confuse the host #NM
handler to misinterpret a non-XFD-related #NM as XFD related.

There is no need to save the host XFD_ERR value because the only
place where XFD_ERR is consumed outside of KVM is in #NM handler
(which can not be preempted by a vCPU thread). XFD_ERR should
always be observed as ZER0 outside of #NM hanlder, thus clearing
XFD_ERR meets the host expectation here.

The saved guest value is restored to XFD_ERR right before entering
the guest (with preemption disabled).

Current implementation still has two opens which we would like
to hear suggestions:

  1) Will #NM be triggered in host kernel?

  Now the code is written assuming above is true, and it's the only
  reason for saving guest XFD_ERR at preemption time. Otherwise the
  save is only required when the CPU enters ring-3 (either from the
  vCPU itself or other threads), by leveraging the "user-return
  notifier" machinery as suggested by Paolo.

  2) When to enable XFD_ERR save/restore?

  There are four options on the table:

    a) As long as guest cpuid has xfd enabled

       XFD_ERR save/restore is enabled in every VM-exit (if preemption
       or ret-to-userspace happens)

    b) When the guest sets IA32_XFD to 1 for the first time

       Indicate that guest OS supports XFD features. Because guest OS
       usually initializes IA32_XFD at boot time, XFD_ERR save/restore
       is enabled for almost every VM-exit (if preemption or ret-to-
       userspace happens).

       No save/restore for legacy guest OS which doesn't support XFD
       features at all (thus won't touch IA32_XFD).

    c) When the guest sets IA32_XFD to 0 for the first time

       Lazily enabling XFD_ERR save/restore until XFD features are
       used inside guest. However, this option doesn't work because
       XFD_ERR is set when #NM is raised. An VM-exit could happen
       between CPU raising #NM and guest #NM handler reading XFD_ERR
       (before setting XFD to 0). The very first XFD_ERR might be
       already clobbered by the host due to no save/restore in that
       small window.

    d) When the 1st guest #NM with non-zero XFD_ERR occurs

       Lazily enabling XFD_ERR save/restore until XFD features are
       used inside guest. This requires intercepting guest #NM until
       non-zero XFD_ERR occurs. If a guest with XFD in cpuid never
       launches an AMX application, it implies that #NM is always
       trapped thus adding a constant overhead which may be even
       higher than doing RDMSR in preemption path in a) and b):

         #preempts < #VMEXITS (no #NM trap) < #VMEXITS (#NM trap)

       The number of preemptions and ret-to-userspaces should be a
       small portion of total #VMEXITs in a healthy virtualization
       environment. Our gut-feeling is that adding at most one MSR
       read and one MSR write to the preempt/user-ret paths is possibly
       more efficient than increasing #VMEXITs due to trapping #NM.

For above analysis we plan to go option b), although this version
currently implements a). But we would like to hear other suggestions
before making this change.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kernel/fpu/core.c | 2 ++
 arch/x86/kvm/cpuid.c       | 5 +++++
 arch/x86/kvm/vmx/vmx.c     | 2 ++
 arch/x86/kvm/vmx/vmx.h     | 2 +-
 arch/x86/kvm/x86.c         | 5 +++++
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 5089f2e7dc22..9811dc98d550 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -238,6 +238,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
+	gfpu->xfd_err           = XFD_ERR_GUEST_DISABLED;
 	gfpu->user_xfeatures	= fpu_user_cfg.default_features;
 	gfpu->user_perm		= fpu_user_cfg.default_features;
 	fpu_init_guest_permissions(gfpu);
@@ -297,6 +298,7 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 		fpu->fpstate = guest_fps;
 		guest_fps->in_use = true;
 	} else {
+		fpu_save_guest_xfd_err(guest_fpu);
 		guest_fps->in_use = false;
 		fpu->fpstate = fpu->__task_fpstate;
 		fpu->__task_fpstate = NULL;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f3c61205bbf4..ea51b986ee67 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -219,6 +219,11 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
+	/* Enable saving guest XFD_ERR */
+	best = kvm_find_cpuid_entry(vcpu, 7, 0);
+	if (best && cpuid_entry_has(best, X86_FEATURE_AMX_TILE))
+		vcpu->arch.guest_fpu.xfd_err = 0;
+
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
 	if (!best)
 		vcpu->arch.guest_supported_xcr0 = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6198b13c4846..0db8bdf273e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -161,6 +161,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
 	MSR_IA32_XFD,
+	MSR_IA32_XFD_ERR,
 #endif
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_ESP,
@@ -7153,6 +7154,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 static void vmx_update_intercept_xfd(struct kvm_vcpu *vcpu)
 {
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_R, false);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_RW, false);
 }
 
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bf9d3051cd6c..0a00242a91e7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -340,7 +340,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	14
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	15
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d127b229dd29..8b033c9241d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4550,6 +4550,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 		kvm_steal_time_set_preempted(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
+	if (vcpu->preempted)
+		fpu_save_guest_xfd_err(&vcpu->arch.guest_fpu);
+
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 }
@@ -9951,6 +9954,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
 
+	fpu_restore_guest_xfd_err(&vcpu->arch.guest_fpu);
+
 	if (unlikely(vcpu->arch.switch_db_regs)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
