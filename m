Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C263A19
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 19:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfGIRYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 13:24:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:18135 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbfGIRYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 13:24:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 10:24:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,470,1557212400"; 
   d="scan'208";a="176562861"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga002.jf.intel.com with ESMTP; 09 Jul 2019 10:24:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: nVMX: trace nested VM-Enter failures detected by H/W
Date:   Tue,  9 Jul 2019 10:24:02 -0700
Message-Id: <20190709172402.2934-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190709172402.2934-1-sean.j.christopherson@intel.com>
References: <20190709172402.2934-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently added tracepoint for logging nested VM-Enter failures
instead of spamming the kernel log when hardware detects a consistency
check failure.  Take the opportunity to print the name of the error code
instead of dumping the raw hex number, but limit the symbol table to
error codes that can reasonably be encountered by KVM.

Add an equivalent tracepoint in nested_vmx_check_vmentry_hw(), e.g. so
that tracing of "invalid control field" errors isn't suppressed when
nested early checks are enabled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/vmx.h | 14 ++++++++++++++
 arch/x86/kvm/trace.h       |  9 ++++++---
 arch/x86/kvm/vmx/nested.c  | 15 ++++++++++-----
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4e4133e86484..038ab715307f 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -575,6 +575,20 @@ enum vm_instruction_error_number {
 	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
 };
 
+/*
+ * VM-instruction errors that can be encountered on VM-Enter, used to trace
+ * nested VM-Enter failures reported by hardware.  Errors unique to VM-Enter
+ * from a SMI Transfer Monitor are not included as things have gone seriously
+ * sideways if we get one of those...
+ */
+#define VMX_VMENTER_INSTRUCTION_ERRORS \
+	{ VMXERR_VMLAUNCH_NONCLEAR_VMCS,		"VMLAUNCH_NONCLEAR_VMCS" }, \
+	{ VMXERR_VMRESUME_NONLAUNCHED_VMCS,		"VMRESUME_NONLAUNCHED_VMCS" }, \
+	{ VMXERR_VMRESUME_AFTER_VMXOFF,			"VMRESUME_AFTER_VMXOFF" }, \
+	{ VMXERR_ENTRY_INVALID_CONTROL_FIELD,		"VMENTRY_INVALID_CONTROL_FIELD" }, \
+	{ VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,	"VMENTRY_INVALID_HOST_STATE_FIELD" }, \
+	{ VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS,	"VMENTRY_EVENTS_BLOCKED_BY_MOV_SS" }
+
 enum vmx_l1d_flush_state {
 	VMENTER_L1D_FLUSH_AUTO,
 	VMENTER_L1D_FLUSH_NEVER,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 50fbe2d5db83..755daab45f24 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1467,18 +1467,21 @@ TRACE_EVENT(kvm_hv_send_ipi_ex,
  * Tracepoint for failed nested VMX VM-Enter.
  */
 TRACE_EVENT(kvm_nested_vmenter_failed,
-	TP_PROTO(const char *msg),
-	TP_ARGS(msg),
+	TP_PROTO(const char *msg, u32 err),
+	TP_ARGS(msg, err),
 
 	TP_STRUCT__entry(
 		__field(const char *, msg)
+		__field(u32, err)
 	),
 
 	TP_fast_assign(
 		__entry->msg = msg;
+		__entry->err = err;
 	),
 
-	TP_printk("%s", __entry->msg)
+	TP_printk("%s%s", __entry->msg, !__entry->err ? "" :
+		__print_symbolic(__entry->err, VMX_VMENTER_INSTRUCTION_ERRORS))
 );
 
 #endif /* _TRACE_KVM_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3bfce3f507c7..9a0dd784bca0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -23,7 +23,7 @@ module_param(nested_early_check, bool, S_IRUGO);
 ({									\
 	bool failed = (consistency_check);				\
 	if (failed)							\
-		trace_kvm_nested_vmenter_failed(#consistency_check);	\
+		trace_kvm_nested_vmenter_failed(#consistency_check, 0);	\
 	failed;								\
 })
 
@@ -2840,9 +2840,13 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
 	if (vm_fail) {
+		u32 error = vmcs_read32(VM_INSTRUCTION_ERROR);
+
 		preempt_enable();
-		WARN_ON_ONCE(vmcs_read32(VM_INSTRUCTION_ERROR) !=
-			     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+
+		trace_kvm_nested_vmenter_failed(
+			"early hardware check VM-instruction error: ", error);
+		WARN_ON_ONCE(error != VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 		return 1;
 	}
 
@@ -5256,8 +5260,9 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 		return false;
 
 	if (unlikely(vmx->fail)) {
-		pr_info_ratelimited("%s failed vm entry %x\n", __func__,
-				    vmcs_read32(VM_INSTRUCTION_ERROR));
+		trace_kvm_nested_vmenter_failed(
+			"hardware VM-instruction error: ",
+			vmcs_read32(VM_INSTRUCTION_ERROR));
 		return true;
 	}
 
-- 
2.22.0

