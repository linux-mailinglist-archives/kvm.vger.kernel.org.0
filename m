Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82922761BE
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIWUNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:13:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:49297 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgIWUNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:13:51 -0400
IronPort-SDR: yDJMVdtSMJ3TSGZIM2Pajj/F1KYFCorrP1WVKxcSNQB/xraRGSDFTfpkgc7myziVdeF/Wks0Zs
 bpP7ZeuLn6tQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140472236"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140472236"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 13:13:51 -0700
IronPort-SDR: pwa6i3ryyt6bkcrHbLxCBosaqVRQoMgRNnImssPjEE9duRZ+xpHlT1kXrE0FZOQiCFHjLjcEBW
 ZD45bUkqgwYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="349004945"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2020 13:13:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] KVM: x86: Add intr/vectoring info and error code to kvm_exit tracepoint
Date:   Wed, 23 Sep 2020 13:13:46 -0700
Message-Id: <20200923201349.16097-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923201349.16097-1-sean.j.christopherson@intel.com>
References: <20200923201349.16097-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the kvm_exit tracepoint to align it with kvm_nested_vmexit in
terms of what information is captured.  On SVM, add interrupt info and
error code, while on VMX it add IDT ITD vectoring and error code.  This
sets the stage for macrofying the kvm_exit tracepoint definition so that
it can be reused for kvm_nested_vmexit without loss of information.

Opportunistically stuff a zero for VM_EXIT_INTR_INFO if the VM-Enter
failed, as the field is guaranteed to be invalid.  Note, it'd be
possible to further filter the interrupt/exception fields based on the
VM-Exit reason, but the helper is intended only for tracepoints, i.e.
an extra VMREAD or two is a non-issue, the failed VM-Enter case is just
low hanging fruit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  7 ++++++-
 arch/x86/kvm/svm/svm.c          |  9 ++++++++-
 arch/x86/kvm/trace.h            | 12 +++++++++---
 arch/x86/kvm/vmx/vmx.c          | 18 ++++++++++++++++--
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bc..3604e40586c7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1143,7 +1143,12 @@ struct kvm_x86_ops {
 	/* Returns actual tsc_offset set in active VMCS */
 	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
-	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2);
+	/*
+	 * Retrieve somewhat arbitrary exit information.  Intended to be used
+	 * only from within tracepoints to avoid VMREADs when tracing is off.
+	 */
+	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+			      u32 *exit_int_info, u32 *exit_int_info_err_code);
 
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2e2ff0f17e4a..d2b72d150f7b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2963,12 +2963,19 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_to:", save->last_excp_to);
 }
 
-static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
+static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+			      u32 *intr_info, u32 *error_code)
 {
 	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
 
 	*info1 = control->exit_info_1;
 	*info2 = control->exit_info_2;
+	*intr_info = control->exit_int_info;
+	if ((*intr_info & SVM_EXITINTINFO_VALID) &&
+	    (*intr_info & SVM_EXITINTINFO_VALID_ERR))
+		*error_code = control->exit_int_info_err;
+	else
+		*error_code = 0;
 }
 
 static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index bb5e44f83262..7e3ad6419f90 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -248,6 +248,8 @@ TRACE_EVENT(kvm_exit,
 		__field(	u32,	        isa             )
 		__field(	u64,	        info1           )
 		__field(	u64,	        info2           )
+		__field(	u32,	        intr_info	)
+		__field(	u32,	        error_code	)
 		__field(	unsigned int,	vcpu_id         )
 	),
 
@@ -257,13 +259,17 @@ TRACE_EVENT(kvm_exit,
 		__entry->isa            = isa;
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		kvm_x86_ops.get_exit_info(vcpu, &__entry->info1,
-					   &__entry->info2);
+					  &__entry->info2,
+					  &__entry->intr_info,
+					  &__entry->error_code);
 	),
 
-	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info %llx %llx",
+	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "
+		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",
 		  __entry->vcpu_id,
 		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa),
-		  __entry->guest_rip, __entry->info1, __entry->info2)
+		  __entry->guest_rip, __entry->info1, __entry->info2,
+		  __entry->intr_info, __entry->error_code)
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f9a0c6d5dc5..ac54f0ddc155 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5653,10 +5653,24 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
-static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
+static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+			      u32 *intr_info, u32 *error_code)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	*info1 = vmx_get_exit_qual(vcpu);
-	*info2 = vmx_get_intr_info(vcpu);
+	if (!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY)) {
+		*info2 = vmx->idt_vectoring_info;
+		*intr_info = vmx_get_intr_info(vcpu);
+		if (is_exception_with_error_code(*intr_info))
+			*error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
+		else
+			*error_code = 0;
+	} else {
+		*info2 = 0;
+		*intr_info = 0;
+		*error_code = 0;
+	}
 }
 
 static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
-- 
2.28.0

