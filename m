Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB37A4679
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 11:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbjIRJ4f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 18 Sep 2023 05:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241150AbjIRJ4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 05:56:24 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9733C1BD
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 02:55:25 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rq0VG5DX5z6HJlt;
        Mon, 18 Sep 2023 17:53:26 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 18 Sep 2023 10:55:23 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 18 Sep 2023 10:55:23 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty log
Thread-Topic: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty
 log
Thread-Index: AQHZ1zeYniphcsNMdESdQqigwTISA7AZEKiAgAEU5SCAAPR6AIAFYYpQ
Date:   Mon, 18 Sep 2023 09:55:22 +0000
Message-ID: <853b333084c4462a870bb2a37ec65935@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <ZQHxm+L890yTpY91@linux.dev> <14eb2648eb594dd9a46a179733cee0df@huawei.com>
 <ZQOm9gUo8un+claf@linux.dev>
In-Reply-To: <ZQOm9gUo8un+claf@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> Sent: 15 September 2023 01:36
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; maz@kernel.org; will@kernel.org;
> catalin.marinas@arm.com; james.morse@arm.com;
> suzuki.poulose@arm.com; yuzenghui <yuzenghui@huawei.com>; zhukeqian
> <zhukeqian1@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined
> dirty log
> 
> On Thu, Sep 14, 2023 at 09:47:48AM +0000, Shameerali Kolothum Thodi
> wrote:
> 
> [...]
> 
> > > What you're proposing here is complicated and I fear not easily
> > > maintainable. Keeping the *two* sources of dirty state seems likely to
> > > fail (eventually) with some very unfortunate consequences.
> >
> > It does adds complexity to the dirty state management code. I have tried
> > to separate the code path using appropriate FLAGS etc to make it more
> > manageable. But this is probably one area we can work on if the overall
> > approach does have some benefits.
> 
> I'd be a bit more amenable to a solution that would select either
> write-protection or dirty state management, but not both.
> 
> > > The vCPU:memory ratio you're testing doesn't seem representative of
> what
> > > a typical cloud provider would be configuring, and the dirty log
> > > collection is going to scale linearly with the size of guest memory.
> >
> > I was limited by the test setup I had. I will give it a go with a higher mem
> > system.
> 
> Thanks. Dirty log collection needn't be single threaded, but the
> fundamental concern of dirty log collection time scaling linearly w.r.t.
> the size to memory remains. Write-protection helps spread the cost of
> collecting dirty state out across all the vCPU threads.
> 
> There could be some value in giving userspace the ability to parallelize
> calls to dirty log ioctls to work on non-intersecting intervals.
> 
> > > Slow dirty log collection is going to matter a lot for VM blackout,
> > > which from experience tends to be the most sensitive period of live
> > > migration for guest workloads.
> > >
> > > At least in our testing, the split GET/CLEAR dirty log ioctls
> > > dramatically improved the performance of a write-protection based ditry
> > > tracking scheme, as the false positive rate for dirtied pages is
> > > significantly reduced. FWIW, this is what we use for doing LM on arm64
> as
> > > opposed to the D-bit implemenation that we use on x86.
> >
> > Guess, by D-bit on x86 you mean the PML feature. Unfortunately that is
> > something we lack on ARM yet.
> 
> Sorry, this was rather nonspecific. I was describing the pre-copy
> strategies we're using at Google (out of tree). We're carrying patches
> to use EPT D-bit for exitless dirty tracking.

Just curious, how does it handle the overheads associated with scanning for
dirty pages and the convergence w.r.t high rate of dirtying in exitless mode? 
 
> > > Faster pre-copy performance would help the benchmark complete faster,
> > > but the goal for a live migration should be to minimize the lost
> > > computation for the entire operation. You'd need to test with a
> > > continuous workload rather than one with a finite amount of work.
> >
> > Ok. Though the above is not representative of a real workload, I thought
> > it gives some idea on how "Guest up time improvement" is benefitting the
> > overall availability of the workload during migration. I will check within our
> > wider team to see if I can setup a more suitable test/workload to show
> some
> > improvement with this approach.
> >
> > Please let me know if there is a specific workload you have in mind.
> 
> No objection to the workload you've chosen, I'm more concerned about the
> benchmark finishing before live migration completes.
> 
> What I'm looking for is something like this:
> 
>  - Calculate the ops/sec your benchmark completes in steady state
> 
>  - Do a live migration and sample the rate throughout the benchmark,
>    accounting for VM blackout time
> 
>  - Calculate the area under the curve of:
> 
>      y = steady_state_rate - live_migration_rate(t)
> 
>  - Compare the area under the curve for write-protection and your DBM
>    approach.

Ok. Got it.

> > Thanks for getting back on this. Appreciate if you can do a quick glance
> > through the rest of the patches as well for any gross errors especially with
> > respect to page table walk locking, usage of DBM FLAGS etc.
> 
> I'll give it a read when I have some spare cycles. To be entirely clear,
> I don't have any fundamental objections to using DBM for dirty tracking.
> I just want to make sure that all alternatives have been considered
> in the current scheme before we seriously consider a new approach with
> its own set of tradeoffs.

Thanks for taking a look.

Shameer
