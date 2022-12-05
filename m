Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E480B642BCA
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiLEPbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiLEPam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:30:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5769C36
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:29:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gx4lE1o27hA/iy/iw+YZ5+qTTCYvfA3SVZNEoIb9Xgn/MdOOWnfZoD13+XwVlENU+bfjCG+By5wD1BBQvzLsT99GGd6GhATbi/3F207cPhpk5wODRNqxmcLssOwZENr/Nvd8Z+LsiF3BMw2EBJD2uGOnSCjxuiaOUqUai4NbRjdsoQZB77G93HG+wU7HFM9RWQPIuUH4V1H8qe/7Y9+79y+NLTSlgivvqrkrWwwx4On7OEVHCz6/aJxwSEyn3lpYnkKZSdjzArcH9g9iOHeY4HwDMERedyaVa25bVH1jj49xLgzaGo+NhlsY8ND9xq9MlWFd77ObHp6uIilVSdPbmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkEbUK++3Pz31BCbkoOE33dzIv+e41BvXcURJA5t+pY=;
 b=lQHM2sBm29o1yFL/f4FDMQXOt6cmqjxQNPHMg92o7rgt9DzTGWy/stOKonOsSPYj29HstGs0VBftyRL+Qb3iIoYQKVWdmQScJ72YTAyIBDcrT+qy2OIdppMooAsoGidMtABmKfShiF/Kextqgj3O/5u3DDUgvyvmNQPNVmVr1H+9DkA5BgA16r5DRbpL+ps1V+zYRIgIYb3Jr9M3gVLDLwPRnYKPRUn2z0N5f38JPs2WhgMiIpIwtkfIwrocJcZFlSbRZUIC+BFQ6jy0tIsri1OXpqmisNAdq5mRzUPcaHAqoMAHtdokth+ygH6fSw56UHYzaZJkncSQdP5Ze6yoyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkEbUK++3Pz31BCbkoOE33dzIv+e41BvXcURJA5t+pY=;
 b=Q+RYzr6GdxTvUvBGERTbyPvUESeICRTsAGSTt7/5eAnKVKI5ku95m5SERX/xYv/QCwp5Sd+kx2p9ldPAXEpi5XUBEeOujBr3V8crgqEr8Ip09I/C/Y2Nkbzk+iXrL/VFKGKE0nVRZWvlMHcRT+441eEHax3pULQ/qvzItMg/suZLdjUJx9qn0yHD8RDcNsfb5loDfLh5j5KbUxTlyXtSaivHBmqNayYA2NF6+K0pOzfsuM6tR1DMfkjKElrUM4LdOfM0ZlL6TOa+euorzeRUPwjjCrF4G+dtkJLQukFADhFY2qNiDYjNY/ftdR+Rw1KUZZ4ZNXPW+5p7XHZ078wOxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 5 Dec
 2022 15:29:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 15:29:24 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 5/5] vfio: Fold vfio_virqfd.ko into vfio.ko
