Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7C4EAF24
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 16:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiC2OVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 10:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbiC2OVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 10:21:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD68963C6
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 07:19:23 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648563560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gC3hDeP6xDMAGbmPmAwHT/7gHDPuXesaXf648iZZiGY=;
        b=tWyM3W9ZTLiEhs2gEQhON7NDb3u8Ca5xxqMlLWLyUufqna7hbpaP2y+8qEZvJ0VmtY3kKV
        f8Q2X0UjY0QPJmbWeYN4LN4sA7o0WzskkDEiEMZeCBPlnffEHTshLkxPUC6T7RQ0KHdhSD
        2inaSBV1/pbzMMbC9z2i9dTb1Hl2KKLgFoa/gVWsTtCK8VB4m8FbBLyDHpU3zqZHQCeRw0
        qoT57ynscuWRejeVc21EPZy7si0duMGW11CU3UmSxJ2M3NgSSWu9it5yt3DllK6xreD7kv
        ZCas4LzPxAucvrWNvFZVFd2Thb6tmgbgSGJuhOTwoj9Zak0rJm1UWbvVl4i2eQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648563560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gC3hDeP6xDMAGbmPmAwHT/7gHDPuXesaXf648iZZiGY=;
        b=t86PdnCAIQDblWgeBTuO2qSD47WNkL4ZhPQheBjCAxDU3CZuwvJp4QP220r0J4XyOrKBs6
        VWwpSUz3rWYp3BAA==
To:     Oliver Upton <oupton@google.com>, "Franke, Daniel" <dff@amazon.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
In-Reply-To: <YjpFP+APSqjU7fUi@google.com>
References: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
 <YjpFP+APSqjU7fUi@google.com>
Date:   Tue, 29 Mar 2022 16:19:19 +0200
Message-ID: <875ynwg7tk.ffs@tglx>
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

On Tue, Mar 22 2022 at 21:53, Oliver Upton wrote:
> On Tue, Mar 22, 2022 at 07:18:20PM +0000, Franke, Daniel wrote:
>> The KVM_PVCLOCK_STOPPED event should trigger a change in some of the
>> globals kept by kernel/time/ntp.c (which are visible to userspace through
>> adjtimex(2)). In particular, `time_esterror` and `time_maxerror` should get reset
>> to `NTP_PHASE_LIMIT` and time_status should get reset to `STA_UNSYNC`.
>
> I do not disagree that NTP needs to throw the book out after a live
> migration.
>
> But, the issue is how we convey that to the guest. KVM_PVCLOCK_STOPPED
> relies on the guest polling a shared structure, and who knows when the
> guest is going to check the structure again? If we inject an interrupt
> the guest is likely to check this state in a reasonable amount of time.
>
> Thomas, we're talking about how to not wreck time (as bad) under
> virtualization. I know this has been an area of interest to you for a
> while ;-) The idea is that the hypervisor should let the guest know
> about time travel.

Finally. It only took 10+ years of ranting :)

> Let's just assume for now that the hypervisor will *not* quiesce
> the guest into an S2IDLE state before migration. I think quiesced
> migrations are a good thing to have in the toolbelt, but there will
> always be host-side problems that require us to migrate a VM off a host
> immediately with no time to inform the guest.

Quiesced migrations are the right thing on the principle of least
surprise.

> Given that, we're deciding which clock is going to get wrecked during
> a migration and what the guest can do afterwards to clean it up.
> Whichever clock gets wrecked is going to have a window where reads race
> with the eventual fix, and could be completely wrong. My thoughts:
>
> We do not advance the TSC during a migration and notify the
> guest (interrupt, shared structure) about how much it has
> time traveled (delta_REALTIME). REALTIME is wrong until the interrupt
> is handled in the guest, but should fire off all of the existing
> mechanisms for a clock step. Userspace gets notified with
> TFD_TIMER_CANCEL_ON_SET. I believe you have proposed something similar
> as a way to make live migration less sinister from the guest
> perspective.

That still is an information _after_ the fact and not well defined.

> It seems possible to block racing reads of REALTIME if we protect it with
> a migration sequence counter. Host raises the sequence after a migration
> when control is yielded back to the guest. The sequence is odd if an
> update is pending. Guest increments the sequence again after the
> interrupt handler accounts for time travel. That has the side effect of
> blocking all realtime clock reads until the interrupt is handled. But
> what are the value of those reads if we know they're wrong? There is
> also the implication that said shared memory interface gets mapped
> through to userspace for vDSO, haven't thought at all about those
> implications yet.

So you need two sequence counters to be checked similar to the
pv_clock() case, which prevents the usage of TSC without the pv_clock()
overhead.

