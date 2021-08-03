Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290773DE5AA
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 06:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhHCEqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 00:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbhHCEql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 00:46:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A92C061799
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 21:46:29 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l16-20020a170902f690b029012cb82f15afso4476891plg.10
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 21:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/kt3GsReI0qxlgk6gWKn2NJ23HEdkW7Aud8Gxnwk7qw=;
        b=Xh81q1RmonSbkzq73aaMKLEqC/x2Cco72xRZ8gNWiIBwOPcwOaB5/GGrvb9rz47gBS
         XXg2t0f2JCAihWnYPpJvZoalPTYvi4DJ6RopV8A0fsfodMASneaUYJ4FU83DeTRGCEEI
         +ePoGauvyPKOeP+/kewT9XOp+C4TiJ/sx3qD202pbHcE0BkpoWjwjHlPkhEirp09x6EV
         ySIzlpWuN239XjN2P7ke1ftWkVWAiqPeiTPZGGgEg/fUMjjl5S+hVikebIXw2ZchHdGO
         vCJ3/k8Z7iTWrT6YGaSsGH6pJkJWNhgsORa+N1ljG3poKuIoGshhO0P/TLwzMZsapNVO
         aBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/kt3GsReI0qxlgk6gWKn2NJ23HEdkW7Aud8Gxnwk7qw=;
        b=sqoQqmaHsgiwyM6TAlaUvtTVALMU4na+FIUNhhjf7Ue8qpAD/4keCPCZYDHqzFkArU
         F7uMtSnAkTWBh3Q727nCP0SDgmcDvre9+guwgQrJT9n+SN0F3gQ5LcsXwrVgDwyr9cRZ
         gtlyJdJ6wcdBY8Yaxohs3dW5EmSxaE4EzNYM/K5vIkfVAsVuCkJF5xhiZThVkhoNMDaP
         lfRB6yhDW+qIozdRdwCQc+jQCmH6vSnUXD3FR+OHRtAEajK/fcrz9VY3WBuodxkhBKw5
         cll/d3C35rFjcLN3/pVyXPP0ewV8hjCpIMIpDbaoic2zzGtVnHDQWXohgilddPjo6wDt
         jwfA==
X-Gm-Message-State: AOAM531E2towg+6kbBfMXspJwjfQ7mtL+Fce71XEMLjXSqtWW1dPq6US
        idGWV1i5F/ZGwo9naaIb0I7iRmvT+Het
X-Google-Smtp-Source: ABdhPJxps/Vl+UCc7rA/SBKbGz0jwmpKAc00VAX8dRqRa4N0RWHQf3ZnxU+ioFSRa6KEOCh6it2TAaN1BkTM
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:4304:2e3e:d2f5:48c8])
 (user=mizhang job=sendgmr) by 2002:a17:902:a5c5:b029:12c:9108:d83 with SMTP
 id t5-20020a170902a5c5b029012c91080d83mr17010060plq.33.1627965989421; Mon, 02
 Aug 2021 21:46:29 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  2 Aug 2021 21:46:06 -0700
In-Reply-To: <20210803044607.599629-1-mizhang@google.com>
Message-Id: <20210803044607.599629-3-mizhang@google.com>
Mime-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v4 2/3] KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in
 TDP MMU lpage stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>

Fixes: 1699f65c8b65 ("kvm/x86: Fix 'lpages' kvm stat for TDM MMU")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 43f12f5d12c0..4b0953fed12e 100644
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

