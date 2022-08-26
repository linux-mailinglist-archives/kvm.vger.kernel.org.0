Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB725A3010
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 21:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242903AbiHZTeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 15:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHZTeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 15:34:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777E6E0FCC;
        Fri, 26 Aug 2022 12:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzjDI7GWdAAuDdQWCvKVLYOLGVqdYl1L0YzUgPN79txC0c65Q7SaHGX5lcKKjtf8NGQB1x2/qh17FpCrrtcHP5QhDOU92hX9t9dY9E6sk9euF5AXS+M3iC/xIXHsjP2TCZ9nxCDdsU17YzR6hDpzTx0xDV9o1vhjDBJ46AWKMDbrtnVmh/QpQO/yxaWB+TjDho4gbncqbRGovaqp0aNr/cfZHQ2PC12pGkCC/teyo7OgybLZroCMWhXvx1mDhwqrwt/CM1BzK+TNQONaunUAtrxHyWoB+iTXyuALo19HBVSZBi8nt235aPpWSOvtiHGPzihwzJb3XYXIyoroNsw21w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IU8HuPyqfzgR7AoVDXAl4Gb7oZdqhbQX6tOkCRoUKao=;
 b=fmYEhz0Xu4HBhZOxc3rqtIhE0zSJvMgZNON4DNjcgR+1sZ79LlT59cc5l3TEYkasYh4DNdwOSS65QI+/LxKfrzIEHnAOC0AfXe5WfQ+dvLsn6aGOATISNWI397s1coHFTJ2cUqqmbXOPCz8ym0gw18tcqgoTNQQzUbRiOy7yrckRXO+OUtKte4ghFRlcPkSbS2yt2mUv9VS/CSetBloPocWwR1Ra55KsNLkpfseQLRGeZAFOcshc/jzhcNo96Ri+66jODXhBCTZRcNpaJr5PXsjrWkmSzBDWFMho+TAV1s9x4C+ndoJW2ptuzT19NXx2qPUUwXt63sCxF9Ho7P/yIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IU8HuPyqfzgR7AoVDXAl4Gb7oZdqhbQX6tOkCRoUKao=;
 b=F3XF9YUjV32OdbwZge460zBw7L8wL71PTbKvGIgM/KX5eehncZUEZ5t3pJeTsjJRuNNvgvuJY6aaPklv9W5BgUS2TROLnv20gyD8uPvmrrR0W1AJKcb35paxRgwBogtWojtoYWWf7q6VPQwDOdDTyJeU3462UflADMNSqklYln5OXgUIBo6dxDe9jaA2fxj1n5qLD9SlNn4hQCjtfdBgUcBgSOlFy5lNN7sXCZgYL3QNaqUOYuxNVAt7HDTv5zFUELfdOGmKX0dkALiOV077vkmLvht20u0QFvqw2TQLtAlfUjBH8ao3ZvS58hVO6PvcnexaFqbNh+YKv0AHCi4kvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 19:34:04 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 19:34:04 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 3/3] vfio/pci: Simplify the is_intx/msi/msix/etc defines
