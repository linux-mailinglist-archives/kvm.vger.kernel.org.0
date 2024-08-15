Return-Path: <kvm+bounces-24287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 600119536C6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10D3828A291
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944B21AC432;
	Thu, 15 Aug 2024 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HlHAzKMm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CA81B5801
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734719; cv=fail; b=hfNOSifnSQeRP6n4QgdEz+5+smMy4OAjzZ6j77WClHg4jWw+lMMw67s8Ain7zwFY//4ftvkGoO4Ibv8nBRhEaps1SQA1qFqbO6djOJG1mda31O4tEPb1TJnGzgjx8OvwAzBsinX2ABpy8XMnm4QMKWePO13vQ3nswxE3uOYN9qQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734719; c=relaxed/simple;
	bh=elnGt5Scnh90tq/u6Bi6HaTrajvp+q7+d0VD7OK8i3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l4zIL2klaB/+3FF8ToALMxMJAWznCrYXK5yqLJ/H8F7eyVT/UO4RszMyRcLsXr6PBWfiqWVoj/JSBseMXwqXw/Ih2F3nAuhyGzXeyh5W2Jiz41kOEOmrsWbcIb/5wfWUglMTHR42wmByi/unzZ989oTDwpHuk46C4mqRd9cElCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HlHAzKMm; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/lJTt19gWlwQyLniK90pj2stX4iYDjUy9Ra2am6llOdxY0xnSjjDOGpscS45myUC3T3vd5LIKL1WbNlvY3OiXFlV95KkI1AZZcI8+enlq580Sn5QS3mLpJm77yImPeq3uwiuJm1URJM/tU1RQdx+DqXGeqwrxNGHtoG/YnzJO4yrbzyxIu4AnS8FyHaJVheh4RhunKA4l3sWoUDALsFFQpgBAAGgqqUKsrhpvaD/XDnBEpyCA6IA0it7TlnTleoea9ENiqzqX2+mhTkgszcmndgHF04pq2X6U39lGPcim0Jo4lKd4f+EcKS8eNutrdon4kOhBjOtYf8ykZsP6OsCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihOu2iVN4hwGcHHGXbybEwpG6CY6bCTOfEKx143ZTj4=;
 b=VOHovd+bdujtNa9v5rhCUGJ89hgeLsLAZN3jyHUW27A1Utldupatur3xfSGmUiB0fVnLMDwRXp7hIVukDApXnLhgf/nyMgbHIeWDocgLfYxsrfHE42jIkYOdTma8mvS+aelv1TmeM5f7k1vO07K5ENRhjMr8yAGh1Ar4rY9hgoLbCqaqvJFFv79qgUbyg8HXCdtSRLV41fjhdngIVJhnz4CpeRDWjgQX4/vcZ0Fi4h6LRoSjQhtG80841Bpq8pO5+gt5mHw2Pfn1nFZ6GYav7BW4WWV4v+RMi6cgYavPTPR5YC8sb99DtVQ7Hca5qFuLroN2vHdQmwBpkmmjt+N7CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihOu2iVN4hwGcHHGXbybEwpG6CY6bCTOfEKx143ZTj4=;
 b=HlHAzKMmBrvPzM9aUQJqBr9OXS+kstH6QVd9dvoU8IXWU1vMmm7+Ur3/6fB3wbtVzHSU9RYb50AULa0OR/ZpJGYlZpGwlpioRjT0aqDwrrwVGgcEnekv2cLjohc8OMw57yB1Fj2U1E6bYemKnELtgWNnKmnJ2uTDF3KWJ1xxpV4w4Hwc0bsqDqPGitne/8SDKGtOFj9+tnNXu7JORQe5sWI9RCxgo26rVcDIYWm2maIfMrDuqj5r8YxH3SZe05YYrdaFl8YcgRH6+dKTqbyRt49Il8BqafckFSQSKpCV9xoH1k9zpw3wsqnpMDvLOB+IaXwIQk/KWe4gPP1Yom2fgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 15:11:42 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:42 +0000
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
Subject: [PATCH 11/16] iommupt: Add the 64 bit ARMv8 page table format
Date: Thu, 15 Aug 2024 12:11:27 -0300
Message-ID: <11-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::34) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 74004e44-e112-4ed6-fabb-08dcbd3c8e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ziSufx5ojokGC33D/nzHI6hCJjOTxu4RQLTpTihna/7dLbKElMM5Wpt73mo4?=
 =?us-ascii?Q?Oj8k2+H+AGIknfyQfCCJK7neX5cUaNkr9YlJNkMK5M8lfbNlHwoqXmaY9LKT?=
 =?us-ascii?Q?vuMqrl9SzQwwZJnWwXsgKJk38UUDn1BPSI6SYJVfSyDWo20M7q3niB1d4ama?=
 =?us-ascii?Q?fu6x+yBZWxfcIq1BzrvvBJaHjWzZPVhR+65HQfZdXUlLG7rb3MJE3OY6hGYV?=
 =?us-ascii?Q?QTjrp5wE+gdoCd37zjHv7ampzIYShI16ir6VQdqdOEKi0/cCH8R8kZFuVoDa?=
 =?us-ascii?Q?pWkcjpmagKyzgXJlG+7KRk/EeSPSLnCDUn2oqhUfGKnPehc/3fGm3v63eAOe?=
 =?us-ascii?Q?6GFNamZszGi9pRSqQtRGORxtihcbUtxCscquL3F7XdMGUQtCxFazzhQ5SH9q?=
 =?us-ascii?Q?na5x2AtK6y/JOqmUhXOmN9lyxO/2A65HVehJT8zT6jMR2vgsSURMiqGV0m2W?=
 =?us-ascii?Q?AP22tIDH9KPY7t+DSfIvqIF6GDL8udshDFr6+cxTqsl5XOeJLy6e5fflHedh?=
 =?us-ascii?Q?NMF9F5YxqpU9Y/RoorfFsjc91TRzCzBi/DGeAZAeaidyVoJTI4QSGnCGGY08?=
 =?us-ascii?Q?g+pejx3LBraK/dHXJKK5pvxrgCuI0v8rkwhKkpzXEN72gB5EGiQqNI9a5W4U?=
 =?us-ascii?Q?Byj9vDNMoSLOgPfR8feG7VzedDAITUL2HAvWhaivCktJ9eFCB7AGVdAuMdmJ?=
 =?us-ascii?Q?xxH8S3YvgfFHQ2S5OqLfmQfp+Df0mWoSKJ7kOW1Fpu43C5pjGf7OZI2/ufNM?=
 =?us-ascii?Q?tMWxIAurfcTvD5AKCFR2rZ1LKpjQ2Ks4sIdPOL65Ll5GnjeWhotQ1TZ3kxgh?=
 =?us-ascii?Q?DtDeCabCUWWxOhNThpqQYaoCcpaoN7cfdwZ0krEhgX5QyyK8bRpTTydPnFm1?=
 =?us-ascii?Q?B0hm8ywJJ3pcC7u9q/YSM8iYKPcyVsidUeGJmbxoa+ZDkURVEP1/nkTtvaGJ?=
 =?us-ascii?Q?poUurVOzLxZ7czDztHhlXeI2Hq/bARQ/C4YRqxsQ9VCimGlIbXo5+f7ADlTQ?=
 =?us-ascii?Q?fzphfd2ryXutE1wjs5sMkfQQ/0pIYb8alGbmOvJNAd8UqDgJkMfi74/ixE9x?=
 =?us-ascii?Q?7cB5nvZi/x6u9XWsly9nd8PIiSaR6mrzOL6KA2r6jgEU48Vgpnog6ock6run?=
 =?us-ascii?Q?mw0rvJaMKcMq9U1dcnx2PNSTCFGVSN3kUHQpVPAxD4G/r/nGU/6C8WcgqNih?=
 =?us-ascii?Q?lsHU+MODjqimaS2v7Gt9KLhYB2rBU+cgXYP1ovKY5zq7tUJuTka/W0iK1LAm?=
 =?us-ascii?Q?7ohbEr6JXqDhIVHi6F+vGsrtVjYrhROpV3RjW3cV2OJXX5nymihpPUGXGc82?=
 =?us-ascii?Q?zxRChij43u8wx5TSUb1+iyoO6KS7nS1IezSHyirmt/3BQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?67P6Uz96U3O+h4yLkkIm67jLvwMgQ6S0kQJ3g9lQpqiji4orSXeAr6C8Zaoo?=
 =?us-ascii?Q?ZpQsMOJl2W1/f5yVamB6dazXPAPMt0HL2kvs5v7Ozx0MoSr9BCwLpS5Wpl6g?=
 =?us-ascii?Q?Z/Dk+aEktx7S7aT7bwXj7Aq9HU58AFe+4NvqHGc6gHYDy+CPtnJY+YsqRHs1?=
 =?us-ascii?Q?PL8SySsZmHnNDRukPnyOt79FBV4hS1G0WL0EWLE2klEMdY6IoOBYF3VQWSm1?=
 =?us-ascii?Q?m1v34XGnLh8Xm/4TAbGkwkaaSmJ1h3v0hi8fKh+xcSQEwc+TFXhRYny9ClKx?=
 =?us-ascii?Q?CIVu4+ORA5JhMSCJar3b9mpg0UR/68RZ9YSnw+7U3rMoI5Yl2mWtvy+lij3R?=
 =?us-ascii?Q?lYH0U/CHo3INXoEipVLjLwN6THo2l/g+Xqr9rSl90RRhdwTV3ZYAjjmkwji4?=
 =?us-ascii?Q?vk3PWw2Bm4prIkI4wMI9nKJiDyCxiAU2ovU1P4O9G9blbTPfhLxxP8iXo/pP?=
 =?us-ascii?Q?cti3hQxEE9hAbu9cU6Xfop4szC8mddiz9+3k0+jqHvkrAIsr+xiqAs97XwWv?=
 =?us-ascii?Q?ABz/PqzL3FNBS5ec+L46KGiY7ADSwKmE3t0AWiVuc84Ppf6CprPlL5t8k6cJ?=
 =?us-ascii?Q?90sDPTX/TzEDuexCD6ECjWkyTT7YV/CwOFPM/AuiYqKMZB/e0ATZcZsuVkiD?=
 =?us-ascii?Q?MSQUm8O1K+bD+qP4+SGV+lU2A6aGN2kYRQNAxBiTljSGvC6k+xnswbDnAY2g?=
 =?us-ascii?Q?GGyiPAMq8CvfrjUs4J+XtKWr3KXYBi5whQ7Z003LNefwXK/hlsSXNnkAp2/K?=
 =?us-ascii?Q?8UHwsNnmoJg7vMfB8pE1LIMqM4tfw4TzLER7iGkFTqN7NAGggby3UTvxl+TG?=
 =?us-ascii?Q?EOBhvs4xp2mhZnGUlJph87ALdxVFIXNPxZa8W30nkKa5oGJ8jr8/1Qoh8Zgq?=
 =?us-ascii?Q?CHx2Q/O1TBM7jWSIQs63bEHlvSsaX5+xFJKj2CAHmrhSsBukr4bUovJ9bx6P?=
 =?us-ascii?Q?QvsTEdCknIB15HUCx7pvdl3mZVej6PAsowC2XLZDPON2ipqp5TlvrV+GsNDS?=
 =?us-ascii?Q?XQGnjXcLh3BxuXv7cL9cEpkCEBEIXhQFl2c3PXxHyi74oxJC/1QEZ1auhlRs?=
 =?us-ascii?Q?VI0Q+wSoTe9/Jr4LFLAGTw/pGba3lhXIkhtOyM9X1EWIgD+5s6xxCVlblZ8s?=
 =?us-ascii?Q?ooexDrpUMJiptJssmcUOl+F40ehl/npPvAfaq4Mwq9yGoMvLutpOEHpvcVsv?=
 =?us-ascii?Q?Q8dzv84MVRDir6cmroWnDSNZTE85Tv5meu0H7yHvtAtaIf+CpxfXtRQCBzaL?=
 =?us-ascii?Q?LNW8abJ6M9UjA361lUlpa+Wddf7jUZAhHJT5ouI/0gKcWonWyNAhPi4OpuA+?=
 =?us-ascii?Q?JvUmUTR8GRdDSs/CLx7GJ/CkXfgBhOecVHFZoFYXd9ibrpkXHGiDrz1PHB74?=
 =?us-ascii?Q?u8AbK31HnHIXHBlcCoZPsNB0JksXWyGSR36weA0rs4oqlOlY3BuVYhzrSUoT?=
 =?us-ascii?Q?007P+IZALhozcBzFSdwpYVBVvJEGpreP1JkUExkv7P42pPWucFiAqx1Jp+gg?=
 =?us-ascii?Q?7vWmqwHM991z5ZuWDzV1wZkxux/NVl12FepsshL16UDpjc3hdHJ7qVmRGxD/?=
 =?us-ascii?Q?02y66rjNpemU7btkSTg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74004e44-e112-4ed6-fabb-08dcbd3c8e58
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:36.6136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wka/EjPR5hlw01zTVC4Vv7inIkQnRmTjmhVi0T38+qyxR731zAIcWE/haEvSCawx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631

