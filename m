Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA434D5663
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344739AbiCKAOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbiCKAOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:14:20 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F446A1BDE
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:13:18 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso4178313pjt.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8u1aPiGW/o27wTV56C41DyPROp99q3kPdYLfCSmvyXA=;
        b=kNm7mfwLzQXjrt3m9rW6/pTgtcbgoMOsvtbAt4D1PVW30e/8WMfq2SViV3ev8WjRPI
         rTzaYvo750KeeK2KRrcN1H5HNmnlaRuFjrlYmV2bPWuSIXv8694z4zIIX9ClSGS0/9n4
         0PjcLETfVwnavoM3k91KWojfvB+TlRkeV6kw+RWr5AggfrNxwVfOOM7ob9ZNJB9ePQo9
         XTV8R3dp8XBNrKQPrNDjg/+FvrrrRNH6Qt7xigyGa4oc2ZlAr9auwV9ujN1jEHdeDgwK
         2fhdt3qE1h9UI8TVqDx28RGfc58G63xj8lGefyTP8FSsdLCrla30tdM5gECTRgTQwqdA
         S4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8u1aPiGW/o27wTV56C41DyPROp99q3kPdYLfCSmvyXA=;
        b=AlJhYkEa2HgQsy1Mxjb0mK0fKJRf7SO892nicS/7Q8rEgCFUdCnR2kwhlHcpcMBHpY
         6FxvfST6shUpBq7QTkrbLC2qPRntIZsjyMi2+YEqhBJZ7DeZ/yK+695KPC7BQSJvzPqN
         e0kQQS3e752i/smOmDeWE441U2jDG7opwfom0cgsbiYOQYMQVt9AQHLEfMHRUFUpB4Ae
         GzdaOI5o1vnahbmGuMwX9kdWxGpG30EMwpttRYZcrcxemdhQHNuTCjkZ6zVMytFA/blH
         4x9AsapuB8jMpD3bbDsv/dF70Jo/Pfqbr/1wCpBkyNQFEvnlM8mOCbZxzVPMsnsr3b4Q
         57lQ==
X-Gm-Message-State: AOAM533s0dpIb35yF8jsqcdg/lDYz6dfGbHjOt+nmI227WF6S9sJvnob
        r/CRq5cMifqG8q1TeXCE27/hB6lY9q58hH6H
X-Google-Smtp-Source: ABdhPJw2ajaJNAzIOKb5V2NPwn0Kvslh/PvFKP6JTod3DIf570v+T9cZeeQ8gCz3zhnbZ/UBWRRx0a4qSqlK2vKt
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:903:291:b0:150:4197:7cf2 with SMTP
 id j17-20020a170903029100b0015041977cf2mr7444516plr.173.1646957597899; Thu,
 10 Mar 2022 16:13:17 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:12:52 +0000
Message-Id: <20220311001252.195690-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH] KVM: memcg: count KVM page table pages used by KVM in memcg
 pagetable stats
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Count the pages used by KVM for page tables in pagetable memcg stats in
memory.stat.

Most pages used for KVM page tables come from the mmu_shadow_page_cache,
in addition to a few allocations in __kvm_mmu_create() and
mmu_alloc_special_roots().

For allocations from the mmu_shadow_page_cache, the pages are counted as
pagetables when they are actually used by KVM (when
mmu_memory_cache_alloc_obj() is called), rather than when they are
allocated in the cache itself. In other words, pages sitting in the
cache are not counted as pagetables (they are still accounted as kernel
memory).

The reason for this is to avoid the complexity and confusion of
incrementing the stats in the cache layer, while decerementing them
by the cache users when they are being freed (pages are freed directly
and not returned to the cache).
For the sake of simplicity, the stats are incremented and decremented by
the users of the cache when they get the page and when they free it.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/mmu/mmu.c          | 19 +++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++++
 virt/kvm/kvm_main.c             | 17 +++++++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f72e80178ffc..4a1dda2f56e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -458,6 +458,13 @@ struct kvm_mmu {
 	*/
 	u32 pkru_mask;
 
+	/*
+	 * After a page is allocated for any of these roots,
+	 * increment per-memcg pagetable stats by calling:
+	 * inc_lruvec_page_state(page, NR_PAGETABLE)
+	 * Before the page is freed, decrement the stats by calling:
+	 * dec_lruvec_page_state(page, NR_PAGETABLE).
+	 */
 	u64 *pae_root;
 	u64 *pml4_root;
 	u64 *pml5_root;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b8da8b0745e..5f87e1b0da91 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1673,7 +1673,10 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
+
+	dec_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
 	free_page((unsigned long)sp->spt);
+
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
 	kmem_cache_free(mmu_page_header_cache, sp);
@@ -1711,7 +1714,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	inc_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
+
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
@@ -3602,6 +3608,10 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	mmu->pml4_root = pml4_root;
 	mmu->pml5_root = pml5_root;
 
+	/* Update per-memcg pagetable stats */
+	inc_lruvec_page_state(virt_to_page(pae_root), NR_PAGETABLE);
+	inc_lruvec_page_state(virt_to_page(pml4_root), NR_PAGETABLE);
+	inc_lruvec_page_state(virt_to_page(pml5_root), NR_PAGETABLE);
 	return 0;
 
 #ifdef CONFIG_X86_64
@@ -5554,6 +5564,12 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 {
 	if (!tdp_enabled && mmu->pae_root)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
+
+	/* Update per-memcg pagetable stats */
+	dec_lruvec_page_state(virt_to_page(mmu->pae_root), NR_PAGETABLE);
+	dec_lruvec_page_state(virt_to_page(mmu->pml4_root), NR_PAGETABLE);
+	dec_lruvec_page_state(virt_to_page(mmu->pml5_root), NR_PAGETABLE);
+
 	free_page((unsigned long)mmu->pae_root);
 	free_page((unsigned long)mmu->pml4_root);
 	free_page((unsigned long)mmu->pml5_root);
@@ -5591,6 +5607,9 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	if (!page)
 		return -ENOMEM;
 
+	/* Update per-memcg pagetable stats */
+	inc_lruvec_page_state(page, NR_PAGETABLE);
+
 	mmu->pae_root = page_address(page);
 
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af60922906ef..ce8930fd0835 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -64,6 +64,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	dec_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -273,7 +274,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	inc_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
 
 	return sp;
 }
@@ -1410,6 +1413,7 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 		return NULL;
 	}
 
+	inc_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
 	return sp;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9581a24c3d17..3c8cce440c34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -397,6 +397,23 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 	}
 }
 
+/*
+ * After this funciton is called to get a page from mmu_shadow_page_cache,
+ * increment per-memcg pagetable stats by calling:
+ * inc_lruvec_page_state(page, NR_PAGETABLE)
+ * Before the page is freed, decrement the stats by calling:
+ * dec_lruvec_page_state(page, NR_PAGETABLE).
+ *
+ * Note that for the sake per-memcg stats in memory.stat, the pages will be
+ * counted as pagetable pages only they are allocated from the cache. This means
+ * that pages sitting in the mmu_shadow_page_cache will not be counted as
+ * pagetable pages (but will still be counted as kernel memory).
+ *
+ * Counting pages in the cache can introduce unnecessary complexity as we will
+ * need to increment the stats in the cache layer when pages are allocated, and
+ * decrement the stats outside the cache layer when pages are freed. This can be
+ * confusing for new users of the cache.
+ */
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 {
 	void *p;
-- 
2.35.1.723.g4982287a31-goog

