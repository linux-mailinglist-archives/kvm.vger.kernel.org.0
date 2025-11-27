Return-Path: <kvm+bounces-64901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F111C8F983
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 828474E28E2
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D9B2E7F14;
	Thu, 27 Nov 2025 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TxapOUtY"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF302E06ED;
	Thu, 27 Nov 2025 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263218; cv=fail; b=cdX26utc4huI06iI2yZMi5D/GzLpn2/gWe989UvkZ9H4L5v1NLeSb2HXK15d4oiMn09a2ketWAKnBP+e4P+2gekXn63UNwu+unvfBbjkbMx+khjPURkXIk1GU0ttwfbrhTXhenlZWYTN+4dUNxtK4BI+OuUtqd6D2AsGpgH2l+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263218; c=relaxed/simple;
	bh=b0p3wi8GBj+fw0mWBWmogPVwpARnQo4pEbO2QBSZ0HI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cMGCkipOjjDT0cyOQNYWtIDLQMY5A9ddc/vJ0ILgcVtGp4CGnTz2W8x1qVHIgo+RK5IzA7v+9M1CsSA+QnLWP/vR2M4vAwfunJBkKdxU6rNDcldfRLPcfnVkhjl09CqeT33G0OyXb840nWgQv0ypa8jMGxweUPJU8oJwnQd7IE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TxapOUtY; arc=fail smtp.client-ip=52.101.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAK/vTgc9nbCCA/D16Eq9JnCBcwGwNppWwV+/F57Qn0eHMNx5ymLwr/h4Gr60H+OHWj8E6jL/9UM8ngBp4QbO0p9TKReC88lcLkNHdIc6MIG6rKrmUcDa87eBTWIYc2UrWbBR0C3LV6TiXAnS0UTilfAyd3VOXBzGi2ExmQNPy0KrDs90uBuC7QKfSnZo0RngaxLKfav3wuwLZN0Bvg4iHqxZV091kFH8P5Q9eO1Q++/wH3rMWrQC9p+YGXbiyuUolNVJDJLjkkL8ILHO0/mgIkJgMwDeic9Pk5MwBqv5JzwsrC/E25eVcf3vQRylWsgvqCGhsJlACruqv81B9NqVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmd/FucWpId7632iP4376tIwH3LfEJ/HD8Iqn26vVVg=;
 b=SHZNLCWUtJtUFLS7u1bJuRDkyh9ejGeHZ0fuzdrdSu4J9KPcexbAJ7HmYJ88MptxszvMEgTz8fvIfuZ6wbGccoPvbZQihFDTiTnJsyY7MS0m4QfkYBpdCF4e2x+Ya1rs1bUsJ1N/qqE6FicvGbcD6eYwdY7BaVjO4SvCdyavze70z5EYLV0rysYTIH74zqMjX/bAwtvxOHScbF/0tryJ+Qqut8Ebb+G9DK8q5tny1M8RSyFfNqpyX7BKN/7cdWzMrcWODg8J9JoXFilPIUFTokVQqG2p5GQY+I4WBeop6ccDW/+UrrLSbvxWcVKadBRXBAIzrdmrSBGbZXQa6FbgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmd/FucWpId7632iP4376tIwH3LfEJ/HD8Iqn26vVVg=;
 b=TxapOUtY4MEwJxRD6FhZmjaY6d+b+kgRM7RZRR/kxrqj22bRb92eDPfa7TnIYRrhlBJxQPiDo3Z4wRhE+h7HZmIg5dc79LSbgpMSVCjyJbRXwDJ4U7dyYcfjfFtl01/+c6UzkUtScrO6CMXwPvsqqabCALeH7YuXM/yLIYOz8xQu0Kc+a+0Zxnw9ZIHTbAFqjJADJFA4Oq2gAKvJFxe+x+qnjoEzMoAPi2cgcqPZZJPCWGW5GjlarahdBqoAQMYZzWUVE3V0w4WZAFt6zQ+UW9Dbehl/qEsm/YjSuIsT2vIC1vp2FWIMNOtiMl40025KnwtlnlZYs9v9sLsgoGIgQg==
