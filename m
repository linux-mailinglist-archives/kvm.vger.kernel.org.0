Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8E55A300B
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344374AbiHZTeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 15:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245719AbiHZTeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 15:34:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDF6E0FC9;
        Fri, 26 Aug 2022 12:34:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbNN+NXxc8XNKyYaCJnCIIQMwZmBC6qxBRQxkjTQdBmf479L2dTY0wdPrwTATjTIlmGuz9EAePXKKltKA11uaY8Q66uXcKLJyisVoA8iRY10E8rBWPM29wMs3Ww9z4saagcH7/j+VxbdJTEtCDryaQj+kLjNAkqjpWfrq7XzJuwW8Q7aEFmPmq1Mic0VKrGezFdGg1lg8Ebyr5LnUVzoxHmqLuBNS/KfHWzCrIuwHPhSNFEkrDWagcVx8FKuSrO1e0j//Cw7s87bqq4DTiImr0rNmx7UUkEoeRghgSr991ZDyJfkQrSIjVSEnKqvhfHUSg2U7jw7p0stMmJMSefGrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2Ct3sLCpABvsDXEQaSA5siZea3HuQX2ymens2AKRYw=;
 b=KnbOz4EKVcHfAV3iIUgdobcLLh/TiyJk/jrjwo4PSIvtaXxMldOPNtOnh/KVNlDBiMzc2vZ1GOS5oUinv2IE5j11sWjcp4+hkI9Bokxd4SFUWhZFM1svY/gm3QMUylTPYKlv93QhZJ52tGdFZOF4qnSyPns3kzRtRNPR7Z/0vYToVDGtsYzwH01HyMLrN0hoLrAJIsx9lnSZEW+wLaBaCehvCHL/AL4g6xUDUHr42DgbKFygfmm7y+NXxt/cHgCcpH9wm5HGfqJ2EVFTG6CRdhzt2TMB/eCGQiacULGKQ7zVhap7ATcBZgb9cjFDe9iFDfvTirznKc+Gq4vu1bFp8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2Ct3sLCpABvsDXEQaSA5siZea3HuQX2ymens2AKRYw=;
 b=JJNsBsNMW+uRpWAs/Ormmk0y+xXzgmyfvWqTW7yzFnhusdBxI/Dg261TugW3jxwcvNzKga9hkFE5ZnLTZd5ZSWlAYDUtKr5tqm5f7WXjfFelVUMog+eeeraug2ZOk1J/FXmLUpBo830BcszfXyAID+hVNqsxxvOGrlFqnO1ZPS8jEMshKPtfbgK8hvIULtuOOhNMqhuB1PBCTk/Co7/UaSONtj8T3Klg6A0a2RyQHdDmCnxTwqVDngEif99lSjGN7dp3GQedACk/TdYkpSQthGdiqrQTmuaHQ9VlUaGxBGayaR1G+hgb06OHaPuNKRIF+Vm+TLv28W43XCV8lTahow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 19:34:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 19:34:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 1/3] vfio/pci: Split linux/vfio_pci_core.h
