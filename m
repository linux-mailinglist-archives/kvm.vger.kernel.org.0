Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08CF674CE7
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 06:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjATF6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 00:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjATF6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 00:58:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0938661A0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 21:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674194279; x=1705730279;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qO3loxrpApHeUs48FOJbFjVd9MSUnUWsGfno0aAx/oc=;
  b=oB11MxGc11StMTHc08qCLGtjHgqD40PPZo13xdWO7EgK7UntzhbgFd3t
   Q80mz2bf+bV8l01yZuKSyNL1/68TV0koOY90ejRiwblan/ME5XoW9tXuk
   Delrj9cbIpt0FVIQgLrB6SZ7fS5YIDiypkB/9bQxGSTd/7me3d55wexOP
   9vk2y80WhiK4XGFXvRe8NpllHePFHyEO9q5gQptjutT9QThrNWWDGEzyO
   sqjQKzzh0CrMo9qmYv78axYO3v/IWEjHo7du3m3pOtjknbR4Pn6LzILoA
   WURu8xRDAulBa92BeAsDiZkYFwNR34BlLjF7mCprU+Luj993b9RKioDan
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="324194802"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="324194802"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 21:57:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="905854744"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="905854744"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jan 2023 21:57:59 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com, kevin.tian@intel.com
Cc:     yi.l.liu@intel.com, kvm@vger.kernel.org, iommu@lists.linux.dev
Subject: [PATCH] iommufd: Add two missing structures in ucmd_buffer
Date:   Thu, 19 Jan 2023 21:57:57 -0800
Message-Id: <20230120055757.67879-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct iommu_option and struct iommu_vfio_ioas are missed in ucmd_buffer.
Although they are smaller than the size of ucmd_buffer, it is safer to
list them in ucmd_buffer explicitly.

Fixes: aad37e71d5c4 ("iommufd: IOCTLs for the io_pagetable")
Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 083e6fcbe10a..1fbfda4b53bf 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -255,6 +255,8 @@ union ucmd_buffer {
 	struct iommu_ioas_iova_ranges iova_ranges;
 	struct iommu_ioas_map map;
 	struct iommu_ioas_unmap unmap;
+	struct iommu_option option;
+	struct iommu_vfio_ioas vfio_ioas;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
-- 
2.34.1

