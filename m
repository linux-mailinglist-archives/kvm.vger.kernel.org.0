Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39830E842
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhBDAFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhBDADV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:03:21 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135C3C06121F
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w4so1551463ybc.7
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=luNrCKLtsPU27ckN7gNdItwjuKJ5CIfky359N7ChVXk=;
        b=p3Nfy1i5cJizykjazbp5BhDXRAb3f6qml14F9H38h0NuUPl4trhBkfZKE2UUmhpb+/
         qT7GIEp+B1EmNxvcts14/ih1sGmKy/3Jeyu8qsiPUobvLC6o+SlBD1dQj6sjG0XFJqua
         NuhJZwxcOkbQc8Jfl9Y1FT4ctIABenjNglrHM4zoudX0DJK3ybFJQlg1BdvCeutdnE6N
         PplSMDNIPEdMZviV4TYTMIvFuqpEsyNZRaOzlg+VPRKpUl1cU/ur5FNKl5Asdu8N1REQ
         9g/3DiBmMfmqz/ewtd/b/BpHnrL+WZa4b5R9m2aGxtV3GnSG8CrxiKVeP7YHQjabzCp6
         G42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=luNrCKLtsPU27ckN7gNdItwjuKJ5CIfky359N7ChVXk=;
        b=BP/lZdpHPPDdSqN4pAgT+v9bpGS7huxdWOGpmhDQKR9Cw4ABRY5FROBuQ+KLxKF1LS
         jJwr82/qroJXhjQJefcMHPKTE+apBn7v4v0mK+MkjsgoLK92ev7rBHG0BQVvye4elKxH
         XiYr+X9GDjQX5luqXd/DcoE5kBIvFMp1Y743g6wrtKtRNOf1brKmoRVWIQLh0sRvRs0+
         QTbi+ObbXVZ9FWNFuWwE33lEKYusa4gubvDvZ9geqLNMiTzwuKnF5WuwiD+W9LWFqat5
         suFyYFyErOauRD7RyG0XlsrMcQs5+tWnYDK9i4TPP9SSCesAPNGb4z2+sDzTzLkgpE/b
         9YEQ==
X-Gm-Message-State: AOAM530ofz0md3cMd+z2/Lb3grRt1wLkqzrUHLbL25o/3k5UbKRt4vH5
        tOv0auLY7cajnvk8jjg2RW+mfVcTlok=
X-Google-Smtp-Source: ABdhPJzWxYdN+wSCf25IEtYIx8ntCF1X3y1H+Pg95o847to6WtjhpgKVS/wU2bzzPBiimahIyNkWXZK5al0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a25:5557:: with SMTP id j84mr8065418ybb.472.1612396914318;
 Wed, 03 Feb 2021 16:01:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:17 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 12/12] KVM: nSVM: Trace VM-Enter consistency check failures
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use trace_kvm_nested_vmenter_failed() and its macro magic to trace
consistency check failures on nested VMRUN.  Tracing such failures by
running the buggy VMM as a KVM guest is often the only way to get a
precise explanation of why VMRUN failed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index add3cd4295e1..16fea02471a7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -29,6 +29,8 @@
 #include "lapic.h"
 #include "svm.h"
 
+#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
+
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 				       struct x86_exception *fault)
 {
@@ -216,14 +218,13 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
-	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
+	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
 
-	if (control->asid == 0)
+	if (CC(control->asid == 0))
 		return false;
 
-	if ((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
-	    !npt_enabled)
+	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
 		return false;
 
 	return true;
@@ -240,32 +241,36 @@ static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
 	 * CR0.PG && EFER.LME.
 	 */
 	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
-		if (!(save->cr4 & X86_CR4_PAE) || !(save->cr0 & X86_CR0_PE) ||
-		    kvm_vcpu_is_illegal_gpa(vcpu, save->cr3))
+		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
+		    CC(!(save->cr0 & X86_CR0_PE)) ||
+		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
 			return false;
 	}
 
-	return kvm_is_valid_cr4(&svm->vcpu, save->cr4);
+	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
+		return false;
+
+	return true;
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
 static bool nested_vmcb_valid_sregs(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save)
 {
-	if (!(save->efer & EFER_SVME))
+	if (CC(!(save->efer & EFER_SVME)))
 		return false;
 
-	if (((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||
-	    (save->cr0 & ~0xffffffffULL))
+	if (CC((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||
+	    CC(save->cr0 & ~0xffffffffULL))
 		return false;
 
-	if (!kvm_dr6_valid(save->dr6) || !kvm_dr7_valid(save->dr7))
+	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))
 		return false;
 
 	if (!nested_vmcb_check_cr3_cr4(svm, save))
 		return false;
 
-	if (!kvm_valid_efer(&svm->vcpu, save->efer))
+	if (CC(!kvm_valid_efer(&svm->vcpu, save->efer)))
 		return false;
 
 	return true;
@@ -367,12 +372,12 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_npt)
 {
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3)))
 		return -EINVAL;
 
 	if (!nested_npt && is_pae_paging(vcpu) &&
 	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
-		if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
 			return -EINVAL;
 	}
 
-- 
2.30.0.365.g02bc693789-goog

