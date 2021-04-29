Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD636E819
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 11:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhD2Jjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 05:39:33 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:47113 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233046AbhD2Jj3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 05:39:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UX9zyA9_1619689109;
Received: from IT-FVFX909QHV2H.local(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0UX9zyA9_1619689109)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 17:38:29 +0800
Subject: Re: [PATCH] Guest system time jumps when new vCPUs is hot-added
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
References: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
 <87lf92n5r1.ffs@nanos.tec.linutronix.de>
 <e33920a0-24bc-fa40-0a23-c2eb5693f85d@linux.alibaba.com>
 <875z057a12.ffs@nanos.tec.linutronix.de>
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
Message-ID: <2df3de0e-670a-ba28-fdd2-0002cebde545@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 17:38:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <875z057a12.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/4/29 下午4:46, Thomas Gleixner wrote:
> On Thu, Apr 29 2021 at 07:24, Zelin Deng wrote:
>> On 2021/4/28 下午5:00, Thomas Gleixner wrote:
>>> On Wed, Apr 28 2021 at 10:22, Zelin Deng wrote:
>>>> [   85.101228] TSC ADJUST compensate: CPU1 observed 169175101528 warp. Adjust: 169175101528
>>>> [  141.513496] TSC ADJUST compensate: CPU1 observed 166 warp. Adjust: 169175101694
>>> Why is TSC_ADJUST on CPU1 different from CPU0 in the first place?
>> Per my understanding when vCPU is created by KVM, it's tsc_offset = 0 -
>> host rdtsc() meanwhile TSC_ADJUST is 0.
>>
>> Assume vCPU0 boots up with tsc_offset0, after 10000 tsc cycles, hotplug
>> via "virsh setvcpus" creates a new vCPU1 whose tsc_offset1 should be
>> about tsc_offset0 - 10000.  Therefore there's 10000 tsc warp between
>> rdtsc() in guest of vCPU0 and vCPU1, check_tsc_sync_target() when vCPU1
>> gets online will set TSC_ADJUST for vCPU1.
>>
>> Did I miss something?
> Yes. The above is wrong.
>
> The host has to ensure that the TSC of the vCPUs is in sync and if it
> exposes TSC_ADJUST then that should be 0 and nothing else. The TSC
> in a guest vCPU is
>
>    hostTSC + host_TSC_ADJUST + vcpu_TSC_OFFSET + vcpu_guest_TSC_ADJUST
>
> The mechanism the host has to use to ensure that the guest vCPUs are
> exposing the same time is vcpu_TSC_OFFSET and nothing else. And
> vcpu_TSC_OFFSET is the same for all vCPUs of a guest.
Yes, make sense.
>
> Now there is another issue when vCPU0 and vCPU1 are on different
> 'sockets' via the topology information provided by the hypervisor.
>
> Because we had quite some issues in the past where TSCs on a single
> socket were perfectly fine, but between sockets they were skewed, we
> have a sanity check there. What it does is:
>
>       if (cpu_is_first_on_non_boot_socket(cpu))
>       	validate_synchronization_with_boot_socket()
>
> And that validation expects that the CPUs involved run in a tight loop
> concurrently so the TSC readouts which happen on both can be reliably
> compared.
>
> But this cannot be guaranteed on vCPUs at all, because the host can
> schedule out one or both at any point during that synchronization check.
Is there any plan to fix this?
>
> A two socket guest setup needs to have information from the host that
> TSC is usable and that the socket sync check can be skipped. Anything
> else is just doomed to fail in hard to diagnose ways.

Yes, I had tried to add "tsc=unstable" to skip tsc sync.  However if a 
user process which is not pined to vCPU is using rdtsc, it can get tsc 
warp, because it can be scheduled among vCPUs.  Does it mean user 
applications have to guarantee itself to use rdtsc only when TSC is 
reliable?

>
> Thanks,
>
>          tglx
