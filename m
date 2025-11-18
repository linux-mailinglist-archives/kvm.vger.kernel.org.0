Return-Path: <kvm+bounces-63507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8452DC6811C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 401DE3823F0
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FFA305E2D;
	Tue, 18 Nov 2025 07:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aZi5Jsjq"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B537305047;
	Tue, 18 Nov 2025 07:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451888; cv=fail; b=MuMrzEuudxTBjydmZ22lxDgf/svegIBb7elIWbG/pBsb1Hvo9Ci8JEi9pIZR+V5LFG32h9FStgIsIuznZoHdRN+ZID91v9lj2srt6CPLwZS2ar1CAgMXDx+Q0tULEvZfo7aCgO+U99MqlrZldePc4qUvRcElNUHTmhL7qVPZnV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451888; c=relaxed/simple;
	bh=N7+zYOdrJZ7FIL476RpLrz5wXoXB6jWLw/EraOMqSBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJcsMnTxzpJJXQaciARgNcQ5uxGkloZHEh8+tQUusDiuT0syV3A/c1VpUAozkhyRoIWLT7F22yISBHxeGCAsjcs1UpeGG9BGm/HihsKVJP7Fhk8PDp2QzvhItc0mi4prv3214PuW4z6yZsE4GfChMbraxMSQ698VYbFGbO2SXkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aZi5Jsjq; arc=fail smtp.client-ip=40.107.200.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XvdfkqMcmjw8eIr28CatL86KeBqUePMuEFwl9lHQIx+lGaBGthcvm0nmzKKE3HvPL2y6lyjxjAC9jeocFG7fZIMrvkATiEI5e2ck5726SQ+4oGLspHrCB5jpUgnG/5kWCslBBw1XJyGvA2My9Ahuz1vOBCFl+39V8xQG3ICocoCgNFckA1df5HbfFEr+BAjSODPEoHp94UN5Bmms1MzgYsh3Zg1HvJNN35uYKftQU0zYYjIOgkUfTyhYH4BRzPOLnARWhCRUNPcQFXES6+uI+DWp27Z4TJLMwK67iy3QRI9r8O16XBlRTY5Nw/1GuSyaAaxg0mzeja80SZOTSTbVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gIwnXlwC5nA45FDLzSeoV2hjFrKoOSTsb3afesgyis=;
 b=EwjVzCHt9CgFU76CnNmvaeSB/n6anrtqOBHmEQxwgkxegce7G5cN9HRNX6agaOzbRK5/iNm38aoP81WPJ3S2l1rmNiEWB0/zui5nM4k7pVKiNRF5yf+26kpPEJ/Ik0I7EOMwwIahl0w8/BaEA9oUCeZhkLtEn7AayruoJuL4kotrcSBhQ3pOZgaHZtFLhpuZV5tnwUaQ7o65QDoKCI/37Zr+KVamfFGnz4W1J13A8JCc9zrQizW0PUdpHHHfsU0h9iift1B0T4iIZIR1Z0+FZ6HwORvQGMxOmqksC9XZZ90ZUzzBb5gpclHYyjWNp3hYUGMU/eZfLP8ejHAc/ifmDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gIwnXlwC5nA45FDLzSeoV2hjFrKoOSTsb3afesgyis=;
 b=aZi5JsjqmYRKAyGCch2ujR6ekJMW9vedV7crJ/e8wRaA1RfEhS/c4iQcOY/hyCNilmDtOmnUywJpI//F39PP7eVjF7aiOXBdwpnR8Je06AI7TVL5UwmE+ilBDOsWotlh0GXWPjIJLQCU7WhKVPv6hDsBdwHAU4zW5wdUaQ84VosQe6Z08nm1Cf0pksRQRzg6UIrLTQKbepxwzBg6fCsROfRS/zpfjES5rHQhHdzDOYJ9KOyl8hU6QMRYGbQLTSBiPrNbOlShSFydAO2Pn8ftvjt2oSWryoW35on7usgmG5TeU18e5elkHmy891SAQs2luLd/mQvYdvPC+/1Lx4Sudw==
