Return-Path: <kvm+bounces-63375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF93C6435E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 13:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 516C74F4463
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06FF32ED2C;
	Mon, 17 Nov 2025 12:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HiJzXqmF"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012062.outbound.protection.outlook.com [52.101.48.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AA53375D0;
	Mon, 17 Nov 2025 12:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763383346; cv=fail; b=e6KG2yKE9BVs/e0kAp9EzgrsM/qTHAxSiNVRJ7HCKGc8hY7SfBTf1i//JCWAT7B3soIOhAxKN1bUqtRwzASD31XTLwd6EpKgwr1vJAg0iQsnk+e0etZOV+hrNtXmeYRJLX9DkM1gNVYBOLI178vzfX1BbHAx8AyXyiVmDJeBTqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763383346; c=relaxed/simple;
	bh=07zGaeR/09BrybS3fDP6PSdZNXkWUcqXrUDxQgAkJwY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oCQw2SF+1VJelvJ/I5Jn2ea1UIaqudhZxCcW+lrvUZjXOKB7k+86SqA6/ka4ogVeFupTSGhpLXVtKwkDfPlqbmrBG529o7K2zvCV0gwG5ffJIkuJ77ekNSB75edi+fjtv3qUlZyAO8WoQOwXXlmfeqm+bow+ZW5771k05muBeVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HiJzXqmF; arc=fail smtp.client-ip=52.101.48.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qL7T745jUp81jZXm/Gc4Sq9PFOlAD+KOh5m4SWrvfPoa/e+PSIbHgK96V9Nmxz81AF2E77n2YxPajF77iSef7MVsZUgzp/ExZI7LtvEES99p105caVWod3pAVmdmtUCYK8LbCvByP5ma1DBCYxdUlX2AuLvUevVVV+PE7u4SWyNOoab+EVGjiWr7pkqNbYMAPJsTssc1kpY5hQlsbupsRhwYo4IRxWsk3URRCzFFIDXouCRBN/voyBccCUh+Mi4AO25Qf9V1RhxUhxJGhqaDEC7rCehQtNUas6lDM3Je6rNQvswJQLQRHY9kfF9PRirY766pul/sgCmm4ggDXdNaWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oY1JiytPJAu0QkoTATrS+xm3tV33sbKI6AZdaUyQ9do=;
 b=SZVxpUcijvgUjUUkCh3TRrd1z2311n0DMMloQyJ17GOjAO2XsYiMfmP1+zqnKonJ5W55rPcR/EBunbtbft++TgXXHu1/11H01T/6HfQo1eT2J6Wa4Rmko2FNI1U3ifBfRC+HtRce0iOo/8w2c9Q6Rpc521CQpyuBnO/DMEBPCbUVTwFU0b4+BpuUek3lWquhd7BQmNseldtcqHTexSB83+wAC+Klffi3jZSVvGkLCBaJPnSh0P+TV35CpMYj/THQ28nbBpZtmrzqVyodS/djwqthIi+4vBEyoQMd865Ar3J9IZaVUZavgWZSwOP9rLl8mTRXJE5EsX/xnBctMIqLaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oY1JiytPJAu0QkoTATrS+xm3tV33sbKI6AZdaUyQ9do=;
 b=HiJzXqmFIZUkmR6UyoKadOneaVyjvUjlW9FTcq0562PAn7FFUaSN4VYy6I1JPNb0mJPSLKoMHQ97Mnr8GLz5ldoWjU9eFicW6UkNJK1Ok5uqRdxOloruN95fM7hJT3Qk3XUGoCNt1TXHs9ACdJJlBftDdYeqE7Hiw5UJFkztg4BduyFR3Ve+bYrA54UKSWZfZLlCT5OvOqE2MxElLbz/HZouM3UsnQRvdj9gO8M9FZP1AvYZSlOOqwK4Sth6GD/XS3R0aPcNkpanLLv1dq9MMwLtsn1+a6J4kDKCSK9W3MQ6BSs3/E/OLOIOoFmAWt+4gySHoZ2XQpY+9PJFUgZfNw==
