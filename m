Return-Path: <kvm+bounces-52178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 838B6B02043
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 17:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B256316C5E8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81ECE2E4252;
	Fri, 11 Jul 2025 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kfgcLOzK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF24C18DF8D;
	Fri, 11 Jul 2025 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752247082; cv=fail; b=uLZio6WdAa4VRn6H9XMU/rKZGXE5rYNXczDfDqNH/jStxb3Er7oqZZjysvRVGE8DO2OyPOXq1vuyvHW9y3N/DC1Elmnei2DJUdbPzh60o1+SdShpqkDftppuAaCmu1PHlKgLbstM9pLdzhyBEXDKhxs4zgbMAlidEEjbqOpk/EY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752247082; c=relaxed/simple;
	bh=ZciK/iG8LcmPdJUp/7Bm1h0LpPjvmCyl3iDHGgpkCOk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUPiI2Z4XdxUhJZOXuzMdZJXE4+cfijy5bglYcS7ZmrF3XH4llw/RFm9j8jFEG2+5oHyU222YGKxwk1owVUlWMYU1c90Nwr/rV+cv3jqwxtPU/BFY0BYlqEzqwtBGDGcr3qtVPnwVdbYNvsF+HWOUS1XG6VlZk7YvoC/tM8jE5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kfgcLOzK; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aw1R0sdF7OPUCmoaVsDhGZ1sVZ72qr4d1BzZaCe1k2Y129Vrm3M9kXjRtD2iycdoK7979nh6tTPxP1Y5bTgKyLDcZQQrveFnEmckLGFnJAVUXyHzxA4rLNjYlqcAEcU/Vg8UR3FfIc11N8eQJ2F3wofu9z44oQAYc9llxd5PvN9QUoDwDc5rpO8lf6U3RvaGRwua2Yhs5ywsMihjvzEaMHtqpuTO2gjtBFX6zsqfF6LTYtNu+Ao5uNtkJXDXWcQqNag/rmlxuee9T22vuaGpeE0YvWafcppRjtgBDP43Pd1bJUcKYn9yTH4JPtNUFiMEOjpOichAffBFZFPBrJuKcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqEeewhd+fl0jnBcABeAMkEHdnmwhXLPOa4fWFl3jJY=;
 b=QZrDTpm+axc3iKrjp2qLfRs3/JOrOeBXk/Mpd17kYnWUeZGWlJ6QUSaIhkfc2Vh+9NweM1PGuXVATUgJg2Hpt9FyESs8CP8xA1tadlqn2Y2w3luNnFL2CsWSyo/0mnBUFEDN98GjUY1pf98OLXALh7/8hDloAQBQWdKO+B/5vAdgKSXlUQykMrDSvwPbG1HMZRP/GxVUfnDXMiXNt23yqLB1Y1UhZ+iJbVeqizI5wsYqDMZS7VHadUxfbMTCk3JrN5wTLdjmsDZTVnmDMVch1F5f/Xp3EvTKbJ1w/cfMdQbGrw1jEiHaFRf6C62HicVtFnd8Bm5zP3Jri95WklEPaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqEeewhd+fl0jnBcABeAMkEHdnmwhXLPOa4fWFl3jJY=;
 b=kfgcLOzKCdT3vP9TygebbFqUfqqmf/tE4KSVergkCUiPtzgzipTyet4pIhZf8YULPu3JS3asQhdluDwPAX/Bn506bsUWSuZt+oEfYYrlZq1XttUHkS7kwjqaQ2xIf2tejOklIj1X4eXE9ldioqcP3TTTRItsNv4csIGoED3lUWI=
