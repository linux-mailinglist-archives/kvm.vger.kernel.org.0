Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203A7494556
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358075AbiATBHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358034AbiATBH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:27 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98292C06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:27 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x15-20020a17090a46cf00b001b35ee9643fso5007498pjg.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Juh5ZOlMsSeAWLXziqBZ7hfTYcz1GBOOW6Gc4QgkpAc=;
        b=GtfeymlahDJq8GbLIHsgKU1pkM/psWDB6FaaA9uBAH4K1H+aRW5dwP8RdupCLpWoDT
         oYxl+VfEKCriqB+z5dTojuQILPK1pdmyAQSapnqeyW5E1HUpfyt4YfDuA4k5hMDsek8l
         ud8FQv5Gm5rps/XrixIn5418PNQU1F4D1LgNwJuQnBnvRRXOi695Mg1TsIio58wyzAJy
         r6a2D76teZ9oIwqMEfSZvzJpixH4NVQ7YdnpiSB+dqviU8jFhba12o+8FcZ3f5Aczhxq
         Y8hNBdXjhDMKUJq9UrDFQ3Aw++XstSFNEdDdZALzH72fR6rSpYt2El5zMBsKyMMAkYuH
         AVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Juh5ZOlMsSeAWLXziqBZ7hfTYcz1GBOOW6Gc4QgkpAc=;
        b=LX+azCp3+nHZWdAjV3MyoSN/A+EaH4GGs6Pqvxcr9xNulGRRq6zcNlxyrgCd/svzbW
         S975hP4p67S1a4bwk1pAju3aDPWrOu43Kfcd8WoHvgQ2BOuUusTl6Ytvl609ern4EL5+
         UDZWNoZs8MTS7KVEXAuAaSVcG2X+bqEyEVeSqAF/r0xhf2Mdy8AzeQ83wouvt25OecTA
         n57vQh6Z0vvqpdk/p3A4dAwgbi5krz5Y2NBHP/kQIevthEiv56bqPYQG6yE1/Hwk0ZEI
         itoDNMllMe4n6dN1jIQxc0Cf2OsD2k9izuZnkGzrB6S4bLkwRYbgE8dHjsZygyrC8zEh
         qnbA==
X-Gm-Message-State: AOAM533Ot/gczHzhxYlUQwugUMSKqGxnpajvCKQZkGr/kUaXMY4bKVbn
        xCyMlx9RV0hxfF47dNGK6nQ/InGdVfs=
X-Google-Smtp-Source: ABdhPJzjjAsbw39gYVbrNDfA6srZk5+ykqTMw++E0hDvNbPZ/Nf/6L8kjhpSLEzx25PIbPON7JqSCpN2hko=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:d044:: with SMTP id s4mr15422908pgi.350.1642640847082;
 Wed, 19 Jan 2022 17:07:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:12 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 2/9] Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
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

Revert a completely broken check on an "invalid" RIP in SVM's workaround
for the DecodeAssists SMAP errata.  kvm_vcpu_gfn_to_memslot() obviously
expects a gfn, i.e. operates in the guest physical address space, whereas
RIP is a virtual (not even linear) address.  The "fix" worked for the
problematic KVM selftest because the test identity mapped RIP.

Fully revert the hack instead of trying to translate RIP to a GPA, as the
non-SEV case is now handled earlier, and KVM cannot access guest page
tables to translate RIP.

This reverts commit e72436bc3a5206f95bb384e741154166ddb3202e.

Fixes: e72436bc3a52 ("KVM: SVM: avoid infinite loop on NPF from bad address")
Reported-by: Liam Merwick <liam.merwick@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 -------
 virt/kvm/kvm_main.c    | 1 -
 2 files changed, 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aa1649b8cd8f..85703145eb0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4311,13 +4311,6 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
 	if (likely(!insn || insn_len))
 		return true;
 
-	/*
-	 * If RIP is invalid, go ahead with emulation which will cause an
-	 * internal error exit.
-	 */
-	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
-		return true;
-
 	cr4 = kvm_read_cr4(vcpu);
 	smep = cr4 & X86_CR4_SMEP;
 	smap = cr4 & X86_CR4_SMAP;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5a1164483e6c..0bacecda79cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2248,7 +2248,6 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.34.1.703.g22d0c6ccf7-goog

