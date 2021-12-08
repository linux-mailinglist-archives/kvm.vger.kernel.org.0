Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6646BECD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhLGPNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238619AbhLGPNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821175"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821175"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289885"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:41 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Date:   Tue,  7 Dec 2021 19:03:50 -0500
Message-Id: <20211208000359.2853257-11-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Intel's eXtended Feature Disable (XFD) feature allows the software
to dynamically adjust fpstate buffer size for XSAVE features which
have large state.

WRMSR to IA32_XFD is intercepted so if the written value enables
a dynamic XSAVE feature the emulation code can exit to userspace
to trigger fpstate reallocation for the state.

Introduce a new KVM exit reason (KVM_EXIT_FPU_REALLOC) for this
purpose. If reallocation succeeds in fpu_swap_kvm_fpstate(), this
exit just bounces to userspace and then back. Otherwise the
userspace VMM should handle the error properly.

Use a new exit reason (instead of KVM_EXIT_X86_WRMSR) is clearer
and can be shared between WRMSR(IA32_XFD) and XSETBV. This also
avoids mixing with the userspace MSR machinery which is tied to
KVM_EXIT_X86_WRMSR today.

Also introduce a new MSR return type (KVM_MSR_RET_USERSPACE).
Currently MSR emulation returns to userspace only upon error or
per certain filtering rules via the userspace MSR mechinary.
This new return type indicates that emulation of certain MSR has
its own specific reason to bounce to userspace.

IA32_XFD is updated in two ways:

  - If reallocation is not required, the emulation code directly
    updates guest_fpu::xfd and then calls xfd_update_state() to
    update IA32_XFD and per-cpu cache;

  - If reallocation is triggered, above updates are completed as
    part of the fpstate reallocation process if succeeds;

RDMSR to IA32_XFD is not intercepted. fpu_swap_kvm_fpstate() ensures
the guest XFD value loaded into MSR before re-entering the guest.
Just save an unnecessary VM-exit here

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/vmx/vmx.c   |  8 +++++++
 arch/x86/kvm/x86.c       | 48 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h       |  1 +
 include/uapi/linux/kvm.h |  1 +
 4 files changed, 58 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 70d86ffbccf7..971d60980d5b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7141,6 +7141,11 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_update_intercept_xfd(struct kvm_vcpu *vcpu)
+{
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_R, false);
+}
+
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7181,6 +7186,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_XFD) && guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		vmx_update_intercept_xfd(vcpu);
+
 	set_cr4_guest_host_mask(vmx);
 
 	vmx_write_encls_bitmap(vcpu, NULL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91cc6f69a7ca..c83887cb55ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1873,6 +1873,16 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 {
 	u64 msr_reason = kvm_msr_reason(r);
 
+	/*
+	 * MSR emulation may need certain effect triggered in the
+	 * path transitioning to userspace (e.g. fpstate realloction).
+	 * In this case the actual exit reason and completion
+	 * func should have been set by the emulation code before
+	 * this point.
+	 */
+	if (r == KVM_MSR_RET_USERSPACE)
+		return 1;
+
 	/* Check if the user wanted to know about this MSR fault */
 	if (!(vcpu->kvm->arch.user_space_msr_mask & msr_reason))
 		return 0;
@@ -3692,6 +3702,44 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.msr_misc_features_enables = data;
 		break;
+#ifdef CONFIG_X86_64
+	case MSR_IA32_XFD:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+			return 1;
+
+		/* Setting unsupported bits causes #GP */
+		if (~XFEATURE_MASK_USER_DYNAMIC & data) {
+			kvm_inject_gp(vcpu, 0);
+			break;
+		}
+
+		WARN_ON_ONCE(current->thread.fpu.fpstate !=
+			     vcpu->arch.guest_fpu.fpstate);
+
+		/*
+		 * Check if fpstate reallocate is required. If yes, then
+		 * let the fpu core do reallocation and update xfd;
+		 * otherwise, update xfd here.
+		 */
+		if (kvm_check_guest_realloc_fpstate(vcpu, data)) {
+			vcpu->run->exit_reason = KVM_EXIT_FPU_REALLOC;
+			vcpu->arch.complete_userspace_io =
+				kvm_skip_emulated_instruction;
+			return KVM_MSR_RET_USERSPACE;
+		}
+
+		/*
+		 * Update IA32_XFD to the guest value so #NM can be
+		 * raised properly in the guest. Instead of directly
+		 * writing the MSR, call a helper to avoid breaking
+		 * per-cpu cached value in fpu core.
+		 */
+		fpregs_lock();
+		current->thread.fpu.fpstate->xfd = data;
+		xfd_update_state(current->thread.fpu.fpstate);
+		fpregs_unlock();
+		break;
+#endif
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 24a323980146..446ffa8c7804 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -460,6 +460,7 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
  */
 #define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
 #define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
+#define  KVM_MSR_RET_USERSPACE	4	/* Userspace handling */
 
 #define __cr4_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..0c7b301c7254 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_FPU_REALLOC      36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
