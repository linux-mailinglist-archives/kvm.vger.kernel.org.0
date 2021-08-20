Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2711F3F370F
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 00:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhHTW4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 18:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhHTWz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 18:55:59 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05254C061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 15:55:21 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id j12so5202460ljg.10
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 15:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OVgl6NYG6keKKu00zAIKlyoS+SlGhGRMo5kOSa5PnG0=;
        b=RQvpyG3rM+U2rBpkWf3bcovUJEsSPs8JCcMYDACloI6yu2K0oVsFLge+L2z/znEmg0
         9Ip7J3zbvn1PKlgEFZTxxmuwtyFhe6O0qP9befQNZZRiH5zJ4RzxWOpfQI6m44C8ZyJk
         ti47fPEb3zcxHFQpdYRDcrQ1k4FZELUPr9B1w3c44yeiqgcZ7amfsNw3U4VGKF/3aYlj
         uCc9S46W2M1yVJnvncGDXzY87nJBY+hRR6JD8tGbPdfzq2W9rB76MUpA/zttl6hL+W4o
         bCwAozGDbQZtTQx0HOurh4hGA13Dz+Ig8TshIEXqaB3kG4wNUSMql3H2kFu5eaUaOJNO
         8jOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OVgl6NYG6keKKu00zAIKlyoS+SlGhGRMo5kOSa5PnG0=;
        b=KZhjCXY/MLk+yuIYSeIrTjodefIE4ks5CU8nXo1C/NMviZ9m/xhRy+5IiWhz9K6mdW
         s4vx1tcOHicZM+yUuWZZf8igiMpGr97ZxulT0v4t7T/g2ZD7KzePv4FLLYqGpZbttVSb
         2KDmuEapwZMjJo/pTeBvSYr4FPPQCzqn9kkkbOLKCYZmiL8k8lWcGzx2gqJO6PvELGDl
         ubpNSYfjr9dawaJ18WKbvZvPu976d5zRrC5HvewLDyhEERPuXscsacQ7/Y3UgELdmEZc
         EtNBx3Yi9+ebViLoYdxVS0JviDa8NdlYjeSYjVr1UoQkY8sCncqAcaYCGPswW1wjvMo7
         e08g==
X-Gm-Message-State: AOAM530Vjhnu8wAD1K4aSzmK0CT4Fr5p3GXZgeuLOqY4fOSiQmiDeFFk
        v2Fm/Qs90LnronFmA5TkLwvUNj6gb+cBIsl9SgCuCg==
X-Google-Smtp-Source: ABdhPJw/Xio5KUM0x4cOAc1XscTNHCzOk+Tjxz6AHiMkra7KNMNEZFgsa1SeplbKgvHF1o7SWkqEATsCuWcMjnxdgeA=
X-Received: by 2002:a2e:9903:: with SMTP id v3mr17420283lji.383.1629500119004;
 Fri, 20 Aug 2021 15:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com> <20210813203504.2742757-4-dmatlack@google.com>
 <YR6Iyc3PNqUey7LM@google.com>
In-Reply-To: <YR6Iyc3PNqUey7LM@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 20 Aug 2021 15:54:52 -0700
Message-ID: <CALzav=crHjGo0fBg2=npaJyQSS9cvQ6b8nbU0W_4fX_ABC4O+Q@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 13, 2021, David Matlack wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 3352312ab1c9..fb2c95e8df00 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2890,7 +2890,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
> >
> >  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> > -     struct kvm_memory_slot *slot;
> > +     struct kvm_memory_slot *slot = fault->slot;
> >       kvm_pfn_t mask;
> >
> >       fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
> > @@ -2901,8 +2901,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >       if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
> >               return;
> >
> > -     slot = gfn_to_memslot_dirty_bitmap(vcpu, fault->gfn, true);
> > -     if (!slot)
> > +     if (kvm_slot_dirty_track_enabled(slot))
>
> This is unnecessarily obfuscated.

Ugh. It's pure luck too. I meant to check if the slot is null here.

> It relies on the is_error_noslot_pfn() to
> ensure fault->slot is valid, but the only reason that helper is used is because
> it was the most efficient code when slot wasn't available.  IMO, this would be
> better:
>
>         if (!slot || kvm_slot_dirty_track_enabled(slot))
>                 return;
>
>         if (kvm_is_reserved_pfn(fault->pfn))
>                 return;

That looks reasonable to me. I can send a patch next week with this change.

>
> On a related topic, a good follow-up to this series would be to pass @fault into
> the prefetch helpers, and modify the prefetch logic to re-use fault->slot and
> refuse to prefetch across memslot boundaries.  That would eliminate all users of
> gfn_to_memslot_dirty_bitmap() and allow us to drop that abomination.
