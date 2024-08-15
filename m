Return-Path: <kvm+bounces-24276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 350029536BB
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4E681F22805
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3666C1AE878;
	Thu, 15 Aug 2024 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="urCoF+Fz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2608B1AC426
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734709; cv=fail; b=oQ+WC67tHkOBTOxMCHFSBfRAlGjhtBdjSAsjmCK1Az5upR6u47b9/G/Rd6fhaRtDxzKvZPjLKU95M95YDWYD63/kurHMcmiFzS8QAcdVRObGrlaNFosaARXc+pS0pAQEUGhW6la+6H61inisSN8kS3ZRwwE5rzz9bPkm3P+q3Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734709; c=relaxed/simple;
	bh=TllDC80KUMNSN7CeUf4l8H87u5VzWHuI8R9DSSqUjEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZJSJkDyRVtjfZFa4VeWJ5eAz3I+EwcqMH1ROwxZbqPEVHar+LNachpiEXXtswTYeaxql9XY5YCii1nVz054eMdp6cMV6I8VT/wNy/dY1S1gp15O7Y9mv/wIt9VGT/X+pq8Oiw2JHBN7DC4lMesAsytxVCrJXUwYLhrJQ6UW83H0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=urCoF+Fz; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IXdmduK33MWdbL5DvwuWIbPLJPhJ8igiOV+GSbV+m2kWhz1bPhfKVrMOcLdoyx7IzuRIWJiyQNKrfKUCkWkIECoHNBwyfHZilzSRiLHiR14tV1VQwKVmVGkw7h8OyBhgjDH/YItJgDeYIkEE6zjlcnZtOEwsdGUjloJZoFXIExFGB1gVSjFGoJrva4NxsO8KcEB7hAMvjG5nmup1p6v7lUksO3UxXnM11fSR/xwXLcdc0gAX5erzgXCdi45J7tAyMpCZ+4b70z9p1jP+Dd0Mi4pbzTDn5BpUOiSiXYNxZJBzAmfFkk3jpxiUUC4CLZyUETttWLabdCz7/QRkVTrJRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgpyrIrWeMvIdTyL/LbSbfN211GNOImYYvbh7eFv3DY=;
 b=Gm8DnfwlWBxC5BYN5YWNsgDhVYpoI4n94sz2gd/a+zOMJYbxV6B4/ie99qoT0WOCTGBmTkCutYRpRsZTIOoFdVwlf/1fJiYpHA2S0/PuKwBXokTpgKh4Kt4/qbIx7yZsJjkgpI/vN4IIkGXwT/T4FAllEFT+nY8X2zZWEAh32zIZ/qwyyvz0dqLCXav3sFIPTRobztFVC1dCLaUxX/3kyS02dWqdBCcVTKv8UOrxygZ+ZKtHpcHagQGgI8i1uIUN8bjSbpPEDvnbZ4119u+fiOzRYxrgQ3k2b1PzTe6RwXB94m7cyC97CiedaLwtJ0D7p9BOnv3nVe45kR7rbGOIXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgpyrIrWeMvIdTyL/LbSbfN211GNOImYYvbh7eFv3DY=;
 b=urCoF+Fz0Dio4E7YSJn4bhMLSPHP304u5XS/dLvM18r2ge2StL4UJh0iC/hOobl4ONuUuOj9vPrYSM4Xum0h2NWyyLF2aDDup8XJL6M7O6ynd/2223h7w1654H14YSNmEV0e+7ErYQztIRfAqJXkVTIcYDN+6zFTxrv1Jj0oIeLFZmf6jFapJYh1azlq0xJOrduJ1aOJkmJedLIHvbBcQKD3ohuE/bSj7xLZOb5Q3+yAbujdkMO10T9l1H9WwMByK35tRqnstf1a6NIliJ4ipF0oPDFxZ3+TZKHeK1VYFHMU/ckMW1Iu0FnPUfoKs0vbwwCh3RsmCpau+m07TE16ZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:36 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:36 +0000
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
Subject: [PATCH 12/16] iommupt: Add the AMD IOMMU v1 page table format
Date: Thu, 15 Aug 2024 12:11:28 -0300
Message-ID: <12-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:335::19) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c793138-8b85-49b2-a175-08dcbd3c8d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kQZQ3LqkAacC1Qla1g/NzFSbJYsTwDf2hodYisEyyreufvhgacgY0sUsJp4t?=
 =?us-ascii?Q?CssrXVL6VwTCfO+1UcYlj0ubyp3/nhqVdWFxbTu9pKjxC+B6JjdBvOXu4xBh?=
 =?us-ascii?Q?sgazCDuINk2l+aGZvh9cqqLxd6xc3tTohwvw74FUcL8OWOazg+WJDGITtWUz?=
 =?us-ascii?Q?aSxWdz3uiEiEvGU7nOAHnXV8463Pkdm9xpCnF69WANDyyhJ0ui0hASDs+amo?=
 =?us-ascii?Q?l4GtjeYHiMPJqBqZQnKJftfn8s0ayH68RUjAxhJ8qWUUa+V1MWT4BcZzWWq+?=
 =?us-ascii?Q?t+3Elly0bZdIgVdB2g98tMAeTBxWQs9f9tQBNgp7TzsBx5t4zHNYGkOfycuZ?=
 =?us-ascii?Q?9k1/XPvXTy31TzCZssCxb55Hmfr99EE2iSU9Qnv6OlAUjdQtMhJrJh9Rp2Hi?=
 =?us-ascii?Q?1XvR2QisaGLdorxOJwP0b7IKeJMFLtGy/DDzs3R/9uQDa9XhGrhGg1crPt/r?=
 =?us-ascii?Q?FHwGH1HNB4yN0hIn3osmgncteFqtexbhpDUgwVELbxUCy5TifBakmpOPGh6a?=
 =?us-ascii?Q?5pJeULqpSscdG86UYe3+fV1rdZNf7V4ObsVCRD3/grWoWbbVyMSmnxDZnsHM?=
 =?us-ascii?Q?SOlANs8bgSwhE1sPwoYRrRfS0QEgrXN6G7lVd2xGUIsciPAXVh6wf7pPCKv+?=
 =?us-ascii?Q?Po4yIcwGpBrqQE3gHF+gDQMk8kCM3tTc+ooolklgLcFoB9q93C9S2UXzxtTR?=
 =?us-ascii?Q?yO/1sIzQ1VO95dRwfZGAn1h2VNiv47f0g/aKvjFiyJCV9t3h4osmdHxe9hQk?=
 =?us-ascii?Q?fhbEp69k/5dAf+SjFG0LzKcvPzA1YpRVjrMy+Aj1cZiZCDJ4G8q+WA5T4DTI?=
 =?us-ascii?Q?MW2NjwLxsSW1+geoNNRlm+liTnD2K7hgLdcr2uB+hztz3C86mATu4AkwV5Wd?=
 =?us-ascii?Q?HvsiMLmnrvUncagOlKb9Gr4+MIkgR0rOG5uElOqJNr5MTDIl1gY4I2N+g6XX?=
 =?us-ascii?Q?0QCHxCpfznFWXQ/tmPT3vq+69tWA/8LeAZ+zRdDA/OBpEaseTUXowGXp8q0o?=
 =?us-ascii?Q?eeMjE6E/wwpnFrC6D+5Ede3oaJstSZmgfyX06tRp+KL0C3/OifSefkrf7nvq?=
 =?us-ascii?Q?2+2Y6sF7nbNE7t6rvi/zoA1EV3B/gIVa3M/kCpMmG/w6w6Pm1RbCMcbA7HN7?=
 =?us-ascii?Q?VMEGY1N9nYyjWmAo6nN/5kV4enWxFK2Vf9vyrRMvcaSHYsjn1EMPoLHrJp2S?=
 =?us-ascii?Q?vJMGbDbqyl2sZU0blIxjTthEan4LZ2/c1WGk+qDLArFKqFNkS49G0t8aVnyM?=
 =?us-ascii?Q?pi6qaKusJa9fKFrbjEH+gQTWF/7JqqCq0ufBYeKJ+2whgAGVHGta7LAF8/yn?=
 =?us-ascii?Q?CjTqcu2bl1DmgzPV5/4Ga2JazG8yM+fiidfQthl5tSKUfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hxlpOQXL9eRpzDA4ecwlJLvUALEA+w9D8C0Z1cKmjpr1zBnrbL3EIWvwGo7w?=
 =?us-ascii?Q?X/OWrkkQ74LFqzUoGj1WKJK9k/9RkerwSuEbQ5umBki0T0UCCX8jkJ6uOB03?=
 =?us-ascii?Q?jyyTgeALldAdh+aPh7x7njRxPERW+nfbrix6rzRA+/KlvnkjtxnBgtiFiDsN?=
 =?us-ascii?Q?ypibjb+RZdnBrytGT5hpBPKfre06UiihQBba5L7B695BREc+8lGFiFBuIxDJ?=
 =?us-ascii?Q?oT5kE9xAatUjotgzU1heSidLEdphG0OMbjLzIErf4fKB6jHqFvEn15DBR4kw?=
 =?us-ascii?Q?3fhKw6g+mHYYVsMD1fFYV0AZ4RyAYnd5gTIyjOAV3tKk5N08fxQEcY7GbJNL?=
 =?us-ascii?Q?OemyrpZ+QfVxPbqhdutNsle7qkvadEbJezxQIMzgNOcc7EvW5I8UwpvN19/F?=
 =?us-ascii?Q?hWoB/KhBJkoZG/3b0UqJ7IovxpShOZHkSXumt1ubIqknQvG1QwDcRaofjztA?=
 =?us-ascii?Q?LcQOWZBjMfzZZGtoRDYkVPpf7B3QlM8szEeD/no3FcGkH0fYzn6hdmgOwm28?=
 =?us-ascii?Q?C7dUi9KEQOQ9iXhIo5WYbRUds1xY0ySpmbPKPkUPg0X76l0F2Acgp/EFaJFO?=
 =?us-ascii?Q?/kebUsRLIUDNzHzob8baqw9jKaV9OeJJBQP1/k0A19YrlKCqcrbuUIDgBF5n?=
 =?us-ascii?Q?vv7JkLAoP2gg0FPZtn4mqSl5qWdGUA+H6h2EgyArNbhmAjeBl042RzY6/0E6?=
 =?us-ascii?Q?8eF9aFworcp7NDT123w/kJ9I88ZeuGxnDiZ7kWo+WtMMNFGAZxbEsvDFnthK?=
 =?us-ascii?Q?LI5dnR/vTHpKelUNU4E2spKsZW9eOs3qi0mY1mMA8REYHEnbs7Xm9qgjH0Sx?=
 =?us-ascii?Q?xfoUn0luYS6xZ8LamJhb3xgyqzuqmWKb43YSZph3UUr/V11qTnNiB8mmLpru?=
 =?us-ascii?Q?Wq+KVtNX9Z88YJDKh1XQSdBajFOiqVpbV8IFD42ilN0Dd/75xxyUwFldUnzq?=
 =?us-ascii?Q?Fl8KjwqgsRgU6bgWGLG7TI70V3JXN9a3MbE+y7r5PUFFhmIaszR/LMMPycGp?=
 =?us-ascii?Q?tduXXunn7LfregMGLnp1QF0MpSKgQ9y91/MZcvsuOTc+eXV7PA5mLnMsQNzD?=
 =?us-ascii?Q?HvOt0UtaOW2kcaVi1AEgAozLfDxEiIky9DzrP26CeYomlCH0QqjgMN6OCjZb?=
 =?us-ascii?Q?10y1N22KrjwtHCH07y0sPdaw5HDU5LB+2gQXrcNPr7rF3bzup0xY18JPNe7c?=
 =?us-ascii?Q?iAFtx8oFIexbiXWWd156iKqZOvNoIGaC6AFeb+3eD/7C3STOfyiqyCT2m3ho?=
 =?us-ascii?Q?djonubLjs95zaBusVrpa871j8K4jGuHhg/wvDmeATV44PT13sHWDcP+P1gua?=
 =?us-ascii?Q?x0EUl2Xxp/HKSHjJJ4yKS70/spJIbaPLRw470j3vmy+wOgvV9Tg5dNHzisMP?=
 =?us-ascii?Q?CvnzW3/8GFfu+XQ4lISrZDSld5vToRRm6qKe9wxMdGd1eT4WCDq451u4CgqL?=
 =?us-ascii?Q?YaZ689OeHjfWmdZolwQiol6Y4otfxAVxN/8RUWdMWEdsLy9XiMMDDgtXjxyl?=
 =?us-ascii?Q?LwJaOM9o0D2e0Ofq/VDkT97O1RvktCNmrC5+rdMhYcyho83+Rn4Q6CYw+yk9?=
 =?us-ascii?Q?shYMnVAbGhzqxIAv174=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c793138-8b85-49b2-a175-08dcbd3c8d59
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:34.9642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/DlYbaGvzn7vPhGNX1DFNqnZ8CUoZwXaXF/GV5fm2Xlob3SnVuvrNoDMX6VZn1o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

