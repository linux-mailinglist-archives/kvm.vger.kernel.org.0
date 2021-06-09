Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE913A17F4
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbhFIOyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237146AbhFIOyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 10:54:14 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA08C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 07:52:05 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id e2so192388ljk.4
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 07:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J4uqZat43uXQvNOJTycrnSDnl08RIvJWttyNK5Ek/y8=;
        b=CnZXh4kHjTx7xzwkiaOAmy6w5zVWdF9I7OMYc2MeamT4FBJcxWhk4ZxsvP3iAKRd0E
         JIim2I1xEV4q0gsNORNvPQPjaCwf2dieYPoj7voiuY4/U4lF7Z88RVSwIt4TUs/6bG6h
         5uHWDdj1Y/Nlsi8oG6ivfWIsZEUNED8MLbfV8tM/D6Om9ZUNjkn3snaoYrJr4uIiLT5G
         UqA37LNR0HHSABqmq/Eo7QAVW7989ErxHRajxq7SJhhjRz2a/Li+mhfj2tSaT3Xwg4/a
         ya/gBgN+q+aVYEcz3wkNQO06NZZl8WCAvdSuRnFLdV9ZYBxuwbBro+0uEmyfD6QTVWvx
         jgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J4uqZat43uXQvNOJTycrnSDnl08RIvJWttyNK5Ek/y8=;
        b=TgqoVWGEhFM86wB0WJZbydfXFId6OC10DHKQ6ACy9aMciSDKa4GG+ZI0JPCpRgEhF2
         5CXSAeNdfl57mwfTzHqSVqG3yUfh2hMFM8SLToQ55qORScnWot8t9q8SY3fOHMi6bKYF
         9d9TqLL+t3olREAmqXSqDtOYOvEQBZJTP1t68JCj4PVnFwrPoqh+aKo0ZkctNWrf3OJT
         Yv9ZajrfxSU4zVYHkcRpSAHcCjqky9M/zFnhagXVg82ipAAoH4kWEXTW5LOVxx3jI04N
         ll2kPm+Tcf19BVvrSuXoqSbY5eQ0JsrvXitneHMyywunNQj5Iw1IOMSf44YcLZytaLji
         bJVQ==
X-Gm-Message-State: AOAM531MjvulU5jL4n9Nv+4x3BrU1so/ITKgCwN8HQlxGeJwpX2rfhi1
        bt+rLGdqG8gu5icb1FJL4kPwziaMDDVrc4fju/kasQ==
X-Google-Smtp-Source: ABdhPJwtEy715cts9tm9X8JTlBt0diCbht9bovQ7EqpFFv+TmmL+DAqN6jgcAGII2MOGq/hEEtGudbEoe7Zf41meHZw=
X-Received: by 2002:a05:651c:304:: with SMTP id a4mr251806ljp.331.1623250322933;
 Wed, 09 Jun 2021 07:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com> <20210608214742.1897483-3-oupton@google.com>
 <877dj3z68p.wl-maz@kernel.org>
In-Reply-To: <877dj3z68p.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 9 Jun 2021 09:51:51 -0500
Message-ID: <CAOQ_QsgobctkqS5SQdqGaM-vjH7685zGPdDXZpcOCS8xWJxegA@mail.gmail.com>
Subject: Re: [PATCH 02/10] KVM: arm64: Implement initial support for KVM_CAP_SYSTEM_COUNTER_STATE
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 9, 2021 at 5:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> Please Cc the KVM/arm64 reviewers (now added). Also, please consider
> subscribing to the kvmarm mailing list so that I don't have to
> manually approve your posts ;-).

/facepalm

Thought I had done this already. Re-requested to join kvmarm@. Seems
that gmail politely decided the mailing list was spam, so no
confirmation email came through.

