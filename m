Return-Path: <kvm+bounces-36703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27950A2000C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1167F7A3FC3
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764751D9A79;
	Mon, 27 Jan 2025 21:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B1Jxdn4D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06135190664
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738014190; cv=none; b=DN14oH9R/CbBKnwXVQMeWiGN/fl2x1Xc0U9GmbQnrcBAHAYWSR7fdSltu4V7BSZC0DBWx36Lm+y6cqdzJsskVZrIo/3YCyqB2kQ3kqxCYRV2YBE/0j7mnGcgut9RGEgLqe8FLFZvjZUMOJ0Eg3vbE6KGw8DXDxMxvFoh9dRtWzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738014190; c=relaxed/simple;
	bh=1Mmezq64xFQiWGkw26fJ7DDOre0fNkgTFxXXwGJNpRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LpfBYe0tkfjDvPepSXs8px08lz6gEk/hjio4CnLDb3lmu3RzdFwGeF2CLFklOalDh1PRyQWKnPwG3vNBZi9G1Rj6MK+XEO80z8++x8squAhEYn5TB4gxbhdWUvaadbsCDq34iNz6KUQzjv3pJoA6zFInpZH8aA/4c6PnZNDVaaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B1Jxdn4D; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e5773c5901aso9709783276.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738014188; x=1738618988; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kal/h6HuE49/U9kHkBt8NU6lHKhENL+j4yJx2XelRk0=;
        b=B1Jxdn4Di7m7GivQhnXewVbsPN5yuYDfKb9TpJXBA50XD78jtv82oTzYmYrpOK2uvO
         gvnmw2MeA7ubnafZcBMDwkcWZL0zq3hq+vf8XlGr0M+EqoWLLxT+oEzswYiT0pCDDo/Y
         TpJ0GMfZ1Q45t/oHT72r7BL6aLKpmiM+GkBdv8ma/UbuM/PQYHOghDsYWEjNOZyUgqLQ
         K1yiOSWS6QxoGoYVY7ocT0bxlsgyfLOOBZtM/g3tfUtKsnXlECDX80EpWhIvTEalaCPu
         6Yif8jZxfpa2NNx/ntEc7lDU1v914/i1xVyTm7TuES+XcJaBMl+zBKobw7dFHMxkXryI
         i85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738014188; x=1738618988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kal/h6HuE49/U9kHkBt8NU6lHKhENL+j4yJx2XelRk0=;
        b=pcjP7HcsFJ1wViN9hgP4NsUaNdR2l65sAI/pYuwg4fODvODUnEZLpYcYJOWNm/LbQl
         m7DvWAa3TY9fmZ4jC/OBxiktgzIWME8C93RTBUaG+GaXXZxMrVKXApXYObts/BVcrt7H
         q4hB9ifls+BCZGzvCkWMy+TCjilmtryci3EMl5R/EQ6QiHmg/RXZVH00fdlOYgy7ae85
         otgVMtElUezgzp2FraRZc61acnTDqFx/hNXMHeh8AaQZKXocIMoKcews6uHLwPA+JGTA
         S09N5GqkbhlcCtjUyPiV22BjCAf6eXslfl8yBDATyLRuDDN2HrTEJMI0dzV663OwH8AG
         G+3g==
X-Forwarded-Encrypted: i=1; AJvYcCURpj6NatCTYvHb+vT29fi/5fRvAIfwzKRIjAsKrOClXDXY2lOmF4ebvkM5rEXyLSBZsiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIJdAh4MjytcFw+rXE2p3yA7vbEbeYCejeDuklNn9ZH8xAJNqm
	2jWW2cZm3CU36wrHeOYbwzMpCweQm8/vuMS28CQWoDl5I6lyqsLU0HqzEMQXM98FjtktEPhxBoK
	JKpxOd+uFT+S/4I9ZTdd1YWFlQ8ZpF8fpMI3z
X-Gm-Gg: ASbGncta6uU9cvDsS/JZ2DdN2/iAg5CX8zVl+PpJ0CPuHNaXJX3Pm7tQK6rf9vhnyJU
	hP+v3vP1WsDj+UwG7h00pXLJ4sBgHNd7laocThuIx4zwX/8JWwNsClMYmWlYfxuAj8xgVClUmC+
	ykLNI7NVdoA0ls5LLs
X-Google-Smtp-Source: AGHT+IFazq9Q49VCzD19KJviUhgdKEtFO9E3esYfSlvb5RSTS+MriKdbI5KaiEZ8DM7YqiJapq+57DVJbnGCLzZnjEU=
X-Received: by 2002:a05:690c:6381:b0:6ea:6644:ddf8 with SMTP id
 00721157ae682-6f79743ee1dmr10695077b3.0.1738014187685; Mon, 27 Jan 2025
 13:43:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-9-jthoughton@google.com> <Z4Gq443gcop9mL4X@google.com>
