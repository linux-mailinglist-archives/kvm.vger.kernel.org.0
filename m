Return-Path: <kvm+bounces-19865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6AD90D786
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10A4FB35515
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A43148313;
	Tue, 18 Jun 2024 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flh3q8Q6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B582139DF
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718721450; cv=none; b=syqBS4fs7+f9Rdz4EcOJqKAt4mxxSBzS9DiW4saF7jmmpTJquktFw5VoZGSmU5Bo2RAJREx5/HUKUiMlGRS6lN3TCvjuhAR1DBpPo+b30FhYtkSOfi35ICZPGB0pCwZ8Rep/BUWdY8dpVTAX4wMM+JP/ZniPishzo3LqNAgbc3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718721450; c=relaxed/simple;
	bh=aOu0/jH+c+xg2A3PJvl53jLIf3oYGe7U7yf1SetbVWQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bnfzwdu1cPZz+1bHb90+Kfmby7iaTpci3ZLwnt27tX2wq4clhGYyAaULEGr6d63zrOUBAl8s0ss66UHQYoGyJW4OahInGUpgWcrUpvA+AYi+QtUPvtYv/sysWw5Bpm7gbZ/nTCnKjBd0ZbGqAmYQALHD0BEspbnYoXk3REL09Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flh3q8Q6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-632588b1bdeso72658507b3.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 07:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718721448; x=1719326248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jteX3qu1M+ho2SEsuD2VKCJXLgOnluRf0X8KAKxQZSE=;
        b=flh3q8Q6wIXGdWsV11No69YcV+Ss8MJj2F5+vVl+HRz+BslM3fHLjvDoIOwF/olJ9J
         R4CrW/l+eD4qhRLx8ZRTms5ManRwBkxa7MIbD6lAIz8Ye2Et+lpcNJPDlioScY8E8WjU
         Pn684Y8RIbsvKEMQgt4SFu7Axz8JD0I4coqh0sxQImrZKlFzt2t92oFQDlBuIjehR0HO
         riiv4oXlUDGesvj5anESIM9Q3WpCRSTT0r59gyZLDrYLa7sijp6PMLRe54Hp3JXdE4NZ
         AwsO14O7F77y7OLP3RMgxllqEcnaaU7X1yjkQwjcnm0drEXcdvbddQt6Bcydq4YIHW2u
         VERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718721448; x=1719326248;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jteX3qu1M+ho2SEsuD2VKCJXLgOnluRf0X8KAKxQZSE=;
        b=qEo49Uk17vvxtUd4X02KdlkflOOYPwUQC2Ixd5vy4MTgLA2/DV1GBxAKdmaeLDw/Uo
         9e5ZwEHsONh+yvAzgA/4KHUZLDIu8og6jXqbAyl/AlNi6cYFS/8H+DxLjb2SCfKbFoEW
         2/XaY3sq2urFy1mgTCuEe4+1Wg9YrBTcolHFGa0WjZI588PpqLzq0Rk+cUeYLrviXz15
         xGFiguNGcQ1d2IZiXOQzvxqyUTJrs/v0roSLms80Fp3kB9W8YMT3bJ9e5a3LQsRqv4QT
         bZRF0/Tpbdtuo3q6PtarM/YJV52R7ovRe9oiXqvnn+zStBfrPLsAnGd2/h0E9C6yhq6w
         3CGg==
X-Forwarded-Encrypted: i=1; AJvYcCU/yMpFnnBb+LqBbMoQQUDSyTzD1HIcXKZMSvdufve30M7iEl83OzMpGNEAHQLM2ASmnVTDmxZtNodxKWEPMsuJIIrN
X-Gm-Message-State: AOJu0Ywm6lTvLJUJdrIXZ/MyviWWz3dXZUwO1c38KtZ1BXeOnTkI3d9P
	CNkOKxSsRUJIvOc6m6/Ufr42vdZzyr4mT/1dN/K/CNLpjViq9YMlO5C512maTo9DNfxsJ4hVuj6
	r7g==
X-Google-Smtp-Source: AGHT+IHdPmqiCw8J4Le5ic/RNDfekcm6Vi0d+tfaxfbnBmc0hVTs/YAhUz+Mm331qyU6QDy+rbMcIOqRP+k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:858f:0:b0:dff:36b3:5c1d with SMTP id
 3f1490d57ef6-e02be18bb15mr618276.4.1718721447818; Tue, 18 Jun 2024 07:37:27
 -0700 (PDT)
Date: Tue, 18 Jun 2024 07:37:26 -0700
In-Reply-To: <CABgObfZCNN4AdzGavqzFANCLq4E5pi+h2+mr9-cysZrFk6bUzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240507133103.15052-1-wei.w.wang@intel.com> <171805499012.3417292.16148545321570928307.b4-ty@google.com>
 <CABgObfZCNN4AdzGavqzFANCLq4E5pi+h2+mr9-cysZrFk6bUzw@mail.gmail.com>
Message-ID: <ZnGbpizfefZgO0Q5@google.com>
Subject: Re: [PATCH v4 0/3] KVM/x86: Enhancements to static calls
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024, Paolo Bonzini wrote:
> On Wed, Jun 12, 2024 at 3:23=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, 07 May 2024 21:31:00 +0800, Wei Wang wrote:
> > > This patchset introduces the kvm_x86_call() and kvm_pmu_call() macros=
 to
> > > streamline the usage of static calls of kvm_x86_ops and kvm_pmu_ops. =
The
> > > current static_call() usage is a bit verbose and can lead to code
> > > alignment challenges, and the addition of kvm_x86_ prefix to hooks at=
 the
> > > static_call() sites hinders code readability and navigation. The use =
of
> > > static_call_cond() is essentially the same as static_call() on x86, s=
o it
> > > is replaced by static_call() to simplify the code. The changes have g=
one
> > > through my tests (guest launch, a few vPMU tests, live migration test=
s)
> > > without an issue.
> > >
> > > [...]
> >
> > Applied to kvm-x86 static_calls.  I may or may not rebase these commits
> > depending on what all gets queued for 6.10.  There are already three co=
nflicts
> > that I know of, but they aren't _that_ annoying.  Yet.  :-)
>=20
> I think it's best if we apply them directly (i.e. not through a pull
> request), on top of everything else in 6.11.

Works for me.  I'll maintain the branch so that the code stays in -next, an=
d so
that patches that are destined for 6.12+ are built on the new world, and th=
en
post the rebased patches when the time comes.

