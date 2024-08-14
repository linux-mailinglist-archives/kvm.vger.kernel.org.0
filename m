Return-Path: <kvm+bounces-24130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 221D6951AF8
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:37:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCD6C2816CB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D65F19FA86;
	Wed, 14 Aug 2024 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W+Uwk3UQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3947D15C9;
	Wed, 14 Aug 2024 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639046; cv=fail; b=pCRpm0l6KB6dTRvDkqcd9tFnDsLg0s1+N3zzctbaITvd+p9Nlajc3IseA1sRL8Gi8DUOu+wXW2HWlAXuAopcnUY2U9N/Pp6mlhOZ+Y2lh+Zv2ipdB7krKZyNzqZ1Jdf/hLLV3ebg+Nr8FcwVqrIyWmw3ti3xXaTrGp53XG0nWts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639046; c=relaxed/simple;
	bh=qvd1QXkPJ5AIX6LsnhRIf4sscKareWMdYVLr2vrEg1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LyFpU3jz32U3GLhE3Pv4yGSmG+xXIkHIPADZ5GAK3wYGTgkWxRNcGYCO/CCR/xt9SfAsriUkpI2lkTiFUpWIoodb0rofZln+Gsz3QrXXD+DD3JogNyrYkDPm8Kx0q594Cz9WjDtrNfgM7adGGndapN5EgtE7hXi4F5y/sFVC4LU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W+Uwk3UQ; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2Th1EF0szfo30hV/m62m9YwVB4+X4renbFkyrLo1ON6ktutIskHzQ5T6NAc87KF8vvazTeQRJ7j0bvrQR3U1sSvwREO0YI0MaNhQlDZX1hNQWFioGjJp0ftHpL5TukdlOblvXlU5tIh/8kddoryHewtzJHtrDfiIHWxprdYk9kFuunHzjOCazd7SeW6333Q78yFLY1rJL2EnB0eSqX+SjTC6c9xeiXnjfICTk7uaHssyOgkihzxO564r/V0sFlTq6pJa/oyJGz8GLuFXrOqnhBrS34B22DoTmygSb0gvvcr6tF36DTMEabjAYaUmh5hd8qBJ2v1xMar/zP07lhUIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8c+68+qcFrF9XEinE1+B2F7HpeFycmCYHze14VEYae8=;
 b=KS1hf3qPIdAO59hP4NdSlYvEHOrfuhLmOk9KopClQTr/UXj6DIiqk4ps8ReAfyKuCbUr76gMzsFfuZ+AZunhWKDOJdpEq2iL6lDxB5Z94QGbDVtfoPKg10DuqvCiwN09bAPqw6ev9TNi3mnQ0V564A40vQ+NNB/SelLDogoQhOUPAgwDCKZQLVy/BnxbuZUmKFC8pfO2tckrFakoCk4yhed7pWS/sMLi/d4I5o8UVug8mReazaN7kKlemH2eYqQtLOiLT5zMsTVrSwg8yDxfsjPiHhGbob3LcRz4RrECzTjaJfiDLg7qvLIHmFLar0C+NQK3j8iztZqyKNgaf5mO4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8c+68+qcFrF9XEinE1+B2F7HpeFycmCYHze14VEYae8=;
 b=W+Uwk3UQAD7L/Ezl56X3FXHf4s5SmcQTtT2yu0u+hDcFfDsXBrJy6P9MBnWRbnpBUwVI4xqk1VYeN9/viT6fs0xJ8SJFOBVigh0GgJ3HuE1Kycow70w1zBsdkYzyvZmWTPvgt1ZPWTGqQ5eFutZxeMIwHKtE0PGsoXY00xNIWFY2SiADmg4e8smdolmqq6vsbLnaE0CNEINH+fcao+1C3HY1sHcfo9/xG79LvDct20bkQ//pv68i8fg9SJWiX8LWHIPLIBAP9c/SPwMe8EpwpGyf5MA57YNEQlXfkRVPmfeTk+5y7mJiaN2rlsNwhdg3hi0VPL6KezrXWVsnuhZZHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SA1PR12MB7175.namprd12.prod.outlook.com (2603:10b6:806:2b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Wed, 14 Aug
 2024 12:37:17 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 12:37:17 +0000
