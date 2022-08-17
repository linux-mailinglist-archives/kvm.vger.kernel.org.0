Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BED5972F6
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbiHQP37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiHQP34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:29:56 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D50844D0;
        Wed, 17 Aug 2022 08:29:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocxhO0xO3FeGAI14sB6l90r9FTdxwqmIykKxQGZt2U1v1NmXbTeJMU9VN6zU9fWUKttiQCvU/XDehp4adEnP6virwdpUMBAj9rQpTeUaXwwM7bg978loEMbU/LrWCQCXKfy6gM3zm5qfipWkrsxkm507RcflzGCLsYCeduKxy9hJHEeOlukVFSHs5tu8TQyiPKxtLUpH6OZgvgE4zMVOdjwYnssiU7vYHR7V3jyZp5kQJUYY3WzbXL+1CpNRWHUL6as2lL+RyO4d+OIu6efhuVfUN4WqbiKB2VbkIA10OqdYE3JZ1lgtod1JuWKHxOwmYhPXVBh1jwA9QTn4oHji+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y548jWcaZcM5VmVQm9rocu7vRYhItXzCx/f6JWMcheM=;
 b=DPH0DugXMgGvCDBZeZJZQuQxIhODfWztGa1cc5cM/aki7XyszNYSi/tB+Bm/sb8+xgIUMh4upF8zrGgZqlwRjiGjFllVH5+3D0n6Mh7Fp8SAvlJ0+DAEey/2GlzWf1DSTuULZDAz4untceUY4T+9/HHqxdo8PMnOc1VOLuavw0/VXxrGqxDOr5BFl2eMwucZlsw/9zcLYcHvyXY5EC43ViErA6JgBfOoJKaiLgUQRIa8XOZmYInwsiAdnWOrpHPRoCXUKy/s43XeGn6tE14gOq4s1ukkbX5XO5JTYL99fvnRjSecJRGMMSjViKIyUcFSYzS/MuQ56QF82ei99v3yNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y548jWcaZcM5VmVQm9rocu7vRYhItXzCx/f6JWMcheM=;
 b=clCciC1P9ouh8DR0+HiOp+LQxQhdWKK0radLhhKUg6Sg1SFrHyVXZK28vCSa/CYjPmYXoVg8lpCXTHczaRZ8/qdkOOnsim1Oi72D/+DWA2Tdl7ffWOjA3QQo0yf/6JHHco3sYqiXH7EU6LMAal62xvmvge2K4Fbyv4C+x7KxG7D4tDOXC8U5kXvztm3fMPvrOBpPaA3kUEVs2Kq9NLcbJU/NbMQxq0857KWT7O70XOe3u0jbf52EMDqAoqi19oiIfz6Jyp2AKXtOU5xMegLZtNs67kwtvAug1oIDsig/aTyoMZmLOiCh/SpcylVA6VDXo7Bx9+sYYPo3AKj0E78b7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3689.namprd12.prod.outlook.com (2603:10b6:5:1c7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 17 Aug
 2022 15:29:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 15:29:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 2/2] vfio/pci: Simplify the is_intx/msi/msix/etc defines
