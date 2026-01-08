Return-Path: <kvm+bounces-67480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C87D065BE
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70C0F302BD21
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BE133D50C;
	Thu,  8 Jan 2026 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2Ap99Zxk"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013066.outbound.protection.outlook.com [40.93.201.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B346309F01;
	Thu,  8 Jan 2026 21:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767908839; cv=fail; b=caXX4k5yWHFItf4PClz5Cwziyx3aZ/p9eDsx8eCa2eEbfRqL1hMIiJxxihap+Qs4MurDXMxW2vAlu0iJ8Sh3VpZrym8fhD5TMOmCAm8yx1Jj9+64r5aRwmFvTE+aG1K4qB9TcOdN/wFV0cebC9xeqnkUo4aJ3XeZ0vBdki4VPQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767908839; c=relaxed/simple;
	bh=kiTtp6KV+1TETisjXTDsFckqCBfiy4rq4eBs+EuEX8k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyBl7j/SCjXCwrdhyUFlMaHDxkLre6DNjviUGBS2S3bsfcSQF/2I14zzRgDhS4QQBrNjYc34LXJpr85rEvTH9MJfGf7egN5LOL7nINtFt4Nap8/68/abvpRYJ0okympYE45vhk9nWe0KdM1dOAk6D74AdTM0pK3VJTmPeE+/648=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2Ap99Zxk; arc=fail smtp.client-ip=40.93.201.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDfUZlFHO5QxFwgRd/VZI1B+ugMK/Kpe1pLw3HQ/14UmczRw/uOvbOC3n/fkHhUK+cRVT6LjPYEoLdFc8ByUHJ7AyzJQ3Rq3O0L1uIkVYawNPBg67N29ehXvAt+Zu7LMpCS3xUNq+8RZw0t9y4Dz9SNlYsxwPaKl8A76w0nbGzFtxcUuy+Ov3ELveGUKlN8U9/8BbWllDLzzGe95Bo5/PjP+qoCMLSD4bvZJvxgh8qy5eVv8BoOQEr0ZlP/PMHLNOAWo18DU6sxUxJXzvysnP+3BaWk8N37pEXmGjWqxtD3cBMy16vUU1b1rN2smgw73HDpLqKHACSi33bZeaLS+rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7AYEnnll4IDtrImkjlawfMwmM7B2mK0dwl0jpQEHOo=;
 b=JkuNqO4BWkNq3Q79enS+NQsAsnNJdeS+yGF4E4AJlmeB0jmx8xaW0mnJJZTYo9sqlp18cGzFqwCEKDe2OIJKhdYOX7AMyhXorTmjyVq189uilVqVkTZQjSSoT6WIcSK5Rb+0VPrkWhryzS9iBk073hbOsukNSZYIbmCkvXDEMK0tANs1Q0QVuCA5C6rhd0xmphs5RLmbnVYPIbuGj9CzvdzduPjQzdwKD9KTBmg2H2KPsgODReLvoFrLQRjZOReC3xCF2DJlIClWbEy/8kBuDb4AVUaMjN/T/3Auvpy1y/8/4ZVnrnC/5WBKbL6N2EmTSOFBob/Ifd7N2arQmrW+8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7AYEnnll4IDtrImkjlawfMwmM7B2mK0dwl0jpQEHOo=;
 b=2Ap99Zxk20G2oijqP6w2753p+78TAlwYXScOU2WLkv/TUfldX2bzM40OFNhgm7jXQaqNr27+B8Xb29NW818KgyiM8Cldkb2FsJOrejPNu8blVKGbgqTsDVd0XSwLtNOIrF0XBXDeAURkAyKml9EeOa3oGJZN02xJshfn2msdVUM=