AMD IOMMU v1 is unique in supporting contiguous pages with a variable
size and it can decode the full 64 bit VA space.

The general design is quite similar to the x86 PAE format, except with an
additional level and quite different PTE encoding.

This format is the only one that uses the PT_FEAT_DYNAMIC_TOP feature in
the existing code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/Kconfig           |   6 +
 drivers/iommu/generic_pt/fmt/Makefile      |   2 +
 drivers/iommu/generic_pt/fmt/amdv1.h       | 372 +++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_amdv1.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_amdv1.c |   9 +
 include/linux/generic_pt/common.h          |   4 +
 include/linux/generic_pt/iommu.h           |  12 +
 7 files changed, 426 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/amdv1.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_amdv1.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_amdv1.c

diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 260fff5daa6e57..e34be10cf8bac2 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -29,6 +29,11 @@ config IOMMU_PT
 	  Generic library for building IOMMU page tables
 
 if IOMMU_PT
+config IOMMU_PT_AMDV1
+	tristate "IOMMU page table for 64 bit AMD IOMMU v1"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+
 config IOMMU_PT_ARMV8_4K
 	tristate "IOMMU page table for 64 bit ARMv8 4k page size"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -69,6 +74,7 @@ config IOMMUT_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	select IOMMU_IO_PGTABLE
 	depends on KUNIT
