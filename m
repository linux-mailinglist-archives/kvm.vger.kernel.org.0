Return-Path: <kvm+bounces-36414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E58EDA1A934
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1A683A8144
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D87165F13;
	Thu, 23 Jan 2025 17:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fc467R4h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC19B156F2B;
	Thu, 23 Jan 2025 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737654563; cv=fail; b=nzCel/QSgytsCXrLbGwDrcXSFNCv2J8vxtW5eW8J3s2eFQpVKV76NS9oRKA2xCDWqn3DwDWPMI0pDak8f1PBleOoUYrfxGaDONBy5sanKdcmI93Pxg/urSvIHjznkD9u6uO+7rTIOptfIw0ysNvCw3pA8f1bWqfVBG7s2fLzkBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737654563; c=relaxed/simple;
	bh=3UyG1OjscKLliR4sfSD64HNiIO3eHC8W5MK3YQhOeZk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L45V7nDeS8UHhadJb7MYgZGVuueXglXgxxJ47vgt/FS8Jvm7czwwiqVq90Ndl1NXnTS4tpajOWMY0XGIFpplLGb2zMqeqmajBFe2hQlgMENWFk04QqOB7yRIy4vo/ZLjGk0xvKK7sBj2gyAI/DQ7BeW0w97K4vVY5SwJEG9xFss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fc467R4h; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzrd7pl62lMs13BKXAUTBrNS+ILHm6RlPyh22RmuMF/E33NC3wcslGydncIXasoY1ildbfkChBlYAwmvjES2PxZx8YMaU/1C6Lcra4cbS7Ix+Dlj0AjrrSeBKSYQ6TeJLCpwtxLkbMQl+uKuQP5a8CJh5RWZvqSiOqovNJFIBjETbTbd5LJWV8cEG5IWMS9tUNNBj28DiQfDlMI6fzomEPsZyJ+5L02Tnss8I/2RSt60QoVMHapozX3Meg6LKU8b6Qmml87S8Y+1NEdN/+t2NYLG8VdzzE1q644zpohH/resFHkDrnNuHblGbeoe8HUbghCx2Ty6Fd0AGzaUeFv/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aV/JQ0o92vB/kwi77/MAQ4YKAW4k+U1div9PQOdBMIk=;
 b=ZiGdMzNmMiyqrUQBRoLva17UVlCgQX1pgiG1Tt0g9QXKQY+0xX3AyM+lH/pvXyOkfaJwpS8z0mbPzXDEMzhm93mLeZpG4A89E9evZI4IhYTcKywd/+hcJRgsgsxn4A1CqLJV6ne4+vsSWTWVLOnGNNlU3ZmT0paOc3Vp4ycuQKCh5bUH0abvYBTb2mFOWknCaYV6XiUf7yEGFPXxQCGXe9wiAhnFGBTzC5VUOQr5M0wMQrEDvh2v8ecz4f8HdIkyQiS4MV9HT2kemU1dabcsuVvM6JrCvdM6+/2JSyxiBFaq0aovnDG0AFONoMQ2FYcLYUOWYhhWJQcdT5/RWI8i7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aV/JQ0o92vB/kwi77/MAQ4YKAW4k+U1div9PQOdBMIk=;
 b=fc467R4hlwSIjxDIgCm/JD8xkwPwHlspTM9xGdp76UnZPJ+MPfn4J+DD9d7EMjag0CI1nACkvTI1Ne9DLD51vG3Lwey8fng7/nkeay2O0ehzxj5jaJwQgdoNtIAz5xuKqD6dXhX/V2sy/0Y7dpKMBP3+91VZwK1YCcGYL5826eZjIvilZlsCHwYqxG+6XlvUu3wNgN50cl87NPsPfOJTwapiCmtKvwQwflsySgFSqtMTPyjyHbfrEuzsMHT7jBplX/QwgJWkTaTLmVLMGt6/rZt1bP5N5TiZBBt4vJyosHe2tYKL2FT/9BeChyrNM63F43p6Rzf8mHgB1BtkvVt8FQ==
