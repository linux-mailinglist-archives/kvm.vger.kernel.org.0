Return-Path: <kvm+bounces-6041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5228A82A620
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 03:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CA351C2310B
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 02:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3713EEBC;
	Thu, 11 Jan 2024 02:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VbPSGGUp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF8C19C;
	Thu, 11 Jan 2024 02:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704940859; x=1736476859;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BWmEPGKhWLdMVb7L1dk46+ZmfvqWXHkU7pqK1sY/r7A=;
  b=VbPSGGUpMBc+FZyFZpGIJACgkj5qhyPDV6fpfhrFKV58TOhhXAdMPOdk
   R+SZHUIXgsC1nq8Fqwug+3jdXplWTkeuvlC41mLO5vFkF7Ju05odPlnSK
   nKhC17mwRXmuT6sS3SzPN3XBBgIfvcO4xykFY3f6cD3+PlPLCzdElA2Do
   30ZJb01D17ME1giQR6hSOfF/+Rqlc06pyZMftGXxIyX9QkA12wrN718V9
   e1lrkifbY5u5L2oW9aTMP7ihvvyqMN3Aeyq9pc02wluUU+VHhi2z23GZM
   WZcvqXvfsy2ur8KQgLsf6SsESvJiY6Zn5OANwfxLgTnQcVpF5vfWTD1jz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="395867223"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="395867223"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 18:40:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10949"; a="955582697"
