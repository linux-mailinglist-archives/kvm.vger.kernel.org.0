Return-Path: <kvm+bounces-22273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 906C893CC14
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 02:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97AA61C20F9A
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 00:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBEC41879;
	Fri, 26 Jul 2024 00:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NxbFhHb1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78060803
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721953775; cv=none; b=a0hKSz+oViBYeJ9XMTcnCF6ChIf6GtTgONW0l5AYYNX7cH46iMtcuHQ4oAnEBZ9l9XGJuTIhzhRuhNkLnfTExQ+FT70gUwFwzTozgl7okGUNSS7PVGjatCGG4Y45qOGMaLV3Jx7ficwr8zCc5sNTC4ADkHUUr3NQzv1qCvem7is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721953775; c=relaxed/simple;
	bh=kviLB+w2lXuUML0TzG8iXmFtCyiR/hwIxPgrFeBKB2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QCA69Z930EMEuJ3BRa/6VAO53GlOWVN6JhNr8XGorgyFIUeHCItH8hV7rTU17wOZIW5fESbh47nKXKcmmr+h6YObJwVgjrGBQUo/UxkEHtT8CnqrGi1+GrKdff6YYJm7zNo3oH5dyD/r+6ipcVtxnqNwL+PON1ACVPtmBUuPmBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NxbFhHb1; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-44fdc70e695so63861cf.0
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 17:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721953771; x=1722558571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbyJs6ojjDUY/aYBbei0H0GJsGGC+U+B84+bho9NthY=;
        b=NxbFhHb12wnDT1rcGSIK0tAabxi1zIzCVPKIJFFlB6A0QgeHU+mAbfprCf4kmykCyw
         9J0u6YLicl/LinKjflrsZ+Lcdv/lEvlXaGA8hE/97A4cJI1L7G7R4/XEta3CUfHnEbz3
         JfhLdYFytj1AYSxqDmLDA+CDR+/LbrYsjZy5zAiZAvOZmfPsuPMbExrW1uk1FEahUZ3g
         MTDEdz/VCkTlTI6vDi8bf1u39jRvy6GWzdCYHLaLVBT5Kj4vUCtFuV4FxnyBHd6WfG3S
         n9Oar9+3MHfmtrdVogs4tnchSc+AaF7mtRl4Auh8qokljJ67aZYkAJOZ10g+gVeXf9l2
         Yd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721953771; x=1722558571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbyJs6ojjDUY/aYBbei0H0GJsGGC+U+B84+bho9NthY=;
        b=SNeFxmaEJHdhhheeVCic4uSUPqg2zKWlpGn+VK+KIxSrGA5bRoqKp7ztI0YNJdaNzG
         b6JMED5w6qYcU8M6QZ3F2C3cXc1nCwEhlrUVWerMK6nlvwHTGfOd6Y8adqhNYzdMBakX
         utLlDCNQUSQFDEEdcG7StoQ6VCyK9AAj1NtekiYqE7cN8fOh12eq1K49ziEBXr/e3tXU
         hoM1v3MIwXMydJqLyUj/CuodKJSnPwGfArB6C5qgEywpCunMv9oA8TRLJhTrjmV8QLSQ
         86UsG2DtEee7lSbMXxAJKJRDUDyIOure7amiL/DtwwwPl8zkg3K301pCpZuQssxj8Dil
         x51w==
X-Forwarded-Encrypted: i=1; AJvYcCVUmL903karai3V9lzjfpIDsKiZDJWsUjY7jYlROD4bNWrvLtFhvG1Gy05lGyGiLdDZeTr2G2TVfjXh7QlAKB2qar0t
X-Gm-Message-State: AOJu0YzmMZHjOFo98QODmnaWLn+ebLYUzpo/+wHC7n5AiKk0yylVNEE1
	OuCrFGJ+vMJdCsQJzdr4N13o2Lw7xejMdGhsLZDUx8N6pGt+gJvst615votrRDAKFe89HNjkimZ
	6xRNb4NJUWMAoqC9jrxfAaIUS0EP7zyLmdwpQ
X-Google-Smtp-Source: AGHT+IEAKXr1ckGzIAW0Zij5lROUgzcsWDVkCYVl2RWE/gIa1eP8NSl4F+ePaiwMP4UG1WnczScB6df5XE4x/GMY03s=
X-Received: by 2002:a05:622a:1ba6:b0:447:f5de:bd18 with SMTP id
 d75a77b69052e-44ff3e5d32amr1488861cf.9.1721953771125; Thu, 25 Jul 2024
 17:29:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-2-jthoughton@google.com> <ZqJ_xANKf3bNcaHM@google.com>
In-Reply-To: <ZqJ_xANKf3bNcaHM@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 25 Jul 2024 17:28:55 -0700
Message-ID: <CADrL8HW2mjC=ukNBG6Tww+Y3t6poU0ZM5uQJteTk4e8kj-s2wA@mail.gmail.com>
Subject: Re: [PATCH v6 01/11] KVM: Add lockless memslot walk to KVM
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

On Thu, Jul 25, 2024 at 9:39=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2024-07-24 01:10 AM, James Houghton wrote:
> > Provide flexibility to the architecture to synchronize as optimally as
> > they can instead of always taking the MMU lock for writing.
> >
> > Architectures that do their own locking must select
> > CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.
> >
> > The immediate application is to allow architectures to implement the
> > test/clear_young MMU notifiers more cheaply.
> >
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> Aside from the cleanup suggestion (which should be in separate patches
> anyway):
>
> Reviewed-by: David Matlack <dmatlack@google.com>

