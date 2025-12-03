Return-Path: <kvm+bounces-65214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74740C9F48F
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 15:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F1B33A3DA3
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 14:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9F72FC005;
	Wed,  3 Dec 2025 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jt0fg4+8"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB382FB62A;
	Wed,  3 Dec 2025 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764772033; cv=fail; b=gdUI1yYJUcGBCTkbgoX/Nu9A28HhJWYXbPVV6aU8VFsF0YQ+lAnQ1x4iR9kh1AcbSDas0TiRP7ihRoZjLrHtbSa9dy71QES8VVeCw/OJiSK15S6LibNRJSnxmDTB69iJicvxdHNz/WqTNyq1x452dVH7ngwLCVfo/skTHRctt5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764772033; c=relaxed/simple;
	bh=t9qCOgwdkI7HEAjPAtHvVH3HxFq0HGPda5OQ9wJOUj4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zm1MwNY0mfTwZtSWA8vuLU2CL9GCo6UBfngWGovEyOfPWgmCADby1urOMUYSF82twKWqRnkCnKm0B8vGODLx/1SCB0VyVFLQqp156leXWJMOFkTb1t/nYYUhUF8y/bUCsxfH2T1ae+tPHEfc68bZl2TkqQzAyy6j6Ti1dSzjias=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jt0fg4+8; arc=fail smtp.client-ip=40.93.201.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hze+cepH5Q6fT/sILPNvTyVCBpzoW6KZO3z3jXjU2kr/3JVPnS7iMVfABM3iG1HVoDOTX+iRslssvG2U6QvyL78dZuhDt0nbaKXKFaarBa40C8AR90NoFpOqlQb/j08bAOjwuCXgE6eIzRyQdzmhtlkg+n9XZs9QcqEtoY9YcN5CuJDmEPJyYx33fDxIxbwxaGZHOGfT9g3Ci8v/Z2ifOjx5+bibQEy8ug/9UVjnSWjSvcHw8FT6R1zU/EcBRgtqycCVdw6qy0hoSZhKqhPHkeZ0h3un7sxiYDLxd+xBs8KoKUuaSjnWKapHS4WlZBf+wTZasDXVyTmeeQC9ErABkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fOdh18wbnLqD7A33Lq20mZUe0y2vQx2A8LMfM8cEJQ=;
 b=QDHXYD9JIZ6HsEIhFRK4rn/lSaxSNRqePMaQ3bo9cLEEUysI00xgAzfyN9rgcem42qPQgqLyEMsxI+2OF/DnYZCrdw6a0xrb+YEZGRU4vcZ4uZMuqZt2UHlvZpAgDSbC4CJo/HMws+AMkCR8juPGxrr3kA12xfvQGltGboIhnDrYEZlCOdxwT/J12Q/1RWJjxPSofqnT/dT6R+2pZhzqWJGZNShLyzH3dj6cMjL5kcSB3QEK03QUn3iHouhG32shogUH/Gwe6Q1fYc2nHftgdIkyONPzXPa0ALFbO0VX3xCrUbpiJLai/Te/ooY1ce4qtahJRFJ6arLgyupH1el4lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fOdh18wbnLqD7A33Lq20mZUe0y2vQx2A8LMfM8cEJQ=;
 b=Jt0fg4+8on7f7vg9AmZ7redTeS7ILZNXHIGiJm7Zo8LDMwZPzoVcUoGC8QFTjSnqAE4+WxEu67osiUC1vtBsPVmUySsu7WT53kAGkA+GamoGkwRi8P5G07QN3/d+b/XlfI2WDXeic34Kmb3Wa1aeGGTiNAGuNzfJ9gkgkLnsl2g=
