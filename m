Return-Path: <kvm+bounces-35790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E85FA152CC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DC46167851
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7896D199939;
	Fri, 17 Jan 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FblOY3h0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4513194A6B;
	Fri, 17 Jan 2025 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737127428; cv=fail; b=PhcapFmN7nLTKGzEMvAgvlx7CD4Xr2fs3iXugoebsoxv3JK9sRV+PgSaEJFa1bCaMHoXRxeJ2HhENH3UCd/G/5fl96jrBWyc5aHiRaFQnqMk7gOBGJNad7TK1kUgEjCLwjHtivJWdQCXc6EVArUSAR1H6/YgokR5bs1JnVLE27E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737127428; c=relaxed/simple;
	bh=eVxatu0YA9JB27Bm/rCzpTskek1eh/bf6o3FzdbPynE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bog/zPd8G/hNHtjEsWIelrUVQq0bNxjzB21Ds8gxzkyzPI3ck1vteH0a0dPmBqVVZh8RcLUqnoV/qj2yFu0J0ylU5el4zBdi3xjYBuTSXv7u3qy8j2w1cLZUuYx3RHTDzIY/2p/iMMfosbRZyOvbQpB1RsTOdRJHH9T+Xjq6IDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FblOY3h0; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qV012LnmYOQpxyM1HFE0+sMGJulTcTuyxgxOADaQ1Br3OldcSIFNe31JNK96UoYsyDegonFQpCVUTrigpQKsa0UtBy/9q9VX3dAMFRjRCO1aNyub4A1s+ZsShjDp/MCXQX9ShI3htDEbRInotND7xSjIyWpRlyXp19ln+73eLbgszt8nEGtkyQoEBTntEie+S8TnIrJbS7ctyfDvsrXQI/Bv3d4E+vs8+oyBFTwK3yPuvPXBlMqwz7zpl6wdxD5vViHGazwawStpA6rlnltqQoJNQVizIy0WPcD6ds/eXtjUBF/nqWy0V6c46sESblGHWFxdGb4GOXIF12em2Ymp6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skvwhLRWNwwG/5a5/dmlQv5hlqNwknM74FieAj1woE4=;
 b=opluige6ojSB5Bt7JvyaKI90EklhJw7SPt75c5ECWQoEJwjZ9jFEjh2SsPFS+iyYC2uytfDrPVXkhTs1NSzf721ndFTZoZuO4HBTr76px1PxSsD9ScK1koBE3z1t7+rxbxpLeAvkTNuITIOwwZj3oYG7z54C4YYZpLJb+TO3vBLDJBGwvtesoydtx3/qnZym1/jU0cgbRwB4cRv93XKVjCxABYekY/LyuMx07KzCPNnX4MfTQpMEeOFnJMRAmbVyMbAxj38viMpu72ctBWIckjbAUbIPTZ2m1EPtadBNX9dQqb527lzP4w7AgUrnExCx5dkwgKEWp1ouBt2ZMQfMdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skvwhLRWNwwG/5a5/dmlQv5hlqNwknM74FieAj1woE4=;
 b=FblOY3h0LKNtRpo7SpV2WSiWPG+cLtiKUd8EruK1s97bLSm+pJUUB/U7cZwDhgWMcpAwE5rQOrskAU2Or2yOTRmNVo+KZYn8W6cMcZEY71SF4UmP7s0vGacWuLWnF6cXcidkk7m4DiCNDcYZ31a96UssxdSyYB5KLhzq2eBu/5WdSYrkFZbJBZHQYgXT6RAx1clbydvQv1dUoPHuakqk1TwlLEnRtvoBPWpdGWISUKKRQDBvGBCU+sHW9sJ00UL/C2clKTx8Z9MreXf75U/maxqwgErBeyRkf8JSaZLhTV6jlThpW/7UXsEk0XbZGNu1rxkjdlEbiJ3TeURz7XQn4g==
