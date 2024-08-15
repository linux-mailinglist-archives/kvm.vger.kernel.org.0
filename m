Return-Path: <kvm+bounces-24242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8E0952C8B
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 12:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08CDA1C20F64
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 10:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD201D3637;
	Thu, 15 Aug 2024 10:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oNztwj/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B401D2F71
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 10:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723716775; cv=none; b=fKhxAQcofYd7NcrTTiW3ZaY0z62yvGaK+v48AYMVuxa/yVo1AIEFRsPhuIzoUvnKzzAIphBpv5DE2bM0uvNOPzs47atAD0daejzjH9NBAytjBNl1wlSa7/Lvlma2KmFuJJ2yyoNwJWL8i4LLmFPzIdZV1cvpR+V2o9IVIN8AY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723716775; c=relaxed/simple;
	bh=ss2vBVBMZppsp8++4g/gygQoLY9/mLJIOe++Wq2OAtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n96UpYJByvSQ9qZA/BZnCg8G2GMKIXh9oyTB+NkGqJpWBPlvKteMtf+Hhd7qXsmfmV8gnlFf8p4tLC6L98WFzZ/I/XwQHrVdJcx9oE+kPK/a3LJouPyoED+ffH/i2DYnHN1bIaj00rFqfiGcXRTcrSB77bEx3RpGktp8kRFnzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oNztwj/M; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5b01af9b0c9so946056a12.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 03:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723716772; x=1724321572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBNryXwUQ1FmSedDlo0SbME5pHcOtJSt28zB17THPuk=;
        b=oNztwj/Mh/lOaoglLhWWlvjXUzVNW8MhyWr7EIFFW504tryLY62sD1uXUdJ/sDeRk4
         0RNDq34TB6P5giPr2fxCya84EXIjdhrbF1Su9pd2aJMVBCD3v+NaA38gsJE8DJMB9WK7
         M9igx+A0MKHwGL2Bpt+GaPBYbtSv4S6bdU5kkgtipy5wt6gr0L7aj3fEoM3pTwYwf0bS
         I9F5fnQRCE7B/3UrkDxjyBwXwwVG863gwwP7oCbdYXgaEXP4tl3EZspQzClWjsfl8Kf/
         E7kZO2N0O2jQdoEyVXgRFWkg3+E+DREBREHCcNFe1FZO08i81CAFFxX0ekxANStD4LjH
         95Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723716772; x=1724321572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IBNryXwUQ1FmSedDlo0SbME5pHcOtJSt28zB17THPuk=;
        b=OZ0hFzOLDVmYVxH60n6KpbZGFkKWsmbTRQsuIJxl6O4C2Ej+p/B+u5/ZSx0/TawjsX
         RnsUMStYnQyYEaycot/+cwfOu5DvYcXA953zUU9Yrf3DisRMa5xwyWHEz4LdaLq4Ihgd
         onEbb0CC2eKcEreZd3qXyIWa6t2jHAqOjaaUDMrpb5f+/I0keBxDPvAu2I/OzmSELjyo
         xRbcDrAANkIiSBWnHA9TOyyFCro+ViK/1pWAo5G0gOkrmULRiT9wEV/uDMmKZs4JEG6u
         GlIfVe3DXHjyndf9iP+Gm8kS71gI6ByUz2B9uMTYDNY/kXwjzKGDpbHi43yoc1X4wfvp
         tPcg==
X-Forwarded-Encrypted: i=1; AJvYcCWVhYNoPCr5udKkX6w+vVDP8AUEQ7rIBiQcxmtK5IHdOEagkpS4ew6UaJgN0OnBO4WqvX0qNoj8SKg01Uw3GT0i3Ipc
X-Gm-Message-State: AOJu0YwwFrU9EehO1cEnUl7d/CyWHz69Ei2PAR9At0DHCKYPB5uu0Q3B
	Jcwgz1WC4BkEB2XYmnLE4PSU4xIUtivZ6xyLAD2V3zHnsuCFqRxeOuLCQjYLzuI9ou7TjNdU8tM
	ZAK5zr0fH/oS5ATo3U39VJp+2crJpwhCO/KsCcA==
X-Google-Smtp-Source: AGHT+IGNaYJf90yHZ/TRxldPcq5OdO7je4IKLHSYUqjFp+8oZOTGa63oYD4Ubggc5/tHzKEgewZOFYIFZFUJtMC9c+Y=
X-Received: by 2002:a05:6402:3788:b0:58b:7b90:94e2 with SMTP id
 4fb4d7f45d1cf-5bea1cb4e62mr2896445a12.38.1723716771475; Thu, 15 Aug 2024
 03:12:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org> <20240814224132.897098-2-pierrick.bouvier@linaro.org>
In-Reply-To: <20240814224132.897098-2-pierrick.bouvier@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 15 Aug 2024 11:12:39 +0100
Message-ID: <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org, Beraldo Leal <bleal@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Aug 2024 at 23:42, Pierrick Bouvier
<pierrick.bouvier@linaro.org> wrote:
>
> When building with gcc-12 -fsanitize=3Dthread, gcc reports some
> constructions not supported with tsan.
> Found on debian stable.
>
> qemu/include/qemu/atomic.h:36:52: error: =E2=80=98atomic_thread_fence=E2=
=80=99 is not supported with =E2=80=98-fsanitize=3Dthread=E2=80=99 [-Werror=
=3Dtsan]
>    36 | #define smp_mb()                     ({ barrier(); __atomic_threa=
d_fence(__ATOMIC_SEQ_CST); })
>       |                                                    ^~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  meson.build | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/meson.build b/meson.build
> index 81ecd4bae7c..52e5aa95cc0 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -499,7 +499,15 @@ if get_option('tsan')
>                           prefix: '#include <sanitizer/tsan_interface.h>'=
)
>      error('Cannot enable TSAN due to missing fiber annotation interface'=
)
>    endif
> -  qemu_cflags =3D ['-fsanitize=3Dthread'] + qemu_cflags
> +  tsan_warn_suppress =3D []
> +  # gcc (>=3D11) will report constructions not supported by tsan:
> +  # "error: =E2=80=98atomic_thread_fence=E2=80=99 is not supported with =
=E2=80=98-fsanitize=3Dthread=E2=80=99"
> +  # https://gcc.gnu.org/gcc-11/changes.html
> +  # However, clang does not support this warning and this triggers an er=
ror.
> +  if cc.has_argument('-Wno-tsan')
> +    tsan_warn_suppress =3D ['-Wno-tsan']
> +  endif

That last part sounds like a clang bug -- -Wno-foo is supposed
to not be an error on compilers that don't implement -Wfoo for
any value of foo (unless some other warning/error would also
be emitted). At any rate, that's how gcc does it
(see the paragraph "When an unrecognized warning option ..."
in https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html )
and I thought clang did too...

thanks
-- PMM

