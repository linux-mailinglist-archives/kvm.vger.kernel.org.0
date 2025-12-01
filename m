Return-Path: <kvm+bounces-65052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D557AC999FD
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 00:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5BC7C3453A3
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 23:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E410228642B;
	Mon,  1 Dec 2025 23:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fmNA1ANe"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011036.outbound.protection.outlook.com [52.101.62.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AE129AAFD;
	Mon,  1 Dec 2025 23:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764632710; cv=fail; b=qI8ci97EGMII3GPhcHwIAClVp9W8nmzDMYD4Y8FLvUFg7LaRTlmgyMmW7uIvqITqUlqye0UcDwR0gt2uTuj8UhTBeIJsqpqB2DgF9hHGizi948//+yIHxdWNVSLDYO8d1l1hZyozTxpF5HW9whu35Q6+wHYhRO4QwHwPddNuVZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764632710; c=relaxed/simple;
	bh=I5gibG2K2ro0nPuB3EE+KOhOyAyPXKYDrQjOjeh7e34=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDIs3auvRGH6OE6+df5Vz1Cz8Jti1vyZnhWEMMzSknxpvETFtNRunEX5C6u0PIq4ygCuBEtUXHSirBV706bMnFPVNkuPplRk2pESViMI7EPKLUjUfl6cAzYwl0imX1JpcEH7dQHPVWd5rt98w3GzL+YEulHcr38vUV95xNffWpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fmNA1ANe; arc=fail smtp.client-ip=52.101.62.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WTPg1KUFlysA0xGSEpA6gntQHdmmYyDBp5ZQ4AAcjxPTd7N6b5xyoHwE9v8oZ8aboTQ18pOhUTa70DKYwGSYHb6rCT5959j7D9os1XiKBTkLSTJHRvk+Sg3FxSVIgvK4RHZJljDX1nkypSzHijiDCbgWHXWpw78max4SGBreNxQ+d+O5mGxpIE3ZnKlJQtiSFvxbJTenDMK0lsqUoweerd2jAgVK4N4eN+FpLbMMw9GzK7UxuLqqKySlUa1/jvv6dfZV0AUcTuOtf25DEhHh0b1rDnXKCFRs8Vz/akLkTyVBu/pNJ+HvLp6Vy7KXLZOnnoQFxGzsQMUTcALIq4w5bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+reHd9JRoMT9Oi+70vF1pMnz6u/emAnxt4cEvX7r9tI=;
 b=vSvLVT8CDULCWufyOOEHVLgQlX1dicwPSYixcRFBlA2pDy8OP+Xv9KdetLakGntSvhFGcLqARdnIKluvyB+7rimeHcuaReRnx9Y3aK/tXbotwhVKw1/aboNYB4eDijQat9E0SdYu8eW9YlV+AbbDmIUCr1xNhCimJ+kHDUp2BpPBJDZNHDM9gqR2+5L8X170awgBvJ4rcrgYvDS0gAjVGz8GIfvyFjzntoSVdsIy4pGkglArMMoxDSTJvABmshOKHxxDZ+eWWEGPcbt2Y4cSXkHClH3A/gwxkZsKY8GYIISRefsQZtswSAn4+u1TLEZVB/krCjnKjpD9hZe4O65qIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+reHd9JRoMT9Oi+70vF1pMnz6u/emAnxt4cEvX7r9tI=;
 b=fmNA1ANe+85+sU0veM5KALY8x58zzQ1Abf34wd4wXDaxmgaYb7awRPIx8EHLv47ArSlFfWrd7if5dDn8nS9vC9vUGbTpspuyZ28bnksKDjcoBOZuaTIhR5bYF0hRbICfQJM4IKsyxbKfuWhd4MfcE1vQCCzP6MiA1wgFceJOaLA=
