Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C6E5EF84D
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiI2PFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiI2PFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:05:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B0261D94
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:05:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJmoMCSE5Zfsx85KPkZNna1gKWf+kRjsn+XhAOym+uPdxCy8Oy4ThL3USA2bkklY4Dr+FQCySJ5PZpe1V2Gz43QgeUEakk1QRg+Y6kFesUhRLif2FJWH8pUg6A10LAlVjDNZHR4iATFtbS8dMPyVUQy9Ir3S09PlRbekVVQW+DuhOOe1wsrHoHrTq7TQ4Reo9dsTVb23xj6e/q0f/gXt4Mz8taioQvtuQPFAf4NxMwgIev/gZcRp11JJocZkscnWZC9h4pfS0mgReJnlrA/AgrnDGFehWOc8Z+Dnt4iuy6xXbWuZMuxdr5JDBXLcTXnJpSgfKyh8KTpcvHRaogZALA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kQRakpMlHJdXqaku+uHb5j9TPTZ2V1jrpsyj05zHtE=;
 b=YbYtxTz99GJ6G5KS/3e0jnJfUFMoK85m/HKYPynihuomFnwO3vmrl2eVqahVQ1bZ1bwFuHDByIv0pT5zTcAEoZzPPIXf9DoCP/vSBWF7ebq9JVrFHy8aWbbU5oLl5cqAX0BFZHxSBfvwTo8lRI10QweOSxbfb/J065wfZKQv4X71jWZt9KV/7nW4ajd5Cr9nv7ov9NDgKKp5++SsL9EOHF12V7uBiib/HluSzm9RPAXaNZ1MT6eb7aQ8l3VXUtze4kw51KQOOtfT/CwERdT9sH6uWyPaPtBMSMHGnpzoekcqDa8Q5eArKIozQliAcm4HNCNoTB/GA8WMd3hnIEP9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kQRakpMlHJdXqaku+uHb5j9TPTZ2V1jrpsyj05zHtE=;
 b=JLcwzkJE6g469zqa4F9GTHDErDASgMqdckiUbML2Q8IcyMu0OlvjhlEkPF3VLBwt9JzybgASNVYhzqeHqgtyv6iB5QRTj4WTIDyyNqfLoH9KJ4cr7huypTd5jGXYjzCWbh0MAbHUMm4tD+NUb7v7uvzM3jC7U2u6iYVUv51zG4E8nljtPb8wiNXkQp3rDncxRs1mOhNy13vn1eZG5xpTaZyzG1hYzFeQQArdnoVpvM06Xh1vRm25kXcokiYIpm5okIgkWHO5zU4ptSDwTJYhAnel7pZFDtlI1RZBzJFVHbyKYBUqm+7W6Iub/+smoakhlJ+EIsVp4uynwKKxSoiyWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 15:05:03 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 15:05:02 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