The features, format and naming is taking from the ARMv8 VMSAv8-64
chapter. ARMv8 uses almost all the features of the common implementation:

 - Contigous pages
 - Leaf pages at many levels
 - Variable top level
 - Variable size top level, including super-sized (concatenated tables)
 - Dirty tracking
 - low or high starting VA

Compared to the io-pgtable version this also implements the contiguous
page hint, and supports dirty readback from the S2.

The common algorithms use a bit in the folio to keep track of the cache
invalidation race, while the io-pgtable version uses a SW bit in the table
PTE.

In part as an demonstration, to be evaluated with performace data, ARMv8
is multi-compiled for each of the 4k/16k/64k granule size. This gives 3x
the .text usage with an unmeasured performance improvement. It shows how
Generic PT can be used to optimize code gen.

FIXME: Not every detail around the variable VA width is fully completed
and tested yet.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/Kconfig              |  39 ++
 drivers/iommu/generic_pt/fmt/Makefile         |   4 +
 drivers/iommu/generic_pt/fmt/armv8.h          | 621 ++++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv8.h     |  28 +
 .../iommu/generic_pt/fmt/iommu_armv8_16k.c    |  13 +
 drivers/iommu/generic_pt/fmt/iommu_armv8_4k.c |  13 +
 .../iommu/generic_pt/fmt/iommu_armv8_64k.c    |  13 +
 include/linux/generic_pt/common.h             |  22 +
 include/linux/generic_pt/iommu.h              |  73 ++
 9 files changed, 826 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8_16k.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8_4k.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8_64k.c

diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 3ac9b2324ebd98..260fff5daa6e57 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -29,10 +29,49 @@ config IOMMU_PT
 	  Generic library for building IOMMU page tables
 
 if IOMMU_PT
+config IOMMU_PT_ARMV8_4K
+	tristate "IOMMU page table for 64 bit ARMv8 4k page size"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+	help
+	  Enable support for the ARMv8 VMSAv8-64 and the VMSAv8-32 long
+	  descriptor pagetable format. This format supports both stage-1 and
+	  stage-2, as well as address spaces up to 48-bits in size. 4K
+	  granule size version.
+
+	  If unsure, say N here.
+
+config IOMMU_PT_ARMV8_16K
+	tristate "IOMMU page table for 64 bit ARMv8 16k page size"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+	help
+	  Enable support for the ARMv8 VMSAv8-64 and the VMSAv8-32 long
+	  descriptor pagetable format. This format supports both stage-1 and
+	  stage-2, as well as address spaces up to 48-bits in size. 4K
+	  granule size version.
+
+	  If unsure, say N here.
+
+config IOMMU_PT_ARMV8_64K
+	tristate "IOMMU page table for 64 bit ARMv8 64k page size"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+	help
+	  Enable support for the ARMv8 VMSAv8-64 and the VMSAv8-32 long
+	  descriptor pagetable format. This format supports both stage-1 and
+	  stage-2, as well as address spaces up to 48-bits in size. 4K
+	  granule size version.
+
+	  If unsure, say N here.
+
 config IOMMUT_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	select IOMMU_IO_PGTABLE
 	depends on KUNIT
+	depends on IOMMU_PT_ARMV8_4K || !IOMMU_PT_ARMV8_4K
+	depends on IOMMU_PT_ARMV8_16K || !IOMMU_PT_ARMV8_16K
+	depends on IOMMU_PT_ARMV8_64K || !IOMMU_PT_ARMV8_64K
 	default KUNIT_ALL_TESTS
 endif
 endif
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 0c35b9ae4dfb34..9a9173ce85e075 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -1,5 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_4K) += armv8_4k
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_16K) += armv8_16k
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_64K) += armv8_64k
+
 IOMMU_PT_KUNIT_TEST :=
 define create_format
 obj-$(2) += iommu_$(1).o
diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
new file mode 100644
index 00000000000000..73bccbfa72b19e
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -0,0 +1,621 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * The page table format described by the ARMv8 VMSAv8-64 chapter in the
+ * Architecture Reference Manual. With the right cfg this will also implement
+ * the VMSAv8-32 Long Descriptor format.
+ *
+ * This was called io-pgtable-arm.c and ARM_xx_LPAE_Sx.
+ *
+ * NOTE! The level numbering is consistent with the Generic Page Table API, but
+ * is backwards from what the ARM documents use. What ARM calls level 3 this
+ * calls level 0.
+ *
+ * Present in io-pgtable-arm.c but not here:
+ *    ARM_MALI_LPAE
+ *    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA
+ */
+#ifndef __GENERIC_PT_FMT_ARMV8_H
+#define __GENERIC_PT_FMT_ARMV8_H
+
+#include "defs_armv8.h"
+#include "../pt_defs.h"
+
+#include <asm/page.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/container_of.h>
+#include <linux/errno.h>
+#include <linux/limits.h>
+#include <linux/sizes.h>
+
+#if ARMV8_GRANUAL_SIZE == 4096
+enum {
+	PT_MAX_TOP_LEVEL = 3,
+	PT_GRANUAL_LG2SZ = 12,
+};
+#elif ARMV8_GRANUAL_SIZE == 16384
+enum {
+	PT_MAX_TOP_LEVEL = 3,
+	PT_GRANUAL_LG2SZ = 14,
+};
+#elif ARMV8_GRANUAL_SIZE == 65536
+enum {
+	PT_MAX_TOP_LEVEL = 2,
+	PT_GRANUAL_LG2SZ = 16,
+};
+#else
+#error "Invalid ARMV8_GRANUAL_SIZE"
+#endif
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 48,
+	/*
+	 * Currently only support up to 48 bits of usable address, the 64k 52
+	 * bit mode is not supported.
+	 */
+	PT_MAX_VA_ADDRESS_LG2 = 48,
+	PT_TABLEMEM_LG2SZ = PT_GRANUAL_LG2SZ,
+	PT_ENTRY_WORD_SIZE = sizeof(u64),
+};
+
+/* Common PTE bits */
+enum {
+	ARMV8PT_FMT_VALID = BIT(0),
+	ARMV8PT_FMT_PAGE = BIT(1),
+	ARMV8PT_FMT_TABLE = BIT(1),
+	ARMV8PT_FMT_NS = BIT(5),
+	ARMV8PT_FMT_SH = GENMASK(9, 8),
+	ARMV8PT_FMT_AF = BIT(10),
+
+	ARMV8PT_FMT_OA52 = GENMASK_ULL(15, 12),
+	ARMV8PT_FMT_OA48 = GENMASK_ULL(47, PT_GRANUAL_LG2SZ),
+
+	ARMV8PT_FMT_DBM = BIT_ULL(51),
+	ARMV8PT_FMT_CONTIG = BIT_ULL(52),
+	ARMV8PT_FMT_UXN = BIT_ULL(53),
+	ARMV8PT_FMT_PXN = BIT_ULL(54),
+	ARMV8PT_FMT_NSTABLE = BIT_ULL(63),
+};
+
+/* S1 PTE bits */
+enum {
+	ARMV8PT_FMT_ATTRINDX = GENMASK(4, 2),
+	ARMV8PT_FMT_AP = GENMASK(7, 6),
+	ARMV8PT_FMT_nG = BIT(11),
+};
+
+enum {
+	ARMV8PT_MAIR_ATTR_IDX_CACHE = 1,
+	ARMV8PT_MAIR_ATTR_IDX_DEV = 2,
+
+	ARMV8PT_SH_IS = 3,
+	ARMV8PT_SH_OS = 2,
+
+	ARMV8PT_AP_UNPRIV = 1,
+	ARMV8PT_AP_RDONLY = 2,
+};
+
+/* S2 PTE bits */
+enum {
+	ARMV8PT_FMT_S2MEMATTR = GENMASK(5, 2),
+	ARMV8PT_FMT_S2AP = GENMASK(7, 6),
+};
+
+enum {
+	/*
+	 * For !S2FWB these code to:
+	 *  1111 = Normal outer write back cachable / Inner Write Back Cachable
+	 *         Permit S1 to override
+	 *  0101 = Normal Non-cachable / Inner Non-cachable
+	 *  0001 = Device / Device-nGnRE
+	 * For S2FWB these code to:
+	 *  0110 Force Normal Write Back
+	 *  0101 Normal* is forced Normal-NC, Device unchanged
+	 *  0001 Force Device-nGnRE
+	 */
+	ARMV8PT_MEMATTR_FWB_WB = 6,
+	ARMV8PT_MEMATTR_OIWB = 0xf,
+	ARMV8PT_MEMATTR_NC = 5,
+	ARMV8PT_MEMATTR_DEV = 1,
+
+	ARMV8PT_S2AP_READ = 1,
+	ARMV8PT_S2AP_WRITE = 2,
+};
+
+#define common_to_armv8pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_armv8, common)
+#define to_armv8pt(pts) common_to_armv8pt((pts)->range->common)
+
+static inline pt_oaddr_t armv8pt_oa(const struct pt_state *pts)
+{
+	u64 entry = pts->entry;
+	pt_oaddr_t oa;
+
+	oa = log2_mul(FIELD_GET(ARMV8PT_FMT_OA48, entry), PT_GRANUAL_LG2SZ);
+
+	/* LPA support on 64K page size */
+	if (PT_GRANUAL_SIZE == SZ_64K)
+		oa |= ((pt_oaddr_t)FIELD_GET(ARMV8PT_FMT_OA52, entry)) << 52;
+	return oa;
+}
+
+static inline pt_oaddr_t armv8pt_table_pa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_table_pa armv8pt_table_pa
+
+/*
+ * Return a block or page entry pointing at a physical address Returns the
+ * address adjusted for the item in a contiguous case.
+ */
+static inline pt_oaddr_t armv8pt_item_oa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_item_oa armv8pt_item_oa
+
+static inline bool armv8pt_can_have_leaf(const struct pt_state *pts)
+{
+	/*
+	 * See D5-18 Translation granule sizes, with block and page sizes, and
+	 * output address ranges
+	 */
+	if ((PT_GRANUAL_SIZE == SZ_4K && pts->level > 2) ||
+	    (PT_GRANUAL_SIZE == SZ_16K && pts->level > 1) ||
+	    (PT_GRANUAL_SIZE == SZ_64K && pts_feature(pts, PT_FEAT_ARMV8_LPA) && pts->level > 2) ||
+	    (PT_GRANUAL_SIZE == SZ_64K && !pts_feature(pts, PT_FEAT_ARMV8_LPA) && pts->level > 1))
+		return false;
+	return true;
+}
+#define pt_can_have_leaf armv8pt_can_have_leaf
+
+static inline unsigned int armv8pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	return PT_GRANUAL_LG2SZ +
+	       (PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64))) * pts->level;
+}
+#define pt_table_item_lg2sz armv8pt_table_item_lg2sz
+
+/* Number contigous entries that ARMV8PT_FMT_CONTIG will join at this level */
+static inline unsigned short
+armv8pt_contig_count_lg2(const struct pt_state *pts)
+{
+	if (PT_GRANUAL_SIZE == SZ_4K)
+		return ilog2(16); /* 64KB, 2MB */
+	else if (PT_GRANUAL_SIZE == SZ_16K && pts->level == 1)
+		return ilog2(32); /* 1GB */
+	else if (PT_GRANUAL_SIZE == SZ_16K && pts->level == 0)
+		return ilog2(128); /* 2M */
+	else if (PT_GRANUAL_SIZE == SZ_64K)
+		return ilog2(32); /* 2M, 16G */
+	return ilog2(1);
+}
+#define pt_contig_count_lg2 armv8pt_contig_count_lg2
+
+static inline unsigned int
+armv8pt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	if (pts->entry & ARMV8PT_FMT_CONTIG)
+		return armv8pt_contig_count_lg2(pts);
+	return ilog2(1);
+}
+#define pt_entry_num_contig_lg2 armv8pt_entry_num_contig_lg2
+
+static inline pt_vaddr_t armv8pt_full_va_prefix(const struct pt_common *common)
+{
+	if (pt_feature(common, PT_FEAT_ARMV8_TTBR1))
+		return PT_VADDR_MAX;
+	return 0;
+}
+#define pt_full_va_prefix armv8pt_full_va_prefix
+
+static inline unsigned int armv8pt_num_items_lg2(const struct pt_state *pts)
+{
+	/* FIXME S2 concatenated tables */
+	return PT_GRANUAL_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 armv8pt_num_items_lg2
+
+static inline enum pt_entry_type armv8pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!(entry & ARMV8PT_FMT_VALID))
+		return PT_ENTRY_EMPTY;
+	if (pts->level != 0 && (entry & ARMV8PT_FMT_TABLE))
+		return PT_ENTRY_TABLE;
+
+	/*
+	 * Suppress returning VALID for levels that cannot have a page to remove
+	 * code.
+	 */
+	if (!armv8pt_can_have_leaf(pts))
+		return PT_ENTRY_EMPTY;
+
+	/* Must be a block or page, don't check the page bit on level 0 */
+	return PT_ENTRY_OA;
+}
+#define pt_load_entry_raw armv8pt_load_entry_raw
+
+static inline void
+armv8pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			   unsigned int oasz_lg2,
+			   const struct pt_write_attrs *attrs)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	PT_WARN_ON(log2_mod(oa, oasz_lg2));
+
+	entry = ARMV8PT_FMT_VALID |
+		FIELD_PREP(ARMV8PT_FMT_OA48, log2_div(oa, PT_GRANUAL_LG2SZ)) |
+		FIELD_PREP(ARMV8PT_FMT_OA52, oa >> 48) | attrs->descriptor_bits;
+
+	/*
+	 * On the last level the leaf is called a page and has the page/table bit set,
+	 * on other levels it is called a block and has it clear.
+	 */
+	if (pts->level == 0)
+		entry |= ARMV8PT_FMT_PAGE;
+
+	if (oasz_lg2 != isz_lg2) {
+		u64 *end;
+
+		PT_WARN_ON(oasz_lg2 != isz_lg2 + armv8pt_contig_count_lg2(pts));
+		PT_WARN_ON(log2_mod(pts->index, armv8pt_contig_count_lg2(pts)));
+
+		entry |= ARMV8PT_FMT_CONTIG;
+		tablep += pts->index;
+		end = tablep + log2_to_int(armv8pt_contig_count_lg2(pts));
+		for (; tablep != end; tablep++) {
+			WRITE_ONCE(*tablep, entry);
+			entry += FIELD_PREP(
+				ARMV8PT_FMT_OA48,
+				log2_to_int(isz_lg2 - PT_GRANUAL_LG2SZ));
+		}
+	} else {
+		WRITE_ONCE(tablep[pts->index], entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry armv8pt_install_leaf_entry
+
+static inline bool armv8pt_install_table(struct pt_state *pts,
+					 pt_oaddr_t table_pa,
+					 const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = ARMV8PT_FMT_VALID | ARMV8PT_FMT_TABLE |
+		FIELD_PREP(ARMV8PT_FMT_OA48,
+			   log2_div(table_pa, PT_GRANUAL_LG2SZ)) |
+		FIELD_PREP(ARMV8PT_FMT_OA52, table_pa >> 48);
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_NS))
+		entry |= ARMV8PT_FMT_NSTABLE;
+
+	return pt_table_install64(&tablep[pts->index], entry, pts->entry);
+}
+#define pt_install_table armv8pt_install_table
+
+static inline void armv8pt_attr_from_entry(const struct pt_state *pts,
+					   struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits =
+		pts->entry &
+		(ARMV8PT_FMT_SH | ARMV8PT_FMT_AF | ARMV8PT_FMT_UXN |
+		 ARMV8PT_FMT_PXN | ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP |
+		 ARMV8PT_FMT_nG | ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP);
+}
+#define pt_attr_from_entry armv8pt_attr_from_entry
+
+static inline void armv8pt_clear_entry(struct pt_state *pts,
+				       unsigned int num_contig_lg2)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 *end;
+
+	PT_WARN_ON(log2_mod(pts->index, num_contig_lg2));
+
+	tablep += pts->index;
+	end = tablep + log2_to_int(num_contig_lg2);
+	for (; tablep != end; tablep++)
+		WRITE_ONCE(*tablep, 0);
+}
+#define pt_clear_entry armv8pt_clear_entry
+
+/*
+ * Call fn over all the items in an entry. If the entry is contiguous this
+ * iterates over the entire contiguous entry, including items preceding
+ * pts->va. always_inline avoids an indirect function call.
+ */
+static __always_inline bool armv8pt_reduce_contig(const struct pt_state *pts,
+						  bool (*fn)(u64 *tablep,
+							     u64 entry))
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+
+	if (pts->entry & ARMV8PT_FMT_CONTIG) {
+		unsigned int num_contig_lg2 = armv8pt_contig_count_lg2(pts);
+		u64 *end;
+
+		tablep += log2_set_mod(pts->index, 0, num_contig_lg2);
+		end = tablep + log2_to_int(num_contig_lg2);
+		for (; tablep != end; tablep++)
+			if (fn(tablep, READ_ONCE(*tablep)))
+				return true;
+		return false;
+	}
+	return fn(tablep + pts->index, pts->entry);
+}
+
+static inline bool armv8pt_check_is_dirty_s1(u64 *tablep, u64 entry)
+{
+	return (entry & (ARMV8PT_FMT_DBM |
+			 FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY))) ==
+	       ARMV8PT_FMT_DBM;
+}
+
+static bool armv6pt_clear_dirty_s1(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep,
+		   entry | FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY));
+	return false;
+}
+
+static inline bool armv8pt_check_is_dirty_s2(u64 *tablep, u64 entry)
+{
+	const u64 DIRTY = ARMV8PT_FMT_DBM |
+			  FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
+
+	return (entry & DIRTY) == DIRTY;
+}
+
+static bool armv6pt_clear_dirty_s2(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep, entry & ~(u64)FIELD_PREP(ARMV8PT_FMT_S2AP,
+						     ARMV8PT_S2AP_WRITE));
+	return false;
+}
+
+static inline bool armv8pt_entry_write_is_dirty(const struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s1);
+	else
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s2);
+}
+#define pt_entry_write_is_dirty armv8pt_entry_write_is_dirty
+
+static inline void armv8pt_entry_set_write_clean(struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		armv8pt_reduce_contig(pts, armv6pt_clear_dirty_s1);
+	else
+		armv8pt_reduce_contig(pts, armv6pt_clear_dirty_s2);
+}
+#define pt_entry_set_write_clean armv8pt_entry_set_write_clean
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_armv8
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
+	return &container_of(common, struct pt_iommu_table, armpt.common)->iommu;
+}
+
+static inline int armv8pt_iommu_set_prot(struct pt_common *common,
+					 struct pt_write_attrs *attrs,
+					 unsigned int iommu_prot)
+{
+	bool is_s1 = !pt_feature(common, PT_FEAT_ARMV8_S2);
+	u64 pte = 0;
+
+	if (is_s1) {
+		u64 ap = 0;
+
+		if (!(iommu_prot & IOMMU_WRITE) && (iommu_prot & IOMMU_READ))
+			ap |= ARMV8PT_AP_RDONLY;
+		if (!(iommu_prot & IOMMU_PRIV))
+			ap |= ARMV8PT_AP_UNPRIV;
+		pte = ARMV8PT_FMT_nG | FIELD_PREP(ARMV8PT_FMT_AP, ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_DEV);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_CACHE);
+	} else {
+		u64 s2ap = 0;
+
+		if (iommu_prot & IOMMU_READ)
+			s2ap |= ARMV8PT_S2AP_READ;
+		if (iommu_prot & IOMMU_WRITE)
+			s2ap |= ARMV8PT_S2AP_WRITE;
+		pte = FIELD_PREP(ARMV8PT_FMT_S2AP, s2ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_DEV);
+		else if ((iommu_prot & IOMMU_CACHE) &&
+			 pt_feature(common, PT_FEAT_ARMV8_S2FWB))
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_FWB_WB);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_OIWB);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_NC);
+	}
+
+	/*
+	 * For DBM the writable entry starts out dirty to avoid the HW doing
+	 * memory accesses to dirty it. We can just leave the DBM bit
+	 * permanently set with no cost.
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_DBM) && (iommu_prot & IOMMU_WRITE))
+		pte |= ARMV8PT_FMT_DBM;
+
+	if (iommu_prot & IOMMU_CACHE)
+		pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_IS);
+	else
+		pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_OS);
+
+	/* FIXME for mali:
+		pte |= ARM_LPAE_PTE_SH_OS;
+	*/
+
+	if (iommu_prot & IOMMU_NOEXEC)
+		pte |= ARMV8PT_FMT_UXN | ARMV8PT_FMT_PXN;
+
+	if (pt_feature(common, PT_FEAT_ARMV8_NS))
+		pte |= ARMV8PT_FMT_NS;
+
+	// FIXME not on mali:
+	pte |= ARMV8PT_FMT_AF;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot armv8pt_iommu_set_prot
+
+static inline int armv8pt_iommu_fmt_init(struct pt_iommu_armv8 *iommu_table,
+					 struct pt_iommu_armv8_cfg *cfg)
+{
+	struct pt_armv8 *armv8pt = &iommu_table->armpt;
+	unsigned int levels;
+
+	/* Atomicity of dirty bits conflicts with an incoherent cache */
+	if ((cfg->features & PT_FEAT_ARMV8_DBM) &&
+	    (cfg->features & PT_FEAT_DMA_INCOHERENT))
+		return -EOPNOTSUPP;
+
+	/* FIXME are these inputs supposed to be an exact request, or a HW capability? */
+
+	if (cfg->ias_lg2 <= PT_GRANUAL_LG2SZ)
+		return -EINVAL;
+
+	if ((PT_GRANUAL_SIZE == SZ_64K && cfg->oas_lg2 > 52) ||
+	    (PT_GRANUAL_SIZE != SZ_64K && cfg->oas_lg2 > 48))
+		return -EINVAL;
+
+	/*if (cfg->ias > 48)
+		table->feat_lva = true; */
+
+	cfg->ias_lg2 = min(cfg->ias_lg2, PT_MAX_VA_ADDRESS_LG2);
+
+	levels = DIV_ROUND_UP(cfg->ias_lg2 - PT_GRANUAL_LG2SZ,
+			      PT_GRANUAL_LG2SZ - ilog2(sizeof(u64)));
+	if (levels > PT_MAX_TOP_LEVEL + 1)
+		return -EINVAL;
+
+	/*
+	 * Table D5-6 PA size implications for the VTCR_EL2.{T0SZ, SL0}
+	 * Single level is not supported without FEAT_TTST, which we are not
+	 * implementing.
+	 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
+	    PT_GRANUAL_SIZE == SZ_4K && levels == 1)
+		return -EINVAL;
+
+	/* FIXME - test me S2 concatenated translation tables
+	if (levels > 1 && cfg->is_s2 &&
+	    cfg->ias_lg2 - (ARMV8PT_LVL0_ITEM_LG2SZ * (levels - 1)) <= 4)
+		levels--;
+        */
+	pt_top_set_level(&armv8pt->common, levels - 1);
+	armv8pt->common.max_vasz_lg2 = cfg->ias_lg2;
+	armv8pt->common.max_oasz_lg2 = cfg->oas_lg2;
+	return 0;
+}
+#define pt_iommu_fmt_init armv8pt_iommu_fmt_init
+
+#if defined(GENERIC_PT_KUNIT)
+static inline void armv8pt_kunit_setup_cfg(struct pt_iommu_armv8_cfg *cfg)
+{
+	cfg->ias_lg2 = 48;
+	cfg->oas_lg2 = 48;
+
+	cfg->features &= ~(BIT(PT_FEAT_ARMV8_TTBR1) | BIT(PT_FEAT_ARMV8_S2) |
+			   BIT(PT_FEAT_ARMV8_DBM) | BIT(PT_FEAT_ARMV8_S2FWB) |
+			   BIT(PT_FEAT_ARMV8_NS));
+}
+#define pt_kunit_setup_cfg armv8pt_kunit_setup_cfg
+#endif
+
+#if defined(GENERIC_PT_KUNIT) && IS_ENABLED(CONFIG_IOMMU_IO_PGTABLE_LPAE)
+#include <linux/io-pgtable.h>
+
+static struct io_pgtable_ops *
+armv8pt_iommu_alloc_io_pgtable(struct pt_iommu_armv8_cfg *cfg,
+			       struct device *iommu_dev,
+			       struct io_pgtable_cfg **unused_pgtbl_cfg)
+{
+	struct io_pgtable_cfg pgtbl_cfg = {};
+	enum io_pgtable_fmt fmt;
+
+	pgtbl_cfg.ias = cfg->ias_lg2;
+	pgtbl_cfg.oas = cfg->oas_lg2;
+	if (PT_GRANUAL_SIZE == SZ_64K)
+		pgtbl_cfg.pgsize_bitmap |= SZ_64K | SZ_512M;
+	if (PT_GRANUAL_SIZE == SZ_16K)
+		pgtbl_cfg.pgsize_bitmap |= SZ_16K | SZ_32M;
+	if (PT_GRANUAL_SIZE == SZ_4K)
+		pgtbl_cfg.pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
+	pgtbl_cfg.coherent_walk = true;
+
+	if (cfg->features & BIT(PT_FEAT_ARMV8_S2))
+		fmt = ARM_64_LPAE_S2;
+	else
+		fmt = ARM_64_LPAE_S1;
+
+	return alloc_io_pgtable_ops(fmt, &pgtbl_cfg, NULL);
+}
+#define pt_iommu_alloc_io_pgtable armv8pt_iommu_alloc_io_pgtable
+
+static void armv8pt_iommu_setup_ref_table(struct pt_iommu_armv8 *iommu_table,
+					  struct io_pgtable_ops *pgtbl_ops)
+{
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(pgtbl_ops)->cfg;
+	struct pt_common *common = &iommu_table->armpt.common;
+
+	/* FIXME should determine the level from the pgtbl_cfg */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2))
+		pt_top_set(common, __va(pgtbl_cfg->arm_lpae_s2_cfg.vttbr),
+			   pt_top_get_level(common));
+	else
+		pt_top_set(common, __va(pgtbl_cfg->arm_lpae_s1_cfg.ttbr),
+			   pt_top_get_level(common));
+}
+#define pt_iommu_setup_ref_table armv8pt_iommu_setup_ref_table
+
+static u64 armv8pt_kunit_cmp_mask_entry(struct pt_state *pts)
+{
+	if (pts->type == PT_ENTRY_TABLE)
+		return pts->entry & (~(u64)(ARMV8PT_FMT_OA48));
+	return pts->entry & (~(u64)ARMV8PT_FMT_CONTIG);
+}
+#define pt_kunit_cmp_mask_entry armv8pt_kunit_cmp_mask_entry
+#endif
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/defs_armv8.h b/drivers/iommu/generic_pt/fmt/defs_armv8.h
new file mode 100644
index 00000000000000..751372a6024e4a
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_armv8.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * VMSAv8-64 translation table in AArch64 mode
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_ARMV8_H
+#define __GENERIC_PT_FMT_DEFS_ARMV8_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+/* Header self-compile default defines */
+#ifndef ARMV8_GRANUAL_SIZE
+#define ARMV8_GRANUAL_SIZE 4096
+#endif
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct armv8pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs armv8pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_armv8_16k.c b/drivers/iommu/generic_pt/fmt/iommu_armv8_16k.c
new file mode 100644
index 00000000000000..46a5aead0007fc
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_armv8_16k.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT armv8
+#define PT_FMT_VARIANT 16k
+#define PT_SUPPORTED_FEATURES                                   \
+	(BIT(PT_FEAT_DMA_INCOHERENT) | BIT(PT_FEAT_ARMV8_LPA) | \
+	 BIT(PT_FEAT_ARMV8_S2) | BIT(PT_FEAT_ARMV8_DBM) |       \
+	 BIT(PT_FEAT_ARMV8_S2FWB))
+#define ARMV8_GRANUAL_SIZE 16384
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/iommu_armv8_4k.c b/drivers/iommu/generic_pt/fmt/iommu_armv8_4k.c
new file mode 100644
index 00000000000000..2143104dfe0d4d
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_armv8_4k.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT armv8
+#define PT_FMT_VARIANT 4k
+#define PT_SUPPORTED_FEATURES                                   \
+	(BIT(PT_FEAT_DMA_INCOHERENT) | BIT(PT_FEAT_ARMV8_LPA) | \
+	 BIT(PT_FEAT_ARMV8_S2) | BIT(PT_FEAT_ARMV8_DBM) |       \
+	 BIT(PT_FEAT_ARMV8_S2FWB))
+#define ARMV8_GRANUAL_SIZE 4096
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/iommu_armv8_64k.c b/drivers/iommu/generic_pt/fmt/iommu_armv8_64k.c
new file mode 100644
index 00000000000000..df008e716b6017
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_armv8_64k.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT armv8
+#define PT_FMT_VARIANT 64k
+#define PT_SUPPORTED_FEATURES                                   \
+	(BIT(PT_FEAT_DMA_INCOHERENT) | BIT(PT_FEAT_ARMV8_LPA) | \
+	 BIT(PT_FEAT_ARMV8_S2) | BIT(PT_FEAT_ARMV8_DBM) |       \
+	 BIT(PT_FEAT_ARMV8_S2FWB))
+#define ARMV8_GRANUAL_SIZE 65536
+
+#include "iommu_template.h"
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 6a865dbf075192..6c8296b1dd1a65 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -100,4 +100,26 @@ enum {
 	PT_FEAT_FMT_START,
 };
 
