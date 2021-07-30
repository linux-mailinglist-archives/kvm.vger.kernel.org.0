Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489513DC163
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 01:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhG3W7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbhG3W7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:59:53 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60462C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:59:48 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id u22-20020ae9c0160000b02903b488f9d348so6589393qkk.20
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WOuUX+XoU7663u8UFn5j2EHWwVW3ujHXkDlL4NsSjs0=;
        b=iY9zlta5rGtyt9y69A6lMEqBEpSRaocSketV5A0B7mLv0cL6ooPCXHEUervS206jU3
         ZddMpCudqXX9qNhKf9kkVMtLdka8/kU1bF04rjI74CwqWTpxiThLtN2q3cmKhyL+BFGs
         SID335T15BHd36nQ3nx60xa1SjNxyjsvQv9jDXWClYVN0UKCmVlT3JuuKaKBX7JoguMS
         OMY9PVZcgBWdHQV/i6jegzgwU59+C58pCwB9Z8lOVCf69pfY6gn0oCwUh0Sl2m47eGp6
         wxB+rOn+H7kq2M/6DYq2Deq3vEjDXmnHmRYSDkDY9ogu13TRH92Yxb0VSCvCDg2+F7yP
         wkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WOuUX+XoU7663u8UFn5j2EHWwVW3ujHXkDlL4NsSjs0=;
        b=M8aUGjsPgIKMBSmKtwt8N5dMtf//vD03CcdqKgIz1ooOnizVTBn++6i4lgjreOkLpf
         m2ES24Ty1nwpjnAu+Wxws+SS03x5kEE0Wfu2QK9PxSHuo2GC8zPuHorkDC8bmNFFq9Gr
         SKsu5mouSyMvGC1adH8efyf1mVdEDnNAiZl7eWX8hizVrOkSxSrgFY2StRF87n2C/hdO
         Gu7hL6vKvU2BXN/guuAU2mIx2WYnhin+hlP07nSNlrjIu3Y0UMqG6ZFL7N5xRnKoCAI6
         6kQ7/qVWjnFRGqgPAlGoXEcfhzTrirrq1gVjbGKzQS0Qn+EIe0LTU2g+ZargYZ6BVMds
         P1fw==
X-Gm-Message-State: AOAM5335eqsRuhrUBgEVjBULPt/BMQAeQ7LyO8DEkEyYqNZ0TQp4vgR4
        S3bmRC0547umyKPuMHH/OeDW+DPuOgnN
X-Google-Smtp-Source: ABdhPJx0vfKmbGuGSTpNM2oPAXD/64Lfqq6cdLDFFsEPzYtHDW/Qj3xdAnGWOZipgrEk3btkP0roP2LY98OS
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:a198:4c3e:b951:58e3])
 (user=mizhang job=sendgmr) by 2002:a05:6214:d4d:: with SMTP id
 13mr5266594qvr.42.1627685987547; Fri, 30 Jul 2021 15:59:47 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri, 30 Jul 2021 15:59:38 -0700
In-Reply-To: <20210730225939.3852712-1-mizhang@google.com>
Message-Id: <20210730225939.3852712-3-mizhang@google.com>
Mime-Version: 1.0
References: <20210730225939.3852712-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 2/3] KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in
 TDP MMU lpage stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Factor in whether or not the old/new SPTEs are shadow-present when
adjusting the large page stats in the TDP MMU.  A modified MMIO SPTE can
toggle the page size bit, as bit 7 is used to store the MMIO generation,
i.e. is_large_pte() can get a false positive when called on a MMIO SPTE.
Ditto for nuking SPTEs with REMOVED_SPTE, which sets bit 7 in its magic
value.

Opportunistically move the logic below the check to verify at least one
of the old/new SPTEs is shadow present.

Use is/was_leaf even though is/was_present would suffice.  The code
generation is roughly equivalent since all flags need to be computed
prior to the code in question, and using the *_leaf flags will minimize
the diff in a future enhancement to account all pages, i.e. will change
the check to "is_leaf != was_leaf".

Reviewed-by: Ben Gardon <bgardon@google.com>

Fixes: 1699f65c8b65 ("kvm/x86: Fix 'lpages' kvm stat for TDM MMU")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index caac4ddb46df..cba2ab5db2a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -413,6 +413,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool was_large, is_large;
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -446,13 +447,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
-	if (is_large_pte(old_spte) != is_large_pte(new_spte)) {
-		if (is_large_pte(old_spte))
-			atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
-		else
-			atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
-	}
-
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
@@ -478,6 +472,18 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		return;
 	}
 
+	/*
+	 * Update large page stats if a large page is being zapped, created, or
+	 * is replacing an existing shadow page.
+	 */
+	was_large = was_leaf && is_large_pte(old_spte);
+	is_large = is_leaf && is_large_pte(new_spte);
+	if (was_large != is_large) {
+		if (was_large)
+			atomic64_sub(1, (atomic64_t *)&kvm->stat.lpages);
+		else
+			atomic64_add(1, (atomic64_t *)&kvm->stat.lpages);
+	}
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-- 
2.32.0.554.ge1b32706d8-goog

