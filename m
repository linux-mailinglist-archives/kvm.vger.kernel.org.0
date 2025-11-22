Return-Path: <kvm+bounces-64288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 49271C7D260
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 15:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6DB304E59C7
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 14:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2728C26056C;
	Sat, 22 Nov 2025 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mQTDjnph"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011010.outbound.protection.outlook.com [52.101.62.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A3E1D6DB5;
	Sat, 22 Nov 2025 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763820838; cv=fail; b=c568VvoNgTr4dqRsjIgfNZVXOHwbNHhFMV6V3IHSWLUfWuL+nlurDKrhOmmPiKNF2ZdyiFPpPSklf15wHdkzPxpV/WgucQsK6hrIlTwv7Ll9EVxWDVpagbLz2R+xLaSvnGhV8et+1+XxPuiImg2bj01sUCjhHRfgDtOkKmnvP9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763820838; c=relaxed/simple;
	bh=F5RC2MlkPybeFQXqi6wQNCnmliFxtYDR8AMe0qzp/Xg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A621b3GbqRceIiYhqXAjUnqKcNHbiozWlDkUuy6zWK5L/5tl7hGDJXABZMRNDp7hWKZsIdtXOYl9CVGly/EMijGFxbIqBiMWA+NohEE5aT4jepnoyFSIs51oMgtlYmXw7PvQe32FBfDD3ltruOWcASj/r4e6p+n2ycdaoC6p6nM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mQTDjnph; arc=fail smtp.client-ip=52.101.62.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPytod7LVuFPnRTnqo4wpOtxPC0dZgy94h4NVRx3jPEPinaCL9yrtUBo3tL5nPRFoz+5SOI7026eJ3ePaiqt9OGHplHfM6bYf0ifZEC969mGygfR+17m5KhYX7cRZwvw4KUIpK+lDUuz6sdhiBTdJenPo2jzLX6gJ8HURafEe1I0qHOSOhr7SHxa8IezkNM9d1vLBGZ6ElnL8dCN0yNtITQSm0/OqL/981IzSOPf6loE3ZX8yxvgibaHq3GAC5s3DxqZYeZl9qWgJw3ggrDD7m67SAoPt9u7Bwy5PEWmCsW+kBdaKZYusAW2GxN8GZoD3YyIDGApDJxiBulUXlvQNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Rwn/DZw4HKm9HtHhqbLg0Ebp52ug0+pNCtnMkE/XXE=;
 b=dGjhUB2RmT031ys6Wn3EWJtdFknL2r00IkupGvz+X7qek7D+32rfv4OC0yQvAHo6k5/t6vjBTstihIB4/UcDnIBi8eofbXGHN5HjeXKvusjjrEHuf1o03YqPyKOaphCDzgajw5UPj/hAEKhtpEQgpfjdRyXN6fV97Gj6e4/oCOQTQaW8p0gaRX93+MahpDNsLbL4X4hUYT+tG3KeiCfFi5Mr1+Ish5BPKMXqsW8zCmIKYoUCtzrw/fyfNdo2u8m2i6EjVP+o0H1o7zCNvBXWwz/G1I2OnlOMZedUZUJ0R18zBf47YYsZKCQmjfYixnYE5azX31fADV+Gq2xa3g+e7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Rwn/DZw4HKm9HtHhqbLg0Ebp52ug0+pNCtnMkE/XXE=;
 b=mQTDjnphQg/kvAoap7a9aBpHgUvopWrOBKS14yVHkiP9YDbx0vew0owyRuIt0OEkhPfFeY/tr9oDx8KqXQ2ko+Bz59qESAr6Z9Hi/gxbogpQ0mNQN1rfcIBXWkLFt0AsQfkRX3zC1VQ4SzqemEt2Q/JFpKBQPU6EThK2Gn0JcZYs+78BAz2JQ9nld39/PQXSIrs568GbR7+r9kIv5iB080Pm+ZMSMHojfWxmCPTxVb3hSpgpGBxGE+Z8IC0xCmynEynoqUQzu2m+rFfespAZ1qsxqrZqRMF2bzS2lhlVtYTBvdM+Nhlp46YO6mzIVoQf+c1wqz+AUGTnE01aRt3zKQ==
