Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B83F3517F2
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhDARnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234884AbhDARlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmwsKY8J4nK6bYChJo7qBgeWMBlHl0uvtUs7chjpSMQ=;
        b=S5Mq4WRuLdTyELvN+FC4Ly20ap9keUJwkACeW0Jb6dCjPzScOZ5gnOj635tLRK0FIhz6SK
        mE2zA7YgvoScRHOQIiobL2CxZurCN1/CBcQE+DiA1B5M9LhcPd7IuitwuAxv1mmncgY/9A
        DM0v67+IK5Q/CGKy//BmZsXV5WLKLU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-yw6xFhj4MYqEz1LKH2Bguw-1; Thu, 01 Apr 2021 10:39:32 -0400
X-MC-Unique: yw6xFhj4MYqEz1LKH2Bguw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5765910074A1;
        Thu,  1 Apr 2021 14:38:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DED55D9CA;
        Thu,  1 Apr 2021 14:38:33 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/4] KVM: x86: remove tweaking of inject_page_fault
Date:   Thu,  1 Apr 2021 17:38:17 +0300
Message-Id: <20210401143817.1030695-5-mlevitsk@redhat.com>
In-Reply-To: <20210401143817.1030695-1-mlevitsk@redhat.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is no longer needed since page faults can now be
injected as regular exceptions in all the cases.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 20 --------------------
 arch/x86/kvm/vmx/nested.c | 23 -----------------------
 2 files changed, 43 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ff745d59ffcf..25840399841e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -53,23 +53,6 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	nested_svm_vmexit(svm);
 }
 
-static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
-{
-       struct vcpu_svm *svm = to_svm(vcpu);
-       WARN_ON(!is_guest_mode(vcpu));
-
-       if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
-	   !svm->nested.nested_run_pending) {
-               svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
-               svm->vmcb->control.exit_code_hi = 0;
-               svm->vmcb->control.exit_info_1 = fault->error_code;
-               svm->vmcb->control.exit_info_2 = fault->address;
-               nested_svm_vmexit(svm);
-       } else {
-               kvm_inject_page_fault(vcpu, fault);
-       }
-}
-
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -575,9 +558,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (ret)
 		return ret;
 
-	if (!npt_enabled)
-		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
-
 	svm_set_gif(svm, true);
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1c09b132c55c..8add4c27e718 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -418,26 +418,6 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
 	return 0;
 }
 
-
-static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
-		struct x86_exception *fault)
-{
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-
-	WARN_ON(!is_guest_mode(vcpu));
-
-	if (nested_vmx_is_page_fault_vmexit(vmcs12, fault->error_code) &&
-		!to_vmx(vcpu)->nested.nested_run_pending) {
-		vmcs12->vm_exit_intr_error_code = fault->error_code;
-		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
-				  PF_VECTOR | INTR_TYPE_HARD_EXCEPTION |
-				  INTR_INFO_DELIVER_CODE_MASK | INTR_INFO_VALID_MASK,
-				  fault->address);
-	} else {
-		kvm_inject_page_fault(vcpu, fault);
-	}
-}
-
 static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
 					       struct vmcs12 *vmcs12)
 {
@@ -2588,9 +2568,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 	}
 
-	if (!enable_ept)
-		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
-
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl)))
-- 
2.26.2

