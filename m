Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2CC7CB921
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjJQDVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjJQDVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:21:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E0FAB;
        Mon, 16 Oct 2023 20:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512871; x=1729048871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dsdAUA8p1gbd434H5E9bJERERFBzsxCgS1ZKXsNQj30=;
  b=artdBOv5V1vsnvytgpJOdYu1b//88t1Du6e2GHqbNAjo0a2eE87uBkhu
   m0gaj+1TZRX5pUhCXxkr5CokalCPAyumJkGIJ1g+yUUTKqzqSaqBluMBm
   tbrmNzJV+WQra0dbyJ7CbWB9bAtjyAXHtNA3cVQWPtfxVf/yiwWg4E5AY
   ioRO2D8APwJLdmXawT4Kz9sL3BPdVCqRVEbr9c3KOvm2DKHS+7M+4/46L
   ftbX1GGwFVZmUzH+54TmU9EUAukhYwfvQn/4IDGVt93EnEeg2nBSicwnO
   hB3KU0NnhA5QGF50fiq/nlc8Rl3xpKKVaKg/YWyoBdJGqhB2kwY0i9xGC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560777"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560777"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826269905"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826269905"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:08 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 01/12] iommu/vt-d: Retire the treatment for revoking PASIDs with pending pgfaults
Date:   Tue, 17 Oct 2023 11:20:33 +0800
Message-Id: <20231017032045.114868-2-tina.zhang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231017032045.114868-1-tina.zhang@intel.com>
References: <20231017032045.114868-1-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revoking PASIDs with pending page faults has been achieved by clearing the
pasid entry and draining the pending page faults in both hardware and
software. The temporary treatment can be retired now.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/svm.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 3c531af58658..9bf79cf88aec 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -387,13 +387,6 @@ void intel_svm_remove_dev_pasid(struct device *dev, u32 pasid)
 			if (svm->notifier.ops)
 				mmu_notifier_unregister(&svm->notifier, mm);
 			pasid_private_remove(svm->pasid);
-			/*
-			 * We mandate that no page faults may be outstanding
-			 * for the PASID when intel_svm_unbind_mm() is called.
-			 * If that is not obeyed, subtle errors will happen.
-			 * Let's make them less subtle...
-			 */
-			memset(svm, 0x6b, sizeof(*svm));
 			kfree(svm);
 		}
 	}
-- 
2.39.3

