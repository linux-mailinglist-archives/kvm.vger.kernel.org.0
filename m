Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55C601677
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiJQSim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJQSij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:38:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771EE72B4E
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:38:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDeBZrDhNXsWJQULeHkZtEN72LQ3nUVlgXKcECatOSPkDINGTLd96fysirWO5/SUnIhslm9gtEO+UHZrj1kxAnsh36M6s5rWCJ8m6tADYw7S2+GeaHMwzpM9EE50dx3aRt+XL+0fZK52SUBxXSwB4znmpkOlBGxoZYTPN0pr1ngoi3FVZxpZFc9V6ZLpoRgEnpJV1VE4Dglakc5lu6y7NkbSPotnpz7s7UFsZmP7szZO4xMSNwQKwBimFdlubXv2d7w1sY6adAZGmtiKKYXhEI3eIIeRE7LoadiYmK6BLCkheBg2wWn3VXtnGTX/bhBDwVl0tR0f7Ug6z13RVowHOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ZBbkWTKB0ZcjrSPTBUdegxvLI/TAYHEVOKvHsM7EX0=;
 b=b60C8WGXgHLbHU/wyqIMiQ++51UDv/3RSpOtMaZCmORqIFyGanuaDztpI7IF8GvZ8tZcIOCHMhHMYJqh5mZeGqBmZw+aZlEDc1jifp10PoxW47cTfiu6zA1m6VaVwhUkai6SXZL9NOxLQtlFeGnsOboSglrg1hzY0pkrhme/hvRgLEwcIJAT9r6Jyo/KzS7oCkUhGkgFmULT/KDsqDuGdyZJlmAGys4S23arEI6yy3UmV0PkUVi6X23sw1mHDSymtqzKvQQTohN844KcejAiKnvdayAjnWT+lI+KNOKINdcSqytsCXFD4ctJ7cwFV0sKNr0zDt7zFzAddQoodjLDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZBbkWTKB0ZcjrSPTBUdegxvLI/TAYHEVOKvHsM7EX0=;
 b=FWRbO+6CnIailLEGEm32sl57suxWvxdj8PMS04bVx/CItIVkwTO/hWJqYcJQXbqctm8A1DTZ965icnIny3t/a03HGt1kK0zILrdYU6+KN6TlQCBZrhkPKUHvIOtFwRBAYphLa1Osz/bKmZZyET38dibIhojdKog6n7Xrh4ojQ3bzZcABlnsRtiEx1WceQCwLbdqf1EqWLAeL3TXTbLhm/Nnzbtd+MVLRK3SE9vvjpaLyCh9HRhTdjXhpkN/ylu+JFh8O/I7RJylbLR2rd6kJVdjXT+i7Kxd8Dwi9LajyBpHPpEzDcL/iwavYX12SxKAMtpuEfTiHXeHAGoxLjfpkZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 18:38:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 18:38:35 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 5/5] vfio: Fold vfio_virqfd.ko into vfio.ko
