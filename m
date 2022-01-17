Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3A5490085
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 04:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbiAQDXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jan 2022 22:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiAQDXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jan 2022 22:23:18 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C223C061574
        for <kvm@vger.kernel.org>; Sun, 16 Jan 2022 19:23:18 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id y4so28113149uad.1
        for <kvm@vger.kernel.org>; Sun, 16 Jan 2022 19:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q9SVo+f6dgUavA4xqDj7rCCdQm9sgpR68lZeR6ag/AU=;
        b=pXkhEfOkBnZ3rkG5MXGsvE+ucMi1XFgWS0j/7yscTiipWC1KV67ZB6H1btatJEunK5
         /UCgP4QrxImjBP/bITqYYDlc1jqBPHu8MKmhJxeSi58qzo59RkbxaRVWtYVpQWMpbgu5
         /0VIA12vQuB/0vUa7Aj1TshTTbRdImv+/JMZdxCN4rvmkJB0X8Q3eqIMb6NYMljGu50A
         J9WizShGjki9IazWgGxcpzktSWOP5NWcQqZIkG1uo4NpsWUlJqLTNrjYU8WaSYb6O/s7
         UfByT0uGic8xEMwBuGPMF3XqusLp8xlK1NpifUlAj6moJmthC2luQJXDPEMBELTZMNzH
         VF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q9SVo+f6dgUavA4xqDj7rCCdQm9sgpR68lZeR6ag/AU=;
        b=H3rCJPg/gfuHFmujwaPUe+9/jVH3IZeVbhN6uJp7QmZ4jaOnxaAlw1rgDFc4OrQsZT
         ndojzj0+ZFYnLEp7eryL4aiinlEJXQdQdWknvNzaMx8WzqFe6oLF55dQEZz8f24/7l89
         EqGOLl/Tyk856JpNy52pcU95s7fS9uqosTDEk9Yl7Fuwm3tNOlVcgZQwHiAdGQlRT5y2
         QcoAfum4vElxj9/Gra7331gbq+zybRe+ya5b6gXkiPd4ZD2B+wKYgWO5sZA+sKgrlQRr
         YuphoGg75v+kD9h4z/c0X7lBofKiELeKiDzACIRrP8s9InGOoQaZLTUxbp4vAI87TQ9B
         4yKg==
X-Gm-Message-State: AOAM531p9GvUJ/KHzhgGl+qTt5+AaidxphzCL2AVijs02cEqiAIwZ3Tw
        vEmHJvEDKciRv5sqfTxVmsWQPthZhkAWzX5qiZo4wg==
X-Google-Smtp-Source: ABdhPJz0Ml23OeNs4PVzflMjLgqC1PMFnYM+QUtn472KrkIuc5/oFdgNhdINP3mf04H7ahtbQE3GgNyiAsBVfuAYURg=
X-Received: by 2002:ab0:1609:: with SMTP id k9mr3323464uae.137.1642389797118;
 Sun, 16 Jan 2022 19:23:17 -0800 (PST)
MIME-Version: 1.0
References: <20220113221829.2785604-1-jingzhangos@google.com>
 <20220113221829.2785604-3-jingzhangos@google.com> <87wnj0x789.wl-maz@kernel.org>
In-Reply-To: <87wnj0x789.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Sun, 16 Jan 2022 19:23:06 -0800
Message-ID: <CAAdAUti0Ydsw4uHyT29H93+LUmY5fRSYF02k+qBJvrpv0VnD_w@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 16, 2022 at 3:14 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 13 Jan 2022 22:18:28 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > To reduce MMU lock contention during dirty logging, all permission
> > relaxation operations would be performed under read lock.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index cafd5813c949..15393cb61a3f 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1084,6 +1084,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       unsigned long vma_pagesize, fault_granule;
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> > +     bool use_mmu_readlock = false;
>
> Group this with the rest of the flags. It would also be better if it
> described the condition this represent rather than what we use it for.
> For example, 'perm_fault_while_logging', or something along those
> lines.
>
Sure, will group with logging_active and rename it as "logging_perm_fault".
> >
> >       fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
> >       write_fault = kvm_is_write_fault(vcpu);
> > @@ -1212,7 +1213,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       if (exec_fault && device)
> >               return -ENOEXEC;
> >
> > -     write_lock(&kvm->mmu_lock);
> > +     if (fault_status == FSC_PERM && fault_granule == PAGE_SIZE
> > +                                  && logging_active && write_fault)
> > +             use_mmu_readlock = true;
>
> This looks a bit clumsy, and would be better if this was kept together
> with the rest of the logging_active==true code. Something like:
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index bc2aba953299..59b1d5f46b06 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1114,6 +1114,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (logging_active) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
> +               use_readlock = (fault_status == FSC_PERM && write_fault);
>         } else {
>                 vma_shift = get_vma_page_shift(vma, hva);
>         }
>
> I don't think we have to check for fault_granule here, as I don't see
> how you could get a permission fault for something other than a page
> size mapping.
>
You are right. Will do as you suggested.

> > +     /*
> > +      * To reduce MMU contentions and enhance concurrency during dirty
> > +      * logging dirty logging, only acquire read lock for permission
> > +      * relaxation. This fast path would greatly reduce the performance
> > +      * degradation of guest workloads.
> > +      */
>
> This comment makes more sense with the previous hunk. Drop the last
> sentence though, as it doesn't bring much information.
>
Will do.
> > +     if (use_mmu_readlock)
> > +             read_lock(&kvm->mmu_lock);
> > +     else
> > +             write_lock(&kvm->mmu_lock);
> >       pgt = vcpu->arch.hw_mmu->pgt;
> >       if (mmu_notifier_retry(kvm, mmu_seq))
> >               goto out_unlock;
> > @@ -1271,7 +1284,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       }
> >
> >  out_unlock:
> > -     write_unlock(&kvm->mmu_lock);
> > +     if (use_mmu_readlock)
> > +             read_unlock(&kvm->mmu_lock);
> > +     else
> > +             write_unlock(&kvm->mmu_lock);
> >       kvm_set_pfn_accessed(pfn);
> >       kvm_release_pfn_clean(pfn);
> >       return ret != -EAGAIN ? ret : 0;
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
