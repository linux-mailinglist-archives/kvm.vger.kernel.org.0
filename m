Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43904E563F
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 17:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiCWQXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 12:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiCWQXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 12:23:03 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810BA6E8E2
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 09:21:33 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id z6so2333666iot.0
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 09:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4N4f2kqMt6aSFm1V0Ap+fXBWktjxTNcae8aDTJMwFQw=;
        b=g/DfNDhHQyAVTKyQA3X022da7pKxyhMZrxFDwywmc7xjD+TQPHIWbDfJqiU0jdmF2J
         KYycb9LsX386oVX7uhIReoxq6KK/ep6ZUmzWMXR8bXMDbFYOsDSKaunJgNdx0ixhPEzz
         PsnFut9WcUeZy+LkBzOPgv8elbpCyJGWkJCXyU0KNqHIici6TJPYY8nx7oX8v6DHSFgg
         e/qaHiznwJdVGEr5q5boeCp8M/Fv4ZUfkm5c0Hr/2eIzWmQWTStpZ+0m9P0JQf2Ojae+
         qDDJF3JivpL9qq5q/RZahsj4OSjnV1wCIhvIyu9PtoR+PSpjZXTTgFeT/bLjzov/VsgA
         NXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4N4f2kqMt6aSFm1V0Ap+fXBWktjxTNcae8aDTJMwFQw=;
        b=zp7Kt+DM41/LzamYjwvlw0088mt6jUyskW5fZu9CMiS1aE09GLfLrxykXiH8vlnnwJ
         xHDlZa7qwUAG41+Nb0S12wrS+isdYYk2Fwpk8erVXU8QJcrJkESat2EPNhvsxDBF8fBH
         XwDJYfAySxADZx7qzePoaQ033ycYhS5OkiiwG/uZV62JRbe8c3SFoxnHsy1Y8acD0s0l
         5TryS6XnP8stX9XziKywEIMT4EoGWfg+NeTYRRs6xNqnbqeeHIoAMKNqrnz67lZ3C4mn
         qmh99W7FbD3UCv3guRDdGwtjDR+N/EZ2Cc+32eYFdUQecppoN7LFp+4G5G0Rar1x7f7k
         j1eQ==
X-Gm-Message-State: AOAM530KsDtlGk3Pxlyx/MBmdg/iOXyqqlvMur8HdqaU268qplwA9Isj
        Ra2RLJJDKM+cIz0fEzwFc+RP5Q==
X-Google-Smtp-Source: ABdhPJwUg4HhlXyE/vBCv/uEv82asnis0brQpwzWooIAd7SolbuVakOHCskK5Dnz8vccnam3kwoPFw==
X-Received: by 2002:a6b:fd0c:0:b0:645:d261:ba25 with SMTP id c12-20020a6bfd0c000000b00645d261ba25mr470995ioi.124.1648052492635;
        Wed, 23 Mar 2022 09:21:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id v1-20020a92d241000000b002c82ba9d58esm217843ilg.9.2022.03.23.09.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 09:21:31 -0700 (PDT)
Date:   Wed, 23 Mar 2022 16:21:28 +0000
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
Message-ID: <YjtJCDvLAXphkxhK@google.com>
References: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
 <YjpFP+APSqjU7fUi@google.com>
 <9fe6ac14df519ca8df42d3a7fd54ee0c49c58922.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fe6ac14df519ca8df42d3a7fd54ee0c49c58922.camel@infradead.org>
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

On Wed, Mar 23, 2022 at 12:35:17PM +0000, David Woodhouse wrote:
> On Tue, 2022-03-22 at 21:53 +0000, Oliver Upton wrote:
> > But what happens to CLOCK_MONOTONIC in this case? We are still accepting
> > the fact that live migrations destroy CLOCK_MONOTONIC if we directly
> > advance the guest TSCs to account for elapsed time. The definition of
> > CLOCK_MONOTONIC is that the clock does not count while the system is
> > suspended. From the viewpoint of the guest, a live migration appears to
> > be a forced suspend operation at an arbitrary instruction boundary.
> > There is no realistic way for the guest to give the illusion that
> > MONOTONIC has stopped without help from the hypervisor.
> 
> I'm a little lost there. CLOCK_MONOTONIC is *permitted* to stop when
> the guest is suspended, but it's not *mandatory*, surely?
> 
> I can buy your assertion that the brownout period of a live migration
> (or the time for the host kernel to kexec in the case of live update) 
> can be considered a suspend... but regardless of whether that makes it
> mandatory to stop the clocks, I prefer to see it a different way. 
> 
> In normal operation — especially with CPU overcommit and/or throttling
> — there are times when none of the guest's vCPUs will be scheduled for
> short periods of time. We don't *have* to stop CLOCK_MONOTONIC when
> that happens, do we?
> 

