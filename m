Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D18773F1C
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjHHQn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjHHQmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 12:42:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142021655A;
        Tue,  8 Aug 2023 08:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691510124; x=1723046124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=n1Msk62xu+U/2i8oJmw01jY05sFs/JrR7DH8MV3GHPs=;
  b=ORZ+D49z9sv2aH5G42g9nIrix9X2cgGmyTJ4Bl2+LhxKMpczVnVeiqYU
   bp6ry9i1ngVoYhNdVq02CQrmWCme9/BMSxrTNH8rjai9J/aBELx3W6iDJ
   Q0UlQvSQWOJrO07VBBmNoXzaw7r/Hw9fXQQGl6H6iQLTin7jQapkkFncN
   Dgp1Akviyn2G+OTMuHlvFB1WdxI09ZcBqAlwNdDTcUBsotTLccxo/t2hI
   PBz/eL1RfSrJ51WnM+AxIWETU+eaD0q4i8rcCGyji+EchJBtpo/MUWQv1
   arBJCXpIvZ3LtV98wU/fHW8VgwkXY6DY/ccNUo59hE0sioJcyxVzFf50n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="369646759"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="369646759"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="874625381"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:42:43 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 2/3] mm: don't set PROT_NONE to maybe-dma-pinned pages for NUMA-migrate purpose
Date:   Tue,  8 Aug 2023 15:15:46 +0800
Message-Id: <20230808071546.20173-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230808071329.19995-1-yan.y.zhao@intel.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't set PROT_NONE for exclusive anonymas and maybe-dma-pinned pages for
NUMA migration purpose.

For exclusive anonymas and page_maybe_dma_pinned() pages, NUMA-migration
will eventually drop migration of those pages in try_to_migrate_one().
(i.e. after -EBUSY returned in page_try_share_anon_rmap()).

So, skip setting PROT_NONE to those kind of pages earlier in
change_protection_range() phase to avoid later futile page faults,
detections, and restoration to original PTEs/PMDs.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 mm/huge_memory.c | 5 +++++
 mm/mprotect.c    | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb3678360b97..a71cf686e3b2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1875,6 +1875,11 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			goto unlock;
 
 		page = pmd_page(*pmd);
+
+		if (PageAnon(page) && PageAnonExclusive(page) &&
+		    page_maybe_dma_pinned(page))
+			goto unlock;
+
 		toptier = node_is_toptier(page_to_nid(page));
 		/*
 		 * Skip scanning top tier node if normal numa
diff --git a/mm/mprotect.c b/mm/mprotect.c
index cb99a7d66467..a1f63df34b86 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -146,6 +146,11 @@ static long change_pte_range(struct mmu_gather *tlb,
 				nid = page_to_nid(page);
 				if (target_node == nid)
 					continue;
+
+				if (PageAnon(page) && PageAnonExclusive(page) &&
+				    page_maybe_dma_pinned(page))
+					continue;
+
 				toptier = node_is_toptier(nid);
 
 				/*
-- 
2.17.1

