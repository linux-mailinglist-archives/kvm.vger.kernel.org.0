Return-Path: <kvm+bounces-9479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C7EE860A4E
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 06:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06DFB1F21CEE
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 05:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C138125AD;
	Fri, 23 Feb 2024 05:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLrpKnh+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18DF11197;
	Fri, 23 Feb 2024 05:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708666728; cv=fail; b=ukKw5qajjS7BWY5ALg0gYCCyn8xGbzZb4s/LsjqoA6pfD4mmuykeIEEPuFVj1LxYcoZNvXs0sIBIrxLCUpQHpv1HacNsxMtlx9vey2LFd1+WEM+rLJaRiNYvx6RXIWmmvAzlxTQULIuiBRyCGX4HAT4kpXy+0udy0M3MkKy7qV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708666728; c=relaxed/simple;
	bh=dNC1LHOGsZ/bd1H3vSa0vAoBTzx523m576CJ8Qk3K7w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V34tQN95OKlbY/BISAsYxijTGRJnH0S8p6xxUvnNT3GRBPa5VUjw4eR4gInSR7mtwYbiWQl8cML/GMm0LZJmNn/htBjqN6bwwlybWDN2icoQOECpO0o0QXCPomGflpzxdazkkqyGM1AO9wphPrbpXntVevTaTDOoEbZMBiup5YQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YLrpKnh+; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708666719; x=1740202719;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dNC1LHOGsZ/bd1H3vSa0vAoBTzx523m576CJ8Qk3K7w=;
  b=YLrpKnh+KsOKYJitEpInyj97RtzUcIgL1ktIbpdNhr7AMyGF8DuKNCiS
   QadsQd5Hlr/031B3aEknxKI4ViGdiO509LISP9AqRguWCwspre3zdWP/T
   sdNa0pPvJ4o/qV5nuBRreHOPYaLAQYDTysDVZ1V0ZRvPBEX7f9TF/Yfp/
   a/GMizkdnnFkt8x53yEkF5Zg3f8gn01Fdc+hpHv3sGNIdNnYAxUXvLmCP
   Q7E+WqM/i1BQ1PezEKHLdSiiGpZOMoT6EauJ2xsZPl9aYMItihxQcBqZS
   97GM998vfGHqh8yQsbOzV2U5w/b0fg3vNKhSQIgnf37lCaJaPvAmEbOgJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="20503629"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="20503629"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 21:38:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="6174247"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Feb 2024 21:38:37 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 22 Feb 2024 21:38:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 22 Feb 2024 21:38:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 22 Feb 2024 21:38:35 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 22 Feb 2024 21:38:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD5c2XskA0qeYshG/MvMt8vLKLQIacVgorD1A4gag04R1Wy7jhVaAVj5QrobDsG+vSjVM3uXbzXcObbcHvmEwcA/BRWehZvaBnK6I73DIncuX4T7+OJ3N43IhYxzLU3qRfueTJH0Z9+WLyeK5NGE/8i9CrRq3ll/4L6Kr/wIhzQvjjhDrrX0lNAS5RvjdR2g6OPVIhrfEeWkZ99CSrY6dNdBGKTR47IewRcIAc6BNoMDYSEzl3KvszgXXOL4DvXBx+1Nen3moAWPhkCZX4fcfYzNLjB5Zg0lmbP9tv/X1S7T1NZ+x6ZMjmBj4Uy4peh534quAw9nzfEbP2gL0ihymQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3rhPOCVZNuoSjfZ8huok1HdVkdcQ5xmuFpQ79tZSMg=;
 b=STb0u75tG40byIfjf5Y0n3je9hYHL/6v5W+WNsbLq7TVM8OSDqtQuGGUrNofTOUPC/8zgT1mbzS73IeqCL4nDv0jfI0uaf7e7mxl8YJn9qrKrPs625LXt9gWEBiXiwANxCNKVWcCu3f2Fgf6lSeFyC8sOPxS1dLHwDH5Y6R4XM7f+06Mdzwx45Eq4OqQzoINbpN/lEOH+30ayRCDRTURLEbMDQTPVLSKZGgjFjfXUB38lQUabQypy+h1gXJRhcCyIYbtmOFnKvyI6x/pH58CY/8x7E05Oi07m+GkGfhk2YVLZKgPBBbd3WpfGspanS3+D+9vqeEgcW8+YxHoWxQm7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB7697.namprd11.prod.outlook.com (2603:10b6:806:33a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Fri, 23 Feb
 2024 05:38:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7316.018; Fri, 23 Feb 2024
 05:38:32 +0000
Date: Fri, 23 Feb 2024 13:08:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Friedrich Weber <f.weber@proxmox.com>, "Kai
 Huang" <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun
	<yilun.xu@linux.intel.com>
Subject: Re: [PATCH v5] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <ZdgoYcteDOxazzWG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240222012640.2820927-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240222012640.2820927-1-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0030.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::17)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: 44ae89b0-25e0-4b61-46f0-08dc3431ac33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zUQeSDvQ6xvLP1gSjIv7Qm/rdkkSUwHwJrptYHQ80CPIM93jJv44L4EIjwNO4aX97v6VGbRehlkC/VypXcstcOs04iDxtmlEQ14EB1XtKrVwOIixyr/Q0VwykuugkF6AjyJWpxNrE+h/2RNv9LK4I3khzT4ieVAs5dyRc87HReeD68xcwVWHISqrhmyyO7YheuM/m1DePoiUkNbtQdk+2YJPF4Upjvur3OgFrIZAT7fDe4xcI70slbIXaFrp/SHR9vlrWektDRacEwzMKbhr1hX3FC7gPrwI8mywVFXIik9yPhGRsUeaH82a3LwGbheQf8hmlPpOTK0ohQERCe7rhT7azjy0EoAhsEMGTceYqFOVFNUMdc2oMYQynjDnknc2G3YaUceH2pu+aRzi0B5tSLRxLFeD/XxjePfRiH8JHAAf4lTps6D+rH0gnGRnzsZhWch/SmdW+x8nktUlbuwxfnJ6La/kZSYwWUQtxHqCwlMCZtSwiLCaCyZy46wa9PV9dBgkywEqIRRWugzm2pd0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pPK4Q5ZDGbF9m8h9l1OKmCww/LDcQ6HTAK1Bd+RfFYKWIf3Z1TRzHG9DaiZM?=
 =?us-ascii?Q?//9/5WllO3OSKNWpGxxD2VKffqve5VMHLRfJSnCQKKHQlsY5gN5OPJaBgTbv?=
 =?us-ascii?Q?I9T3QMqfIJoQ92TYTElfmKdAT69X9iri/TaGNxvCs5IO06foIU2rgz9vPBkP?=
 =?us-ascii?Q?r++vQ4G2ATn7YlWoLuvRZPJa8JwLKHhbbJVWPaJm5HoCJE8WjgcujZaGaFCz?=
 =?us-ascii?Q?jr50IhRA/u5nZtLN2iKOarZIzjl+Vhjmm8y9Xw9q6A43u4DB9TotQwVcUE8X?=
 =?us-ascii?Q?yGQiBDytoFnpdU7qMYpK7sUZ4V8Hy2L/hoU2LZmwJMM8sV5vagYh5PuipWTP?=
 =?us-ascii?Q?E+pZP4G/Q1HI0wP3immiDaG2BZ028A14Xc+Xwu5hCNC8N8A0WOIhesKyIjOt?=
 =?us-ascii?Q?9E7QTxoHDQVOdHa1QbEiLBB2L8n6pjltaHMKq5c58loG7t/mZZMzNlzqi65u?=
 =?us-ascii?Q?4QC4Wh3aVaKKgAUyMQhU1mDcuupOxQ/6OAQiT5swsbZugLfqbU2a66TOhbft?=
 =?us-ascii?Q?eQzj+wvLD7F6LkuLZKOJGwgc9Nie09QrS0ibUePwWxCCH7GS5CuKu85q2+vP?=
 =?us-ascii?Q?/YkBJRZuY3trzkymJvuxZ7j3hZVQXMkvGKRrQiIUCdDb4dHk5IkRWey7XcIL?=
 =?us-ascii?Q?+s7xzDtT3E+DkSIIXJz/nu+HweibAZzJZqQS0NUzbTXGP5HB3WurWnWQtyef?=
 =?us-ascii?Q?3opzzGK1XZ5rvunwf/hpfidAHIZgPgNKYGhWEV0/ngraYNPibOoX9e6G7zus?=
 =?us-ascii?Q?yGg/6k3FSnxPMsW5bs3W1OTfMt15jB/kz9vWeRMF9iU7CQybhelb8potf+Zw?=
 =?us-ascii?Q?huy+cnxAJKZCaGeiE8xDXkbWNilMzilRAgSD2zkfkmcGEScUEpmwCFVcyXbQ?=
 =?us-ascii?Q?HFTYUdohiIBdgSPCO1/Qt0JYOEXucTZ18EHL8f+TgBHfjehReluqtDV3tFV1?=
 =?us-ascii?Q?BXoffHUFoe00VO/9zwjZzRtfXwsZ0RauGwKQw3TtPgSDB+kiuKeORixQLGB3?=
 =?us-ascii?Q?Cwtt4fE+bS1zZGW1xdAbmXcFuG4FKeyXH0QLp0/kZLZRCzcuWgLi4Wi8/ulm?=
 =?us-ascii?Q?zVcI0qfDkKoNcERlCHXaD80xpi0gpjZ7+ofr/EiHyUi5RRFRRsIst7hMsyCG?=
 =?us-ascii?Q?d405plKmnNJtY8P7eNq9vWneO0BCRjSGQwZ5jNdVWJRU1M06EbQIr46CnxI2?=
 =?us-ascii?Q?2RgTajya99sjI/6UCjlV1kpjd0gNp6XkumydSo/58DqpkbcLNrUo5O5JyrCG?=
 =?us-ascii?Q?ODhGDsYviKWUqQrsXnd9cZEauX2VhttADT7elrBg2jhFezzoiSKNUV4sJ8UW?=
 =?us-ascii?Q?NncWyD5+qrDCH1z94nteeaUZRqP4WTxPMiruHrEv2in8MJSE3v3trNpwE5sA?=
 =?us-ascii?Q?NzxvAMUuF1nipX3STEq0wB6/+7k6YI+72M7ceLGlbI2ZUJZmPEc6GIZz6Y7V?=
 =?us-ascii?Q?0pMlHqkTRp1ogOEypRq1fcGUIQJSMrsHgQHhAwIZfhwxYkSUi478WM/CSmcu?=
 =?us-ascii?Q?MDCXc415HVXioLx22pWhy6aesfYuAOg9xhcKUjWIyiznCNzQgOvu+pu+IYgu?=
 =?us-ascii?Q?g1JjhQ7J0mdkSPld9eYirOCiS/kS4UjSPRf7QRXW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ae89b0-25e0-4b61-46f0-08dc3431ac33
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2024 05:38:32.7972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5SBoljeMZ9pKlb8eEkNyXGziQ3Ie1JPjOZkJmK1AVW4n+QUetRrnA7CgbF+0v14kt4PoIPYvszlFXFHK4KtWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7697
X-OriginatorOrg: intel.com

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Wed, Feb 21, 2024 at 05:26:40PM -0800, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock, and without even faulting
> the page into the primary MMU, if the resolved gfn is covered by an active
> invalidation.  Contending for mmu_lock is especially problematic on
> preemptible kernels as the mmu_notifier invalidation task will yield
> mmu_lock (see rwlock_needbreak()), delay the in-progress invalidation, and
> ultimately increase the latency of resolving the page fault.  And in the
> worst case scenario, yielding will be accompanied by a remote TLB flush,
> e.g. if the invalidation covers a large range of memory and vCPUs are
> accessing addresses that were already zapped.
> 
> Faulting the page into the primary MMU is similarly problematic, as doing
> so may acquire locks that need to be taken for the invalidation to
> complete (the primary MMU has finer grained locks than KVM's MMU), and/or
> may cause unnecessary churn (getting/putting pages, marking them accessed,
> etc).
> 
> Alternatively, the yielding issue could be mitigated by teaching KVM's MMU
> iterators to perform more work before yielding, but that wouldn't solve
> the lock contention and would negatively affect scenarios where a vCPU is
> trying to fault in an address that is NOT covered by the in-progress
> invalidation.
> 
> Add a dedicated lockess version of the range-based retry check to avoid
> false positives on the sanity check on start+end WARN, and so that it's
> super obvious that checking for a racing invalidation without holding
> mmu_lock is unsafe (though obviously useful).
> 
> Wrap mmu_invalidate_in_progress in READ_ONCE() to ensure that pre-checking
> invalidation in a loop won't put KVM into an infinite loop, e.g. due to
> caching the in-progress flag and never seeing it go to '0'.
> 
> Force a load of mmu_invalidate_seq as well, even though it isn't strictly
> necessary to avoid an infinite loop, as doing so improves the probability
> that KVM will detect an invalidation that already completed before
> acquiring mmu_lock and bailing anyways.
> 
> Do the pre-check even for non-preemptible kernels, as waiting to detect
> the invalidation until mmu_lock is held guarantees the vCPU will observe
> the worst case latency in terms of handling the fault, and can generate
> even more mmu_lock contention.  E.g. the vCPU will acquire mmu_lock,
> detect retry, drop mmu_lock, re-enter the guest, retake the fault, and
> eventually re-acquire mmu_lock.  This behavior is also why there are no
> new starvation issues due to losing the fairness guarantees provided by
> rwlocks: if the vCPU needs to retry, it _must_ drop mmu_lock, i.e. waiting
> on mmu_lock doesn't guarantee forward progress in the face of _another_
> mmu_notifier invalidation event.
> 
> Note, adding READ_ONCE() isn't entirely free, e.g. on x86, the READ_ONCE()
> may generate a load into a register instead of doing a direct comparison
> (MOV+TEST+Jcc instead of CMP+Jcc), but practically speaking the added cost
> is a few bytes of code and maaaaybe a cycle or three.
> 
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Closes: https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
> Reported-by: Friedrich Weber <f.weber@proxmox.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Yuan Yao <yuan.yao@linux.intel.com>
> Cc: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v5:
>  - Fix the inverted slot check. [Xu] 
>  - Drop all the other patches (will post separately).
> 
>  arch/x86/kvm/mmu/mmu.c   | 42 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/kvm_host.h | 26 +++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c193b096b45..274acc53f0e9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4405,6 +4405,31 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>  	smp_rmb();
>  
> +	/*
> +	 * Check for a relevant mmu_notifier invalidation event before getting
> +	 * the pfn from the primary MMU, and before acquiring mmu_lock.
> +	 *
> +	 * For mmu_lock, if there is an in-progress invalidation and the kernel
> +	 * allows preemption, the invalidation task may drop mmu_lock and yield
> +	 * in response to mmu_lock being contended, which is *very* counter-
> +	 * productive as this vCPU can't actually make forward progress until
> +	 * the invalidation completes.
> +	 *
> +	 * Retrying now can also avoid unnessary lock contention in the primary
> +	 * MMU, as the primary MMU doesn't necessarily hold a single lock for
> +	 * the duration of the invalidation, i.e. faulting in a conflicting pfn
> +	 * can cause the invalidation to take longer by holding locks that are
> +	 * needed to complete the invalidation.
> +	 *
> +	 * Do the pre-check even for non-preemtible kernels, i.e. even if KVM
> +	 * will never yield mmu_lock in response to contention, as this vCPU is
> +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> +	 * to detect retry guarantees the worst case latency for the vCPU.
> +	 */
> +	if (fault->slot &&
> +	    mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
> +		return RET_PF_RETRY;
> +
>  	ret = __kvm_faultin_pfn(vcpu, fault);
>  	if (ret != RET_PF_CONTINUE)
>  		return ret;
> @@ -4415,6 +4440,18 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (unlikely(!fault->slot))
>  		return kvm_handle_noslot_fault(vcpu, fault, access);
>  
> +	/*
> +	 * Check again for a relevant mmu_notifier invalidation event purely to
> +	 * avoid contending mmu_lock.  Most invalidations will be detected by
> +	 * the previous check, but checking is extremely cheap relative to the
> +	 * overall cost of failing to detect the invalidation until after
> +	 * mmu_lock is acquired.
> +	 */
> +	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
> +		kvm_release_pfn_clean(fault->pfn);
> +		return RET_PF_RETRY;
> +	}
> +
>  	return RET_PF_CONTINUE;
>  }
>  
> @@ -4442,6 +4479,11 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
>  		return true;
>  
> +	/*
> +	 * Check for a relevant mmu_notifier invalidation event one last time
> +	 * now that mmu_lock is held, as the "unsafe" checks performed without
> +	 * holding mmu_lock can get false negatives.
> +	 */
>  	return fault->slot &&
>  	       mmu_invalidate_retry_gfn(vcpu->kvm, fault->mmu_seq, fault->gfn);
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 18e28610749e..97afe4519772 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2062,6 +2062,32 @@ static inline int mmu_invalidate_retry_gfn(struct kvm *kvm,
>  		return 1;
>  	return 0;
>  }
> +
> +/*
> + * This lockless version of the range-based retry check *must* be paired with a
> + * call to the locked version after acquiring mmu_lock, i.e. this is safe to
> + * use only as a pre-check to avoid contending mmu_lock.  This version *will*
> + * get false negatives and false positives.
> + */
> +static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
> +						   unsigned long mmu_seq,
> +						   gfn_t gfn)
> +{
> +	/*
> +	 * Use READ_ONCE() to ensure the in-progress flag and sequence counter
> +	 * are always read from memory, e.g. so that checking for retry in a
> +	 * loop won't result in an infinite retry loop.  Don't force loads for
> +	 * start+end, as the key to avoiding infinite retry loops is observing
> +	 * the 1=>0 transition of in-progress, i.e. getting false negatives
> +	 * due to stale start+end values is acceptable.
> +	 */
> +	if (unlikely(READ_ONCE(kvm->mmu_invalidate_in_progress)) &&
> +	    gfn >= kvm->mmu_invalidate_range_start &&
> +	    gfn < kvm->mmu_invalidate_range_end)
> +		return true;
> +
> +	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
> +}
>  #endif
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> 
> base-commit: 21dbc438dde69ff630b3264c54b94923ee9fcdcf
> -- 
> 2.44.0.rc0.258.g7320e95886-goog
> 

