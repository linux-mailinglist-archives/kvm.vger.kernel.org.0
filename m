Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F7F55F318
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 04:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiF2CFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 22:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiF2CFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 22:05:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74865313B6;
        Tue, 28 Jun 2022 19:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656468315; x=1688004315;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oEv43ZklnInyeYG0C+sgV1T7PE3bi9pBSUOvJ2667rQ=;
  b=ELaes25dUQXmdJC5/gRhlctVKCColhq4Ng8icKyApFcdrOQYS5lrJPKH
   FRICR5A+uaZ2VA9iV+SIYINddOpS9CxA0j9x5qbaGPjsuNiGWZy8+iPHK
   cOeZ8KvdNVqA6mdQsf+P7VDu1zOCYdB4sBLUfZDLVyL/MBAmh8wIWTR0e
   7BgHsQl4Xn6+/pJpUFI39QhN7sZHLV55ChikvCAt2e3wXj2QcoHD964CG
   Xc7qCuexyOdUkDpPqVFBR4Gv0Aic8arXSDGGYsrR60plVFXn1YA2i33SP
   5l+AhBwbfJzF4S36hV2FJ7yzuBqFcHG0MHvp8SbvkDsydg4xgiO92HlWS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="270660468"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="270660468"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 19:05:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="647171135"
Received: from leirao-pc.bj.intel.com ([10.238.156.101])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jun 2022 19:05:01 -0700
From:   Lei Rao <lei.rao@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lei Rao <lei.rao@intel.com>
Subject: [PATCH] vfio: Fix memory leaks in vfio_create_group()
Date:   Wed, 29 Jun 2022 10:05:00 +0800
Message-Id: <20220629020500.878300-1-lei.rao@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If an error occurs after vfio_group_alloc(), we need to release the
group.

Signed-off-by: Lei Rao <lei.rao@intel.com>
---
 drivers/vfio/vfio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..2460aec44a6d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -414,6 +414,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	mutex_unlock(&vfio.group_lock);
 err_put:
 	put_device(&group->dev);
+	vfio_group_release(&group->dev);
 	return ret;
 }
 
-- 
2.32.0

