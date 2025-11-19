Return-Path: <kvm+bounces-63635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A072C6C1C2
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E972F4E4348
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11ACF1E32D3;
	Wed, 19 Nov 2025 00:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zxCqcKb1"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA1D7082F;
	Wed, 19 Nov 2025 00:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763511564; cv=fail; b=XgcsWIXzVac08P+llgraiShnmJaBEwnIrCvuk/KihxTB3n3amQB8gAP3fLWAdhS2JfgBXgRrNQJgai32dDjruSVO9cXFguzeH7/dmVEDIeKr9GfcZrN1t7UPwHQS3ddZkakJjZ0mm5P3FYbJAUU+QI3mwtYf3wVICLwOT/zk0RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763511564; c=relaxed/simple;
	bh=e1omNUZzD1ePMIlH1JfC6BHW59YRjUqmBItNsY9QhBM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muTO57birrCfo3uDLYEbkOZ6KGSlKbf5HVn+fMnP3ocAAPRvA2CBZ5gyrwv4jP4R+ywNchHF4Pbk0ciic6LUwP8PrLR/nMPE0y/r99M16P9WCLoF43KXfecXpjUd2A2wMfxZvKptvhi+/8ZfILhR0UZTLHhYT8H9ak87w/s6Rzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zxCqcKb1; arc=fail smtp.client-ip=52.101.43.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtEvaCA3PIFOINt9MjTankK3mYOihAjW479urRj/irpyFGlkE/WUsFdRoKKUk2o9CAGyGcfMPYTRh72iTiugk/iIJnWnp+LByKLlIzSKq5Ku9Tcf+60hRwcetnJHam/kVu/Nxa8Lkp8UrmxOfHl/5DLCWEnUvKqwYBCrJUerkT+31PQ6XVcSvW+R/YOKgmzkl3PNnZbmaIsJP9gT9nUF4nxCCxwa6Cjordf0QcnqeHqvL7B9c6YwnJtmNjAkScLs1cr0akpu0lWeMxp4zWFaNLycz1iISBLDHkjKOE6oNYVO85LFC+Bj9MHcLVBhblJVj2CWxQiQNMCo5g4ud3Gerg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKYS/svfp/P9esRciBmgOf/ZbpjghbQN6DFVVWI2PgQ=;
 b=RFqMb9kSKO9A8E7E2uy3RXaNE7tyJi1KxclieX46ZpmfgU1T81Rlz1z1UtAeQejDwAyO3CbZwuYaZPhsyEPnLNmdYfUyfaEdpIZ4wi7x6rYCXdsVkNCDiEHyhh71WfARJ902Gb+eIeS3k1mhfe9XLE7KF9Ei4N4ks7pyMIKOyt6OHfA18PRZFCY33XjkLXZK/O5OulcdZf6JvDb1h9nOvF0QM1Ai2qqCNieVsFVvAdO5yYmzmU1g/hxKrwZ3SblJodUGVw5HhdD/XR56Hw/GMAxSdCurP/w2GG5suJibKaH3Na4igrTN50WgrImemiIsNBlUHe3vFQoLTZI2+0rScg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKYS/svfp/P9esRciBmgOf/ZbpjghbQN6DFVVWI2PgQ=;
 b=zxCqcKb1lSpjJFAUmBUkaWO9iuVOQGnzXnpNC3Nl90B4K/fjZcyc5S4VAoEDG4opDjW6nP/WBoPdojRaOFm/DQ6QBdsVnxxP09UggLE30Q7hEmCYCbEnGCUfW3g4ur+5WA8jSZAWC/xSRu9iyMtNN41AHaAvAct8TEBi1buF5CI=