Received: from BLAPR03CA0177.namprd03.prod.outlook.com (2603:10b6:208:32f::30)
 by SJ0PR12MB8168.namprd12.prod.outlook.com (2603:10b6:a03:4e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sat, 22 Nov
 2025 14:13:50 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::5c) by BLAPR03CA0177.outlook.office365.com
 (2603:10b6:208:32f::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Sat,
 22 Nov 2025 14:13:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Sat, 22 Nov 2025 14:13:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 22 Nov
 2025 06:13:42 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 22 Nov
 2025 06:13:41 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Sat, 22 Nov 2025 06:13:41 -0800
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
Subject: [PATCH v4 RESEND 7/7] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Sat, 22 Nov 2025 14:13:41 +0000
Message-ID: <20251122141341.3644-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|SJ0PR12MB8168:EE_
X-MS-Office365-Filtering-Correlation-Id: 787fe85a-7b14-4c50-2931-08de29d15be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LJsl+8Y/wxUXFYCDn/RlSCl/y4tVgMY3/zKEqXZdn/dxKioqytYKzWUp74HN?=
 =?us-ascii?Q?DNkSiCmfqcQDgtKONuKwDE7Hds9TKOyULFEYoSpLFQTzx0ObbmTkLis14QLQ?=
 =?us-ascii?Q?NePfMmL/M82tyKZB79mv1sjSa3M9RcbyYXi0XEyYSIPRqJRbbhq6OZf62F+4?=
 =?us-ascii?Q?iZ/7s2M4H8P7f5yqrOZECiMCaGKt2IxNeQ1yhGbKzQTx5PrvUpD1B7qu8HWt?=
 =?us-ascii?Q?Jp7mqHQ7sBDX+KigQQvaEDzOX0zhdRHvCUXhlh+5DwfTeD08G+DXZ/Ly/uTy?=
 =?us-ascii?Q?e+HL3/pW/F1K8fdq/YJlIxD5tB1PJ9jE6qdQcpLNOUS+lWkqjRZ88rwEZlvL?=
 =?us-ascii?Q?IJN1Hn+4RF6CsPISU/VJt4ewqUh0hsJnQArCq4RzPqOLFuCU9EARIVZH8Q38?=
 =?us-ascii?Q?k2vFXSRQxsEyc/4+DyWSayJ4LwwY41FOHOWorD7df7+14o+t+70I33iR+zoC?=
 =?us-ascii?Q?KvNxklpsGdAF8COIsTVO0SsC11m9+k2tXd0GcLRWmyAMpu3kymFqFhDGe1pq?=
 =?us-ascii?Q?yB7wyZKch5HTF/mrAz+J8Nn2YpEu1aDnW8GbqMt+PAdanCvXgD33nPkFEf4m?=
 =?us-ascii?Q?W/hVDPaSg+nxp6vGf483TR22MA7DQln+UObWOgj/nkgHZy2GohUh6j7wKfWY?=
 =?us-ascii?Q?GKYUQjMHOBZdz94Snl1MXZAgRrJjn/9hTnpnDdZee9SzbsX9SF7SSsCr4eQn?=
 =?us-ascii?Q?kxHzw+Yfvjp+OV9/s11GZhh1jG3DkoSKjDwJJkMxne5gTXwUcOMB8TUE3tpD?=
 =?us-ascii?Q?0p0Af9eQLOMl0iwcpzMFFaOql4So8lEqxIWT0vEQ5DKX/dHjIP4S2zcs1xhQ?=
 =?us-ascii?Q?/EblOxXqjlpwymUFQIzbM5TZIDbAusvdFnnzX6fFfmFUZ25zHhCOOvJQoFYV?=
 =?us-ascii?Q?JYSKIwqfgKxPmBVglKH57xzdu7MQnhdu2ylTAizZevSUKF/Z1zuOh4Y++wIH?=
 =?us-ascii?Q?uDwaWxTVi2vn6y7Nwp3Ruco1lW+gWslqUMzeDhk2ZvyFxBLYLTqc9Zu7JfUc?=
 =?us-ascii?Q?NHs+bSENYeKWB4SMvff29Wnk6f6y0aLQXFIM0cr3Elgx5cHxKqhifxgLH6D/?=
 =?us-ascii?Q?Ch8ttQs+KrEp6P7qdwnZzPJr3pMtht5UeVhLqG3lql7cpzgRKdwlH+fcHfyG?=
 =?us-ascii?Q?BAzBUVGx+1jbU67kRgrrT11eP9NtxZ4HbHiG0KkFkHvsYigKp9LcSz/Vz/+J?=
 =?us-ascii?Q?OZHWdA693rH5wqhwxA0xSwIP3xq9GgvoaVnZ5jixqL+tiGagsaCILVysnfPI?=
 =?us-ascii?Q?q4HB17AoAUlrfpFmVaXeODKyclS24rGFrXxjV+vknWmajfEzeve3/sGa4qCv?=
 =?us-ascii?Q?6OxOYhEYaS4cixd3H63IMNfufY0YD8563CFUxGklGCg4MnjkkfO/kO+WNO2D?=
 =?us-ascii?Q?5zpu8lWbmztzButIpP/0ris3Dv71X2+vPQnApzbJALTse7pOaSzuMrKOckdA?=
 =?us-ascii?Q?Gc0bAJtVxkFHU//5SEmreqx8V8c1yGakSh+dBiiPpu9lQFz0ba7tWTZMOeNM?=
 =?us-ascii?Q?fxXwiHtAs+lmqwQ5YC4qts8t3bF53uPd4qr3jBAe61rgkZT1ZS+PFjyQiLXf?=
 =?us-ascii?Q?wlZgTabRVvAUgjyE1y4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 14:13:49.8239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 787fe85a-7b14-4c50-2931-08de29d15be7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8168

From: Ankit Agrawal <ankita@nvidia.com>

Speculative prefetches from CPU to GPU memory until the GPU is
ready after reset can cause harmless corrected RAS events to
be logged on Grace systems. It is thus preferred that the
mapping not be re-established until the GPU is ready post reset.

The GPU readiness can be checked through BAR0 registers similar
to the checking at the time of device probe.

It can take several seconds for the GPU to be ready. So it is
desirable that the time overlaps as much of the VM startup as
possible to reduce impact on the VM bootup time. The GPU
readiness state is thus checked on the first fault/huge_fault
request which amortizes the GPU readiness time. The first fault
is checked using the gpu_mem_mapped flag. The flag is unset on
every GPU reset request by the reset_done handler.

cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Vikram Sethi <vsethi@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 51 +++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 5a2799dce417..d6a9f1cc4a25 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -104,6 +104,17 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 		mutex_init(&nvdev->remap_lock);
 	}
 
