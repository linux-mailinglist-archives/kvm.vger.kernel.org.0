Return-Path: <kvm+bounces-24285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C2E9536C4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBAFB28A159
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7049E1B582B;
	Thu, 15 Aug 2024 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WbNq89Zn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D070F1AB53B
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734716; cv=fail; b=msQiCcZ/K3mgZ5B9rtvlpiluBrpfvjwXWpLA+OVrBcWzS7CF49abTaSoTxA7d8+nvW4wP/d1outb1XfBaK+lueyBCk3+q449XAomWcqMpVERCKQmYGzuaHGnrsBATjWRFCDvdXDU7tGJP6l4d0mgtD2R8kf0CiA0GENUpqYVFsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734716; c=relaxed/simple;
	bh=29uTBnoGpbyKMAiHRTrEGBS9z+5H1o4932xxCdaZ8PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tZuuDDVdLbqMlzxX9mM7LujA/RLHb3CJa21pImhyxVC8i/zZpnQNOrGTlhYzO926JHQYPVreDGWPUbdpZ8fnGdapsIJlU07CImb7oxaUp1BfSAmPPRProX6bWr882NOr1ZUd+iKPhdo41vaJvS3kXrQ7V5lYXgOBjTO2RxWbZZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WbNq89Zn; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BnQMH8Ny0qG8NrQFE8w+l5cOzpDGNMMuVFOlQ2ac3BPKTbs1iLNO+uxg1Zoz9IzGdUgoMZJILeMTrJz2pziMczHIhD5ep7XV4AnN/hAORGZbVeFiu7+LMNCcDAARwVVXYAh/CrAxTGh4zT3tnxpLluFBSWI06fp76Vnpq/0BzZ9CMTph9QDdesq0WE+HTyxMf60G1cyEI7XuUKp5PTGsoQDuL2rAsN4/vD/P4f4S8wzd7XuzcJEJuN9ho1Ti/Db0mTFMQDT+pXhmRQR9o0qvCGqjVS6T28ccSxLR605eBAlhfEHCeqxYpt2Mo32sYL96dSiRWpvuQi1Man46MusALg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1GCFF6HFre+Ch9IAI238a7zHyLUoZvwQXrRGegK8Qw=;
 b=rmxtqZZnORr+bDBDdTdfAm6C7vNCQYOCaTBMXqJSRCtR01t6NEcfz15rbP6KvQhWB1M0ymK85xogwQckXmpgWIz96yVkwkIdeZDDEMB6hH9WKyiHwm7r4CO/WxpcTx/siRepc7eNug2v+zLEfDrcB/BV43M0vFPmoqXBXY5bHm3qCLRWZ3GO1+NPiBrX0rg7jnFRTxgMu0R4vVZsgBt8fLGPV+TJPSt/iGKnCFDhMk5f7/FQOBkFBZ76kz+5kUu7YgarvLeH8sBcoxBHoeWnO6iVL3hIwL6SjQs3MO7G1qCeJ8bHrcsAUnqQITSXDk8F358qeSJ0AakPyDMaMWs9Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1GCFF6HFre+Ch9IAI238a7zHyLUoZvwQXrRGegK8Qw=;
 b=WbNq89ZnSqHqBEq0SYfGPjnAvA9zxdPq3p8Fm2PYmIMvCQinfy7uanF7yrPP1LHe3p9+ghk+fh0uGT+Gs8+YUurg2WogbxFyU8NP6qF9r/QMb48IWlxOsKHNJ8GS/IWYMTvc74caCslu2KLRMfmU5/fafwJI8Tx6vYI3Z6QhPWEVnPBC90lIspNiA14Izofw5yMvz9Nu8aXSol96hfaKiEoAfQhssPx6RtyC37tVJATFVhLFfDnFzWBu9gMYcK5YgxbqUEFCyPEwzQaOKw2a5Pj4vOtLfvPuTogpcmggVVj5Gn/7MG8TpR2x6P0L/Qnehc95OPBjcVk70FdqULOXjQ==
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
Subject: [PATCH 09/16] iommupt: Add a kunit test for Generic Page Table and the IOMMU implementation
Date: Thu, 15 Aug 2024 12:11:25 -0300
Message-ID: <9-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:208:236::24) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 5910d8ad-7cc9-4b40-ee2e-08dcbd3c8e2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W4h1IJ1GYFP3pWzVdBPoly1rF/y9rCHT1PFaXvykCaLp3Pe0pEdl2K8vt+AB?=
 =?us-ascii?Q?jXmLSJw/90cG8Fpkl0Qp6GetU4FLEHoV5vxh0bPzJIKpvCCPhi5eF0mdfyOm?=
 =?us-ascii?Q?u46NsXhdsgnmgFr0llsHyovH72wtet2v6fVww9rIYXfnLWOkT5VPrCBckWi1?=
 =?us-ascii?Q?GPY30ygnFPUt/ym2uMIOnflzj3OyqCwZOMjXNp1r43c2XYbb21yZEM5CH8oU?=
 =?us-ascii?Q?qQXtU7vtO3rv23eN9ZKfACXmw6ORj6uHi3LckJFDXBVmWac9a8ddNGd1e/he?=
 =?us-ascii?Q?i0Z6yulVDC6xz1uiMF3ozOzq8jXjbkMIT3RdN9VM0IzfzsDZf5naCuqHK+ZH?=
 =?us-ascii?Q?amYUMRdKzC84nAQaT3LrhKcKIu/ttSZggfKPD5TmUisIJ0+gvW+Kv8psbRuj?=
 =?us-ascii?Q?Tn2BQm2kJGe6pMFuoE5zfncxy8ALuvD38dp+/Jn0Wm5EvnV+L5x/q2VUy8uQ?=
 =?us-ascii?Q?GDnPZCO1ZGjNyn2LqiqiBJY0Mhk06qjz2tdt/XcSusOSZMy0tXPraQpEIcpC?=
 =?us-ascii?Q?rBuBJfwlFugBjCqZKtwJuFXANdIHys9db99hqgEaS+rtIoTAveTRb45AKjvd?=
 =?us-ascii?Q?R4SMV7wFaqXFEaBjDcNWFeMpCyrpNdUMoonv3iOO8yC5aj0MVu9qhlLzKlLe?=
 =?us-ascii?Q?witIQqw5RsYiCAAajkP0V6ABNPXSuTXL068XeOPw2n+qZhBaPVEpKlHIch/8?=
 =?us-ascii?Q?Z5PXcKgi2Z6GsWGGNMmd/ryAXhT8x5v3kQWq4HWCx4XEP8qA6e8Y+K1P7Vqw?=
 =?us-ascii?Q?VEgSgUILlOka7zFbuubmiEjP+wGWL9tvXGUEbzKhnMLYdyoG7Z7TetQ2AYhc?=
 =?us-ascii?Q?CvSf54qzswe/uLDvcIepGZB8K4N6XAUKg34WOZwazVLdRePg7UgMuRdOYf8Y?=
 =?us-ascii?Q?GdMTUMh3i1ihgPMU87VK5+mcmniy4t9ICGp5B5VZMDT9U3q/dKlJHm2wYPc8?=
 =?us-ascii?Q?03UzNEvhb5nwoyP3+UbbNK4QwOUq0aGq0qqEa3j5Xhs12kCpvkCgE8W5gvnY?=
 =?us-ascii?Q?zORwPBILPihclt3OiLkVQCaaXVrOUQT250gw7VmJFN5b+GkRNAtIfe3SoTwp?=
 =?us-ascii?Q?8G+eNqhyyp2ZYTZaMT7lCjxUgrFjzGSEi5OcSZp5Kk9y3xhwu527kk+efTzM?=
 =?us-ascii?Q?yOWj4fKP2k2ghNbXEg4Yg8yphpaGtCTx94Gw0Em239jOdPFml2a2Yb+AiaB8?=
 =?us-ascii?Q?WubvZ6gwvvU4wV9QrhkkVf+INDS30O1QdneEfTqBZapZ1c7mFVH7pgAUsSE7?=
 =?us-ascii?Q?QQvRggPgvmFfgstakvUajpNmCz0IU03pISfs1Ld3RBSFd6lcD+L3iXV6nM+k?=
 =?us-ascii?Q?RNUK/Idfdien+OrE8Fm2Wb+EnBPoWA0bSpPt0ptHMF6Zqg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tnWC1zPfctccvfTkiPC/F9GLpZdnaHrGZyrmK5ZKlVCkJZw3Un3C245gHu/k?=
 =?us-ascii?Q?HgmsNQujj9fbr6xYjHrhISoZ9qqXv15dHWXf1t7xTNFj1UsnJ25TPJ23KaEx?=
 =?us-ascii?Q?Onegm2Bl/7RPa9f4p/tXvI8rNFWRrUiX49WXlMn74pzYlGNywVYt4uPtNncp?=
 =?us-ascii?Q?odQfRvvzd6SxSxxmmCamDHN8nM0nVLN+kY5v6fdjZI6NUwYLlYCDJzYIpHdP?=
 =?us-ascii?Q?fKZ0LAiatyVPJp3UWs/hrgjFnAzebKfGn4RU3L88pgNZSdEY7okhsMJyPOxg?=
 =?us-ascii?Q?K4X3LxVH309pFC/Vn8p+INxi1/+9u5xIgsIVGB7wGoW/bP6uSLMAhAgZuUG+?=
 =?us-ascii?Q?se8b7HA6MjOUTJHwasRR7yjz3iysLGearAiSCI/W0HivOaBnRxi81qe7nauO?=
 =?us-ascii?Q?6NC2+p2MFB4Rb/L6Eo/NXr4/vHirm62IV+KGQ0Ksu2g968fk/qCVYv4NAi3t?=
 =?us-ascii?Q?5xAwKXToKLVJHCtuUTHTMRY7Dw71OAAylMP+klHyvTDVlxOlCMJjFuxH60JM?=
 =?us-ascii?Q?MinYAayg/ZyoatPWXHUHRR08bJ4J8LoF0Mg33SNgPVgy0qQByPUvolCEwURJ?=
 =?us-ascii?Q?yddT95MSGowRRspmjnQmrJMxJp2oIlmro2gDygRWQENtp5kg1sb+dhdCFZ+t?=
 =?us-ascii?Q?EO+ELbtXF/6pv/8E7UiAL4V9+ZXPTBRcYYR22vS/01fVNojmOWYL8qjTfQqc?=
 =?us-ascii?Q?Q5/E3Z4hjSIdT9HCBK0E29sDfkUuFjZCaXCJuRgilcHfOtqSwUu3MjwexRiS?=
 =?us-ascii?Q?pbPKBOlEXRtVxBfkWRjkkzps0w4jGfXQDxylgrJkjpcnZ9i6/K/0LQ3oDhXm?=
 =?us-ascii?Q?j+W9WXt1pGFs9SF9ve3GtPrRzog8jYVHITH53OJsWIuG8SkIRDPm2OP6R1p8?=
 =?us-ascii?Q?tJ0/Z5nr9NaG0APPCQ9lUN6lL2K7V/qqULoxeGznnhcjhhJCUHB9Ao4apqEy?=
 =?us-ascii?Q?WF6/MGUldiuXURP33KloFeJbwV2V7p1u1X8y/4TqEGyS5zc3Gki1yoh+i/IE?=
 =?us-ascii?Q?6juZLF9Trb6nMZx0B53Sy4iih4S4ubQfA48LOCrCbb9GoTnZRZGZCy9zZug0?=
 =?us-ascii?Q?tVkUkYCpmy799/7AoTXZzt18s+gQXljsTUxQ7aqLMCldQvctn/ugjun/zHj6?=
 =?us-ascii?Q?mX2HEg0lB8wfhWjevBqBDiAqqLGG5fk+aTuncP9oCI1UNDxn6R7X71oklqvz?=
 =?us-ascii?Q?Vb58IIasP7cVycKfwoMaSCo1r1IFAujk0yEZ7LT1mKWOrfoDhfyPOfaJgm8M?=
 =?us-ascii?Q?cXT/0NvpBwW+MYW7sPva2jaAjtPXEvzLxXDn0Bc2yOLG72prWyum8JQukVWy?=
 =?us-ascii?Q?rkXdtvqFiaL4KgU1Q2g9BQmEI7tUN0YBMjbBceuqaVr3/whbLdAYgXrgRt1o?=
 =?us-ascii?Q?wgUoDYs87Cp41ZV0olNySEy5RATuVxbavzf5VnRz4Ssw0Y3QNCova/S1KcxQ?=
 =?us-ascii?Q?nsS5GqgvhlpUfGAHbwZAdaC2Dxl3lKXhWx+RDrHil70/qVFMr61SShDsdOL5?=
 =?us-ascii?Q?Du3QwOiP1XkFK/2N5/5zN2VU0WnpVFwaZLUAdqr8FgudK6X+co1CPLT+Zp4n?=
 =?us-ascii?Q?HFHXv5GLvuu+GFgj0p4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5910d8ad-7cc9-4b40-ee2e-08dcbd3c8e2c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:36.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/1/I74sF33HJAmM8qYkXbMMAiGd1pAQjNKfoPPNAnC7vwEq5OcqZ69HBM65dA2L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631

