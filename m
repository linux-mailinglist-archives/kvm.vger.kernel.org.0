Return-Path: <kvm+bounces-65570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2551CB0AB3
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C608313B44E
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B2532ED41;
	Tue,  9 Dec 2025 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XRIrYXaC"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EA432E754;
	Tue,  9 Dec 2025 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299176; cv=fail; b=Nwfv9nrqFR6aMhT+b8TsKljMKWQ/HS8JEesJSBjozavn4ciJFqjbR6eto1SNNWqVmcXzmJAh7AaWQTiWLx3BWFBJ0Ze6z8UwUdDrxN6LgcRP1GxQ+yRPHxCxLH3SxngZ0Zmsk4/96Bnacpi5rVDUosXdjTwpv1tQCTZKuLeqjQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299176; c=relaxed/simple;
	bh=LOwsheOKKVVZ7acqCJgghSjBj7GHKmpFtZb4yIm6gYQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cvsx6xBc3giWyxrpjlWC5MKEsRKAaeG8KPhP8in3ml3E76jlrr4ZegFWsew+Cyj1DTfFIjjpAkK5oO+wJBR/etoLfvHaMgkSHJ6FSPJZkPQl9aZBL/gt7GBbZcICMHRC1cGm2o6PLZp0qqML4MZcXaGUCI/KKAy/YavI43z9zV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XRIrYXaC; arc=fail smtp.client-ip=40.93.201.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQL40svWU2gFZDNoxPSv8ukXwze4ySBBNa4mkQB4pXXeZSSaMRzadBOonDvdfXf1g0LnTjJ4y7izPLj/sHoZnzUhVgM/FAjwZmBroASvnMakx64aXsroXUnMuCgdNW/z6WxSM29YFYX8hWJuMenIHf42yB96KJK2TssctJXUmgE45yMcH/wKkXAKA9C5s4UZ8hp8KBCGoULLRwEY+TEyoLjZBNRqogVT4kIXf74gIa9b9jwwbU5PI0ucc1fCxS1kJp8jZpSjCUwoYirSD353WAVcGJ76ADQ0o8D6klkuLyNKTtfr5Ugy8+4LdydLmQp/81B1KTNcRaK24Bj2JwlmZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qsLY0NgXi1tm8IptIeayfybd52oa2lHS+sDJQlUZXM=;
 b=m9bvhDp9vpcWKFbznXXLtRTWAV3qY17CTaLWiUvZEYOk8afc4ZW5tmsAhuh83RZy0P0/1VY/DrkOd6tKNY55+Cgp1O4/9oc21XWByFYk+n4t3oLIr5Kep6Yb2q9Nn5xuNHyAwd/hbTO6agGy2pnHVbp90MI5aD8RW7XMqSrXWHsVRAVumutivSkr9CkX8XSxqn0niAUbnAcTFi8pAJ0mCoCenrzF2cfGa7YuhIeaDo8Wbmmd1HPov7DawfB0FMINoWflcDW03V1LYEP+A7kffFcMc/JvSvBosQhWZBuwrgITcJJfYarmSnXAufeY08w83DxFTuqhhgNn5SZ82iMyuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qsLY0NgXi1tm8IptIeayfybd52oa2lHS+sDJQlUZXM=;
 b=XRIrYXaCei+qxkDivcGNvZXpcB7dSpSM8r9UcXFVAWf/ClXm5cQirbcnMIniLj8w0Tle+K87rOj/Afrv/GZ9H+/RCDJdlqThuFk9OCc+y902WR9N9/WVTNx9b7UwTLMQgRcyD4XCcjCFdRunIa4prY9cTq/5/FSEBQOPlILUxp5ZVD0WLX+wZV/MuTol2oIjZoCllm+d7KzYUYurhw0qDw7aUFwdy9mtPAFuViatIdjHIP7WWW6G8Vw3jq5VVh46JRSpuwL4xBFTs6qvVIApRLPcRcoyoqx3lizox/DEbJlbZzi86Cp9jqNGSvxzzb2Ns8Y2dSx11CHM41PwX6u+VA==
Received: from SJ0PR03CA0248.namprd03.prod.outlook.com (2603:10b6:a03:3a0::13)
 by IA0PPF0A63E7557.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 9 Dec
 2025 16:52:43 +0000
