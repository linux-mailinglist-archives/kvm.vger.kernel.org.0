Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53ECE63CC4B
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiK3AKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiK3AK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:10:27 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641DE3FBAE
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 16:10:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPbU8geSKJnc5akHKEFd14Qxa6ppplnuKfKOovu+KKh9oIQAFlS//h7SwSwVggFVteh8SIsRM6GOe8MvrQE7eKIN5a02ikAZr89Mfvjxqvsn67yfZU0yKB76Ig0QF5KVFjBpMwS6obmKmSW3xjap/rtxr+uvY+T1WLNSWP+P40KGaKAkY0hg4A1Jkr1+lTMAqCBOXcnWb3t5i5nFuvVpDB4HkZeykZiHsdMVRyiPBGRSTpd5wAXz22VOcUhnbnCbczj3/BNITkDeanb0TJXbqpY/WctSPyvkrkbiWqqWJKnwYyvd70lqpxfiozC3Ga3iOE62au8Kgdha+X7RRz1NqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkEbUK++3Pz31BCbkoOE33dzIv+e41BvXcURJA5t+pY=;
 b=Qx6pSNyRASGmgtVvKY3LMvjWLlj2ua15n9y8B6QK67D66Xt8bF9wWiIdasOZ1kfizFv49a+d3gHy5dALC9v5VzJcnQEu3n2XuZgggji3ybS48mjGFFci56qygOO7cRNHfHyf3eXeFKu1FUoYA/efy1wvMr8EG0Bs3VdpxQS1gDHCYsnC2YDfWcgGbln9Pue0/edAyTBDLeo0oQ3jLwBw1jey6A3g5RlQzRET1BzmS4P/UFTd/h8Z50XcxPJryNXf42eFV9uVEDM5r0bVfetn6X7CbnG+33C/QX9sKN8S1FXzDnysSxvgKfuRKQw8yyWCMYs3MFaRFaG81IFa0N3sLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkEbUK++3Pz31BCbkoOE33dzIv+e41BvXcURJA5t+pY=;
 b=tVNua4KkBBiwbkGN11auvziuFhd8Dg+L1bdWwTDNnzscbasoP3c26nzdnkMKTPNyrgt371gaG0UHhTv/mUjoKTTRYCd9C1n1evZ1YHhmYBB/ySWaE9OA1vHrhYJb3zq2qvZipiFQNuFcL5PRQYxyKqlEI2CQ0hSfhg7nFDABLi9uArYQLBDIHQLkI020TerpkZS0X58QfiNyFkA+RwMF0kQ7lwpW9lrWOEYttgmOpzmRulZI7+qfS/ma/0YCnwwwU8BZOwdc8CZVi2SB7b511Z3ZH7cId4PeDOlWqsBJQOBXOzEOR48VpK0A+zXIJMWUszoWADiM/+J5zus5oSDBMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:10:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:10:24 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 5/5] vfio: Fold vfio_virqfd.ko into vfio.ko