This intends to have high coverage of the page table format functions and
the IOMMU implementation itself, exercising the various corner cases.

The kunit can be run in the kunit framework, using commands like:

tools/testing/kunit/kunit.py run --build_dir build_kunit_arm64 --arch arm64 --make_options LD=ld.lld-18  --make_options 'CC=clang-18 --target=aarch64-linux-gnu' --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig
tools/testing/kunit/kunit.py run --build_dir build_kunit_uml --make_options CC=gcc-13 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig --kconfig_add CONFIG_WERROR=n
tools/testing/kunit/kunit.py run --build_dir build_kunit_x86_64 --arch x86_64 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig
tools/testing/kunit/kunit.py run --build_dir build_kunit_i386 --arch i386 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig
tools/testing/kunit/kunit.py run --build_dir build_kunit_i386pae --arch i386 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig --kconfig_add CONFIG_X86_PAE=y

There are several interesting corner cases on the 32 bit platforms that
need checking.

FIXME: further improve the tests

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig         |  13 +
 drivers/iommu/generic_pt/Kconfig              |   7 +
 drivers/iommu/generic_pt/Makefile             |   2 +
 drivers/iommu/generic_pt/fmt/Makefile         |  21 +
 drivers/iommu/generic_pt/fmt/iommu_template.h |   9 +
 drivers/iommu/generic_pt/kunit_generic_pt.h   | 576 ++++++++++++++++++
 drivers/iommu/generic_pt/kunit_iommu.h        | 105 ++++
 drivers/iommu/generic_pt/kunit_iommu_pt.h     | 352 +++++++++++
 8 files changed, 1085 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/.kunitconfig
 create mode 100644 drivers/iommu/generic_pt/fmt/Makefile
 create mode 100644 drivers/iommu/generic_pt/kunit_generic_pt.h
 create mode 100644 drivers/iommu/generic_pt/kunit_iommu.h
 create mode 100644 drivers/iommu/generic_pt/kunit_iommu_pt.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
