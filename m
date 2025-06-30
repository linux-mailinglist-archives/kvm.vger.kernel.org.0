Return-Path: <kvm+bounces-51105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F2BAEE2AF
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 17:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11DE017379A
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 15:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0251E28D85E;
	Mon, 30 Jun 2025 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pXHN/Wc8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5DC28A1D4
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 15:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751297687; cv=none; b=ELGFsT7//EP+X6LJiotPxG287Gx36wIcZLmVn+j86yI15om3VtwYUgmUxLqCFhdrcw3I3Xni/b8doVX2Q9x+SQ7Rq4kjWH3cZusEJqwUYTvFkRHQ1vXMReo9x2ZNzFPCUdv8qAMN5uBwSzY4ufWBfeC+031/BJNGLsSjADJNrXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751297687; c=relaxed/simple;
	bh=dTIEpNfnYulofFuNLh2SOoCSx1vdBES881FHujrcw+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ugrpA0ufOJFl7SFPtSSErkucZXa+GNiI16AtOkr31lYjhBx5yXPGdbPj1TCBgUCqqWXrJ3sX/+1AhiiZTFEXbW4Vo+etjQZ2cbx60/WV2hXUBmDoMMWOFS9zPfaVkgZUtYOJd+04w7ijt0ysGwTQgI05MjfOJ6M9SxgC+jmC/4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pXHN/Wc8; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-714067ecea3so17325137b3.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 08:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751297684; x=1751902484; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzC/oii9o7rPIbYU7tLpYjy4/LYNBCTnqw6z2ZXkL0s=;
        b=pXHN/Wc8fuFwoMmjfSnoYH4cJof7PiokBtzxNnkDYWYVfPsoPGvbG4Rjrtv6kyX59t
         vy9Sv8cguvRU2iVa5iIxZ7tjBzTrAqX4WdzM7DXpC4RW/ZeXIB1Jz5kitvmUcOe8gk+D
         Gm6e5SrOsgBv30u12rP6G2rWFaFVnsavIPQSann+DlidNhIjZeaOfP+vaaf4drEX7TUF
         o3pLFf2dWrIikzoma3RwrAL5BjKFpEt6WkZPkGm6hg2+odowWz8OEqd9kE/YiHBunABs
         vXW6YQrO3Fr539IaJkHggVtgU92SXXgRQEFT1DFxyxXC8eFcvk2d6HYy33ZBq/6KUWyg
         rJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751297684; x=1751902484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzC/oii9o7rPIbYU7tLpYjy4/LYNBCTnqw6z2ZXkL0s=;
        b=C1k/uPEKcuSHc3JKFuAqDki0R+rJ+CRjo0Bo57Ue1nYGU+rfG1XAfBKXbzC3Jl2wB9
         DRQxRtrr7fn9Xm033wpJO1FT74bmIIT9qs9tfs8+woit9fjnTfrgyI4PPx795SzZSHM7
         VNhKz3vbWV/PpscWRK0p7HmvpZocCU83ZKtf1FfdoMk1uE+JOUnTq+liGI5aSKOFGKZr
         PCUbLED3SMK4wN6bl9Oju1gHzULCUjklf46bVIgtuEmViWGKeE5SYTtmi1uTSDsPgfwM
         XRR9/GWqglP8vPXSv+H81W/dXdQy79r/G36XCoEslflTh7vHYEcc3bElkdTtEPV8QOc0
         n1WA==
X-Forwarded-Encrypted: i=1; AJvYcCUPI5vmaX0bs2YraLgN8JRQiHSwSOPBzQEOSwxcDiFyVMVuuQ1xa71ObY+fqw24t3H1AHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH00ByHfsS4YewYhNDE12GAJGqTA3MvJ9tsRA0J2XVYdPnisCs
	8F/gjeoqIlJFbmA0+fUV+bodWM5Ep4BTYQTL82D0XH43CSzoIMygswFkcyrE3/ePxRe4zVtLJvX
	PrwMhgls4tejjsClydWFCn+lK38muSGTH20O38ZOPLw==
X-Gm-Gg: ASbGncsRfBk9OdxtpDaRFtKvdP0eBPfCEsfvQx/+ALTwT6Va7cuEx+kwY+0RIMml7Dd
	z/fRR3HvjveDyxrW1ErJlFoNxbuaqLKYaRFhnyRQeX/xI0jLftAjLGDEuV431q2IBHhmVt43aqT
	AkM91RF1Frg+M/d03lmaLoiAVfdakfJFqMy2Xb+r/FCfvo
X-Google-Smtp-Source: AGHT+IH+iwwqTU7zlX2I945lgbnNlrrxF9cxMU8gMHe6Vd7HsmOmqSLMequo3znfXJSEumDV7EvriQUoY33Fxg3xTNc=
X-Received: by 2002:a05:690c:d85:b0:70f:8884:17af with SMTP id
 00721157ae682-7151714d14emr228157307b3.6.1751297684555; Mon, 30 Jun 2025
 08:34:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250623121845.7214-1-philmd@linaro.org> <20250623121845.7214-21-philmd@linaro.org>
In-Reply-To: <20250623121845.7214-21-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 30 Jun 2025 16:34:32 +0100
X-Gm-Features: Ac12FXygwnSXLP-ZPonXcEmOAhgztcCBXBn2LNuOkJFkl9HoaCecpnHthAmLnYw
Message-ID: <CAFEAcA_xqu1oDLThHBp5T_srQs2+2oxWTXF=sQzBjKDduc0cfw@mail.gmail.com>
Subject: Re: [PATCH v3 20/26] hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>, 
	qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>, 
	Radoslaw Biernacki <rad@semihalf.com>, Phil Dennis-Jordan <phil@philjordan.eu>, 
	Richard Henderson <richard.henderson@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2025 at 13:20, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> QDev uses _post_init() during instance creation, before being
> realized. Since here both vCPUs and GIC are REALIZED, rename
> as virt_post_cpus_gic_realized() for clarity.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  hw/arm/virt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index a9099570faa..da453768cce 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2032,7 +2032,8 @@ static void finalize_gic_version(VirtMachineState *=
vms)
>   * virt_cpu_post_init() must be called after the CPUs have

You forgot to update the function name in this comment :-)

>   * been realized and the GIC has been created.
>   */
> -static void virt_cpu_post_init(VirtMachineState *vms, MemoryRegion *sysm=
em)
> +static void virt_post_cpus_gic_realized(VirtMachineState *vms,
> +                                        MemoryRegion *sysmem)

thanks
-- PMM

