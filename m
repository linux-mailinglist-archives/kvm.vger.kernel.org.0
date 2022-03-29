Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C9A4EB426
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 21:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbiC2TgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 15:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiC2TgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 15:36:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FB45D18E
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 12:34:16 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648582454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPTYv8oZoZk/pXXJmyyCi5d1/1rNE6WDpyTpsQnrolg=;
        b=Xw0oqvh9VEvhGT3zLsv/z/ZsEiCFSPpeN6bQH8PuYklikmf0IDZCsliMBzwsYXbpW6zf3w
        ArTfHrZ3MrGMM4hTK1BFzLwhO6N+aw9+tpVMSdMwpXfmjgzv5KstnK87PJA5TmqtdDLIE9
        x/aMwq6iVBpuGgzV12IaHgJEDX9vW89HJj2V0HdLo3gWSnBU+OXQ+lz6wzjsNfYN6FQqFa
        0RfS7ZFQukg2GdtM9bp6iMmDKklFVqbMZt7AyHl/ynyGGVj0Br2/6o7Op/gxJktfX0nHUz
        2g/rzjW61Ozr4aKdIxX7kQm4fw0SmzzcbfAZbCFhG/loQcSdPyc8z6epyibMzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648582454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPTYv8oZoZk/pXXJmyyCi5d1/1rNE6WDpyTpsQnrolg=;
        b=TQSuKq5qrPKHW4z80aYWk/f6fmtnuIbSdLb02zp9DEZwb4LcwswYCh2g8YmxJHwnw1Sd7L
        991zNClnKyBKh1DQ==
To:     Oliver Upton <oupton@google.com>
Cc:     "Franke, Daniel" <dff@amazon.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
In-Reply-To: <CAOQ_QsgDY0oeS0kU62MWMWj9JR3mKfU_p=MC7kto=LX5tQ2PPA@mail.gmail.com>
References: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
 <YjpFP+APSqjU7fUi@google.com> <875ynwg7tk.ffs@tglx>
 <CAOQ_QsgDY0oeS0kU62MWMWj9JR3mKfU_p=MC7kto=LX5tQ2PPA@mail.gmail.com>
Date:   Tue, 29 Mar 2022 21:34:13 +0200
Message-ID: <87sfr0eeoa.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oliver,

On Tue, Mar 29 2022 at 09:02, Oliver Upton wrote:
> On Tue, Mar 29, 2022 at 7:19 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> > Doing this the other way around (advance the TSC, tell the guest to fix
>> > MONOTONIC) is fundamentally wrong, as it violates two invariants of the
>> > monotonic clock. Monotonic counts during a migration, which really is a
>> > forced suspend. Additionally, you cannot step the monotonic clock.
>>
>> A migration _should_ have suspend semantics, but the forced suspend
>> which is done by migration today does not have proper defined semantics
>> at all.
>>
>> Also clock monotonic can be stepped forward under certain circumstances
>> and the kernel is very well able to handle it within well defined
>> limits. Think about scheduled out vCPUs. From their perspective clock
>> monotonic is stepping forwards.
>>
>
> Right. For better or worse, the kernel has been conditioned to
> tolerate small steps due to scheduling. There is just zero definition
> around how much slop is allowed.

From the experience with the MONO=BOOT experiment, I'd say anything < 1
second is unlikely to cause larger trouble, but there might be user
space applications/configurations which disagree :)

>> The problem starts when the 'force suspended' time becomes excessive, as
>> that causes the mass expiry of clock monotonic timers with all the nasty
>> side effects described in a3ed0e4393d6. In the worst case it's going to
>> exceed the catchup limit of non-suspended timekeeping (~440s for a TSC
>> @2GHz) which in fact breaks the world and some more.
>>
>> So let me go back to the use cases:
>>
>>  1) Regular freeze of a VM to disk and resume at some arbitrary point in
>>     the future.
>>
>>  2) Live migration
>>
>> In both cases the proper solution is to make the guest go into a well
>> defined state (suspend) and resume it on restore. Everything just works
>> because it is well defined.
>>
>> Though you say that there is a special case (not that I believe it):
>
> I believe the easier special case to articulate is when the hypervisor
> has already done its due diligence to warn the guest about a
> migration. Guest doesn't heed the warning and doesn't quiesce. The
> most predictable state at this point is probably just to kill the VM
> on the spot, but that is likely to be a _very_ tough sell :)

