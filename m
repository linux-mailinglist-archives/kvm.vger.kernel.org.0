Return-Path: <kvm+bounces-34564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BF0A01AFC
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 18:36:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B80A188330F
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 17:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314001B6CF6;
	Sun,  5 Jan 2025 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nwzZIIim"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B93143725;
	Sun,  5 Jan 2025 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736098602; cv=fail; b=sdqSo10T+WW/pamFqnGHEKBgHb3GgmcXFxdYdwAn4Q0AMuOA71ewO1ei8+HtoDTxEengs71PwtOAk5eAGLA5Rn/RUNjbhk4Zzi49ZejaDzmcpLdIZJdpXNtKpC3iTzucmcvFruTyejTdIq04QndNifDkNSLX0nj+RM1dKP22m9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736098602; c=relaxed/simple;
	bh=JBWJ4EQCYNvt/wbVcO/n/hy4TTbfdWKfuqTbUGGtG+E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cfPO6BqWpLjA4NKKwZo5jClG/tvScJ7mQne8FdAaMD5KNyrFOjOmrxfVhisP7cvTzpzQqVXxBitRD8VliHhgmcy6xfz3Q/8kkos2XF7hBLCUy1C2Yo4wV+/cOb/rq+tCv4O8aIVFbZS+1vdvbMh4vPwYlXdnVRP9lFTz0akiB9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nwzZIIim; arc=fail smtp.client-ip=40.107.237.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KUDVKkMcBgXVxV1CGyfxmZCyLhcLC/SC0L+pzH+13qyI4O6cJFDKcv1f5IcewFOoyMEXR8tdT9ycvemGLLgQVach2tItCLztJeXjG8U/w4Clf2xLuzK8En3X6HQ8vTmXWO4XZ240WlfzilXRdkNQr7g27AzzBip6HAZ82exf0DXA+Z3Aod7sZYGoDh3dKcvU2UEUOldfZ80TCg1cVElmSc0bqWePE2a87M0S7e+Seyt27aC8Qg/SUz03ofZJDPMOH9wwbhPUM3uenW4fCeOSaxOTptcFMLpEtmgIUeVG8NPZYaRb4HxBR5FBBte3Yb9G7HkW0qNBl/Q391Ce21L/Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsHEc9ziShkXCAR4X1c8MgCdnCvGOO5mFIF1pUqE8JY=;
 b=ZlDJluW2f8CvWzpKE/PYDMvEMGVSkuJIQSlziJqc47Y1BldXzUO6Eq941OvpacmHrj1gd4bAvCxryfj02h2n2h31qRiAYQLMqO1sUN0SWnFBiw4U1uwv0iY6kgc7seNRI+ZonuwAcsLTekXHOx/3eQVj8gSThCwb77hzSae2VChpQK5oi+KO5hD+iL/jz6sPK15lAJiJ9+FXYKHydHwdt40u/D3vMjRztsXsFRys12XraTR+FgvWW32gXQE9XLLiRACH6BQG5iRzX6kWmi6U46lzrSsQfOaeWDoiSp4ypucEVskHbmXI35pO2KZG9Faa663LIb+LXdR7/QpoD1wYGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsHEc9ziShkXCAR4X1c8MgCdnCvGOO5mFIF1pUqE8JY=;
 b=nwzZIIimBGdMWH0NHuuDCuGXKthGsXTMs2JN0lSFBYWDEw+E83eQ9vZqE+pCzN28+zy9DQw5d6QQJXBit2IK5KhSzF9/YGckKTKNXovEDkDEt/8Bzj60TZyYZVGs0DyQ6IKq1WwPa7LudAMKFcgMU5q3OQlsz+1VLHtk3osSjupuYv3j7ExFlGj0NRR2XvIhOIRiJ1gR+8xoqZvpak4P3eULdfZpHT+ZHEX2Dn9XK4rqWxhYBz8dtWNWvECH1HHPLSsoa2YVqCASRQpINVGaj11OYGjUVQ/7VKudX6NIvRjAdncH/ZczK3ivv57XiuBKrU5hIhfI8rXXaHhvRjOf8w==
