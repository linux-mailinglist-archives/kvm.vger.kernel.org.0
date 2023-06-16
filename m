Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE0A732BCC
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344417AbjFPJba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344086AbjFPJav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819612D7B;
        Fri, 16 Jun 2023 02:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686907847; x=1718443847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cw5q/x8iFiAWleDzpwNMsBaOgKBGI0jR+jvZ2itY57k=;
  b=Yf9yI7W4mckhi9Fx7WjEXZOMg80SdMfQE5sqQJOq8usGk4h7pr5ZJCrX
   T5+hdvj0aim6r8LOX/i6Ykul3E4l48fqDLnIWq7017eQ/ykY7K0VIDst4
   +PrLT9+E94bmifGZDwSy1BIcONqIaDVLcts4DxurOPmvPxJcrhb+cj40O
   J16vCqoyTC8t2cFLJECTdcveEIyoO+uu704YJswjFdBsQqP37JhSmf+sq
   m9Cw4tncXnYqSf0BfuR3XUsHd0VmCqfhK6kc+5JSLyJh8gE14jIDwf7v8
   axZagza8jzxkRatBp8omwvTwz55kUpgAHQSExS2aWFaeMc0lIWtaNmrm2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387863454"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="387863454"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 02:30:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742601922"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="742601922"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2023 02:30:45 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v8 03/10] iommufd: Reserve all negative IDs in the iommufd xarray
Date:   Fri, 16 Jun 2023 02:30:35 -0700
Message-Id: <20230616093042.65094-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616093042.65094-1-yi.l.liu@intel.com>
References: <20230616093042.65094-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With this reservation, IOMMUFD users can encode the negative IDs for
specific purposes. e.g. VFIO needs two reserved values to tell userspace
the ID returned is not valid but has other meaning.

Tested-by: Terrence Xu <terrence.xu@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 3fbe636c3d8a..32ce7befc8dd 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -50,7 +50,7 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 	 * before calling iommufd_object_finalize().
 	 */
 	rc = xa_alloc(&ictx->objects, &obj->id, XA_ZERO_ENTRY,
-		      xa_limit_32b, GFP_KERNEL_ACCOUNT);
+		      xa_limit_31b, GFP_KERNEL_ACCOUNT);
 	if (rc)
 		goto out_free;
 	return obj;
-- 
2.34.1

