Return-Path: <kvm+bounces-8056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 051F784AA31
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A3701C283E4
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8254F613;
	Mon,  5 Feb 2024 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DK4sVM91"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA2E4F5E4;
	Mon,  5 Feb 2024 23:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174122; cv=fail; b=AflPZi6XdIFF8DHIqICje68ufbEFt91bVyoUon6BR3fVvXWRex8n+ld/r4b7wU/krdJKNJUjmubg1GARtPysraB/tALv1FAWF7jZdh1KPXSrWWSZgEvYnFKx3BLv58xS/A01ZoP/d/a1iwS5J43UOG0B7eMJsk1oVwCcdnw35kE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174122; c=relaxed/simple;
	bh=zUFq+9GM48j9srXRrfb55ZAjhx1EK1wjC9YWiELty2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bPT6SlLm/1/zOUzTCHijcCQEuyU0pLRI7RJjR7xDV0kFPs4uJgSxtDo7l2CJ1Ii7SGySdAGW/eFQc0YaOHP9+30pfEXkxl4oxGhZ0iwbm4b7JUvmWl7Ql/PIkKI633lgSPIIG7j0OdyTfSYieW4So3MV3lWnpS4RX9C9a4xu9RQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DK4sVM91; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpeAPHkFcpVdNCOyZGaAbcdJuBZacDMmyajjDTHv1iE1NlILAjc9aB0UVoBicQTTvBfpcjt4+sCs1QpYB4b5dgETSvZmGmyqX+YrUmQxnsY2OaZ1rYo42W2zyThWzerEj+7XI94NM41/F9Vq9Nuhk+0Axs001Ejsi2Sb7YClDUYHchm/zxws7FuH3vLZIuee5MLC1C6bPl+N4RI4kUtp4Knqt/L3Po0g6BLVe/UDqVjHxVUiU0B0IM5j9E1Qp39pnSia2E5SeYPAswjKVkSYbkbok1UG059coi+Zj49KcduFuNRa0ypG8jGVLTH6mmxcSkA5MPhZWYF4GsaI2ihFkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQasvauqemcFGwYycw2aeEdnE/cSOSG37PT4czdLFY8=;
 b=hR0vLiv1be5ziIlaATfJppA9Va4kV9qdFKqyYIeqKuqE5+cR42clw18hboVD/f7mh0WH06i19VIhbT+wnOWuo+DEqweUjdXohXWy2mPrRbemSqspEEbjOm/Q+dt+xjdnksK3vSLSg9g53qzZzKjc4O79S97o5j9qc+2xLCA256Jx98/fV7bs+06O/wX8rSAtqX+qeeKCXCE8/x5QlsOi6IK8LrNqyPJ2y39fEH0O4eL5o3myjdvMVxBjETD3cAlKH1LureI/AV3qtgaMBr8WtFJwDseeLmrXpGLYSETIlA+smFNzXUSZxNvoTraxAuHPwtfZ3HS0Fuw43EdK6LwLqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQasvauqemcFGwYycw2aeEdnE/cSOSG37PT4czdLFY8=;
 b=DK4sVM91nNTyAtjru61wLlbvHLA4Sb122QpzkI+1S3xyOcpcC9s5W1a7+4GkBy1Icj1kCgdxe5HMkBhtEm1o+vkVOvjR7BuCM6MlGZ06lgERMHJOcM9HzT1WlyNbsXuNM3h578+h9qe7EfCsIfgoTO5Lx0dELU4czz+WCkAriddHHC9NDU024Yg0Dbcvd3VsrVwBzSncyXY3bkIJqe1Y32M5BDZOwyERDJOrogl9o6u7sBDhHNAh/5Flts12YHMr+AC2O+236UDZI3iWW5M1+jmMWdHp33PJCnRH6ix6AoY8pVgeCx8JpahQ8WzJq+Qm4+Izzzn4EJXfqWwpehZmgw==
Received: from DM6PR14CA0053.namprd14.prod.outlook.com (2603:10b6:5:18f::30)
 by LV8PR12MB9232.namprd12.prod.outlook.com (2603:10b6:408:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Mon, 5 Feb
 2024 23:01:57 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::f6) by DM6PR14CA0053.outlook.office365.com
 (2603:10b6:5:18f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Mon, 5 Feb 2024 23:01:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 23:01:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 5 Feb 2024
 15:01:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Mon, 5 Feb 2024 15:01:48 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 5 Feb 2024 15:01:41 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <mst@redhat.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<clg@redhat.com>, <oleksandr@natalenko.name>,
	<satyanarayana.k.v.p@intel.com>, <eric.auger@redhat.com>,
	<brett.creeley@amd.com>, <horms@kernel.org>, <rrameshbabu@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v17 2/3] vfio/pci: rename and export range_intesect_range
