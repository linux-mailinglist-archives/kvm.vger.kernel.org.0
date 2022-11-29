Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43063C96B
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiK2Udx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbiK2UdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:25 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E986A76C
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNii8TYLXPZ+NjFk1U5QImQ3Tbp+FZilsWxpRNJMYbN5GmMDJaJRLrmo1s+z8Je3Y1XyHuB/+mkNhun6NdZXiZxmjxTINNRChR63dgrr6GeABBq73B6go9Kmh8t0VtvuhuZxk7MRIoeTxwCVmnv1XvJrd789pGep8TFBGMATmL2dHV3KcBzEVeopLcMizyQGSCcDlRvVvUDT81V9FjfeeQfDfxsHExGr4FeZnG6t/FuvrxvRhYE4eqZFFyD725LlodQaRkv1RU3InCReJyj8MPPcobxLEGTPEby410jVbhsBjoMWcAUryfoyRyT3t6kOT8wDgVjmumO64vppNW5zHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pw9pT49w4ykIaFoGUtYpcV/7XCoNxj5uNt4C8ddb5i8=;
 b=TMGDUgu5Gsl4ncdOT2a7pYfURJ3U3xoyEGspLnXda7GJzMrvSO/Jt93hCFOZdGhxtd7ioYlWbLFEBNyfY8+4o3Awr1T+YUTePue9QUFKYG8cOHzBPTTaMS05kvNynZDsx+wGdc76l2jaOVk8Lx7p96ozO6iUPeHjkrFsf44scgohSTTEpzS9MatQTtoe3YFSURJcxL/fm7RDDjbltOhw2cut4VDWnwLp5TQ+rj5DL89AN7GyusCkv5g4cMn3NHCGIrzfBZHUvL5w3vNhk78bBcUXGiINzb1BAJ7Jq3vRLqO1gqtMB8Pi9/dhgbFekGic+6RhfJkct2woucPPLjta+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pw9pT49w4ykIaFoGUtYpcV/7XCoNxj5uNt4C8ddb5i8=;
 b=oY1TPOmhEV2Eu/M4h8hyU87JRf8Kj0FKstpvub6Q9GjsuVhbkyuSukKiy5i4fa1WMTBE2AtXwX9MG3UcLnqwDU8m2Bn7QDW2bfS/XlEjMw3Gft3p6dO4L7Fqs4K01QBSdm2UqfHuLCyFAx0c6uwMNegICldB+Uc9ts/xrR6EglPynpJd59TvBoy7v+3aCRfN/Qq2wjtudvyp/mRCycOqWfAzIa3R4EeQ1FmDdqgd+wWTJXCjzb3BjpgXaHkoBZWG/kmEOq7UQq1A7f44q3b97mcbyHT6jhhztET/98g0RtnNVm2vkwJKSFEtI07KHDDRzS86FgfJNCrBszwDKDaDaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:04 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 07/10] vfio-iommufd: Support iommufd for emulated VFIO devices
