Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1950731DBCF
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhBQO7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:59:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233688AbhBQO7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXC9PCMpIbRFpZekIm74aFA90Ezuln3DIDaR/mC8t7U=;
        b=ZeqArFTCWC/TMilOASZG3vJPu/jmbpUoDaPlu14cwFbcS3sjrkvO4BdrnkM2OakTPhlJdD
        kGzq7tcCagpYNW3Ez56rml53KwbTYeQus5U5nk+vYOWVUhAN1KAYZ6PrVq8afArUB8ktu4
        KAskvXihtc6VEV+uzuYQ6grFtKGBxkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-okOqrkgtNyG8-LCW3kbhLg-1; Wed, 17 Feb 2021 09:57:43 -0500
X-MC-Unique: okOqrkgtNyG8-LCW3kbhLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EC82CE64F;
        Wed, 17 Feb 2021 14:57:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18B0A10023AF;
        Wed, 17 Feb 2021 14:57:37 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/7] KVM: nSVM: fix running nested guests when npt=0
Date:   Wed, 17 Feb 2021 16:57:16 +0200
Message-Id: <20210217145718.1217358-6-mlevitsk@redhat.com>
In-Reply-To: <20210217145718.1217358-1-mlevitsk@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case of npt=0 on host,
nSVM needs the same .inject_page_fault tweak as VMX has,
to make sure that shadow mmu faults are injected as vmexits.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  5 ++++-
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1bc31e2e8fe0..53b9037259b5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -53,6 +53,23 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	nested_svm_vmexit(svm);
 }
 
+void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+{
+       struct vcpu_svm *svm = to_svm(vcpu);
+       WARN_ON(!is_guest_mode(vcpu));
+
+       if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
+	   !svm->nested.nested_run_pending) {
+               svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
+               svm->vmcb->control.exit_code_hi = 0;
+               svm->vmcb->control.exit_info_1 = fault->error_code;
+               svm->vmcb->control.exit_info_2 = fault->address;
+               nested_svm_vmexit(svm);
+       } else {
+               kvm_inject_page_fault(vcpu, fault);
+       }
+}
+
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -531,6 +548,7 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
 	if (ret)
 		return ret;
 
+
 	svm_set_gif(svm, true);
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 74a334c9902a..59e1767df030 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3915,7 +3915,10 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 
 static void svm_complete_mmu_init(struct kvm_vcpu *vcpu)
 {
-
+	if (!npt_enabled && is_guest_mode(vcpu)) {
+		WARN_ON(mmu_is_nested(vcpu));
+		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
+	}
 }
 
 static int is_disabled(void)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7b6ca0e49a14..fda80d56c6e3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -437,6 +437,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
+void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa, struct vmcb *vmcb12);
 void svm_leave_nested(struct vcpu_svm *svm);
 void svm_free_nested(struct vcpu_svm *svm);
-- 
2.26.2

