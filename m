Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A947241F617
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 21:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354825AbhJAUBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 16:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354638AbhJAUBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 16:01:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAE6C0613E4
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 12:59:29 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633118367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tRAIlcEEJZVysiJv4SYaZZ2qA/sm4dvQ1Zi2vUF4Xzc=;
        b=2aMhS6jeVE2n90XIKeN47DGDf5FQ1yK32beWgJ9j9/xS7WfqUFNhV9HKvPr6x032udNAuu
        HC2LiWtsbnoEkN34L3SYoN/rJRIQRjlZXq7a/y/jigGu2elxEhW3hYgEWv39y97sWWPRZp
        bjLnxsreivRBz/aSsZzBrCkObsp9moaMRS/5ynHrcGwISA0UmwfkdB/W8EDu+X0iQfSvNJ
        ZFQycPtH1KFH7AE9q/WL2JZ3IxAwRjHeUGCzq6FXChglR9sAcyxyjuCIMerOmJwR1gdnP6
        Cr1eu+68aC7d9EVk1CACcliHZgDyR5rmoQ82sXXpeetUo0JN4UljO3sye069Wg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633118367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tRAIlcEEJZVysiJv4SYaZZ2qA/sm4dvQ1Zi2vUF4Xzc=;
        b=gzevmohru7/BMPKfeBRLN+A4CtQVR9jD0az7kYHWw+iHYyZs+jE+81wgotG6DlFJ0kH/on
        8CEAvFWSk3nY5SBg==
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
In-Reply-To: <20211001120527.GA43086@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <20210929185629.GA10933@fuller.cnet> <20210930192107.GB19068@fuller.cnet>
 <871r557jls.ffs@tglx> <20211001120527.GA43086@fuller.cnet>
Date:   Fri, 01 Oct 2021 21:59:26 +0200
Message-ID: <87ilyg4iu9.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marcelo,

On Fri, Oct 01 2021 at 09:05, Marcelo Tosatti wrote:
> On Fri, Oct 01, 2021 at 01:02:23AM +0200, Thomas Gleixner wrote:
>> But even if that would be the case, then what prevents the stale time
>> stamps to be visible? Nothing:
>> 
>> T0:    t = now();
>>          -> pause
>>          -> resume
>>          -> magic "fixup"
>> T1:    dostuff(t);
>
> Yes.
>
> BTW, you could have a userspace notification (then applications 
> could handle this if desired).

Well, we have that via timerfd with TFD_TIMER_CANCEL_ON_SET for
CLOCK_REALTIME. That's what applications which are sensitive to clock
REALTIME jumps use today.

>>   Now the proposed change is creating exactly the same problem:
>> 
>>   >> > +	if (data.flags & KVM_CLOCK_REALTIME) {
>>   >> > +		u64 now_real_ns = ktime_get_real_ns();
>>   >> > +
>>   >> > +		/*
>>   >> > +		 * Avoid stepping the kvmclock backwards.
>>   >> > +		 */
>>   >> > +		if (now_real_ns > data.realtime)
>>   >> > +			data.clock += now_real_ns - data.realtime;
>>   >> > +	}
>> 
>>   IOW, it takes the time between pause and resume into account and
>>   forwards the underlying base clock which makes CLOCK_MONOTONIC
>>   jump forward by exactly that amount of time.
>
> Well, it is assuming that the
>
>  T0:    t = now();
>  T1:    pause vm()
>  T2:	finish vm migration()
>  T3:    dostuff(t);
>
> Interval between T1 and T2 is small (and that the guest
> clocks are synchronized up to a given boundary).

Yes, I understand that, but it's an assumption and there is no boundary
for the time jump in the proposed patches, which rings my alarm bells :)

> But i suppose adding a limit to the forward clock advance 
> (in the migration case) is useful:
>
> 	1) If migration (well actually, only the final steps
> 	   to finish migration, the time between when guest is paused
> 	   on source and is resumed on destination) takes too long,
> 	   then too bad: fix it to be shorter if you want the clocks
> 	   to have close to zero change to realtime on migration.
>
> 	2) Avoid the other bugs in case of large forward advance.
>
> Maybe having it configurable, with a say, 1 minute maximum by default
> is a good choice?

Don't know what 1 minute does in terms of applications etc. You have to
do some experiments on that.

> An alternative would be to advance only the guests REALTIME clock, from 
> data about how long steps T1-T2 took.

Yes, that's what would happen in the cooperative S2IDLE or S3 case when
the guest resumes.

>> So now virt came along and created a hard to solve circular dependency
>> problem:
>> 
>>    - If CLOCK_MONOTONIC stops for too long then NTP/PTP gets out of
>>      sync, but everything else is happy.
>>      
>>    - If CLOCK_MONOTONIC jumps too far forward, then all hell breaks
>>      lose, but NTP/PTP is happy.
>
> One must handle the
>
>  T0:    t = now();
>           -> pause
>           -> resume
>           -> magic "fixup"
>  T1:    dostuff(t);
>
> fact if one is going to use savevm/restorevm anyway, so...
> (it is kind of unfixable, unless you modify your application
> to accept notifications to redo any computation based on t, isnt it?).

Well yes, but what applications can deal with is CLOCK_REALTIME jumping
because that's a property of it. Not so much the CLOCK_MONOTONIC part.

>> If you decide that correctness is overrated, then please document it
>> clearly instead of trying to pretend being correct.
>
> Based on the above, advancing only CLOCK_REALTIME (and not CLOCK_MONOTONIC)
> would be correct, right? And its probably not very hard to do.

Time _is_ hard to get right. 

So you might experiment with something like this as a stop gap:

  Provide the guest something like this:

          u64		   migration_seq;
          u64      	   realtime_delta_ns;

  in the shared clock page

  Do not forward jump clock MONOTONIC.

  On resume kick an IPI where the guest handler does:

         if (clock_data->migration_seq == migration_seq)
         	return;

         migration_seq = clock_data->migration_seq;

         ts64 = { 0, 0 };
         timespec64_add_ns(&ts64, clock_data->realtime_delta_ns);
         timekeeping_inject_sleeptime64(&ts64);

  Make sure that the IPI completes before you migrate the guest another
  time or implement it slightly smarter, but you get the idea :)

That's what we use for suspend time injection, but it should just work
without frozen tasks as well. It will forward clock REALTIME by the
amount of time spent during migration. It'll also modify the BOOTTIME
offset by the same amount, but that's not a tragedy.

The function will also reset NTP state so the NTP/PTP daemon knows that
there was a kernel initiated time jump and it can work out easily what
to do like it does on resume from an actual suspend. It will also
invoke clock_was_set() which makes all the other time related updates
trigger and wakeup tasks which have a timerfd with
TFD_TIMER_CANCEL_ON_SET armed.

This will obviously not work when the guest is in S2IDLE or S3, but for
initial experimentation you can ignore that and just avoid to do that in
the guest. :)

That still is worse than a cooperative S2IDLE/S3, but it's way more
sensible than the other two evils you have today.

> Thanks very much for the detailed information! Its a good basis
> for the document you ask.

I volunteer to review that documentation once it materializes :)

Thanks,

        tglx