Date:   Fri, 26 Aug 2022 16:34:01 -0300
Message-Id: <1-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:207:3d::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14358f6a-7edf-4b53-b61c-08da8799efce
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uwm9ZKRG0qgFF77tY9/MnFz2YAzqxjijV0Mi0gCmjj5imlv7jcmBQj1hvmhKD3l6uP0I7Bda0An+JI8Q7XnEU1cdCxszfj3IJEU/YgApO5e3pzs8d3glqILu8mamdWXD7PQAOhkN8NiRdMmLGnRQZomnqv1sT+YQPMe0CFW50NQbW6p3+armfCTVfOvgT81I8QHL4RzGZaqFDcdN4OAzjF33yn2bgHRoo6zty8Ag8QRGbpDeCyqi+vfyck66bFPuP5YB4d2IGmEgkB/fdYFTHGLuvm8zx+EVbrLqt6g/klJK30e0cOgJwNM3ESi/rSX7abbBrf0ZUj8/yZ3nMDXrnPHe11GHxSX+FQikPDr+JObCMHantvEt1J/Ipq8yv2xMfVpozdS6hwYzifw5mieF0CfuWaD+cOXQJcGrMMfFO6sK/NYDtN/nQrhpA5Rbz8Zka5pgdPWr/oMzxZoK9Kxs3mFg/8mcoQGznXbDMI9WlC1ysbvIDLJnfnFl0eOPK/iv7rFFdxNPz7yBnb2b/CIGrQ1usjJWUMp2jvK8FT7hwOAlDXHAJitIsRha0PDsLCnInohotFfEu3HMOjEjXdrb1BRvUd1oYwjy7GQlXJ8FgJovRli5wH1o8uEwRLl8JmxReD5t3STlaVP9RSazlxzgfI+CzU+PEENk8KqoBlll72NwvxNfEJi95rzCtxj1bs7BQV/5mjKDzVSE+ukmk/ZNXz8DT0J+px2Qk/2M7m9KjgmjDgYYu/h0pbhrzudnKYRK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(8936002)(83380400001)(2906002)(478600001)(2616005)(6486002)(30864003)(5660300002)(36756003)(66476007)(316002)(38100700002)(6666004)(8676002)(66556008)(86362001)(110136005)(6512007)(186003)(41300700001)(26005)(66946007)(6506007)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ISN/lcLMpy5x1s3WZjRf0N6mU2s/7ZHXlxoaIogjC+Ak5J6jwmLdvsPJNz+o?=
 =?us-ascii?Q?tOYxmqKnismLODR3SRPQcPYNUh08xA4riycR0XYL7njPaIykB9XRL6K/TPFk?=
 =?us-ascii?Q?G0t5P4DBS2idRMtdU52pFEyeiyVqxHlck160ggSmVZT9f42hzAMqgYAlki+c?=
 =?us-ascii?Q?5og6qlgpl4wQq84rcPTHS4hnmUWMj78pRW/ULSODMCfS6wUdiRjbUjMH77uf?=
 =?us-ascii?Q?ZEkGRlt9kKBtcC0mQ7ODEvYDT6Yda4XeSxwp4WsR8IkgVFFU4vV85s7Gns2S?=
 =?us-ascii?Q?E2lGcSC0nmvxlSM5GblqlTNSEO0SFwA3g2i6fCPmNaQVUq++8lBc64lCC81/?=
 =?us-ascii?Q?4Ql9xk75rwpP0/XxIsp+Ss2vvKl22kLWzgXiEPqVfY18fvV09H0DxTi9wUvX?=
 =?us-ascii?Q?VX18OTbvLWkD7EYQXQGUoRnvNQchlSbEGqkV5fWHC5Oeu4UXwvLcLtirxBmD?=
 =?us-ascii?Q?qWHRQ1REKmlJScVXaCJSkStgTmt5A/NiG500kceQLpsey+91RZiyjETfwVlV?=
 =?us-ascii?Q?tpLcJT1/ksqjZ2DQXRYd70ApMHBwGTqUUunWyFjmaHjzOX1QK35Fp0YIp7Xu?=
 =?us-ascii?Q?ABPRtFlI5wDtYomFZtcSzWjNhi/ic6t7PJ36BKYqvikvG+MDJpAna89jfZG2?=
 =?us-ascii?Q?BugDIea4w2rNDnrNQuz9xiqlMWUIq0hdkzBPs9qjAheI3tt/diNmnZuo+bZn?=
 =?us-ascii?Q?yV3EEerDk3S8gvZeKx3O5H8JCAuqaDgdtV3MfkoT9iGneiCiewBmHkbuSKL2?=
 =?us-ascii?Q?i6uz07lhBwcJmYENYPkIueFeEP18pAceDTYwpzRHV009Aht4mBFCwMpKc6vi?=
 =?us-ascii?Q?j8NyUGaAKl8djUo0v9+gXWZe5p5P5ucy0cp3fjfoDt69EvxILX2rK/wg1dwB?=
 =?us-ascii?Q?ZaUkHRoKZfeBRHe6pvFWKLoi6Q1qScR3S6zQwysjsDHhgDg24cfHGNZPvofJ?=
 =?us-ascii?Q?vj1A+aH3OyFEHfbsyaTjhzoIX2LCMhxec/k00wtyN+GjEjyBv4/TPqtMY4Mh?=
 =?us-ascii?Q?NJ8L4LGaWBM+BZHcv976/x563KtXVL0G69CY1m4lf4SudNzZ6gsyaNjgMYbh?=
 =?us-ascii?Q?gurDpysFoWNJ3gZq5iXjpJKr+awCTU/WyI1hIc2O68xXEkgUOPuQw9eMRWyG?=
 =?us-ascii?Q?NEnkgkPYfeFq+M1QJ3Hu2ucMB4WX78jEz8ncKGe1WbXctXc7vZTp+u9IyBXi?=
 =?us-ascii?Q?Bb4vxQvH6kCH04WS0WQd+rD2ea1QWsDmOUulqPU10Y1AHW3G2sY3v5Q4Nv26?=
 =?us-ascii?Q?hWMd8BllId2fjSLUVMMz1o1ioF4MqSt8ypamXlK7vlcmal82iDM+gnKkTlkk?=
 =?us-ascii?Q?kNyqV6i+khWtaTc0PyNd7v4BnYmsDCriJs3caxGu2yMCLJ8OJ0CmkismK1CB?=
 =?us-ascii?Q?R8PI3h8qkh4FEGZWv68nSSI2oYSAE6qtHhNUTKlvIGtj12cXDKHKUwA94JaC?=
 =?us-ascii?Q?p9zWuvddY1W6CD/RgobU1UBPYGoLmArxBU+HkAhhdjGzve36HXmXflwzYXfr?=
 =?us-ascii?Q?pS8oiVCO+V3gf3VGTe8dCmZOXXpei1lKV1wbeWARPLF20fKs8m9OxTbOEdVQ?=
 =?us-ascii?Q?Ki/2RlrUoM/wPLCMTR5eEX/h2B56v+XU2SLCs+0j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14358f6a-7edf-4b53-b61c-08da8799efce
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 19:34:05.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXT/v2NFu6UUAcaXpX5rFGIyFA0uHCuho5YHqvCeV8CU9OvWFIfj5rAOnc+Sao0n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The header in include/linux should have only the exported interface for
other vfio_pci module's to use.  Internal definitions for vfio_pci.ko
should be in a "priv" header along side the .c files.