Received: from BN0PR04CA0135.namprd04.prod.outlook.com (2603:10b6:408:ed::20)
 by DS0PR12MB8504.namprd12.prod.outlook.com (2603:10b6:8:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 00:19:13 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::20) by BN0PR04CA0135.outlook.office365.com
 (2603:10b6:408:ed::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 00:19:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 00:19:12 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 18 Nov
 2025 16:19:12 -0800
Date: Tue, 18 Nov 2025 18:18:52 -0600
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <aik@amd.com>, <ira.weiny@intel.com>,
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20251119001852.jx3lydjhk4xj2xst@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <diqzqztwb495.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzqztwb495.fsf@google.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|DS0PR12MB8504:EE_
X-MS-Office365-Filtering-Correlation-Id: 00188fb3-68e9-45c4-4394-08de27014462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FYy2ZKrb/+RYvYNbPSzQi0418SfDO6lU4mL/daBdcb9G02rVnuk2DU6HEsos?=
 =?us-ascii?Q?jACdpei2X31dx0V4O+XrN77XkBOEGHee/2Zm15gB6AeDuvfgkk2t+Gk3viYS?=
 =?us-ascii?Q?gXbmiv7hrlja2mdpPyuHBvlzLrN26MJlUqhLb4lX1vP1vksOudxymfxewDpM?=
 =?us-ascii?Q?cnts7TCvTV1BuYL5rmYfFG5SmGgdXFwKVGvT8GqAUoM5Ax+BdhicuMQRIyxP?=
 =?us-ascii?Q?Bh4BU2o+VYnVet5h5eZ4InRtou/sxXBjpttvuyc82ssIQSTFcOVtU3HR7+kr?=
 =?us-ascii?Q?pM7E9Sm/6mkqiWRDQzhjUOqBzEaSjjrhROBLjrurzUKb+kxRsD+UKQ1ORWmx?=
 =?us-ascii?Q?ZZeYNSfarsDjQVC3mXYgU7BWnPPVtBBHw4ejiIwESdTxuDLfajPThFcqIoTx?=
 =?us-ascii?Q?engkTKSwy2j80CcjJ6urelB6dvtGM43zVCJg5JiyPh8Z5WUDHcRvN6fSOyDA?=
 =?us-ascii?Q?cxiwmWfhzkTHQL3O9eq9WibQlS00ymd/YXCtm3m3mFW9mAkaN7vOIL/HO30B?=
 =?us-ascii?Q?ZK3eiVh+6ToDdxlwb60D2JpxicbrxKoUk6US0C3jnc+eHP69JQGyxfVbP4Ua?=
 =?us-ascii?Q?EaZZpvd1gthxyt6ZghRfcEj3r9x1WYPpZJ5AbiRQBcpYssH6Jda+sFAU9gOt?=
 =?us-ascii?Q?uhxFvc48dxKas6erwJ6wrrd1s2P65gECMiFrcRCI7HqNIZOTe3AydEgWWteP?=
 =?us-ascii?Q?If6gPoLzbUHj0c6psXv50W38443PAlJ+aEbZU+wtJKndwRyTG6OKcABf9fI7?=
 =?us-ascii?Q?d7UlPe/kKwRUQTOy51IzV5Ba2+fMe7gMEqnWgtLvpMArzPDLYSdcZb0gf/6w?=
 =?us-ascii?Q?8ZnQK46y01d//cRRehs+MzmRtwBwPkHvxFKx3CJ42D65nvYVTEc07CHoPjO7?=
 =?us-ascii?Q?rC7RakPcZkLwXRCBA7QpNppXRzeksw2STOlpKdmL9nDPR11yISwZMnZbymxi?=
 =?us-ascii?Q?B5esVNFTH3rKDsxh+5+qM23dhODiCIbqlLlkRckVoWcaCW7/70CmNd2ZXkZg?=
 =?us-ascii?Q?ulm4BYSpBjcJFW8wb6FmlDC2v9L4dAGWSi0weR07QVSCNQ7oyHsbH1GUbDGe?=
 =?us-ascii?Q?JQ17lL0n1MjUezlLO45nOoUtJvBHUfIxmPSdT7zkaU0Erf3ZCpnBSVgdoKFw?=
 =?us-ascii?Q?tSbkUSOaaHMiWjMgeKnS4+hXKbiUxsKjWA/hTUQZ34vI/55eMrmxKZhcZoIW?=
 =?us-ascii?Q?QnQB0MeJRMCouvVtZ1QNPpUwny+b+bI9MtTg5Ht+8C8D/wgatbSjk9YoH4gy?=
 =?us-ascii?Q?XoD/i8mz8l5rx+J9qpXe2qBwE7WLVW2b0ftjd5BeHLQqmrxw6sbm+6uO/9Pp?=
 =?us-ascii?Q?oiNS7/SVt2FebXSYtPZ/h5zzVN4ZNGTZZ+HV99hopC94ffZ/Kl7FRlglqT1I?=
 =?us-ascii?Q?PItDCGHU0UKmKPr2bIV8aycesVx6mdxA2sZ4arGWHDJHNpBcnOSTtP5Z7EXD?=
 =?us-ascii?Q?3q1F7BPtOxNqVfelnKASVPUD51W2LUodgb9gEKQyxomzfUtgb5CN5cEclIEO?=
 =?us-ascii?Q?GVYMzqlW6xRYm0WogkFu1NUrtGbvnRPPysbH2ZtMZTe5UsSEyAKkOuUCXjO6?=
 =?us-ascii?Q?r0r6A+zzb9PlljE5Jrk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 00:19:12.8516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00188fb3-68e9-45c4-4394-08de27014462
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8504

On Mon, Nov 17, 2025 at 03:58:46PM -0800, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > guest_memfd currently uses the folio uptodate flag to track:
> >
> >   1) whether or not a page has been cleared before initial usage
> >   2) whether or not the architecture hooks have been issued to put the
> >      page in a private state as defined by the architecture
> >
> > In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> > there do not seem to be any plans/reasons that would suggest this will
> > change in the future, so this additional tracking/complexity is not
> > really providing any general benefit to guest_memfd users. Future plans
> > around in-place conversion and hugepage support, where the per-folio
> > uptodate flag is planned to be used purely to track the initial clearing
> > of folios, whereas conversion operations could trigger multiple
> > transitions between 'prepared' and 'unprepared' and thus need separate
> > tracking, will make the burden of tracking this information within
> > guest_memfd even more complex, since preparation generally happens
> > during fault time, on the "read-side" of any global locks that might
> > protect state tracked by guest_memfd, and so may require more complex
> > locking schemes to allow for concurrent handling of page faults for
> > multiple vCPUs where the "preparedness" state tracked by guest_memfd
> > might need to be updated as part of handling the fault.
> >
> > Instead of keeping this current/future complexity within guest_memfd for
> > what is essentially just SEV-SNP, just drop the tracking for 2) and have
> > the arch-specific preparation hooks get triggered unconditionally on
> > every fault so the arch-specific hooks can check the preparation state
> > directly and decide whether or not a folio still needs additional
> > preparation. In the case of SEV-SNP, the preparation state is already
> > checked again via the preparation hooks to avoid double-preparation, so
> > nothing extra needs to be done to update the handling of things there.
> >
> 
> This looks good to me, thanks!
> 
> What do you think of moving preparation (or SNP-specific work) to be
> done when the page is actually mapped by KVM instead? So whatever's done
> in preparation is now called from KVM instead of within guest_memfd [1]?

