Return-Path: <kvm+bounces-7955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5981F849212
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 01:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2B0C1F21E99
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 00:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1348F40;
	Mon,  5 Feb 2024 00:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N14xMcxY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D9779E4;
	Mon,  5 Feb 2024 00:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707093851; cv=fail; b=HIJMutyGH4fGOs6fyeLxg0Uu2pVwyMxnW8dg4J7nXYN8Lgoi8LisOeuQF8UfE0h0dHSOfE3ar8ycIfvU5r5XhKuEvuqsS6Weflx2tqNAegbCpe/EN98EgNRK83EKRgFH6wfE0Epuf5KvGL4EE0G2GkrCpo9LaWYnSte5lCUjIiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707093851; c=relaxed/simple;
	bh=Joqy7ddnDFKwaTJ7V/Y3h+lA5hXISpbwbVLdwq9PPuY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MdUt9dF40AAXPK4BnWQ6PHhpCT6n1Uq1uldp+sBgweN5d6zGWqWpJO7BJDLtxkOwUEBFnXRGloNMdlCkh3ixdv7SE65REpkRA4JPccs7NWGhspFJuHRdHGc7jNr/xeNQGcc5DnSS8CM8HHjcUMUHeIXPBHsVqiiP0wcp2vVssbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N14xMcxY; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707093849; x=1738629849;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Joqy7ddnDFKwaTJ7V/Y3h+lA5hXISpbwbVLdwq9PPuY=;
  b=N14xMcxYJ9AOpGPax2P8APnm+g2Nxar5D0Ie6IWVQx37xmF3qvDBAL67
   vmZ8c4QKGgSD7owepTIdBhDn2/nFtIXeKSP0npj42hYVxOKpdEEJXODOL
   8KSvrEkO+W0BdKzLL2jGzq8KRxqRhFDH+RXiAEnqWAQNa2Imuzboe4Woy
   fQKf1QejfDJFcfkBMAWGF4iFbAqN9OhHR52rcktkgAQYtF4dFUEzawlUO
   Io2pGP3P5Nw7PPxnq8ybBhf0m/qPPkEsmadz+8TQ10KzXkSAg7LVSBaVZ
   8c8GlkGqFb7ARmRKT2jFjo9CfZL6jGBFk4zh55IN6ZtskSlkF+x7ME6Z6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="11165893"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="11165893"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 16:44:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="5199087"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Feb 2024 16:44:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 4 Feb 2024 16:44:06 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 4 Feb 2024 16:44:06 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 4 Feb 2024 16:44:06 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 4 Feb 2024 16:44:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TO2ikeYA6jllvliQL5PDUPYdjqlvApx4tCKVqeMkFXYYJzeqw526kzH66RqTGVnfz7FxvzNNM4LenaN4YEtQ1Nt8IaW5NVFFuV33v1Nga4awaY9VqDOQNMMcZsd3Gh+ZiwCZ/Jc7/C/7tF3YWq9Lhko+a57vDfgI5/vN3IyIjT169slfMr74hxWxAHGTHvIRRqJEnikdCSmCRhclYHWrGoNpAg2KRGpulJVwu7eFATloDYr1InbDvIC4yWY53B2DjY6OX3RkkpLxQJKnoWf+cqRfKkHAN02SC8isumQ6xgDnOVAHV8fm/xrayS3aqIQrGhQ2sI9cXkiLFreICM2yeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ud4wiLiU8UeeCKq14N3wv2ZTOHMVsT4ZMBY2chNA1S8=;
 b=ZsKMRAlC/shbhrr4hT45q3Ux/z7R+7DBwc4POCRECRLpO97LQ2uytZ5FLdYPGoiqfokLOEAsjybjasRCfkXzuVjZTeLpmKdY0RuZWWx2JOdOpGR0mX21EDzyZ5cUiASthfooL+EyU5rJ0KGcTjFlqaDigY/0h0bixR259NYjt6zEa0T5TNaJ/UfPcS+cb81nwpc9HrK8GmgjAg6YZuLGOsisg+ikhpmHNtuV4AW0IAa6xkrLNFMfg2XrLvSyo+xg8sAl5vCCWJFRImUaS9haPgMxiRcevzSjeLCa5ZUpbP+ngAdDoHpPJQiM+mIOG5COVWqXHBzjfxO62ToAaWz5yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6261.namprd11.prod.outlook.com (2603:10b6:8:a8::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.34; Mon, 5 Feb 2024 00:44:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e%6]) with mapi id 15.20.7249.032; Mon, 5 Feb 2024
 00:44:04 +0000