Date:   Wed, 17 Aug 2022 12:29:51 -0300
Message-Id: <2-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0373.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbe7fe88-9d31-44f7-9d29-08da8065547c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3689:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKcvv6HfO74Y3oxcEeWvfz8jD8OElkIIIvEm/TupUDo/ysd97zrjiyrZE4rsWxZzSCK9620DVCmuXiTieparKDcRxnqc38da8qpAnzXZP2rimVNHPQByPLu7BNMHd34RgHK2DYlxnt4VhxhktnnpSBWKN8RT4pR/2egBUYn0bcTvx5i4pIsj4ssjRCK4VBINTBaBm4/Q0xLINZ5DNBXF2cOHbQIozg80fOdpevOVT+PqVexHwsXWOUOL2/6NRk60O9r7KeF5e/irrTgteB3CIHN+F3B/h8fg74HGgNNpie177EiYQRuzTFPspG98m2GTeWfC0rzDK2uY+d92xPdX+wbMHpXJRetR5W8XhxmOHl/K4HCkHUOO7zbMe2W4Jsrn+aYX0wZG2v5Nle7Z6VuFwYTj/AkL7schz4uXxukdC5HV3wBCeonMB6lI9FkNw+yBn7hcno6zAZYI66kPF2J+gFG3jecCUNakcIjNA1XXHsc4OxXO2THe+OaDgQrKtkGEIDyJ4/ovybZXb/CDCJVdeLsRtva+QsKBYXToUGDpgQMyurA9LVkz7Ax6ZMS23uKdY4Mz0CRtJEdV+U0Px11dMfCk4CyAQlTKttfxb6BilskTHg08sVu4ILsh6BqadQuk5BjjEV8g0vegRcQ0vxkmoYJgieTXutDcwGYz4rqtV0CC/qwjK7Ne553Z7CK4AHwnUjh9WofHz0CSCJF00PR+/QSelgO9O3FDPPV9mvjHeRIeUGF7JiAsAs83lph2/AHSo4yyPxg5sh6MgP4zNU9NeeObta8nfEz8CEnGOnqZRfs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(2616005)(66556008)(26005)(8676002)(66476007)(316002)(83380400001)(36756003)(186003)(6512007)(66946007)(86362001)(5660300002)(2906002)(8936002)(478600001)(110136005)(6486002)(6506007)(41300700001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?45CZshk/MXsAvMtEOyKmQUvFJmTQLFTSMoMu7aI0kTgWZVCdVyjdXzv6SRON?=
 =?us-ascii?Q?krfXerHwLSwpybaTn+Av7dolCRrKJiLhCPEb7SYUEAoCppxNs/Mb09KeQ7+n?=
 =?us-ascii?Q?zsRG8P50i9i+a/QnYoHjFt6VLfhpA8ir4r9oudL0+cJEyrMmB0jVEgUh45GV?=
 =?us-ascii?Q?f3RkroJ7ptUPiyk/SgXfAqZ/wwJ3psf0+v5DAu+6xru2BTgC7NtX7j5/N1Pl?=
 =?us-ascii?Q?iYBNGTd/tQE1frxB0bMShtsSJuNjinsKpB8AdvZ4aKANEWHK0veoh9QMlEP6?=
 =?us-ascii?Q?obdYN0bT2sHvU4fiARLn20KwSostmQC8c4x4Mn4ow1buyQVguuR+aPdIFM5d?=
 =?us-ascii?Q?w/WYr5EOkCy9W3CpFAK9VK4bLYQudfJwwV3xx53YFbwg6C/YB/cfgjVCN/U8?=
 =?us-ascii?Q?CDzwUONIUXw4loiN5bClGvZ41QE1NZZMNn/0QYj5r9dbc7tAYboFruuqWgam?=
 =?us-ascii?Q?FQcHZgtu8BCzx+ait1BTg0lW0LDyMDitBuzOZMErPiuvK9S61LQvwA5jNScl?=
 =?us-ascii?Q?kcN3w5UEMrzVX5IAW0qudN/7OF63k/FOsD4zGIjfvZXt+wELNm3ry1NiXDEU?=
 =?us-ascii?Q?9qR8JWW3/2FrE8/eEX5+zdJf9BiEw0oC9dLHpAjMKJcZUrQnTwJLiapFksFe?=
 =?us-ascii?Q?04eCA+vax2lJBwMkSwyJC54woIG0QRRYfghMnjqEfXav4Q+sdRfqN4MPZxKa?=
 =?us-ascii?Q?pNghHzuI7S6TXn5JcDLHdfe0qpVg81wUsIuwDIM9zf687bW1+mkNw0sxTLRP?=
 =?us-ascii?Q?UHiIqtA5aDuUEV76Y/6+hMygA++72wjnF7P5CaUGqHwps+tpsDLxj0LNXbxg?=
 =?us-ascii?Q?NEwSJNMZSROOHKjA8Gib/TFQ9UsvrbEc91usyAcVRnFTFhgTs+7gNwjhUVGR?=
 =?us-ascii?Q?1oOGYJweGzUGzwmAsxPzGIffR/6MLyj/pGGPYX20udx6XCIWfd2O2o90dpp5?=
 =?us-ascii?Q?loGoUIHO+dOWNtlX64L6zptshaTyfK4Gh+NE93AbSAJyGuLOABSAGKntYyRu?=
 =?us-ascii?Q?Nbi6WnXjPmuZoFv6Ll/QhXSt8ASqP/b7QvWlnx1ud5XUGqpsY5dvVSoL/gxJ?=
 =?us-ascii?Q?kaeoFsTBM7EIuthfZXPuFlgfTTSthwv+3kq/d3WxB9+2iT60kxVLpyL4/F4f?=
 =?us-ascii?Q?jVPNtHLOZRpQp26zmLGLaO1/uQCIzmnkKQPepOOgkpeJL+Z9qcX5qTDmYpZ+?=
 =?us-ascii?Q?jns42RAOA3tRJYJqtoIQYeRmOxLp4QL8RxMRBcQ5ZEK7R9rGr/iVojaMvcoY?=
 =?us-ascii?Q?lxLQB3pjuLEM8ej76B9pyhF4ttF5y+/Hw4wyruYunGrkQsAZkounjBC18kOu?=
 =?us-ascii?Q?sUyCNuLDmPLFqHbCUgXQAW0Phg47LO7XjKitzAHu78xIESTyvafx896Q50UX?=
 =?us-ascii?Q?w1YZH5lCzbHDo7s3MYqHRAlMxtDEAQaJ9+Eh/1tvTmHivL7NJt7+ZTvjngGP?=
 =?us-ascii?Q?xycI19I14HJo/SML3Uersr1ONvekatgweIy6xK9hvLyEA+mkTnwdg0QKlPn3?=
 =?us-ascii?Q?35zLByBtXkIDhNWQAoKcLZfKhq2nLaEEq3y5l4iWaQ4s1nONJTlo13xHSfpy?=
 =?us-ascii?Q?NJzlV766ONJjp5msIRgLBIJq0CIuvlgPndg6+yR+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe7fe88-9d31-44f7-9d29-08da8065547c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:29:52.6663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfW+6x/SVJMzglXl+YolE588Dh8fV+AELmWI4U7u85XygaSFs/MEMfWIqo0+N6ez
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3689
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only three of these are actually used, simplify to three inline functions,
and open code the if statement in vfio_pci_config.c.

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

