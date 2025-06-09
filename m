Return-Path: <kvm+bounces-48764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4360CAD2A46
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 01:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1386A18929B0
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 23:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745CF227B9F;
	Mon,  9 Jun 2025 23:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DvQ3VvWy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59CB22688B
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 23:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749510303; cv=none; b=LfpEm8a4EAOqA/SyNPn0TJ39MM/Wz3DE/X56QdvNl3REDnl5k6EMp57nhaUO46LbDBly0eKZVpBKRlETtPPWjyXnXMm9TgMWYm1z0JW0k6ZKptTX6pS3xk5WI3JU0R6Bcq0+SLuwzmsw2WRVvbci56tp6BuNZPBFmGGUOnZgLiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749510303; c=relaxed/simple;
	bh=8JQVGbTAqQUabzFe20anuyHGA4gpZl+ONkN6GLx8ymI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKOc54G6hVFGatR04sW014PfucOksz2++ygsNvxRIhilyqr+k42/UB6fX7xbd0fk4fTt6+sZOAtupUJbDbEj+4X1iK6Qg0sa5Ph+0CBF7U+/6o+7NhVxN8axGlGbrDznS9N2hrsZN6RIWg3N1lmDY6u5LI3ogCUg/N47/xcPo1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DvQ3VvWy; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e81a7d90835so3640494276.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 16:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749510301; x=1750115101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7+cVr8dsExjTk3ijrllXSzAu8Gblm5oL77kdyoH2ZE=;
        b=DvQ3VvWyq3FvzVm8BNKbZvXYbIOhxV8vmBzMEqQ9oKXdIKRumc0brDSk/kf+NRmTC+
         2Ix0nE+oI2oCeQfSsZrBCTrnQVTj/UyRNhGLkkw22bh6mxO3LPLYg+lBWwnWOBr26rze
         h00OuudIbD300dhvJpSQorDzKDm2Ebo5s3DeUSsU8H/knMwurQw53gOqc4LqbF84mL5H
         G0iwBD6kEJ3mNnlw8MCO0QJJH/5BX78cCAZN9QDs6sRq7EEGCjewotddFFzgL2qNPBsl
         NPU4j8bCBsjUhjFuSXCTwMk/QC1ZcYWwjXIpWqc2HScukEtzqpvywj9Dp+vvJO+cPlUj
         lCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749510301; x=1750115101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7+cVr8dsExjTk3ijrllXSzAu8Gblm5oL77kdyoH2ZE=;
        b=k/gJHoDMJ5fzxg1OGHWZQ4hIpE5UJ2gbsG+TPsxqoxOkWDh8CoXDQ07QEMsziO46H7
         ohGNZKlP1TCxBPf6wBfeFQKh9ASng1P9+FeP5rNZhZfq9KbQTnyj7UZvVgSkiBS4sIfh
         DBx7FwOCFeTS/6X/O6zrqcRNjA9t5xVAtjOJpNLaUJXyFIdHJgCfAvcTCv4iJ7vPUKLu
         W1QznqfUSzwxPEeZY4kHT/Cgi/fEzb4zSdq9ZoudJxSRnhQ9HPXzaTqMd78pnySHzOYs
         9KDc7BkRVTw5O5pvVtSjhkRvpAHYB7tw38K/PXYFyuPRhiysowvhyqueod2mT1nK0UIE
         uPJA==
X-Forwarded-Encrypted: i=1; AJvYcCXIzYhpJfdgVT5Ex1djxVY5lpdJQGZhRK/S076i1t3BxbKhv0KjUhnPX20WWTbrabPbmi4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu2UkNT9jaGpbIs8fTd/x1BTZQ3Y30Py78wmRfLEZ+Hupw0d5d
	aJKONcksQXvcphpQYROf2MPvYvYKgnPHKHf8IsoCXWPc4BF6porHat6zt/N2sFA9Qzgneqo3TAq
	Ke6CexzdH6URE4rghzo78VKlOe2DfKIf8Y/zIyV6q
X-Gm-Gg: ASbGnctRvUFqynmkva1xkgtjXJBomTknWycWN1ILSeBhxrRekPLNQdKxZcdD0pKgzaK
	MNcSHPqpPLCbSj2pJoyhZuWBPnA35fDJ9FrxQw5xDkCC1PdMoaML1h+RDJm45rC7ZO59oMquW72
	0QhwPqrkVUsxtGwClYkWWz0ODpA1qyU+KKoYS4E9kjhhwCvYSL9LJg11OM4S0ajeh5SoKMte/A0
	g==