Date:   Tue, 29 Nov 2022 16:31:52 -0400
Message-Id: <7-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: e04f98b9-43cc-4929-9f34-08dad248c4e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sN4sa/iq9ZiZcbPqDDcCbH0wZh139S8I8ASgOPbQxNGToZE30fJbniPfMJSdmplU/eWXD/sIWHMp0YDrESy05DJniEnzYDw6KgyLIyELdHj+bz4iip4mMM2lOQsQZgNKwzpDOxBT8hzQvl+jiFr3Xt9OVkVrr/Gu5GRDzUCndXj3hoKRzczkyX5Suk0QJ6rumtO2xAmhCXIJ2x9Az/38s5cjLnGljXvy1FqCef2FdOYnnjm9Bwp3SLkSB9jzVQLZCvTkdhY8A5inTladq6Dnb97EE8YHfLg4krymsp32Y5ORCppFdfiIupU4+idqutHYv4kyQDswN2PF7Rh7SsFR4l9iEFxSUWEkcUbhvvTdd9uTtIMFBoLtQqcbtgtXZAD5aeXecnXSDWEzo5dVuK5kTf4KxWOztG1bKwCN9w2W1GQXhxt1qOz/53vIR2bTApjco7hyHcmi9CwDCCovyRcp7Gi4XVDmuydOo2qkFsfPnmUarBZnXZzKzwphj3ikElP78oZeKIo1Xre+hCo5rSR2dW1cZZRazknI6+iLxFnoCxyLB5MCvo2GE6z2iIuv4qycgIpXE4NUYqwQLk78aVecEkiL6ytiSsU1Y4lCvd5FYxfuKOkmTV2AG7nniK9hu+4NSM965hiKgtusS8UybDCiUunK6lFNBfqt+HLqvL5XZuJYiKNt7APVsV6nDKQCov8UQY4p+yd+xJDvYpT1433AMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(30864003)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7D8e0oTmxYtxNLjlQX30okUdDEkM7XZKmBEtVSlc6UtFOuxBizxT/dXyvmw4?=
 =?us-ascii?Q?39p+4DFM+FFskJDjUduONYjRMSkGo0le6CgftzwCyoEIRPoduaHwqkubRTIS?=
 =?us-ascii?Q?XJOzQkLntKfMGz85jitlvymJpkbfdk0RAg9pGJzdDmHxU3MM9zmWYscbn+bL?=
 =?us-ascii?Q?nOXqHt576hZnulmqN7qjr673uGkziCkaG/U4PxF9x9p0kOre9KfBFq7x1XO7?=
 =?us-ascii?Q?87/1mb3ICyZAnjDl/sT7pKZXIVOqAnQf3/dZVsAaUfo9yRgNh1mBjvhs2A8w?=
 =?us-ascii?Q?X5jKOLj+UiVpQ5bVXYjP0Zom8/Cnu4o8aG9UcAHdeau919nxhEfrrLuvOG5A?=
 =?us-ascii?Q?BMRyv65hcKlCfzBOHhOOwyHshrQchX7fP4kwUqtT460cbNEgad8fIKkLEpnr?=
 =?us-ascii?Q?mQWPY6fUZq0cnMRBEQM0nt4kdQwK2OPwXVwk36hvSxFEMZI4mVF1h4obI45b?=
 =?us-ascii?Q?LIWDxs4qQ4GhoxqEfaqZJ2G3n4lqiNLt6WvjDd4XHDdIH+IJ3zY1LRSwWz+V?=
 =?us-ascii?Q?m3f0tSZToEiG56+DUkcKLB3EVRMpF6o2kiZhbrvhNgHmwK9KQL7l4QvE0SHY?=
 =?us-ascii?Q?93xgpEjjCBEpf4rqz0z9KijJI1qNRH5ygTq8v3uhgMfDz29uo0qXlWh8PUsU?=
 =?us-ascii?Q?TsThinyNUlypY5VlUluDkKGp4FHDKS85JV/SNtixopcd5yzMb6yuAfVKgjRk?=
 =?us-ascii?Q?GKuSSXk390C/a1CEYarw6UQ3FAr5EJfsJwgLJ++SLu2KOHoZ256pECelLDo6?=
 =?us-ascii?Q?RbEuvHvYAeATYPm98ZvV/dkoqCu3V77voRMCH0C7HWvC4HFSSINqIzN72oYG?=
 =?us-ascii?Q?GQPMXPl871K+U4zMRiO+tgq12Tu6WWmOKsxfXLMAtvEV+QYz9pohDi7NIXUm?=
 =?us-ascii?Q?pDnvRFVKFiF0rBvghi1iM4SG7jsdwC9mhAFALmn46OKItGmsuOE4M82EudeK?=
 =?us-ascii?Q?6TUJjJCIZbjeERJAjr24zBfwB2PC5kPsMpYUdKsoco+6vRFbCJnRXOq5m3gi?=
 =?us-ascii?Q?t8dESccml9x2f0nSnohYO7rgODYB5AOLPi/ZtC236UZtYdzrcn6lKFCwiK7K?=
 =?us-ascii?Q?2vnWLhCXLpGfDDvRVHxeNzEqRBKAcSIP9z7hRNyLk1cbwVBbq5gUx0dydO7A?=
 =?us-ascii?Q?8RHwMQgYlfOcM8yP41PdLrLhqcwe1CflHejyq5WMGdYic6B27lngiR9c4dY4?=
 =?us-ascii?Q?67BIWYTKXbHKs5giYCLmZFH97WUiKdEmFxwsPxaFBgtqlnSrYmGRbRu9SXwu?=
 =?us-ascii?Q?/Y3X2atXpEXzeL7QKdFmnw5jGEw20syDobyOmRVTqV7/30Dvsv1GpdTMjsdo?=
 =?us-ascii?Q?Ua+g0PnzBU2ItB5o7R5WSh0Ynk9Z9rmpOD4Tcye4Pw6wPCyZ0IyaPH+H5cqb?=
 =?us-ascii?Q?OYxSvTRsgYHHk3z7EjOI4X6tusQUA+dQYf7LqQ4K+W3k2LIFPv/l6CV0MI7r?=
 =?us-ascii?Q?yae0dicuD2G/5ZzMARJtXIt/uxTPnX2Uoy9nYiH9cku1XooUUsuXqLKCA/6n?=
 =?us-ascii?Q?j8D/hk42Mx7w3sRwwapfdfBzd/ArvQoW0wBUNTRQYRvri3dKm2btwRpuqSsy?=
 =?us-ascii?Q?t0y1I38MBIOcs2QBcVRj0CxwKnR4E9RRtI5pW7hC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04f98b9-43cc-4929-9f34-08dad248c4e1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:32:01.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SSSlB4/dclyB6HQejLLHBxgxxdD4Cq301lMEWcFELpVTjnMafUco+j8U5XnHIPd7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulated VFIO devices are calling vfio_register_emulated_iommu_dev() and
