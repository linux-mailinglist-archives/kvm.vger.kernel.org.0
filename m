Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8AC22494A
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 08:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgGRGjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 02:39:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:30319 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgGRGjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jul 2020 02:39:01 -0400
IronPort-SDR: ev6P7L7z0mIVit7Iu2MSp7Uq3fJ74UOQDXLK8HbDSXwllsPqfbc6NukANXnSe/m+Ybxr06X48x
 k2ZWmeWCPLGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="151079554"
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="151079554"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 23:39:00 -0700
IronPort-SDR: 8qOsloI9kWxr5b75qRu2eShMkfvmVb62rKV9UZZPvWd7MKhoYZ+oh5ioxo8zaxMZKLUalUatoB
 ObhfseBBj/Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,366,1589266800"; 
   d="scan'208";a="486690952"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 23:39:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] KVM: x86: Read guest RIP from within the kvm_nested_vmexit tracepoint
Date:   Fri, 17 Jul 2020 23:38:49 -0700
Message-Id: <20200718063854.16017-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200718063854.16017-1-sean.j.christopherson@intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_rip_read() to read the guest's RIP for the nested VM-Exit
tracepoint instead of having the caller pass in the tracepoint.  Params
that are passed into a tracepoint are evaluated even if the tracepoint
is disabled, i.e. passing in RIP for VMX incurs a VMREAD and retpoline
to retrieve a value that may never be used, e.g. if the exit is due to a
hardware interrupt.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm/svm.c    | 2 +-
 arch/x86/kvm/trace.h      | 6 +++---
 arch/x86/kvm/vmx/nested.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 783330d0e7b88..1fea39ff33077 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2943,7 +2943,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
-		trace_kvm_nested_vmexit(svm->vmcb->save.rip, exit_code,
+		trace_kvm_nested_vmexit(vcpu, exit_code,
 					svm->vmcb->control.exit_info_1,
 					svm->vmcb->control.exit_info_2,
 					svm->vmcb->control.exit_int_info,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 9899ff0fa2534..00e567378ae1f 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -571,10 +571,10 @@ TRACE_EVENT(kvm_nested_intercepts,
  * Tracepoint for #VMEXIT while nested
  */
 TRACE_EVENT(kvm_nested_vmexit,
-	    TP_PROTO(__u64 rip, __u32 exit_code,
+	    TP_PROTO(struct kvm_vcpu *vcpu, __u32 exit_code,
 		     __u64 exit_info1, __u64 exit_info2,
 		     __u32 exit_int_info, __u32 exit_int_info_err, __u32 isa),
-	    TP_ARGS(rip, exit_code, exit_info1, exit_info2,
+	    TP_ARGS(vcpu, exit_code, exit_info1, exit_info2,
 		    exit_int_info, exit_int_info_err, isa),
 
 	TP_STRUCT__entry(
@@ -588,7 +588,7 @@ TRACE_EVENT(kvm_nested_vmexit,
 	),
 
 	TP_fast_assign(
-		__entry->rip			= rip;
+		__entry->rip			= kvm_rip_read(vcpu);
 		__entry->exit_code		= exit_code;
 		__entry->exit_info1		= exit_info1;
 		__entry->exit_info2		= exit_info2;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4d561edf6f9ca..6f81097cbc794 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5912,7 +5912,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	exit_intr_info = vmx_get_intr_info(vcpu);
 	exit_qual = vmx_get_exit_qual(vcpu);
 
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason, exit_qual,
+	trace_kvm_nested_vmexit(vcpu, exit_reason, exit_qual,
 				vmx->idt_vectoring_info, exit_intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
-- 
2.26.0

