Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE467A00AA
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbjINJr5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 Sep 2023 05:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbjINJrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:47:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56604EB
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 02:47:51 -0700 (PDT)
Received: from lhrpeml500002.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RmXXw4vk5z6K5yT;
        Thu, 14 Sep 2023 17:47:12 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500002.china.huawei.com (7.191.160.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 14 Sep 2023 10:47:48 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Thu, 14 Sep 2023 10:47:48 +0100
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
Thread-Index: AQHZ1zeYniphcsNMdESdQqigwTISA7AZEKiAgAEU5SA=
Date:   Thu, 14 Sep 2023 09:47:48 +0000
Message-ID: <14eb2648eb594dd9a46a179733cee0df@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <ZQHxm+L890yTpY91@linux.dev>
In-Reply-To: <ZQHxm+L890yTpY91@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

> -----Original Message-----
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> Sent: 13 September 2023 18:30
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
> Hi Shameer,
> 
> On Fri, Aug 25, 2023 at 10:35:20AM +0100, Shameer Kolothum wrote:
> > Hi,
> >
> > This is to revive the RFC series[1], which makes use of hardware dirty
> > bit modifier(DBM) feature(FEAT_HAFDBS) for dirty page tracking, sent
> > out by Zhu Keqian sometime back.
> >
> > One of the main drawbacks in using the hardware DBM feature for dirty
> > page tracking is the additional overhead in scanning the PTEs for dirty
> > pages[2]. Also there are no vCPU page faults when we set the DBM bit,
> > which may result in higher convergence time during guest migration.
> >
> > This series tries to reduce these overheads by not setting the
> > DBM for all the writeable pages during migration and instead uses a
> > combined software(current page fault mechanism) and hardware
> approach
> > (set DBM) for dirty page tracking.
> >
> > As noted in RFC v1[1],
> > "The core idea is that we do not enable hardware dirty at start (do not
> > add DBM bit). When an arbitrary PT occurs fault, we execute soft tracking
> > for this PT and enable hardware tracking for its *nearby* PTs (e.g. Add
> > DBM bit for nearby 64PTs). Then when sync dirty log, we have known all
> > PTs with hardware dirty enabled, so we do not need to scan all PTs."
> 
> I'm unconvinced of the value of such a change.
> 
> What you're proposing here is complicated and I fear not easily
> maintainable. Keeping the *two* sources of dirty state seems likely to
> fail (eventually) with some very unfortunate consequences.

It does adds complexity to the dirty state management code. I have tried
to separate the code path using appropriate FLAGS etc to make it more
manageable. But this is probably one area we can work on if the overall
approach does have some benefits.

> The optimization of enabling DBM on neighboring PTEs is presumptive of
> the guest access pattern and could incur unnecessary scans of the
> stage-2 page table w/ a sufficiently sparse guest access pattern.

Agree. This may not work as intended for all workloads and especially 
if the access pattern is sparse. But still hopeful that it will be beneficial for
workloads that have continuous write patterns. And we do have a knob to
turn it on or off.

> > Tests with dirty_log_perf_test with anonymous THP pages shows
> significant
> > improvement in "dirty memory time" as expected but with a hit on
> > "get dirty time" .
> >
> > ./dirty_log_perf_test -b 512MB -v 96 -i 5 -m 2 -s anonymous_thp
> >
> > +---------------------------+----------------+------------------+
> > |                           |   6.5-rc5      | 6.5-rc5 + series
> |
> >
> |                           |     (s)        |       (s)
>    |
> > +---------------------------+----------------+------------------+
> > |    dirty memory
> time      |    4.22        |          0.41    |
> > |    get dirty log
> time     |    0.00047     |          3.25    |
> > |    clear dirty log
> time   |    0.48        |          0.98    |
> > +---------------------------------------------------------------+
> 
> The vCPU:memory ratio you're testing doesn't seem representative of what
> a typical cloud provider would be configuring, and the dirty log
> collection is going to scale linearly with the size of guest memory.

I was limited by the test setup I had. I will give it a go with a higher mem
system. 
 
> Slow dirty log collection is going to matter a lot for VM blackout,
> which from experience tends to be the most sensitive period of live
> migration for guest workloads.
> 
> At least in our testing, the split GET/CLEAR dirty log ioctls
> dramatically improved the performance of a write-protection based ditry
> tracking scheme, as the false positive rate for dirtied pages is
> significantly reduced. FWIW, this is what we use for doing LM on arm64 as
> opposed to the D-bit implemenation that we use on x86.

Guess, by D-bit on x86 you mean the PML feature. Unfortunately that is
something we lack on ARM yet.
 
> > In order to get some idea on actual live migration performance,
> > I created a VM (96vCPUs, 1GB), ran a redis-benchmark test and
> > while the test was in progress initiated live migration(local).
> >
> > redis-benchmark -t set -c 900 -n 5000000 --threads 96
> >
> > Average of 5 runs shows that benchmark finishes ~10% faster with
> > a ~8% increase in "total time" for migration.
> >
> > +---------------------------+----------------+------------------+
> > |                           |   6.5-rc5      | 6.5-rc5 + series
> |
> >
> |                           |     (s)        |    (s)
>     |
> > +---------------------------+----------------+------------------+
> > | [redis]5000000 requests in|    79.428      |      71.49       |
> > | [info migrate]total
> time  |    8438        |      9097        |
> > +---------------------------------------------------------------+
> 
> Faster pre-copy performance would help the benchmark complete faster,
> but the goal for a live migration should be to minimize the lost
> computation for the entire operation. You'd need to test with a
> continuous workload rather than one with a finite amount of work.

Ok. Though the above is not representative of a real workload, I thought
it gives some idea on how "Guest up time improvement" is benefitting the
overall availability of the workload during migration. I will check within our
wider team to see if I can setup a more suitable test/workload to show some
improvement with this approach. 

Please let me know if there is a specific workload you have in mind.

> Also, do you know what live migration scheme you're using here?

The above is the default one (pre-copy).

Thanks for getting back on this. Appreciate if you can do a quick glance
through the rest of the patches as well for any gross errors especially with
respect to page table walk locking, usage of DBM FLAGS etc.

Thanks,
Shameer 
