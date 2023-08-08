Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D6A773EFD
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjHHQkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjHHQja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 12:39:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD3E155A0;
        Tue,  8 Aug 2023 08:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691510063; x=1723046063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ocUW9vorpBfsQJM0jJFuvi0sbVc6/jU+9IayIc6V+C0=;
  b=RewRBO1W3a89ECBY8L0u9HwnGl4ZHMIJBLPexztM6KIw1E/2mDgXETWB
   GeTWYah26SxGEoXcSkTrZWcTAHr88e11rUvEcml8j9IdJbyCev54oSvOl
   NCwsWzT7PuWwigj/RJQ6n4TfN5eWk93d8y0F1sBfIAn8yYCY0o3Jx5uMj
   sgWtOI1Ys6CaFTqCMGtKKR5GZBTfXCieCtAcqn7/lTcuCl+trLsES7ikd
   9Bafzi6l7uMJRMZViku898FDeaJCIWZDkTqLDQ/N7b2fmreDspS3n1iAE
   sVSJ8HC6eWlOMdoU2GF/cyjEZn9ovtKHYIaxt7vq0KwjY0i1p2MQi6s0f
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="437077172"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="437077172"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:41:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="681143961"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="681143961"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:41:50 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 1/3] mm/mmu_notifier: introduce a new mmu notifier flag MMU_NOTIFIER_RANGE_NUMA
Date:   Tue,  8 Aug 2023 15:14:48 +0800
Message-Id: <20230808071448.20105-1-yan.y.zhao@intel.com>
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

Introduce a new mmu notifier flag MMU_NOTIFIER_RANGE_NUMA to indicate the
notification of MMU_NOTIFY_PROTECTION_VMA is for NUMA balance purpose
specifically.

So that, the subscriber of mmu notifier, like KVM, can do some
performance optimization according to this accurate information.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/mmu_notifier.h | 1 +
 mm/mprotect.c                | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 64a3e051c3c4..a6dc829a4bce 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -60,6 +60,7 @@ enum mmu_notifier_event {
 };
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
+#define MMU_NOTIFIER_RANGE_NUMA (1 << 1)
 
 struct mmu_notifier_ops {
 	/*
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 6f658d483704..cb99a7d66467 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -381,7 +381,9 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
 			mmu_notifier_range_init(&range,
-				MMU_NOTIFY_PROTECTION_VMA, 0,
+				MMU_NOTIFY_PROTECTION_VMA,
+				cp_flags & MM_CP_PROT_NUMA ?
+				MMU_NOTIFIER_RANGE_NUMA : 0,
 				vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-- 
2.17.1