Date:   Fri, 26 Aug 2022 16:34:03 -0300
Message-Id: <3-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0060.namprd16.prod.outlook.com
 (2603:10b6:208:234::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4870a5e-e7a1-4528-1d7c-08da8799ef3d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVddwLyqytG3oESlP6dN/hOcWoTTTw1SzTMTQD/COTxB6kAX7GvGneu7iUCKOImLmrNVHPN4AFcrayPm1hCBJ9i2SIWCm0BXsxmUZM1dpTusKPaXql8K3TvedpRyKIcbEsQS4YyRwiFo/IXWjEYl0F6theirSwKiquHVVpUHzX66kDeZjqbS48cU1hB9OSRCRnUui35zCtgVIZGkw6KKStWi9ozEK0XquIoPgYHud9qhMkzuvoo1Hq2PsdDeQWSujbdstFRsoXj/YeRmlywXALSKmOlSy5UwR2IqYYiXSUD11xU2qTCPPjldHmsNGfxiAaYFn/Tp8HMHt33dLlV1z6usgpO8YbV7VPmKA2cQkdmj1J+WPodw9I0E1h7lUmE1q9OWEDcXnrlch3OkJ2Rahg/dno/juexfujJ7FmxUf/PhEmNDZPu90WtpzrG3ZfL8OjcM6QGrLwch0A5P4tur7xD0qcgtzyMd7rG6zmO4bgZ1job5cJztiBCW7Asm2oa3r3vAQakjbLmkpiTalv9l7RzMwYA3lfB5ep1oDIHp+30+bzGbUn96zT7EqDRUshnS8WIRqlDXxUOLTokVnYWSHqBgAEKiY95N3pc8xVRTVS4jfpakQdyP3vsrp5pnsjV7VqZNI5ly6l4GEEEWTdSsjjM6+J0qNZa5N2OnbiasqU5CXyCoiqabQZoQYwTZttOeV8AO0qhQEtWO4PPMX18+/ycML5GGHZPYa2e/mAKTghKJ5AUC3d3U5MBWzcjyAlYj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(8936002)(83380400001)(2906002)(478600001)(2616005)(6486002)(5660300002)(36756003)(66476007)(316002)(38100700002)(8676002)(66556008)(86362001)(110136005)(6512007)(186003)(41300700001)(26005)(66946007)(6506007)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C/QjM0u0PzO3wDz11U5MfCoFfonV1IQh2IRcWaqAo/qABRIV1nfkpNJWkSsq?=
 =?us-ascii?Q?i47L6jkhiQDvfJ+34FgVLF2Ej+wWEaY8bh2ja/hmpfBn8c66UA9KMl2U/VSy?=
 =?us-ascii?Q?t2H2Sh2jXwyS27PuBivdgR0iU9eZfWhELUoWGkAiyNw492kA3oMHo86v6pga?=
 =?us-ascii?Q?N3uW3kQC9oKaxjAqqs1RUVmWE/kvoycnejJYoyi1IAXJlPAIH6tehztDEsSU?=
 =?us-ascii?Q?nn3RxQcD/i2HEk735rayt96vzRar+klbFQ9SIp/ztlLFynG77r2pUpVuLP34?=
 =?us-ascii?Q?anbjCQQJn4UUtQtkldrtit/jEEb+sfUPsxQuNi7DAdbrvdNXWQXZ0sO6F83i?=
 =?us-ascii?Q?8VkpgfZcoy0NaCw8RiF0eTZhp0XKrHTBIRlhXh1CZ8JUhljRxF0SBdJ0tHd8?=
 =?us-ascii?Q?CnuoLqtPvsz7T4ZbBYxiIFOrDJ2g/dltBNNxjxsYFEd6lMwiTXmM5+s4Xwx8?=
 =?us-ascii?Q?aNLL+lO2tNzje/swQHbPZZYipN71biei+L/LKR1uoKDvxozDxBINNEal95Pd?=
 =?us-ascii?Q?QXsbitJrFETeZfQtkW1PClgBABvJKVYvaCFQ3BKaSK1Xzr/sUDPE+Ebfzxyz?=
 =?us-ascii?Q?Om8AjvxB20cF6v2BVj2Uh0AAO8To+XJVB++LqL5Q3nHPEzb7Edz8okpWfpqT?=
 =?us-ascii?Q?qS0m8yUvIWK3KZrLa2vESHvtTAahhPh8F+ywM74vfOLMyMwDCVmMl9DGDF9I?=
 =?us-ascii?Q?6+8MRpcW9mfwTbPaLFiOYpVPePtPe7nYUlP3UvWCu08bNO+PcqmK4EIP9BC7?=
 =?us-ascii?Q?ynm/EVEwQ8XcsCi0r+dJa0zzRWQ0dgKq6X6CCnxg7tCcMDFjcnbZvlASVL4Z?=
 =?us-ascii?Q?a7q8UXgNh17FO0SiwgN1SraZN5wjBkNIx/fObT+bw5m88Arb3YXlvP2l5WKs?=
 =?us-ascii?Q?mWZ5Y23jkZfVnq/ahaTe4gBX/xyJtq95VeSVfJJoA5Y73xg7HoP63H85KRxJ?=
 =?us-ascii?Q?FT38NlL+KmVlcn4q5CzXTnFsfE1AFTBB4fzKu2DWCrCo7KCWarESVgNGqyay?=
 =?us-ascii?Q?ccRcCLlBpg/8iiVyQk/TeUDatsXWc9g9DLqg/RJDi7gfblaRSSBZwgKVdLet?=
 =?us-ascii?Q?uv4oZrFtLZ1MRip7VHWCnXz4w5ysuQgl7Yt8PQRAfe+/tVz1mhji78fF6rOO?=
 =?us-ascii?Q?R3VNg18pJVbkdxZlnfbOSL5OOeDSU1aWnk/FByD5MMwSNFn95c5KN+UlxYfI?=
 =?us-ascii?Q?K88/BwxeiaXwWNGb6oJpwodVFNcXqgyDTTqv3KoR5sNTswgyxUb5rLTOfN7G?=
 =?us-ascii?Q?NIL5CyhehOeuNUjizAs0yP6crxvJmg5aj/TkrYXN3nZ6uaAfkY9oRGwm01y3?=
 =?us-ascii?Q?kEIwL8jYmFXhz8maMY5GC+P12tgfykLWvT01T4T8qU3w3MFaAYFldbqdilLy?=
 =?us-ascii?Q?xNa5k7g2uuQQtnUicY3vFrs4PyMoIzLZaAy9IgAeur0xJlOflGmH+u+iukpM?=
 =?us-ascii?Q?VhQIc4j9BTZx/v3zPiPzP/MR3BhBaFD+33DsbXT13toMgvPmr5yLNog9ZJNd?=
 =?us-ascii?Q?85C+bNh6YGDR9PHu329i5mkA7Wla7jQLuv86vvNduTFtM8SeK2b96ZO75P09?=
 =?us-ascii?Q?t302SfpRBrFcZqHSAy9HKmCNeCVf1oUUh8mucInU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4870a5e-e7a1-4528-1d7c-08da8799ef3d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 19:34:04.1739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+tBDBYP1Iunb73sYXD8maCmUDc1DScm+4QbuctQ22mgsEoVSfxF5IedbbXd9oHY
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

Only three of these are actually used, simplify to three inline functions,
and open code the if statement in vfio_pci_config.c.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c  | 22 +++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_priv.h   |  2 --
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 5f43b28075eecd..4a350421c5f62a 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1166,7 +1166,7 @@ static int vfio_msi_config_write(struct vfio_pci_core_device *vdev, int pos,
 		flags = le16_to_cpu(*pflags);
 
 		/* MSI is enabled via ioctl */
-		if  (!is_msi(vdev))
+		if  (vdev->irq_type != VFIO_PCI_MSI_IRQ_INDEX)
 			flags &= ~PCI_MSI_FLAGS_ENABLE;
 
 		/* Check queue size */
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 32d014421c1f61..8cb987ef3c4763 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -22,11 +22,6 @@
 
 #include "vfio_pci_priv.h"
 
-#define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
-#define is_msix(vdev) (vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
-#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
-#define irq_is(vdev, type) (vdev->irq_type == type)
-
 struct vfio_pci_irq_ctx {
 	struct eventfd_ctx	*trigger;
 	struct virqfd		*unmask;
@@ -36,6 +31,23 @@ struct vfio_pci_irq_ctx {
 	struct irq_bypass_producer	producer;
 };
 
+static bool irq_is(struct vfio_pci_core_device *vdev, int type)
+{
+	return vdev->irq_type == type;
+}
+
+static bool is_intx(struct vfio_pci_core_device *vdev)
+{
+	return vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX;
+}
+
+static bool is_irq_none(struct vfio_pci_core_device *vdev)
+{
+	return !(vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX ||
+		 vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
+		 vdev->irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
+}
+
 /*
  * INTx
  */
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index ac701f05bef022..4830fb01a1caa2 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -23,8 +23,6 @@ struct vfio_pci_ioeventfd {
 	bool			test_mem;
 };
 
-#define is_msi(vdev) (vdev->irq_type == VFIO_PCI_MSI_IRQ_INDEX)
-
 void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
-- 
2.37.2