X-Google-Smtp-Source: AGHT+IHDN7yYiqZfvU9YYp0Xn0iNVyQLG2U2NkvCT1T2HFwTM8W1uiwWGtxc6CrVQKMfQxc4kQw9Dq00AIFK5/ldCts=
X-Received: by 2002:a05:690c:360e:b0:70d:f3bb:a731 with SMTP id
 00721157ae682-710f76949a7mr201808267b3.9.1749510300215; Mon, 09 Jun 2025
 16:05:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aDdILHOu9g-m5hSm@google.com> <20250528201756.36271-1-jthoughton@google.com>
 <aDebZD1Kmmg15zs7@google.com>
In-Reply-To: <aDebZD1Kmmg15zs7@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 9 Jun 2025 16:04:24 -0700
X-Gm-Features: AX0GCFsscOLeJsC5afeLhStDd6O3F0bHoTP2OBA-juWmkL4Q85V0QPpPjCgJ_5E
Message-ID: <CADrL8HWwWN6tgV5ws8HMmeONmmhx_xS5ZSHgV7E6Cg=NDrqCTQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	kalyazin@amazon.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, 
	wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 4:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, May 28, 2025, James Houghton wrote:
> > On Wed, May 28, 2025 at 1:30=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c5d21bcfa3ed4..f1db3f7742b28 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -2127,15 +2131,23 @@ void kvm_arch_commit_memory_region(struct kvm *=
kvm,
> >                                  const struct kvm_memory_slot *new,
> >                                  enum kvm_mr_change change)
> >  {
> > -     bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> > +     u32 old_flags =3D old ? old->flags : 0;
> > +     u32 new_flags =3D new ? new->flags : 0;
> > +
> > +     /*
> > +      * If only changing flags, nothing to do if not toggling
> > +      * dirty logging.
> > +      */
> > +     if (change =3D=3D KVM_MR_FLAGS_ONLY &&
> > +         !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> > +             return;
> >
> >       /*
> >        * At this point memslot has been committed and there is an
> >        * allocated dirty_bitmap[], dirty pages will be tracked while th=
e
> >        * memory slot is write protected.
> >        */
> > -     if (log_dirty_pages) {
> > -
> > +     if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
> >               if (change =3D=3D KVM_MR_DELETE)
> >                       return;
> >
> >
> > So we need to bail out early if we are enabling KVM_MEM_USERFAULT but
> > KVM_MEM_LOG_DIRTY_PAGES is already enabled, otherwise we'll be
> > write-protecting a bunch of PTEs that we don't need or want to WP.
> >
> > When *disabling* KVM_MEM_USERFAULT, we definitely don't want to WP
> > things, as we aren't going to get the unmap afterwards anyway.
> >
> > So the check we started with handles this:
> > > > > > +       u32 old_flags =3D old ? old->flags : 0;
> > > > > > +       u32 new_flags =3D new ? new->flags : 0;
> > > > > > +
> > > > > > +       /* Nothing to do if not toggling dirty logging. */
> > > > > > +       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES=
))
> > > > > > +               return;
> >
> > So why also check for `change =3D=3D KVM_MR_FLAGS_ONLY` as well? Everyt=
hing I just
> > said doesn't really apply when the memslot is being created, moved, or
> > destroyed. Otherwise, consider the case where we never enable dirty log=
ging:
> >
> >  - Memslot deletion would be totally broken; we'll see that
> >    KVM_MEM_LOG_DIRTY_PAGES is not getting toggled and then bail out, sk=
ipping
> >    some freeing.
>
> No, because @new and thus new_flags will be 0.  If dirty logging wasn't e=
nabled,
> then there's nothing to be done.
>
> >  - Memslot creation would be broken in a similar way; we'll skip a bunc=
h of
> >    setup work.
>
> No, because @old and thus old_flags will be 0.  If dirty logging isn't be=
ing
> enabled, then there's nothing to be done.
>
> >  - For memslot moving, the only case that we could possibly be leaving
> >    KVM_MEM_LOG_DIRTY_PAGES set without the change being KVM_MR_FLAGS_ON=
LY,
> >    I think we still need to do the split and WP stuff.
>
> No, because KVM invokes kvm_arch_flush_shadow_memslot() on the memslot an=
d marks
> it invalid prior to installing the new, moved memslot.  See kvm_invalidat=
e_memslot().
>
> So I'm still not seeing what's buggy.

Sorry, I didn't see your reply, Sean. :(

You're right, I was confusing the KVM_MEM_USERFAULT and
KVM_MEM_LOG_DIRTY_PAGES. I'll undo the little change I said I was
going to make.

Thank you!

