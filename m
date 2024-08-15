Return-Path: <kvm+bounces-24281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEA59536C0
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 518FF1C2381D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9801B3747;
	Thu, 15 Aug 2024 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="To0Hw9C6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7F61AED44
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734713; cv=fail; b=eS9lzNesm+cbvFVOe1V84YVVeoDfGeQ2Q3Kl9Nr45Ta2FuqsChY6FOODWHCEYybjWcSbwjiGQxxGWXPAxoFJfmiWhIAlMKzPJojKrcqoMkBkhSz8bBX+wIYblxnA5saPKXiBniccnUZPRWd1uxf8qALJ7L4I4JSG43SavAXjUlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734713; c=relaxed/simple;
	bh=QZN57gbxoe0V0/caPN7JPngYpzagvJDuqCG8MLUsXeY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fRG19xGBMCoGB72eO/Ia/W599bz3Y47vKr+jB70pAH92GwHPAKkrdcQ7qT94CbI1GdEeeU3/31uAjEw2C9tfa7qdbNVaCjsB+riClafc2sFGEnvwDf22TJDe7Z+zH6D4cPO1raHoaJPnq06sVpqljnEotBMIMOwETYXl7ktXu0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=To0Hw9C6; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5THSX+JVmt7ADgxgO5iDNDUkPKd9NpBkZmF0DTLHFc21SufaFvlKwabvQlT0VnmP26zjXQHkbjKqd4jH0ByHgAa2+8OZXLXQFHIpAM8MgVceTT2ByXTEt+0KaDCvYrM9UeK+EbCPdGcb4QuOTZ4s/aAjX/QAwlK3t1DZXVjL7jVMhzfV6mNdiVWO5sIDKrHknMBnuMBYHEHgeI6VfneDqtusfqybjJT8sZka7VdHk4SJMjqRJz0zBHp0DVSUUcd/l8VI2efg3Vu9og5kyXSh5+JTABVfdyGcUWa5dXt63nW8MTo/gJpabTknMEZIE+fSYuaXmqcIGMsfqtPqYILZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Ys9zkdyaf4QzN+J2RTZjtRiqCYiBd5UKmRH8hiHJiI=;
 b=avyw2K18TyT4cykVll8yYXXheqnUjGekrQTCXa5tl+M62Etznbfd71WhYl9TlR2YRZKUPIGEwn6t5/sN0YJG/OOI/DZ466bvb9QQUaddgC+XGxyo82rzRLEWKbrWsfSvauqIB58UqFMp0RLND2lDcWQv5hSLkWHUhNWverUeN6Mq8A3pNxtSPn4txkbLKF8SzOdPKO0IxdKwOyngkquS9SxjS8LwM3kcNj2tFol9dUGN3VA1gI5jS18E13cZ1IudtHyRKjVMPxzGQ9Mo43mgAp62chm89m7/F11CH20L6bp5IflVnMjitF+WekLTS4apQacW3h0gX2N9bil1BEFMjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ys9zkdyaf4QzN+J2RTZjtRiqCYiBd5UKmRH8hiHJiI=;
 b=To0Hw9C6zaOe80Y2rFkcWnQLAmwfe9dQdbcNbhqxjJ71Vwhe39NYWbabrkbx4FSpYk6AAvnwsInMTIYezrNY0BH2AcDpjIAtVZG28/fnR3Ppi6Eyc99Tf+hyxaJfs95C1MZ3pjxL2LBH9Igg8M9sq0j+AtajGzFxjQKBM8vqW8OJHRQdVRLYj74rrXzSzJoQbdMCMjtUB3B4oVnPAgNR3tHvA1Dz765UeyJ8BE/hmW4YraFYHTIYpENGL+/lswsu4G2lWmrTX6wYdQKwXuMPTBdC58RKmJ+R0xwSNMcc9ptfPwi5us9ecBpY9vSj0NqiYpSVM8zmtX09iAIvPUZs1Q==
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
Subject: [PATCH 00/16] Consolidate iommu page table implementations
Date: Thu, 15 Aug 2024 12:11:16 -0300
Message-ID: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::27) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 09abbb01-a6ef-41c1-c04a-08dcbd3c8e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c3B5WKFwG6qhWo4gmx8WFdqHpIu8XItHLK6FD0df/NizNhFEbjxr3EKsR1iJ?=
 =?us-ascii?Q?vwBxDXPlU7Bk7APtiPrQUeHSAIxQPC9AuhUKmCfd/av/VCMQdo5R+XWuIGFh?=
 =?us-ascii?Q?lqRVXsie/Rwroj0Ykk5B70mAdCPeA71AnkgksT2jbTCvwZiHMQGEy+Quw2p+?=
 =?us-ascii?Q?qg0A2/qcYV1z9ZNXV9kcTe7eoHhs9QKMMHLjsiLALM2g+s7fWcoHkC3uLEzB?=
 =?us-ascii?Q?fOsxnHyojmX/9P4/5m+sNlVwo/sputdAQCy17CIJ6NMlCrcMzO7fE45YyVPk?=
 =?us-ascii?Q?NfRj/H9DAR/ZbLzxXT/o6gtpCX4H9tz3QT3pE1tAVaPWe4AWXgL3D0A2AoVO?=
 =?us-ascii?Q?J/oTTFTFs2Rc6kdAWtd8RcQgEBYaK5Ka/G7+mj9z3R9L17W6k+fSv42Cv9kR?=
 =?us-ascii?Q?5o4FrVd8WCs+E2t504mC+BfeHjDvCdqhWiUuYmBVkDtks0cPb+jtV21SFub0?=
 =?us-ascii?Q?lpgdh2cdDe60QrXqaGBNh2GLNWiXNdDyJsoSkaefnL+or60Pnfd3g8yejv/Y?=
 =?us-ascii?Q?P9Ur2U4E/RF7A8Kb1jVhUHiVr0djxI7QpkBgAGobKu9TM3mvX5L8IbTSog9K?=
 =?us-ascii?Q?sTPBu8HFqKHOJjxbLePFg7q/JDo9z2UNowlL0dtD24RSIhX5pT79csnxk1sc?=
 =?us-ascii?Q?d/jV7Z3EEOxfWCAkP7qP+94GwoYNqM+bnaf6lCtDB6SPOE5MNbYVOGJG/4FR?=
 =?us-ascii?Q?r9bWxaVzqYJFsrkzpm2zu3TwT3FWsq7G7uk+H1pu63sXfB2IYsGJ8f9eY7K1?=
 =?us-ascii?Q?7Glwo2fzdNmFI67rMLPrEeJysmeCrqmnN+iiDdf5/O2BjCIy/o5zU0kbohZS?=
 =?us-ascii?Q?DybCykIm4KKMY5aUW+AZ/LGEYznR+HDwvN2eImwpc8SgyyRuYwOySazvIgGz?=
 =?us-ascii?Q?ZKjpuKppFwJ71qoqZvH+AxsnyYVT9FaghTMfEF35NuPlLsOMz6bISm4vg/nm?=
 =?us-ascii?Q?bLjghDs2Lfw0VLGEZRonn2PhEFJ1/NFJ4Z05EUHjRWaP3O11VlraYNrvw31K?=
 =?us-ascii?Q?4vMLiElWosoM7Mjei3za1C+jaXwlGEf9tV/fkSHVxK0233FvJ94UEsooKSaV?=
 =?us-ascii?Q?1ol6bp4KX7oU8nEO76HoP2c96tLt4+AAKJsYD0nTsGWBZ4TX0ihEvz3hlqxb?=
 =?us-ascii?Q?0JGq/Vht54+YOT5ovZQLgIvB1aHKwFL1gEG3bEAuvGA1tQr5s+gs7V0uh1p6?=
 =?us-ascii?Q?Sx23nli//sN6RZ4MjkE4KD/gj5tHjz+EyHb4Ibd+GiExz4lINr6mBJnKS6Dx?=
 =?us-ascii?Q?idEOD3CYSr/jHVfC3ZPsvEJ0i+P7BK+D091txD/yB6KbQZdmahwVzrFublQ1?=
 =?us-ascii?Q?VozRtfWOemWle+Wa6MqKG/Snx8V9vE4/FfyHbRUnTfZXllw7tD2g7xP/H0fm?=
 =?us-ascii?Q?0iXfS+E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zXUSIJvvVRFZ4jiBBkw3AyICFk/caphvJ+k0Hyl+HqGeWKWr+gQdkidS6fXM?=
 =?us-ascii?Q?4qB3YHFz7A/+oM4Hf737fVuMEgYZtsShQtbJNVsDITnXhytz62/eKCkGWRqi?=
 =?us-ascii?Q?z9cmeGf9PEcaifZ1TTBG/FL8KxzVU0QfQySTo+7zt1qSmmqt0G9tmKiL/Fef?=
 =?us-ascii?Q?nxjjROG384aRRFy0SxSbkGj+TrO+ojRFGKZld0woDzfIIMIAt+QvlximnWZG?=
 =?us-ascii?Q?Z0rVHBkgmN++O6n1yv5d6XE6ZdlpPz2VNpgzEuGy/62RXXEOs7PyKSYkAgFt?=
 =?us-ascii?Q?wgHHlaB6uDlpSZm/bOlpESNbapfJ+iV1xXKsMEX00MkM+ci29YJwvgf7CX1t?=
 =?us-ascii?Q?Y1x/ichTtO/sScF8VMDVziwOLNJt+/Wb+NsRzQPDxjHr1TH31/z1xEQQ4IO5?=
 =?us-ascii?Q?hd/Yw0N83xJ2WX6ualh8gqTU8Bmd6vKxyw672YE4DjNPwOAXCR/wefxBDpCl?=
 =?us-ascii?Q?gQmUfxzyhANmZBnpdEzMWFm6WeIfvR5IM8GCAaGAgLZCiiV3Z1TBo+H4JTAb?=
 =?us-ascii?Q?eRpQNj1atpHAkfir5/GfMvTVUO6c1sSz5mJJAKzBPQKHfSSGsDFqExPTK1Tt?=
 =?us-ascii?Q?gd1O6whNAUiyi3WfyDGgeZQiG9XNu7XPwuOKECoQcJ3Zsmhs9KNfbhqFfDGs?=
 =?us-ascii?Q?s6EvPzTaaQYywagY28gUyp1/AlaV2AgiW18uUZU92fpnb9vKq6xPqyGqIeAD?=
 =?us-ascii?Q?VHJvJ4JWnzkEATjrYyzgV6Y80iaBdSN+xJ5gLk6HLJzB9YI4yMEc+vOtgFJz?=
 =?us-ascii?Q?jsKcTEaRWmiZMrydPNr43hmeWBTIWsDuyp6UylUxwudy8SrT1YigECI/pZ4U?=
 =?us-ascii?Q?ym4ogFdkt0csN1vneieQm9Nh9zMQ0/4naHozICdAhypmKf+7EYX398/ZEP6P?=
 =?us-ascii?Q?+DMM9eoAywRSSwbFxu8SuLC2txSJiRxujd6Q9XcqBZ6WS80d5UtOvC3w6ocM?=
 =?us-ascii?Q?tOfaJ4oG4sGx2qR9PwYfqrv0oR6nQtd8KfZoDf74eu4NKWKt9I7kwF/gRxz+?=
 =?us-ascii?Q?3opxbmnfGPX1rFsvetyxBnKOXoMm18TetYAXTyY8r/WofzBCsOvVrXsvfT/L?=
 =?us-ascii?Q?hRSeDMtKNGJvldIA7H1UWem/BOkTT8KFj4qfOkKjfoSNh0BjowwbJDqNDIGB?=
 =?us-ascii?Q?tWfPveeQAgHnAQw3i1/nNDnTZeBzaYuCHj5/VDnLpOgGzJ2rlShHP9GMKMhf?=
 =?us-ascii?Q?4KF/gfXDnudpmvx697nm6fKzrC8A56U08blYlpIxz/0B+vmG/H1HZ62hh4rv?=
 =?us-ascii?Q?MAH2kgzmBj+ZiJ4xXrGdt4TNy9iGcGKG406pnZsuZXNEgzFqU8PlDg9sLflC?=
 =?us-ascii?Q?6N0RO9RCp6k5B1O+pbr3gugt99JRgalOTvUiwGw+EdXEVzJqVKZIrHPZoTxH?=
 =?us-ascii?Q?YV9hDvqHvhjx7TDpoM/E2Qlijd3DMOmQzH56q8+s6vqDK/47vyWkyZWf+pDU?=
 =?us-ascii?Q?SPAYenzyM3+YkkPT4RtQeSa/WzIHHWLzvP+aE6lYaa9dohs4MxnjrGTVT7J5?=
 =?us-ascii?Q?FLY4xcKeoUij1DTHBClglZ8uf4A1FcIjE14N5vODSyY4WODVPkw3C/EH8Mvc?=
 =?us-ascii?Q?T7YbiB9RAJOc6jtvLZ0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09abbb01-a6ef-41c1-c04a-08dcbd3c8e09
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:36.3187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: am4nwgoqHZZSydcdWLmlczSBemeAu65hkCX+Ukc3brh11+X9+760LLpPB7EH0jgP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631

