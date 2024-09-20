Return-Path: <kvm+bounces-27228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E49197DA9A
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FCDEB21B4C
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B938318E039;
	Fri, 20 Sep 2024 22:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UfKFZ25s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD018DF8C;
	Fri, 20 Sep 2024 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871722; cv=fail; b=qfVla5XotKx196L+JsrX1XBXfrFmpPOlHTvD2sfHdxeomCoxqsvG2AbHkyb2qlLK25kpJovOEowGjLXEBh/nkFOL0l20r9f03NQznZtQ4ikiNXmpb9N10rp1r/74KmI/PlXgI749vn/w2w7jdqmeUusvYRbpfyKEVRWJPKZGm/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871722; c=relaxed/simple;
	bh=CNypwOQFjOrA9uoujWe1o9nKAHHeK/8cRfipSHQnETY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krgloT2kxwiBks0CC07LZFWGIi8VlMZ7BRPh6IS91VL26vF8fgSI8lhydp6vVXTQKd9AXGAX6SyxZk1Brq7tZKf63MpJn1nGCazw6tPRmSYvlbcW67avEdBFJ3RLNvcvgAX2OaoNL3gotb/u8pKp9sPJeDM9hzuaolzHymz1Yhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UfKFZ25s; arc=fail smtp.client-ip=40.107.94.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iD9LSqgL2z8KfWEjbslSmP6ly0zaQSnHdD9vpoQWz54k889Er/ioJYz25w0DGTvgKLa4HQKZoEC5RetbSbfS6c4gxSOGBycVT5Q0OZo/w+N9kP12i8C/iB0dN+vmfuwTQINLSN3VnALCpHaGd7K+MXno1oy5ELHwyARqnIhze21gXEXNwG5NOoFfitNh5memCJrSGpK/rStJkmeBas8fp0sKWKSpa15rISsvYPSfsn9aeSNj0I5loHyOfPpWoduxdODhfRnJ6B9xYGgRmhgg8mIb8TfzataZxnO4WZkY4MhWasS81xXMp3OfDIWMaHtr2IGrfxv6gL90NxK3Lpw8AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Lz+MrXoheRZPhqJ3diJ1ne9h8twBQcPiLrAkvWRYd8=;
 b=lMZ6GIv8pX7scQoHmHx/vPixGgD/JOR1YuxE1wtFDXAdlRGDvEv5q+mvwfSH6e2jg2KIW1GvZFK7CqEigbH2wuhdIpJIezsVUP0U7Bfg7CV8dkxQurjQ1o2fMkqFku8uHOm1RFCh3uQw60bAKdwHzjfnUUjLNV1yAIGB5MMTkBNidKfutMf75fPRtHaEJHCWT84KVR0jmaKidkBlXvEvKz6zj+PXTpyWZ9hb0q1EOg78qMxA5FWNzZA0hNeMJYr9za6rTx7rhp3jzrE/OQyqNyl7mDnG4zcMwpXmhI2HfCe6LWFOVwHsSjTJX1QKi2GXzmONGc19UwxYvju10KVbiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Lz+MrXoheRZPhqJ3diJ1ne9h8twBQcPiLrAkvWRYd8=;
 b=UfKFZ25sLpPsdmDMTV1HH5PycQZAh+rUXlqEvPzEcAXey8tv7nZT9sOkgWoKtiagg70kjC/w9yu40UNzfiMM7nyYybrYJQkIEu5kvuSrgCPMD3JBVioA25nLo/2qRp153lMFPMFKOAbVaM+FqBNh9aSx45k6bIIEgigN3lY29s2gBzNbggJDOvYaWZAIK65vVr3Vam1M+JwrosYGMUz6GvGiJn4QQ/79xbaeIWwfCa6IgKxiVPCbSK2FtQo/3wYHgix6L2yBc7/R3xWMhPhHX7IZj/Rtaj3EZWhFZimqsavUMXn0RLDOoE/UZxKAoO0e4uxHL6eo+p5l5iF3W7oeGQ==