Received: from BY5PR04CA0002.namprd04.prod.outlook.com (2603:10b6:a03:1d0::12)
 by DS0PR12MB9039.namprd12.prod.outlook.com (2603:10b6:8:de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 15:17:57 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::c2) by BY5PR04CA0002.outlook.office365.com
 (2603:10b6:a03:1d0::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.23 via Frontend Transport; Fri,
 11 Jul 2025 15:17:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Fri, 11 Jul 2025 15:17:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Jul
 2025 10:17:55 -0500
Date: Fri, 11 Jul 2025 10:17:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <20250711151719.goee7eqti4xyhsqr@amd.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHCUyKJ4I4BQnfFP@yzhao56-desk>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|DS0PR12MB9039:EE_
X-MS-Office365-Filtering-Correlation-Id: 55555110-8968-482b-b21e-08ddc08e1d70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i0C43kaVCMXkTIjG/jgvMlytePyrkExHedQb6VBq86j3y0n+3EHERVSaZ4Mz?=
 =?us-ascii?Q?GL4NnL7lRuhhTkISBTPszE6cLRSQU/itakpsBRZv0deZ6sjFs2vdQx7HHwv5?=
 =?us-ascii?Q?1U3HVOcpTbOi/6mrve2d6yKnyyP18tQU6kq529qStZ5ilsHQ+kYryW8teDKT?=
 =?us-ascii?Q?TsEreWAiBSSvv3xviXcDZS4Zjk9oqreaq6VapM6AmVOWCGN6QMa1fLHVdyKD?=
 =?us-ascii?Q?baQDnYrZhkkceGEXDrxUiZc/3jsmbnBLSs1d9mlqoKChoiIIY2pEpofWxmeJ?=
 =?us-ascii?Q?Ej2e7kkFDD2UxVWp2TWWGJHNNuHF3PrpaeePeRcSq8O/o9OefYaeqvt1XnAf?=
 =?us-ascii?Q?YxqhJsjbqI7KM0Zy7sGEl8R9EZFC3rWy0fHH8/ff4Uy7pqBSu7XDXBs5csKU?=
 =?us-ascii?Q?SrNQWqNLh5/WQPOzGQoF2osMP7q82k0wabggHHYxW3AD1kKCv25T+smc+WRz?=
 =?us-ascii?Q?2f/pZhCxyWBmV/3GXE1ARGgSSIu0eBI7TqdOrTHb//ZBfA1LG8rG1s+4RUJE?=
 =?us-ascii?Q?Y52PE2Acr1ydqIhOYcO9Qcr3hNPIfO/+nIy8tETyr68LGDcpvhURG4TG+l0O?=
 =?us-ascii?Q?5IR4FxfbZPJ6oJ4mpnUiJnHpudsW/NxYTkRJQtTfDpkgdWQS9XWrmp40GXju?=
 =?us-ascii?Q?Tol5wCsJESIo7eYD57lUDWfLf1pvS6OVSp4aceWoVhv1UotqL/I4ky0HZZ8t?=
 =?us-ascii?Q?9+ukQQHK6HbYwpyyOhG283ULtgrz0LCc24xEH5eN33cz/ypxY6vtQJVLCykm?=
 =?us-ascii?Q?brVNtQ4MxRJKqBjivvxTeOzmvKlziDZMiwJWSiimAxJhDto3cbKK8lbiML94?=
 =?us-ascii?Q?eAr1/nFxUFQQaIkpxFooXyS9Il2p5v5SMvdi40NNQZdA9eDL56nw9KgS7XsC?=
 =?us-ascii?Q?oDL8KSFBPqDRpgF3Xvn8f65LjKlHS6vxVQ00JthVuydpSHsD9+VL/Te426Wt?=
 =?us-ascii?Q?sqxyYXOyJnCLNVEI02QzygCbBOQp34IOBIEfeygOnnyDOEjuL2WXgsd1zaIh?=
 =?us-ascii?Q?OBxjzhy4Yj/kfWhj7stQHiipB3QVXmsmrAQ36/EixsUXevteLIw/0HpNedJJ?=
 =?us-ascii?Q?E2A/KmuA+kFk8mjsrFeTLNW3D1VF/XTIHFwz5SxnfTinvThuLez1TRQh/lqV?=
 =?us-ascii?Q?1dVuEzPeHbF7703KzGLFjdRGCCjIjvSD1kLmVMsAxc5mwvsE1c0ppE02NoUz?=
 =?us-ascii?Q?fqjgjSPnVuusvKbnCjUGCO0gKXsH5J0FscCBxjoojNB2jun54i+6ghU0Gc1z?=
 =?us-ascii?Q?cEHMvfuxH3ofsp8D2lASE9XS0hHyXLm3RftVurTYZg/K2F6LHtCQruwspWId?=
 =?us-ascii?Q?xabyyDOP/T0pbm+kKPOVOy0NMPmrPsvzyzmzqbQW9RB4UPExRQ1CLSmv+zPJ?=
 =?us-ascii?Q?BKy4z+tQ6pZqhtNedt9V+5iGvg/GFtA9aQAXwwYOBrcV/oyx88H9JLIozSTc?=
 =?us-ascii?Q?xkkcsgQXfDjJ/MrVIgrNob99ip0sG/R5vYENSWlYxVfkCQ7Ky+uEgWW4hK5F?=
 =?us-ascii?Q?cmb7KUOcWTnQ339/2oTL7JDM3IA+XoujH66b?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 15:17:56.6946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55555110-8968-482b-b21e-08ddc08e1d70
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9039

On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> On Thu, Jul 10, 2025 at 09:24:13AM -0700, Sean Christopherson wrote:
> > On Wed, Jul 09, 2025, Michael Roth wrote:
> > > On Thu, Jul 03, 2025 at 02:26:41PM +0800, Yan Zhao wrote:
> > > > Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region()
> > > > to use open code to populate the initial memory region into the mirror page
> > > > table, and add the region to S-EPT.
> > > > 
> > > > Background
> > > > ===
> > > > Sean initially suggested TDX to populate initial memory region in a 4-step
> > > > way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
> > > > interface [2] to help TDX populate init memory region.
> > 
> > I wouldn't give my suggestion too much weight; I did qualify it with "Crazy idea."
> > after all :-)
> > 
> > > > tdx_vcpu_init_mem_region
> > > >     guard(mutex)(&kvm->slots_lock)
> > > >     kvm_gmem_populate
> > > >         filemap_invalidate_lock(file->f_mapping)
> > > >             __kvm_gmem_get_pfn      //1. get private PFN
> > > >             post_populate           //tdx_gmem_post_populate
> > > >                 get_user_pages_fast //2. get source page
> > > >                 kvm_tdp_map_page    //3. map private PFN to mirror root
> > > >                 tdh_mem_page_add    //4. add private PFN to S-EPT and copy
> > > >                                          source page to it.
> > > > 
> > > > kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
> > > > invalidate lock also helps ensure the private PFN remains valid when
> > > > tdh_mem_page_add() is invoked in TDX's post_populate hook.
> > > > 
> > > > Though TDX does not need the folio prepration code, kvm_gmem_populate()
> > > > helps on sharing common code between SEV-SNP and TDX.
> > > > 
> > > > Problem
> > > > ===
> > > > (1)
> > > > In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
> > > > changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
> > > > invalidation lock for protecting its preparedness tracking. Similarly, the
> > > > in-place conversion version of guest_memfd series by Ackerly also requires
> > > > kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
> > > > 
> > > > kvm_gmem_get_pfn
> > > >     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> > > > 
> > > > However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
> > > > in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
> > > > filemap invalidation lock.
> > > 
> > > Bringing the prior discussion over to here: it seems wrong that
> > > kvm_gmem_get_pfn() is getting called within the kvm_gmem_populate()
> > > chain, because:
> > > 
> > > 1) kvm_gmem_populate() is specifically passing the gmem PFN down to
> > >    tdx_gmem_post_populate(), but we are throwing it away to grab it
> > >    again kvm_gmem_get_pfn(), which is then creating these locking issues
> > >    that we are trying to work around. If we could simply pass that PFN down
> > >    to kvm_tdp_map_page() (or some variant), then we would not trigger any
> > >    deadlocks in the first place.
> > 
> > Yes, doing kvm_mmu_faultin_pfn() in tdx_gmem_post_populate() is a major flaw.
> > 
> > > 2) kvm_gmem_populate() is intended for pre-boot population of guest
> > >    memory, and allows the post_populate callback to handle setting
> > >    up the architecture-specific preparation, whereas kvm_gmem_get_pfn()
> > >    calls kvm_arch_gmem_prepare(), which is intended to handle post-boot
> > >    setup of private memory. Having kvm_gmem_get_pfn() called as part of
> > >    kvm_gmem_populate() chain brings things 2 things in conflict with
> > >    each other, and TDX seems to be relying on that fact that it doesn't
> > >    implement a handler for kvm_arch_gmem_prepare(). 
> > > 
> > > I don't think this hurts anything in the current code, and I don't
> > > personally see any issue with open-coding the population path if it doesn't
> > > fit TDX very well, but there was some effort put into making
> > > kvm_gmem_populate() usable for both TDX/SNP, and if the real issue isn't the
> > > design of the interface itself, but instead just some inflexibility on the
> > > KVM MMU mapping side, then it seems more robust to address the latter if
> > > possible.
> > > 
> > > Would something like the below be reasonable? 
> > 
> > No, polluting the page fault paths is a non-starter for me.  TDX really shouldn't
> > be synthesizing a page fault when it has the PFN in hand.  And some of the behavior
> > that's desirable for pre-faults looks flat out wrong for TDX.  E.g. returning '0'
> > on RET_PF_WRITE_PROTECTED and RET_PF_SPURIOUS (though maybe spurious is fine?).
> > 
> > I would much rather special case this path, because it absolutely is a special
> > snowflake.  This even eliminates several exports of low level helpers that frankly
> > have no business being used by TDX, e.g. kvm_mmu_reload().
> > 
> > ---
> >  arch/x86/kvm/mmu.h         |  2 +-
> >  arch/x86/kvm/mmu/mmu.c     | 78 ++++++++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/mmu/tdp_mmu.c |  1 -
> >  arch/x86/kvm/vmx/tdx.c     | 24 ++----------
> >  4 files changed, 78 insertions(+), 27 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index b4b6860ab971..9cd7a34333af 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -258,7 +258,7 @@ extern bool tdp_mmu_enabled;
> >  #endif
> >  
> >  bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
> > -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> > +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
> >  
> >  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> >  {
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6e838cb6c9e1..bc937f8ed5a0 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4900,7 +4900,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  	return direct_page_fault(vcpu, fault);
> >  }
> >  
> > -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> > +static int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa,
> > +				 u64 error_code, u8 *level)
> >  {
> >  	int r;
> >  
> > @@ -4942,7 +4943,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> >  		return -EIO;
> >  	}
> >  }
> > -EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
> >  
> >  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  				    struct kvm_pre_fault_memory *range)
> > @@ -4978,7 +4978,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  	 * Shadow paging uses GVA for kvm page fault, so restrict to
> >  	 * two-dimensional paging.
> >  	 */
> > -	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
> > +	r = kvm_tdp_prefault_page(vcpu, range->gpa | direct_bits, error_code, &level);
> >  	if (r < 0)
> >  		return r;
> >  
> > @@ -4990,6 +4990,77 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  	return min(range->size, end - range->gpa);
> >  }
> >  
> > +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > +{
> > +	struct kvm_page_fault fault = {
> > +		.addr = gfn_to_gpa(gfn),
> > +		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> > +		.prefetch = true,
> > +		.is_tdp = true,
> > +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> > +
> > +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> > +		.req_level = PG_LEVEL_4K,
> kvm_mmu_hugepage_adjust() will replace the PG_LEVEL_4K here to PG_LEVEL_2M,
> because the private_max_mapping_level hook is only invoked in
> kvm_mmu_faultin_pfn_gmem().
> 
> Updating lpage_info can fix it though.
> 
> > +		.goal_level = PG_LEVEL_4K,
> > +		.is_private = true,
> > +
> > +		.gfn = gfn,
> > +		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> > +		.pfn = pfn,
> > +		.map_writable = true,
> > +	};
> > +	struct kvm *kvm = vcpu->kvm;
> > +	int r;
> > +
> > +	lockdep_assert_held(&kvm->slots_lock);
> > +
> > +	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> > +		return -EIO;
> > +
> > +	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
> > +		return -EPERM;
> > +
> > +	r = kvm_mmu_reload(vcpu);
> > +	if (r)
> > +		return r;
> > +
> > +	r = mmu_topup_memory_caches(vcpu, false);
> > +	if (r)
> > +		return r;
> > +
> > +	do {
> > +		if (signal_pending(current))
> > +			return -EINTR;
> > +
> > +		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
> > +			return -EIO;
> > +
> > +		cond_resched();
> > +
> > +		guard(read_lock)(&kvm->mmu_lock);
> > +
> > +		r = kvm_tdp_mmu_map(vcpu, &fault);
> > +	} while (r == RET_PF_RETRY);
> > +
> > +	if (r != RET_PF_FIXED)
> > +		return -EIO;
> > +
> > +	/*
> > +	 * The caller is responsible for ensuring that no MMU invalidations can
> > +	 * occur.  Sanity check that the mapping hasn't been zapped.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> > +		cond_resched();
> > +
> > +		scoped_guard(read_lock, &kvm->mmu_lock) {
> > +			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, fault.addr), kvm))
> > +				return -EIO;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_tdp_mmu_map_private_pfn);
> 
> Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
> log:
> 
> Problem
> ===
> ...
> (2)
> Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> - filemap invalidation lock --> mm->mmap_lock
> 
> However, in future code, the shared filemap invalidation lock will be held
> in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> - mm->mmap_lock --> filemap invalidation lock

I wouldn't expect kvm_gmem_fault_shared() to trigger for the
KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it).
There was some discussion during previous guest_memfd upstream call
(May/June?) about whether to continue using kvm_gmem_populate() (or the
callback you hand it) to handle initializing memory contents before
in-place encryption, verses just expecting that userspace will
initialize the contents directly via mmap() prior to issuing any calls
that trigger kvm_gmem_populate().

I was planning on enforcing that the 'src' parameter to
kvm_gmem_populate() must be NULL for cases where
KVM_MEMSLOT_SUPPORTS_GMEM_SHARED is set, or otherwise it will return
-EINVAL, because:

1) it avoids this awkward path you mentioned where kvm_gmem_fault_shared()
   triggers during kvm_gmem_populate()
2) it makes no sense to have to have to copy anything from 'src' when we
   now support in-place update

For the SNP side, that will require a small API update for
SNP_LAUNCH_UPDATE that mandates that corresponding 'uaddr' argument is
ignored/disallowed in favor of in-place initialization from userspace via
mmap(). Not sure if TDX would need similar API update.

Would that work on the TDX side as well?

Thanks,

Mike