+struct pt_armv8 {
+	struct pt_common common;
+};
+
+enum {
+	/* Use the upper address space instead of lower */
+	PT_FEAT_ARMV8_TTBR1 = PT_FEAT_FMT_START,
+	/*
+	 * Large Physical Address extension allows larger page sizes on 64k.
+	 * Larger physical addresess are always supported
+	 */
+	PT_FEAT_ARMV8_LPA,
+	/* Use the Stage 2 format instead of Stage 1 */
+	PT_FEAT_ARMV8_S2,
+	/* Use Dirty Bit Modifier, necessary for IOMMU dirty tracking */
+	PT_FEAT_ARMV8_DBM,
+	/* For S2 uses the Force Write Back coding of the S2MEMATTR */
+	PT_FEAT_ARMV8_S2FWB,
+	/* Set the NS and NSTable bits in all entries */
+	PT_FEAT_ARMV8_NS,
+};
+
 #endif
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index f77f6aef3f5958..64af0043d127bc 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -204,4 +204,77 @@ static inline void pt_iommu_deinit(struct pt_iommu *iommu_table)
 	iommu_table->ops->deinit(iommu_table);
 }
 
+struct pt_iommu_armv8 {
+	struct pt_iommu iommu;
+	struct pt_armv8 armpt;
+};
+
+struct pt_iommu_armv8_cfg {
+	struct device *iommu_device;
+	unsigned int features;
+	/* Input Address Size lg2 */
+	u8 ias_lg2;
+	/* Output Address Size lg2 */
+	u8 oas_lg2;
+};
+
+int pt_iommu_armv8_4k_init(struct pt_iommu_armv8 *table,
+			   struct pt_iommu_armv8_cfg *cfg, gfp_t gfp);
+int pt_iommu_armv8_16k_init(struct pt_iommu_armv8 *table,
+			    struct pt_iommu_armv8_cfg *cfg, gfp_t gfp);
+int pt_iommu_armv8_64k_init(struct pt_iommu_armv8 *table,
+			    struct pt_iommu_armv8_cfg *cfg, gfp_t gfp);
+
+static size_t __pt_iommu_armv8_granuals_to_lg2(size_t granual_sizes)
+{
+	size_t supported_granuals = 0;
+
+	if (IS_ENABLED(CONFIG_IOMMU_PT_ARMV8_4K))
+		supported_granuals |= BIT(12);
+	if (IS_ENABLED(CONFIG_IOMMU_PT_ARMV8_16K))
+		supported_granuals |= BIT(14);
+	if (IS_ENABLED(CONFIG_IOMMU_PT_ARMV8_64K))
+		supported_granuals |= BIT(16);
+
+	granual_sizes &= supported_granuals;
+	if (!granual_sizes)
+		return 0;
+
+	/* Prefer the CPU page size if possible */
+	if (granual_sizes & PAGE_SIZE)
+		return PAGE_SHIFT;
+
+	/*
+	 * Otherwise prefer the largest page size smaller than the CPU page
+	 * size
+	 */
+	if (granual_sizes % PAGE_SIZE)
+		return ilog2(rounddown_pow_of_two(granual_sizes % PAGE_SIZE));
+
+	/* Otherwise use the smallest page size available */
+	return __ffs(granual_sizes);
+}
+
+static inline int pt_iommu_armv8_init(struct pt_iommu_armv8 *table,
+				      struct pt_iommu_armv8_cfg *cfg,
+				      size_t granual_sizes, gfp_t gfp)
+{
+	switch (__pt_iommu_armv8_granuals_to_lg2(granual_sizes)) {
+	case 12:
+		if (!IS_ENABLED(CONFIG_IOMMU_PT_ARMV8_4K))
+			return -EOPNOTSUPP;
+		return pt_iommu_armv8_4k_init(table, cfg, gfp);
+	case 14:
+		if (!IS_ENABLED(CONFIG_IOMMU_PT_ARMV8_16K))
+			return -EOPNOTSUPP;
+		return pt_iommu_armv8_16k_init(table, cfg, gfp);
+	case 16:
+		if (!IS_ENABLED(CONFIG_IOMMU_PT_ARMV8_64K))
+			return -EOPNOTSUPP;
+		return pt_iommu_armv8_64k_init(table, cfg, gfp);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 #endif
-- 
2.46.0