Received: from MN2PR18CA0002.namprd18.prod.outlook.com (2603:10b6:208:23c::7)
 by MN0PR12MB6367.namprd12.prod.outlook.com (2603:10b6:208:3d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.22; Fri, 20 Sep
 2024 22:35:16 +0000
Received: from BL02EPF00029928.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::3c) by MN2PR18CA0002.outlook.office365.com
 (2603:10b6:208:23c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.25 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00029928.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:02 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:01 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:35:00 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 08/13] vfio/cxl: emulate HDM decoder registers
Date: Fri, 20 Sep 2024 15:34:41 -0700
Message-ID: <20240920223446.1908673-9-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00029928:EE_|MN0PR12MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d6b09f-7005-4c0c-a1e9-08dcd9c47fc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wb1I7xCBiCBhf3MP1QoeX13Djt+Q1LMlAlCikqMI3bvrWbySKXzKHCrgO5/T?=
 =?us-ascii?Q?kd5RJ8422ZChbQ8+rgYoFO/ef5+lGkUX+WX3XDGGT/6N22poiT49ZNwlwa6D?=
 =?us-ascii?Q?hfSBIFI8LAFtix6dk8n5DAPS/jZZqVCmkkudeBnf/vJCweOATcNJ+90c2mvq?=
 =?us-ascii?Q?WaUZj9mRPRh6MwTbTGmmVxBZ150ppyi5q4xMPzi1ZzqAr4gnEpJGHz5g1kW2?=
 =?us-ascii?Q?ShrljCDvMhKxt/4vW7TjX/CjqqCTfWYcoCZ7725gCL4g6LRh6jWtoWKgphVx?=
 =?us-ascii?Q?DlADSMadSV2dFYWSUi7vlwoxmArBKlOQXI4gUY7Cm602vEhTcA7s00nz4SkF?=
 =?us-ascii?Q?0PwLIr2I7ldYVYnViOG5XqEmdQ2k8s3RCGOs55v3Ki79+rzj88s2qTZr2Wp4?=
 =?us-ascii?Q?SRywY7StIx/O7p91l8dt5G1mZAZ7LoIpt2XOE3GhJYv2INrhuUSg2pVpA6JP?=
 =?us-ascii?Q?wfKHKFcDwkP9eTnd19zvtomzmJlxQ5rxwmBHn+BN8dcl2aRg0mhNgSDcMYmY?=
 =?us-ascii?Q?FDP6dMETLwh2I2Ah2sCcCVFBAKWPq7bPaS5qVzrMpCCHxc3QUiejpGLTkKdv?=
 =?us-ascii?Q?Ld4B61HUjRZoJmPjvHZx7DQQ377ihw+0OTL9/INoAwQFRqOjVMwhuBRwOxG2?=
 =?us-ascii?Q?J+WNwykinpG5X+C1C8HItUigPwT3uZT8WKRqXkH9zSznbIXxtEcW0BmXbTnx?=
 =?us-ascii?Q?6Eq23uKycijQkVUuQdbAj+VPrYfEWvZVrWtdZmQHfATWW/LnBE04h3Gql7os?=
 =?us-ascii?Q?dRtqGz550n6lZ+X1a0QgbnpAz8VIm0pSqtlBveR2Dioy/no96RpyLzlhAjf9?=
 =?us-ascii?Q?0nwO3HJbE1+6Ux5GRgIcRX3KOBdpvQYtujZcwA9TBQU98BiccO2Spl9tVg/a?=
 =?us-ascii?Q?wnP1X+FDez+J6rsaDQVhiXQEISDnHQaziTWJ6Oc4GmUOuuXjMo81QrCe03iT?=
 =?us-ascii?Q?HJR0MEju8Pb4wAsMZwlt1KjqLgUWfEF4ANmb3dWRniOb3PK4XJ4DCDQ4ffsb?=
 =?us-ascii?Q?G7GX2sWNTFda6OG5uU4vyMun1PMSbWIxdpEY/WcNIkbfJqAXREhlEV4c0YAv?=
 =?us-ascii?Q?e6z59dDipLurFmmIglp3Se2hMyX/w0fWNRIMfsFBiVoxflnidbT7xOVMMHJH?=
 =?us-ascii?Q?JKLD4aEi0mh2BNb1+kzJp5xf8Rao+jZ9Q4W4nOuvDBZEE6n2DuO0KZAcCK6Z?=
 =?us-ascii?Q?XAASC9vs20p+PYEtegWe+/Amf/aU1EBHTHwdNEn67/rSB11V5jO23EstF8Zr?=
 =?us-ascii?Q?/Gc0+/uC/iQUPrBNbd8acIWcUZsdNGjHWACwF7G3EAR61W6PsPJL0z+hek8/?=
 =?us-ascii?Q?nOZp6/imF4T26UmDm9BtwK6JRyOdX+9ndAErj2bl2q5qV90g2xn/AneUOsRd?=
 =?us-ascii?Q?KHn6xwHy1IuI9G8IcZETWJYbPkTwBMlOaDAgQ6K7QlRcEr75sDgeGl4pYIKk?=
 =?us-ascii?Q?GaXZOqV1XrIGPTv4SjXSwFBe3zyribNi?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:15.8212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d6b09f-7005-4c0c-a1e9-08dcd9c47fc5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029928.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6367

