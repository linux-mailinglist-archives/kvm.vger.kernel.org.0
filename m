Return-Path: <kvm+bounces-24277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7BB9536BD
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3017DB24694
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636291B1437;
	Thu, 15 Aug 2024 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kd5nJ/I9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A5B19DF9C
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734711; cv=fail; b=HraSgLdsMdzhhLKf9kYQpC0u3TNLeJy+fKqk2+HTNThFd+g6tOj8OeSI76tmzThjnRL+fyF/iMLiU5Wvu9gEDuSkj/kV4I+aw91rknJ2lr0xCccAKf4ZA4VracJh178gC/AHmbt/bh/OA3C7k9q6PiKJOMp9fK6NwIpt2PmedVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734711; c=relaxed/simple;
	bh=floNC/8wQVWXeV4prn2EKTuRfrjjmUW7uhW5+F2hU9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tAFhWcIWGjbjRa1EidollYfolr3SdV3XktzVR+gcnH9ZvwjBC/6gOwz8hu1WGhcwOB+DtDxa0xD53JApjQNApRjImBf4lQ5mTH2ohKMOPcfeyYBsHJ8vQ6dtb7ekzr3MDlYvy+Sgk+ckboswF977wfVdf9xyMLk8OAgMqC/CKsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kd5nJ/I9; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u3nNYvwhCsxvB4i3LM8P1CozhTomhgq45/FOFYBpaNQNKFbV2CYfPoiZm+aF5w8dGMW7Z6CV6WhkDVilSz67y/z2rQ6R8HfBMmMoxwT6vNHmxwrOcVaXJFmqswfvUWLc1U5KvwrNLMyQ5H0pkPCl9DxJCot5Bkx81g7I7qmQQZ19s9wryKGpnNbC7iY7KAlSm1osjo06y/eTaRdUCkJa9Rw6HP/4nQBoyq8VervDFVkREE+xiAvo4F3TeJD984ZYwk3OR4f4TrALgK70rIZCu/XB9UAxhOrqEwklNxRAOBi2yL3cwFxSX9aPGfXT0/n2XL7XwGKbLveIe3GeVjqtxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0j/1k4c/G8MHTtnGIYqp87lKLwi6X64vXDrTwMalFs=;
 b=CHUYyOU9b/83aolD5NIdRneCSCCIzQLKhI5FU02DuOpO4cGIzLqCYrgY11v4asyWNWucaC1CeeZ9vawzxQDMLGN1rYhEsuEJiWcyQPQXgXWDzOwK1l39C8rXP4CFZmFMCTQ4YO5ZSjdMKNA943GAQKGam6ZgJEckoTYI7h4pUmYiNXu0VQKKUBR0CW46cTkyy5prcsbEBkceoA9NLUojXU40CPMWAuOiBF8aE9n+7trPlt/avWRYYMpbOsIOGMnTKXQeMl9E44Z3QSRE6OP0ll1+O6m3IVAXKV0ooYy6Wfs18nYoia2Og5Uvna5Tp3WfaGnJa4CRr91BaTtsGN67nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0j/1k4c/G8MHTtnGIYqp87lKLwi6X64vXDrTwMalFs=;
 b=Kd5nJ/I9PmvYUIs4so1zDZTU/v2lRWFhqNlbndWJxmrj0mY02zEnbgYx9cymao1FzgWg797hUsw7K8c4AsdDzrTUswIq7Jn854DUKiIS2pN+fCt1oj+sBA6/zwsJYURECllh3ehjKzRNf6F+GxMYrJ5M+wYOxlSQRWMuv37Rcox7m/dU2EBBCPP2oj0fhy7Gq+/0c0ryZjN5vZyFaFhw70iHAIRqjcCUenXnDD6fpvbmZI/VF8TY/y4AfBZEqNoLgMARaQ3qNEkGXJ4kQhPpsR8I8l/3vdi2WipXg/9TgvTLn9tEKe87IexItIZ2X4LA2QtRdg/vlatnaAoUflR/ZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 15:11:41 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:41 +0000
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
Subject: [PATCH 14/16] iommupt: Add the DART v1/v2 page table format
Date: Thu, 15 Aug 2024 12:11:30 -0300
Message-ID: <14-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:208:236::23) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b8c7175-a6a6-4fd8-3b8d-08dcbd3c8e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UvLiRKekO0lqf54baC2BFGyUofW26wDh9wUg8xTnDQcIX3aqloLR/DyBK1Uq?=
 =?us-ascii?Q?j9mvlqSVce+yaRR0/+pHI++czCtHuJwaYMMNy5PO+54KLTdizNuE4X/qUrsW?=
 =?us-ascii?Q?8V5kpiZv/ViwFDoADMEqHJo3gb62cE1WnRuFOyJkgs81zqh2h7Yv8RCMpcfJ?=
 =?us-ascii?Q?N1fLkLFb+pFpITgQhZOyBdcGW3Hw717j7kyDvOXyXdPAzruS8bh7ybs2hw9z?=
 =?us-ascii?Q?FxgmlHfCqI+0guNDN1T1tLUvYycqSI1rytg4aqc5Bll5BA+gaF+fd5gjnWtc?=
 =?us-ascii?Q?BdGfyiIXzhpXfQYkXrHyOOub0RgOZ/7Th75gbhg4f4maXWsfwgwA/z3mgVCm?=
 =?us-ascii?Q?TophWT9o7C8BQIXAfWYZFilc8eNKFNQP7H8JTIrKnkInrxY4Q9ffWaSEakiT?=
 =?us-ascii?Q?qAXuWAU2zsm/lkVruy3z3SDa9tEQ23KjvPlUjXi47+xzS3nFmeqtUj7yUSn7?=
 =?us-ascii?Q?7tN+XT/BaOw82dnMXQRaPISOZ/VS/fpGcPZ6arO9M/A+LZgCP7XDa6ehTeSK?=
 =?us-ascii?Q?v0JxmXMCRazq2MQ8p0mjRKDfknI2z31SODFmViPGoD8pqv7EVuNUA8wJJMuQ?=
 =?us-ascii?Q?7bstQrMmhqPkXGZhUEU7LnRuSf6VI+HmhNHZn4mf97/MQDKa3QcM+6BPDNcr?=
 =?us-ascii?Q?Yk6IuTCL1tJfDygd/o4WwRytXnKB9gcizvD0GcMBkyP2hiZetB/J72qMy/8/?=
 =?us-ascii?Q?sim4ORjMqTLqbT4ljjOCnn/RkX2LpwBIDOn5InCCj3BHfwD3D5ije2pnMZmg?=
 =?us-ascii?Q?jBxyek5YUl4kmM4a0rbDECVjtjFMNZ5gMayXYHTcf7JUM3LeGBpDB+V7oWZm?=
 =?us-ascii?Q?5sFrjOJKsmo6XnzsX9iH8zVFv2ceg6pS1SzqlNbGf82t52yVGYVVOx6h03l/?=
 =?us-ascii?Q?tYdE9tyYHK5syESRSk4BjFccsRQtEon3tXnBCHeU5SwJNgbyaMjBwNle/f5d?=
 =?us-ascii?Q?uFmUzt+gT7fuxO9gy1dPGxvLGqXZHnN8VSUZOPgaLRKuuk7bzvH+k5xjNVks?=
 =?us-ascii?Q?Bk+gscGEtQJlereRz/cLpETXgrqPu0p+FJrL4XwFFeFZjUWAImI0lf/M0GAD?=
 =?us-ascii?Q?Ihdb59H04y6rdEw4RcNV/xAe9IbCR7hxJCcrQQ3ifZg8k3nd2zeoPireUwgR?=
 =?us-ascii?Q?VgfxM7brWnue9zkg0sW+FxAf91+aX7zL13tmqB9B4nAGmoQ8gut65A6LRSh1?=
 =?us-ascii?Q?JBnU1Z1bbFdffcZeB9Nfso7gY7eW2HZ+rhGdNeRm+10z+dbepcwC8P+xGT5V?=
 =?us-ascii?Q?1wNB6cEvK42jSEch4reHXLiNVkMMCmrqJ9s8HI5/H7mSZJjE1X9qyUSOHG3B?=
 =?us-ascii?Q?/aau2t9qPSFlvTJ+linCW/alObi3LBLoRW06CmQmgfO/kw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7V+UOlVKhruoY2eCREAa0rCGGgUbV8RnbNa7Sh+zTZcWIDIee+glD/3atvxE?=
 =?us-ascii?Q?C8G+j+F8MbM8RWAIp3yRzpqN7YQi4c3lh7qr3LFoHRjAIRQSxPxbXGM2kAc/?=
 =?us-ascii?Q?EBzySCDH9iSSq5TfFke4F5szSaJ/D8wWquZRepccxwMg/TuDNbhQ7su13+So?=
 =?us-ascii?Q?6DEAjeRQGHmJR2RVAXZXaKfYOBCbFfyCBnqHmOy5UEXg2gAqTA6Uo8lzvWbp?=
 =?us-ascii?Q?UAx22zMHm0GIDbi825voUUdJfiGOiEpeevurFuSGcTa04T+Zpk3aEl9QzQKb?=
 =?us-ascii?Q?6u78VYENLjuTqy7xd58Gfn/HZNS5eX2Zsk6qu8tcYyOo1fAR5umqiFO1h+X8?=
 =?us-ascii?Q?RKIIHS2xnW7Qe+LLsMVYzjccrztz8v4P7MOh2ZkcwljjMKgUzia/Uhqi9F+v?=
 =?us-ascii?Q?bzxrZNnxXsvJ+CyfgyATwbNjGtu/jkvPwmjmmb6zOsVCR5l1pPU+/daiFZ9r?=
 =?us-ascii?Q?NX4MJImpFdvz4fOQRBWIHxW5kBL12IPEzlsI3FtbqbG7urH/rEJgLngEy21O?=
 =?us-ascii?Q?LakfoOKnrfprHWg1Pdsjhfh+oDTKySI6gSs8eqpsxsGCvANGgAuKxWNCl1Pt?=
 =?us-ascii?Q?EEMQUDLzvCSvcgNchI0AXOrzstb3HfsWm3tfnElteJsoAF2XksanV11YYBLW?=
 =?us-ascii?Q?4XehY0UgBgnHyVyX3q+5IXmG6yZVXrifk24ieW9gB47cFSRAke65Ox1BJg5j?=
 =?us-ascii?Q?CDC3wEVTr3w11c/KKrfMElqJzkxwbcA9sPXspDTgkbwBNBlD5E5jL/RdRAVf?=
 =?us-ascii?Q?AyzAH92bzf2DEx1+0DbUbFrIaZhq3zk6QJZFY0pqRhX0suAtfatgIixNd8BQ?=
 =?us-ascii?Q?z8+pUfANkE1wC1rg3Hzp1erwhyIy+I3SbW0r1tsQ9+YhkqhbswR+UW6BdAx7?=
 =?us-ascii?Q?nUvykdukl0GnesOD/2HiEEVbru8BP+tpnHWzVPRp68pdJMqXtjh44Gy94K0R?=
 =?us-ascii?Q?cjdEyoZ/xR5eXTBjUq3GgIo9LFGuS6F83LsKUJ8rAo/C3A+nT3UE44fut+HB?=
 =?us-ascii?Q?wRutQkSeLNow9bMUUWZDgWxRRirW4vJTiyqiJ8DBZaRt5E9hxOLQ7HCTo3E+?=
 =?us-ascii?Q?yF0K8OhMaWERBYbBmgxMjJ088ZcZgFUL3Tx4yS7p5ETzkYF1SYyq/ktyrX07?=
 =?us-ascii?Q?FPfOCkNkQfQ2gJ6SfKD5Y20uR6U2GidfkfRtjGGct6JMGK58YfkZN3M+5GW/?=
 =?us-ascii?Q?q5Bf6eK2aU4NC/scrvGjgUSOGLg1kcAwZdgMD/YLW55y64b2uOYgBEO5lIrx?=
 =?us-ascii?Q?AuyT9bmHbao8I9Bm821ScIgKVRwebx+tHLYuf9uipOMW6m4+Oer39JkBLP8Z?=
 =?us-ascii?Q?27gUH2DS+aHteDB1CpdKzJc8n5RczUW6aeRbqhDRnj6xrEO7nUJhJ3yV1bFW?=
 =?us-ascii?Q?sXILj9tL98XzVhnG+fdwCbvpmmmNCOECGdsHOz8xJR8wTilAdiAa/7VgtZwI?=
 =?us-ascii?Q?beHfa6Px43Ubbn0VyMi2lJfbVASPUyECNjxqilPen2oqpi+O/iLhGMpG9Ljy?=
 =?us-ascii?Q?jy4/2rQyHPCs0vVL94peqT2FGn4tXJW1/hqJrqOAAgf4pNxfrJDHWk/OwW/E?=
 =?us-ascii?Q?PYmfqkP+UFzp+dSSWcQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b8c7175-a6a6-4fd8-3b8d-08dcbd3c8e1d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:36.2640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wss0bsSHnKyPMCGdzNpG/VZD9W9o6Hf3IErKo31wL5WUgjZ3sQ5o1AiCxwKHuaIN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631

