Return-Path: <kvm+bounces-42164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEF1A7418E
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 00:41:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DB8417B6CC
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 23:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753561E51FC;
	Thu, 27 Mar 2025 23:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2HiIE7et"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418011AA1E0
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 23:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743118906; cv=none; b=G+vdtYCdJ3bVoGTCD1FZCJyrOR/qt2dUnTkIrz5CJoJnUSQY7VYAXD6j503x7z8er//BZZT4fKHeU432WI+0h5Htf8uthu/6hUzp2vh219c1cV0jIzweXn9c3ngcywTbL50khRb75q4LTX3MViujVoVwMdWt8EEdiT2e/GT665M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743118906; c=relaxed/simple;
	bh=v2MIMhXW5/PpGnOpZd6qs07zLPEvlgqJTsbUmutlQ7s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lBKDHXKtuwa+209FZ7lXIIcKNG0U4tStEh96S24tqV2DInJgmGAUIcC0SFp0EFKd7OWpuBJ72ym8DjVahOnZNZs+oABXou7FkE43szZeG64FjEh5saW19+JzvwQ0i84esydzcYhy75VYzhweWU5OdwJYtBLQglAB30MSUXqq2VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2HiIE7et; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-223f3357064so25547425ad.3
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 16:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743118904; x=1743723704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NnoN3AQJXWLmOQ41DRTgKv3zHqbLRMNW8uQM+h01TxE=;
        b=2HiIE7etB7V5DJcHp5GeVRn++6n3HTBtopopGcwKrNzhDAvOGBA2MgdfOzIVB2xmfr
         QEud2LgUoHAXY7wuSrqKiq8QDmjy61rpUBiuC0TYnFicJa0D6rfyII0VRY0UnbMy3znY
         q1UhCXorKX5A48gFDNePkmlD+5GcueRb3XobYo/BZOGwLlCRhCKIySE4BLiWznxIbrzn
         47YI7iXkzq/k4adfBSPuD31lARfXm2TwDBJetLX3Hs7H7RwuNDx26B2G6LJ0TBJmEqfR
         3Z96RpquC5KziNtLfN6xxRl6sX1Skw40F3REe620o1z0gMM7krWxlW1mmw0V9FYYc8zK
         54MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743118904; x=1743723704;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NnoN3AQJXWLmOQ41DRTgKv3zHqbLRMNW8uQM+h01TxE=;
        b=kOa+0hmYPm6tVU8FSZVSBu/r8apuwY3m0AP5J4+e/FhWixVZT9ivwQDJ4okh57wXwD
         2woeEvY/vYOXeVF5oDcFXPdz6sTDLvatSspEsG/89DvjIpBpypSdVTg2+QEgX4RMLCqd
         xdUGUQyoSLBbu+EG/Z3GjZ7pR3/ArLbNwpgbEZLbPnlfuP4wxu3ioLI87yOk4joW6Zgl
         Awrv218h+OmAGlcrxc0jctPAkpOAy9F1bIBnlrEfOAZiwNskkq1Nj9ZrbI0SjLj5p9v+
         Lcl6W576JgzkHQn6pkPG2BjcqKQFrJlR5ziPJ2B53yodq1JHU3E7PvA6UuuPgqQVqtiF
         E7cg==
X-Forwarded-Encrypted: i=1; AJvYcCUyXCZ42e250q4RzyJB1D3hAHVB+i33j0rEoxvIvqluLvy0mEZpYWzSutPuULLPpGhG+PM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY+pGOqXJZ5CVCka7pVCNpxyCbxsVJx9uTtg+2KATZ6TWFOoF/
	+dOPXtF6Lzim3YXhAB00Dt71EHp86J9DXE/C+IxLMWyI1fOeb5rW/mAk7KCUKNmXZyi0j6VupW1
	rfA==
X-Google-Smtp-Source: AGHT+IEEw3maAJDcGnIBtaPztpOoRCDtmEQ64tg/eWfd7UA+kccv5uTH0uokcd5etC3Q+xYxaQWsJva4uTU=
X-Received: from plrf24.prod.google.com ([2002:a17:902:ab98:b0:224:cc7:127f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2ce:b0:224:1005:7280
 with SMTP id d9443c01a7336-228048edd4bmr89463135ad.38.1743118904369; Thu, 27
 Mar 2025 16:41:44 -0700 (PDT)
Date: Thu, 27 Mar 2025 16:41:42 -0700
In-Reply-To: <Z+U/W202ngjZxBOV@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
 <Z9ruIETbibTgPvue@google.com> <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
 <Z+U/W202ngjZxBOV@yzhao56-desk.sh.intel.com>
Message-ID: <Z-XiNiQqhbwLmimp@google.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock lock
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2025, Yan Zhao wrote:
> On Fri, Mar 21, 2025 at 12:49:42PM +0100, Paolo Bonzini wrote:
> > On Wed, Mar 19, 2025 at 5:17=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > Yan posted a patch to fudge around the issue[*], I strongly objected =
(and still
> > > object) to making a functional and confusing code change to fudge aro=
und a lockdep
> > > false positive.
> >=20
> > In that thread I had made another suggestion, which Yan also tried,
> > which was to use subclasses:
> >=20
> > - in the sched_out path, which cannot race with the others:
> >   raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1=
);
> >
> > - in the irq and sched_in paths, which can race with each other:
> >   raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> Hi Paolo, Sean, Maxim,
>=20
> The sched_out path still may race with sched_in path. e.g.
>     CPU 0                 CPU 1
> -----------------     ---------------
> vCPU 0 sched_out
> vCPU 1 sched_in
> vCPU 1 sched_out      vCPU 0 sched_in
>=20
> vCPU 0 sched_in may race with vCPU 1 sched_out on CPU 0's wakeup list.
>=20
>=20
> So, the situation is
> sched_in, sched_out: race
> sched_in, irq:       race
> sched_out, irq: mutual exclusive, do not race
>=20
>=20
> Hence, do you think below subclasses assignments reasonable?
> irq: subclass 0
> sched_out: subclass 1
> sched_in: subclasses 0 and 1
>=20
> As inspired by Sean's solution, I made below patch to inform lockdep that=
 the
> sched_in path involves both subclasses 0 and 1 by adding a line
> "spin_acquire(&spinlock->dep_map, 1, 0, _RET_IP_)".
>=20
> I like it because it accurately conveys the situation to lockdep :)

Me too :-)

Can you give your SoB?  I wrote comments and a changelog to explain to myse=
lf
(yet again), what the problem is, and why it's a false positive.  I also wa=
nt
to change the local_irq_{save,restore}() into a lockdep assertion in a prep=
 patch,
because this and the self-IPI trick rely on IRQs being disabled until the t=
ask
is fully scheduled out and the scheduler locks are dopped.

