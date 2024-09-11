Return-Path: <kvm+bounces-26444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3EF974799
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66DFB2874BA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F32217BD9;
	Wed, 11 Sep 2024 00:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpKWZgsE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C13AD5A
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 00:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726016144; cv=none; b=E3haNI+XIC70RA2Zd76hCXNtHCmnhTIQMT6h2KRrmppyvPiCeDjRJ2F7ge7wXVccYy3kQEnwY0X0znLOBBUySTK1e+6TBbOY85ZJumrVgJqZn1yIO3HQGzZRnqKrOMFaWE4TAo9fSRlFkB+AZvtXt1BHhRUwpJ9ee5d95YsIXCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726016144; c=relaxed/simple;
	bh=xkHnAUkzLmC5486vaTFdbksVFRf4EDutLsyQdr80otc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=grvw1h3io6qSabMSyC6XTscYezJ03VCKfsvzL5kcJEU1Mx6uT2vC2K7XNc+qQ5b3KtWCESAxEf41SnxgC3XdVKXvv4G034gpglhiU2i9xKiHpurdfJalTrcevx0J4XQRdJMj5fuZ2Wwg4ec5J1MG5BE0P4EhCaT5ITA2/sTpUjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kpKWZgsE; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-206aee40676so51185115ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726016141; x=1726620941; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itC2WqutZECbXY6ZLrN2/kGwGHxwBlnGdFqeRrwJWbo=;
        b=kpKWZgsEz8u+n2iFiovPwsGAG5kyRUe9AM7kpBwR/UZROpkutkd9hsMQakiyDaV0hN
         tSTlm4iAiZ7lecZomfJ7H6mbr8P/Jsq0SyDk1Z+It+TSAU51Rn3+N8AsbgvA4jtrOyE4
         rK8oyBSbcH0zEbU48IR6Fo4I1Mh9U7Za6p7TnmLChEYka89PvMqZd5iSP0XfCf1pB7tC
         S2ssJKibmLJX+G0XEgCpXBOq633PMDvX7/644DupNC0h91du2OW5UVqIG0ejU50W/+v9
         s7QMAc1qvvf9gf/1Ch0POTQKNCPSfhvJGLO1egyuFhd+BDgt9l9JIcvD39DCbKC9UdP6
         GLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726016141; x=1726620941;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=itC2WqutZECbXY6ZLrN2/kGwGHxwBlnGdFqeRrwJWbo=;
        b=M8I08Jg6w6YjDXphNJfwCHawXNr9eknBemZ/W1p8qqt0gnpdroafJAZ4dZbQI3K5eu
         R2cCpyMzqRyoCPjJOpZke/61sbksM0wgLuwhQa1j6X/sRgjDI6eswsLaUoHYTIeQ6gMM
         C+DfZdYIVxCCBaXqB3057Hf6qXnevGzXwCVNswhI1FKRj6SfWmCwYkz8Qh4QiXgzmhqe
         r8NtkzbnxyZVeSTH9+4EMGoHC+uVP/IYuALwK8+TKJFBeU2ZlM7epr7RkeQxy6HKUUca
         stlB8lK3fVN/6XHifI835d6tROmz2FZRbPKtN9uLhldYcHlj80WRz37+XRKuDQlm2YxA
         aXXg==
X-Forwarded-Encrypted: i=1; AJvYcCUTX/oP0PMzl/v1WlZLzuTzIIkyoniwOguNXL0gmx0ooCDtxwLZNPYSPbPgpxiHMD/rzEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwShT9DFDx6L4cAjJRP6VhbrZhRP37ZxT3lod9TY2J9zUo68YIo
	Ud0rcqkTyc37pR6ksgbFwLLbdMuF5I5MvtCXITC34SeQE+2jVeVY
