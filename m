Return-Path: <kvm+bounces-14903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE29A8A7794
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F9C81F23B84
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1FD84D34;
	Tue, 16 Apr 2024 22:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zFKUXqyp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AAB78C7F
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713305697; cv=none; b=Fq6uL9D8YouCXdSnL1+wV6QmEQUPI7jnXU6UgJ7En3DMm9oWhO8daHMinboRx1WDjA227OmQUBhUvqgW22H2cBFuVxw9PguRPvb1CAh5iiT18PbQnCm0fi1cPK1+1G15i+5oiYRM1MCksj7jMigRYDqI8ihcpzNWQavNLAWn4xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713305697; c=relaxed/simple;
	bh=7y3M+0fa7LjUGCW8zz0dPkhDbnFqBsAs1zY2vanoPcw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ryGAvZbeaOLBlZmY4q1fabnFPx6dt2Y8SR58mYgLj4D6m/H+cCFp0skQmn1WkGwBZVVlpNoISLztjcYry9sSPbOASV3EfN9aPsCmNEUNA96/K7zp52Pm9ceUKmFG2ELYPWi+X2VKPTO+6NJjatgtSf7FD08ndyr6flXWDL75t4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zFKUXqyp; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61afae89be3so14792867b3.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 15:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713305695; x=1713910495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ojAEudSaSnS6y1Hv+EyDUIwvL32E3n7xtXtPYkUfBj0=;
        b=zFKUXqypvTvGF555bgjBt0erX55aDgTTyZK71AWJQw+5G/tYwc3GnK7nbUnYvk25lX
         QYooX3CiiN0l5ott4sBi9bqQhCoXTjT5l9he33Q023Ifb9KSkx0i3oHYqtk0fhL9ub1b
         DSVCt8LYv9MZr/CF4QkL7j+fRN9L/GxBIjqRhDvpjtG8hFEE9wYFFvR1t8X3EpMjGhuv
         KnKJGPzXURs/LssuZFAG0XcLddvEa4X/tPREccHd2ch0VuQy5HaVkK450kC9HMiRgUQ4
         cSb35f6ZAmI9i5CCQtnAstADEhBFAWw4fBMIgGRxPoujleH2UcVO3k7k8dTueHYd0l0Y
         T91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713305695; x=1713910495;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ojAEudSaSnS6y1Hv+EyDUIwvL32E3n7xtXtPYkUfBj0=;
        b=nkGCZsZFSgnqwM31dqFI2CDiRfHL/O3xaKtR0C+NiAFuTWtrE6SpFWkgxkRN1tiUqa
         4NP7ObCkPROj3C1Dqvu/yxcLGgKvqU7+dCy9SVRxn07Kwj4Mz6oFiEpFOoFxj6NnhWOm
         2ggZmQuzecbYHJpeWSoucqQ5s/OhtDcKLng3e+1RQKmdAyPGTu/c35hK5zyulhPBieY1
         KJF7wV8SSiRnD7CEvM1NvyzjIRvfMQFj2CbqQUjVhlSWLcMHgBq3RYzM2evpJ9nmSleg
         XfZOSQ4l8lpNxsUX+qZJuleIE7gh++UiLU8bwixe2eulTg3fj4KLYqVC2cdUIBZ8RqE/
         mgXg==
X-Forwarded-Encrypted: i=1; AJvYcCV0CyMopZ0KihoBMPWZqcOUtanCd0pT0yFRsZFUSsC24/fzpXeV7t44Kk738qy+u79A94stlt3Disld3wuyX8DcbKiR
X-Gm-Message-State: AOJu0YwPEtam30UgTOrJpnHCcrdq4Gic6tjZEjOdMZjYDrlEYk0oRPLk
	sWKDCza7CGdWhC2pxCHwDvn2YgxlANbhT7ByLFT2d54bUyBdAsO2WD1KQHo5Keu7VM2hmj6MWGO
	GJQ==
X-Google-Smtp-Source: AGHT+IEGWsaw9u26zK3PN5zbRSPRYyfDKGBaFt2K6uHPnxrP/X83MK3MKEIo+XYbUZDKfg8SYvyQ6tKroEc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e94:0:b0:61b:46e:62da with SMTP id
 c142-20020a814e94000000b0061b046e62damr161189ywb.4.1713305695455; Tue, 16 Apr
 2024 15:14:55 -0700 (PDT)
Date: Tue, 16 Apr 2024 15:14:53 -0700
In-Reply-To: <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com> <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
Message-ID: <Zh74XcF2xWSq7_ZA@google.com>
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: boris.ostrovsky@oracle.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> On Tue, Apr 16, 2024 at 10:57=E2=80=AFPM <boris.ostrovsky@oracle.com> wro=
te:
> > On 4/16/24 4:53 PM, Paolo Bonzini wrote:
> > > On 4/16/24 22:47, Boris Ostrovsky wrote:
> > >> Keeping the SIPI pending avoids this scenario.
> > >
> > > This is incorrect - it's yet another ugly legacy facet of x86, but we
> > > have to live with it.  SIPI is discarded because the code is supposed
> > > to retry it if needed ("INIT-SIPI-SIPI").
> >
> > I couldn't find in the SDM/APM a definitive statement about whether SIP=
I
> > is supposed to be dropped.
>=20
> I think the manual is pretty consistent that SIPIs are never latched,
> they're only ever used in wait-for-SIPI state.

Ya, the "Interrupt Command Register (ICR)" section for "110 (Start-Up)" exp=
licitly
says it's software's responsibility to detect whether or not the SIPI was d=
elivered,
and to resend SIPI(s) if needed.

  IPIs sent with this delivery mode are not automatically retried if the so=
urce
  APIC is unable to deliver it. It is up to the software to determine if th=
e
  SIPI was not successfully delivered and to reissue the SIPI if necessary.