Received: from BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::12)
 by CH3PR12MB8185.namprd12.prod.outlook.com (2603:10b6:610:123::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 23:45:02 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::cc) by BY1P220CA0010.outlook.office365.com
 (2603:10b6:a03:59d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 23:45:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 23:45:01 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 17:45:01 -0600
Date: Mon, 1 Dec 2025 17:44:47 -0600
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20251201234447.5x62vhlg3d5mmtpw@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
 <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|CH3PR12MB8185:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9a67b0-578b-4ad9-86e5-08de3133a561
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Whra7sHZNJJhPp/ejputbrXO3l2zRXH38zL8qwNdDWzXp0ynwsoJb3sHbedR?=
 =?us-ascii?Q?kXfcK+WOfcKBeEagxnYAYHjPms8BkG4r+5wCOsQbLz7Ye9kfyJkL/Z2DvSOA?=
 =?us-ascii?Q?H0+iI6ytv8+VGe+uDE3yrdoZAw33d31TSlPBHLoFWc9XPV0McNd9vX6PNuyT?=
 =?us-ascii?Q?QgwmAle3yHcGCzqsavFfWHrFWWn7FG/ZApqGTGkjQt/flWD96PzcPhtRXAz1?=
 =?us-ascii?Q?/Bmk/SaFe+ZwPIqKX3a64ZAHESGBfjSZa9nTMSBRLVaXpBnL61RxECOzQdWd?=
 =?us-ascii?Q?LYnIDI8djJKUFMxWF0/8QBDMm1T5fgzOAKwTo3RkzzlsZlxfEd9FMVITDz2z?=
 =?us-ascii?Q?fJ5cEOBnlMUUsE3EK3iCO4Fo4gRh/yuWX1MC567xvhcTh9VeKmamvivD46R+?=
 =?us-ascii?Q?lF5g0BmIFQQbPvEsyGrbLCHNsvgPUG6j3UF2Tp6qr1sP0N8zRB7JTCESTIgh?=
 =?us-ascii?Q?K4rUOMce/1mWyM1DEt8Sb3qjpcr0V6duSS1eSWSJQGhJF2rnkqtN5H+8p0Ji?=
 =?us-ascii?Q?abi9i4Q9BSTQMLJk979kUe/6KRt/TLhdzxLW6sSFCXVqs9Rca+/92Va7bgus?=
 =?us-ascii?Q?jZnhLSSWBOUfOHi3IuaO9qJ0uB/HmA9npJgLJEqxd7aPp7Z9J13OCXsQRO38?=
 =?us-ascii?Q?obw5oeWbB4X4r/cv3E5r/Ug5jHo7Wruhcr2yPqFJXsDkFC9hP/a9hTNSy/TG?=
 =?us-ascii?Q?mp5qP6g+QgwH9jZfvTCM0I6j8wGHEBBBC7ztMlcoFsWGEdKMki9l1ttmTr16?=
 =?us-ascii?Q?1E/sJt+6eUABwdSe+/KKaqzZfbNXMq9gXGQUAQKuyeKpopDCvIlykzzt49Ca?=
 =?us-ascii?Q?qA7xR9/nRTAdabh2pZHS8Wua3X4Ca5uvSCz/ugZoD0i/GdrOzUoDngwwSaES?=
 =?us-ascii?Q?VUvTDJqQPf6siciY5ajYzdaOFnlO7l5RBs/RIR8GfH13ouW06+l0UKSGnEo/?=
 =?us-ascii?Q?HskuemSzkkPm+RbC14qGYqdbSRKsth938jEtxhC3rzbEWCGMpu8Hjbp5BrI3?=
 =?us-ascii?Q?bbP4LNEVFHjPoV+5vX9FMHlagUFn8vLhEDfgPJAB1kXBTwqX0ahFvnRmCjHg?=
 =?us-ascii?Q?jOw8hG7vDh9TL0+9S0ZXJoJgt5y7Y4LmfyLOB8tyYFTXWVSgNmroyvdKVosR?=
 =?us-ascii?Q?IgiMKF6tqOmq4UbF6Jd7sZSQdkcCPXMYCDhO8Oi6Utc88Aug6aCwdH9a4uMw?=
 =?us-ascii?Q?AugvVJL+maJH5y2UMqc1qDefXQnMeUZ/ufmyqBZJkj2bMLl+ndoqFTvwzyyQ?=
 =?us-ascii?Q?avnWnN7hXtK4keSdozj6f9VD+hBFajfWNy8rjNOBjh2fv6Y5rKgmTnRH05Qj?=
 =?us-ascii?Q?U61mafOXPaeBs6npSwSYCZFf2/RK21GCqZTLR0LpL+802WS94rnnNhZb2g/o?=
 =?us-ascii?Q?UXUrcsXXU6b9vxH6VCfVns2876GCxo1BCeQyRQgIBfgr7E0nXQrXNDK7XRcr?=
 =?us-ascii?Q?t+6e8coDohsZWCt3Psn3CRUn66+MyQrLT1c2zlXiJYT1c0oC/CYq4Ouvx6AE?=
 =?us-ascii?Q?SJCzwRUHoidrsaAF4oMpk56/rhMsektCp0FZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 23:45:01.9587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9a67b0-578b-4ad9-86e5-08de3133a561
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8185

On Tue, Nov 25, 2025 at 11:13:25AM +0800, Yan Zhao wrote:
> On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> > On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > >  {
> > > >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > >  	struct folio *folio;
> > > > -	bool is_prepared = false;
> > > >  	int r = 0;
> > > >  
> > > >  	CLASS(gmem_get_file, file)(slot);
> > > >  	if (!file)
> > > >  		return -EFAULT;
> > > >  
> > > > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > > > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > > >  	if (IS_ERR(folio))
> > > >  		return PTR_ERR(folio);
> > > >  
> > > > -	if (!is_prepared)
> > > > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > > +	if (!folio_test_uptodate(folio)) {
> > > > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > > > +
> > > > +		for (i = 0; i < nr_pages; i++)
> > > > +			clear_highpage(folio_page(folio, i));
> > > > +		folio_mark_uptodate(folio);
> > > Here, the entire folio is cleared only when the folio is not marked uptodate.
> > > Then, please check my questions at the bottom
> > 
> > Yes, in this patch at least where I tried to mirror the current logic. I
> > would not be surprised if we need to rework things for inplace/hugepage
> > support though, but decoupling 'preparation' from the uptodate flag is
> > the main goal here.
> Could you elaborate a little why the decoupling is needed if it's not for
> hugepage?

For instance, for in-place conversion:

  1. initial allocation: clear, set uptodate, fault in as private
  2. private->shared: call invalidate hook, fault in as shared
  3. shared->private: call prep hook, fault in as private

Here, 2/3 need to track where the current state is shared/private in
order to make appropriate architecture-specific changes (e.g. RMP table
updates). But we want to allow for non-destructive in-place conversion,
where a page is 'uptodate', but not in the desired shared/private state.
So 'uptodate' becomes a separate piece of state, which is still
reasonable for gmem to track in the current 4K-only implementation, and
provides for a reasonable approach to upstreaming in-place conversion,
which isn't far off for either SNP or TDX.

For hugepages, we'll have other things to consider, but those things are
probably still somewhat far off, and so we shouldn't block steps toward
in-place conversion based on uncertainty around hugepages. I think it's
gotten enough attention at least that we know it *can* work, e.g. even
if we take the inefficient/easy route of zero'ing the whole folio on
initial access, setting it uptodate, and never doing anything with 
uptodate again, it's still a usable implementation.

> 
> 
> > > > +	}
> > > > +
> > > > +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > >  
> > > >  	folio_unlock(folio);
> > > >  
> > > > @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > >  		struct folio *folio;
> > > >  		gfn_t gfn = start_gfn + i;
> > > >  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > > -		bool is_prepared = false;
> > > >  		kvm_pfn_t pfn;
> > > >  
> > > >  		if (signal_pending(current)) {
> > > > @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > >  			break;
> > > >  		}
> > > >  
> > > > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > > +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> > > >  		if (IS_ERR(folio)) {
> > > >  			ret = PTR_ERR(folio);
> > > >  			break;
> > > >  		}
> > > >  
> > > > -		if (is_prepared) {
> > > > -			folio_unlock(folio);
> > > > -			folio_put(folio);
> > > > -			ret = -EEXIST;
> > > > -			break;
> > > > -		}
> > > > -
> > > >  		folio_unlock(folio);
> > > >  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > > >  			(npages - i) < (1 << max_order));
> > > TDX could hit this warning easily when npages == 1, max_order == 9.
> > 
> > Yes, this will need to change to handle that. I don't think I had to
> > change this for previous iterations of SNP hugepage support, but
> > there are definitely cases where a sub-2M range might get populated 
> > even though it's backed by a 2M folio, so I'm not sure why I didn't
> > hit it there.
> > 
> > But I'm taking Sean's cue on touching as little of the existing
> > hugepage logic as possible in this particular series so we can revisit
> > the remaining changes with some better context.
> Frankly, I don't understand why this patch 1 is required if we only want "moving
> GUP out of post_populate()" to work for 4KB folios.

Above I outlined one of the use-cases for in-place conversion.

During the 2 PUCK sessions prior to this RFC, Sean also mentioned some
potential that other deadlocks might exist in current code due to
how the locking is currently handled, and that we should consider this
as a general cleanup against current kvm/next, but I leave that to Sean
to elaborate on.

Personally I think this series makes sense against kvm/next regardless:
tracking preparation in gmem is basically already broken: everyone ignores
it except SNP, so it was never performing that duty as-designed. So we
are now simplying uptodate flag to no longer include this extra
state-tracking, and leaving it for architecture-specific tracking. I
can't see that be anything but beneficial to future gmem changes.

> 
> > > 
> > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > >  		p = src ? src + i * PAGE_SIZE : NULL;
> > > >  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > >  		if (!ret)
> > > > -			kvm_gmem_mark_prepared(folio);
> > > > +			folio_mark_uptodate(folio);
> > > As also asked in [1], why is the entire folio marked as uptodate here? Why does
> > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
> > > uptodate?
> > 
> > Quoting your example from[1] for more context:
> > 
> > > I also have a question about this patch:
> > > 
> > > Suppose there's a 2MB huge folio A, where
> > > A1 and A2 are 4KB pages belonging to folio A.
> > > 
> > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
> > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> > 
> > In SNP hugepage patchset you responded to, it would only mark A1 as
> You mean code in
> https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?

No, sorry, I got my references mixed up. The only publically-posted
version of SNP hugepage support is the THP series that does not involve
in-place conversion, and that's what I was referencing. It's there where
per-4K bitmap was added to track preparation, and in that series
page-clearing/preparation are still coupled to some degree so per-4K
tracking of page-clearing was still possible and that's how it was
handled:

  https://github.com/AMDESE/linux/blob/snp-prepare-thp-rfc1/virt/kvm/guest_memfd.c#L992

but that can be considered an abandoned approach so I wouldn't spend
much time referencing that.

> 
> > prepared/cleared. There was 4K-granularity tracking added to handle this.
> I don't find the code that marks only A1 as "prepared/cleared".
> Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_populate()
> to mark the entire folio A as uptodate.
> 
> However, according to your statement below that "uptodate flag only tracks
> whether a folio has been cleared", I don't follow why and where the entire folio
> A would be cleared if kvm_gmem_populate() only adds page A1.
> 
> > There was an odd subtlety in that series though: it was defaulting to the
> > folio_order() for the prep-tracking/post-populate, but it would then clamp
> > it down based on the max order possible according whether that particular
> > order was a homogenous range of KVM_MEMORY_ATTRIBUTE_PRIVATE. Which is not
> > a great way to handle things, and I don't remember if I'd actually intended
> > to implement it that way or not... that's probably why I never tripped over
> > the WARN_ON() above, now that I think of it.
> > 
> > But neither of these these apply to any current plans for hugepage support
> > that I'm aware of, so probably not worth working through what that series
> > did and look at this from a fresh perspective.
> > 
> > > 
> > > (2) kvm_gmem_get_pfn() later faults in page A2.
> > >     As folio A is uptodate, clear_highpage() is not invoked on page A2.
> > >     kvm_gmem_prepare_folio() is invoked on the whole folio A.
> > > 
> > > (2) could occur at least in TDX when only a part the 2MB page is added as guest
> > > initial memory.
> > > 
> > > My questions:
> > > - Would (2) occur on SEV?
> > > - If it does, is the lack of clear_highpage() on A2 a problem ?
> > > - Is invoking gmem_prepare on page A1 a problem?
> > 
> > Assuming this patch goes upstream in some form, we will now have the
> > following major differences versus previous code:
> > 
> >   1) uptodate flag only tracks whether a folio has been cleared
> >   2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() and
> >      the architecture can handle it's own tracking at whatever granularity
> >      it likes.
> 2) looks good to me.
> 
> > My hope is that 1) can similarly be done in such a way that gmem does not
> > need to track things at sub-hugepage granularity and necessitate the need
> > for some new data structure/state/flag to track sub-page status.
> I actually don't understand what uptodate flag helps gmem to track.
> Why can't clear_highpage() be done inside arch specific code? TDX doesn't need
> this clearing after all.

