Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFD077746D
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbjHJJ1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjHJJ1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:27:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967B22129;
        Thu, 10 Aug 2023 02:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691659661; x=1723195661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ckO2Ib+mc5GNqAr3UWlAyUsh+UXakl7WbTml3P3tRYo=;
  b=elnXKUW0eyi9BJovupJJwBi4C9VAeXrbjIhj5mCLEOVNKLKRvu0Syobq
   avK4Q37FI3W6LoVKA51S2HsWvRj8SSND5CwcXh9GffLBj2LP8aGLddfBC
   0/DVZjlPmNVlr9HDu/KznuB+aGjPf+DiAWG8kfxyrZ7KIETPYjoe30Xdh
   H8Koj/tMpc3SmBuHPCOZ+s19X2QCHwEBmijYF4vyPZLVHBIwAFOTv28O0
   EKAFQCDtfgGC5eDM4LEUlFU/kgV6j1LR/89jBEK26KYdBSPdrSCkthLY5
   xxlHKV3/Qsm7v8yl/aCEB7P+/B5tlrePUKL6vOjsyvWnNx0gO3hH7A+Ss
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="361487657"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="361487657"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:27:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="875629237"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:27:41 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 4/5] mm/autonuma: call .numa_protect() when page is protected for NUMA migrate
Date:   Thu, 10 Aug 2023 17:00:48 +0800
Message-Id: <20230810090048.26184-1-yan.y.zhao@intel.com>
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

Call mmu notifier's callback .numa_protect() in change_pmd_range() when
a page is ensured to be protected by PROT_NONE for NUMA migration purpose.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 mm/huge_memory.c | 1 +
 mm/mprotect.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a71cf686e3b2..8ae56507da12 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1892,6 +1892,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING &&
 		    !toptier)
 			xchg_page_access_time(page, jiffies_to_msecs(jiffies));
+		mmu_notifier_numa_protect(vma->vm_mm, addr, addr + PMD_SIZE);
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
diff --git a/mm/mprotect.c b/mm/mprotect.c
index a1f63df34b86..c401814b2992 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -164,6 +164,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 				    !toptier)
 					xchg_page_access_time(page,
 						jiffies_to_msecs(jiffies));
+				mmu_notifier_numa_protect(vma->vm_mm, addr, addr + PAGE_SIZE);
 			}
 
 			oldpte = ptep_modify_prot_start(vma, addr, pte);
-- 
2.17.1

