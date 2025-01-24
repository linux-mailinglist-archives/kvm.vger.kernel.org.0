Return-Path: <kvm+bounces-36567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79205A1BC27
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4369C1883DDF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B39F21C9EE;
	Fri, 24 Jan 2025 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z80FZbEM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA4121B8EC;
	Fri, 24 Jan 2025 18:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737743499; cv=fail; b=qoW4jnbB1CESz8DjeHVQcy4xBadwJT0pzR1LAqGBdYbpXqnnVE0tyH6AlX/maBwHEPDEnP5Ojh1L0YUSASZi/bWDuZlRFPoBdLYaOU08Lbm+8Z9WcnGfWQ/ui8pvMw1QEXNIPSw55VLR2we8ezhMhIiws1KOa6TT5RnfvJSGNpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737743499; c=relaxed/simple;
	bh=CRAf9nB55YQe4xbxTi2gsfWfIqE6LXB5GJa0TmLGEeg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AGtC9YvelNYpPMfjitE7znPWI7uFNqs7sKm43r9pPfI8aWp3vSR7+sGQNjoMIIEqt9LrwduutwnTJSZ9x9OsxhvMtFAUI3PVFxuqkKNWq+TSnDmealnI9ik2pFYsRZpYhnG9pzxuTPaDPwy0Qi9a/80njaD88j1oD+YhIw8LPIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z80FZbEM; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UuyoRCnTqbhs4QoUEWUrzrQ9XKkDZf7CdY1XW9CIIfy4fM+qUxwirlfXu/DRNbS3B/wsKZ5/J6z2I98oTBxFC3jWTc7W4BqN3THLn5YSLNDkf4jJ7Apyqa7LZRk5W3DGaddNhT/TSXY9lpGQVWabKRUr56K6Cn7H+DsWzgmc7NSWSM4jVk4jjPQFw3lgMWqSSrrzuR8Z0eM52QJ4F8jMf7qjfA6V/4Zr44346T+2P6gorKWjjPhlu8KNrxwFmuMrAknv88+rn80B7Ci96y0DHwCqbZrYHgJKAo2niWeB7PacV7GUfQTGzQGZ5cXjpOyK6Yvr8DsLyg4emORiKRyR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmOiRdq3Xdj1LspP6YKU6EZzx5pOOa7RzW3qPn8XRxI=;
 b=ZENDh9Z8fwFGNlNvBJHwJl5+Rgn5U3Jqz84PlRqY6bOYfZhrKyAe7alQ03Vf3n1T4fLkYqRewthWLeubH9ZoLh9O2YziDDBBa8gbSUDUQst0sEnH0MRpaJAQ4/YJ2J/7iR7S3f5RaQPUJMqQT7fT7yguU1PAlNOhaC6n8v+iFrTovIVY1/FhkwDv9D+EH4H1naixRB/tHYDERVEHkvYugRn0usXQrezaki6WWmRRxjJx1KlKrTFkehTaW5JQ3UTwnigydWjLK8vYoEhEmg/6M8+egMNte+ZE0dWloK1mXtqcHRQwpf5rK+30b7fK8Vc6zVZ/bh/WKdl5H0fgzwQbGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmOiRdq3Xdj1LspP6YKU6EZzx5pOOa7RzW3qPn8XRxI=;
 b=Z80FZbEMFcc454PGGVCWD7L0/foFycRVEl4MEG4tvMRyLKveB2aQ4LxLUKm7iwo9x685oF8/6SlEbUxP6U+Ty5swnJ8tvLwsZtc13VBH6GCrvZEC2ySEzlei2vKVQilguoj7xkV1ma6z5nLsq8dqmziF8JfDRIw2pmOGEGLcR7Yc3zeuANK4fKrIu3b1GgioThc6aLzyihn77Y0pkfmG8GXAMzJt6W7v+5VtPEJHlSlZQW3EEp8lgC5r92KNDxEWYMxn2mmYRLs0BIJDYo9yaaQS9XXVg/O+fyljcfrP/pBSMLWybbDX7Q3eflVh/Qr/bEXVy5ITCj8JhS7YDnkHVw==
Received: from SA0PR11CA0049.namprd11.prod.outlook.com (2603:10b6:806:d0::24)
 by SJ0PR12MB8090.namprd12.prod.outlook.com (2603:10b6:a03:4ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Fri, 24 Jan
 2025 18:31:31 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:806:d0:cafe::f2) by SA0PR11CA0049.outlook.office365.com
 (2603:10b6:806:d0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Fri,
 24 Jan 2025 18:31:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Fri, 24 Jan 2025 18:31:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 Jan
 2025 10:31:14 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 24 Jan 2025 10:31:13 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 24 Jan 2025 10:31:13 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kjaju@nvidia.com>, <udhoke@nvidia.com>, <dnigam@nvidia.com>,
	<nandinid@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 0/4] vfio/nvgrace-gpu: Enable grace blackwell boards