consist of all the mdev drivers.

Like the physical drivers, support for iommufd is provided by the driver
supplying the correct standard ops. Provide ops from the core that
duplicate what vfio_register_emulated_iommu_dev() does.

Emulated drivers are where it is more likely to see variation in the
iommfd support ops. For instance IDXD will probably need to setup both a
iommfd_device context linked to a PASID and an iommufd_access context to
support all their mdev operations.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c  |   3 +
 drivers/s390/cio/vfio_ccw_ops.c   |   3 +
 drivers/s390/crypto/vfio_ap_ops.c |   3 +
 drivers/vfio/container.c          | 110 +++++----------------------
 drivers/vfio/iommufd.c            |  58 ++++++++++++++
 drivers/vfio/vfio.h               |  10 ++-
 drivers/vfio/vfio_main.c          | 122 +++++++++++++++++++++++++++++-
 include/linux/vfio.h              |  14 ++++
 8 files changed, 229 insertions(+), 94 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index f563e5dbe66fad..f99cbc0b1eed5b 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1479,6 +1479,9 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
 	.mmap		= intel_vgpu_mmap,
 	.ioctl		= intel_vgpu_ioctl,
 	.dma_unmap	= intel_vgpu_dma_unmap,
+	.bind_iommufd	= vfio_iommufd_emulated_bind,
+	.unbind_iommufd = vfio_iommufd_emulated_unbind,
+	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
 };
 
 static int intel_vgpu_probe(struct mdev_device *mdev)
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 6ae4d012d80084..560453d99c24fc 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -588,6 +588,9 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
 	.ioctl = vfio_ccw_mdev_ioctl,
 	.request = vfio_ccw_mdev_request,
 	.dma_unmap = vfio_ccw_dma_unmap,
+	.bind_iommufd = vfio_iommufd_emulated_bind,
+	.unbind_iommufd = vfio_iommufd_emulated_unbind,
+	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
 };
 
 struct mdev_driver vfio_ccw_mdev_driver = {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8bf353d46820e3..68eeb25fb6611c 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1805,6 +1805,9 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 	.close_device = vfio_ap_mdev_close_device,
 	.ioctl = vfio_ap_mdev_ioctl,
 	.dma_unmap = vfio_ap_mdev_dma_unmap,
+	.bind_iommufd = vfio_iommufd_emulated_bind,
+	.unbind_iommufd = vfio_iommufd_emulated_unbind,
+	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
 };
 
 static struct mdev_driver vfio_ap_matrix_driver = {
diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 8772dad6808539..7f3961fd4b5aac 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -540,113 +540,41 @@ void vfio_group_unuse_container(struct vfio_group *group)
 	fput(group->opened_file);
 }
 
