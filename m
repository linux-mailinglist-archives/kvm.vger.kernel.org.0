Return-Path: <kvm+bounces-64528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F90FC86375
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 125A84E5074
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C5A32D0D2;
	Tue, 25 Nov 2025 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="orKbEzub"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9836E32C95A;
	Tue, 25 Nov 2025 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091852; cv=fail; b=aR8yF0E6f4Buo72i8exZfqC8er99IHngsPauI4D2Mzy7bIETOgELv18aZyml/bVyY+PGtO/Y4P1JbNPi8oFazhO9L1spL4mCahlSKmQkyM13ECc/VbgnOGj6dg9igDc9TFGTFA5dnV6M2UD6q9c/wQVqBpRTW0tD7FNKF3wsO6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091852; c=relaxed/simple;
	bh=GZSdlgjuxNNV7d9ISYTLvxiuS7noW9k529k+xXUcYis=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPA1rsO2YlN2Fu135EAQFd8II0VU7mkSHsKSuOM/qsZMEiI/dA2QWSmXAkhchtnUAgADQIp3GFtbMwAZ83MSM+cInMZAVusE9b4DiFjOapXTF6lRBJQAfDN4VZzYVyTP7blUNzXEcGQ6cUqYiQlD0ALwA2FMKx0JwMWn+4wSGOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=orKbEzub; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kzDt6k7I46W5jlZMoSh5CqjkTePYZ6JYf2a4GFq/MVdA/GzkZtXWhrhfTa3CxJPGe6FzlzXEVA+wtEI8BX/1nG1/Z+OctRtpRFlNmAuHJGJfeXLCQRHosN8q8dUJg/eDG/+okbRGjAfc45EMyBtGqZe0QWJRWIr2ZS0FowiqyXhIqp01CdNFvRZYxScxlgJ/gsQHh4aMK0XKWoeTcsewST7g+nXZN27mJjj2CXUEIsSxE3DlZyN3DrrI0qhgIuIrYed073vqJX68ro+KTa0eVN9akBK1Z8+/4rUrzhq9/KAwki62DPgfkGC1c2+DL7OvnUXm/3uamlqHk7SPa3eiUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEJ5AugDYwxrbouCVU97OCY3Toz/J5ATwz8lRguyiu8=;
 b=ICBHSjleDnIe6H94/GgJotGpWVl/tfAK2Cwhvgd7ugv/XMUzVYDtt7lz9OmlAxwneokwpnXX/afE2P+qDwvzAGAY8z6iTrL9h+rTwE0DvVsS9txjRClNS/jaQYkOlx10j2TRLR3TW/v4mfieJGqw6rb+T91rrh9E+Zas1BhJkMLS/5xtkLY/eGBNnoYJMnGwlwqKTrk3EdIG8jJ9X5gVlqznXLgV8V88WQx1qkngVOfPSKj0yDq4l6SoGJOUy6GgCWq9Lz2sVR6SU2PNbSuqmePN84rMe5ueUzUtkqtWIV4LgyOmVcYhniEhwISaNdAIwhUIFC8Cwj/xa/ViXNp4dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEJ5AugDYwxrbouCVU97OCY3Toz/J5ATwz8lRguyiu8=;
 b=orKbEzubjnd/vvluKR0sm6kc/I4Xjc/LuBRJntMuw+F6X3Mjf4SPRGRB8tUUhxlzOJx5Dg59Lco0EBVAjBz6mVcino75Gn0gjhuB4CxEXTws5wf5Q/SBAiV91UrKetA23DjEtIEVEakzfLetbkwQitx14uuv9t7+KLVXvKmZMBGX27/U4B81ZGsL0TipIen0IdygmsvFZmp7vJvdp4vGZr+AMEGhZvoUEt1XfPfku+TnNVaa1JgPAEIxv+Lgm7Jc4OzKrW78l8lR1j/WWzTOTnz+JU8W0lgK+lZ+YCDR6s34KwkVkzu7X3zp7MJ0S/G2DvL9KJ+urGA723BmQ08TFA==