To directly access the device memory, the HDM decoder registers on the
path from CXL root port to the device needs to be configured when
creating a CXL region.

However, the physical HDM decoders are owned by the kernel CXL core when
creating and configuring a CXL region. Thus the VM is forbidden to
access and configure the phsyical HDM decoder registers. The HDM decoder
register in the CXL component register group needs to be emulated.

Emulate the HDM decoder registers in the vfio-cxl-core. Locate the BAR
where the component registers sit. Take a snapshot of component
registers before initialize the CXL device. Emulate the HDM decoder
registers when VM access them from vfio_device_ops->{read, write}.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c | 208 ++++++++++++++++++++++++++++++-
 include/linux/cxl_accel_pci.h    |   6 +
 include/linux/vfio_pci_core.h    |   5 +
 3 files changed, 216 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index 68a935515256..bbb968cb1b70 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -283,6 +283,90 @@ static const struct vfio_pci_regops vfio_cxl_regops = {
 	.release	= vfio_cxl_region_release,
 };
 
+static int find_bar(struct pci_dev *pdev, u64 *offset, int *bar, u64 size)
+{
+	u64 start, end, flags;
+	int index, i;
+
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		index = i + PCI_STD_RESOURCES;
+		flags = pci_resource_flags(pdev, index);
+
+		start = pci_resource_start(pdev, index);
+		end = pci_resource_end(pdev, index);
+
+		if (*offset >= start && *offset + size - 1 <= end)
+			break;
+
+		if (flags & IORESOURCE_MEM_64)
+			i++;
+	}
+
+	if (i == PCI_STD_NUM_BARS)
+		return -ENODEV;
+
+	*offset = *offset - start;
+	*bar = index;
+
+	return 0;
+}
+
+static int find_comp_regs(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	struct pci_dev *pdev = core_dev->pdev;
+	u64 offset;
+	int ret, bar;
+
+	ret = cxl_find_comp_regblock_offset(pdev, &offset);
+	if (ret)
+		return ret;
+
+	ret = find_bar(pdev, &offset, &bar, SZ_64K);
+	if (ret)
+		return ret;
+
+	cxl->comp_reg_bar = bar;
+	cxl->comp_reg_offset = offset;
+	cxl->comp_reg_size = SZ_64K;
+	return 0;
+}
+
+static void clean_virt_comp_regs(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+
+	kvfree(cxl->comp_reg_virt);
+}
+
+static int setup_virt_comp_regs(struct vfio_pci_core_device *core_dev)
+{
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	struct pci_dev *pdev = core_dev->pdev;
+	u64 offset = cxl->comp_reg_offset;
+	int bar = cxl->comp_reg_bar;
+	u64 size = cxl->comp_reg_size;
+	void *regs;
+	unsigned int i;
+
+	cxl->comp_reg_virt = kvzalloc(size, GFP_KERNEL);
+	if (!cxl->comp_reg_virt)
+		return -ENOMEM;
+
+	regs = ioremap(pci_resource_start(pdev, bar) + offset, size);
+	if (!regs) {
+		kvfree(cxl->comp_reg_virt);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < size; i += 4)
+		*(u32 *)(cxl->comp_reg_virt + i) = readl(regs + i);
+
+	iounmap(regs);
+
+	return 0;
+}
+
 int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 {
 	struct vfio_cxl *cxl = &core_dev->cxl;
@@ -299,10 +383,18 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 	if (!cxl->region.size)
 		return -EINVAL;
 
-	ret = vfio_pci_core_enable(core_dev);
+	ret = find_comp_regs(core_dev);
+	if (ret)
+		return ret;
+
+	ret = setup_virt_comp_regs(core_dev);
 	if (ret)
 		return ret;
 
+	ret = vfio_pci_core_enable(core_dev);
+	if (ret)
+		goto err_pci_core_enable;
+
 	ret = enable_cxl(core_dev, dvsec);
 	if (ret)
 		goto err_enable_cxl_device;
@@ -324,6 +416,8 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
 	disable_cxl(core_dev);
 err_enable_cxl_device:
 	vfio_pci_core_disable(core_dev);
+err_pci_core_enable:
+	clean_virt_comp_regs(core_dev);
 	return ret;
 }
 EXPORT_SYMBOL(vfio_cxl_core_enable);