Received: from BN9P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::22)
 by CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Sun, 5 Jan
 2025 17:36:32 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:408:10a:cafe::a9) by BN9P221CA0025.outlook.office365.com
 (2603:10b6:408:10a::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Sun,
 5 Jan 2025 17:36:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.7 via Frontend Transport; Sun, 5 Jan 2025 17:36:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:17 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:16 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 5 Jan 2025 09:36:16 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Date: Sun, 5 Jan 2025 17:36:12 +0000
Message-ID: <20250105173615.28481-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|CH3PR12MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ed5e00f-8292-4ac3-54f7-08dd2daf7ed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lZpApKl5OFGtqif1TXZXnjLXfLYALIak4KEHQJZI2Ujxsc+R/ujD/YpELVqb?=
 =?us-ascii?Q?SYv8uKtjzSdT0BFNq6OXicgWZS0bl9eEc+DYZGxqVB/qjftFwKGw/6ejXZU9?=
 =?us-ascii?Q?F5RmR1LpSBZrpgCULtoLrA7liAmXKWUbRIK/lukVyXjwH2Uf8R/1xvxFRChm?=
 =?us-ascii?Q?VHzqLd7oXTxT3iX2Fd01BKBvSKcZd7vT32fjLoQ0YWUdbhXx5NWGg2KYC/yW?=
 =?us-ascii?Q?G0AwcMt7mmwnySgDVTjOwETWjQyTDNVNVquoRaQXTng09454m88QlxnmUe6k?=
 =?us-ascii?Q?dT+jLYMWvHHKcem55ECWo/FTpl9OQhPRDcyvRxMImQZ3rJCWUOOIcYZ2DtnE?=
 =?us-ascii?Q?nekafV8acCDAsWMhGpEBSs37+fHPh2k0njZYrWgFFV5fjtQRSlR0CzVzs+Ih?=
 =?us-ascii?Q?C3iXgrBTUQLMq5NT/fqOrYmTtZkVgpSquooJKvZJPeWzgJrzviqfp5Vff7EI?=
 =?us-ascii?Q?mXbuWZWDFWUlU3XGRLeZOupsnSwlJKVs4VDhnzP8hbg50cCEhZQ4iCCPNN03?=
 =?us-ascii?Q?+ostSABoJhKveuUvbAexFlhAyxycuSbNObUlEO1U75wT3nROcW3O6ySDgN9L?=
 =?us-ascii?Q?SQ0sUFv/C3V3DcKf8XxpCWgobzGvwgpNhOSHbt6IFZ+dI9u7YAboymFgVDLD?=
 =?us-ascii?Q?uyLfYJ5cZNOAf2s2vnPNyYzl7P4hCSr+ThDYw+wZyvY5W0CsksJ5eXsz1h++?=
 =?us-ascii?Q?Oo6+3WPaQf+H3yCglKV5hVYgo8GfcAAV7lVRU2ESEaIYisUKHy7WeVMfQNFs?=
 =?us-ascii?Q?BkBxjVCO5NePL9GR2vrWwkf+YdFTTgLZrZ7pO1kqLk1mXR3ckc5ROiUbeLbY?=
 =?us-ascii?Q?bRAdNsuvrK0FXGGbkpYsuIhfwlEkc5g2ZdB4aTy9TWE2+n7jdNSSa6M3w9Ap?=
 =?us-ascii?Q?TZuHLPN+GocL6fZYE5kbqVpLdL/l6oHQWwZ99YkYNMsroXRoEzR1TBX8ll3W?=
 =?us-ascii?Q?gAxiBVzOyDXdTWQJsPgn4wli/vDJWNMA0tb20Sx45jW9Ffj3mUZnCUrFn1CZ?=
 =?us-ascii?Q?lH61JvBDR9PQRwiZFgMCwEEKk3pflUMaFifxobcMzdU5TFp6ueu9FIyVvOlV?=
 =?us-ascii?Q?17UiE7klkUQowReBYeXFuOYBKsdr4ecncZ/lhAP8daf1q5liJmUS8rr5ZRnU?=
 =?us-ascii?Q?cRZM8rdKNlHNY8ifkn13jLp84Tk1AmUMySfWnYG8AOovQTutWGzQLB1nJKxp?=
 =?us-ascii?Q?Q0F3469EJznI2FRJpxxZ3KMO/uQHTsawcH8vCvfCbTAkx42lOqFY7zZc9uqa?=
 =?us-ascii?Q?gDMC1AbsrhyUkS8WoWyF3pjyYw4FezV4Fp4RHiqqT7nHxMloR4hgcgDsnsNG?=
 =?us-ascii?Q?247ReTusFp1M8ULtfeTZzsRypU5bzEiKsd4su3g1PPE5G52ULjt/BdrBnKs7?=
 =?us-ascii?Q?RRltxTDsLwwe7ulvrjtc11VZS5KtbhyXHvOF6YuP8iSC4AxlvdBlJeDUGP8T?=
 =?us-ascii?Q?6AGjkMIZi50AFQu6rMJIjzmdW7zmosIOR0qBek5lvor2v0jH3Xq+Nh5mayyH?=
 =?us-ascii?Q?tWeuEL/LWlIQw8I=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2025 17:36:32.4924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed5e00f-8292-4ac3-54f7-08dd2daf7ed8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8659

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

 drivers/vfio/pci/nvgrace-gpu/main.c | 115 ++++++++++++++++++++++++++--
 1 file changed, 107 insertions(+), 8 deletions(-)

-- 
2.34.1


