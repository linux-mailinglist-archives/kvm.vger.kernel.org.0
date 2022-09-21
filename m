Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71E95BF24E
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiIUAmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiIUAmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD13481EC
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZnylC4whEDxiAQqhFjzBTrKOkruVlQq7EyoGfalRrOcMGaaWBJ+Gnc9fIem084Yx/hi8LBJ7oIv9PUCKyny8tpjYDRSZJZw45a4E4CfXbRh1vEolMwWq2cxHyoohz4c1g4nD9ld4w14yLwpjknrsmmjHKLelJbgXadFaPmUGuK1Rcr03n/9b0UHygYov3LjlcSfVcylXnosAxU00PM46F/AI1XnmNBxQ+CZo0t1uhjzfkM0RAXgTfYabeik8ZpKRzjBwfXRE7Ccu0oZ4t4ledpeOtXCTXeF8cqsB2dtBWLKL6O2ajM47pkyVsLEuAk+Sv1/GCv4GK+6E9ra0VAAhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A66GCMOQd7p8njM/A6RQuU3zXVodSqEO2bNH9K/4ZQ8=;
 b=UEGZd7OWz5bVDQihj/QIez6MNBqmV/saHYfUYf4vY9OY1JLhPH0BH579SdHdI1vDgKc2CvTKPRhTSAYEKdnlPkbw2wxwcBcsdme/WOmnhbmm3kSSKE8xyW679pnbkig3xAT1lEUaWQg+5mfbeaTleWZC0A3lFH4HlQUoTqjeIUuIXH3Vi89p2E/ziqfiYj24rPnV/+pyXkrInkidXPeWdh8RNH7/BsQcKm9I+Iyz1R+RRuOZ6ayIrYMFV/uxTP4LHpJYeoCgs/Q5gb4qrzuVxg0RSYp9BvFwU4FDWr9+6BMzKtxxId7MK1bq2sCBvp1VfCjIpKOqgePK/1LFz2C1Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A66GCMOQd7p8njM/A6RQuU3zXVodSqEO2bNH9K/4ZQ8=;
 b=fvcNFGuC0Bp67wr7IjYr5NpQc/iCeuDBDWUq+zLHggg+fcI/C29XkhqE/em/8m1jTuaHJMv/M6uWSfjjHgb4lOFxijcXeSu3d5h8jcKUXIhIkcXqdt0YmUvvUCrEChb9cFJcO65cMDE+gg6knB7KY6NXkrh2P3VxmtLJN8Nmxk6fKHnhe3iTtsD8gIUF1S5SMC172NOT5nvCzgwf1cbSniXxWhmwLrMqKGRvowJgz2UnArTCcDIWqtwwmZXLcDKjlwjYjmMigjIabH73Y2gRKRSgnsVurQh+S7ypblugmZvPRCZmOMXkQ9nlmvCx6WhiO9n/2eWQaWbhjiSBmJZuVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by MW3PR12MB4426.namprd12.prod.outlook.com (2603:10b6:303:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 00:42:39 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 5/8] vfio: Split out container code from the init/cleanup functions
