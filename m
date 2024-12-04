Return-Path: <kvm+bounces-33065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 742749E43DB
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3535E284269
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E691C3C1D;
	Wed,  4 Dec 2024 18:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FdltHmvw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B965E1C3BEF;
	Wed,  4 Dec 2024 18:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733338559; cv=none; b=px4FC7D8E88ux6pynxWOzxK8OdwVF/NxuUfeGjDTF0HrqlFByt0OCzGEaV+O3pHO1NwXGMx/8fux5vhfF/H/J813IUT1CvBWJ+7ZHc/R20Vge3Z00rmKL9hqBURJVK8CYxfN0jXQbRz8uKis32lgRXBTMrsorpnYv9rKRIHreSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733338559; c=relaxed/simple;
	bh=Q1I96KHKoKquP99zDV8hikTm7n6IHjkE0xL4a4TEJxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lDlcGq6wwtcJIDymdnx5IPKBzbH9HK/1cilsT4PgwQftQbQ4uCP1HQRrEmBF1nVbOfd2r7XvgxVuZ+i6BO7rY01hXSiKG+wWnkfpK7lChVhuyinqYuZC7a2ZrkjD7N9egAmXMEXsJkc1cjk6xOT+f/MfU9ipXdGi9NQRDVnqxvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FdltHmvw; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9e8522445dso7267466b.1;
        Wed, 04 Dec 2024 10:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733338556; x=1733943356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1/QHLcx9K+qGIU6YvEpG3MhDlT7rfFaGUxo0C4Xc9Y=;
        b=FdltHmvwVDG4CiObU6fs8IiyJMnlJf1M47SKWTx8Fo+6VLn5710uQzC4g9lFmVT09t
         wMBCxcE+0mYWAXtqXHMvGAZ/dGLrymbvVD+fStKsBYvm730MBWvYWpPzMTsdrA9OOyZq
         GJ4KUHOsjqkTO7yvEpEZ/MpTrPAqd/9fdkWMHfBUNwrMclEl+1sY8jMTX36EPuMouJEf
         Vz+tXVNsacqLI/AzUIfrvc/CaqWUOZ1JiAbOkZZWhLS5NfmP74L+uZgYPIE2VyhzsztQ
         U9LjDNGWt8pyYobZWCkRa+mFikVUiA2DhPEf1glB53daxZUBrMFLSkXl8EoER6IT3F6L
         uIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733338556; x=1733943356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c1/QHLcx9K+qGIU6YvEpG3MhDlT7rfFaGUxo0C4Xc9Y=;
        b=j2YBps+XLwzXaVHkwnmS7JopneIldd+AkjNjQ6xvOv4Rp8tcIwM2G+0fnBVbNwuSja
         ZC8AIxx/Gfw6OvuHlpWaF/fubLsecdbKhDh2KE9+pDydVti5IETsxtRe/GK0Zr2aFESo
         EMfyD4+FDCDyJxuR2b/83mTmsLJ+/MWIFmV6PxXZHzD3xNxVVOrJg56b5Sr7jOohOWRd
         KazTVIBUlKHQSmhmAn3qw8gA/C7dXdza1jW0q3vJZpfEX3je6Yp9FmndzeOCFW+LDby4
         o6mhA5lzMDeUccQfjtwoeY3BQDrnmBAhX/r1SwAgU8GDSMOAFFvfrdBG8GzeO5/Lhhf3
         CP+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVdR0VdrIHoNXxLbsGPg7Jz4qCv4DYQvDsuafXPg4ehr3lF7hEXlkWH2qcflM1JdktWlDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRA1mxgXls5zWhYtZC/bHIZEN/1Ld/0EQj8gROYqtHc0PRCcYd
	6hH94oWpM4WXvIAN/cw5pLhzpPezcGdfF08n2W3Mzh2SSgG5Prau9QtE64IuHmU36p4VM/nFOFf
	rufRdeE0sPdkqIFP4G+G17yzJJc8=
X-Gm-Gg: ASbGnctf+Bly5uY3fITnTYSMw2rZmD82Oo6ZePwUnEQPycjie6+dQWRfxcv7kctNwhM
	KyqOVcuv+0gkWD1XK1FyqSpt7dCaawQY=
X-Google-Smtp-Source: AGHT+IHO73y0YMfpyzVFzPRnJuX/MCTvcGmO3AohXcef59b3IHqy3sLghsRluNcSGYhVKKHz6SZLH/YUcm+SMs8TWEw=
X-Received: by 2002:a17:906:23e1:b0:aa5:4adc:5a1f with SMTP id
 a640c23a62f3a-aa5f7da98eamr589602866b.33.1733338555820; Wed, 04 Dec 2024
 10:55:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-9-arnd@kernel.org>
In-Reply-To: <20241204103042.1904639-9-arnd@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 4 Dec 2024 20:55:19 +0200
Message-ID: <CAHp75VfzHmV2anw6C8iSCiwnJc2YNa+1aLDj6Frf9OZyGjD0MQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] x86: document X86_INTEL_MID as 64-bit-only
To: Arnd Bergmann <arnd@kernel.org>, Ferry Toth <fntoth@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+Cc: Ferry

On Wed, Dec 4, 2024 at 12:31=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The X86_INTEL_MID code was originally introduced for the
> 32-bit Moorestown/Medfield/Clovertrail platform, later the 64-bit
> Merrifield/Moorefield variant got added, but the final

variant got --> variants were

> Morganfield/Broxton 14nm chips were canceled before they hit
> the market.

Inaccurate. "Broxton for Mobile", and not "Broxton" in general.


> To help users understand what the option actually refers to,
> update the help text, and make it a hard dependency on 64-bit
> kernels. While they could theoretically run a 32-bit kernel,
> the devices originally shipped with 64-bit one in 2015, so that
> was proabably never tested.

probably

It's all other way around (from SW point of view). For unknown reasons
Intel decided to release only 32-bit SW and it became the only thing
that was heavily tested (despite misunderstanding by some developers
that pointed finger to the HW without researching the issue that
appears to be purely software in a few cases) _that_ time.  Starting
ca. 2017 I enabled 64-bit for Merrifield and from then it's being used
by both 32- and 64-bit builds.

I'm totally fine to drop 32-bit defaults for Merrifield/Moorefield,
but let's hear Ferry who might/may still have a use case for that.

...

> -               Moorestown MID devices

FTR, a year or so ago it was a (weak) interest to revive Medfield, but
I think it would require too much work even for the person who is
quite familiar with HW, U-Boot, and Linux kernel, so it is most
unlikely to happen.

...

>           Select to build a kernel capable of supporting Intel MID (Mobil=
e
>           Internet Device) platform systems which do not have the PCI leg=
acy
> -         interfaces. If you are building for a PC class system say N her=
e.
> +         interfaces.
> +
> +         The only supported devices are the 22nm Merrified (Z34xx) and
> +         Moorefield (Z35xx) SoC used in Android devices such as the
> +         Asus Zenfone 2, Asus FonePad 8 and Dell Venue 7.

The list is missing the Intel Edison DIY platform which is probably
the main user of Intel MID kernels nowadays.

...

> -         Intel MID platforms are based on an Intel processor and chipset=
 which
> -         consume less power than most of the x86 derivatives.

Why remove this? AFAIK it states the truth.


--=20
With Best Regards,
Andy Shevchenko

