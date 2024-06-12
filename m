Return-Path: <kvm+bounces-19487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A289059F7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E98DE285B7A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124B01822DA;
	Wed, 12 Jun 2024 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yZgdmIRv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA80EBB
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213492; cv=none; b=Epnrb+IwUn0KoMspkeFWwQgawb+baYZ1usk1O3cjZ+m+jl6exHFFvJroTxyB4XoawizfqZugkT/Qzhs+o4/caAo0tCm76z5pAZ2frfcCyapHmQlFqj9EeNjU7HSTup3HfR58A1umlvdLA+E1gl5Hs/reSaMAlJma0O6orx19aYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213492; c=relaxed/simple;
	bh=BVxVglBu/aJdIm8zaMwOg3iRpiLrT6XOkxr2cN79Qtg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e4HgCJZvdnYayysDROLD96eQZoz8Yc6zspl4ud88fYhWhVIVffpRgdxm54zih0j/klw/wACAxlWVc6GzhKdMqrhRQX5cXlhtatYw0vy03zFakqczQcVM08Y9S6N0pQFCyH1ap+Zibj9i9jUGkg+FD45kQio993kWAUTpbVE5hZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yZgdmIRv; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f71d5a85f9so1532995ad.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718213489; x=1718818289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZttrWbEybPZrU6j9LIdJZge1/Pd2kmv/UPX9FdzbJ4o=;
        b=yZgdmIRv2moEI8Zld6u/VkhMeDaPNBowLD5mqzgUawyckf+6uKgiEpnvneIfP4v8FV
         WOmAWW33+keA4TocyR7SUMJNYlJpph+hMQPsIC1mrHssbSFAHZTXAqQI2k+94Z3JGRZn
         ssrk2ZmjVaV6UA0nwa0tJ4gqdz4iSiDj1mEE2QfORsmHVs/vuIIHBKIISR8+YIwFMihi
         uWyFttAx4xGdHXoGdh0ZviEmhP6pdwqNgaKk7Jk1eMhE78nW8BaFAkeky4PAgXWNl+0N
         cPERpKsYDxaqxIt6hjIe2mhbLo4cc0aMRh490Ha3fAaChpygl6QgWdjucY1jWosdeXr3
         b4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718213490; x=1718818290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZttrWbEybPZrU6j9LIdJZge1/Pd2kmv/UPX9FdzbJ4o=;
        b=TSh/y7SRrpwkTBC7H8H1dcWikt+SR43dTIwzR1tLOemiMy5jfl3sYyT9vZFJ5QGT8K
         2c4LE/WoRGkzbGgNz81zH2UfrEE4TxlRjSUNUb1JydDBc7h5L2JGDXT1bQ9y3IaZgcJa
         AvbclE4GDqU0YCqYm+JnwUEzM0FdhLt8AG5HzY1Blapb5ZG7HpDOTFPq1z7wh0aFuytI
         TCmcnTsfdIXH4dzDKPgIbKaULj4JTaiK/cqKT4NVCEtQmWQgSSquh5cV/9PojsoG6B1V
         8sF1vEnSjMOkTwSMkiQybWV1UoRjrQ8mN/JzW2eLo0a8mZDuzZIddxwSi0PHdXzfdx54
         1PiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgWcLLlczk8fa8i5ChZgcwVDSLJZWNig7DRzMpALHJkH1D7SLPaSWYTrHb4rP4WyxT4yOmkWeR+i4Rt4QgbTSCy7Gx
X-Gm-Message-State: AOJu0YxqlXYXz9kR4okjJgWWvjQ9aiOo0KVUu9OmXwpMZbwTdtXz5+w2
	peXG/4oRE8fEduho2tIQ1hV/W6qm5/gd4vVgh0yoOQkMjPWwrbEHCprX31PfQ6+zS7JOeweMCSB
	Tkg==
X-Google-Smtp-Source: AGHT+IEfEUqjAJd5HwtcI3SellD9wJyKICC45AOG2hDSPfUBXvAeRlQriWUGwdY0fjJOl8E1dOYOBVVBc8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:182:b0:1f3:4b2a:1acb with SMTP id
 d9443c01a7336-1f83b23ddb1mr79315ad.0.1718213489334; Wed, 12 Jun 2024 10:31:29
 -0700 (PDT)