This is used by Apple Silicon CPUs.

DART is quite simple, with only two actual page table levels and only a
single page size. No support for variable top levels.

DARTv2 vs v1 has quite a different format, it may deserve its own file.

DART has a unique feature where the top most level in the page table can
be stored in the device registers. This level is limited to 4 entries.

The approach here is to add an extra level to the table and the core code
will permanently populate it with subtables at init time (FIXME core part
not done yet). The IOMMU driver can then read back the subtables and load
them into the TTBR registers. From an algorithm perspective this is just
another table level with 4 items.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/Kconfig          |  12 +
 drivers/iommu/generic_pt/fmt/Makefile     |   2 +
 drivers/iommu/generic_pt/fmt/dart.h       | 371 ++++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_dart.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_dart.c |   8 +
 include/linux/generic_pt/common.h         |  10 +
 include/linux/generic_pt/iommu.h          |  15 +
 7 files changed, 439 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/dart.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_dart.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_dart.c

diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index a7c006234fc218..5ff07eb6bd8729 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -70,6 +70,17 @@ config IOMMU_PT_ARMV8_64K
 
 	  If unsure, say N here.
 
+config IOMMU_PT_DART
+       tristate "IOMMU page table for Apple Silicon DART"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+	help
+	  Enable support for the Apple DART pagetable formats. These include
+	  the t8020 and t6000/t8110 DART formats used in Apple M1/M2 family
+	  SoCs.
+
+	  If unsure, say N here.
+
 config IOMMU_PT_X86PAE
        tristate "IOMMU page table for x86 PAE"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -83,6 +94,7 @@ config IOMMUT_PT_KUNIT_TEST
 	depends on IOMMU_PT_ARMV8_4K || !IOMMU_PT_ARMV8_4K
 	depends on IOMMU_PT_ARMV8_16K || !IOMMU_PT_ARMV8_16K
 	depends on IOMMU_PT_ARMV8_64K || !IOMMU_PT_ARMV8_64K