Date:   Tue, 29 Nov 2022 20:10:22 -0400
Message-Id: <5-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0360.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 72f6cf11-94d0-417d-69cd-08dad26746e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LLDfHh8e4WHJLr0oQOPvOW6pqj4SyE89nID+69VzpkUiGKLzKYI5lrNVvu3O1ewuaIJACF6n3CgJqzWI+rmVCUq3h1P+/CVPAQjb6Ji34XuYmacfquf0c29j4z7cj2Gtbr3uJ0aCwPoIgksQArH4tm1q2uiHomIv6Ju3850rGRPRc1fjXJJj+ceB9yi/YUO+tm6MOtyFFTsob4ensnaNfnwBdQrPPq22zGUJgM35jNSHHT+afPpJtZPacu+hBD4DxnSxLl+F6sk0F4ktKtKc50E7cQwcr+kQodRt3idpyKLOF6aIG81aoe3D93QX6XUGpCI2XcLGYE6jUVntRQlDhmWZuQGfxdCcRccAo+lDL9YIx0gqsMkevDgwhmQZ1D4LHLScw/mlmluJPyZ30GAwTXUbC3tFVjElsTneNo0FZqtcXCt2xmqZkTAYmPAK8Y6F6MVq+bh31gQ3KWz64X1RqT7L+LI550wHlizPZ5Y5g+l4lRAC3d1CHv/bCr8Js1ZGAP4E74uC0wPFgUfxcDeE2M5yzaGZhH3i0ACftMaJc6Qzqjmzd2Qv+rLpKYx3+0/jbSlx/Vsv260I4ufj42t/I62NckqO2wAT6q70NByRuiOXrh8SwY/H5Rztecg/yyNaumJQZgcMKpJ3kaLlUs/QFZS7enpiBgNgLwXzKyatR6w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199015)(6506007)(110136005)(2616005)(316002)(54906003)(6512007)(478600001)(26005)(6486002)(36756003)(186003)(38100700002)(86362001)(83380400001)(66946007)(4326008)(8676002)(5660300002)(66556008)(8936002)(66476007)(41300700001)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SpVLVn0ShWo8NdVQLClCjjMAb5KCQVo7rZcmyrRMgJiOqNjANhnO+puhvKNO?=
 =?us-ascii?Q?mN2rxGDOrkSC/f438MUcj27+2rA96aK0MgeX7WFGAWDzgzrKm1jJeOCds2Tp?=
 =?us-ascii?Q?xCJTw4LMQqHIvAJrdzWH2ddDlJy1LA4YVmqzZKvPQ1ZbAEcHAUgkJCipim4I?=
 =?us-ascii?Q?CWfYEvfNseOJhNgaQ3X4kkK0/mgnHUZNoPkK0c09Fa0LhHHT/E8Elc2VuzMK?=
 =?us-ascii?Q?xqAozrKb/aC4aIcTGUEAB7yfoyetMoH30XHfJgmpX1pW9QCnUuRX9Cy/K5RD?=
 =?us-ascii?Q?qm3RyUvlYz8YAUatJJz+k8JJCrXqeLOAFxjme8VX2ysgsGoybFfYK69rrcsR?=
 =?us-ascii?Q?yobXXO5KvZzqsWde/Ha+C8Oi1wJpfh7YbXgC/EsMomCONiwVb7X+DBMdbg+K?=
 =?us-ascii?Q?mmiLV3uhknYIjbXVhw2eX376kZixBpw5aHs58gPXnRw4+V5zUcZPcQ50cWMt?=
 =?us-ascii?Q?wiftGZ03hcF/4zSC8OHFpHxz/gE8NFzz9XwVQmUC4srmA0pfjCc55DYGAWmQ?=
 =?us-ascii?Q?vDvbTbgWkvR3YC1+LX/te0vg+2YL0+avtXOq8onhN2KdCsO63VTyVDxxkouB?=
 =?us-ascii?Q?GT0i5kb6zX+p9bv4mEb1ZoIadE0hVpCLuSNxTt5XK8e1LASdEPew/0Ab2ESp?=
 =?us-ascii?Q?UGDGpYZVde9CFP1O2AAuUFp3VlKWwr9RglJcE3VktdvTvEEATakIhcz1TxAp?=
 =?us-ascii?Q?Q63LNZm83vbb4m93dh664Yo9kYRCK40XspHsFiaXEo1zYqoKmZ85pAzFpdjv?=
 =?us-ascii?Q?Hm6/ExM+6gWeSgq1KfewVvob0pcEj1XNvsYrUCAewGiWNlC7tmf3ZKhLaAOZ?=
 =?us-ascii?Q?Ns3h3GJA/S1v1DiW9MQEz6hPIalue9WGXljgdXMcJgsHxHsG9GbG3syAT5At?=
 =?us-ascii?Q?3bm6UhfGoA+QS1wDLdv/qEmQIkwfINP7RXJd9Sl7wTMOdQybSowcq+AiGDn5?=
 =?us-ascii?Q?b3F2X/kFdMSD0W6hfaX50OtjI4b80SFKaXhyXawH2W6RTCd3eCkc4lrEfO/0?=
 =?us-ascii?Q?o4B7bQuFhHIbskz7OSwoKZ1y287clH4LcMzM9U83VPOlMVTBLga2Ujs2VFTX?=
 =?us-ascii?Q?3jRvPkSkQxs2KA37xKa/mI/cuPCklY+n/hWDdykTZlTC9Ivi/3/mOdb5pUgY?=
 =?us-ascii?Q?tBZrx6C+ctJSZHI2P5uktTb5QYuSfhD/emtmMZoiYHti1erThZJHTXkNJu9J?=
 =?us-ascii?Q?MLTpTAVydbUb5x+K3aFzPGA6qYqUka2tTOEzWoFAdtpYWA2PrjsZu9VIfxsh?=
 =?us-ascii?Q?ep3LWLY2vU7tLwd04FixIc1ZbUVugT+Iy86C0LTAoW1irQGV4sM87CT2fL7p?=
 =?us-ascii?Q?bAXQDwMNbo9LWS5pXT+Fa25sEYT48Tve5MNQP6qoK1BwPyP3PWCKO/5DU1bk?=
 =?us-ascii?Q?zme8B+J5sbNB+xCWKj44bfP0IAmjyMisCBaxc8DowVkBmU7qJon980oGD5vO?=
 =?us-ascii?Q?dTzotznvlzWx/1FV4sSslh/t9CcgPdy9+ikWJ+UFzkY1juo8svAfIYEUyG2N?=
 =?us-ascii?Q?OGjb6n5I+PzZv2ZDV/+H9r4lfs7NMWqdrHQ9yt9HUc5RfiHxLTGYXdzm5Ght?=
 =?us-ascii?Q?WhYdH3S3rzgZVVAJPzA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f6cf11-94d0-417d-69cd-08dad26746e8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:10:24.0541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xw0Hr3akYITBX7s/sub4Jp8gONCUCb9QthcWYLP5blCyVnBgN5fTRO7u/u6fJB3j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.38.1