Date: Wed, 14 Aug 2024 09:37:15 -0300
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
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Message-ID: <20240814123715.GB2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
X-ClientProxiedBy: BN9PR03CA0942.namprd03.prod.outlook.com
 (2603:10b6:408:108::17) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SA1PR12MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: e2a09231-85d5-477d-fc4a-08dcbc5dd4ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XZITxWUJO95SBwMru13DUVUM1EmekcmllAIerAFdmEzK5IyvGk74uuqmAAK+?=
 =?us-ascii?Q?N9jkHBD1l2X0XT1AbecLEsA4gZuogOX7i9tPuIQP+XSElZGcusvhsjZW4OP+?=
 =?us-ascii?Q?ixPu8DJg7jApuENyOuU+ChAtafhDqjsDiFHiyUp/HZnsB3oBgv/6afynRcdM?=
 =?us-ascii?Q?kt1EHYKmxRUvo5FTie9BrZRwtX9mmCjVv6292TgYq6eK8vltcIwP+4fI+Yqv?=
 =?us-ascii?Q?SH/GoCGo6U/APiqnuEKc3xWs9PUPPcoyqGk0V756JuxjSdHjY7DMJbeeHKHp?=
 =?us-ascii?Q?TtvnwHwibSubsK+l8EJuTPZ/sl8PyzX269/u2wpCANvoXjUYe2iXxqpEK5xF?=
 =?us-ascii?Q?YlkAyivA53ri5C9qPpXNKQWrQm2h91oFFcKLQ8RTdVS7cvsQMpA6314Csy2I?=
 =?us-ascii?Q?KEb9YVLIauCKRAxXM0fkw2wNSM09v5uiKuJpcz7xcbmo2p5udbB4CNPaujSu?=
 =?us-ascii?Q?yuFuEHPlSnwOP+HPy8yh9yLgbq7nBgy84RLpNwna1Wm3DOQRBUzumXZqIRVc?=
 =?us-ascii?Q?HDPm9V+l7inKG5Ri9lrYPTmNhf6fM2b4JKCBNG6D5uyXRmmj0kN8kYji1CIM?=
 =?us-ascii?Q?s66ysKhyMBjPb/4l9eRNxdVRNlLXxeTPXffzEIVcU85tw7049GSL0acdEAjm?=
 =?us-ascii?Q?efoY521B/xLf2CZ1TqqHpm81+4+Ed0Tnx4eg5V1WpEI1J7GuBDLQRDKj21fF?=
 =?us-ascii?Q?UTGw2O/Ib72XYGCfmXmCM6U6hAebjHyXFge2zEY+tsNNg/gTjIoC6fBLtDbA?=
 =?us-ascii?Q?hAH0rn9+KKYu6G6/Z10euhyNG2MYa1zAIh1nzUxxvQZXA3Z65yZu4pUnBF2e?=
 =?us-ascii?Q?pAjFUT/mhrchInWvTsr/cYus9lhDjaWfI5W0GIjA9r9faqhjx5ws+yejigkD?=
 =?us-ascii?Q?K8fNUnmrLTY5bfHVl5SFN6O7j3K6/DYoHpacJw2Geg7HDIRW9SJnQEzTGwq/?=
 =?us-ascii?Q?35z6bdbEWjCvtvZcxabLcnImvaIeGZBL7RSjBRqTt9V66/HmoJdtGqq/E+jU?=
 =?us-ascii?Q?wzhPcMChamCQdK3Za7nZmD4B0I/x3jcjPqNIPZF4LttvcSoGRd45N/ALjosQ?=
 =?us-ascii?Q?lTMzJo492cQXAG5ebPxAl3HI1heX9+Em51GWu2h0tVe6nstzhHys21HizEdl?=
 =?us-ascii?Q?+qZdFFJOKHd/wV62fdwwruWNn3UXuv+z8YveJPcALp5Ux/Pvfmec0BD8l2wc?=
 =?us-ascii?Q?lpJ1G2OWqAsuPeCHg8jICkcmrWlUPj5P6zJgrB62hbHWSCJe+g3wR1rIfEyw?=
 =?us-ascii?Q?sUWkK9At4LhCseB/99OWH2Nyhr7/+XVGxDi7PMZpxQiPaK9X7Rq9BRtkJvB0?=
 =?us-ascii?Q?PmZU383pAeIxEekl+IKe61MW6eH59AAlRNPVTziHbXHNcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IScOCySLwnlnyLnTEMOT2oiKWHlzNw8ZfHtrtUSe7WG3alqTSmerjXJDe8GS?=
 =?us-ascii?Q?xUPBIRu0AJXfiqpqRe+8NYScbddU37L0vLIWwCsVn2EFSH7KTZ0/jykeRdhi?=
 =?us-ascii?Q?byblbmCAuv1ia4GkUu5m9Pe2yKM50pT9fb0TfX7hvikSd1b8QlT22Tmy/SqZ?=
 =?us-ascii?Q?aKUOR8hAQliJ8m5rcND6rkS/5t0i1XuU0xzdSmjVMZuDodCrTfqELOKRwGxm?=
 =?us-ascii?Q?93TaNwV+p0bJ2y5RC5xpHIgKSZE5CPb89IBW3Dq4vwYiDK9yB9/rO7qSw/M5?=
 =?us-ascii?Q?VxpUTyWRMsgC0Ajae5X5YWqUECbbuz1HJ/dKViBBPHSAqKpmXOLRIYuBHTHz?=
 =?us-ascii?Q?0YmzHR3UCB1/O4Pr7ZnkiwKxVWoP6k9qCyCrvyUHFoUOrl3p3oCndtA6svPr?=
 =?us-ascii?Q?5bTSIA5w8ZIGFxpY3lhKxpAW3/10MxRRMUkSs83gnZrbK/G+PCXrfYTAFHpq?=
 =?us-ascii?Q?NGwSD1m+niF8KA2YaHX3TvTfLHtaYS+z5nj7NJzEtjEFhQqzCR76/vcEIpMI?=
 =?us-ascii?Q?GksOeXH1iCCfOg12IpLNiX5irPAc/XkbBsfhCKBY8zSMaPUnIeAz/rZOkWFw?=
 =?us-ascii?Q?o8JftYPdJ0H5mAuw2bYNMzDn2U+5ScckWtDP3G05pYknzipSPfXvA2C5BxTo?=
 =?us-ascii?Q?66KnmC3GrYkzvHKfkaSiDzzVAusLAAP9A40qz/N1H6+SFGsaF3XjKtJUVXUQ?=
 =?us-ascii?Q?gRwo8GzTR6YpSpCNd2F31mtfrUsPVOonOdv2ta6zZQgm+1iNMtOTTRZXEo++?=
 =?us-ascii?Q?N0uNwWhfEc6/qQm6mj8gqUbGlLJEAelz0bGiTgQnK5CKKQur8vctOhjKtKva?=
 =?us-ascii?Q?diDydZ3EeBSdEFZVXjCleHT4ZOfjlTr5eGBkmwKNluOjfRJoRPI3iHi+ttrz?=
 =?us-ascii?Q?5tVFaRtQsYcTniadHL4MfAnSK2a817cHz7GNFSSWJONQoWWRDYjAMhJRLtkv?=
 =?us-ascii?Q?IXxqYVOSeASeuhem/FaHSQBwZ5OUuFUVZYR6XYzp447Ltlrdqsm7em7Jfcfy?=
 =?us-ascii?Q?KxEfJ+qq8M7L16tAVD3Tpc/z0UpePjHRDAb5+5QPiyNy0t/28LbjurqCMmrd?=
 =?us-ascii?Q?4jZXYGe8qkq0jvxyBzdzjh4HjLcUIp3IDfBByuVgHh3QeJ0g/keDPl6lZWGa?=
 =?us-ascii?Q?9du471UcIFBo3XMz5L9wnMeg/5mG3PPXdO6ZuF/2MktaLGyYc7ygi1Yksno2?=
 =?us-ascii?Q?i0g/rctL1nmwKBciZzU2w0F7qIvkup3ehGIt3qO3/kptrSrytkMkmjakfaAC?=
 =?us-ascii?Q?1NwO9QBnA1ij/XQu13QRuTyZTGrOxF6+kyDSPmG8WhN8Q6MyNb3zus1w8vAT?=
 =?us-ascii?Q?u2Am0mEsggv4TIQn3ZcM7vafgFFGK+wZNkpJbv+++Fq11iFejoIYGjkkXNC3?=
 =?us-ascii?Q?mt6EMBcwfnm29SA21yfrjZfzbBdmE7HOY6563NSJknH2ymTu9oAIr6WVsJbm?=
 =?us-ascii?Q?5YsmPjlSkyFw9knR8wIslm54thzPmCydy4rQAhfS3CSHwtFDgPcTMAztE05s?=
 =?us-ascii?Q?Ftib4lAzojW93lGNFu6oz3P1Fr3/B38hFr+9rirhoPWHazvG7C+0bjPg0xyc?=
 =?us-ascii?Q?yfKG+5UArXfOO4LC4ZPYDHk2bSwGWBjaV1NLDLWj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a09231-85d5-477d-fc4a-08dcbc5dd4ef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:37:17.1704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Whs+wNOX73nbZ9aXnWmQwiB9JsgiqLhoHx1HbWu9uYIHYF/HqaHGHgbL/K6m0aG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7175

