Return-Path: <kvm+bounces-6403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D907B830B7A
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 17:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C88DB23B4F
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 16:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733FE224E7;
	Wed, 17 Jan 2024 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VanpWu13"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F825224D6
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 16:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705510303; cv=none; b=pSgXtsvMxQT+phvwNEgHUeqia9NJkK8JcIySQjHgL8hEhR3iWA9PgbHx+hxj+l4jZRUKQormB7eKMRXGhlCWIXDLzTW64jmjMxnle4DLzft9cQjJBTcYIXyx1jCbZA2ryEElH4jy/cJzHpQLwu60lkGtSLIXZuWQo81OwTDoMqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705510303; c=relaxed/simple;
	bh=Flpoh3ReMa+f01zkWdwyPUtfMDQc8awDAoOZ7kl2Rbk=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=UPTmoqKDnr13NduH53TXnvvn8kHFj23dekZeaTpMEq1yy4JgoqLdSYIfqpoZPwkGqZtZMeTuD1NkrfrxporR5SlztUjttFiesBUn6v/q/UhMUYG7EJ7saDibt5Dpu5QzPVh4DSuOak8Ryl5eyO+ClYdWuJQTqkBPpNuLayveiNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VanpWu13; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c659339436so3962067a12.2
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705510302; x=1706115102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AQfvIeCd7zUSaSSlAixj7/WQFqRLxQS0winR/4uznmc=;
        b=VanpWu13vIna6wEt4PzaaiRGCj3DkoS1qk64yt4n2uf93GrWFHGwatws8u4X2a3hQU
         YfEHUAf4tgIfWcy8m/ltSakMBOw4FQ96KN5pm57DvPk7wKrV/Ru22vEk4ovgoRTgjXOQ
         +mk+zHjUBGQIUcKLJlTuCa+J9Hg8WT+U2uJoOEANB6kEAcIAyDxWtcrpbcRYmz3Vo9hM
         l2smlAHaSEUlPS5rqISbObES4dw9iYr8Zuyuqe+vnCyIEupSzV0d9qvZp7dkE1k51Wdg
         cHKny6kGpBFuI+oyvtw7vb6l1NPAeobcssSf/F+BWdvxVX0IlXy1jymVjNEdfS0nk+9Z
         82Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705510302; x=1706115102;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AQfvIeCd7zUSaSSlAixj7/WQFqRLxQS0winR/4uznmc=;
        b=Az6u3yIJvGnopgcNzadKLfmQziCWA3e+b+yJ91TKyK89cEF/CCKk7Pz9RLpxBT0Bwx
         6ZmdljuRWLVkdnTbqLgJOOPNVRXT5aWISlwPIHQB/pUb2epj+/Klsja5S7f2rD9Wdid6
         sKgixU4PW3GXnfFVx7NH/KC/kfHIRw8WCaHHGpEcByRC9VgYgrCnw1lsVoZHAGoFf4Se
         M41qIdGeEj1CMeJ2jOTMw/Wpi7iHN0IjzRjw0Ye9KjUHWASKjZj1rLkcyoD1skewGcdY
         npO/r/5Io+bnkklvy7wlApTBry1kvVy+LYappVdbkUg8A6Ar1mveq9szyCPIOyZd0bwG
         6AuA==
X-Gm-Message-State: AOJu0Yw1/uBjEBZRmcdU0rtNilfqUNetVG8ihI7AfUkPCR5J8JWafv0b
	QV1+8YqhN86ND5W5DA2a6SWhjEneO6Vr8q2iwQ==
X-Google-Smtp-Source: AGHT+IGL0PWq2TGf0nDbHAhvadJ9D0G0DOckQIs3hyNL6KMra58JOuh2T6rxa7GPWAK/WmbxX74/DQfVVp0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3d4e:b0:28d:337:1281 with SMTP id
 qn14-20020a17090b3d4e00b0028d03371281mr273612pjb.2.1705510301071; Wed, 17 Jan
 2024 08:51:41 -0800 (PST)
Date: Wed, 17 Jan 2024 08:51:39 -0800
In-Reply-To: <ef60725c38faa30132ab45cf14ee0af86e885596.camel@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <9a82db197449bdb97ee889d2f3cdd7998abd9692.camel@amazon.co.uk>
 <Zaf7yCYt8XFuMhAd@google.com> <ef60725c38faa30132ab45cf14ee0af86e885596.camel@amazon.co.uk>
Message-ID: <ZagFm0tmZ4_nWf9L@google.com>
Subject: Re: [PATCH] KVM: pfncache: rework __kvm_gpc_refresh() to fix locking issues
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Paul Durrant <pdurrant@amazon.co.uk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024, David Woodhouse wrote:
> On Wed, 2024-01-17 at 08:09 -0800, Sean Christopherson wrote:
> > On Fri, Jan 12, 2024, David Woodhouse wrote:
> > As you note above, some other mutex _should_ be held.=C2=A0 I think we =
should lean
> > into that.=C2=A0 E.g.
>=20
> I don't. I'd like this code to stand alone *without* making the caller
> depend on "some other lock" just for its own internal consistency.

Hmm, I get where you're coming from, but protecting a per-vCPU asset with
vcpu->mutex is completely sane/reasonable.  Xen's refresh from a completely
different task is the oddball.  And unnecessarily taking multiple mutexes m=
uddies
the water, e.g. it's not clear what role kvm->arch.xen.xen_lock plays when =
it's
acquired by kvm_xen_set_evtchn().

> > =C2=A0 1. Pass in the guarding mutex to kvm_gpc_init() and assert that =
said mutex is
> > =C2=A0=C2=A0=C2=A0=C2=A0 held for __refresh(), activate(), and deactiva=
te().
> > =C2=A0 2. Fix the cases where that doesn't hold true.
> > =C2=A0 3. Drop refresh_mutex
> >=20
>=20
> I'll go for (3) but I disagree about (1) and (2). Just let the rwlock
> work as $DEITY intended, which is what this patch is doing. It's a
> cleanup.
>=20
> (And I didn't drop refresh_lock so far partly because it wants to be
> done in a separate commit, but also because it does provide an
> optimisation, as noted.

