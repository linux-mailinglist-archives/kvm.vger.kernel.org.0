Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D473AF96C
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 01:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhFUXe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 19:34:58 -0400
Received: from forward100j.mail.yandex.net ([5.45.198.240]:54803 "EHLO
        forward100j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229940AbhFUXe5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 19:34:57 -0400
Received: from myt6-640abdf8240b.qloud-c.yandex.net (myt6-640abdf8240b.qloud-c.yandex.net [IPv6:2a02:6b8:c12:238c:0:640:640a:bdf8])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id 0574750E15F0;
        Tue, 22 Jun 2021 02:32:40 +0300 (MSK)
Received: from myt6-efff10c3476a.qloud-c.yandex.net (myt6-efff10c3476a.qloud-c.yandex.net [2a02:6b8:c12:13a3:0:640:efff:10c3])
        by myt6-640abdf8240b.qloud-c.yandex.net (mxback/Yandex) with ESMTP id oTWnFCU2p0-Wde8WsKS;
        Tue, 22 Jun 2021 02:32:39 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624318359;
        bh=c9v72GT4SWZCjxbmh53+FhfBIokaX6qvhChHTiV5FZ8=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=F1xpFipW4uDvR/vjUjTGQx4MFS7oA60T91yAUEMOm4rJjQsXFj3+EYJv6yQ3n2yEd
         uuIlkH7eLZTqF+W8hsEOWtLHeQpbqOVme+vKnaC00JFmxXrk5cVPqB3cjYohKfAmy0
         3amSqenTt7En9YVxZT2pggG/5sA7kKmFpeMoWuAI=
Authentication-Results: myt6-640abdf8240b.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-efff10c3476a.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id bytpaGG0RA-WdPGq0wq;
        Tue, 22 Jun 2021 02:32:39 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on
 core2duo?)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <145c3b82-0d31-307f-9af8-e684885c7045@yandex.ru>
Date:   Tue, 22 Jun 2021 02:32:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

22.06.2021 01:33, Jim Mattson пишет:
> On Sun, Jun 20, 2021 at 7:34 PM stsp <stsp2@yandex.ru> wrote:
>> 19.06.2021 00:07, Jim Mattson пишет:
>>> I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers:
>> OK, so this indeed have solved
>> the biggest part of the problem,
>> thanks again.
>>
>> Now back to the original problem,
>> where I was getting a page fault
>> on some CPUs sometimes.
>> I digged a bit more.
>> It seems I am getting a race of
>> this kind: exception in guest happens
>> at the same time when the host's
>> SIGALRM arrives. KVM returns to
>> host with the exception somehow
>> "pending", but its still on ring3, not
>> switched to the ring0 handler.
>>
>> Then from host I inject the interrupt
>> (which is what SIGALRM asks for),
>> and when I enter the guest, it throws
>> the pending exception instead of
>> executing the interrupt handler.
>> I suspect the bug is again on my side,
>> but I am not sure how to handle that
>> kind of race. I suppose I need to look
>> at some interruptibility state to find
>> out that the interrupt cannot be injected
>> at that time. But I can't find if KVM
>> exports the interruptibility state, other
>> than guest's IF/VIF flag, which is not
>> enough in this case.
> Maybe what you want is run->ready_for_interrupt_injection? And, if
> that's not set, try KVM_RUN with run->request_interrupt_window set?

Good idea, I coded the patch to
check that. It will take some time
to find out the result.


>> Also I am a bit puzzled why I can't
>> see such race on an I7 CPU even
>> after disabling the unrestricted_guest.
>>
>> Any ideas? :)
> I'm guessing that your core2duo doesn't have a VMX preemption timer,
> and this has some subtle effect on how the alarm interrupts VMX
> non-root operation. On the i7, try setting the module parameter
> preemption_timer to 0.

OK, will try that tomorrow.
But why don't you consider the
simpler scenario?

kvm code is full of ctxt->have_exception
vcpu->arch.exception.pending
kvm_queue_exception() and all that.
This all is set up by the emulator
that handles "invalid guest state".
I would much rather believe that emulator
encountered PF and exited to user-space
after "queueing" it.
Does this sound realistic?

