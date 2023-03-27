Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93C66C9FAB
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjC0Jed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjC0JeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:34:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366EE5274;
        Mon, 27 Mar 2023 02:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679909641; x=1711445641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sTUWE0zIue9rn+1zVTq2OYPpArHNzBrN70lBtzwd6gM=;
  b=Q6HryV+3t578r9h4CWcwe6mD9bvJwLDogUnjJ24Y6U4RQkda6q26xx1j
   l3/za+KfdnkEsh7eYMRpQqU/dEWCub1bNU6+0g8sRSNOef7wPSHbLp1tL
   J6Ark9cESYmN+yMSbvFdg2BVziCHcjdJThCaQmDkiFZWfMudb/nu/m6T0
   C+d3TivcE/vr8EceC1tkoIL32+jP8tFZJ4zSCrem3vI+63k9dlylgTQDi
   riILpf8kBLb5k5vVkIRTScP25YHmktNBoan1D/hdw+xTfd70jKH7oxP70
   U6/ZabzP8EJK1Vfsp0DtVazY/7+HsqAbA4kXUGAo7jO7srEybaVSvFhkk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="402817910"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="402817910"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:33:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="685908076"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="685908076"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 02:33:54 -0700
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
        yanting.jiang@intel.com
Subject: [PATCH v3 1/6] iommu/iommufd: Pass iommufd_ctx pointer in iommufd_get_ioas()
Date:   Mon, 27 Mar 2023 02:33:46 -0700
Message-Id: <20230327093351.44505-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230327093351.44505-1-yi.l.liu@intel.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

no need to pass the iommufd_ucmd pointer.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/ioas.c            | 14 +++++++-------
 drivers/iommu/iommufd/iommufd_private.h |  4 ++--
 drivers/iommu/iommufd/selftest.c        |  6 +++---
 drivers/iommu/iommufd/vfio_compat.c     |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 31577e9d434f..d5624577f79f 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -71,7 +71,7 @@ int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd)
 	if (cmd->__reserved)
 		return -EOPNOTSUPP;
 
-	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	ioas = iommufd_get_ioas(ucmd->ictx, cmd->ioas_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
@@ -151,7 +151,7 @@ int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd)
 	if (cmd->__reserved)
 		return -EOPNOTSUPP;
 
-	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	ioas = iommufd_get_ioas(ucmd->ictx, cmd->ioas_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 	iopt = &ioas->iopt;
@@ -213,7 +213,7 @@ int iommufd_ioas_map(struct iommufd_ucmd *ucmd)
 	if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX)
 		return -EOVERFLOW;
 
-	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	ioas = iommufd_get_ioas(ucmd->ictx, cmd->ioas_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
@@ -253,7 +253,7 @@ int iommufd_ioas_copy(struct iommufd_ucmd *ucmd)
 	    cmd->dst_iova >= ULONG_MAX)
 		return -EOVERFLOW;
 
-	src_ioas = iommufd_get_ioas(ucmd, cmd->src_ioas_id);
+	src_ioas = iommufd_get_ioas(ucmd->ictx, cmd->src_ioas_id);
 	if (IS_ERR(src_ioas))
 		return PTR_ERR(src_ioas);
 	rc = iopt_get_pages(&src_ioas->iopt, cmd->src_iova, cmd->length,
@@ -262,7 +262,7 @@ int iommufd_ioas_copy(struct iommufd_ucmd *ucmd)
 	if (rc)
 		return rc;
 
-	dst_ioas = iommufd_get_ioas(ucmd, cmd->dst_ioas_id);
+	dst_ioas = iommufd_get_ioas(ucmd->ictx, cmd->dst_ioas_id);
 	if (IS_ERR(dst_ioas)) {
 		rc = PTR_ERR(dst_ioas);
 		goto out_pages;
@@ -292,7 +292,7 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 	unsigned long unmapped = 0;
 	int rc;
 
-	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	ioas = iommufd_get_ioas(ucmd->ictx, cmd->ioas_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
@@ -381,7 +381,7 @@ int iommufd_ioas_option(struct iommufd_ucmd *ucmd)
 	if (cmd->__reserved)
 		return -EOPNOTSUPP;
 
-	ioas = iommufd_get_ioas(ucmd, cmd->object_id);
+	ioas = iommufd_get_ioas(ucmd->ictx, cmd->object_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 9d7f71510ca1..2e6e8e217cce 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -211,10 +211,10 @@ struct iommufd_ioas {
 	struct list_head hwpt_list;
 };
 
-static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
+static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ctx *ictx,
 						    u32 id)
 {
-	return container_of(iommufd_get_object(ucmd->ictx, id,
+	return container_of(iommufd_get_object(ictx, id,
 					       IOMMUFD_OBJ_IOAS),
 			    struct iommufd_ioas, obj);
 }
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index cfb5fe9a5e0e..8667eb222cf1 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -75,7 +75,7 @@ void iommufd_test_syz_conv_iova_id(struct iommufd_ucmd *ucmd,
 		return;
 	*flags &= ~(u32)MOCK_FLAGS_ACCESS_SYZ;
 
-	ioas = iommufd_get_ioas(ucmd, ioas_id);
+	ioas = iommufd_get_ioas(ucmd->ictx, ioas_id);
 	if (IS_ERR(ioas))
 		return;
 	*iova = iommufd_test_syz_conv_iova(&ioas->iopt, iova);
@@ -279,7 +279,7 @@ static int iommufd_test_mock_domain(struct iommufd_ucmd *ucmd,
 	struct iommufd_ioas *ioas;
 	int rc;
 
-	ioas = iommufd_get_ioas(ucmd, cmd->id);
+	ioas = iommufd_get_ioas(ucmd->ictx, cmd->id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
@@ -322,7 +322,7 @@ static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
 	struct iommufd_ioas *ioas;
 	int rc;
 
-	ioas = iommufd_get_ioas(ucmd, mockpt_id);
+	ioas = iommufd_get_ioas(ucmd->ictx, mockpt_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 	down_write(&ioas->iopt.iova_rwsem);
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index 514494a0025b..fe02517c73cc 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -137,7 +137,7 @@ int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
 		return iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 
 	case IOMMU_VFIO_IOAS_SET:
-		ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+		ioas = iommufd_get_ioas(ucmd->ictx, cmd->ioas_id);
 		if (IS_ERR(ioas))
 			return PTR_ERR(ioas);
 		xa_lock(&ucmd->ictx->objects);
-- 
2.34.1

