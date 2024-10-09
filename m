Return-Path: <kvm+bounces-28285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C10997180
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1268286846
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CA51E283D;
	Wed,  9 Oct 2024 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kD+e2dRl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A58B1E25F6
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491019; cv=fail; b=GVOrrOKWQeK5z8omA2xA1BwBrO8/Ur/UqpSG0thNQFFwvCKG9S6fVjbOyKyZssb9nTpYW2e2irROdMY1BGNVQ8xl3+oriupwrCyfN8Qk8z7jhHj72E/uQtHDhOZLAMvd8opbRXLEO5i9bzTTPhVWDzJAyewpwaYhAb3WuN3fCxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491019; c=relaxed/simple;
	bh=13XIPhzPixZBnmAScrwHpiKjtNd0BnIIDm76rCNfJnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hMtfjxVcA5kuoEEpoMk3pThMGqyrRWFZH0wGRjleY9d8+hTBlV6NRZY1bSo9hmQ87LMqUpzaVASDjUsCiR4wll1MOWmbCOm/iIyl4ojK1ONrxMU9k3SYCU5HNBtk02uF46kd3fnLNslfD5pd9P23k9eziBFbTXAXVbjdW/Xt2T4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kD+e2dRl; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uAd11PQnSBWJPFDAUSz8RbveZ9kbMk5o8CxoEhNoifLYM/0uO3aifT+/IeTln4KyHkYspv+czKfYfPDui5FRvR04qNcJTOLHPqnNVLFijX4UfLlzMB76bI8VTWNgPnWrEs/Cx9ccNEPVco8oJZoVbF9jO/quRDuRqxoiuxRGkomCYnXpVz8gPO3BRxytqtVQ3lne2jeoZhJ6l60494URuE0etMsDZsJ/V3y7BZbIS6IIcoDv9c3a2TeYeIbE6fyI+LHn1+R6ih8SItIaq2MJpUdw+GDP1sAEktNp0UaUHrwgmifAAwa83EwdhN55cw/wnDbfu87ahPvDnzYOx4beww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzkew/fTCrQzoPLzoQu5qlbNv+Zi5AHyETLlK5w1NyA=;
 b=ra+9Clib88nRhWGeYhW/68xL9UXWBCX/pb/5Vl29C4SYzNsgyCjP7r1ev7Wgjzp0xXFsXyUd/h3cqGgWlgB9uYpK9WtQgldeReQdXEfkTVgiXLzXLX91oKmLtuGChBsrRDTSuVB9Vsr1u8oIv+3/sJtY5990NxK933wkjU3t7Mq/yYlTYi+Px4Xw8OMarbLagYhLQGR7kDyly1VwA4Ali+pzl/JdcbooWlr9PF8Si7/8mwVTwZysSJsQ2XH4mk5Q84CQLGOPx8B/1OlvaBAh86lLFT8JQ3bP/VObOqIHIR8MUuMl6LuRh942t4TbkObMaa1vtTuWluBq+1JMo6YsdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzkew/fTCrQzoPLzoQu5qlbNv+Zi5AHyETLlK5w1NyA=;
 b=kD+e2dRlNg0rWVOcg1LToYNERSHJ6WWMWRjA9O9rKHgGczwC6i5JMJnXRNdr7sIyEqEOreiblaF4fC/+ikWB+KLsXjpA0Vr3Ug7KN4wn8ARdKInKmoMkuY4LYdQ9w1XTm14wszKaizFvRZM44xhujc5c0CghUdpdoL5l9EZtn+rMXoes8Iv/lFiXnr7CYAvq2IUX+7kvFgb1LYTbNvWz6ReC/N43cGc1TjDEDgZkaD1kgIOwAgG2wVEGhZfIepQJPa/RNHznLvyu6dd59FgU0QjC7EvBQoj1XqEFnlIecBtzSyf4NnsEL/5vBDBmdA3tMxnJa8qY1dL6qR4CxHUXiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 1/9] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Date: Wed,  9 Oct 2024 13:23:07 -0300
