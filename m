Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A88C2E6F19
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 09:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgL2IvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 03:51:10 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2933 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgL2IvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Dec 2020 03:51:10 -0500
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4D4p4y0Ld3z5Bsw;
        Tue, 29 Dec 2020 16:49:38 +0800 (CST)
Received: from [10.174.185.135] (10.174.185.135) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 29 Dec 2020 16:50:25 +0800
Subject: Re: [PATCH v2 0/6] KVM: arm64: VCPU preempted check support
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <james.morse@arm.com>,
        <linux@armlinux.org.uk>, <suzuki.poulose@arm.com>,
        <julien.thierry.kdev@gmail.com>, <catalin.marinas@arm.com>,
        <mark.rutland@arm.com>, <steven.price@arm.com>,
        <daniel.lezcano@linaro.org>, <peterz@infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <20191226135833.1052-1-yezengruan@huawei.com>
 <20200113121240.GC3260@willie-the-truck>
 <b1d23a82d6a7caa79a99597fb83472be@kernel.org>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <f126098f-24ec-8c9a-6085-cca82370cf90@huawei.com>
Date:   Tue, 29 Dec 2020 16:50:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b1d23a82d6a7caa79a99597fb83472be@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.135]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/1/15 22:14, Marc Zyngier wrote:
> On 2020-01-13 12:12, Will Deacon wrote:
>> [+PeterZ]
>>
>> On Thu, Dec 26, 2019 at 09:58:27PM +0800, Zengruan Ye wrote:
>>> This patch set aims to support the vcpu_is_preempted() functionality
>>> under KVM/arm64, which allowing the guest to obtain the VCPU is
>>> currently running or not. This will enhance lock performance on
>>> overcommitted hosts (more runnable VCPUs than physical CPUs in the
>>> system) as doing busy waits for preempted VCPUs will hurt system
>>> performance far worse than early yielding.
>>>
>>> We have observed some performace improvements in uninx benchmark tests.
>>>
>>> unix benchmark result:
>>>   host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 CPUs
>>>   guest: kernel 5.5.0-rc1, 16 VCPUs
>>>
>>>                test-case                |    after-patch    |   before-patch
>>> ----------------------------------------+-------------------+------------------
>>>  Dhrystone 2 using register variables   | 334600751.0 lps   | 335319028.3 lps
>>>  Double-Precision Whetstone             |     32856.1 MWIPS |     32849.6 MWIPS
>>>  Execl Throughput                       |      3662.1 lps   |      2718.0 lps
>>>  File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |    158011.8 KBps
>>>  File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |     37664.0 KBps
>>>  File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |    441108.8 KBps
>>>  Pipe Throughput                        |   6405029.6 lps   |   6021457.6 lps
>>>  Pipe-based Context Switching           |    185872.7 lps   |    184255.3 lps
>>>  Process Creation                       |      4025.7 lps   |      3706.6 lps
>>>  Shell Scripts (1 concurrent)           |      6745.6 lpm   |      6436.1 lpm
>>>  Shell Scripts (8 concurrent)           |       998.7 lpm   |       931.1 lpm
>>>  System Call Overhead                   |   3913363.1 lps   |   3883287.8 lps
>>> ----------------------------------------+-------------------+------------------
>>>  System Benchmarks Index Score          |      1835.1       |      1327.6
>>
>> Interesting, thanks for the numbers.
>>
>> So it looks like there is a decent improvement to be had from targetted vCPU
>> wakeup, but I really dislike the explicit PV interface and it's already been
>> shown to interact badly with the WFE-based polling in smp_cond_load_*().
>>
>> Rather than expose a divergent interface, I would instead like to explore an
>> improvement to smp_cond_load_*() and see how that performs before we commit
>> to something more intrusive. Marc and I looked at this very briefly in the
>> past, and the basic idea is to register all of the WFE sites with the
>> hypervisor, indicating which register contains the address being spun on
>> and which register contains the "bad" value. That way, you don't bother
>> rescheduling a vCPU if the value at the address is still bad, because you
>> know it will exit immediately.
>>
>> Of course, the devil is in the details because when I say "address", that's
>> a guest virtual address, so you need to play some tricks in the hypervisor
>> so that you have a separate mapping for the lockword (it's enough to keep
>> track of the physical address).
>>
>> Our hacks are here but we basically ran out of time to work on them beyond
>> an unoptimised and hacky prototype:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy
>>
>> Marc -- how would you prefer to handle this?
> 
> Let me try and rebase this thing to a modern kernel (I doubt it applies without
> conflicts to mainline). We can then have discussion about its merit on the list
> once I post it. It'd be good to have a pointer to the benchamrks that have been
> used here.
> 
> Thanks,
> 
>         M.


Hi Marc, Will,

My apologies for the slow reply. Just checking what is the latest on this
PV cond yield prototype?

https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy

The following are the unixbench test results of PV cond yield prototype:

unix benchmark result:
  host:  kernel 5.10.0-rc6, HiSilicon Kunpeng920, 8 CPUs
  guest: kernel 5.10.0-rc6, 16 VCPUs
                                       | 5.10.0-rc6 | pv_cond_yield | vcpu_is_preempted
 System Benchmarks Index Values        |    INDEX   |      INDEX    |      INDEX
---------------------------------------+------------+---------------+-------------------
 Dhrystone 2 using register variables  |  29164.0   |    29156.9    |    29207.2
 Double-Precision Whetstone            |   6807.6   |     6789.2    |     6912.1
 Execl Throughput                      |    856.7   |     1195.6    |      863.1
 File Copy 1024 bufsize 2000 maxblocks |    189.9   |      923.5    |     1094.2
 File Copy 256 bufsize 500 maxblocks   |    121.9   |      578.4    |      588.7
 File Copy 4096 bufsize 8000 maxblocks |    419.9   |     1992.0    |     2733.7
 Pipe Throughput                       |   6727.2   |     6670.2    |     6743.2
 Pipe-based Context Switching          |    486.9   |      547.0    |      471.9
 Process Creation                      |    353.4   |      345.1    |      338.5
 Shell Scripts (1 concurrent)          |   3187.2   |     1432.2    |     2798.7
 Shell Scripts (8 concurrent)          |   3410.5   |     1360.1    |     2672.9
 System Call Overhead                  |   2967.0   |     3273.9    |     3497.9
---------------------------------------+------------+---------------+-------------------
 System Benchmarks Index Score         |   1410.0   |     1885.8    |     2128.5


Thanks,

Zengruan