Thanks David!

>
> > ---
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/Kconfig         |  3 +++
> >  virt/kvm/kvm_main.c      | 26 +++++++++++++++++++-------
> >  3 files changed, 23 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 689e8be873a7..8cd80f969cff 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -266,6 +266,7 @@ struct kvm_gfn_range {
> >       gfn_t end;
> >       union kvm_mmu_notifier_arg arg;
> >       bool may_block;
> > +     bool lockless;
> >  };
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)=
;
> >  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index b14e14cdbfb9..632334861001 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -100,6 +100,9 @@ config KVM_GENERIC_MMU_NOTIFIER
> >         select MMU_NOTIFIER
> >         bool
> >
> > +config KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
> > +       bool
> > +
> >  config KVM_GENERIC_MEMORY_ATTRIBUTES
> >         depends on KVM_GENERIC_MMU_NOTIFIER
> >         bool
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d0788d0a72cc..33f8997a5c29 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -555,6 +555,7 @@ struct kvm_mmu_notifier_range {
> >       on_lock_fn_t on_lock;
> >       bool flush_on_ret;
> >       bool may_block;
> > +     bool lockless;
> >  };
> >
> >  /*
> > @@ -609,6 +610,10 @@ static __always_inline kvm_mn_ret_t __kvm_handle_h=
va_range(struct kvm *kvm,
> >                        IS_KVM_NULL_FN(range->handler)))
> >               return r;
> >
> > +     /* on_lock will never be called for lockless walks */
> > +     if (WARN_ON_ONCE(range->lockless && !IS_KVM_NULL_FN(range->on_loc=
k)))
> > +             return r;
> > +
> >       idx =3D srcu_read_lock(&kvm->srcu);
> >
> >       for (i =3D 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> > @@ -640,15 +645,18 @@ static __always_inline kvm_mn_ret_t __kvm_handle_=
hva_range(struct kvm *kvm,
> >                       gfn_range.start =3D hva_to_gfn_memslot(hva_start,=
 slot);
> >                       gfn_range.end =3D hva_to_gfn_memslot(hva_end + PA=
GE_SIZE - 1, slot);
> >                       gfn_range.slot =3D slot;
> > +                     gfn_range.lockless =3D range->lockless;
> >
> >                       if (!r.found_memslot) {
> >                               r.found_memslot =3D true;
> > -                             KVM_MMU_LOCK(kvm);
> > -                             if (!IS_KVM_NULL_FN(range->on_lock))
> > -                                     range->on_lock(kvm);
> > -
> > -                             if (IS_KVM_NULL_FN(range->handler))
> > -                                     goto mmu_unlock;
> > +                             if (!range->lockless) {
> > +                                     KVM_MMU_LOCK(kvm);
> > +                                     if (!IS_KVM_NULL_FN(range->on_loc=
k))
> > +                                             range->on_lock(kvm);
> > +
> > +                                     if (IS_KVM_NULL_FN(range->handler=
))
> > +                                             goto mmu_unlock;
> > +                             }
> >                       }
> >                       r.ret |=3D range->handler(kvm, &gfn_range);
> >               }
> > @@ -658,7 +666,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hv=
a_range(struct kvm *kvm,
> >               kvm_flush_remote_tlbs(kvm);
> >
> >  mmu_unlock:
> > -     if (r.found_memslot)
> > +     if (r.found_memslot && !range->lockless)
> >               KVM_MMU_UNLOCK(kvm);
> >
> >       srcu_read_unlock(&kvm->srcu, idx);
> > @@ -679,6 +687,8 @@ static __always_inline int kvm_handle_hva_range(str=
uct mmu_notifier *mn,
> >               .on_lock        =3D (void *)kvm_null_fn,
> >               .flush_on_ret   =3D true,
> >               .may_block      =3D false,
> > +             .lockless       =3D
> > +                     IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS=
),
> >       };
> >
> >       return __kvm_handle_hva_range(kvm, &range).ret;
> > @@ -697,6 +707,8 @@ static __always_inline int kvm_handle_hva_range_no_=
flush(struct mmu_notifier *mn
> >               .on_lock        =3D (void *)kvm_null_fn,
> >               .flush_on_ret   =3D false,
> >               .may_block      =3D false,
> > +             .lockless       =3D
> > +                     IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS=
),
>
> kvm_handle_hva_range{,_no_flush}() have very generic names but
> they're intimately tied to the "young" notifiers. Whereas
> __kvm_handle_hva_range() is the truly generic handler function.
>
> This is arguably a pre-existing issue, but adding
> CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS makes these functions even more
> intamtely tied to the "young" notifiers.
>
> We could rename kvm_handle_hva_range{,_no_flush}() but I think the
> cleanest thing to do might be to just drop them entirely and move their
> contents into their callers (there are only 2 callers of these 3
> functions). That will create a little duplication but IMO will make the
> code easier to read.
>
> And then we can also rename __kvm_handle_hva_range() to
> kvm_handle_hva_range().

Thanks for the suggestion, I think this is a good idea. I'm curious
how others feel, as this indeed does duplicate the code some. Perhaps
it is better just to rename kvm_handle_hva_range() to
kvm_handle_hva_range_age() or something like that, and something
similar for _no_flush(). :/

But yeah I think it's fine to just do the manipulation you're
suggesting. I'll include it in v7 unless others say not to.