Received: from SJ1PEPF00002311.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::45) by SJ0PR03CA0248.outlook.office365.com
 (2603:10b6:a03:3a0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:52:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002311.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:52:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:20 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:20 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:52:13 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 12/15] vfio/cxl: introduce the emulation of CXL configuration space
Date: Tue, 9 Dec 2025 22:20:16 +0530
Message-ID: <20251209165019.2643142-13-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002311:EE_|IA0PPF0A63E7557:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a9971a-ef1a-4651-18a3-08de37435f28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hLk15DCFxAxdQIx8WOOYP9h/aoK/Wxkep7dL0uPMLGjKB3aC7H1wHedwBdRi?=
 =?us-ascii?Q?WoQikgM6efLRxyZ+gMtcc7CiJqDBeLcHcdwUBhjcWfb7iVixO7hNhTPsnVca?=
 =?us-ascii?Q?DkN0k5VXjF7M7+25zdCHVz5dc9J2y7kVqPUGS+o3EnXAN/jEctsbz0S4ZRTt?=
 =?us-ascii?Q?A+s+BRofNcHl2zNBw+SHhv+FU4mOjScRs6WWpD/Bt8Icy10ZLWVD+YA3BknF?=
 =?us-ascii?Q?6CkaxGI+WYKNXFyMcZq/JXpq+YcKjETlUq8d0+cTVed/r+zxCvCGNQkXOSJP?=
 =?us-ascii?Q?1IfAP3MBpAgT2FiWMoRDYcZrtIuDGE6GWKPyo/MZYGq2p9EDvdltWFZTo7NM?=
 =?us-ascii?Q?UwU0WZp986GaxtOLnL4+r21DKJ4UprlzJKa/7IRlg5X5jWHve9x0S6tb9/wp?=
 =?us-ascii?Q?RXxl46FA1d18bdq3BU0tJ2Faxdc3EQRfzfJRLM9PE48UMZi5faUiHUti2/4l?=
 =?us-ascii?Q?nPNTgf4KUY76TuYXIbD8Hv9GHQdK+kCOrbFJPz4S1P8+niA+IR884AjkBo4G?=
 =?us-ascii?Q?PRCHlLS4/1u0tSBJUZU5TAC4WEyj0RSe238Dp0Yepa/NOk4etQamOUBukdgX?=
 =?us-ascii?Q?Qk+QReFXKT6b4A/s3/aznaTjdbvkg4FcZ6jZeBC2aFPH1hHtfKCqV1O39ekU?=
 =?us-ascii?Q?qi9BCbN+1K13aHoSj25NNVajwS0jD+isZs1UzhoLWok+o8cZ++bGoHqLrUy8?=
 =?us-ascii?Q?PJhsKJ/pyjPqnOYYN6L7qaBpNUNlLhlCgnd2AWKmEVCkQTnR6PH+AOFT6MTA?=
 =?us-ascii?Q?0FjCP+VpR/xt8JSnY7tSiIN58gxerqvm8xVQJSqA+IAekz4cygsuAeq0F1F5?=
 =?us-ascii?Q?I4iRlGKkxHH1ckEVKGKpFsaJEzkqOlniyJfzXCUR5xs+Cy8P9W3Q1Zi5A8iy?=
 =?us-ascii?Q?l4OzCMwdDgzNsADmOL8dQl3E3GDnm8sBUGJdupAxo4g29lS5z5+olOi7/MCx?=
 =?us-ascii?Q?W7SkuerM5/HlhPA61wMMlCvwAKYZRik2w+9ADZNq86bWoa4Shf88ZNyTdL72?=
 =?us-ascii?Q?IneRQW0SvLjKTpqlKg7cuDPMTvUKE2IjdUBPJITXUyz3QFBrcoonZynXm45y?=
 =?us-ascii?Q?l3Wo1U0v/F2p0O07iFz/GCcb09I8b9MwYorqodmjgSHmIOGCD/qKYqs+ZWCu?=
 =?us-ascii?Q?JAdYgM48WU0Fb7Y27YyI8/JmCw9oopXiXUMx7lBPCA7OVc00nbbom2qoNFf+?=
 =?us-ascii?Q?vgV0NOppTRppOnZOL7jRozusbWTD7D/aksMwpnVI0/TIomZGnMCTCbO4GF0y?=
 =?us-ascii?Q?wVxgMbxkAfkf+nyklmHmtsR0xyNoSsYwElZ8JEmQS5IslMLomngoLLOwElrr?=
 =?us-ascii?Q?QHTi/dX9H1rfne6BQq0MBTRcFxVOflmd8DMQfWJqckGKQWcjgTSmwV8pcrGj?=
 =?us-ascii?Q?2c/E3w8jBq86/xHX0LlVkUOrHPEGAP8df1ftIc3vzSkZfMyjmqLsnxFF8sZq?=
 =?us-ascii?Q?eOSywjmmccSCQMIsPURCGTpVqpXoZ5xk89QTsYBEcz1WBNWXcicCrgiCFolI?=
 =?us-ascii?Q?vg4z/hCHt3J4FinFxEm+M4uJoO/Sw1KbyhCeQmYk9hWlaZhUY4CpgLwXAE6a?=
 =?us-ascii?Q?8JYqr7dNol3UVs04pRCrhN1bYGHAHhZhgFvG5PC4?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:43.1202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a9971a-ef1a-4651-18a3-08de37435f28
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002311.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF0A63E7557

