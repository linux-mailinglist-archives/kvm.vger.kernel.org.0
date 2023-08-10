Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502F5777468
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjHJJZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjHJJZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:25:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C3A213F;
        Thu, 10 Aug 2023 02:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691659519; x=1723195519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=n1Msk62xu+U/2i8oJmw01jY05sFs/JrR7DH8MV3GHPs=;
  b=gVGzE4syAmyLeFTLq7q/I6Zw8D5pDr2UAigi0IPM3fWXkSJP7WeVbpNA
   ihHP2Mt5mc6GttJLAYvVnutUi2C4zDzBj0e654hLQLfl+q0gDMq3ZPOo8
   Lqi4WmyOuBT/Vnot79P3T5pvKwzYob2fP1AYs7gHe2G4+HIBUCSAOD+gZ
   HWPnz3gGWTdcrha34ZVlBbOuGcAxF6WYv//NpvUH6HZ8UbWk94NWNxOBK
   wsCQPAruSC9bpPHeeTzQJ45GpvUPfU91v9aNTbfgljd+7/Y0ODnCZ+5Yo
   SBqcP63A6tT5MdcMTTNhQ3EJgsC/qpLvnmPvhI4pnXQveC8IT7smnBgOA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="374123736"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="374123736"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:25:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="855867318"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="855867318"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:25:16 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 2/5] mm: don't set PROT_NONE to maybe-dma-pinned pages for NUMA-migrate purpose
Date:   Thu, 10 Aug 2023 16:58:25 +0800
Message-Id: <20230810085825.26038-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230810085636.25914-1-yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

