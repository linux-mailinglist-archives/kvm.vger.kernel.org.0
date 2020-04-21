Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345891B2EBF
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgDUSIF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 Apr 2020 14:08:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:43840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUSIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:08:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC77FAC6C;
        Tue, 21 Apr 2020 18:08:01 +0000 (UTC)
Date:   Tue, 21 Apr 2020 11:04:35 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, tglx@linutronix.de,
        kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        peterz@infradead.org
Message-ID: <20200421180435.2yyrdndkbqinjmb6@linux-p48b>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

1;5002;0c	torvalds@linux-foundation.org, bigeasy@linutronix.de,
	linux-kernel@vger.kernel.org, rostedt@goodmis.org,
	linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
	joel@joelfernandes.org, will@kernel.org,
	kvmarm@lists.cs.columbia.edu
Bcc:
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
Reply-To:
In-Reply-To: <02e1b00d-a8ea-a947-bbe6-0b1380aa7ec4@redhat.com>

On Tue, 21 Apr 2020, Paolo Bonzini wrote:

>On 20/04/20 23:50, Davidlohr Bueso wrote:
>> On Mon, 20 Apr 2020, Paolo Bonzini wrote:
>>
>>> On 20/04/20 22:56, Davidlohr Bueso wrote:
>>>> On Mon, 20 Apr 2020, Marc Zyngier wrote:
>>>>
>>>>> This looks like a change in the semantics of the tracepoint. Before
>>>>> this
>>>>> change, 'waited' would have been true if the vcpu waited at all. Here,
>>>>> you'd
>>>>> have false if it has been interrupted by a signal, even if the vcpu
>>>>> has waited
>>>>> for a period of time.
>>>>
>>>> Hmm but sleeps are now uninterruptible as we're using TASK_IDLE.
>>>
>>> Hold on, does that mean that you can't anymore send a signal in order to
>>> kick a thread out of KVM_RUN?  Or am I just misunderstanding?
>>
>> Considering that the return value of the interruptible wait is not
>> checked, I would not think this breaks KVM_RUN.
>
>What return value?  kvm_vcpu_check_block checks signal_pending, so you
>could have a case where the signal is injected but you're not woken up.
>
>Admittedly I am not familiar with how TASK_* work under the hood, but it
>does seem to be like that.

I should have looked closer here - I was thinking about the return value
of rcuwait_wait_event. Yes, that signal_pending check you mention makes
the sleep semantics change bogus as interruptible is no longer just to
avoid contributing to the load balance.

And yes, unfortunately adding prepare_to and finish_rcuwait() looks like the
most reasonable approach to keeping the tracepoint semantics. I also considered
extending rcuwait_wait_event() by another parameter to pass back to the caller
if there was any wait at all, but that enlarges the call and is probably less
generic.

I'll send another version keeping the current sleep and tracepoint semantics.

Thanks,
Davidlohr
