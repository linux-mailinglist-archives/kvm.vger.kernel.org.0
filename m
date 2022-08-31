Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7611E5A7319
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiHaBCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiHaBCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:08 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA616EF23
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekWqHGNibsi8HSwS8V9BF7xjnOc6zZ9bU3JFNoZMvClamk1uEayFhfHYQgmlvrff3dZT5YIhHH0E2HUhDCf0VY3vYhpkSi6+10UuQlLXMhpayUQ3P89x/b90pedzrt1uLiQYo5FgXWjAwKxvilcViIW7kJjEF2wPzII+ul5v2es/bfER/0fVDbtc+TCrKHVFbWKgcBGORm3u4+hZIHFzHZ7HpHaK8qEI5Pdx0VZ61o6DLsMaS99BVpj26ti0S5SGJeh1DgVnahMeGRetEmT903JqNGpk6gH7PHF4TXwBXq/qm3z9yGGBklAfe/LKCTOokGbthMKu9yR6nGf3LMbuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+YHUEmzk73MBbvqVTb4kPU0FeBwfM9Cs8DrJzXvsVM=;
 b=dVjwXfeRFmPX0T3WwxWvGkjQqD2QjZ4uvJoTJJsfwVHmF+37cpWqpZml5yNAw7TYnIeCCVy4fTWBqUznEKfTIECStruLXfuPVNkLdcx0Uu2fCwUzUPU1F2TW4IA6f9td0ywDT4pjjYlbEL/MO94xUtm9cgXLTrWUiIyiE2pWqk8CoZSN0lDSpt9OTZ3J6EgnjIyKqeRZkY/M7KgHkVf5qNHMg87vaZ4hC0+cGqJw6BOCgWk33y1wlG4fv3VrCgvOPd6Dz9uNHuqFzFYyxF0fCkvbmEohngguGnqfjZTM5Tu+80VqBD23sU9QlZia8UriZZmFRkGM/OSntbycx3siMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+YHUEmzk73MBbvqVTb4kPU0FeBwfM9Cs8DrJzXvsVM=;
 b=OchnpFT2HuLSXa9PvrTfP1RQyJ2yoMOf1mTzAyqses8hqU1pMMjeq7U8xWadltt2AGBySiBlQHXk5FQYMHTUkAJZUNRcSPPhRvDETZ7GjThPa3eSF7WkTAo5VLim4eaThNUNO8oaZKKG7kMbPdRaR7Pj5NNsV0QJJOdaosVtFDeWxhF0AAoyzY6l/cJpg5ftlC3adNgi2L2vFti0XJsYdr5ISeVkPyaytMl1mz4LEqlGVxC8Bcl4SJ4txhLjgYWHDDhSVHi4Hy+Etw4sjsCpxs3L8QrwnCapSCNaKHTQvgH8GIeqIFc5oF8MfgjX35BElvnT27ki1NunofdvHydQyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:04 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:03 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 5/8] vfio: Split out container code from the init/cleanup functions
