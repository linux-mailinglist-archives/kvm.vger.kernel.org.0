Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F23F5F32C1
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 17:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiJCPkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 11:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiJCPjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 11:39:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB9212623
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 08:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gw7/uZhXrL7OQy2FN5zCxmgCHAGlf8FjjhqHxOlpY8u8dmtEaGAJ9x6KSWbXE72nnN5jKNXuHwmiIQLE8brxbz+OGo7CS8TsGRmIdeUfBcocKuoGKpEsdR+zFT6GrBXGBlSHKdt3h6+UBdMHs+nSLRL31xzJCtXv4kMVgeT8751NpmoGPWxRDi00d0laNgRUwCyG+pfExPqpNSSPcxK1qe0fVCuKXCrLz/j1KR7mARO3gEH4mB/vMfJhKlmXAszkFO8qVifN+P16bMnMj9J0fwXUhIeoaiwaoV34tJm5gHvz//CtKSx7qDOJzvY/Kwk6oaqJ6TyOSAaneP1/xxUMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jp4216QHHeblPSxseD9wYFd0QPJFodBYVw8O7p/tf0=;
 b=M+dhvekI6YwU6AV6cv7vacsElSbeEjhhNPzrTEr1UDiKPnRVdw9XFSZRLrhdAu0RYnUUcdp8/2uHBo1eYa7DBGc2dSqh6MaOlRxkX89TV6iJ7DMPQuuvWFU0bkLo43RanxLMB8AVZsW5LGk/nCARc62EUZA8EzKuMEiQzBK3Rf2FFZ4apuVfxjVPsELXPWrBDsjRhj6CQNVxjWDtQ/vqYSi3RTyw7WBp0NA9FWOMl40ue1IeAcquwgutU1bjtgBRb/jx4ZwiG6XG3ohS/y/29JNXZpRTA+r17iYkKyKtujWkGFWY9SwKYg6hv6pLfiCuoSGUC3aJYYiHbXlLz1+/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jp4216QHHeblPSxseD9wYFd0QPJFodBYVw8O7p/tf0=;
 b=QmGdm0WAp2H8jhmBVl75J2kr3ZOtDAkJRGzaZ4e0MSmfL3tUCydih/taSQcz64s7r78PvL3sgYRrYHlpzZK5Ti8VmvoTbqIyruuzS2uTt/7f8Prp/lloTUt2NshQK4xxtVbaXLlMJG5fjATDWw2QFWIdHwRYdlq0We6SXf8LohSuep+s6tPyUHAj4QXtB4dAoblfVNoE58qmmtCcjAvpRTj0V+5yUCMfH8seu+spmX8duFPTCOuwMvSD11xK7DKBpzIKc/QFCGiV6h1by8KaqR3NoNh9ADU8q4yn7/a1YroiUVm51/Zf/yJ/46Xh7KaWpvMONHlF7twScae7fEwF9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 15:39:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 15:39:37 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
