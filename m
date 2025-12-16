Return-Path: <kvm+bounces-66095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E265CC56AF
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 23:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CD4DF30036D5
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 22:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2754D33FE00;
	Tue, 16 Dec 2025 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="logYfAw4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D49B23958A
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 22:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765925968; cv=none; b=aVV75MkmuQD1Lx1h1m3NCpd/gycpEowuccXF5jxBqE/GzFD2vf1//vR5O+Hb7+Jk/zF9svIqkfhNqGZfcmIAjcjEzBW9lUFHU+CESgunpaDmayBdaRv8cDSe37QjhAgGy6ffB54QDACqP4r0cVZJQIguOxSvgf0PvYfIAInRyLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765925968; c=relaxed/simple;
	bh=kWLv1ZatiB79bU/6xLjGSPPP8KxuSeaL3GK3ohz7jvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JTe87js+XOThPP2Jw0brMKOF2GsgWw5tL9lM+wHdCmsWS57DE/OSHx7vanD1SfQAKg11UuA93RGt9ieAauPkT+OJPavF1ShaxQDS7iexlC2anRBD13DCvNcFSSo+UVzlo64kV5p1NzrF6TVXxQJR2qwQGf5ngIz+2WtdhZdi9aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=logYfAw4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7baaf371585so10955b3a.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 14:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765925966; x=1766530766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A6FqMrw/4plY2VKF8NHzNlp9G6Ihzs4CeaMN/98WbHo=;
        b=logYfAw4w+7oeqIUbAhc5AhKLpAuoVQeL5Zj1tVAB4OsOjKc7vMxPED9HzcI3og/6X
         Xwyj7BHUWCaxpo3KjkYgzAgzKKRxnEPAAkmsiQFrvRMdyun7eVT3IKBuJ5d53K+Dod4T
         yR/HyyrDVJnFgv4FSn8tJj/MzHi60HxMed6JKNNd1x4KswJx4daPYQbI3dy9et91Bh5L
         lELxpceyB8byTrWI7W7m0sEoVL9lO8cgRNCfBAKS2i2OtRJaOr9V39eStgFVNvDlwBDv
         T+VpiwouOhFP1ex0AgZocPlSkvaOPbE1FzeMm5plrIxovJG8BVQKMBt/1WGoEyWWhm21
         dEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765925966; x=1766530766;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A6FqMrw/4plY2VKF8NHzNlp9G6Ihzs4CeaMN/98WbHo=;
        b=tUnqb7URf6ITfsKu+jjKGpakN2Ag2ZHt71yxFaeIFi7fDl/ZcFeghqI6/TmbUwBFLy
         0fSmDC1NhEGC0RzGO3lVM2J50lNlrOg52uZxWR2ue2iYE1qybtSg03UgIiRK4sv9mpEc
         DLTSEebnvuz5ZCrcaSPPB04wZlh8C/q81goCbXgzmmTvbJ706IZQ7T50ISPR1+R+8Hk7
         79dSzuENSrCZm3Jx908GfuhAQ3FAhLnagp2gtw2W0Ll2Y10FAiDsIG8+bZ/QLiXVCKne
         0kDkzc7AIJDUfVQiwNd4CpovKtLIHcDd1JcCNLiBkEQv5gfO2YyAAp+0uqK+yGj4eJeE
         KZjg==
X-Forwarded-Encrypted: i=1; AJvYcCXnbsR8gmGzgXIbyP44sK2L4Bj5Ules0WKvp8jMTREpqFWeZ25SOoIMVcvtr+0b9P9mjFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDzKaHNFw9hrZlOvmEOUUOKsCcrf4Go2Xw+eE6GrQ/wAQFoDqS
	m9qAx6d5ZK2+iLsnaJ37HK9YICdKpLoa8mwpxa+FqVsGdvc3sxE972ZZFU/cokV+ioS/HB8OfS0
	Nakwc2A==
X-Google-Smtp-Source: AGHT+IExgYn2AoeL6TyR0RvctoohVap9xTM7Yty7PGJedJtwf0ynDvLmNyZOoeANgTeWAYI0dch7dNX6VG4=
X-Received: from pjbnb12.prod.google.com ([2002:a17:90b:35cc:b0:34c:c510:f186])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734c:b0:35f:31bb:5a5d
 with SMTP id adf61e73a8af0-369a83f9190mr16163192637.2.1765925966212; Tue, 16
 Dec 2025 14:59:26 -0800 (PST)
Date: Tue, 16 Dec 2025 14:59:24 -0800
In-Reply-To: <CADH9ctCEVJCC+_bZwDETmePhgfVy+jJvSb4Jz6bGLdmL9RSmUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816101308.2594298-1-dwmw2@infradead.org> <20250816101308.2594298-3-dwmw2@infradead.org>
 <aUHAqVLlIU_OwESM@google.com> <CADH9ctCEVJCC+_bZwDETmePhgfVy+jJvSb4Jz6bGLdmL9RSmUA@mail.gmail.com>
Message-ID: <aUHkTBzRqqvsG0LG@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Provide TSC frequency in "generic"
 timing infomation CPUID leaf
From: Sean Christopherson <seanjc@google.com>
To: Doug Covelli <doug.covelli@broadcom.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, graf@amazon.de, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Colin Percival <cperciva@tarsnap.com>, Zack Rusin <zack.rusin@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025, Doug Covelli wrote:
> On Tue, Dec 16, 2025 at 3:27=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > +Doug and Zach
> >
> > VMware folks, TL;DR question for you:
> >
> >   Does VMware report TSC and APIC bus frequency in CPUID 0x40000010.{EA=
X,EBX},
> >   or at the very least pinky swear not to use those outputs for anythin=
g else?
>=20
> Yes, all 32-bits of 0x40000010.EAX is for TSC frequency and all
> 32-bits of 0x40000010.EBX is for APIC bus frequency.

Nice, thanks much for the confirmation and quick response!