Message-ID: <1-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:208:237::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: a739de17-ebaf-45e4-83c6-08dce87eaef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0wXzOSD4ppeCp460b/EcgaYWfPZhaLtbdbnOd/0Cj/w0hBrOOIxUM130Fe+n?=
 =?us-ascii?Q?PcHr3osYjPe8imC7UyScPFqfuKfqzpMDUxs4XYgUSqge9Lq0mJPR2KelE6br?=
 =?us-ascii?Q?XL390RIzMkKLpfVhlMYO1Ui5dH504Rmk3LZoBjmd2i0p+KqgHB2XRRkFJN9M?=
 =?us-ascii?Q?oByTmwOeKrCoqyg/lLSAl6qG3incfZ5RtP80afUW5NTLAeUQRM08pFGnXnj8?=
 =?us-ascii?Q?d1MEWK4LOoqVKGmmOttVK4Flp7Edmr1EaRPVah6nDi22Loxc//RJ7WucLHtv?=
 =?us-ascii?Q?L0iOF826/1LtQeQou1+bTGkWysCxaQdu/MTXBPOO4v/ND6bU9ILV4/Sbb4kX?=
 =?us-ascii?Q?L3edj3BPZgmq9lwSgG8OiceNqX7a3SAfiF9HQYY83SqDEJK0DnSntzq2oHt1?=
 =?us-ascii?Q?igC2mC4a5N4ehAy3+o3Gy0fT5E3xdOJzPKZ+emArsoMhB48NbeHA2H2zHEI7?=
 =?us-ascii?Q?ZFXn4y8WytHzckyLHM26W3QAoKMVglQawt6stQWPDgoIeRKVCWEF6Rau5iMQ?=
 =?us-ascii?Q?pn4uExDXdJ1Sy5zG2jx+yW7bjBpP0tzrh4L7WZZ8TLe18E81lfVcMV6qsF2N?=
 =?us-ascii?Q?C0T66SHgIaZrZY4Vqm0UhpK0FDDZCZObAOaSP9EKin6vHCp0v9T3ikyJnR5D?=
 =?us-ascii?Q?3by71luaZud5fazeAOZOntn5aDk78zGEYYjlQXG2zwLZkqIo81WG8OEdj2iF?=
 =?us-ascii?Q?q2lcl6/HlzYBNxGwnVuYX8stB5qyg9AqXzSc7cLdYZPKVp3svQaKEOUH/XM+?=
 =?us-ascii?Q?GPUFlj+z1gSuqCGrTrTH1cw5rs3vjjSGqkeKP0utDMISTnWFC2SNSyWAZlO5?=
 =?us-ascii?Q?GSmymyYkiL1tO71TJXIWcQ2kI2Dr2yKV36rc3zKJ3272SVhJJvclH9KOre1U?=
 =?us-ascii?Q?ICeMcAH7XE183aUuKQM8Vc3tkiQT35xFxnO7zDD/3yE1CPkOZZtOUKhR+MUD?=
 =?us-ascii?Q?+50RzBr2XBsI1cl+d3uBkQjZ/LvUOmVOa6dO+Hje0gYtwxgQ+vApjQ2HECGr?=
 =?us-ascii?Q?Ssl58NRBqR5vX1kqNTxsJEd7u3VgmYKQVsBpkMbvn0y1f3cqUQPA/6bLez7o?=
 =?us-ascii?Q?bwNfaJa0ADOJcgC19wPiWtghhssPAlS7SGoWd8oR+LxbVKo9nKM7C1g+9++x?=
 =?us-ascii?Q?i1T5dGwqsCvG+XaqtXbBEVDpYWpsBtjU4Wa7eaEMzNH1bLFuzIxgGN0yEj4d?=
 =?us-ascii?Q?nArmCmY9S7FNAwSM1Kwvt4QeWteJkuBQRuBsYg5is8dbp0eZujb+SivcXisa?=
 =?us-ascii?Q?UpOWvTqz+oOfmm+PRa64qvZliHUGM1DNQb3eUT8DtFufZ1rHvgwwFHET+Plz?=
 =?us-ascii?Q?JcIDg69sZqaoejakPEnaI7pe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IXu+SmobYwG5BoP4Fryfu/W3itzPkDxZEaju7faClUV3F/LhybPV8sxPE3mc?=
 =?us-ascii?Q?l0UtKOBxIdbTn/nDRqpxyW7gmqedFpwO8ap7xmiWhssNTVIYM4+uhhr+cZjN?=
 =?us-ascii?Q?9c4XQj92Jo0o7zrFKceXbgFpjD+ZOo5pqNavstsFw52Z0NWIrD1Kn7h5GDrU?=
 =?us-ascii?Q?m4p3I6BJkIIoG7lly5tRht1G4CTsoXLaPWgXhNkvnIy5efwZi95FskoTKLaG?=
 =?us-ascii?Q?rvk5Zv6VnkQgw9/tDCzK/rrZ2Jr5lBONnuqUBR8mJ80nmMNbPWrF1CZi/9sk?=
 =?us-ascii?Q?QvpJKlK2rCw+njy1E7AfIcAKnWE/+CXiiqTD5x/Mn5dSXNRx4DocWKglyYVP?=
 =?us-ascii?Q?gyRumoDxrNjJoaK3VimgeWsZEEm37+3NPe+Dd8JOwAczYG+LSeKmMwrNnmFz?=
 =?us-ascii?Q?muj/tAnC/4jaxI0ZadJ8uhzYJjxY/RbOLDsIaLLEUYG2Lu1Vh9NLr8ybj03R?=
 =?us-ascii?Q?sSrPiz5CRzyDfhCCxy+nQtSUbPZdKqexqCR5vihlV+K+hGCt0zqUcUDayVr8?=
 =?us-ascii?Q?k5PF86Y4hJgWjDCaJ4Vz5I6cnBRgF6yfFeexKbfJpv4DlrYfAoLCnJIHQk8w?=
 =?us-ascii?Q?i0ZKUkkVdeJHt2U6mbQi3WBbSSE5BJsr9ajcYuBS3VxWZBwihdoPUA8KGPv9?=
 =?us-ascii?Q?nfOP8Qn8WzzvIthuH8sO6dvOEyeUFV748ViMXzaOWk5m/c8ojYV5NZbgdrlW?=
 =?us-ascii?Q?Cxupwfmf+6qeAk5q8Cj1/7jxZORfKNJKcAcI+WeQNGtIu0Lgv3uis99a6nhP?=
 =?us-ascii?Q?V/9x0T7T5ak9Xh2bJbFxifRnGCZlB9TMKXWZOPYPdR1iKrTVfvtUlRO1T13y?=
 =?us-ascii?Q?aoKJn5jIbFcHUdAIw3umFW9mA/mJye1EulY4tmKqbAR8igj+Nph0wSLwYW7c?=
 =?us-ascii?Q?nZPKuer1zRkGSd6K3HWhj1CfPNfP1OIdKL4+tW+fWumj4amj8zvpoUkvy7tL?=
 =?us-ascii?Q?8EpL9m3o57uLnEg2GFYQIv1+eCmTZpHBfhFiDCnHEX29a9YyWuGKDqSAjaBg?=
 =?us-ascii?Q?pbmTWHQ/ZI6s4v9y/3Fap1wuTiiKcstrwlvKHLnKJ26qS7kVqTh/hD3v3Xh8?=
 =?us-ascii?Q?6H0vLiO6ldwioPmDi39p2XW7CHtocJJe+0srmoNbt/OuBv95nX8P98DVPgm9?=
 =?us-ascii?Q?mcVMCStRTj4GbEvJibjHqJRtYc3jmDS9eApfAW6TDDFSyGYL55I0upFuUns5?=
 =?us-ascii?Q?M3gzdATI+uFHizoytwCHW757By27d1W/gINHNajUutkFZ3ZWBgmhkpZXZbHC?=
 =?us-ascii?Q?k9xEsZYW6uXb9xM7lMsVUM6dobTpbEISQ3rJVgWRdDgWaUyFUYSTmUHGo9br?=
 =?us-ascii?Q?OFxcFP0zlPHDLwr/JwsE+XLAtOU1QHs2++iEEdJq1bQGEidXKPycIB++x/EJ?=
 =?us-ascii?Q?69xOBFt6uusXa12eb/dAVrrkvJJm52N5sbakdDYv338xyzsg/7XAVvoKef63?=
 =?us-ascii?Q?Mc/EnNOrZZFM+I5wrMn2BfBHWe7EEgEuAzG/cFmeMuQvOQLzfLrCLnOB/AyY?=
 =?us-ascii?Q?igj4hZxIGozoAIQfiDbp3YAj4SBo2oFNG0jFY1HtwNbgFPFxiVQoKr1g/A8b?=
 =?us-ascii?Q?q9KcwECc4nE4WiH7/fc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a739de17-ebaf-45e4-83c6-08dce87eaef1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:18.0518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ym60ZkOPbdTgKN5AFDSwYMbS1ChO+GeMm7xGGmGcLEFONzcMZlNSmFePRucVxvnX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