Received: from CH2PR05CA0015.namprd05.prod.outlook.com (2603:10b6:610::28) by
 CY5PR12MB6456.namprd12.prod.outlook.com (2603:10b6:930:34::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.21; Thu, 23 Jan 2025 17:49:17 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::34) by CH2PR05CA0015.outlook.office365.com
 (2603:10b6:610::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 17:49:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Thu, 23 Jan 2025 17:49:16 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:02 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:01 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 23 Jan 2025 09:49:01 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kjaju@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Date: Thu, 23 Jan 2025 17:48:51 +0000
Message-ID: <20250123174854.3338-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|CY5PR12MB6456:EE_
X-MS-Office365-Filtering-Correlation-Id: ea828191-e76b-44ed-4f91-08dd3bd641d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p9ti39EmnNAPJfpUwBZA0aaQiK03AQs5J/evm5qEAXYUzJ3EahCnxxuqdR6j?=
 =?us-ascii?Q?qjRrRjKtb8GYF0wgshua7UtiO5SPYjGL4BMp0Aji4/gIBsayv+n7Xs/9hZCG?=
 =?us-ascii?Q?hyWGPCCIYb9gPW3HPb/qc54dOOYvKZryTeahmdscDZCLqg2N/bfxGhEuxicN?=
 =?us-ascii?Q?wgoZr/zeKoPkB578PTC2agAWOPHzUaIEwqk7j9W4+V5uZ4XJaKVxOcSZNSLu?=
 =?us-ascii?Q?e8OgVBqUvmfGOkzV9BA4jYwCYG0sjJacyLDYaAm72F9iFk55Wt3XOLoIgcm6?=
 =?us-ascii?Q?8nHguecZ+wyIiYYw089dkHcI1oBjQjqJZiAYWLt6ebpY2bVRMffkZHioro9L?=
 =?us-ascii?Q?TmLjayJAU2fk90ZyGeVnCeXLIOMLZVZ5bqLFmE7G0h3SFe0gSQaKVe2TsWG8?=
 =?us-ascii?Q?/1R2+XN6wmogdqRj7gNULwBuKqEwbPCbQaI/rynwi+Wy8G7AtY5Yx9kz4vXG?=
 =?us-ascii?Q?3StAVWebJfXMfPDsSG2u/Utsgq7vuqyf63Kt7+DKwuI32UsYkFZcUm7/nzoH?=
 =?us-ascii?Q?TGtVPG7zmyAedp/GNKj4hirUvjZ4ZzylBFn3suSZpgY/Fo85einpm9eIDAkV?=
 =?us-ascii?Q?+aTdDnzzJ4TIto6dOsjQIPFY+teejPKGpAVVlbGqI6eL10a2BkJ6cBi1Ag4x?=
 =?us-ascii?Q?CE+h9zw8ecMIYw32f1Jy3owcBitms4eusSH+Hi/yKM621q6A6sANc+UiyIQs?=
 =?us-ascii?Q?DLjJJwPwA7ehR6jpX0DDMWvZIG+eACq9hYGeX5IXhuxBrqzo88/FCdS+A5eR?=
 =?us-ascii?Q?Nvn0s6yD+Xi76BX2h2NjM739kGwKyU3It4qWt5xTYbaOv9i3M+qFyIMXq+yi?=
 =?us-ascii?Q?T5p80oW0230/cxLoI9qUezkwJF16nZqYcy03GsNNHP4cuO+NF8FO7xehhI47?=
 =?us-ascii?Q?5MDU9uTPv09zlLKAISa4X19fwQfXRRmLW2gdEzxefiGrJzkgGSw3yOtypJwo?=
 =?us-ascii?Q?kqQkecG+GVcYNN+Am2Mni8zSPuRuqjj5Ha0kK1eba9Qn03YpqqzXp4q7ksXv?=
 =?us-ascii?Q?BrrKnFpVARq2xvTKntNuA7OJPV1dH29hAw9RkfTIhxhISiJevYON2uDGY9Z/?=
 =?us-ascii?Q?NkA5OkVJbSKpWfxPC7IpyScwtaleBNvGRfKP+dII5P40+SNbD+YHXw/AmaMq?=
 =?us-ascii?Q?yFCwdyxfdnDC26xnLP6TIOPcrGv4p5q7PNHat5ZJ6V5M76nJsiEuw176PK87?=
 =?us-ascii?Q?CSdOl3FDtmObDKnxHDwH2XhT0XrftihHR61FDqmiRj3w3xIHdo/0/ql0KTnH?=
 =?us-ascii?Q?hg9DIPX21+nM5TgVG3d5s0vRf7ImdQVMBjtgFnB25OW4LRuOlJERYYRskCyh?=
 =?us-ascii?Q?32GwIChYf5cl+3568Nd0q9qrSm3obEuqhItNw4oXjowev9U7uOD1GkUMmPG0?=
 =?us-ascii?Q?BYgDRdBPRhsvUcPpxTzwrpwXunQ4PYrGh/pW5flyGhK8mZcUUBFP2lBYIL8q?=
 =?us-ascii?Q?kFb4jec5oXf2B/izcE1Q1bKQAiaRv/2o7vG1oY/wZ7eRPumbYHweIhye95Ar?=
 =?us-ascii?Q?nwe1bqPW3+SMd30=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 17:49:16.8792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea828191-e76b-44ed-4f91-08dd3bd641d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6456

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

v4:
Link: https://lore.kernel.org/all/20250117233704.3374-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (3):
  vfio/nvgrace-gpu: Read dvsec register to determine need for uncached
    resmem
  vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
  vfio/nvgrace-gpu: Check the HBM training and C2C link status

 drivers/vfio/pci/nvgrace-gpu/main.c | 169 ++++++++++++++++++++++++----
 1 file changed, 147 insertions(+), 22 deletions(-)

-- 
2.34.1


