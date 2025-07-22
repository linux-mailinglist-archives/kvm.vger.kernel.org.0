Return-Path: <kvm+bounces-53110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F405B0D764
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 12:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95C805615C0
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 10:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913172DECCC;
	Tue, 22 Jul 2025 10:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k/02Fx6v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97D6288C0F
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753180572; cv=none; b=tmAlyIM9GvVUK1bGh/OY4Davi1MtjSVFn9cPATfD0pYBytcUB9vNHhIXlnqwN5xC+WAX9m7vqKw1A4I6nmlmH4LzOOw8ABAsfDB3HWivjCM4aPSA/h8m0cIavJlirGJPj8uUVmUyax58mJltVHPUNtOxHXoNbXfuT+z+g+4Wyzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753180572; c=relaxed/simple;
	bh=Es8rvtELoL3Efx2Ylf7dLNukFAd8ZQcCqR7sAg8srHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kTW0lHPFXvT2bL8NmDtwOCmk8kRRKWOthpSvoPIS60BXdBC2PgNv6YD9h8DKQ3vlo2uZt4tH8WT9epYvETmCtVq0VgU9TJnN2F6C5jZ3WdCmw+kXMfVSodv7t2XSsFKwysom6AfTsD5y1grqjbcnnQRfDRisRUnCQ0+TIiO9kRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k/02Fx6v; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3855fca3so210061cf.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753180568; x=1753785368; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h2sNENsiUXWZHkoFKe8iTv45YtKCJ7msVi+m+Dnfo0w=;
        b=k/02Fx6vepOfFDyb7Tt0a0bgAXJiaNqe57wr/K45wcFqtcnHhZY4g2IR7+90OnZBtY
         gEMMrJGqxSHa0G69LT9tQYOI+rtGKpHvdjclQ09JA4oxQgx2MAEB5QdcklxO4IjJCinO
         ccCAfyDUPrS8QhJ7/bvIQvG8578iu31Xa3NnSo7vrcQ/FD/ujrsnLuh4A2DRbYABeu77
         KiIpzyX+79cUU8cK7Rss5JgWOJuJ4UFMNZt3bIWwL92btvkW3Fo9jrYtbyy5UxdkFPkh
         eJ8G3ipQsgiXScZ/CuxCWKD48tIR92eEVfweyuvIOzwfoaD2w5XGqGD0iGNFruVAnWrq
         5Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753180568; x=1753785368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h2sNENsiUXWZHkoFKe8iTv45YtKCJ7msVi+m+Dnfo0w=;
        b=nMnnXOOFJPg8z7AfRQpMqcCJlrIKl4tHiTYoIezZC7GbX2s9+LHnzJOmRv8m7lvpbA
         4ELGJ2AVqM4xsr9X7wjlVrf+CU/UWwCwROkb5wRFqelqTn43TT9FRa0AXy8RZDrZYr9o
         E/RPubTeyRrPm6ukZms9NyYvy88WxtX4Pz5vUw+aBIDI2yl41TtMfYd9Il9PfxW2py6I
         l6HjrkzAjLeKf7hB+pATQ4QEd7xMBpYNW1HKLAKsokS+5IDockIhHsGViHPNxzHyhAnc
         TJYSy9C6SzhgWpwCiHJcOTr36cWP+Loa5f473Y0Wadjwy3fXjgOS6+qh3mUbR1BGdxzf
         N1og==
X-Forwarded-Encrypted: i=1; AJvYcCUmEQ8NQa7vgAwyT/mmULDqmPTQUzsHbQow69acjMtj5X9WeCCCpcdVekpy1EDmWUcKqbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrnTFk2G2+O/N9d/MvvQa94W/s8HFaomq5iz3xMvt0P2m4GBGG
	UJAtauxsGYzjm54LlAxWVkrsTOUvHOdl/2lfB0/XFi0FwQrY8qMzSJqz9bxXs19QBFIldG9xc1Y
	6MuQ6DcXUKvqzbWFzE1k3uKfoJQMoicOX+xCc3h84
X-Gm-Gg: ASbGncvEtIZVYiVZgQIURhZ1c+WTp30UbK0MhZQtA7jt7uVszgnXOBoGzlGFCc/75NK
	R24pSsRv12CfB+Oos8MWy/UHpSt0gwDRy4vb2v9BtkN2aXOZ5mg4TLrkVXzuI98MHRFnL7oGZBJ
	A+taYrVND6Tg1evmOVCvlOLUTmf8Q2CdwFI3jZvAhO8RuOiaCfeoPAAG+/GBKZprK7g+nSyN+jC
	jaEAU+K2JzozYQdwXpNQ5q10RFVOQTXsA5K
X-Google-Smtp-Source: AGHT+IEvqsS58GzqZAYQQgB7BqYiKCpYg+Q8XL/j8/io4oCnmPzNh5X8oKUHq2YYykzKu368BpAYr2MBwji0MjUioSA=
X-Received: by 2002:a05:622a:1dc6:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4ae5cc6a1d5mr4457581cf.10.1753180567987; Tue, 22 Jul 2025
 03:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
