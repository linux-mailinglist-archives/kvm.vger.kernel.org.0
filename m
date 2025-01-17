Return-Path: <kvm+bounces-35884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B85A159F3
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33D777A30DC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F771DE8AF;
	Fri, 17 Jan 2025 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hORHg0hs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDEA25A636;
	Fri, 17 Jan 2025 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157045; cv=fail; b=XhDAS233kGyiWuBt4s4EzSYiXqrlub1b9zXjf68OXmRAE5LpJMNszo0rNY5AcQUdUicbi23fGhoLulNDha3gkI81c7JjzYgGUI+WLygIERDaYgTlpEy2jahG5foNW7sUOVzwenFdlK+Rn/Wq2tFJzNfeE1IMOVUpGemPPQ0sggU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157045; c=relaxed/simple;
	bh=Zi32ZHVhr+L0er8DT2dGF0yDNAa1MBbm2OnzujeJRww=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LhX0S0WPfHc+bX2hVGyVuWRMPCHPTMk6Wt4R0DPkeC75NROZKUf6DpKx8DN5NMA9EfnumPbKGH9+oFXMygBEl7v7K4sPB2fuOhkS6+ywyTvdcXFj4GbmeZJKuLinE6csncZmb206kS4UJA/gRu9O50PnVJkZUkIRWqwLyLUTRko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hORHg0hs; arc=fail smtp.client-ip=40.107.243.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kO1wSL+rHTrbQlE0p9BwcINEXJsNMNqvWw853WxmNw76gy3DMxAzmxLidOUcmje8qaSvJf6une234xQ8q1CE1NuVPNPRP//5gDFZ0xnqX1yN3wWr5Rqtz+xZnXkodSLWgtZOYRDM2UM9bbASYafhbFOytKDM3Z6kVEawOeILsb2thQEwuPVQ0EILw1uLDhCB3JYkIY7/eOYhnbOoQpmNejgx/G0x09pt/+Wf3kRPcCmgoBxqesv7DiOY7TcIj22o0pos/N/Di2te7DFr9UtzIG2yrl3x7YH9WLVUr+cgoAaicPK/NHyOj6egMWo+OlTPhhW0kYOI+BvcPrxGjJlOgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKM2uSc6WAZ9mz8N/nVpcpzfa/r10LaXob55n5piGGY=;
 b=VOZ3xVJ9Q17upNoKAJvZqY3rW7aJRP25DShzRd+Ep5nR5Jp3ydFUb6er/AAqypc0hZw+BAqllzhUC9QGwxZBuIl2kydRYe2bqR2mAVWTOJe1VvplF3A3S9uhyiggvjbeMjMfsMkVkCdHGOgaiyWLJ1sxqE1Z2FWKdMMieyc9MYtLd1xgxiO8QKdE59a5f1JeWcj+EtTypKkiJqjGA+uoT7tWwBZSpUMk26Rgp+VSlnbeJuavIwjVWojY4KGeMpfzkcFy9l+lXwz6s5IIwILQn97ulMCxc2YY7fzG2Dri9nXscfGGh11qSqJF456iH9BdTaPPmU3Acy2Vdn1w4uPP5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKM2uSc6WAZ9mz8N/nVpcpzfa/r10LaXob55n5piGGY=;
 b=hORHg0hskJe41t5lrcc5vWQybg1Lmy6++z+y25ZKNnwukgkfxbO6u58e+wHmfr+seG1zABUp9spAFx5ZWVoITHjwOIKdOUbr7LDTgAJc/ea8u6w6PZFOXU893Q2jWyIDRrIeGtg8ssMRRPLlmS92lXXqcg4l5Lylf/H3uFP/sIdr3plomwPh601+SEv9/jDZ2eLRH0IArF82hbMr9vsHyW/pha23hQTUcxDKoCpjH/AHd5dd1DzetEQYs3hb5AifFGHjDYlHApJ0HAw6vsix4fdNRSBDmRKM3MPTpdLtu7VzXwvPQP+wjCPIHtCrre2hmFgAB/q3yWW/Bluu/W/B9Q==
