Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2A33D6613
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhGZRNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 13:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhGZRNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 13:13:40 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DE1C061757
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:54:09 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id k5-20020a05620a4145b02903b8eff05707so9642382qko.5
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Pod+cFJd0HRiOKBwqMg7GhCqe0Dwn2Ux12SPPveDuz0=;
        b=r+Vp2vQ9xFmyHkJGZ11F9CGL8HamVo2WBZjEfRxh2RXs7ddPgtjbVo0ojL884xRRaz
         qawzYDy485UOCeY4sqSPuiQB81fgVquVEaJ0s3p2kShy3NTMobaR6XuXwcA0Wt4yhEkP
         vafRx3UOsz+8eJX9bFRQfZqX2R41KmFnjllsB64KJtTPgYoqERcUpoY5hdi6r7N1GbUG
         W0ag/TaCDPHDxvE3HOuFGcn2LU1meGZbzKU6M+15DGls7mkfSAeD8iEbSCKLi5AxfZRh
         HANlVlXM9z+zpUF55l/7Nr07By4g58AU1k22xiJcXkZfxGOsaMSmBHvZoDf+38Bc9Smn
         TIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Pod+cFJd0HRiOKBwqMg7GhCqe0Dwn2Ux12SPPveDuz0=;
        b=JybaFdc/CwDRU4qaneF9i7uULyIANG/WLFTXn7/ErMGgxwouSw0e6Dy+gyDgjPV46w
         A/VBb2goNg7cTp7G1Zkq/ZlMzZQAh3w7S2/8CXINT0qJvUPhEk/wSCPta5NDs1ZF+RBi
         pDfeS06OGfcUmazwfW62qMSFslnO4hH9U2lxB7V7zFo9rti5OvOSgDUVNFr3J1D9m9l5
         qLXzgEqlZ0CLDWk+hfZSNlZsl3CkAGbzwktP3QITBhuKM6RRRk2g7bPNIayk3E0XUPRM
         66WTg3BNiFAIDeYIxqR/64xJY2Kr/4t1Kl/eHbtqb0JACPYMJVhKx4MmJ2CeVeahgzFt
         a64A==
X-Gm-Message-State: AOAM531NZ12zxqG1m5xCTn1yzSKwlcgj84Yz9xYaADA+VBBKsHP1pndF
        rYdUb4xTntxR/z6dtBs6j1rEfEo2atFq
X-Google-Smtp-Source: ABdhPJx5fx/l3bVzcng89Bya601B9TuPS3jV7p4TwEMqThJhYXKWlfhzD8e44XOweJYv2cpvO3ynxBwmcU84
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:93c5:105:4dbc:13cf])
 (user=mizhang job=sendgmr) by 2002:a0c:e70f:: with SMTP id
 d15mr18640267qvn.47.1627322048130; Mon, 26 Jul 2021 10:54:08 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 26 Jul 2021 10:53:56 -0700
In-Reply-To: <20210726175357.1572951-1-mizhang@google.com>
Message-Id: <20210726175357.1572951-3-mizhang@google.com>
Mime-Version: 1.0
References: <20210726175357.1572951-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 2/3] KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in
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
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor in whether or not the old/new SPTEs are shadow-present when
adjusting the large page stats in the TDP MMU. A modified MMIO SPTE can
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

Suggested-by: Sean Christopherson <seanjc@google.com>
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
2.32.0.432.gabb21c7263-goog