Received: from BLAPR03CA0080.namprd03.prod.outlook.com (2603:10b6:208:329::25)
 by MN2PR12MB4344.namprd12.prod.outlook.com (2603:10b6:208:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 14:27:09 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:208:329:cafe::8b) by BLAPR03CA0080.outlook.office365.com
 (2603:10b6:208:329::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Wed,
 3 Dec 2025 14:27:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Wed, 3 Dec 2025 14:27:08 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 3 Dec
 2025 08:27:07 -0600
Date: Wed, 3 Dec 2025 07:47:17 -0600
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20251203134717.475azsubs26pj2x4@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
 <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <20251201234447.5x62vhlg3d5mmtpw@amd.com>
 <aS6uoFyqF+SdGWlI@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aS6uoFyqF+SdGWlI@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|MN2PR12MB4344:EE_
X-MS-Office365-Filtering-Correlation-Id: 839ad995-6d65-4e83-ffec-08de32780a93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UybG9uXCqAFN8IsqJEwy0jUp1/TQeiFpIkX61umKho055BQcf1ijQURVGv/F?=
 =?us-ascii?Q?HoquzrI4R+ZN6VUl9dEJ5LJhn1orDBlhTBCmYljod8gCune5x2Lo+8acKqDY?=
 =?us-ascii?Q?crd6ygxLC3NPKp5+c9mGfH+RAjI8XV7i6LE+iSyRUc4u902Bvox28yUGljJp?=
 =?us-ascii?Q?zmVOKwEtM+xwFLR5fHKtw4n3rBMi1wgesUbrd1v5I2z3dZPsZwJdpera1ijH?=
 =?us-ascii?Q?rfO2M+bX2jcYIA1IuzpnST1q2LwbUXM0KcGu1ZPF7TdZsRWZPMvKV40QCyx4?=
 =?us-ascii?Q?tWmITlQBk/2dzMF+/lCy6iJ55XmjN90gf7haQFfY83HaabeqA6Qgdb1aY4T3?=
 =?us-ascii?Q?LOL9TcAdT0h0eUod9C/MTuQKEv8FNd1ZpbvufpEd4QHnvFJvh5v3TwKyJH9Y?=
 =?us-ascii?Q?Irbaz2rsCmewjcngLNeYzR5neK2KB2KCM0q8x9rXuA+OMMNUxYmWpANwc9oV?=
 =?us-ascii?Q?KUZ8S8TAdDh6oUBTsh35oJBhl4UMjgT8UqtRDrdyFmfXIprdArbauJkSTTKX?=
 =?us-ascii?Q?bPJ9Bkqxvwr6hJZkrLMNeRg76R9gTIBcaVTbe9jJW5TLOFLqeQ+3jGBYJHou?=
 =?us-ascii?Q?5Ff3xgb+/y0ZEjtHCYjN29jfTJ3Jj8ntB8heLweFgRvJ6QFB3q2RHCch6rIG?=
 =?us-ascii?Q?fjoNEmbZM4EpNEnMboGSORHYUsA1Vc3ArpG79WWMjatHvYVQD41Kces6AmKQ?=
 =?us-ascii?Q?9296v4ZlsFYeOwDPEDTTN16Fg6RH9VEuK4Xku3lcSJ9pBJjLEsob2qRm1gmq?=
 =?us-ascii?Q?veityU6IEAOC7BJi1sUAxhY2n1hiE9jU/O1NlQC4w4OpGArYvAt+p4Z07Yq/?=
 =?us-ascii?Q?NSoDTq/SKNiFwNn5NpjMytEB8XaZ5I7/Mbf01CvwrQPMiavxxTWfwI3pLnBW?=
 =?us-ascii?Q?bvwpP48Ywy9Ubr0r2EB3Eqy0kEffJWz3i37rUSfDP2AtRHFHioFb8ZDp5BIA?=
 =?us-ascii?Q?Th/JVM4qCUwUYP6At+oGVrRgXBfakoh8y4FhGbYzbwfp2mHSTcFhxLyL5qc4?=
 =?us-ascii?Q?92VgT5BR/MEvZLEybpimxwzLp+QWQst3c9ccqyFLY5b3XHA9LvA+YZv0nVRm?=
 =?us-ascii?Q?L5/o0wdBNOsux87tqxmadNHewWs9hae8st4f+nKFltXychX82UQiEXeROejy?=
 =?us-ascii?Q?/Vg+dIQMGaDpl2s0Ux0aZ1sLS8dtj65yIusjRfs3BZNEjeR4bpCsuZarD5+k?=
 =?us-ascii?Q?Y9hUetSzC/W/dt6WIKF7E4M+x8g9cxvx3F89IUSxxR/zYWmK7ruzB5FuGCTB?=
 =?us-ascii?Q?ryRh5nytXn/hu06KMMOK7h6NZkYUN5lAmx6BY6CuDWOc9s4CIJxlHAf4IcCo?=
 =?us-ascii?Q?tj5f0osCAFLgCu8d+1qwph+ir2tXoUWq0EmJBc8K2SMuTsiOlQUZmpA3eNAG?=
 =?us-ascii?Q?ncSVLzyHtbSNk3JlYtfZH/+qmoFm0wQxc4m7AWVTPZBQ46VSg1QkAP/68UIq?=
 =?us-ascii?Q?T45IlTkui78HgXAfN7BStZ/FfCPZ/kiVr+BCG2DqYmET8LnT5cH7+Y4TwaTW?=
 =?us-ascii?Q?McvB80I3JWUgJb/AwWTxT1oefYjZgwQ8YvG0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 14:27:08.7743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 839ad995-6d65-4e83-ffec-08de32780a93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4344

On Tue, Dec 02, 2025 at 05:17:20PM +0800, Yan Zhao wrote:
> On Mon, Dec 01, 2025 at 05:44:47PM -0600, Michael Roth wrote:
> > On Tue, Nov 25, 2025 at 11:13:25AM +0800, Yan Zhao wrote:
> > > On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> > > > On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > > > > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > > > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > > >  {
> > > > > >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > > > >  	struct folio *folio;
> > > > > > -	bool is_prepared = false;
> > > > > >  	int r = 0;
> > > > > >  
> > > > > >  	CLASS(gmem_get_file, file)(slot);
> > > > > >  	if (!file)
> > > > > >  		return -EFAULT;
> > > > > >  
> > > > > > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > > > > > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > > > > >  	if (IS_ERR(folio))
> > > > > >  		return PTR_ERR(folio);
> > > > > >  
> > > > > > -	if (!is_prepared)
> > > > > > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > > > > +	if (!folio_test_uptodate(folio)) {
> > > > > > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > > > > > +
> > > > > > +		for (i = 0; i < nr_pages; i++)
> > > > > > +			clear_highpage(folio_page(folio, i));
> > > > > > +		folio_mark_uptodate(folio);
> > > > > Here, the entire folio is cleared only when the folio is not marked uptodate.
> > > > > Then, please check my questions at the bottom
> > > > 
> > > > Yes, in this patch at least where I tried to mirror the current logic. I
> > > > would not be surprised if we need to rework things for inplace/hugepage
> > > > support though, but decoupling 'preparation' from the uptodate flag is
> > > > the main goal here.
> > > Could you elaborate a little why the decoupling is needed if it's not for
> > > hugepage?
> > 
> > For instance, for in-place conversion:
> > 
> >   1. initial allocation: clear, set uptodate, fault in as private
> >   2. private->shared: call invalidate hook, fault in as shared
> >   3. shared->private: call prep hook, fault in as private
> > 
> > Here, 2/3 need to track where the current state is shared/private in
> > order to make appropriate architecture-specific changes (e.g. RMP table
> > updates). But we want to allow for non-destructive in-place conversion,
> > where a page is 'uptodate', but not in the desired shared/private state.
> > So 'uptodate' becomes a separate piece of state, which is still
> > reasonable for gmem to track in the current 4K-only implementation, and
> > provides for a reasonable approach to upstreaming in-place conversion,
> > which isn't far off for either SNP or TDX.
> To me, "1. initial allocation: clear, set uptodate" is more appropriate to
> be done in kvm_gmem_get_folio(), instead of in kvm_gmem_get_pfn().

The downside is that preallocating originally involved just
preallocating, and zero'ing would happen lazily during fault time. (or
upfront via KVM_PRE_FAULT_MEMORY).

But in the context of the hugetlb RFC, it certainly looks cleaner to do
it there, since it could be done before any potential splitting activity,
so then all the tail pages can inherit that initial uptodate flag.

We'd probably want to weigh that these trade-offs based on how it will
affect hugepages, but that would be clearer in the context of a new
posting of hugepage support on top of these changes. So I think it's
better to address that change as a follow-up so we can consider it with
more context.

> 
> With it, below looks reasonable to me.
> > For hugepages, we'll have other things to consider, but those things are
> > probably still somewhat far off, and so we shouldn't block steps toward
> > in-place conversion based on uncertainty around hugepages. I think it's
> > gotten enough attention at least that we know it *can* work, e.g. even
> > if we take the inefficient/easy route of zero'ing the whole folio on
> > initial access, setting it uptodate, and never doing anything with 
> > uptodate again, it's still a usable implementation.

To me as well. But in the context of this series, against kvm/next, it
creates userspace-visible changes to pre-allocation behavior that we
can't justify in the context of this series alone, so as above I think
that's something to save for hugepage follow-up.

FWIW though, I ended up taking this approach for the hugetlb-based test
branch, to address the fact (after you reminded me) that I wasn't fully
zero'ing folio's in the kvm_gmem_populate() path:

  https://github.com/AMDESE/linux/commit/253fb30b076d81232deba0b02db070d5bc2b90b5

So maybe for your testing you could do similar. For newer hugepage
support I'll likely do similar, but I don't think any of this reasoning
or changes makes sense to people reviewing this series without already
being aware of hugepage plans/development, so that's why I'm trying to
keep this series more focused on in-place conversion enablement, because
hugepage plans might be massively reworked for next posting based on LPC
talks and changes in direction mentioned in recent guest_memfd calls and
we are basically just hand-waving about what it will look like at this
point while blocking other efforts.

-Mike

> 
> <...>
> > > > Assuming this patch goes upstream in some form, we will now have the
> > > > following major differences versus previous code:
> > > > 
> > > >   1) uptodate flag only tracks whether a folio has been cleared
> > > >   2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() and
> > > >      the architecture can handle it's own tracking at whatever granularity
> > > >      it likes.
> > > 2) looks good to me.
> > > 
> > > > My hope is that 1) can similarly be done in such a way that gmem does not
> > > > need to track things at sub-hugepage granularity and necessitate the need
> > > > for some new data structure/state/flag to track sub-page status.
> > > I actually don't understand what uptodate flag helps gmem to track.
> > > Why can't clear_highpage() be done inside arch specific code? TDX doesn't need
> > > this clearing after all.
> > 
> > It could. E.g. via the kernel-internal gmem flag that I mentioned in my
> > earlier reply, or some alternative. 
> > 
> > In the context of this series, uptodate flag continues to instruct
> > kvm_gmem_get_pfn() that it doesn't not need to re-clear pages, because
> > a prior kvm_gmem_get_pfn() or kvm_gmem_populate() already initialized
> > the folio, and it is no longer tied to any notion of
> > preparedness-tracking.
> > 
> > What use uptodate will have in the context of hugepages: I'm not sure.
> > For non-in-place conversion, it's tempting to just let it continue to be
> > per-folio and require clearing the whole folio on initial access, but
> > it's not efficient. It may make sense to farm it out to
> > post-populate/prep hooks instead, as you're suggesting for TDX.
> > 
> > But then, for in-place conversion, you have to deal with pages initially
> > faulted in as shared. They might be split prior to initial access as a
> > private page, where we can't assume TDX will have scrubbed things. So in
> > that case it might still make sense to rely on it.
> > 
> > Definitely things that require some more thought. But having it inextricably
> > tied to preparedness just makes preparation tracking similarly more
> > complicated as it pulls it back into gmem when that does not seem to be
> > the direction any architectures other SNP have/want to go.
> > 
> > > 
> > > > My understanding based on prior discussion in guest_memfd calls was that
> > > > it would be okay to go ahead and clear the entire folio at initial allocation
> > > > time, and basically never mess with it again. It was also my understanding
> > > That's where I don't follow in this patch.
> > > I don't see where the entire folio A is cleared if it's only partially mapped by
> > > kvm_gmem_populate(). kvm_gmem_get_pfn() won't clear folio A either due to
> > > kvm_gmem_populate() has set the uptodate flag.
> > > 
> > > > that for TDX it might even be optimal to completely skip clearing the folio
> > > > if it is getting mapped into SecureEPT as a hugepage since the TDX module
> > > > would handle that, but that maybe conversely after private->shared there
> > > > would be some need to reclear... I'll try to find that discussion and
> > > > refresh. Vishal I believe suggested some flags to provide more control over
> > > > this behavior.
> > > > 
> > > > > 
> > > > > It's possible (at least for TDX) that a huge folio is only partially populated
> > > > > by kvm_gmem_populate(). Then kvm_gmem_get_pfn() faults in another part of the
> > > > > huge folio. For example, in TDX, GFN 0x81f belongs to the init memory region,
> > > > > while GFN 0x820 is faulted after TD is running. However, these two GFNs can
> > > > > belong to the same folio of order 9.
> > > > 
> > > > Would the above scheme of clearing the entire folio up front and not re-clearing
> > > > at fault time work for this case?
> > > This case doesn't affect TDX, because TDX clearing private pages internally in
> > > SEAM APIs. So, as long as kvm_gmem_get_pfn() does not invoke clear_highpage()
> > > after making a folio private, it works fine for TDX.
> > > 
> > > I was just trying to understand why SNP needs the clearing of entire folio in
> > > kvm_gmem_get_pfn() while I don't see how the entire folio is cleared when it's
> > > partially mapped in kvm_gmem_populate().
> > > Also, I'm wondering if it would be better if SNP could move the clearing of
> > > folio into something like kvm_arch_gmem_clear(), just as kvm_arch_gmem_prepare()
> > > which is always invoked by kvm_gmem_get_pfn() and the architecture can handle
> > > it's own tracking at whatever granularity.
> > 
> > Possibly, but I touched elsewhere on where in-place conversion might
> > trip up this approach. At least decoupling them allows for the prep side
> > of things to be moved to architecture-specific tracking. We can deal
> > with uptodate separately I think.
> > 
> > -Mike
> > 
> > > 
> > >  
> > > > > Note: the current code should not impact TDX. I'm just asking out of curiosity:)
> > > > > 
> > > > > [1] https://lore.kernel.org/all/aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com/
> > > > > 
> > > > >  
> 

