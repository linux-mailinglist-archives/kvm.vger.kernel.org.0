Return-Path: <kvm+bounces-11485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6313F87799F
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 424C0B211C5
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB65910E9;
	Mon, 11 Mar 2024 01:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WXDBEy7J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015DA7EC;
	Mon, 11 Mar 2024 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710121599; cv=fail; b=UldXXNDF5W/7R+0ZZYk5npDEXl75nH7ATr6sw48uJ/ww1+mQjdZ8gJ/9agsRavd521cIFjYIFWgK4QO/d/cyvM5Tw01w1XoNLVHUJEhJPNtV1tBSBZrn2OCFa8L4iCbeSTGJ9V1b0HLLt+ewqfQytN6+UsRp35IGBzjsf8EcWpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710121599; c=relaxed/simple;
	bh=44YXcOowGavk1ZSJJXPsGNJeggEib5h6olrh9lxZiA0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h7iZtXIIRkHgKfv8TH/Brc7j6IaebhQiFC8syGAHSh9aH6wjCXVTGdoj1Tx0OGF1NB4C/ub/mF2Z5/toLXCsiBPEYcO0Jq5CyfVg0CGGtchkzRtYb/dvZ8UzrJ7GP0oKyWCwEQDIX+rABO2vEN+Bs0AgBvnSLFJ++6H5HPFZRBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WXDBEy7J; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710121597; x=1741657597;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=44YXcOowGavk1ZSJJXPsGNJeggEib5h6olrh9lxZiA0=;
  b=WXDBEy7JA3qaxfTEhvOfsTjIp1chGSRqCCmBJl5FqVHoOOJGXe3kO5C1
   CzOT8zGTHwRhnvn9uNgX16G+kB70ypt3+FilWTdfMJ1Felw+lCQzqz4A9
   ULpKaXRwW2rhz41usFYS7jnJFbfGujodyfX6Kmyoe2P4o/dyj+OUeAjc7
   fLFGOMovBmvHfjMc81ZO5Z/ialmzJUsopCT0nT0EAqYvi94XAFp2XKJpv
   avXF3mxsGgkqaa0oHNZlwkHMzJ4R5LvDnMtvyZSuNrg3D4aARYJLUCpQS
   W0nSa/k863kOnrmbxGklmUbmvOZ9GM25dA68ZRYrCLNP/wZlFgF0WAKwp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="7718014"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="7718014"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:46:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="15714634"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2024 18:46:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:46:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Mar 2024 18:46:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Mar 2024 18:46:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZqepU0DQ1UeDR5w7idPLVTui2t2gk0pNsNF1tRU749qgKnXR39wuqFHw8OR/VusAWLqoatq7WuS/iSCXl1rZVd40LqGsW5+oNScf8wl9lf6CwCS6HqXBA+z3KJ0FEyW3b6Qoca9pYDSFRREf+bhctyV9DB0A4QahGoJTlSXEopn8Hp1xn/Fqo+EU/Tf1JTLhdKkDUv6E/qauJ76RiWkyLxW5DDFXTyXG0M/q0QzLZM2O1yeH6f4jzyFwm7yiUXaQdu37RDnlL77ICJWkk/U1IjlJG2LdMQy2OduIxxd80tR+F6BitcbyZGHV5FtkoR2gzW+fQsOf5XK7fPR5I15Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZFSN+QhyPCR3jQvpuVL35oxT2qTHn722Rd58A/dfQw=;
 b=Ohgxn2MXyASrdRgHSW4SE7BqRIfAsBO/TOIqEStqKB9t1kmSjIMDxgNxiCts1jTZFoYjPpINZXK+3qE0CPJvq/l2xqK5w3wr+gKQ+xgkXGoiG8s/Waa0LNxmLRlGg/GIS1QyOQisTVK1ZWWmtiDxQnkz4SXoniLVcC0/5WMnsycpKW/9TAwpiWtAXY5ec7FZEhSACiMBDiBOsZibpGelxrgmgZzOkVvwHLXyvzEPqfSGEN4LigTwv2gtFgWWKStcxYLplw3eb7ATXW9DnfF+Y7lGuTReDcKlFiVOMZwxfO2IaEg0c2zC37Ucf9p+Pymhkh5t6krCygSsj+AusVx7VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8404.namprd11.prod.outlook.com (2603:10b6:a03:53f::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.16; Mon, 11 Mar 2024 01:46:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7386.016; Mon, 11 Mar 2024
 01:46:32 +0000
Date: Mon, 11 Mar 2024 09:16:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, <kvm@vger.kernel.org>,
	<rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kevin Tian
	<kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <Ze5bee/qJ41IESdk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240309010929.1403984-6-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8404:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca375ec-1444-4f44-11dd-08dc416d1449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XFsqB7H5iqrIvWMmASbVasvUGsjHN0yRJTY7aBUuBxFQdLOSiw7xc7A88p0mgaXOW+ACPncEyZRH8tId8JQJwsa6faK4Tfg+iV0Z3tk/XL9mlPFjT/bghqKa9aOCxweyJqJAtIZ19daBkTHFXSyL1HT9cpH4n6UbhMI7jitmpdjVih9i1yGgjYlf5xBAkMIuV7e7t7z8Z5UkmSfHpvorHc3UYVzlV3NcWZRDERZR+DBh9K/PYhWvcpG0db06QBLyHEpf4xKznA1jkgazVD1m/vMCCUW3WxkwjCUugpSn4U7TKOOSUzeze3Wfrv4fXwQYHtETbEcHGbGqQ99wBbsNn7G4iCuOQyR1QnteeHarO8cKBSae3AySpJ1x8hNcaDb8u2Wgjtaj17regjurzqNd7exsnO3QY/PtyRnEmKQ0ZPFziMs75CrJgjVqUGP1cWDxa0EwF9dFqaOD7DDMybXhjE/1lnj05xWJcldgRxQtY4qUWJaNUZ9zRwHKECfFWkb/1ZhXAy6FWfiypEo7qTXmFpDFmem71n2o5GxnB8qGIpvX9fwC7bHEJmzwP110+R9dr2x6ycz6HwwTJroeMlO0H5BhaH2tzt2SVsjWRVUxXBY3xVpszafEV0VCV1ykgsMhL9BCrjGhFTxc5VpAd4fvxVchexkU9wOecIVF9eH9yNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R41UPWtVAWsgSDTlhVmjTloATtpNeofiAzA75I6wO1VALrwFd4K+qKJ2kxp+?=
 =?us-ascii?Q?iV+48I/yEADH1DgYumEQPVd+qBxlNSz9yYH94dZQvDMfWvLvQmoFYoSolrnk?=
 =?us-ascii?Q?VPaU0/Q8QvP9HPOIg4BIBUcFgenHi+jiqmbQOBnMWVUxirdQoxUdlzzzlcCB?=
 =?us-ascii?Q?1csurFKIyQslzwru3YhsYdDM1QvCXLXGZ/7du3SRdz3PDNy69+APicbT3iVn?=
 =?us-ascii?Q?lLF0NUZopZGf+H/Cp4irhC0sisf4XO/IYPQpM0TmbiKZXiPpq1PUMWv9WTV1?=
 =?us-ascii?Q?+SauE5eG4QHR9z7GC853eYbra/HZhtKj29UzGssfKUugmlESraQfrWKaB4ep?=
 =?us-ascii?Q?tC88NRtMw3GD2wtmUhNuKxbVF/3YDwtbuelLTwCDyWEr76vU5/lk9dJi5gOp?=
 =?us-ascii?Q?cLjYdm1OTeTItDLTjIa0o+nJqErg5UnsugmMiubSY9jVmjTORGavsOj0S68S?=
 =?us-ascii?Q?fTdtw/xALtq/tjZYswQsWFGAKe3ZT5aA3F/YXE80HNroeXJLrg8P6Z6DWZ5D?=
 =?us-ascii?Q?X/6pWnQxpqPw7iK3Cp0Dvvt+RZLYpnTA4dxlxX0T3jrA0kosSyPxJfomsWci?=
 =?us-ascii?Q?SyzElIYHeVPTEqa4CZzTYtKifYLH81r/lwXgUCeZc5Uuo4R+1S/4y2psLKQr?=
 =?us-ascii?Q?CI5scXqKlCnMo83PTUlQ2xzvc4D0neDhg5PeDaQntpGOK1BUwQzctTvQitD0?=
 =?us-ascii?Q?jWF0JB+hjEkihx10YAiJwXhnzoBSIUmjBFp0OazqKCD/wYqyUa8fhwxrEUgV?=
 =?us-ascii?Q?V3HFUdHHQEULXgSgfoN4renn1kNVHeiDotHf78beh72N6nBFdJJal7nZpQcb?=
 =?us-ascii?Q?+pU1M9+gqIfJao8ua7D1YoqXy1OGbrrzmmI3UvdBQfyHGLTUX5tOMFzsfCKl?=
 =?us-ascii?Q?ZjU4AOavVNFCUz5YKkoYiVDZwXsAstNIFiZ7QdttXiSIsSD1IjmkMLCkSxRL?=
 =?us-ascii?Q?7Yr54ZPp4zeek3Oj12H6TfraFPDSZ7EutFtSsYPoxLLXUZ9LM2KsijrUoEEs?=
 =?us-ascii?Q?EHXaw5gZX8dqmlQD+el8rrlPwItNL0PluLUl4uQi84JXvhFj8HpfN7UFVKj7?=
 =?us-ascii?Q?QOUXKBFjsXxsZwCRXtwvD5GStwLOdert38M5HFAzTn7OgDFecjLYSyimzl6i?=
 =?us-ascii?Q?4ZuA1N782f94xFbl9TXCuVItVw7M9jEfTrbuagmWV7epIU2fbnskA8aB3QYx?=
 =?us-ascii?Q?Xp0zzWrqPSBr/amGiq4OrEO1iEwsr4ACzllIb3xKpi1ivG89hSXEtDKFvuUl?=
 =?us-ascii?Q?0J/kautrsuv7GT4ZQQsUAgutEAu1bohDEcTypkbeShu/NSvEpGuM68b+kN6x?=
 =?us-ascii?Q?LX6Tq9TnfcSb5SBUozX+PUp7fiqqqp27wkx/VryXReipWgvz/NNI8VsuShFK?=
 =?us-ascii?Q?1xRg3Gn7gELleDpM6yLjr53V15/MAvVwK6SHXIEEE/skPe8QVat6u3Cv7iAC?=
 =?us-ascii?Q?STW8Ur0xlskUQApr8u9wcnIULvJSD5alKN5oRldVjEhd6Lxl+De7sjFz818t?=
 =?us-ascii?Q?cW+p2pKUZqxtSclK9fIqJKAwZWpdNFgXHkfuOmzqRsP7S6p3WdECOvSZIvl6?=
 =?us-ascii?Q?nbZ+BF9NeHQCpB2phH/FZdwSNL3oKFAfCjDuS2me?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca375ec-1444-4f44-11dd-08dc416d1449
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 01:46:32.8285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYh00t6mp1M4TJ6fIjKpB1+eMOI9eUzJ1Q0MrHQf6VwwOogvnmdG6IZzEs2+W49H/PtB4DSu20gwpNSSkOcOqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8404
X-OriginatorOrg: intel.com

On Fri, Mar 08, 2024 at 05:09:29PM -0800, Sean Christopherson wrote:
> Unconditionally honor guest PAT on CPUs that support self-snoop, as
> Intel has confirmed that CPUs that support self-snoop always snoop caches
> and store buffers.  I.e. CPUs with self-snoop maintain cache coherency
> even in the presence of aliased memtypes, thus there is no need to trust
> the guest behaves and only honor PAT as a last resort, as KVM does today.
> 
> Honoring guest PAT is desirable for use cases where the guest has access
> to non-coherent DMA _without_ bouncing through VFIO, e.g. when a virtual
> (mediated, for all intents and purposes) GPU is exposed to the guest, along
> with buffers that are consumed directly by the physical GPU, i.e. which
> can't be proxied by the host to ensure writes from the guest are performed
> with the correct memory type for the GPU.
> 
> Cc: Yiwei Zhang <zzyiwei@google.com>
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c |  8 +++++---
>  arch/x86/kvm/vmx/vmx.c | 10 ++++++----
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 403cd8f914cd..7fa514830628 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4622,14 +4622,16 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  bool kvm_mmu_may_ignore_guest_pat(void)
>  {
>  	/*
> -	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
> +	 * When EPT is enabled (shadow_memtype_mask is non-zero), the CPU does
> +	 * not support self-snoop (or is affected by an erratum), and the VM
>  	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
>  	 * honor the memtype from the guest's PAT so that guest accesses to
>  	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
>  	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
> -	 * KVM _always_ ignores guest PAT (when EPT is enabled).
> +	 * KVM _always_ ignores or honors guest PAT, i.e. doesn't toggle SPTE
> +	 * bits in response to non-coherent device (un)registration.
>  	 */
> -	return shadow_memtype_mask;
> +	return !static_cpu_has(X86_FEATURE_SELFSNOOP) && shadow_memtype_mask;
>  }
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 17a8e4fdf9c4..5dc4c24ae203 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7605,11 +7605,13 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  
>  	/*
>  	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> -	 * device attached.  Letting the guest control memory types on Intel
> -	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> -	 * the guest to behave only as a last resort.
> +	 * device attached and the CPU doesn't support self-snoop.  Letting the
> +	 * guest control memory types on Intel CPUs without self-snoop may
> +	 * result in unexpected behavior, and so KVM's (historical) ABI is to
> +	 * trust the guest to behave only as a last resort.
>  	 */
> -	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +	if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
> +	    !kvm_arch_has_noncoherent_dma(vcpu->kvm))
>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

For the case of !static_cpu_has(X86_FEATURE_SELFSNOOP) &&
kvm_arch_has_noncoherent_dma(vcpu->kvm), I think we at least should warn
about unsafe before honoring guest memory type.
Though it's a KVM's historical ABI, it's not safe in the security perspective
because page aliasing without proper cache flush handling on CPUs without
self-snoop may open a door for guest to read uninitialized host data.
e.g. when there's a noncoherent DMA device attached, and if there's a memory
region that is not pinned in vfio/iommufd side, (e.g. memory region in vfio's
skipped section), then though the guest memory from this memory region is not
accessible to noncoherent DMAs, vCPUs can still access this part of guest memory.
Then if vCPUs use WC as guest type, it may bypass host's initialization data in
cache and read stale data in host, causing information leak.

My preference is still to force WB
(i.e. (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT) in case of
!static_cpu_has(X86_FEATURE_SELFSNOOP) && kvm_arch_has_noncoherent_dma(vcpu->kvm).
Firstly, it's because there're few CPUs with features VMX without self-snoop;
Secondly, security takes priority over functionality :)

>  
>  	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
> -- 
> 2.44.0.278.ge034bb2e1d-goog
> 

