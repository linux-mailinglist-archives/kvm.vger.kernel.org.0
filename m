Return-Path: <kvm+bounces-8068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E5384ACB2
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 04:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B518286A71
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 03:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6D27319A;
	Tue,  6 Feb 2024 03:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="moH5Juf7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768544BAAA;
	Tue,  6 Feb 2024 03:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707188871; cv=fail; b=lvFw/zCmswF/IYytVs9E47M8+VCiMKFP+L0hvRhFkA9K364/NX555wXN2tr9HXSnNPlDxA6Ojkc+QAKXYRe2/MrPeWPgrY6JyyRpOyioMJrgEWzVTicqMfIse5p8xYAqja7ZgScT+cSKGhzjEMa7FnU3tjkjXK3WeYEwRol+STc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707188871; c=relaxed/simple;
	bh=iem4LUSyO3HpMAsTzsv50Xnvix8rQtjqTK8hVMAtT5c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lrRMXI9fpO4npdyQdHuWsQuRhYnWV2CHCiB/9Y860bIfe5DYjrjRd/H/SX6vWfa5+up5gFBS8u71iGQZFJ+rXgC/9NPgVbTn6sd+yKekAmRPSlphhoiZ6V1oy8Lnlt5PlPFWSLI1eKB61Q78NdM/55/GdFUZCHccIMBszCWYQy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=moH5Juf7; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707188870; x=1738724870;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=iem4LUSyO3HpMAsTzsv50Xnvix8rQtjqTK8hVMAtT5c=;
  b=moH5Juf7Z30KcTxruOIACwdWFmHiEzmu44CDcI+oEpRKwv2vU4WaMnwQ
   p/lV5K562d1Glw9qEDJM58JQRqLN8tB/Oh3KcG6rfhdDqIDa5Uia7/O+/
   elHR/Dttpq4rQZXNnulBqasJQl7QzVhQZQd+bDBYQwiEBXg7DBKFlSZuG
   sG0olm3qtGRaSB/Df0jfkQMVHvPQqMmcm4xpo03gRT6LtQgPdhZUDgWWB
   fkMUC8e5YOJW2AuzvsmATbTd0myqr/0ja4FYmOTwrcn6HalGo1bDDIyZB
   fjeOYMdlB0gsNMthNIWyHH+Up60en3RUznsku0hq/YqB9GRX6KBqHPh5r
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="4444497"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="4444497"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 19:07:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="1176907"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 19:07:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 19:07:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 19:07:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 19:07:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKqdPSlIu51Fx9xLHySzyE9RzmYesEHlN6YTMuMsGhItk7sS47xEAFORUmBh0jvq4upQMhA3oO5Tq5p6R79phQHQ65l331fmn80d3VETJGLQ7VmAs9R8Edzrkusax8dEbQTrOehbJfDqNXLLfba/Fh3OBYMPvUIveuPW7xVknOVDJ5KG1/QIaaUTZUrNiY1idm9B+RIRvR8JrKCGXyFViEsvak+QwvRdgWef0NSGARl6GS8DYKJRENLIMFnW+3E/QEMK0wcjORlWQXnxR9sQUjE/DUmi3T7xJ9tHTg1tSpfBxUTvMXxXbmYWqLaKYKlfgQPS2K5iwjkwBc6x6U70qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcevibNKMbYTrB/JOq9/QgF+e2TZdosCXuP30/zX//Y=;
 b=jBrgSbuYD6kXZQ1I4GwEHk5St9PJyyhICwnjw/z7OOGAfOqQiGSuRKL+wo4EF6JC7D5wj+FtjNmiZijqf5Pb1WuPHI4Q4XbgUy1R8Z9E1lfVbXOUwT/D20g/9kYAFEJL0f9SAJycuGgMqgdGMVgM5K6mhbIwEyWBwDWwcSrHD0RoQhwzgZYFnR6zuq2zn/z/Rg0v4csDh4r3WgAS7AMvgZ71M0kXN90mt5qe0Dppe0HOv5rP9UqPIt383UyOEFqzIG0MfA8svvc/0N0yty+MOcdoMWB66De1OUH/zs5GgtkZilL6SJATalilgmp1V8JGgrsAo90fwzgXjtZSnkrRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8095.namprd11.prod.outlook.com (2603:10b6:610:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 03:07:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e%6]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 03:07:39 +0000
