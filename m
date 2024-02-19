Return-Path: <kvm+bounces-9005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB3E859B4B
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 05:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCF21B20D9E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 04:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6874AF9F4;
	Mon, 19 Feb 2024 04:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPC5jNfC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B145DEAD3;
	Mon, 19 Feb 2024 04:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708316044; cv=fail; b=QB7p8yDWM8TOyx5QfdT0KmurmsUoc1PeMK+L7M1rf7F+zgZnPsKDDfTZTXvU0MJZwE8mQF9HE8W6cmEGWmFwfC2Xw4t2HysLp4t1rZDYynWaJ72M5s0rGy38SUiuIKwa/ZoNkqpAXvspWDh7nrPWdNzdzxl0aO54bUBFCBjgbyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708316044; c=relaxed/simple;
	bh=CXJGus7sPRaDuNXZFTDK1iJauZ+74ZM/nV3iiyiURCU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XZ9vi9O7m81StkKuaHRSanfrrcUsVzpOXKftQksgPXm9F6ZUOBQurwT2mMNsFJQKZKM0Mn5feiL1D5M2ybqgC55lalscFn2FF5/weKPwGOxcYZxTX2HWsFDMo08mUCTBRvAcr78Bz7UjU4WVpixJPntnEzrKLyCaJuYlqUpp0W0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPC5jNfC; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708316043; x=1739852043;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=CXJGus7sPRaDuNXZFTDK1iJauZ+74ZM/nV3iiyiURCU=;
  b=SPC5jNfClJl3Ams6jXBnHkLBf49qul7BM/wJk1EDFTCLMYZNHQx1nrs7
   HIbrPP5MC1ZXxUwNnFO4YidX5Mnl6Tpoc2OoKy3F3HmwTbdBdqcQDofgZ
   HTB69fanGlTS+tDlhCcyz/U/t4oz1NnQdm8EkQ8UQP0qYyYrp6IeUBn8d
   Kmz70frn3h+zRllEPftcYGLfSFeCByZJ86Zq8x6nNgE1nDtpYelEDKgbw
   NvsSPVK+dt9LQPpAsWZbHUDW/zSi5TiO8L3bTZssdnG5mx4NRpZMSgeR8
   OW2gCd6vJJK1z0A5YGxCvWSRcB+5GAwqLD8YF7Y3K218iiU3UwMDKi2//
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2253330"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2253330"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 20:14:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="4731155"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Feb 2024 20:14:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 18 Feb 2024 20:13:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 18 Feb 2024 20:13:58 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 18 Feb 2024 20:13:58 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 18 Feb 2024 20:13:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahStLxcsaDqmKAz+1rhFWWmqUCFxByzKpWSQvGo+WxPPO8h2hQI37OG8rHEjhe5dCZi/cnQor6KgNpsyT5wHQLt+1KXGqotLNF9dK7KICWecq1W/sAYgCEytqpB4k6KuzVXKza7iKDQGJRtP04gOA1Db7+ApGmWS4fn041FGwi3qNRSAJZpqjvVe2fLta0M/ZJsPrTYRIaI5mW7JljQ0ftL6XYDXHj1KZTs642fyc45cr5IyNnX1vCCV8fOQ9FF1HqaEGEOKhP6wKsguRTLQnjOdlN+5slOu0VfxrB46klYnHq399HqupTAhX6p9n6az7R0YjSgSkYvXJ34+foKJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSFWz3pQZlMEPwwpBmyFHXge89oc9dakGEoXQ9dNjok=;
 b=HDh9czLJkBoZpGmHV9ixFpXKT1fXec3wAO0dogRmFcGeAB7tpblOkTDUynGh7o5GRkLcyXbl9FMtIZ1pW4gdMcZykL4aH1sQThA84JkJ+O4WjOQA/0wIyyRAnTpN7t8LaNNsIO3LfbuzK6CCzWK5NurYXqRAlGW8F6PZ+90B1uTv/ZP7Jx26ZuBTr1+TVstvPgXaZK10i/1fskpWLHUFWvxT9819VAeNoy6+UBwLFb596wthvZw3Coy+eTdTBZB+KCpR8euHG4lTlUXPlDNQdoEajwuQc65ms1gJBUU4KmN9CO0tDIJpp5DiCTiGfEJSk0Ai5XsxWueVdYEczGy87Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV2PR11MB5973.namprd11.prod.outlook.com (2603:10b6:408:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.34; Mon, 19 Feb
 2024 04:13:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e%6]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 04:13:56 +0000