On Fri, Aug 09, 2024 at 12:08:50PM -0400, Peter Xu wrote:
> Overview
> ========
> 
> This series is based on mm-unstable, commit 98808d08fc0f of Aug 7th latest,
> plus dax 1g fix [1].  Note that this series should also apply if without
> the dax 1g fix series, but when without it, mprotect() will trigger similar
> errors otherwise on PUD mappings.
> 
> This series implements huge pfnmaps support for mm in general.  Huge pfnmap
> allows e.g. VM_PFNMAP vmas to map in either PMD or PUD levels, similar to
> what we do with dax / thp / hugetlb so far to benefit from TLB hits.  Now
> we extend that idea to PFN mappings, e.g. PCI MMIO bars where it can grow
> as large as 8GB or even bigger.

FWIW, I've started to hear people talk about needing this in the VFIO
context with VMs.

vfio/iommufd will reassemble the contiguous range from the 4k PFNs to
setup the IOMMU, but KVM is not able to do it so reliably. There is a
notable performance gap with two dimensional paging between 4k and 1G
entries in the KVM table. The platforms are being architected with the
assumption that 1G TLB entires will be used throughout the hypervisor
environment.

> Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.  

There is definitely interest here in extending ARM to support the 1G
size too, what is missing?

> The other trick is how to allow gup-fast working for such huge mappings
> even if there's no direct sign of knowing whether it's a normal page or
> MMIO mapping.  This series chose to keep the pte_special solution, so that
> it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so that
> gup-fast will be able to identify them and fail properly.

Make sense

> More architectures / More page sizes
> ------------------------------------
> 
> Currently only x86_64 (2M+1G) and arm64 (2M) are supported.
> 
> For example, if arm64 can start to support THP_PUD one day, the huge pfnmap
> on 1G will be automatically enabled.

Oh that sounds like a bigger step..
 
> VFIO is so far the only consumer for the huge pfnmaps after this series
> applied.  Besides above remap_pfn_range() generic optimization, device
> driver can also try to optimize its mmap() on a better VA alignment for
> either PMD/PUD sizes.  This may, iiuc, normally require userspace changes,
> as the driver doesn't normally decide the VA to map a bar.  But I don't
> think I know all the drivers to know the full picture.

How does alignment work? In most caes I'm aware of the userspace does
not use MAP_FIXED so the expectation would be for the kernel to
automatically select a high alignment. I suppose your cases are
working because qemu uses MAP_FIXED and naturally aligns the BAR
addresses?

> - x86_64 + AMD GPU
>   - Needs Alex's modified QEMU to guarantee proper VA alignment to make
>     sure all pages to be mapped with PUDs

Oh :(

Jason

