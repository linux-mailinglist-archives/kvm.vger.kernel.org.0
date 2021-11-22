Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC86945948A
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbhKVSPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbhKVSPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:15:13 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38D8C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:12:06 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id w15so19055243ill.2
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6/8uM+NimmsItYVu7awvBFOK5lN31Sf9yeeX+5zQIs=;
        b=PLO5Rz6qCRt6kyLFwICfoY1F8IoEssWROqiQoJEstRqbksS2hDNtWrbnxCS3+eJRnR
         EOgXAgdA8uBJ6o8vEOSQGhD99q8+K6A2ZIBGRimd2TQGHON0/YZKS7xyRqoxe6zggCSl
         ymcHk5OtCc+Yq2hxNnsraKzVe4ky174OAU+txst3vn/KYxIX3VMyw/9MRlBc6cMvxyEQ
         IY4k52zN2E6sc2kex6ryADL9CiZqrIoxmxg1+sVLLosIWpYqg80ZPiqbu+PpURZCWE/F
         i1Vci8nfqdjq5+8XOlwVA2udXzcC40XLNS31BtmjnRugWxIaX67Vfp04aPuBuLzSH5uo
         yUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6/8uM+NimmsItYVu7awvBFOK5lN31Sf9yeeX+5zQIs=;
        b=utfDNBTP6OAUhKa5zlqyGw8opGOEcm4EIurgGyXSCUDS0GE8+V34fFzOjw14dLalvW
         ca8ZvDddAbZw4RzqB77u57waaPXsDgZFV1yJMabUe04p4zIVw7yLgzfLXu2aqDFwcOxj
         utqFzuI/dQ7s+eq7ZHkviUooCcii4B9skefBqRW1fkhw2eXDcDONPRxw33V0OyLYMqWd
         3GdgnLJNu0UNyv5NfN+MeYbuHvX7NjFGOPf89pfOqCApvFeIaMYp/0j3wiFGrgIaHXpz
         FoRlCE24Smmv5ZPUrpSyFIzaWeHrfXSVrfObyXPR9RrCHgAMrAWwRIrECZQL3emNLRzt
         TvSQ==
X-Gm-Message-State: AOAM530iy4kdSuDIDXcROeY7glr/4TUhg+rYzfSHeZU94zOsk4eml1O+
        Mwjt+IwpnLapSjBvQaDd31rfsnI8oZtX7jMZd44v+A==
X-Google-Smtp-Source: ABdhPJxJuvT7i6OSzB4lM5dDSpcLPxT4IvshhbwD/+Fe5beRzQCFEFUaH3Rdt465r4JhzmzyVJH83xJN/x84pja1Puc=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr21561146ils.274.1637604725887;
 Mon, 22 Nov 2021 10:12:05 -0800 (PST)
MIME-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com> <20211115234603.2908381-12-bgardon@google.com>
 <a1be97c6-6784-fd5f-74a8-85124f039530@redhat.com> <YZZxivgSeGH4wZnB@google.com>
 <942d487e-ba6b-9c60-e200-3590524137b9@redhat.com>