Currently each of the iommu page table formats duplicates all of the logic
to maintain the page table and perform map/unmap/etc operations. There are
several different versions of the algorithms between all the different
formats. The io-pgtable system provides an interface to help isolate the
page table code from the iommu driver, but doesn't provide tools to
implement the common algorithms.

This makes it very hard to improve the state of the pagetable code under
the iommu domains as any proposed improvement needs to alter a large
number of different driver code paths. Combined with a lack of software
based testing this makes improvement in this area very hard.

iommufd wants several new page table operations:
 - More efficient map/unmap operations, using iommufd's batching approach
 - unmap that returns the physical addresses into a batch as it progresses
 - cut that allows splitting areas so large pages can have holes
   poked in them dynamically
 - More agressive freeing of table memory to avoid waste
 - Fragmenting large pages so that dirty tracking can run efficiently
 - Reassembling large pages so that VMs can run at full IO performance
   in error flows

In addition there are possibilities like directly mapping a bvec, or
sg_list in more efficient ways, and perhaps even optimizations for the GPU
drivers using the io-pgtable code as well.

Together these are algorithmically complex enough to be a very significant
task to go and implement in all the page table formats we support. Just
the "server" focused drivers use almost all the formats (ARMv8 S1&S2 / x86
PAE / AMDv1 / VT-D SS / RISCV)

