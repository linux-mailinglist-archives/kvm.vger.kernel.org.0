Return-Path: <kvm+bounces-24282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 716B29536C1
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B87821F22252
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF011B3F03;
	Thu, 15 Aug 2024 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rralaf3W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C643F1AED5A
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734714; cv=fail; b=IxlHeUxm90keO/a7Ix3TdP/tSth5/L3SoUZ95zy46B6jdJgJr2+kiW6/MfU4/pZALup16oieGsbOYJnnaT+irG94PvOgJ2xDoEPBbyZ65W+FlI3YxCGAV6AEyE3jC0gLh21kjxP62XwbC5tmzcz3CyivZFkVZKhwptfmiXlELfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734714; c=relaxed/simple;
	bh=1XcPgrzJVKo6BtF+++DIQ5Sth+zdkKblDM7x1SaHdA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vv2Gf46geoiiDD7UD+TEjRiV0RPCTuiNpSulZdoatEhVsMA2VacdfIv4jUOGJGrazDclnv5CcWtiCopYFlRraOYDJRpM0m36NZRLP4BanCkVIpwt7J5Ad7bGvTSmrtC0WHQGtxvJ0Xij8XdXwZbKWGBrU5bFZDnX2wPNkbMAUNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rralaf3W; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f60b3maRMgdxiKEK+dqCgyL714VlxVRKwQykPU9rSfovJxgsp9UlBaScPpXJwmqIGq028zMDE1ESHArY/DQggQZdIi6W4rHI/fWbkL9C7Taq9DfDdUquuDL1H2cJJOF58VIw2NipGs6BsEylcvn5HlXCvVlRmuYh6y/qtjNX0D7FawkYIX5IeqOKfvGErEm7lf5hJGXjBwWS+zpbRcm9GUb3gmzFc0vJ4ni/DvN+y/sW7O9MosAuAuPgJb/XjgadmOhs6/AfJDW5VGgPk3fbMEcUOFq6jFhPtLR0H2ISb5VjkZWbM21fM0nQP5JIfIhQNsLbkc5Rkv7hLS53/Z6Znw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EypQGesWi28ruO1EyqITK/gMemNPOViuFlIPGd4zS1w=;
 b=yT5dde2QXuFFJQqsUkOb+4ZElUNs2MboqDjtZRyIfqUEr/LFT+7CLPZbP8IUOtvn71/FtxIoWMV/eB/9wl1XgBOkUqBK6VQMU3pOEYEo7NV5jr9u5nBSLSFFLV8YWi3jrA3Neo4dz+hel1cxCWp+kqksT5brBgdnSQfYBMOsvGorzaBPixW8iWgOI3Gc9q7r5lS4gYcDOfh2D7OLv/TWQl5LiN2jYJiIBOKFSmEhhF4rPhg72VLlmznDGbrYc9pt6GRjDt+GkqB37H7t7iRsMMYVqNEP620afLzwS2DSY38a9LPQyE7xETgzFOmhBBhFA2LlTn4MV2sqfgoyn5eGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EypQGesWi28ruO1EyqITK/gMemNPOViuFlIPGd4zS1w=;
 b=Rralaf3WZMtQlqjimocNn9yR0zLJ8Kfpk4UB7rjdUFN5ukoaAQUY624+e6Z7jRb8Wzy9mZEZ/0igucdIS70LJ9r3gvdTzRhCry99VvFybQCtoG6N0ISYnAYmDfOHSXAfvO0xcu3+R1iL4yyoWa/AwvNwSs6gQ6bwMHe2jWB+o9uiFKectnz9T5EgpM9cDZRjlNXBBgwfLievMIYV8wmvbxaLSLmk9/m/mqWD25Ulf1+s7YwRy1oz0YZRAO9+VWKLeQ3TvccDp0AXOb9tzU53M7hnWVBJgh1lyUnLWv7l5yuyxrqYlF8BDCkWw7ce1FcyhmwrUOJaZKnhkTwYN1QNPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:37 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:37 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To:
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	iommu@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 15/16] iommupt: Add the 32 bit ARMv7s page table format
Date: Thu, 15 Aug 2024 12:11:31 -0300
Message-ID: <15-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0235.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::30) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 61e3e86b-d2d3-47a9-b702-08dcbd3c8d70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ae6j7d5xsXUBDJwcd89E7mJDtUCISb5cM6nQ0r1lNNfJkBPS/YHLotO8RNtb?=
 =?us-ascii?Q?FGKXbEUGjzsZUR8I6JzInanxMWLhGxccLbYTSzRlvDwVQlBqyKJgaGqWItCF?=
 =?us-ascii?Q?Hpv2BSozCj+3NV3TYPl4yxkmZwS2w7gjeOSsGV27gbSaRUlkfwPKhG4cGGar?=
 =?us-ascii?Q?i5ppwdwHpbHkdCXBwT1p12Bb45hpje6BVrwbBF6jAeckCHEHxG9EaEa3+9oh?=
 =?us-ascii?Q?a7K78xvgRGyoRA0lA6DIdDGPXIx/ppD+t4wD7k4AZe7lk3WahuiIRDUR2l6J?=
 =?us-ascii?Q?aEM3g2RSBLZd7QG89PSqfvot11wq3RfwTWUr5yUKP30drViMhP51mq1Uryah?=
 =?us-ascii?Q?ZD2P9G6TjGGcllmHssto3moLfdbZGqorVpoETuZFmK2TDYyKRTB3zL+pvfF2?=
 =?us-ascii?Q?5GiPA5lz3FVPt57h8dNUkRBuCq2LMjBxLaaahPfnt3qGqJ3g+JvPOhSQEFJU?=
 =?us-ascii?Q?LuIIXZG5URxlhoUpDu/2Ue8ziIMgMLjCNxMJd8mvOnhxEiK7CZjxIg2CA52i?=
 =?us-ascii?Q?7MU1qsNkUBZjUg8qQuJPavCXtBJzalXfR0MPeuS4R8YB7oiv504DKR7IVonF?=
 =?us-ascii?Q?iVNrcqyl0ZxBeLxclnr7bwH1z7DT3TXNRKWIpBNPZ5ZM0yYMaMzIibZq9aXu?=
 =?us-ascii?Q?8KryOTDsGEkqM1Errw5Il+q3C78tnCbe2nsa38hsXajMgu7L6qnCaf1w/I87?=
 =?us-ascii?Q?gCDrxkTZcMNC0KbnByRgFfo6n/ErxXHSbVC0sqXgyCaHI5I/dOLlevySO1J9?=
 =?us-ascii?Q?lkHKLgYwkUvVUeVapjIdABHFpbM4JJdUKFbMx0BCeyH4/uDS8M9K+PfQl/b1?=
 =?us-ascii?Q?NYRSadSkR1nOGuXyHRRGuyHx51WBQ3FvCYy/VBbacGO8i6LLurfCBB8Hzs7k?=
 =?us-ascii?Q?7ZNsLIo2ViCW7yvyBfIy5cGfy5aoQkS6bY/glEqhcEi8Bmaco5ltb4FEBnJ6?=
 =?us-ascii?Q?go0JxQ7TOKj17m7d/lIqMzNfxOnWDP9A6xJhpnaJtQNQMoI35X3ixZBnGS8A?=
 =?us-ascii?Q?Kir1yI2by65F2OyTS7K8cmJo/nx1JEb+eSGJeahf1Vagoyd84+/hDWsKFgyh?=
 =?us-ascii?Q?CkR6V8Uppd464VHfGQ4HCp6BVmNno6Gz5et8tZy1K5+ImB97rKiC2TigE4qG?=
 =?us-ascii?Q?lOYPOKNTtfCvLFNfGaDtAG7N8fPliJLKFFblyPoknH+B47GttSqahToPzI+H?=
 =?us-ascii?Q?jBTCrxwrFMQ/ryAkzMPIs32GA7c+a5pVew3sBcR4XuteLt3YrK60LBqk0X1Q?=
 =?us-ascii?Q?i/W1T46ovotBq6+hEFWWHkw01P/2D1b2J/fil7y61I6YJ7gbSH5HqhEk7Zt9?=
 =?us-ascii?Q?mXZCclHs9ZGUKFHrqGJTHmFkX6ivWleqxgxH16iWckKJhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WPYfJeYYdmw1qMw5T0fX+z+cX33bH2GsRc16AWrMNejk3lTMw65POEbOwUOU?=
 =?us-ascii?Q?uMeoYGLG1pYM8bpP9CWyFzxcH3WCGi4RRdP+NPuWlc5DGHEfl5ECRZYMg9O9?=
 =?us-ascii?Q?BKoVGBle2F5iiaEwmG9AEQx25rjYlu1/1VuyPwA2/JaWCQMbV1p2jSjeXDWe?=
 =?us-ascii?Q?+ut/FMfI7U9zSLBbTQB5tPLeordngGsxq862xul1Ecbwcwzp3f+L/nxaKfRn?=
 =?us-ascii?Q?oNZeEATL0ChJrmrEZta+R8xaljE9MoHa+gcJutEWB0cuM6GjUAms/ShjGmoL?=
 =?us-ascii?Q?BPqSSFg0GCfWWWdUmjaQyxWgarzjx7KXx6VhsgM8Fhd2cGOxySr3sQQY4aCy?=
 =?us-ascii?Q?CdkaOBtrEV9n7oWEbNxkqQek4imPh7bT09EH0fjsx0s/j109t5Y2XIfSKwQO?=
 =?us-ascii?Q?wM908gtUbzN7cEAJHmoI6u/JRjH2L7kndgTgS6OaG9JL8SysJZF+Qz85RQez?=
 =?us-ascii?Q?1bttkCiKuBXtJo5gKl+Uj73Uxhg7hb+x3gOcdyFmSvuKLtIJmJ8pV9M5ewj5?=
 =?us-ascii?Q?1HTHO83k9BcT1afi7CV+qeeR/vSCCDX7I2wgb5Kt4Di619JwxPUDv2EH/CYt?=
 =?us-ascii?Q?uqzPakBKlKS61CnUjkA1rs5+kFfLT2CHc5DwygDc1O6oQEpsCytPqbtiHezk?=
 =?us-ascii?Q?1x/91sNyTcndNSNsvJOh15L/Qvrx+wesWsnCDJs683xHma/ul72EJ6hFCJok?=
 =?us-ascii?Q?R3GsBI95eY7atyp+E0rVQtlNSgw+CUOE2U/yXwqg5orZRQmkwv6Vi6B78i3P?=
 =?us-ascii?Q?fXQ7ZalGrO1kGXqeYDN/Pm/LwHw3dkbV1Q4OfkSw1EoLuW3/VipCjMivcsE+?=
 =?us-ascii?Q?6vrDJ8Zt5PKiYD6z3r5shNS0fJBIfzY4cko9ffDzYsuIda4ZYneM9T5lrsK6?=
 =?us-ascii?Q?5r70dzF27wKEdAOc3nVv8IdSLSOonC1A6B8qzt/K7WPITIYGjDl5lqdMYqy5?=
 =?us-ascii?Q?u3bGqTtaTfdohD63T4zcXskV/H7Rye0qj4OdVBpzSRryawm1QR5AhFqssFNd?=
 =?us-ascii?Q?pnej+/ZFK+0qrGhFhziFTXeXgOIF9EHOXx82XrKOcgNCoWvPbLcvwk90OW+1?=
 =?us-ascii?Q?dX/yUlAFSpPuCzz2iu68lm+hz/h7HcZdSfThMdgc5946lOTy9vc1cMPbL2nf?=
 =?us-ascii?Q?oCDplfo89MvuGKuBF4f2PC4fq04zfWrLAtozHtUjI2m/sglGAUi7aM2FKXvy?=
 =?us-ascii?Q?VEmBTDEC9xp9haW+LECgYYccsc62KYJthISTshSyW53rfIleN66CcHprMO/X?=
 =?us-ascii?Q?lH17nFR4yyKk+BTxFISQul3mfMrfh/cJn3sIfn6/NAd/4CeFnS0Uj1hrTIXT?=
 =?us-ascii?Q?z8OXszl9Xi/83u0Uu8uaCPhCYLzO30S4xFAPtAIL5YZqQy6hnGPVktAi1fcZ?=
 =?us-ascii?Q?sPDAPiMk0JWT1P0UCz3oKxE7oOBZ86ZCUzZzFcWcj/O5KSWIv4bFTfByBMXp?=
 =?us-ascii?Q?lFS/VYt6NUMYLOGiNWISnHOhtdn6ULgsZ6c7suFBSRd97AwX5iiifspUYAyv?=
 =?us-ascii?Q?dEpbkcJwKMYnYvcAAABSeiOTIzqUae3J9OV+NxA7k7WCJFnqVwLnpGelO3He?=
 =?us-ascii?Q?MMIjlB328bVe969faYI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e3e86b-d2d3-47a9-b702-08dcbd3c8d70
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:35.1114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DXmI6tlgkxhUWo5jPT3I4MJdDdIyydD3r7ThcMtB3l8wx1kakQfb8N3XKPGkNCR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

