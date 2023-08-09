Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCD5776CDF
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 01:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjHIXsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 19:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjHIXsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 19:48:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD757F7;
        Wed,  9 Aug 2023 16:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691624884; x=1723160884;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=AUDIqSpX4e9VVfFkgpkWcoi6NJ23scDDrIg9qI+yayQ=;
  b=hzybfn7YVfI70NeT7jojzi44lNGP8Ucqe3Ta7/zBVX8BVIw9YuQNp/RU
   3wDEj9lLWIFYJpS6UewoIyVUoD7hNMjs/xYoDlsoNW5B5bjWPl3DKLPuR
   W/XM6YQL4ZATL0w9Zs5PU22ZnQfJXVBc/u3HdXa5iLMoyRVMo/08yYgoQ
   eC+WvqrZ5q6f3OK99zA1VidTPNFP4QV2RtCtjZ9wltmr1rS4n+BGdHx1F
   rB2pa0LscX7x6ei4zoZ+AdWkOAkiUq74MPPizpEZtS2lIm/0hPtB5bJOT
   Ttoh9LnSyi/kUyFr9CDLg9e2R2CK10zrZ1nquOC4AuRxAHYVrOmhfq7/1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="351559754"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="351559754"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 16:48:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="797388824"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="797388824"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2023 16:48:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 16:48:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 16:48:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 16:48:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 16:48:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k25sUr1cLR64XBvDxCndtArd5es33cTqDmDArqDpweIori8n+Mvrh/mKnjDWAdFwerBdm8iJ9XGw1QJmA8fifuu0soWvlx5U5d5C11zU/j6uqh0hGdcFrTdPvJ0hLqDII6CBqyJxuhK7gWlXbxC7xzwofl40B6AJXtUq3NNofTlQ0xCvvv/+iKVezdnwUcU2vJqXKRctg4b0NDeuwqokK3rQRv2h/Jper+wj18okfhbtUHWhNL6UKsuit8LyVwussC+t8MWSAm26HcIU0JPSWrEj9PT3iGRwEgMD7wFfmAECePrg1v8vPSI/PSIGJMJVSXd6iZ8ycXBdV15KCz6EBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AoFPCBsfNsgqaBUhgcslBw4NFjnxE5ljlrdPEMKn8+Q=;
 b=Gs8PZQaIEGToFZ65tsGjono7ESkA5staXLK92yQo6lrAgFmd0W/mBQ2foTa18rS4KEZhAR+YDHy920ATRMGxw1GHI31UB4fXAD9olYrUh6UJeKDjUXSS+EIZpld7tPGWwdr/5DhQQMfBc55Q/e5GBJac0efK8bhkUva5AkhqZZaVaefA9oSPgi0A49PpAGN5fAXH9cCXbqtz6xzNXpiwHl27rsxzO2HefxE+Z5dF6cy0vquEZGRDymGKP4/lL9u/Bt2nKVjffE2wLIaiXwSxtCh21vCtL3fZTSXuWLHnvUiVAG2FOTyvB1Qd2gJ7dIVKizApVLGl1SWmIyPLyqIcvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7901.namprd11.prod.outlook.com (2603:10b6:8:f4::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.25; Wed, 9 Aug 2023 23:48:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 23:48:00 +0000
Date:   Thu, 10 Aug 2023 07:21:03 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Like Xu <like.xu.linux@gmail.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
Message-ID: <ZNQfX4JHTJu1Qtl0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-20-seanjc@google.com>
 <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com>
 <ZNEni2XZuwiPgqaC@google.com>
 <ZNLlseYag5DniUg3@yzhao56-desk.sh.intel.com>
 <ZNOjyf2OHQZYfMEJ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNOjyf2OHQZYfMEJ@google.com>
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7901:EE_
X-MS-Office365-Filtering-Correlation-Id: e121b4f4-fcf4-4bfd-8dfb-08db99331070
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ReDeYKTqoxRNNEuV8TfI4EQKhIULVb00TTLbdJtg4qWAtnDZ+7aRq444aKMySUxX0RujJr07KXqVhyOAE47F8IVod6XKGBpgyxjPvV4vXOHqL7EazUV86AogX6boY43pQvN46QSHseBI9+z58N28vyOzPY3EQK/oO431+Vv3rnVEdQnmpJRrmdytwxM2NOI5jctN9tdUInUg7ZLQMS+JfF0f4E8mAr7djnF/c2gy6pv45EXIbEIiBjGNikGP0l1orGxo+uvjBEu6xB86DX9QAtOJhjWm1MvhUe6zwf6b/utFjJwZQHZVMPcfkKkMVQ1+jSY4qq1zSc9lTEeZNnJ5Qgl7sfJvyRTdOVVDzaEWOncjFpnhPxq+PPeOa2g/7PufHE5FqA1dSOK1SiHYJIb6Vuqj2Up5oAyJW8eADvVkEWjpYGNKPneOFK1yb7s7ICMyEiF92vg+CDqWmFnNo9rom4hsI6NkapwqDjHFnf/fqiRdN27S2i2kMqXfu5W6u6b+ViqpLeu7QPL9c4Y5CMOec7O/BaFJIMfCI2xRYh9rhQDdAfblRWiKUPm17co4MQ/kLSUZKpkIhdNiBWhEj7lNDMB/ODQ/AWQeP452RTUsUKlVOAyLZIM+idgPv+vrebWFtnUpEmjf4oQea8sNIa0sSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(346002)(376002)(186006)(1800799006)(451199021)(83380400001)(4326008)(86362001)(5660300002)(6916009)(54906003)(8676002)(66556008)(316002)(3450700001)(66476007)(38100700002)(66946007)(2906002)(8936002)(6512007)(478600001)(82960400001)(6486002)(26005)(41300700001)(6506007)(53546011)(26730200005)(19860200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OGkKG0ljQNkJXLnuz3O2vr9U0rswy/xmBd5cgOyiyMo1VUp6l3kTzZpV6N1b?=
 =?us-ascii?Q?Oj90H5Ap15c1h0y9J9e26OxxUtZWDKrgez/HTxz8QBtDDVIInrRka+qC1Jh6?=
 =?us-ascii?Q?AgQX6d/2kg0gXEq+WAQAx+DwCHGPfGuD5qDRdiZxLOZe9GWQCsPdwuXZET/O?=
 =?us-ascii?Q?4KfqdBgJcnTdNLSj/XoGttWIudH3/0sP0gYfcuztHBvKnwCkOVH0eK9HWFg5?=
 =?us-ascii?Q?a0OroxuBjVClFpiOtXtes4ISsqJM+yw4/Ns8kpaDDKREteppmGWOUyZC1hRK?=
 =?us-ascii?Q?zxew2GjDbWpCkT4h43RP6PFzKQKOwBW7jrwEOs8QgVGellVxnV8/ApEUWKkh?=
 =?us-ascii?Q?aQH6nVyxKhvY2YXFR22LTURAyRQhQvQ4ggUOqdShsDs+3cmLjLn3R6LaIB/V?=
 =?us-ascii?Q?8aHsVXDPQHEagd8Cop5WK6X8XADuQw3RrXN+swRezIFM3bdow+Q4yJ7Q0rp2?=
 =?us-ascii?Q?GOfKtBZ2EP0UVrQ+K/Sj9kkiTn6kMuWxI3ACvojQ0Dft6v0FZnApG58WEAmR?=
 =?us-ascii?Q?yIbf4B4Qx5yU/uQ7J9u8kO0uR8RnshZ7xifXyMrYBOXTGHAbnQsnlmTqJFwK?=
 =?us-ascii?Q?b40/y4QhFQnobH5arm+0KKA4oJc6dhMA4jcu20YyJ9RfILco0tpW4fWAhCWc?=
 =?us-ascii?Q?+Qx3HxRZfoDu0StgGIuhEU4Um3OXetQY88bk23WGd8D87VCrSy3Avdt3iiat?=
 =?us-ascii?Q?6l2NuvS4EDQ5nD8Z7JFjSf/4iMjMOmsIfmQrxwsDb98kFlooNyHVBbYgYsBD?=
 =?us-ascii?Q?aP1WTFhn+/sQRiLiBKBJ1ojENfnmbOvFzFIrpcES7I9+qM4Ua6HDgzWV09Hg?=
 =?us-ascii?Q?YaQAVyBroiPkPC3ZELZWWM3QqXt3sZ5Gi24zVKhS7u2yV9b0HXeRUJ03Jjg/?=
 =?us-ascii?Q?s+HGl+B1qkej7rTdr6wNkKydVvvHlUG4slzlFYS0qi0bmob5c3x9iMoATidV?=
 =?us-ascii?Q?IjnBBIsA4cODF3byOlMLIDzBhYQnyRJOL7pcQwjuRf4VDirY/Tw7aztRYG2F?=
 =?us-ascii?Q?AxhwaMyFVS9FkoWfHvUONHseWwJ1U/5UTIvSLkcyMPYqrDw5YDMGrpBaZE9x?=
 =?us-ascii?Q?Yl3+uk4K1vWO1sI66RBXUL6JqANDmwc4eHSuWI1lboYu9yAH+K2IO+QKevTj?=
 =?us-ascii?Q?UCKYryVh4oXHpwn2MfzTW0Rp20DE2Ur034Eyrtsl6Q86coBrnCrm7FwxuK4q?=
 =?us-ascii?Q?u0qiZjpmju/p4jM1MR2FVS/NXheOWquCv0D+RJi5JkxgTSfnHdiAkpSvKwL3?=
 =?us-ascii?Q?GGdPt9t4aqQUvVTUloojFWyBmqUUYclOMCmPx4PCn1bcydahLdn2kb95kSZF?=
 =?us-ascii?Q?hLb1dhw5jBD08X/eu9GHt21bsUV3drThFLjpa4cyEhH1JtHUNe/nTALeKr6v?=
 =?us-ascii?Q?kwce7PCuZ2KCta60UnqYm63eUyAaDnDAl87hrnYKBvtE59ix3Ope3vc6/VUQ?=
 =?us-ascii?Q?rNzQFoAc5uZEit/3qs+haauGTtYQLQb/sptB/+BXMyGCFFR3lwCjrXQsWz9e?=
 =?us-ascii?Q?lfAXLVKuGjt/U/P/AEdC0VVmB68s2O/i62iUpYNyKuSR4eQwKcxW/b1N4Z9d?=
 =?us-ascii?Q?ILhKimuYtcvWOHC+O5iETNqJI16ej5LFtnVVQJGN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e121b4f4-fcf4-4bfd-8dfb-08db99331070
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 23:48:00.6107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l8bkJDqtkjrZXhxC+5OIy583Nb1krETQtCm7w8tVhnevdu9MmbRgX2XPSfanXxO3njw6EilnFpw0fLZiHHOcOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7901
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 07:33:45AM -0700, Sean Christopherson wrote:
> On Wed, Aug 09, 2023, Yan Zhao wrote:
> > On Mon, Aug 07, 2023 at 10:19:07AM -0700, Sean Christopherson wrote:
> > > On Mon, Aug 07, 2023, Like Xu wrote:
> > > > On 23/12/2022 8:57 am, Sean Christopherson wrote:
> > > > > +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> > > > > +					const u8 *new, int bytes)
> > > > > +{
> > > > > +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> > > > > +
> > > > > +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> > > > > +}
> > > > 
> > > > The kvm_mmu_track_write() is only used for x86, where the incoming parameter
> > > > "u8 *new" has not been required since 0e0fee5c539b ("kvm: mmu: Fix race in
> > > > emulated page table writes"), please help confirm if it's still needed ? Thanks.
> > > > A minor clean up is proposed.
> > > 
> > > Hmm, unless I'm misreading things, KVMGT ultimately doesn't consume @new either.
> > > So I think we can remove @new from kvm_page_track_write() entirely.
> > Sorry for the late reply.
> > Yes, KVMGT does not consume @new and it reads the guest PTE again in the
> > page track write handler.
> > 
> > But I have a couple of questions related to the memtioned commit as
> > below:
> > 
> > (1) If "re-reading the current value of the guest PTE after the MMU lock has
> > been acquired", then should KVMGT also acquire the MMU lock too?
> 
> No.  If applicable, KVMGT should read the new/current value after acquiring
> whatever lock protects the generation (or update) of the shadow entries.  I
> suspect KVMGT already does this, but I don't have time to confirm that at this
I think the mutex lock and unlock of info->vgpu_lock you added in
kvmgt_page_track_write() is the counterpart :)

> exact memory.
> 
> The race that was fixed in KVM was:
> 
>   vCPU0         vCPU1   
>   write X
>                  write Y
>                  sync SPTE w/ Y
>   sync SPTE w/ X
> 
> Reading the value after acquiring mmu_lock ensures that both vCPUs will see whatever
> value "loses" the race, i.e. whatever written value is processed second ('Y' in the
> above sequence).
I suspect that vCPU0 may still generate a wrong SPTE if vCPU1 wrote 4
bytes while vCPU0 wrote 8 bytes, though the chances are very low.


> 
> > If so, could we move the MMU lock and unlock into kvm_page_track_write()
> > as it's common.
> > 
> > (2) Even if KVMGT consumes @new,
> > will kvm_page_track_write() be called for once or twice if there are two
> > concurent emulated write?
> 
> Twice, kvm_page_track_write() is wired up directly to the emulation of the write,
> i.e. there is no batching.
