Return-Path: <kvm+bounces-24139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C66C9951BAE
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 701DC1F22596
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD5C1B1408;
	Wed, 14 Aug 2024 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cLRJJB2B"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086F1879;
	Wed, 14 Aug 2024 13:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723641603; cv=fail; b=T200DalP/1vHuOWV6rRjLJMTpefpEAi/p0RVa3CAfnUAg15R7OoxnVIVKNm1I8HYms36jAY57QYMWPg2xj2C5xwAv8DO36TpHM0i9I0KEIu/f4TledrKr8xhc/au50x8tvI9H5FgT/MVplcOGXHzfsx9R/6WDbuorvgcC5F6Cp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723641603; c=relaxed/simple;
	bh=Iac1H0ewvdlyTuvTK7oZcnawCHfS2Y5XB46rgwaiYqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KZDiHrNj8jgwb/2S2tdW7y9LW3H7zS1a5qaOrT11LpL6Vj+ctCbx8B6XmmI+npWGx4aQ6lCHyf63ph+SXU/CSSlBCAEe+yOWUWajFpeJm+CF/sN7PrttIJHL6VPNVgJCXTEwOp6awnqNTBcfwcyUOsNSE1e6BevazeYRPKbIolY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cLRJJB2B; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9u5YVFEx4pvKYO/d8il0tdwaMWmMCvbcU0AT/e8x4zPgNvcMu2/qDL2gfYR133YA87daT6Xu3nWku1XTuqfU2vHD2PiyzqHJfSiG+8r8GgJ1JuW4JUKecu18if7ru0qWp2I7NdS8gEDcdXLn3biOy/Cc8pJOAYZH9n69paJ4k2/dYc7NeT7gDYvblEVYU1Rsf6ot1+T78qVIiT1qabMXMMCGkkddRjQhyI0Vc2dcyFKv8dl8bLqKUQ/dLZ3VGuebFH2k/PVQ/OzBmNU1NJyIdzkw4/SSCF4UllQRc0xlum71wGEGgqI+py16lwbjAd5XjxqUyFqpzwzveWsZwle2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcABRMHL2ulYhthnVZF/fRMjR5F0znFiDK12irBq6p8=;
 b=JH+GdVmb7Ova3WJgsTvQVDy62gaEevKvsqkKKjgrEIWZGaEmpvmh739O4Kxb9n3EnQtyEu+DvbQh5dofenjc4cdhk6U2Yk/N6/2LzhOJhN1mbiyO9C+dNbFNfbzgaJCk+DsoFuvizZM2qbPq3uzF8iwDRGHKJZh5k8+pR58wcFtrsHir0TYInTHfv1X+Ml8SOvr+6AaFU9Nrmiepi9J5kYF+zpVkhi6PxHgF28YKXsehalHfQAUOj+ww3uTJ3GtPzvNyMr17KDq/jHiuL9FuBvdydj7WJ9XzCv88Qk5f/1AM/ROwgrkHTDWIS2HcWtN3qH5mAQcF9Vbrq2RzMrgXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcABRMHL2ulYhthnVZF/fRMjR5F0znFiDK12irBq6p8=;
 b=cLRJJB2BgXvLI7+wctpLOthf0EL47Klylp+sxjwzv3pWVgwx1KsfIyFcETNJzzLimw9wSBZTFTqhTuruZM27qyrgKtvwpZDUIKzI60TnegpRqD7679s8+vEuj/Tvy8/FvOPOZeE59fEb2DT0s7XuuoYW13fHnCHL2yly52hGNNApGKWR/vMYeinThE7z9lC9TzgAZeJB2D5uXA/S/PaRIdlBD8JvybRZTAoRpQcULDMkmlcFfO39DHGRXLLn01WeXJBOoqbPzGRLXpFpz+EckQWR+tjliMwVvmMc5++52yupj5zX/I8lBLckKDToQ8bAcpFxYcY8ti4gfb24GfFJXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SA1PR12MB6823.namprd12.prod.outlook.com (2603:10b6:806:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Wed, 14 Aug
 2024 13:19:56 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 13:19:56 +0000
Date: Wed, 14 Aug 2024 10:19:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 09/19] mm: New follow_pfnmap API
Message-ID: <20240814131954.GK2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-10-peterx@redhat.com>
X-ClientProxiedBy: BL1PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::27) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SA1PR12MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 2696fc85-905d-4d04-da45-08dcbc63ca1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	Y8f9/I/bHlv5c4PDPxV671cXf5xIzGW94ZTkdYkBVvjfH3FtoaSAKdcoP6iRbjSiD0BePxcEoow82nbdy7QZLg7uC5mQK18qxQ5JWPVd+RK+2y6D20Krof3dRnMkp0pCy1l5YChNqMP0T1U+RmoTO/BQxAjoXqt0iekGjNX1qt7Ld1EnQkFFLwhYOVWuWIZqKARQBxDEvPzwBb+YsUCp+wO3cGtoAS65pbDQ2eyp2GMV3Cm65e1DAqNwVSWSIsfIl1D1HF6sW33T197zWf7WIS8jd5JYokmEVEYvwwn6rcRRDe83ZaEz8unCEI6gYRm/pA5zxeUMs0U1u/68Ce0RY/6w9W6+X7LYPOSa5fJFHmnUjzPtL4rtKIq0/Y9mrwkGKIo1Kmjfol+/wWwND45PHDCkpbLhUMi4Lm/xyvMhofg59TI993d1x7tW2kksCYFBuGeNXrfE5g7XQ6taKfItbLt6fQJZV5WigzhmLY0pNy4D9CdGCNESobuLtgdRhBmQVjnOH1U+K71WGLI3rIqPTq/TrNW+at3P1mvIxm0owh4zyKxT2mrrnL569/sFQ4+ZoYowWe8kXvABlbY6TfgLXj6kY7uuIBcgT9cmHupGdMwzU5iD57zFZzPEaHbnEy+5+6ALXNrbBie2Zxn4a6YKSVyZ82GPqRpTO95UmoiXxPU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cyPTSAUc/4m0xD2ih334aJxqMsS2rb4zHpfiFEK4ThFEUcAvUs2v0bbHeE0l?=
 =?us-ascii?Q?G1dYfjeYGetc1lTPDuomII9wuIjDGYXc/BzaxeRKOZckfYuFqvUO20yPhmAb?=
 =?us-ascii?Q?tnhsv+QOEzdALWBKgOlilLV7eXnF2czS1k17gukLmtkIvHAbhM2/lRFnXrbG?=
 =?us-ascii?Q?HCbGDYbvOcTCzY/+5oa05XFIu5jGQOWyaUfiPDvYRk32DPBbThG4Wu4s5RK9?=
 =?us-ascii?Q?9WI9zB3GYZKlbg5zHHknVcnB4BDCR3znEjh9db6RyOzKPEA1nSCTpzHZ5GwH?=
 =?us-ascii?Q?Nc09IwXka/rhlYar+2xTEQy9gS9a3MRaoUuSpozAeDf9M9HDIAijhyDSJa0R?=
 =?us-ascii?Q?tYytVs5DdtoVuhjUIES3A90b6bM3Lys/ngwOfjx+QRyXN+JoPuNftUluFLyj?=
 =?us-ascii?Q?cs9nDFcfyHslR6rUwA//sHYs3eIUpslmhVUgquIWQafBEKs/B3xvPVLfq8gy?=
 =?us-ascii?Q?y2v1K6yqUtivOiDF4zlpxvxmol4HU6u8qn6BZwK+0eKq+HhhF/0nilUzv2+y?=
 =?us-ascii?Q?0FbV2KQYBBRc8AQpN4GOyIrkwWZS2f7VonQbrd9VhUXDoW9HNJ7IeVMjaQHH?=
 =?us-ascii?Q?kUzy+Mp/Y3hn3rRJH10nXWd0qB+9in3jLVRh23Pe33Qq/OUCmWUV+bHae0sA?=
 =?us-ascii?Q?m90AAmsSqpwErpPBaD2PhnQQlFrXEpYVH1Ig7DaKb+LPSPiyMI+SDa5itkrm?=
 =?us-ascii?Q?TSlnsyz928qFkj42SpI8FGgqhFs+rKt5SF2fSmmLvo2rknQX12ZWyS6FQyBb?=
 =?us-ascii?Q?mkhZcNgRQmzk+/OogmzbXQbpzjfcEOGzTcmcgA6qo2E8EwWLq4ARceN8ESzz?=
 =?us-ascii?Q?xzXwjjvnOx2QOylogIGfrQcOvEgoWXbV6s2rlcac1RNcpG6kRC+nps1vS+1N?=
 =?us-ascii?Q?NYEcCB+8FfMZJmg7WYbuC7N8svT7+ffvrRCJ/yhqcHRSLATkz4AeJhY1Gc74?=
 =?us-ascii?Q?Pu6W1EzpLXSzPn6/RfkcFm0bt74he5F6ibWzvQXBz1QbO1E1nkR8MgYdDRUP?=
 =?us-ascii?Q?qmIBZcCbotRaZ2Dl6J9IsgGN7aBq+NFUnkb0eff5Nz6iRczGSIkS5Nr1ZRsF?=
 =?us-ascii?Q?MhRsfYjzICMaAJmZ3e9S6XEr9O2FGW8hqTUl0+3bjIwksnNwKOO81Lbt5DIO?=
 =?us-ascii?Q?uzkn22jA0onamjcMhkkA/cBuurYJZgkCZrDR2q8inkVLe+lozzYtQM2fCnk4?=
 =?us-ascii?Q?iAIEnv8L6NfkuV/9Qs5AQczobe335Te8O5pLZkMjo0FYgHjbPwSolY17a2lF?=
 =?us-ascii?Q?uU9qYBK+5If3gzOAUJb7JsrCdfno+AR3fBcHrOWP69qXOpHzVafpXKNglGXP?=
 =?us-ascii?Q?9ZKf4xE0vaSkqRr+0f2lh1kelT6HgjSCFvfpTByIezT7l1nM8Y2F3DOTu71S?=
 =?us-ascii?Q?y5T0Gt9/C7HBeaVDQuPpBukybXG4CirCGVp4mW3uCDCirKvTECf7HGYt8gQo?=
 =?us-ascii?Q?h4t8x9rMSIPygiCCzWZX6bwZelWYQGnMTsrl+RYlTeu2t+C4qjzxnkHRFsUo?=
 =?us-ascii?Q?g6se6BFVRLZ4eaiIQ2zbN0YPbuWmYPlYNnUHidqDsKG/Uq2fZIiFLNB2TqJE?=
 =?us-ascii?Q?/mxlrtCU4tDyA6Db3N85SMc0UTAu5MbdHFrCgROG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2696fc85-905d-4d04-da45-08dcbc63ca1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 13:19:56.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5cFQS8qss3iBcxaeCgh7IuLPjgJxck5EZ66J1HO32L5ooDVSdlA0KNM92BSutJHd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6823