Date: Mon, 5 Feb 2024 08:14:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, Yuan Yao
	<yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH v3] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <ZcAoZ/uZqJHFNfLC@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240203003518.387220-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240203003518.387220-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: bd94ab21-febe-4338-70dc-08dc25e38d70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nje2+2jmoWeJlfbpTaTMV4fHgGxhKylpOGuERFAJZjt0RfaiONPdU1YIBM+vxzRbyGgTodsX3jAK1kwH4EProMge7bYvF0oXfZPr/0pisqfDGs2A617cVUISr8IifESLnAiuKae3lVwNZEz/ziwIeWdGu/6UL6LvhJ1tFwXwEx6UOpUFlt99J7IxsW2Fshu4oD+ReAp4DPwyKZXI+ST/k69Zo8kzvpxSVHXL/som7/3a2VDpoqBUI1P09UqsXGuVlybMH7d1eAedTuqVH0/R/9FfgyALJBWc458eBy3E/RT/Ex7POi8qYaMO8M+06Qzvkc4HxJ595Z1tMLPjC4FlRmsrgPCY1XofXKRDE7MF1dG4bzLBw6g8MGR5FPkmNkUQOVkLgJ++5Gym5gEnqkb1GV4BLHe7n8900zHx1uSn5QR8QLgHLsrvxaUoGPRHrDg3Cxec4+EOenq9+AuduTiLbXqqgdfYD2B4cHKNXQOQPJ0O/SYWpyDqINrl6kAtnoc+uIg/r1eC5y3cdjhjBCXrsYT+NCOSqld4Kura3l5CWEEk000SA/OntK7K8qydEdl4annYyL6VozwQem0M+NgKsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(316002)(26005)(86362001)(966005)(6486002)(5660300002)(478600001)(2906002)(3450700001)(66946007)(6916009)(54906003)(66476007)(66556008)(8936002)(8676002)(4326008)(6512007)(6506007)(6666004)(82960400001)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B0q59A9NjPE0DFdqteeRfoKWlkmiR+UPLUYWINI8+YUukYhV7kWpiZMMx+xd?=
 =?us-ascii?Q?TqYMSOB9tAE6kdv47T0rfzn0mtNfJR5CNlNXNOtzNXlrEBkW4R74AIXTR2jV?=
 =?us-ascii?Q?CrfBwi7DeQL+8sJQAcwfIlioPb15OuyGk8qlbOAFBcXQGz4EzE4CuSRLcajT?=
 =?us-ascii?Q?7d4wPPDxdchZCFP1gtP9zZatO2jUPIZTQ1vLqZXDkeknRxXNtn06D+1jpe5i?=
 =?us-ascii?Q?dtcJbquIyDtqwyZmAddWKCL/64dniXuZ50hAnS7r4Q9hWjVCScjFpLATJ7ul?=
 =?us-ascii?Q?652L4QgAs9Mr803DJu+jLQmGOkt58F0Zk1IiYfARTHFTuJjUXaVJ+QdMF5Ps?=
 =?us-ascii?Q?lUVv5vwq40JIZjQ6pAaP3oMvYSNAIV35K3Q/5whvHeHCxOsTtHpRWgwyW8x7?=
 =?us-ascii?Q?VmG7XMXqXfKt2B/EUS42m+OKuD9KWpRyDNTxenVEii1j4noY7bq7q8DuV+hq?=
 =?us-ascii?Q?RWX2A9m/uEsn1woDdF4xkeQc1dkuRodk8BfcNa2D1zBGMPuwmbNZK2gM0aXs?=
 =?us-ascii?Q?oSiZybpbm6yNCSZ5iK0zOfszFuiClwxZmsiQTkYSbGOx29aNGMmSCe+67Swy?=
 =?us-ascii?Q?DumEONyWha8DqFDoTO61o01LdNN8G8PO1z1evC6LNRYXoP6O1QQnEeYKVgAo?=
 =?us-ascii?Q?S8uUjqbUT8gUi6oZTXhmJwjK14kI5gm4v7b328FIwa3jWGwVE1e7RHUjD7KL?=
 =?us-ascii?Q?b7U2796TdeA4M2VZAlXGHawQp2IuYELWQWS0LUrMQJ8wNELDzmgTNls8WH9o?=
 =?us-ascii?Q?5OsKOi4f+Nx0anwp/YnW+dLPpcgpRcmAiiqtUvM/Zr791GFKXryDJUlIic8j?=
 =?us-ascii?Q?vTKFyPM99AWV//2rwga3pv7RvWtecgPA5FsY8PSPthmtw4dXapJDR4syzY3r?=
 =?us-ascii?Q?nhr1fO9PjhRKPlr4ejzQxUMILmWlO9gV6w4bcr4SB0cLvVVDHiOC1Fh8NZNs?=
 =?us-ascii?Q?89XPvep4kKDJnLCDGCqaMmsYwv+oGUfh6piKOBRQ9sVFpM5YhnpafV8z3h4X?=
 =?us-ascii?Q?NxSO/Vw5XOulkgfdAXtg40qsfeXMhfT294YUqDOLirCKw4ELZqpN9rk36l38?=
 =?us-ascii?Q?McG9WuDCM7cvlaRHpuR7S1RqvfYbplwFgXF3F/i5hdPMfwfkYHLMly4w1qtM?=
 =?us-ascii?Q?v0b7y3FSQDulQlfD8s4NLsnFIursX6NiyP8ipCJ6F5Jg0NnuJd+DfLl82ief?=
 =?us-ascii?Q?JmQbxVbIXM1H4sWD+Iut6SFkqCGGhb5UNgutEMFhpTgSFeJQ72wPw3NqiFEZ?=
 =?us-ascii?Q?C+BnELiD6HdYr+tz75JpoPGcWCGtbZE+5kvys8qseqtKBuoBthiH9a4jCCSS?=
 =?us-ascii?Q?pDpRLa5Z18wfxGCPx+gY36iq44IKm8hBx2FnAoDtCXq4mM+qd26qece1Gco/?=
 =?us-ascii?Q?K0LIUflF+eMSM6VJcJYrWv3W5KBDKSvUuCn00V2Mk/lZSCf78lHga9CgsxJs?=
 =?us-ascii?Q?Skd1UPYHiwWUImUtDL53kPolhhVvoygY4yBMK2bVleY5/PPSX+JHbhlgvwsM?=
 =?us-ascii?Q?LbKd1RqpFtgOhDndhlPB4jZaZs5gsQNipxSLA02ktakWH8HnYzmuHoRhc7q6?=
 =?us-ascii?Q?7gz0jtiBkNevoye6cTNYAk64TIMF6Sf2wjvD9+Mu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd94ab21-febe-4338-70dc-08dc25e38d70
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 00:44:04.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMJUqPQcOSDoKQiHer0Elmr+C6f/wru1LGzCQmjw7FXRn7iICJC+Pbd3Pu6QFj5v08BRCYUlvsB2O6Yjc9U1TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6261
X-OriginatorOrg: intel.com