-/*
- * Pin contiguous user pages and return their associated host pages for local
- * domain only.
- * @device [in]  : device
- * @iova [in]    : starting IOVA of user pages to be pinned.
- * @npage [in]   : count of pages to be pinned.  This count should not
- *		   be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
- * @prot [in]    : protection flags
- * @pages[out]   : array of host pages
- * Return error or number of pages pinned.
- *
- * A driver may only call this function if the vfio_device was created
- * by vfio_register_emulated_iommu_dev().
- */
-int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
-		   int npage, int prot, struct page **pages)
+int vfio_container_pin_pages(struct vfio_container *container,
+			     struct iommu_group *iommu_group, dma_addr_t iova,
+			     int npage, int prot, struct page **pages)
 {
-	struct vfio_container *container;
-	struct vfio_group *group = device->group;
-	struct vfio_iommu_driver *driver;
-	int ret;
-
-	if (!pages || !npage || !vfio_assert_device_open(device))
-		return -EINVAL;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-	/* group->container cannot change while a vfio device is open */
-	container = group->container;
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->pin_pages))
-		ret = driver->ops->pin_pages(container->iommu_data,
-					     group->iommu_group, iova,
-					     npage, prot, pages);
-	else
-		ret = -ENOTTY;
-
-	return ret;
+	if (unlikely(!driver || !driver->ops->pin_pages))
+		return -ENOTTY;
+	return driver->ops->pin_pages(container->iommu_data, iommu_group, iova,
+				      npage, prot, pages);
 }
-EXPORT_SYMBOL(vfio_pin_pages);
 
-/*
- * Unpin contiguous host pages for local domain only.
- * @device [in]  : device
- * @iova [in]    : starting address of user pages to be unpinned.
- * @npage [in]   : count of pages to be unpinned.  This count should not
- *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
- */
-void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
+void vfio_container_unpin_pages(struct vfio_container *container,
+				dma_addr_t iova, int npage)
 {
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-
 	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
 		return;
 
-	if (WARN_ON(!vfio_assert_device_open(device)))
-		return;
-
-	/* group->container cannot change while a vfio device is open */
-	container = device->group->container;
-	driver = container->iommu_driver;
-
-	driver->ops->unpin_pages(container->iommu_data, iova, npage);
+	container->iommu_driver->ops->unpin_pages(container->iommu_data, iova,
+						  npage);
 }
-EXPORT_SYMBOL(vfio_unpin_pages);
 
-/*
- * This interface allows the CPUs to perform some sort of virtual DMA on
- * behalf of the device.
- *
- * CPUs read/write from/into a range of IOVAs pointing to user space memory
- * into/from a kernel buffer.
- *
- * As the read/write of user space memory is conducted via the CPUs and is
- * not a real device DMA, it is not necessary to pin the user space memory.
- *
- * @device [in]		: VFIO device
- * @iova [in]		: base IOVA of a user space buffer
- * @data [in]		: pointer to kernel buffer
- * @len [in]		: kernel buffer length
- * @write		: indicate read or write
- * Return error code on failure or 0 on success.
- */
-int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
-		size_t len, bool write)
+int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
+			  void *data, size_t len, bool write)
 {
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-	int ret = 0;
-
-	if (!data || len <= 0 || !vfio_assert_device_open(device))
-		return -EINVAL;
-
-	/* group->container cannot change while a vfio device is open */
-	container = device->group->container;
-	driver = container->iommu_driver;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
 
-	if (likely(driver && driver->ops->dma_rw))
-		ret = driver->ops->dma_rw(container->iommu_data,
-					  iova, data, len, write);
-	else
-		ret = -ENOTTY;
-	return ret;
+	if (unlikely(!driver || !driver->ops->dma_rw))
+		return -ENOTTY;
+	return driver->ops->dma_rw(container->iommu_data, iova, data, len,
+				   write);
 }