X-IronPort-AV: E=Sophos;i="6.04,185,1695711600"; 
   d="scan'208";a="955582697"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jan 2024 18:40:57 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Jan 2024 18:40:56 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 10 Jan 2024 18:40:56 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 10 Jan 2024 18:40:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDRZm+SgBSIAUk6cLJP33Z1drHLzZPBzv2R+PiT1Q/oOTcHUhKAIv5TlS6BSGqz876iR7352LekarGMxPjBx18RjLuIo3cXYH1hoM44cT3JKUHXMKkz9Ev9edwIOXBYqmd+Tv/Mx31YtUV6Ch+DnkYvOa3iEVpQWLSb13vb1hTlICH5LUMmot8KNQWhv5ib61QBhXN49sVR4o4SuVWQMf0U7nyvWtJdnjld9v4zxaB1irLzCZoVc0BN6iFvLU7mwmhOBO9xAaJTmzyd2bNcItc2FCcW4MLoGOpq0i19qKXpY36jj+NxT7p3EHGKUsMC1fKIGtFuFjipl87TtrdoKlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1M4m6XS4Pl842dF/ip0IvPJf111DQZ0b9FWpxoM4u0=;
 b=B7l7OBi4TncNCZ3SJ3uLbfjadLqFViHHVLtUL8qawenmMnLxIW9T+Db0lt9hIXXnZmv4uQanmmcxsj1TWhGg6bBmrzuhwQfHZX2f9VJd/jdR5F9XtLCg5srptFoG6m7Nfd7Z5vxlfzEioHIcnnradBDuzpSRQ4411EkbYqr6/EH2qCQ0SJdX1hQ7Y0cP8vMcq0Bw0zU/XT/HfPxb7n3vv7okXb/6ErKOgNlKa9FBE/isx/K+Yh7UUGvaGv4V9ZGmpDIa4IgILf1oibU7rjSohUS4R83cTyJNDmJvE3A2i9/XKkyRXsdTmaE3Q1nSzZ3mjjrti2J0n0kFkIzM6/As8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7113.namprd11.prod.outlook.com (2603:10b6:806:298::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Thu, 11 Jan
 2024 02:40:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7159.026; Thu, 11 Jan 2024
 02:40:49 +0000
Date: Thu, 11 Jan 2024 10:11:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <ZZ9OUxnkX2Uwn3x2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240110012045.505046-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240110012045.505046-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0120.apcprd03.prod.outlook.com
 (2603:1096:4:91::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7113:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c3eaee7-927c-4d3a-e6d7-08dc124eb887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aI9w/Lk/tK3hWz+6NGRskOxw6S6NtdWwbFv7HSNaXwgHh2EU2A9lJ7Jy/oTDMXQTvj5MrOSribr0Oa6ikdR9EBN6mO6vPfyQxieugVehC9G+dNpgvQBSCsMwewR9P471Ahf11G7uR3zA0um2HU6uW/GkGBec0BG5tHv84leDyk3iYsnzk5W2GulqJZql1sMYg/Q5Wkc7zJ5PkiEFeurVRXdbIbtGxw+HOYKb3OzxKvfW/ittUdqB+CxBjcIJGtLqtVwWFd9jdPbOSCRaLY6wSo7Z/SqwOMequ34Cu9XTmiMb7/SG15D1AhLtiDmg/7oHHbHdmtAtHXcJ4URcqkTLlf5lBlGYE/pK3pexrRfc80Dyr24X0yOLCPyfm+mvECyuQT4sfj/2VOnl2uqLj+KstOywTSp3t6WMtH+Zwg005f/qjkhIUekGJDae9n9aUxho5hI8Z/6BEtBYx4+2jGgvLuPkXiQwJ2q3GQHKXuaM5GqXlq6pnEZzNR+HNMGrDmr7EqJAaU7oEJrHRVi52MWrQPsdQFSXh+Z8pnpgfRC5d2Z8jH/Co/sQRaBi/rOjI0FOlZCRjkUq3ohZSWGRxnLMJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39860400002)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(86362001)(82960400001)(8676002)(6916009)(4326008)(38100700002)(83380400001)(26005)(107886003)(966005)(6512007)(66556008)(6506007)(6666004)(6486002)(66946007)(66476007)(54906003)(316002)(478600001)(3450700001)(41300700001)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FqpTdgtIoy+Zr67oqs5MQb74Q/MCqHOObFkm9wyT0S9acCCpTkkipiYPLmpI?=
 =?us-ascii?Q?2mLa8ewAawj05pBcsGuICWkB6um/Q++Tq3gSwqMxf23htLqS+5B/MvC0ebXN?=
 =?us-ascii?Q?Hrj+ba43S84bveBdHfYb5rUK2Y7DKTKIRLH82FF57t8PlS7a6vzlf38/EzOo?=
 =?us-ascii?Q?GuMYFsrV5QMpB6+VLIjC/9F73nC2pOgYmpJ4cVuqV0kq/MFQCrke5x0a+RGt?=
 =?us-ascii?Q?AITfZm+RLwEQ6fpNPOkEukDXtuE+ZgXZl+pif+KL54zLFWWTWVsggfhOFwHt?=
 =?us-ascii?Q?OXTIyySofJ5nPTdk9hLB8QGePgHRo2dvVkj40EVik8verg8U9T4bG0XMhi66?=
 =?us-ascii?Q?0MDeYkKAIIlvj81zmZn5x/fKqZQEQG/W7XfMomvbz8eKgoE17YzrBVVZ2IHT?=
 =?us-ascii?Q?7i6uIT/H5zzbmcAuJb9VX2dGSs0JDto3GtTvGxp45r8gXudtseJx0hlaQZmn?=
 =?us-ascii?Q?AreKDpPCF/fDHpg8Sc0ZTJdMz2RT6IjM/MyUAoPGrxW/viXxySsU+it7f1tV?=
 =?us-ascii?Q?1WO+esBEGtwrepIKc3a+Xx6PD3kBxmD7WbbI2CGSPdjYgMmVAm8cA0miRsRS?=
 =?us-ascii?Q?V6U0YS6CfOmquv36W2gli2YE81sigXJUu/0fIP3Fz5q/nhgnVhGc6mwCr+6O?=
 =?us-ascii?Q?A8qXOV9pdC1UOfj9wXOjYpHxWQp4XjBWWvTSvhnaDkvJXRWZgeDiwLAIC01C?=
 =?us-ascii?Q?CP0ndCDoDOPQHMUWVDp0zvjR3TkplV/FhJAeuSnZ6iHmWkoB/84m+y1ERtJK?=
 =?us-ascii?Q?bXUhP8tgQGZgUeCDiQfQ7MKijWuIL50pkLgpFFOaeplPbN6QaaEMt8Mrld5m?=
 =?us-ascii?Q?wHapyTsQD8IEfegzTOJ3j5AIkgjav3GSyj/VCF4FNy1/bVrou6QBslj0rYRd?=
 =?us-ascii?Q?aKT3mguboYA/F7JFGuSEfv2SxBULboPm1tKPTmDjgjokgbBwzsN9Sq6Y2fWO?=
 =?us-ascii?Q?mWrMWZbjRoo9pSAivqUndexYZQt45RRByBuMy54CiSAm0r4xxM8SZJGvjyoC?=
 =?us-ascii?Q?p/vz9+FRR4kMLB7WecCQ7L/wg6Eao59/mlgyq7gi1P/bRLIrQuDL83r/I5eG?=
 =?us-ascii?Q?eD6CY6tricFHyhr4EjrEhtL0oKReKw/lIJnPbp4BCjSip2wKnFqmAW1IfsTH?=
 =?us-ascii?Q?oiOyrjFeI2J1mry4Cb9FLrNbnENmDhoIlzV0bs1ipo2UoHPJVpXDIN0EX64m?=
 =?us-ascii?Q?y9Dv8kvdvMP+TDV2k/Z1zTwurmo3RNPlnYmr+SNZO4oTlehllFewI0nBEKG1?=
 =?us-ascii?Q?X2yOjlhqnd7mW0I104bPJdWH9Ix87kjJnUDQ5x3yPbbrTBcXriPyF0hHvC/n?=
 =?us-ascii?Q?Zk7jvPn7nKfFwn1Dta23T+Z/0dKYvwFKTimktH/+gB0YsDH2KaofsWcaTV0w?=
 =?us-ascii?Q?A5SQijMiEmjEOGhkoajq/Wy0LS0qZl9FBnWBUpLdLcCJLwUibLHfVhLLcYyt?=
 =?us-ascii?Q?h6x3UNptAI1rFZDx0I2XF0tG9CS4NmIKp2j9ogs+sg7e5UJlJU7zYma2ruwu?=
 =?us-ascii?Q?F+nWrxoupLCa2pvGdG6MzjK+K9BDCB2Tv2aN9FcseZ2wLV9Nwx1I10pQL5/B?=
 =?us-ascii?Q?ChUMXaB++ajhZD0P2IZVpJG8tB5QQj/Cs7sjR35P?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3eaee7-927c-4d3a-e6d7-08dc124eb887
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 02:40:49.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HmwIdib94IMjJbt4i0iPLzW/f1MaE+zd6f7d67y8kXOkBgynetc7vtWPnmw80vLhhO+QshEIQYoWz1z8jwEmXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7113
X-OriginatorOrg: intel.com

Tested on my environemnt with below improvements observed:
For a VM with 8 vcpus + 16G memory + OVMF

Avg cycles of kvm_zap_gfn_range() is reduced from 1100k to 800k;
Avg cycles of kvm_unmap_gfn_range() is reduced rom 470 to 180.

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Tue, Jan 09, 2024 at 05:20:45PM -0800, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock if the resolved gfn is covered
> by an active invalidation.  Contending for mmu_lock is especially
> problematic on preemptible kernels as the mmu_notifier invalidation task
> will yield mmu_lock (see rwlock_needbreak()), delay the in-progress
> invalidation, and ultimately increase the latency of resolving the page
> fault.  And in the worst case scenario, yielding will be accompanied by a
> remote TLB flush, e.g. if the invalidation covers a large range of memory
> and vCPUs are accessing addresses that were already zapped.
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
> Acked-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Note, this version adds a dedicated helper, mmu_invalidate_retry_gfn_unsafe(),
> instead of making mmu_invalidate_retry_gfn() play nice with being called without
> mmu_lock held.  I was hesitant to drop the lockdep assertion before, and the
> recently introduced sanity check on the gfn start/end values pushed this past
> the threshold of being worth the duplicate code (preserving the start/end sanity
> check in lock-free code would comically difficult, and would add almost no value
> since it would have to be quite conservative to avoid false positives).
> 
> Kai, I kept your Ack even though the code is obviously a little different.
> Holler if you want me to drop it.
> 
> v2:
>  - Introduce a dedicated helper and collapse to a single patch (because
>    adding an unused helper would be quite silly).
>  - Add a comment to explain the "unsafe" check in kvm_faultin_pfn(). [Kai]
>  - Add Kai's Ack.
> 
> v1: https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com
> 
>  arch/x86/kvm/mmu/mmu.c   | 16 ++++++++++++++++
>  include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c844e428684..92f51540c4a7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4415,6 +4415,22 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (unlikely(!fault->slot))
>  		return kvm_handle_noslot_fault(vcpu, fault, access);
>  
> +	/*
> +	 * Pre-check for a relevant mmu_notifier invalidation event prior to
> +	 * acquiring mmu_lock.  If there is an in-progress invalidation and the
> +	 * kernel allows preemption, the invalidation task may drop mmu_lock
> +	 * and yield in response to mmu_lock being contended, which is *very*
> +	 * counter-productive as this vCPU can't actually make forward progress
> +	 * until the invalidation completes.  This "unsafe" check can get false
> +	 * negatives, i.e. KVM needs to re-check after acquiring mmu_lock.  Do
> +	 * the pre-check even for non-preemtible kernels, i.e. even if KVM will
> +	 * never yield mmu_lock in response to contention, as this vCPU ob
> +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> +	 * to detect retry guarantees the worst case latency for the vCPU.
> +	 */
> +	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
> +		return RET_PF_RETRY;
> +
>  	return RET_PF_CONTINUE;
>  }
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..179df96b20f8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2031,6 +2031,32 @@ static inline int mmu_invalidate_retry_gfn(struct kvm *kvm,
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
> base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