Received: from BN1PR10CA0010.namprd10.prod.outlook.com (2603:10b6:408:e0::15)
 by CH3PR12MB8284.namprd12.prod.outlook.com (2603:10b6:610:12e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 15:23:39 +0000
Received: from BN1PEPF00005FFF.namprd05.prod.outlook.com
 (2603:10b6:408:e0:cafe::90) by BN1PR10CA0010.outlook.office365.com
 (2603:10b6:408:e0::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.17 via Frontend Transport; Fri,
 17 Jan 2025 15:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFF.mail.protection.outlook.com (10.167.243.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.11 via Frontend Transport; Fri, 17 Jan 2025 15:23:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 07:23:36 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 17 Jan 2025 07:23:35 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 07:23:35 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Date: Fri, 17 Jan 2025 15:23:31 +0000
Message-ID: <20250117152334.2786-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFF:EE_|CH3PR12MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: a3e71b94-44d9-4d34-3820-08dd370aeb08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OWT3hng3Ae8uR46WJWGVtVNA1ZrUEa2QQIzyKEvsL66e2hDvby0NADIRXjGY?=
 =?us-ascii?Q?ROwuVauPS5tCMWlR4Hd8p7gBeeSeWu3Kd4k8kFWmgoSi8CyI31K7b3nPRRf6?=
 =?us-ascii?Q?0C/A9qTAhQJrTQLK5Uv0uko0JVU+HHqoCaY03rkXPxdO8Oc64+TIIC2ZSpdl?=
 =?us-ascii?Q?Xt6vtFKjuEh5saZhuW3kWNw9riACzgf0ZJLkRfUPMWVggkDIUuRRb63hnuUq?=
 =?us-ascii?Q?QYmOgxs3xRwwJaNoQUncr48oadPIiaGIg6gBxv2JAqtCRSIasTgQA2dsFl/Z?=
 =?us-ascii?Q?ywDYQlSo1gCqEPTznhJpoP1nWmmyzLb+zEjOIa5G+7JrQFWbco9/Xe3n0Q1N?=
 =?us-ascii?Q?nUHiaKMxO6BpwVIpOTIEupx6fSmQNW8TcsN7auDclGuo7iI6/R6nPjpKqfSu?=
 =?us-ascii?Q?dxl8pwKq8MabsZgG4vYqdC9TGkS0sYi43PyeT7wCQVtWLdGv0NRD3V+5udgy?=
 =?us-ascii?Q?2eU5NeN44vlp7dzbVRVaEKA+YkU6nkuJOpVRyw96U+SuxbGk8HQMeYDKQbbJ?=
 =?us-ascii?Q?8JJ4RQHnRoHpDeBxOTi7jIfQQEc03VAOolvUbs4ZzCTQbtp0OLwDyKiDMl71?=
 =?us-ascii?Q?d0aYdmf2HrW0NJueTvgmHstBH+BSFU2FcyxDZqHUjj88gxEY0QAF0lxBpxBM?=
 =?us-ascii?Q?9huX+kZm7AvJjylzLixlLxElot3ff5oMye/X9d4qOU37ItRsUO+Mg0YQB0Tk?=
 =?us-ascii?Q?FytVhJkS7AyY+J2urjfBtH9JtS/sNcW/M7QvTcI1Lpyh50nSEaSLIfOSNvkK?=
 =?us-ascii?Q?Pg0fLPwjTvmqHkGYUGn3YKuRy+Pzfps8XYFqmccTwkA5mH4/FDwt7MYRjt4D?=
 =?us-ascii?Q?n1YEvoYkILdgNhoxcJWAmgVWEcpPJQDdzzts8fH53IsSQCZIu7tQgRtsWLfu?=
 =?us-ascii?Q?H9Q2f57Y2tFLXHLhnyE4Q+bW67Oj6JiWV15EzId05+xd1Ylfg7u+3BmL+nIv?=
 =?us-ascii?Q?CXFtc3DJc4Olv3oRVGjOMZ4Qhe2IlchpTaRmI8ExwYw0mRjnO94YP1p/6sT1?=
 =?us-ascii?Q?oP6KxIEIj/C1csmefyJTGLRimwyzWqjvsHLrZZso8hHWkDOsMcD+wNNxx7AU?=
 =?us-ascii?Q?RZhqVRn3s893T6ZiRKwN0kWaSDPnpmg4iH5rvbpjj0CzyjzT2DFkZWbcru8x?=
 =?us-ascii?Q?W5za3z2APlTrqRyTiA3fHjhrjO6a61X9KYF+BnrpND/AqFI3z+aXA9SAe6gg?=
 =?us-ascii?Q?+asG1DokhDQQhZpzrI3IarBFiD52OY2hkEpH2cThh2SwAnqAo1VV22US2Pae?=
 =?us-ascii?Q?Km5qPdBbluiyQX9PswWOxOhg4t+MRGKKZySb9paIkGEnL2IWgzVreA8y5rg3?=
 =?us-ascii?Q?CUHftywqzKdpZ8twSHE22hQCRB4qJaizH1EZ9tYSh4MjWjGFyI7QiJxDDh0Z?=
 =?us-ascii?Q?Fz7s0TzewwEHBtQCGeU/tSp/80Qj2ekrXXSvGrM5Jv/+CooMd0qfUmKIXOdZ?=
 =?us-ascii?Q?QS9NnG58R1R4aFCztK1uDPH5ScecZr8jEcT/Mrf021xxaFSD3baeYmYZB8o+?=
 =?us-ascii?Q?jRgwPBkRuu+KDcY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 15:23:38.7144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e71b94-44d9-4d34-3820-08dd370aeb08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8284

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's recently introduced Grace Blackwell (GB) Superchip in
continuation with the Grace Hopper (GH) superchip that provides a
cache coherent access to CPU and GPU to each other's memory with
an internal proprietary chip-to-chip (C2C) cache coherent interconnect.
The in-tree nvgrace-gpu driver manages the GH devices. The intention
is to extend the support to the new Grace Blackwell boards.

There is a HW defect on GH to support the Multi-Instance GPU (MIG)
feature [1] that necessiated the presence of a 1G carved out from
the device memory and mapped uncached. The 1G region is shown as a
fake BAR (comprising region 2 and 3) to workaround the issue.

The GB systems differ from GH systems in the following aspects.
1. The aforementioned HW defect is fixed on GB systems.
2. There is a usable BAR1 (region 2 and 3) on GB systems for the
GPUdirect RDMA feature [2].

This patch series accommodate those GB changes by showing the real
physical device BAR1 (region2 and 3) to the VM instead of the fake
one. This takes care of both the differences.

The presence of the fix for the HW defect is communicated by the
firmware through a DVSEC PCI config register. The module reads
this to take a different codepath on GB vs GH.

To improve system bootup time, HBM training is moved out of UEFI
in GB system. Poll for the register indicating the training state.
Also check the C2C link status if it is ready. Fail the probe if
either fails.

Applied over next-20241220 and the required KVM patch (under review
on the mailing list) to map the GPU device memory as cacheable [3].
Tested on the Grace Blackwell platform by booting up VM, loading
NVIDIA module [4] and running nvidia-smi in the VM.

To run CUDA workloads, there is a dependency on the IOMMUFD and the
Nested Page Table patches being worked on separately by Nicolin Chen.
(nicolinc@nvidia.com). NVIDIA has provided git repositories which
includes all the requisite kernel [5] and Qemu [6] patches in case
one wants to try.

Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
Link: https://docs.nvidia.com/cuda/gpudirect-rdma/ [2]
Link: https://lore.kernel.org/all/20241118131958.4609-2-ankita@nvidia.com/ [3]
Link: https://github.com/NVIDIA/open-gpu-kernel-modules [4]
Link: https://github.com/NVIDIA/NV-Kernels/tree/6.8_ghvirt [5]
Link: https://github.com/NVIDIA/QEMU/tree/6.8_ghvirt_iommufd_vcmdq [6]

v2 -> v3
* Incorporated Alex Williamson's suggestion to simplify patch 2/3.
* Updated the code in 3/3 to use time_after() and other miscellaneous
  suggestions from Alex Williamson.

v1 -> v2
* Rebased to next-20241220.

v1:
Link: https://lore.kernel.org/all/20241006102722.3991-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (3):
  vfio/nvgrace-gpu: Read dvsec register to determine need for uncached
    resmem
  vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
  vfio/nvgrace-gpu: Check the HBM training and C2C link status

 drivers/vfio/pci/nvgrace-gpu/main.c | 150 +++++++++++++++++++++++-----
 1 file changed, 126 insertions(+), 24 deletions(-)

-- 
2.34.1


