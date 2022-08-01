Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33FC3586D8B
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 17:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiHAPTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 11:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiHAPTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 11:19:41 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AE52AE26
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 08:19:40 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t9-20020a056a00138900b0052dc8a1b97dso147518pfg.2
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 08:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=S/2jI0VtfXi7m6ZMf+qwyQLgOYuMiCIT7wBl4PXRX+g=;
        b=OqEy/n2odJcpLuQeQrEW3uvv4W6U5wbHVoh+YVePDwAMenajqwhMu4ssIBWUMxydvo
         PKYVsYiXs6raDPcmybsCA24N7Xr/PKhc3cv0Vwr6BMp4HyuldkXfgDcjH9L3QbzEG3q5
         bnNJS2cnVbxfJyehbXL9D+5LzG6I9WBICeXtTSON6X+SPopmA/aqmPqDBG7bmgqEp6PG
         5KtSDvU7j4UB39QtuZW1XmQ721oGR4wdvlfPYnTwC+l7niSzawHFaz2uGJslDdVkhgFL
         9D7Sf0+Iz1Jj8kgeI9C//InH/tv88mSYgGkCu1saaRUz09yZ27m4tFnY+LnZQP+AJSP8
         CdjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=S/2jI0VtfXi7m6ZMf+qwyQLgOYuMiCIT7wBl4PXRX+g=;
        b=hrz2OBL8a32mCRQETybbwy4ow2WleB4EomoUKXsqMTnUHQN18sZiK+b+EcgnMzuVik
         gN5gjVjbxuQ2dYkg432s1scMwjWCyT+SVpdlWJt0pdR8tpZhkixg1xDLg2p0gw9LLqdk
         MVng+/YvItRx1vAs/Uox7Z90mRwkwLYMwnVYTVXKtMeF+vvL7kmPEH8IQZnDN7iiDDI7
         5aWNz4LPo8FOmA5tLOvn8wVJ5Ot0CrBOpIr1Wvc17bmXZdpq26ybl3uzcNm2lQyANyp0
         jwqNCQG6KaVpbrykZvxE+Rp5ZlTjQ3TtpLfXKCng1VfKxrFEK3jdeJeU/DxpxTed49wa
         gXrQ==
X-Gm-Message-State: AJIora+cqPoM0eN47+FZqgw0Nyf8xqjy7FHXOgm6eLg+1WveSI3l/SHx
        gfThT5r2Nbcd6mgXu+eb7cTteaxXIQko
X-Google-Smtp-Source: AGRyM1tmitgRItVDG9wYYQJP7lV6j2QhkGGFMfWO4zg8l7GgEPHyefkScB+izDXwBytqYaqte5+sZLs4g3s8
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:6c45:0:b0:419:b668:6d with SMTP id
 h66-20020a636c45000000b00419b668006dmr13395927pgc.548.1659367180173; Mon, 01
 Aug 2022 08:19:40 -0700 (PDT)
Date:   Mon,  1 Aug 2022 08:19:28 -0700
Message-Id: <20220801151928.270380-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting NUMA aware
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

tdp_mmu_alloc_sp_for_split() allocates page tables for Eager Page
Splitting.  Currently it does not specify a NUMA node preference, so it
will try to allocate from the local node. The thread doing eager page
splitting is supplied by the userspace and may not be running on the same
node where it would be best for page tables to be allocated.

We can improve TDP MMU eager page splitting by making
tdp_mmu_alloc_sp_for_split() NUMA-aware. Specifically, when splitting a
huge page, allocate the new lower level page tables on the same node as the
huge page.

__get_free_page() is replaced by alloc_page_nodes(). This introduces two
functional changes.

  1. __get_free_page() removes gfp flag __GFP_HIGHMEM via call to
  __get_free_pages(). This should not be an issue  as __GFP_HIGHMEM flag is
  not passed in tdp_mmu_alloc_sp_for_split() anyway.

  2. __get_free_page() calls alloc_pages() and use thread's mempolicy for
  the NUMA node allocation. From this commit, thread's mempolicy will not
  be used and first preference will be to allocate on the node where huge
  page was present.

dirty_log_perf_test for 416 vcpu and 1GB/vcpu configuration on a 8 NUMA
node machine showed dirty memory time improvements between 2% - 35% in
multiple runs.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf2ccf9debcaa..1e30e18fc6a03 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1402,9 +1402,19 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+/*
+ * Caller's responsibility to pass a valid spte which has the shadow page
+ * present.
+ */
+static int tdp_mmu_spte_to_nid(u64 spte)
+{
+	return page_to_nid(pfn_to_page(spte_to_pfn(spte)));
+}
+
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
 {
 	struct kvm_mmu_page *sp;
+	struct page *spt_page;
 
 	gfp |= __GFP_ZERO;
 
@@ -1412,11 +1422,12 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 	if (!sp)
 		return NULL;
 
-	sp->spt = (void *)__get_free_page(gfp);
-	if (!sp->spt) {
+	spt_page = alloc_pages_node(nid, gfp, 0);
+	if (!spt_page) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
 	}
+	sp->spt = page_address(spt_page);
 
 	return sp;
 }
@@ -1426,6 +1437,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       bool shared)
 {
 	struct kvm_mmu_page *sp;
+	int nid;
+
+	nid = tdp_mmu_spte_to_nid(iter->old_spte);
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
@@ -1436,7 +1450,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
 	if (sp)
 		return sp;
 
@@ -1448,7 +1462,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
-- 
2.37.1.455.g008518b4e5-goog