Date: Tue, 6 Feb 2024 04:31:22 +0530
Message-ID: <20240205230123.18981-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240205230123.18981-1-ankita@nvidia.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|LV8PR12MB9232:EE_
X-MS-Office365-Filtering-Correlation-Id: ef1a47c6-ef12-4aa2-7a03-08dc269e7407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5hXDtD7KEB7G45K4v+Bqoy/cQD+BIRl/TmR6XCQhJp1QNZ03/Ry3uF+DLcNmjXJBXPOBTrP5Zw6V+LcSOsDcm9O8O7UcTE35VQkzK72XYq8SVR2FrHON2j/bgfZ8KnrMw9ia+vQvp38brvF0FBe5zUZL4tBZkyFZxTLvcuv67LR4iPU4QCv1jwb3qaQ6Z6sInJNzOBxhQAt0KLyvla0GpRjqYepHrZsqut6VMXuFkGy0s4C8tWbJOIt360oCA5S7QqGh1+7m7OXnaSHq0wVLR+iZzxLnHlRR+ImUEZ8eaW2OAdfJL1nZQYQbhXnBjmkK+WxJ3PsG3epgyNyBePxXhWbSWeDX0enUgOz6Y0a92ZIkg1PJruj+un7wVsUm8GUAP3dSgb7n3+xJOBAujmb7EAyE25TUmnc98rcdf4o3HiSzF12dwigBfJLI5n9k2AbPNg+b+b7H8oBhI8so8FHg0c/l60PGirzN4wySzRdcfLlZWU0d9MHhg4OaD6vocZPLrWPdCb0BgzFRq7/zXNUPzqebLRjAuYdWwDj1lYCbLE8HakZpn57RPu3JTXZf0FRL73LDwdWdeaBkOPHcBK3iS0jEznW9xejnk6dUH+CexSJOcga8mZ8CWVIL/YNX3gSinXOdjbfOguNbZHjSTgF4+3h7Fwh9lw8ED2Y7FWEQL0Ch73NJsjxGYKPnpTtX0r7p6luYbseYdokBvVRNkoZg4UUtl/CplHOWqeC7UtnwI2FBxiwXOLsTUPFTHNRI7LzmB+e1HTJJPBG1Ioq8LmlBJQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(346002)(39860400002)(230922051799003)(64100799003)(82310400011)(451199024)(186009)(1800799012)(40470700004)(36840700001)(46966006)(41300700001)(2876002)(316002)(6666004)(86362001)(4326008)(70206006)(8676002)(110136005)(5660300002)(2906002)(8936002)(7416002)(70586007)(54906003)(7636003)(356005)(82740400003)(36860700001)(36756003)(47076005)(7696005)(478600001)(83380400001)(426003)(2616005)(336012)(921011)(6636002)(40480700001)(26005)(1076003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 23:01:57.1696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1a47c6-ef12-4aa2-7a03-08dc269e7407
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9232

From: Ankit Agrawal <ankita@nvidia.com>

range_intesect_range determines an overlap between two ranges. If an
overlap, the helper function returns the overlapping offset and size.

The VFIO PCI variant driver emulates the PCI config space BAR offset
registers. These offset may be accessed for read/write with a variety
of lengths including sub-word sizes from sub-word offsets. The driver
makes use of this helper function to read/write the targeted part of
the emulated register.

Make this a vfio_pci_core function, rename and export as GPL. Also
update references in virtio driver.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 45 +++++++++++++++++++
 drivers/vfio/pci/virtio/main.c     | 72 +++++++++++-------------------
 include/linux/vfio_pci_core.h      |  5 +++
 3 files changed, 76 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 672a1804af6a..4fc3c605af13 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1966,3 +1966,48 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	return done;
 }