Date:   Tue, 20 Sep 2022 21:42:33 -0300
Message-Id: <5-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:208:236::22) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|MW3PR12MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: 25bede3d-0da5-4246-e8be-08da9b6a2e7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJCYzI+C7VdCUzLFio7Ze87lM1BN8nsj7qeXS6bj/D9LSsllO2vjq7cpWT5Sp0Osh4kn+zt81bnKmsvUuF2Y4cypaIJlzB9E4iuVm11yAb8WAPCLIKBKrTd7n5uz4v00PuYy8sc9DM1SZDBFon2APbcBt13z9+DlfFOgn67u4XmMkvf81C+LFs1r3fC/H7GmXVCsm5uV4LdcFDMlPeuvPs+/N/3ux2x122fR0us/N6q4zENU1Azlpx/fyUvRv9h8LmatFeAnJwO6mDVIMTXp062IbunLk6WHBUIH79AytaZSgh2pGYkyJ0JZR0jCik5OjnstCFEtrTlCZRwOnL9nRIKpjPFC4aCyCyP42T2o84zIFjFMOT7GIlBV+WB2nP+xdbWsNXzEWd2dBNs7ix7F+0s+YRe6Vz+Kmqds/HIT+1vDQ08T1iUOOVmkhOyPLJX5aKa37bgyMQ21RHnoTJtO73OfQI2+rD1vHHsmcfTB9UIcGeGFY0EJM1E4Z5NtVHppn5/Ik9emS6ilegisAvlSEBWiJMFidVquhPQWdDaxXLcyQi3IBMGSBR6Xw78MBtVFUi+xrfEbtcP14G8tKuGEuCJYzbK37NsmDa57tn6bK8zRxlhoymFovVofKFAXIe1s7liOfwnkUTL6mksiBeuAEZddF7sAylwEgABfWKEwJcQhLDGjuSIFAMrPcrGHFDGf9k7KBQiUoy+QYm9CvnsK7qHjmM1zDGdT69Tj+gPOP8+hDH7Zj9IbitGP5q10LeVr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199015)(38100700002)(8676002)(6512007)(41300700001)(316002)(83380400001)(110136005)(36756003)(86362001)(478600001)(2906002)(2616005)(26005)(6486002)(6506007)(5660300002)(66556008)(8936002)(66476007)(186003)(4326008)(66946007)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pCKkTocr03BdNWSQHTNe4p9OEs7tgoFhfaJEgysXhGMZ3irVLztsS6o6ZZmc?=
 =?us-ascii?Q?+8yN9qSpWea/X5ejFdljo7QFgnywopr0t0tvqXX9sLyC5tMl/+QzobmTPs8H?=
 =?us-ascii?Q?+EpLGF82fH3GXwRpdiq2mJdEJywihTca+WTdFT5PpkL4xLBo/5SNVrIsnLUo?=
 =?us-ascii?Q?hAbDov03oUj8TBxbqf2yeKhSsVDKNgZ5TGeanGDntThgswWMMalTcafFpOiK?=
 =?us-ascii?Q?PAxfGA0OihDIMt+oUUU9Dt8ORJJimS3zt+W+V9B9VZs8nibieKl1/EJS+7IG?=
 =?us-ascii?Q?E+XqIOHgJnJ+U4+SxAlCyd1s/zPrgSV9EiiobNKV3zZHr52lw4Jhl64+U2PI?=
 =?us-ascii?Q?DQhRb1tm9HgQdb9Dc3KD0lFz+0aQnBAIHefukTM+E0uIXKy0sRNwlK6HprXn?=
 =?us-ascii?Q?yxm20rPMj6chJWO+kXe/v6CYLck30yKuFL/sfVeZvliMLNhxR8gsFvABP3YM?=
 =?us-ascii?Q?uoyygDGutSt5dBvvjUhnMYxX2smraJgJpQNNf7PqzEym8MDag3zIoekdZKwt?=
 =?us-ascii?Q?Hwb6vt7MujU+uXnF6HkK13SeMjLLK0VInqCjJgq8bJz3Uz7vTNYeemU+uWYz?=
 =?us-ascii?Q?HqgDNgf5HCk+vO75vIyPO4I22eTyJh3p/hxDpbrB/IKutfKPgZRyyUtGwUEL?=
 =?us-ascii?Q?beaG9f9y6q4ASMh7WInRS1a5z2xqeS7CMNkOr9CAM8BuT7Wu5cUYrtaHrJb1?=
 =?us-ascii?Q?10YZqL4Y/R09mpc7Dp9bfQRlo74vxGhSsO7jfelWeE4yQR2SL8abe9E6lDLD?=
 =?us-ascii?Q?tG72QtML5zfiYOJ8VQf7c3opeBLJ6rgfp7rYpxOhjD5bzjCd7ykSV/UQ0trA?=
 =?us-ascii?Q?A6Pew4DIlZyTY2XcnBLF7eZXyhpAdbaiRCg8BEWpj2tuhVkLb3rXeYdgt2Iw?=
 =?us-ascii?Q?iKMEpnNFa1ePkUwyla2S0joCVE7OF4HDILFKckW+A1RZblabBjQM/Rrp5BAf?=
 =?us-ascii?Q?W6kwrUs1DzKQKebLhKN6rWiH80YUhPrZh/M91RI3FsK/5R+B1SInjd8eGvWc?=
 =?us-ascii?Q?LwXhph0jFG0yJ3fBDJaHJ2gCCrzh9r78oMDzWci6qWeRk4aIPnUKcpwtZxtG?=
 =?us-ascii?Q?Qzu4oeXhIXDWq916lS1fK+nFCuy+mdfB1qVmV40r+CgxDsOfPPIfoaFDhGzF?=
 =?us-ascii?Q?WMsescBk3zPAkK1Ya4LXHvM6nkiEO4X5lsWB+1cwnMsS4hbRG+m9q9CoxOan?=
 =?us-ascii?Q?AWOHuOK1txzVMLAGSIrYNmXVnIPOLLp8OHIRd28Px2Heu5VNS9KkPC/tu2JH?=
 =?us-ascii?Q?ZOGAPqQBACfPZDDU0+L+krK3SEtxTWeleqvOfqpE/BAjoJst9WiFpdj5oQuD?=
 =?us-ascii?Q?vQpbrUYK2/HS+zumY3km28zBjCzds+aVcSSFRyL9CZauMCNe4WrHecbzX/1F?=
 =?us-ascii?Q?/WuvGyyrrMANu8tVjL4FwosXA/J+mSNtbuZFWKbVIEC2ttqwVn4flXKJqTjw?=
 =?us-ascii?Q?tnpmMaaHbP3qlEkSDQCUriDzL4zsXORKqEMK0urA/aoF4A1sq7WH43xfp+Ba?=
 =?us-ascii?Q?Gr11RLQJLZ60Daeqt2nyKCijyh4GhHHdaO6FfTFXkr8CSrET54ioDwD3pShQ?=
 =?us-ascii?Q?AcCDtpVAhFtAqUNeaHDQ8MOK1Z7iR5UexglvMSLd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25bede3d-0da5-4246-e8be-08da9b6a2e7b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:37.5995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iitJ+uDWaWejS4gXJF6hM8GomR4BNlAihNC0jl/3qW4MW8ZQswVTZGEV7ypJxB9z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4426
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This miscdev, noiommu driver and a couple of globals are all container
items. Move this init into its own functions.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 52 +++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a7e3b24d1e01b0..33ed1a14be04e3 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2114,14 +2114,11 @@ static struct miscdevice vfio_dev = {
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
@@ -2130,6 +2127,38 @@ static int __init vfio_init(void)
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
@@ -2143,22 +2172,14 @@ static int __init vfio_init(void)
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
 
@@ -2166,14 +2187,11 @@ static void __exit vfio_cleanup(void)
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
2.37.3