Received: from SA0PR13CA0029.namprd13.prod.outlook.com (2603:10b6:806:130::34)
 by PH7PR12MB6809.namprd12.prod.outlook.com (2603:10b6:510:1af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Thu, 27 Nov
 2025 17:06:52 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::c9) by SA0PR13CA0029.outlook.office365.com
 (2603:10b6:806:130::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.4 via Frontend Transport; Thu,
 27 Nov 2025 17:06:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Thu, 27 Nov 2025 17:06:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 27 Nov
 2025 09:06:37 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Thu, 27 Nov 2025 09:06:37 -0800
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
Subject: [PATCH v9 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after reset
Date: Thu, 27 Nov 2025 17:06:31 +0000
Message-ID: <20251127170632.3477-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127170632.3477-1-ankita@nvidia.com>
References: <20251127170632.3477-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|PH7PR12MB6809:EE_
X-MS-Office365-Filtering-Correlation-Id: 938605fa-8087-4f63-a2f8-08de2dd75c51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xeMsUB7D0V95P9QDKdSKHg8iAc27zzrI4I6lja8Ki/TROmgdutqkC4WB9FYR?=
 =?us-ascii?Q?YpjctFxuLOkK4JKoHmP1vexsFVd9i6zRFQ2xln6FiKenDoAk+3/0XkpOelLB?=
 =?us-ascii?Q?D+33qs2AuQ0SEcH4vaJ01MF7sab6YCcFiNn5MfmKTvNDbcpsMzdgB9pIN+5o?=
 =?us-ascii?Q?FV+zzXiWyVjuZF1StCQvtAUufd8JZiw3sNPtz6ryDFettvFCunRKaHEAcaQl?=
 =?us-ascii?Q?bzP4HV2wJJpKpycwJ33NcKWERKvZ7eFTTD5SDbWO7rCusvsfl/itmhWPXWzq?=
 =?us-ascii?Q?QHvXTZl+6GJlUmWu48tKmNhK6CpYpWZWhHjG06uSwSrxwJUwoBgQISM/aBvA?=
 =?us-ascii?Q?04QdlKRwHgzZFabv4+YwGEhKhUwp/VNHXo7iMeojAqhDj6mlFvhse6TfuzOh?=
 =?us-ascii?Q?JsinVuPJA6L1Tr3zmux5Z4BmgqucZy7FeAATgaD2DHB1VSTalhta98q7bDzv?=
 =?us-ascii?Q?mDYC0DTDrw7tOxXZ2y11NsTxn+z5fX6s7PWlG+8IA1ZgHI9ey9oooP94lfyU?=
 =?us-ascii?Q?F1Ik2ioDzltaSvD/rvYnLORREfbevgqbgdzjaO6LSyBS92b0gvdeUmEcCUcy?=
 =?us-ascii?Q?7EIDR9hAee2YAAA6D+q9wkvqFijftW/XI3Kd3VSTJOsHqS14rHCw5a8nUuK7?=
 =?us-ascii?Q?qaZuOBqupBSFo1vwtJuor4E2qpI+1kB0AynFtO+jeYhGZgpx9sTwZY3r6lWS?=
 =?us-ascii?Q?y11Jqcaz8q1iA4qBrvOacQhZp5w7e6uKHtsM9ekFkdBPEM7Ki0FGfMmyEyjm?=
 =?us-ascii?Q?ZkKubyOLFmCrLmHbdFMD9AvgvcM3SDPJifcgPBQCY/tSNo8+A1CLZoNJ40Lg?=
 =?us-ascii?Q?USdksrsYVYVmMNNnWCIEJCSsfas6pSXGU9BovYgkwaL320crZk8rZRbR9YXX?=
 =?us-ascii?Q?KjkFI3htbLtSntZ7bLmHUM5u6ECoT4lxk5FIPj/2h8JCNdmxLFsPqs9AxUNb?=
 =?us-ascii?Q?QtH+Y6S7u96Qt8ck9CedvKCXGCCfoJeJeelBNfrFIcYv28v914UqAok87cRb?=
 =?us-ascii?Q?FiyqFikWN6nbLuXVYLRnv6Gk4ecj3dIkBte/AMch1fl/G8R4/RfohpW3KHFw?=
 =?us-ascii?Q?OFaezjVNk8Gh6VFeadWWWnZNaN4m+r1wWG5NoDTDYe65XS9NKGUBr2vYiDvY?=
 =?us-ascii?Q?yDc0Gm4vj/jNd9XSp9r7vVduvI39LO0SEmZvu7Yx/CPB7VzNIGxnEsa/VUWc?=
 =?us-ascii?Q?ZU+L7tsSZswz9y4QOC2hFou/c84fyrk+VyHe49DWHiGeSTb6QSgInoEuZXw5?=
 =?us-ascii?Q?Us+EnQZlK/LsgmSOMPJhUNVRWgCMKkUY5K1yikB6X/vO5wAdRNNyKsXeEpWu?=
 =?us-ascii?Q?HWnEOFdleTtTiWoCmsSKFHekcVdT3kv9EqvobF9MwzvgdkLRePw/ZHUSfGY+?=
 =?us-ascii?Q?0DGwzZBk6mu2sNiHSUSsFcJ+IaEiQgdV/25L7coytuq4cqQj1yScLtHVSRDW?=
 =?us-ascii?Q?Thb7MZpMk5zASy6VPFiFXHStyrjXkZ3Kzz8EEuNGLgmNUGV6ecf7aJv4cyzc?=
 =?us-ascii?Q?bCD8+ylcmYn0rHY4WWST83taKJj5n/88lvXC0Oi+W+Q4cAQ/5lODKwKph/1z?=
 =?us-ascii?Q?I9sFgxTnYdBCpLR9UsE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 17:06:52.1887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 938605fa-8087-4f63-a2f8-08de2dd75c51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6809

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new flag reset_done to notify that the GPU has just
been reset and the mapping to the GPU memory is zapped.

Implement the reset_done handler to set this new variable. It
will be used later in the patches to wait for the GPU memory
to be ready before doing any mapping or access.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 059ac599dc71..bf0a3b65c72e 100644
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
@@ -1044,12 +1046,34 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
 
+/*
+ * The GPU reset is required to be serialized against the *first* mapping
+ * faults and read/writes accesses to prevent potential RAS events logging.
+ *
+ * First fault or access after a reset needs to poll device readiness,
+ * flag that a reset has occurred.
+ */
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