Date: Tue, 6 Feb 2024 10:38:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, Yuan Yao
	<yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH v3] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <ZcGbjstPnwVpR3Jw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240203003518.387220-1-seanjc@google.com>
 <ZcAoZ/uZqJHFNfLC@yzhao56-desk.sh.intel.com>
 <ZcEolLQYSlLEVslN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZcEolLQYSlLEVslN@google.com>
X-ClientProxiedBy: SG2PR04CA0182.apcprd04.prod.outlook.com
 (2603:1096:4:14::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8095:EE_
X-MS-Office365-Filtering-Correlation-Id: 18497376-e06a-4807-ab9b-08dc26c0c733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivX1qMlPC3E6C6dYGuTJ0WMSjXcdTtmeBbmZD+9nVbp3yBprQsK4uD6ZULTTQA9WJBopTDbGjpbBbLrT/HTnOFvMiyeiw1nYXbUP/gE5ezOgWkcdBpjqbVUrnzBcWICPPHvSDXancKel+TRU+0HKoMLOvMtSm/VHHkFybNa1CEhd2ZzFB02CLIGXV7Ud1gPCpn0wOoRw9EI7v6eI1ABUYiUd117UeLQw5THDN/gekj+aXhAA9uPnc83uO5ESqRoxd8kJX4f1DzStolkFZLNHODeTed7f9l/5+pTWfxnQzXAhS3QnkXGABr2vBnqddjjepDTCMLbjGnDC/7sKKrrJZJiaqTErVMMcVbbBjTZXrmzufW0fnYPgGAKZJsQPksLGBG49yZMUuM7vhcOzRx0W447b7aWZdUEZa0L460z0UnWS8zvo/wVhJiB0OWn4rHo3vHDYQ71DlH/EQ6WzbP33pve1Q5Q5xlm3vrip5fVbEWEMgqi+01hLGZrsdlpBjMgvA/HnGxFQYenHBBn/xaD4ysRh/MfZ/QszacoF0JQ0lpPFaDZHfUgQWA2ZTdR/tZIm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(376002)(396003)(346002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(26005)(86362001)(41300700001)(5660300002)(6486002)(478600001)(2906002)(3450700001)(316002)(54906003)(6916009)(66476007)(66556008)(66946007)(4326008)(8676002)(6512007)(8936002)(6506007)(6666004)(38100700002)(82960400001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H0aWigfFC3t4X3CeztGo6JJOQCemQAOh8iaN8oKE5RGZfuy7wNp4a7FCHebI?=
 =?us-ascii?Q?yGmNfw/3qC+J75FTnBhr6FzOJbjNZjdJw7PKYWrE+DESQoBWCqKHqxsGBDPP?=
 =?us-ascii?Q?wX7mS4Qoz8b1gV3TLoa7dFfi3LEO0XXBHTFek/+b/uJeLhhuJZkfcZ6hhPB+?=
 =?us-ascii?Q?3TKYEFu1iE75MIpc3rg9GTPLcQeLZUYrykUox2pwbkjiAOy3Qn7tSHiVK7GA?=
 =?us-ascii?Q?Y1BqUALPEVhQ6MGPNREtFnG2dG523AamFuS/T5mT93503l3J23vfenk96VtK?=
 =?us-ascii?Q?k6v+LH8UCg/2ZsuR3jjtn/GPNfKmB2920uIswmU3kESdNI0jcbe29cgedDpi?=
 =?us-ascii?Q?N7i7cAx15qicDIK+gRPBwqSCK6qNTUuVZUBP0f0SXaZrUhlDycsZioXaebXL?=
 =?us-ascii?Q?AigeIUqv0gjQMBFfJbnH1POr5GGdsgcvnRyghfl7KvOtCCkqujGwkHUm32uF?=
 =?us-ascii?Q?QCfIYeTz4BswzEb7OA3od/HtK4W6mURvyFYVzKeMhffG7KZnRAGPDR8qRkP5?=
 =?us-ascii?Q?uoLKBVkCDBjE75Qj3ZYdCDNS0hIhmE2Ns7l/0qka8uT9MATK31Z5h3QgPVi1?=
 =?us-ascii?Q?KeGmflJA1+avE8d6YvqMsbgzIqR41PICkFyzqLJN4zrpwYVjxw9vQbdeikxG?=
 =?us-ascii?Q?FY2WpKZ/lc0mKFw/3bdFi/Xxc9PPRfp1lVJxCgAGqhDOCbSH37FQJI+74n8l?=
 =?us-ascii?Q?jVEuBk3N1WXnx5iT0hct1/Rb5/ynIwytKBz11TgvDphX6FZvFjObIq3uK2Gm?=
 =?us-ascii?Q?4UmFCdo7GFmiE6oYuVgNuwH4m1UndSEvqs0+5wmXerSJpNTmjSDfpu+zVoYw?=
 =?us-ascii?Q?7RW0SUhMN6393AGxwTIZC+7H6TBJjJZfN3knFYF0vD42rci+2MbtL+Ftr9Au?=
 =?us-ascii?Q?cJlwwIoijL5O90Lu4kCaGOXUv5iJh39JldtbUq12lyOf8RKnMVRD936XkdAE?=
 =?us-ascii?Q?Dso7Q5HQ6mBanFREkMSX1Zv/wlY5KJu/oi1drrHWmKTrwbZvFoWC30ZfkFdi?=
 =?us-ascii?Q?4uOhIsHVF9wxwMqKOj3Ha1y9Zq6mITMH6H6zCNPUoalI2iZW/2Q8l5vS24Np?=
 =?us-ascii?Q?QahVMS5m3Vb6TUQLi4dgZmovv4NLHul88uN16lMkGiFv1MOP/1ak4l8r2K5a?=
 =?us-ascii?Q?cO0oJwap/FgRK5vCuJURmDn+vVrLjmQAcD7Vsj+O928RhqSER/0e883gOUZ4?=
 =?us-ascii?Q?Fc21NY3bZV88QqVMXeewaLrb88pwpLOMyTg8AaVYnxuQuTAi4dDvXJTaCh8+?=
 =?us-ascii?Q?779ToH3bolJUys5fg8gESxn2I6pqKxuSiETFWmBhijue7QFGOuuAmAaU3su5?=
 =?us-ascii?Q?b82fgac5lgMo8w2MAvcN8jrAGda95nonGe84d3DCq3PKY7SdYkSzpJ16jDgM?=
 =?us-ascii?Q?AbgFJhKs8wn9djI/jHF/ylowblcZGEOIlPs0reH9nTGofd8vXQR6QNfxZQjF?=
 =?us-ascii?Q?Fks88fAAGG5boOctfLD2UDi9XA7+sU10PmRDarQhrg6uj/z0oIbcDRATlU5j?=
 =?us-ascii?Q?H0o+lFvshQCFmgFiCBMSODM8eQ2xOOmVXjHPrCKPzHGyz1DDiy1EvqG+2mkQ?=
 =?us-ascii?Q?rDV4JXzayoaJwgQvuzfT9yGk/Wt5npuyCfrbQF08?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18497376-e06a-4807-ab9b-08dc26c0c733
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 03:07:39.8332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gq96Cpi1NLoAv80CdvsXW7k5VtSUfSSgnQHtHkzMlcjrP2LEilpRIRwxkw3IJEUWXwKh5emLJvDwuJIA+g+e7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8095
X-OriginatorOrg: intel.com

On Mon, Feb 05, 2024 at 10:27:32AM -0800, Sean Christopherson wrote:
> On Mon, Feb 05, 2024, Yan Zhao wrote:
> > On Fri, Feb 02, 2024 at 04:35:18PM -0800, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 3c193b096b45..8ce9898914f1 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4415,6 +4415,25 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > >  	if (unlikely(!fault->slot))
> > >  		return kvm_handle_noslot_fault(vcpu, fault, access);
> > >  
> > > +	/*
> > > +	 * Pre-check for a relevant mmu_notifier invalidation event prior to
> > > +	 * acquiring mmu_lock.  If there is an in-progress invalidation and the
> > > +	 * kernel allows preemption, the invalidation task may drop mmu_lock
> > > +	 * and yield in response to mmu_lock being contended, which is *very*
> > > +	 * counter-productive as this vCPU can't actually make forward progress
> > > +	 * until the invalidation completes.  This "unsafe" check can get false
> > > +	 * negatives, i.e. KVM needs to re-check after acquiring mmu_lock.
> > > +	 *
> > > +	 * Do the pre-check even for non-preemtible kernels, i.e. even if KVM
> > > +	 * will never yield mmu_lock in response to contention, as this vCPU is
> > > +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> > > +	 * to detect retry guarantees the worst case latency for the vCPU.
> > > +	 */
> > > +	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
> > > +		kvm_release_pfn_clean(fault->pfn);
> > > +		return RET_PF_RETRY;
> > > +	}
> > > +
> > Could we also add this pre-check before fault in the pfn? like
> > @@ -4404,6 +4404,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > 
> >         fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> >         smp_rmb();
> > +       if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
> > +               return RET_PF_CONTINUE;
> > 
> >         ret = __kvm_faultin_pfn(vcpu, fault);
> >         if (ret != RET_PF_CONTINUE)
> > 
> > Though the mmu_seq would be always equal in the check, it can avoid repeated faulting
> > and release pfn for vain during a long zap cycle.
> 
> Just to be super claer, by "repeated faulting", you mean repeated faulting in the
> primary MMU, correct?
>
Yes. Faulting in the primary MMU.
(Please ignore my typo in return type above :))

BTW, will you also send the optmization in v1 as below?
iff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e340098d034..c7617991e290 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5725,11 +5725,13 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
        }
 
        if (r == RET_PF_INVALID) {
-               r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-                                         lower_32_bits(error_code), false,
-                                         &emulation_type);
-               if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
-                       return -EIO;
+               do {
+                       r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
+                                                 lower_32_bits(error_code),
+                                                 false, &emulation_type);
+                       if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
+                               return -EIO;
+               while (r == RET_PF_RETRY);
        }
 
        if (r < 0)

