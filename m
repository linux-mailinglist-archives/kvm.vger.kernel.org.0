Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4465250A87A
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391593AbiDUSxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391552AbiDUSxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:53:40 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FC14C401
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:50:49 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2ec42eae76bso62032357b3.10
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SCveG505PM0eS4oBerBuk8CsCGSzSfCcKji+8XOvNE0=;
        b=YVMhd2GdKPqj5XRaHBO6N/nswQFtI7i9d4QbnTiuK4aCbwsWsiG8ZFmX6GOl6MhkAV
         o+AhQ0ZvhniV8nr6agpx70BJa740lqEWylQZvshC4Gw2JtW6ZjD2qYclDeSdv89qrZ6l
         WIOhjihx0hhk+bsAg98Ju15YA6ahSA8mwhlpK1yNgcyLmxzR14X97Q+2JNkELqArkQ0P
         09LB1QF0KnJJCDkxGy6tPZAGj/5Kpuh4oU53RZwgQm3Ycnjsn4fYxp8mjLynWvQKuZTp
         TNSNldWPJ1g0H61gMzG9Yij3GF+s6XXA7L+Dlwd+IzaP3u9awOGCEA4jcSpZRz3bsE11
         6eBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SCveG505PM0eS4oBerBuk8CsCGSzSfCcKji+8XOvNE0=;
        b=sz688wjQGYzGYsuyiUWtZ290xVO3blAKI2S1G2Tc8FEw55n189YeP+4eMwLUbpj2Oc
         e9mA88aMeQhdVGYYo7rwEvXN9mFEZmkjk3yWXV/9EobDiMRqNyN28N0gyRwuu5qvO/Z9
         kNWh32EBQvoZu1m1tG3gVFllVdR2rc2QUHBvZLd9WxCPqo5KUD9MySoQdqJoDfYMTvNZ
         aJ3vJdJSktChI3J1WfOBTo8zKrX4OJ9/vRnjdQy/FqU6Q2hKW1bNvYpFFnUe85SqabEy
         WLt9cMdu4uVsB5Q+tW0lSmw+7GNgsYKHAfVOZA/y1kT/2hUm0tsKk5oed2hDlw4Fe0rA
         DE9Q==
X-Gm-Message-State: AOAM533LF4xDILEpOrfbsrQPXp+OaTrWsUvUzqZwIxLPArCRFEBd9RxB
        4j5p01cpqY6AY2wGK192ucsKS6+unVij3g3xtvypng==
X-Google-Smtp-Source: ABdhPJz9dtxKniYusPWYrT1L2uWBlhv4ib1AmPhNQr8X18eUEOacA3eksamFMnR8UoXnwEkCQOrMDb7FztRO1dcZH0s=
X-Received: by 2002:a0d:f485:0:b0:2e6:8c95:d874 with SMTP id
 d127-20020a0df485000000b002e68c95d874mr1158308ywf.23.1650567048746; Thu, 21
 Apr 2022 11:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com> <20220321224358.1305530-6-bgardon@google.com>
 <YlWe6bwQX9V4Oc5S@google.com>
In-Reply-To: <YlWe6bwQX9V4Oc5S@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 21 Apr 2022 11:50:37 -0700
Message-ID: <CANgfPd8a3opGRKqzgWj9bAUx42wXG9Wc2HrsgtP6PoTBttQ3+w@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 8:46 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Mar 21, 2022, Ben Gardon wrote:
> > Factor out the implementation of reset_tdp_shadow_zero_bits_mask to a
> > helper function which does not require a vCPU pointer. The only element
> > of the struct kvm_mmu context used by the function is the shadow root
> > level, so pass that in too instead of the mmu context.
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 3b8da8b0745e..6f98111f8f8b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4487,16 +4487,14 @@ static inline bool boot_cpu_is_amd(void)
> >   * possible, however, kvm currently does not do execution-protection.
> >   */
> >  static void
>
> Strongly prefer the newline here get dropped (see below).
>
> > -reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
> > +build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
>
> Kind of a nit, but KVM uses "calc" for this sort of thing.  There are no other
> instances of "build_" to describe this behavior.
>
> Am I alone in think that shadow_zero_check is an awful, awful name?  E.g. the EPT
> memtype case has legal non-zero values.  Anyone object to opportunistically
> renaming the function and the local shadow_zero_check to "rsvd_bits" to shorten
> line lengths and move KVM one step closer to consistent naming?

That makes sense to me. I'm happy to add a commit to this series to
standardize on rsvd_bits.

>
> > +                             int shadow_root_level)
> >  {
> > -     struct rsvd_bits_validate *shadow_zero_check;
> >       int i;
> >
> > -     shadow_zero_check = &context->shadow_zero_check;
> > -
> >       if (boot_cpu_is_amd())
> >               __reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
> > -                                     context->shadow_root_level, false,
> > +                                     shadow_root_level, false,
> >                                       boot_cpu_has(X86_FEATURE_GBPAGES),
> >                                       false, true);
> >       else
> > @@ -4507,12 +4505,19 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
> >       if (!shadow_me_mask)
> >               return;
> >
> > -     for (i = context->shadow_root_level; --i >= 0;) {
> > +     for (i = shadow_root_level; --i >= 0;) {
> >               shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
> >               shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
> >       }
> >  }
> >
> > +static void
> > +reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
>
> One line!  Aside from being against the One True Style[*], there is zero reason
> for a newline here.
>
> And I vote to drop the "mask", because (a) it's not a singular mask and (b) it's
> not even a mask in all cases.
>
> And while I'm on a naming consistency rant, s/context/mmu.
>
> I.e. end up with:
>
> static void calc_tdp_shadow_rsvd_bits(struct rsvd_bits_validate *rsvd_bits,
>                                       int shadow_root_level)
>
> static void reset_tdp_shadow_rsvd_bits(struct kvm_mmu *mmu)
>
> [*] https://lore.kernel.org/mm-commits/CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com
>
> > +{
> > +     build_tdp_shadow_zero_bits_mask(&context->shadow_zero_check,
> > +                                     context->shadow_root_level);
> > +}
> > +
> >  /*
> >   * as the comments in reset_shadow_zero_bits_mask() except it
> >   * is the shadow page table for intel nested guest.
> > --
> > 2.35.1.894.gb6a874cedc-goog
> >