+	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
 	depends on IOMMU_PT_ARMV8_4K || !IOMMU_PT_ARMV8_4K
 	depends on IOMMU_PT_ARMV8_16K || !IOMMU_PT_ARMV8_16K
 	depends on IOMMU_PT_ARMV8_64K || !IOMMU_PT_ARMV8_64K
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 9a9173ce85e075..16031fc1270178 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_AMDV1) += amdv1
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_4K) += armv8_4k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_16K) += armv8_16k
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_64K) += armv8_64k
diff --git a/drivers/iommu/generic_pt/fmt/amdv1.h b/drivers/iommu/generic_pt/fmt/amdv1.h
new file mode 100644
index 00000000000000..3c1af8f84cca02
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/amdv1.h
@@ -0,0 +1,372 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * AMD IOMMU v1 page table
+ *
+ * This is described in Section "2.2.3 I/O Page Tables for Host Translations"
+ * of the "AMD I/O Virtualization Technology (IOMMU) Specification"
+ *
+ * Note the level numbering here matches the core code, so level 0 is the same
+ * as mode 1.
+ *
+ * FIXME:
+ * sme_set
+ */
+#ifndef __GENERIC_PT_FMT_AMDV1_H
+#define __GENERIC_PT_FMT_AMDV1_H
+
+#include "defs_amdv1.h"
+#include "../pt_defs.h"
+
+#include <asm/page.h>
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/minmax.h>
+#include <linux/sizes.h>
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
+	PT_MAX_VA_ADDRESS_LG2 = 64,
+	PT_ENTRY_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 5,
+	PT_GRANUAL_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+};
+
+/* PTE bits */
+enum {
+	AMDV1PT_FMT_PR = BIT(0),
+	AMDV1PT_FMT_NEXT_LEVEL = GENMASK_ULL(11, 9),
+	AMDV1PT_FMT_OA = GENMASK_ULL(51, 12),
+	AMDV1PT_FMT_FC = BIT_ULL(60),
+	AMDV1PT_FMT_IR = BIT_ULL(61),
+	AMDV1PT_FMT_IW = BIT_ULL(62),
+};
+
+/*
+ * gcc 13 has a bug where it thinks the output of FIELD_GET() is an enum, make
+ * these defines to avoid it.
+ */
+#define AMDV1PT_FMT_NL_DEFAULT 0
+#define	AMDV1PT_FMT_NL_SIZE 7
+
+#define common_to_amdv1pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_amdv1, common)
+#define to_amdv1pt(pts) common_to_amdv1pt((pts)->range->common)
+
+static inline pt_oaddr_t amdv1pt_table_pa(const struct pt_state *pts)
+{
+	return log2_mul(FIELD_GET(AMDV1PT_FMT_OA, pts->entry),
+			PT_GRANUAL_LG2SZ);
+}
+#define pt_table_pa amdv1pt_table_pa
+
+/* Returns the oa for the start of the contiguous entry */
+static inline pt_oaddr_t amdv1pt_entry_oa(const struct pt_state *pts)
+{
+	pt_oaddr_t oa = FIELD_GET(AMDV1PT_FMT_OA, pts->entry);
+
+	if (FIELD_GET(AMDV1PT_FMT_NEXT_LEVEL, pts->entry) ==
+	    AMDV1PT_FMT_NL_SIZE) {
+		unsigned int sz_bits = oalog2_ffz(oa);
+
+		oa = log2_set_mod(oa, 0, sz_bits);
+	} else if (PT_WARN_ON(FIELD_GET(AMDV1PT_FMT_NEXT_LEVEL, pts->entry) !=
+			      AMDV1PT_FMT_NL_DEFAULT))
+		return 0;
+	return log2_mul(oa, PT_GRANUAL_LG2SZ);
+}
+#define pt_entry_oa amdv1pt_entry_oa
+
+static inline bool amdv1pt_can_have_leaf(const struct pt_state *pts)
+{
+	/*
+	 * Table 15: Page Tabel Level Parameters
+	 * The top most level cannot have translation entries
+	 */
+	return pts->level < PT_MAX_TOP_LEVEL;
+}
+#define pt_can_have_leaf amdv1pt_can_have_leaf
+
+static inline unsigned int amdv1pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	return PT_GRANUAL_LG2SZ +
+	       (PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64))) * pts->level;
+}
+#define pt_table_item_lg2sz amdv1pt_table_item_lg2sz
+
+static inline unsigned int
+amdv1pt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	u64 code;
+
+	if (FIELD_GET(AMDV1PT_FMT_NEXT_LEVEL, pts->entry) ==
+	    AMDV1PT_FMT_NL_DEFAULT)
+		return ilog2(1);
+
+	if (PT_WARN_ON(FIELD_GET(AMDV1PT_FMT_NEXT_LEVEL, pts->entry) !=
+		       AMDV1PT_FMT_NL_SIZE))
+		return ilog2(1);
+
+	/*
+	 * Reverse:
+	 *  log2_div(log2_to_int(pgsz_lg2 - 1) - 1, PT_GRANUAL_LG2SZ));
+	 */
+	code = FIELD_GET(AMDV1PT_FMT_OA, pts->entry);
+	return oalog2_ffz(code) + 1 -
+	       (PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64))) * pts->level;
+}
+#define pt_entry_num_contig_lg2 amdv1pt_entry_num_contig_lg2
+
+static inline unsigned int amdv1pt_num_items_lg2(const struct pt_state *pts)
+{
+	/* Top entry covers bits [63:57] only */
+	/* if (pts->level == 5)
+		return 7;
+	*/
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 amdv1pt_num_items_lg2
+
+static inline pt_vaddr_t amdv1pt_possible_sizes(const struct pt_state *pts)
+{
+	unsigned int isz_lg2 = amdv1pt_table_item_lg2sz(pts);
+
+	if (!amdv1pt_can_have_leaf(pts))
+		return 0;
+
+	/*
+	 * Table 14: Example Page Size Encodings
+	 * Address bits 51:32 can be used to encode page sizes greater that 4
+	 * Gbytes. Address bits 63:52 are zero-extended.
+	 *
+	 * 512GB Pages are not supported due to a hardware bug.
+	 * Otherwise every power of two size is supported.
+	 */
+	return GENMASK_ULL(min(51, isz_lg2 + amdv1pt_num_items_lg2(pts) - 1),
+			   isz_lg2) &
+	       ~SZ_512G;
+}
+#define pt_possible_sizes amdv1pt_possible_sizes
+
+static inline enum pt_entry_type amdv1pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	unsigned int next_level;
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!(entry & AMDV1PT_FMT_PR))
+		return PT_ENTRY_EMPTY;
+
+	next_level = FIELD_GET(AMDV1PT_FMT_NEXT_LEVEL, pts->entry);
+	if (pts->level == 0 || next_level == AMDV1PT_FMT_NL_DEFAULT ||
+	    next_level == AMDV1PT_FMT_NL_SIZE)
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw amdv1pt_load_entry_raw
+
+static inline void
+amdv1pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			   unsigned int oasz_lg2,
+			   const struct pt_write_attrs *attrs)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = AMDV1PT_FMT_PR |
+		FIELD_PREP(AMDV1PT_FMT_OA, log2_div(oa, PT_GRANUAL_LG2SZ)) |
+		attrs->descriptor_bits;
+
+	if (oasz_lg2 == isz_lg2) {
+		entry |= FIELD_PREP(AMDV1PT_FMT_NEXT_LEVEL,
+				    AMDV1PT_FMT_NL_DEFAULT);
+		WRITE_ONCE(tablep[pts->index], entry);
+	} else {
+		unsigned int end_index =
+			pts->index + log2_to_int(oasz_lg2 - isz_lg2);
+		unsigned int i;
+
+		entry |= FIELD_PREP(AMDV1PT_FMT_NEXT_LEVEL,
+				    AMDV1PT_FMT_NL_SIZE) |
+			 FIELD_PREP(AMDV1PT_FMT_OA,
+				    log2_div(log2_to_int(oasz_lg2 - 1) - 1,
+					     PT_GRANUAL_LG2SZ));
+		for (i = pts->index; i != end_index; i++)
+			WRITE_ONCE(tablep[i], entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry amdv1pt_install_leaf_entry
+
+static inline bool amdv1pt_install_table(struct pt_state *pts,
+					 pt_oaddr_t table_pa,
+					 const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	/*
+	 * IR and IW are ANDed from the table levels along with the PTE. We
+	 * always control permissions from the PTE, so always set IR and IW for
+	 * tables.
+	 */
+	entry = AMDV1PT_FMT_PR |
+		FIELD_PREP(AMDV1PT_FMT_NEXT_LEVEL, pts->level) |
+		FIELD_PREP(AMDV1PT_FMT_OA,
+			   log2_div(table_pa, PT_GRANUAL_LG2SZ)) |
+		AMDV1PT_FMT_IR | AMDV1PT_FMT_IW;
+	return pt_table_install64(&tablep[pts->index], entry, pts->entry);
+}
+#define pt_install_table amdv1pt_install_table
+
+static inline void amdv1pt_attr_from_entry(const struct pt_state *pts,
+					   struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits =
+		pts->entry & (AMDV1PT_FMT_FC | AMDV1PT_FMT_IR | AMDV1PT_FMT_IW);
+}
+#define pt_attr_from_entry amdv1pt_attr_from_entry
+
+/* FIXME share code */
+static inline void amdv1pt_clear_entry(struct pt_state *pts,
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
+#define pt_clear_entry amdv1pt_clear_entry
+
+/* FIXME pt_entry_write_is_dirty/etc */
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_amdv1
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->amdpt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, amdpt.common)->iommu;
+}
+
+static inline int amdv1pt_iommu_set_prot(struct pt_common *common,
+					 struct pt_write_attrs *attrs,
+					 unsigned int iommu_prot)
+{
+	u64 pte;
+
+	/* FIXME Intel allows control over the force coherence bit */
+	pte = AMDV1PT_FMT_FC;
+	if (iommu_prot & IOMMU_READ)
+		pte |= AMDV1PT_FMT_IR;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= AMDV1PT_FMT_IW;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot amdv1pt_iommu_set_prot
+
+static inline int amdv1pt_iommu_fmt_init(struct pt_iommu_amdv1 *iommu_table,
+					 struct pt_iommu_amdv1_cfg *cfg)
+{
+	struct pt_amdv1 *table = &iommu_table->amdpt;
+
+	/* FIXME since this isn't configurable right now should we drop it? */
+	pt_top_set_level(&table->common, 2); // FIXME
+	return 0;
+}
+#define pt_iommu_fmt_init amdv1pt_iommu_fmt_init
+
+#if defined(GENERIC_PT_KUNIT)
+static void amdv1pt_kunit_setup_cfg(struct pt_iommu_amdv1_cfg *cfg)
+{
+}
+#define pt_kunit_setup_cfg amdv1pt_kunit_setup_cfg
+#endif
+
+#if defined(GENERIC_PT_KUNIT) && IS_ENABLED(CONFIG_AMD_IOMMU)
+#include <linux/io-pgtable.h>
+#include "../../amd/amd_iommu_types.h"
+
+static struct io_pgtable_ops *
+amdv1pt_iommu_alloc_io_pgtable(struct pt_iommu_amdv1_cfg *cfg,
+			       struct device *iommu_dev,
+			       struct io_pgtable_cfg **pgtbl_cfg)
+{
+	struct amd_io_pgtable *pgtable;
+	struct io_pgtable_ops *pgtbl_ops;
+
+	/*
+	 * AMD expects that io_pgtable_cfg is allocated to its type by the
+	 * caller.
+	 */
+	pgtable = kzalloc(sizeof(*pgtable), GFP_KERNEL);
+	if (!pgtable)
+		return NULL;
+
+	pgtable->iop.cfg.iommu_dev = iommu_dev;
+	pgtable->iop.cfg.amd.nid = NUMA_NO_NODE;
+	pgtbl_ops =
+		alloc_io_pgtable_ops(AMD_IOMMU_V1, &pgtable->iop.cfg, NULL);
+	if (!pgtbl_ops) {
+		kfree(pgtable);
+		return NULL;
+	}
+	*pgtbl_cfg = &pgtable->iop.cfg;
+	return pgtbl_ops;
+}
+#define pt_iommu_alloc_io_pgtable amdv1pt_iommu_alloc_io_pgtable
+
+static void amdv1pt_iommu_free_pgtbl_cfg(struct io_pgtable_cfg *pgtbl_cfg)
+{
+	struct amd_io_pgtable *pgtable =
+		container_of(pgtbl_cfg, struct amd_io_pgtable, iop.cfg);
+
+	kfree(pgtable);
+}
+#define pt_iommu_free_pgtbl_cfg amdv1pt_iommu_free_pgtbl_cfg
+
+static void amdv1pt_iommu_setup_ref_table(struct pt_iommu_amdv1 *iommu_table,
+					  struct io_pgtable_ops *pgtbl_ops)
+{
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(pgtbl_ops)->cfg;
+	struct amd_io_pgtable *pgtable =
+		container_of(pgtbl_cfg, struct amd_io_pgtable, iop.cfg);
+	struct pt_common *common = &iommu_table->amdpt.common;
+
+	pt_top_set(common, (struct pt_table_p *)pgtable->root,
+		   pgtable->mode - 1);
+	WARN_ON(pgtable->mode - 1 > PT_MAX_TOP_LEVEL || pgtable->mode <= 0);
+}
+#define pt_iommu_setup_ref_table amdv1pt_iommu_setup_ref_table
+
+static u64 amdv1pt_kunit_cmp_mask_entry(struct pt_state *pts)
+{
+	if (pts->type == PT_ENTRY_TABLE)
+		return pts->entry & (~(u64)(AMDV1PT_FMT_OA));
+	return pts->entry;
+}
+#define pt_kunit_cmp_mask_entry amdv1pt_kunit_cmp_mask_entry
+#endif
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/defs_amdv1.h b/drivers/iommu/generic_pt/fmt/defs_amdv1.h
new file mode 100644
index 00000000000000..a9d3b6216e7f30
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_amdv1.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_AMDV1_H
+#define __GENERIC_PT_FMT_DEFS_AMDV1_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct amdv1pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs amdv1pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_amdv1.c b/drivers/iommu/generic_pt/fmt/iommu_amdv1.c
new file mode 100644
index 00000000000000..81999511cc65da
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_amdv1.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT amdv1
+#define PT_SUPPORTED_FEATURES (BIT(PT_FEAT_FULL_VA) | BIT(PT_FEAT_DYNAMIC_TOP))
+#define PT_FORCE_FEATURES BIT(PT_FEAT_DYNAMIC_TOP)
+
+#include "iommu_template.h"
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 6c8296b1dd1a65..e8d489dff756a8 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -100,6 +100,10 @@ enum {
 	PT_FEAT_FMT_START,
 };
 
+struct pt_amdv1 {
+	struct pt_common common;
+};
+
 struct pt_armv8 {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 64af0043d127bc..bf139c5657fc06 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -204,6 +204,18 @@ static inline void pt_iommu_deinit(struct pt_iommu *iommu_table)
 	iommu_table->ops->deinit(iommu_table);
 }
 
+struct pt_iommu_amdv1 {
+	struct pt_iommu iommu;
+	struct pt_amdv1 amdpt;
+};
+
+struct pt_iommu_amdv1_cfg {
+	struct device *iommu_device;
+	unsigned int features;
+};
+int pt_iommu_amdv1_init(struct pt_iommu_amdv1 *table,
+			struct pt_iommu_amdv1_cfg *cfg, gfp_t gfp);
+
 struct pt_iommu_armv8 {
 	struct pt_iommu iommu;
 	struct pt_armv8 armpt;
-- 
2.46.0