Move the internal declarations out of vfio_pci_core.h. They either move to
vfio_pci_priv.h or to the C file that is the only user.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c        |   2 +-
 drivers/vfio/pci/vfio_pci_config.c |   2 +-
 drivers/vfio/pci/vfio_pci_core.c   |  19 +++-
 drivers/vfio/pci/vfio_pci_igd.c    |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c  |  16 +++-
 drivers/vfio/pci/vfio_pci_priv.h   | 106 +++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c   |   2 +-
 drivers/vfio/pci/vfio_pci_zdev.c   |   2 +-
 include/linux/vfio_pci_core.h      | 134 +----------------------------
 9 files changed, 145 insertions(+), 140 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_priv.h

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 4d1a97415a27bf..d9b5c03f8d5b23 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -25,7 +25,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "VFIO PCI - User Level meta-driver"
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 442d3ba4122b22..5f43b28075eecd 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -26,7 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/slab.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 /* Fake capability ID for standard config space */
 #define PCI_CAP_ID_BASIC	0
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c8d3b0450fb35b..04180a0836cc90 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,7 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC "core driver for VFIO based PCI devices"
@@ -41,6 +41,23 @@ static bool disable_idle_d3;
 static DEFINE_MUTEX(vfio_pci_sriov_pfs_mutex);
 static LIST_HEAD(vfio_pci_sriov_pfs);
 
+struct vfio_pci_dummy_resource {
+	struct resource		resource;
+	int			index;
+	struct list_head	res_next;
+};
+
+struct vfio_pci_vf_token {
+	struct mutex		lock;
+	uuid_t			uuid;
+	int			users;
+};
+
+struct vfio_pci_mmap_vma {
+	struct vm_area_struct	*vma;
+	struct list_head	vma_next;
+};
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 352c725ccf1812..8177e9a1da3bfd 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -15,7 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6069a11fb51acf..32d014421c1f61 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -20,7 +20,21 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
+
+#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
+#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
+#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
+#define irq_is(vdev, type) (vdev->irq_type == type)
+
+struct vfio_pci_irq_ctx {
+	struct eventfd_ctx	*trigger;
+	struct virqfd		*unmask;
+	struct virqfd		*mask;
+	char			*name;
+	bool			masked;
+	struct irq_bypass_producer	producer;
+};
 
 /*
  * INTx
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
new file mode 100644
index 00000000000000..ac701f05bef022
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VFIO_PCI_PRIV_H
+#define VFIO_PCI_PRIV_H
+
+#include <linux/vfio_pci_core.h>
+
+/* Special capability IDs predefined access */
+#define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
+#define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
+
+/* Cap maximum number of ioeventfds per device (arbitrary) */
+#define VFIO_PCI_IOEVENTFD_MAX		1000
+
+struct vfio_pci_ioeventfd {
+	struct list_head	next;
+	struct vfio_pci_core_device	*vdev;
+	struct virqfd		*virqfd;
+	void __iomem		*addr;
+	uint64_t		data;
+	loff_t			pos;
+	int			bar;
+	int			count;
+	bool			test_mem;
+};
+
+#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
+
+void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
+
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
+			    unsigned index, unsigned start, unsigned count,
+			    void *data);
+
+ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			   size_t count, loff_t *ppos, bool iswrite);
+
+ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite);
+
+#ifdef CONFIG_VFIO_PCI_VGA
+ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite);
+#else
+static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite)
+{
+	return -EINVAL;
+}
+#endif
+
+long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
+			uint64_t data, int count, int fd);
+
+int vfio_pci_init_perm_bits(void);
+void vfio_pci_uninit_perm_bits(void);
+
+int vfio_config_init(struct vfio_pci_core_device *vdev);
+void vfio_config_free(struct vfio_pci_core_device *vdev);
+
+int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
+			     pci_power_t state);
+
+bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
+void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
+u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
+void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
+					u16 cmd);
+
+#ifdef CONFIG_VFIO_PCI_IGD
+int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
+#else
+static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
+{
+	return -ENODEV;
+}
+#endif
+
+#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
+int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
+				struct vfio_info_cap *caps);
+int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
+void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
+#else
+static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
+					      struct vfio_info_cap *caps)
+{
+	return -ENODEV;
+}
+
+static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
+{
+	return 0;
+}
+
+static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
+{}
+#endif
+
+static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
+{
+	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
+}
+
+#endif
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 82ac1569deb052..d5e9883c1eee10 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,7 +17,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 #ifdef __LITTLE_ENDIAN
 #define vfio_ioread64	ioread64
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index e163aa9f61444f..0bff24f0d4d717 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -15,7 +15,7 @@
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
-#include <linux/vfio_pci_core.h>
+#include "vfio_pci_priv.h"
 
 /*
  * Add the Base PCI Function information to the device info region.
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5579ece4347bdc..9d18b832e61a0d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -20,39 +20,10 @@
 #define VFIO_PCI_CORE_H
 
 #define VFIO_PCI_OFFSET_SHIFT   40
-
 #define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
 #define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
 #define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
 
-/* Special capability IDs predefined access */
-#define PCI_CAP_ID_INVALID		0xFF	/* default raw access */
-#define PCI_CAP_ID_INVALID_VIRT		0xFE	/* default virt access */
-
-/* Cap maximum number of ioeventfds per device (arbitrary) */
-#define VFIO_PCI_IOEVENTFD_MAX		1000
-
-struct vfio_pci_ioeventfd {
-	struct list_head	next;
-	struct vfio_pci_core_device	*vdev;
-	struct virqfd		*virqfd;
-	void __iomem		*addr;
-	uint64_t		data;
-	loff_t			pos;
-	int			bar;
-	int			count;
-	bool			test_mem;
-};
-
-struct vfio_pci_irq_ctx {
-	struct eventfd_ctx	*trigger;
-	struct virqfd		*unmask;
-	struct virqfd		*mask;
-	char			*name;
-	bool			masked;
-	struct irq_bypass_producer	producer;
-};
-
 struct vfio_pci_core_device;
 struct vfio_pci_region;
 