That also means that CLOCK_REALTIME, CLOCK_TAI and CLOCK_REALTIME_COARSE
will need to become special cased in the VDSO and all realtime based
syscall interfaces.

I'm sure that will be well received from a performance perspective.

Aside of that where do you put the limit? Just user space visible read
outs? What about the kernel? Ignore it in the kernel and hope that
nothing will break? That's going to create really hard to diagnose
issues, which I'm absolutely not interested in.

You can't expand this scheme to the kernel in general because the CPU
which should handle the update might be in an interrupt disabled region
reading clock REALTIME....

Also this would just make the race window smaller. It does not solve the
problem in a consistent way. Don't even think about it. It's just
another layer of duct tape over the existing ones.

As I explained before, this does not solve the following:

   T = now();
   -----------> interruption of some sort (Tout)
   use(T);

Any use case which cares about Tout being less than a certain threshold
has to be carefully designed to handle this. See also below.

> Doing this the other way around (advance the TSC, tell the guest to fix
> MONOTONIC) is fundamentally wrong, as it violates two invariants of the
> monotonic clock. Monotonic counts during a migration, which really is a
> forced suspend. Additionally, you cannot step the monotonic clock.

A migration _should_ have suspend semantics, but the forced suspend
which is done by migration today does not have proper defined semantics
at all.

Also clock monotonic can be stepped forward under certain circumstances
and the kernel is very well able to handle it within well defined
limits. Think about scheduled out vCPUs. From their perspective clock
monotonic is stepping forwards.

The problem starts when the 'force suspended' time becomes excessive, as
that causes the mass expiry of clock monotonic timers with all the nasty
side effects described in a3ed0e4393d6. In the worst case it's going to
exceed the catchup limit of non-suspended timekeeping (~440s for a TSC
@2GHz) which in fact breaks the world and some more.

So let me go back to the use cases:

 1) Regular freeze of a VM to disk and resume at some arbitrary point in
    the future.

 2) Live migration

In both cases the proper solution is to make the guest go into a well
defined state (suspend) and resume it on restore. Everything just works
because it is well defined.

Though you say that there is a special case (not that I believe it):

> but there will always be host-side problems that require us to migrate
> a VM off a host immediately with no time to inform the guest.

which is basically what we do today for the very wrong reasons. There you
have two situations:

  1) Trestart - Tstop < TOLERABLE_THRESHOLD

     That's the easy case as you just can adjust TSC on restore by that
     amount on all vCPUs and be done with it. Just works like scheduling
     out all vCPUs for some time.

  2) Trestart - Tstop >= TOLERABLE_THRESHOLD

     Avoid adjusting TSC for the reasons above. That leaves you with the
     options of

     A) Make NTP unhappy as of today

     B) Provide information about the fact that the vCPUs got scheduled
        out for a long time and teach NTP to be smart about it.

        Right now NTP decides to declare itself unstable when it
        observes the time jump on CLOCK_REALTIME from the NTP server.

        That's exactly the situation described above:

        T = now();
        -----------> interruption of some sort (Tout)
        use(T);

        NTP observes that T is inconsistent because it does not know
        about Tout due to the fact that neither clock MONOTONIC nor
        clock BOOTTIME advanced.

        So here is where you can bring PV information into play by
        providing a migration sequence number in PV shared memory.

        On source host:
           Stop the guest dead in it's tracks.
           Record metadata:
             - migration sequence number
             - clock TAI as observed on the host
           Transfer the image along with metadata

        On destination host:
           Restore memory image
           Expose metadata in PV:
             - migration sequence number + 1
             - Tout (dest/source host delta of clock TAI)
           Run guest

        Guest kernel:

           - Keep track of the PV migration sequence number.

             If it changed act accordingly by injecting the TAI delta,
             which updates NTP state, wakes TFD_TIMER_CANCEL_ON_SET,
             etc...

             We have to do that in the kernel because we cannot rely on
             NTP being running.

             That can be an explicit IPI injected from the host or just
             polling from the tick. It doesn't matter much.

           - Expose information to user space:
               - Migration sequence counter

           - Add some smarts to adjtimex() to prevent user space racing
             against a pending migration update in the kernel.

        NTP:
           - utilize the sequence counter information 

             seq = get_migration_sequence();

             do stuff();
        
             if (seq != get_migration_sequence())
             	do_something_smart();
             else
                proceed_as_usual();

        That still will leave everything else exposed to
        CLOCK_REALTIME/TAI jumping forward, but there is nothing you can
        do about that and any application which cares about this has to
        be able to deal with it anyway.

Hmm?

Thanks,

        tglx
