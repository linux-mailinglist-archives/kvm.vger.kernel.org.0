Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C8F647696
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiLHTkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiLHTkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:02 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D83880EA
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b4-20020a253404000000b006fad1bb09f4so2548493yba.1
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CaDXua+LFbRv3ei+U1Fgv/kax6A2A04L4lM62rMK90Q=;
        b=FQRVJBa4KRKObP8S3n7w3f2m+Bcx87+PQgURkRJCXrk7m4BdVxUrIfCvxY3dvCxGvX
         DFNpL9OiA6gV3a7OA6rX48DXADwjzhjgTFiSwWT9yA/sZdiwLepPrDM/Dmol5FJsTFtd
         1z4mxGJZs7yrfwU4FQjUHnKK5PWmnwdRAprtxH5S0Ua5f0HoeWKVyWfSamiqMLNdnacf
         wBp7G+B2Y+E/qsY0zWkyQWEjRsad/cIklCbMqtgv/ZnA3GI3slUIM7MR6Z7bKiBB5z6N
         n2PV1n0iU9J6gxAvFUL2pGUf26H+n9zVjk4Eh4mosAVvSNZBvAGEZTWWsWyjSDwLmgGs
         n+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CaDXua+LFbRv3ei+U1Fgv/kax6A2A04L4lM62rMK90Q=;
        b=qgj4nNzR4YM+gJIDO6N2vlc8B9ue9CxMOZZKTHZT4FFbRkEE0irJFTeDL4qF56k3fz
         Xc2TjdxIcoTYW4/VjorUarWhVvUaEOcUc86WfEYAu2Xx4yPPpmR5UZMHTwg1GC/RTZaI
         kn+KZ4FIap8gXBuISNX3ygQsPVulihxUzYOjiMh9J3r7FRITlipwbjXL+naswlFlRMYg
         PiCd8PF4iwSlEjkUkq/YKdSZdlYojNQK6hdjGfRSf2iz9kf/Sd80NEqE83jUXF7f4hgd
         LQR1Poo5lN2Xixtr0fu4qbrE/b2zQdW8ENIjacxhWyLEDQELbw8UfzwUjFuZckP7dd0b
         PwcA==
X-Gm-Message-State: ANoB5plLMnmrCcyIDhJCdZ/sLI9WCvepu5y1uuW4xsBTlxpY1TUS0QM4
        cEfEdtNUHz1Jp3AI8EqNMcusZKiLuMo0Ng==
X-Google-Smtp-Source: AA0mqf5XxSPsh1gElJLISTCH8jBxKw2l85vxM5vFZMR7VtMxrzDAz9u8B+smh4G6eaCc3YG8CKpqOh9t0eSRDA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:b18:b0:388:7d2:587b with SMTP id
 cj24-20020a05690c0b1800b0038807d2587bmr8897906ywb.416.1670528380375; Thu, 08
 Dec 2022 11:39:40 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:40 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-21-dmatlack@google.com>
Subject: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Abstract away kvm_mmu_max_mapping_level(), which is an x86-specific
function for computing the max level that a given GFN can be mapped in
KVM's page tables. This will be used in a future commit to enable moving
the TDP MMU to common code.

Provide a default implementation for non-x86 architectures that just
returns the max level. This will result in more zapping than necessary
when disabling dirty logging (i.e. less than optimal performance) but no
correctness issues.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c     | 14 ++++++++++----
 arch/x86/kvm/mmu/tdp_pgtable.c |  7 +++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7670fbd8e72d..24d1dbd0a1ec 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1696,6 +1696,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
 
+__weak int tdp_mmu_max_mapping_level(struct kvm *kvm,
+				     const struct kvm_memory_slot *slot,
+				     struct tdp_iter *iter)
+{
+	return TDP_MAX_HUGEPAGE_LEVEL;
+}
+
 static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
 				       const struct kvm_memory_slot *slot)
@@ -1727,15 +1734,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		/*
 		 * If iter.gfn resides outside of the slot, i.e. the page for
 		 * the current level overlaps but is not contained by the slot,
-		 * then the SPTE can't be made huge.  More importantly, trying
-		 * to query that info from slot->arch.lpage_info will cause an
+		 * then the SPTE can't be made huge. On x86, trying to query
+		 * that info from slot->arch.lpage_info will cause an
 		 * out-of-bounds access.
 		 */
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-							      iter.gfn, PG_LEVEL_NUM);
+		max_mapping_level = tdp_mmu_max_mapping_level(kvm, slot, &iter);
 		if (max_mapping_level < iter.level)
 			continue;
 
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index b07ed99b4ab1..840d063c45b8 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -163,3 +163,10 @@ void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
+
+int tdp_mmu_max_mapping_level(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot,
+			      struct tdp_iter *iter)
+{
+	return kvm_mmu_max_mapping_level(kvm, slot, iter->gfn, PG_LEVEL_NUM);
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