@@ -341,6 +435,7 @@ void vfio_cxl_core_close_device(struct vfio_device *vdev)
 
 	disable_cxl(core_dev);
 	vfio_pci_core_close_device(vdev);
+	clean_virt_comp_regs(core_dev);
 }
 EXPORT_SYMBOL(vfio_cxl_core_close_device);
 
@@ -396,13 +491,102 @@ void vfio_cxl_core_set_driver_hdm_cap(struct vfio_pci_core_device *core_dev)
 }
 EXPORT_SYMBOL(vfio_cxl_core_set_driver_hdm_cap);
 
+static bool is_hdm_regblock(struct vfio_cxl *cxl, u64 offset, size_t count)
+{
+	return offset >= cxl->hdm_reg_offset &&
+	       offset + count < cxl->hdm_reg_offset +
+	       cxl->hdm_reg_size;
+}
+
+static void write_hdm_decoder_global(void *virt, u64 offset, u32 v)
+{
+	if (offset == 0x4)
+		*(u32 *)(virt + offset) = v & GENMASK(1, 0);
+}
+
+static void write_hdm_decoder_n(void *virt, u64 offset, u32 v)
+{
+	u32 cur, index;
+
+	index = (offset - 0x10) / 0x20;
+
+	/* HDM decoder registers are locked? */
+	cur = *(u32 *)(virt + index * 0x20 + 0x20);
+
+	if (cur & CXL_HDM_DECODER0_CTRL_LOCK &&
+	    cur & CXL_HDM_DECODER0_CTRL_COMMITTED)
+		return;
+
+	/* emulate HDM_DECODER_CTRL. */
+	if (offset == CXL_HDM_DECODER0_CTRL_OFFSET(index)) {
+		v &= ~CXL_HDM_DECODER0_CTRL_COMMIT_ERROR;
+
+		/* commit/de-commit */
+		if (v & CXL_HDM_DECODER0_CTRL_COMMIT)
+			v |= CXL_HDM_DECODER0_CTRL_COMMITTED;
+		else
+			v &= ~CXL_HDM_DECODER0_CTRL_COMMITTED;
+	}
+	*(u32 *)(virt + offset) = v;
+}
+
+static ssize_t
+emulate_hdm_regblock(struct vfio_device *vdev, char __user *buf,
+		     size_t count, loff_t *ppos, bool write)
+{
+	struct vfio_pci_core_device *core_dev =
+		container_of(vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl *cxl = &core_dev->cxl;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	void *hdm_reg_virt;
+	u64 hdm_offset;
+	u32 v;
+
+	hdm_offset = pos - cxl->hdm_reg_offset;
+	hdm_reg_virt = cxl->comp_reg_virt +
+		       (cxl->hdm_reg_offset - cxl->comp_reg_offset);
+
+	if (!write) {
+		v = *(u32 *)(hdm_reg_virt + hdm_offset);
+
+		if (copy_to_user(buf, &v, 4))
+			return -EFAULT;
+	} else {
+		if (copy_from_user(&v, buf, 4))
+			return -EFAULT;
+
+		if (hdm_offset < 0x10)
+			write_hdm_decoder_global(hdm_reg_virt, hdm_offset, v);
+		else
+			write_hdm_decoder_n(hdm_reg_virt, hdm_offset, v);
+	}
+	return count;
+}
+
 ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl *cxl = &vdev->cxl;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+
+	if (!count)
+		return 0;
+
+	if (index != cxl->comp_reg_bar)
+		return vfio_pci_rw(vdev, buf, count, ppos, false);
+
+	if (WARN_ON_ONCE(!IS_ALIGNED(pos, 4) || count != 4))
+		return -EINVAL;
 
-	return vfio_pci_rw(vdev, buf, count, ppos, false);
+	if (is_hdm_regblock(cxl, pos, count))
+		return emulate_hdm_regblock(core_vdev, buf, count,
+					    ppos, false);
+	else
+		return vfio_pci_rw(vdev, (char __user *)buf, count,
+				   ppos, false);
 }
 EXPORT_SYMBOL_GPL(vfio_cxl_core_read);
 
