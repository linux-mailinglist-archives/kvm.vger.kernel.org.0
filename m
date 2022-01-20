Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AF2494554
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358055AbiATBH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357983AbiATBH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:26 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5327FC061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:26 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t18-20020a63dd12000000b00342725203b5so2662097pgg.16
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SYLTfRN0UdpLZb7rj/xZArHK2NjDhiJ3xTDdO+xMLpw=;
        b=e/ddioxUJ2mGT/zPwMN6e7mbsWUnUxxxhQxEVYvACcfWAQZcWx0nzK28hvkIJENFKX
         XH2iEDb2gVbVia2qJwA6c/NSm70agmWw6VhQlSe+7UHL8HrSEhfEwdImJeRfSXzT+dnO
         bjGrBLZfvF+/f/9BCMxWfuAFLuc49tZ2WMvGZYePJ8BMWfAlHReGyXdEXMT6RiWekqXt
         /mHKG8P6cHuyPkOKEd73Gmcq6NiHsrdztLlRqxjZ/jRZ1sZVrqT+ECTPTAvjCZkUw4IZ
         H37d3TjzTBk7oW2VPuqnhydCTFsoXCgkqQKUQ9qMyRfoN6rSBcw6VHS6c4LpgvrO8ACT
         15dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SYLTfRN0UdpLZb7rj/xZArHK2NjDhiJ3xTDdO+xMLpw=;
        b=i6CZ9lBUUOxzlS6P7WXl32teToDZwlQzBs9KFWpbCjyL0aqplZbqdJIlZFfJYlC+42
         e4nnQu9+mEgWJsJHB+OltmdNYggwnv/X4Skf+I59l88CyBPTIujrxsxTxW2UlrhqTud0
         jzpopsYzeOStSV8i5xUl7fuIQFl20MEvldYsDHA+31EQbhwlN/Mhzu2HiNALT8ZS1HvI
         CWOl7afLcmgQVhzsnIVhxB4ICwurL+5fWNPPBVEFEotnjq1CyJ2Jac3S+r4AFjORYnRr
         qahPe3rB3jpPVRROIyIzx7V05KS6Qz0sG4QjTZad0UuBW3J7ornjmB95JVMSzYfefOGy
         RVZA==
X-Gm-Message-State: AOAM531UFNzH5UBRUA1lWDcup7R89NDf5ItBS1f/gVPNfszalBCn4UDa
        +hXhY8/R+ZE9SY99J0aLn5s/6Et+RwE=
X-Google-Smtp-Source: ABdhPJwTvVOzUZqs0xBVFNeu53Do/4EVDZXsNm3N619mlDWiUPwRr5jQ04+APop3sG4+nQGWt1Qr6nbA4tk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d84:: with SMTP id
 oj4mr791349pjb.0.1642640845477; Wed, 19 Jan 2022 17:07:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:11 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 1/9] KVM: SVM: Never reject emulation due to SMAP errata for
 !SEV guests
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
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always signal that emulation is possible for !SEV guests regardless of
whether or not the CPU provided a valid instruction byte stream.  KVM can
read all guest state (memory and registers) for !SEV guests, i.e. can
fetch the code stream from memory even if the CPU failed to do so because
of the SMAP errata.

Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6d31d357a83b..aa1649b8cd8f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4257,8 +4257,13 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/* Emulation is always possible when KVM has access to all guest state. */
+	if (!sev_guest(vcpu->kvm))
+		return true;
+
 	/*
-	 * When the guest is an SEV-ES guest, emulation is not possible.
+	 * Emulation is impossible for SEV-ES guests as KVM doesn't have access
+	 * to guest register state.
 	 */
 	if (sev_es_guest(vcpu->kvm))
 		return false;
@@ -4318,9 +4323,6 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	smap = cr4 & X86_CR4_SMAP;
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
-		if (!sev_guest(vcpu->kvm))
-			return true;
-
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
-- 
2.34.1.703.g22d0c6ccf7-goog

