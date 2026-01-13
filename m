Return-Path: <kvm+bounces-67979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A21D1B6ED
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 22:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4AE9030563DC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 21:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967B534F27B;
	Tue, 13 Jan 2026 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O4GMVwKN"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010059.outbound.protection.outlook.com [52.101.56.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5754934E75D;
	Tue, 13 Jan 2026 21:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768340185; cv=fail; b=STzA58dVhfsZ0niHGxJ8MsLuJIZmv/UxULe48Fq0jki6EcCw4khnNS9xshh91dHWl0m/0MhTp/QzBaviXdVXCQWw9FPpwOgtnQYyUwi621SjzTkAA6zet9S6DGi0VZb0M+JBhc6+OMQsBIET1Wnq3HiINX95l9pnrxxHtXjIcj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768340185; c=relaxed/simple;
	bh=ipn94Fv+qEjhrr+wlTfjA0nVnm0Fguq6MJVjk6mD1l0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeVlYaWC9tIy69q74dPyV8rxugdqo2PuiBFVz7iXcNvDnt07RUkG0gDmlZdWuwqoMPTN6AlNw5pI/c4AZmIEQmoGjo8H9P5Ba4LsiPAht5Pi+mYf0WBfDHwtsX1q+yYARVIy3KigGIV2kW7rBDb5UIPtfdgVyRcVr17Bs2s+hcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O4GMVwKN; arc=fail smtp.client-ip=52.101.56.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARJWvTxtNv9fW2J0smKWCywEv4inGfyj0QPxD83L1os60B9iVhfz1Myg1pynbNISp+Zin3cLDdpOiDK81UbYSPRJqWHhwJ9c2yDkiZA2D9SZtf2b6Ez5OTiUaNWbpGMjmLqcPdpkS4MFsUDFkOgzK1V08nzzrxqXpqcA7/MLWQ6Er7Q6c9HvHh5QZnkbjAVX82aGQLfQcOT1sQSNcGRwfvyxWxagXaeleJJoV5BcTn+EYfs1O4wJ4cDdG3ThMSx1vVcMnb52B02jxsW4nbtTx167hKsEgBA01RexNg+vjOSCb0GvBSCOmwxOvLBq2rszKiLEbgJVFvjFdW4Xd27fEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tkTuR9aQ+86bU8typGk1j9ny7LHoHvWVBk7wjA4suo=;
 b=NCNf0LxrVhTvOSVc8ODkdkML7YD7Md8KTbXjCIinfSk0uOj6D8tSm69skGhR9rAOOHjO578B2mv1SJ8lt9RQBLDV13vUF/q5+/zLhY+904Dta+ErUOl4ogRTFXNJmIm6NgdF4TWGYkjWn/SPu4iW1fCLG6aBadtGLjmbdtRAMaHYz4Ktj4MnGLzH0FMsTm5/7zE6cTdvTgcbPN37IF1nw4Z2h+fvtxSyEWeNe8/W1gla4xXiyqoECFZrXDlY3jCb87KBKfZRvD1qewwfNUfzfCDlbTssJ26OYJu1LWoTzcPfUfhjwsYZf36xy/WIWnv6M3k7/UXOyI0Y4VEmQoXgDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tkTuR9aQ+86bU8typGk1j9ny7LHoHvWVBk7wjA4suo=;
 b=O4GMVwKN5Aflu12ZF5X6+xfkTA4WHOE46Dfya4I/DpE4K0l6CVQlW+bEhhQNZ3p89skHqEZIfInm/IPRhSr/8qdaXya47bD32Ac69DDxEtRewHiX1zqqavkzP6dJHmcwzis2u5tP8dXKO4lAe2R50XQ4YEuIFihwtHrpsn9ipdU=
