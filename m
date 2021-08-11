Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503373E9808
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 20:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhHKS47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 14:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKS47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 14:56:59 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6AFC061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 11:56:35 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z2so7951525lft.1
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 11:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ScGXpGBVKuemsdnjrMZtpirVRiYqp0nxEwpdjzvAcQc=;
        b=BKzD/phz2V62L+BYy2l6IT1uRjXbNsfEnzJ1FP0i4QNPcJzu7wq5do8D8vcLmOFMdd
         7KpQTTNtf52WOneMY8EYnz8BGgQdqj2Hn1/PyugV0cMwUsu28juY0d7gBj+7y3ap/Yr/
         wbBDtL9syqcrir563sm91vau1YSpqnaTb42w7lyS7D4tUUzvIWRWTiL6mDX8BbNyH+6/
         6bi6aiP5Zmp3R99aKSL7YAvBriWg+BAJBHE+BFjlz2Hbb+1bY+8a49+1+3ekTgERfjHp
         OF7r5f7z69rrUu95q0CIjZuxKjsDyvAJjD6vCEwiKG1XrUAe0CFLx0GFn3FX5zjSO+Sv
         UhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ScGXpGBVKuemsdnjrMZtpirVRiYqp0nxEwpdjzvAcQc=;
        b=cax6XEr/wVhzFmY0PeMwmiE+ChhlkC8k2w1qpuMt/nVBVXunV5pIO9L/f79DiZZnvV
         vl+CfhfsnZ2ylXNrkRSUCwRsn4+WoFN365YuSWA3Nz+V/UTg/loetQrny+kCAZHTgG4G
         CFCFDM8HiVVMZSN7hAYabYf/ak0nPCO99VOLOd5q4+2ZhyEBOPJLAWLD3R/WBU+iAkzR
         n+tbEwCZI7K7cXyVByEUhiWEhtzFONIIr3/J/Jk2y7Un4cFW/ZmhWJRC5vbZF452oFWB
         3yRJ7vek/Y3wHCghltOOkbs1TJLiv/KHw6689vaEZLMjB6Q2Me3pUYNuIbha2nz69l4O
         UQsA==
X-Gm-Message-State: AOAM530HiZx3z8ortNWm0EVsOKlQRhEiFPDZyzs9yqf4ogm/Y3mxqFdS
        4Y1wTFqbbfC19IknYqmK/rZ9az7+tlS8NohYts++ng==
X-Google-Smtp-Source: ABdhPJwGtbhMqHwJKvW91HNOMAe2ToUWMYoIqEwOcawUfgK0gps7jUCiF6LzH6yuRTJPb08sopXFSG2mGtm6DyX1DtU=
X-Received: by 2002:ac2:5fc7:: with SMTP id q7mr183843lfg.524.1628708193196;
 Wed, 11 Aug 2021 11:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com> <927240ff-a4f4-fcc6-ae1b-92cefeda9e59@redhat.com>
In-Reply-To: <927240ff-a4f4-fcc6-ae1b-92cefeda9e59@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 11 Aug 2021 11:56:22 -0700
Message-ID: <CAOQ_Qsjby+z_kU49_s0PDKo5c3V-UD+FRg-2PcPycNq-p2gPVg@mail.gmail.com>
Subject: Re: [PATCH v6 00/21] KVM: Add idempotent controls for migrating
 system counter state
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 6:05 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/08/21 10:57, Oliver Upton wrote:
> > KVM's current means of saving/restoring system counters is plagued with
> > temporal issues. At least on ARM64 and x86, we migrate the guest's
> > system counter by-value through the respective guest system register
> > values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> > brittle as the state is not idempotent: the host system counter is still
> > oscillating between the attempted save and restore. Furthermore, VMMs
> > may wish to transparently live migrate guest VMs, meaning that they
> > include the elapsed time due to live migration blackout in the guest
> > system counter view. The VMM thread could be preempted for any number of
> > reasons (scheduler, L0 hypervisor under nested) between the time that
> > it calculates the desired guest counter value and when KVM actually sets
> > this counter state.
> >
> > Despite the value-based interface that we present to userspace, KVM
> > actually has idempotent guest controls by way of system counter offsets.
> > We can avoid all of the issues associated with a value-based interface
> > by abstracting these offset controls in new ioctls. This series
> > introduces new vCPU device attributes to provide userspace access to the
> > vCPU's system counter offset.
> >
> > Patch 1 addresses a possible race in KVM_GET_CLOCK where
> > use_master_clock is read outside of the pvclock_gtod_sync_lock.
> >
> > Patch 2 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> > ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> > essential for a VMM to perform precise migration of the guest's system
> > counters.
> >
> > Patches 3-4 are some preparatory changes for exposing the TSC offset to
> > userspace. Patch 5 provides a vCPU attribute to provide userspace access
> > to the TSC offset.
> >
> > Patches 6-7 implement a test for the new additions to
> > KVM_{GET,SET}_CLOCK.
> >
> > Patch 8 fixes some assertions in the kvm device attribute helpers.
> >
> > Patches 9-10 implement at test for the tsc offset attribute introduced in
> > patch 5.
>
> The x86 parts look good, except that patch 3 is a bit redundant with my
> idea of altogether getting rid of the pvclock_gtod_sync_lock.  That said
> I agree that patches 1 and 2 (and extracting kvm_vm_ioctl_get_clock and
> kvm_vm_ioctl_set_clock) should be done before whatever locking changes
> have to be done.

Following up on patch 3.

> Time is ticking for 5.15 due to my vacation, I'll see if I have some
> time to look at it further next week.
>
> I agree that arm64 can be done separately from x86.

Marc, just a disclaimer:

I'm going to separate these two series, although there will still
exist dependencies in the selftests changes. Otherwise, kernel changes
are disjoint.

--
Thanks,
Oliver
