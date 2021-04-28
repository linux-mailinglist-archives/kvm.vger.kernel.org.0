Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6C136DCEC
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 18:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbhD1QY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 12:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240934AbhD1QYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 12:24:55 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA635C061574
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 09:24:08 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso44803241otm.4
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 09:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vFFeVW33ruUEu/k84GYwSnkp1LcEq7XYbpo7nxvVcFI=;
        b=hn+R2pvJfLdJc/4FJGrLTsET9/BSFZHQ3oyvmGarpqqestJfKms3Tpj/IujFgKAK+I
         STWb4Qige1UGtc7wy0KuENrTa2Pu7sEZx/BXCYVQJon9TnFgC+6xapjpJeI5XS97UqAD
         PskI9dX0Haq3e0/eOmrBhs2wAU1K8uE8bjQ+PnDAHPcoMhfs+0Mw4COjmFSyNb6GfUZ1
         RK8Yo+sHZ9mW/OSVZjISnjiwOxC7J4/DScD6bpR+wPrmH1F8+uAyDiyZKQ87bFtPxypQ
         il5d7LCT4zkXOqK7HNc0ERUv6Xx9PXmyWzUrEl4z4nHacZRpZDTTC5x+58shKX+l84bn
         bAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vFFeVW33ruUEu/k84GYwSnkp1LcEq7XYbpo7nxvVcFI=;
        b=Cc03/49qBhOna/eiZ2/1f+m1ydkBmn9gqdYN7EqiG3SVyx7P2DVvghE9nVovAfqNsF
         C9SFo6dhXhg0lgiNRNpXeWjbSOrJQrPkEN3ze2/QNh9G14/mr/O8xAQMCD766uqXlYQ4
         twGKn14Is7WAa+MDKzp+3a1fKDLoz11t1ewLqSHGmbi+rZvmF/o1PDX/CG9TtiDJO2Gv
         b1oEs/cyW9AEhl7qutVGkF11QkNVP6jfig1jED/GjpwfLuHtvjGHhjfRrBX2QPLr4Rg/
         GFmhCNHc7ChW7cX4XsRvoXIuIuBXFSldqMntM9+p8jVybMVNXeHAj0l/DpauFtBOF9fo
         gPJw==
X-Gm-Message-State: AOAM530LBGs9ktHN6gmZRBvpGNtauHXpv6V4oWFg8q4xWcVaOatwL40k
        RNtzQ/Y72LBdYBtpUrCBvtXScVQW/tGbb0fyk2jH+A==
X-Google-Smtp-Source: ABdhPJwWHRNFe5yz7wBYtOPEdrHwUqI1dTfIVjAv50VzHm+M+vApvLtLT8m3GLJkwbhFeJKPFsHpIeINVS9qEG1hLoA=
X-Received: by 2002:a05:6830:1deb:: with SMTP id b11mr25593909otj.72.1619627047878;
 Wed, 28 Apr 2021 09:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com> <20210427223635.2711774-4-bgardon@google.com>
 <2e5ecc0b-0ef4-a663-3b1d-81d020626b39@redhat.com>
In-Reply-To: <2e5ecc0b-0ef4-a663-3b1d-81d020626b39@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 28 Apr 2021 09:23:56 -0700
Message-ID: <CANgfPd9OrCFoH1=2G_GD5MB5R54q5w=SDKP7vLnHPvDZox5WiQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: Deduplicate rmap freeing in allocate_memslot_rmap
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 3:00 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Typo in the commit subject, I guess?

Oh woops, yeah It should just be "Deduplicate rmap freeing" or
something to that effect.

>
> Paolo
>
> On 28/04/21 00:36, Ben Gardon wrote:
> > Small code deduplication. No functional change expected.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >   arch/x86/kvm/x86.c | 19 +++++++++++--------
> >   1 file changed, 11 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index cf3b67679cf0..5bcf07465c47 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10818,17 +10818,23 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >       kvm_hv_destroy_vm(kvm);
> >   }
> >
> > -void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > +static void free_memslot_rmap(struct kvm_memory_slot *slot)
> >   {
> >       int i;
> >
> >       for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> >               kvfree(slot->arch.rmap[i]);
> >               slot->arch.rmap[i] = NULL;
> > +     }
> > +}
> >
> > -             if (i == 0)
> > -                     continue;
> > +void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > +{
> > +     int i;
> > +
> > +     free_memslot_rmap(slot);
> >
> > +     for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
> >               kvfree(slot->arch.lpage_info[i - 1]);
> >               slot->arch.lpage_info[i - 1] = NULL;
> >       }
> > @@ -10894,12 +10900,9 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >       return 0;
> >
> >   out_free:
> > -     for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> > -             kvfree(slot->arch.rmap[i]);
> > -             slot->arch.rmap[i] = NULL;
> > -             if (i == 0)
> > -                     continue;
> > +     free_memslot_rmap(slot);
> >
> > +     for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
> >               kvfree(slot->arch.lpage_info[i - 1]);
> >               slot->arch.lpage_info[i - 1] = NULL;
> >       }
> >
>