> On Tue, 08 Jun 2021 22:47:34 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > ARMv8 provides for a virtual counter-timer offset that is added to guest
> > views of the virtual counter-timer (CNTVOFF_EL2). To date, KVM has not
> > provided userspace with any perception of this, and instead affords a
> > value-based scheme of migrating the virtual counter-timer by directly
> > reading/writing the guest's CNTVCT_EL0. This is problematic because
> > counters continue to elapse while the register is being written, meaning
> > it is possible for drift to sneak in to the guest's time scale. This is
> > exacerbated by the fact that KVM will calculate an appropriate
> > CNTVOFF_EL2 every time the register is written, which will be broadcast
> > to all virtual CPUs. The only possible way to avoid causing guest time
> > to drift is to restore counter-timers by offset.
>
> Well, the current method has one huge advantage: time can never go
> backward from the guest PoV if you restore what you have saved. Yes,
> time can elapse, but you don't even need to migrate to observe that.
>
> >
> > Implement initial support for KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
> > to migrate the value of CNTVOFF_EL2. These ioctls yield precise control
> > of the virtual counter-timers to userspace, allowing it to define its
> > own heuristics for managing vCPU offsets.
>
> I'm not really in favour of inventing a completely new API, for
> multiple reasons:
>
> - CNTVOFF is an EL2 concept. I'd rather not expose it as such as it
>   becomes really confusing with NV (which does expose its own CNTVOFF
>   via the ONE_REG interface)

Very true. At least on x86, there's a fair bit of plumbing to handle
the KVM-owned L0 offset reg and the guest-owned L1 offset reg.

> - You seem to allow each vcpu to get its own offset. I don't think
>   that's right. The architecture defines that all PEs have the same
>   view of the counters, and an EL1 guest should be given that
>   illusion.

Agreed. I would have preferred a VM-wide ioctl to do this, but since
x86 explicitly allows for drifted TSCs that can't be the case in a
generic ioctl. I can do the same broadcasting as we do in the case of
a VMM write to CNTVCT_EL0.

> - by having a parallel save/restore interface, you make it harder to
>   reason about what happens with concurrent calls to both interfaces
>
> - the userspace API is already horribly bloated, and I'm not overly
>   keen on adding more if we can avoid it.

Pssh. My ioctl numbers aren't _too_ close to the limit ;-)

>
> I'd rather you extend the current ONE_REG interface and make it modal,
> either allowing the restore of an absolute value or an offset for
> CNTVCT_EL0. This would also keep a consistent behaviour when restoring
> vcpus. The same logic would apply to the physical offset.
>
> As for how to make it modal, we have plenty of bits left in the
> ONE_REG encoding. Pick one, and make that a "relative" attribute. This
> will result in some minor surgery in the get/set code paths, but at
> least no entirely new mechanism.

Yeah, it'd be good to do it w/o adding new plumbing. The only reason
I'd considered it is because x86 might necessitate it. Not wanting to
apply bad convention to other arches, but keeping at least a somewhat
consistent UAPI would be nice.

> One question though: how do you plan to reliably compute the offset?
> As far as I can see, it is subject to the same issues you described
> above (while the guest is being restored, time flies), and you have
> the added risk of exposing a counter going backward from a guest
> perspective.

Indeed, we do have the risk of time going backwards, but I'd say that
the VMM shares in the responsibility to provide a consistent view of
the counter too.

Here's how I envisioned it working:

Record the time, cycles, and offset (T0, C0, Off0) when saving the
counter state. Record time and cycles (T1, C1) again when trying to
restore counter state. Compute the new offset:

Off1 = Off0 - (T1-T0) * CNTFRQ - (C0 - C1).

The primary concern here is idempotence. Once Off1 is calculated, it
doesn't matter how much time elapses between the calculation and the
call into KVM, it will always produce the intended result. If instead
we restore the counters by-value (whilst trying to account for elapsed
time), my impression is that we'd do the following: Record time and
guest counter (T0, G0) when saving counter state. Record time again
when trying to restore counter state.

In userspace, compute the time elapsed and fold it into the guest counter (G1):

G1 = G0 + (T1-T0) * CNTFRQ

And then in the kernel:

CNTVOFF = G1 - CNTPCT

Any number of things can happen in between the kernel and userspace
portions of this operation, causing some drift of the VM's counter.
Fundamentally I suppose the issue we have is that we sample the host
counter twice (T1, G1), when really we'd want to only do so once.

So, open to any suggestions where we avoid the issue of causing the
guest counter to drift, offsets only seemed to be the easiest thing
given that they ought to be constant for the lifetime of a VM on a
host and is the backing state used by hardware.

--
Thanks,
Oliver

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
