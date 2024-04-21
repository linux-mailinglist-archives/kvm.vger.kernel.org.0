Return-Path: <kvm+bounces-15421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C9C8ABDD2
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 02:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE0FF28131E
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 00:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9332C2107;
	Sun, 21 Apr 2024 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MPmkbA11"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20231645
	for <kvm@vger.kernel.org>; Sun, 21 Apr 2024 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713658809; cv=none; b=CcmI3vV2BCov/t131q54G2HtUfQduEC5tItP2di+yJTZ7S6qppkuOG4FECUQz4iXPo8NTQOVpkVMwiOOYNatFFsXt3eU8h0E7nrjQQQ7Evrwf77GdTQDkyqBWSh27Rhkl9+ZibtqJDe2aJcizeqrrdSFDkqSf4Qo7+pNQB1gmh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713658809; c=relaxed/simple;
	bh=3iI/ZwfiK90rE1vl9rkJqobbZPBa+/ZCwxY8qPyIrUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bdDBdw/+L0a1/bsivP+IeFfN/JooZAPzeVE0F2LEklsegTLpwam4GVL+dSYshHbyRPursipmcVtm1A9mI1Qi1VpAp77Taf9mlEiXxHWVOTw8eHs5GnFTBJNgHGWTqx0LB4LSKTc/9x3zpFN5LTchX2/Y7hOHy0pmvtFfvTfQpI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MPmkbA11; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-571e13cd856so9154a12.0
        for <kvm@vger.kernel.org>; Sat, 20 Apr 2024 17:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713658806; x=1714263606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oz0Tuj6DlzITFTKo1WuqGSj2CD5OL4MfynPTYKg49wk=;
        b=MPmkbA11LNgrZKk4vsRN+T5dMR0orzI7I4MFqpA4zRuCtyWZqjo/CgVe1ODZifLOqC
         cDIHhbGh/errrP761LxUQuVpMDRF+aLYzlu6Wt5j0HhoFRUZDZdudDi+gIagl9R4BV6U
         B13iuRz+0fuFFBP5tzxD0UFr/4qzyozhSlTIifjoxINX4MF2TkMysyn2Sdjn1AD7rbCj
         /jBBE4+yF0SkKo3TXcNhanX0eRNxCjTUzbCkiu19+wClsbOm2Q9t1ITNi8XGso3Y++nN
         IBHj2keaMHM42LtPLkQGzskwyFi02KV5HiOxdDxNxnebv4kzosIy+8kjf7Hg/R6/ikRh
         622w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713658806; x=1714263606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oz0Tuj6DlzITFTKo1WuqGSj2CD5OL4MfynPTYKg49wk=;
        b=PFJfbuQ+bEXDz0TYbM+jmq2wUkGnzNjkdN5E7DGQrKJO+GY+RlJBdBGem0T9ZvIZPY
         W6hjHVu4fV0pmgN92FFVXjkKAZd3oXzHVZ3gzYU2qK4SD6tCxDMn9AI6l+roGtMgsR2R
         A/I6OEQBcIjwj7rpJxMfqd9ufcw/E3EOhWBKWwEREkQNHkuulRegWKSWCuXv6nQzfsua
         zltSByXsOxpQHbI7+sEhZkJY3ZxQQi3a2Uim01tDzWIZrqPjVf9BH5EXXzkJrKElikvR
         ohDLMee3G+WDQ2hy122dQAo6tz4O6rz93sCG+78aRe4Dk5R004sOawH8IDXSUXi5Iw3p
         +GHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi/j/+fqec5BaO27FkAoW2GLhgNsjEvVhGCQnlH8FxISbqvUqbKNruEJwSEviYM2afllSTWwQPjx/bf2h5v8L1DUGp
X-Gm-Message-State: AOJu0Yx2vk1BZvhmYoKwHYKTsRax/7Bc7SINrr9wkf23usjyIIJ89znU
	Ql7KdlryukWuND1T+ZaUWSYh3TekvX2iqj+gYV+jMudbW6zfMoaPtGTP2Mfn9CP0tcRVy5zG6g/
	k0JAaHpuBZei9xZH3/tz3aDK1rPAcVqMIxVKj
X-Google-Smtp-Source: AGHT+IFnrvPCNneqerzD05ClyZhnz2EnkFQKegicnMvDgyA8/2oshU9h8CQq7U+j3yGfhKQTM0feyi/OqvJPICIP0e4=
X-Received: by 2002:a50:ec95:0:b0:571:fc6f:426a with SMTP id
 e21-20020a50ec95000000b00571fc6f426amr28507edr.6.1713658806100; Sat, 20 Apr
 2024 17:20:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com> <ZhgZHJH3c5Lb5SBs@google.com>
 <Zhgdw8mVNYZvzgWH@google.com> <CADrL8HUpHQQbQCxd8JGVRr=eT6e4SYyfYZ7eTDsv8PK44FYV_A@mail.gmail.com>
 <ZiLc8OfXxc9QWxtg@google.com> <CADrL8HUmGFP=w5COnJzyJ+2a2gjCugqQg9WDXQ2ZAK7B9gJThA@mail.gmail.com>
