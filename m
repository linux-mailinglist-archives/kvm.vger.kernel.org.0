Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286063A1FC2
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 00:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhFIWHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 18:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhFIWHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 18:07:21 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10373C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 15:05:11 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id bn21so1857929ljb.1
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 15:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vr2tBHks9ZBBCNjLgkmwbQ5QJI5NTkstZNlpt1qagU=;
        b=RazSI0IwVhztNcLYGcPLLoPrHxs2ar0yzXkSt3W6WGNGHWsMxpJaYTP9NEIf6ASgJD
         N6Xgux5HtSGOaStAc84anHQxcgAs56eTPw9jpK4ydrlZeKyX4t/8YQVhbbKMbhof5KWS
         Ns9NY239sKswxxVTeGkN08ZvrlVTwKBnmr/WMZ6qPDpE4SWF3b5lUWDPWPmh+8Bm8MSP
         tsD5RzDj/reVH08U1gTRd2MuyXPSdAbEklEEIwBJM0NdSJEjEaMBrSxx2W/YqZyIn0ZM
         CV/Ysyyj7fo8/VEc+j6Dx3+RWx3v5jyXudO4vsI9CeTMxPHXHFDJLLFHBzjQU650cMku
         86Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vr2tBHks9ZBBCNjLgkmwbQ5QJI5NTkstZNlpt1qagU=;
        b=CKojx1HHcpwsDKOx+xOPp5dYbyYgDErX6rn3wK9nSbCOdmuXUPlOZ5IlSG3djaulr2
         P4/g3nm6rYjXShUflzOu4uvlXfj8I5zPn1lA6FdhpXi7zrS63XJ7rgZUY4x9CCl4+qGk
         HyOAB9slKqnsLRjF1n3bpaW1ksARvgDYgOu8kT6BVIRCidGMqEbBEqwwsC41Hyh4KEH6
         txJphb9uLE0BMWGPn4MC3ZezBK8M9IM5/DVk5e2P71TBZQoEmGFU2Exh0Lp90BCBVqSI
         cJf+3uJ2NtEcmDrlS384caizAB9Xsq9VUY4sR/MaQAmtXeQai0aAdc2Ibjt6xBgftFTp
         clFA==
X-Gm-Message-State: AOAM5334Ir3nEpL4MuPWqt3uaYrCP1hwSGUQx7cAamtxUHch1cokKeSL
        YDcP3HpI4rdKzA2gnNeJ5Vb8p+L7EGr96C4jVSQgLA==
X-Google-Smtp-Source: ABdhPJy7amfMMNI9BVqffQnd2f3UaNboqUWX2CbIPWkfwsMGpwMQKSYrxM7Q52wynbMbN8j1smXqh5iad9xOhKETNx4=
X-Received: by 2002:a2e:7d0f:: with SMTP id y15mr1404039ljc.388.1623276309082;
 Wed, 09 Jun 2021 15:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com> <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com> <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
In-Reply-To: <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 9 Jun 2021 17:04:57 -0500
Message-ID: <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 9, 2021 at 12:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/06/21 17:11, Oliver Upton wrote:
> > Perhaps this will clarify the motivation for my approach: what if the
> > kernel wasn't the authoritative source for wall time in a system?
> > Furthermore, VMMs may wish to define their own heuristics for counter
> > migration (e.g. we only allow the counter to 'jump' by X seconds
> > during migration blackout). If a VMM tried to assert its whims on the
> > TSC state before handing it down to the kernel, we would inadvertently
> > be sampling the host counter twice again. And, anything can happen
> > between the time we assert elapsed time is within SLO and KVM
> > computing the TSC offset (scheduling, L0 hypervisor preemption).
> >
> > So, Maxim's changes would address my concerns in the general case, but
> > maybe not as much in edge cases where an operator may make decisions
> > about how much time can elapse while the guest hasn't had CPU time.
>
> I think I understand.  We still need a way to get a consistent
> (host_TSC, nanosecond) pair on the source, the TSC offset is not enough.
>   This is arguably not a KVM issue, but we're still the one having to
> provide a solution, so we would need a slightly more complicated interface.

Ah, right, good luck doing that without some help from the kernel. +1
to this _not_ being a KVM issue, but anyways...

> 1) In the kernel:
>
> * KVM_GET_CLOCK should also return kvmclock_ns - realtime_ns and
> host_TSC.  It should set two flags in struct kvm_clock_data saying that
> the respective fields are valid.
>
> * KVM_SET_CLOCK checks the flag for kvmclock_ns - realtime_ns.  If set,
> it looks at the kvmclock_ns - realtime_ns field and disregards the
> kvmclock_ns field.

Yeah, these additions all make sense to me.

>
> 2) On the source, userspace will:
>
> * per-VM: invoke KVM_GET_CLOCK.  Migrate kvmclock_ns - realtime_ns and
> kvmclock_ns.  Stash host_TSC for subsequent use.
>
> * per-vCPU: retrieve guest_TSC - host_TSC with your new ioctl.  Sum it
> to the stashed host_TSC value; migrate the resulting value (a guest TSC).
>
> 3) On the destination:
>
> * per-VM: Pass the migrated kvmclock_ns - realtime_ns to KVM_SET_CLOCK.
>   Use KVM_GET_CLOCK to get a consistent pair of kvmclock_ns ("newNS"
> below) and host TSC ("newHostTSC").  Stash them for subsequent use,
> together with the migrated kvmclock_ns value ("sourceNS") that you
> haven't used yet.
>
> * per-vCPU: using the data of the previous step, and the sourceGuestTSC
> in the migration stream, compute sourceGuestTSC + (newNS - sourceNS) *
> freq - newHostTSC.  This is the TSC offset to be passed to your new ioctl.
>
> Your approach still needs to use the "quirky" approach to host-initiated
> MSR_IA32_TSC_ADJUST writes, which write the MSR without affecting the
> VMCS offset.  This is just a documentation issue.

I think I follow what you're saying. To confirm:

My suggested ioctl for the vCPU will still exist, and it will still
affect the VMCS tsc offset, right? However, we need to do one of the
following:

- Stash the guest's MSR_IA32_TSC_ADJUST value in the
kvm_system_counter_state structure. During
KVM_SET_SYSTEM_COUNTER_STATE, check to see if the field is valid. If
so, treat it as a dumb value (i.e. show it to the guest but don't fold
it into the offset).
- Inform userspace that it must still migrate MSR_IA32_TSC_ADJUST, and
continue to our quirky behavior around host-initiated writes of the
MSR.

This is why Maxim's spin migrated a value for IA32_TSC_ADJUST, right?
Doing so ensures we don't have any guest-observable consequences due
to our migration of TSC state. To me, adding the guest IA32_TSC_ADJUST
MSR into the new counter state structure is probably best. No strong
opinions in either direction on this point, though :)

--
Thanks,
Oliver

>
> Does this make sense?
>
> Paolo
>