X-Google-Smtp-Source: AGHT+IEm97cCFXdaI03zMLbj/Gxe4ThtsIkW15HwzaeJnZxbas50Ww+SgIR4e2MihlsHN/sSiMGa3w==
X-Received: by 2002:a17:902:e846:b0:206:c8dc:e334 with SMTP id d9443c01a7336-2074c69b72emr35544575ad.39.1726016141297;
        Tue, 10 Sep 2024 17:55:41 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710eeaf1csm53934775ad.176.2024.09.10.17.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:55:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:55:34 +1000
Message-Id: <D431NLP0XYPF.F69YFSU98T2G@gmail.com>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <atishp@rivosinc.com>,
 <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] lib/stack: Restrengthen base_address
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>
X-Mailer: aerc 0.18.2
References: <20240904145107.2447876-2-andrew.jones@linux.dev>
In-Reply-To: <20240904145107.2447876-2-andrew.jones@linux.dev>

On Thu Sep 5, 2024 at 12:51 AM AEST, Andrew Jones wrote:
> commit a1f2b0e1efd5 ("treewide: lib/stack: Make base_address arch
> specific") made base_address() a weak function in order to allow
> architectures to override it. Linking for EFI doesn't seem to figure
> out the right one to use though [anymore?]. It must have worked at
> one point because the commit calls outs EFI as the motivation.
> Anyway, just drop the weakness in favor of another HAVE_ define.

I prefer HAVE_ style than weak so fine by me.

How is the linker not resolving it properly? Some calls still
point to weak symbol despite non-weak symbol also existing?


>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/riscv/asm/stack.h |  1 +
>  lib/riscv/stack.c     |  2 +-
>  lib/stack.c           | 10 ++++++----
>  lib/stack.h           |  2 +-
>  4 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/lib/riscv/asm/stack.h b/lib/riscv/asm/stack.h
> index f003ca37c913..708fa4215007 100644
> --- a/lib/riscv/asm/stack.h
> +++ b/lib/riscv/asm/stack.h
> @@ -8,5 +8,6 @@
> =20
>  #define HAVE_ARCH_BACKTRACE_FRAME
>  #define HAVE_ARCH_BACKTRACE
> +#define HAVE_ARCH_BASE_ADDRESS
> =20
>  #endif
> diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
> index 2cd7f012738b..a143c22a570a 100644
> --- a/lib/riscv/stack.c
> +++ b/lib/riscv/stack.c
> @@ -5,7 +5,7 @@
>  #ifdef CONFIG_RELOC
>  extern char ImageBase, _text, _etext;
> =20
> -bool arch_base_address(const void *rebased_addr, unsigned long *addr)
> +bool base_address(const void *rebased_addr, unsigned long *addr)
>  {
>  	unsigned long ra =3D (unsigned long)rebased_addr;
>  	unsigned long base =3D (unsigned long)&ImageBase;
> diff --git a/lib/stack.c b/lib/stack.c
> index 086fec544a81..e1c981085176 100644
> --- a/lib/stack.c
> +++ b/lib/stack.c
> @@ -12,9 +12,10 @@
>  #define MAX_DEPTH 20
> =20
>  #ifdef CONFIG_RELOC
> +#ifndef HAVE_ARCH_BASE_ADDRESS
>  extern char _text, _etext;
> =20
> -bool __attribute__((weak)) arch_base_address(const void *rebased_addr, u=
nsigned long *addr)
> +bool base_address(const void *rebased_addr, unsigned long *addr)
>  {
>  	unsigned long ra =3D (unsigned long)rebased_addr;
>  	unsigned long start =3D (unsigned long)&_text;
> @@ -26,8 +27,9 @@ bool __attribute__((weak)) arch_base_address(const void=
 *rebased_addr, unsigned
>  	*addr =3D ra - start;
>  	return true;
>  }
> +#endif
>  #else
> -bool __attribute__((weak)) arch_base_address(const void *rebased_addr, u=
nsigned long *addr)
> +bool base_address(const void *rebased_addr, unsigned long *addr)
>  {
>  	*addr =3D (unsigned long)rebased_addr;
>  	return true;

Shouldn't HAVE_ARCH_BASE_ADDRESS also cover this?

Thanks,
Nick

