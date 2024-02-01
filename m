Return-Path: <kvm+bounces-7741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 784B2845C85
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 594DF1C226B1
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E606626CD;
	Thu,  1 Feb 2024 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9ugbW94"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6AF626B1
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706803799; cv=none; b=egdk6drtjtH288+AyxUiVYetEb0Bch6w32L7T4KMElJ2NOhRAngU/0Crf/0krLDVuSmHWMQU0wVrINoEMcj/6w+jB+hdj4MJEGSPZUeW8BY3d3ImNztLw8pxuT4pGkk5tPW9MfPi5dKSBNn6LtVatHRCVAeGPUhvHRJuaVRkIYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706803799; c=relaxed/simple;
	bh=7CSEMHGFIzUqMuP3BxvtQKRgmSmzo+WkEAQHpp7aqbQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qIdssOmJd8T0On1ThdoFH4/yf7k2jsqXzfArTddaJ2WAa4fBPWQL6AusPQfZELl+FwqvY7brfNCSGv2SkWXpNxnGI8wxLPwhWVX8ePk2ONNjsTL8iypJF0otcEZd6VzPEmIW05y1Ch7pO4iyYbfe4Lp+adMxjBINSq+nV1ELqDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9ugbW94; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b269b172so2768143276.1
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 08:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706803797; x=1707408597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5D6A9MAokm1eQJhhhCS/vvtEFg3NRQqyUoXU7zcFXbM=;
        b=w9ugbW94r3ibq1Lk0LU0PTF5uNEdZxjvxlF44n2EMnYnDmououZ6nZeRzen4ts2rt2
         snd9BLVDYOpS1wPSuCHAWoGxUxqT83IUj7ZMMG2W6VtAJp47VioFA51L2FB6z/VxzHd4
         mB9IOYBRH7aGgKwooQhEGe9BBWc/bkQK4WQSYZXI6avq8pVyQAM1dHdJnOqfFISWBMLt
         zgWzlC5Ln2YGSu3f6rSnG0IUhJ80/kPx8EuDIOAjwMPlH+COedCLxC03lm6SZYA8Mjc5
         vGddH0UrdMIrmsRMPSoQhIvcx/7sZ1hDdEbokXPzVxnjuWmgpTemxaiFt3sW7d0NiYSg
         bieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706803797; x=1707408597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5D6A9MAokm1eQJhhhCS/vvtEFg3NRQqyUoXU7zcFXbM=;
        b=Z7PGNHLjlbQlYGUo+jGVmBEQti8idNRg1Yc9KLYFrDkz/BuVX40Xmhl74zqQlRH+EP
         6N+mwNOoNt0x5qYxWQckGfUvP5tm4gDNPtVTE8YumFu9uFkcsc8r2/aVhqUwK2p6Gn51
         awD2Fac107LJp/IKngWbAjbNRQw/48H5XfexJJ/cnG0s/0xHychGoSHKRZ8/45V7aVB5
         b7o0uVK/dxjgt5B3yZwXeebG8j7NyDSfrf2O2AphUsofa4eXl0erCJq855pXkYZJV4qS
         e2EiP3NhfkRTm7QFbqdwflNNfWtOl12yaq6uMULczhmRPaovHWpl8Jag2PHsb+2SK3Wp
         L+4w==
X-Gm-Message-State: AOJu0YxCbgPHeBeXZeYqHA0PoE5Z9m6WqBKDH3IhxZJRTrvtcW6UtBIP
	/IQ4yWthcij9gi57h0NTo1WVROs7Bov/TItMaBPx+e+t3wz3GLCZt4YSo4AvjTMSAYuSufZY+Q6
	xRQ==
X-Google-Smtp-Source: AGHT+IH+OpGONSjXILl9u3ckR2DfQpvHTkdIoYM8QZCypQrXj2y1qc/DOfkdyz811+61uoLrP/+1GQZPrKY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2404:b0:dc2:51f6:9168 with SMTP id
 dr4-20020a056902240400b00dc251f69168mr1296460ybb.2.1706803797347; Thu, 01 Feb
 2024 08:09:57 -0800 (PST)
Date: Thu, 1 Feb 2024 08:09:55 -0800
In-Reply-To: <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com> <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
Message-ID: <ZbvCU5wPAnePJZtI@google.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024, Anish Moorthy wrote:
> On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > Feel free to add:
> >
> > Reviewed-by: James Houghton <jthoughton@google.com>
>=20
> > If we include KVM_MEM_GUEST_MEMFD here, we should point the reader to
> > KVM_SET_USER_MEMORY_REGION2 and explain that using
> > KVM_SET_USER_MEMORY_REGION with this flag will always fail.
>=20
> Done and done (I've split the guest memfd doc update off into its own
> commit too).
>=20
> > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kv=
m_memory_slot *slot, gfn_t gfn,
> > >                 writable =3D NULL;
> > >         }
> > >
> > > +       if (!atomic && can_exit_on_missing
> > > +           && kvm_is_slot_exit_on_missing(slot)) {

Operators go on the preceding line:

	if (!atomic && can_exit_on_missing &&
	    kvm_is_slot_exit_on_missing(slot))

> > > +               atomic =3D true;
> > > +               if (async) {
> > > +                       *async =3D false;
> > > +                       async =3D NULL;
> > > +               }
> > > +       }
> > > +
> >
> > Perhaps we should have a comment for this? Maybe something like: "If
> > we want to exit-on-missing, we want to bail out if fast GUP fails, and
> > we do not want to go into slow GUP. Setting atomic=3Dtrue does exactly
> > this."
>=20
> I was going to push back on the use of "we" but I see that it's all
> over kvm_main.c :).

Ignore the ancient art, push back.  The KVM code base is 15 years old at th=
is
point.  A _lot_ of has changed in 15 years.  The fact that KVM has existing=
 code
that's in violation of current standards doesn't justify ignoring the stand=
ards
when adding new code.

