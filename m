Return-Path: <kvm+bounces-23540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7F2A94A9BB
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 16:16:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95BAD2857B2
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 14:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B81D77114;
	Wed,  7 Aug 2024 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="odM5cGvs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557AE38DF9
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040120; cv=none; b=rdI2EhDQl2zQni9HOoqpvSkhICDPR0CDbDbH2Q85JtklSfgxLvGJfWlAoOgGMRDuTvFAHcebEk3bDthfpJLiXvKjaGgXgcECEB6QdiQoapkzvlVAMuce4vLpqyuCdRmHRvX2dbd65AUyinNDOD+b0cxWAcv5WDUZNar1/uAFIIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040120; c=relaxed/simple;
	bh=qIZZqXvSK2dTj4OOR4TWFpTBy0obASFjlIhXZsvJN6c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xk7isHunyot0BRmxJ4EMfQp+KMJ/Z5/MPtyDXfxuTZBohxtnyPgmytByG6g8NPJogMT7BoHSFPjYeVJ8yLrozzPK8PIkzN++VmjDFKi7zjqXGu3MFx2YEGJN1NANquzhnYhQ7sllUfnCM5QADnKWVLsvOgnOBysPKMSEAdcJ/Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=odM5cGvs; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0bfd36cda0so1588099276.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 07:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723040118; x=1723644918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ghOIw54hCGsAyiOMfVcHm566iY09Y1oNz8lmYYBe4I=;
        b=odM5cGvsDjqA7JJfK5LcCRy8S5bvtOdtOBuUZYSnIN7kq6cTF90MLJYg/kWBZB0J0L
         bT+sdJ9p2eUZyGLla8gwp3HZB/Jxe4N5DfMS0/yV1rXgyBuEUKpCgMcix8lSYtt8W2xE
         le5YGMU3DwmZJerbnt0wDEpAtmCugFuLaNF+Z/0p4U98/q8KcBSMQDedjto+XpDkk/RN
         UQdzpsk2sUzCRMSmuKG6ATMrns3CTBSUyVmkyDk5/VQk+SaaJEiAo/E3EWNZGc0hby5e
         qCUA+bPbYcH6/r1nPU3ILwMnLF1F4nJOGcsFqbWce1zBDgI9iKGzWb66iAYlVTyM11D/
         L1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040118; x=1723644918;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3ghOIw54hCGsAyiOMfVcHm566iY09Y1oNz8lmYYBe4I=;
        b=klh6d8kSZCyi/mLi/vzzElTDvm9QAWQWKNpy0XWDGqlWLqZVmOH0N9x0LHg2zSq3qG
         7achuzBjWAqOih+BUR+c/YbwVUxhULL/c/wQBUtnaEnIq2wOhh7tCqh09OQWyMu9Bwq3
         Uhk/j7yXZBNp0RT6mlLcSZC38eSF5GyoJpr9ufL7iKEOjWINQeJso7zfROh4SDUekTbw
         6sTX5X9/cj2OYFPrRfljmyld4PGwhKV9Z16+K6rKqOabVDdXcrL/pgCGQ9tm1IBYBW2O
         DIAU6m2KC91VumFt1YmNpQh8tQhjBx0e/bVgowAANG01wz51vFFwD76utx5y3A7UIOHM
         mSsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNNKAGFlxaC26KXmgGU38GAyGDtkmN2fOVnDoo/tHUP57qM+CY5liWl5NXTXRQF+W7wBZpAobp21Cw9ph2m3B9HwxY
X-Gm-Message-State: AOJu0YyqyMG/cCISfJDezTdK/PwrE5x3fwB1j4kG09d9kS2LTWloXn5C
	YxwSykyudFrNBiLVH9GNDxoqtq51RsWhRUhu4c4Qhtp1bAu+wGkHHKDxTGj43x67weLrceGCw+O
	LBw==
X-Google-Smtp-Source: AGHT+IHbb3RmkB6VOeVJulhq/I4ys0iHpE5UZAynZajDuk/K2bUNwVgItbr4ODKjVBtTOTYTX55osDs7Uq8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1895:b0:e0b:af9b:fb94 with SMTP id
 3f1490d57ef6-e0e87c88673mr5767276.6.1723040118246; Wed, 07 Aug 2024 07:15:18
 -0700 (PDT)
Date: Wed, 7 Aug 2024 07:15:16 -0700
In-Reply-To: <ZrJ9DhNol2pUWp2M@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com> <20240802224031.154064-3-amoorthy@google.com>
 <ZrFXcHnhXUcjof1U@linux.dev> <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
 <ZrJ9DhNol2pUWp2M@linux.dev>
Message-ID: <ZrOBdBBAQZ55uoZt@google.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 06, 2024, Oliver Upton wrote:
> On Tue, Aug 06, 2024 at 11:14:15AM -0700, Anish Moorthy wrote:
> > On Mon, Aug 5, 2024 at 3:51=E2=80=AFPM Oliver Upton <oliver.upton@linux=
.dev> wrote:
> > >
> > > The wording of the cap documentation isn't as relaxed as I'd
> > > anticipated. Perhaps:
> > >
> > >   The presence of this capability indicates that KVM_RUN *may* fill
> > >   kvm_run.memory_fault if ...
> > >
> > > IOW, userspace is not guaranteed that the structure is filled for eve=
ry
> > > 'memory fault'.
> >=20
> > Agreed, I can add a patch to update the docs
> >=20
> > While we're at it, what do we think of removing this disclaimer?
> >=20
> > >Note: Userspaces which attempt to resolve memory faults so that they c=
an retry
> > > KVM_RUN are encouraged to guard against repeatedly receiving the same
> > > error/annotated fault.
> >=20
> > I originally added this bit due to my concerns with the idea of
> > filling kvm_run.memory_fault even for EFAULTs that weren't guaranteed
> > to be returned by KVM_RUN [1].
>=20
> This sort of language generally isn't necessary in UAPI descriptions. We
> cannot exhaustively describe the ways userspace might misuse an
> interface.

I don't disagree in general, but I think this one is worth calling out beca=
use
it's easy to screw up and arguably the most likely "failure" scenario.  E.g=
. KVM
has had multiple bugs (I can think of four off the top of my head) where a =
vCPU
gets stuck because KVM doesn't resolve a fault.  It's not hard to imagine u=
serspace
doing the same.