In-Reply-To: <Z4Gq443gcop9mL4X@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 13:42:32 -0800
X-Gm-Features: AWEUYZnvAZ_BwS8yKnHLDrPZdi9LEa_eBaPnVqrn9vPfixIsRaeIMC4MfsmSGyw
Message-ID: <CADrL8HWx-_1uVdfNyz2x2iEXEo4dJW0f_MK21NEQ=HLYfpROKg@mail.gmail.com>
Subject: Re: [PATCH v8 08/11] KVM: x86/mmu: Add infrastructure to allow
 walking rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 3:19=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Nov 05, 2024, James Houghton wrote:
> > +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> > +{
> > +     unsigned long old_val, new_val;
> > +
> > +     /*
> > +      * Elide the lock if the rmap is empty, as lockless walkers (read=
-only
> > +      * mode) don't need to (and can't) walk an empty rmap, nor can th=
ey add
> > +      * entries to the rmap.  I.e. the only paths that process empty r=
maps
> > +      * do so while holding mmu_lock for write, and are mutually exclu=
sive.
> > +      */
> > +     old_val =3D atomic_long_read(&rmap_head->val);
> > +     if (!old_val)
> > +             return 0;
> > +
> > +     do {
> > +             /*
> > +              * If the rmap is locked, wait for it to be unlocked befo=
re
> > +              * trying acquire the lock, e.g. to bounce the cache line=
.
> > +              */
> > +             while (old_val & KVM_RMAP_LOCKED) {
> > +                     old_val =3D atomic_long_read(&rmap_head->val);
> > +                     cpu_relax();
> > +             }
>
> As Lai Jiangshan pointed out[1][2], this should PAUSE first, then re-read=
 the SPTE,
> and KVM needs to disable preemption while holding the lock, because this =
is nothing
> more than a rudimentary spinlock.

Ah! Sorry for missing this.

>
> [1] https://lore.kernel.org/all/ZrooozABEWSnwzxh@google.com
> [2] https://lore.kernel.org/all/Zrt5eNArfQA7x1qj@google.com
>
> I think this?
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1a0950b77126..9dac1bbb77d4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -873,6 +873,8 @@ static unsigned long __kvm_rmap_lock(struct kvm_rmap_=
head *rmap_head)
>  {
>         unsigned long old_val, new_val;
>
> +       lockdep_assert_preemption_disabled();
> +
>         /*
>          * Elide the lock if the rmap is empty, as lockless walkers (read=
-only
>          * mode) don't need to (and can't) walk an empty rmap, nor can th=
ey add
> @@ -889,8 +891,8 @@ static unsigned long __kvm_rmap_lock(struct kvm_rmap_=
head *rmap_head)
>                  * trying acquire the lock, e.g. to bounce the cache line=
.
>                  */
>                 while (old_val & KVM_RMAP_LOCKED) {
> -                       old_val =3D atomic_long_read(&rmap_head->val);
>                         cpu_relax();
> +                       old_val =3D atomic_long_read(&rmap_head->val);
>                 }
>
>                 /*
> @@ -931,6 +933,8 @@ static unsigned long kvm_rmap_lock(struct kvm *kvm,
>  static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
>                             unsigned long new_val)
>  {
> +       lockdep_assert_held_write(&kvm->mmu_lock);
> +
>         KVM_MMU_WARN_ON(new_val & KVM_RMAP_LOCKED);
>         /*
>          * Ensure that all accesses to the rmap have completed
> @@ -948,12 +952,21 @@ static unsigned long kvm_rmap_get(struct kvm_rmap_h=
ead *rmap_head)
>
>  /*
>   * If mmu_lock isn't held, rmaps can only locked in read-only mode.  The=
 actual
> - * locking is the same, but the caller is disallowed from modifying the =
rmap,
> - * and so the unlock flow is a nop if the rmap is/was empty.
> + * locking is the same, but preemption needs to be manually disabled (be=
cause
> + * a spinlock isn't already held) and the caller is disallowed from modi=
fying
> + * the rmap, and so the unlock flow is a nop if the rmap is/was empty.  =
Note,
> + * preemption must be disable *before* acquiring the bitlock.  If the rm=
ap is
> + * empty, i.e. isn't truly locked, immediately re-enable preemption.
>   */
>  static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_h=
ead)
>  {
> -       return __kvm_rmap_lock(rmap_head);
> +       unsigned rmap_val;
> +       preempt_disable();
> +
> +       rmap_val =3D __kvm_rmap_lock(rmap_head);
> +       if (!rmap_val)
> +               preempt_enable();
> +       return rmap_val;
>  }
>
>  static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
> @@ -964,6 +977,7 @@ static void kvm_rmap_unlock_readonly(struct kvm_rmap_=
head *rmap_head,
>
>         KVM_MMU_WARN_ON(old_val !=3D kvm_rmap_get(rmap_head));
>         atomic_long_set(&rmap_head->val, old_val);
> +       preempt_enable();
>  }
>
>  /*

I don't see anything wrong with these changes. Thanks! Applied.

