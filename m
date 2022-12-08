Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56E647677
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLHTjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiLHTjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:35 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DA0A56D6
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:27 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y6-20020a25b9c6000000b006c1c6161716so2533645ybj.8
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T0+hU8k+RyCmVBvBo6qJA+pYHpeWz4BnzaTdktBKy2A=;
        b=j2HX3lJ7u8ucEzkeGBQfuBx9Yb7N2Qy9oTH39ulAVDzwqd+G0fIW4WjnRqotxR/RTx
         o/pna9eXTXuMdJmAYL1UVpM36PkT4GZM2h0bpfrNAurm7bBa7yOIol4vLsYL261GeqzA
         3HOdEsZ41tJib1TeC34Adynr+Edi81xeW1SDkV4CdXiQGoTOGOVJ4WxSxzRqIQRX0/iB
         RSZpalWLzZZk3q25mDyKyCcOP/lgTKFRKvpNiWk49MLHspz7m3Pd9fzp8sxVKQa7WFIV
         Cq+v/eIrOgIUSWXVgUqA7VpSfMfnDwSrS/lkhXxrcLWaE6ZViWl/62plvpN2oVhZ91U+
         +4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T0+hU8k+RyCmVBvBo6qJA+pYHpeWz4BnzaTdktBKy2A=;
        b=0Y815YtbRRS0WfdLMxBfKPvKAp183yj59jUY0adfpLZcCKpGMdDkGsiM0rxIdG4cd4
         67jnFs1+MUIs8TH1DauI5DsKJt7ijTuxYPg6N57b7hMayxhxbxWPomitR6OkigApHNGX
         UNElgNJqSpkU3HFP3Tfr4AUFywUsCv6ZgH9mIepDhpdn7CIp7bJL4pS1+LjUoqVJ7vKF
         CYjwgsXYYs8kZszZsYhvlnNw4mJKE8GV0Sw7HqXcWk2w/4xBv3GrtvjWQtt2OKxXsXkD
         A/HR5FcbEqD2mQBqvL/pbHoKiKS1n5XyB6l842ANpZO9O16Fn/+WuSg1hGY5rD80tqPE
         wiDg==
X-Gm-Message-State: ANoB5pnVU+Cs/I71kKn3ZNMffTC/G3Ci6SnnJEHQPUst9+WwAVkUhVJ4
        IyTLafkiPdzAt3dYEfpUNyF0k6MKP3cTPQ==
X-Google-Smtp-Source: AA0mqf4KN0ToQ1wmZzmflZp36b4L5Nl4FpG0VJHdW80YwtBlwu869ju+Ri2dl6OmwZR+dYAtfRM+xdMRlNvXFw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6994:0:b0:6f3:c535:4ea3 with SMTP id
 e142-20020a256994000000b006f3c5354ea3mr55731660ybc.498.1670528366862; Thu, 08
 Dec 2022 11:39:26 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:32 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-13-dmatlack@google.com>
Subject: [RFC PATCH 12/37] KVM: x86/mmu: Use PG_LEVEL_{PTE,PMD,PUD} in the TDP MMU
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use PG_LEVEL_{PTE,PMD,PUD} in the TDP MMU instead of the x86-specific
PG_LEVEL_{4K,2M,1G} aliases. This prepares for moving the TDP MMU to
common code, where not all architectures will have 4K PAGE_SIZE.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c  | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..892c078aab58 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -106,7 +106,7 @@ struct tdp_iter {
 	     tdp_iter_next(&iter))
 
 #define for_each_tdp_pte(iter, root, start, end) \
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_PTE, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4940413d3767..bce0566f2d94 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -347,7 +347,7 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool pfn_changed;
 	struct kvm_memory_slot *slot;
 
-	if (level > PG_LEVEL_4K)
+	if (level > PG_LEVEL_PTE)
 		return;
 
 	pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
@@ -526,7 +526,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
-	WARN_ON(level < PG_LEVEL_4K);
+	WARN_ON(level < PG_LEVEL_PTE);
 	WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
 
 	/*
@@ -897,9 +897,9 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 * inducing a stall to allow in-place replacement with a 1gb hugepage.
 	 *
 	 * Because zapping a SP recurses on its children, stepping down to
-	 * PG_LEVEL_4K in the iterator itself is unnecessary.
+	 * PG_LEVEL_PTE in the iterator itself is unnecessary.
 	 */
-	__tdp_mmu_zap_root(kvm, root, shared, PG_LEVEL_1G);
+	__tdp_mmu_zap_root(kvm, root, shared, PG_LEVEL_PUD);
 	__tdp_mmu_zap_root(kvm, root, shared, root->role.level);
 
 	rcu_read_unlock();
@@ -944,7 +944,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_PTE, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
@@ -1303,7 +1303,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	/* Huge pages aren't expected to be modified without first being zapped. */
 	WARN_ON(pte_huge(range->pte) || range->start + 1 != range->end);
 
-	if (iter->level != PG_LEVEL_4K ||
+	if (iter->level != PG_LEVEL_PTE ||
 	    !is_shadow_present_pte(iter->old_spte))
 		return false;
 
@@ -1672,7 +1672,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!mask)
 			break;
 
-		if (iter.level > PG_LEVEL_4K ||
+		if (iter.level > PG_LEVEL_PTE ||
 		    !(mask & (1UL << (iter.gfn - gfn))))
 			continue;
 
@@ -1726,7 +1726,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_PMD, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