Now that preparation tracking is removed, it is now completely decoupled
from the kvm_gmem_populate() path and fully contained in
kvm_gmem_get_pfn(), where it becomes a lot more straightforward to move
this into the KVM MMU fault path.

But gmem currently also handles the inverse operation via the
gmem_invalidate() hooks, which is driven separately from the KVM MMU
notifiers. And it's not so simple to just plumb it into those paths,
but invalidation in this sense involves clearing the 'validated' bit
in the RMP table for the page, which is a destructive operation, whereas
the notifiers as they exist today can be using for non-destructive
operations like simply rebuilding stage2 mappings. So we'd probably need
to think through what that would look like if we really want to move
preparation/un-preparation out of gmem.

So I think it makes sense to consider this patch as-is as a stepping
stone toward that, but I don't have any objection to going that
direction. Curious what others have to say though.

> 
> I'm concerned about how this preparation needs to be done for the entire
> folio. With huge pages, could it be weird if actually only one page in
> the huge page is faulted in, and hence only that one page needs to be
> prepared, instead of the entire huge page?

In previous iterations of THP support for SNP[1] I think this worked out
okay. You'd prepare optimistically prepare the whole huge folio, and if KVM
mapped it as, say, 4K, you'd get an RMP fault and PSMASH the RMP table
to smaller 4K/prepare entries. But that was before in-place conversion
was in the picture, so we didn't have to worry about ever converting
those other prepared entries to a shared state, so you could defer
everything until folio cleanup. For in-place we'd need to take the
memory attributes for the range we are mapping into account and clamp
the range down to a smaller order accordingly before issuing the prepare
hook. But I think it would still be doable.

Maybe more directly would be to let KVM MMU tell us the max mapping
level it will be using so we can just defer all the attribute handling
to KVM. But this same approach could still be done with gmem issuing
the prepare hooks in the case of in-place conversion. So I think it's
doable either way... hard to tell what approach is cleaner without some
hugepage patches on top. I'm still trying to get update THP on top of
your in-place conversion patches posted and maybe it'll be easier to see
what things would look like in that context.

[1] https://lore.kernel.org/kvm/20241212063635.712877-1-michael.roth@amd.com/

