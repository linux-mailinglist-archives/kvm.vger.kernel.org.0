Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B64E3F4893
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 12:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbhHWKW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 06:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbhHWKWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 06:22:24 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D976C061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 03:21:42 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso3292024otv.12
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 03:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SIoAG5g2ZaKJiQFYiR9SaO4E6gipkwSLQl5y4hOcarA=;
        b=gQR9xHDtBAfQ7agjkTp8NRtgfMZgp2tWmaTnwwDFtYUsSn8xoqh6FWO8lKEH3dgIuS
         lkoW4/+4SJ9dv9HEpfZFner4olxP4FJAYRyQAsSO+0ymOU7G9QKsaZ8UM0CtBIZ2N+XQ
         VM7BZVS4yQiUtU8oTJ4isjKYO4sTIprNB3aeykLN+cKzcbaHjcGvRFL+YjMoHNxtLgtj
         JdZARJ3RqzKvlbg+uoY1AccFAi6C7ginCERt4SFjHQ1B0EKnYV9lH+UXtdpR3YBoNByY
         9OdmFDtiqd4UAhNw5Sr4lQQ95igvDB9B5Mht/F40M8tUtFqho0gwwnIpzRq3duSkYYTT
         b00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SIoAG5g2ZaKJiQFYiR9SaO4E6gipkwSLQl5y4hOcarA=;
        b=NKO4J9pOl+TgmQfh7D20Pgzf2sgRiEayunEDITN2rIx3knvWjuWwOLO5cH90vecHWT
         pZHQkqAD6fyGWeX1LpCuhfYaS267Gi0wyaOF6qpxG7vgO23m0E9zGEyvt/w+/B3LTciE
         e1fkCcXuzlqgg871Zk417KR9g/K/SgVPyqx/ftTlQGxLqSyjT1R0sEED1Aloj6nnJVHb
         mYDa3yIwyny8QMjYrYf2c2pWZOIPoN37/VIqE4GqIJEQJQUAn5eFOn6fa6m6X+03ZAWl
         llwAcynRBlcPxkIbqeYkAZNe/Fe14UCknpu3TfUpilk5xf1yjdpwRo4afWzxrXE6rckl
         EHnA==
X-Gm-Message-State: AOAM532SnrazXW1O8CabgY//f8Cr1OQEdX5j+T1MSs8RhspZV35vFcXq
        M6s1YMpavF9f1u4HGx8znHaGVgI0tCieIeKO99xs1A==
X-Google-Smtp-Source: ABdhPJxVB/BIKUm3PHO6SrY9hnhKeihrCixbwenNombX7S3W6PJqEJkNgrfQet45jdjnvWcG2w43uFrI7fLY/KRecvc=
X-Received: by 2002:a9d:309:: with SMTP id 9mr27312697otv.365.1629714101736;
 Mon, 23 Aug 2021 03:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com> <20210817081134.2918285-12-tabba@google.com>
 <87fsv6snup.wl-maz@kernel.org> <87zgtdqz77.wl-maz@kernel.org>
In-Reply-To: <87zgtdqz77.wl-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Mon, 23 Aug 2021 11:21:05 +0100
Message-ID: <CA+EHjTwyC-ZMpKQWGPqqYGHHR+YvyG3cdaxdwJfmYYf7XbBWEw@mail.gmail.com>
Subject: Re: [PATCH v4 11/15] KVM: arm64: Guest exit handlers for nVHE hyp
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Aug 19, 2021 at 3:36 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, 18 Aug 2021 17:45:50 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Tue, 17 Aug 2021 09:11:30 +0100,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > Add an array of pointers to handlers for various trap reasons in
> > > nVHE code.
> > >
> > > The current code selects how to fixup a guest on exit based on a
> > > series of if/else statements. Future patches will also require
> > > different handling for guest exists. Create an array of handlers
> > > to consolidate them.
> > >
> > > No functional change intended as the array isn't populated yet.
> > >
> > > Acked-by: Will Deacon <will@kernel.org>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/include/hyp/switch.h | 43 +++++++++++++++++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/switch.c        | 33 +++++++++++++++++++
> > >  2 files changed, 76 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > index a0e78a6027be..5a2b89b96c67 100644
> > > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > @@ -409,6 +409,46 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> > >     return true;
> > >  }
> > >
> > > +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> >
> > This returns an int...
> >
> > > +
> > > +exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
> > > +
> > > +static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
> > > +{
> > > +   return is_nvhe_hyp_code() ? kvm_get_nvhe_exit_handler(vcpu) : NULL;
> > > +}
> > > +
> > > +/*
> > > + * Allow the hypervisor to handle the exit with an exit handler if it has one.
> > > + *
> > > + * Returns true if the hypervisor handled the exit, and control should go back
> > > + * to the guest, or false if it hasn't.
> > > + */
> > > +static bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu)
> > > +{
> > > +   bool is_handled = false;
> >
> > ... which you then implicitly cast as a bool.
> >
> > > +   exit_handle_fn exit_handler = kvm_get_hyp_exit_handler(vcpu);
> > > +
> > > +   if (exit_handler) {
> > > +           /*
> > > +            * There's limited vcpu context here since it's not synced yet.
> > > +            * Ensure that relevant vcpu context that might be used by the
> > > +            * exit_handler is in sync before it's called and if handled.
> > > +            */
> > > +           *vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
> > > +           *vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> > > +
> > > +           is_handled = exit_handler(vcpu);
> >
> > What does 'is_handled' mean here? By definition, any trap *must* be
> > handled, one way or another. By the look of it, what you really mean
> > is something like "I have updated the vcpu state and you'd better
> > reload it". Is that what it means?
> >
> > > +
> > > +           if (is_handled) {
> > > +                   write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> > > +                   write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> > > +           }
> > > +   }
> > > +
> > > +   return is_handled;
> > > +}
> >
> > All these functions really should be marked inline. Have you checked
> > how this expands on VHE? I think some compilers could be pretty
> > unhappy about the undefined symbol in kvm_get_hyp_exit_handler().
> >
> > It is also unfortunate that we get a bunch of tests for various
> > flavours of traps (FP, PAuth, page faults...), only to hit yet another
> > decoding tree. Is there a way we could use this infrastructure for
> > everything?
>
> I realised that I wasn't very forthcoming here. I've decided to put
> the code where my mouth is and pushed out a branch [1] with your first
> 10 patches, followed by my own take on this particular problem. It
> compiles, and even managed to boot a Debian guest on a nVHE box.
>
> As you can see, most of the early exit handling is now moved to
> specific handlers, unifying the handling. For the protected mode, you
> can provide your own handler array (just hack
> kvm_get_exit_handler_array() to return something else), which will do
> the right thing as long as you call into the existing handlers first.
> When it comes to the ELR/SPSR handling, it is better left to the
> individual handlers (which we already do in some cases, see how we
> skip instructions, for example).
> Please let me know what you think.

Thanks a lot for this and sorry for being late to reply. I've been travelling.

I think that your proposal looks great. All handling is consolidated
now and handling for protected VMs can just be added on top. There are
some small issues with what parameters we need (e.g., passing struct
kvm to kvm_get_exit_handler_array), but I will sort them out and
submit them in the next round.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pkvm-fixed-features
>
> --
> Without deviation from the norm, progress is not possible.