Date:   Thu, 29 Sep 2022 12:04:58 -0300
Message-Id: <4-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:207:3d::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: 06665632-260d-45e3-ce77-08daa22bfb3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: btuzEe/6mh5haVNSmhfT8WKTYDnfA+fITkolI2tpk33mUxv/Ye7LBeLFiw51rcd1wi8mbqgCXRkQ1cy5ojoHAwfUZolVgjfK9caWzLnxu43HaLvrNcjerD2/L7xbXB+2PMg0ZTiaosm8ORnTMEPI0Aw3IjcXYVskT1opIQ4DVSPw0QMEXCCC76FGGPV6rPvKt15w88LDSw1VZHMuUSJTN+p/V1TFjHbLcZRD299oMDEpeTGZUCiYLE9eM3ftguXmfPpsc5UVhsu9jIOiOcPB8s6eKBlFnsOUmYeKaAeQ6Mj/IpO8COO+lLv1sfGXqTE0JpZ+HvcSJhggdjYQWemZSkYmo6I+rIi6RHKpxbGVAON2YV/RY+OrbwlgZuN+cfQTRO2NkY67t3Uj0doisqN8uYRMfuG7aQHPTH3wyHTZa22Ol3beXYsLvP0dur/wU4vYHQAZz0n9fNaeqGrEOTLP+tis/K/6M3yfT+97KXzhnKPh/XJHFBCuS9U414M4W/Q+rtX9hKNWR8NWZO42Ty00VOSpTBDSrxy6wlOrAQ5mSOE7H2OHSwuF65ebflb9SI7sR41aIfKUOq3qYoP42CgpnAYTaGEcywDuhFsvxtFlvrk1Iwa4j8DRLYlXa1yp9crlcd+Yx5s80ckgAxk3IMpPZg+IE72xMx+BCMQSAcfZWEdmPEB6pMyj5LzcAQu88EFtBom+IV5ilBTMlgwq32MQBcwIyjyypzoj7dfPMngPfpA4IT1y6D/5tJuDrAICl00Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(8676002)(83380400001)(186003)(38100700002)(2616005)(6512007)(2906002)(41300700001)(8936002)(5660300002)(6486002)(478600001)(26005)(6506007)(6666004)(66476007)(66556008)(316002)(66946007)(110136005)(36756003)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OTVq5PUxROg/ThHoLQG1bdk21dEBH+mSKjFPWDK9246dVwTsyAbPjkad55Nj?=
 =?us-ascii?Q?xoUkQDtZq/mbCL+rYTgSZkItbS22u86ZIS2lakhp8tcCefnX2R96XxbBoMcx?=
 =?us-ascii?Q?0Lpk21fgPp5YM3TqegpgD/H+cHMTrAP4smYU9pfyAov+ooq8yZZmot9beuHH?=
 =?us-ascii?Q?dyaI+7kzinsk7lv6TXFpYEIjWN264kzp8VIYOC7E2Be5F0QTBarOU2gY0NIw?=
 =?us-ascii?Q?aV86Rz3/0HGd+cEzk3gJEE5wz7AHG0zm9YdIjoZiLd7c7L5QXr7k7zC8qyFT?=
 =?us-ascii?Q?4fK7JmOmcYG9ua1TnQsFsn+ISiK8UjkGkUdj/yVcUbJ2agCkyQiHiSLoYKRR?=
 =?us-ascii?Q?6v3NFsvLZe3UHxMj8aUyEMV7DhYu9YO0lv+MjRlDCMVLs8qoO4mtHa55nsmP?=
 =?us-ascii?Q?XiKvSem8viDdAim9QUKEZeUMEBY9tmJlvfz4MCj2xhTuqkTZJAGM3/REzHu8?=
 =?us-ascii?Q?fxa5dE0PL0A7mEnfQhYe6+hr73kSrOuzXB7ccQRVMNjHc6if62eK+bb1LfMI?=
 =?us-ascii?Q?Qn+TJAMzcQAmASrDJxnbETNgl8qE5b/h0snagHwzIB8bYfhC9EJxT+Dt7PmS?=
 =?us-ascii?Q?14U5MaxdJwJ8/d6i4x1vKHGQ80vuJcQd5uESjRIUCvY7AgOaeSB419eg2QTS?=
 =?us-ascii?Q?QqhSMjRVtEK99R3XpG03/AH8nBIOvCd1uFHODudgOQUgb+0Vng75hbpvdNyY?=
 =?us-ascii?Q?QDnCFAul7j0hJ44jy2pV/AXF06zrcwr4+RvblyVUFNIVF/82eHgzSRdN/XjG?=
 =?us-ascii?Q?fToxG4eeflg3WBC9JtlHkIUj1EfOyBtuZA9BBgTZ24erVdT4T2+ZwtfWYwq6?=
 =?us-ascii?Q?knCT0ywLIvOOd4oGKF9+6p5U9Px5Ec6Fj8djQMCwdZn0dvP5X+DEE1weehLw?=
 =?us-ascii?Q?AoG7Mogmlyk/fa1zm6nND0Fvk6Q3eNzHXlWziqXL0GQeU0o+mjGCl9HD07Sl?=
 =?us-ascii?Q?ANBycdRwregX3a7RHbawsW+3bmc770kfpMfEqfvbDqnyqlSMrOUFHrtYzKg5?=
 =?us-ascii?Q?sjhEwK58dl6nUTaMkVGdLRVj5+5Q0CgxJ0sZcUHiiJIRsPBK961sW61ohv4z?=
 =?us-ascii?Q?+Jif0a2kalCCIMkJKarsiKWy7hiaCERvw9KLon2NmM61ilyz0iLZ4nfv1Ufx?=
 =?us-ascii?Q?VXBqBS7vv3brCwgE86jOgZ7Ciz9lgAjitQxWZkxchywYlntPJ4hMqC5yIbb7?=
 =?us-ascii?Q?wi4JH8sFn56Z4yIsmpy0lqh3w7tT+CHzcb6LSikRUgLtWP5iUp808W0NXlmV?=
 =?us-ascii?Q?S04UndvevbazrBMO6hgPwVeigAv/16A7NWti+/TV10OXQiRgAf8KBMH9zTi3?=
 =?us-ascii?Q?RKmgiD+ZS7oyk4m4hoa9HWcFTqfbu2t4hgGXW3PfVts8mEGKr4uuyrWz3Lb9?=
 =?us-ascii?Q?9k86FvxtIyCuEoycDMeDCn4NxCg0HEXQTY9z5KceJUJX+TalGZ/kFv3+ZEVg?=
 =?us-ascii?Q?HadBs7oCzz5yYcscrKzn5ez3LF50eijYsJkKETRZN9sPkCDOysJ0/JnPAOOA?=
 =?us-ascii?Q?+U8vsO9yHCzvbMXhHdYvWukPJOSwzFYumh8yui20YiEHx/M9u54B4jPDDsZx?=
 =?us-ascii?Q?Oi4J9RPkpIgrjkHUqMA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06665632-260d-45e3-ce77-08daa22bfb3d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:05:01.0333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXrWat16Wm5VC2EjG84i3WSrlE/BDLjeq/2rGegVbItPiHncP9pddK2gY+wZyufw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is only 1.8k, putting it in its own module is going to waste more
