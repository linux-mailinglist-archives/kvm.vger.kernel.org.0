Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36E9494394
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357700AbiASXJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344236AbiASXHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:51 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA22C061751
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:51 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id f1-20020a17090a8e8100b001b44bb75678so2700475pjo.0
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Bvp8e17RJHmgn68Vah/vaY6v0G1B7Poi9MrN2aFSo5g=;
        b=muNvJHqM8X4S9ixv2lWhzHuetbLR8BcDVG1Wx6rqD1IaWS4bNtQlo9XWiiIbZWyNKm
         nR3jhl4zHNP+oQb/rtHZQG8Dg4/BMi+Hb0Y3A9jp43hAJfEGvsZ8HHebjCMwFpBM8JyZ
         RzM74mDTg94Lo2MjMACNgpoUPowFsElw/Ykl3J8N2fhISr29U9Z2y5TvZWecNIHqHXKL
         d9woTJuiW4voRpWWmHTECta02r7EAb/wZi2yBO2CQh8Ny7Cr1X7SNNlj22TE0m0A7zbN
         J/8vOJaSHtrAXeGV7pNaJvoOpN2vCPZu5x4YoteTg7agoKfHRO//Z2+bYmFRUS6AZ887
         +cTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Bvp8e17RJHmgn68Vah/vaY6v0G1B7Poi9MrN2aFSo5g=;
        b=CtVJ/SLzwCij6BXkq8O7ukeaz5AqV7XgrSxximVAHarp6wqJb3tPVh417wWwNg+WwE
         QkwQx5v77qGMohrxABls90TepK4TJeNF6iB56u1OpmcUSbVXiDzgK9WO+INHzr3LfQ/z
         OeLjp3lNJPmtQdlQD8DmpzNpigACt16c9BWztMdGpbds0R7E01cSJi7hoOvEF0R0lvk3
         9qHmvoeDauQK6gS0c4bUQTIYKn8trLIu6rwYXvfqgiUUCK7zxV68bzzZsovjNzPNpyz3
         Zs/lyJ8wM+FZXV3x9spQIrf9driAj8+4jtl8H5x/+xFH2olcnhaXOc6eqXL71nJVlcgs
         +Xtw==
X-Gm-Message-State: AOAM5322m6iA04buRiADnzANXjpI/CWwSzPdbm7I0GiTiyg5S6tAF0Ul
        YwQFLzP/KZoscZI9blu1XEncRhk8FgfJvw==
X-Google-Smtp-Source: ABdhPJxdzOuYev/P1jZoL+qyuJRnakrO1gtLhPSB6s9Wos/fZF6h3rG8o09UcwrOoCZIUBEvEqs8uEIpb7HBMg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:883:b0:4bc:39c1:9644 with SMTP
 id q3-20020a056a00088300b004bc39c19644mr33083544pfj.14.1642633670737; Wed, 19
 Jan 2022 15:07:50 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:23 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 02/18] KVM: x86/mmu: Rename __rmap_write_protect() to rmap_write_protect()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function formerly known as rmap_write_protect() has been renamed to
kvm_vcpu_write_protect_gfn(), so we can get rid of the double
underscores in front of __rmap_write_protect().

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b541683c29c7..fb6718714caa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1229,9 +1229,9 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool __rmap_write_protect(struct kvm *kvm,
-				 struct kvm_rmap_head *rmap_head,
-				 bool pt_protect)
+static bool rmap_write_protect(struct kvm *kvm,
+			       struct kvm_rmap_head *rmap_head,
+			       bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1311,7 +1311,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					PG_LEVEL_4K, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1410,7 +1410,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 			rmap_head = gfn_to_rmap(gfn, i, slot);
-			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+			write_protected |= rmap_write_protect(kvm, rmap_head, true);
 		}
 	}
 
@@ -5802,7 +5802,7 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot)
 {
-	return __rmap_write_protect(kvm, rmap_head, false);
+	return rmap_write_protect(kvm, rmap_head, false);
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-- 
2.35.0.rc0.227.g00780c9af4-goog

