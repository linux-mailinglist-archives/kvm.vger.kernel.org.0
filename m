Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B557A9675
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjIURD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjIURDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:03:30 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A05182
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:02:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+z4s/cEK/1doRmsNqukFbh88GsQGAKeQkgwfeWf2m0ywIoYL8BE4txkFSmTAwofeRFFL4f2ZiGPdJzdPQHEZUExtGFBBVw8VKe0hHjeMES66p1X22tr/4cAeD1k0iumf0zmYDt11yokR6el2Kee+mf16iICHxoQVWcNXQlgY/pymWFB5T/DlEo8ek8nLBdg3GF6gr+aPUR5M+7KO9Xq76D5Kg3TFzri/COpgRcVugABTlKUyF/bFgtWTH3CT88uTlV7AAo6YWwq/jLyfHbZuYFusv4mD0eQAn+8FWyppmPbj5BIMRD7VGK6/XNM9CDvlI9UID9n0q+CVt5WzdGXlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8W3p89QAltRZ1zWi8LhOhIMZebEugb+OQMBXR017KHs=;
 b=IfX3QX6Mp5WwfIPi8mMpAvdF23c1DfAUBs/cwxRMMDsn0ZSVJDPe+RjFRVCHjY2FBidXIvARhZ64zHDKGYdcZzG1/QVT9Fbx27JwcDQSuaoaN3t0LyDWlSUys1J3z7Dwib8YxHe7+tnmngpjvLsNUsFbGLQrZWEBDhJBjo6yu0E1TO/v4tph1TxOEeNxh5MQQypaTxXDbtpmwUeScJwgg1elOR5drsYBkoLhtPnh3MaBtOVCA5qUeXt1negQ/TS+DaL9M31oT6fGzPSZmxI3GJ3nCJtGR+nsfafUvMfUNexaULQWZbzw1Kgni5/Q8Yx9xKhW1MXf2bDUlhqtza6B0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W3p89QAltRZ1zWi8LhOhIMZebEugb+OQMBXR017KHs=;
 b=fD+/evmOFbw3UDjcHgAz8FBpo6vO7QII015XfF2QB4xc6tO/g15EeGkEZ1e2/gKFhVw+EyvfkjLnMoIx4mQhX++IhLT+ByEhfms7gxsvXAe+Nw4ziIpMF5R5NaezHqropSvUQtxeOZvcvpxyJYZtLkAtDTUcZEnt6+LjOz9hmZqzcn85+jQLvlHCujvdT/uViaH5ByeS7N7kkvAAVIycUWZhKkPkUHEgnArVDvisX1VtbaUmdI/99QBKI2zxbDOeAAZVO6dctmOP+a3o5ojHRz90A0pV8PGPxxBRu6o1BousuT+CQbjH4u5valq/jVXiX18Dc9ZRe5a+ZjvfIN1Dhg==
Received: from DM6PR06CA0065.namprd06.prod.outlook.com (2603:10b6:5:54::42) by
 SA1PR12MB6871.namprd12.prod.outlook.com (2603:10b6:806:25f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 12:41:35 +0000
Received: from DS1PEPF00017094.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::2e) by DM6PR06CA0065.outlook.office365.com
 (2603:10b6:5:54::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31 via Frontend
 Transport; Thu, 21 Sep 2023 12:41:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017094.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Thu, 21 Sep 2023 12:41:35 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:27 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 21 Sep
 2023 05:41:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 21 Sep
 2023 05:41:23 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 01/11] virtio-pci: Use virtio pci device layer vq info instead of generic one
