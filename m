Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752E350A8CE
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 21:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391795AbiDUTM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 15:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391788AbiDUTMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 15:12:55 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD408BCA4
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:10:04 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id m132so10452608ybm.4
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YgTBv49RcPLCS1V/hwfIKdZLdC/q/JL1hjJ+DfP94jw=;
        b=BfWo9WwRl81yef5UaOxA2TXICz6ubMdq+UDQF7kEKe1Q9A88ggvFz0Xt6pGSukGmxB
         5fwpOKWJYWusyW5QGH6gB93GfsEGMhszLtohZCMPCbufS97v9BI9z3XRl5mcX/alInjf
         zQSs/eyTO7BO0/nF/29TBwjqu0vLA6RAJ+9ANDB9FZZ7L2xYrgzfiZUmGxJBcnE6v7Ha
         Phwo/L0+ciuIgyTLrcFOdQ8Gy981nfgeEEMOtNmza/2iN7qGnLijGnYQg4XJjTMsTe+5
         4CQTqL4JS0KXL4Od+kCsGCA8BnCtnes5PQ05Cc9rbLAa2Vi80iKLBvsLdzs6UM4qdx3j
         zocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YgTBv49RcPLCS1V/hwfIKdZLdC/q/JL1hjJ+DfP94jw=;
        b=IA/Vaq0to+5vMIEO+9cGrPbDN/A2bP/ktmj9k0v/RRJOW3MI0ixHLK5diLiG5xZxR9
         vILuFctUALn9l5R4Iak7/FUyfLzesFmsVXF+iVnRNDcFwPda1eH4OfAMNLbI8Gs/YUg3
         scxy4ff04VDoQUTSf+pGh6QvuYIUdH1v1XdpVOyeGyKdpF7Mg7fWEkuss6fJo7zsY+/L
         B4K3h0uH9pugipfLrBi65LOrTbE9PCYIyq4MZr4mM4OmIolXJ+Qlu/LTn8OrSW2vPoeQ
         kD84eXKMvVp14F+CZPX/LnqRejhyr307c9RlSSjGMd0BZIPgUyekHmsV76XTLNj/VnWy
         Qwhg==
X-Gm-Message-State: AOAM533z7v1bwVEUw8DF/EZeEvO9km9EO49gmIqbQtxJX3aAPgz89FCg
        J14SAitKJ2FDdYSSwjcsvV0vZqtcpqub3uKV+3R7Lw==
X-Google-Smtp-Source: ABdhPJzjrVSLG8FkT5vzwRS9XbgRhkhcbH7he7pxURtyn+uR+Ln78OOW1c0ZuRVUOAAvdjmU18At7r1/tcAKQIbiTvs=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr1105656ybn.259.1650568203918; Thu, 21
 Apr 2022 12:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com> <20220321224358.1305530-6-bgardon@google.com>
 <YlWe6bwQX9V4Oc5S@google.com> <CANgfPd8a3opGRKqzgWj9bAUx42wXG9Wc2HrsgtP6PoTBttQ3+w@mail.gmail.com>
In-Reply-To: <CANgfPd8a3opGRKqzgWj9bAUx42wXG9Wc2HrsgtP6PoTBttQ3+w@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 21 Apr 2022 12:09:52 -0700
Message-ID: <CANgfPd-fmYHACProScyd+gzopgC0sqVJTpjHXMgkTDSu1H17DQ@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 11:50 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Tue, Apr 12, 2022 at 8:46 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Mar 21, 2022, Ben Gardon wrote:
> > > Factor out the implementation of reset_tdp_shadow_zero_bits_mask to a
> > > helper function which does not require a vCPU pointer. The only element
> > > of the struct kvm_mmu context used by the function is the shadow root
> > > level, so pass that in too instead of the mmu context.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Ben Gardon <bgardon@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
> > >  1 file changed, 11 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 3b8da8b0745e..6f98111f8f8b 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4487,16 +4487,14 @@ static inline bool boot_cpu_is_amd(void)
> > >   * possible, however, kvm currently does not do execution-protection.
> > >   */
> > >  static void
> >
> > Strongly prefer the newline here get dropped (see below).
> >
> > > -reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
> > > +build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> >
> > Kind of a nit, but KVM uses "calc" for this sort of thing.  There are no other
> > instances of "build_" to describe this behavior.
> >
> > Am I alone in think that shadow_zero_check is an awful, awful name?  E.g. the EPT
> > memtype case has legal non-zero values.  Anyone object to opportunistically
> > renaming the function and the local shadow_zero_check to "rsvd_bits" to shorten
> > line lengths and move KVM one step closer to consistent naming?
>
> That makes sense to me. I'm happy to add a commit to this series to
> standardize on rsvd_bits.

Actually rsvd_bits is already a function name so I'm going to
standardize on spte_rsvd_bits, if that works for everyone.

>
> >
> > > +                             int shadow_root_level)
> > >  {
> > > -     struct rsvd_bits_validate *shadow_zero_check;
> > >       int i;
> > >
> > > -     shadow_zero_check = &context->shadow_zero_check;
> > > -
> > >       if (boot_cpu_is_amd())
> > >               __reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
> > > -                                     context->shadow_root_level, false,
> > > +                                     shadow_root_level, false,
> > >                                       boot_cpu_has(X86_FEATURE_GBPAGES),
> > >                                       false, true);
> > >       else
> > > @@ -4507,12 +4505,19 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
> > >       if (!shadow_me_mask)
> > >               return;
> > >
> > > -     for (i = context->shadow_root_level; --i >= 0;) {
> > > +     for (i = shadow_root_level; --i >= 0;) {
> > >               shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
> > >               shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
> > >       }
> > >  }
> > >
> > > +static void
> > > +reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
> >
> > One line!  Aside from being against the One True Style[*], there is zero reason
> > for a newline here.
> >
> > And I vote to drop the "mask", because (a) it's not a singular mask and (b) it's
> > not even a mask in all cases.
> >
> > And while I'm on a naming consistency rant, s/context/mmu.
> >
> > I.e. end up with:
> >
> > static void calc_tdp_shadow_rsvd_bits(struct rsvd_bits_validate *rsvd_bits,
> >                                       int shadow_root_level)
> >
> > static void reset_tdp_shadow_rsvd_bits(struct kvm_mmu *mmu)
> >
> > [*] https://lore.kernel.org/mm-commits/CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com
> >
> > > +{
> > > +     build_tdp_shadow_zero_bits_mask(&context->shadow_zero_check,
> > > +                                     context->shadow_root_level);
> > > +}
> > > +
> > >  /*
> > >   * as the comments in reset_shadow_zero_bits_mask() except it
> > >   * is the shadow page table for intel nested guest.
> > > --
> > > 2.35.1.894.gb6a874cedc-goog
> > >
