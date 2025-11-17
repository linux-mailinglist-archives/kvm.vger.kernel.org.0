Return-Path: <kvm+bounces-63378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A6CC642E3
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 13:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id E06A428DFE
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D27F33A029;
	Mon, 17 Nov 2025 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uJvmgqaf"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8C1339705;
	Mon, 17 Nov 2025 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763383352; cv=fail; b=bqhH6OaMnS5VVhfucaSLy082KUh/yTCLopHqB6lO9nCwnlLKPB7Uow/urHQ24y3fqCpp48ns6sRDtI7BTHxq0vGDiFO/acVnIqMsVV2yClcDV7UTOcbGkrUQXy7WTBz8vXX0OpodmATf+SfYKHMisirzfH91w7QVPvdUXN3FiTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763383352; c=relaxed/simple;
	bh=N7+zYOdrJZ7FIL476RpLrz5wXoXB6jWLw/EraOMqSBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXgW09LhuJKwj1sxc7musSM59vHH16YiOWlt8ID2ToEVxdV8encVDbGdvXerZrLP595LBV8gTeeGM/KGsbRqOL6HmlgsntMbclkrBfVSqyLHXKiiZWFITRYF5f9oUNC/w0ECwEVhUuC6u60qnMC1FyuN4wY1uEM20h60nb0dIHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uJvmgqaf; arc=fail smtp.client-ip=40.107.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzICzWacJyZZAQdnCKtb6mhf/E3mk6o38+TeVWxfGil1JtRGzxgTbNbizzIUtwtLpwyLzITlf4u211Rqa7+irg59Dp0YjRs+KlKEAC2ifNyr5RJooiGwjXupUu6jQsQlwUOH9dLkIjd623yaXdC0vRiV91tYm9Cb7SLk27dGmTYMMXRMjcLynS6ZvdBm0AuECZK+k3tPAhNedtSyNyo+z6FWHeW0Nkyj+KmsiJ++Rw0sBYPu8yOtvC7SfuD89hBmAlrYdXkQHPgG0uTE4pZ+8N38TIvBjF+iLN54p63tZVwre26FhP/HcLjv0swZO16kpn8pXl77GJdMJkpd9eK6FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gIwnXlwC5nA45FDLzSeoV2hjFrKoOSTsb3afesgyis=;
 b=OvKQ3Bn7WnhQOOPADxIixyyXaHBwf9fO1GMekOHy/JVvnAQYwCxW1VLA1aO6GiVC0A0FXT+FxjnR8VwMIuDFX6mgFnHpgFhzOUKf3TmiZ4BMQv5ciKOyYyDyATNvMpMJiXzkuXp4swXD5JSXoVEFoz0E3FPmSwuB/1ajMSHB48/r3GsJVT4rBqOZBtrq9A0XLUxgUItia6/UprZZZvWwJqPxHMnMI4pTgj+tLjq5oEcyOqjCtcFoDTo9Iayj6UtkXQwSHMnsoAx/UBz0nSwSQ9/ar3SYC+KT6HjFMi1X2llOJ8DLpAyLP16NyIAye02k9L7y74LwaSwm+TrI/VUGIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gIwnXlwC5nA45FDLzSeoV2hjFrKoOSTsb3afesgyis=;
 b=uJvmgqafnP/Hdru5HzORBkoST4zpAEWRFSXn8MWapSZl5FGfkNQtxdL60VBa1lUpzgANg+grrgkQ3tXwOgdKlOgMBTA5xEwh3Xspem/GZ3jSMcywP6/xLUNNVWOueGqAAKJNo/bN6XzUu2zb9R1v/wH7CClfRQ/Cwh9ATDGmcg7zYUXu0R+EBzKXVaR57W6941nAJvkcQem2/vYhXQNoURo12Roh+Bmx4f6e3elScuImicuGxhTZztj8vqzao/7QI5zb1/eWHMzYQDRD9cT5yR4aFrdfnqvCqbwTdCGHI1U0cgdEzwq/W2Qf5JH/ipD8EEPqWQmT2CPKsv6EROqF5A==
