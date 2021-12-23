Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393BC47E957
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350621AbhLWWYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350422AbhLWWX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:57 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1910C061757
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:56 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 35-20020a17090a0fa600b001b160e1ecffso4020063pjz.9
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/tgTHkNO24YF7TEp6ddw/+GI148Bo3vvZKD6TVuZqKc=;
        b=c7szg7bIMyxnqWFnynUtnxGaauqoLh+3Dc6S1L+RSwCz5ENGT7B4D4aa+SQspWrX2a
         rHOJUCadILTnbnCczP3Ea15+LvPcNxa2iUJ3txp8CZI1YYVCU0I3LBaZl5B3sJeJVFCY
         l9pEFLKvoin2yHbgh4cLp/sdn/U/PTDabM53rofzKy8aCWs1X7tL0n66xEpp3sSnPSvi
         cxasmMkp6068upgJ32Xov6BFv5PPEzwQvMXTzmZGlrLBbPBezDxBvKSA4iI7E1sQ/iOf
         xZe+LLSR6XNgTD7iHa+PLkj6Ycy9Khq5RnX6A6BFDnJg5xmHMGAFh1bkmP9UJ5pg2lbD
         XubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/tgTHkNO24YF7TEp6ddw/+GI148Bo3vvZKD6TVuZqKc=;
        b=SsGal6ZEwMGSpW3ZbhtiUhFWYy7qMR2iR8G6N+uPKa4YBh0HgdfdLRJdnR0wlrSc22
         E9H+C72/kromVgX6Fg7VqY3jjKFH7RZxu4y6d2v69pofWCclaA6h4OPFGuAzi6gwUOLD
         MCjXIqCnSuWXvEwG7tUrEmekJTrKAKJJMfPmoIwciVpQ6A3z3G0KOtZLMsRbFL4+A3h5
         6KFiW/PzWWMoTpmJW9HVZu2DsnPcrJtZtiTM1oil3ztkGnsTpzhqbxUR//bdJ6WHCBMd
         +RfTa0VJ0B8YoXDns6rGoJYiLWID7d9LqQU9aF3uXajkHT/0A5VWi3H91xVwUQlugrUO
         BAbw==
X-Gm-Message-State: AOAM533s+Kx4tRgd3i289duAqtwjKzIMF7kpAHsx6Y6sPY5iN6mRM4Y8
        bYjeTmZUVFswW/GXw8GRj8/m36UaOuo=
X-Google-Smtp-Source: ABdhPJx61pNg8/a4KRQPgnCci3Pfp3tZaa8BoFTdRQXMVKG9zPf8CcCKzCdQLs/52ih+UKgSbOq2mqkJ57U=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa89:b0:148:a2e7:fb69 with SMTP id
 d9-20020a170902aa8900b00148a2e7fb69mr4114580plr.170.1640298236092; Thu, 23
 Dec 2021 14:23:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:57 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-10-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 09/30] KVM: x86/mmu: Drop unused @kvm param from kvm_tdp_mmu_get_root()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the unused @kvm param from kvm_tdp_mmu_get_root().  No functional
change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 87785dce1bd4..cd093fa73d14 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -146,7 +146,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 	while (next_root) {
 		if ((type == ALL_ROOTS || (type == !!next_root->role.invalid)) &&
-		    kvm_tdp_mmu_get_root(kvm, next_root))
+		    kvm_tdp_mmu_get_root(next_root))
 			break;
 
 		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
@@ -243,7 +243,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	 */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
-		    kvm_tdp_mmu_get_root(kvm, root))
+		    kvm_tdp_mmu_get_root(root))
 			goto out;
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 08c917511fed..6b9bdd652bca 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -7,8 +7,7 @@
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 
-__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
-						     struct kvm_mmu_page *root)
+__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
-- 
2.34.1.448.ga2b2bfdf31-goog