Instead of doing the duplicated work, this series takes the first step to
consolidate the algorithms into one places. In spirit it is similar to the
work Christoph did a few years back to pull the redundant get_user_pages()
implementations out of the arch code into core MM. This unlocked a great
deal of improvement in that space in the following years. I would like to
see the same benefit in iommu as well.

The approach is split into three deliberate layers:
 - The truely generic page table components. These are very application
   neutral and could conceivably by used in the MM or KVM if there was
   a reason. A DRM driver may also be interested in this layer as it
   could be more efficient than working through the iommu focused ops.

 - The per format functions. These are a set of small inline functions
   that abstract the details on how the page table is layed out in
   memory and what bits do what things. Like the MM these functions
   share the same name so the same code can be compiled against
   different formats by including the appropriate format header.

 - An iommu implementation. This is intended to create ops that can
   take over from the iommu_domain ops. There is a single set of C
   routines that compile against all the formats generically.

On top of this are two kunit tests, one that directly exercises the iommu
implementation across all the different formats. The second kunit does an
A/B comparison between the iommupt and the io-pgtable implementation to
ensure things are identical.

Sort of like MM, this uses multi-compilation where the common code
includes format specific headers that implement the same C API. Unlike the
MM we need to build multiple page table formats into the same kernel, so
each combinaton of format/parameters/iommu implementation is compiled in a
single compilation unit and into a module. This results in compiling the
same C code multiple times in a single kernel build, using different
combinations of header files.

