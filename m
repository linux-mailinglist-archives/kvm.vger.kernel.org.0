Return-Path: <kvm+bounces-40240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EB6A5487A
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 11:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6790170C76
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 10:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42113204F6E;
	Thu,  6 Mar 2025 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q6TH37RJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0BD1A76BC
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 10:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741258497; cv=none; b=gGgrZTg65T08ydMWeLr09ZEF9bonHpdnI2284D3hmhpPOv7KSIVMezNxMaRNrmXwMHPf5Xj4eaGdbTJPzF44JKWgryxKwHZIxMP77Hq0nhxrmyt4KnV1TP7b4a6BzxR+vnJHDvUv4InL5+ZL7Sl/V/BrL2dxANn0CQ1f++GwOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741258497; c=relaxed/simple;
	bh=855b6L8nqsEHYMcX9MPJemARlXX5K2LPQ5geJ0egnGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JgPsfj5mcOJ2KAzgIhdFW+PRxkbh6KHMGrkuwt2qbuDI/Mi0GOtDnlO+ayH4KWf3Nlu9QRb7v2U6c+z7ryrqFnvta9lhLd6Cp6+NSAqhAHLOpk3nZ+j/bANhbNkPqB7KVVnNQbcDHowVbptc5go1thuiUuO81NCvd34dJMTqUVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q6TH37RJ; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-472098e6e75so145751cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 02:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741258495; x=1741863295; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n8NpZ5y1NnHyafYNLq4ILW6Ns+61OzoqQPIfzuXR+8g=;
        b=Q6TH37RJq1eRx0KUFpBcPEpPY6ERku9fhsKkvUrpC9pYmFoEtwVW5lqDL23roy0QlC
         /0/sMDh/1358PrLWNGd/4ie+HbL0n65InuvUS6ViZNZWEQwJB3BoK/z8hFCEd3z2V/NO
         YA5s2IO0E8H14eX2jSGsJ5+6rSo3boVowUnhWnmsOvAZSz6MfZTXqYdmQydc/i4BEFC9
         gFgFyojzRIFm0Zm6b4I02PU6O4YbV4GjQEDhuwoNOXed06RA2My7HOkf10rHWJ5MfuAQ
         az5FVulEnz9Y+6VRJGTOdOKgRfQabE60RZ52s2G6/IKCkt3oM1Srr30NMFMAMQfQAUua
         u0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741258495; x=1741863295;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n8NpZ5y1NnHyafYNLq4ILW6Ns+61OzoqQPIfzuXR+8g=;
        b=sOEhQL3n9nU1wokn2nhbfBfppWwWUqkAYIndQ/33MMc4DfHEDaj/0g90OM8Dca66n0
         5UZoyDrKFeItaEgeQNAbfmDx46OrfEAVsQ1OXkJwL2RiHedRp4hnHhNPYeKAncOEpj2v
         3DizIME/xRbs+EnhUC39e1FyQGxhEgouMKBSsgXUcfRStV6YdrESus3fmYJ2uQGf3MaJ
         WH6JaN/RkD6w7lrB4CTEFc4668R/n697hIVykBDYLdUTD4XDaysoEQnZWj86h1uod+J2
         e2xfF9I+OKL0fnFTI7cmAeZklZTcMZG8AHaxu8+A3kmRy1qL/2elHvp9S/SlzguS2clZ
         8bpw==
X-Gm-Message-State: AOJu0Yz7poAP7XBNAtqrM6tN7nYvb0QOqZSnSSLtXkjN1dl8a5rVe3bm
	XX+0zCClanqW20t+anYPE2UopKYcxHJMvQH3BwNzi/LvPrGNzOqHTQgvr6+2YvErjFxdo9TRKNH
	I5exAgQ+0xq4N4bd2laHtpPqZanKwC9pmbbwO
X-Gm-Gg: ASbGncvUjvwXizglh3HtwS20LNBE675m9BHPNnpbR9ZapNufMKn0D2dpYR/U9kcpswi
	/SMXQnRUT8NEdU6gSVm6XSOtC0Ap85rCCIQnoyk6kjyjnOHAyeq6L8wJnIISffyRJKHZy5b1sf5
	mz9+r2cnlsoHWtDn9nBpFbvgIb
