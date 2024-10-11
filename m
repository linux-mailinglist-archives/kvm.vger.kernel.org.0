Return-Path: <kvm+bounces-28606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9837A99A0D0
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 12:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47853284AA3
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 10:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44752101B6;
	Fri, 11 Oct 2024 10:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WPUwLjE4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B99A21018F
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 10:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728641351; cv=none; b=nlNMKzBLHYCncyHH9b8lSHELdKfpmOXF7ifqzn6tR0Fc5y3S4sv/kLkYCOuzjIr3W/CIJD/upoQuFPI1a/uMMAu6tVo+3eM49pUhRN3Pe2CzSKvg0dR0UD9Ola2HAhM0yEyuF002aIgfxEKP59PHVwvL5k6GG+YTpwX7lse6xaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728641351; c=relaxed/simple;
	bh=PMAPZWief1Cvlh5MnoziMG0cwFA7qKjTMEUZ3nnKxnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NLTGkrYvCcykn1DN5xr/vBufPVgqwgoLFdTOLoeVxq5AHiH3Qvtrc3Hxo3r43v+fGdqO4o5bQPENaivjetL4CA+AZJf0g7I+5PbnOmcs4uFw49iYRWqRdMe94Ag5Lg7C6PMQ7Xz5wUyWIjxFRmgdhSGax9ey8fuPqVYv2F12T54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WPUwLjE4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728641348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYX1/0xaAsVY9y/xa8IDQZuNB9RuCS/ODqECEVP3XcY=;
	b=WPUwLjE4cr6Za6/zA3/AE/EsmyVg0exnhEHgEwbxyJhHmx9XMeQkgi2/SRCI1f9pk92t3M
	xJoYVR9xpB6Kt3f4WzMY2LppumKL699oep46Xq5+KsTfcECnvJsU6Uhzdk/H81liKK2ilj
	IgWB2e+Y8q+cJn3Jda1WexS51y7v3Hg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237--tLT2vXFMwC9l5W-ti5xhQ-1; Fri, 11 Oct 2024 06:09:07 -0400
X-MC-Unique: -tLT2vXFMwC9l5W-ti5xhQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5398d98bea0so1283084e87.3
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 03:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728641345; x=1729246145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rYX1/0xaAsVY9y/xa8IDQZuNB9RuCS/ODqECEVP3XcY=;
        b=CjD3+WFQa7ELfbf2m0wafmlzSGsxueoMmepuPSQXDLPbBJAdi9uH/r1dWcvWQn6lEQ
         O0k5yhBzJr/Ad3ZYf4FwxaJPHYJN3L7MsAtyCMXaXUNcZXKTk+I+ZnLXn+yCLaVdZoM3
         CT1Nj6kEfEetrQac+NLqyUrBeqPoHJTMaQKnVmA4bra7gPzQOO3MUWWruDwr2jOInpME
         zaGHYAHwspGheED8tVTQa8wBnf+wj3tBzZRFJOjOMrh1O96U1ipOYpI9dDFQqD4Xh22r
         tg2WXGY5kNvLOqOV6ECgiP/vTS0a5nY6Ppcbawe3TSXIkTzNx0HRPvCkD1SfX2y1OcCP
         ef8w==
X-Forwarded-Encrypted: i=1; AJvYcCUhZn8vad7/2kd59T5E0x+qw4+gAXkoNGAanhrMFDsH1pWVO+bTUjfC/JmYk7PSVQK2w1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmc/V4nC3Yht+wMRcO29SFELb7I4n/S7MC+mU9tp4WPyRf8u58
	U1QDvOT1r63VwmKJ9ZIIWRQWQtG9THSmNhVVI8DrJ3kEzZdCK9njPCpa6J5ltyc1N7nr+RXAv2Z
	e8hSV7mppy7W8tt3RYUmqoZ+nfifxu67BhUQJhbdiM91Xd+B/p8R7GgxnjVvNtUSr1w6Oi4MI3Y
	jWagYWp+M6dQ+/wofc97Y3pwO0b5Z58S7KGY0=
X-Received: by 2002:ac2:4c43:0:b0:539:93ef:9ed9 with SMTP id 2adb3069b0e04-539da4f8601mr1065155e87.36.1728641345341;
        Fri, 11 Oct 2024 03:09:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHh9JhMluU61p9DiGJofBd50PyPZtVPQ4h/Gwn/PPd9vgOrL5ypr4hHBgPmFmh0wtP+fgFjDzk950NotpVtb30=
X-Received: by 2002:ac2:4c43:0:b0:539:93ef:9ed9 with SMTP id
 2adb3069b0e04-539da4f8601mr1065125e87.36.1728641344858; Fri, 11 Oct 2024
 03:09:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZwgYXsCDDwsOBZ4a@linux.ibm.com> <640d6536-e1b3-4ca8-99f8-676e8905cc3e@redhat.com>
 <Zwj4AllH_JjH5xEb@linux.ibm.com>
In-Reply-To: <Zwj4AllH_JjH5xEb@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 11 Oct 2024 12:08:52 +0200
Message-ID: <CABgObfa9AjsDTTKJY5sZLcH0+-7tbpUvMnEiyq_wxhe9-fajzA@mail.gmail.com>
Subject: Re: [RFC] powerpc/kvm: Fix spinlock member access for PREEMPT_RT
To: Vishal Chourasia <vishalc@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2024 at 12:04=E2=80=AFPM Vishal Chourasia <vishalc@linux.ib=
m.com> wrote:
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 8094a01974cca..568dc856f0dfa 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -168,6 +168,7 @@ config PPC
>         select ARCH_STACKWALK
>         select ARCH_SUPPORTS_ATOMIC_RMW
>         select ARCH_SUPPORTS_DEBUG_PAGEALLOC    if PPC_BOOK3S || PPC_8xx
> +       select ARCH_SUPPORTS_RT                 if !PPC || !KVM_BOOK3S_64=
_HV
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_CMPXCHG_LOCKREF         if PPC64
>         select ARCH_USE_MEMTEST
> I tried rebuilding with the above diff as per your suggestion
> though it works when KVM_BOOK3S_64_HV is set to N, but for
> pseries_le_defconfig, it's set to M, by default, which then requires sett=
ing it
> to N explicitly.

Yes, that was intentional (the "!PPC ||" part is not necessary since
you placed this in "config PPC"). I understand however that it's hard
to discover that you need KVM_BOOK3S_64_HV=3Dn in order to build an RT
kernel.

> Will something like below be a better solution? This will set
> KVM_BOOK3S_64_HV to N if ARCH_SUPPORTS_RT is set.
>
> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> index dbfdc126bf144..33e0d50b08b14 100644
> --- a/arch/powerpc/kvm/Kconfig
> +++ b/arch/powerpc/kvm/Kconfig
> @@ -80,7 +80,7 @@ config KVM_BOOK3S_64
>
>  config KVM_BOOK3S_64_HV
>         tristate "KVM for POWER7 and later using hypervisor mode in host"
> -       depends on KVM_BOOK3S_64 && PPC_POWERNV
> +       depends on KVM_BOOK3S_64 && PPC_POWERNV && !ARCH_SUPPORTS_RT
>         select KVM_BOOK3S_HV_POSSIBLE
>         select KVM_GENERIC_MMU_NOTIFIER
>         select CMA

No, that would make it completely impossible to build with KVM enabled.

Paolo