Date:   Tue, 30 Aug 2022 22:01:59 -0300
Message-Id: <5-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 979be2bb-6f7e-46d7-fd44-08da8aec6aa7
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BtnzZwQCRzxJo8VQFM7detwz6XgqK2IvkjuSw7iJ8usFNQ1Cd+zAaP82VcW1Hp92vQNGZcxOgFX+GgDWEii5GChxGF733GfBtTlPOH71VtaDLHYzGsq7rKXVg3+AJxNvGX4UKUOLEfNXpAYrudbP4Dh07EKFdwjM9fwBpHnCGb29qzB5AN/u+1AzRWfg3L2uDvpl9aaQKJV17VV/PE8CWHzm/O6hsG0lSQG9zSwOb85awONitpHZz7BeltaT26bQxwRyIdd7gUzDxsgNdE0XH0epIMO5sM1aevWgpF5z53aXyV4x2vy/Vki7IK8GRSFfRO4oHDiVN5xvtCvINB+sZ20/4v9NIbqlotlLyq5JBiC8vcv2Y9ZtK0U48QIHIqNpdbvqztS1+OlHJXWuTKKrJhZBLSw6I3tQix9reeulcn02MNQw6HGYbeV2LPoEoy8R6/NFHGWs06zqIu/TdNnCRCYEyIBVYCJZ/cGpCYFPUvY+74xq4ePjIMfR9ENryVlJs5FK+T3ElqjOz95xJhFEtc32xbgFh64pWuAhPVv+0/5crqwFOh/aZqZJHr7r4in3xxH/5A9Jw3AicpLaACuFXc3Wy2Rh3McVistUWxEK32CIe1LzYFzZ1rsLVSyOUj9e+psodfyKcY0JZsYl6kITZ/YBMnkJEmZxA0a8V3mf7yhJYgHhxAAR2LveEpw965U5Xfs4YJd8+StwnqqqnTyqujHORJw+ciqP+ihl+scxfxKIi2DYxByj1FqfLMTTTTT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(6666004)(38100700002)(83380400001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dqOCFjXfpyOxWnz5ED4fdkDIrEjdaokeET2dNXTfdq5GdEDU39w1dCLrTdYS?=
 =?us-ascii?Q?sy47ACzquyjfm74ZEnqpOPDMQQnY/JJcrYtay4ThsNv2BRfQTNoiicJyE9V6?=
 =?us-ascii?Q?0fFNLcNQ4pi+ovgBrwOATXOhpZtISTed/jAGhcU9ZqVGFstQBCafvJIR/S6l?=
 =?us-ascii?Q?rm1GL67nX/iNeYNATJOIpym7U/SG78jVS4drKVULtNBikZStfpjbn4yAMiqT?=
 =?us-ascii?Q?2vwUJMDJlY34ZlZfTmOwECCb8KXip7e548GakUVf4ThvX4szk2YoeZ1GHFyY?=
 =?us-ascii?Q?NdDy1+Yas56MoEZWCPlrX0WLFsqEF1b0YNfzzaVXkjyv4nfUJt5i3WnwwiS7?=
 =?us-ascii?Q?PGP9FtN6GgOcFhlq13eZYAcUmjsJ+hE6VbOfbcrqeVTksUWXoCJQip0bBT+k?=
 =?us-ascii?Q?IF2FT2rO02hZJ+d3J8chs7IQYdRkPC9RLWpHV5V27JpU39AQpShHh3s+52n1?=
 =?us-ascii?Q?AdbeC2NmTlmakaYbazGOnxMxAI8qdcwe2skgXke73QCqFgPeHTT0+H5gXn7+?=
 =?us-ascii?Q?uxIV/ILIC2Mjtkq7DrVOEBRi4EBVi1oCw+BZO6297wet6R+vyKYHTG3wSzKd?=
 =?us-ascii?Q?Gn40Zti48sMU32niWLRLU0uKLUfxBVqA+jB6jRBuR3GL5jKSOU97BFqsi/X6?=
 =?us-ascii?Q?Uzix3ZT55pVjdIlyY6gejb4ASPNWr7pKEGDKs6Ghnup6HGfYwWxqvKP04P30?=
 =?us-ascii?Q?Oki4DLJNTUJWmV5/Cmx7gvt9wjIbBIvGqIWNIYGMsQNRB85p36w2Yj15vCWV?=
 =?us-ascii?Q?qg3cBBGtZ8sv8BdX+BHkC4QJg28yM8yCAQY5keNLQJhTL0usjfDcmSjck5/h?=
 =?us-ascii?Q?p3n8RY3eNFdZt4J2VJkUJQV3RELuamNeCec6yzI7i1xhhVqBWr3rPapT2Tna?=
 =?us-ascii?Q?B3kOYf8/ldrkGWot3Sg3QzjxvZy5HqaE+YXCbO5dlNXQcF/D3DWq0Pu78ax0?=
 =?us-ascii?Q?rkHAkebJzjgIrAvUXUWHM2a3PeVXKdNQx8Uq9LWKruzYk3aUXO6RgPud7lgV?=
 =?us-ascii?Q?DoAVF+eBxF1gtt3xAcJb0T+YGX08zB2QwL+J5H0Mz6JHDGlUyr86m8qWX8iG?=
 =?us-ascii?Q?cySS0+dEgOJhsO4Yvxs6XQzk4drJPOAhK+XB+pv2KCeItnpdrpPqPwQ1iYK4?=
 =?us-ascii?Q?aywCw9t5e+vwnDNznMMSNF5c8NeO6qMy8W8Ba6KxnRU7vwyDHi3T1JoMD0Ev?=
 =?us-ascii?Q?eQwHnNkb/yH8XwXOEA9Vaz2QkU6yJyn9I76Jl+Y3W9taWUIldQhQhOJcI7N7?=
 =?us-ascii?Q?MPY5k2lwZTb5xHXkP17P4S98v0wM1ZT/AwUaJQntrfWhkODfWLTcNZgXHNUG?=
 =?us-ascii?Q?VkkIrz0/GWj2SIP77ItdYCBA8c2ODa53ZIw5/6IaoVLBbymS5xcs5DV19vE9?=
 =?us-ascii?Q?N6vsC9SIblnOeqAPHZJw2aHqLSHLfUzw62XA+CIAgGk+8yBeb5TyoPAKd2Ot?=
 =?us-ascii?Q?zYInSNLvcM5SRIWG2hwrNnKG9cLsgOluzts2poBMbI7xtlGGr375i9jYzV8c?=
 =?us-ascii?Q?Do+/Zv8wviRRGyH/UAwYIShgtZEbF4AOlqTbU1OMC/dD8myb6QVcugSABaCC?=
 =?us-ascii?Q?2jcwuik3QYn/28iZFm7vQw4ZPcSPlpj2PYEMjdOk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979be2bb-6f7e-46d7-fd44-08da8aec6aa7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:03.4230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwJFKQLw9m/EjW5n17xU3s1GS+KCijgw/BwCXjtk2/MHYQC+hvZuqfKAwdTxiVSX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This miscdev, noiommu driver and a coule of globals are all container
items. Move this init into its own functions.

A following patch will move the vfio_container functions to their own .c
file.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 52 +++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f76cea312028a6..bfe13b5c12fed7 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2067,14 +2067,11 @@ static struct miscdevice vfio_dev = {
 	.mode = S_IRUGO | S_IWUGO,
 };
 
-static int __init vfio_init(void)
+static int __init vfio_container_init(void)
 {
 	int ret;
 
-	ida_init(&vfio.group_ida);
-	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
-	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
 
 	ret = misc_register(&vfio_dev);
@@ -2083,6 +2080,38 @@ static int __init vfio_init(void)
 		return ret;
 	}
 
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
+		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
+		if (ret)
+			goto err_misc;
+	}
+	return 0;
+
+err_misc:
+	misc_deregister(&vfio_dev);
+	return ret;
+}
+
+static void vfio_container_cleanup(void)
+{
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
+	misc_deregister(&vfio_dev);
+	mutex_destroy(&vfio.iommu_drivers_lock);
+}
+
+static int __init vfio_init(void)
+{
+	int ret;
+
+	ida_init(&vfio.group_ida);
+	mutex_init(&vfio.group_lock);
+	INIT_LIST_HEAD(&vfio.group_list);
+
+	ret = vfio_container_init();
+	if (ret)
+		return ret;
+
 	/* /dev/vfio/$GROUP */
 	vfio.class = class_create(THIS_MODULE, "vfio");
 	if (IS_ERR(vfio.class)) {
@@ -2096,22 +2125,14 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_chrdev;
 
-	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
-		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
-		if (ret)
-			goto err_driver_register;
-	}
-
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
 
-err_driver_register:
-	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 err_alloc_chrdev:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
 err_class:
-	misc_deregister(&vfio_dev);
+	vfio_container_cleanup();
 	return ret;
 }
 
@@ -2119,14 +2140,11 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
-	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
-		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
-
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 	class_destroy(vfio.class);
+	vfio_container_cleanup();
 	vfio.class = NULL;
-	misc_deregister(&vfio_dev);
 	xa_destroy(&vfio_device_set_xa);
 }
 
-- 
2.37.2

