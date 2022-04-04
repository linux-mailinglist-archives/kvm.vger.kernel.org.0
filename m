Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8544F2062
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 01:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiDDXo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 19:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDDXo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 19:44:27 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C880467D2E
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 16:42:22 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u32-20020a634560000000b0039940fd2020so1376826pgk.20
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 16:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J9JdczjCflhADAkwzg8dC3TDq1QsxwIOBSphHHb7CsE=;
        b=SaWbXJ+eSFTVQL00bJErXWshHip0oHjDBJJ3CIjnu+HT1vgtdjTOKQ5DbQ/ufD1TV0
         KjV/tA6YYnA81ykCQC3j//faUYtVWANYG3TWqO5vvleQIOaF1wMwH6CIx9OarPSJijtl
         N+NrDkerr2DpDmOf14B1eQHC03/3lJhoA+J6XEex9Gke9EWDb63M83lHmpeUDSeirv38
         Bw/oONKyFCZRdQ3jATywM7tgwYQ9e7o6Jz9JGpPKOqLpFTMvm8mz1gMR24/R5Rsuc0A/
         2r+sC5P+gQ7BrHrHJYLzRQKzF2SgfzAsiq9kAWb+a5gOV1n4QSezrxgW+PCrKtynH9BG
         sPFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J9JdczjCflhADAkwzg8dC3TDq1QsxwIOBSphHHb7CsE=;
        b=a55jYY31QosIAT01fI57gA9n9Y3+qVZqxf/PORa+9XCyFm5iGq2IzvtLyPFD/gatAV
         2+tFbSPVESYc+6AzVUy3xZgfRfBNlkc+a4uIMx2/mw4OkHj1dNZtoafjh3d69LMBgigN
         u90Ab4Cm05y0cu60XOf6Ve2ggub2PD+lLjsoZxPHQo9yLgLNtUTMqb2A/OjWSpzqCQNV
         r7uyfufvyyqc/ZGhhWJhB5eGuBjxfFPt/dcV1pHnL5uoJw42ngwEkFO/rxNNFs6jwicM
         8YJuH2Y3m2DoxHOKplslMtTIF6c3pYnAryAyWnYQ64oKSHnCp1sWqEPB7t1HY1PVDKe+
         5qXg==
X-Gm-Message-State: AOAM533B9i1TgVC7Pzj+pEZx0ylTLr5sTtkkxFFXUv0mzGwOKDGbsn0p
        VR0rWjUIftEA2zJVMYyAaVvW3lJ1iyym7+bo
X-Google-Smtp-Source: ABdhPJxUcLxVvHcungJ/u8mKlomdmSoM+z9Z0/wfx0EDKoCLliJIJcUmyYrzylj+sfx8Tmyi4TDgZPNYbu5dQXeU
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90b:1e4e:b0:1c7:3512:c2ac with SMTP
 id pi14-20020a17090b1e4e00b001c73512c2acmr817714pjb.61.1649115727218; Mon, 04
 Apr 2022 16:42:07 -0700 (PDT)
Date:   Mon,  4 Apr 2022 23:41:52 +0000
In-Reply-To: <20220404234154.1251388-1-yosryahmed@google.com>
Message-Id: <20220404234154.1251388-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220404234154.1251388-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 3/5] KVM: arm64: mm: count KVM page table pages in
 pagetable stats
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     mizhang@google.com, David Matlack <dmatlack@google.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Count the pages used by KVM in arm64 for page tables in pagetable stats.

Account pages allocated for PTEs in pgtable init functions and
kvm_set_table_pte().

Since most page table pages are freed using put_page(), add a helper
function put_pte_page() that checks if this is the last ref for a pte
page before putting it, and unaccounts stats accordingly.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/arm64/kernel/image-vars.h |  3 ++
 arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 884844849c70..4c87a718ccf0 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -139,6 +139,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
 /* pKVM static key */
 KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
 
+/* Called by kvm_account_pgtable_pages() to update pagetable stats */
+KVM_NVHE_ALIAS(__mod_lruvec_page_state);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2cb3867eb7c2..53e13c3313e9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -152,6 +152,7 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
 
 	WARN_ON(kvm_pte_valid(old));
 	smp_store_release(ptep, pte);
+	kvm_account_pgtable_pages((void *)childp, +1);
 }
 
 static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