On Fri, Aug 09, 2024 at 12:08:59PM -0400, Peter Xu wrote:

> +/**
> + * follow_pfnmap_start() - Look up a pfn mapping at a user virtual address
> + * @args: Pointer to struct @follow_pfnmap_args
> + *
> + * The caller needs to setup args->vma and args->address to point to the
> + * virtual address as the target of such lookup.  On a successful return,
> + * the results will be put into other output fields.
> + *
> + * After the caller finished using the fields, the caller must invoke
> + * another follow_pfnmap_end() to proper releases the locks and resources
> + * of such look up request.
> + *
> + * During the start() and end() calls, the results in @args will be valid
> + * as proper locks will be held.  After the end() is called, all the fields
> + * in @follow_pfnmap_args will be invalid to be further accessed.
> + *
> + * If the PTE maps a refcounted page, callers are responsible to protect
> + * against invalidation with MMU notifiers; otherwise access to the PFN at
> + * a later point in time can trigger use-after-free.
> + *
> + * Only IO mappings and raw PFN mappings are allowed.  

What does this mean? The paragraph before said this can return a
refcounted page?

> + * The mmap semaphore
> + * should be taken for read, and the mmap semaphore cannot be released
> + * before the end() is invoked.

This function is not safe for IO mappings and PFNs either, VFIO has a
known security issue to call it. That should be emphasised in the
comment.

The caller must be protected by mmu notifiers or other locking that
guarentees the PTE cannot be removed while the caller is using it. In
all cases. 

Since this hold the PTL until end is it always safe to use the
returned address before calling end?

Jason