X-Google-Smtp-Source: AGHT+IG6OsD42F1knNe3Kt9VjRfTzIWJ04jHpV3JKdkuhxaDtWGyJxm9xft2KkM6tmIjMhnXXjfbDbXbNxWWCB4wmEA=
X-Received: by 2002:a05:622a:19a0:b0:474:b6cb:faea with SMTP id
 d75a77b69052e-4751c6128a6mr2545721cf.25.1741258494501; Thu, 06 Mar 2025
 02:54:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com> <20250303171013.3548775-7-tabba@google.com>
 <Z8l8_J5ro97MsMuR@google.com>
In-Reply-To: <Z8l8_J5ro97MsMuR@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Mar 2025 10:54:17 +0000
X-Gm-Features: AQ5f1JpE7UvSKbJ3ozjQNKKGFVgoXYTnyCWiPZhh_kAgKiUUYyGIZ2pOslJRodU
Message-ID: <CA+EHjTwhVSWuFuCSFUSwO6e3LM=xb-1xEJgc6w4yqDcCZxfO2g@mail.gmail.com>
Subject: Re: [PATCH v5 6/9] KVM: arm64: Refactor user_mem_abort() calculation
 of force_pte
To: Quentin Perret <qperret@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, keirf@google.com, roypat@amazon.co.uk, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, 
	peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Mar 2025 at 10:46, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 03 Mar 2025 at 17:10:10 (+0000), Fuad Tabba wrote:
> > To simplify the code and to make the assumptions clearer,
> > refactor user_mem_abort() by immediately setting force_pte to
> > true if the conditions are met. Also, remove the comment about
> > logging_active being guaranteed to never be true for VM_PFNMAP
> > memslots, since it's not technically correct right now.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 13 ++++---------
> >  1 file changed, 4 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1f55b0c7b11d..887ffa1f5b14 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1460,7 +1460,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                         bool fault_is_perm)
> >  {
> >       int ret = 0;
> > -     bool write_fault, writable, force_pte = false;
> > +     bool write_fault, writable;
> >       bool exec_fault, mte_allowed;
> >       bool device = false, vfio_allow_any_uc = false;
> >       unsigned long mmu_seq;
> > @@ -1472,6 +1472,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       gfn_t gfn;
> >       kvm_pfn_t pfn;
> >       bool logging_active = memslot_is_logging(memslot);
> > +     bool force_pte = logging_active || is_protected_kvm_enabled();
> >       long vma_pagesize, fault_granule;
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> > @@ -1521,16 +1522,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               return -EFAULT;
> >       }
> >
> > -     /*
> > -      * logging_active is guaranteed to never be true for VM_PFNMAP
> > -      * memslots.
> > -      */
>
> Indeed, I tried to add the following snippeton top of upstream:
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1f55b0c7b11d..b5c3a6b9957f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1525,6 +1525,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          * logging_active is guaranteed to never be true for VM_PFNMAP
>          * memslots.
>          */
> +       WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP));
>         if (logging_active || is_protected_kvm_enabled()) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
>
> And I could easily get that thing to trigger --  the trick is to back a
> memslot with standard anon memory, enable dirty logging, and then mmap()
> with MAP_FIXED on top of that a VM_PFNMAP region, and KVM will happily
> proceed. Note that this has nothing to do with your series, it's just an
> existing upstream bug.
>

Thanks Quentin. Since you had told me about this offline before I
respun this series, I removed the warning I had in previous
iterations, the existing comment about logging_active, and made this
patch a "no functional change intended" one.

> Sadly that means the vma checks we do in kvm_arch_prepare_memory_region()
> are bogus. Memslots are associated with an HVA range, not the underlying
> VMAs which are not guaranteed stable. This bug applies to both the
> VM_PFNMAP checks and the MTE checks, I think.
>
> I can't immediately think of a good way to make the checks more robust,
> but I'll have a think. If anybody has an idea ... :-)
>

Cheers,
/fuad

> Thanks,
> Quentin
>
> > -     if (logging_active || is_protected_kvm_enabled()) {
> > -             force_pte = true;
> > +     if (force_pte)
> >               vma_shift = PAGE_SHIFT;
> > -     } else {
> > +     else
> >               vma_shift = get_vma_page_shift(vma, hva);
> > -     }
> >
> >       switch (vma_shift) {
> >  #ifndef __PAGETABLE_PMD_FOLDED
> > --
> > 2.48.1.711.g2feabab25a-goog
> >

