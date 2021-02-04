Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD2130EA45
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhBDCgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 21:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbhBDCgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 21:36:21 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE6FC0613D6
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 18:35:40 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id e62so1952777yba.5
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 18:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=+Rhoed1XQepPnJf3F6uh773jLZ78lN8W7AVU2qB258o=;
        b=hyYr9tldNB35f9XCt4oiqOeUSNLxT3NzdiZyYRqw2VWSCllNgj7jm86k+RuoZo3WKC
         Q4U6sRpqW1+G9vn2tlCUnmHvyT5H+18d2QWAzl+Wr05TzOvImbvKjxLjMLjanHNltUBv
         Vlv//0aK+8HssbdNw2hanUTO9l8zEJupWTSUKoB2OcElbV4Q1j+sLzlK1ZmBrQwQYYPP
         UsaC1/czjkdIps5Xd7KXfnryrTz+4GuQZT8OuBP1TvjNj6NHkVQYjp0/MmdJ0JKrCuM4
         YMzNqdvDMd13Y7OwjUVX1lvwHxdiKQTWvtvXQ5eGLsgnzmbVykh/0Aj1aFFOh/ZBsP+M
         BPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=+Rhoed1XQepPnJf3F6uh773jLZ78lN8W7AVU2qB258o=;
        b=XliIVHAkz8cQSg3nitjmoUzPutzMs38/eEQ4gzQp1a+93nEtW/+MRSSKV0cbpj3Qb0
         I1DPXxr+0TIqqzhbwbg6bLcQfGWSwA6+VJA4+WwhT4pusvJQQim1J1hH478bTxEzPg1R
         GE2KRtUd8SaAHvjEd+YlM6tCYr/G4hEL//FHvC6kKJUluKmLOuo6L3Q130O5vm/7fqDQ
         j/8USGIxPh39P4UuczG+s7ASFE7ORna72AVAA6TGUbIEqMWPNgBpQnnSoCjEIF2ZCKx2
         fFZANuR3jTODea0WnTJodYkVdBiRCtoLUy9F531G/7py8XI/IHj65QlByzbl6sFcOBP3
         ZzhA==
X-Gm-Message-State: AOAM530ciDm4y/k3o5UvxwrDMvUMtw6KKSGTI5GcWGFllmHhjlf5UhuA
        Pab95Q8rEazxupKqbwt259vjyhnNsvs=
X-Google-Smtp-Source: ABdhPJz31YtwdDoZ04CvFBL+71M8C0dpug36wp8GedSEwyhOz06UH9fTvuGaPWWibtMV0aUW3dA9nSUivBU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a25:4e07:: with SMTP id c7mr8588817ybb.288.1612406140095;
 Wed, 03 Feb 2021 18:35:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 18:35:36 -0800
Message-Id: <20210204023536.3397005-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] KVM: SVM: Remove bogus WARN and emulation if guest #GPs with EFER.SVME=1
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bandan Das <bsd@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Immediately reinject #GP (if intercepted) if the VMware backdoor is
disabled and the instruction is not affected by the erratum that causes
bogus #GPs on SVM instructions.  It is completely reasonable for the
guest to take a #GP(0) with EFER.SVME=1, e.g. when probing an MSR, and
attempting emulation on an unknown instruction is obviously not good.

Fixes: b3f4e11adc7d ("KVM: SVM: Add emulation support for #GP triggered by SVM instructions")
Cc: Bandan Das <bsd@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f53e6377a933..707a2f85bcc6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2263,7 +2263,8 @@ static int gp_interception(struct vcpu_svm *svm)
 	opcode = svm_instr_opcode(vcpu);
 
 	if (opcode == NONE_SVM_INSTR) {
-		WARN_ON_ONCE(!enable_vmware_backdoor);
+		if (!enable_vmware_backdoor)
+			goto reinject;
 
 		/*
 		 * VMware backdoor emulation on #GP interception only handles
-- 
2.30.0.365.g02bc693789-goog