Received: from BN1PR12CA0029.namprd12.prod.outlook.com (2603:10b6:408:e1::34)
 by SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 17:30:43 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::1c) by BN1PR12CA0029.outlook.office365.com
 (2603:10b6:408:e1::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.18 via Frontend Transport; Tue,
 25 Nov 2025 17:30:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:30:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:30:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 09:30:15 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 09:30:15 -0800
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
Subject: [PATCH v6 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after reset
Date: Tue, 25 Nov 2025 17:30:12 +0000
Message-ID: <20251125173013.39511-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251125173013.39511-1-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a8da58-a0d4-481c-6078-08de2c485c77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KcZ7E5EdwBSsAm7inrWuHmTzNR32kvXiu2+G5/nyYijAQqcYZ0BK8bMaih32?=
 =?us-ascii?Q?v59V6b4x9txX39XxIyW9gANZZXVS2MisFwyLHa1zciDd5Q5CKMDQKccbcxM0?=
 =?us-ascii?Q?vGTY8hWcLaNlilht9MfJgxglkBCvHL5lK7UUmL4LSdqG3YFQduHWpaxEHSX/?=
 =?us-ascii?Q?OFD/sSBL56wi0ZyJhDZgjSowxpKGuB65n848We6rtzM5tVeGzTV+xYiIeyPP?=
 =?us-ascii?Q?MVdQUGPVIAm5vTulm3ZEUBlvBUOrI+i1tBAxJ5x7wcleKVpgNMSrXqh+TEqC?=
 =?us-ascii?Q?Q1mQjKVMutJ7AlH3VyqnWUgOUxwbjno8y83lkuAYDBsMRsg9DLIdtulEKsOX?=
 =?us-ascii?Q?k+d2Opz4oTDXlkvBXLmimIACidvUMA6RHPzYQM9QEEbMQjmsjX86i923Ww+B?=
 =?us-ascii?Q?XSmaq1D+KpCrteV1B451ZDDFCxdocRmB8y8w7IBAl2kgu+RKBQdyAUv24Z/S?=
 =?us-ascii?Q?JJKgbfXRdaR6m4uhAWFcVBFl6N17iHqqya/YnH9PNKNCoQHJqVQLePtIjzQ8?=
 =?us-ascii?Q?Su1vSdaceJaCZQkzLXsFQmPdqdvZwRy3S189tLtolvPxd/JIAtZ4CXaXq1mK?=
 =?us-ascii?Q?ZNLOdVXy2lPlHEnkq0H15P7vLOwrPeZ2GlyLdSLqKOoF0I8MPMqOyVXxB3yB?=
 =?us-ascii?Q?GJEXsCken+u+ytWnkidA6BlduwzwhfMUOuEfTEO1TTVeHQR5gsWs/iP/WAVB?=
 =?us-ascii?Q?fNUyCzK3JhwBrFjEqmQxtdF/NOk4oDrAN0oEf744GUAxp/9aPMKXqzcbiv0n?=
 =?us-ascii?Q?kJOdJZAOMoC4cQcCtUvwjmDnVuRypvEE8RGc/0NRvHWp6dZR+BJqTY63fCy4?=
 =?us-ascii?Q?esaNayjg5G919g8bnb8nXVUrnBiXrfh6R+aABY8q5JwrKpnrRr11TsDv9LI/?=
 =?us-ascii?Q?SHRp63zdz+WKw93O7PQf4SNmbYcs2i9X3S/plRR8o2PBiM7B2H9cy5q39ddY?=
 =?us-ascii?Q?BKVpkylpGgSmXqQoVIBQrtRYBOmZS4lyheKvFp370KBct9c1Q4+jGxVd1LNW?=
 =?us-ascii?Q?FWROXtcRUJC6QVZ99xIJBKbM3yJLu39EzNByP9CEc5SXLPUCDyC/hV+4jgnt?=
 =?us-ascii?Q?KCIA+nYzJ9REu/zrAjpyihExse463PmHf3Ni4BEu/sbC22EI+31HRrGWiXj6?=
 =?us-ascii?Q?23FyZyccUgX/Kt03D4FKyBP61eA1JvinRrGTWY7F/D18AQogBOWlZDRSIPrs?=
 =?us-ascii?Q?sYl8sDUUa7m8YL9MM5NrXftVa0olG62g7xpX+x8Ypse2TD1Ihe65r+fBJlgW?=
 =?us-ascii?Q?YogYkgY5bTbVgrzFt3ubhQIviJOiGiGBRTwXXZuvlT8whJgM504uCy/o/5JM?=
 =?us-ascii?Q?6fGffkXVdoSwjAqOZ/BKZ0YSNfxoD7Br5MUM/gEv5NvqKNi13fXstkw+Asb5?=
 =?us-ascii?Q?E7wwibXe/NlkVDQneFXzlHM86etqXfExF2nWjKUqC8mLXVV4qXJFaCIFVcI7?=
 =?us-ascii?Q?xJZPaShFB2TVGCGHWsPNtzY8y0W5YzuYgrdDfasI9gxJon85LQfjgdhz+3bz?=
 =?us-ascii?Q?sq3FSl2H04sMhAKOua82JDLsiv2OsMadlITUNg3sfrCjCWqgWIdGYGljTXXv?=
 =?us-ascii?Q?hJXAwC0XZpoIDG/HCyM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:30:43.2606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a8da58-a0d4-481c-6078-08de2c485c77
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new flag reset_done to notify that the GPU has just
been reset and the mapping to the GPU memory is zapped.

Implement the reset_done handler to set this new variable. It
will be used later in the patches to wait for the GPU memory
to be ready before doing any mapping or access.

cc: Jason Gunthorpe <jgg@ziepe.ca>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 2b736cb82f38..7d5544280ed2 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
 	bool has_mig_hw_bug;
+	/* GPU has just been reset */
+	bool reset_done;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -1047,12 +1049,27 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
 
+static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+	struct nvgrace_gpu_pci_core_device *nvdev =
+		container_of(core_device, struct nvgrace_gpu_pci_core_device,
+			     core_device);
+
+	nvdev->reset_done = true;
+}
+
+static const struct pci_error_handlers nvgrace_gpu_vfio_pci_err_handlers = {
+	.reset_done = nvgrace_gpu_vfio_pci_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = nvgrace_gpu_vfio_pci_table,
 	.probe = nvgrace_gpu_probe,
 	.remove = nvgrace_gpu_remove,
-	.err_handler = &vfio_pci_core_err_handlers,
+	.err_handler = &nvgrace_gpu_vfio_pci_err_handlers,
 	.driver_managed_dma = true,
 };
 
-- 
2.34.1


