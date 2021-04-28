Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6209236E223
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 01:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhD1XZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 19:25:44 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45621 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231807AbhD1XZn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 19:25:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UX6F7Pt_1619652295;
Received: from IT-FVFX909QHV2H.local(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0UX6F7Pt_1619652295)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 07:24:56 +0800
Subject: Re: [PATCH] Guest system time jumps when new vCPUs is hot-added
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
References: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
 <87lf92n5r1.ffs@nanos.tec.linutronix.de>
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
Message-ID: <e33920a0-24bc-fa40-0a23-c2eb5693f85d@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 07:24:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <87lf92n5r1.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/4/28 下午5:00, Thomas Gleixner wrote:
> On Wed, Apr 28 2021 at 10:22, Zelin Deng wrote:
>
>> Hello,
>> I have below VM configuration:
>> ...
>>      <vcpu placement='static' current='1'>2</vcpu>
>>      <cpu mode='host-passthrough'>
>>      </cpu>
>>      <clock offset='utc'>
>>          <timer name='tsc' frequency='3000000000'/>
>>      </clock>
>> ...
>> After VM has been up for a few minutes, I use "virsh setvcpus" to hot-add
>> second vCPU into VM, below dmesg is observed:
>> [   53.273484] CPU1 has been hot-added
>> [   85.067135] SMP alternatives: switching to SMP code
>> [   85.078409] x86: Booting SMP configuration:
>> [   85.079027] smpboot: Booting Node 0 Processor 1 APIC 0x1
>> [   85.080240] kvm-clock: cpu 1, msr 77601041, secondary cpu clock
>> [   85.080450] smpboot: CPU 1 Converting physical 0 to logical die 1
>> [   85.101228] TSC ADJUST compensate: CPU1 observed 169175101528 warp. Adjust: 169175101528
>> [  141.513496] TSC ADJUST compensate: CPU1 observed 166 warp. Adjust: 169175101694
> Why is TSC_ADJUST on CPU1 different from CPU0 in the first place?

Per my understanding when vCPU is created by KVM, it's tsc_offset = 0 - 
host rdtsc() meanwhile TSC_ADJUST is 0.

Assume vCPU0 boots up with tsc_offset0, after 10000 tsc cycles, hotplug 
via "virsh setvcpus" creates a new vCPU1 whose tsc_offset1 should be 
about tsc_offset0 - 10000.  Therefore there's 10000 tsc warp between 
rdtsc() in guest of vCPU0 and vCPU1, check_tsc_sync_target() when vCPU1 
gets online will set TSC_ADJUST for vCPU1.

Did I miss something?

>
> That's broken.
>
> Thanks,
>
>          tglx
