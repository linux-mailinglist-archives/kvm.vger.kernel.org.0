Return-Path: <kvm+bounces-26440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 355B4974756
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1AD72854AB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA4D6DF42;
	Wed, 11 Sep 2024 00:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PjDXoOFn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F91C148;
	Wed, 11 Sep 2024 00:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726014291; cv=none; b=efoZk9gF38iOnVgAVVjvIWMzeilJ/vbdJlnXAIsqO6mP8BnFjN51M+m5a+d/JAkzWSBGPO0JjaLii2grPbH6L5dtjN5QYSvW4xJeYZlrZzSd9oZR/QSCn/b6b6rZzpqIG+fZUScIJZ1841GjoDr2K0MOm5Sl6iChEX4GdG92puM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726014291; c=relaxed/simple;
	bh=O7i8vO8KrxkhxH47kfbnpbOXoX45S9Fs3mljcLtz22o=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=MrtgtIdjfp+qbc/U2madOSSGWvFgTrdqK95sqR2dm+30IxwQgWZpW7KCHSIQsNtuFlQhUnhrp7d/7yFk4svsMG+K9AIbPuy7O/gFX5O8D/meFH5xpYYk7gwbhoH7dzZ3m4KH2bjNfr+jA0tnc4Evd9XfoWyEGw4mzT3mpWMcBdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PjDXoOFn; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-718e6299191so2094890b3a.2;
        Tue, 10 Sep 2024 17:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726014289; x=1726619089; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQL7b2T+ck7yVp9AOdbZlAurU0fDqRzd8GlLZ/sklTg=;
        b=PjDXoOFnLj5bk7ZOyoGiPeiLXNA0JIibKgx8hpKsvL9ncpWWWbMZbGjG0QUsEzmoxZ
         01rBi0iUwPXgntTaZw7erXxPsWB9VT1vJA1XOPAGz1uSuCbNq8NqVJ3080quLNghcd4+
         26zrPLNGxEqV5khaO2Jk+YXnzXnEwH3qxHazRSpj/mkgtFjoAhjORAhxWjtCCcuFyzyJ
         fFhQl+sfMRHTCE8c8U4/KvpTpslLlhmqAZB7COwTviMw+BAJygOcIO2qSAmJa03bgXZ0
         WZAIDPH0Lx6+nNEsaVAlvoJl77rrHk+5na9oD6/U5WF3AdiKqB2EcgmjzUe2zhT9xDYh
         rSDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726014289; x=1726619089;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hQL7b2T+ck7yVp9AOdbZlAurU0fDqRzd8GlLZ/sklTg=;
        b=k3tuwBOub8Yt0A/mw2sj7dpnWcyFCWLPteb7S3Sd+6KePAR1eofRPycTED7f8BceuW
         JE+CZHTEqqUNSVDpz0KmzH8K7ZUzLQV9q/qfrtUnR48K29jIr7DiLmskLdwy64Zmf/x7
         B29TZtBJf9hlHO9OpKWOz1lNEpRnVyRSD3jOOWIcP3zSO2qn8Il3A3BDmweVT8EIcsfV
         40FvU7BXFIBO4dxvtNPt/AyUOC9/HoJ1b77DLAW8fJl2cC8qWRv+ooAQ4bWHpybNu3l0
         +4pvAEyCV/3ic4UtSUTXS3oSc9rSW1H229esJeXfQycX/wNTAK8mV6filgBHlD/sTaZ4
         BCEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwHgb5vBewUR3986rdy2/2nnYdx7hxuNzrxOQvNfuQjAGj/WkVL0BPZWYSivb1hgQUREd5StO6AMvcPQ==@vger.kernel.org, AJvYcCXvuJVJS6DO7CljwXV9IbOOduk+2m6NbuaFMMOPLNVw1N0t3tp5KyH0zzDt69YiopvBbXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxEXuPR90zqpO4LzbuAF/UdrL6N4rnS2nTLAVp2KFmqbFo52+y
	M9Cl+4yBQIHWgBaGdOAiNWI7wI9iZQyMxTE+a2K0/6XN9t2LA/Hr