Date:   Mon,  3 Oct 2022 12:39:33 -0300
Message-Id: <4-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:208:23a::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: 363f3936-e4dd-4407-1c73-08daa55579a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ln6yu1LHIdMwX9NphZCzWp4pWYMfXuNwbpj92AJkGH24MLbzKwr7vjO7GSSjROFxfs49ip6C+h6cG1XLo2RLt9Z/zzfnOA5+EFgrgQEvjQTypRT2vhqHLL9NZYOQfmLjsOEw/1EYs+prVZMxQ0XuUgXiqad5JEUxoXC5WK84j/Kzh0wvqa3F+cdiaq9/tkyyMYwRdq4lnc1jF+h0I8W5lwR0677ur6Aj7V0btgbwIdkrOQg+anPy81O6omzLQjSrAJ79gIxBF+7Z0CU0blAO0Z0oAOwwC3hCFqigMOOs545X3MUro2iOJjis611xL1lacc4jUliOarRFc2nbQReicJPqBey+dSr2ukesr5w9Es0NdjehE2XZJYWV8LbgkvNT7kKG6Xrx3MGPalMA2KttSzeqqFkzKqB8X0s46QJSz4ogEOm9AZEVxkXMofu054+mcJ7j+K60SWKrDJ8mAeUHAjAL1qv1OHrZpQQnXhc9ULWHnXBEJcvzMXLczWZ1OUeb1YuPnpOOgsjbJBNgoER+hiT2Ta81mHaLQedym+4vdrKCYBpT6RGRxQ37FN5uTHeQ80dJjdLzwlOPKinEgakMT7Y9MhLitRmyms2Czez/zrzFhuuwucIglU8Dov3caxWeAwx3UwOFBqNaYChFE02wEDOO/p3mDRb/8L6DLQaCeRgbVFpYGjOYiUFAL04QeJDmY5H0jGJlktnX+YgCzzzbsMdtTDPUlB6AWwobM5t1Mlb1+d7e+B8R9gf7mVSn1DDb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(6506007)(6666004)(38100700002)(8676002)(66556008)(66946007)(66476007)(36756003)(86362001)(478600001)(2616005)(186003)(26005)(6512007)(6486002)(110136005)(316002)(2906002)(5660300002)(8936002)(83380400001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BpkkG9rBHrPG4qDMce7dAApjPPOi9kgHQDSAcGkn3X09DGaGsxiOMVoEdGin?=
 =?us-ascii?Q?GM8HEQzXHsY3z1T4QdSV7SA5MBi44VSChFI6aG8iMtwv4xPS/WSSY5M5/KY1?=
 =?us-ascii?Q?Z5SKD1+5Vh/JlSl5PpD1CJhCaytIR3s9MrW0wrbP8hEb9k3Uc1XP/rKyl4Ub?=
 =?us-ascii?Q?qkOouA0LJI80kixqpHZBxY0CSookvWWZQpZ+2R1eJ1NEiV6KfeiGzF8aH18I?=
 =?us-ascii?Q?xCUPn4GfApbxp6vpSTcYfuORvpxaiN2EsIc9xxFrH/tjKMOvoG+AKS4twgFc?=
 =?us-ascii?Q?ybPmqwxj5wcHtxxwCkUDkgJzCABKIoHp4KLx5K+7ICLQJBDC5YSYc5XdXLkR?=
 =?us-ascii?Q?KhAspjNFrO4uastxNcnTeaiTPbCfz6zm01gnf6orlz7Eqq2WrKNkL/hvN7P5?=
 =?us-ascii?Q?g/2DDb7i/kviAMew+sY/zr0An53deQs7+dmp6Gqe5Y6d2pDPjPPv7m3cFiW4?=
 =?us-ascii?Q?IZ88ouKTAgBS6I/kTCf/miDAkEeGBM2S+Q+3eginxgbZzog00FXtATDZdDlR?=
 =?us-ascii?Q?ZI5H22lB+9dtAnxzo8lvIAwyZlpPlcFjp6wTVkUcJ4YKBABoj6Qh3g2XXV7Y?=
 =?us-ascii?Q?Bk7BttE716WWInThcL2DpkqZudCrz9V6kr8x4uh3oh+jmtWdzP8EtgzlbZdN?=
 =?us-ascii?Q?MJLAe1HjeRVtCtE9vsjINgmtIVdbyZX2aWFS8Fdrkp6BEs0c5TIt6+iQ13Ih?=
 =?us-ascii?Q?PRmA1dUBjigoC8ELY/dfl+X23RY8kuARtmlZeRaC4dJ902ygFr31MJF2I2ts?=
 =?us-ascii?Q?TMrQyLT47JnRDq/OwX7p3/3EOuk3ovErI5mlyoTU8e2Jz3cO1jRnylOzoR/2?=
 =?us-ascii?Q?O2MneSibtcWgzdMzs8ts9vj69oMv2MlwpZwDs9S8r09XNiShUoclCBLMyuYM?=
 =?us-ascii?Q?Lpp1O43g58arpfWPRtRQJPTDs3SE5JcN+zJT47VtLnHzTCdENg7eWkxheLHd?=
 =?us-ascii?Q?T/MUSO5XK6EZRvofM/VM46rO3Rw+vLv9EQxyMHyNHI0pxCuLghuFd5FCe8fS?=
 =?us-ascii?Q?gzkvOa6E+/Hd/tb0AJZ0VF4N012XcJjK2zQu/oAP29neF9PwFhw+6NxlklvC?=
 =?us-ascii?Q?zpZbzaNaI1aVfa0IiH83NVoh9VvOXG+1YhGuizN9ctt3u/Ih7BMLl+SSjDpI?=
 =?us-ascii?Q?ryD2iWTTNN3fcDSSbpojhEqKCwSom+WwmmdDsG6E3kHXaapCBvl6Yhx1qMyZ?=
 =?us-ascii?Q?qfcEqq9x+91BUN1vc2Ux/Z50NUPkjZfrEtFxj0i824HAi/zIPtpVUs79lX3n?=
 =?us-ascii?Q?WpSTgtdmKkEJN1RLXmshWR+XOyL7TZ2QGi0N14jbNwRlBdmDzyTItIrD0MgK?=
 =?us-ascii?Q?vgQdVCQ1/pPJbZJPg0KIyx6W+didOfWC02kpVNMQe5tp/jIE3SFY3oTxIrMU?=
 =?us-ascii?Q?s1MWoyDqYzFFNR7G52RyuE4qicwIt6+8n5cw7oi33vQE0a+NqiqwreJMKEBE?=
 =?us-ascii?Q?8j+c9OI/l6DvFAdewr5WJdfIPaA9Tyj0T2sVaM0X/5W4kiuD+FhDocGJSfR0?=
 =?us-ascii?Q?eXK/VSw6zxGC/ojZKHUOoF2ZezsNWIAA4X+9v2roGTPBUnyIaktupevz9yZz?=
 =?us-ascii?Q?zfpPeLOMLhkmbLvT3N2GTlLrLHO+S6mmROTwiXvD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 363f3936-e4dd-4407-1c73-08daa55579a2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:39:35.9379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Czc+z9kyiGs2GKYswms3VlH8oqUhG6+A6Tha1vs8OUaRXRq4g0nsquIesqr7Ujl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/vfio/vfio.h      | 13 +++++++++++++
 drivers/vfio/vfio_main.c |  7 +++++++
 drivers/vfio/virqfd.c    | 16 ++--------------
 4 files changed, 23 insertions(+), 17 deletions(-)

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
index 4a1bac1359a952..4d2de02f2ced6e 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -125,6 +125,19 @@ long vfio_container_ioctl_check_extension(struct vfio_container *container,
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

