Return-Path: <kvm+bounces-64137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AE726C7A1EF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 016EB4F01FF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B6434D39E;
	Fri, 21 Nov 2025 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iaXM2ykr"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8903C340D9A;
	Fri, 21 Nov 2025 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734336; cv=fail; b=OFoNkrWT7H0pzFGFZb8/Si/PejfbSoMOkxnqwZ2kxdvKy1Mh45e9lexGmip0yTUioxxTZFX9OAKjJ5bIiZLt5ezzWtHOIllJiAcgm82ed7L9Dx/JCLM2gh0oH5njiwwGN//gpOHWp6KBU3PAcR7iJudphSLU8OPf/MG23A1IHU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734336; c=relaxed/simple;
	bh=KUQ+JzuD16Sd+xnSm759kwQfSLYHfBf1fSS910AKprk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p8LjqjNHdTNDWLdGKq+/Wn7q+u7KeHqucMl5y+9+VpwsaKlLLRi8QJL5dmGvaj1wnd0heWwNTPAFvbyN7c5HXIXEB0rqQ9ZGVcnrGE8L4MX09bdDQjxsUX5pTu3Wa6XL+HTlV7FEoWB5mLGYIFR9BRNFhNRktKVqj7pk7/yXy6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iaXM2ykr; arc=fail smtp.client-ip=52.101.193.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfrC3+1Dhdkgkrz6X969Vbf1t/OGW9wazhUSRGMk+13vVTgzM9O2kWVHNMwSuvYkhbyJF+FJ4KA8nA6ANF74dx6auP/STOzt283h7wLA26tivlJj7dm0ez8V7eQ7t8cDsFat9cFpRqe4US2SB/z/7DlZRKRG2P76cLjhXJ5QRP7ckAXg+LpIKVhsWNq5+u2JgP0zQ+fK5nDLwnKRJhHCqWEEozTKPwmcqU5c3mqguW7bUAx5m699X9ZnvPI/YbHHJFAif/vbd2LzMk1KhQEnwyc+srVNi8gvgtmeYAyzpLsbZ77XJ1qKhsLHRwzL3/3ep5K8QUTWx4udstisL9qD/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqd4mPklKKz90FQmlhZl8Gd/tmO/gfDoD2IWb5c0F1c=;
 b=rA9FPLW8E5hMO2x/Ap2q/FbsIV4Iu0wtmMtreAfnr2Wzo83eI9mTvW0iUrP45JBEHcSi77PSRZuCulD5G81U5ZLH+9HVtYHDF+LxxfhTK8IzEEVeBVs31H5PAzPR6UQvyO/b2hwbA+/jwOPVq4DPeyNGCSiX9DDEZbgbwmpomTn+vW6fN8eMTqOCQ/bO/c55MRSu+3nvtNPnRnvrYwYY7xHIsA+XuiFeAtjNQtekj3tMiwI5UA+2loMsnGX80jMaB7fPxOLUOqoKmVFPUxZQQKeSjRfJVgStCJKRj9r2M4NPBU4ovRq6w/4/SMJPvHsn4iQtt2o8oKO+G5TGnBs0lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqd4mPklKKz90FQmlhZl8Gd/tmO/gfDoD2IWb5c0F1c=;
 b=iaXM2ykrmYXENv0hR9kO0obDVNFF/sD9bZfUjQN2w3Y2RShHrQklZZNd+kDg8a5CZrxyGlAC2DkMfTj7+Te3MFpJd23car8rQ1/nRDEDSecUKw59cgXmGawLxrTveeNxOhvapw1+wO3EK8CoRYs9eS4u4sIfB5c7ysGRc1k1R4jF6c+E4KzuLV4NVHUWVJA+MInHQVUIviMfACDdQ5rBCtxkgqKNRiaYrPMaJDx9PhfAiZx0oa2JncszGNPaekBDBPIyl2xQDlZ/9mq8lOnWrF4xLuepbxHnygs4U4SBzDiW2VWFGXuqKV6uXCAKbRkFTeQ2VK1PEaTN+EpR05eQxQ==
