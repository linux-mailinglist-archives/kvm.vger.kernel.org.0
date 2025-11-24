Return-Path: <kvm+bounces-64377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24BFDC80598
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0DDF3A0550
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0988B3002A2;
	Mon, 24 Nov 2025 11:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AOmH06Tw"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653BF2FE598;
	Mon, 24 Nov 2025 11:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985581; cv=fail; b=bkDdPVA3bhpRwx2fZMWQRkMOTqd+8vnRnCGAUrHieojvs+yUOZW9RbrLvz2AIgSQ4yUBL21GN4mp22j9qpwRNbayqMXruDM07kb7d724//hJjxkXJ+i4BhaR9FeigErd3xcItf/TjX91QqyjLU1SnVWRqg1FVePIPVhTNR8lILk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985581; c=relaxed/simple;
	bh=Mh+UYXNXe4/gzNpZcrdPpAqcoU7GgpTYvJHuvrccIDk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uVe3o0QEkgKKUUEwURvwVT+9fQjI9zT1qhetSUIonZPGh6CxWk1DDBvjq1p6yKVrLW91g9YXJ55foI466AJ5qeBH2pcnDz+bJTDNEng+rXF7A07Ffk04VBboaSAe8pRzD435PM9v2xsxKe/sFhgA6reVpY4de+5+ifaKP7uPeMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AOmH06Tw; arc=fail smtp.client-ip=40.93.195.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UNwhhRCKWGigZGD13/QoNHxsvuc7MRZdNnUIto3Qa8NfDHq96xC3YlOpcDyEyV8o4z0ALB0HyFbQ/ITdKPV0RoHiQfmLwKxLx8zH+OZQ6YsTuiNlKHl0k73AsJR1iWWS8kniPljRy2M6X0tAsVALeDGY85Ayr60EUkhtw/YBhJjRI9UG738fsrs258UqCtLqmr5FehGUu28XUq9qaMFSVx6gxAq6KE8cgG5OsD0K/0TUahBGwV2q68z7I1jdPR+sdHRNapAqlbpftJ931x06k2ylGuKiHAPuDtwfRdnuSQQNWn3COTla8aU92ooKPSR8QvQKxUV6QtIVRX7PtCHzdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dW0xh6AY105OE3L33VsYk4hQYN3xNexzX0ZQQQkrHBo=;
 b=ES6bBRCNKzrek4MYmCBkkhJNsx3AA1Q1qlWAPxiNzDYyYJJTVjZRiKUkxFsVqsNqGpLS+j24CMLdH0FwojIrpc4m1xS0WrBgNUjtg+bQBkjU1oHi6rgzvuqGPVyqt7SGxQzUVm/Kq1rSP4RIxz4+v3CM/fmHSEsaL+xpEpm/342KQpZEx9BYotL9lM9GCaOQaRrR4Wj6A2OZ84bnTrM7bfux1ui+bRw/FYX8bQKcrRhb96AgXpVAP63fFp5nnsSTrSMVhxJI4NnjIAV2UixCg7G4Jz//tKO5lL8MyuBddxz1xAEa7cLVMSkUyzPjLs7oYR0cMLBBKjwrB+wUGbp5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dW0xh6AY105OE3L33VsYk4hQYN3xNexzX0ZQQQkrHBo=;
 b=AOmH06TwHriECGkegzNUwfM7NbOViabXzYVoH/IqKR9hjYk0RARTzYU7PuVBRsGp8U4W370lxs5LHkd2dEM4+P/rqAIb4aZEqOCEVOVQRj/7luuflc601l90mQQD2VWAXMqsA5A+CkDfm4fbNEvd3gp/BKY9czMp7kR7THenLHlVpe5Wj2/pTGV8qODTbft3MleeFzsl2hAAysWOiA6Fus1W++sNGAjAQbbY2LDwL0bQ8hFWgir9kFWXc98nmN1QA35XYYDCj0Qp/ou76YiBmtu7ZjNoDnWnhChldbARaaNr0C6mbbvhOwDXmgiInMoS1bpbMaiwxf/0IoIQABtupg==