Received: from MN0P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::29)
 by IA0PR12MB8086.namprd12.prod.outlook.com (2603:10b6:208:403::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 12:42:20 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:52b:cafe::5c) by MN0P223CA0016.outlook.office365.com
 (2603:10b6:208:52b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Mon,
 17 Nov 2025 12:42:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Mon, 17 Nov 2025 12:42:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:00 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:00 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 04:41:59 -0800
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
Subject: [PATCH v1 0/6] vfio/nvgrace-gpu: Support huge PFNMAP and wait
Date: Mon, 17 Nov 2025 12:41:53 +0000
Message-ID: <20251117124159.3560-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|IA0PR12MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: 553f8c80-9d2c-46d0-08e3-08de25d6bffb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eJFNrr9Tt+hVk9HTGf+G3WIL4rQT1R+Ae1fKDdxuxKk+32nO29RD5MRjGcD7?=
 =?us-ascii?Q?wJrAyiMfq1zSyYiYEijq0A0jgqGYjTHVUmOLpU7rjum82NeKVvDabpLxx25u?=
 =?us-ascii?Q?/XWeOKQyaluYc8SFbP1Plu5gZHRC0NrcdFYIkiVSSyFykV92yeqFxLkuU60V?=
 =?us-ascii?Q?EwNdxb/j/Lu4v6hbm0REGbxXTY6b/lPKHhPF1af4dEI17owJEnDq67mlTOQD?=
 =?us-ascii?Q?pWe6Tjw/mci3vmMUd7PCx5HGKwMdk0vmMwSWqjJqRISwb0GgPPr+o8YZYUPF?=
 =?us-ascii?Q?Lb3/1P0uBR1N1K5EjKnU9+EnCnvE6chuEjJLXVj6DwEP2xwA6Nf08TIaJqFG?=
 =?us-ascii?Q?zc1HsPMmKlvKFVSZx/EvUxJo8KKIwOgwOedsdRh4LYmKTePjDnK7LynOX4vP?=
 =?us-ascii?Q?VIr0ggN0siQ9/UASOyWe8jZjMT74w0OymDZ3IcaqnlAglyAzrmBylbwmNUCo?=
 =?us-ascii?Q?aa9bq1mtdrEqYPuM0NXzhnSmRkNG1xqSeBaGflLHNTIZ9Vr7bu3q5NSVX/xh?=
 =?us-ascii?Q?JsKrZqShW8VzBkb4hzw3fljXq1NgbhnSB0a+4MkVRCLDH7MdIz2/RAPvuL0m?=
 =?us-ascii?Q?bDBpSLpsnTJU37xrTWIkrVYydPp1XVVIxHbXDa4dQEBO/FZ5C1leURb9N0s6?=
 =?us-ascii?Q?G9lW//rAvKN1k1/pVCSTKQmJBwJRJLyS1MOYZ2lx/pZ01jbIyMLcwMUcDzdB?=
 =?us-ascii?Q?TzXcSGz6h4RyyfUQ3jgcyzDhfbwJrCX9cPv2iAyZ1zFRjcoB+ENhbqfiysgQ?=
 =?us-ascii?Q?dGR4xJdcy9PxYb8vZW0LyZGdklYJYvpUJLb3kF2IeqkikEztpBB5Qxgrs7E6?=
 =?us-ascii?Q?hkqUVij6PD2FuBCxVBM2YWtGIgNCwYBSbQJVoLl3Ju7FFSN/Yi9E758DAF42?=
 =?us-ascii?Q?yAnhc0peBEu6ZiuyTI73VSWx688SuMYZ4nxqzqnprqaGnRd+lRn5x+cnIgv1?=
 =?us-ascii?Q?oBggBddHaetvs6JR1/O0MO7S9Ui1MF3T5S1Hx3Bj29UCQpuXtuYlrTv70kfQ?=
 =?us-ascii?Q?hJ1YQrEjDETcB4zxuBkyDpnLuoAH3Ps4oIL16pH5OUucUypANAZi7qwHsf0B?=
 =?us-ascii?Q?FGulHF/akuf2b/BpXs6aEMWIjAKSFjvwbCNobMGlt+f/HbsoxLQnKM3flYtx?=
 =?us-ascii?Q?RVh8a1nSCPJufUN3ABq4HRSZWmJgfAZdk1tEe4VHW4xzcX+nP+zIONnmfhxo?=
 =?us-ascii?Q?RLUtkbp3pWKPOXgIzkI646pW4FS+t2ekSZ8vDJkrm/FwJnqOp4gfXIBZbbFT?=
 =?us-ascii?Q?piIylIExLP/Dfh1BgaW+ks20nvVRmZbLl1rhAjFwTDSmKwgWZbtkvD0Y6s3c?=
 =?us-ascii?Q?eDTPEU0+6M87EdS5bMCweCbqbzkC4nmEPY0lmt5670a1VbpIS5Uy0tHs6S5H?=
 =?us-ascii?Q?Vg3ukILPMd4+Sk27k3odEelAgbbWvvkre3cFj6xxUxBwjfoa7M2KZFkM9EXs?=
 =?us-ascii?Q?wo7nO8rBOgkgDiCvvcmvz/sE2IIxof6Ngc5fxaARzuHlaRE0U6goJeIiJWyY?=
 =?us-ascii?Q?3pB1s2ViOh+gGKlBz7GLiXTL+6za9gPBIu8dY0XghXlurwu2I4Pe4TsbQ+Zj?=
 =?us-ascii?Q?XK7WNW0+6HJd4wl8Nk8SBG26ui/FoldRGdC2WUVr?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 12:42:20.5367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 553f8c80-9d2c-46d0-08e3-08de25d6bffb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8086

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
the CPU attempts to do speculative reads on the GPU memory.

Wait for the GPU to be ready on the first fault. The GPU readiness can
be checked through BAR0 registers as is already being done at the device
probe.

Patch 1 updates the mapping mechanism to be done through faults.

Patch 2 splits the code to map at the various levels.

Patch 3 implements support for huge pfnmap.

Path 4-6 intercepts reset request and ensures that the GP is ready
before re-establishing the mapping after reset.

Applied over 6.18-rc4.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (6):
  vfio/nvgrace-gpu: Use faults to map device memory
  vfio: export function to map the VMA
  vfio/nvgrace-gpu: Add support for huge pfnmap
  vfio: export vfio_find_cap_start
  vfio/nvgrace-gpu: split the code to wait for GPU ready
  vfio/nvgrace-gpu: vfio/nvgrace-gpu: wait for the GPU mem to be ready

 drivers/vfio/pci/nvgrace-gpu/main.c | 170 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_config.c  |   3 +-
 drivers/vfio/pci/vfio_pci_core.c    |  46 +++++---
 include/linux/vfio_pci_core.h       |   3 +
 4 files changed, 168 insertions(+), 54 deletions(-)

-- 
2.34.1