+	/*
+	 * GPU readiness is checked by reading the BAR0 registers.
+	 *
+	 * ioremap BAR0 to ensure that the BAR0 mapping is present before
+	 * register reads on first fault before establishing any GPU
+	 * memory mapping.
+	 */
+	ret = vfio_pci_core_setup_barmap(vdev, 0);
+	if (ret)
+		return ret;
+
 	nvdev->gpu_mem_mapped = false;
 
 	vfio_pci_core_finish_enable(vdev);
@@ -152,6 +163,27 @@ static int nvgrace_gpu_wait_device_ready(void __iomem *io)
 	return ret;
 }
 
+static int
+nvgrace_gpu_vfio_pci_premap_check(struct nvgrace_gpu_pci_core_device *nvdev)
+{
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+	int ret = 0;
+
+	down_write(&vdev->memory_lock);
+	if (nvdev->gpu_mem_mapped)
+		goto premap_exit;
+
+	ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
+	if (ret)
+		goto premap_exit;
+
+	nvdev->gpu_mem_mapped = true;
+
+premap_exit:
+	up_write(&vdev->memory_lock);
+	return ret;
+}
+
 static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 						  unsigned int order)
 {
@@ -162,6 +194,15 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 	struct mem_region *memregion;
 	unsigned long pgoff, pfn, addr;
 
+	/*
+	 * If the GPU memory is accessed by the CPU while the GPU is
+	 * not ready after reset, it can cause harmless corrected RAS
+	 * events to be logged. Make sure the GPU is ready before
+	 * establishing the mappings.
+	 */
+	if (nvgrace_gpu_vfio_pci_premap_check(nvdev))
+		return ret;
+
 	memregion = nvgrace_gpu_memregion(index, nvdev);
 	if (!memregion)
 		return ret;
@@ -485,6 +526,16 @@ nvgrace_gpu_map_device_mem(int index,
 	struct mem_region *memregion;
 	int ret = 0;
 
+	/*
+	 * If the GPU memory is accessed by the CPU while the GPU is
+	 * not ready after reset, it can cause harmless corrected RAS
+	 * events to be logged. Make sure the GPU is ready before
+	 * establishing the mappings.
+	 */
+	ret = nvgrace_gpu_vfio_pci_premap_check(nvdev);
+	if (ret)
+		return ret;
+
 	memregion = nvgrace_gpu_memregion(index, nvdev);
 	if (!memregion)
 		return -EINVAL;
-- 
2.34.1