ARMv7s is the 32 bit ARM page table format, it has only two levels. The
format behavior is good, but there are several additional complexities to
support this format, 32 bit DMA and the 1k allocations for the table
memory that are not ready.

It is an interesting demonstration of how a format can work when there are
many different bit encodings for the PTEs depending on page size and
level.

Also it translates the full 32 bit VA, and has a u32 VA with a u64 OA,
which excercies some unique corner cases.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/Kconfig            |  10 +
 drivers/iommu/generic_pt/fmt/Makefile       |   2 +
 drivers/iommu/generic_pt/fmt/armv7s.h       | 529 ++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv7s.h  |  23 +
 drivers/iommu/generic_pt/fmt/iommu_armv7s.c |  11 +
 include/linux/generic_pt/common.h           |   9 +
 include/linux/generic_pt/iommu.h            |  13 +
 7 files changed, 597 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv7s.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv7s.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv7s.c

diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 5ff07eb6bd8729..2d08b58e953e4d 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -34,6 +34,15 @@ config IOMMU_PT_AMDV1
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
 	default n
 
+config IOMMU_PT_ARMV7S
+	tristate "IOMMU page table for the 32 bit ARMv7/v8 Short Descriptor Format"
+	default n
+	help
+	  Enable support for the ARM Short-descriptor pagetable format.
+	  This supports 32-bit virtual and physical addresses mapped using
+	  2-level tables with 4KB pages/1MB sections, and contiguous entries
+	  for 64KB pages/16MB supersections.
+
 config IOMMU_PT_ARMV8_4K
 	tristate "IOMMU page table for 64 bit ARMv8 4k page size"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -91,6 +100,7 @@ config IOMMUT_PT_KUNIT_TEST
 	select IOMMU_IO_PGTABLE
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_ARMV7S || !IOMMU_PT_ARMV7S
 	depends on IOMMU_PT_ARMV8_4K || !IOMMU_PT_ARMV8_4K
 	depends on IOMMU_PT_ARMV8_16K || !IOMMU_PT_ARMV8_16K
 	depends on IOMMU_PT_ARMV8_64K || !IOMMU_PT_ARMV8_64K
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index a41a27561a82d0..1e10be24758fef 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -2,6 +2,8 @@
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_AMDV1) += amdv1
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV7S) += armv7s
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_4K) += armv8_4k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_16K) += armv8_16k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_64K) += armv8_64k
diff --git a/drivers/iommu/generic_pt/fmt/armv7s.h b/drivers/iommu/generic_pt/fmt/armv7s.h
new file mode 100644
index 00000000000000..52a0eccf9fd5cf
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/armv7s.h
@@ -0,0 +1,529 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * ARMv7 Short-descriptor format. This is described by the ARMv8 VMSAv8-32
+ * Short-descriptor chapter in the Architecture Reference Manual.
+ *
+ * NOTE! The level numbering is consistent with the Generic Page Table API, but
+ * is backwards from what the ARM documents use. What ARM calls level 2 this
+ * calls level 0.
+ *
+ * This was called io-pgtable-armv7s.c and ARM_V7S
+ *
+ * FIXME:
+ * - mtk encoding
+ * - GFP_DMA32
+ */
+#ifndef __GENERIC_PT_FMT_ARMV7S_H
+#define __GENERIC_PT_FMT_ARMV7S_H
+
+#include "defs_armv7s.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+
+enum {
+	/*
+	 * FIXME: The code supports the large physical extensions and
+	 * can set this to 40, but the io-pgtable-arm-v7s does not, so
+	 * reduce it.
+	 */
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 40,
+	PT_MAX_VA_ADDRESS_LG2 = 32,
+	PT_ENTRY_WORD_SIZE = sizeof(u32),
+	PT_MAX_TOP_LEVEL = 1,
+	PT_GRANUAL_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 10,
+};
+
+#define PT_FIXED_TOP_LEVEL PT_MAX_TOP_LEVEL
+
+enum {
+	ARMV7S_PT_FMT_TYPE = GENMASK(1, 0),
+};
+
+/* Top most level (ARM Level 1, pts level 1) */
+enum {
+	/* Translation Table */
+	ARMV7S_PT_FMT1_TTB = GENMASK(31, 10),
+
+	ARMV7S_PT_FMT1_B = BIT(2),
+	ARMV7S_PT_FMT1_C = BIT(3),
+	ARMV7S_PT_FMT1_XN = BIT(4),
+	ARMV7S_PT_FMT1_AP0 = BIT(10),
+	ARMV7S_PT_FMT1_AP1 = BIT(11),
+	ARMV7S_PT_FMT1_TEX = GENMASK(14, 12),
+	ARMV7S_PT_FMT1_AP2 = BIT(15),
+	ARMV7S_PT_FMT1_S = BIT(16),
+	ARMV7S_PT_FMT1_NG = BIT(17),
+
+	/* Section */
+	ARMV7S_PT_FMT1S_OA = GENMASK(31, 20),
+
+	/* Supersection */
+	ARMV7S_PT_FMT1SS_OA_C = GENMASK(8, 5),
+	ARMV7S_PT_FMT1_SUPER_SECTION = BIT(18),
+	ARMV7S_PT_FMT1SS_OA_B = GENMASK(23, 20),
+	ARMV7S_PT_FMT1SS_OA_A = GENMASK(31, 24),
+
+};
+
+enum {
+	ARMV7S_PT_FMT1_TYPE_TABLE = 1,
+	/* PXN is not supported */
+	ARMV7S_PT_FMT1_TYPE_SECTION = 2,
+};
+
+/* Lowest level (ARM Level 2, pts level 0) */
+enum {
+	ARMV7S_PT_FMT2_SMALL_PAGE = BIT(1),
+	ARMV7S_PT_FMT2_B = BIT(2),
+	ARMV7S_PT_FMT2_C = BIT(3),
+	ARMV7S_PT_FMT2_AP0 = BIT(4),
+	ARMV7S_PT_FMT2_AP1 = BIT(5),
+	ARMV7S_PT_FMT2_AP2 = BIT(9),
+	ARMV7S_PT_FMT2_S = BIT(10),
+	ARMV7S_PT_FMT2_NG = BIT(11),
+
+	/* Small Page */
+	ARMV7S_PT_FMT2S_XN = BIT(0),
+	ARMV7S_PT_FMT2S_TEX = GENMASK(8, 6),
+	ARMV7S_PT_FMT2S_OA = GENMASK(31, 12),
+
+	/* Large Page */
+	ARMV7S_PT_FMT2L_XN = BIT(15),
+	ARMV7S_PT_FMT2L_TEX = GENMASK(14, 12),
+	ARMV7S_PT_FMT2L_OA = GENMASK(31, 16),
+};
+
+enum {
+	ARMV7S_PT_FMT2_TYPE_LARGE_PAGE = 1,
+	ARMV7S_PT_FMT2_TYPE_SMALL_PAGE = 2,
+};
+
+#if 0
+/* Attr bits, relative to the field of FMTx_ATTRS */
+enum {
+	ARM_V7S_ATTR_NG = BIT(7),
+	ARM_V7S_ATTR_S = BIT(6),
+	ARM_V7S_ATTR_B = BIT(2),
+
+	ARM_V7S_ATTR_AP0 = BIT(0),
+	ARM_V7S_ATTR_AP1 = BIT(1),
+	ARM_V7S_ATTR_AP2 = BIT(5),
+
+	/* Simplified access permissions */
+	ARM_V7S_PTE_AF = ARM_V7S_ATTR_AP0,
+	ARM_V7S_PTE_AP_UNPRIV = ARM_V7S_ATTR_AP1,
+	ARM_V7S_PTE_AP_RDONLY = ARM_V7S_ATTR_AP2,
+};
+#endif
+
+#define common_to_armv7s_pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_armv7s, common)
+#define to_armv7s_pt(pts) common_to_armv7s_pt((pts)->range->common)
+
+static inline pt_oaddr_t armv7s_pt_table_pa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(ARMV7S_PT_FMT1_TTB, pts->entry),
+			PT_TABLEMEM_LG2SZ);
+}
+#define pt_table_pa armv7s_pt_table_pa
+
+/* Returns the oa for the start of the contiguous entry */
+static inline pt_oaddr_t armv7s_pt_entry_oa(const struct pt_state *pts)
+{
+	if (pts->level == 0) {
+		if (pts->entry & ARMV7S_PT_FMT2_SMALL_PAGE)
+			return oalog2_mul(FIELD_GET(ARMV7S_PT_FMT2S_OA,
+						  pts->entry),
+					PT_GRANUAL_LG2SZ);
+		return oalog2_mul(FIELD_GET(ARMV7S_PT_FMT2L_OA, pts->entry), 16);
+	}
+	if (pts->entry & ARMV7S_PT_FMT1_SUPER_SECTION)
+		return oalog2_mul(FIELD_GET(ARMV7S_PT_FMT1SS_OA_A, pts->entry),
+				24) |
+		       oalog2_mul(FIELD_GET(ARMV7S_PT_FMT1SS_OA_B, pts->entry),
+				32) |
+		       oalog2_mul(FIELD_GET(ARMV7S_PT_FMT1SS_OA_C, pts->entry),
+				36);
+	return oalog2_mul(FIELD_GET(ARMV7S_PT_FMT1S_OA, pts->entry), 20);
+}
+#define pt_entry_oa armv7s_pt_entry_oa
+
+static inline bool armv7s_pt_can_have_leaf(const struct pt_state *pts)
+{
+	return true;
+}
+#define pt_can_have_leaf armv7s_pt_can_have_leaf
+
+static inline unsigned int
+armv7s_pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	return PT_GRANUAL_LG2SZ +
+	       (PT_TABLEMEM_LG2SZ - ilog2(sizeof(u32))) * pts->level;
+}
+#define pt_table_item_lg2sz armv7s_pt_table_item_lg2sz
+
+static inline unsigned short
+armv7s_pt_contig_count_lg2(const struct pt_state *pts)
+{
+	return ilog2(16);
+}
+#define pt_contig_count_lg2 armv7s_pt_contig_count_lg2
+
+static inline unsigned int
+armv7s_pt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	if ((pts->level == 0 && !(pts->entry & ARMV7S_PT_FMT2_SMALL_PAGE)) ||
+	    (pts->level != 0 && pts->entry & ARMV7S_PT_FMT1_SUPER_SECTION))
+		return armv7s_pt_contig_count_lg2(pts);
+	return ilog2(1);
+}
+#define pt_entry_num_contig_lg2 armv7s_pt_entry_num_contig_lg2
+
+static inline pt_vaddr_t armv7s_pt_full_va_prefix(const struct pt_common *common)
+{
+	if (pt_feature(common, PT_FEAT_ARMV7S_TTBR1))
+		return PT_VADDR_MAX;
+	return 0;
+}
+#define pt_full_va_prefix armv7s_pt_full_va_prefix
+
+/* Number of indexes in the current table level */
+static inline unsigned int armv7s_pt_num_items_lg2(const struct pt_state *pts)
+{
+	/* if (pts->level == 1)
+		return 12;
+	*/
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u32));
+}
+#define pt_num_items_lg2 armv7s_pt_num_items_lg2
+
+static inline enum pt_entry_type armv7s_pt_load_entry_raw(struct pt_state *pts)
+{
+	const u32 *tablep = pt_cur_table(pts, u32);
+	unsigned int type;
+	u32 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	type = FIELD_GET(ARMV7S_PT_FMT_TYPE, entry);
+	if (type == 0)
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 1 && type == ARMV7S_PT_FMT1_TYPE_TABLE)
+		return PT_ENTRY_TABLE;
+	return PT_ENTRY_OA;
+}
+#define pt_load_entry_raw armv7s_pt_load_entry_raw
+
+static inline void
+armv7s_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			     unsigned int oasz_lg2,
+			     const struct pt_write_attrs *attrs)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	u32 *tablep = pt_cur_table(pts, u32);
+	u32 entry = 0;
+
+	PT_WARN_ON(oalog2_mod(oa, oasz_lg2));
+	tablep += pts->index;
+
+	if (oasz_lg2 == isz_lg2) {
+		if (pts->level == 0)
+			entry = FIELD_PREP(ARMV7S_PT_FMT_TYPE,
+					   ARMV7S_PT_FMT2_TYPE_SMALL_PAGE) |
+				FIELD_PREP(ARMV7S_PT_FMT2S_OA,
+					   oalog2_div(oa, PT_GRANUAL_LG2SZ)) |
+				attrs->pte2;
+		else
+			entry = FIELD_PREP(ARMV7S_PT_FMT_TYPE,
+					   ARMV7S_PT_FMT1_TYPE_SECTION) |
+				FIELD_PREP(ARMV7S_PT_FMT1S_OA,
+					   oalog2_div(oa, 20)) |
+				attrs->pte1;
+		WRITE_ONCE(*tablep, entry);
+	} else {
+		u32 *end;
+
+		if (pts->level == 0)
+			entry = FIELD_PREP(ARMV7S_PT_FMT_TYPE,
+					   ARMV7S_PT_FMT2_TYPE_LARGE_PAGE) |
+				FIELD_PREP(ARMV7S_PT_FMT2L_OA,
+					   oalog2_div(oa, 16)) |
+				attrs->pte2l;
+		else
+			entry = FIELD_PREP(ARMV7S_PT_FMT_TYPE,
+					   ARMV7S_PT_FMT1_TYPE_SECTION) |
+				ARMV7S_PT_FMT1_SUPER_SECTION |
+				FIELD_PREP(ARMV7S_PT_FMT1SS_OA_A,
+					   oalog2_div(oa, 24)) |
+				FIELD_PREP(ARMV7S_PT_FMT1SS_OA_B,
+					   oalog2_div(oa, 32)) |
+				FIELD_PREP(ARMV7S_PT_FMT1SS_OA_C,
+					   oalog2_div(oa, 36)) |
+				attrs->pte1;
+
+		PT_WARN_ON(oasz_lg2 !=
+			   isz_lg2 + armv7s_pt_contig_count_lg2(pts));
+		PT_WARN_ON(
+			log2_mod(pts->index, armv7s_pt_contig_count_lg2(pts)));
+
+		end = tablep + log2_to_int(armv7s_pt_contig_count_lg2(pts));
+		for (; tablep != end; tablep++)
+			WRITE_ONCE(*tablep, entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry armv7s_pt_install_leaf_entry
+
+static inline bool armv7s_pt_install_table(struct pt_state *pts,
+					   pt_oaddr_t table_pa,
+					   const struct pt_write_attrs *attrs)
+{
+	u32 *tablep = pt_cur_table(pts, u32);
+	u32 entry;
+
+	entry = FIELD_PREP(ARMV7S_PT_FMT_TYPE, ARMV7S_PT_FMT1_TYPE_TABLE) |
+		FIELD_PREP(ARMV7S_PT_FMT1_TTB,
+			   oalog2_div(table_pa, PT_TABLEMEM_LG2SZ));
+
+	return pt_table_install32(&tablep[pts->index], entry, pts->entry);
+}
+#define pt_install_table armv7s_pt_install_table
+
+/*
+ * Trivial translation of the different bit assignments. pt_attr_from_entry() is
+ * not a performance path to justify something more optimized.
+ */
+#define _COPY_PTE_MASK(mask, l1, l2, l2l)                         \
+	{                                                         \
+		attrs->pte1 |= FIELD_PREP(l1, FIELD_GET(mask, entry));   \
+		attrs->pte2 |= FIELD_PREP(l2, FIELD_GET(mask, entry));   \
+		attrs->pte2l |= FIELD_PREP(l2l, FIELD_GET(mask, entry)); \
+	}
+#define COPY_PTE_MASK(name, entry, l1, l2, l2l)                             \
+	_COPY_PTE_MASK(ARMV7S_PT_##entry##_##name, ARMV7S_PT_##l1##_##name, \
+		       ARMV7S_PT_##l2##_##name, ARMV7S_PT_##l2l##_##name)
+
+static inline void armv7s_pt_attr_from_pte1(u32 entry,
+					    struct pt_write_attrs *attrs)
+{
+	COPY_PTE_MASK(NG, FMT1, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(S, FMT1, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(TEX, FMT1, FMT1, FMT2S, FMT2L);
+	COPY_PTE_MASK(AP0, FMT1, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(AP1, FMT1, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(AP2, FMT1, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(XN, FMT1, FMT1, FMT2S, FMT2L);
+	COPY_PTE_MASK(B, FMT1, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(C, FMT1, FMT1, FMT2, FMT2);
+}
+
+static inline void armv7s_pt_attr_from_pte2(u32 entry,
+					     struct pt_write_attrs *attrs)
+{
+	COPY_PTE_MASK(NG, FMT2, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(S, FMT2, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(AP0, FMT2, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(AP1, FMT2, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(AP2, FMT2, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(B, FMT2, FMT1, FMT2, FMT2);
+	COPY_PTE_MASK(C, FMT2, FMT1, FMT2, FMT2);
+}
+
+static inline void armv7s_pt_attr_from_pte2s(u32 entry,
+					     struct pt_write_attrs *attrs)
+{
+	COPY_PTE_MASK(TEX, FMT2S, FMT1, FMT2S, FMT2L);
+	COPY_PTE_MASK(XN, FMT2S, FMT1, FMT2S, FMT2L);
+}
+
+static inline void armv7s_pt_attr_from_pte2l(u32 entry,
+					     struct pt_write_attrs *attrs)
+{
+	COPY_PTE_MASK(TEX, FMT2L, FMT1, FMT2S, FMT2L);
+	COPY_PTE_MASK(XN, FMT2L, FMT1, FMT2S, FMT2L);
+}
+#undef _COPY_PTE_MASK
+#undef COPY_PTE_MASK
+
+static inline void armv7s_pt_attr_from_entry(const struct pt_state *pts,
+					     struct pt_write_attrs *attrs)
+{
+	attrs->pte1 = 0;
+	attrs->pte2 = 0;
+	attrs->pte2l = 0;
+	if (pts->level == 0) {
+		armv7s_pt_attr_from_pte2(pts->entry, attrs);
+		if (pts->entry & ARMV7S_PT_FMT2_SMALL_PAGE)
+			armv7s_pt_attr_from_pte2s(pts->entry, attrs);
+		else
+			armv7s_pt_attr_from_pte2l(pts->entry, attrs);
+	} else {
+		armv7s_pt_attr_from_pte1(pts->entry, attrs);
+	}
+}
+#define pt_attr_from_entry armv7s_pt_attr_from_entry
+
+/* The starting index must be aligned to the contig */
+static inline void armv7s_pt_clear_entry(struct pt_state *pts,
+					 unsigned int num_contig_lg2)
+{
+	u32 *tablep = pt_cur_table(pts, u32);
+	u32 *end;
+
+	PT_WARN_ON(log2_mod(pts->index, num_contig_lg2));
+
+	tablep += pts->index;
+	end = tablep + log2_to_int(num_contig_lg2);
+	for (; tablep != end; tablep++)
+		WRITE_ONCE(*tablep, 0);
+}
+#define pt_clear_entry armv7s_pt_clear_entry
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_armv7s
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->armpt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, armpt.common)
+			->iommu;
+}
+
+/*
+ * There are three enccodings of the PTE bits. We compute each of the three and
+ * store them in the pt_write_attrs. install will use the right one.
+ */
+#define _SET_PTE_MASK(l1, l2, l2l, val)        \
+	({                                     \
+		pte1 |= FIELD_PREP(l1, val);   \
+		pte2 |= FIELD_PREP(l2, val);   \
+		pte2l |= FIELD_PREP(l2l, val); \
+	})
+#define SET_PTE_MASK(name, l1, l2, l2l, val)                            \
+	_SET_PTE_MASK(ARMV7S_PT_##l1##_##name, ARMV7S_PT_##l2##_##name, \
+		      ARMV7S_PT_##l2l##_##name, val)
+
+static inline int armv7s_pt_iommu_set_prot(struct pt_common *common,
+					   struct pt_write_attrs *attrs,
+					   unsigned int iommu_prot)
+{
+	bool ap = true; // FIXME IO_PGTABLE_QUIRK_NO_PERMS
+	u32 pte1 = 0;
+	u32 pte2 = 0;
+	u32 pte2l = 0;
+
+	SET_PTE_MASK(NG, FMT1, FMT2, FMT2, 1);
+	SET_PTE_MASK(S, FMT1, FMT2, FMT2, 1);
+
+	if (!(iommu_prot & IOMMU_MMIO))
+		SET_PTE_MASK(TEX, FMT1, FMT2S, FMT2L, 1);
+
+	/*
+	 * Simplified access permissions: AF = AP0, UNPRIV = AP1, RDONLY = AP2
+	 */
+	if (ap) {
+		/* AF */
+		SET_PTE_MASK(AP0, FMT1, FMT2, FMT2, 1);
+		if (!(iommu_prot & IOMMU_PRIV))
+			SET_PTE_MASK(AP1, FMT1, FMT2, FMT2, 1);
+		if (!(iommu_prot & IOMMU_WRITE))
+			SET_PTE_MASK(AP2, FMT1, FMT2, FMT2, 1);
+	}
+
+	if ((iommu_prot & IOMMU_NOEXEC) && ap)
+		SET_PTE_MASK(XN, FMT1, FMT2S, FMT2L, 1);
+
+	if (iommu_prot & IOMMU_MMIO) {
+		SET_PTE_MASK(B, FMT1, FMT2, FMT2, 1);
+	} else if (iommu_prot & IOMMU_CACHE) {
+		SET_PTE_MASK(B, FMT1, FMT2, FMT2, 1);
+		SET_PTE_MASK(C, FMT1, FMT2, FMT2, 1);
+	}
+
+	/* FIXME:
+	if (lvl == 1 && (cfg->quirks & IO_PGTABLE_QUIRK_ARM_NS))
+		pte |= ARM_V7S_ATTR_NS_SECTION;
+	*/
+
+	attrs->pte1 = pte1;
+	attrs->pte2 = pte2;
+	attrs->pte2l = pte2l;
+	return 0;
+}
+#define pt_iommu_set_prot armv7s_pt_iommu_set_prot
+#undef _SET_PTE_MASK
+#undef SET_PTE_MASK
+
+static inline int armv7s_pt_iommu_fmt_init(struct pt_iommu_armv7s *iommu_table,
+					   struct pt_iommu_armv7s_cfg *cfg)
+{
+	/* FIXME */
+	cfg->features &= ~(BIT(PT_FEAT_ARMV7S_TTBR1));
+	iommu_table->armpt.common.max_oasz_lg2 = 32;
+	return 0;
+}
+#define pt_iommu_fmt_init armv7s_pt_iommu_fmt_init
+
+#if defined(GENERIC_PT_KUNIT)
+static inline void armv7s_pt_kunit_setup_cfg(struct pt_iommu_armv7s_cfg *cfg)
+{
+	cfg->features &= ~(BIT(PT_FEAT_ARMV7S_TTBR1));
+}
+#define pt_kunit_setup_cfg armv7s_pt_kunit_setup_cfg
+#endif
+
+#if defined(GENERIC_PT_KUNIT) && IS_ENABLED(CONFIG_IOMMU_IO_PGTABLE_ARMV7S)
+#include <linux/io-pgtable.h>
+
+static struct io_pgtable_ops *
+armv7s_pt_iommu_alloc_io_pgtable(struct pt_iommu_armv7s_cfg *cfg,
+			       struct device *iommu_dev,
+			       struct io_pgtable_cfg **unused_pgtbl_cfg)
+{
+	struct io_pgtable_cfg pgtbl_cfg = {};
+
+	pgtbl_cfg.ias = 32;
+	pgtbl_cfg.oas = 32;
+	pgtbl_cfg.pgsize_bitmap |= SZ_4K;
+	pgtbl_cfg.coherent_walk = true;
+	return alloc_io_pgtable_ops(ARM_V7S, &pgtbl_cfg, NULL);
+}
+#define pt_iommu_alloc_io_pgtable armv7s_pt_iommu_alloc_io_pgtable
+
+static void armv7s_pt_iommu_setup_ref_table(struct pt_iommu_armv7s *iommu_table,
+					  struct io_pgtable_ops *pgtbl_ops)
+{
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(pgtbl_ops)->cfg;
+	struct pt_common *common = &iommu_table->armpt.common;
+
+	pt_top_set(common,
+		   __va(log2_set_mod_t(u32, pgtbl_cfg->arm_v7s_cfg.ttbr, 0, 7)),
+		   PT_FIXED_TOP_LEVEL);
+}
+#define pt_iommu_setup_ref_table armv7s_pt_iommu_setup_ref_table
+
+static u64 armv7s_pt_kunit_cmp_mask_entry(struct pt_state *pts)
+{
+	if (pts->type == PT_ENTRY_TABLE)
+		return pts->entry & (~(u32)(ARMV7S_PT_FMT1_TTB));
+	return pts->entry;
+}
+#define pt_kunit_cmp_mask_entry armv7s_pt_kunit_cmp_mask_entry
+#endif
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/defs_armv7s.h b/drivers/iommu/generic_pt/fmt/defs_armv7s.h
new file mode 100644
index 00000000000000..57ba77d5f19c46
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_armv7s.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_ARMV7S_H
+#define __GENERIC_PT_FMT_DEFS_ARMV7S_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u32 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct armv7s_pt_write_attrs {
+	u32 pte1;
+	u32 pte2;
+	u32 pte2l;
+	gfp_t gfp;
+};
+#define pt_write_attrs armv7s_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_armv7s.c b/drivers/iommu/generic_pt/fmt/iommu_armv7s.c
new file mode 100644
index 00000000000000..591a97332bbefe
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_armv7s.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+
+#define PT_FMT armv7s
+#define PT_SUPPORTED_FEATURES                                        \
+	(BIT(PT_FEAT_DMA_INCOHERENT) | BIT(PT_FEAT_OA_SIZE_CHANGE) | \
+	 BIT(PT_FEAT_OA_TABLE_XCHG) | BIT(PT_FEAT_FULL_VA))
+
+#include "iommu_template.h"
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index edfbf5f8d047b6..558302fe1e0324 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -108,6 +108,15 @@ struct pt_armv8 {
 	struct pt_common common;
 };
 
+struct pt_armv7s {
+	struct pt_common common;
+};
+
+enum {
+	/* Use the upper address space instead of lower */
+	PT_FEAT_ARMV7S_TTBR1 = PT_FEAT_FMT_START,
+};
+
 enum {
 	/* Use the upper address space instead of lower */
 	PT_FEAT_ARMV8_TTBR1 = PT_FEAT_FMT_START,
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 0896e79863062e..351a69fe62dd1d 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -216,6 +216,19 @@ struct pt_iommu_amdv1_cfg {
 int pt_iommu_amdv1_init(struct pt_iommu_amdv1 *table,
 			struct pt_iommu_amdv1_cfg *cfg, gfp_t gfp);
 
+struct pt_iommu_armv7s {
+	struct pt_iommu iommu;
+	struct pt_armv7s armpt;
+};
+
+struct pt_iommu_armv7s_cfg {
+	struct device *iommu_device;
+	unsigned int features;
+};
+
+int pt_iommu_armv7s_init(struct pt_iommu_armv7s *table,
+			 struct pt_iommu_armv7s_cfg *cfg, gfp_t gfp);
+
 struct pt_iommu_armv8 {
 	struct pt_iommu iommu;
 	struct pt_armv8 armpt;
-- 
2.46.0


