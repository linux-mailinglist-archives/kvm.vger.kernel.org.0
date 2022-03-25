Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB514E7BEA
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiCYT3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 15:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiCYT27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 15:28:59 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B571EDA31
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 12:02:56 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bc27so7162873pgb.4
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 12:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=H89JS/8JQtajA1uj5y1Vc5ETBZypgWbs3bQvjVl+VwQ=;
        b=jHCsi+edTq2UV2ylEQSfdblND7OyHqnRmpqAs8ByzONl27cklVLBULiwZ54LSy5Yad
         7sDF+m3VAN2A6D7XXzHhNoMVFlH2VRIdGYRZTsywuyumQHFFsPHgieGItVHThQHz2WK3
         0SpMwdEHkQGMQWPDiqjQ9r/umpt2qIauqlPJYmmR6NXug46fcuMZGTnOQQa/WY1KXWYS
         kSDbYlaeYPQ7YGA15Jz833MA6KrrUZfz4S5weGNXj7PuujoGtbaQzA0h7ql19Sqa6qiW
         ddzD8X3l4LbBhOIp8mszw5YoBoWWLx1x5adQN7XQ/drPSThykgQUpMuZIdAy+0ysPljo
         WJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=H89JS/8JQtajA1uj5y1Vc5ETBZypgWbs3bQvjVl+VwQ=;
        b=CvQvBUodbC2H+j3atjiWQ6CJHS9EVLSPT0TVtBbCgXK4s1MYtMCJgc6GiCNy1pE/wA
         c9aQ2d23Z56EyhH+PIAr2g9XeWpYwIr5vt6t5nkEwAMOcicW5pmrqH+oodwwbPOrCXMT
         dUtg5x0UAi9Ll/1dkpmQLrwbTeQKF0S9NbHyVbCLgFf71uKMHIbiHSokvzIY4DD2rTMN
         GOm4XsWWlzpFo3J5apfY44TA6IGum/l0ftTwoyZLvQg6ouDfyPA7yoRrsbOByqlA79F9
         hoZquGLbbjyUeeINv/vtxUxj0BgT0Y+pPa4xFJoKrBVNd8yrwytQCYwRfmZczrQUIvla
         yLyA==
X-Gm-Message-State: AOAM5304SU2QIQzPlxEQ0nZOTKDIdA9gSvXOIJXm/7/UglIyMtAwWfTc
        nQ7vMkbLFWAhJFc9L51IVGV3fKTf3KXhxQ==
X-Google-Smtp-Source: ABdhPJxZiQ3qg8giMVquv+I7ZUHxLxtuZdO/N2hIT4j3tB0DZPhRV7aYsGEx/a8rMCoDZTwZpJ5xyw==
X-Received: by 2002:a6b:750c:0:b0:641:3b39:7b24 with SMTP id l12-20020a6b750c000000b006413b397b24mr6503889ioh.139.1648230441423;
        Fri, 25 Mar 2022 10:47:21 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id z11-20020a92cd0b000000b002c85ac49d2asm3158168iln.79.2022.03.25.10.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 10:47:20 -0700 (PDT)
Date:   Fri, 25 Mar 2022 17:47:17 +0000
From:   Oliver Upton <oupton@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "Franke, Daniel" <dff@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Message-ID: <Yj4AJRcg9His0rMf@google.com>
References: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
 <YjpFP+APSqjU7fUi@google.com>
 <9fe6ac14df519ca8df42d3a7fd54ee0c49c58922.camel@infradead.org>
 <YjtJCDvLAXphkxhK@google.com>
 <2dd68865688a0a3d49501598f524bcc63ded7b08.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2dd68865688a0a3d49501598f524bcc63ded7b08.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 25, 2022 at 09:03:50AM +0000, David Woodhouse wrote:
> On Wed, 2022-03-23 at 16:21 +0000, Oliver Upton wrote:
> > On Wed, Mar 23, 2022 at 12:35:17PM +0000, David Woodhouse wrote:
> > > And it all looks *just* like it would if the vCPUs happened not to be
> > > scheduled for a little while, because the host was busy.
> > 
> > We could continue to get away with TSC advancement, but the critical
> > part IMO is the upper bound. And what happens when we exceed it.
> > 
> > There is no authoritative documentation around what time looks like as a
> > guest of KVM, and futhermore what happens when a guest experiences time
> > travel. Now we're in a particularly undesirable situation where there
> > are at least three known definitions for time during a migration
> > (upstream QEMU, Google, Amazon) and it is ~impossible to program guest
> > software to anticipate our shenanigans.
> > 
> > If we are to do this right we probably need to agree on documented
> > behavior. If we decide that advancing TSCs is acceptable up to 'X'
> > seconds, guest kernels could take a change to relax expectations at
> > least up to this value.
> 
> I'm not sure I even buy this line of argument at all. I don't think of
> it as 'TSC advancement'. Or maybe I should put that the other way
> round: TSCs advance *all* the time; that's the whole point in them. 