Received: from BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::7)
 by IA0PR12MB9045.namprd12.prod.outlook.com (2603:10b6:208:406::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 12:42:26 +0000
Received: from MN1PEPF0000ECD7.namprd02.prod.outlook.com
 (2603:10b6:208:32c:cafe::c9) by BLAP220CA0002.outlook.office365.com
 (2603:10b6:208:32c::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Mon,
 17 Nov 2025 12:42:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD7.mail.protection.outlook.com (10.167.242.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Mon, 17 Nov 2025 12:42:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:06 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:05 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 04:42:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v1 4/6] vfio: export vfio_find_cap_start
Date: Mon, 17 Nov 2025 12:41:57 +0000
Message-ID: <20251117124159.3560-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251117124159.3560-1-ankita@nvidia.com>
References: <20251117124159.3560-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD7:EE_|IA0PR12MB9045:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a5a1a24-57e7-45e0-c2eb-08de25d6c327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eiYE9J1Op7O2WOPSg5wUd06eEzh2GCtkwiR4XYAoJaiRZo2CuCscTcfdS2fg?=
 =?us-ascii?Q?/gg4zlRo8o6aOJVXiOtRkvFaX+XQvwyEen33/1OnD+KdTC9It3g0W8tGTdBX?=
 =?us-ascii?Q?5H1peYCyDNUXfoiHq6bVaE22XjhI18ajEjtodNLErmZHH6bujVb/eRzPcsTJ?=
 =?us-ascii?Q?+deUxY4qWwF0PRaH/ivVtjTiSt5zx63YewNPXKGmjwoEYs5ZhhmpV1IhtxRE?=
 =?us-ascii?Q?sirP8F5qwVW6p0P/Mg0lLrO86pWDgWXFD0UcHCSAcaHFPqdWPDJ9q3bpwb4u?=
 =?us-ascii?Q?DwcCd4WB7iBtfTYc09qrRjp/nGCJfU6+daAPo8bWLyIx6MDXui+J0CIb0sNV?=
 =?us-ascii?Q?C35bqis/uielymGIuo7rR2caimj0OwxkeGuIEOpi4encDwtkOagruV3St4m+?=
 =?us-ascii?Q?5JgV2w4qYy/N9aqYdiDnzBvvhlq7BWqlRfairo/RbnagcN8/J6h1/AboQdmC?=
 =?us-ascii?Q?sfMVWVyIvfl4eSHHyLmcsaHpLmx/HbTiYvCvZwgj8tLfBLS0F2tgCnQAR23y?=
 =?us-ascii?Q?JMnQZWtKJfG1iA5pyGZcKHVlVA5yoKI33h7qGVoNoT9LvPYMPtNLWbqsS4MN?=
 =?us-ascii?Q?mNmhYf3Z95fSSX1lZYd5Yh0e95c4jcZhAHZ4o/mYwLWu2MODfx+u4OsS4Txw?=
 =?us-ascii?Q?MyNCAfvTvAi5G23vKSMPqR2k3u8OETvMTkx+UANmlAIGcWIlTyYpDheZ7grt?=
 =?us-ascii?Q?0clYdY+Oje4iDuBMGDPyKv5U+C9MzM1GirPlAVgGaC8osH9kVVkaPIwtaT41?=
 =?us-ascii?Q?P0U6ygG7oVOEJ3cDvs558cqNR0qJQjvihR/gwYtDhTITSTrHTKYOh8CHSaXw?=
 =?us-ascii?Q?RzgoOSumswt39VQeC1VjiaY26l8fn9PWBkFbYWxxhuPwEAYENwMNKh+WX/AH?=
 =?us-ascii?Q?VNIG/OTAVW+hh64itXnNH79Ys10TeKmS/GDAYvGgaUcByfpZjO2bW/EFWybf?=
 =?us-ascii?Q?10tgBxjG6cBajhsqex0x8teSKVtwbTjnHZKOgD1EYof9KLHOKU2qpO7C7/UK?=
 =?us-ascii?Q?VV763FWshwJiVUabewyfJHYN+z08jbVjXdS1kbT82E8oaG30VBsEPPnygBpK?=
 =?us-ascii?Q?x13/Bn6DjvPJSqxv+V7OEOD/YjSGGi0DAwlP42R8/4QOzkyzG8QH/WU06ETn?=
 =?us-ascii?Q?exWOeChomLE8ERDBQUJtY/Cv6VUOzRqn+A6Bx0SiyLzlkU5YbA3IYB1gBlHg?=
 =?us-ascii?Q?gWeKqW30yX0tq5z608tSLWP04fhngYRwuV++kB30xu/KjAf0UH4UTCY8OXc+?=
 =?us-ascii?Q?iYuXQgVnTYvX4SZTQjZuANY8h0RXHKvongYu6hd0pE/AojqQhIGccnNFNd5d?=
 =?us-ascii?Q?Cqyg/48mFlA2R3UkWeEslzdPC0S/O14joUKX6iqXOElG3Jw4qZD4XCtCr81E?=
 =?us-ascii?Q?eWBLhTPy5BDzPCiG+b46SUFMwrki0vFZHfq73ziV/zGnO1GFUl4LNQm52XFp?=
 =?us-ascii?Q?P1r1nXGBbDID+GapS0FCHu31hMaXKHMzLev+DQibHP8xHxtUITmUcMsrGcOW?=
 =?us-ascii?Q?Hf3wLTKz0eKaQhPnFvL1ji9U9ECA0qevU9Q7swcdnL8XANbSnNsFtbA4nb50?=
 =?us-ascii?Q?/TMimlVEMXjlTmw/U/A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 12:42:25.8656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5a1a24-57e7-45e0-c2eb-08de25d6c327
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9045

From: Ankit Agrawal <ankita@nvidia.com>

Export vfio_find_cap_start to be used by the nvgrace-gpu module.
This would be used to determine GPU FLR requests.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 3 ++-
 include/linux/vfio_pci_core.h      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 333fd149c21a..50390189b586 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1114,7 +1114,7 @@ int __init vfio_pci_init_perm_bits(void)
 	return ret;
 }
 
-static int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
+int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
 {
 	u8 cap;
 	int base = (pos >= PCI_CFG_SPACE_SIZE) ? PCI_CFG_SPACE_SIZE :
@@ -1130,6 +1130,7 @@ static int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
 
 	return pos;
 }
+EXPORT_SYMBOL_GPL(vfio_find_cap_start);
 
 static int vfio_msi_config_read(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 058acded858b..a097a66485b4 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -132,6 +132,7 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
+int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos);
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-- 
2.34.1