Received: from BYAPR11CA0044.namprd11.prod.outlook.com (2603:10b6:a03:80::21)
 by SA1PR12MB8144.namprd12.prod.outlook.com (2603:10b6:806:337::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 21:47:11 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::1f) by BYAPR11CA0044.outlook.office365.com
 (2603:10b6:a03:80::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:47:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:47:11 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:47:09 -0600
Date: Thu, 8 Jan 2026 15:38:11 -0600
From: Michael Roth <michael.roth@amd.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david@redhat.com"
	<david@redhat.com>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"seanjc@google.com" <seanjc@google.com>, "aik@amd.com" <aik@amd.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 2/5] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20260108213811.qhurtlw3gto5yhfy@amd.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
 <20251215153411.3613928-3-michael.roth@amd.com>
 <35e79cadf079622588ddb9fac0ccc985751dd81b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <35e79cadf079622588ddb9fac0ccc985751dd81b.camel@intel.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|SA1PR12MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: e156d45f-7a49-4778-8e2f-08de4eff7a96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WYOVKP7AF64dnRcaalcXLcswTXmXA/88xIsOKWHnK0SHFiAVwYFykZUCD7al?=
 =?us-ascii?Q?rfsKNjUESXPNZx8XNmX02SvgW3bjTmN7CLCvvSudHwc69E084ZQrkIS1fokz?=
 =?us-ascii?Q?AIu27MWILhRQ4BZ7vBiS4zciaVX89x6wFOi2SgEhKpBZYPbunbKwqsFUSpKn?=
 =?us-ascii?Q?GPi5M4kUqLH0DJM6o0GAPoOP82eFgRn5/Ip/QEQvaa/NmbamNbi7/lAp80SN?=
 =?us-ascii?Q?4WGk7Y8K0Ov4solGan2eUHka5e8FOub2JtVcuN8NVh3+bmblx7LxyXwLx97Q?=
 =?us-ascii?Q?Qug6S4Xtcx7KY/Uas2U4S1/nMIOEkDMFdqjkZFeJyJklXG2CDPd5+lJ6O2ZT?=
 =?us-ascii?Q?N2+bfHJAAwWI530+4Odl4uIujLnAszcHYgUGe2cKacizXdrua/+NBhCTDvlZ?=
 =?us-ascii?Q?zLFbDL7IEWFhY08kIF3la/Xda2RJwcww3zRUOzREtz/A0Kb0FtxXGGk49h2r?=
 =?us-ascii?Q?+YlSosrcWBSpa2m1uPy0BA0bojmNOilmWqCP4GIDjmvpR4wZAzcMbInAn0ga?=
 =?us-ascii?Q?WYvcoSTTxfub59OhHG6Gm5BW9VZfBfbpn+Xapw1+Ionm7agp3mL8zjd93TsV?=
 =?us-ascii?Q?SFJ9W+BAa8JS2YacWQPYsRlELI4LQ4G0cuJSPOUNX4wa4MFzhPBV8KG5gK4H?=
 =?us-ascii?Q?p0EJtwmIQAEKjMLXqzfvLAyeb6H1AdE+WHJjITCqv0DH7aosH/IgQH8yI1w/?=
 =?us-ascii?Q?BcPRZo5wHZgCJCXt5u/RfCNGDyjxK+Jiss1AnG9lWyXz8+IPGGyZy4EVyYYx?=
 =?us-ascii?Q?FgVW8e4Qx0Aaj2AhbVxUELnK/oYiaWj7bDy9eUiZNEuOpNVP/4qmchm8WonP?=
 =?us-ascii?Q?cq2GzABGsfvoDki+yD6OUVqhtcTt4KjmRgR5w2KQYY4IUHv6I+VIoZz8temW?=
 =?us-ascii?Q?253VXJM+5+4/o+fCLNAzwWI3Y7F1wtwyjazSzBlPRjw31fo6fQWNxnQ5Se8V?=
 =?us-ascii?Q?vqMr7z143YNS4mTz0WMSG0bj0Sd0Sc58qajfdLCcI1nyX+POcGaWayp7t9J5?=
 =?us-ascii?Q?YVUGpP6E31YvAvdXr+GandQ5/TdCSopXu7m/7egbhYo3fqCCuUNNIlx7qETu?=
 =?us-ascii?Q?T7ureKQ2sOucqZFlkoxTdqP9S/RFWhBFnFe7mGcNUuIYpeaybJ+tYBifkNLe?=
 =?us-ascii?Q?a5pBnye6LwZd/bY/8ozd+1F9Qg8N+xHu5P34A9zvIKMi/9K56GcRinejYnjA?=
 =?us-ascii?Q?SjLvLfO/HMON0AnbqenbmMaLVsZmkwKvUBskTDkZbgFh3GNNM6T8roYk/R+A?=
 =?us-ascii?Q?EzG2kW8KgC6ifP5zCulbJBg7b0CzdmtFZZqTEflBsjt+fxdHz+VZO6YCWu1r?=
 =?us-ascii?Q?RO9CeCPKJkRgkhlTBVEi+XANh2jyiWYVKK+4oKqxqgB2EGKVsU89p5+nmxD8?=
 =?us-ascii?Q?3bUwsC9KB2e2QWGErooXZ6wLxR0gh4C2C+RtWXd0JHmSprNixeJfihhP3Ew/?=
 =?us-ascii?Q?VreszVGL2VbjvBbwll+D/noVsYxGdZpfjwnfwSO5vWgwPih5BBCF0rhdhw2o?=
 =?us-ascii?Q?IwrPlNvO61yqBtqXxwLrA8guCLlb/eQTxyFpaupKah3t0PNbmVYuVPh9jcZu?=
 =?us-ascii?Q?Lx20tZMUnrSv4IXDBwE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:47:11.2160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e156d45f-7a49-4778-8e2f-08de4eff7a96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8144

