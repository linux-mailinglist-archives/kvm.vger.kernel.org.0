Return-Path: <kvm+bounces-9177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF5D85BAF5
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 310AA1C21B60
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 11:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D2267C40;
	Tue, 20 Feb 2024 11:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fiSsRDlb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973766773B;
	Tue, 20 Feb 2024 11:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708429902; cv=fail; b=qtxZLIad7z9GRVV/xtxDt1vSNPTEMmOT/8b4/pMsDO7AxpLT8qUfWjmhuk+OXRyWo3OeYFHTzFhbUBpWeRy7EYs/JKAu1JdCvR/tgWjOmIlWxN0ZhOTEhf50cfDNBk98Vbh4QYZd/VNvfChfQRowhkEQbSPiEzP2ESLQIaEl+jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708429902; c=relaxed/simple;
	bh=nMFlCjN6MU3JTpNvfsKh2bao3/4f4ehltFH7X4y18s8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9Am1znkE2psvGVq9IRF1mX81zpk6yY+dLX5SVZrAYBbi7Pu1XLGKPjMdwP8FIIOoZUP8PU3zB6wzYJMdX3X3Ftr2G4gd1KCGO9zKXjczU4WIxIKRVWTGlHP8qbsmokUxVHtctdsFqzWO2oe1ZoJZO9UEuLkqLe2Sirl7kAqKjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fiSsRDlb; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnhrTU7qRIWSXyczkDjK2cHCb84LBTreEmHmzcWDGDcR751i7aKrndC5+AeCiZBaQk7TZbaQazjgMCWa1mCDly5O1RsoZQ4WQGYlUWUnLWmSO9w1yIb5FldMmH557WNrdRWbNMR1UMMQAPRIztbwrmH0U8zJv6aQjiQvdlw0dsmaTuTq54EtjuvvB6acJS923iRejF9J7KTGzSRVYzG3XH8x0dThgXi+Xj5pBliEJEveigosnNAL9RyIAsXPxl/yVpAHLrpuh7+1nIuMx275fUiUlZapGJMQgAdKp7UvZ56eSSazQsjfnWGF+66aBvz5TyRYEWsfVZpmG9mcENveyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzvjFnpVzHD/3wkou5whtUP9Afsl+M3Oo5Fjoevnj8M=;
 b=AkNHGwPlBPKeyvz+IuxZCICA48A6PubS7N+I7B7MbvkD9zYppVVjTIkJReQy6RVNl8wlDECjUi2HDvGlCL5Rh7lyF6LJzDlOwibsU9ov+QD4lsRVF5sxyylRz9D5H0rljg8hkOHJJDwYc85DXASZ0vYO6wTj23lSO8gKC5x0mjb8IXllbB/LakvElYEl9g7xzXawYFxX4zYs8GRJpk7GoGJlyg+kTGKfdnbNmRV1jx8dlJ3iW0TttrkjsO6MJeqigx8FjGaDFpyD61KEsOfjenheIzPcpSaqlUWIeaigVWJNs2deDVNXwSLYOVT2T8k3hwPduWo7VDWGIi4aGqXBYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzvjFnpVzHD/3wkou5whtUP9Afsl+M3Oo5Fjoevnj8M=;
 b=fiSsRDlbyN3xc7xFvKGddfofu/Jf8JwAGCVhYrkcSn0OxExhJLgXrjFDyCv3eUuRo2CqV9lqbdDn2pIC4fpcCW4ZgKPUe9sus3/yVpjWFCveQrGR+3t1uqlVOyg912PSzc2psbovQho7g3Qs9oxVqDgsZKcSPoRzJBcCwY33yutrhN0PrmCidhqfcjivxoIU8WO4iUxJ760M/Rgt5RazzJhVOZcnOPFe0pKw0cWcUjSQiA+VIX/si1sNmxkiBhSkuat9loVWK7qIEaAWaPwYTcBFS/9qRT3FGK6qE2+BHPajoEF1nNXaEymATPlBeAM42E5LsvlaMl+HzD3EjJhdSA==
Received: from SJ0PR05CA0187.namprd05.prod.outlook.com (2603:10b6:a03:330::12)
 by PH8PR12MB6820.namprd12.prod.outlook.com (2603:10b6:510:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Tue, 20 Feb
 2024 11:51:33 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::fb) by SJ0PR05CA0187.outlook.office365.com
 (2603:10b6:a03:330::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Tue, 20 Feb 2024 11:51:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 11:51:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 20 Feb
 2024 03:51:21 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Tue, 20 Feb 2024 03:51:21 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Tue, 20 Feb 2024 03:51:13 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mst@redhat.com>, <eric.auger@redhat.com>,
	<jgg@ziepe.ca>, <oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>, <rrameshbabu@nvidia.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v19 2/3] vfio/pci: rename and export range_intersect_range
