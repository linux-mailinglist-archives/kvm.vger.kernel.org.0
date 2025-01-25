Return-Path: <kvm+bounces-36597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67984A1C4DB
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 19:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0C823A6A56
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 18:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3A386358;
	Sat, 25 Jan 2025 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VmYezx0F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF316088F
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737828982; cv=none; b=kXqq7vUxcemq2NyK32feOGQ4bIM0uJ+x9xRhLyeSFpaZLcXAhM3CXJjT2wlI3d2CDOopPw/sgKrPzJP7BLgQuDo0ARJcDejtU2INCTrUWtu769Rq2nxo6+5X6zxrtEN8ik4Nnr9oaVT/bCYyIHmv4bB5la1mRY6y2iwxW/jQna0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737828982; c=relaxed/simple;
	bh=nS1r4ZaokxUFk2zNZeebkVwEYqCuct68mYFLzUH3mJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eRhB43pV2uuZ/oQL8I6nJpk8/1xN8AtYBIBARlmEdkEOsqfhvvU6HZUQqv/rAudOo8wo70ppcxqKDnYEEdEhYNFy/hAk9kT7o/IF5zY3R3Wl3uZQ88uZhpAWfr92l8pP+XXUJaMn7Ts311ohSCXJXbboUM6KBxXCXw8uIudaXjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VmYezx0F; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaee0b309adso443447966b.3
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 10:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737828978; x=1738433778; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VD96Nbcx0ze8c3A+so83/f1Z5byWnpQbzAm4VxjJ4aQ=;
        b=VmYezx0FnonYTd1wMMNQ4TnBYEKhE2h8cexaT9vCHDImJoY5mfENtDmzZICUWtMMRf
         1aoM6J1Oq48eniIQcABma/0uTKrVhluHrxms9W5uDIvClqMl/OJY3GP3LYTAP6WjHUi6
         L/jTe0pgXrWLQZsyJtNX54lIMxngMtT2BFRLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737828978; x=1738433778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VD96Nbcx0ze8c3A+so83/f1Z5byWnpQbzAm4VxjJ4aQ=;
        b=isIy+3kbjyJQ9fndiDmm7nWQPG4dXvbt5x4mGfSo1Znany+YloS3rr38tSq+glnqPi
         1qYCoUyUzOVwZ9On96QsesiSlMTzLiTSYCBkaGmB9AeA2m3lkHI7FwzZvU4tJOduhues
         1pdyAYLgWig/sxm1x5h9e/d+pQ+bV7qAA7RfiHqHcOQwaihE5MJWNbtgUDGk6jSwLiHQ
         3nm0A9ti/qKcj8k3BWNRlNri0GBBFSawVIfRiApqGmCJshIDW+OvdPEyD9oPf4Ydi8Og
         7XBYjAU/uxes2ygKrIDe4537MvgIKTjWcnm/7mcWiJKM3V+2MyMFeOeDm16OY9FasChg
         N6eg==
X-Forwarded-Encrypted: i=1; AJvYcCX7RdNY8RZqfUE4OYFUD+0dJSvAbzrbH5Vm0nNPD92cED/cTz7AxotdmnPAPu6+cRNtaDc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYr9ewUtD0y2dzJNUiayP1LGV2ZFjVF5sdGWvUYd62a5feXAsn
	9AlCp9AS3eDZBLPpM5lB2JnWkx0s1OMXnJ9U7YFIkRHQrFKoMo98BwmW5a5d4fYUVr55BabJ4qg
	FmYk=
X-Gm-Gg: ASbGnctelmDdDAgRdGQ/AGrS0P2oi93vqFJkB9YCO4h1QtyGAJtuJVdiM5/auoOOSbC
	27uDy++EJXd4N3NaO0n+rZRfIzqnFjcfk/mDFYMyVKB+3S0MrZlBaADTuMkwaKG1hbbCNIr+05y
	52kIlbBBUxhS/BY5LYo06oIlfC8VF9G3m0Xny4RKhm27a6oLlb2vDRPVHlDmO/tI4KH+uvft1Pq
	Nit4q80RG1jpwf0vfHv5oVB2eG33/4ciuaR30s6kXv9V+nW5rXWJBW0eo5D6NGNQGWxkmi3ym1t
	7A/QNV5+SI5S32bv3peSfB0+ovO3zbycZU8+/N2TtcYSxVkd055yCIM=
X-Google-Smtp-Source: AGHT+IEszJd/ioJugBcIaYoD7qIuYd/dHEMkVqGj61Hw+5hs9kub3NpQMWEk6L5xDJ+UeUvhM1WLNg==
X-Received: by 2002:a17:907:1c89:b0:aa6:96ad:f8ff with SMTP id a640c23a62f3a-ab38b3fc0f7mr3492549566b.52.1737828978279;
        Sat, 25 Jan 2025 10:16:18 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6760fbb9fsm325203766b.142.2025.01.25.10.16.17
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2025 10:16:17 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3f28a4fccso4629792a12.2
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 10:16:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXJd8HMPSft4Y8hCSQzLCKtzywvfk+jGNzC9/v5Y8jtbPO6D6njlCt8AoBSLWge72PmWSg=@vger.kernel.org
X-Received: by 2002:a05:6402:2790:b0:5d0:9974:7da2 with SMTP id
 4fb4d7f45d1cf-5db7d30107bmr33843812a12.19.1737828976881; Sat, 25 Jan 2025
 10:16:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com>
In-Reply-To: <20250124163741.101568-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Jan 2025 10:16:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghGxSMv3K0BEB8N3N3vwk-3v=T1FhBVJyf2u_xYYJOCA@mail.gmail.com>
X-Gm-Features: AWEUYZm1WOgdXuN6Os_6LHBEmk6sncIu_qlZynye5K1hrxyDSOmJeX31ATyvZ-E
Message-ID: <CAHk-=wghGxSMv3K0BEB8N3N3vwk-3v=T1FhBVJyf2u_xYYJOCA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Jan 2025 at 08:38, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> but you can throw away the <<<< ... ==== part completely, and apply the
> same change on top of the new implementation:
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index edef30359c19..9f9a29be3beb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1177,6 +1177,7 @@ void kvm_set_cpu_caps(void)
>                 EMULATED_F(NO_SMM_CTL_MSR),
>                 /* PrefetchCtlMsr */
>                 F(WRMSR_XX_BASE_NS),
> +               F(SRSO_USER_KERNEL_NO),
>                 SYNTHESIZED_F(SBPB),
>                 SYNTHESIZED_F(IBPB_BRTYPE),
>                 SYNTHESIZED_F(SRSO_NO),

Ehh. My resolution ended up being different.

I did this instead:

               F(WRMSR_XX_BASE_NS),
               SYNTHESIZED_F(SBPB),
               SYNTHESIZED_F(IBPB_BRTYPE),
               SYNTHESIZED_F(SRSO_NO),
+              SYNTHESIZED_F(SRSO_USER_KERNEL_NO),

which (apart from the line ordering) differs from your suggestion in
F() vs SYNTHESIZED_F().

That really seemed to be the RightThing(tm) to do from the context of
the two conflicting commits, but maybe there was some reason that I
didn't catch that you kept it as a plain "F()".

So please take a look, and if I screwed up send me a fix (with a
scathing explanation for why I'm maternally related to some
less-than-gifted rodentia with syphilis).

           Linus