Received: from DS7P220CA0057.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:224::9) by
 PH0PR12MB8174.namprd12.prod.outlook.com (2603:10b6:510:298::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.16; Fri, 17 Jan 2025 23:37:19 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:8:224:cafe::89) by DS7P220CA0057.outlook.office365.com
 (2603:10b6:8:224::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.13 via Frontend Transport; Fri,
 17 Jan 2025 23:37:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.11 via Frontend Transport; Fri, 17 Jan 2025 23:37:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:08 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:07 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 15:37:07 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Date: Fri, 17 Jan 2025 23:37:01 +0000
Message-ID: <20250117233704.3374-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|PH0PR12MB8174:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f439991-f8fd-4cc0-e3f8-08dd374fe202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sBn7gNtcTIiwP48Z3sJLL6ch29iAdwSFOdYnJJQOki5y1TOLTLa26i3z7NIf?=
 =?us-ascii?Q?I5cZ9POfRNjtdDiF53MRaMzy5iQ0NNgyyX+hHaUbjh5BtfI7aH58B40fFVZC?=
 =?us-ascii?Q?Ad5nOi6t9u0RVxr1msjGn3VDdYwUVz2h5rC2aYaAYF8LuDt7TXXpNWltuEZN?=
 =?us-ascii?Q?oMuesWZvTxSFKiNuJkE0yypwoGSiJD6MMZCT8w4fjC+k6bxPAgG5Ck4LPm7j?=
 =?us-ascii?Q?wfT900bnPWwM1ggrPd5ebWKJfDmC7nfHjGNX8FXrKvcPrUbIV7J0HsORucz1?=
 =?us-ascii?Q?JuBSIKjUAenOBLfVNm7D4MqbZhWODIuqkVIFoCVwYvWZM34NC66ABKJ0gr5F?=
 =?us-ascii?Q?wmaMBdo1kNrmx798O/FCn/+1fGO8slf0/kcA7+Aitm3p8uBqywB7F3nJlHKM?=
 =?us-ascii?Q?0GeU/4F4W/sgm43BW1N22+fbI18rovCYqIgAy1NYBo6xHLuA8VVuhILs0oAI?=
 =?us-ascii?Q?4JSBRGIr68g/87onQPW/ZT+GuzOq+UnSw1X9Yyq2/juyMzldrLv8/umfcz/A?=
 =?us-ascii?Q?ToqXAa+VFvy9l8EUsR5kv3HQZc0M0bHXn8InQGIjclJGlk7r2TmRtlnZ8MLJ?=
 =?us-ascii?Q?h22Ynsh4K4k74j4BFCkrlWB/yo+dCxEvYjIlyYME83i1awPfEWrU97wBCknD?=
 =?us-ascii?Q?mz6kXVkXPMkEsvhe/OIbokYeV0v0uZvfg897nv4+dtwhjsUBmDNtdlDJZSqK?=
 =?us-ascii?Q?gHbPF9sLwIbS5Z8syL9QKAVK0ziYTGsZI+twANezlKKNZx5l4YNpRGHu+ZD8?=
 =?us-ascii?Q?qqluuM+I1jxTVWnbyM9STb4kXlltUKYItLa8JCH12VaoWZv1p8lfJ157AcHr?=
 =?us-ascii?Q?en0MnHfOMlWY7Y/3Q77if+g+6iR0u5zGP1YirMoZzfsFbH4t9cqvRFPRD/H/?=
 =?us-ascii?Q?aKHbdaKE/humTQPxMD24xEtzDHk97+4bnnkzVNKgvCKJUD4cqh4med/RCjc6?=
 =?us-ascii?Q?af/GDtpiv3UnpVW5t2AiRqvKtRav3X2hn0YpmQ2kkK5ce5s0xnTq/zHwIUEg?=
 =?us-ascii?Q?WJdCMbQbSiCP4iXUjihq4auctwTbvPSxPQH5pEBtCyeFBTgfPf3xgs6O57q+?=
 =?us-ascii?Q?nP9cnfzdoOJ+nHl/adwDmsGxIrx6uFgBwTpBPcCKDDcLF1+drlHWhbmuprgp?=
 =?us-ascii?Q?qQR47BrD+Y+IsjVX1ywLfkuFRRB3B/uqVda+CTmv11BI0SY9MlNQ1Em4DKtP?=
 =?us-ascii?Q?1HZNCyhIxX8UeY/jDUlvQQbZDtvwB9kdLrArx7nwV44trD4Kdex9dtDmnBqT?=
 =?us-ascii?Q?Tyj/9fhA4eYsLlghvEIZpBQWdmmwpLE5IA8GmyU7DZdROYtq9UlDfdVarhNQ?=
 =?us-ascii?Q?x7DGgBzj+gaXoSucwD/RScqXPkrKCuXQ2MYEHz2aB5uO+dwIZZiSRlPejLPU?=
 =?us-ascii?Q?wqPKyuislkxBjSS6wudPeKKeyiNCL9YodNIVsrj6qP2QF5LaGGUDOjstALNP?=
 =?us-ascii?Q?xtdKGjRIV8I7QBkIkkB42pn1dBoZtEl8v/RAbbQbmLevyojQgeTxGOAMW6Jt?=
 =?us-ascii?Q?B+Ygrm/BkT6SsIE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 23:37:18.8856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f439991-f8fd-4cc0-e3f8-08dd374fe202
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8174

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

v3 -> v4
* Added code to enable and restore device memory regions before reading
  BAR0 registers as per Alex Williamson's suggestion.

v2 -> v3
* Incorporated Alex Williamson's suggestion to simplify patch 2/3.
* Updated the code in 3/3 to use time_after() and other miscellaneous
  suggestions from Alex Williamson.

v1 -> v2
* Rebased to next-20241220.

v3:
Link: https://lore.kernel.org/all/20250117152334.2786-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (3):
  vfio/nvgrace-gpu: Read dvsec register to determine need for uncached
    resmem
  vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
  vfio/nvgrace-gpu: Check the HBM training and C2C link status

 drivers/vfio/pci/nvgrace-gpu/main.c | 160 +++++++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_core.c    |   2 +
 2 files changed, 138 insertions(+), 24 deletions(-)

-- 
2.34.1