The approach is designed to be able to provide both mm-like fully inlined
performance, or as typical for iommu, recursive non-inlined smaller .text
version. As the implementation is now shared it will be worthwhile to do
some performance work and fine tune this as appropriate.

I've CC'd a few people from outside iommu that may have some interest in
the generic part of this, or ideas how to better build the abstraction and
helpers.

For this RFC I've provided draft formats for nearly everything (S390 and
RISCV are notably not included). The formats all pass the compare test and
thus, to a significant degree, produce the same memory layouts for the
radix tree. The primary purpose of this breadth is to prove the common API
is suitable for the job. Completing these to be fully usable in their
respective drivers is still to be done.

I'm expecting to show maybe another RFC round with all the formats and
pivot to a more focused series, likely just for AMD, that brings the
minimum necessary. From there we can work in parallel to add the new
iommufd features and convert more of the drievrs. From an iommufd
perspective I would like the "server" drivers (AMD / SMMUv3 / VT-D) to be
converted as a minimum.

This general concept was brough up and discussed a few times during LPC
last year and I have a formal session on the schedule for this series in
LPC Vienna.

There are many additional support patches required to run the kunits,
everything is on github:

https://github.com/jgunthorpe/linux/commits/iommu_pt

FIXME:
  - Improve the two kunit tests
  - Implement additional new iommufd ops
  - Implement the debugfs with the RCU safety
  - Do a performance study vs the io-pgtable versions
  - Implement the flush callbacks, iommu core hookups, etc
  - Look at possible bvec and sg optimizations
  - Link it up to the iommu drivers and test it in HW as an iommu
    implementation

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: iommu@lists.linux.dev
Cc: kvm@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (16):
  genpt: Generic Page Table base API
  genpt: Add a specialized allocator for page table levels
  iommupt: Add the basic structure of the iommu implementation
  iommupt: Add iova_to_phys op
  iommupt: Add unmap_pages op
  iommupt: Add map_pages op
  iommupt: Add cut_mapping op
  iommupt: Add read_and_clear_dirty op
  iommupt: Add a kunit test for Generic Page Table and the IOMMU
    implementation
  iommupt: Add a kunit test to compare against iopt
  iommupt: Add the 64 bit ARMv8 page table format
  iommupt: Add the AMD IOMMU v1 page table format
  iommupt: Add the x86 PAE page table format
  iommupt: Add the DART v1/v2 page table format
  iommupt: Add the 32 bit ARMv7s page table format
  iommupt: Add the Intel VT-D second stage page table format

 .clang-format                                 |    1 +
 drivers/iommu/Kconfig                         |    2 +
 drivers/iommu/Makefile                        |    1 +
 drivers/iommu/generic_pt/.kunitconfig         |   23 +
 drivers/iommu/generic_pt/Kconfig              |  117 ++
 drivers/iommu/generic_pt/Makefile             |    7 +
 drivers/iommu/generic_pt/fmt/Makefile         |   35 +
 drivers/iommu/generic_pt/fmt/amdv1.h          |  372 ++++++
 drivers/iommu/generic_pt/fmt/armv7s.h         |  529 +++++++++
 drivers/iommu/generic_pt/fmt/armv8.h          |  621 ++++++++++
 drivers/iommu/generic_pt/fmt/dart.h           |  371 ++++++
 drivers/iommu/generic_pt/fmt/defs_amdv1.h     |   21 +
 drivers/iommu/generic_pt/fmt/defs_armv7s.h    |   23 +
 drivers/iommu/generic_pt/fmt/defs_armv8.h     |   28 +
 drivers/iommu/generic_pt/fmt/defs_dart.h      |   21 +
 drivers/iommu/generic_pt/fmt/defs_vtdss.h     |   21 +
 drivers/iommu/generic_pt/fmt/defs_x86pae.h    |   21 +
 drivers/iommu/generic_pt/fmt/iommu_amdv1.c    |    9 +
 drivers/iommu/generic_pt/fmt/iommu_armv7s.c   |   11 +
 .../iommu/generic_pt/fmt/iommu_armv8_16k.c    |   13 +
 drivers/iommu/generic_pt/fmt/iommu_armv8_4k.c |   13 +
 .../iommu/generic_pt/fmt/iommu_armv8_64k.c    |   13 +
 drivers/iommu/generic_pt/fmt/iommu_dart.c     |    8 +
 drivers/iommu/generic_pt/fmt/iommu_template.h |   49 +
 drivers/iommu/generic_pt/fmt/iommu_vtdss.c    |    8 +
 drivers/iommu/generic_pt/fmt/iommu_x86pae.c   |    8 +
 drivers/iommu/generic_pt/fmt/vtdss.h          |  276 +++++
 drivers/iommu/generic_pt/fmt/x86pae.h         |  283 +++++
 drivers/iommu/generic_pt/iommu_pt.h           | 1030 +++++++++++++++++
 drivers/iommu/generic_pt/kunit_generic_pt.h   |  576 +++++++++
 drivers/iommu/generic_pt/kunit_iommu.h        |  105 ++
 drivers/iommu/generic_pt/kunit_iommu_cmp.h    |  272 +++++
 drivers/iommu/generic_pt/kunit_iommu_pt.h     |  352 ++++++
 drivers/iommu/generic_pt/pt_alloc.c           |  174 +++
 drivers/iommu/generic_pt/pt_alloc.h           |   98 ++
 drivers/iommu/generic_pt/pt_common.h          |  311 +++++
 drivers/iommu/generic_pt/pt_defs.h            |  276 +++++
 drivers/iommu/generic_pt/pt_fmt_defaults.h    |  109 ++
 drivers/iommu/generic_pt/pt_iter.h            |  468 ++++++++
 drivers/iommu/generic_pt/pt_log2.h            |  131 +++
 include/linux/generic_pt/common.h             |  156 +++
 include/linux/generic_pt/iommu.h              |  344 ++++++
 42 files changed, 7307 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/.kunitconfig
 create mode 100644 drivers/iommu/generic_pt/Kconfig
 create mode 100644 drivers/iommu/generic_pt/Makefile
 create mode 100644 drivers/iommu/generic_pt/fmt/Makefile
 create mode 100644 drivers/iommu/generic_pt/fmt/amdv1.h
 create mode 100644 drivers/iommu/generic_pt/fmt/armv7s.h
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/dart.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_amdv1.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv7s.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_dart.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_x86pae.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_amdv1.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv7s.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8_16k.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8_4k.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8_64k.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_dart.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_template.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_x86pae.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/x86pae.h
 create mode 100644 drivers/iommu/generic_pt/iommu_pt.h
 create mode 100644 drivers/iommu/generic_pt/kunit_generic_pt.h
 create mode 100644 drivers/iommu/generic_pt/kunit_iommu.h
 create mode 100644 drivers/iommu/generic_pt/kunit_iommu_cmp.h
 create mode 100644 drivers/iommu/generic_pt/kunit_iommu_pt.h
 create mode 100644 drivers/iommu/generic_pt/pt_alloc.c
 create mode 100644 drivers/iommu/generic_pt/pt_alloc.h
 create mode 100644 drivers/iommu/generic_pt/pt_common.h
 create mode 100644 drivers/iommu/generic_pt/pt_defs.h
 create mode 100644 drivers/iommu/generic_pt/pt_fmt_defaults.h
 create mode 100644 drivers/iommu/generic_pt/pt_iter.h
 create mode 100644 drivers/iommu/generic_pt/pt_log2.h
 create mode 100644 include/linux/generic_pt/common.h
 create mode 100644 include/linux/generic_pt/iommu.h


base-commit: fdc4344ef3ee7741df149967893fb61240520ab3
-- 
2.46.0