@@ -78,23 +49,6 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
-struct vfio_pci_dummy_resource {
-	struct resource		resource;
-	int			index;
-	struct list_head	res_next;
-};
-
-struct vfio_pci_vf_token {
-	struct mutex		lock;
-	uuid_t			uuid;
-	int			users;
-};
-
-struct vfio_pci_mmap_vma {
-	struct vm_area_struct	*vma;
-	struct list_head	vma_next;
-};
-
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -141,92 +95,11 @@ struct vfio_pci_core_device {
 	struct rw_semaphore	memory_lock;
 };
 
-#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
-#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
-#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
-#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
-#define irq_is(vdev, type) (vdev->irq_type == type)
-
-void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
-void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
-
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
-			    uint32_t flags, unsigned index,
-			    unsigned start, unsigned count, void *data);
-
-ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
-			   char __user *buf, size_t count,
-			   loff_t *ppos, bool iswrite);
-
-ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			size_t count, loff_t *ppos, bool iswrite);
-
-#ifdef CONFIG_VFIO_PCI_VGA
-ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			size_t count, loff_t *ppos, bool iswrite);
-#else
-static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
-				      char __user *buf, size_t count,
-				      loff_t *ppos, bool iswrite)
-{
-	return -EINVAL;
-}
-#endif
-
-long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
-			uint64_t data, int count, int fd);
-
-int vfio_pci_init_perm_bits(void);
-void vfio_pci_uninit_perm_bits(void);
-
-int vfio_config_init(struct vfio_pci_core_device *vdev);
-void vfio_config_free(struct vfio_pci_core_device *vdev);
-
+/* Will be exported for vfio pci drivers usage */
 int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 				 unsigned int type, unsigned int subtype,
 				 const struct vfio_pci_regops *ops,
 				 size_t size, u32 flags, void *data);
-
-int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
-			     pci_power_t state);
-
-bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
-void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
-u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
-void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
-					u16 cmd);
-
-#ifdef CONFIG_VFIO_PCI_IGD
-int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
-#else
-static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
-{
-	return -ENODEV;
-}
-#endif
-
-#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
-int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
-				struct vfio_info_cap *caps);
-int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
-void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
-#else
-static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
-					      struct vfio_info_cap *caps)
-{
-	return -ENODEV;
-}
-
-static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
-{
-	return 0;
-}
-
-static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
-{}
-#endif
-
-/* Will be exported for vfio pci drivers usage */
 void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
@@ -256,9 +129,4 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
-{
-	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-}
-
 #endif /* VFIO_PCI_CORE_H */
-- 
2.37.2