You're absolutely right. We've at least accepted MONOTONIC behaving the
way it does for time lost to host scheduling, and expose this through
steal_time for the guest scheduler.

> If we want live migration to be guest-transparent, shouldn't we treat
> is as much as possible as one of those times when the vCPUs just happen
> not to be running for a moment?

There is still a subtle difference between host scheduler pressure and
live migration. Its hard to crisply state whether or not the VM is
actually suspended, as any one of its vCPU threads could actually be
running. Migration is one of those events where we positively know the
guest isn't running at all.

> On a live update, where the host does a kexec and then resumes the
> guest state, the host TSC reference is precisely the same as before the
> upate. We basically don't want to change *anything* that the guest sees
> in its pvclock information. In fact, we have a local patch to
> 'KVM_SET_CLOCK_FROM_GUEST' for the live update case, which ensures
> exactly that. We then add a delta to the guest TSC as we create each
> vCPU in the new KVM; the *offset* interface would be beneficial to us
> here (since that offset doesn't change) but we're not using it yet.
> 
> For live migration, the same applies — we can just add a delta to the
> clock and the guest TSC values, commensurate with the amount of
> wallclock time that elapsed from serialisation on the source host, to
> deserialisation on the destination.
> 
> And it all looks *just* like it would if the vCPUs happened not to be
> scheduled for a little while, because the host was busy.

We could continue to get away with TSC advancement, but the critical
part IMO is the upper bound. And what happens when we exceed it.

There is no authoritative documentation around what time looks like as a
guest of KVM, and futhermore what happens when a guest experiences time
travel. Now we're in a particularly undesirable situation where there
are at least three known definitions for time during a migration
(upstream QEMU, Google, Amazon) and it is ~impossible to program guest
software to anticipate our shenanigans.

If we are to do this right we probably need to agree on documented
behavior. If we decide that advancing TSCs is acceptable up to 'X'
seconds, guest kernels could take a change to relax expectations at
least up to this value.

> > > The KVM_PVCLOCK_STOPPED event should trigger a change in some of the
> > > globals kept by kernel/time/ntp.c (which are visible to userspace through
> > > adjtimex(2)). In particular, `time_esterror` and `time_maxerror` should get reset
> > > to `NTP_PHASE_LIMIT` and time_status should get reset to `STA_UNSYNC`.
> > 
> > I do not disagree that NTP needs to throw the book out after a live
> > migration.
> > 
> > But, the issue is how we convey that to the guest. KVM_PVCLOCK_STOPPED
> > relies on the guest polling a shared structure, and who knows when the
> > guest is going to check the structure again? If we inject an interrupt
> > the guest is likely to check this state in a reasonable amount of time.
> 
> Ah, but that's the point. A flag in shared memory can be checked
> whenever the guest needs to know that it's operating on valid state.
> Linux will check it *every* time from pvclock_clocksource_read().
> 
> As opposed to a separate interrupt which eventually gets processed some
> indefinite amount of time in the future.

There are a few annoying things with pvclock, though. It is a per-vCPU
structure, so special care must be taken to act exactly once on a
migration. Also, since commit 7539b174aef4 ("x86: kvmguest: use TSC
clocksource if invariant TSC is exposed") the guest kernel could pick
the TSC over the pvclock by default, so its hard to say when the pvclock
structure is checked again. This is what I had in mind when suggesting a
doorbell is needed, as there is no good way to know what clocksource the
guest is using.

> > Doing this the other way around (advance the TSC, tell the guest to fix
> > MONOTONIC) is fundamentally wrong, as it violates two invariants of the
> > monotonic clock. Monotonic counts during a migration, which really is a
> > forced suspend. Additionally, you cannot step the monotonic clock.
> > 
> I dont understand why we can't "step the monotonic clock". Any time
> merely refrain from scheduling the vCPUs for any period of time, that
> is surely indistinguishable from a "step" in the monotonic clock,
> surely?

Right, there is some nebulous threshold that we've defined as an
acceptable amount of time to 'step' the monotonic clock. I think that
everything to date is built around the assumption that it is a small
amount of time of O(timeslice). Pinning down the upper bound should at
least make clocks more predictable on virtualization.

> > Sorry to revisit this conversation yet again. Virtualization isn't going
> > away any time soon and the illusion that migrations are invisible to the
> > guest is simply not true.
> 
> I'll give you the assertion that migrations aren't completely
> invisible, but I still think they should be *equivalent* to the vCPU
> just not being scheduled for a moment.

I sure hope that migrations are fast enough that it is indistinguishable
from scheduler pressure. I think the situations where that is not the
case are particularly interesting. Defining a limit and having a
mechanism for remedial action could make things more predictable for
guest software.

But agree, and shame on us for the broken virtual hardware when that
isn't the case :-)

--
Thanks,
Oliver