Date:   Mon,  5 Dec 2022 11:29:20 -0400
Message-Id: <5-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 19eb0f10-883e-43d5-bfc9-08dad6d57c7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9D0SVgh+V6AGJlRu44N/RkS0oqkqbfb0e49exL28EFdi9PdmyxOdSmdVdE8zuOl/x5H/n0jl4R8naHcLu2nksON6yBSPlyJNS+eJ1I0emsRh6ldkud+D11xYGTdOQgitS0zJIH8mNPyMtIi40juMg2BGj99aFupDUsteeCJg953cZ1vhsUlnyBl67T8RJWLPiw2dqd0ro/fA1+c2bKwJXSY6vDjmOQHCfH9vuEPF0T0iAMM+R2f/y8FS+R/ttkyIi3MbAObLDGnRQ5nBNlXuDLxTsBVd95JwnkyzEInsb8pD7wHocpRTnllKygjiZz7qT6kQuyHphMI/YdsIUHbyvUkzpb19y4yxwplEA7teVgzkFUEwGzHscBb1fU2nPGESmL633imTm+nND3KgCwdyoF7Cws1R6aPSSfAl6t6H5T8rwKweURMKoy3RUGiilsSQvJbKuVT6atdNUnOJZ+Pif7Hv2Uk08fl38IjQJ7JEywScj59w1Hq1nH9OcEdp76l2QkXRiNQyoWv878u+RkpuFL2eOR+6AWVuPHGTMALZ30DO6wwu/JqNaW4GfI/a+CxT4iiaRHs1RBYCkyRlxsJlDbdzJLaBEo91iYCtQ4vu1rvs/CY+IigkZvtDXSk6bAqg6AC4Cx1dKdVthlHbvnLjxbqX1znjR6uOFMmautaJQrN/8FG4IdjCv2eT1qxfIIg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(66476007)(36756003)(38100700002)(2906002)(41300700001)(4326008)(5660300002)(8936002)(83380400001)(86362001)(478600001)(6666004)(66556008)(2616005)(8676002)(54906003)(110136005)(186003)(316002)(6506007)(6486002)(66946007)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YuD6omAqgEQWpRqydwzYm9sqqaLjPFe+1EHrArU1BDsZLU8PLmN6dNBLwB6J?=
 =?us-ascii?Q?5PjHaCr2ciUP1ZxHcDVwTD7KmzATKEAwhcOHxMwzU43FUOQWBY2WCF6dbouV?=
 =?us-ascii?Q?YJBdZ99R1kEhL7tecNXtLqdnGmAX8YQUVKaWwvjDRvPRQ4b8wC7F0niAq62C?=
 =?us-ascii?Q?Jry5y6EXNo+DCi9I1gUUg/W/AH2UqI+/fVmf+57oiOm8KvfHbqq378vj7rye?=
 =?us-ascii?Q?d4tF5SqSqfP76hVpDY2hHVDCZIy4yWuJjj25iV2F56CNsjdCIEe/8wA//lrU?=
 =?us-ascii?Q?okXItn+hZyfTizYWgBUjKcbvwbirYJohgmXrvcPR1WsbYtLATa3EF+z3eB2m?=
 =?us-ascii?Q?Mm+iw4m0amGBCyt7YxEnAcmuM5B9WVn8tczVRM1/7GVXmUcrPWtIMKLAtJYN?=
 =?us-ascii?Q?fXnfYkZJmYUd8F/WvIyOE4XF4D0XqlUY3i+2t4s4KsdcW6g4VvTkUgJgbYrf?=
 =?us-ascii?Q?APGk1iho1vKVhWIBOYgOQNaqpxGLX+7/8CAHzzicOqLzd8d6LOIjWfswGd+i?=
 =?us-ascii?Q?1QTmic2XJ+e44FSeACA/xwsSG6T3zY1kHn2HyMRH7AR3IPTZV6Ulje3DIJhA?=
 =?us-ascii?Q?oEhAZfXX4EqtA/aJlVoYY+zhcYgnWOaUfWH2lz629DGLhT8fGLTPjEsW6qnJ?=
 =?us-ascii?Q?9KRUSN4PJnDzdfrJlzo8LsQVF6PjZTflzeYulU17n2PhtvDObzXOySjr0mur?=
 =?us-ascii?Q?YPAVOyN81Jvl0+q4ZyAQhj3SYSfOvBz0L/96G2UEfFq8z3XzHrFsScv40GqX?=
 =?us-ascii?Q?5HofH6Et16W5N1At+te//VMVU8CdU7+bWp8NhIzq0AhP2rprVlFCV8RroY5O?=
 =?us-ascii?Q?zgyjo/bZuEEHeNGIBHYXjMcOal/1OoNrrSbnE85EAWh6SEgsjl0hu67BoY6d?=
 =?us-ascii?Q?r55awEsOMCFkFHFs0w+faEn+ePi/PPajKKFD6D6ELVA5ApttCplYRiP7OlME?=
 =?us-ascii?Q?Dk8LKnTo4cfZBog59cBuS0AAZZMBCOPi1IsJjsLxIu1O2KV5ftayaRqqCzZ/?=
 =?us-ascii?Q?vJDWaYRC+7t0/KPwXNkg804X1AOvb6qDgSEdsvgXYmEJ32UTHwpTwA0a+EFy?=
 =?us-ascii?Q?eMjV3yCYsUS/DDgFNmdaZV1SqExzOKSKBXMlR8kEpo+01CW5/+czwKSm7t4f?=
 =?us-ascii?Q?N/Kvz+fiURXVD9tRg5hG2bRAUaL+oPXW06j9YgtQ6RGANUIxF4bJoRSWq12C?=
 =?us-ascii?Q?xirj86IYFsmOZPHyyj0HWum78q0ip/LZIdEB6T2tBjUIUBgKEGSQzAs212Cq?=
 =?us-ascii?Q?Nsrd3WpLJLF4jY9JAoEgZoLSYNswZyCgSd5DQcyRP4w0pjEL4FZ85FgTV1TM?=
 =?us-ascii?Q?Kt02YzeSaGNhJNw3v41nQymlD2sUtg/e30WlwU1tI8JXaT9xw1tlK7TimDny?=
 =?us-ascii?Q?yrwudjYnKNkD4Cu4+7xA8Aea4Mw9NCql6bbptQ2/EdnnKNtCHEO2G8WS3DfH?=
 =?us-ascii?Q?jW9cvuuPBpxzD4dQB3CtfdRvW6BKS9eJdtBTQAsmvQSbtgYUs56xP8YqICkS?=
 =?us-ascii?Q?r0O0ULQ3bqhVC37h5hitMF0/cUEoSyRuLAAhmEcIiHhwWkYIJLqVt/6rnsK4?=
 =?us-ascii?Q?AIptxaTNKe6QFjfNz1gxkI0KoGImjxu6R7tZxHjg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19eb0f10-883e-43d5-bfc9-08dad6d57c7e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:29:23.2187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snXNtsm8moEQ+tgCOs5nCQ9mLtlvLQMRe1YwyPrlNkQvjhoL5JIiFESv3mURogMS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
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

