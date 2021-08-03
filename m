Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7323DF6CA
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 23:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhHCVSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 17:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhHCVSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 17:18:41 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01425C061757
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 14:18:30 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y34so831152lfa.8
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 14:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ta6l2xXWDT9u5jccv96eXJ1qjXmVTPggm0wilGcpdVs=;
        b=BdE9W00YEuXqcEPUPfUmVzyU+jcHWH+410m74a1ncOOtdr5zirV7UEplYvEhtLPMre
         WaJruCdCQxginzPDCczLWu89yDppye3VsjFTRRvJx0YL9OFa5tRmy2fIQWJ12YlcZfY1
         kTufqa+cc2M7lKqhQemENjDHf1CRXAyT9ZktXCzVoIaVNxD0D6KRIOYOCg1zIh1b4Jwp
         2R3NiFWyLNR200i/dmGmjfDVaVGGG2CBL5Dh7GGv1K/XTgQCvRBZ/38jnpkv0bTShWe6
         UR72L1IOHGOyCrNc7ttsTvZYbgs4gvGld1YdPhKmDauqAZ/glfLv0vhV5gYwXRnmBPjC
         8s3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ta6l2xXWDT9u5jccv96eXJ1qjXmVTPggm0wilGcpdVs=;
        b=ek1kcdFNHTA6wyJaOGKauc62Im0b823SrcPag2cwg25ghsSD7bPhQ3h2gpFvZG/AYM
         9lTYJZUAGJg+W5Mrl4CvE2R4r2UHCRRQXsgTDtV/9kANYr4blyO9uDOr5VXDRvvfZMrk
         MF35SdNqHCQzJCfNceHfEFaJJDx4n82b1W8in4plOW5NoX2fuOkwK+VUvxGxphUe+CVu
         nCyDJuM6VamEpMED7r/ljMNtOKyj10AXndMZwbzngizlYIaqztQ8gZTof/WRGR7qhA5A
         k5Rjm5QNFBf4fN19Sd1772beg2eCUDkRRvkjdhJYPaQjBNZJIN0yMtitfYdm7lvsPbzk
         FcaA==
X-Gm-Message-State: AOAM5335YqmHgGCQ6kiftMFzArQlGC+erenTiXxOluWTsHm8DfVHKikp
        I0+lVG+nlMpXi7tXADu0ns3A/fBGyASKTVc4OW0yuA==
X-Google-Smtp-Source: ABdhPJxHnayzG6ipEbIowb4o96jcK4d1APZCmmGvNA676lxtxxTmkXjlKp38rlwEV12gMG1y7qkziiPC0bhMql6xLi8=
X-Received: by 2002:ac2:57cd:: with SMTP id k13mr147309lfo.117.1628025508018;
 Tue, 03 Aug 2021 14:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com> <20210729173300.181775-3-oupton@google.com>
 <YQRAGSJ1PxwXA2m/@google.com>
In-Reply-To: <YQRAGSJ1PxwXA2m/@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 3 Aug 2021 14:18:17 -0700
Message-ID: <CAOQ_Qsiko1U4ZQPuSkxQtzxZ_PVvW7JCMoBvY06uMoNrVSjj+g@mail.gmail.com>
Subject: Re: [PATCH v5 02/13] KVM: x86: Refactor tsc synchronization code
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 11:08 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 29, 2021, Oliver Upton wrote:
> > Refactor kvm_synchronize_tsc to make a new function that allows callers
> > to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
> > for the sake of participating in TSC synchronization.
> >
> > This changes the locking semantics around TSC writes.
>
> "refactor" and "changes the locking semantics" are somewhat contradictory.  The
> correct way to do this is to first change the locking semantics, then extract the
> helper you want.  That makes review and archaeology easier, and isolates the
> locking change in case it isn't so safe after all.

Indeed, it was mere laziness doing so :)

> > Writes to the TSC will now take the pvclock gtod lock while holding the tsc
> > write lock, whereas before these locks were disjoint.
> >
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> > +/*
> > + * Infers attempts to synchronize the guest's tsc from host writes. Sets the
> > + * offset for the vcpu and tracks the TSC matching generation that the vcpu
> > + * participates in.
> > + *
> > + * Must hold kvm->arch.tsc_write_lock to call this function.
>
> Drop this blurb, lockdep assertions exist for a reason :-)
>

Ack.

> > + */
> > +static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
> > +                               u64 ns, bool matched)
> > +{
> > +     struct kvm *kvm = vcpu->kvm;
> > +     bool already_matched;
>
> Eww, not your code, but "matched" and "already_matched" are not helpful names,
> e.g. they don't provide a clue as to _what_ matched, and thus don't explain why
> there are two separate variables.  And I would expect an "already" variant to
> come in from the caller, not the other way 'round.
>
>   matched         => freq_matched
>   already_matched => gen_matched

Yeah, everything this series touches is a bit messy. I greedily
avoided the pile of cleanups that are needed, but alas...

> > +     spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
>
> I believe this can be spin_lock(), since AFAICT the caller _must_ disable IRQs
> when taking tsc_write_lock, i.e. we know IRQs are disabled at this point.

Definitely.


>
> > +     if (!matched) {
> > +             /*
> > +              * We split periods of matched TSC writes into generations.
> > +              * For each generation, we track the original measured
> > +              * nanosecond time, offset, and write, so if TSCs are in
> > +              * sync, we can match exact offset, and if not, we can match
> > +              * exact software computation in compute_guest_tsc()
> > +              *
> > +              * These values are tracked in kvm->arch.cur_xxx variables.
> > +              */
> > +             kvm->arch.nr_vcpus_matched_tsc = 0;
> > +             kvm->arch.cur_tsc_generation++;
> > +             kvm->arch.cur_tsc_nsec = ns;
> > +             kvm->arch.cur_tsc_write = tsc;
> > +             kvm->arch.cur_tsc_offset = offset;
>
> IMO, adjusting kvm->arch.cur_tsc_* belongs outside of pvclock_gtod_sync_lock.
> Based on the existing code, it is protected by tsc_write_lock.  I don't care
> about the extra work while holding pvclock_gtod_sync_lock, but it's very confusing
> to see code that reads variables outside of a lock, then take a lock and write
> those same variables without first rechecking.
>
> > +             matched = false;
>
> What's the point of clearing "matched"?  It's already false...

None, besides just yanking the old chunk of code :)

>
> > +     } else if (!already_matched) {
> > +             kvm->arch.nr_vcpus_matched_tsc++;
> > +     }
> > +
> > +     kvm_track_tsc_matching(vcpu);
> > +     spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
> > +}
> > +

--
Thanks,
Oliver
