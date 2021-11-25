Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176C945D1DD
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244448AbhKYA02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:16278 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353187AbhKYAYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432283"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432283"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:30 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042428"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:29 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v3 58/59] KVM: TDX: exit to user space on GET_QUOTE, SETUP_EVENT_NOTIFY_INTERRUPT
Date:   Wed, 24 Nov 2021 16:20:41 -0800
Message-Id: <4078d2cec2ca3fa4dd7d07f3fb9401a996c53b78.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

GET_QUOTE, SETUP_EVENT_NOTIFY_INTERRUPT TDG.VP.VMCALL requires user space
to handle them on behalf of kvm kernel module.

Introduce new kvm exit, KVM_EXIT_TDX, and when GET_QUOTE and
SETUP_EVENT_NOTIFY_INTERRUPT is called by TD guest, transfer the execution
to user space as KVM exit to the user space.  TDG_VP_VMCALL_INVALID_OPERAND
is set as default return value to avoid random value. User space should
update R10 if necessary.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c   | 113 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  57 ++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 53fc01f3bab1..a87db46477cc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -152,6 +152,18 @@ BUILD_TDVMCALL_ACCESSORS(p2, r13);
 BUILD_TDVMCALL_ACCESSORS(p3, r14);
 BUILD_TDVMCALL_ACCESSORS(p4, r15);
 