X-Google-Smtp-Source: AGHT+IEBdeHkCceNz2Cdj6vYvPK7rPbq1iaO3iYumNfAUIh3qemUllNju96UzHJ623oYLYNeAbHUxw==
X-Received: by 2002:a05:6a00:988:b0:714:2198:26b9 with SMTP id d2e1a72fcca58-718d5e50f2emr17269272b3a.13.1726014288800;
        Tue, 10 Sep 2024 17:24:48 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fe264csm1918606b3a.61.2024.09.10.17.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:24:34 +1000
Message-Id: <D430ZV4FP2GE.3B7VE2I37RPXX@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <lvivier@redhat.com>,
 <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <nrb@linux.ibm.com>,
 <atishp@rivosinc.com>, <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/4] configure: Support cross
 compiling with clang
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.18.2
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-9-andrew.jones@linux.dev>
In-Reply-To: <20240904105020.1179006-9-andrew.jones@linux.dev>

On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> When a user specifies the compiler with --cc assume it's already
> fully named, even if the user also specifies a cross-prefix. This
> allows clang to be selected for the compiler, which doesn't use
> prefixes, but also still provide a cross prefix for binutils. If
> a user needs a prefix on the compiler that they specify with --cc,
> then they'll just have to specify it with the prefix prepended.

Makes sense.

> Also ensure user provided cflags are used when testing the compiler,
> since the flags may drastically change behavior, such as the --target
> flag for clang.

Could be a separate patch but no big deal.

>
> With these changes it's possible to cross compile for riscv with
> clang after configuring with
>
>  ./configure --arch=3Driscv64 --cc=3Dclang --cflags=3D'--target=3Driscv64=
' \
>              --cross-prefix=3Driscv64-linux-gnu-

Nice. Perhaps add a recipe to README?

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  configure | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/configure b/configure
> index 27ae9cc89657..337af07374df 100755
> --- a/configure
> +++ b/configure
> @@ -130,6 +130,7 @@ while [[ "$1" =3D -* ]]; do
>  	    ;;
>  	--cc)
>  	    cc=3D"$arg"
> +	    cc_selected=3Dyes
>  	    ;;
>  	--cflags)
>  	    cflags=3D"$arg"
> @@ -200,6 +201,10 @@ while [[ "$1" =3D -* ]]; do
>      esac
>  done
> =20
> +if [ -z "$cc_selected" ] && [ "$cross_prefix" ]; then
> +    cc=3D"$cross_prefix$cc"
> +fi
> +
>  if [ -z "$efi" ] || [ "$efi" =3D "n" ]; then
>      [ "$efi_direct" =3D "y" ] && efi_direct=3D
>  fi
> @@ -370,7 +375,7 @@ fi
>  cat << EOF > lib-test.c
>  __UINT32_TYPE__
>  EOF
> -u32_long=3D$("$cross_prefix$cc" -E lib-test.c | grep -v '^#' | grep -q l=
ong && echo yes)
> +u32_long=3D$("$cc" $cflags -E lib-test.c | grep -v '^#' | grep -q long &=
& echo yes)
>  rm -f lib-test.c
> =20
>  # check if slash can be used for division
> @@ -379,7 +384,7 @@ if [ "$arch" =3D "i386" ] || [ "$arch" =3D "x86_64" ]=
; then
>  foo:
>      movl (8 / 2), %eax
>  EOF
> -  wa_divide=3D$("$cross_prefix$cc" -c lib-test.S >/dev/null 2>&1 || echo=
 yes)
> +  wa_divide=3D$("$cc" $cflags -c lib-test.S >/dev/null 2>&1 || echo yes)
>    rm -f lib-test.{o,S}
>  fi
> =20
> @@ -442,7 +447,7 @@ ARCH=3D$arch
>  ARCH_NAME=3D$arch_name
>  ARCH_LIBDIR=3D$arch_libdir
>  PROCESSOR=3D$processor
> -CC=3D$cross_prefix$cc
> +CC=3D$cc
>  CFLAGS=3D$cflags
>  LD=3D$cross_prefix$ld
>  OBJCOPY=3D$cross_prefix$objcopy