> Yeah, I agree, that makes sense.  The only question is whether to check before
> and after, or only before.  When abusing KSM, I see ~99.5% of all invalidations
> being detected before (21.5M out of just over 21.6M).
> 
> I think it makes sense to also check after getting the pfn?  The check is super
> cheap, especially when there isn't an invalidation event as the checks should all
> be quite predictable and cache hot.
I think checking at before and after is reasonable if the cost of check is not a
concern.


> > > +/*
> > > + * This lockless version of the range-based retry check *must* be paired with a
> > > + * call to the locked version after acquiring mmu_lock, i.e. this is safe to
> > > + * use only as a pre-check to avoid contending mmu_lock.  This version *will*
> > > + * get false negatives and false positives.
> > > + */
> > > +static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
> > > +						   unsigned long mmu_seq,
> > > +						   gfn_t gfn)
> > > +{
> > > +	/*
> > > +	 * Use READ_ONCE() to ensure the in-progress flag and sequence counter
> > > +	 * are always read from memory, e.g. so that checking for retry in a
> > > +	 * loop won't result in an infinite retry loop.  Don't force loads for
> > > +	 * start+end, as the key to avoiding infinite retry loops is observing
> > > +	 * the 1=>0 transition of in-progress, i.e. getting false negatives
> > > +	 * due to stale start+end values is acceptable.
> > > +	 */
> > > +	if (unlikely(READ_ONCE(kvm->mmu_invalidate_in_progress)) &&
> > > +	    gfn >= kvm->mmu_invalidate_range_start &&
> > > +	    gfn < kvm->mmu_invalidate_range_end)
> > > +		return true;
> > > +
> > Is a smp_rmb() before below check better, given this retry is defined in a header
> > for all platforms?
> 
> No, because the unsafe check very deliberately doesn't provide any ordering
> guarantees.  The READ_ONCE() is purely to ensure forward progress.  And trying to
> provide ordering for mmu_invalidate_in_progress is rather nonsensical.  The smp_rmb()
> in mmu_invalidate_retry() ensures the caller will see a different mmu_invalidate_seq
> or an elevated mmu_invalidate_in_progress.
> 
> For this code, the order in which mmu_invalidate_seq and mmu_invalidate_in_progress
> are checked truly doesn't matter as the range-based checks are will get false
> negatives when performed outside of mmu_lock.   And from a correctness perspective,
> there are zero constraints on when the checks are performed (beyond the existing
> constraints from the earlier smp_rmb() and acquiring mmu_lock).
> 
> If an arch wants ordering guarantees, it can simply use mmu_invalidate_retry()
> without a gfn, which has the advantage of being safe outside of mmu_lock (the
> obvious disadvantage is that it's very imprecise).
Ok. It makes sense!