Received: from SJ0PR13CA0137.namprd13.prod.outlook.com (2603:10b6:a03:2c6::22)
 by SA1PR12MB999110.namprd12.prod.outlook.com (2603:10b6:806:4a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 11:59:35 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::ef) by SJ0PR13CA0137.outlook.office365.com
 (2603:10b6:a03:2c6::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Mon,
 24 Nov 2025 11:59:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:35 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:28 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:26 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:26 -0800
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
Subject: [PATCH v5 0/7] vfio/nvgrace-gpu: Support huge PFNMAP and wait for GPU ready post reset
Date: Mon, 24 Nov 2025 11:59:19 +0000
Message-ID: <20251124115926.119027-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|SA1PR12MB999110:EE_
X-MS-Office365-Filtering-Correlation-Id: f8f1064c-06ae-4b93-3ee6-08de2b50eff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GuxNgdX0idrxps/NaWWLeGjp5Ohjlsm3acsY4zsmAt9rymIFs2Xkx6GIoNi/?=
 =?us-ascii?Q?7D/xTI1RjMqV072BmjjDfsEfb5ohnFbPgsF16O2ezcWUXzgiqrEwE9XV3QJt?=
 =?us-ascii?Q?C41xijgWkdNjittHEVthbt/JtUQbAGfmfJvLIn76eHKiEsKl14plKmmlU3QT?=
 =?us-ascii?Q?vOilI//370zXz7mY6ggL2D44PBD90Vcd1rz451+GjBcHKHXxHs7GHKOtDpjr?=
 =?us-ascii?Q?Mtu8P+0d2sqizOhJfiuxkO7Y4q8AaPoZeUMQ4O9+MOBEaattkP/U7Dt56SC0?=
 =?us-ascii?Q?azXBSJXNN9+GoWy279Yt1avjzjXZcpYl1THpNSkC0NHt3mAsz5vRz6RMAMIi?=
 =?us-ascii?Q?oB2DDmbAIxsrzWVVFzy1zfMlrfSF03OQ80EPa6K5V6bVHRTtKoH94TJtTCZR?=
 =?us-ascii?Q?h3Tb6eT7KS9onbmSLmwwPxn0gr346nrEkZK2gSJ1+8fz1LTWMJiZlSrzkfIV?=
 =?us-ascii?Q?cmjUTz4nyEOG5zx6iHSsnDtstnNCkOB4pV4tegUqjryVF74sEuIVUyPYfPvc?=
 =?us-ascii?Q?317VEzBJWBwipqT7S/cVo7y3FpVK9cSPGlRTcOO0xFjz4xHT9J+LQZSwLRdg?=
 =?us-ascii?Q?Q9z3EWhvYalDNNbd5OY1tC6gFLaW7lNtkpsumfKz+pe6u2R/q+hcvLn/K0lE?=
 =?us-ascii?Q?aIr43Vh/q2ce72viZSGuJqo8DryK2foRCmLYGcB8os6enGIFvJRHEWopTEAE?=
 =?us-ascii?Q?2tjSUPguJx2pfBx+nMbzS9LBQUvbV/EjaB0tthSwKry2gmEUa5CzmWHg87rn?=
 =?us-ascii?Q?rXgtfgEdZwPSMo8JsTxi6PPp/XNj08WqjkFuLKlQeNHo8I8nfkkurUH8bRU9?=
 =?us-ascii?Q?yOTcqXL6SoQM4sX1/pl5jg7LUE+tX4Hh9Bs0n2XpEhP6H20tXeMXiZdiqqY5?=
 =?us-ascii?Q?+Kef9RXbIp1JWH9T/u80aWC6KJBJxygWgXiNNsv/ZLsIkOnxcwk4f/b6J2/m?=
 =?us-ascii?Q?YmIfOinc7nqc+oumRz27+2YM6d7SOwpHL+1iwhuA6gBCLshoEaJ9Ebx4UsMF?=
 =?us-ascii?Q?YTR9D46Ig9GmxTEI+2dP6jTCr2srAqMscy777jq7EzuNngtoMmL8vWulLVD9?=
 =?us-ascii?Q?O+c8qoHnhA67kcWX2mDRq/et6Z6fEX2Mo5+IYkPV0u6ZGQsVDBYWB3Ckfvqs?=
 =?us-ascii?Q?NmJH55FK9E956uk89GQkFCXKtbLUnTwEGkZQtCqVJ2TUx3LwoGAOXSRvbHc2?=
 =?us-ascii?Q?Qvc2FgwqHj3pXgoDkM1DPagx+g6RgidyJtk1QYplYTPetZzXJH1/Dmk5h+k3?=
 =?us-ascii?Q?GjtdkHZZ4xovwCxlvFdeqhec3syi+IIP5qRzWhqz/tjwl6NGrYkGXeci9076?=
 =?us-ascii?Q?cPnEVyOsfV1uoQ78O94nNASHCZLMeBs+Mivh9d5IaeGm/Y8/tFKHqWWAd667?=
 =?us-ascii?Q?AHw6IDYbNtT5B13vUXg4b2ixBEKX1zIqzs4oocb2vYxw8tAPcbYsR1uqTWAM?=
 =?us-ascii?Q?eCdxBd3QxskDlQkHWXW2Y0/HLIwuQFnpkyW94vxuexykFpvk++iXy0AtJ4rT?=
 =?us-ascii?Q?BSf4Du8O+G7Wuvl/vdADNhQCluw9gPwSEg9c/dajI9WxqzS+m95tYrH61anJ?=
 =?us-ascii?Q?WUi78vRWHbApIy6+Ri8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:35.5971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f1064c-06ae-4b93-3ee6-08de2b50eff1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999110

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's Grace based system have large GPU device memory. The device
memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
module could make use of the huge PFNMAP support added in mm [1].

To achieve this, nvgrace-gpu module is updated to implement huge_fault ops.
The implementation establishes mapping according to the order request.
Note that if the PFN or the VMA address is unaligned to the order, the
mapping fallbacks to the PTE level.

Secondly, it is expected that the mapping not be re-established until
the GPU is ready post reset. Presence of the mappings during that time
could potentially leads to harmless corrected RAS events to be logged if
the CPU attempts to do speculative reads on the GPU memory on the Grace
systems.

It can take several seconds for the GPU to be ready. So it is desirable
that the time overlaps as much of the VM startup as possible to reduce
impact on the VM bootup time. The GPU readiness state is thus checked
on the first fault/huge_fault request which amortizes the GPU readiness
time. The GPU readiness is checked through BAR0 registers as is done
at the device probe.

Patch 1 updates the mapping mechanism to be done through faults.

Patch 2 splits the code to map at the various levels.

Patch 3 implements support for huge pfnmap.

Patch 4 vfio_pci_core_mmap cleanup.

Patch 5 split the code to check the device readiness.

Patch 6 reset_done handler implementation

Patch 7 Ensures that the GPU is ready before re-establishing the mapping
after reset.

Applied over 6.18-rc6.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Changelog:
v5:
- Updated gpu_mem_mapped with reset_done flag for clearer semantics. (6/7)
  (Thanks Alex Williamson)
- Renamed vfio_pci_map_pfn to vfio_pci_vmf_insert_pfn. (2/7)
  (Thanks Alex Williamson)
- Updated to hold memory_lock across the vmf_insert_pfn and the
  read/write access of the device. (7/7) (Thanks Alex Williamson)
- Used scoped_guard to simplify critical region. (1/7, 7/7)
[v4]
- Implemented reset_done handler to set gpu_mem_mapped flag. Cleaned up
  FLR detection path (Thanks Alex Williamson)
- Moved the premap check of the device readiness to a new function.
  Added locking to avoid races. (Thanks Alex Williamson)
- vfio_pci_core_mmap cleanup.
- Added ioremap to BAR0 during open.
Link: https://lore.kernel.org/all/20251121141141.3175-1-ankita@nvidia.com/ [v3]
- Moved the code for BAR mapping to a separate function.
- Added BAR0 mapping during open. Ensures BAR0 is mapped when registers
  are checked. (Thanks Alex Williamson, Jason Gunthorpe for suggestion)
- Added check for GPU readiness on nvgrace_gpu_map_device_mem. (Thanks
  Alex Williamson for the suggestion.
Link: https://lore.kernel.org/all/20251118074422.58081-1-ankita@nvidia.com/ [v2]
- Fixed build kernel warning
- subject text changes
- Rebased to 6.18-rc6.
Link: https://lore.kernel.org/all/20251117124159.3560-1-ankita@nvidia.com/ [v1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (7):
  vfio/nvgrace-gpu: Use faults to map device memory
  vfio: export function to map the VMA
  vfio/nvgrace-gpu: Add support for huge pfnmap
  vfio: use vfio_pci_core_setup_barmap to map bar in mmap
  vfio/nvgrace-gpu: split the code to wait for GPU ready
  vfio/nvgrace-gpu: Inform devmem unmapped after reset
  vfio/nvgrace-gpu: wait for the GPU mem to be ready

 drivers/vfio/pci/nvgrace-gpu/main.c | 216 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_core.c    |  61 ++++----
 include/linux/vfio_pci_core.h       |   2 +
 3 files changed, 207 insertions(+), 72 deletions(-)

-- 
2.34.1