@@ -326,6 +327,14 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
 	return ret;
 }
 
+static void put_pte_page(kvm_pte_t *ptep, struct kvm_pgtable_mm_ops *mm_ops)
+{
+	/* If this is the last page ref, decrement pagetable stats first. */
+	if (!mm_ops->page_count || mm_ops->page_count(ptep) == 1)
+		kvm_account_pgtable_pages((void *)ptep, -1);
+	mm_ops->put_page(ptep);
+}
+
 struct hyp_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
@@ -488,10 +497,10 @@ static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 	dsb(ish);
 	isb();
-	mm_ops->put_page(ptep);
+	put_pte_page(ptep, mm_ops);
 
 	if (childp)
-		mm_ops->put_page(childp);
+		put_pte_page(childp, mm_ops);
 
 	return 0;
 }
@@ -522,6 +531,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
 	if (!pgt->pgd)
 		return -ENOMEM;
+	kvm_account_pgtable_pages((void *)pgt->pgd, +1);
 
 	pgt->ia_bits		= va_bits;
 	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
@@ -541,10 +551,10 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!kvm_pte_valid(pte))
 		return 0;
 
-	mm_ops->put_page(ptep);
+	put_pte_page(ptep, mm_ops);
 
 	if (kvm_pte_table(pte, level))
-		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
+		put_pte_page(kvm_pte_follow(pte, mm_ops), mm_ops);
 
 	return 0;
 }
@@ -558,7 +568,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	pgt->mm_ops->put_page(pgt->pgd);
+	put_pte_page(pgt->pgd, pgt->mm_ops);
 	pgt->pgd = NULL;
 }
 
@@ -694,7 +704,7 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
 	}
 
-	mm_ops->put_page(ptep);
+	put_pte_page(ptep, mm_ops);
 }
 
 static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
@@ -795,7 +805,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 	if (data->anchor) {
 		if (stage2_pte_is_counted(pte))
-			mm_ops->put_page(ptep);
+			put_pte_page(ptep, mm_ops);
 
 		return 0;
 	}
@@ -848,8 +858,8 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 		childp = kvm_pte_follow(*ptep, mm_ops);
 	}
 
-	mm_ops->put_page(childp);
-	mm_ops->put_page(ptep);
+	put_pte_page(childp, mm_ops);
+	put_pte_page(ptep, mm_ops);
 
 	return ret;
 }
@@ -962,7 +972,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!kvm_pte_valid(pte)) {
 		if (stage2_pte_is_counted(pte)) {
 			kvm_clear_pte(ptep);
-			mm_ops->put_page(ptep);
+			put_pte_page(ptep, mm_ops);
 		}
 		return 0;
 	}
@@ -988,7 +998,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 					       kvm_granule_size(level));
 
 	if (childp)
-		mm_ops->put_page(childp);
+		put_pte_page(childp, mm_ops);
 
 	return 0;
 }
@@ -1177,16 +1187,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      enum kvm_pgtable_stage2_flags flags,
 			      kvm_pgtable_force_pte_cb_t force_pte_cb)
 {
-	size_t pgd_sz;
+	u32 pgd_num;
 	u64 vtcr = mmu->arch->vtcr;
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 
-	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
-	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
+	pgd_num = kvm_pgd_pages(ia_bits, start_level);
+	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_num * PAGE_SIZE);
 	if (!pgt->pgd)
 		return -ENOMEM;
+	kvm_account_pgtable_pages((void *)pgt->pgd, +pgd_num);
 
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
@@ -1210,17 +1221,17 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!stage2_pte_is_counted(pte))
 		return 0;
 
-	mm_ops->put_page(ptep);
+	put_pte_page(ptep, mm_ops);
 
 	if (kvm_pte_table(pte, level))
-		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
+		put_pte_page(kvm_pte_follow(pte, mm_ops), mm_ops);
 
 	return 0;
 }
 
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 {
-	size_t pgd_sz;
+	u32 pgd_num;
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
@@ -1229,7 +1240,8 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
-	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
+	pgd_num = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
+	kvm_account_pgtable_pages((void *)pgt->pgd, -pgd_num);
+	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_num * PAGE_SIZE);
 	pgt->pgd = NULL;
 }
-- 
2.35.1.1094.g7c7d902a7c-goog

