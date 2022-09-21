Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7EC5BF251
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiIUAmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiIUAmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:46 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926D64BD32
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDZpkn92GRCWas3/OaGF7xB98cIfPWb3FKVw4uzVE49+gay4gEc8Szlt8h8Xa+STKg2M4IBEhJMyEVtiXQYvF1MFHkfrY2cr9HY6ln9RILUJaFqlLuFPKq303qxvCBf/NYpKE6l8y1GLSGRk1ZZf0c0Om+uBhiNiD7a7hrM2PVwdr4kutFO+fIYLaHzF1u0RBmrgFOUU9j7Ko+dRyjabyc6dHxzpvBxRDH7RKMaKKFE7ZGC74zVcdpWCbKGoq/XYh7m/u5uOcFZtTcb8L9kibCmHToRVQuBKfl6RDgkXgiEytXQTKxe09dZjLcVafdqs67imIkfkMGfoohmg7Fglsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvE7DPKIflJZSajm+Jrvuf1+yZ4UrTRFwXB2RHD+s8g=;
 b=DzfsVvuFs4xIo/4WQqedp8f+Se6UfGHaSxpfkRS1W2gLvzlEqzlCnIgIP0KqhzERigSemuNjLgxYonOS61UHS/2G16vBchCNkVLLU48FR2vFQqJF0agLxK6o4kFlTuFrxcoraa7ZRJ8eLfgeUb+RNKjG4eHpDi9xbnWpsleG9Wz0Q1orxFJgidVL05uU7w3vJCPSQP7pXBeTGFptR6ttJDeiy4mbaD3b/s4ubmCn/hCjcuAnHCZWH9QwKF1PVSbVLCGfhpCd58SMTjtLPaSVJbv0HJdyoJflkWb+6+FXzHNfEGjGFARWZKuB98xI9rHA9P2hECcs6Bn4sQIX9aGJwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvE7DPKIflJZSajm+Jrvuf1+yZ4UrTRFwXB2RHD+s8g=;
 b=t5ADpMIbbFfFNOVGAlt4ftbieCKQWj6ph+fbCs9adS8PUH1xPpA8Dn48gi+t5Sp0KsT/FkVTz6wUKolapi87xNUj2TIjjqhoGcZnqXvFza2vtx1XPtFem4luRnpo65wRJe52aIYZIAISEh2+OsI1WFK/7aiO2KH0trL2OSp/UIYl+WvCPjKD1GY3tyjdGN22ApIqGRzNxJDweiJPOie9I/0pxEDO/QRgvMwb0HeAxxCkrGbdXIgyjBQ6zNq3jGRCak3u+a1S3+VjMXhmK547Sn0SY5qsw/xYkQfIB3Lqj2A6lqo2lrusYQ9+SYHJ7zYByaeec/eOPsexFTBeU5GiEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by CH0PR12MB5313.namprd12.prod.outlook.com (2603:10b6:610:d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 00:42:40 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Date:   Tue, 20 Sep 2022 21:42:32 -0300
Message-Id: <4-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:236::16) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|CH0PR12MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b13375-1cb2-48cd-7851-08da9b6a2f14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7CZN8x2vMNm+vZrPYC4R/hKpFpMWpTxDJYKWxGPMdtagw9RA+tAa1S7iWnfTOCkkMP7pR3tGQUCb8bTgGht3OQcIL25gAg+oge2MmbuQU0oXKJDzAtA005nvVWdGC8GlTdR2FYWuPaEsy0fSAe57e9GqgvfpP+LwtYUWNV5yOHRo6ldpq8p/Bn+Na2o93RcAYoOSzKCuZhVFu9+lg6XmpzlMty2gxUllqC2xZABRoKKTQcXQPO0BwtdK2Fy6SrH6SIdX/aYsjGWmDf4kQXZkeUvMOWI0CRvS2pFS6vl17LcpbCQoYugg4At2a9fywFJ7QxDI+8mgNl0sX/vy8bZ0A1RuncHPi7xV1XaxDPeeXva4gpK5r8UasydfQHggEE8Ssvzf6puYuqHKk2qgNi8LQFs4BFL0i0+VIhgH/FMm01SVtnklaIs5x8+Yi+Toaf4ciFBOqlBFdMAYQO/pf2hoAM6azpkJ5G/jS/9RggUNZVpB0RrBojmNxTnL6TFtnE4SxrNBHg/dMf+Z0Y/LOQN3SE8S9yn23CESREVjg2FPoEfv53xZpzZhJBLoG7twAxuZm7jMKMQTe9A11cqINuLmpG0kYbVCCu/tIAHb/C2naDJw3Zdhf2nf9/pWHAO9DfAns/sL9LVci+27VeIr9m/eBcndoqb2SKG3dLU4XVR2fCac4P0HpOdEYPGWUKnyyUQDc413GOc+8Fy86Sl3rQOkqN6JkJS6hJHL+mNKzrmisOPytFwb3VBL7pRQ7oNZY46M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199015)(6666004)(478600001)(6486002)(41300700001)(8936002)(86362001)(5660300002)(316002)(8676002)(110136005)(66556008)(66476007)(4326008)(66946007)(38100700002)(2616005)(186003)(6506007)(6512007)(26005)(83380400001)(36756003)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tsmlkMIckULt8bn//kPKmxPQRdepw1JP9I8mquH2NImBH/j7jmotMemDF6Wd?=
 =?us-ascii?Q?uf9o2c54GQ9VWLXEuRWXscjDXb+O2hSC+lMHwh7GR2cW1ArvVzw5pJdBq2/8?=
 =?us-ascii?Q?Xi02m4Ssc4oxw8NTRRPA29bPrHVhKXKxXv8bM2RPIYLk2/tM68SNN5GL/lFn?=
 =?us-ascii?Q?wh10S+xF3M37w1Z2qj5Y/neoFJWkMctomVzq+ifyQqddJO9z3LvOpWDiRO8U?=
 =?us-ascii?Q?lgwY4ToThkID4yqlQoyyNJ/bqnbrhAskQ8lixio6UKjeIVMu/tGCaEfPHHcv?=
 =?us-ascii?Q?FXRaLOsUw0pMI0Cfs1kKnhskxnKePeWrbyOyCE+G3KB9ePyG2cUOmuv7UnzU?=
 =?us-ascii?Q?2dCtkWGplPqu7oJkdPFQwjhdIZI4H4tv6Exxa7ZtbXHB+zosI+5w5JtIFz3t?=
 =?us-ascii?Q?jZBc42ctZqgZMF8qkzZ3EhHOaZ1TowyvrNGOghtKxEC8/YqMkiLgC3PMBEmN?=
 =?us-ascii?Q?vOWBfl7qzS3ydlH4XxttS3xICWsjtfW1fcDgs5jMKoDFc6iJKewGqX/G5gzs?=
 =?us-ascii?Q?XZB/ePFzf6LyHifIZZjRSsg08Pu3i2VYCQ5KmdW/OMC2f6GbOCj6UnmTeC/A?=
 =?us-ascii?Q?lFrEk1Ra2XTej9RGJY0rb6PsUkspIHTPLdVk1dBjWCK3QJwF+Eb3GDGIw1mQ?=
 =?us-ascii?Q?It3OVJdhR7aGkURPK69jn0lyGLHixFArgM67xcj5ImcDDEPcVRmy8Nb4uIh3?=
 =?us-ascii?Q?iK08xYguOZXpOEkUh2V/z2y9cBelMfHDZNiC37RXRzswh1G7NNSVCoJYZFlz?=
 =?us-ascii?Q?yFINacPw+vtkiDoZpGMkmTDeOha71slPI0iFqI/K9T8obqM6BMaE43GOV5I+?=
 =?us-ascii?Q?sia4RNBrfYfTc2QRrdHnFNWhbuyhxpVvKRI1ffLpOsZL70pqfxIDMLjUkEqJ?=
 =?us-ascii?Q?JGQLtOQg6CnlluNObVvDgnJegjK3zgObFJWJFOlVj+whWy+6T6F8ZDQkZJ8R?=
 =?us-ascii?Q?1I+KcVj1OEZEf39xLQknRGcVRUQEvY+lTs3wL7Bs2vsKgcdsXvgSMBOfIsLF?=
 =?us-ascii?Q?3EhKihWThGTrVum5MwliSzvrM2Op/aZgXyvqxVDKFYIO47p7N3wRW7ExN2TU?=
 =?us-ascii?Q?lizXzqUx7L13Zi/sey95VugMljtsQxy9o6P1LHwJhgTktePohbaWRogWN/5M?=
 =?us-ascii?Q?iL31L6aHQygmaihhYEhIzZyP+NpBfbyM0Lt31JNCqo5tmZhb0wDc+OtEB2kL?=
 =?us-ascii?Q?Xjjkvm8dPsNDeCYiRaDnftmY8Vya+rMpnF2XGn/zYl1hxldB29/N3yGyVGrb?=
 =?us-ascii?Q?UpQRBLVnCWuUB4pLY9dWVLYzgiXRzMqNOoih9osehb/Miw7A052WB5rKaptp?=
 =?us-ascii?Q?GK3feXRQT/NAk/O0xOdd81kDvKqdSWcU5jkxSOTTy2Wz3VG1sBYiHyuy4SJk?=
 =?us-ascii?Q?xCSsPusweYXCyOgzrDYo6O5cYWYMmExpNH/7V7kXf7ZCC7kokDmYeJ9vgPI6?=
 =?us-ascii?Q?znecFyvsE50eZu07QgoJ5hitDAaohJE/viIHyFcdEgSdeYqUKujYF4qPy9qx?=
 =?us-ascii?Q?1pM55doTbS8b1YoCD+0OUuh3thn0DoQOOllDvr09M6EEJeulrsgLplQ0w847?=
 =?us-ascii?Q?/u7BIT+/5CUxhfOZ7pXK+R9JgkoJ7sqQ9GUAuQCe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b13375-1cb2-48cd-7851-08da9b6a2f14
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:38.5681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9xDh5dONgJpMJb8+6m+Jy5vAK4E3B6pKIpxmIrXx6fV8f0weXdO+hbnSHyZHM6D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5313
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
index aa6d872b105757..a7e3b24d1e01b0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -82,10 +82,12 @@ struct vfio_group {
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
@@ -162,7 +164,6 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-#ifdef CONFIG_VFIO_NOIOMMU
 static void *vfio_noiommu_open(unsigned long arg)
 {
 	if (arg != VFIO_NOIOMMU_IOMMU)
@@ -181,7 +182,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 			       unsigned int cmd, unsigned long arg)
 {
 	if (cmd == VFIO_CHECK_EXTENSION)
-		return noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
+		return vfio_noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
 
 	return -ENOTTY;
 }
@@ -211,18 +212,13 @@ static const struct vfio_iommu_driver_ops vfio_noiommu_ops = {
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
@@ -535,8 +531,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	struct vfio_group *group;
 
 	iommu_group = iommu_group_get(dev);
-#ifdef CONFIG_VFIO_NOIOMMU
-	if (!iommu_group && noiommu) {
+	if (!iommu_group && vfio_noiommu) {
 		/*
 		 * With noiommu enabled, create an IOMMU group for devices that
 		 * don't already have one, implying no IOMMU hardware/driver
@@ -550,7 +545,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		}
 		return group;
 	}
-#endif
+
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
 
@@ -2148,11 +2143,11 @@ static int __init vfio_init(void)
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
@@ -2171,9 +2166,9 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
-#ifdef CONFIG_VFIO_NOIOMMU
-	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
-#endif
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
+
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 	class_destroy(vfio.class);
-- 
2.37.3