Date: Fri, 24 Jan 2025 18:30:58 +0000
Message-ID: <20250124183102.3976-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|SJ0PR12MB8090:EE_
X-MS-Office365-Filtering-Correlation-Id: 6164f4b1-1ca8-4d94-8d59-08dd3ca5521c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vTvLr9SzOiOxAK9o7babzNAWgvowbR+E92T2VsCwacAuRrHEwQA3F8IdrP7y?=
 =?us-ascii?Q?oCsYEBvD+vpwNcANaKE/ZTPloRfkogVaO8cKetlAhSVppiKEnBDLVTCuNh72?=
 =?us-ascii?Q?SD3SkqgHkPEZ6gJ3WM2wojHTfIBZ7bnN/yzDp1YlTeKzqlGZjc21E6CnFYlz?=
 =?us-ascii?Q?IUq898bvD9lau5gTed25TqROA2v3ZK7D2oahyspYC716ODK9/h4MQ3J1dDiL?=
 =?us-ascii?Q?2zH14KSlExUoTv7vUpDUGvGUj2AtyqcuWfVf1JViE8IZV27mwrI3pRocMJt1?=
 =?us-ascii?Q?fx3r/zMSoR+e/J3j5P5Zf2QWzaKGttKflpzY4ADv9/yaT2DHA7tP8xQaJAZ0?=
 =?us-ascii?Q?lWKVoPXx8diwNm3YfRjY10OcNRiWkCuV6TvqlfiiRTtiwAdtkL2bq263G9n7?=
 =?us-ascii?Q?e4Aaqx9Ti8xom3KURfAkH1R0RjyDvTZw+LPPfjuf8ri0aCVytv35JEHAQUAH?=
 =?us-ascii?Q?LoNRpuzsBr6SNArKoecqcAPMRFG8KzD50bw5IxIvnnEs2GzGMzuEwO0RfwXn?=
 =?us-ascii?Q?ay/KkIR6pxqxrnpPlrRJ0UHkLlxeepoYTJlA97TUSc2wxrgFCUtSuNRaMxQF?=
 =?us-ascii?Q?TU0LrwYQMTRk0xxxcPkwopNYrfzbAanAPVaMbq4NC3ualG4L6E+eMeSwIjW6?=
 =?us-ascii?Q?7m3aSgkug3vUkFsP00Ke2WdYc2deeACPDPmvvsYMHcFtWHUZtzfMc84OsFrU?=
 =?us-ascii?Q?ic2jcUXGcRoWC8EvM6U1t+SlcjwMbEVT31O6DvqCbBwSnHCG1UMBImBPXJGN?=
 =?us-ascii?Q?lKIWaIgCUvGqC06g4PZ7cy7NFQ4Lv1rOdQUawAqzEUCdI2y9H4lzjISy8JzO?=
 =?us-ascii?Q?9fT2crnQNlrYOy1OFrIl1U222MTJWv1E+sCyUfnVhVtbQnI6K6w9LQstHVMQ?=
 =?us-ascii?Q?NvDAwJeZgMCbtBH8cFMaHHotF+8zPtTee2AlZpg+QhKfo5nCwY9lgUO/BJT4?=
 =?us-ascii?Q?f7AR5WUsu3k7XEt+UPoZ19tsB4OYmp6J+n0Hpnb8LQ6sDdKPAke/G6J7JzPp?=
 =?us-ascii?Q?zt60I8tH6V8w8hGE7d0u/BBN82fpOmdgC1xx4fgiTq0jvDVfpJUMrnodFeB5?=
 =?us-ascii?Q?KDCFfat/VLsyTyKzzR/njWmvdZnBOmfQNPpk6FoPDvzS7yMwOQ+adoBJ3kvY?=
 =?us-ascii?Q?ksAF80cU1ahhGw5MKlSWcaEPNh3k84LxEMgyyCVc573/MnLXHHObvUWzzjsa?=
 =?us-ascii?Q?7mJgoyxUfqoRjAcO0dH/jZ78SXf8X0EYBRPE/6UqAw5b/bR29Ez0PM13p0hz?=
 =?us-ascii?Q?79+cO5XFiUVcu3gZPWYdJZH6ZK6mOaiihDRmNLzuICGso+JWKigChZGNSeDl?=
 =?us-ascii?Q?0mO7CuyJ8zSJnHqAPsovrTYtE3YzvbH1Vg8os6YHUuDtZZNuMuAPu1E28fLP?=
 =?us-ascii?Q?6AkqBb2Y9mtZ+9DIoFUcIR0EnwPeP5nW5kxor4tlPO9W4HeuszE7pluV3cAB?=
 =?us-ascii?Q?p2ve5DKvOltByLiQbVF3CQeEqNrxIuJzBQl/BdGIK8Vye9qOrjDs5+/CvKXM?=
 =?us-ascii?Q?tAtV/phNF0S84kk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 18:31:30.0258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6164f4b1-1ca8-4d94-8d59-08dd3ca5521c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8090

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

v5 -> v6
* Updated the code based on Alex Williamson's suggestion to move the
  device id enablement to a new patch and using KBUILD_MODNAME
  in place of "vfio-pci"

v4 -> v5
* Added code to enable the BAR0 region as per Alex Williamson's suggestion.
* Updated code based on Kevin Tian's suggestion to replace the variable
  with the semantic representing the presence of MIG bug. Also reorg the
  code to return early for blackwell without any resmem processing.
* Code comments updates.

v3 -> v4
* Added code to enable and restore device memory regions before reading
  BAR0 registers as per Alex Williamson's suggestion.

v2 -> v3
* Incorporated Alex Williamson's suggestion to simplify patch 2/3.
* Updated the code in 3/3 to use time_after() and other miscellaneous
  suggestions from Alex Williamson.

v1 -> v2
* Rebased to next-20241220.

v5:
Link: https://lore.kernel.org/all/20250123174854.3338-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (4):
  vfio/nvgrace-gpu: Read dvsec register to determine need for uncached
    resmem
  vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
  vfio/nvgrace-gpu: Check the HBM training and C2C link status
  vfio/nvgrace-gpu: Add GB200 SKU to the devid table

 drivers/vfio/pci/nvgrace-gpu/main.c | 169 ++++++++++++++++++++++++----
 1 file changed, 147 insertions(+), 22 deletions(-)

-- 
2.34.1


