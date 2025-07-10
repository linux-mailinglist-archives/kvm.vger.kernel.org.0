Return-Path: <kvm+bounces-52029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE8DAFFF9E
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 12:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D88B1C847E4
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E4C2DECB4;
	Thu, 10 Jul 2025 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIkebAk1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF261FBEA2
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 10:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752144526; cv=none; b=dvaB211NObK+L4SKQK620JlmOXsZyAVg9pxDDZkd5hNoDyZV0qzRZteOCDH0T1VWcuW0KDccumF4sHfXANfyGm3X8s4dsuysXyFCimoKH/mSm1FzSi5kK+r87unW+i+1rrYsnaBmDmm/YZAFaZ/HxWMhENuDro+okWwnI4ff4O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752144526; c=relaxed/simple;
	bh=reDJB+jVA2jze/Op4vAV+YAROelsnXkSfMwWLjC3sb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a1cpoy7xwjosa5Ak8d2RciKk8yixxGZMQPuEj6Bc/ls6nt9tz17wSG+aQR9M+NSm1x/CquJ3Y22tIrlDKoBCD0Xb5ie25bUx1r3frC1SA64vmWIzWrxvMrSFhpFPB/oiMc94+OdtAwCaFDG0gz2E5O9AE/hwFOTUtaoTvoT/wMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIkebAk1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752144524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNmncl3vzJsUWRoJNZxmBhE+E8sb6lSPv1tCHk92ysY=;
	b=dIkebAk1ZdzdUBJFPM4NbPa0JluLcJhoi4Eln2fHo+KiAgd680T7KCd/XrSa60gkaz09Xf
	+meb8i0ckSiTzQ8u9acfeZzotQwu6eNkaMfIN57veLTL3zBosngCMIuXPmVHa7shnllFKO
	Nmd3Ho1gD1y/Iwt24dQYFaU6wLCVzJ0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-ir1mki2-NWC0Ke_zAPKMwg-1; Thu, 10 Jul 2025 06:48:40 -0400
X-MC-Unique: ir1mki2-NWC0Ke_zAPKMwg-1
X-Mimecast-MFC-AGG-ID: ir1mki2-NWC0Ke_zAPKMwg_1752144519
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45311704d1fso5387615e9.1
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 03:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752144519; x=1752749319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lNmncl3vzJsUWRoJNZxmBhE+E8sb6lSPv1tCHk92ysY=;
        b=LQIl2DX48em/uasDDNP+vHQL1PXq1XB7mFg1koY7KyLyC/K3B1aePD+MKzoQnTr1Tv
         E1ekSLdp+l132v7rSeFvQzZBRhQcWbJ5Fu8Xp2PE+K1VL9fnViFmxJCwAgVSLSPSZjvE
         Tf/zm4Wbt1preJH0Lv/NXbDjo/HCU/RA9T682kXXgP0TOo8wqnre80GSjHdgAW1IAEA4
         c9HhDN1/LJ3nHXYJXw7lWnMf0O/tFIDfaHJVDQfJsOqOGSktsrs+yqdS1NlC6eaaVNmW
         Mcpso93t+lKMkIP8NfUFxagTIHSe+KZ1X23DqsriXtZOv3M5qkk+1o5Z9yIbkDkdk4z3
         5nMg==
X-Forwarded-Encrypted: i=1; AJvYcCWaTDbudqhM2rn//KwwcNvkQpJE790agrXO6rKMa0UhH8Sy/cviU64Sa/OmY39YtfPwAZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQeLO2W04vN9sk/2heg4usVjTw3PcRAFBPfmOmbWzNa/DpISzw
	6VQ0lF+Q/MZ7rYMior0ErOwm2hBcHXfey33DqyuekOosITnHnl5Zk915kMEVP+lSghpaplFCSqJ
	aVvIzrY7zIfqP2ZG8VNnkvSqz6nH0p3QAjhWeiXEJl/YeUSkNpOfpiPIup7+XQyLF4oQRK+eTdh
	ZS8+OS5jEjldeeOishGO+voi2EXxth
X-Gm-Gg: ASbGncs86lBpTq/8EhCoztWbdd5CZlxgeReqrbQUMrdfY3Ckwp8Y7ZAfevfvQsyru2Y
	SOoRbVZw3ugB5zOjDoUUbIz2ARC0J3sWyFmHILw2o4AyXG57LmrxUJtcb57WS55TZKW58NyiKIt
	lkC1xZ
X-Received: by 2002:a05:6000:240e:b0:3b2:dfc6:2485 with SMTP id ffacd0b85a97d-3b5e866be37mr1530565f8f.4.1752144519479;
        Thu, 10 Jul 2025 03:48:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmY5FVV5iTS8z0YqIW6yODFY43cB2gfswppkDLC9lidIswhlzZ5Ms1OGnA8y43lftuWydzsAPcndaHukvYemo=
X-Received: by 2002:a05:6000:240e:b0:3b2:dfc6:2485 with SMTP id
 ffacd0b85a97d-3b5e866be37mr1530551f8f.4.1752144519104; Thu, 10 Jul 2025
 03:48:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626152023.192347-1-maz@kernel.org> <CABgObfZ3RepTFAMVSB4v1cmuOg+JB7LAcqx04EZui6qF3q5QtA@mail.gmail.com>
 <86o6tua76o.wl-maz@kernel.org>
In-Reply-To: <86o6tua76o.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 10 Jul 2025 12:48:27 +0200
X-Gm-Features: Ac12FXwkZUiiCJDC2HojeWiVZysisH16fFGmMHmUxWKm3vmZc3XEF7c6L-0RtaY
Message-ID: <CABgObfa-1ee9ugHk2WmwYmqTqUtc5x1wOW2JPv9+5VigvSAkZA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 8:06=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
> On Tue, 08 Jul 2025 15:48:01 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On Thu, Jun 26, 2025 at 5:20=E2=80=AFPM Marc Zyngier <maz@kernel.org> w=
rote:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tag=
s/kvmarm-fixes-6.16-4
> >
> > Done now, thanks!  Note that in the meanwhile git:// is not working
> > anymore, so you probably want https:// in there.
>
> Really? That's... odd. Was this announced one way or another? I can
> definitely use git:// from where I seat:

And it works now for me too, so it must have been a fluke on
git.kernel.org's side.

Paolo