The only reason I use the term 'TSC advancement' is to account for the
fact that the guest probably feels *very* differently about what the
advancement time actually is. The world around it has continued onwards
while it was out.

> All we do when we live-migrate is move the state from one host to
> another, completely intact. From the guest point of view we don't
> "advance" the TSC; we just set the guest TSC on the destination host to
> precisely¹ the same value that the guest TSC on the source host would
> have at that moment if we were to abort the migration and do a
> rollback. Either way (rollback or not), the vCPUs weren't *running* for
> a period of time, but time and TSCs are entirely the same.
> 
> In fact, on live update we literally *don't* change anything that the
> guest sees. The pvclock information that the guest gets is *precisely*
> the same as before, and the TSC has 'advanced' purely by nature of
> being precisely the same CPU just a short period of time in the
> future... because that's what TSCs do when time passes :)
> 
> Really, we aren't talking about a "maximum advancement of the TSC".
> We're talking about a "maximum period for which the vCPUs aren't
> scheduled".

But that is all built on the assumption that a guest is actually
being *live* migrated. That is entirely a userspace decision, and IMO we
can't glean what the VMM is trying to do just based on how it calls
the KVM APIs.

The only thing we know for certain is the guest state is serialized.
Where that data goes and how long it takes to be acted upon is none of
our business in the kernel.

> And I don't see why there need to be documented hard limits on that. I
> see it as a quality of implementation issue. If the host is in swap
> death and doesn't manage to run the guest vCPUs for seconds at a time,
> that's fairly crappy, but it's not strictly a *timekeeping* issue. And
> it's just the same if the final transition period of live migration (or
> the kexec time for live update) is excessive.

Serializing a VM to persistent storage and resuming it at a later date
is a completely valid use of the KVM APIs. Sure, if the guest goes down
for that long during a live migration then it has every right to scream
at the entity running the VM, but I would argue there are more
lifecycles outside of what our businesses typically do.

> > > > > The KVM_PVCLOCK_STOPPED event should trigger a change in some of the
> > > > > globals kept by kernel/time/ntp.c (which are visible to userspace through
> > > > > adjtimex(2)). In particular, `time_esterror` and `time_maxerror` should get reset
> > > > > to `NTP_PHASE_LIMIT` and time_status should get reset to `STA_UNSYNC`.
> > > > 
> > > > I do not disagree that NTP needs to throw the book out after a live
> > > > migration.
> > > > 
> 
> Right. To recap, this is because where I highlighted 'precisely¹'
> above, our accuracy is actually limited to the synchronisation of the
> wallclock time between the two hosts. If the guest thinks it has a more
> accurate NTP sync than either of the hosts do, we may have introduced
> an error which is more than the error bounds the guest thinks it has,
> and that may ultimately lead to data corruption in some circumstances.

Agreed. And on top of that I would state the guest is likely running on
a different oscillator with its own set of problems since we switched out
the underlying hardware. NTP would need to rediscipline the clock even
if the migration somehow bends our understanding of reality and happens
in zero time.