Date: Tue, 20 Feb 2024 17:20:54 +0530
Message-ID: <20240220115055.23546-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240220115055.23546-1-ankita@nvidia.com>
References: <20240220115055.23546-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|PH8PR12MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce78189-0296-4752-8ab1-08dc320a4902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xZkthwZj656gAFedJGkGlHOAdhs4dL8kWpEbU1ciPr2XcfXiSUQQDeKVz44Ev0PNDFxVXIgHpCDCuMbaj8zH6ocYxBql1XbFmL23entmQqdusKBtYe6j6tjsBhLgYc9gTmNT4Idt3fJNaISBev/9HHNPgKykcvc5V1+VMW5FP235GXmcu3uYx3JQD8L8ZcOIoupV3ACOJDg8GAaXYpbSvl/E/Ws6ikwWoBSb8Ft0lgFUsaWfc7fTV0JKZq5hWfdW7XJ2SlJttrOgn/GZxR6o92Yp9QJqWlSzQiwkfKdPq6Sy+KAOCZnwShZdWV12o1MCCYr5Go631AXLPcNAvv0NkKFBOuVKnHkgrHIRiheVQf+n87ULQnXCUCG236YFXq89GS0jk6vrtQtxAEC7dQJVl7ozCFZt7EvCWXdy7DV53UPPz38ZEJBxlVSTWPxPX8PY6jaFvWlPotkC7s+UTdW69Xv5boazYXhJFfMw66SarZNITj4othnIdj+fNnmtP0PRr4b52LowleZWtspAQVZC0llZzcOT8EE4zKcjpRGgwwlE6yFHi7o0gBUHXVMd4/gx9i3qTmjFyNKbvqpCRYqC3THpZvXdaucTyB1zAowrqhmfwkRJoxcmBWEGXLmcV9zTQ8YXsUCCHMNKgSK00d8yE5WprOqLlVZDjveWB+YjgNk=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 11:51:33.4795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce78189-0296-4752-8ab1-08dc320a4902
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6820

From: Ankit Agrawal <ankita@nvidia.com>

range_intersect_range determines an overlap between two ranges. If an
overlap, the helper function returns the overlapping offset and size.

The VFIO PCI variant driver emulates the PCI config space BAR offset
registers. These offset may be accessed for read/write with a variety
of lengths including sub-word sizes from sub-word offsets. The driver
makes use of this helper function to read/write the targeted part of
the emulated register.

Make this a vfio_pci_core function, rename and export as GPL. Also
update references in virtio driver.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 42 +++++++++++++++++
 drivers/vfio/pci/virtio/main.c     | 72 +++++++++++-------------------
 include/linux/vfio_pci_core.h      |  5 +++
 3 files changed, 73 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 672a1804af6a..971e32bc0bb4 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1966,3 +1966,45 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	return done;
 }
+
+/**
+ * vfio_pci_core_range_intersect_range() - Determine overlap between a buffer
+ *					   and register offset ranges.
+ * @buf_start:		start offset of the buffer
+ * @buf_cnt:		number of buffer bytes
+ * @reg_start:		start register offset
+ * @reg_cnt:		number of register bytes
+ * @buf_offset:	start offset of overlap in the buffer
+ * @intersect_count:	number of overlapping bytes
+ * @register_offset:	start offset of overlap in register
+ *
+ * Returns: true if there is overlap, false if not.
+ * The overlap start and size is returned through function args.
+ */
+bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
+					 loff_t reg_start, size_t reg_cnt,
+					 loff_t *buf_offset,
+					 size_t *intersect_count,
+					 size_t *register_offset)
+{
+	if (buf_start <= reg_start &&
+	    buf_start + buf_cnt > reg_start) {
+		*buf_offset = reg_start - buf_start;
+		*intersect_count = min_t(size_t, reg_cnt,
+					 buf_start + buf_cnt - reg_start);
+		*register_offset = 0;
+		return true;
+	}
+
+	if (buf_start > reg_start &&
+	    buf_start < reg_start + reg_cnt) {
+		*buf_offset = 0;
+		*intersect_count = min_t(size_t, buf_cnt,
+					 reg_start + reg_cnt - buf_start);
+		*register_offset = buf_start - reg_start;
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
index cf9480a31f3e..a2c8b8bba711 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -134,6 +134,11 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
 			       size_t x_end, bool iswrite);
+bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
+					 loff_t reg_start, size_t reg_cnt,
+					 loff_t *buf_offset,
+					 size_t *intersect_count,
+					 size_t *register_offset);
 #define VFIO_IOWRITE_DECLATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io);
-- 
2.34.1