new file mode 100644
index 00000000000000..f428cae8ce584c
--- /dev/null
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -0,0 +1,13 @@
+CONFIG_KUNIT=y
+CONFIG_GENERIC_PT=y
+CONFIG_DEBUG_GENERIC_PT=y
+CONFIG_IOMMU_PT=y
+CONFIG_IOMMU_PT_AMDV1=y
+CONFIG_IOMMU_PT_ARMV7S=y
+CONFIG_IOMMU_PT_ARMV8_4K=y
+CONFIG_IOMMU_PT_ARMV8_16K=y
+CONFIG_IOMMU_PT_ARMV8_64K=y
+CONFIG_IOMMU_PT_DART=y
+CONFIG_IOMMU_PT_VTDSS=y
+CONFIG_IOMMU_PT_X86PAE=y
+CONFIG_IOMMUT_PT_KUNIT_TEST=y
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index c22a55b00784d0..2c5c2bc59bf8ea 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -27,4 +27,11 @@ config IOMMU_PT
 	default n
 	help
 	  Generic library for building IOMMU page tables
+
+if IOMMU_PT
+config IOMMUT_PT_KUNIT_TEST
+	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+endif
 endif
diff --git a/drivers/iommu/generic_pt/Makefile b/drivers/iommu/generic_pt/Makefile
index f7862499642237..2c9f23551b9f6f 100644
--- a/drivers/iommu/generic_pt/Makefile
+++ b/drivers/iommu/generic_pt/Makefile
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-y += fmt/
+
 iommu_pt-y := \
 	pt_alloc.o
 
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
new file mode 100644
index 00000000000000..0c35b9ae4dfb34
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0
+
+IOMMU_PT_KUNIT_TEST :=
+define create_format
+obj-$(2) += iommu_$(1).o
+iommu_pt_kunit_test-y += kunit_iommu_$(1).o
+CFLAGS_kunit_iommu_$(1).o += -DGENERIC_PT_KUNIT=1
+IOMMU_PT_KUNIT_TEST := iommu_pt_kunit_test.o
+
+endef
+
+$(eval $(foreach fmt,$(iommu_pt_fmt-y),$(call create_format,$(fmt),y)))
+$(eval $(foreach fmt,$(iommu_pt_fmt-m),$(call create_format,$(fmt),m)))
+
+# The kunit objects are constructed by compiling the main source
+# with -DGENERIC_PT_KUNIT
+$(obj)/kunit_iommu_%.o: $(src)/iommu_%.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)
+
+obj-$(CONFIG_IOMMUT_PT_KUNIT_TEST) += $(IOMMU_PT_KUNIT_TEST)
diff --git a/drivers/iommu/generic_pt/fmt/iommu_template.h b/drivers/iommu/generic_pt/fmt/iommu_template.h
index d6ca1582e11ca4..809f4ce6874591 100644
--- a/drivers/iommu/generic_pt/fmt/iommu_template.h
+++ b/drivers/iommu/generic_pt/fmt/iommu_template.h
@@ -34,4 +34,13 @@
 #include PT_FMT_H
 #include "../pt_common.h"
 
+#ifndef GENERIC_PT_KUNIT
 #include "../iommu_pt.h"
