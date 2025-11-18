Return-Path: <kvm+bounces-63508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 589BDC68130
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C3D693670CF
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A183064A2;
	Tue, 18 Nov 2025 07:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PD7znVz/"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012046.outbound.protection.outlook.com [52.101.43.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219A830506F;
	Tue, 18 Nov 2025 07:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451888; cv=fail; b=RJTnyEKOaoWGWenS/FldEIcs/Ji/Zjlde/j2Cz3QoPeh+haA4C1Wg813xqXJ31Mp9irDKblARVhm7q1yu2DnAOyk0qaAppQOvON4uu+1eqdpaHh635Rke5C7qoUsk7fmMZkliFVu5ojatY9GYezDWWCxJRCzBzarJ1j1JX9qptw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451888; c=relaxed/simple;
	bh=WDk/fqmmVTWc+QpZEkcaC8m4x1SEeJKYCw9EUYpNfgY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFig2GKK3ck9qupiNTXwyCX5BPWUJ4e1Do261zyQ17d4MOJy0KfdxyI2MtH2d0Mvq2xXPHfXVqNnmRd0ruh1iHY6HelODzQl0qjAOvZxhFJ7Ne50D31dJQuu/aObGUBcanAKY+tStnVV2r1FlO/6mOHNVLMgXPWDnWEu0GNoQaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PD7znVz/; arc=fail smtp.client-ip=52.101.43.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JlI1inJxZNJDIN+t4pApwES+Yz4nkjV7cDvy1VH20it9OVhIi6ySkBycprS0+P8uQQqLTUC3mqsgC13uUk9bPaji88lf+871mGUPt8WkY3lAsk1DC/vqmuJkfc7gjVkGBLmrpANpyVd6+DblYnAnRGefx55JbjPd4XxECnBOEfyEabQAXr2uy4cjMmlaF1Nj1CYVxCpUoSfqk5Sx3XckH+0tqeouNmLR1ZNwDrDiw+bX/ZAI/qQxBnhlu8H7aeGa7ls5IdJTp+ahMFPSBFdMP/W6mfVZbkF47sFxEofXfsnaRjBsh8fUb7h0vkHXSdDp9BkRU4OWjoTcdEDeaK7QNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6hNw5p+XymSD/qkHSd206mWU0VY9wsizJRLK2LyyD0=;
 b=esdrGVeQg1lMFcdPvWWdmwiREJccPPZtBiTRDmOZ73qGJ0VIOYLCoQJeEMMtUmdv2HsQ5WZeXEBFz1IdTRyVrESs6MHqN0ILHuJlwV1BA9RKeC6yffw72bX0eWWgWZcYZkPf78TzzASuAHWo11yvX7CXe+E1UAq2DboffPogjnhPhzyy6XpdQIlFPy7JpyOqtw4ZgBv5eo+jGVpR+3JglvIpxwCyWd8BD4r3/0s3C7DrqXFs3OQg3+vSKUlAxocEbqGbugY3wgQ1xf1SwbaaUVHl6WwKsex5IDMzQ6ZKUIlsToemHHJAwGWrLB2Jjf3RABWDv3qF11JXNNVmFkI1gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6hNw5p+XymSD/qkHSd206mWU0VY9wsizJRLK2LyyD0=;
 b=PD7znVz/uHeH+WnF4RFsvEQ+wJwyNgliaKU22CZY8XiS23kk4pMnT0REGcnlHo8xr4BtRT3tPOnKlrbvDATy0gSJj1qIQDb3koOrZJ7mifoyMvCfcvpzc6G9HsBho+JQEcJz85o6KmvjzV77N/v/D09UTj1sdo+ME/bTmC5Hh1V6IOAC1uB4bTyDYzXh3Xv/+vvHUE8yJKlQp7AyKBvGB6uB70DwRbLNGmlsMrJTsLwXgt+VvfmuZwtMhe3mvMRH+XHCIxjRPC0XFnE6QchFUJRvodiiYUsT+CQW1XW5g4N53e8URHRHGlipgBLfxKdiTvvQgrjATikQoSsDiBqvxg==
