Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4629239
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 09:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbfEXH7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 03:59:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:8668 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389264AbfEXH7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 03:59:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 00:59:12 -0700
X-ExtLoop1: 1
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga008.jf.intel.com with ESMTP; 24 May 2019 00:59:08 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
Date:   Fri, 24 May 2019 15:56:35 +0800
Message-Id: <20190524075637.29496-2-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524075637.29496-1-tao3.xu@intel.com>
References: <20190524075637.29496-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds support for UMONITOR, UMWAIT and TPAUSE instructions
in kvm, and by default dont't expose it to kvm and provide a capability
to enable it.

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---
 Documentation/virtual/kvm/api.txt | 12 ++++++++++++
 arch/x86/include/asm/kvm_host.h   |  1 +
 arch/x86/include/asm/vmx.h        |  1 +
 arch/x86/kvm/cpuid.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c            |  4 ++++
 arch/x86/kvm/x86.c                |  7 +++++++
 arch/x86/kvm/x86.h                |  5 +++++
 include/uapi/linux/kvm.h          |  1 +
 8 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ba6c42c576dd..3d0196220486 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4997,6 +4997,18 @@ it hard or impossible to use it correctly.  The availability of
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
 Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
 
+7.19 KVM_CAP_ENABLE_USR_WAIT_PAUSE
+
+Architectures: x86
+Parameters: args[0] whether feature should be enabled or not
+
+With this capability enabled, a VM can use UMONITOR, UMWAIT and TPAUSE
+instructions. If the instruction causes a delay, the amount of
+time delayed is called here the physical delay. The physical delay is
+first computed by determining the virtual delay (the time to delay
+relative to the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT
+and TPAUSE cause an invalid-opcode exception(#UD).
+
 8. Other capabilities.
 ----------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 450d69a1e6fa..0da87c2e1c4d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -882,6 +882,7 @@ struct kvm_arch {
 	bool mwait_in_guest;
 	bool hlt_in_guest;
 	bool pause_in_guest;
+	bool enable_usr_wait_pause;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4e4133e86484..1c94b1009288 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -82,6 +82,7 @@
 #define SECONDARY_EXEC_PT_USE_GPA		0x01000000
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	0x00400000
 #define SECONDARY_EXEC_TSC_SCALING              0x02000000
+#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	0x04000000
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
 #define PIN_BASED_NMI_EXITING                   0x00000008
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 80a642a0143d..1cc001870a9d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -405,7 +405,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1ac167614032..a65ee7ea47b4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2247,6 +2247,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_RDRAND_EXITING |
 			SECONDARY_EXEC_ENABLE_PML |
 			SECONDARY_EXEC_TSC_SCALING |
+			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
 			SECONDARY_EXEC_ENABLE_VMFUNC |
@@ -3880,6 +3881,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
 	if (kvm_pause_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
+	if (!kvm_enable_usr_wait_pause(vmx->vcpu.kvm) ||
+		(vmcs_config.cpu_based_exec_ctrl & CPU_BASED_RDTSC_EXITING))
+		exec_control &= ~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 	if (!kvm_vcpu_apicv_active(vcpu))
 		exec_control &= ~(SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 536b78c4af6e..38a89c878c5d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3141,6 +3141,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_x86_ops->get_nested_state ?
 			kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
 		break;
+	case KVM_CAP_ENABLE_USR_WAIT_PAUSE:
+		r = boot_cpu_has(X86_FEATURE_WAITPKG);
+		break;
 	default:
 		break;
 	}
@@ -4622,6 +4625,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_ENABLE_USR_WAIT_PAUSE:
+		kvm->arch.enable_usr_wait_pause = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0868c5..37685e6679f3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -333,6 +333,11 @@ static inline bool kvm_pause_in_guest(struct kvm *kvm)
 	return kvm->arch.pause_in_guest;
 }
 
+static inline bool kvm_enable_usr_wait_pause(struct kvm *kvm)
+{
+	return kvm->arch.enable_usr_wait_pause;
+}
+
 DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b40d503..5a19a5984c57 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_ENABLE_USR_WAIT_PAUSE 173
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.20.1