+#define TDX_VMCALL_REG_MASK_RBX	BIT_ULL(2)
+#define TDX_VMCALL_REG_MASK_RDX	BIT_ULL(3)
+#define TDX_VMCALL_REG_MASK_RBP	BIT_ULL(5)
+#define TDX_VMCALL_REG_MASK_RSI	BIT_ULL(6)
+#define TDX_VMCALL_REG_MASK_RDI	BIT_ULL(7)
+#define TDX_VMCALL_REG_MASK_R8	BIT_ULL(8)
+#define TDX_VMCALL_REG_MASK_R9	BIT_ULL(9)
+#define TDX_VMCALL_REG_MASK_R12	BIT_ULL(12)
+#define TDX_VMCALL_REG_MASK_R13	BIT_ULL(13)
+#define TDX_VMCALL_REG_MASK_R14	BIT_ULL(14)
+#define TDX_VMCALL_REG_MASK_R15	BIT_ULL(15)
+
 static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
 {
 	return kvm_r10_read(vcpu);
@@ -1122,6 +1134,91 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_vp_vmcall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
+	__u64 reg_mask;
+
+	tdvmcall_set_return_code(vcpu, tdx_vmcall->status_code);
+	tdvmcall_set_return_val(vcpu, tdx_vmcall->out_r11);
+
+	reg_mask = kvm_rcx_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R12)
+		kvm_r12_write(vcpu, tdx_vmcall->out_r12);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R13)
+		kvm_r13_write(vcpu, tdx_vmcall->out_r13);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R14)
+		kvm_r14_write(vcpu, tdx_vmcall->out_r14);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R15)
+		kvm_r15_write(vcpu, tdx_vmcall->out_r15);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RBX)
+		kvm_rbx_write(vcpu, tdx_vmcall->out_rbx);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDI)
+		kvm_rdi_write(vcpu, tdx_vmcall->out_rdi);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RSI)
+		kvm_rsi_write(vcpu, tdx_vmcall->out_rsi);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R8)
+		kvm_r8_write(vcpu, tdx_vmcall->out_r8);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R9)
+		kvm_r9_write(vcpu, tdx_vmcall->out_r9);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDX)
+		kvm_rdx_write(vcpu, tdx_vmcall->out_rdx);
+
+	return 1;
+}
+
+static int tdx_vp_vmcall_to_user(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
+	__u64 reg_mask;
+
+	vcpu->arch.complete_userspace_io = tdx_complete_vp_vmcall;
+	memset(tdx_vmcall, 0, sizeof(*tdx_vmcall));
+
+	vcpu->run->exit_reason = KVM_EXIT_TDX;
+	vcpu->run->tdx.type = KVM_EXIT_TDX_VMCALL;
+	tdx_vmcall->type = tdvmcall_exit_type(vcpu);
+	tdx_vmcall->subfunction = tdvmcall_exit_reason(vcpu);
+
+	reg_mask = kvm_rcx_read(vcpu);
+	tdx_vmcall->reg_mask = reg_mask;
+	if (reg_mask & TDX_VMCALL_REG_MASK_R12)
+		tdx_vmcall->in_r12 = kvm_r12_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R13)
+		tdx_vmcall->in_r13 = kvm_r13_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R14)
+		tdx_vmcall->in_r14 = kvm_r14_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R15)
+		tdx_vmcall->in_r15 = kvm_r15_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RBX)
+		tdx_vmcall->in_rbx = kvm_rbx_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDI)
+		tdx_vmcall->in_rdi = kvm_rdi_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RSI)
+		tdx_vmcall->in_rsi = kvm_rsi_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R8)
+		tdx_vmcall->in_r8 = kvm_r8_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R9)
+		tdx_vmcall->in_r9 = kvm_r9_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDX)
+		tdx_vmcall->in_rdx = kvm_rdx_read(vcpu);
+
+	/* notify userspace to handle the request */
+	return 0;
+}
+
+static int tdx_get_quote(struct kvm_vcpu *vcpu)
+{
+	gpa_t gpa = tdvmcall_p1_read(vcpu);
+
+	if (!IS_ALIGNED(gpa, PAGE_SIZE)) {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+
+	return tdx_vp_vmcall_to_user(vcpu);
+}
+
 static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
@@ -1130,6 +1227,18 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_setup_event_notify_interrupt(struct kvm_vcpu *vcpu)
+{
+	u64 vector = tdvmcall_p1_read(vcpu);
+
+	if (!(vector >= 32 && vector <= 255)) {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+
+	return tdx_vp_vmcall_to_user(vcpu);
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1158,8 +1267,12 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_mmio(vcpu);
 	case TDG_VP_VMCALL_MAP_GPA:
 		return tdx_map_gpa(vcpu);
+	case TDG_VP_VMCALL_GET_QUOTE:
+		return tdx_get_quote(vcpu);
 	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
+	case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
+		return tdx_setup_event_notify_interrupt(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bb49e095867e..6d036b3ccd25 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -231,6 +231,60 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_tdx_exit {
+#define KVM_EXIT_TDX_VMCALL	1
+	__u32 type;
+	__u32 pad;
+
+	union {
+		struct kvm_tdx_vmcall {
+			/*
+			 * Guest-Host-Communication Interface for TDX spec
+			 * defines the ABI for TDG.VP.VMCALL.
+			 */
+
+			/* Input parameters: guest -> VMM */
+			__u64 type;		/* r10 */
+			__u64 subfunction;	/* r11 */
+			__u64 reg_mask;		/* rcx */
+			/*
+			 * Subfunction specific.
+			 * Registers are used in this order to pass input
+			 * arguments.  r12=arg0, r13=arg1, etc.
+			 */
+			__u64 in_r12;
+			__u64 in_r13;
+			__u64 in_r14;
+			__u64 in_r15;
+			__u64 in_rbx;
+			__u64 in_rdi;
+			__u64 in_rsi;
+			__u64 in_r8;
+			__u64 in_r9;
+			__u64 in_rdx;
+
+			/* Output parameters: VMM -> guest */
+			__u64 status_code;	/* r10 */
+			/*
+			 * Subfunction specific.
+			 * Registers are used in this order to output return
+			 * values.  r11=ret0, r12=ret1, etc.
+			 */
+			__u64 out_r11;
+			__u64 out_r12;
+			__u64 out_r13;
+			__u64 out_r14;
+			__u64 out_r15;
+			__u64 out_rbx;
+			__u64 out_rdi;
+			__u64 out_rsi;
+			__u64 out_r8;
+			__u64 out_r9;
+			__u64 out_rdx;
+		} vmcall;
+	} u;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -270,6 +324,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_TDX              50	/* dump number to avoid conflict. */
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -487,6 +542,8 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_TDX_VMCALL */
+		struct kvm_tdx_exit tdx;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1

