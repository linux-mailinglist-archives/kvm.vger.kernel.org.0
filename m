Return-Path: <kvm+bounces-38191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A735A36617
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 20:27:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B18D23B1012
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 19:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44AC11ACED1;
	Fri, 14 Feb 2025 19:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKgiQlAc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C996C19B586
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739561259; cv=none; b=sTIEFLRlKnN4V+yebhl1KpGFgbCFXjYpi9hFAimrn5e4rXW08iczxyF3prOgMMfss4eKc4y+4KLjZLRtltZTOMXRC4F9GuG/e7S5ZtzGM/x80rPcCRCbvUpanavIUag5GJE2LrpeMd2JdNEvgpwKH2Wy3wkus7qEF/9/Hv9tCcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739561259; c=relaxed/simple;
	bh=DYa5M1lN4G8k0q9NNjk0n1aZvgrn+ZWN9RQE2qQ6GoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gx0jQy84oXDHRrF7dD3Eiq0LurNoOqWAB1vIMis2vCt4ka7tfUSj2HcOheihBrKoK3yZllUt/CpkEhzTL8uxZRV+UjI8Y9EsC+lMRDhm/kURDdUkzFV1O6XuM5+bwMBpJ7fKyGJDtsNLrAJ8WYDnRXa5YRPfrXrUOX8NXfs2odM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKgiQlAc; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6f754678c29so23516007b3.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739561257; x=1740166057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oY7qB5SrrWW/s/zTs9PGLldL2hUDnZjFDu0Se/qxC+Q=;
        b=PKgiQlAcKU7uxZyYM+K77IH8qujRhvvo3Zikrr3vIxUYcL0ya9thGCm3cgTf4jzecb
         wdOXWmCXIyA6GiIkbCIg6g3kV4FD7QeELxDV79SO+OWwtLaVOz53mnF7VbQU8JlE9B5K
         1qaLWAZcxFB3tHBcKtRxfCHMzESYhc6LWCWvQLfkZsA/2tU4DUyRzquVYmEKI/wwiCTW
         Gf/PbOdpi4t0jLmVFQfowz9+6ZmRZtEDTEUhPiDwtcI66Nq/kSioBjATf76Jwky4mKSV
         wxCOvOrQyIhvXppRd8h/Ww/njPVwEp352qrpobUJxOCW6hdIWEDwehL2GrK3pdUTbtfM
         0wLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739561257; x=1740166057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oY7qB5SrrWW/s/zTs9PGLldL2hUDnZjFDu0Se/qxC+Q=;
        b=sFkdGU6KN+EpnHFG+wISEOfArntcA/p4m7FK5SlRnW/d5SLM5Mrw5QXZ27x45dP4TZ
         q7d75ZHYOgb/XYFBVkNkCM+7oVql4E0j3YLQgU+PH/6dFT9JjeKtmjler7PGsW2jDi+g
         xjUlZlD53M8PAD429MDZYVe9TrhlxRUHPN/k3BTDsvSS3nrVFH4cP6Q+vrZXpDGlfo/F
         Ype8DFpRbHipCdPD+cTe2pXWQNcoOJMxb50SMxTyuup3R2Qr8Cvt3pfntvyteDGQGue0
         B1LqpTMTmrDUmCK+Us3PFrEC523hAiJNUdrIM+yHqVJ/2n5YmVBomvp6/c6PR4YIAJee
         9qRw==
X-Forwarded-Encrypted: i=1; AJvYcCVIp8u5IuZZUOKcUhvZq+CFaNTaazN+ZusuFrUL1aw397TnCsYK0eHw7prEO6aVDuIz/is=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9WXP5kdJrEF776Y3S0zDEEXKmmxP6NCbF+48uj1ndveA90BsW
	SC98h/VQ6kHdalgi6cGlsKu2WpB0cuwjY3oy6PX6OAAdBdS73JwsfHlqUqatLt7GzRr/VbsGp7f
	PcGK6QTmog8ZGKKy4cU/C2UWJMpjM/FQ0I9ND
X-Gm-Gg: ASbGncs1AzwmqMa5KnqTNUi5h1O6c11En/04knOQKq4Q5ifQqqgz1/Ys6ckL1P1Aywb
	7xSuZcpZ91bPptkprlS/wkjgsqDUYlTBGmoP/eMU9Xt8xsyJNz05ogQdpHtqn7GcMpGe6/WpG3X
	Rv3ZZcYwfM1bxS/16LYRBKrCFae6U=
X-Google-Smtp-Source: AGHT+IGg7kvdCi72ltCDUjU6eEKB8SbPlHGSKxrM9IB1TlOo5p2QgL47qVpy2+9G9Z2ahIgLLrmeJ5AYTLO7iw4Pn6c=
X-Received: by 2002:a05:690c:6389:b0:6f9:a402:ff68 with SMTP id
 00721157ae682-6fb582b9c1cmr8153637b3.19.1739561256615; Fri, 14 Feb 2025
 11:27:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
 <20250204004038.1680123-3-jthoughton@google.com> <Z69gwTQjaeMLY7rM@google.com>
