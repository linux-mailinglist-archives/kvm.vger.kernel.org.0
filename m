Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F009332B57E
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379526AbhCCHRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581401AbhCBSvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:51:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48157C061356
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 09:45:24 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i2so23505564ybl.16
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 09:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=31LBsCqBADvCpwzM4dtkr4Bc7blALb2wIAK9gYaWhMs=;
        b=kS+5o5XBkzLc3LmDd6zKQMYAuWgKUI6LLx3EbzgFmquNFDjVDHug4e2ci5RKwhpouv
         VVuT1KFIc9aXLqunWf8KHi5v7W2wv6IwPI2vaE9KX8jG9HYagIYkHTKgzMLHzBCuGnNK
         UjfX2ngfLmM6c9p5QiTC84kEjXMWiUrev3jxbjX+44pDzb/IgADhqAA4ZCrXhynw+ZYi
         MTn/SvoOXusyQv7OrY4ZjVsOs9g2qhKp3x7f3NL+E7OOdkNUL9hyJZjdJHq1KbQm7epV
         XL6c8z/xRYVaQW5EsKawM6ca+OALA+TYEFzyQqtZDbaEUcRTaChXPS0ar6xCN7N/CpJH
         MmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=31LBsCqBADvCpwzM4dtkr4Bc7blALb2wIAK9gYaWhMs=;
        b=PnkIWc/cXFJ3EIsAq/ZYot9EPvk2WQjKIEPmq1Le9/SN6SqnOnxNiyMzW5JKmFQqd8
         kOkO8j20Nm9OkynlKaTtV4lplA5a6i/C3iivffeqHiolxQVc/mrJueEI3ePZhW/nIi36
         a+YEJieSK+8zdzSO1h+D2F1ssU18k8Xfju1vIPQ6jsHSfCl6LEpOsHTUxqMIQUFJZl81
         IALE9vWk7yE2/nXWFEgWJbeRZuEXJp1cZ0K35b00GnGInousu2zWXMJis3Gp3P68vGIt
         Ue03Wy28laZjUzc23r23qDKvV6QZQx9jNPJuz5Ntcefvw1hpA2vs7GCDeqM4qru6zY6I
         EgcA==
X-Gm-Message-State: AOAM531+9dUK/p6pGlEqINm+VENzVNoDglxJe0Ly2pk8kuMa0CV1eytc
        1RQ1XqNacYsYWynXsY4wL9is3goTGVg=
X-Google-Smtp-Source: ABdhPJyYVqoHThTfgm90OvuP8GR7yf04ZCAHuwXMm516iqEPId3kVxuI/Pa5ino5Q8mZ7DarEExzCDflhl8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a25:557:: with SMTP id 84mr33333812ybf.291.1614707123536;
 Tue, 02 Mar 2021 09:45:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 09:45:15 -0800
In-Reply-To: <20210302174515.2812275-1-seanjc@google.com>
Message-Id: <20210302174515.2812275-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210302174515.2812275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 2/2] KVM: nSVM: Add helper to synthesize nested VM-Exit
 without collateral
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to consolidate boilerplate for nested VM-Exits that don't
provide any data in exit_info_*.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 55 +++++----------------------------------
 arch/x86/kvm/svm/svm.c    |  6 +----
 arch/x86/kvm/svm/svm.h    |  9 +++++++
 3 files changed, 16 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 93a61ed76e5b..307c11125391 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -797,12 +797,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->vmcb->control.exit_code   = SVM_EXIT_SHUTDOWN;
-	svm->vmcb->control.exit_info_1 = 0;
-	svm->vmcb->control.exit_info_2 = 0;
-	nested_svm_vmexit(svm);
+	nested_svm_simple_vmexit(to_svm(vcpu), SVM_EXIT_SHUTDOWN);
 }
 
 int svm_allocate_nested(struct vcpu_svm *svm)
@@ -1027,50 +1022,11 @@ static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 	nested_svm_vmexit(svm);
 }
 
-static void nested_svm_smi(struct vcpu_svm *svm)
-{
-	svm->vmcb->control.exit_code = SVM_EXIT_SMI;
-	svm->vmcb->control.exit_info_1 = 0;
-	svm->vmcb->control.exit_info_2 = 0;
-
-	nested_svm_vmexit(svm);
-}
-
-static void nested_svm_nmi(struct vcpu_svm *svm)
-{
-	svm->vmcb->control.exit_code = SVM_EXIT_NMI;
-	svm->vmcb->control.exit_info_1 = 0;
-	svm->vmcb->control.exit_info_2 = 0;
-
-	nested_svm_vmexit(svm);
-}
-
-static void nested_svm_intr(struct vcpu_svm *svm)
-{
-	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
-
-	svm->vmcb->control.exit_code   = SVM_EXIT_INTR;
-	svm->vmcb->control.exit_info_1 = 0;
-	svm->vmcb->control.exit_info_2 = 0;
-
-	nested_svm_vmexit(svm);
-}
-
 static inline bool nested_exit_on_init(struct vcpu_svm *svm)
 {
 	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INIT);
 }
 
-static void nested_svm_init(struct vcpu_svm *svm)
-{
-	svm->vmcb->control.exit_code   = SVM_EXIT_INIT;
-	svm->vmcb->control.exit_info_1 = 0;
-	svm->vmcb->control.exit_info_2 = 0;
-
-	nested_svm_vmexit(svm);
-}
-
-
 static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1084,7 +1040,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 		if (!nested_exit_on_init(svm))
 			return 0;
-		nested_svm_init(svm);
+		nested_svm_simple_vmexit(svm, SVM_EXIT_INIT);
 		return 0;
 	}
 
@@ -1102,7 +1058,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 		if (!nested_exit_on_smi(svm))
 			return 0;
-		nested_svm_smi(svm);
+		nested_svm_simple_vmexit(svm, SVM_EXIT_SMI);
 		return 0;
 	}
 
@@ -1111,7 +1067,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 		if (!nested_exit_on_nmi(svm))
 			return 0;
-		nested_svm_nmi(svm);
+		nested_svm_simple_vmexit(svm, SVM_EXIT_NMI);
 		return 0;
 	}
 
@@ -1120,7 +1076,8 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 		if (!nested_exit_on_intr(svm))
 			return 0;
-		nested_svm_intr(svm);
+		trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
+		nested_svm_simple_vmexit(svm, SVM_EXIT_INTR);
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 54610270f66a..9fe9076d4b8b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2203,12 +2203,8 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 	int ret;
 
 	if (is_guest_mode(vcpu)) {
-		svm->vmcb->control.exit_code = guest_mode_exit_codes[opcode];
-		svm->vmcb->control.exit_info_1 = 0;
-		svm->vmcb->control.exit_info_2 = 0;
-
 		/* Returns '1' or -errno on failure, '0' on success. */
-		ret = nested_svm_vmexit(svm);
+		ret = nested_svm_simple_vmexit(svm, guest_mode_exit_codes[opcode]);
 		if (ret)
 			return ret;
 		return 1;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fbbb26dd0f73..c4a433c66a33 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -444,6 +444,15 @@ int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct kvm_vcpu *vcpu);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
+
+static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
+{
+	svm->vmcb->control.exit_code   = exit_code;
+	svm->vmcb->control.exit_info_1 = 0;
+	svm->vmcb->control.exit_info_2 = 0;
+	return nested_svm_vmexit(svm);
+}
+
 int nested_svm_exit_handled(struct vcpu_svm *svm);
 int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
-- 
2.30.1.766.gb4fecdf3b7-goog