-EXPORT_SYMBOL(vfio_dma_rw);
 
 int __init vfio_container_init(void)
 {
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 6e47a3df1a7102..4f82a6fa7c6c7f 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -98,3 +98,61 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
+
+/*
+ * The emulated standard ops mean that vfio_device is going to use the
+ * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using this
+ * ops set should call vfio_register_emulated_iommu_dev().
+ */
+
+static void vfio_emulated_unmap(void *data, unsigned long iova,
+				unsigned long length)
+{
+	struct vfio_device *vdev = data;
+
+	vdev->ops->dma_unmap(vdev, iova, length);
+}
+
+static const struct iommufd_access_ops vfio_user_ops = {
+	.needs_pin_pages = 1,
+	.unmap = vfio_emulated_unmap,
+};
+
+int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
+			       struct iommufd_ctx *ictx, u32 *out_device_id)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	vdev->iommufd_ictx = ictx;
+	iommufd_ctx_get(ictx);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_bind);
+
+void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->iommufd_access) {
+		iommufd_access_destroy(vdev->iommufd_access);
+		vdev->iommufd_access = NULL;
+	}
+	iommufd_ctx_put(vdev->iommufd_ictx);
+	vdev->iommufd_ictx = NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_unbind);
+
+int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
+{
+	struct iommufd_access *user;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	user = iommufd_access_create(vdev->iommufd_ictx, *pt_id, &vfio_user_ops,
+				     vdev);
+	if (IS_ERR(user))
+		return PTR_ERR(user);
+	vdev->iommufd_access = user;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 9766f70a12c519..b1ef842496372a 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -111,8 +111,6 @@ struct vfio_iommu_driver {
 int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 
-bool vfio_assert_device_open(struct vfio_device *device);
-
 struct vfio_container *vfio_container_from_file(struct file *filep);
 int vfio_group_use_container(struct vfio_group *group);
 void vfio_group_unuse_container(struct vfio_group *group);
@@ -121,6 +119,14 @@ int vfio_container_attach_group(struct vfio_container *container,
 void vfio_group_detach_container(struct vfio_group *group);
 void vfio_device_container_register(struct vfio_device *device);
 void vfio_device_container_unregister(struct vfio_device *device);
+int vfio_container_pin_pages(struct vfio_container *container,
+			     struct iommu_group *iommu_group, dma_addr_t iova,
+			     int npage, int prot, struct page **pages);
+void vfio_container_unpin_pages(struct vfio_container *container,
+				dma_addr_t iova, int npage);
+int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
+			  void *data, size_t len, bool write);
+
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a74c34232c034b..fd5e969ab653a5 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -770,7 +770,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 static const struct file_operations vfio_device_fops;
 
 /* true if the vfio_device has open_device() called but not close_device() */
-bool vfio_assert_device_open(struct vfio_device *device)
+static bool vfio_assert_device_open(struct vfio_device *device)
 {
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
@@ -1876,6 +1876,126 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 }
 EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
 
+/*
+ * Pin contiguous user pages and return their associated host pages for local
+ * domain only.
+ * @device [in]  : device
+ * @iova [in]    : starting IOVA of user pages to be pinned.
+ * @npage [in]   : count of pages to be pinned.  This count should not
+ *		   be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ * @prot [in]    : protection flags
+ * @pages[out]   : array of host pages
+ * Return error or number of pages pinned.
+ *
+ * A driver may only call this function if the vfio_device was created
+ * by vfio_register_emulated_iommu_dev() due to vfio_container_pin_pages().
+ */
+int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
+		   int npage, int prot, struct page **pages)
+{
+	/* group->container cannot change while a vfio device is open */
+	if (!pages || !npage || WARN_ON(!vfio_assert_device_open(device)))
+		return -EINVAL;
+	if (device->group->container)
+		return vfio_container_pin_pages(device->group->container,
+						device->group->iommu_group,
+						iova, npage, prot, pages);
+	if (device->iommufd_access) {
+		int ret;
+
+		if (iova > ULONG_MAX)
+			return -EINVAL;
+		/*
+		 * VFIO ignores the sub page offset, npages is from the start of
+		 * a PAGE_SIZE chunk of IOVA. The caller is expected to recover
+		 * the sub page offset by doing:
+		 *     pages[0] + (iova % PAGE_SIZE)
+		 */
+		ret = iommufd_access_pin_pages(
+			device->iommufd_access, ALIGN_DOWN(iova, PAGE_SIZE),
+			npage * PAGE_SIZE, pages,
+			(prot & IOMMU_WRITE) ? IOMMUFD_ACCESS_RW_WRITE : 0);
+		if (ret)
+			return ret;
+		return npage;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vfio_pin_pages);
+
+/*
+ * Unpin contiguous host pages for local domain only.
+ * @device [in]  : device
+ * @iova [in]    : starting address of user pages to be unpinned.
+ * @npage [in]   : count of pages to be unpinned.  This count should not
+ *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ */
+void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
+{
+	if (WARN_ON(!vfio_assert_device_open(device)))
+		return;
+
+	if (device->group->container) {
+		vfio_container_unpin_pages(device->group->container, iova,
+					   npage);
+		return;
+	}
+	if (device->iommufd_access) {
+		if (WARN_ON(iova > ULONG_MAX))
+			return;
+		iommufd_access_unpin_pages(device->iommufd_access,
+					   ALIGN_DOWN(iova, PAGE_SIZE),
+					   npage * PAGE_SIZE);
+		return;
+	}
+}
+EXPORT_SYMBOL(vfio_unpin_pages);
+
+/*
+ * This interface allows the CPUs to perform some sort of virtual DMA on
+ * behalf of the device.
+ *
+ * CPUs read/write from/into a range of IOVAs pointing to user space memory
+ * into/from a kernel buffer.
+ *
+ * As the read/write of user space memory is conducted via the CPUs and is
+ * not a real device DMA, it is not necessary to pin the user space memory.
+ *
+ * @device [in]		: VFIO device
+ * @iova [in]		: base IOVA of a user space buffer
+ * @data [in]		: pointer to kernel buffer
+ * @len [in]		: kernel buffer length
+ * @write		: indicate read or write
+ * Return error code on failure or 0 on success.
+ */
+int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
+		size_t len, bool write)
+{
+	if (!data || len <= 0 || !vfio_assert_device_open(device))
+		return -EINVAL;
+
+	if (device->group->container)
+		return vfio_container_dma_rw(device->group->container, iova,
+					     data, len, write);
+
+	if (device->iommufd_access) {
+		unsigned int flags = 0;
+
+		if (iova > ULONG_MAX)
+			return -EINVAL;
+
+		/* VFIO historically tries to auto-detect a kthread */
+		if (!current->mm)
+			flags |= IOMMUFD_ACCESS_RW_KTHREAD;
+		if (write)
+			flags |= IOMMUFD_ACCESS_RW_WRITE;
+		return iommufd_access_rw(device->iommufd_access, iova, data,
+					 len, flags);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vfio_dma_rw);
+
 /*
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a7fc4d747dc226..d5f84f98c0fa8f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -19,6 +19,7 @@
 struct kvm;
 struct iommufd_ctx;
 struct iommufd_device;
+struct iommufd_access;
 
 /*
  * VFIO devices can be placed in a set, this allows all devices to share this
@@ -56,8 +57,10 @@ struct vfio_device {
 	struct completion comp;
 	struct list_head group_next;
 	struct list_head iommu_entry;
+	struct iommufd_access *iommufd_access;
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
+	struct iommufd_ctx *iommufd_ictx;
 	bool iommufd_attached;
 #endif
 };
@@ -111,6 +114,10 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
 int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
+int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
+			       struct iommufd_ctx *ictx, u32 *out_device_id);
+void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
+int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 #else
 #define vfio_iommufd_physical_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
@@ -119,6 +126,13 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 	((void (*)(struct vfio_device *vdev)) NULL)
 #define vfio_iommufd_physical_attach_ioas \
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
+#define vfio_iommufd_emulated_bind                                      \
+	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
+		  u32 *out_device_id)) NULL)
+#define vfio_iommufd_emulated_unbind \
+	((void (*)(struct vfio_device *vdev)) NULL)
+#define vfio_iommufd_emulated_attach_ioas \
+	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #endif
 
 /**
-- 
2.38.1