@@ -411,8 +595,26 @@ ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *bu
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct vfio_cxl *cxl = &vdev->cxl;
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+
+	if (!count)
+		return 0;
+
+	if (index != cxl->comp_reg_bar)
+		return vfio_pci_rw(vdev, (char __user *)buf, count, ppos,
+				   true);
+
+	if (WARN_ON_ONCE(!IS_ALIGNED(pos, 4) || count != 4))
+		return -EINVAL;
 
-	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
+	if (is_hdm_regblock(cxl, pos, count))
+		return emulate_hdm_regblock(core_vdev, (char __user *)buf,
+					    count, ppos, true);
+	else
+		return vfio_pci_rw(vdev, (char __user *)buf, count, ppos,
+				   true);
 }
 EXPORT_SYMBOL_GPL(vfio_cxl_core_write);
 
diff --git a/include/linux/cxl_accel_pci.h b/include/linux/cxl_accel_pci.h
index c337ae8797e6..090f60fb9a3f 100644
--- a/include/linux/cxl_accel_pci.h
+++ b/include/linux/cxl_accel_pci.h
@@ -20,4 +20,10 @@
 #define   CXL_DVSEC_RANGE_BASE_LOW(i)	(0x24 + (i * 0x10))
 #define     CXL_DVSEC_MEM_BASE_LOW_MASK	GENMASK(31, 28)
 
+#define CXL_HDM_DECODER0_CTRL_OFFSET(i) (0x20 * (i) + 0x20)
+#define   CXL_HDM_DECODER0_CTRL_LOCK BIT(8)
+#define   CXL_HDM_DECODER0_CTRL_COMMIT BIT(9)
+#define   CXL_HDM_DECODER0_CTRL_COMMITTED BIT(10)
+#define   CXL_HDM_DECODER0_CTRL_COMMIT_ERROR BIT(11)
+
 #endif
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 64ccdcdfa95e..9d295ca9382a 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -62,6 +62,11 @@ struct vfio_cxl {
 	u8 caps;
 	u64 dpa_size;
 
+	int comp_reg_bar;
+	u64 comp_reg_offset;
+	u64 comp_reg_size;
+	void *comp_reg_virt;
+
 	u32 hdm_count;
 	u64 hdm_reg_offset;
 	u64 hdm_reg_size;
-- 
2.34.1


