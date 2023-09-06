Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E03793345
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 03:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbjIFBSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 21:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbjIFBSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 21:18:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538D01AB;
        Tue,  5 Sep 2023 18:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693963089; x=1725499089;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UxXBSt2yvKyUjNb49TVlzh+fwWGir7bcKlWlTurdCS8=;
  b=R0Chf5M0ibWgvc1n5eIHL+idtG15byBskXkBZcPtdKGPw4HodQ1nMgND
   0y25NAHzjjGTvxIUCJwftpwd8tiMUkw4Q8DOZ2jggh12AOCrvRPBl0iZs
   NvKfrqNGWwvcwZe8HG4tasOQpUHw+rd7AW5LdhrYjKckJFg1DdcsPx9KZ
   VS+C1xoY464Se+Jp1Gwvn6YQD/RU9VHqnqgye4afcKSDz6YLTR50p22KS
   ovYP3V01QvJ8oKZ3Hy16GLoCgFZDq7ivGDG0ow7+Orgp2NE9Pd+R9aP9d
   bUecyJb8rjxOCorIoBtIAxeBLGDjqjDSMrXtsANc5Wr9c6lSYy5pHlT6G
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="367158131"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="367158131"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 18:18:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="741323783"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="741323783"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2023 18:18:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 18:18:08 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 18:18:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 5 Sep 2023 18:18:08 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 5 Sep 2023 18:18:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqsfGSW061npU5vt5RDQ0OH7MDqk5v+CeCY/Ht83ZQxngZvD6xsaYYf5Z4s4EAZPKHjorf4JyUe43Vh/OjIPOsWjdVTo42aHdNnS0SSEFnxYEW3UHodJmRicrKmBT+NYonxl/rcrCXQ+HCYhPUILOQTTwk4t0jFFJHk3ANnBRcgAX9hb6Lh1wm7V5Zalg/y99Di7Kbi4rpm6rn/RsVS2wUERed/NJLt1i9OEruT2dLboygemilTOpoOW7Os23dxkAoVhLdoWHHk9MCQnKCS9FDFCliV4n2EQddBSqZqwa/G3Fm4bLMqQqwRApe+tOxHQzmO615glo77tHjDlw9eKgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBHmA36JBGTOIYCuheuthQvXMZ999WCl5WQfQrnAAs0=;
 b=nHKxwBpdoQ00G/FizXMjJcBqMc7xRwoO3GawxBi7jEieWu+sJK0zUccMTKA2kz53CK/jOvQGszHtdQLJDPV6I1EXry1/r0+5CFhH8ZB1ajhAu5TjNDcFCjxKrx2GijWTb8s+VC9uuxtoIgGzt30c7pFQfYn283mjkz/qnVZFNpeLT3x2cHr+FwNdVW3udgXd0EHkXck2TEzd/bhFLZ1x4ignO9xhsd/GBhLT1ghbmmLJoBkj50FRUZKcmRTFvJCTNJV0r2xPIdp9PcjlzNuy1rH95s3lbHIyjxr8OzB23N5vR600V2LaRDHzBjFtgNP29Fgz2wnqp4aFenUbikf+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BY1PR11MB8080.namprd11.prod.outlook.com (2603:10b6:a03:528::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 01:18:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 01:18:04 +0000
Date:   Wed, 6 Sep 2023 08:50:26 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 12/12] KVM: x86/mmu: convert kvm_zap_gfn_range() to
 use shared mmu_lock in TDP MMU
Message-ID: <ZPfM0kr+/sx2cae5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065631.20869-1-yan.y.zhao@intel.com>
 <ZOkeZi/Xx+1inver@google.com>
 <ZPWHtUh9SZDc4EoN@yzhao56-desk.sh.intel.com>
 <ZPesX2xp6rGZsxlE@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZPesX2xp6rGZsxlE@google.com>