I'm all for it. It's very well defined.

> So assuming that it's still possible for a non-cooperative suspend
> (live migration, VM freeze, etc.) there's still a need to stop the
> bleeding. I think you touch on what that may look like:
>
>>   1) Trestart - Tstop < TOLERABLE_THRESHOLD
>>
>>      That's the easy case as you just can adjust TSC on restore by that
>>      amount on all vCPUs and be done with it. Just works like scheduling
>>      out all vCPUs for some time.
>>
>>   2) Trestart - Tstop >= TOLERABLE_THRESHOLD
>>
>>      Avoid adjusting TSC for the reasons above.
>
> Which naturally will prompt the question: what is the value of
> TOLERABLE_THRESHOLD? Speaking from experience (Google already does
> something similar, but without a good fallback for exceeding the
> threshold), there's ~zero science in deriving that value. But, IMO if
> it's at least documented we can make the shenanigans at least a bit
> more predictable. It also makes it very easy to define who
> (guest/host) is responsible for cleaning up the mess.

See above, but the hyperscalers with experience on heavy host overload
might have better information when keeping a vCPU scheduled out starts
to create problems in the guest.

> In absence of documentation there's an unlimited license for VM
> operators to do as they please and I fear we will forever perpetuate
> the pain of time in virt.

You can prevent that, by making 'Cooperate within time or die hard' the
policy. :)

>>              if (seq != get_migration_sequence())
>>                 do_something_smart();
>>              else
>>                 proceed_as_usual();
>
> Agreed pretty much the whole way through. There's no point in keeping
> NTP naive at this point.
>
> There's a need to sound the alarm for NTP regardless of whether
> TOLERABLE_THRESHOLD is exceeded. David pointed out that the host
> advancing the guest clocks (delta injection or TSC advancement) could
> inject some error. Also, hardware has likely changed and the new parts
> will have their own errors as well.

There is no reason why you can't use the #2 scheme for the #1 case
too:

>>         On destination host:
>>            Restore memory image
>>            Expose metadata in PV:
>>              - migration sequence number + 1

                - Flag whether Tout was compensated already via
                  TSC or just set Tout = 0

>>              - Tout (dest/source host delta of clock TAI)
>>            Run guest
>>
>>         Guest kernel:
>>
>>            - Keep track of the PV migration sequence number.
>>
>>              If it changed act accordingly by injecting the TAI delta,
>>              which updates NTP state, wakes TFD_TIMER_CANCEL_ON_SET,
>>              etc...

                if it was compensated via TSC already, it might be
                sufficient to just reset NTP state.

>>         NTP:
>>            - utilize the sequence counter information
                ....

OTOH, the question is whether it's worth it.

If we assume that the sane case is a cooperative guest and the forced
migration is the last resort, then we can just avoid the extra magic and
the discussion around the correct value for TOLERABLE_THRESHOLD
alltogether.

I suggest to start from a TOLERABLE_THRESHOLD=0 assumption to keep it
simple in the first step. Once this has been established, you can still
experiment with the threshold and figure out whether it matters.

In fact, doing the host side TSC compensation is just an excuse for VM
operators not to make the guest cooperative, because it might solve
their main problems for the vast majority of migrations.

Forcing them to doing it right is definitely the better option, which
means the 'Cooperate or die hard' policy is the best one you can
chose. :)

>>         That still will leave everything else exposed to
>>         CLOCK_REALTIME/TAI jumping forward, but there is nothing you can
>>         do about that and any application which cares about this has to
>>         be able to deal with it anyway.
>
> Right. There's no cure-all between hypervisor/guest kernel that could
> fix the problem for userspace entirely.

In the same way as there is no cure for time jumps caused by
settimeofday(), daylight saving changes, leap seconds etc., unless the
application is carefully designed to deal with that.

> Appreciate you chiming in on this topic yet again.

I still hope that this get's fixed _before_ I retire :)

Thanks,

        tglx