> 
> In the other series [2], there was a part about how guest_memfd should
> invalidate the shared status on conversion from private to shared. Is
> that still an intended step, after this series to remove preparation
> tracking?

Yes, I was still planning to have gmem drive prepare/invalidate where
needed. If we move things out to MMU that will require some rethinking
however.


Thanks,

Mike

> 
> [1] https://lore.kernel.org/all/diqzcy7op5wg.fsf@google.com/
> [2] https://lore.kernel.org/all/20250613005400.3694904-4-michael.roth@amd.com/
> 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
> >  1 file changed, 15 insertions(+), 32 deletions(-)
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index fdaea3422c30..9160379df378 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -76,11 +76,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
> >  	return 0;
> >  }
> >  
> > -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> > -{
> > -	folio_mark_uptodate(folio);
> > -}
> > -
> >  /*
> >   * Process @folio, which contains @gfn, so that the guest can use it.
> >   * The folio must be locked and the gfn must be contained in @slot.
> > @@ -90,13 +85,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  				  gfn_t gfn, struct folio *folio)
> >  {
> > -	unsigned long nr_pages, i;
> >  	pgoff_t index;
> > -	int r;
> > -
> > -	nr_pages = folio_nr_pages(folio);
> > -	for (i = 0; i < nr_pages; i++)
> > -		clear_highpage(folio_page(folio, i));
> >  
> >  	/*
> >  	 * Preparing huge folios should always be safe, since it should
> > @@ -114,11 +103,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
> >  	index = kvm_gmem_get_index(slot, gfn);
> >  	index = ALIGN_DOWN(index, folio_nr_pages(folio));
> > -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> > -	if (!r)
> > -		kvm_gmem_mark_prepared(folio);
> >  
> > -	return r;
> > +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> >  }
> >  
> >  /*
> > @@ -420,7 +406,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >  
> >  	if (!folio_test_uptodate(folio)) {
> >  		clear_highpage(folio_page(folio, 0));
> > -		kvm_gmem_mark_prepared(folio);
> > +		folio_mark_uptodate(folio);
> >  	}
> >  
> >  	vmf->page = folio_file_page(folio, vmf->pgoff);
> > @@ -757,7 +743,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
> >  static struct folio *__kvm_gmem_get_pfn(struct file *file,
> >  					struct kvm_memory_slot *slot,
> >  					pgoff_t index, kvm_pfn_t *pfn,
> > -					bool *is_prepared, int *max_order)
> > +					int *max_order)
> >  {
> >  	struct file *slot_file = READ_ONCE(slot->gmem.file);
> >  	struct gmem_file *f = file->private_data;
> > @@ -787,7 +773,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
> >  	if (max_order)
> >  		*max_order = 0;
> >  
> > -	*is_prepared = folio_test_uptodate(folio);
> >  	return folio;
> >  }
> >  
> > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  {
> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> >  	struct folio *folio;
> > -	bool is_prepared = false;
> >  	int r = 0;
> >  
> >  	CLASS(gmem_get_file, file)(slot);
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> >  	if (IS_ERR(folio))
> >  		return PTR_ERR(folio);
> >  
> > -	if (!is_prepared)
> > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > +	if (!folio_test_uptodate(folio)) {
> > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > +
> > +		for (i = 0; i < nr_pages; i++)
> > +			clear_highpage(folio_page(folio, i));
> > +		folio_mark_uptodate(folio);
> > +	}
> > +
> > +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> >  
> >  	folio_unlock(folio);
> >  
> > @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  		struct folio *folio;
> >  		gfn_t gfn = start_gfn + i;
> >  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > -		bool is_prepared = false;
> >  		kvm_pfn_t pfn;
> >  
> >  		if (signal_pending(current)) {
> > @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  			break;
> >  		}
> >  
> > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> >  		if (IS_ERR(folio)) {
> >  			ret = PTR_ERR(folio);
> >  			break;
> >  		}
> >  
> > -		if (is_prepared) {
> > -			folio_unlock(folio);
> > -			folio_put(folio);
> > -			ret = -EEXIST;
> > -			break;
> > -		}
> > -
> >  		folio_unlock(folio);
> >  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> >  			(npages - i) < (1 << max_order));
> > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  		p = src ? src + i * PAGE_SIZE : NULL;
> >  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> >  		if (!ret)
> > -			kvm_gmem_mark_prepared(folio);
> > +			folio_mark_uptodate(folio);
> >  
> >  put_folio_and_exit:
> >  		folio_put(folio);
> > -- 
> > 2.25.1
> 

