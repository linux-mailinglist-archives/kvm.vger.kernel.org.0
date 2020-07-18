Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EBA224945
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 08:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgGRGjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 02:39:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:30320 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgGRGjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jul 2020 02:39:02 -0400
IronPort-SDR: T89Lh71XERJ64S+GDQRZW50Vu+C9BDa/sB24ZUE1f4D66DOln0I3XOGSdqcZQZeIgOyylWnbBY
 l9jkcIoHt0gA==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="151079558"
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="151079558"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 23:39:01 -0700
IronPort-SDR: 91aWTCWCr0xpEKdiuoIXb2gCOWaalXug0gaZjGuqKjRmovEE1CYY6zyLhfVgx4Sgcw8MdV7me1
 BBSpIM7hNbNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="486690973"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 23:39:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] KVM: x86: Use common definition for kvm_nested_vmexit tracepoint
Date:   Fri, 17 Jul 2020 23:38:53 -0700
Message-Id: <20200718063854.16017-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200718063854.16017-1-sean.j.christopherson@intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the newly introduced TRACE_EVENT_KVM_EXIT to define the guts of
kvm_nested_vmexit so that it captures and prints the same information as
with kvm_exit.  This has the bonus side effect of fixing the interrupt
info and error code printing for the case where they're invalid, e.g. if
the exit was a failed VM-Entry.  This also sets the stage for retrieving
EXIT_QUALIFICATION and VM_EXIT_INTR_INFO in nested_vmx_reflect_vmexit()
if and only if the VM-Exit is being routed to L1.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm/svm.c    |  7 +------
 arch/x86/kvm/trace.h      | 34 +---------------------------------
 arch/x86/kvm/vmx/nested.c |  5 +----
 3 files changed, 3 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8ab3413094500..133581c5b0dc0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2950,12 +2950,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
-		trace_kvm_nested_vmexit(vcpu, exit_code,
-					svm->vmcb->control.exit_info_1,
-					svm->vmcb->control.exit_info_2,
-					svm->vmcb->control.exit_int_info,
-					svm->vmcb->control.exit_int_info_err,
-					KVM_ISA_SVM);
+		trace_kvm_nested_vmexit(exit_code, vcpu, KVM_ISA_SVM);
 
 		vmexit = nested_svm_exit_special(svm);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6cb75ba494fcd..e29576985e03a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -579,39 +579,7 @@ TRACE_EVENT(kvm_nested_intercepts,
 /*
  * Tracepoint for #VMEXIT while nested
  */
-TRACE_EVENT(kvm_nested_vmexit,
-	    TP_PROTO(struct kvm_vcpu *vcpu, __u32 exit_code,
-		     __u64 exit_info1, __u64 exit_info2,
-		     __u32 exit_int_info, __u32 exit_int_info_err, __u32 isa),
-	    TP_ARGS(vcpu, exit_code, exit_info1, exit_info2,
-		    exit_int_info, exit_int_info_err, isa),
-
-	TP_STRUCT__entry(
-		__field(	__u64,		rip			)
-		__field(	__u32,		exit_code		)
-		__field(	__u64,		exit_info1		)
-		__field(	__u64,		exit_info2		)
-		__field(	__u32,		exit_int_info		)
-		__field(	__u32,		exit_int_info_err	)
-		__field(	__u32,		isa			)
-	),
-
-	TP_fast_assign(
-		__entry->rip			= kvm_rip_read(vcpu);
-		__entry->exit_code		= exit_code;
-		__entry->exit_info1		= exit_info1;
-		__entry->exit_info2		= exit_info2;
-		__entry->exit_int_info		= exit_int_info;
-		__entry->exit_int_info_err	= exit_int_info_err;
-		__entry->isa			= isa;
-	),
-	TP_printk("rip: 0x%016llx reason: %s%s%s ext_inf1: 0x%016llx "
-		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
-		  __entry->rip,
-		  kvm_print_exit_reason(__entry->exit_code, __entry->isa),
-		  __entry->exit_info1, __entry->exit_info2,
-		  __entry->exit_int_info, __entry->exit_int_info_err)
-);
+TRACE_EVENT_KVM_EXIT(kvm_nested_vmexit);
 
 /*
  * Tracepoint for #VMEXIT reinjected to the guest
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fc70644b916ca..f437d99f4db09 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5912,10 +5912,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	exit_intr_info = vmx_get_intr_info(vcpu);
 	exit_qual = vmx_get_exit_qual(vcpu);
 
-	trace_kvm_nested_vmexit(vcpu, exit_reason, exit_qual,
-				vmx->idt_vectoring_info, exit_intr_info,
-				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
-				KVM_ISA_VMX);
+	trace_kvm_nested_vmexit(exit_reason, vcpu, KVM_ISA_VMX);
 
 	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
 	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
-- 
2.26.0