Date: Wed, 12 Jun 2024 10:31:27 -0700
In-Reply-To: <Zmm9SdVfg18RECT5@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405115815.3226315-2-pbonzini@redhat.com> <20240412104408.GA27645@willie-the-truck>
 <86jzl2sovz.wl-maz@kernel.org> <ZhlLHtfeSHk9gRRO@google.com>
 <86h6g5si0m.wl-maz@kernel.org> <Zh1d94Pl6gneVoDd@google.com>
 <20240418141932.GA1855@willie-the-truck> <ZiF6NgGYLSsPNEOg@google.com>
 <20240419112432.GB2972@willie-the-truck> <Zmm9SdVfg18RECT5@google.com>
Message-ID: <Zmnbb-Xlyz4VXNHI@google.com>
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin <npiggin@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, Will Deacon wrote:
> > On Thu, Apr 18, 2024 at 12:53:26PM -0700, Sean Christopherson wrote:
> > > On Thu, Apr 18, 2024, Will Deacon wrote:
> > > > > I assume the idea would be to let arch code do single-page invalidations of
> > > > > stage-2 entries for each gfn?
> > > > 
> > > > Right, as it's the only code which knows which ptes actually ended up
> > > > being aged.
> > > > 
> > > > > Unless I'm having a brain fart, x86 can't make use of that functionality.  Intel
> > > > > doesn't provide any way to do targeted invalidation of stage-2 mappings.  AMD
> > > > > provides an instruction to do broadcast invalidations, but it takes a virtual
> > > > > address, i.e. a stage-1 address.  I can't tell if it's a host virtual address or
> > > > > a guest virtual address, but it's a moot point because KVM doen't have the guest
> > > > > virtual address, and if it's a host virtual address, there would need to be valid
> > > > > mappings in the host page tables for it to work, which KVM can't guarantee.
> > > > 
> > > > Ah, so it sounds like it would need to be an arch opt-in then.
> > > 
> > > Even if x86 (or some other arch code) could use the precise tracking, I think it
> > > would make sense to have the behavior be arch specific.  Adding infrastructure
> > > to get information from arch code, only to turn around and give it back to arch
> > > code would be odd.
> > 
> > Sorry, yes, that's what I had in mind. Basically, a way for the arch code
> > to say "I've handled the TLBI, don't worry about it."
> > 
> > > Unless arm64 can't do the invalidation immediately after aging the stage-2 PTE,
> > > the best/easiest solution would be to let arm64 opt out of the common TLB flush
> > > when a SPTE is made young.
> > > 
> > > With the range-based flushing bundled in, this?
> > > 
> > > ---
> > >  include/linux/kvm_host.h |  2 ++
> > >  virt/kvm/kvm_main.c      | 40 +++++++++++++++++++++++++---------------
> > >  2 files changed, 27 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index afbc99264ffa..8fe5f5e16919 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -2010,6 +2010,8 @@ extern const struct kvm_stats_header kvm_vcpu_stats_header;
> > >  extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
> > >  
> > >  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> > > +int kvm_arch_flush_tlb_if_young(void);
> > > +
> > >  static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
> > >  {
> > >  	if (unlikely(kvm->mmu_invalidate_in_progress))
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 38b498669ef9..5ebef8ef239c 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -595,6 +595,11 @@ static void kvm_null_fn(void)
> > >  }
> > >  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
> > >  
> > > +int __weak kvm_arch_flush_tlb_if_young(void)
> > > +{
> > > +	return true;
> > > +}
> > 
> > I tend to find __weak functions a little ugly, but I think the gist of the
> > diff looks good to me. Thanks for putting it together!
> 
> Circling back to this, I don't think we should pursue this specific tweak, at
> least not without hard data for a concrete use case.

Ha, I spoke too soon.  Based on the learning from the KVM+MGLRU thread[*], it
looks like KVM should omit the TLB flush when aging pages whenever possible.  If
that's not doable on all architectures for whatever reason, then something like
this is probably the way to go.

[*] https://lore.kernel.org/all/CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com