Received: from BN0PR02CA0031.namprd02.prod.outlook.com (2603:10b6:408:e5::6)
 by CH1PPFF5B95D789.namprd12.prod.outlook.com (2603:10b6:61f:fc00::62a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 21:36:18 +0000
Received: from BN2PEPF0000449E.namprd02.prod.outlook.com
 (2603:10b6:408:e5:cafe::e7) by BN0PR02CA0031.outlook.office365.com
 (2603:10b6:408:e5::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Tue,
 13 Jan 2026 21:36:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF0000449E.mail.protection.outlook.com (10.167.243.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Tue, 13 Jan 2026 21:36:12 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 13 Jan
 2026 15:36:11 -0600
Date: Tue, 13 Jan 2026 15:35:56 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <vbabka@suse.cz>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>,
	<yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20260113213556.rwihf3v3ek3c5kwl@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-7-michael.roth@amd.com>
 <aWabORpkzEJygYNQ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWabORpkzEJygYNQ@google.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449E:EE_|CH1PPFF5B95D789:EE_
X-MS-Office365-Filtering-Correlation-Id: 2abfdd1b-d14e-4c68-8a1e-08de52ebc5dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+dCJg6BgYvL/sIyGBCzUe4swuko53py6nr0SkV1bn1HDCF20lR+p6kNXB50n?=
 =?us-ascii?Q?sEq2NYvbhqp94/J3PsY0CDjvPCdC2IBeZIKa8soicVwbfVjQVsjBsV+E3FkD?=
 =?us-ascii?Q?lQcQNmYKAe4rgu1de6OzT/bIOFij1tV3dH/1zeASRCpA0znbVN2ho5yKfIKm?=
 =?us-ascii?Q?afzwI156z4caJLgK8AmfQjAmDU9lMvfADNWdSOx1v5J9dnNkiNFYSDoSTRYT?=
 =?us-ascii?Q?QPrd0QA+LMWDtY41h3zhyy+MbnW3vCcCnDFwnAp+BFa+2Tl3fM6UHG+/EkzE?=
 =?us-ascii?Q?iUa9GT3cPvvU9vxI0xXD5HHDthBimkqHO7TNbvzucb3MWsqlFapbXM4y8Ech?=
 =?us-ascii?Q?chiYWkRmnYiFeyjbMCZ/9K0INNULyqmeLlTVdVK1ueUrfbo/3IxWJqvSqQwF?=
 =?us-ascii?Q?32qzt/8DScKrYlDgMOg1/vbsL9ASD+2CVaQXJdJVhw51omrJ+EILEaiz6HO1?=
 =?us-ascii?Q?fe097LImqN2Di/wy+J83YsxcOAePSPiR3Fu7a9b9Q+qVDmrNEQ6Q1QJ+svWs?=
 =?us-ascii?Q?zvXkNmg+LejUKmVkuSGiMwEhVhvvQcntbfFdEYylqKu84FJkHAoY4+GYl6Jx?=
 =?us-ascii?Q?qfyvBgBdowbWC1M5OVyvTrOp91M3GN/6lD0az7qnzGunlfvV+wo78KaVZohz?=
 =?us-ascii?Q?2hxxMBhpUuo9oK0JPxzP/KAYp1Y1MgXJrbmFawcxzG58eSmhyGpv3RI8QibY?=
 =?us-ascii?Q?VIKODQqLKX+emr+6l3uSkrvU7x+mgU7VK8DngFdau+0HolrnuVRBIOz/gZKB?=
 =?us-ascii?Q?uiTtPzyzJRaFZUNXMev5+qsAq1Y8EaAm36ZkFKybZnCCJy4ADP0nvwtaozLz?=
 =?us-ascii?Q?H46HB3m/DdvZq2cFeSrZ/D3eoAbHuDAq4x3+VRYtKkXduD2L/IuEk5IRM21t?=
 =?us-ascii?Q?QPvLnJBPbwhYuzqqbzRTzo5pmkbE+3igmTbjpq8IF9NMJ4LmLOOyfIfhWhoh?=
 =?us-ascii?Q?AnAxxwNSRfi33KUkmPL976apCIYBdOWM8HbvNMA8dp6kfSlAIzNmnYAM2v9P?=
 =?us-ascii?Q?OCvd+TljmfKNrsGZ2qVwR9OoMxCAgnKG2dBNWhEpa57MxJWtYB6iCxfHRlR3?=
 =?us-ascii?Q?AIn1wO8g/cOLKi5gD6J72xM2SkckeimEq4y3Lt0fXvPlnQi/vf1JoKz24eda?=
 =?us-ascii?Q?nnNQO1YOUvDu9ZzOsN+Bi9TFEiv6kw3bdtWwyv6zQCLH0+e+8Fg+sSmKioqt?=
 =?us-ascii?Q?88I6K2tSATKwt9TY3EMorNv6dzMQ3ysBtKfVMeC7RlfZQIxZQd5vG0piEK1T?=
 =?us-ascii?Q?ay820IZnNua1FWVQMLXjrwCYm2T/O583HGc4oxGYh/y/k77tcn9bbmuLmPJg?=
 =?us-ascii?Q?30v8Y89mNkLiFLTVr4yQ6acmrfdvWOnjRxxkL7hrbbN7lGN/u08n2+l1gFnT?=
 =?us-ascii?Q?/c+ZW1Yutjq4VPavc2xc+/fvWZWLXjE9m7u0y4lbhQqboPuKdZuavPmeObGV?=
 =?us-ascii?Q?t+dcLDIkgECTopIWALyjKtwgZoVLIGyFwf7vSVjsh3vEnaFt4Y1CL5pDk43C?=
 =?us-ascii?Q?1Z431sFOcVL5fV020YeRU0NXGzgUupeIjVxOmgoErR4nXGaoqSKSrWAf9Mij?=
 =?us-ascii?Q?wXi5vs7zeY3zi+k7KTQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 21:36:12.3188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2abfdd1b-d14e-4c68-8a1e-08de52ebc5dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFF5B95D789

On Tue, Jan 13, 2026 at 11:21:29AM -0800, Sean Christopherson wrote:
> On Thu, Jan 08, 2026, Michael Roth wrote:
> > @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > -	filemap_invalidate_lock(file->f_mapping);
> > -
> >  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> >  	for (i = 0; i < npages; i++) {
> > -		struct folio *folio;
> > -		gfn_t gfn = start_gfn + i;
> > -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > -		kvm_pfn_t pfn;
> > +		struct page *src_page = NULL;
> > +		void __user *p;
> >  
> >  		if (signal_pending(current)) {
> >  			ret = -EINTR;
> >  			break;
> >  		}
> >  
> > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> > -		if (IS_ERR(folio)) {
> > -			ret = PTR_ERR(folio);
> > -			break;
> > -		}
> > +		p = src ? src + i * PAGE_SIZE : NULL;
> >  
> > -		folio_unlock(folio);
> > +		if (p) {
> 
> Computing 'p' when src==NULL is unnecessary and makes it hard to see that gup()
> is done if and only if src!=NULL.
> 
> Anyone object to this fixup?

No objections here, and it does seem a bit more readable. Will include
this if a new version is needed.

Thanks,

Mike

> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 18ae59b92257..66afab8f08a3 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -884,17 +884,16 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>         npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
>         for (i = 0; i < npages; i++) {
>                 struct page *src_page = NULL;
> -               void __user *p;
>  
>                 if (signal_pending(current)) {
>                         ret = -EINTR;
>                         break;
>                 }
>  
> -               p = src ? src + i * PAGE_SIZE : NULL;
> +               if (src) {
> +                       unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
>  
> -               if (p) {
> -                       ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
> +                       ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
>                         if (ret < 0)
>                                 break;
>                         if (ret != 1) {
> 
> To end up with:
> 
> 		struct page *src_page = NULL;
> 
> 		if (signal_pending(current)) {
> 			ret = -EINTR;
> 			break;
> 		}
> 
> 		if (src) {
> 			unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
> 
> 			ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
> 			if (ret < 0)
> 				break;
> 			if (ret != 1) {
> 				ret = -ENOMEM;
> 				break;
> 			}
> 		}
> 
> 		...