X-ClientProxiedBy: KL1P15301CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:6::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BY1PR11MB8080:EE_
X-MS-Office365-Filtering-Correlation-Id: 515e1635-4dc4-49c4-eace-08dbae771e4f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPBOvU7XKQ+mGzY/67SLAKIVOrM/WyvoS7SCEqsRHywXZ5Ap4PyJOrOKj9jgQ23hEs8oFY+6TSK/18sQlvfOQeDOc8h59NSvvM9o6AgdawBcrFxI6lLnSZfCtJHWs7VOJWuLOdaV1N4HA2DbckWtZFCUYyuWr/RUxJyaFDFdFBtI1rfshq7LfSgXUWk1jSYFSAV1Y5G1JfF9TTG9aEuDU/3u9miBhvOh8iJvzQtJpArjV1W3VcykYCdruqTHyoIuei7zGtVZqkjaBZbWAps28WZHmAKA2T0/2gLuu9YonimJmVrkqNaU2P1zdcSKB1/g5Tti8IZkS00Hh0U9rnlAD6CzIwz8q1FR15pajnPehRZYtq12MB3UfP2DICG4q22WtmWbTi2eKpdxulMb7MP3Z4KdFWui8PYi+Lj5mh9WfdJAYAuIjMyfRs8KyDXVGSqxCmKdqpxfG6cWSA0REyNnBCKGYc8g+FLKwAlWZtpzuzxrvocbSlP/otscl0ihBiPuadNPNLUstYrlHMDbeA1xo4hEMb5koL9Q7e6lmpp4l0QA6FI4dFp4R0OJRXsXvdht
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(39860400002)(346002)(376002)(1800799009)(451199024)(186009)(2906002)(66476007)(8676002)(4326008)(8936002)(3450700001)(6916009)(41300700001)(5660300002)(316002)(6506007)(66946007)(66556008)(86362001)(82960400001)(6666004)(478600001)(6512007)(6486002)(26005)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Waknth3LEOPELQLljX+VbgRt+es/djZKkiINeHQvBDbuBe7x1St1qDl1ZT/7?=
 =?us-ascii?Q?gBXPFwYxXWmOX/YfhE7s71dyvFMFCI3vMvJBNew7u0yiwqygtGE+Hi25iBSY?=
 =?us-ascii?Q?TXxKBIQ8n0F7adU7jn4BF8VID22uQ7qogHQAaK3s9+kIs8KvNd0yJn2Ya89J?=
 =?us-ascii?Q?0PKfYfsuEBGApJ+pyUx0FPNuAX5/YF9hIr/Ddaj9vEkHA3Eup2bdBckawywq?=
 =?us-ascii?Q?H3Je6EgS+uaJNuU00TUS1/q9A4YDp1/Qm7MNwwOWkWkmUIeylUPMkFYjNLoK?=
 =?us-ascii?Q?ci47uP0jiNdfUc8triHu8Kipizyrbx6E4TUgLnwcy/UNcwFPZB4PSxf1UxvX?=
 =?us-ascii?Q?6EHiW+M6PiOfnGg6m8vUO1CfO6hNr0hMvXyIGzz+rFJ+Ic2CMB1Suabf4rSZ?=
 =?us-ascii?Q?YCgLSP66WSGnAHKlJqWKmtUUL66/25hXFCDPHftYAUpREXkoiE/kA1/7czqo?=
 =?us-ascii?Q?uQTfu44sjX+pn5din6IXGOgSQhMIa7u5slp+GXGm5HgXT7njKjI20x7uGYne?=
 =?us-ascii?Q?SJ5jHE+bYxFn+FRY/s8mUzv3nnPcsx1kdaqqDkEtIWfrnXYjrPExHriYt8Qf?=
 =?us-ascii?Q?N7xzBtzr9D9sQJj+T+vXceTI4x5HtsLoS/AkTsx/zynoZ8f9rMypfg7WjVNI?=
 =?us-ascii?Q?k/ccWb0+AIoYxIgc1tAbpN5coz66QDVuhuCE4VycmRbPsSayU/DlLcSTEC0X?=
 =?us-ascii?Q?S+OyKNfBuQaQBx+HlKcjT01kAdzOJbw9XzTg1raH0OR7hW7QPkARnGp3cWRr?=
 =?us-ascii?Q?8aefY/8SIcbQJtlubg0CNnXmftK0k53WaeenoaQh5kF8UhNkmc3ZPp5lHNI4?=
 =?us-ascii?Q?hBTSSQ1OM/g4MN9aokPZtV8hoA/HsJGvDAafDWnscOO3LTH6D5oBf6VRJ3b9?=
 =?us-ascii?Q?BaU63v0k79AD9U9TtV30i9y0xS0XLK/Ut3+jIDeH1go4cYMuE+juWVp+wIs9?=
 =?us-ascii?Q?HwKiRfDvCJx3+oLZlGb74uKzMcmSzXAP+yeQR35wRPIBC88uY57rh6C3VQ9b?=
 =?us-ascii?Q?ee2M2W65YdBPc+UVIbYzNw2aiDGJDR5aDN3ViU9XWGeS6gMM8r6PIkrbBVpm?=
 =?us-ascii?Q?HZjbPPKcLtDjwnAAEIY3iz7WbvvnB3lM/tlbZQLLt6Dx5vP0pQ+6MfFsyRy8?=
 =?us-ascii?Q?CTIEhhZvoiHpx97H2QqUdMChE3a27ixi9soMRgGMAsiKzJrWGyrBh2er4MWp?=
 =?us-ascii?Q?N2YbxkfW+F/e3W9wDvHNTluefvrW6mlZ2HaS1qzkpim3r/LPeklci9Fp6RyA?=
 =?us-ascii?Q?sRaOyUb0l1kSdMoYlld/IXl4SBOsDJES2xf5DQzTSzc7kcrm3mbgTt+4OAVK?=
 =?us-ascii?Q?H5ktu7So6VVNY9D3ECu79IVwQ080yw1EaUNJEV0lfQtoAbbnKURKq5InwX6L?=
 =?us-ascii?Q?opr2mAXsQWLnupTPG523wX4vcP/pxNseehAG4CNOwFigYu/OoXskQdxPGL8f?=
 =?us-ascii?Q?/LFGhl2ZeIHsqwdRDya0kKVSGnDfRykBkGE7wjfk7pQGpsukmdW9eIjjTMWS?=
 =?us-ascii?Q?Z9FTIN3WDNUlWjnGu3reZr2pKnF2a34lEp3Q35sZ7/XAALT7tK3co2zKVINC?=
 =?us-ascii?Q?fAFZnePoeh3S5JM6BVyFV3Cg5RCFUi8CB0RelufK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 515e1635-4dc4-49c4-eace-08dbae771e4f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 01:18:04.3636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnIPql0NkTTRAq9WCuWrGKuESh3ePp2xZ/L/EBOXv0xRDybwmWBVt/pekc3txPh9ORlTLX5EFwlKDdlYgPVnLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8080
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 05, 2023 at 03:31:59PM -0700, Sean Christopherson wrote:
> On Mon, Sep 04, 2023, Yan Zhao wrote:
> > On Fri, Aug 25, 2023 at 02:34:30PM -0700, Sean Christopherson wrote:
> > > On Fri, Jul 14, 2023, Yan Zhao wrote:
> > > > Convert kvm_zap_gfn_range() from holding mmu_lock for write to holding for
> > > > read in TDP MMU and allow zapping of non-leaf SPTEs of level <= 1G.
> > > > TLB flushes are executed/requested within tdp_mmu_zap_spte_atomic() guarded
> > > > by RCU lock.
> > > > 
> > > > GFN zap can be super slow if mmu_lock is held for write when there are
> > > > contentions. In worst cases, huge cpu cycles are spent on yielding GFN by
> > > > GFN, i.e. the loop of "check and flush tlb -> drop rcu lock ->
> > > > drop mmu_lock -> cpu_relax() -> take mmu_lock -> take rcu lock" are entered
> > > > for every GFN.
> > > > Contentions can either from concurrent zaps holding mmu_lock for write or
> > > > from tdp_mmu_map() holding mmu_lock for read.
> > > 
> > > The lock contention should go away with a pre-check[*], correct?  That's a more
> > Yes, I think so, though I don't have time to verify it yet.
> > 
> > > complete solution too, in that it also avoids lock contention for the shadow MMU,
> > > which presumably suffers the same problem (I don't see anything that would prevent
> > > it from yielding).
> > > 
> > > If we do want to zap with mmu_lock held for read, I think we should convert
> > > kvm_tdp_mmu_zap_leafs() and all its callers to run under read, because unless I'm
> > > missing something, the rules are the same regardless of _why_ KVM is zapping, e.g.
> > > the zap needs to be protected by mmu_invalidate_in_progress, which ensures no other
> > > tasks will race to install SPTEs that are supposed to be zapped.
> > Yes. I did't do that to the unmap path was only because I don't want to make a
> > big code change.
> > The write lock in kvm_unmap_gfn_range() path is taken in arch-agnostic code,
> > which is not easy to change, right?
> 
> Yeah.  The lock itself isn't bad, especially if we can convert all mmu_nofitier
> hooks, e.g. we already have KVM_MMU_LOCK(), adding a variant for mmu_notifiers
> would be quite easy.
>
> The bigger problem would be kvm_mmu_invalidate_{begin,end}() and getting the
> memory ordering right, especially if there are multiple mmu_notifier events in
> flight.
> 
> But I was actually thinking of a cheesier approach: drop and reacquire mmu_lock
> when zapping, e.g. without the necessary changes in tdp_mmu_zap_leafs():
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 735c976913c2..c89a2511789b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -882,9 +882,15 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
>  {
>         struct kvm_mmu_page *root;
>  
> +       write_unlock(&kvm->mmu_lock);
> +       read_lock(&kvm->mmu_lock);
> +
>         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
>                 flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
>  
> +       read_unlock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
> +
>         return flush;
>  }
> 
> vCPUs would still get blocked, but for a smaller duration, and the lock contention
> between vCPUs and the zapping task would mostly go away.
>
Yes, I actually did similar thing locally, i.e. releasing write lock and taking
read lock before zapping.
But yes, I also think it's cheesier as the caller of the write lock knows nothing
about its write lock was replaced with read lock.


> > > If you post a version of this patch that converts kvm_tdp_mmu_zap_leafs(), please
> > > post it as a standalone patch.  At a glance it doesn't have any dependencies on the
> > > MTRR changes, and I don't want this type of changed buried at the end of a series
> > > that is for a fairly niche setup.  This needs a lot of scrutiny to make sure zapping
> > > under read really is safe
> > Given the pre-check patch should work, do you think it's still worthwhile to do
> > this convertion?
> 
> I do think it would be a net positive, though I don't know that it's worth your
> time without a concrete use cases.  My gut instinct could be wrong, so I wouldn't
> want to take on the risk of running with mmu_lock held for read without hard
> performance numbers to justify the change.
Ok, I see. May try conversion later if I found out the performance justification.

Thanks!