Date:   Thu, 21 Sep 2023 15:40:30 +0300
Message-ID: <20230921124040.145386-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230921124040.145386-1-yishaih@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017094:EE_|SA1PR12MB6871:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c5cbf7-7fb1-46c7-2357-08dbbaa01759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTdgzAGZ28BlQJupUVeTATPuV7piZgos0i6euYxKAIDCFH88L+9wjgAqb+guE4HIvFyIz6QPNkkXPk7nivOSGkpLz4nzH2TKekuPaRfIlH5W/RjiYOsyYL7GYErzGWWXbLoiFvDQ6emL05feNLTzVJbctmt/FMUtzIUO0Qa0i4Zz2BIKaUlP3Nhj/tzDxnLXDImr9HxmZ9DtGlDBDvpg9PUNI78/6U10ocFYqSiD3qWPTuIX/gWq5doGrr2K8a7ToQH6SCxybsKt3+t2TvDREv9tyFHSgaSgWkXj8fDruBFW5trK9CPzLSfJPVfzG+kWjsTJ51UPIU1S2CfO6VZqQdPfVVhajq4QazhuqQvXI0xldZP3PAPtmc62sJI/O31YskgESqspLRiyNJZaeXRoX4aGSNPcggtdF0l53FJa+6UbHi0yHbLOqoyRbJQvVO2ScRPGtsr7vll28f5Pox+csXHK727kFYIY4tAfP37lQPs4AzFU2oeXLXfqHFusL1duycbA0hOFS1u3pW6YlTdXDnHSv0dMuzUdLsCUx4/lTH0dcm3t74SYTlO6h3sK4fH2paw3rvLYfCz5mnbRnoVY55y5UhRcqoSUKqG7Po4qERJQc4bhrLQQ1tv9CSg+ysDDfqL8b9H4IudgREQdqMSwzJJxKtFoejrPu5BvndRAGZLTEDrZTfAu2J61XPfyFIuQyk8jEfYZP6qQaoBOyrXSZEmdDNOMOqk+WCCf/O5MLWgVKKq+kaigeXGSYP+030quuvKLOSaQmyipk4CuWjo05aEWsPiBFZ8l9zqfLUuw0E0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199024)(1800799009)(186009)(82310400011)(36840700001)(40470700004)(46966006)(2906002)(47076005)(83380400001)(7636003)(40480700001)(82740400003)(6666004)(356005)(5660300002)(426003)(336012)(8676002)(8936002)(4326008)(86362001)(36860700001)(1076003)(26005)(6636002)(316002)(40460700003)(70206006)(110136005)(478600001)(7696005)(36756003)(2616005)(41300700001)(107886003)(70586007)(54906003)(41533002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 12:41:35.0902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c5cbf7-7fb1-46c7-2357-08dbbaa01759
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017094.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6871
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Feng Liu <feliu@nvidia.com>

Currently VQ deletion callback vp_del_vqs() processes generic
virtio_device level VQ list instead of VQ information available at PCI
layer.

To adhere to the layering, use the pci device level VQ information
stored in the virtqueues or vqs.

This also prepares the code to handle PCI layer admin vq life cycle to
be managed within the pci layer and thereby avoid undesired deletion of
admin vq by upper layer drivers (net, console, vfio), in the del_vqs()
callback.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.c | 12 +++++++++---
 drivers/virtio/virtio_pci_common.h |  1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index c2524a7207cf..7a3e6edc4dd6 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -232,12 +232,16 @@ static void vp_del_vq(struct virtqueue *vq)
 void vp_del_vqs(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	struct virtqueue *vq, *n;
+	struct virtqueue *vq;
 	int i;
 
-	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
+	for (i = 0; i < vp_dev->nvqs; i++) {
+		if (!vp_dev->vqs[i])
+			continue;
+
+		vq = vp_dev->vqs[i]->vq;
 		if (vp_dev->per_vq_vectors) {
-			int v = vp_dev->vqs[vq->index]->msix_vector;
+			int v = vp_dev->vqs[i]->msix_vector;
 
 			if (v != VIRTIO_MSI_NO_VECTOR) {
 				int irq = pci_irq_vector(vp_dev->pci_dev, v);
@@ -294,6 +298,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
 	if (!vp_dev->vqs)
 		return -ENOMEM;
+	vp_dev->nvqs = nvqs;
 
 	if (per_vq_vectors) {
 		/* Best option: one for change interrupt, one per vq. */
@@ -365,6 +370,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
 	if (!vp_dev->vqs)
 		return -ENOMEM;
+	vp_dev->nvqs = nvqs;
 
 	err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
 			dev_name(&vdev->dev), vp_dev);
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 4b773bd7c58c..602021967aaa 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -60,6 +60,7 @@ struct virtio_pci_device {
 
 	/* array of all queues for house-keeping */
 	struct virtio_pci_vq_info **vqs;
+	u32 nvqs;
 
 	/* MSI-X support */
 	int msix_enabled;
-- 
2.27.0