This control causes the ARM SMMU drivers to choose a stage 2
implementation for the IO pagetable (vs the stage 1 usual default),
however this choice has no significant visible impact to the VFIO
user. Further qemu never implemented this and no other userspace user is
known.

The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
SMMU translation services to the guest operating system" however the rest
of the API to set the guest table pointer for the stage 1 and manage
invalidation was never completed, or at least never upstreamed, rendering
this part useless dead code.

Upstream has now settled on iommufd as the uAPI for controlling nested
translation. Choosing the stage 2 implementation should be done by through
the IOMMU_HWPT_ALLOC_NEST_PARENT flag during domain allocation.

Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
enable_nesting iommu_domain_op.

Just in-case there is some userspace using this continue to treat
requesting it as a NOP, but do not advertise support any more.

Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
 drivers/iommu/iommu.c                       | 10 ----------
 drivers/iommu/iommufd/vfio_compat.c         |  7 +------
 drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
 include/linux/iommu.h                       |  3 ---
 include/uapi/linux/vfio.h                   |  2 +-
 7 files changed, 3 insertions(+), 63 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 737c5b88235510..acf250aeb18b27 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3378,21 +3378,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_of_xlate(struct device *dev,
 			     const struct of_phandle_args *args)
 {
@@ -3514,7 +3499,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free_paging,
 	}
 };
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 8321962b37148b..12b173eec4540d 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1558,21 +1558,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks)
 {
@@ -1656,7 +1641,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
 		.free			= arm_smmu_domain_free,
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 83c8e617a2c588..dbd70d5a4702cc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2723,16 +2723,6 @@ static int __init iommu_init(void)
 }
 core_initcall(iommu_init);
 