Received: from CH2PR08CA0024.namprd08.prod.outlook.com (2603:10b6:610:5a::34)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 07:44:43 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::36) by CH2PR08CA0024.outlook.office365.com
 (2603:10b6:610:5a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.21 via Frontend Transport; Tue,
 18 Nov 2025 07:44:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 07:44:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:28 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:28 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 23:44:27 -0800
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
Subject: [PATCH v2 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Tue, 18 Nov 2025 07:44:22 +0000
Message-ID: <20251118074422.58081-7-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 391f80bc-287c-4ee7-8ee2-08de267656c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8h+RXwtTvZ+dOqKOdSs0xPQiMccz/aYpmvA0nsgQ+9cwK0L6JJKCvT1sekLn?=
 =?us-ascii?Q?1uqgA7Dw+KbdoizFLk6AvtRh0H0xsiTFFHiwJrwo4HHxxE1kjPKSfQwcKA+r?=
 =?us-ascii?Q?DIDXWiD7PMdpb+9G9EufvKlkdHoosGs2KUnVS3eEqB06+7T0q7nfoqfvsB+p?=
 =?us-ascii?Q?Y+0sgQQhNca14j1bGqv/JtwsolmF0z3HpzgB7ohhetgyx7h5Cro1oc730Pw6?=
 =?us-ascii?Q?Cq/kZhksOOHR3VCgtc0hngsu41sGcSn33szG1h11mQtApq1+DN/YBsI0KUvh?=
 =?us-ascii?Q?NYqqy8n8FzXvjRJ1unQNu7cRSi8MC+wzWPOgEtB5dQt/TM0WxdcQwByFELH8?=
 =?us-ascii?Q?TwrfMPEUbGz4wZ0BOA6z59z7btuZxU5NPNx5u/rfRORIAjf+iebtE8toYnld?=
 =?us-ascii?Q?BVmmKz2MbBYDc8cJFu7S1RlHgwwmtb+KsxbJ/Ggxe/qbK/5f3hw9UA5vr0aB?=
 =?us-ascii?Q?qWPsrccZAL815S6sUBJs7SBPIZATGt2MAXs0TGcsffR7Y9XJCIxCJ8cY+8/6?=
 =?us-ascii?Q?4hHY+kiUus9HN5p3eSj2F88U8+NhKp95U2HVCfP8ujFazavpeuIRrRuO1PrQ?=
 =?us-ascii?Q?dY9GfprmOuHvTbO/dZ3IcFGZn0Q1fMgPOj0J+IAUv41++EeNQlMbci14DXxV?=
 =?us-ascii?Q?j4Mz2XR+oWVk8jLufszbqRITp/1LGUzHua4q3HXBMMKfy04r8dxkpYvW6ZiT?=
 =?us-ascii?Q?ixeniQLO2CYGGq8QCPai5U+NZmsWUkr//DGU4LCRgV1XKksTwn20GmPZseNy?=
 =?us-ascii?Q?zgBECN1kG6TCUP9px5HvZHMW0g4ORGbDnY4V3CA6X2vOVYGuw8UytScfyQWZ?=
 =?us-ascii?Q?AHBBhA9qv7MBUB9dtepFmrMURtqx6qQPwRIVeIRZzNIRbqZ/5Pgbs2zmrHqB?=
 =?us-ascii?Q?IhShpPYnHwicWLyCt5Ryn6Lh+LzBIyGVPTyh6yV6xR9nm/cOcvu8L8V7ZW/J?=
 =?us-ascii?Q?p2N9iw9XGtBbSKOYZe+rJOsQ6rMscJE7AxP11MSY0as6a4yHyIXnYV2jc+DX?=
 =?us-ascii?Q?RIly+EAMGEpEFUj//nIf8OqSrKN341+aDlvWoMHnaey8Fh6w4sbw6vvN33Ib?=
 =?us-ascii?Q?aKJ7D5Qwu5r2UJpR0z/7WZs4CqAKdvqwhjS9AH+qhJw9isNWE8/dTTp+WtTP?=
 =?us-ascii?Q?VU/8cE+Zdip6QzFy/SnRF/Nw8bO1J6c+x49lNMEVDn3POocMfwX7mcoVwrwp?=
 =?us-ascii?Q?Bcb7l68/hp2Nhv5PSRpBqz+jdI0ZemtPe072XecRAeUwRX4A1Tt7BsmrZ3o1?=
 =?us-ascii?Q?DbNYhnXonCE4Ny+4D+HM4ldk4DrTPxGyckbG4fvqs9eMO83JR6TYc5m2mNzy?=
 =?us-ascii?Q?Iw06z8W7Tsmpo+vnq4TB+/z8hsydTcVi91bE2U0Sj7SAMAFd57riP2He1/aW?=
 =?us-ascii?Q?eIzBc/qB4qu0kr+/DVCCjEMqp1CVlrLYEnWVhmYiod1F33za0bJ//McB+szc?=
 =?us-ascii?Q?D8T8QSAuaMY/ywttyfZrcPXjGy2BkWfxoS/xflilJ6fvNvIC5POzlsSiJhY0?=
 =?us-ascii?Q?pawlSlXK0N2+jNfiSoiQFcDn3hv7o9CC9N4iOO694CAypSvZwW8NIyzwqVmI?=
 =?us-ascii?Q?MdsU7I3UQHhjYDAiCPk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:44:43.5431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 391f80bc-287c-4ee7-8ee2-08de267656c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

From: Ankit Agrawal <ankita@nvidia.com>

Speculative prefetches from CPU to GPU memory until the GPU
is not ready after reset can cause harmless corrected RAS events
to be logged. It is thus expected that the mapping not be
re-established until the GPU is ready post reset.

Wait for the GPU to be ready on the first fault before establishing
CPU mapping to the GPU memory. The GPU readiness can be checked
through BAR0 registers as is already being done at the device probe.

The state is checked on the first fault/huge_fault request using
a flag. Unset the flag on every reset request.

So intercept the following calls to the GPU reset, unset
gpu_mem_mapped. Then use it to determine whether to wait before
mapping.
1. VFIO_DEVICE_RESET ioctl call
2. FLR through config space.

cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Vikram Sethi <vsethi@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 52 +++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 7618c3f515cc..5d7bf5b1e7a2 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
 	bool has_mig_hw_bug;
+	/* Any GPU memory mapped to the VMA */
+	bool gpu_mem_mapped;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -102,6 +104,8 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 		mutex_init(&nvdev->remap_lock);
 	}
 
+	nvdev->gpu_mem_mapped = false;
+
 	vfio_pci_core_finish_enable(vdev);
 
 	return 0;
@@ -158,6 +162,24 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 	struct mem_region *memregion;
 	unsigned long pgoff, pfn, addr;
 
+	/*
+	 * If the GPU memory is accessed by the CPU while the GPU is
+	 * not ready after reset, it can cause harmless corrected RAS
+	 * events to be logged. Make sure the GPU is ready before
+	 * establishing the mappings.
+	 */
+	if (!nvdev->gpu_mem_mapped) {
+		struct vfio_pci_core_device *vdev = &nvdev->core_device;
+
+		if (!vdev->barmap[0])
+			return VM_FAULT_SIGBUS;
+
+		if (nvgrace_gpu_wait_device_ready(vdev->barmap[0]))
+			return VM_FAULT_SIGBUS;
+
+		nvdev->gpu_mem_mapped = true;
+	}
+
 	memregion = nvgrace_gpu_memregion(index, nvdev);
 	if (!memregion)
 		return ret;
@@ -354,7 +376,17 @@ static long nvgrace_gpu_ioctl(struct vfio_device *core_vdev,
 	case VFIO_DEVICE_IOEVENTFD:
 		return -ENOTTY;
 	case VFIO_DEVICE_RESET:
+		struct nvgrace_gpu_pci_core_device *nvdev =
+			container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
+				     core_device.vdev);
 		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
+
+		/*
+		 * GPU memory is exposed as device BAR2 (region 4,5).
+		 * This would be zapped during GPU reset. Unset
+		 * nvdev->gpu_mem_mapped to reflect just that.
+		 */
+		nvdev->gpu_mem_mapped = false;
 		fallthrough;
 	default:
 		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
@@ -439,11 +471,14 @@ nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
 	struct nvgrace_gpu_pci_core_device *nvdev =
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	struct mem_region *memregion = NULL;
 	size_t register_offset;
 	loff_t copy_offset;
 	size_t copy_count;
+	int cap_start = vfio_find_cap_start(vdev, pos);
 
 	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_2,
 						sizeof(u64), &copy_offset,
@@ -462,6 +497,23 @@ nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
 		return copy_count;
 	}
 
+	if (vfio_pci_core_range_intersect_range(pos, count, cap_start + PCI_EXP_DEVCTL,
+						sizeof(u16), &copy_offset,
+						&copy_count, &register_offset)) {
+		__le16 val16;
+
+		if (copy_from_user((void *)&val16, buf, copy_count))
+			return -EFAULT;
+
+		/*
+		 * GPU memory is exposed as device BAR2 (region 4,5).
+		 * This would be zapped during GPU reset. Unset
+		 * nvdev->gpu_mem_mapped to reflect just that.
+		 */
+		if (val16 & cpu_to_le16(PCI_EXP_DEVCTL_BCR_FLR))
+			nvdev->gpu_mem_mapped = false;
+	}
+
 	return vfio_pci_core_write(core_vdev, buf, count, ppos);
 }
 
-- 
2.34.1


