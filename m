Return-Path: <kvm+bounces-22274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6E493CC1B
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 02:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE2A81C215C7
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 00:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2256C3C30;
	Fri, 26 Jul 2024 00:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fe7K/vzq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FC180B
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721954109; cv=none; b=gPHAzvgPhDvD58lMjtZu0cpPhT4zlwqmY+ec81fwAQNhUKYjU4EZyIO8Jk3k4/JTUwBcyhrSftn9/VxQ6v/aFT4NeuNHUd8bd4lYM7sadK+HM8F0GStkhF+RBuyh6oGH+KA3Zpc/KWm68itJlZPV4tiR1lcNkBIytGeQ/BMXVyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721954109; c=relaxed/simple;
	bh=eXsvx/oB2qbjHdSp6vi8FE0sL5fteTwRYvum4R3pSAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aQwUJ9qRmnYmbmDfuqKxTWdYBlSymT0Ht9+8W7GftyrNDWl9g8Vlyn4ouZ/Sk5aac8zrnkByut5qj/kkE/XVcF7Ml0wKKOAr10voGjxCGLvRB4TkvKXybRx3n11ykKXaFx52yM/oL0vPj9nLwmTbaw0NhwrUIEy9T3UZem9YO8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fe7K/vzq; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fd657c9199so26935ad.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 17:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721954106; x=1722558906; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXmOiT3ja7tbFfoShPzcte9+u5DgaoMfXxdrhdWg4sE=;
        b=Fe7K/vzqIkO2XB6kGODBl/cQ+t/LtaxPaN0VuUg/G+7j0Nht2KSMN9ShODCTyNhKh4
         H4b+QVDSbkCYKJDgb2xlztZv7NSWloe9m7yB6tpBBo6Y7rmJGjGs8GggPVbqeqUQv8aO
         HBcERGvbQJOazTzoV0jGydKZUHmZa1CcPO98mnrstRvLUc4+vkRkVchnBWyLJ9LEGyXC
         JjuvVrTxNtT52tHE+R6sT1dB8GOG0al1hf/zAo4tTTYc+iEHpQfsmKIO33yuKlkXBZuI
         y8iavahxE1I2pwI7ahkdmItlZpRzG9eIJcuRJgIes7R4+ACjgtV7iUX+x1fD/B7b1575
         uRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721954106; x=1722558906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YXmOiT3ja7tbFfoShPzcte9+u5DgaoMfXxdrhdWg4sE=;
        b=pEeXadvJMQqdF4iDRUPc93w6SDIgdjpapi+wfjUYZWExmPWwxlEkoyP5tqQd3k69jO
         8sCYhtWk0Kxsl8dMw8wy8I7528lV6ifQsI0vBLrKIgb10pEmwgt+xZR8YaDIGtWGPI8B
         JOaq57CapRc8IakdoT/D/cF/J+w0g8hsqh657RGSnit3bFmbFktbIBAF9fv/RWp+7c/0
         j2DgDaqZhfM/GphKjgcSEerWmYSQBaTAEvguUOdmj6xyZVyKLiBSfYh+uHJy9xN7Jahu
         TvlAd+fU/oqE59S/VJeZZyyQ3Xdt+cEvnUN2vfvaA9k9ZkTXp4LDKs1pxzu6wYQ4uQBq
         8bww==
X-Forwarded-Encrypted: i=1; AJvYcCWr69Qe6bl7d8WwxJnWUSLq7WUufjgnDKVBz9nrPFahM49jFMQ0NUbWBvW6hpFsOTVBge577RaCNTBQs6D7FFXtScNK
X-Gm-Message-State: AOJu0YxsIdhFAKZyPknHMLnmwra4jPgjSxbjZKtqsMj1v5PsivY8COMv
	2RHJvqTRXwjVRyAOOKJpARCUlJLyWChbO/w+6qxC9yHICSqI2VF+AIJTSo0VpAr0Nb4HHo7U9ZG
	NA0CAoGND1AZTO9bi0ECvN4U9cRheh14Xvtdm
X-Google-Smtp-Source: AGHT+IFnv7tfdYJpXM8klvYkuM0VxwmIgdPCwCR+A2LuBYkT8SZpSWEYLkUMwdBrr+1/n3tswklB7a7UCo/1ZzddTK8=
X-Received: by 2002:a17:903:2988:b0:1f3:3ede:9b0 with SMTP id
 d9443c01a7336-1feee856698mr1378625ad.10.1721954105611; Thu, 25 Jul 2024
 17:35:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com> <ZqKUefN3HgBQQkuA@google.com>
In-Reply-To: <ZqKUefN3HgBQQkuA@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 25 Jul 2024 17:34:29 -0700
Message-ID: <CADrL8HXoGeafwNvSyMF0=MMjkbodyYrA6+J638QXgyC_TW76XQ@mail.gmail.com>
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 11:08=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2024-07-24 01:10 AM, James Houghton wrote:
> > Walk the TDP MMU in an RCU read-side critical section. This requires a
> > way to do RCU-safe walking of the tdp_mmu_roots; do this with a new
> > macro. The PTE modifications are now done atomically, and
> > kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for th=
e
> > fact that kvm_age_gfn can now lockless update the accessed bit and the
> > R/X bits).
> >
> > If the cmpxchg for marking the spte for access tracking fails, we simpl=
y
> > retry if the spte is still a leaf PTE. If it isn't, we return false
> > to continue the walk.
> >
> > Harvesting age information from the shadow MMU is still done while
> > holding the MMU write lock.
> >
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> Aside from the comment fixes below,
>
> Reviewed-by: David Matlack <dmatlack@google.com>

Thank you!

>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/Kconfig            |  1 +
> >  arch/x86/kvm/mmu/mmu.c          | 10 ++++-
> >  arch/x86/kvm/mmu/tdp_iter.h     | 27 +++++++------
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++--------
> >  5 files changed, 77 insertions(+), 29 deletions(-)
> >
> [...]
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_=
ptep_t sptep, u64 new_spte)
> >       return xchg(rcu_dereference(sptep), new_spte);
> >  }
> >
> > +static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64=
 mask)
> > +{
> > +     atomic64_t *sptep_atomic =3D (atomic64_t *)rcu_dereference(sptep)=
;
> > +
> > +     return (u64)atomic64_fetch_and(~mask, sptep_atomic);
> > +}
> > +
> >  static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_=
spte)
> >  {
> >       KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
> > @@ -32,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_pte=
p_t sptep, u64 new_spte)
> >  }
> >
> >  /*
> > - * SPTEs must be modified atomically if they are shadow-present, leaf
> > - * SPTEs, and have volatile bits, i.e. has bits that can be set outsid=
e
> > - * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
> > - * handler, and Accessed and Dirty bits can be set by the CPU.
> > + * SPTEs must be modified atomically if they have bits that can be set=
 outside
> > + * of the mmu_lock. This can happen for any shadow-present leaf SPTEs,=
 as the
> > + * Writable bit can be set by KVM's fast page fault handler, the Acces=
sed and
> > + * Dirty bits can be set by the CPU, and the Accessed and R/X bits can=
 be
>
> "R/X bits" should be "W/R/X bits".

Thanks. Right, we are clearing all of VMX_EPT_RWX_MASK.

>
> > + * cleared by age_gfn_range.
>
> nit: "age_gfn_range()"

Thanks, will fix this and all the other places where I've left off the ().