Received: from CH0PR04CA0099.namprd04.prod.outlook.com (2603:10b6:610:75::14)
 by SJ2PR12MB7918.namprd12.prod.outlook.com (2603:10b6:a03:4cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 14:12:02 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:75:cafe::b9) by CH0PR04CA0099.outlook.office365.com
 (2603:10b6:610:75::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 14:11:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 14:12:02 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:42 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 06:11:42 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Fri, 21 Nov 2025 06:11:41 -0800
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
Subject: [PATCH v3 0/7] vfio/nvgrace-gpu: Support huge PFNMAP and wait for GPU ready post reset
Date: Fri, 21 Nov 2025 14:11:34 +0000
Message-ID: <20251121141141.3175-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|SJ2PR12MB7918:EE_
X-MS-Office365-Filtering-Correlation-Id: 900f8c50-7435-400b-7404-08de2907f15e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WH4ugXO2j5mHKyGzFxhi7w2BGSo518+4E2+HPSXslsxaYdmgaQmbHOPE/G+J?=
 =?us-ascii?Q?sAzHlJM8nZc3qkXUgDr0J0m9AxZl0d2p968TmhtHj+Cdl5nxgDM+ztfXVxVz?=
 =?us-ascii?Q?6AMhfheS2k0S7+ZQnjSUWn1ireHc1hWp80W/TcpEGcF+Wib19Sff8qBMueLV?=
 =?us-ascii?Q?HOaf89OSWVzqAdcU6BRxBh5Y+kCnofEYClTn2ZdN5TKo+2+LH7A9NxbIs5FV?=
 =?us-ascii?Q?K2Vjg12tXHU6ZCHZzM222+E2Kans51r2O2xirD6YgUyFtemrlNa6YBmiUum+?=
 =?us-ascii?Q?y1p6kVWnavN/J+SdSpdY350gxoyt1yLsZkBck3oyi1RNM4cfq+JEULocD/fz?=
 =?us-ascii?Q?rMup4VklsmtPBu9iWq+iO3nNgixs8yb8E3cKJmSdG+NETYPUoAih+qR38Doi?=
 =?us-ascii?Q?cqWE+5M6uqyw+MMPenWMCaBW/qQF2H6eziW7sg3TVy4/IRaTSzWijoVeaDdq?=
 =?us-ascii?Q?IccVAQxMsvcBhcmFIWL5NPWfOwtp/Wh3NzOUes87IzpcJpS9gpXhfKXDh8za?=
 =?us-ascii?Q?SwJBrHt0dYHO2NZzQmZ2IvUs91b0GeLT9qGh+oalOkmSE1FIDEN3+6oJ0MLd?=
 =?us-ascii?Q?xlYjmS8YMSlA/b9DQ4VfzrCfeZk6Af3rt+LHLbeFLJ4u/Jx8x48J6eEvQoq7?=
 =?us-ascii?Q?gOCio26sIbf51lcZE8irVnAdCFjxeIrRUrbj9jVZCmiDnAf3+VM1Xr4PjGus?=
 =?us-ascii?Q?iYj+vvKXqDRDGmDSz1mNq/OhY3kMsRS0bQe9TvqheVaX09OWRyF95u+wG9z9?=
 =?us-ascii?Q?xEB3YrSIZGljdo0iwOKABB9RY1dOtJNTC68mFHT72osw9siv5AtpjUiD/xoW?=
 =?us-ascii?Q?01YEU1z3mHpYc5NbcMHzwjVr6hKUBpXfTNLRe5XxMx+v7OYrJfPFV2xWwKe2?=
 =?us-ascii?Q?bgmZJ8SsdF9OyYZW3yb56HAK0aSlJF966GkZw0/un4FLj3HesjWTo/ezqgRu?=
 =?us-ascii?Q?QfLMY2KEeX4do7vSHbqEfSH1AXWbeIM/ASxtT2qkDAiljqEyCznGRfGtlXrO?=
 =?us-ascii?Q?UWTGBAhs/WjdqQXETuDR8wX0/h2pxSa7+YCwDBH6Fj3vwRsaZqI3JLLaqhlY?=
 =?us-ascii?Q?Mi+x5Y+fzUxwarZR9Sc56m6OmqqO0pLHZ4TEioKRWS4SjaobFUpR1zA8D7g8?=
 =?us-ascii?Q?wIOo1GmdPaIZfjQ2GcDhD2PlOzUdyZCzXt8nYyOf+wrM/1fyLLg+pajm9Pwf?=
 =?us-ascii?Q?G6AnRXmiEfOQut6i5BrZ1q4fotR344bXJ6KrO8qR9mpVdFwJxCTso7cbAVtB?=
 =?us-ascii?Q?6Fn0LacGvpNgDASM80PuJ7kRrkkKKRQFmLmRG170peu1rDfrCD+yki8oC1iK?=
 =?us-ascii?Q?srcxWslEJwiQ8FQtB+jhEFLUoN95c5Owspf4mK6b4LPhJKDcIWqkyqSS0eKL?=
 =?us-ascii?Q?jWto4r1DwkKvJHuiNBx0MGpxNzpbX2U+arOlRu6zQQf1YuiKbP0nvw7cjUgl?=
 =?us-ascii?Q?omqxn5d/hq2+McCS0ArhsinZbst0y6lSQfzl9jiqkddQVSRmP3jkZwu23g10?=
 =?us-ascii?Q?dTw94hwM94pIAM7VyhQUqwzQNmYTDXMomRvh8G9G1jvC/0PC/BNgart8r+lg?=
 =?us-ascii?Q?jWqM0LkQUzh0QwUWedA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 14:12:02.2548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 900f8c50-7435-400b-7404-08de2907f15e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7918

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

Patch 4 move the code to map the BAR to a separate function.

Path 5-7 intercepts reset request and ensures that the GP is ready
before re-establishing the mapping after reset.

Applied over 6.18-rc6.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Changelog:
v3:
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
  vfio: export vfio_find_cap_start
  vfio: move barmap to a separate function and export
  vfio/nvgrace-gpu: split the code to wait for GPU ready
  vfio/nvgrace-gpu: wait for the GPU mem to be ready

 drivers/vfio/pci/nvgrace-gpu/main.c | 183 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_config.c  |   3 +-
 drivers/vfio/pci/vfio_pci_core.c    |  84 ++++++++-----
 include/linux/vfio_pci_core.h       |   4 +
 4 files changed, 207 insertions(+), 67 deletions(-)

-- 
2.34.1