In-Reply-To: <CADrL8HUmGFP=w5COnJzyJ+2a2gjCugqQg9WDXQ2ZAK7B9gJThA@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Sat, 20 Apr 2024 18:19:28 -0600
Message-ID: <CAOUHufb5di7t4aHx7jNJvMd_L85b=xoJvO4V4RGi+nY78rpF_Q@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
To: James Houghton <jthoughton@google.com>
Cc: David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 3:48=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Fri, Apr 19, 2024 at 2:07=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On 2024-04-19 01:47 PM, James Houghton wrote:
> > > On Thu, Apr 11, 2024 at 10:28=E2=80=AFAM David Matlack <dmatlack@goog=
le.com> wrote:
> > > > On 2024-04-11 10:08 AM, David Matlack wrote:
> > > > bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > > {
> > > >         bool young =3D false;
> > > >
> > > >         if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps=
(kvm))
> > > >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_=
rmap);
> > > >
> > > >         if (tdp_mmu_enabled)
> > > >                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
> > > >
> > > >         return young;
> > > > }
> > > >
> > > > bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > > {
> > > >         bool young =3D false;
> > > >
> > > >         if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps=
(kvm))
> > > >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_test=
_age_rmap);
> > > >
> > > >         if (tdp_mmu_enabled)
> > > >                 young |=3D kvm_tdp_mmu_test_age_gfn(kvm, range);
> > > >
> > > >         return young;
> > >
> > >
> > > Yeah I think this is the right thing to do. Given your other
> > > suggestions (on patch 3), I think this will look something like this
> > > -- let me know if I've misunderstood something:
> > >
> > > bool check_rmap =3D !bitmap && kvm_memslot_have_rmaps(kvm);
> > >
> > > if (check_rmap)
> > >   KVM_MMU_LOCK(kvm);
> > >
> > > rcu_read_lock(); // perhaps only do this when we don't take the MMU l=
ock?
> > >
> > > if (check_rmap)
> > >   kvm_handle_gfn_range(/* ... */ kvm_test_age_rmap)
> > >
> > > if (tdp_mmu_enabled)
> > >   kvm_tdp_mmu_test_age_gfn() // modified to be RCU-safe
> > >
> > > rcu_read_unlock();
> > > if (check_rmap)
> > >   KVM_MMU_UNLOCK(kvm);
> >
> > I was thinking a little different. If you follow my suggestion to first
> > make the TDP MMU aging lockless, you'll end up with something like this
> > prior to adding bitmap support (note: the comments are just for
> > demonstrative purposes):
> >
> > bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > {
> >         bool young =3D false;
> >
> >         /* Shadow MMU aging holds write-lock. */
> >         if (kvm_memslots_have_rmaps(kvm)) {
> >                 write_lock(&kvm->mmu_lock);
> >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap=
);
> >                 write_unlock(&kvm->mmu_lock);
> >         }
> >
> >         /* TDM MMU aging is lockless. */
> >         if (tdp_mmu_enabled)
> >                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
> >
> >         return young;
> > }
> >
> > Then when you add bitmap support it would look something like this:
> >
> > bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > {
> >         unsigned long *bitmap =3D range->arg.metadata->bitmap;
> >         bool young =3D false;
> >
> >         /* SHadow MMU aging holds write-lock and does not support bitma=
p. */
> >         if (kvm_memslots_have_rmaps(kvm) && !bitmap) {
> >                 write_lock(&kvm->mmu_lock);
> >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap=
);
> >                 write_unlock(&kvm->mmu_lock);
> >         }
> >
> >         /* TDM MMU aging is lockless and supports bitmap. */
> >         if (tdp_mmu_enabled)
> >                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
> >
> >         return young;
> > }
> >
> > rcu_read_lock/unlock() would be called in kvm_tdp_mmu_age_gfn_range().
>
> Oh yes this is a lot better. I hope I would have seen this when it
> came time to actually update this patch. Thanks.
>
> >
> > That brings up a question I've been wondering about. If KVM only
> > advertises support for the bitmap lookaround when shadow roots are not
> > allocated, does that mean MGLRU will be blind to accesses made by L2
> > when nested virtualization is enabled? And does that mean the Linux MM
> > will think all L2 memory is cold (i.e. good candidate for swapping)
> > because it isn't seeing accesses made by L2?
>
> Yes, I think so (for both questions). That's better than KVM not
> participating in MGLRU aging at all, which is the case today (IIUC --
> also ignoring the case where KVM accesses guest memory directly). We
> could have MGLRU always invoke the mmu notifiers, but frequently
> taking the MMU lock for writing might be worse than evicting when we
> shouldn't. Maybe Yu tried this at some point, but I can't find any
> results for this.

No, in this case only the fast path (page table scanning) is disabled.
MGLRU still sees the A-bit from L2 using the rmap, i.e., the slow path
calling folio_check_references().