space rounding up to a PAGE_SIZE than it is worth. Put it in the main
vfio.ko module now that kbuild can support multiple .c files.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Makefile    |  4 +---
 drivers/vfio/vfio.h      |  3 +++
 drivers/vfio/vfio_main.c |  7 +++++++
 drivers/vfio/virqfd.c    | 16 ++--------------
 4 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 50b8e8e3fb10dd..0721ed4831c92f 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,13 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
-vfio_virqfd-y := virqfd.o
-
 obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
 	  iova_bitmap.o \
 	  container.o
+vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
 
-obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_PCI) += pci/
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 4a1bac1359a952..038b5f5c8f163d 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -125,6 +125,9 @@ long vfio_container_ioctl_check_extension(struct vfio_container *container,
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
 
+int __init vfio_virqfd_init(void);
+void vfio_virqfd_exit(void);
+
 #ifdef CONFIG_VFIO_NOIOMMU
 extern bool vfio_noiommu __read_mostly;
 #else
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9207e6c0e3cb26..9b1e5fd5f7b73c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1777,6 +1777,10 @@ static int __init vfio_init(void)
 	if (ret)
 		return ret;
 
+	ret = vfio_virqfd_init();
+	if (ret)
+		goto err_virqfd;
+
 	/* /dev/vfio/$GROUP */
 	vfio.class = class_create(THIS_MODULE, "vfio");
 	if (IS_ERR(vfio.class)) {
@@ -1807,6 +1811,8 @@ static int __init vfio_init(void)
 	class_destroy(vfio.class);
 	vfio.class = NULL;
 err_group_class:
+	vfio_virqfd_exit();
+err_virqfd:
 	vfio_container_cleanup();
 	return ret;
 }
@@ -1821,6 +1827,7 @@ static void __exit vfio_cleanup(void)
 	class_destroy(vfio.device_class);
 	vfio.device_class = NULL;
 	class_destroy(vfio.class);
+	vfio_virqfd_exit();
 	vfio_container_cleanup();
 	vfio.class = NULL;
 	xa_destroy(&vfio_device_set_xa);
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 414e98d82b02e5..0ff3c1519df0bd 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -13,14 +13,10 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#define DRIVER_VERSION  "0.1"
-#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
-#define DRIVER_DESC     "IRQFD support for VFIO bus drivers"
-
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
 static DEFINE_SPINLOCK(virqfd_lock);
 
-static int __init vfio_virqfd_init(void)
+int __init vfio_virqfd_init(void)
 {
 	vfio_irqfd_cleanup_wq =
 		create_singlethread_workqueue("vfio-irqfd-cleanup");
@@ -30,7 +26,7 @@ static int __init vfio_virqfd_init(void)
 	return 0;
 }
 
-static void __exit vfio_virqfd_exit(void)
+void vfio_virqfd_exit(void)
 {
 	destroy_workqueue(vfio_irqfd_cleanup_wq);
 }
@@ -216,11 +212,3 @@ void vfio_virqfd_disable(struct virqfd **pvirqfd)
 	flush_workqueue(vfio_irqfd_cleanup_wq);
 }
 EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
-
-module_init(vfio_virqfd_init);
-module_exit(vfio_virqfd_exit);
-
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-- 
2.37.3