> This part is somewhat orthogonal to the above discussion, isn't it?
> Regardless of whether we 'step' the TSC or not, we need to signal the
> guest to know that it needs to consider itself unsynchronized (or, if
> we want to get really fancy, let it know the upper bounds of the error
> we just introduced. But let's not).

Right, whatever signal we add should be asserted regardless of whether
the TSCs kept ticking while the guest is out. If there is going to be a
shared structure/message/whatever that conveys delta_REALTIME, you could
just set it to zero if the hypervisor decided to handle time on its own.

> > > > But, the issue is how we convey that to the guest. KVM_PVCLOCK_STOPPED
> > > > relies on the guest polling a shared structure, and who knows when the
> > > > guest is going to check the structure again? If we inject an interrupt
> > > > the guest is likely to check this state in a reasonable amount of time.
> > > 
> > > Ah, but that's the point. A flag in shared memory can be checked
> > > whenever the guest needs to know that it's operating on valid state.
> > > Linux will check it *every* time from pvclock_clocksource_read().
> > > 
> > > As opposed to a separate interrupt which eventually gets processed some
> > > indefinite amount of time in the future.
> > 
> > There are a few annoying things with pvclock, though. It is a per-vCPU
> > structure, so special care must be taken to act exactly once on a
> > migration. Also, since commit 7539b174aef4 ("x86: kvmguest: use TSC
> > clocksource if invariant TSC is exposed") the guest kernel could pick
> > the TSC over the pvclock by default, so its hard to say when the pvclock
> > structure is checked again.
> 
> That commit appears to be assuming that the TSC *will* be "stepped", or
> as I call it "continue to advance normally at its normal frequency over
> elapsed time".

Maybe? The author's intent isn't the reason I cared about that commit. It
means we will not detect PVCLOCK_GUEST_STOPPED synchronously with any
clock read, and I imagine we're rather concerned about those reads until
the clock is refined. sched clock would probably be the one to find out.

And sure, changing the clocksource away from the pvclock may not be the
right call if we are going to use it to enlighten NTP, I just feel the
commit above codified that it isn't user error.

> >  This is what I had in mind when suggesting a doorbell is needed, as
> > there is no good way to know what clocksource the guest is using.
> 
> Yes, perhaps that might be necessary.
> 
> The concern is that by the time that doorbell interrupt has finally
> been delivered and processed, an inaccurate timestamp could *already*
> have been used on the wire in the some application's coherency
> protocol, and the guest's database could already be hosed.

Unless you get that software into a known-safe instruction boundary,
who's to say you haven't migrated the guest between the clock read
and eventual packet out to the world? The timestamp would be
pre-blackout.

There's also nothing to prevent any agent within the guest from reading
the clock before NTP refinement comes in. We don't block clock reads on
PVCLOCK_GUEST_STOPPED.

> But I don't see why we can't have both.  I think it makes sense for the
> guest kernel to ditch its NTP sync when it sees PVCLOCK_GUEST_STOPPED,
> but I'm not entirely averse to the existence of a doorbell mechanism
> such as you describe.

Sure, there's nothing stopping us from setting off the alarms when that
bit is set. But:

 - It isn't as helpful for guests using the TSC
 - It does not prevent guest kernel or userspace from getting completely
   wrong clock reads in the interim

Given this, I'm convinced there is significant room for improvement as
there is a significant window of time during which we really wish the
guest to not use its wall clock.

> > > I'll give you the assertion that migrations aren't completely
> > > invisible, but I still think they should be *equivalent* to the vCPU
> > > just not being scheduled for a moment.
> > 
> > I sure hope that migrations are fast enough that it is indistinguishable
> > from scheduler pressure. I think the situations where that is not the
> > case are particularly interesting. Defining a limit and having a
> > mechanism for remedial action could make things more predictable for
> > guest software.
> > 
> > But agree, and shame on us for the broken virtual hardware when that
> > isn't the case :-)
> 
> Right. The "how to tell the guest that it needs to ditch its NTP sync
> status" question needs some more thought
>
> but in the short term I think
> it makes sense to add get/set TSC mechanisms which work like
> KVM_[SG]ET_CLOCK with the KVM_CLOCK_REALTIME flag.
> 
> Instead of realtime though, it should use the KVM clock. So reading a
> TSC returns a { kvm_ns, TSC value } tuple, and setting it will advance
> the value by the appropriate amount just as we advance the KVM clock
> for the KVM_CLOCK_REALTIME delta.

I'm all ears for changes to the TSC mechanisms, I just feel rather
strongly that it needs to support all possible use cases, not just live
migration. Further, KVM doesn't know what userspace is doing and I really
hope that userspace knows what userspace is doing.

If it does, maybe that's the right place to decide how to bend reality.
If we fully commit to KVM advancing clocks for an unbounded amount of
time then there needs to be a *giant* disclaimer for the case of pulling
a VM out of cold storage. Writing back exactly what you saved will in all
likelihood detonate the guest.

I just think it is highly desirable that anything we get upstream is
actually usable by upstream. Even though the hyperscalers only care about
situations where we're likely to immediately resume the guest, there are
other use cases to think about. The TSC offset attributes fit the
immediate interests of my employer, but was only halfway there for
upstream. I'd like to do right on that, because hopefully then I'm not
the only person testing it.

--
Thanks,
Oliver
