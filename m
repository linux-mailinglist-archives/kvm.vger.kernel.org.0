Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC752D838C
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 00:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389634AbfJOWWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 18:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732104AbfJOWWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 18:22:33 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9EED7BDA6
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 22:22:32 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id q9so292883wmj.9
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 15:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fiCu9Lkt0iLC5mxBsEL/QJGEmXdDuljE6cFfd5EN72c=;
        b=dTHEUdQ3IY4pwQpsTExTo4cg4fT0O3627+cjE43Ofoj2lVgLM2n0ZtUYaQ4MA5AZ7v
         Xp+1QZzGZ5xFklf7fnEfw/uiIwi5p2s4lnE4CK4/AMwc1aIDZ8rckdFpslmmVRz++Yya
         Lvi8zV7OVTY+D2VTpqvc17nAMKQp8dkDHC06Pb4iY0VV/uKK4qXyvGRy5cHyNTaPECTl
         UGYgjddU9bE6Fo/b9r63XEpevV8aIMeDfjEFo1ImvJqVShT+27IWkde3JGBsTxmVS+AN
         cg+m4Ryv7ErJCsWT/9xivyAbfaHi3AYXlsrK5jV3eopIMJB9VyRR/ljpUIAbe0RStbMq
         w73g==
X-Gm-Message-State: APjAAAWYIWMV+6WdKYFHAxCVcwX9KQNXo/cUdxO+68kvLMhIS0A2YgT9
        M/wolFWl5OjQxuXh4T/wZYR59+1xRIkAggQZU2RaGhL7OjSTc8oJBkvR72las2/PzRHQC9bnn8E
        7+G2qM661IzOt
X-Received: by 2002:a7b:c5c9:: with SMTP id n9mr606761wmk.28.1571178151394;
        Tue, 15 Oct 2019 15:22:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxMMrxE/p8JBbpixpwdyHYMXy0PBoQ6zpd27bhjbx2gy+s9nO3NiGK9FxcZPv/D9Q+R9T+0tw==
X-Received: by 2002:a7b:c5c9:: with SMTP id n9mr606734wmk.28.1571178151047;
        Tue, 15 Oct 2019 15:22:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id k24sm5156405wmi.1.2019.10.15.15.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 15:22:30 -0700 (PDT)
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
 <20191015164952.GE331@redhat.com>
 <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
 <20191015203516.GF331@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f375049a-6a45-c0df-a377-66418c8eb7e8@redhat.com>
Date:   Wed, 16 Oct 2019 00:22:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015203516.GF331@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 22:35, Andrea Arcangeli wrote:
> On Tue, Oct 15, 2019 at 09:46:58PM +0200, Paolo Bonzini wrote:
>> On 15/10/19 18:49, Andrea Arcangeli wrote:
>>> On Tue, Oct 15, 2019 at 10:28:39AM +0200, Paolo Bonzini wrote:
>>>> If you're including EXIT_REASON_EPT_MISCONFIG (MMIO access) then you
>>>> should include EXIT_REASON_IO_INSTRUCTION too.  Depending on the devices
>>>> that are in the guest, the doorbell register might be MMIO or PIO.
>>>
>>> The fact outb/inb devices exists isn't the question here. The question
>>> you should clarify is: which of the PIO devices is performance
>>> critical as much as MMIO with virtio/vhost?
>>
>> virtio 0.9 uses PIO.
> 
> 0.9 is a 12 years old protocol replaced several years ago.

Oh come on.  0.9 is not 12-years old.  virtio 1.0 is 3.5 years old
(March 2016).  Anything older than 2017 is going to use 0.9.

> Your idea that HLT is a certainly is a slow path is only correct if
> you assume the host is IDLE, but the host is never idle if you use
> virt for consolidation.
>
> I've several workloads including eBPF tracing, not related to
> interrupts (that in turn cannot be mitigated by NAPI) that schedule
> frequently and hit 100k+ of HLT vmexits per second and the host is all
> but idle. There's no need of hardware interrupt to wake up tasks and
> schedule in the guest, scheduler IPIs and timers are more than enough.
>
> All it matters is how many vmexits per second there are, everything
> else including "why" they happen and what those vmexists means for the
> guest, is irrelevant, or it would be relevant only if the host was
> guaranteed to be idle but there's no such guarantee.

Your tables give:

	Samples	  Samples%  Time%     Min Time  Max time       Avg time
HLT     101128    75.33%    99.66%    0.43us    901000.66us    310.88us
HLT     118474    19.11%    95.88%    0.33us    707693.05us    43.56us

If "avg time" means the average time to serve an HLT vmexit, I don't
understand how you can have an average time of 0.3ms (1/3000th of a
second) and 100000 samples per second.  Can you explain that to me?

Anyway, if the average time is indeed 310us and 43us, it is orders of
magnitude more than the time spent executing a retpoline.  That time
will be spent in an indirect branch miss (retpoline) instead of doing
while(!kvm_vcpu_check_block()), but it doesn't change anything.

>>> I'm pretty sure HLT/EXTERNAL_INTERRUPT/PENDING_INTERRUPT should be
>>> included.
>>> I also wonder if VMCALL should be added, certain loads hit on fairly
>>> frequent VMCALL, but none of the one I benchmarked.
>>
>> I agree for external interrupt and pending interrupt, and VMCALL is fine
>> too.  In addition I'd add I/O instructions which are useful for some
>> guests and also for benchmarking (e.g. vmexit.flat has both IN and OUT
>> tests).
> 
> Isn't it faster to use cpuid for benchmarking? I mean we don't want to
> pay for more than one branch for benchmarking (even cpuid is
> questionable in the long term, but for now it's handy to have),

outl is more or less the same as cpuid and vmcall.  You can measure it
with vmexit.flat.  inl is slower.

> and unlike inb/outb, cpuid runs occasionally in all real life workloads
> (including in guest userland) so between inb/outb, I'd rather prefer
> to use cpuid as the benchmark vector because at least it has a chance
> to help real workloads a bit too.

Again: what is the real workload that does thousands of CPUIDs per second?

Paolo
