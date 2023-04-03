Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3E86D4EE3
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjDCR0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 13:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbjDCR0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 13:26:15 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E41123
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 10:26:14 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-17ac5ee3f9cso31564003fac.12
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 10:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680542773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qd9vNo8gmYRz8Z2M2O7ElfQfkdlOYiM1xlJu96lXJAs=;
        b=oX8NBYb547UrM6ZoqymNw1EdsaXNXl8OfwHwQLHx77p13cWWg7QxpeSNTbBJQzK7zN
         GORcfbDwlQG/J8YJ/Udb5aZvAsZpBIlCzL5NbfC07p+OldQfiBWgQjJ8edDqp5/JEwGN
         Vlja5+ZGYN22+5FeGnB3oCd/Aa+fHf5RSjiYxKABYg15BXJODLZ9FdRg3q60s7f5oIII
         1ZaKJSwt6SqvgmHP3cde1MNJOh0BUK71PwH06e/+YCLXpBZJKUOFuthBS6ylbRdFUA5Q
         ivFv1wsc705bWl5a4i6xDG64+T17HQ0h/Kz7lLpBDTcuufNYWZl//dh86SgqnSl/k0nU
         YYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680542773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qd9vNo8gmYRz8Z2M2O7ElfQfkdlOYiM1xlJu96lXJAs=;
        b=4B9yhtOXtt7Xf/FDCBskQCqI53dr8q77Mufy7PDQtNwwBwOt+1YygeGrL7Os2iwF51
         0B01tWoU4T4/sCZ6ZOWHOkXTBvlpDM34PqDDRom0fcewLWrRZIuGhxVJWA0xDgWq0mv4
         uH1lO0gbtwFX48eykCkusJwvBeAJWS5p+PulnZXUD52hphRgYmjJklocTfOPisOM1VyD
         UgT84DBUyPK6MRiX+whRLUXVzTsGEOmVohk4tPfuqP4ZHhdl7mqDn0bXw1QveruedKN7
         k/PK4buvumHzJn/385LYgU5WWG0v9m7Hljo/ItikRzvu12XR9tFQlX7lUTSdLgBXEJdX
         7T8Q==
X-Gm-Message-State: AAQBX9c2UmEF6OH7qcRO6WdHCleXto4pZ/CbTxKcl5+NlOxr3NNw2/TJ
        wqqNwno/TEjiSeW9T5wH2XlH7IOGr6KZb+fVmDJQGg==
X-Google-Smtp-Source: AKy350ZvpCTIPloJRcOFoCrQ+HT6tXfd4a3GZ/Vtv3sZwoG6TcgOwSNV226vkhToXbFZYP2WlIqpnoj9PF1pwnBRTZc=
X-Received: by 2002:a05:6870:96a2:b0:17e:d94f:90d9 with SMTP id
 o34-20020a05687096a200b0017ed94f90d9mr7605490oaq.3.1680542773212; Mon, 03 Apr
 2023 10:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-3-rananta@google.com>
 <ZCTjirkCgBkT65eP@linux.dev>
In-Reply-To: <ZCTjirkCgBkT65eP@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 3 Apr 2023 10:26:01 -0700
Message-ID: <CAJHc60y1BLQC4c0qXCuqF7JfewBC_fG2xuH0Wj0AHJh9x3CK5g@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Add FEAT_TLBIRANGE support
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Mar 29, 2023 at 6:19=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Feb 06, 2023 at 05:23:35PM +0000, Raghavendra Rao Ananta wrote:
> > Define a generic function __kvm_tlb_flush_range() to
> > invalidate the TLBs over a range of addresses. The
> > implementation accepts 'op' as a generic TLBI operation.
> > Upcoming patches will use this to implement IPA based
> > TLB invalidations (ipas2e1is).
> >
> > If the system doesn't support FEAT_TLBIRANGE, the
> > implementation falls back to flushing the pages one by one
> > for the range supplied.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/=
kvm_asm.h
> > index 43c3bc0f9544d..995ff048e8851 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -221,6 +221,24 @@ DECLARE_KVM_NVHE_SYM(__per_cpu_end);
> >  DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
> >  #define __bp_harden_hyp_vecs CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
> >
> > +#define __kvm_tlb_flush_range(op, mmu, start, end, level, tlb_level) d=
o {    \
> > +     unsigned long pages, stride;                                     =
       \
> > +                                                                      =
       \
> > +     stride =3D kvm_granule_size(level);                              =
         \
>
> Hmm... There's a rather subtle and annoying complication here that I
> don't believe is handled.
>
> Similar to what I said in the last spin of the series, there is no
> guarantee that a range of IPAs is mapped at the exact same level
> throughout. Dirty logging and memslots that aren't hugepage aligned
> could lead to a mix of mapping levels being used within a range of the
> IPA space.
>
Unlike the comment on v1, the level/stride here is used to jump the
addresses in case the system doesn't support TLBIRANGE. The TTL hint
is 0.
That being said, do you think we can always assume the least possible
stride (say, 4k) and hardcode it?
With respect to alignment, since the function is only called while
breaking the table PTE,  do you think it'll still be a problem even if
we go with the least granularity stride?

> > +     start =3D round_down(start, stride);                             =
         \
> > +     end =3D round_up(end, stride);                                   =
         \
> > +     pages =3D (end - start) >> PAGE_SHIFT;                           =
         \
> > +                                                                      =
       \
> > +     if ((!system_supports_tlb_range() &&                             =
       \
> > +          (end - start) >=3D (MAX_TLBI_OPS * stride)) ||              =
         \
>
> Doesn't checking for TLBIRANGE above eliminate the need to test against
> MAX_TLBI_OPS?
>
Derived from __flush_tlb_range(), I think the condition is used to
just flush everything if the range is too large to iterate and flush
when the system doesn't support TLBIRANGE. Probably to prevent
soft-lockups?

Thank you.
Raghavendra
> > +         pages >=3D MAX_TLBI_RANGE_PAGES) {                           =
         \
> > +             __kvm_tlb_flush_vmid(mmu);                               =
       \
> > +             break;                                                   =
       \
> > +     }                                                                =
       \
> > +                                                                      =
       \
> > +     __flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, fals=
e);    \
> > +} while (0)
> > +
> >  extern void __kvm_flush_vm_context(void);
> >  extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
> >  extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr=
_t ipa,
> > --
> > 2.39.1.519.gcb327c4b5f-goog
> >
> >
>
> --
> Thanks,
> Oliver
