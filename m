Return-Path: <kvm+bounces-11773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7A887B5E2
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 01:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 578DC1C222A7
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 00:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5885B53AA;
	Thu, 14 Mar 2024 00:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NTw8fReS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48044A08;
	Thu, 14 Mar 2024 00:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710376934; cv=fail; b=XRksu8hNviC0rHp3VFWq2fyoMCslftLJyTBQ+YhgHSu4wi+qAWODtDkE44jBXHcJpOCYRLk1K37dk20cJOG1E4qV35CAOr7/y0PRW8yduf2dJJPZDKnKSlKDyIvUIGlZT08o6W2HJeCdrAkVCxRGdej9ObGoP5WlBjfuzBWiP2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710376934; c=relaxed/simple;
	bh=OzUHubgVo9kUOUEG6xrwQ5xs4ftRwwoN5ZBlIhBoZEc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KWaW06aZPZXaHTdSKew5SOYciWx9WhtFvWo5s0QeTLF2eHZ0wEERxNBUok7GuMG5W7MldlIXI35H7gQzaM0C823Ra4pH/02WZzLuqEUWfrZV9xSQCVjIn1YCXZdfY0ums0Pk+rFVFvDTs2Sf6Cw6AdSJekVVSwqvrqrsgNUrKfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NTw8fReS; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710376932; x=1741912932;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OzUHubgVo9kUOUEG6xrwQ5xs4ftRwwoN5ZBlIhBoZEc=;
  b=NTw8fReS8fUZvF0NM5Yl1T0a8fsfGJCDdWalSg3kuIlZ+PPjpJIRrQz7
   7z0V6+vZxK9hdbKvivV9wkbmOX6WQIutvbxNMZv5DdQ3WWK6qyRzig3hm
   sWGQFG3UvHogqJDHiSuS2iyce/aU+6fzy5BwZFZUTs+pmLagIKQrBonPi
   NoHfOYBR9XIZ52eBrH35YvF7TIE1ls4k8WtqQRyj3a5Tf1iy+nERmf3+r
   A0bHqXMJFcMqzcfwxBeHFnbgQ9i5PGGTddwV8CSNvK1blFij/kglFUED8
   OAWQpSwtU533+mTiYSGfpAMgmfrSIIvqyCDa3C0fEc7eHkieJ8THnOqEA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5040727"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="5040727"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 17:42:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="16713309"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 17:42:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 17:42:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 17:42:11 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 17:42:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wv42jAbEgQYQZVROrKefhLcsG6h9V4+lvgnTl6Sh50cXtrWZU1tGcTCSufERvHgbQVVRz26DZdeqIn03FjcidpI6DnPYdYrwgi4FCVqpJ+kyO6M63w/tUKf0RfD2QRdqXTIAssD9Bznz+f60wSXb5UUnrcz9VYUEi0xvrJXcLqdrKRpfY3anxPbGKZtg/smc5Bwo0aagZneYGvPrHLLYLPKLZy/xEeoqer72RPmm0f8IQNqqVOtvysvMwvbyCU6QGJ2AE3qpOkXDqEvAsp4140a+92vRryGoSENePkFtmKrYrE5IH8Sm0ynk3svxDEmYeulDOYOgNYkyV+v1AphxCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHcGF5TAalz9hGIbl9FHfxj/PXf9Hh790WgnMwOrylE=;
 b=mNYoVWiHYTH1KYqq4f5DrmrnDzHtcYFgvAqYBw9sYkPuiofc63k4m87/ckcP40cijKk/KaopYrQNBeFsTUVxWm23qEt2hcR9DZGcSskGAaWnb1aoaKsVmI9Ytg1OksuDc2p1CYqz07G5SIsyvYcVhh2kchnjArKKjsoMcM69kiSMRtfnqL7PtDA624wzPLuqcB15E7EkcUe1UyUNQgHhNWmrVJENpu17l3whr+fDrsrgvOshmd0tPKwWpBvYhvmWW9O1A2TYsPJuxvZbtVMifMqCJYKatlDdz5PpcsRgWgUr9vQ5JwKUh7x4YmOGquvJZkJTaFflh1aEk4LIbSEGjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6099.namprd11.prod.outlook.com (2603:10b6:208:3d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Thu, 14 Mar
 2024 00:42:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 00:42:08 +0000
Date: Thu, 14 Mar 2024 08:12:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Kevin Tian <kevin.tian@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett
	<josh@joshtriplett.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"rcu@vger.kernel.org" <rcu@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZfJA3AaLga5OXoL1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <Ze5bee/qJ41IESdk@yzhao56-desk.sh.intel.com>
 <Ze-hC8NozVbOQQIT@google.com>
 <BN9PR11MB527600EC915D668127B97E3C8C2B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZfB9rzqOWmbaOeHd@google.com>
 <ZfD++pl/3pvyi0xD@yzhao56-desk.sh.intel.com>
 <BN9PR11MB527688657D92896F1B19C2F98C2A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZfFp6HtYSmO4Q6sW@yzhao56-desk.sh.intel.com>
 <ZfHBqNzaoh36PXDn@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZfHBqNzaoh36PXDn@google.com>
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 2344c3bb-cbcc-4c35-ef3c-08dc43bf9418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sS+4bVdv3p6Y1VGFBEycevTEDjbhkNobPeNYp5oPWfVn2WGOYGo2M9E89BSrKovf2zYwPL+O5uuTkOiPu9dbxvIi0xumLM2X89VZm+csFXqa3h7IVezbmxsP/Qst5f+eZt0EXqlluI1S14C+mEpdmY17KeH8NQA5W+igUw28ClFS3uTuKuxHbRyObmA81nzEC/y1qx8RgJp0RYr3RE3ZgD/bMPk5e8DDAc94yeCr7k176sOiUPM4lcFIuaTfeSzTjp5Xoh8Ccqu7wkak3YBJGDmVUuJWpUXeL8m52roL+k7PBzUPM7QBcqxPP8O8UrucNmo3HSYcLGZiDKGVg1yXzfVPg7Wqq7dJflVnZpT0pgZC63td3datn72YrHD6Rl6/yjvUx3duncw7nsgKP1Z3PMcZr+q63dywNq7oQKRAaWluRGH5zfvcXdMK8ceKZBBHNKggcetW2bN0BhyUtlx5N8KfoP2T6MpQCd+g8MjQreBbIlqfwcWHJXMw+R2PSdFFZ6I5Hg2CPE6pk5swK/wOlMhcChmnqBDVQwi5yjOuyHpFYtRol/he4jiWhO+H3THWCzCofxbs1w9Js9XSAE8bgnfiOjzv7dmKUOagCkA6Z2iLX7lezFnX9DtCE2BVr2EDLF7Abeil/M1jAd13x0eVUzOjjBnAAzZuWdhPFrDH9Rk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v8mrDjiDAD+ST57HaSZz/gYvpr8ZrlYPkejqir7rHSrcyqGK5G2koc50OFBI?=
 =?us-ascii?Q?TgsUQGKzojWHycgV4Cm0dpHxBneYMqFypShVOyx9vPsVslIUnDazfid3BB2A?=
 =?us-ascii?Q?FQkYYV/7v2xM/+WiAwRWXrbHjghpInhUNwY8YfbVN0dwgjDR5sS9GbvRTq2E?=
 =?us-ascii?Q?fITuc8US01sKfkPG/NLRu315QzcuKQiKSJCSzED2c8nv3TcnD+dQVE8T/rFq?=
 =?us-ascii?Q?iH2XLJ4DDycbiLIyHlTwGS2YzFQ0QaR/LnoPOeIGsXO10EbxkoAVXyRiyhOq?=
 =?us-ascii?Q?jWOKavpzse26roJuWj84kAJSdp7hfBa21Sby97IqB77F0VMcnX0i8zrQYvwC?=
 =?us-ascii?Q?qQRprIkfntp3jvpGGTH8mpl47dlQNJFSGbB2sSp5PW2UdgDEypKiQRpsA5G8?=
 =?us-ascii?Q?Z94Y9yHpWwgyF2dMWf3QhnqWl5WtlQ1e3W5YwLukYWOg9eqlGE5kGsll6TyG?=
 =?us-ascii?Q?eLnBv5vWFBPAHXC1o/cVpeUujCdleLn85vbEKz55J26QA1DemW+NNG3CL0wi?=
 =?us-ascii?Q?R0DxxBisLASSxk3rB0bZb3/XINaRQk/xLHopePLJhQVi/a7hEIfuPjyy4BUR?=
 =?us-ascii?Q?tQnQijoGsljdA0Z4ZnjdsGj6F/cCYg8x4sEARZ+XjTvRtPXgAyc//yldnfS4?=
 =?us-ascii?Q?meIOyp5mAM6wkO4IdmdIXVWoZh2Hs4nUSY7DYOCtdad+tGtXGmlc6AKTpMh6?=
 =?us-ascii?Q?zLAXAgVCM3VKHiBTDmpHHuz/QX+4VwaAaMRcFjQHtqYsemB+Y5OfazhGlRUT?=
 =?us-ascii?Q?WwLgrPrYne/7b37aZC+KWgDIZoxWA9fSSCvV6VeS1bGZhS0hI2GnCTe4M1mM?=
 =?us-ascii?Q?i60aBmhSx9BoxB7ZDqH2XZ9o3UK8PKGSDKeW70LEIYNJ/u28cV16pfWFrR0p?=
 =?us-ascii?Q?Zs9VlCRTPWraart35hOYRK76gTXwoB9igHCfNlafyipzk0xI0t36P+tzhzts?=
 =?us-ascii?Q?KRwnmenbF/C+/ikZpz9BkpeBPVBwiGsMtGKsWk/E1USlDxJY9EcmHJw4CWPs?=
 =?us-ascii?Q?YgLRvQI+OQoj1y8KXY8/UW+sfIL8DmyLbu2+u7lhjsEd2zS0xrI7KeNYB8sx?=
 =?us-ascii?Q?+FqYMEmEsIgZD11iu45dw/HCImmlSpb0alkdG7FOqdFhq/hwsGTZK2mcR06q?=
 =?us-ascii?Q?8c3INFCVdfU9FfXAY87kfcVDKCUQkgA9+mQ2TmSTm0YQPMuoSnyUmZ80J4hp?=
 =?us-ascii?Q?6xS9WNfI47i0dM4YMMyJRbPVznVlhYhxenace0q7ZvN+bIKP9SCOG+/k3Oqc?=
 =?us-ascii?Q?5voKsDAk2g8fF5YH+59PVQ9N8/GmGRvuidp+m1isQTCX11qtR4vPuVAy+uUd?=
 =?us-ascii?Q?bjzjnbJ/f8u9nctFA+foy7K2OA3Ou6c3ng9lnDYHDQJMor1HS6ffaMWA3rsO?=
 =?us-ascii?Q?HJEnp5+hukhEHxrvTbqe2+7kUrh4pNu3oAeFbP6fHjxt9Nmjn4HlBkuaIzR5?=
 =?us-ascii?Q?1JltIUfeXulqH/HYxBV7NTjlpaflqXouKI3i0RkA4jr2edkJ3BMxnN7di13+?=
 =?us-ascii?Q?8+q1LVm0bGIc8veeR99IHpAv4fp6jD9S1952+Icw/1TSwyvkUHjnVzqWEK3m?=
 =?us-ascii?Q?NT2FYu0o8CBb7hadc8SdcbTGdYV7u15sSigHrxmD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2344c3bb-cbcc-4c35-ef3c-08dc43bf9418
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 00:42:08.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VhcWwZlhh9CmvZfmayOctydH5F4rUEUDvJepOUHDQayYsJKcyeOuncgdb7LLHKtc5xWHhz6wWUi9qMdMKqXasA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6099
X-OriginatorOrg: intel.com

On Wed, Mar 13, 2024 at 08:09:28AM -0700, Sean Christopherson wrote:
> On Wed, Mar 13, 2024, Yan Zhao wrote:
> > > We'll certain fix the security hole on CPUs w/ self-snoop. In this case
> > > CPU accesses are guaranteed to be coherent and the vulnerability can
> > > only be exposed via non-coherent DMA which is supposed to be fixed
> > > by your coming series. 
> > > 
> > > But for old CPUs w/o self-snoop the hole can be exploited using either CPU
> > > or non-coherent DMA once the guest PAT is honored. As long as nobody
> > > is willing to actually fix the CPU path (is it possible?) I'm kind of convinced
> > We can cook a patch to check CPU self-snoop and force WB in EPT even for
> > non-coherent DMA if no self-snoop. Then back porting such a patch together
> > with the IOMMU side mitigation for non-coherent DMA.
> 
> Please don't.  This is a "let sleeping dogs lie" situation.
> 
>   let sleeping dogs lie - avoid interfering in a situation that is currently
>   causing no problems but might do so as a result of such interference.
> 
> Yes, there is technically a flaw, but we have zero evidence that anyone cares or
> that it is actually problematic in practice.  On the other hand, any functional
> change we make has a non-zero changes of breaking existing setups that have worked
> for many years. 
> 
> > Otherwise, IOMMU side mitigation alone is meaningless for platforms of CPU of
> > no self-snoop.
> > 
> > > by Sean that sustaining the old behavior is probably the best option...
> > Yes, as long as we think exposing secuirty hole on those platforms is acceptable. 
> 
> Yes, I think it's acceptable.  Obviously not ideal, but given the alternatives,
> I think it is a reasonable risk.
> 
> Being 100% secure is simply not possible.  Security is often about balancing the
> risk/threat against the cost.  In this case, the risk is low (old hardware,
> uncommon setup for untrusted guests, small window of opportunity, and limited
> data exposure), whereas the cost is high (decent chance of breaking existing VMs).
Ok, thanks for explanation!
I still have one last question: if in future there are CPUs with no selfsnoop
(for some unknown reason, or just paranoid), do we allow this unsafe honoring of
guest memory type for non-coherent DMAs? 

