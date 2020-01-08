Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3FB1348E8
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbgAHRPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:15:00 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbgAHRO7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 12:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578503698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnM+x6Ssb1mcduODxbe5+uNany1GBwa/Hz6WtXlr7O4=;
        b=YmeA2/Tm4ZHAohrrr7zr780N+A0oqIRDVUp0BVfSJZBh204y5x7NDfeSJS1eY0gpQzHbFc
        fo8b2syCh226gpeoMaUdSym5nUmAz0LJZS9YvuAyESZCTETXb30/r2yD60aJYZ+7ltjFYB
        ZqpX4oEBR3XW+6Pw+UVyAtSkSbYuKdA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-2ffBoDdmNgClB8cTyvdqZQ-1; Wed, 08 Jan 2020 12:14:57 -0500
X-MC-Unique: 2ffBoDdmNgClB8cTyvdqZQ-1
Received: by mail-wr1-f70.google.com with SMTP id u12so1685755wrt.15
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:14:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vnM+x6Ssb1mcduODxbe5+uNany1GBwa/Hz6WtXlr7O4=;
        b=r4VC/VnNY0s0rTBapl/zlkExNiaTYCd08riOGzl1oS8wVsE94AY/IlUGkSmHkM2WuF
         U0s7btEH7klZ9c/VXb62z/cq+Qi/NcfcrBpVw0axkWnOHRw0UOOwNywtlk/H5uIhLjZG
         O17Xb5Lq7oikp2+TOZxK2BaLxd7/kjBBf1/QpQw52v8AgpeXTHLeP5SbpbwFmvoB5wOy
         GxpWe/G9/xipoxqSLwvtp7HalYtBUkgLBqCjUpQvA8Kd7RlgzEjQMxe8fK/velOLpzZJ
         +tNXjCFf9aU6/NEINQoXVnz0HPmRHvIEu1UWNTjuURv9N6LScRbBk6VzIwaX4qpkdraY
         W2AA==
X-Gm-Message-State: APjAAAX2cMz9AnFXPRBAXP02wb52O6+akPqR/Cx5fDimfKQdNitBEIpS
        7vhdroLLb8YuAW/haXd1wa91TNd3F+GPsucrpGUMbwPY7jOcHIhdPgG6QMejGWzrLqTBZiZXacy
        htf9XZNsZl3xX
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr5225237wme.151.1578503696577;
        Wed, 08 Jan 2020 09:14:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6QfyCjkkc/cn5N9B3HuvF1UbjB6DCyXC1I49m1Q5gG7DdVR/OqIU5VsKS3NDGqXBnTP1SDQ==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr5225208wme.151.1578503696324;
        Wed, 08 Jan 2020 09:14:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id b21sm4680093wmd.37.2020.01.08.09.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:14:55 -0800 (PST)
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes
 mwait/hlt
To:     Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
 <20200108155040.GB2827@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <00d884a7-d463-74b4-82cf-9deb0aa70971@redhat.com>
Date:   Wed, 8 Jan 2020 18:14:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108155040.GB2827@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 16:50, Peter Zijlstra wrote:
> On Wed, Jan 08, 2020 at 09:50:01AM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> To deliver all of the resources of a server to instances in cloud, there are no 
>> housekeeping cpus reserved. libvirtd, qemu main loop, kthreads, and other agent/tools 
>> etc which can't be offloaded to other hardware like smart nic, these stuff will 
>> contend with vCPUs even if MWAIT/HLT instructions executed in the guest.

^^ this is the problem statement:

He has VCPU threads which are being pinned 1:1 to physical CPUs.  He
needs to have various housekeeping threads preempting those vCPU
threads, but he'd rather preempt vCPU threads that are doing HLT/MWAIT
than those that are keeping the CPU busy.

>> The is no trap and yield the pCPU after we expose mwait/hlt to the guest [1][2],
>> the top command on host still observe 100% cpu utilization since qemu process is 
>> running even though guest who has the power management capability executes mwait. 
>> Actually we can observe the physical cpu has already enter deeper cstate by 
>> powertop on host.
>>
>> For virtualization, there is a HLT activity state in CPU VMCS field which indicates 
>> the logical processor is inactive because it executed the HLT instruction, but 
>> SDM 24.4.2 mentioned that execution of the MWAIT instruction may put a logical 
>> processor into an inactive state, however, this VMCS field never reflects this 
>> state.
> 
> So far I think I can follow, however it does not explain who consumes
> this VMCS state if it is set and how that helps. Also, this:

I think what Wanpeng was saying is: "KVM could gather this information
using the activity state field in the VMCS.  However, when the guest
does MWAIT the processor can go into an inactive state without updating
the VMCS."  Hence looking at the APERFMPERF ratio.

>> This patch avoids fine granularity intercept and reschedule vCPU if MWAIT/HLT
>> instructions executed, because it can worse the message-passing workloads which 
>> will switch between idle and running frequently in the guest. Lets penalty the 
>> vCPU which is long idle through tick-based sampling and preemption.
> 
> is just complete gibberish. And I have no idea what problem you're
> trying to solve how.

This is just explaining why MWAIT and HLT is not being trapped in his
setup.  (Because vmexit on HLT or MWAIT is awfully expensive).

> Also, I don't think the TSC/MPERF ratio is architected, we can't assume
> this is true for everything that has APERFMPERF.

Right, you have to look at APERF/MPERF, not TSC/MPERF.  My scheduler-fu
is zero so I can't really help with a nicer solution.

Paolo