+#else
+/*
+ * The makefile will compile the .c file twice, once with GENERIC_PT_KUNIT set
+ * which means we are building the kunit modle.
+ */
+#include "../kunit_generic_pt.h"
+#include "../kunit_iommu_pt.h"
+#endif
diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/generic_pt/kunit_generic_pt.h
new file mode 100644
index 00000000000000..dad13ac4b6d14f
--- /dev/null
+++ b/drivers/iommu/generic_pt/kunit_generic_pt.h
@@ -0,0 +1,576 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Test the format API directly.
+ *
+ */
+#include "kunit_iommu.h"
+#include "pt_iter.h"
+
+/* FIXME */
+static void do_map(struct kunit *test, pt_vaddr_t va, pt_oaddr_t pa,
+		   pt_vaddr_t len);
+
+#define KUNIT_ASSERT_PT_LOAD(kunit, pts, entry)            \
+	({                                                 \
+		pt_load_entry(pts);                        \
+		KUNIT_ASSERT_EQ(test, (pts)->type, entry); \
+	})
+
+struct check_levels_arg {
+	struct kunit *test;
+	void *fn_arg;
+	void (*fn)(struct kunit *test, struct pt_state *pts, void *arg);
+};
+
+static int __check_all_levels(struct pt_range *range, void *arg,
+			      unsigned int level, struct pt_table_p *table)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	struct check_levels_arg *chk = arg;
+	struct kunit *test = chk->test;
+	int ret;
+
+	// FIXME check that the index is max
+	if (pt_can_have_table(&pts)) {
+		pt_load_single_entry(&pts);
+		KUNIT_ASSERT_EQ(test, pts.type, PT_ENTRY_TABLE);
+		ret = pt_descend(&pts, arg, __check_all_levels);
+		KUNIT_ASSERT_EQ(test, ret, 0);
+
+		/* Index 0 is used by the test */
+		if (IS_32BIT && !pts.index)
+			return 0;
+		KUNIT_ASSERT_NE(chk->test, pts.index, 0);
+	}
+
+	/*
+	 * A format should not create a table with only one entry, at least this
+	 * test approach won't work.
+	 */
+	KUNIT_ASSERT_NE(chk->test, pt_num_items_lg2(&pts), ilog2(1));
+
+	pts.index = 0;
+	pt_index_to_va(&pts);
+	(*chk->fn)(chk->test, &pts, chk->fn_arg);
+	return 0;
+}
+
+/*
+ * Call fn for each level in the table with a pts setup to index 0 in a table
+ * for that level. This allows writing tests that run on every level.
+ * The test can use every index in the table except the last one.
+ */
+static void check_all_levels(struct kunit *test,
+			     void (*fn)(struct kunit *test,
+					struct pt_state *pts, void *arg),
+			     void *fn_arg)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	struct pt_range range = pt_top_range(priv->common);
+	struct check_levels_arg chk = {
+		.test = test,
+		.fn = fn,
+		.fn_arg = fn_arg,
+	};
+	int ret;
+
+	/*
+	 * Map a page at the highest VA, this will populate all the levels so we
+	 * can then iterate over them. Index 0 will be used for testing.
+	 */
+	if (IS_32BIT && range.max_vasz_lg2 > 32)
+		range.last_va = (u32)range.last_va;
+	range.va = range.last_va - (priv->smallest_pgsz - 1);
+
+	do_map(test, range.va, 0, priv->smallest_pgsz);
+	ret = pt_walk_range(&range, __check_all_levels, &chk);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+}
+
+static void test_init(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+
+	/* Fixture does the setup */
+	KUNIT_ASSERT_NE(test, priv->info.pgsize_bitmap, 0);
+}
+
+static void test_bitops(struct kunit *test)
+{
+	int i;
+
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u32, 0), 0);
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u32, 1), 1);
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u32, BIT(2)), 3);
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u32, U32_MAX), 32);
+
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u64, 0), 0);
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u64, 1), 1);
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u64, BIT(2)), 3);
+	KUNIT_ASSERT_EQ(test, log2_fls_t(u64, U64_MAX), 64);
+
+	KUNIT_ASSERT_EQ(test, log2_ffs_t(u32, 1), 0);
+	KUNIT_ASSERT_EQ(test, log2_ffs_t(u32, BIT(2)), 2);
+	KUNIT_ASSERT_EQ(test, log2_ffs_t(u32, BIT(31)), 31);
+
+	KUNIT_ASSERT_EQ(test, log2_ffs_t(u64, 1), 0);
+	KUNIT_ASSERT_EQ(test, log2_ffs_t(u64, BIT(2)), 2);
+	KUNIT_ASSERT_EQ(test, log2_ffs_t(u64, BIT_ULL(63)), 63);
+
+	for (i = 0; i != 31; i++)
+		KUNIT_ASSERT_EQ(test, log2_ffz_t(u64, BIT_ULL(i) - 1), i);
+
+	for (i = 0; i != 63; i++)
+		KUNIT_ASSERT_EQ(test, log2_ffz_t(u64, BIT_ULL(i) - 1), i);
+
+	for (i = 0; i != 32; i++) {
+		u64 val = get_random_u64();
+
+		KUNIT_ASSERT_EQ(test,
+				log2_mod_t(u32, val, log2_ffs_t(u32, val)), 0);
+		KUNIT_ASSERT_EQ(test,
+				log2_mod_t(u64, val, log2_ffs_t(u64, val)), 0);
+
+		KUNIT_ASSERT_EQ(test,
+				log2_mod_t(u32, val, log2_ffz_t(u32, val)),
+				log2_to_max_int_t(u32, log2_ffz_t(u32, val)));
+		KUNIT_ASSERT_EQ(test,
+				log2_mod_t(u64, val, log2_ffz_t(u64, val)),
+				log2_to_max_int_t(u64, log2_ffz_t(u64, val)));
+	}
+}
+
+static unsigned int ref_best_pgsize(pt_vaddr_t pgsz_bitmap, pt_vaddr_t va,
+				    pt_vaddr_t last_va, pt_oaddr_t oa)
+{
+	pt_vaddr_t pgsz_lg2;
+
+	/* Brute force the constraints described in __pt_compute_best_pgsize() */
+	for (pgsz_lg2 = PT_VADDR_MAX_LG2 - 1; pgsz_lg2 != 0; pgsz_lg2--) {
+		if ((pgsz_bitmap & log2_to_int(pgsz_lg2)) &&
+		    log2_mod(va, pgsz_lg2) == 0 &&
+		    oalog2_mod(oa, pgsz_lg2) == 0 &&
+		    va + log2_to_int(pgsz_lg2) - 1 <= last_va &&
+		    log2_div_eq(va, va + log2_to_int(pgsz_lg2) - 1, pgsz_lg2) &&
+		    oalog2_div_eq(oa, oa + log2_to_int(pgsz_lg2) - 1, pgsz_lg2))
+			return pgsz_lg2;
+	}
+	return 0;
+}
+
+/* Check that the bit logic in __pt_compute_best_pgsize() works. */
+static void test_best_pgsize(struct kunit *test)
+{
+	unsigned int a_lg2;
+	unsigned int b_lg2;
+	unsigned int c_lg2;
+
+	/* Try random prefixes with every suffix combination */
+	for (a_lg2 = 1; a_lg2 != 10; a_lg2++) {
+		for (b_lg2 = 1; b_lg2 != 10; b_lg2++) {
+			for (c_lg2 = 1; c_lg2 != 10; c_lg2++) {
+				pt_vaddr_t pgsz_bitmap = get_random_u64();
+				pt_vaddr_t va = get_random_u64() << a_lg2;
+				pt_oaddr_t oa = get_random_u64() << b_lg2;
+				pt_vaddr_t last_va = log2_set_mod_max(
+					get_random_u64(), c_lg2);
+
+				if (va > last_va)
+					swap(va, last_va);
+				KUNIT_ASSERT_EQ(test,
+						__pt_compute_best_pgsize(
+							pgsz_bitmap, va,
+							last_va, oa),
+						ref_best_pgsize(pgsz_bitmap, va,
+								last_va, oa));
+			}
+		}
+	}
+
+	/* 0 prefix, every suffix */
+	for (c_lg2 = 1; c_lg2 != PT_VADDR_MAX_LG2 - 1; c_lg2++) {
+		pt_vaddr_t pgsz_bitmap = get_random_u64();
+		pt_vaddr_t va = 0;
+		pt_oaddr_t oa = 0;
+		pt_vaddr_t last_va = log2_set_mod_max(0, c_lg2);
+
+		KUNIT_ASSERT_EQ(test,
+				__pt_compute_best_pgsize(pgsz_bitmap, va,
+							 last_va, oa),
+				ref_best_pgsize(pgsz_bitmap, va, last_va, oa));
+	}
+
+	/* 1's prefix, every suffix */
+	for (a_lg2 = 1; a_lg2 != 10; a_lg2++) {
+		for (b_lg2 = 1; b_lg2 != 10; b_lg2++) {
+			for (c_lg2 = 1; c_lg2 != 10; c_lg2++) {
+				pt_vaddr_t pgsz_bitmap = get_random_u64();
+				pt_vaddr_t va = PT_VADDR_MAX << a_lg2;
+				pt_oaddr_t oa = PT_VADDR_MAX << b_lg2;
+				pt_vaddr_t last_va = PT_VADDR_MAX;
+
+				KUNIT_ASSERT_EQ(test,
+						__pt_compute_best_pgsize(
+							pgsz_bitmap, va,
+							last_va, oa),
+						ref_best_pgsize(pgsz_bitmap, va,
+								last_va, oa));
+			}
+		}
+	}
+
+	/* pgsize_bitmap is always 0 */
+	for (a_lg2 = 1; a_lg2 != 10; a_lg2++) {
+		for (b_lg2 = 1; b_lg2 != 10; b_lg2++) {
+			for (c_lg2 = 1; c_lg2 != 10; c_lg2++) {
+				pt_vaddr_t pgsz_bitmap = 0;
+				pt_vaddr_t va = get_random_u64() << a_lg2;
+				pt_oaddr_t oa = get_random_u64() << b_lg2;
+				pt_vaddr_t last_va = log2_set_mod_max(
+					get_random_u64(), c_lg2);
+
+				if (va > last_va)
+					swap(va, last_va);
+				KUNIT_ASSERT_EQ(test,
+						__pt_compute_best_pgsize(
+							pgsz_bitmap, va,
+							last_va, oa),
+						0);
+			}
+		}
+	}
+
+	if (sizeof(pt_vaddr_t) <= 4)
+		return;
+
+	/* over 32 bit page sizes */
+	for (a_lg2 = 32; a_lg2 != 42; a_lg2++) {
+		for (b_lg2 = 32; b_lg2 != 42; b_lg2++) {
+			for (c_lg2 = 32; c_lg2 != 42; c_lg2++) {
+				pt_vaddr_t pgsz_bitmap = get_random_u64();
+				pt_vaddr_t va = get_random_u64() << a_lg2;
+				pt_oaddr_t oa = get_random_u64() << b_lg2;
+				pt_vaddr_t last_va = log2_set_mod_max(
+					get_random_u64(), c_lg2);
+
+				if (va > last_va)
+					swap(va, last_va);
+				KUNIT_ASSERT_EQ(test,
+						__pt_compute_best_pgsize(
+							pgsz_bitmap, va,
+							last_va, oa),
+						ref_best_pgsize(pgsz_bitmap, va,
+								last_va, oa));
+			}
+		}
+	}
+}
+
+/*
+ * Check that pt_install_table() and pt_table_pa() match
+ */
+static void test_lvl_table_ptr(struct kunit *test, struct pt_state *pts,
+			       void *arg)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	pt_oaddr_t paddr =
+		log2_set_mod(priv->test_oa, 0, priv->smallest_pgsz_lg2);
+	struct pt_write_attrs attrs = {};
+
+	if (!pt_can_have_table(pts))
+		return;
+
+	KUNIT_ASSERT_NO_ERRNO_FN(test, "pt_iommu_set_prot",
+				 pt_iommu_set_prot(pts->range->common, &attrs,
+						   IOMMU_READ));
+
+	KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_EMPTY);
+
+	KUNIT_ASSERT_TRUE(test, pt_install_table(pts, paddr, &attrs));
+
+	/*
+	 * A second install should fail because install does not update
+	 * pts->entry. So the expected entry is empty but the above installed,
+	 * this we must fail with a cmxchg collision.
+	 */
+	KUNIT_ASSERT_EQ(test, pt_install_table(pts, paddr, &attrs), false);
+
+	KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_TABLE);
+	KUNIT_ASSERT_EQ(test, pt_table_pa(pts), paddr);
+
+	pt_clear_entry(pts, ilog2(1));
+	KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_EMPTY);
+}
+
+static void test_table_ptr(struct kunit *test)
+{
+	check_all_levels(test, test_lvl_table_ptr, NULL);
+}
+
+struct lvl_radix_arg {
+	pt_vaddr_t vbits;
+};
+
+/*
+ * Check pt_num_items_lg2(), pt_table_item_lg2sz(), and amdv1pt_va_lg2sz()
+ * they need to decode a continuous list of VA across all the levels that
+ * covers the entire advertised VA space.
+ */
+static void test_lvl_radix(struct kunit *test, struct pt_state *pts, void *arg)
+{
+	unsigned int table_lg2sz = pt_table_oa_lg2sz(pts);
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	struct lvl_radix_arg *radix = arg;
+
+	/* Every bit below us is decoded */
+	KUNIT_ASSERT_EQ(test, log2_set_mod_max(0, isz_lg2), radix->vbits);
+
+	/* We are not decoding bits someone else is */
+	KUNIT_ASSERT_EQ(test, log2_div(radix->vbits, isz_lg2), 0);
+
+	/* Can't decode past the pt_vaddr_t size */
+	KUNIT_ASSERT_LE(test, table_lg2sz, PT_VADDR_MAX_LG2);
+
+	radix->vbits = fvalog2_set_mod_max(0, table_lg2sz);
+}
+
+static void test_table_radix(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	struct lvl_radix_arg radix = { .vbits = priv->smallest_pgsz - 1 };
+	struct pt_range range = pt_top_range(priv->common);
+
+	check_all_levels(test, test_lvl_radix, &radix);
+
+	if (range.max_vasz_lg2 == PT_VADDR_MAX_LG2) {
+		KUNIT_ASSERT_EQ(test, radix.vbits, PT_VADDR_MAX);
+	} else {
+		if (!IS_32BIT)
+			KUNIT_ASSERT_EQ(test,
+					log2_set_mod_max(0, range.max_vasz_lg2),
+					radix.vbits);
+		KUNIT_ASSERT_EQ(test, log2_div(radix.vbits, range.max_vasz_lg2),
+				0);
+	}
+}
+
+static void test_lvl_possible_sizes(struct kunit *test, struct pt_state *pts,
+				    void *arg)
+{
+	unsigned int num_entries_lg2 = pt_num_items_lg2(pts);
+	pt_vaddr_t pgsize_bitmap = pt_possible_sizes(pts);
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+
+	if (!pt_can_have_leaf(pts)) {
+		KUNIT_ASSERT_EQ(test, pgsize_bitmap, 0);
+		return;
+	}
+
+	/* No bits for sizes that would be outside this table */
+	KUNIT_ASSERT_EQ(test, log2_mod(pgsize_bitmap, isz_lg2), 0);
+	if (num_entries_lg2 + isz_lg2 != PT_VADDR_MAX_LG2)
+		KUNIT_ASSERT_EQ(
+			test,
+			log2_div(pgsize_bitmap, num_entries_lg2 + isz_lg2), 0);
+
+	/* Non contiguous must be supported */
+	KUNIT_ASSERT_TRUE(test, pgsize_bitmap & log2_to_int(isz_lg2));
+
+	/* A contiguous entry should not span the whole table */
+	if (num_entries_lg2 + isz_lg2 != PT_VADDR_MAX_LG2)
+		KUNIT_ASSERT_FALSE(
+			test,
+			pgsize_bitmap & log2_to_int(num_entries_lg2 + isz_lg2));
+}
+
+static void test_entry_possible_sizes(struct kunit *test)
+{
+	check_all_levels(test, test_lvl_possible_sizes, NULL);
+}
+
+static void sweep_all_pgsizes(struct kunit *test, struct pt_state *pts,
+			      struct pt_write_attrs *attrs,
+			      pt_oaddr_t test_oaddr)
+{
+	pt_vaddr_t pgsize_bitmap = pt_possible_sizes(pts);
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	unsigned int len_lg2;
+
+	for (len_lg2 = 0; len_lg2 < PT_VADDR_MAX_LG2 - 1; len_lg2++) {
+		struct pt_state sub_pts = *pts;
+		pt_oaddr_t oaddr;
+
+		if (!(pgsize_bitmap & log2_to_int(len_lg2)))
+			continue;
+
+		oaddr = log2_set_mod(test_oaddr, 0, len_lg2);
+		pt_install_leaf_entry(pts, oaddr, len_lg2, attrs);
+		/* Verify that every contiguous item translates correctly */
+		for (sub_pts.index = 0;
+		     sub_pts.index != log2_to_int(len_lg2 - isz_lg2);
+		     sub_pts.index++) {
+			KUNIT_ASSERT_PT_LOAD(test, &sub_pts, PT_ENTRY_OA);
+			KUNIT_ASSERT_EQ(test, pt_item_oa(&sub_pts),
+					oaddr + sub_pts.index *
+							oalog2_mul(1, isz_lg2));
+			KUNIT_ASSERT_EQ(test, pt_entry_oa(&sub_pts), oaddr);
+			KUNIT_ASSERT_EQ(test, pt_entry_num_contig_lg2(&sub_pts),
+					len_lg2 - isz_lg2);
+		}
+
+		pt_clear_entry(pts, len_lg2 - isz_lg2);
+		KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_EMPTY);
+	}
+}
+
+/*
+ * Check that pt_install_leaf_entry() and pt_entry_oa() match.
+ * Check that pt_clear_entry() works.
+ */
+static void test_lvl_entry_oa(struct kunit *test, struct pt_state *pts,
+			      void *arg)
+{
+	unsigned int max_oa_lg2 = pts->range->common->max_oasz_lg2;
+	struct kunit_iommu_priv *priv = test->priv;
+	struct pt_write_attrs attrs = {};
+
+	if (!pt_can_have_leaf(pts))
+		return;
+
+	KUNIT_ASSERT_NO_ERRNO_FN(test, "pt_iommu_set_prot",
+				 pt_iommu_set_prot(pts->range->common, &attrs,
+						   IOMMU_READ));
+
+	sweep_all_pgsizes(test, pts, &attrs, priv->test_oa);
+
+	/* Check that the table can store the boundary OAs */
+	sweep_all_pgsizes(test, pts, &attrs, 0);
+	if (max_oa_lg2 == PT_OADDR_MAX_LG2)
+		sweep_all_pgsizes(test, pts, &attrs, PT_OADDR_MAX);
+	else
+		sweep_all_pgsizes(test, pts, &attrs,
+				  oalog2_to_max_int(max_oa_lg2));
+}
+
+static void test_entry_oa(struct kunit *test)
+{
+	check_all_levels(test, test_lvl_entry_oa, NULL);
+}
+
+/* Test pt_attr_from_entry() */
+static void test_lvl_attr_from_entry(struct kunit *test, struct pt_state *pts,
+				     void *arg)
+{
+	pt_vaddr_t pgsize_bitmap = pt_possible_sizes(pts);
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	struct kunit_iommu_priv *priv = test->priv;
+	unsigned int len_lg2;
+	unsigned int prot;
+
+	if (!pt_can_have_leaf(pts))
+		return;
+
+	for (len_lg2 = 0; len_lg2 < PT_VADDR_MAX_LG2; len_lg2++) {
+		if (!(pgsize_bitmap & log2_to_int(len_lg2)))
+			continue;
+		for (prot = 0; prot <= (IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE |
+					IOMMU_NOEXEC | IOMMU_MMIO);
+		     prot++) {
+			pt_oaddr_t oaddr;
+			struct pt_write_attrs attrs = {};
+			u64 good_entry;
+
+			/*
+			 * If the format doesn't support this combination of
+			 * prot bits skip it
+			 */
+			if (pt_iommu_set_prot(pts->range->common, &attrs,
+					      prot)) {
+				/* But RW has to be supported */
+				KUNIT_ASSERT_NE(test, prot,
+						IOMMU_READ | IOMMU_WRITE);
+				continue;
+			}
+
+			oaddr = log2_set_mod(priv->test_oa, 0, len_lg2);
+			pt_install_leaf_entry(pts, oaddr, len_lg2, &attrs);
+			KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_OA);
+
+			good_entry = pts->entry;
+
+			memset(&attrs, 0, sizeof(attrs));
+			pt_attr_from_entry(pts, &attrs);
+
+			pt_clear_entry(pts, len_lg2 - isz_lg2);
+			KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_EMPTY);
+
+			pt_install_leaf_entry(pts, oaddr, len_lg2, &attrs);
+			KUNIT_ASSERT_PT_LOAD(test, pts, PT_ENTRY_OA);
+
+			/*
+			 * The descriptor produced by pt_attr_from_entry()
+			 * produce an identical entry value when re-written
+			 */
+			KUNIT_ASSERT_EQ(test, good_entry, pts->entry);
+
+			pt_clear_entry(pts, len_lg2 - isz_lg2);
+		}
+	}
+}
+
+static void test_attr_from_entry(struct kunit *test)
+{
+	check_all_levels(test, test_lvl_attr_from_entry, NULL);
+}
+
+/* FIXME possible sizes can not return values outside the OA mask? */
+
+static struct kunit_case generic_pt_test_cases[] = {
+	KUNIT_CASE(test_init),
+	KUNIT_CASE(test_bitops),
+	KUNIT_CASE(test_best_pgsize),
+	KUNIT_CASE(test_table_ptr),
+	KUNIT_CASE(test_table_radix),
+	KUNIT_CASE(test_entry_possible_sizes),
+	KUNIT_CASE(test_entry_oa),
+	KUNIT_CASE(test_attr_from_entry),
+	{},
+};
+
+static int pt_kunit_generic_pt_init(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv;
+	int ret;
+
+	test->priv = priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	ret = pt_kunit_priv_init(priv);
+	if (ret) {
+		kfree(test->priv);
+		test->priv = NULL;
+		return ret;
+	}
+	return 0;
+}
+
+static void pt_kunit_generic_pt_exit(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+
+	if (!test->priv)
+		return;
+
+	pt_iommu_deinit(priv->iommu);
+	kfree(test->priv);
+}
+
+static struct kunit_suite NS(generic_pt_suite) = {
+	.name = __stringify(NS(fmt_test)),
+	.init = pt_kunit_generic_pt_init,
+	.exit = pt_kunit_generic_pt_exit,
+	.test_cases = generic_pt_test_cases,
+};
+kunit_test_suites(&NS(generic_pt_suite));
diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
new file mode 100644
index 00000000000000..e0adea69596858
--- /dev/null
+++ b/drivers/iommu/generic_pt/kunit_iommu.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#ifndef __GENERIC_PT_KUNIT_IOMMU_H
+#define __GENERIC_PT_KUNIT_IOMMU_H
+
+#define GENERIC_PT_KUNIT 1
+#include <kunit/test.h>
+#include "pt_common.h"
+
+#define pt_iommu_table_cfg CONCATENATE(pt_iommu_table, _cfg)
+#define pt_iommu_init CONCATENATE(CONCATENATE(pt_iommu_, PTPFX), init)
+int pt_iommu_init(struct pt_iommu_table *fmt_table,
+		  struct pt_iommu_table_cfg *cfg, gfp_t gfp);
+
+#ifndef pt_kunit_setup_cfg
+#define pt_kunit_setup_cfg(cfg)
+#endif
+
+#ifndef pt_iommu_free_pgtbl_cfg
+#define pt_iommu_free_pgtbl_cfg(cfg)
+#endif
+
+#define KUNIT_ASSERT_NO_ERRNO(test, ret)                                       \
+	KUNIT_ASSERT_EQ_MSG(test, ret, 0, KUNIT_SUBSUBTEST_INDENT "errno %pe", \
+			    ERR_PTR(ret))
+
+#define KUNIT_ASSERT_NO_ERRNO_FN(test, fn, ret)                          \
+	KUNIT_ASSERT_EQ_MSG(test, ret, 0,                                \
+			    KUNIT_SUBSUBTEST_INDENT "errno %pe from %s", \
+			    ERR_PTR(ret), fn)
+
+/*
+ * When the test is run on a 32 bit system dma_addr_t can be 32 bits. This cause
+ * the iommu op signatures to be restricted to 32 bits. Meaning the test has to
+ * be mindful not to create any VA's over the 32 bit limit. Reduce the scope of
+ * the testing as the main purpose of checking on full 32 bit is to look for
+ * 32bitism in the core code. Run the test on i386 with X86_PAE=y to get the
+ * full coverage.
+ */
+#define IS_32BIT (sizeof(dma_addr_t) == 4)
+
+struct kunit_iommu_priv {
+	struct pt_iommu_table fmt_table;
+	struct device dummy_dev;
+	struct pt_iommu *iommu;
+	struct pt_common *common;
+	struct pt_iommu_table_cfg cfg;
+	struct pt_iommu_info info;
+	unsigned int smallest_pgsz_lg2;
+	pt_vaddr_t smallest_pgsz;
+	unsigned int largest_pgsz_lg2;
+	pt_oaddr_t test_oa;
+	pt_vaddr_t safe_pgsize_bitmap;
+};
+
+static int pt_kunit_priv_init(struct kunit_iommu_priv *priv)
+{
+	unsigned int va_lg2sz;
+	int ret;
+
+	/* Enough so the memory allocator works */
+	set_dev_node(&priv->dummy_dev, NUMA_NO_NODE);
+	priv->cfg.iommu_device = &priv->dummy_dev;
+	priv->cfg.features = PT_SUPPORTED_FEATURES &
+			     ~BIT(PT_FEAT_DMA_INCOHERENT);
+
+	pt_kunit_setup_cfg(&priv->cfg);
+	ret = pt_iommu_init(&priv->fmt_table, &priv->cfg, GFP_KERNEL);
+	if (ret)
+		return ret;
+	priv->iommu = &priv->fmt_table.iommu;
+	priv->common = common_from_iommu(&priv->fmt_table.iommu);
+
+	priv->iommu->ops->get_info(priv->iommu, &priv->info);
+
+	/*
+	 * size_t is used to pass the mapping length, it can be 32 bit, truncate
+	 * the pagesizes so we don't use large sizes.
+	 */
+	priv->info.pgsize_bitmap = (size_t)priv->info.pgsize_bitmap;
+
+	priv->smallest_pgsz_lg2 = log2_ffs(priv->info.pgsize_bitmap);
+	priv->smallest_pgsz = log2_to_int(priv->smallest_pgsz_lg2);
+	priv->largest_pgsz_lg2 =
+		log2_fls((dma_addr_t)priv->info.pgsize_bitmap) - 1;
+
+	priv->test_oa = oalog2_mod(0x74a71445deadbeef,
+				   pt_max_output_address_lg2(priv->common));
+
+	/*
+	 * We run out of VA space if the mappings get too big, make something
+	 * smaller that can safely pass throug dma_addr_t API.
+	 */
+	va_lg2sz = priv->common->max_vasz_lg2;
+	if (IS_32BIT && va_lg2sz > 32)
+		va_lg2sz = 32;
+	priv->safe_pgsize_bitmap =
+		log2_mod(priv->info.pgsize_bitmap, va_lg2sz - 1);
+
+	return 0;
+}
+
+#endif
diff --git a/drivers/iommu/generic_pt/kunit_iommu_pt.h b/drivers/iommu/generic_pt/kunit_iommu_pt.h
new file mode 100644
index 00000000000000..047ef240d067ff
--- /dev/null
+++ b/drivers/iommu/generic_pt/kunit_iommu_pt.h
@@ -0,0 +1,352 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#include "kunit_iommu.h"
+#include "pt_iter.h"
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+static unsigned int next_smallest_pgsz_lg2(struct kunit_iommu_priv *priv,
+					   unsigned int pgsz_lg2)
+{
+	WARN_ON(!(priv->info.pgsize_bitmap & log2_to_int(pgsz_lg2)));
+	pgsz_lg2--;
+	for (; pgsz_lg2 > 0; pgsz_lg2--) {
+		if (priv->info.pgsize_bitmap & log2_to_int(pgsz_lg2))
+			return pgsz_lg2;
+	}
+	WARN_ON(true);
+	return priv->smallest_pgsz_lg2;
+}
+
+struct count_valids {
+	u64 per_size[PT_VADDR_MAX_LG2];
+};
+
+static int __count_valids(struct pt_range *range, void *arg, unsigned int level,
+			  struct pt_table_p *table)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	struct count_valids *valids = arg;
+
+	for_each_pt_level_item(&pts) {
+		if (pts.type == PT_ENTRY_TABLE) {
+			pt_descend(&pts, arg, __count_valids);
+			continue;
+		}
+		if (pts.type == PT_ENTRY_OA) {
+			valids->per_size[pt_entry_oa_lg2sz(&pts)]++;
+			continue;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Number of valid table entries. This counts contiguous entries as a single
+ * valid.
+ */
+static unsigned int count_valids(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	struct pt_range range = pt_top_range(priv->common);
+	struct count_valids valids = {};
+	u64 total = 0;
+	unsigned int i;
+
+	KUNIT_ASSERT_NO_ERRNO(test,
+			      pt_walk_range(&range, __count_valids, &valids));
+
+	for (i = 0; i != ARRAY_SIZE(valids.per_size); i++)
+		total += valids.per_size[i];
+	return total;
+}
+
+/* Only a single page size is present, count the number of valid entries */
+static unsigned int count_valids_single(struct kunit *test, pt_vaddr_t pgsz)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	struct pt_range range = pt_top_range(priv->common);
+	struct count_valids valids = {};
+	u64 total = 0;
+	unsigned int i;
+
+	KUNIT_ASSERT_NO_ERRNO(test,
+			      pt_walk_range(&range, __count_valids, &valids));
+
+	for (i = 0; i != ARRAY_SIZE(valids.per_size); i++) {
+		if ((1ULL << i) == pgsz)
+			total = valids.per_size[i];
+		else
+			KUNIT_ASSERT_EQ(test, valids.per_size[i], 0);
+	}
+	return total;
+}
+
+static void do_map(struct kunit *test, pt_vaddr_t va, pt_oaddr_t pa,
+		   pt_vaddr_t len)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	const struct pt_iommu_ops *ops = priv->iommu->ops;
+	size_t mapped;
+	int ret;
+
+	KUNIT_ASSERT_EQ(test, len, (size_t)len);
+
+	/* Mapped accumulates */
+	mapped = 1;
+	ret = ops->map_pages(priv->iommu, va, pa, len, IOMMU_READ | IOMMU_WRITE,
+			     GFP_KERNEL, &mapped, NULL);
+	KUNIT_ASSERT_NO_ERRNO_FN(test, "map_pages", ret);
+	KUNIT_ASSERT_EQ(test, mapped, len + 1);
+}
+
+static void do_unmap(struct kunit *test, pt_vaddr_t va, pt_vaddr_t len)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	const struct pt_iommu_ops *ops = priv->iommu->ops;
+	size_t ret;
+
+	ret = ops->unmap_pages(priv->iommu, va, len, NULL);
+	KUNIT_ASSERT_EQ(test, ret, len);
+}
+
+static void do_cut(struct kunit *test, pt_vaddr_t va)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	const struct pt_iommu_ops *ops = priv->iommu->ops;
+	size_t ret;
+
+	ret = ops->cut_mapping(priv->iommu, va, GFP_KERNEL);
+	if (ret == -EOPNOTSUPP)
+		kunit_skip(
+			test,
+			"ops->cut_mapping not supported (enable CONFIG_DEBUG_GENERIC_PT)");
+	KUNIT_ASSERT_NO_ERRNO_FN(test, "ops->cut_mapping", ret);
+}
+
+static void check_iova(struct kunit *test, pt_vaddr_t va, pt_oaddr_t pa,
+		       pt_vaddr_t len)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	const struct pt_iommu_ops *ops = priv->iommu->ops;
+	pt_vaddr_t pfn = log2_div(va, priv->smallest_pgsz_lg2);
+	pt_vaddr_t end_pfn = pfn + log2_div(len, priv->smallest_pgsz_lg2);
+
+	for (; pfn != end_pfn; pfn++) {
+		phys_addr_t res = ops->iova_to_phys(priv->iommu,
+						    pfn * priv->smallest_pgsz);
+
+		KUNIT_ASSERT_EQ(test, res, (phys_addr_t)pa);
+		if (res != pa)
+			break;
+		pa += priv->smallest_pgsz;
+	}
+}
+
+static void test_increase_level(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	struct pt_common *common = priv->common;
+
+	if (!pt_feature(common, PT_FEAT_DYNAMIC_TOP))
+		kunit_skip(test, "PT_FEAT_DYNAMIC_TOP not set for this format");
+
+	if (IS_32BIT)
+		kunit_skip(test, "Unable to test on 32bit");
+
+	KUNIT_ASSERT_GT(test, common->max_vasz_lg2,
+			pt_top_range(common).max_vasz_lg2);
+
+	/* Add every possible level to the max */
+	while (common->max_vasz_lg2 != pt_top_range(common).max_vasz_lg2) {
+		struct pt_range top_range = pt_top_range(common);
+
+		if (top_range.va == 0)
+			do_map(test, top_range.last_va + 1, 0,
+			       priv->smallest_pgsz);
+		else
+			do_map(test, top_range.va - priv->smallest_pgsz, 0,
+			       priv->smallest_pgsz);
+
+		KUNIT_ASSERT_EQ(test, pt_top_range(common).top_level,
+				top_range.top_level + 1);
+		KUNIT_ASSERT_GE(test, common->max_vasz_lg2,
+				pt_top_range(common).max_vasz_lg2);
+	}
+}
+
+static void test_map_simple(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	struct pt_range range = pt_top_range(priv->common);
+	struct count_valids valids = {};
+	pt_vaddr_t pgsize_bitmap = priv->safe_pgsize_bitmap;
+	unsigned int pgsz_lg2;
+	pt_vaddr_t cur_va;
+
+	/* Map every reported page size */
+	cur_va = range.va + priv->smallest_pgsz * 256;
+	for (pgsz_lg2 = 0; pgsz_lg2 != PT_VADDR_MAX_LG2; pgsz_lg2++) {
+		pt_oaddr_t paddr = log2_set_mod(priv->test_oa, 0, pgsz_lg2);
+		u64 len = log2_to_int(pgsz_lg2);
+
+		if (!(pgsize_bitmap & len))
+			continue;
+
+		cur_va = ALIGN(cur_va, len);
+		do_map(test, cur_va, paddr, len);
+		if (len <= SZ_2G)
+			check_iova(test, cur_va, paddr, len);
+		cur_va += len;
+	}
+
+	/* The read interface reports that every page size was created */
+	range = pt_top_range(priv->common);
+	KUNIT_ASSERT_NO_ERRNO(test,
+			      pt_walk_range(&range, __count_valids, &valids));
+	for (pgsz_lg2 = 0; pgsz_lg2 != PT_VADDR_MAX_LG2; pgsz_lg2++) {
+		if (pgsize_bitmap & (1ULL << pgsz_lg2))
+			KUNIT_ASSERT_EQ(test, valids.per_size[pgsz_lg2], 1);
+		else
+			KUNIT_ASSERT_EQ(test, valids.per_size[pgsz_lg2], 0);
+	}
+
+	/* Unmap works */
+	range = pt_top_range(priv->common);
+	cur_va = range.va + priv->smallest_pgsz * 256;
+	for (pgsz_lg2 = 0; pgsz_lg2 != PT_VADDR_MAX_LG2; pgsz_lg2++) {
+		u64 len = log2_to_int(pgsz_lg2);
+
+		if (!(pgsize_bitmap & len))
+			continue;
+		cur_va = ALIGN(cur_va, len);
+		do_unmap(test, cur_va, len);
+		cur_va += len;
+	}
+	KUNIT_ASSERT_EQ(test, count_valids(test), 0);
+}
+
+/*
+ * Test to convert a table pointer into an OA by mapping something small,
+ * unmapping it so as to leave behind a table pointer, then mapping something
+ * larger that will convert the table into an OA.
+ */
+static void test_map_table_to_oa(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	pt_vaddr_t limited_pgbitmap =
+		priv->info.pgsize_bitmap % (IS_32BIT ? SZ_2G : SZ_16G);
+	struct pt_range range = pt_top_range(priv->common);
+	unsigned int pgsz_lg2;
+	pt_vaddr_t max_pgsize;
+	pt_vaddr_t cur_va;
+
+	max_pgsize = 1ULL << (fls64(limited_pgbitmap) - 1);
+	KUNIT_ASSERT_TRUE(test, priv->info.pgsize_bitmap & max_pgsize);
+
+	/* FIXME pgsz_lg2 should be random order */
+	/* FIXME we need to check we didn't leak memory */
+	for (pgsz_lg2 = 0; pgsz_lg2 != PT_VADDR_MAX_LG2; pgsz_lg2++) {
+		pt_oaddr_t paddr = log2_set_mod(priv->test_oa, 0, pgsz_lg2);
+		u64 len = log2_to_int(pgsz_lg2);
+		pt_vaddr_t offset;
+
+		if (!(priv->info.pgsize_bitmap & len))
+			continue;
+		if (len > max_pgsize)
+			break;
+
+		cur_va = ALIGN(range.va + priv->smallest_pgsz * 256,
+			       max_pgsize);
+		for (offset = 0; offset != max_pgsize; offset += len)
+			do_map(test, cur_va + offset, paddr + offset, len);
+		check_iova(test, cur_va, paddr, max_pgsize);
+		KUNIT_ASSERT_EQ(test, count_valids_single(test, len),
+				max_pgsize / len);
+
+		do_unmap(test, cur_va, max_pgsize);
+
+		KUNIT_ASSERT_EQ(test, count_valids(test), 0);
+	}
+}
+
+static void test_cut_simple(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+	pt_oaddr_t paddr =
+		log2_set_mod(priv->test_oa, 0, priv->largest_pgsz_lg2);
+	pt_vaddr_t pgsz = log2_to_int(priv->largest_pgsz_lg2);
+	pt_vaddr_t vaddr = pt_top_range(priv->common).va;
+
+	if (priv->largest_pgsz_lg2 == priv->smallest_pgsz_lg2) {
+		kunit_skip(test, "Format has only one page size");
+		return;
+	}
+
+	/* Chop a big page in half */
+	do_map(test, vaddr, paddr, pgsz);
+	KUNIT_ASSERT_EQ(test, count_valids_single(test, pgsz), 1);
+	do_cut(test, vaddr + pgsz / 2);
+	KUNIT_ASSERT_EQ(test, count_valids(test),
+			log2_to_int(priv->largest_pgsz_lg2 -
+				    next_smallest_pgsz_lg2(
+					    priv, priv->largest_pgsz_lg2)));
+	do_unmap(test, vaddr, pgsz / 2);
+	do_unmap(test, vaddr + pgsz / 2, pgsz / 2);
+
+	/* Replace the first item with the smallest page size */
+	do_map(test, vaddr, paddr, pgsz);
+	KUNIT_ASSERT_EQ(test, count_valids_single(test, pgsz), 1);
+	do_cut(test, vaddr + priv->smallest_pgsz);
+	do_unmap(test, vaddr, priv->smallest_pgsz);
+	do_unmap(test, vaddr + priv->smallest_pgsz, pgsz - priv->smallest_pgsz);
+}
+
+static struct kunit_case iommu_test_cases[] = {
+	KUNIT_CASE(test_increase_level),
+	KUNIT_CASE(test_map_simple),
+	KUNIT_CASE(test_map_table_to_oa),
+	KUNIT_CASE(test_cut_simple),
+	{},
+};
+
+static int pt_kunit_iommu_init(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv;
+	int ret;
+
+	test->priv = priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	ret = pt_kunit_priv_init(priv);
+	if (ret) {
+		kfree(test->priv);
+		test->priv = NULL;
+		return ret;
+	}
+	return 0;
+}
+
+static void pt_kunit_iommu_exit(struct kunit *test)
+{
+	struct kunit_iommu_priv *priv = test->priv;
+
+	if (!test->priv)
+		return;
+
+	pt_iommu_deinit(priv->iommu);
+	kfree(test->priv);
+}
+
+static struct kunit_suite NS(iommu_suite) = {
+	.name = __stringify(NS(iommu_test)),
+	.init = pt_kunit_iommu_init,
+	.exit = pt_kunit_iommu_exit,
+	.test_cases = iommu_test_cases,
+};
+kunit_test_suites(&NS(iommu_suite));
+
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(GENERIC_PT_IOMMU);
-- 
2.46.0