In-Reply-To: <Z69gwTQjaeMLY7rM@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 14 Feb 2025 11:27:00 -0800
X-Gm-Features: AWEUYZmBPaZiJXTB-ux6TIQQ_Cg3i4_wSJFT_Gu64wXh_xbE1h8XoOW9UYzmEoU
Message-ID: <CADrL8HXW4drX-K-JuZ6SLsJDfU8XDyyjmDk_g00y+QFX5=qwDg@mail.gmail.com>
Subject: Re: [PATCH v9 02/11] KVM: Add lockless memslot walk to KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 7:27=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> It's not a lockless walk of the memslots.  The walk of memslots is alread=
y
> "lockless" in that the memslots are protected by SRCU, not by mmu_lock.

Indeed, so I guess I should have said something like "Allow memslot
walk callbacks to be lockless"

>
> On Tue, Feb 04, 2025, James Houghton wrote:
> > It is possible to correctly do aging without taking the KVM MMU lock;
> > this option allows such architectures to do so. Architectures that
> > select CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS are responsible for
> > correctness.
> >
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > ---
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/Kconfig         |  2 ++
> >  virt/kvm/kvm_main.c      | 24 +++++++++++++++++-------
> >  3 files changed, 20 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f34f4cfaa513..c28a6aa1f2ed 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -267,6 +267,7 @@ struct kvm_gfn_range {
> >       union kvm_mmu_notifier_arg arg;
> >       enum kvm_gfn_range_filter attr_filter;
> >       bool may_block;
> > +     bool lockless;
> >  };
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)=
;
> >  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 54e959e7d68f..9356f4e4e255 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -102,6 +102,8 @@ config KVM_GENERIC_MMU_NOTIFIER
> >
> >  config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
> >         depends on KVM_GENERIC_MMU_NOTIFIER
> > +
> > +config KVM_MMU_NOTIFIER_AGING_LOCKLESS
> >         bool
>
> As noted by Stephen[*], this steals the "bool" from KVM_ELIDE_TLB_FLUSH_I=
F_YOUNG.

Ah sorry!

> Looking at it with fresh eyes, it also fails to take a depenency on
> KVM_GENERIC_MMU_NOTIFIER.

Indeed, thanks.

> Lastly, the name is unnecessarily long.  The "NOTIFIER" part is superfluo=
us and
> can be dropped, as it's a property of the architecture's MMU, not of KVM'=
s
> mmu_notifier implementation. E.g. if KVM ever did aging outside of the no=
tifier,
> then this Kconfig would be relevant for that flow as well.  The dependenc=
y on
> KVM_GENERIC_MMU_NOTIFIER is what communicates that its currently used onl=
y by
> mmu_notifier aging.
>
> Actually, I take "Lastly" back.  IMO, it reads much better as LOCKLESS_AG=
ING,
> because LOCKLESS is an adverb that describes the AGING process.
>
> [*] https://lore.kernel.org/all/20250214181401.4e7dd91d@canb.auug.org.au
>
> TL;DR: I'm squashing this:
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index f0a60e59c884..fe8ea8c097de 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -22,7 +22,7 @@ config KVM_X86
>         select KVM_COMMON
>         select KVM_GENERIC_MMU_NOTIFIER
>         select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
> -       select KVM_MMU_NOTIFIER_AGING_LOCKLESS
> +       select KVM_MMU_LOCKLESS_AGING
>         select HAVE_KVM_IRQCHIP
>         select HAVE_KVM_PFNCACHE
>         select HAVE_KVM_DIRTY_RING_TSO
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 9356f4e4e255..746e1f466aa6 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -102,8 +102,10 @@ config KVM_GENERIC_MMU_NOTIFIER
>
>  config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
>         depends on KVM_GENERIC_MMU_NOTIFIER
> +       bool
>
> -config KVM_MMU_NOTIFIER_AGING_LOCKLESS
> +config KVM_MMU_LOCKLESS_AGING
> +       depends on KVM_GENERIC_MMU_NOTIFIER
>         bool
>
>  config KVM_GENERIC_MEMORY_ATTRIBUTES
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e514e3db1b31..201c14ff476f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -655,8 +655,7 @@ static __always_inline int kvm_age_hva_range(struct m=
mu_notifier *mn,
>                 .on_lock        =3D (void *)kvm_null_fn,
>                 .flush_on_ret   =3D flush_on_ret,
>                 .may_block      =3D false,
> -               .lockless       =3D
> -                       IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS=
),
> +               .lockless       =3D IS_ENABLED(CONFIG_KVM_MMU_LOCKLESS_AG=
ING),
>         };
>
>         return kvm_handle_hva_range(kvm, &range).ret;

LGTM, thanks! You will also need to do this same rename in patch 4[1].

[1]: https://lore.kernel.org/kvm/20250204004038.1680123-5-jthoughton@google=
.com/

