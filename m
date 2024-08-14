Return-Path: <kvm+bounces-24163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65561951F20
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C29E2B26104
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909021B86C1;
	Wed, 14 Aug 2024 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bP5ilaOV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BFD1B5819;
	Wed, 14 Aug 2024 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723650805; cv=fail; b=nNKKN7s7mv7nWHDnu+6w9ny9pqjJxDZf6BUCayKX+ptxhW0WyhPekZ+PV4mexKu4E042pbvqUguolCi6awweMO8mEDCTjks1cYQHEDuVRMmsvmoQXNWtVPbpSiXifhJcV09BmjnnieZFhKejV1J/sAsavj55nlqrzf2ExMD7U9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723650805; c=relaxed/simple;
	bh=wb5NFpJ8rfKvR4NcoReutu4CBIFP21A7mMe8v/NDrTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o7eHVOTP7Mflkn9nSNOwPVrV5E9wkLKNNVjumqzRnBYqb4QBmRy+S+Wimuu2O7df0i9v/dYHT2ZcbqcYb4tFyvVmdBmXE0ak2hgMvZynlfndA0mXZNzDcqoqtHekY/nghPt8dG3oN1iFcxdMsTZTU1DCLVNa+ezaZnM5WaoDJSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bP5ilaOV; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CV9bectlEDav3fDTFLdI2VQ/drtM0AeC2RvllyUkcTmOh1scl07NZ3HfpM5tfQzanKMC46fgzwwMt+xPvkudyy9c5fpP/LfcU7A7L2UIEcYaalqZYxy4T8KdQCmT7dyeQyEQaM72NvOukeFYIz+6LaxYrT5k6Lccqxz5nSkGm1jUv+EGES6jQyT3eQMIjc5qlvnpjYsHLNTb2XhiEFoPDobl08RjPRfzrPfBhjFe/Sg+vxNe9YIbHwxB9uRHsRHzB/nRkV3ISenkwOz6HgG2j5oNfnOor5UFUQPoeX4KpDFHTHOlYh4VWYRMvAUbh2bhQDVrpDWJJWzUuq4EkIGlAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfB5cWN7Etape4P9BVQkxXk9RydS0wUToney6qU72/o=;
 b=ASv14LeHJdHLD/D5kVjLwzA2T1iIV7SlpYmr6By2LfNw++sxH6cFREUX63PAmhsQlNxD8RwIoxNjzxMD+PgaFz6Dh15Fz/aaKOoDUGBo7tMCJNw/1tvxSVFpjqvf7JrRgkZB+PiCqzhugZSh3eG/Ojbayj7jhs9Y196Xse15uRUDsB+q6j/v3U1Lr0zP76OQrsNfJestXgxaThmqEeMBdl2ZKc+WEH48BGxpTIMeMm4PKxrIuNS3oNyBGjsGUjAoANx6ev2uOwYF2cWlaviEQ82DQAMJ5lrVgBmrmhOP3T2b4xWBEqgigmTYLeOFGkYDuNjp/K2rO5Bcv1yfmxpfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfB5cWN7Etape4P9BVQkxXk9RydS0wUToney6qU72/o=;
 b=bP5ilaOVD0y6lmHptJPBnmVrH2n3a+67k52Uxqpi3073Wmk+6HbnaF1U9HdnDR4p7y3t1zcY3ujiLJefljVC9B2ysCHsfjavWtrPXVcEVjTtn4QPsIp9tYszLxnTj0oKOHQVuFwFu0s+I0QUvtwca+we5uweI40YGLfUWq/jQZA3BzkKWcStoiVMNLXTmrkXqMAaB9GKtUCEzFu52U9XOnMkaR1V1I7k2QuAFDokLp/N1m0fTYhCFvCYbaQhOFn+Zw535f0s7fuTlgISP8t3zP/jamIdTm0AAMcHQlSlGcHQhEtlAEeDQm5GY0j8/TH+5ItArQiJkS8U4jsv5wsiYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SA3PR12MB7880.namprd12.prod.outlook.com (2603:10b6:806:305::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Wed, 14 Aug
 2024 15:53:20 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 15:53:20 +0000
Date: Wed, 14 Aug 2024 12:53:18 -0300
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
Subject: Re: [PATCH 03/19] mm: Mark special bits for huge pfn mappings when
 inject
Message-ID: <20240814155318.GQ2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-4-peterx@redhat.com>
 <20240814124000.GD2032816@nvidia.com>
 <ZrzL_Yljjw0w9ZSi@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrzL_Yljjw0w9ZSi@x1n>
X-ClientProxiedBy: MN2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:208:23e::34) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SA3PR12MB7880:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e9879e-2766-4077-d569-08dcbc7937d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CYn7XBSP4hK29qd9BzJ+J7sqBfV/oQKoKyr5F5Ba06ZBSYwXal8NhtDJdxpk?=
 =?us-ascii?Q?nvLVPMjPvJthhQdJoJggybX0P2+vxAlhrOutQeXrXe0V54jF4L6y9dds/ofY?=
 =?us-ascii?Q?pNmG90Rel/TSw4iYsUroiNgpIH4prm2boaejLXBb6ZvVGFemAuY78Y5phgqD?=
 =?us-ascii?Q?WLtC7wmM6ma4ofQbWpt5EKKg2Mc8hFtBVV2uqxxV0bvSgwDUPASSlAtsBKL/?=
 =?us-ascii?Q?1D6LW8gQ+RSs9JTGc7MAXdo6maER7YYjOBzg//t/QJ2VMaCb8LpIAiSYmBDT?=
 =?us-ascii?Q?Ctp80kF7828+GYky6hEMt0LE0ZE1cTcRC/bMpiHgbVz1jsQnbwZZh0BavIsq?=
 =?us-ascii?Q?HYiPkdyLKU03GjppSoily3qoHMwklrfVi0vzj1m/jnTDgeY/MrkIbqIXQjWn?=
 =?us-ascii?Q?jYPRg8ZBvdCy+TV4gmdedn4SDB9IMHhToxwqLqw8OkmMclyoBwH5vuR7m0VZ?=
 =?us-ascii?Q?futuiD4pQW+/HSTCHsVgWUKFMyt7+6N7FdhD/vZqILVEA0P/78S24aIpQ44r?=
 =?us-ascii?Q?FQ2zBjTtdg4IoTk+dCixWtx5zbO3+bskLsV8etbZAvp/NhTQuNqPu9GEnsiO?=
 =?us-ascii?Q?gBixLlT39pt2dT/1rO/01hO3ZOwDeTAUqL80MwsPzf3WaZrPRPqQcdj1Pgjs?=
 =?us-ascii?Q?/5Vr4zolMAFfqv5/NqWzc+mx5xmyFjcDHBlAP0kU3rhd2PD0iR7ApmxcCMqZ?=
 =?us-ascii?Q?FLk2vO0ahtKErV/N2qKr7HDMYOKwyXGZYv9BQDHUPL3Q/bs6xhnMgYrTUCZu?=
 =?us-ascii?Q?a2GsFMdz6YePd1PhnfHkbQvUjTRMIr3fT3ha3IZqxhLYHxDgGcyvKZigIYj2?=
 =?us-ascii?Q?ARqVYz+g+go7PThta7/eLxL1XnqEQM1z6hJH9HZn8T3734eSNBqVP09+HJ9c?=
 =?us-ascii?Q?TJZYqueR7MrsN8xh/onp5UsrMIhj17EZ+1n3jonNhXxEmEdD/NS4UqutAZ2r?=
 =?us-ascii?Q?Mk0nnEMM4lf20yQA39wNX5sxQMMm6VPaLPp429sU1XlCh0ek5QcWISiEue1S?=
 =?us-ascii?Q?KcXou0JZCuPHHXob3uQCiUUPLQAqFFC9sdHUh5uNr3IQuiaAiqF/qo0DELVq?=
 =?us-ascii?Q?Lz+maX4pkvSR1rv/gCF3q1sPDydAEBxg4d8BhpB0QMsUgeIKCW3lMp2KyLHR?=
 =?us-ascii?Q?VOFFafnPBa5UVIH3ervxRDRkHB7C1cC1iWHNRaFo9Z0U035/DlHcO6zd3P2+?=
 =?us-ascii?Q?VVkismIrEKMsHwUhyM8rjAj4xi4VzZKFDhPPARXzwwvZmy1DH4B5kzqZIT78?=
 =?us-ascii?Q?UuylK7iDHICyNan6P8ly79g1Cdwnz+GqV8HV2BR1XZph9Lkftp6cqWkINgNS?=
 =?us-ascii?Q?n0GgnisBHUnRVZZUsslkyQTVoD22pubS5CLyk4hzrSrwWA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nLAh5jl8K9bSIO7s1TUwfhdd9QSZNuI4Pb25NEvpayCFRY2GVkMvWa76PnVG?=
 =?us-ascii?Q?qm9112/WCc4dYykxnTafTpDe2KB3aRBM2HPF5a/OtHM0ZMdOkhkY+0dx2N1y?=
 =?us-ascii?Q?yeUHt1AdptVnio6f6sBFqx642WKszrW2TtEssVUsDDrnFuYZoQgDEHIFlgrA?=
 =?us-ascii?Q?s+bfYYdUW+0ZNYzumqnJmWQyi7J52zZgJwRr3/b+jyXvg2MvcVsVLBdNLQrA?=
 =?us-ascii?Q?iJoah41Qucsz6PXJDtw2N73q4HOtgTzmypVQjys5V5h5am3uWGWov2usG/cf?=
 =?us-ascii?Q?nBtTkcdS4UpryTBS1NF+1HdgBOhmtnaqc0lZLwje2nl1Q85FlKz2s6eMAytR?=
 =?us-ascii?Q?jdIIDSzDF2jMgiVRu0pLRUJr8lgpX6FAKvKJ2Dx10CuQdMQlCg/K+iXL/4NV?=
 =?us-ascii?Q?3MAvpWsNEwJtKqHDJyF2pzl6fG64j5pcVmlm0fORHmjd3Vn+daCGM0nQwZmp?=
 =?us-ascii?Q?nbgPPq8Tr6AjCI5f2r3wQ0+McLtZOqTUz7egdsNU7CHmX5n4BMDmMYC5fZQt?=
 =?us-ascii?Q?0Q/5nSZIgTqc7d3vN6Dmjd1jrM3i166xRZQUHROYhoG9qhayROzgvZfCa4zQ?=
 =?us-ascii?Q?G3RLjAMUyJFUX+ADftp1+kP3pr274fwwIKQqtjHivE+DT3iWxP00WQzQpxx5?=
 =?us-ascii?Q?0Jxb/cEZzLqZWh2a0PKkRuSm3yYmINPVvhU17e9J84FrJYlDNcddJaYYYJEN?=
 =?us-ascii?Q?HJIfA3PJYKgj6Cy+0/XJBBj8J3eMEsECLpAdFNm48KYWNoLjaVJthbMQ4VAq?=
 =?us-ascii?Q?Wpf/bY8VF+HzgOlsFr72F9hplmzYKhAagv9kOX6u6w+3t3bQ91P0LEYoQgrq?=
 =?us-ascii?Q?mm7nd/LtbXPWZZUJM5k54N2fI9CQ99uMmvSFDjbYpZ7PBPa2LmSdtOSOalH8?=
 =?us-ascii?Q?aQc5p6Al2MTXBXginGPWBx5d28O2CnjIeDOdYnVfvDlBev3TvKbUggCrTy32?=
 =?us-ascii?Q?jZWPQr5EUb2GdOzcoQct4rgay2FhFnK+w2oIHgqWVZvQ+Pu5L79Hd+q1Wqe/?=
 =?us-ascii?Q?zj/MUvy7V9PnGN+zUxjnIQCgkzk/5pCQjuJvTTSbuTOAcJP1HojSHlQxV+GH?=
 =?us-ascii?Q?WCgPztTogCmumVCB6u2FY1bkBHohonfvN/dTQ1O6fFPmrn9rPr304uzl4w7h?=
 =?us-ascii?Q?9dNxl8l8XeWnb1Hq3xvIJ24TcPR367kCufol5JuYn7UgAu+hBS5FQ/tS+ifd?=
 =?us-ascii?Q?y4AgvrACwSVfIgGSGEokTc9LFr2NT8wmU/Q6lKpmlJSmPWnS4ONMFtReMXLv?=
 =?us-ascii?Q?lcXZq8GRbLmP0aeO8fxMF/M3EES6dHGH7hajJ3s1kISwSHO0yiUjQDSA3iE2?=
 =?us-ascii?Q?g0iDSx6J592FBcfaXeL0VKZb0BQA4tZGEy4bc1VJCqP1oDCBp9HaPYUpOT2r?=
 =?us-ascii?Q?qw4PyMgCotZ+6UHzI5iIs525mqkUr7Qn62/PpDGOKO5olNhbP7qPgoTc2sKM?=
 =?us-ascii?Q?BwSIO5kcTl405QYP9NnRjvq51uxj2LJ5LHJzu/Dke0pvfZHMPrX64GEZuWBc?=
 =?us-ascii?Q?FRc/Ctk4iy34VayzyWBfhKS/VAMxT+BK+a/2l0FiJUDdZxie499eGSqOsiVr?=
 =?us-ascii?Q?zerdjUsFFWIHVme/N6KgMku1XUjzH5Z+JJALblWG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e9879e-2766-4077-d569-08dcbc7937d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 15:53:19.5743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBKZyCKXQiyroetJ1VspJbPc8Ko6/qgUFb57b8I14jflvNHfR2Jy7glNwYlB5mq9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7880

On Wed, Aug 14, 2024 at 11:23:41AM -0400, Peter Xu wrote:
> On Wed, Aug 14, 2024 at 09:40:00AM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 09, 2024 at 12:08:53PM -0400, Peter Xu wrote:
> > > We need these special bits to be around to enable gup-fast on pfnmaps.
> > 
> > It is not gup-fast you are after but follow_pfn/etc for KVM usage
> > right?
> 
> Gup-fast needs it to make sure we don't pmd_page() it and fail early.  So
> still needed in some sort..

Yes, but making gup-fast fail is not "enabling" it :)

> But yeah, this comment is ambiguous and not describing the whole picture,
> as multiple places will so far rely this bit, e.g. fork() to identify a
> private page or pfnmap. Similarly we'll do that in folio_walk_start(), and
> follow_pfnmap.  I plan to simplify that to:
> 
>   We need these special bits to be around on pfnmaps.  Mark properly for
>   !devmap case, reflecting that there's no page struct backing the entry.

Yes

Jason

