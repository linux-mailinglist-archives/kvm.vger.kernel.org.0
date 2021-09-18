Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308AC41032C
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 05:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbhIRDIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 23:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240737AbhIRDIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 23:08:12 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22CAC061574;
        Fri, 17 Sep 2021 20:06:49 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a22so14626182iok.12;
        Fri, 17 Sep 2021 20:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hb162fjdA++svSx4bcbnGtUQwKzEphYjoPNAoQasXSA=;
        b=INpgMBhc5bCcLGpZkUxXimTTTPZHb+e4+zSL/F3aZtHgGGrApBKP0DfPrPIE89Oy4E
         duOBORRuMzpeS6feX5u+h+4Z9smVTIcdAUDKjJvEmEPxfoI00l4aDUlRM+74Pc6Stkfv
         tqfHX68p5shPPdEcemZ9k3J/EwZD/pXb15znXhCh+9x6NxTis6+3pxjyjNRz/JzfS4GA
         Ew7NsQz5SWIWgySrmkw9M7xSughZx4jyXDwg7/HOfY/NsEbE361XCG65z1XhSGqrKqWt
         OQiyxOr2aZb2O0YALne9S8+RS3CMvJsARDB5w2p2B6ZPHPz0VG+XPTFJll/Halh407n1
         3u5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hb162fjdA++svSx4bcbnGtUQwKzEphYjoPNAoQasXSA=;
        b=lZGibVtRtQ8JD8yuhPW+gOJk1bzlR5MTPGm0vPoG4AXt/bEDM0BUM+zsrGHLnhS3FP
         +gSnszQrCG0bzwoRJtCKf6xmB8mRIxdI/S2nWMavoM/e4CIwNdvrVI6jhyOoEHPZbEM1
         KP0CtAC2kWV4YBg/XhQMzeFoskRRRNG/E9xR7HR1NvEtpXScO2w5sEChot9YY9F/irxK
         xxtrCnclI2O5XGtZeCXETJLxo/ezkrH4GZ9hHsrYdS2keqgPvCqKZanCsJmL0ZMgHdcY
         ZtXf2XLIdBC2soTFKjBKuJoMCLP5ujglgHOIJpRxdK86Bn1v4clYCDhvOAAp+rM4chxB
         PnMw==
X-Gm-Message-State: AOAM531X1o0HcI+lKhpFy+OMBMvH5xPD6NDJzChPfLivD7csd7d5m85j
        IdRfeX1YXF8pPn6OuAYwPdmpTZ88f2G5A/m4u7mFs8ehr2w=
X-Google-Smtp-Source: ABdhPJxMum/J8WLj7vI4WPq0VOeL+So4h+kAIb0sxPJK4YIA0cNbVPigfPJqlI3FMSDSf5i2uPnTgSWBhb1+aZ38CpM=
X-Received: by 2002:a02:6d59:: with SMTP id e25mr11412408jaf.68.1631934409043;
 Fri, 17 Sep 2021 20:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210824075524.3354-1-jiangshanlai@gmail.com> <20210824075524.3354-6-jiangshanlai@gmail.com>
 <2f32727a108a626b71ab63b61cee567853ef2fdf.camel@redhat.com>
In-Reply-To: <2f32727a108a626b71ab63b61cee567853ef2fdf.camel@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Sat, 18 Sep 2021 11:06:37 +0800
Message-ID: <CAJhGHyCpQDfon_RFefV_kRzeNBg0EvzyEh9KRogqTRrBQHpYeA@mail.gmail.com>
Subject: Re: [PATCH 5/7] KVM: X86: Don't unsync pagetables when speculative
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is weird that I did not receive this email.

On Mon, Sep 13, 2021 at 7:02 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Tue, 2021-08-24 at 15:55 +0800, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> >
> > We'd better only unsync the pagetable when there just was a really
> > write fault on a level-1 pagetable.
> >
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 6 +++++-
> >  arch/x86/kvm/mmu/mmu_internal.h | 3 ++-
> >  arch/x86/kvm/mmu/spte.c         | 2 +-
> >  3 files changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a165eb8713bc..e5932af6f11c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2600,7 +2600,8 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> >   * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
> >   * be write-protected.
> >   */
> > -int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
> > +int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
> > +                         bool speculative)
> >  {
> >       struct kvm_mmu_page *sp;
> >       bool locked = false;
> > @@ -2626,6 +2627,9 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
> >               if (sp->unsync)
> >                       continue;
> >
> > +             if (speculative)
> > +                     return -EEXIST;
>
> Woudn't it be better to ensure that callers set can_unsync = false when speculating?

I don't want to change the current behavior of "can_unsync"

For a gfn:
  case1: All sps for the gfn are synced
  case2: Some sps for the gfn are synced and the others are not
  case3: All sps for the gfn are not synced

"!can_unsync" causes the function to return non-zero for all cases.
"speculative" causes the function to return non-zero for case1,case2.

I don't think it would be bug if the behavior of old "!can_unsync" is changed
to the behavior of this new "speculative".  But the meaning of "!can_unsync"
has to be changed.

!can_unsync: all sps for @gfn can't be unsync.  (derived from current code)
==>
!can_unsync: it should not do any unsync operation.

I have sent the patch in V2 without any change.  If the new meaning
is preferred, I will respin the patch, or I will send it separately
if no other patches in V2 need to be updated.

>
> Also if I understand correctly this is not fixing a bug, but an optimization?
>

It is not fixing any bugs.  But it is weird to do unsync operation on sps when
speculative which would cause future overhead with no reason.

> Best regards,
>         Maxim Levitsky
>
>
> > +
> >               /*
> >                * TDP MMU page faults require an additional spinlock as they
> >                * run with mmu_lock held for read, not write, and the unsync
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 658d8d228d43..f5d8be787993 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -116,7 +116,8 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
> >              kvm_x86_ops.cpu_dirty_log_size;
> >  }
> >
> > -int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync);
> > +int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
> > +                         bool speculative);
> >
> >  void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
> >  void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 3e97cdb13eb7..b68a580f3510 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -159,7 +159,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
> >                * e.g. it's write-tracked (upper-level SPs) or has one or more
> >                * shadow pages and unsync'ing pages is not allowed.
> >                */
> > -             if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync)) {
> > +             if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync, speculative)) {
> >                       pgprintk("%s: found shadow page for %llx, marking ro\n",
> >                                __func__, gfn);
> >                       ret |= SET_SPTE_WRITE_PROTECTED_PT;
>
>