Date: Mon, 19 Feb 2024 11:44:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Friedrich Weber <f.weber@proxmox.com>, "Kai
 Huang" <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Chao Peng
	<chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, Michael Roth
	<michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "David
 Matlack" <dmatlack@google.com>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
Message-ID: <ZdLOjuCP2pDjhsJl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240209222858.396696-1-seanjc@google.com>
 <20240209222858.396696-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209222858.396696-4-seanjc@google.com>
X-ClientProxiedBy: SGXP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::34)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV2PR11MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: 9897641f-d060-4e7b-83cd-08dc310130e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sksHwTb/4XCSDzP3rgllyP1jI2UPVjhkLjaWaT4YyQHKWM0g92YhAUojurQN7eLGnKQMxLzwQpOIGrV9KE4OYYV3hxxcAd+umNl3QfckN8aj4HFUrtpnSlkkuSQnuCD9OlIO45E2cr3L9Q1/JPeCdvmX3wkH1OHpVDGcN70yhiNKx83wa5sS96pZLrpxF9HXOHLLsAJChgu6tQn/sBOFi7ejbWO1S5QJDici2scbLbfE8ZXucN1Fxe2HuVUmqPLi81Ulfh0NKR6VeM/H1L8isPjh5Wx+ow+LLpnAv6z3uys6GMqkRYaN5u/QvOVOExouxPoqGxF2VlEYHCZd0mQUuJAC8E59eSc5BU/GKjjaWJXfQUHZ7hQzmG7gzNWbshfvrGmE+YvV1slEr/UO2toUZRs2EySeOH+q33ISX5r83wu7+VVw9BS74GblD2zKRSyvyMkQbmGdZQzgxZ2X72idYIG9mevAI8tc1NhHLrs5JeTfhCUQaluYG2CIAygsmf/4VS4lV0EntKuSUvh1zMTf2HT0xTxxoN080t9fK0ndfokLwy7ueYcfDuJ8ByelInE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(8676002)(26005)(41300700001)(83380400001)(8936002)(6916009)(4326008)(66476007)(66556008)(66946007)(316002)(478600001)(6486002)(6506007)(6512007)(6666004)(54906003)(82960400001)(38100700002)(86362001)(5660300002)(7416002)(2906002)(3450700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dZvtnR7bdwLPUBLuAQ/DJR59E4BHw/C4CbCmLY7Q3s1RunAwI7Kg1QqK0PUz?=
 =?us-ascii?Q?ZoyErrZkQhaKMhfV6IyqjTbCCH9MLC7dwF5w64Gj4MvNNS2AIxLDFL+5C454?=
 =?us-ascii?Q?OZN2+L3XVvxjMRufdyH87ENchfSeudjqo+WZjuLKQMnIs5x6Bc7BEvjCzA/6?=
 =?us-ascii?Q?0uB+2kpE5lu4CpKOLI4vZEQDf2vf68mqAyyeRklXc6vKIEAGJwwPO1iEJv48?=
 =?us-ascii?Q?/NMIrIhrYHlibeCx2KCfEQRXXA/KVDfFEaBp+yM9NyGIHW3Y3A7bLRRGf1Pw?=
 =?us-ascii?Q?xNTq6jUezQ2M5V44rkFEnjuZNvppjgR6H9zKyzH/CtVMAVfmdmQ7BiM2Ev1I?=
 =?us-ascii?Q?pjZ1NMCE0vCkjYCkIcBxXB82Y3voDACIxjXQ0umvPaB6d9N3WTTMhbVYOe3R?=
 =?us-ascii?Q?waKvYu7TN4tGwZlXKRX9n09bKL3CnkDSdHuha2oT/nY/e8II4ywldfMd6eaL?=
 =?us-ascii?Q?pu3v2FRXEJWfsQmUfoxNatmomAZ8IwQ6PFtKGA9D+csa2ITmXxmtGkLJbNQ5?=
 =?us-ascii?Q?LGiVsErVJn3rMdwuldq2xkMVUkLYZeI5uPSTQChBLCPppWvCHRJ/Pcy/IXBk?=
 =?us-ascii?Q?d2iEdWheJSl2vSd00jrEYqlJYtssosDxTy2n23muoyjLK2ys58hKLc3gJNt3?=
 =?us-ascii?Q?pvozWzneDKUS3clzqzhRrfdK3UAMpOKpsgQIZS1bbniFmFg1T5h0HBvSqGMC?=
 =?us-ascii?Q?KWqlsjA9qIChmfB24nQ51yWDeqDVmv9SBFwREk6TajdZeOsP8hNW/epe7O8K?=
 =?us-ascii?Q?/97Oa3HqsouFtZBdXg/li+DXDm0BYQ/4hc6QsOVJt1BWnTRUzcTI1USb6LTG?=
 =?us-ascii?Q?5Ogv4Llg18XwD9LeMb55WPUbji7w4JC/1aNd9g5C9LgN4o5veeED9gqdcPaQ?=
 =?us-ascii?Q?J+Zq+S5x665EMDUvrtbUkvm7Y6p2XU7CtdhPuUNOlDMWLotvRrmINWrxw0aH?=
 =?us-ascii?Q?XpmvCTN/AUrqx+G3/leS8/VwBa72Upo4Ao3VmyNMho8tZsbtV2jUB0PXeaFr?=
 =?us-ascii?Q?iVxMnBSvY7Hv8FbfWVcWZ8TBpjS9NnJ1PVqJpTjz3c85+eP+wi/O7oQa7GtV?=
 =?us-ascii?Q?j8P0pgyhH9qtlYozCDh+QCAaD4L9kd9Fl8FgKt+poZYHiZ1CgTQgo8QNaa5j?=
 =?us-ascii?Q?M8dFAGZlvichpGavCqgyu03q/sMc+Pq667Ig81YDbT3g/e53fx+zH0LILESH?=
 =?us-ascii?Q?J3IbqlUqBVewsNuqJuwRJiDq+fHx8YnbY3PWfHsaRKViGKgE5NsRBkeKFES8?=
 =?us-ascii?Q?sSZSrTTSbJZBikZJN7JmB/yqXNt3YRG2DflGQJ2fPICBXV36j7X0V6cs++Hb?=
 =?us-ascii?Q?mVKS420bd5e5TJUHbD7ryM/GIf4JDNHCf9B8YNyM/b0TGGz26u3YN9WKDJ1S?=
 =?us-ascii?Q?t9aHPVt4gfei40r8eVf5yrgPorkpWRIgzV+fTqFttRywF9hPMSrtkRDOjNEh?=
 =?us-ascii?Q?K6C87FHYXS18+cEQMWSIxQv4vMvOs8k7jjivWFY8K/py21XNVpM996DtB9s2?=
 =?us-ascii?Q?BqIwnE6zVbtcUT4zLRniQCS/PXhhisLcEoEf/WwvBHsEubEAnPcktm0GSCtP?=
 =?us-ascii?Q?YzHoxq/M4Z3Eqhut41998Cxn1HjEhhUn/pCgt51r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9897641f-d060-4e7b-83cd-08dc310130e5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 04:13:56.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJt7pvVJyvYEDB+/LiM//YHkydzzVkSKLTWF5ixCo6c8x4iansUN8CMhx8KE8GsoMcfqNnZ9/RDILQcCQfnGoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5973
X-OriginatorOrg: intel.com

On Fri, Feb 09, 2024 at 02:28:57PM -0800, Sean Christopherson wrote:
> Move the checks related to the validity of an access to a memslot from the
> inner __kvm_faultin_pfn() to its sole caller, kvm_faultin_pfn().  This
> allows emulating accesses to the APIC access page, which don't need to
> resolve a pfn, even if there is a relevant in-progress mmu_notifier
> invalidation.  Ditto for accesses to KVM internal memslots from L2, which
> KVM also treats as emulated MMIO.
> 
> More importantly, this will allow for future cleanup by having the
> "no memslot" case bail from kvm_faultin_pfn() very early on.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 62 ++++++++++++++++++++++--------------------
>  1 file changed, 33 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 50bfaa53f3f2..505fc7eef533 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4333,33 +4333,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	struct kvm_memory_slot *slot = fault->slot;
>  	bool async;
>  
> -	/*
> -	 * Retry the page fault if the gfn hit a memslot that is being deleted
> -	 * or moved.  This ensures any existing SPTEs for the old memslot will
> -	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
> -	 */
> -	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
> -		return RET_PF_RETRY;
> -
> -	if (!kvm_is_visible_memslot(slot)) {
> -		/* Don't expose private memslots to L2. */
> -		if (is_guest_mode(vcpu)) {
> -			fault->slot = NULL;
> -			fault->pfn = KVM_PFN_NOSLOT;
> -			fault->map_writable = false;
> -			return RET_PF_CONTINUE;
> -		}
> -		/*
> -		 * If the APIC access page exists but is disabled, go directly
> -		 * to emulation without caching the MMIO access or creating a
> -		 * MMIO SPTE.  That way the cache doesn't need to be purged
> -		 * when the AVIC is re-enabled.
> -		 */
> -		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> -		    !kvm_apicv_activated(vcpu->kvm))
> -			return RET_PF_EMULATE;
> -	}
> -
>  	if (fault->is_private)
>  		return kvm_faultin_pfn_private(vcpu, fault);
>  
> @@ -4406,6 +4379,37 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>  	smp_rmb();
>  
> +	if (!slot)
> +		goto faultin_pfn;
> +
> +	/*
> +	 * Retry the page fault if the gfn hit a memslot that is being deleted
> +	 * or moved.  This ensures any existing SPTEs for the old memslot will
> +	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
> +	 */
> +	if (slot->flags & KVM_MEMSLOT_INVALID)
> +		return RET_PF_RETRY;
> +
> +	if (!kvm_is_visible_memslot(slot)) {
> +		/* Don't expose KVM's internal memslots to L2. */
> +		if (is_guest_mode(vcpu)) {
> +			fault->slot = NULL;
> +			fault->pfn = KVM_PFN_NOSLOT;
> +			fault->map_writable = false;
> +			return RET_PF_CONTINUE;
Call kvm_handle_noslot_fault() to replace returning RET_PF_CONTINUE?

> +		}
> +
> +		/*
> +		 * If the APIC access page exists but is disabled, go directly
> +		 * to emulation without caching the MMIO access or creating a
> +		 * MMIO SPTE.  That way the cache doesn't need to be purged
> +		 * when the AVIC is re-enabled.
> +		 */
> +		if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> +		    !kvm_apicv_activated(vcpu->kvm))
> +			return RET_PF_EMULATE;
> +	}
> +
>  	/*
>  	 * Check for a relevant mmu_notifier invalidation event before getting
>  	 * the pfn from the primary MMU, and before acquiring mmu_lock.
> @@ -4427,10 +4431,10 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
>  	 * to detect retry guarantees the worst case latency for the vCPU.
>  	 */
> -	if (!slot &&
> -	    mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
> +	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
>  		return RET_PF_RETRY;
>  
> +faultin_pfn:
>  	ret = __kvm_faultin_pfn(vcpu, fault);
>  	if (ret != RET_PF_CONTINUE)
>  		return ret;
> -- 
> 2.43.0.687.g38aa6559b0-goog
> 