On Fri, Feb 02, 2024 at 04:35:18PM -0800, Sean Christopherson wrote:
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
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Yuan Yao <yuan.yao@linux.intel.com>
> Cc: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Kai and Yan, I dropped your reviews as this changed just enough to make me
> uncomfortable carrying reviews over from the previous version.
> 
> v3:
>  - Release the pfn, i.e. put the struct page reference if one was held,
>    as the caller doesn't expect to get a reference on "failure". [Yuan]
>  - Fix a typo in the comment.
> 
> v2:
>  - Introduce a dedicated helper and collapse to a single patch (because
>    adding an unused helper would be quite silly).
>  - Add a comment to explain the "unsafe" check in kvm_faultin_pfn(). [Kai]
>  - Add Kai's Ack.
> 
> v1: https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com
> 
>  arch/x86/kvm/mmu/mmu.c   | 19 +++++++++++++++++++
>  include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c193b096b45..8ce9898914f1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4415,6 +4415,25 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
> +	 * negatives, i.e. KVM needs to re-check after acquiring mmu_lock.
> +	 *
> +	 * Do the pre-check even for non-preemtible kernels, i.e. even if KVM
> +	 * will never yield mmu_lock in response to contention, as this vCPU is
> +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> +	 * to detect retry guarantees the worst case latency for the vCPU.
> +	 */
> +	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
> +		kvm_release_pfn_clean(fault->pfn);
> +		return RET_PF_RETRY;
> +	}
> +
Could we also add this pre-check before fault in the pfn? like
@@ -4404,6 +4404,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,

        fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
        smp_rmb();
+       if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+               return RET_PF_CONTINUE;

        ret = __kvm_faultin_pfn(vcpu, fault);
        if (ret != RET_PF_CONTINUE)

Though the mmu_seq would be always equal in the check, it can avoid repeated faulting
and release pfn for vain during a long zap cycle.


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
Is a smp_rmb() before below check better, given this retry is defined in a header
for all platforms?
It should be a just compiler barrier and free on x86?

> +	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
> +}
>  #endif
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> 
> base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb
> -- 
> 2.43.0.594.gd9cf4e227d-goog
> 