On Thu, Dec 18, 2025 at 10:53:14PM +0000, Huang, Kai wrote:
> 
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
> 
> Here the entire folio is cleared, but ...
> 
> [...]
> 
> > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> >  	if (IS_ERR(folio))
> >  		return PTR_ERR(folio);
> >  
> > -	if (!is_prepared)
> > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > +	if (!folio_test_uptodate(folio)) {
> > +		clear_highpage(folio_page(folio, 0));
> > +		folio_mark_uptodate(folio);
> > +	}
> 
> ... here only the first page is cleared.
> 
> I understand currently there's no huge folio coming out of gmem now, but
> since both __kvm_gmem_get_pfn() and kvm_gmem_get_pfn() still have
> @max_level as output, it's kinda inconsistent here.
> 
> I also see kvm_gmem_fault_user_mapping() only clears the first page too,
> but I think that already has assumption that folio can never be huge
> currently?
> 
> Given this, and the fact that the first patch of this series has
> introduced 
> 
> 	WARN_ON_ONCE(folio_order(folio));
> 
> in kvm_gmem_get_folio(), I think it's fine to only clear the first page,
> but for the sake of consistency, perhaps we should just remove @max_order
> from __kvm_gmem_get_pfn() and kvm_gmem_get_pfn()?
> 
> Then we can handle huge folio logic when that comes to play.

Sean had mentioned during the PUCK prior to this that he was okay with
stripping out traces of hugepage support from kvm_gmem_populate() path,
since it's bringing about unecessary complexity for a use-case we'll
potentially never support. We will however eventually support hugepages
outside the kvm_gmem_populate() path, and the bits and pieces of the
API that plumb those details into KVM MMU code are more useful to keep
around since there's existing hugepage support in KVM MMU that make it
clearer where/when we'll need it. So I'm not sure we gain much from the
churn of stripping it out. However, if as part of wiring up hugepage
support those interfaces prove insufficient, then I wouldn't be opposed
to similarly adding pre-patches to strip it out for a cleaner base
implementation, but I don't really think that need to be part fo this
series which is focused more on the population path rather than fault
handling at run-time, so I've left things as-is for v3 for now.

> 
> Btw:
> 
> I actually looked into the RFC v1 discussion but the code there actually
> does a loop to clear all pages in the folio.  There were some other

The thinking there was to try to not actively break the hugepage-related
bits that were already in place, but since we decided to implement
hugepage-related stuff for kvm_gmem_populate() as a clean follow-up
implementation, there's no need to consider the hugepage case and loop
through the page.

> discussions about AFAICT they were more related to issues regarding to 
> "mark entire folio as uptodate while only one page is processed in
> post_populate()".
> 
> Btw2:
> 
> There was also discussion that clearing page isn't required for TDX.  To
> that end, maybe we can remove clearing page from gmem common code but to
> SEV code, e.g., as part of "folio preparation"?

I think we are considering this approach for TDX and there was some
discussion of having gmem-internal flags to select for this type of
handling, but I think that would make more sense as part of TDX-specific
enablement of in-place conversion. I'm planning to post the SNP-specific
enablement of in-place conversion patches on top of this series, so
maybe we can consider this in response to that series or as part of the
TDX-specific enablement.

-Mike