-int iommu_enable_nesting(struct iommu_domain *domain)
-{
-	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
-		return -EINVAL;
-	if (!domain->ops->enable_nesting)
-		return -EINVAL;
-	return domain->ops->enable_nesting(domain);
-}
-EXPORT_SYMBOL_GPL(iommu_enable_nesting);
-
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirk)
 {
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index a3ad5f0b6c59dd..514aacd6400949 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -291,12 +291,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
-	/*
-	 * This is obsolete, and to be removed from VFIO. It was an incomplete
-	 * idea that got merged.
-	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
-	 */
-	case VFIO_TYPE1_NESTING_IOMMU:
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 		return 0;
 
 	/*
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bf391b40e576fc..50ebc9593c9d70 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,7 +72,6 @@ struct vfio_iommu {
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
 	bool			v2;
-	bool			nesting;
 	bool			dirty_page_tracking;
 	struct list_head	emulated_iommu_groups;
 };
@@ -2195,12 +2194,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_free_domain;
 	}
 
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
-	}
-
 	ret = iommu_attach_group(domain->domain, group->iommu_group);
 	if (ret)
 		goto out_domain;
@@ -2541,9 +2534,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 		break;
-	case VFIO_TYPE1_NESTING_IOMMU:
-		iommu->nesting = true;
-		fallthrough;
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 		iommu->v2 = true;
 		break;
@@ -2638,7 +2629,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
-	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_UPDATE_VADDR:
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index bd722f47363520..c88d18d2c9280d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -635,7 +635,6 @@ struct iommu_ops {
  * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
  *                           including no-snoop TLPs on PCIe or other platform
  *                           specific mechanisms.
- * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
  */
@@ -663,7 +662,6 @@ struct iommu_domain_ops {
 				    dma_addr_t iova);
 
 	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
-	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
 
@@ -844,7 +842,6 @@ extern void iommu_group_put(struct iommu_group *group);
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
-int iommu_enable_nesting(struct iommu_domain *domain);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf1902f..c8dbf8219c4fcb 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -35,7 +35,7 @@
 #define VFIO_EEH			5
 
 /* Two-stage IOMMU */
-#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
+#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
 
 #define VFIO_SPAPR_TCE_v2_IOMMU		7
 
-- 
2.46.2