+	depends on IOMMU_PT_DART || !IOMMU_PT_DART
 	depends on IOMMU_PT_X86PAE || !IOMMU_PT_X86PAE
 	default KUNIT_ALL_TESTS
 endif
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index fe3d7ae3685468..a41a27561a82d0 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -6,6 +6,8 @@ iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_4K) += armv8_4k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_16K) += armv8_16k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_64K) += armv8_64k
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_DART) += dart
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86PAE) += x86pae
 
 IOMMU_PT_KUNIT_TEST :=
diff --git a/drivers/iommu/generic_pt/fmt/dart.h b/drivers/iommu/generic_pt/fmt/dart.h
new file mode 100644
index 00000000000000..25b1e61908ab36
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/dart.h
@@ -0,0 +1,371 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * DART Page Table
+ *
+ * This is derived from io-pgtable-dart.c
+ *
+ * Use a three level structure:
+ *  L1 - 0
+ *  L2 - 1
+ *  PGD/TTBR's - 2
+ *
+ * The latter level is folded into some other datastructure, in the
+ * io-pgtable-dart implementation this was a naked array, but here we make it a
+ * full level.
+ *
+ * FIXME: is it a mistake to put v1 and v2 into the same file? They seem quite
+ * different and if v1 is always a 4k granule and v2 always 16k it would make
+ * sense to split them.
+ *
+ * FIXME: core code should prepopulate the level 2 table
+ */
+#ifndef __GENERIC_PT_FMT_DART_H
+#define __GENERIC_PT_FMT_DART_H
+
+#include "defs_dart.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+
+enum {
+	PT_ENTRY_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 2,
+	DART_NUM_TTBRS_LG2 = ilog2(4),
+	/*
+	 * This depends on dartv1/v2 and the granule size. max_vasz_lg2 has the
+	 * right value
+	 */
+	PT_MAX_VA_ADDRESS_LG2 = 0,
+};
+
+enum {
+	DART_FMT_VALID = BIT(0),
+	DART_FMT_PTE_SUBPAGE_START = GENMASK_ULL(63, 52),
+	DART_FMT_PTE_SUBPAGE_END = GENMASK_ULL(51, 40),
+};
+
+/* DART v1 PTE layout */
+enum {
+	DART_FMT1_PTE_PROT_SP_DIS = BIT(1),
+	DART_FMT1_PTE_PROT_NO_WRITE = BIT(7),
+	DART_FMT1_PTE_PROT_NO_READ = BIT(8),
+	DART_FMT1_PTE_OA = GENMASK_ULL(35, 12),
+};
+
+/* DART v2 PTE layout */
+enum {
+	DART_FMT2_PTE_PROT_NO_CACHE = BIT(1),
+	DART_FMT2_PTE_PROT_NO_WRITE = BIT(2),
+	DART_FMT2_PTE_PROT_NO_READ = BIT(3),
+	DART_FMT2_PTE_OA = GENMASK_ULL(37, 10),
+};
+
+#define common_to_dartpt(common_ptr) \
+	container_of_const(common_ptr, struct pt_dart, common)
+#define to_dartpt(pts) common_to_dartpt((pts)->range->common)
+
+static inline unsigned int dartpt_granule_lg2sz(const struct pt_common *common)
+{
+	const struct pt_dart *dartpt = common_to_dartpt(common);
+
+	return dartpt->granule_lg2sz;
+}
+
+static inline pt_oaddr_t dartpt_oa(const struct pt_state *pts)
+{
+	if (pts_feature(pts, PT_FEAT_DART_V2))
+		return log2_mul(FIELD_GET(DART_FMT2_PTE_OA, pts->entry), 14);
+	return log2_mul(FIELD_GET(DART_FMT1_PTE_OA, pts->entry), 12);
+}
+
+static inline u64 dartpt_make_oa(const struct pt_state *pts, pt_oaddr_t oa)
+{
+	if (pts_feature(pts, PT_FEAT_DART_V2))
+		return FIELD_PREP(DART_FMT2_PTE_OA, log2_div(oa, 14));
+	return FIELD_PREP(DART_FMT1_PTE_OA, log2_div(oa, 12));
+}
+
+static inline unsigned int
+dartpt_max_output_address_lg2(const struct pt_common *common)
+{
+	/* Width of the OA field plus the pfn size */
+	if (pt_feature(common, PT_FEAT_DART_V2))
+		return (37 - 10 + 1) + 14;
+	return (35 - 12 + 1) + 12;
+}
+#define pt_max_output_address_lg2 dartpt_max_output_address_lg2
+
+static inline pt_oaddr_t dartpt_table_pa(const struct pt_state *pts)
+{
+	return dartpt_oa(pts);
+}
+#define pt_table_pa dartpt_table_pa
+
+static inline pt_oaddr_t dartpt_entry_oa(const struct pt_state *pts)
+{
+	return dartpt_oa(pts);
+}
+#define pt_entry_oa dartpt_entry_oa
+
+static inline bool dartpt_can_have_leaf(const struct pt_state *pts)
+{
+	return pts->level == 0;
+}
+#define pt_can_have_leaf dartpt_can_have_leaf
+
+static inline unsigned int dartpt_table_item_lg2sz(const struct pt_state *pts)
+{
+	unsigned int granule_lg2sz = dartpt_granule_lg2sz(pts->range->common);
+
+	return granule_lg2sz +
+	       (granule_lg2sz - ilog2(sizeof(u64))) * pts->level;
+}
+#define pt_table_item_lg2sz dartpt_table_item_lg2sz
+
+static inline unsigned int dartpt_num_items_lg2(const struct pt_state *pts)
+{
+	/* Level 3 is the TTBRs
+	if (pts->level == 3)
+		return DART_NUM_TTBRS_LG2;
+	*/
+	return dartpt_granule_lg2sz(pts->range->common) - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 dartpt_num_items_lg2
+
+static inline enum pt_entry_type dartpt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!(entry & DART_FMT_VALID))
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0)
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw dartpt_load_entry_raw
+
+static inline void dartpt_install_leaf_entry(struct pt_state *pts,
+					     pt_oaddr_t oa,
+					     unsigned int oasz_lg2,
+					     const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = DART_FMT_VALID | dartpt_make_oa(pts, oa) |
+		attrs->descriptor_bits;
+	/* subpage protection: always allow access to the entire page */
+	entry |= FIELD_PREP(DART_FMT_PTE_SUBPAGE_START, 0) |
+		 FIELD_PREP(DART_FMT_PTE_SUBPAGE_END, 0xfff);
+
+	WRITE_ONCE(tablep[pts->index], entry);
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry dartpt_install_leaf_entry
+
+static inline bool dartpt_install_table(struct pt_state *pts,
+					pt_oaddr_t table_pa,
+					const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = DART_FMT_VALID | dartpt_make_oa(pts, table_pa);
+	return pt_table_install64(&tablep[pts->index], entry, pts->entry);
+}
+#define pt_install_table dartpt_install_table
+
+static inline void dartpt_attr_from_entry(const struct pt_state *pts,
+					  struct pt_write_attrs *attrs)
+{
+	if (pts_feature(pts, PT_FEAT_DART_V2))
+		attrs->descriptor_bits = pts->entry &
+					 (DART_FMT2_PTE_PROT_NO_CACHE |
+					  DART_FMT2_PTE_PROT_NO_WRITE |
+					  DART_FMT2_PTE_PROT_NO_READ);
+	else
+		attrs->descriptor_bits = pts->entry &
+					 (DART_FMT1_PTE_PROT_SP_DIS |
+					  DART_FMT1_PTE_PROT_NO_WRITE |
+					  DART_FMT1_PTE_PROT_NO_READ);
+}
+#define pt_attr_from_entry dartpt_attr_from_entry
+
+static inline void dartpt_clear_entry(struct pt_state *pts,
+				      unsigned int num_contig_lg2)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+
+	WRITE_ONCE(tablep[pts->index], 0);
+}
+#define pt_clear_entry dartpt_clear_entry
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_dart
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->dartpt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, dartpt.common)
+			->iommu;
+}
+
+static inline int dartpt_iommu_set_prot(struct pt_common *common,
+					struct pt_write_attrs *attrs,
+					unsigned int iommu_prot)
+{
+	u64 pte = 0;
+
+	if (pt_feature(common, PT_FEAT_DART_V2)) {
+		if (!(iommu_prot & IOMMU_WRITE))
+			pte |= DART_FMT2_PTE_PROT_NO_WRITE;
+		if (!(iommu_prot & IOMMU_READ))
+			pte |= DART_FMT2_PTE_PROT_NO_READ;
+		if (!(iommu_prot & IOMMU_CACHE))
+			pte |= DART_FMT2_PTE_PROT_NO_CACHE;
+
+		/*
+		 * FIXME is this a bug in io-pgtable-dart? It uncondtionally
+		 * sets DART_FMT1_PTE_PROT_SP_DIS which is called NO_CACHE on
+		 * v2
+		 */
+		pte |= DART_FMT2_PTE_PROT_NO_CACHE;
+	} else {
+		if (!(iommu_prot & IOMMU_WRITE))
+			pte |= DART_FMT1_PTE_PROT_NO_WRITE;
+		if (!(iommu_prot & IOMMU_READ))
+			pte |= DART_FMT1_PTE_PROT_NO_READ;
+		pte |= DART_FMT1_PTE_PROT_SP_DIS;
+	}
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot dartpt_iommu_set_prot
+
+static inline int dartpt_iommu_fmt_init(struct pt_iommu_dart *iommu_table,
+					struct pt_iommu_dart_cfg *cfg)
+{
+	struct pt_dart *table = &iommu_table->dartpt;
+	unsigned int l2_va_lg2sz;
+	unsigned int l3_num_items_lg2;
+
+	/* The V2 OA requires a 16k page size */
+	if (pt_feature(&iommu_table->dartpt.common, PT_FEAT_DART_V2))
+		cfg->pgsize_bitmap =
+			log2_mod(cfg->pgsize_bitmap, ilog2(SZ_16K));
+
+	if ((cfg->oas_lg2 != 36 && cfg->oas_lg2 != 42) ||
+	    cfg->ias_lg2 > cfg->oas_lg2 ||
+	    !(cfg->pgsize_bitmap & (SZ_4K | SZ_16K)))
+		return -EOPNOTSUPP;
+
+	/*
+	 * The page size reflects both the size of the tables and the minimum
+	 * granule size.
+	 */
+	table->granule_lg2sz = log2_ffs(cfg->pgsize_bitmap);
+
+	/* Size of VA covered by the first two levels */
+	l2_va_lg2sz = table->granule_lg2sz +
+		      (table->granule_lg2sz - ilog2(sizeof(u64))) * 2;
+
+	table->common.max_vasz_lg2 = cfg->ias_lg2;
+	if (cfg->ias_lg2 <= l2_va_lg2sz) {
+		/*
+		 * Only a single TTBR, don't use the TTBR table, the table_root
+		 * pointer will be TTBR[0]
+		 */
+		l3_num_items_lg2 = ilog2(1);
+		pt_top_set_level(&table->common, 1);
+	} else {
+		l3_num_items_lg2 = cfg->ias_lg2 - l2_va_lg2sz;
+		if (l3_num_items_lg2 > DART_NUM_TTBRS_LG2)
+			return -EOPNOTSUPP;
+		/*
+		 * Otherwise the level=3 table holds the TTBR values encoded as
+		 * page table entries.
+		 */
+		pt_top_set_level(&table->common, 2);
+	}
+	return 0;
+}
+#define pt_iommu_fmt_init dartpt_iommu_fmt_init
+
+#if defined(GENERIC_PT_KUNIT)
+static void dart_pt_kunit_setup_cfg(struct pt_iommu_dart_cfg *cfg)
+{
+	cfg->features &= ~(BIT(PT_FEAT_DART_V2));
+	cfg->oas_lg2 = 36;
+	cfg->ias_lg2 = 30;
+	cfg->pgsize_bitmap = SZ_4K;
+}
+#define pt_kunit_setup_cfg dart_pt_kunit_setup_cfg
+#endif
+
+#if defined(GENERIC_PT_KUNIT) && IS_ENABLED(CONFIG_IOMMU_IO_PGTABLE_DART)
+#include <linux/io-pgtable.h>
+
+static struct io_pgtable_ops *
+dartpt_iommu_alloc_io_pgtable(struct pt_iommu_dart_cfg *cfg,
+			      struct device *iommu_dev,
+			      struct io_pgtable_cfg **unused_pgtbl_cfg)
+{
+	struct io_pgtable_cfg pgtbl_cfg = {};
+	enum io_pgtable_fmt fmt;
+
+	pgtbl_cfg.ias = cfg->ias_lg2;
+	pgtbl_cfg.oas = cfg->oas_lg2;
+	pgtbl_cfg.pgsize_bitmap = SZ_4K;
+	pgtbl_cfg.coherent_walk = true;
+
+	if (cfg->features & BIT(PT_FEAT_DART_V2))
+		fmt = APPLE_DART2;
+	else
+		fmt = APPLE_DART;
+
+	return alloc_io_pgtable_ops(fmt, &pgtbl_cfg, NULL);
+}
+#define pt_iommu_alloc_io_pgtable dartpt_iommu_alloc_io_pgtable
+
+static void dartpt_iommu_setup_ref_table(struct pt_iommu_dart *iommu_table,
+					 struct io_pgtable_ops *pgtbl_ops)
+{
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(pgtbl_ops)->cfg;
+	struct pt_common *common = &iommu_table->dartpt.common;
+
+	/* FIXME should test multi-ttbr tables */
+	WARN_ON(pgtbl_cfg->apple_dart_cfg.n_ttbrs != 1);
+	pt_top_set(common, __va(pgtbl_cfg->apple_dart_cfg.ttbr[0]), 1);
+}
+#define pt_iommu_setup_ref_table dartpt_iommu_setup_ref_table
+
+static u64 dartpt_kunit_cmp_mask_entry(struct pt_state *pts)
+{
+	if (pts->type == PT_ENTRY_TABLE) {
+		if (pts_feature(pts, PT_FEAT_DART_V2))
+			return pts->entry & (~(u64)DART_FMT2_PTE_OA);
+		return pts->entry & (~(u64)DART_FMT1_PTE_OA);
+	}
+	return pts->entry;
+}
+#define pt_kunit_cmp_mask_entry dartpt_kunit_cmp_mask_entry
+#endif
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/defs_dart.h b/drivers/iommu/generic_pt/fmt/defs_dart.h
new file mode 100644
index 00000000000000..9b074d22cc6bc0
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_dart.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_DART_H
+#define __GENERIC_PT_FMT_DEFS_DART_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct dart_pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs dart_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_dart.c b/drivers/iommu/generic_pt/fmt/iommu_dart.c
new file mode 100644
index 00000000000000..67e8198a79e1ef
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_dart.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT dart
+#define PT_SUPPORTED_FEATURES BIT(PT_FEAT_DART_V2)
+
+#include "iommu_template.h"
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index e35fb83657f73b..edfbf5f8d047b6 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -126,6 +126,16 @@ enum {
 	PT_FEAT_ARMV8_NS,
 };
 
+struct pt_dart {
+	struct pt_common common;
+	u8 granule_lg2sz;
+};
+
+enum {
+	/* Use the DART 2 rules instead of DART 1 */
+	PT_FEAT_DART_V2 = PT_FEAT_FMT_START,
+};
+
 struct pt_x86pae {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index ca69bb6192d1a7..0896e79863062e 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -289,6 +289,21 @@ static inline int pt_iommu_armv8_init(struct pt_iommu_armv8 *table,
 	}
 }
 
+struct pt_iommu_dart {
+	struct pt_iommu iommu;
+	struct pt_dart dartpt;
+};
+
+struct pt_iommu_dart_cfg {
+	struct device *iommu_device;
+	unsigned int features;
+	unsigned int ias_lg2;
+	unsigned int oas_lg2;
+	u64 pgsize_bitmap;
+};
+int pt_iommu_dart_init(struct pt_iommu_dart *table,
+		       struct pt_iommu_dart_cfg *cfg, gfp_t gfp);
+
 struct pt_iommu_x86pae {
 	struct pt_iommu iommu;
 	struct pt_x86pae x86pae_pt;
-- 
2.46.0