Received: from CH2PR18CA0021.namprd18.prod.outlook.com (2603:10b6:610:4f::31)
 by BY5PR12MB4308.namprd12.prod.outlook.com (2603:10b6:a03:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 07:44:42 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:4f:cafe::a3) by CH2PR18CA0021.outlook.office365.com
 (2603:10b6:610:4f::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 07:44:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 07:44:41 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:26 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:26 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 23:44:25 -0800
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
Subject: [PATCH v2 4/6] vfio: export vfio_find_cap_start
Date: Tue, 18 Nov 2025 07:44:20 +0000
Message-ID: <20251118074422.58081-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118074422.58081-1-ankita@nvidia.com>
References: <20251118074422.58081-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|BY5PR12MB4308:EE_
X-MS-Office365-Filtering-Correlation-Id: ca7249f5-6819-4d5d-a0e3-08de267655a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mmGqQKQ7s8zfggXUIsBkQoFWZKtckpcjLnS2dpv8JhagYaNBIHZlmI7XoyeS?=
 =?us-ascii?Q?PnvTVhuYVlG3JZh3lSoEDBuzooR9Mg9sphu6AZjhr11tIGF/nny0G8p+tTdA?=
 =?us-ascii?Q?wlMEn0PJuoX/4Eug3mw81hk+GcZsnMw2WBQ/GXNzwIxSFEhkm+1k7xbB98FP?=
 =?us-ascii?Q?D4n0cYE7UhrVmbKznMpt5O8THg629EYEoLrU0kYHXwkdNzRI/3ewUcKnoCsq?=
 =?us-ascii?Q?J6nlBzDbN3QRXW0KliGKXESVeXF22BshlxVwyHCIAuwA/c/78oCNVufVFff3?=
 =?us-ascii?Q?oOWO4kDpi7KFzC9+59eIyIRslIBCuWWerAz5Y3Zc3s5F+JMabipUz08HBHN6?=
 =?us-ascii?Q?eOJcpRD9Gxl5s7Er/hhETmMhzfs71QXaHyVTK9TSI3EvH3dDpOjdx3gXw7AV?=
 =?us-ascii?Q?XLWvjhixOFzxlOMO/HV/kmmrOHHBO6s2Zdlcpp/g3Igxd/ALyMNCtSF9B7GX?=
 =?us-ascii?Q?pGtdPBBSqibkxWr9z3OhbFFsbW0Qou5YOX/B/phbd6dzI4E0Zevydhqsm0e4?=
 =?us-ascii?Q?BLolWTieLyO/csn2HRLgR6G+8BCz4wnVl+wjAd37xgEpqATb3WfL/qUFBLVY?=
 =?us-ascii?Q?ejXWkA5sLPGF+K4dEaozY1cHtDdAsJrpNxtvvoA6v42vxYr/dqDDj8BuW1GY?=
 =?us-ascii?Q?L7svLpnwg+LLSYjGLSIbIsfMiz57bQW3sjxgoHk7P3+ciFZDIU/NAduAdrz8?=
 =?us-ascii?Q?j6Oh00mfEwtm9XiZkBMNcv1EZJ0VfnCUpFD7lTvR6j6hTF8+wMG9F6kHbNWg?=
 =?us-ascii?Q?csUsyVc+MipbfYX+9XAmOx8Uf1Yzz7C6VShs6oIeS9tjTA/McTC7Mxnf29Sq?=
 =?us-ascii?Q?z75Un9uF6en2qNg+0CbJDP1ppKrov6A5DfrGy2SSc5U3GELEJBsn7xV42eYk?=
 =?us-ascii?Q?am1CEl4Mbt9raIbgUzV6vfVlfI9UEXQsqWuAeNNbt24pquqWiYM4n/UrcrRu?=
 =?us-ascii?Q?Ac7saMP3vK4Ir30Aewe8Y4eS1pWc0mEJc3yLpmtwOpyhQNxbp6DyeIYSIvNu?=
 =?us-ascii?Q?nQmCHJZ09G2b0XsqaqrSqgvBsXMJsIE5PB4oo05siG00U1nhkAoDmSRKx8EC?=
 =?us-ascii?Q?eCxt87amyXgkqAdb3s6Z/X+O6ydyHaB/4bjz6LihIz4uEg7QdIPSZmRYk+nJ?=
 =?us-ascii?Q?gNRSr8FjlLOSnrawENgMKu7cvEPlIqdGTLfLd+y72tzwg65ZV6kLLEUVUqTD?=
 =?us-ascii?Q?mQnp2Qe8uMn4hjwCQ++CrWIyaTDZWyUguRwQ60Ap2M1Uo05rDVhVqR0/t1IW?=
 =?us-ascii?Q?24snUr5JDst8zOaYadXwKSN1fA8cxD4PiBfl1HhvsBl7VCTqvdFvZndvwFUW?=
 =?us-ascii?Q?jyaDtBYtnMkZof+Zyb5mOu9vM4OIEp/qqq1jw3o4AVA85PLhzFZe4ea2ZDzn?=
 =?us-ascii?Q?aL4+8kyDFN+tEcFsC41oRzdHrGW6wr1+3tpfJjFWLd/Y4/xJLzjrNTRWGktM?=
 =?us-ascii?Q?jIir1UczUOrkHyj2a/2pA+stCIjwt0d9cusb9P8Lf1YRFDHvjJhU9quaxBN7?=
 =?us-ascii?Q?xqw5Jf0m04JsSgbWDtTPRsrRbQcBJsZF+LcnMjqVQeHNaWNwtnhr2BJVcGLc?=
 =?us-ascii?Q?wqgG7QjWht30frk3Hwo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:44:41.6687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7249f5-6819-4d5d-a0e3-08de267655a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4308

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


