Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85ED36F2A6
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 00:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhD2Wk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 18:40:56 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:37264 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhD2Wk4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 18:40:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UXCbXGB_1619736006;
Received: from 192.168.1.8(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0UXCbXGB_1619736006)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 30 Apr 2021 06:40:07 +0800
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
 <2df3de0e-670a-ba28-fdd2-0002cebde545@linux.alibaba.com>
 <87o8dxf597.ffs@nanos.tec.linutronix.de>
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
Message-ID: <1cdd15f4-1242-a21e-e2e5-cecfc93a1219@linux.alibaba.com>
Date:   Fri, 30 Apr 2021 06:40:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <87o8dxf597.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Got it. Many thanks, Thomas.

On 2021/4/30 上午12:02, Thomas Gleixner wrote:

> On Thu, Apr 29 2021 at 17:38, Zelin Deng wrote:
>> On 2021/4/29 下午4:46, Thomas Gleixner wrote:
>>> And that validation expects that the CPUs involved run in a tight loop
>>> concurrently so the TSC readouts which happen on both can be reliably
>>> compared.
>>>
>>> But this cannot be guaranteed on vCPUs at all, because the host can
>>> schedule out one or both at any point during that synchronization
>>> check.
>> Is there any plan to fix this?
> The above cannot be fixed.
>
> As I said before the solution is:
>
>>> A two socket guest setup needs to have information from the host that
>>> TSC is usable and that the socket sync check can be skipped. Anything
>>> else is just doomed to fail in hard to diagnose ways.
>> Yes, I had tried to add "tsc=unstable" to skip tsc sync.  However if a
> tsc=unstable? Oh well.
>
>> user process which is not pined to vCPU is using rdtsc, it can get tsc
>> warp, because it can be scheduled among vCPUs.  Does it mean user
> Only if the hypervisor is not doing the right thing and makes sure that
> all vCPUs have the same tsc offset vs. the host TSC.
>
>> applications have to guarantee itself to use rdtsc only when TSC is
>> reliable?
> If the TSCs of CPUs are not in sync then the kernel does the right thing
> and uses some other clocksource for the various time interfaces, e.g.
> the kernel provides clock_getttime() which guarantees to be correct
> whether TSC is usable or not.
>
> Any application using RDTSC directly is own their own and it's not a
> kernel problem.
>
> The host kernel cannot make guarantees that the hardware is sane neither
> can a guest kernel make guarantees that the hypervisor is sane.
>
> Thanks,
>
>          tglx
>
>
>