Date:   Mon, 17 Oct 2022 15:38:33 -0300
Message-Id: <5-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: 3854594c-a89b-4e26-c790-08dab06ecc40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DciQb37WhMlfK0hsETFPlKutw54vbzqJy0+bfFVjwL/ih89Fyz5U0yhj1FS4pwuL0YUVea+FbbGiSumYo2gur70pwiD0AUnucDD1ptDCxw1hf/EWKEcwiVMoRStBiKerOwiov855ZwQI4SNbR1wGCqgAZoD+/5AL7nCVuF/jXkqkKuOje38iaoWlMzxT8aYYUjsZPKHoJaUmlqq7pgLq/lC6wLADszUi4vUrCMp8pxV3A8PCKEtPeA/hO0zAmQtTeQ2iFNijA1uRTYPhLQZtnRo94CcYtcvdKQ6qHFfknqcr6/ov7p2lgtMtzKkOLA2BbEgF0tCCWE1XjT7W8iPFJ77Pk0X3/JcJ4jKTJav99JWHLncSq0AqDOI4iIPQo8em7vJgX77lSw51JDTiL8fCOXWOKsBplw5VcdlGqYRvq8zQ1hxNOReO1+n3byIQUYA/OEbi9dEVjjtb1em1osNGs+/KTbaAVhHMyBDeCn/4FBShJ83JdL1bqruYeYOsgfyZjvEr5FM4pHx5ld6Y7UCZJE6Fn11FbZdKXMlfgP1EcCr3DcbKwpQinTMko67Y9hpzBYRfNP/3BtEAXDZnoadlILAZM9a291Pm3aYJU/BriS4na2akgYfXRW5h15nYSyPyicXzaxmeJFmzdeacfYRBVTrHpQsWOQiMYajwhYR/QGFfdJ6NxlUAMAkYL5JVvblo0xUmYzSOl4EBS4rTrMFPLud5rONu6vI4U2CLOnT5jXhoJk5Hp1f9SDLmrnuaBi5s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(316002)(110136005)(186003)(36756003)(2616005)(6506007)(2906002)(8936002)(26005)(86362001)(41300700001)(83380400001)(6512007)(66946007)(66556008)(66476007)(5660300002)(8676002)(6486002)(478600001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L+pA0KBVQt7mOLg+VoBKCGgYhJXwgwD/e0uKz9Hk/nKQE3nVuqdqTo5YCi+p?=
 =?us-ascii?Q?Z/FRLfRym2PXqzzK4X2Z/Uyab/2+KAbKQDGBNK01UpsT8mxOPtATfei6EEF3?=
 =?us-ascii?Q?pr3gm7yBCitMq7qnq9DlIHyLxLr9vjs+kd39KawdzQfolENcH/q53e8YhouI?=
 =?us-ascii?Q?KjCivrNa5wx0C6IQCGm8+X/zbnfHdCBrVbf+TRKsF56HXk9OGZdw1Rh94Y0l?=
 =?us-ascii?Q?dTyqcDbUxVa5a1gd9QUuOibRP7ZY/NyO0A3NBHVeX34zdSR0tOuvzXOC4So/?=
 =?us-ascii?Q?djO/d2np0epwngrRcWJY6X57xQ74pZzKs9jbmr8HMo6Y5pizE8X408cP26wL?=
 =?us-ascii?Q?VAFM1bmTc4kqhCTRLkGZxFppdgolKlony8Q6n+YyBCAbWJ7IEiwYaxhcpZmV?=
 =?us-ascii?Q?R0o1lg7K0au8v7LR248bEnNhAEgnOM7kP5PNxHA/Lh/T7+oXwXEZwBhZpF4p?=
 =?us-ascii?Q?kfJ7Y9kWBTyRS2YgOoVY5AnerrUl3jzs/7nj8EIBL84UKS/tGVzNjyjfuJgF?=
 =?us-ascii?Q?RqrjqIfkob4EQshkdsej97/yPc8OtuyDDUcWjSIKjRiz7lfdQ5piKKFVCmiv?=
 =?us-ascii?Q?nn6Pq7xY51PphZDjG/CpunwYVmvVEhMcCdDi0urm9KuiVn18Uj90V7zXIr4D?=
 =?us-ascii?Q?m4XcvnDu99O4JkUyI2x/mTXsvD+RxJiXax+VohoJjGiIOMZth4pmqlt4PXLr?=
 =?us-ascii?Q?Y+tpnHLE8tpSrd2xrnYqRddaiG1Evc8e+O5CB/j/l94Cx0KxWEAGggVrLVqI?=
 =?us-ascii?Q?GK/DEKr5r83SISSqN8pfgw/GalZ6P3b9KpoZgB5we08OSBFDVxumdtgdUkzm?=
 =?us-ascii?Q?swGJLPFFaT1yV1H44aNH7U1ccVhA39EDSBIUsCX8IPWNhG2TBobFt7hdS/j+?=
 =?us-ascii?Q?Ho6JNvxtxbpC1+1NFlv4g1JBCcal3SlMWvLvw0ia/y7u4Vm+Qphu7T7pA4+h?=
 =?us-ascii?Q?KD8ud3bhB8DAEJAg8QR22JFyvAnWiTgNfFKMnar3WbwwCVCdPkULDIN87hKn?=
 =?us-ascii?Q?YxwXB9J0SNVycfsciNFK1IdGckWr7ntIR/JFj1LNHFJfs+esgCL3II6L9pzm?=
 =?us-ascii?Q?165574kWDn+3I2IyAaIwUCXU9ltVPFjO8eSZ2i2dDFjvjzSHV4eK9dRkgErx?=
 =?us-ascii?Q?5W4Ch4+IEC8Hz4ixrEG8NF3WOgBdSLoNo92tIThGquZvRK39DAMRAvIASXoI?=
 =?us-ascii?Q?BSbdsXWYpPiIVS+1K8U+OHcWrpnxeiw6QoeztpxAzDcSY5oQThFHcqt6U7MW?=
 =?us-ascii?Q?UrL0Iq9YC88R9SfwbcPreSJkfi0DgzcQo3mPL8/mTfbFZUh8FA7S8Pzadxbr?=
 =?us-ascii?Q?YfGQ2a5KdugsEKgI5k+3J1XQl8VPKZeIVbed4tbWYcUBECCGbJjJu27819Xe?=
 =?us-ascii?Q?xPxurTQ3+I0S8ib4Z2HZWfOqKtOhdSPPtkYeMP9uyDKinanxbnwylpCdTaMs?=
 =?us-ascii?Q?NISKZecY+65nYNeU4pWUdoY8FGuHGq/lu27IZRXnlorNZs5ErAWZiKP/vB73?=
 =?us-ascii?Q?GBiQxqYN9496Ctf7teOCuKQqRQzLsCWFma3Cp/clB2jl4R3Sg3oIpOgQZdQm?=
 =?us-ascii?Q?bHfjXGlgGasBMc+t+8w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3854594c-a89b-4e26-c790-08dab06ecc40
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 18:38:34.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9QBI4ZDPZiSuq6Jhme8CgUETLqMjm/7tH6in6OmPdIMrhXr+nd7CPjkVToB7lKd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is only 1.8k, putting it in its own module is not really
necessary. The kconfig infrastructure is still there to completely remove
it for systems that are trying for small footprint.

Put it in the main vfio.ko module now that kbuild can support multiple .c
files.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig     |  2 +-
 drivers/vfio/Makefile    |  4 +---
 drivers/vfio/vfio.h      | 13 +++++++++++++
 drivers/vfio/vfio_main.c |  7 +++++++
 drivers/vfio/virqfd.c    | 17 +++--------------
 5 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index d25b91adfd64cd..0b8d53f63c7e5c 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -21,7 +21,7 @@ config VFIO_IOMMU_SPAPR_TCE
 	default VFIO
 
 config VFIO_VIRQFD
-	tristate
+	bool
 	select EVENTFD
 	default n
 
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
index bcad54bbab08c4..a7113b4baaa242 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -124,6 +124,19 @@ long vfio_container_ioctl_check_extension(struct vfio_container *container,
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
 
+#if IS_ENABLED(CONFIG_VFIO_VIRQFD)
+int __init vfio_virqfd_init(void);
+void vfio_virqfd_exit(void);
+#else
+static inline int __init vfio_virqfd_init(void)
+{
+	return 0;
+}
+static inline void vfio_virqfd_exit(void)
+{
+}
+#endif
+
 #ifdef CONFIG_VFIO_NOIOMMU
 extern bool vfio_noiommu __read_mostly;
 #else
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2d168793d4e1ce..97d7b88c8fe1f4 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1814,6 +1814,10 @@ static int __init vfio_init(void)
 	if (ret)
 		return ret;
 
+	ret = vfio_virqfd_init();
+	if (ret)
+		goto err_virqfd;
+
 	/* /dev/vfio/$GROUP */
 	vfio.class = class_create(THIS_MODULE, "vfio");
 	if (IS_ERR(vfio.class)) {
@@ -1844,6 +1848,8 @@ static int __init vfio_init(void)
 	class_destroy(vfio.class);
 	vfio.class = NULL;
 err_group_class:
+	vfio_virqfd_exit();
+err_virqfd:
 	vfio_container_cleanup();
 	return ret;
 }
@@ -1858,6 +1864,7 @@ static void __exit vfio_cleanup(void)
 	class_destroy(vfio.device_class);
 	vfio.device_class = NULL;
 	class_destroy(vfio.class);
+	vfio_virqfd_exit();
 	vfio_container_cleanup();
 	vfio.class = NULL;
 	xa_destroy(&vfio_device_set_xa);
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 414e98d82b02e5..497a17b3786568 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -12,15 +12,12 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-
-#define DRIVER_VERSION  "0.1"
-#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
-#define DRIVER_DESC     "IRQFD support for VFIO bus drivers"
+#include "vfio.h"
 
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
 static DEFINE_SPINLOCK(virqfd_lock);
 
-static int __init vfio_virqfd_init(void)
+int __init vfio_virqfd_init(void)
 {
 	vfio_irqfd_cleanup_wq =
 		create_singlethread_workqueue("vfio-irqfd-cleanup");
@@ -30,7 +27,7 @@ static int __init vfio_virqfd_init(void)
 	return 0;
 }
 
-static void __exit vfio_virqfd_exit(void)
+void vfio_virqfd_exit(void)
 {
 	destroy_workqueue(vfio_irqfd_cleanup_wq);
 }
@@ -216,11 +213,3 @@ void vfio_virqfd_disable(struct virqfd **pvirqfd)
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
2.38.0

