Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E555E6BA8
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiIVTUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiIVTUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:39 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665CAAA3D0
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqG4jo3GRcfM4M59Y8Y//2/u2QkBptlxLdlqfkLyYGCZepx2zQvsOqTTtoz/EQoId3ehmKt1TzjTllv3WAo+vi2couwBrLnR6naaXIZGNzq7C8gqX7Kh2uFyXhIDhkGxtPXQUEJkWIyjZLMqSpK/wYuQuk1CHb9lRanPWJQRuL51kfPqHIPc6yknHzjmM6juohICxT7eTGU8p/ppZ4+9LnV3jQbZU5Ico7U8mHpFKExd4uQx5SdS9Ma4yyM09k66y+GZdkCVD+FKAshneuOFNZq8Xp4Am0Zw31keGMI1mFbWNcYuieCColI4qBukjqEN3BQaperRA8tqHERMq8PxPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOzmXi7NAIxDH9Sjq71fIdye0opjwesp6Y6YATTwopw=;
 b=ZN1s3+xN/LArmbaNKKblNpMcccsTqFuLwCTj6Ou+qpvH9KfvKeRcKrimZmmNEgZt1vymM8/ju05t1W43xtkJ2i4zA9iWw9/JgCtDrpQ49Htk7Gf672wnPWqToXnVaNcDjvTj4S1yAANVXaRG8kzucniImyt43g4oAEZb/6wa0d7YM+os9mvMfZ6uvaEZq7AF2CjKXnYj4y7GH3XwYyVqlobhd738seJvRflZxlLq2DECx0MqlOVg3ekmR6vEyqyt+r13d/ztiTpJhSJudp3SzcYGApAyQ8+vP2ziH09f686O+4u9EY4MKVT/msdsdQAQcbYIYH0BjRvIpWecZrkHGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOzmXi7NAIxDH9Sjq71fIdye0opjwesp6Y6YATTwopw=;
 b=bsCj/VB96R9u3t2HbCkIJ4TaX0bwXsu0kWb6WAUnUcGkj0O4nx9xzrX1J4eQDel/9JIYiU4C3C8cybTx37cp+2l5NkKIoabdmhbHISBC2q2lfgyKkn/uNbSkiHhHwJMWSYSM2/g3AIVMUQZ87Cyw/D01jpSRcrZ/sny6+VLxC342Nye35sn2XsW3XNsZpqkieun/dAFaSNyQHmC1fYPaMLAUHpGmxuiPfERYhfzl7ejhrum2Oc6PH0UwJTvUrp4KrQDjvA0fJgUxU/Foakhgx8Z/W/MpIYwxqwa1ZluJ5gHmwZ4Nq2HUI3zt3tSg9oGNS9MzoH3PZODD4iWn01Irfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5486.namprd12.prod.outlook.com (2603:10b6:a03:3bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:31 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Date:   Thu, 22 Sep 2022 16:20:22 -0300
Message-Id: <4-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:208:23d::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: abe2da3a-4cc2-46ba-465b-08da9ccf81bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmcDSDPqOFncBxRzy5fLRMzJ8qFuLaktqnP2xCtsJXW4Qwx0LnBo9WK5pCMvtjf9uEeaRM2uiwao1Zvzxe8om+JsowO+KqkewsoM63RXd4xmw2J5q7dGOT7Suuw8Ww22L09AeFxllD8zN3DSOdUcwPfF+4tmSjKDciwbyzI/3xoU+JBm+mBLn3kB92G3t/fwY16mZ3fzKn7oY4uTbxS+Samnn/oyd3JzqnLxS7WyYt7xOB4Ng5bqoO2s2n73lrMWKqHqIywPTwly7sGMZ3bcjxn0x4FEqRNeL/0utsoJd1tW9uEQodu3pE2MaF+ttO5glbWesGhlnp3BEpIYdClVaYZ3InULhlICIxL6cmbg8g0pMJ84Ob6aOrjPN85qwZ6mvax3Nzx8keOOi1RAXp4yR0uvbibdDP/HG7a2X1KWlM/Gex5XZoNXPRRc0yXG5QLeb4sQkc7qAb9o58zNvTfWySvzUSQ82UueHnd29Mn//ftQPPy6ieuaXwu5JLzoMLQC80/PFZUgWrAhZcdW8Zq8eWluKzT9n/thnjAZNG0vbh9Ddiup2xA1o52P9DtdO9aJhOm4CIm8VDExs7xhsecY3A0F98/j5RKs4T40ei+k1YoTnOM5zNIZw0fDWCIghBpQHe1HRFPFJq+JQCCS/ELp1vCBdm6rr5ALQNHzrnFUBclh+o2MZ7PItSlrafnSM13vFIRpkoD5I952sl7dXiag792NRPUwKBH8d8r7b0m8nWsO+JW+xgGfMLSoeC5JleF3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(2616005)(36756003)(83380400001)(41300700001)(6506007)(6666004)(2906002)(8936002)(5660300002)(26005)(38100700002)(6512007)(186003)(316002)(86362001)(110136005)(6486002)(66556008)(478600001)(66476007)(66946007)(4326008)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wlDnqHw7IXYkktu0d3Xg4LaLdCMGwWS08RuIk5IUf77gJUicbKct54ZzVI0s?=
 =?us-ascii?Q?LYglxqMzTV519n9or1m47K6ZnSIRWMt5mSCLpAqNINDO4hTPVWE0ryc13cOu?=
 =?us-ascii?Q?yQmXzC+g525F7WxJBci0JZaBgqCxTuO0VDlGhTgqqn9EcrgYr4aA/c5qcaW6?=
 =?us-ascii?Q?J6OjfyxdBAVpEKgOct9brmmS2QbRt5JAqtMBU7wa5BbtWKAIqw78TbU6c6ok?=
 =?us-ascii?Q?ITPprWzWr+6qsKfcgsXdZcliyCxYxx9WuYoVtUVC8fXuh0Hz+vFHgD6asZfS?=
 =?us-ascii?Q?m1Q1nkZBHG8yqQXycEpbUfw3gX4Q3g4qTjeJQ/WtHRRWsNbpsuXT54etVbIn?=
 =?us-ascii?Q?gy8JRcPuVCQYL/27FVLjhnkA4eJXdSyH300FD09wtzkJeWcUnN/uez/qVr0b?=
 =?us-ascii?Q?xzIdyPPjETr+HpfYOBTNU31ejtJGxNAkP/W6rwSh9xXaGd049Ge2Et3yMEhL?=
 =?us-ascii?Q?YKrR7WLPgfj4ZPghF3ZgSFjJz3ajPNQM6GTL8UF3X01pen9y3VVf41Wv4C4T?=
 =?us-ascii?Q?u4lV9c+7Cj61rbGhPWE8UZZZeSHdQ8PCdg5xouUPr6qJeJX6ZuDbmABDXORW?=
 =?us-ascii?Q?DTEeVB7Opt3YI8RxoPp6S73b7Rzz3fxTBS/YdMYzGI3VSBSnZAN3dFSlLB/A?=
 =?us-ascii?Q?XNnQg8uy/i9L02oLVNhnZuMw/xFCnfOjvIE8pjkDVl+/7bBDc6Q2DV0J8QBI?=
 =?us-ascii?Q?eCjq+IByEECt/Ag2wBo+Dn6gA7Z0w+ui4Gx4BW88jDGoCu9JV+VSKpbZB8oJ?=
 =?us-ascii?Q?pDqyDpv+RqZGmmdRcQzofakWGmUpnarkXLLtNb0pc4V49TOGKzWkg6FwfRy2?=
 =?us-ascii?Q?oJk9R50X8ouejQbKJI7h3V9+o5Hl6OUVBU+Hf/Cfc/wbj3ndmIFhJts1FD0O?=
 =?us-ascii?Q?a41TFa+H8zFUZDQpIRq0e+//KAFbdAFN1Gsc2YMSu2MvAq1YPPp4vRGYLfsh?=
 =?us-ascii?Q?yUMohB4XtCrsGKH9P5DVp/cr68a5AZ3u9NQJFZ0mMH0R9DLLkzOfCgolbxuz?=
 =?us-ascii?Q?9lCscRus1vzIfmLVV7ReT9LWIdkufa6IY2YITXVX1z+jpi9jPBdPt1gn6b0I?=
 =?us-ascii?Q?s+1ioES/GMvrpwQ1SJHiRjVgI1wCgrlM9tQqTasPNMlPKqKTk7MRHEMysxm3?=
 =?us-ascii?Q?PXhNBed+FBxvwp0WSbJACTcq/RPruk/U8hZhgfw5h2mDk5w5I06A3zH5by7Y?=
 =?us-ascii?Q?QPryui3jC6QZoAE+XaDpJeye/5WLmftTk3c1y/N94KwuKQOUx4jmJzc0VVcQ?=
 =?us-ascii?Q?qRLZKy5Ynv6Nef8F/si6NLFanURv8WdGCkWA0xxoqw2unaJ/83ZrxSOj8jU3?=
 =?us-ascii?Q?V/7qVyeK9km3DynevlwJkOlFSw5/pAi0MPAJymUOBr/nltHx14qeIqFDvwDa?=
 =?us-ascii?Q?xM9mgn4exOPIpMP4nm4fOlC2B00cz1yZ8QcmoeXA657MpyX9AsBEhev+TY66?=
 =?us-ascii?Q?jGGbq/S1zsFQyrWzesQazQVASAgp8oy2mHOnKZuOaDHXIn/Cq0cZU9btaIS6?=
 =?us-ascii?Q?z6orXolMniZQ4okyAbKGfjY8qS9VN+974pJDLglWEXCei3VzNuIdhNHT1SAq?=
 =?us-ascii?Q?vGo5wb+CWl/5Cc8USn9jWzVI0XV6NsIbQZ/v2Ck4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe2da3a-4cc2-46ba-465b-08da9ccf81bf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:27.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNsZEl0V9sEWp5DnWoOOOF0hVxpjMP/Z7xc5p/GQCUUgGsl4wzkaYfjNeqEbD/lJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5486
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can all be accomplished using typical IS_ENABLED techniques, drop it
all.

Also rename the variable to vfio_noiommu so this can be made global in
following patches.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 43 ++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 879c5d27c71276..f79e7eb02931b0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -86,10 +86,12 @@ struct vfio_group {
 };
 
 #ifdef CONFIG_VFIO_NOIOMMU
-static bool noiommu __read_mostly;
+static bool vfio_noiommu __read_mostly;
 module_param_named(enable_unsafe_noiommu_mode,
-		   noiommu, bool, S_IRUGO | S_IWUSR);
+		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
+#else
+enum { vfio_noiommu = false };
 #endif
 
 static DEFINE_XARRAY(vfio_device_set_xa);
@@ -166,7 +168,6 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-#ifdef CONFIG_VFIO_NOIOMMU
 static void *vfio_noiommu_open(unsigned long arg)
 {
 	if (arg != VFIO_NOIOMMU_IOMMU)
@@ -185,7 +186,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 			       unsigned int cmd, unsigned long arg)
 {
 	if (cmd == VFIO_CHECK_EXTENSION)
-		return noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
+		return vfio_noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
 
 	return -ENOTTY;
 }
@@ -215,18 +216,13 @@ static const struct vfio_iommu_driver_ops vfio_noiommu_ops = {
  * Only noiommu containers can use vfio-noiommu and noiommu containers can only
  * use vfio-noiommu.
  */
-static inline bool vfio_iommu_driver_allowed(struct vfio_container *container,
-		const struct vfio_iommu_driver *driver)
+static bool vfio_iommu_driver_allowed(struct vfio_container *container,
+				      const struct vfio_iommu_driver *driver)
 {
+	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		return true;
 	return container->noiommu == (driver->ops == &vfio_noiommu_ops);
 }
-#else
-static inline bool vfio_iommu_driver_allowed(struct vfio_container *container,
-		const struct vfio_iommu_driver *driver)
-{
-	return true;
-}
-#endif /* CONFIG_VFIO_NOIOMMU */
 
 /*
  * IOMMU driver registration
@@ -630,8 +626,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	struct vfio_group *group;
 
 	iommu_group = iommu_group_get(dev);
-#ifdef CONFIG_VFIO_NOIOMMU
-	if (!iommu_group && noiommu) {
+	if (!iommu_group && vfio_noiommu) {
 		/*
 		 * With noiommu enabled, create an IOMMU group for devices that
 		 * don't already have one, implying no IOMMU hardware/driver
@@ -645,7 +640,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		}
 		return group;
 	}
-#endif
+
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
 
@@ -2439,11 +2434,11 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_chrdev;
 
-#ifdef CONFIG_VFIO_NOIOMMU
-	ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
-#endif
-	if (ret)
-		goto err_driver_register;
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
+		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
+		if (ret)
+			goto err_driver_register;
+	}
 
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
@@ -2465,9 +2460,9 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
-#ifdef CONFIG_VFIO_NOIOMMU
-	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
-#endif
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
+
 	ida_destroy(&vfio.device_ida);
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
-- 
2.37.3