In-Reply-To: <942d487e-ba6b-9c60-e200-3590524137b9@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:11:53 -0800
Message-ID: <CANgfPd-_7tR9tSJg85-0wAG72454qeedovhBvbX6OS1YNRxvMw@mail.gmail.com>
Subject: Re: [PATCH 11/15] KVM: x86/MMU: Refactor vmx_get_mt_mask
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 1:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/18/21 16:30, Sean Christopherson wrote:
> > On Thu, Nov 18, 2021, Paolo Bonzini wrote:
> >> On 11/16/21 00:45, Ben Gardon wrote:
> >>> Remove the gotos from vmx_get_mt_mask to make it easier to separate out
> >>> the parts which do not depend on vcpu state.
> >>>
> >>> No functional change intended.
> >>>
> >>>
> >>> Signed-off-by: Ben Gardon <bgardon@google.com>
> >>
> >> Queued, thanks (with a slightly edited commit message; the patch is a
> >> simplification anyway).
> >
> > Don't know waht message you've queued, but just in case you kept some of the original,
> > can you further edit it to remove any snippets that mention separating out the parts
> > that don't depend on vCPU state?
>
> Indeed I did keep some:
>
> commit b7297e02826857e068d03f844c8336ce48077d78
> Author: Ben Gardon <bgardon@google.com>
> Date:   Mon Nov 15 15:45:59 2021 -0800
>
>      KVM: x86/MMU: Simplify flow of vmx_get_mt_mask
>
>      Remove the gotos from vmx_get_mt_mask.  This may later make it easier
>      to separate out the parts which do not depend on vcpu state, but it also
>      simplifies the code in general.
>
>      No functional change intended.
>
> i.e. keeping it conditional but I can edit it further, like
>
>      Remove the gotos from vmx_get_mt_mask.  It's easier to build the whole
>      memory type at once, than it is to combine separate cacheability and ipat
>      fields.
>
> Paolo
>
> > IMO, we should not separate vmx_get_mt_mask() into per-VM and per-vCPU variants,
> > because the per-vCPU variant is a lie.  The memtype of a SPTE is not tracked anywhere,
> > which means that if the guest has non-uniform CR0.CD/NW or MTRR settings, KVM will
> > happily let the guest consumes SPTEs with the incorrect memtype.  In practice, this
> > isn't an issue because no sane BIOS or kernel uses per-CPU MTRRs, nor do they have
> > DMA operations running while the cacheability state is in flux.
> >
> > If we really want to make this state per-vCPU, KVM would need to incorporate the
> > CR0.CD and MTRR settings in kvm_mmu_page_role.  For MTRRs in particular, the worst
> > case scenario is that every vCPU has different MTRR settings, which means that
> > kvm_mmu_page_role would need to be expanded by 10 bits in order to track every
> > possible vcpu_idx (currently capped at 1024).
>
> Yes, that's insanity.  I was also a bit skeptical about Ben's try_get_mt_mask callback,
> but this would be much much worse.

Yeah, the implementation of that felt a bit kludgy to me too, but
refactoring the handling of all those CR bits was way more complex
than I wanted to handle in this patch set.
I'd love to see some of those CR0 / MTRR settings be set on a VM basis
and enforced as uniform across vCPUs.
Looking up vCPU 0 and basing things on that feels extra hacky though,
especially if we're still not asserting uniformity of settings across
vCPUs.
If we need to track that state to accurately virtualize the hardware
though, that would be unfortunate.

>
> Paolo
>
> > So unless we want to massively complicate kvm_mmu_page_role and gfn_track for a
> > scenario no one cares about, I would strongly prefer to acknowledge that KVM assumes
> > memtypes are a per-VM property, e.g. on top:
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 77f45c005f28..8a84d30f1dbd 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6984,8 +6984,9 @@ static int __init vmx_check_processor_compat(void)
> >          return 0;
> >   }
> >
> > -static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +static u64 vmx_get_mt_mask(struct kvm *kvm, gfn_t gfn, bool is_mmio)
> >   {
> > +       struct kvm_vcpu *vcpu;
> >          u8 cache;
> >
> >          /* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> > @@ -7009,11 +7010,15 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> >          if (is_mmio)
> >                  return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> >
> > -       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> > +       if (!kvm_arch_has_noncoherent_dma(kvm))
> >                  return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> >
> > +       vcpu = kvm_get_vcpu_by_id(kvm, 0);
> > +       if (KVM_BUG_ON(!vcpu, kvm))
> > +               return;
> > +
> >          if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
> > -               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> > +               if (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> >                          cache = MTRR_TYPE_WRBACK;
> >                  else
> >                          cache = MTRR_TYPE_UNCACHABLE;
> >
>