In-Reply-To: <aH7KghhsjaiIL3En@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 11:35:31 +0100
X-Gm-Features: Ac12FXxlfQG4ofD1slov5tvKwsHTWTtSvMayWg2TOJeHuE2UtcTH2RrcWmi_y7k
Message-ID: <CA+EHjTwAVSRU=3FHqV5xrvi5-RfhYDhpoAoYuaU7atSuOv_r_Q@mail.gmail.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Jul 2025 at 00:17, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jul 18, 2025, Xiaoyao Li wrote:
> > On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > > From: Ackerley Tng <ackerleytng@google.com>
> > >
> > > Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
> > > pointer and rename it to kvm_gmem_max_mapping_level().
> > >
> > > The max_mapping_level x86 operation (previously private_max_mapping_level)
> > > is designed to potentially be called without an active page fault, for
> > > instance, when kvm_mmu_max_mapping_level() is determining the maximum
> > > mapping level for a gfn proactively.
> > >
> > > Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
> > > safely handle a NULL fault argument. This aligns its interface with the
> > > kvm_x86_ops.max_mapping_level operation it wraps, which can also be
> > > called with NULL.
> >
> > are you sure of it?
> >
> > The patch 09 just added the check of fault->is_private for TDX and SEV.
>
> +1, this isn't quite right.  That's largely my fault (no pun intended) though, as
> I suggested the basic gist of the NULL @fault handling, and it's a mess.  More at
> the bottom.
>
> > > Rename function to kvm_gmem_max_mapping_level(): This reinforces that
> > > the function's scope is for guest_memfd-backed memory, which can be
> > > either private or non-private, removing any remaining "private"
> > > connotation from its name.
> > >
> > > Optimize max_level checks: Introduce a check in the caller to skip
> > > querying for max_mapping_level if the current max_level is already
> > > PG_LEVEL_4K, as no further reduction is possible.
> > >
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Suggested-by: Sean Christoperson <seanjc@google.com>
> > > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
> > >   1 file changed, 7 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index bb925994cbc5..6bd28fda0fd3 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
> > >     return PG_LEVEL_4K;
> > >   }
> > > -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> > > -                                   struct kvm_page_fault *fault,
> > > -                                   int gmem_order)
> > > +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> > > +                                struct kvm_page_fault *fault)
> > >   {
> > > -   u8 max_level = fault->max_level;
> > >     u8 req_max_level;
> > > +   u8 max_level;
> > > -   if (max_level == PG_LEVEL_4K)
> > > -           return PG_LEVEL_4K;
> > > -
> > > -   max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> > > +   max_level = kvm_max_level_for_order(order);
> > >     if (max_level == PG_LEVEL_4K)
> > >             return PG_LEVEL_4K;
> > > @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > >     }
> > >     fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> > > -   fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
> > > +   if (fault->max_level >= PG_LEVEL_4K)
> > > +           fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
> > > +                                                         max_order, fault);
> >
> > I cannot understand why this change is required. In what case will
> > fault->max_level < PG_LEVEL_4K?
>
> Yeah, I don't get this code either.  I also don't think KVM should call
> kvm_gmem_max_mapping_level() *here*.  That's mostly a problem with my suggested
> NULL @fault handling.  Dealing with kvm_gmem_max_mapping_level() here leads to
> weirdness, because kvm_gmem_max_mapping_level() also needs to be invoked for the
> !fault path, and then we end up with multiple call sites and the potential for a
> redundant call (gmem only, is private).
>
> Looking through surrounding patches, the ordering of things is also "off".
> "Generalize private_max_mapping_level x86 op to max_mapping_level" should just
> rename the helper; reacting to !is_private memory in TDX belongs in "Consult
> guest_memfd when computing max_mapping_level", because that's where KVM plays
> nice with non-private memory.
>
> But that patch is also doing too much, e.g. shuffling code around and short-circuting
> the non-fault case, which makes it confusing and hard to review.  Extending gmem
> hugepage support to shared memory should be "just" this:
>
> @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>         if (max_level == PG_LEVEL_4K)
>                 return PG_LEVEL_4K;
>
> -       if (is_private)
> -               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +       if (is_private || kvm_memslot_is_gmem_only(slot))
> +               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> +                                                       is_private);
>         else
>                 host_level = host_pfn_mapping_level(kvm, gfn, slot);
>         return min(host_level, max_level);
>
> plus the plumbing and the small TDX change.  All the renames and code shuffling
> should be done in prep patches.
>
> The attached patches are compile-tested only, but I think they get use where we
> want to be, and without my confusing suggestion to try and punt on private mappings
> in the hugepage recovery paths.  They should slot it at the right patch numbers
> (relative to v15).
>
> Holler if the patches don't work, I'm happy to help sort things out so that v16
> is ready to go.

These patches apply, build, and run. I'll incorporate them, test them
a bit more with allmodconf and friends, along with the other patch
that you suggested, and respin v16 soon.

Cheers,
/fuad

