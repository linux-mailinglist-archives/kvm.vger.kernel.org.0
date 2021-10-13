Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25542B624
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 07:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhJMFyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 01:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhJMFyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 01:54:24 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0047C061714
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 22:52:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v20so1049865plo.7
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 22:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2yJVVNGRPJXsa1/Y1Zn9pdM/oy3KfLkUusY0H2kckAc=;
        b=Q579i91kdRJn3mILCUDSbxAKnocs2ICoskyM6NFXs0qu98H/SYDhwvyeV9R5vTQCyA
         P17ZAAI/uwNVNrlG8kyETHrT+4bzLBKInEv5K+IP6YdbHtwHUUo0PPmwnklkKl7okPBk
         glOtv45Bv2Whu4p4LF3emRjqM3I5oVJ9JGrGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2yJVVNGRPJXsa1/Y1Zn9pdM/oy3KfLkUusY0H2kckAc=;
        b=CKv9vF+6/ZVF5CtbOaewdUzYSX+TJI0xlPsPaNYKrK+pijtdbSjtmx4MAetAhgEpbU
         PTpdN7BA2lu6m4HY66mSpRaPoPEkim2LFZjzJukIgWKj+0HH6DkEeS7NAom4BPalFzGR
         F58tR2eOIj5q9k94BjygzuZ+NxJtWozJcjy68bwL3ycf/7HZ2cKIytpMwP4keliBmhYU
         fb5H/xx5kr//ZtWQ4qXKPj9kZGBlSJnVFHWUM/Tv4g8edRlAFkZ4VBE1ZKpfhRuFu3wX
         8jk19X0rWQP83b2lsaiHYFdSvuxlyx3U7WeL2/WmRx1Z5BtB7qo9GxKVIbYvHgB35BFI
         muAw==
X-Gm-Message-State: AOAM533ZLogntRx48IjoxLlAvTi9nbEFpvM6UnI+teWAYYgaEszRG/29
        lTOeIQ0lUsNVzVK2aFHsrGvkPg==
X-Google-Smtp-Source: ABdhPJwDQdREjCTkLNonU7TRezwdPLTKa3ccQrKdRYfuM8Ymn5G3JCafYCvHci/p4+0uubDkvnH1lw==
X-Received: by 2002:a17:90b:3a84:: with SMTP id om4mr11171166pjb.153.1634104341357;
        Tue, 12 Oct 2021 22:52:21 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:e5ac:84f1:6b7d:9dac])
        by smtp.gmail.com with ESMTPSA id z12sm1654839pjh.51.2021.10.12.22.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 22:52:20 -0700 (PDT)
Date:   Wed, 13 Oct 2021 14:52:15 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     David Matlack <dmatlack@google.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: make PTE_PREFETCH_NUM tunable
Message-ID: <YWZ0D9r5BOm/8f7d@google.com>
References: <20211012091430.1754492-1-senozhatsky@chromium.org>
 <CALzav=dYeCs=ieC2p074J4KVyFpRsxRVa5ZQuST--2GOVJm7Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dYeCs=ieC2p074J4KVyFpRsxRVa5ZQuST--2GOVJm7Kw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/10/12 09:50), David Matlack wrote:
> On Tue, Oct 12, 2021 at 2:16 AM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > Turn PTE_PREFETCH_NUM into a module parameter, so that it
> > can be tuned per-VM.
> 
> Module parameters do not allow tuning per VM, they effect every VM on
> the machine.
> 
> If you want per-VM tuning you could introduce a VM ioctl.

ACK.

> > ---
> >  arch/x86/kvm/mmu/mmu.c | 31 ++++++++++++++++++++++---------
> 
> Please also update the shadow paging prefetching code in
> arch/x86/kvm/mmu/paging_tmpl.h, unless there is a good reason to
> diverge.

ACK.

> > @@ -732,7 +734,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> >
> >         /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
> >         r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> > -                                      1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
> > +                                      1 + PT64_ROOT_MAX_LEVEL + pte_prefetch_num);
> 
> There is a sampling problem. What happens if the user changes
> pte_prefetch_num while a fault is being handled?

Good catch.

> > @@ -2753,20 +2755,29 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
> >                                     struct kvm_mmu_page *sp,
> >                                     u64 *start, u64 *end)
> >  {
> > -       struct page *pages[PTE_PREFETCH_NUM];
> > +       struct page **pages;
> >         struct kvm_memory_slot *slot;
> >         unsigned int access = sp->role.access;
> >         int i, ret;
> >         gfn_t gfn;
> >
> > +       pages = kmalloc_array(pte_prefetch_num, sizeof(struct page *),
> > +                             GFP_KERNEL);
> 
> This code runs with the MMU lock held. From
> In general we avoid doing any dynamic memory allocation while the MMU
> lock is held. That's why the memory caches exist. You can avoid
> allocating under a lock by allocating the prefetch array when the vCPU
> is first initialized. This would also solve the module parameter
> sampling problem because you can read it once and store it in struct
> kvm_vcpu.

I'll do per-VCPU pre-allocation, thanks. GFP_KERNEL is less of a problem
if we hold read kvm->mmu_lock, but more so if we hold write kvm->mmu_lock.

> >  static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
> > @@ -2785,10 +2798,10 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
> >
> >         WARN_ON(!sp->role.direct);
> >
> > -       i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
> > +       i = (sptep - sp->spt) & ~(pte_prefetch_num - 1);
> 
> This code assumes pte_prefetch_num is a power of 2, which is now no
> longer guaranteed to be true.

It does. I can test if it's a pow(2) in ioctl