From: Zhi Wang <zhiw@nvidia.com>

CXL devices have CXL DVSEC registers in the configuration space.
Many of them affects the behaviors of the devices. E.g. enabling
CXL.io/CXL.mem/CXL.cache.

However, these configuration are owned by the host and a virtualization
policy should be applied when handling the access from the guest.

Introduce the emulation of CXL configuration space to handle the access
of the virtual CXL configuration space from the guest.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core_emu.c | 340 ++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_config.c   |  10 +-
 include/linux/vfio_pci_core.h        |   4 +
 3 files changed, 346 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core_emu.c b/drivers/vfio/pci/vfio_cxl_core_emu.c
index 6711ff8975ef..8037737838ba 100644
--- a/drivers/vfio/pci/vfio_cxl_core_emu.c
+++ b/drivers/vfio/pci/vfio_cxl_core_emu.c
@@ -28,6 +28,334 @@ new_reg_block(struct vfio_cxl_core_device *cxl, u64 offset, u64 size,
 	return block;
 }
 
+static int new_config_block(struct vfio_cxl_core_device *cxl, u64 offset,
+			    u64 size, reg_handler_t *read, reg_handler_t *write)
+{
+	struct vfio_emulated_regblock *block;
+
+	block = new_reg_block(cxl, offset, size, read, write);
+	if (IS_ERR(block))
+		return PTR_ERR(block);
+
+	list_add_tail(&block->list, &cxl->config_regblocks_head);
+	return 0;
+}
+
+static ssize_t virt_config_reg_read(struct vfio_cxl_core_device *cxl, void *buf,
+				    u64 offset, u64 size)
+{
+	memcpy(buf, cxl->config_virt + offset, size);
+	return size;
+}
+
+static ssize_t virt_config_reg_write(struct vfio_cxl_core_device *cxl, void *buf,
+				     u64 offset, u64 size)
+{
+	memcpy(cxl->config_virt + offset, buf, size);
+	return size;
+}
+
+static ssize_t hw_config_reg_read(struct vfio_cxl_core_device *cxl, void *buf,
+				  u64 offset, u64 size)
+{
+	return vfio_user_config_read(cxl->pci_core.pdev, offset, buf, size);
+}
+
+static ssize_t hw_config_reg_write(struct vfio_cxl_core_device *cxl, void *buf,
+				   u64 offset, u64 size)
+{
+	__le32 write_val = *(__le32 *)buf;
+
+	return vfio_user_config_write(cxl->pci_core.pdev, offset, write_val, size);
+}
+
+static ssize_t cxl_control_write(struct vfio_cxl_core_device *cxl, void *buf,
+				 u64 offset, u64 size)
+{
+	u16 lock = le16_to_cpu(*(u16 *)(cxl->config_virt + cxl->dvsec + 0x14));
+	u16 cap3 = le16_to_cpu(*(u16 *)(cxl->config_virt + cxl->dvsec + 0x38));
+	u16 new_val = le16_to_cpu(*(u16 *)buf);
+	u16 rev_mask;
+
+	if (WARN_ON_ONCE(size != 2))
+		return -EINVAL;
+
+	/* register is locked */
+	if (lock & BIT(0))
+		return size;
+
+	/* handle reserved bits in the spec */
+	rev_mask = BIT(13) | BIT(15);
+
+	/* no direct p2p cap */
+	if (!(cap3 & BIT(4)))
+		rev_mask |= BIT(12);
+
+	new_val &= ~rev_mask;
+
+	/* CXL.io is always enabled. */
+	new_val |= BIT(1);
+
+	memcpy(cxl->config_virt + offset, &new_val, size);
+	return size;
+}
+
+static ssize_t cxl_status_write(struct vfio_cxl_core_device *cxl, void *buf,
+				u64 offset, u64 size)
+{
+	u16 cur_val = le16_to_cpu(*(u16 *)(cxl->config_virt + offset));
+	u16 new_val = le16_to_cpu(*(u16 *)buf);
+	u16 rev_mask = GENMASK(13, 0) | BIT(15);
+
+	if (WARN_ON_ONCE(size != 2))
+		return -EINVAL;
+
+	/* handle reserved bits in the spec */
+	new_val &= ~rev_mask;
+
+	/* emulate RW1C bit */
+	if (new_val & BIT(14)) {
+		new_val &= ~BIT(14);
+	} else {
+		new_val &= ~BIT(14);
+		new_val |= cur_val & BIT(14);
+	}
+
+	new_val = cpu_to_le16(new_val);
+	memcpy(cxl->config_virt + offset, &new_val, size);
+	return size;
+}
+
+static ssize_t cxl_control_2_write(struct vfio_cxl_core_device *cxl, void *buf,
+				   u64 offset, u64 size)
+{
+	struct pci_dev *pdev = cxl->pci_core.pdev;
+	u16 cap2 = le16_to_cpu(*(u16 *)(cxl->config_virt + cxl->dvsec + 0x16));
+	u16 cap3 = le16_to_cpu(*(u16 *)(cxl->config_virt + cxl->dvsec + 0x38));
+	u16 new_val = le16_to_cpu(*(u16 *)buf);
+	u16 rev_mask = GENMASK(15, 6) | BIT(1) | BIT(2);
+	u16 hw_bits = BIT(0) | BIT(1) | BIT(3);
+	bool initiate_cxl_reset = new_val & BIT(2);
+
+	if (WARN_ON_ONCE(size != 2))
+		return -EINVAL;
+
+	/* no desired volatile HDM state after host reset */
+	if (!(cap3 & BIT(2)))
+		rev_mask |= BIT(4);
+
+	/* no modified completion enable */
+	if (!(cap2 & BIT(6)))
+		rev_mask |= BIT(5);
+
+	/* handle reserved bits in the spec */
+	new_val &= ~rev_mask;
+
+	/* bits go to the HW */
+	hw_bits &= new_val;
+
+	/* update the virt regs */
+	new_val = cpu_to_le16(new_val);
+	memcpy(cxl->config_virt + offset, &new_val, size);
+
+	if (hw_bits)
+		pci_write_config_word(pdev, offset, cpu_to_le16(hw_bits));
+
+	if (initiate_cxl_reset) {
+		/* TODO: call linux CXL reset */
+	}
+	return size;
+}
+
+static ssize_t cxl_status_2_write(struct vfio_cxl_core_device *cxl, void *buf,
+				  u64 offset, u64 size)
+{
+	struct pci_dev *pdev = cxl->pci_core.pdev;
+	u16 cap3 = le16_to_cpu(*(u16 *)(cxl->config_virt + cxl->dvsec + 0x38));
+	u16 new_val = le16_to_cpu(*(u16 *)buf);
+
+	if (WARN_ON_ONCE(size != 2))
+		return -EINVAL;
+
+	/* write RW1CS if supports */
+	if ((cap3 & BIT(2)) && (new_val & BIT(3)))
+		pci_write_config_word(pdev, offset, BIT(3));
+
+	/* No need to update the virt regs, CXL status reads from the HW */
+	return size;
+}
+
+static ssize_t cxl_lock_write(struct vfio_cxl_core_device *cxl, void *buf,
+			      u64 offset, u64 size)
+{
+	u16 cur_val = le16_to_cpu(*(u16 *)(cxl->config_virt + offset));
+	u16 new_val = le16_to_cpu(*(u16 *)buf);
+	u16 rev_mask = GENMASK(15, 1);
+
+	if (WARN_ON_ONCE(size != 2))
+		return -EINVAL;
+
+	/* LOCK is not allowed to be cleared unless conventional reset. */
+	if (cur_val & BIT(0))
+		return size;
+
+	/* handle reserved bits in the spec */
+	new_val &= ~rev_mask;
+
+	new_val = cpu_to_le16(new_val);
+	memcpy(cxl->config_virt + offset, &new_val, size);
+	return size;
+}
+
+static ssize_t cxl_base_lo_write(struct vfio_cxl_core_device *cxl, void *buf,
+				 u64 offset, u64 size)
+{
+	u32 new_val = le32_to_cpu(*(u32 *)buf);
+	u32 rev_mask = GENMASK(27, 0);
+
+	if (WARN_ON_ONCE(size != 4))
+		return -EINVAL;
+
+	/* handle reserved bits in the spec */
+	new_val &= ~rev_mask;
+
+	new_val = cpu_to_le32(new_val);
+	memcpy(cxl->config_virt + offset, &new_val, size);
+	return size;
+}
+
+static ssize_t virt_config_reg_ro_write(struct vfio_cxl_core_device *cxl, void *buf,
+					u64 offset, u64 size)
+{
+	return size;
+}
+
+static int setup_config_emulation(struct vfio_cxl_core_device *cxl)
+{
+	u16 offset;
+	int ret;
+
+#define ALLOC_BLOCK(offset, size, read, write) do {		\
+	ret = new_config_block(cxl, offset, size, read, write); \
+	if (ret)						\
+		return ret;					\
+	} while (0)
+
+	ALLOC_BLOCK(cxl->dvsec, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	ALLOC_BLOCK(cxl->dvsec + 0x4, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	ALLOC_BLOCK(cxl->dvsec + 0x8, 2,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	/* CXL CAPABILITY */
+	ALLOC_BLOCK(cxl->dvsec + 0xa, 2,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	/* CXL CONTROL */
+	ALLOC_BLOCK(cxl->dvsec + 0xc, 2,
+		    virt_config_reg_read,
+		    cxl_control_write);
+
+	/* CXL STATUS */
+	ALLOC_BLOCK(cxl->dvsec + 0xe, 2,
+		    virt_config_reg_read,
+		    cxl_status_write);
+
+	/* CXL CONTROL 2 */
+	ALLOC_BLOCK(cxl->dvsec + 0x10, 2,
+		    virt_config_reg_read,
+		    cxl_control_2_write);
+
+	/* CXL STATUS 2 */
+	ALLOC_BLOCK(cxl->dvsec + 0x12, 2,
+		    hw_config_reg_read,
+		    cxl_status_2_write);
+
+	/* CXL LOCK */
+	ALLOC_BLOCK(cxl->dvsec + 0x14, 2,
+		    virt_config_reg_read,
+		    cxl_lock_write);
+
+	/* CXL CAPABILITY 2 */
+	ALLOC_BLOCK(cxl->dvsec + 0x16, 2,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	/* CXL RANGE 1 SIZE HIGH & LOW */
+	ALLOC_BLOCK(cxl->dvsec + 0x18, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	ALLOC_BLOCK(cxl->dvsec + 0x1c, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	/* CXL RANG BASE 1 HIGH */
+	ALLOC_BLOCK(cxl->dvsec + 0x20, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_write);
+
+	/* CXL RANG BASE 1 LOW */
+	ALLOC_BLOCK(cxl->dvsec + 0x24, 4,
+		    virt_config_reg_read,
+		    cxl_base_lo_write);
+
+	/* CXL RANGE 2 SIZE HIGH & LOW */
+	ALLOC_BLOCK(cxl->dvsec + 0x28, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	ALLOC_BLOCK(cxl->dvsec + 0x2c, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	/* CXL RANG BASE 2 HIGH */
+	ALLOC_BLOCK(cxl->dvsec + 0x30, 4,
+		    virt_config_reg_read,
+		    virt_config_reg_write);
+
+	/* CXL RANG BASE 2 LOW */
+	ALLOC_BLOCK(cxl->dvsec + 0x34, 4,
+		    virt_config_reg_read,
+		    cxl_base_lo_write);
+
+	/* CXL CAPABILITY 3 */
+	ALLOC_BLOCK(cxl->dvsec + 0x38, 2,
+		    virt_config_reg_read,
+		    virt_config_reg_ro_write);
+
+	while ((offset = pci_find_next_ext_capability(cxl->pci_core.pdev,
+						      offset,
+						      PCI_EXT_CAP_ID_DOE))) {
+		ALLOC_BLOCK(offset + PCI_DOE_CTRL, 4,
+			    hw_config_reg_read,
+			    hw_config_reg_write);
+
+		ALLOC_BLOCK(offset + PCI_DOE_STATUS, 4,
+			    hw_config_reg_read,
+			    hw_config_reg_write);
+
+		ALLOC_BLOCK(offset + PCI_DOE_WRITE, 4,
+			    hw_config_reg_read,
+			    hw_config_reg_write);
+
+		ALLOC_BLOCK(offset + PCI_DOE_READ, 4,
+			    hw_config_reg_read,
+			    hw_config_reg_write);
+	}
+
+#undef ALLOC_BLOCK
+
+	return 0;
+}
+
 static int new_mmio_block(struct vfio_cxl_core_device *cxl, u64 offset, u64 size,
 			  reg_handler_t *read, reg_handler_t *write)
 {
@@ -179,10 +507,10 @@ static int setup_mmio_emulation(struct vfio_cxl_core_device *cxl)
 
 	base = hdm_reg_base(cxl);
 
-#define ALLOC_BLOCK(offset, size, read, write) do {			\
-		ret = new_mmio_block(cxl, offset, size, read, write);	\
-		if (ret)						\
-			return ret;					\
+#define ALLOC_BLOCK(offset, size, read, write) do { \
+	ret = new_mmio_block(cxl, offset, size, read, write); \
+	if (ret) \
+		return ret; \
 	} while (0)
 
 	ALLOC_BLOCK(base + 0x4, 4,
@@ -255,6 +583,10 @@ int vfio_cxl_core_setup_register_emulation(struct vfio_cxl_core_device *cxl)
 	INIT_LIST_HEAD(&cxl->config_regblocks_head);
 	INIT_LIST_HEAD(&cxl->mmio_regblocks_head);
 
+	ret = setup_config_emulation(cxl);
+	if (ret)
+		goto err;
+
 	ret = setup_mmio_emulation(cxl);
 	if (ret)
 		goto err;
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 8f02f236b5b4..4847d09e58b4 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -120,8 +120,8 @@ struct perm_bits {
 #define	NO_WRITE	0
 #define	ALL_WRITE	0xFFFFFFFFU
 
-static int vfio_user_config_read(struct pci_dev *pdev, int offset,
-				 __le32 *val, int count)
+int vfio_user_config_read(struct pci_dev *pdev, int offset,
+			  __le32 *val, int count)
 {
 	int ret = -EINVAL;
 	u32 tmp_val = 0;
@@ -150,9 +150,10 @@ static int vfio_user_config_read(struct pci_dev *pdev, int offset,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_user_config_read);
 
-static int vfio_user_config_write(struct pci_dev *pdev, int offset,
-				  __le32 val, int count)
+int vfio_user_config_write(struct pci_dev *pdev, int offset,
+			   __le32 val, int count)
 {
 	int ret = -EINVAL;
 	u32 tmp_val = le32_to_cpu(val);
@@ -171,6 +172,7 @@ static int vfio_user_config_write(struct pci_dev *pdev, int offset,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_user_config_write);
 
 static int vfio_default_config_read(struct vfio_pci_core_device *vdev, int pos,
 				    int count, struct perm_bits *perm,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 31fd28626846..8293910e0a96 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -201,6 +201,10 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
 			       size_t x_end, bool iswrite);
+int vfio_user_config_read(struct pci_dev *pdev, int offset,
+			  __le32 *val, int count);
+int vfio_user_config_write(struct pci_dev *pdev, int offset,
+			   __le32 val, int count);
 bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t reg_start, size_t reg_cnt,
 					 loff_t *buf_offset,
-- 
2.25.1


