Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7761C3FF44A
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 21:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhIBTms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 15:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhIBTmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 15:42:47 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD44C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 12:41:48 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id g14so5660700ljk.5
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 12:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADrMhTmPrgZbNnM++pu1uoBNav1T6vaZhzMfabX6fg8=;
        b=hO5FKzGplclg/n5vIngJvh6FKIQEXfVeBPrT6JowB2p5Ecz0xWFtPqVmDg/wE1QXjt
         xo+GELyqZ0PZgrgCgSvNKjVyo63+tYKZOotWClNQYtoMAOjByiKzcCSMDiYy8w6Yct05
         2C4nGmqs8SM0fk5maL5+R4jbU/DLMCY0c4hI1nYTCjOUnlNfbts5uZtQ3nGzDfBiqRwp
         mkQrSouEqQhavMgpc37b4Z+iBlJWbpRd/oE3b9gbw4T/iK0UWO6W07ErDgbMJA5n5XxW
         9gADtevCBdTeQImZ6PPBxw2lW2sZ3V4xtJHKHuwh28zQ2jlkXwwqjOezg/4UkLnCOy8Q
         DyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADrMhTmPrgZbNnM++pu1uoBNav1T6vaZhzMfabX6fg8=;
        b=g0zth7DnbIy1Pr22X8TglKbT6j2EW/M0jTQgTFa6ZbIhNwai4ouelexwUhD4MJn7AF
         dVsdGCno/GlfhmzjBnnEBnIxvUIbRC7JPQUlorVA5yVO6zXvYDjpjyqUb0eKLg/WrbwZ
         PJEM7Ptjk+H/QBhgtD3Nr8aCJdMld1EacYmq6KBUNs2kDI+rkSwW6DXsamBdAhSq2Xfb
         npTAc0nUinSwPImfzmRxw2dvJiXMLhksQNwEd5VIGrxJO+m6vaeC5HYdEK5Y5wnReHkS
         hasLAk1RhmNJxGg59ADUrgxT0ae5x1IP0CGG/lFLkLb3PFitXCtyUUEYB7CIS1NYvSzg
         TXgg==
X-Gm-Message-State: AOAM531DvBouSjgHAQQJmQEX4o4uoKcouW0EHQzXJziHVDMXH99TyE9E
        iL0NnopidnM+6dRVP/8KKp//dC1cmV7+4G2KZ4a/lg==
X-Google-Smtp-Source: ABdhPJyPSRz4pY8zwxiiI7e+q4TcAiErfRzU01m5EtpNay3AZ3717xZk6GJsBJZFBVgzI+rrjERJLrroUnk4yHnGBJo=
X-Received: by 2002:a2e:9615:: with SMTP id v21mr3776932ljh.22.1630611705984;
 Thu, 02 Sep 2021 12:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com> <20210816001130.3059564-6-oupton@google.com>
 <YTEkRfTFyoh+HQyT@google.com>
In-Reply-To: <YTEkRfTFyoh+HQyT@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 2 Sep 2021 12:41:33 -0700
Message-ID: <CAOQ_QsjP65fq5+Mc0xP-wejpjugYNxCFOhEecwFhKaDdxDGUJw@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] KVM: x86: Refactor tsc synchronization code
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
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 2, 2021 at 12:21 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Aug 16, 2021, Oliver Upton wrote:
> > Refactor kvm_synchronize_tsc to make a new function that allows callers
> > to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
> > for the sake of participating in TSC synchronization.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> > +     struct kvm *kvm = vcpu->kvm;
> > +     bool already_matched;
> > +
> > +     lockdep_assert_held(&kvm->arch.tsc_write_lock);
> > +
> > +     already_matched =
> > +            (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
> > +
>
> ...
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
> > +             kvm->arch.cur_tsc_generation++;
> > +             kvm->arch.cur_tsc_nsec = ns;
> > +             kvm->arch.cur_tsc_write = tsc;
> > +             kvm->arch.cur_tsc_offset = offset;
> > +
> > +             spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> > +             kvm->arch.nr_vcpus_matched_tsc = 0;
> > +     } else if (!already_matched) {
> > +             spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> > +             kvm->arch.nr_vcpus_matched_tsc++;
> > +     }
> > +
> > +     kvm_track_tsc_matching(vcpu);
> > +     spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
>
> This unlock is imbalanced if matched and already_matched are both true.  It's not
> immediately obvious that that _can't_ happen, and if it truly can't happen then
> conditionally locking is pointless (because it's not actually conditional).
>
> The previous code took the lock unconditionally, I don't see a strong argument
> to change that, e.g. holding it for a few extra cycles while kvm->arch.cur_tsc_*
> are updated is unlikely to be noticable.

We may have gone full circle here :-) You had said it was confusing to
hold the lock when updating kvm->arch.cur_tsc_* a while back. I do
still agree with that sentiment, but the conditional locking is odd.

> If you really want to delay taking the locking, you could do
>
>         if (!matched) {
>                 kvm->arch.cur_tsc_generation++;
>                 kvm->arch.cur_tsc_nsec = ns;
>                 kvm->arch.cur_tsc_write = data;
>                 kvm->arch.cur_tsc_offset = offset;
>         }
>
>         spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
>         if (!matched)
>                 kvm->arch.nr_vcpus_matched_tsc = 0;
>         else if (!already_matched)
>                 kvm->arch.nr_vcpus_matched_tsc++;
>         spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);

This seems the most readable, making it clear what is guarded and what
is not. I'll probably go this route.

--
Thanks,
Oliver