It could. E.g. via the kernel-internal gmem flag that I mentioned in my
earlier reply, or some alternative. 

In the context of this series, uptodate flag continues to instruct
kvm_gmem_get_pfn() that it doesn't not need to re-clear pages, because
a prior kvm_gmem_get_pfn() or kvm_gmem_populate() already initialized
the folio, and it is no longer tied to any notion of
preparedness-tracking.

What use uptodate will have in the context of hugepages: I'm not sure.
For non-in-place conversion, it's tempting to just let it continue to be
per-folio and require clearing the whole folio on initial access, but
it's not efficient. It may make sense to farm it out to
post-populate/prep hooks instead, as you're suggesting for TDX.

But then, for in-place conversion, you have to deal with pages initially
faulted in as shared. They might be split prior to initial access as a
private page, where we can't assume TDX will have scrubbed things. So in
that case it might still make sense to rely on it.

Definitely things that require some more thought. But having it inextricably
tied to preparedness just makes preparation tracking similarly more
complicated as it pulls it back into gmem when that does not seem to be
the direction any architectures other SNP have/want to go.

> 
> > My understanding based on prior discussion in guest_memfd calls was that
> > it would be okay to go ahead and clear the entire folio at initial allocation
> > time, and basically never mess with it again. It was also my understanding
> That's where I don't follow in this patch.
> I don't see where the entire folio A is cleared if it's only partially mapped by
> kvm_gmem_populate(). kvm_gmem_get_pfn() won't clear folio A either due to
> kvm_gmem_populate() has set the uptodate flag.
> 
> > that for TDX it might even be optimal to completely skip clearing the folio
> > if it is getting mapped into SecureEPT as a hugepage since the TDX module
> > would handle that, but that maybe conversely after private->shared there
> > would be some need to reclear... I'll try to find that discussion and
> > refresh. Vishal I believe suggested some flags to provide more control over
> > this behavior.
> > 
> > > 
> > > It's possible (at least for TDX) that a huge folio is only partially populated
> > > by kvm_gmem_populate(). Then kvm_gmem_get_pfn() faults in another part of the
> > > huge folio. For example, in TDX, GFN 0x81f belongs to the init memory region,
> > > while GFN 0x820 is faulted after TD is running. However, these two GFNs can
> > > belong to the same folio of order 9.
> > 
> > Would the above scheme of clearing the entire folio up front and not re-clearing
> > at fault time work for this case?
> This case doesn't affect TDX, because TDX clearing private pages internally in
> SEAM APIs. So, as long as kvm_gmem_get_pfn() does not invoke clear_highpage()
> after making a folio private, it works fine for TDX.
> 
> I was just trying to understand why SNP needs the clearing of entire folio in
> kvm_gmem_get_pfn() while I don't see how the entire folio is cleared when it's
> partially mapped in kvm_gmem_populate().
> Also, I'm wondering if it would be better if SNP could move the clearing of
> folio into something like kvm_arch_gmem_clear(), just as kvm_arch_gmem_prepare()
> which is always invoked by kvm_gmem_get_pfn() and the architecture can handle
> it's own tracking at whatever granularity.

Possibly, but I touched elsewhere on where in-place conversion might
trip up this approach. At least decoupling them allows for the prep side
of things to be moved to architecture-specific tracking. We can deal
with uptodate separately I think.

-Mike

> 
>  
> > > Note: the current code should not impact TDX. I'm just asking out of curiosity:)
> > > 
> > > [1] https://lore.kernel.org/all/aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com/
> > > 
> > >  