+
+/**
+ * vfio_pci_core_range_intersect_range() - Determine overlap between a buffer
+ *					   and register offset ranges.
+ * @range1_start:    start offset of the buffer
+ * @count1:	     number of buffer bytes.
+ * @range2_start:    start register offset
+ * @count2:	     number of bytes of register
+ * @start_offset:    start offset of overlap start in the buffer
+ * @intersect_count: number of overlapping bytes
+ * @register_offset: start offset of overlap start in register
+ *
+ * The function determines an overlap between a register and a buffer.
+ * range1 represents the buffer and range2 represents register.
+ *
+ * Returns: true if there is overlap, false if not.
+ * The overlap start and range is returned through function args.
+ */
+bool vfio_pci_core_range_intersect_range(loff_t range1_start, size_t count1,
+					 loff_t range2_start, size_t count2,
+					 loff_t *start_offset,
+					 size_t *intersect_count,
+					 size_t *register_offset)
+{
+	if (range1_start <= range2_start &&
+	    range1_start + count1 > range2_start) {
+		*start_offset = range2_start - range1_start;
+		*intersect_count = min_t(size_t, count2,
+					 range1_start + count1 - range2_start);
+		*register_offset = 0;
+		return true;
+	}
+
+	if (range1_start > range2_start &&
+	    range1_start < range2_start + count2) {
+		*start_offset = 0;
+		*intersect_count = min_t(size_t, count1,
+					 range2_start + count2 - range1_start);
+		*register_offset = range1_start - range2_start;
+		return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_range_intersect_range);
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index d5af683837d3..b5d3a8c5bbc9 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -132,33 +132,6 @@ virtiovf_pci_bar0_rw(struct virtiovf_pci_core_device *virtvdev,
 	return ret ? ret : count;
 }
 
-static bool range_intersect_range(loff_t range1_start, size_t count1,
-				  loff_t range2_start, size_t count2,
-				  loff_t *start_offset,
-				  size_t *intersect_count,
-				  size_t *register_offset)
-{
-	if (range1_start <= range2_start &&
-	    range1_start + count1 > range2_start) {
-		*start_offset = range2_start - range1_start;
-		*intersect_count = min_t(size_t, count2,
-					 range1_start + count1 - range2_start);
-		*register_offset = 0;
-		return true;
-	}
-
-	if (range1_start > range2_start &&
-	    range1_start < range2_start + count2) {
-		*start_offset = 0;
-		*intersect_count = min_t(size_t, count1,
-					 range2_start + count2 - range1_start);
-		*register_offset = range1_start - range2_start;
-		return true;
-	}
-
-	return false;
-}
-
 static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 					char __user *buf, size_t count,
 					loff_t *ppos)
@@ -178,16 +151,18 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 	if (ret < 0)
 		return ret;
 
-	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_DEVICE_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
 		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
 			return -EFAULT;
 	}
 
 	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
-	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	    vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
 				   copy_count))
 			return -EFAULT;
@@ -197,16 +172,18 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_REVISION_ID,
+						sizeof(val8), &copy_offset,
+						&copy_count, &register_offset)) {
 		/* Transional needs to have revision 0 */
 		val8 = 0;
 		if (copy_to_user(buf + copy_offset, &val8, copy_count))
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+						sizeof(val32), &copy_offset,
+						&copy_count, &register_offset)) {
 		u32 bar_mask = ~(virtvdev->bar0_virtual_buf_size - 1);
 		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
 
@@ -215,8 +192,9 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		/*
 		 * Transitional devices use the PCI subsystem device id as
 		 * virtio device id, same as legacy driver always did.
@@ -227,8 +205,9 @@ static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
-				  &copy_offset, &copy_count, &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID,
+						sizeof(val16), &copy_offset,
+						&copy_count, &register_offset)) {
 		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
 		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
 				 copy_count))
@@ -270,19 +249,20 @@ static ssize_t virtiovf_pci_write_config(struct vfio_device *core_vdev,
 	loff_t copy_offset;
 	size_t copy_count;
 
-	if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
-				  &copy_offset, &copy_count,
-				  &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_COMMAND,
+						sizeof(virtvdev->pci_cmd),
+						&copy_offset, &copy_count,
+						&register_offset)) {
 		if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
 				   buf + copy_offset,
 				   copy_count))
 			return -EFAULT;
 	}
 
-	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
-				  sizeof(virtvdev->pci_base_addr_0),
-				  &copy_offset, &copy_count,
-				  &register_offset)) {
+	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+						sizeof(virtvdev->pci_base_addr_0),
+						&copy_offset, &copy_count,
+						&register_offset)) {
 		if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
 				   buf + copy_offset,
 				   copy_count))
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index cf9480a31f3e..1a056b5ef417 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -134,6 +134,11 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
 			       size_t x_end, bool iswrite);
+bool vfio_pci_core_range_intersect_range(loff_t range1_start, size_t count1,
+					 loff_t range2_start, size_t count2,
+					 loff_t *start_offset,
+					 size_t *intersect_count,
+					 size_t *register_offset);
 #define VFIO_IOWRITE_DECLATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io);
-- 
2.34.1


