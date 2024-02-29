Return-Path: <kvm+bounces-10348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A38D286BF95
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6DF31C2166B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7375C3770B;
	Thu, 29 Feb 2024 03:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gc6H23D2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1E725765;
	Thu, 29 Feb 2024 03:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709178607; cv=none; b=DEWtAFwHPT/GIH6Ase6ihIalzJ9PzYQxoqaOZLsUCr1/WB+b1CRUShh4hbbw4LseJHAVozI3S4klrxBdeP+ESpnm8XsVuDez0czASOKU670m7zuJBmt8CUzBDSSlEGTAcFuv3nDrHL2MVErMxrW1G1hwj1aF1x1CsqDsMLqp/cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709178607; c=relaxed/simple;
	bh=Er8EkfZFtuky5LDCB1/DSrXrfh17COeijDSglM1hi1A=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=unpaO9WNpXtC/fzGWsnJjGUBim/KWiKtUqwXDrLGM1AazGIdCvdXOvdy1r18ALu6Dz/Gtt072MwunCvIz1Uj3zxpBT5fx/L751E3twXWnDWjrEssiEG1igmm/YA7qtCmwx9Rns43OlMAuIWPic1G6qviYqrkFVchNuFbaONwK64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gc6H23D2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dcb3e6ff3fso4273795ad.2;
        Wed, 28 Feb 2024 19:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709178605; x=1709783405; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkGL4ihV2OtiC1xVy3oIJJV1camQdA/fDE7d+XmMCGE=;
        b=gc6H23D2RQCOpBW/rlHz+36M+Vyv0/B3u4r2DoNbDFCjTeQr2Xgyn/n//666iT9/t7
         AHR7E0aFGAIdo7yWE7T6u+m1U7snABz2gJDmlp7SECCTlKPj3Z4x7z9hGEMTL6ZOePFZ
         Rq5hjeDqzid85GN4Crnv949e68Nu78O88OSUpsvtEQivheJgORG40lbo5NOvUjeKJBvJ
         YxDczKKhAmfE7mR3oFYzn8pa3NGQM8OS/lfk7rIrRBF3xV23Im4OJfIO/r3gGtHvkAvw
         qGl5uWNJiX5JiU1VufQ4+Q7digDIErilko8CRR9jbpTG4fXBb8e/RJb20WJPbJCnWbZi
         uvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709178605; x=1709783405;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wkGL4ihV2OtiC1xVy3oIJJV1camQdA/fDE7d+XmMCGE=;
        b=VGjyUNZxWEUqYFahYOv4cowhLjw2Gp8cHM2R52e9TvkF7taJp1/kb21G+ghtBumtBy
         ODz7uuMlgeavA8QduefnIWyJtJTfy6/v52A0pGhvIs7Jom49UHr9OUzwIh0OkagZfK+N
         p4FrMuiQ0tlHGVO0P3hKIMYpKONUABADGLIbMjffKr93lqyiEa4IY/7mTe8C8ADVvH4j
         2T2wsNwvqz+XJr+yLOxGJUEjSQRNPn7BdtkEkmRUJjDsVwRmyTlHh7/WoY1eAKa9i6rD
         a4E/uQLe9maoeAjzIZ2PvUtbq73K7I2MX8poZrcmTjpQYyLR4Lij+E7EIzf0zoVFk0cg
         Z2Bw==
X-Forwarded-Encrypted: i=1; AJvYcCVdKhT9r35Gvz0WeG5xGzT1UAZnvapmkDBAQEndFuiekZXvgeos1/V94jSlra+k/sije7N+LD/1iJIoF4OG9vCbyoOnpxxHmCTVapEgv1xr58RA5sZDfj2HINZx0Cc4gw==
X-Gm-Message-State: AOJu0Yx/Od24ZuX3Ks3rv4nRLmQJbrLNjNZ5f4lOhSGT5KaOalxCv1cK
	XbeXSZjFnCi/p25VlL+E3HoNSu5KLZ+dqp+oHPFIJsyiNDhQ10Xl
X-Google-Smtp-Source: AGHT+IEFuQfnfOdxrtG5oSxHaCUMHqvsrtVGazOAp72epa+sxEp407xvB6/65mkpoFr1O5KeWHfjhg==
X-Received: by 2002:a17:902:ed41:b0:1dc:297d:b621 with SMTP id y1-20020a170902ed4100b001dc297db621mr961057plb.16.1709178605410;
        Wed, 28 Feb 2024 19:50:05 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902da9200b001d9773a1993sm229042plx.213.2024.02.28.19.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 19:50:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Feb 2024 13:49:58 +1000
Message-Id: <CZH98WKJY6NT.5D53XGR31X22@wheely>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
 <lvivier@redhat.com>, <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>,
 <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 04/13] treewide: lib/stack: Make
 base_address arch specific
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>
X-Mailer: aerc 0.15.2
References: <20240228150416.248948-15-andrew.jones@linux.dev>
 <20240228150416.248948-19-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-19-andrew.jones@linux.dev>

On Thu Feb 29, 2024 at 1:04 AM AEST, Andrew Jones wrote:
> Calculating the offset of an address is image specific, which is
> architecture specific. Until now, all architectures and architecture
> configurations which select CONFIG_RELOC were able to subtract
> _etext, but the EFI configuration of riscv cannot (it must subtract
> ImageBase). Make this function architecture specific, since the
> architecture's image layout already is.

arch_base_address()?

How about a default implementation unlesss HAVE_ARCH_BASE_ADDRESS?

Thanks,
Nick

>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/arm64/stack.c | 17 +++++++++++++++++
>  lib/riscv/stack.c | 18 ++++++++++++++++++
>  lib/stack.c       | 19 ++-----------------
>  lib/stack.h       |  2 ++
>  lib/x86/stack.c   | 17 +++++++++++++++++
>  5 files changed, 56 insertions(+), 17 deletions(-)
>
> diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
> index f5eb57fd8892..3369031a74f7 100644
> --- a/lib/arm64/stack.c
> +++ b/lib/arm64/stack.c
> @@ -6,6 +6,23 @@
>  #include <stdbool.h>
>  #include <stack.h>
> =20
> +#ifdef CONFIG_RELOC
> +extern char _text, _etext;
> +
> +bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	unsigned long ra =3D (unsigned long)rebased_addr;
> +	unsigned long start =3D (unsigned long)&_text;
> +	unsigned long end =3D (unsigned long)&_etext;
> +
> +	if (ra < start || ra >=3D end)
> +		return false;
> +
> +	*addr =3D ra - start;
> +	return true;
> +}
> +#endif
> +
>  extern char vector_stub_start, vector_stub_end;
> =20
>  int arch_backtrace_frame(const void *frame, const void **return_addrs,
> diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
> index d865594b9671..a143c22a570a 100644
> --- a/lib/riscv/stack.c
> +++ b/lib/riscv/stack.c
> @@ -2,6 +2,24 @@
>  #include <libcflat.h>
>  #include <stack.h>
> =20
> +#ifdef CONFIG_RELOC
> +extern char ImageBase, _text, _etext;
> +
> +bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	unsigned long ra =3D (unsigned long)rebased_addr;
> +	unsigned long base =3D (unsigned long)&ImageBase;
> +	unsigned long start =3D (unsigned long)&_text;
> +	unsigned long end =3D (unsigned long)&_etext;
> +
> +	if (ra < start || ra >=3D end)
> +		return false;
> +
> +	*addr =3D ra - base;
> +	return true;
> +}
> +#endif
> +
>  int arch_backtrace_frame(const void *frame, const void **return_addrs,
>  			 int max_depth, bool current_frame)
>  {
> diff --git a/lib/stack.c b/lib/stack.c
> index dd6bfa8dac6e..e5099e207388 100644
> --- a/lib/stack.c
> +++ b/lib/stack.c
> @@ -11,23 +11,8 @@
> =20
>  #define MAX_DEPTH 20
> =20
> -#ifdef CONFIG_RELOC
> -extern char _text, _etext;
> -
> -static bool base_address(const void *rebased_addr, unsigned long *addr)
> -{
> -	unsigned long ra =3D (unsigned long)rebased_addr;
> -	unsigned long start =3D (unsigned long)&_text;
> -	unsigned long end =3D (unsigned long)&_etext;
> -
> -	if (ra < start || ra >=3D end)
> -		return false;
> -
> -	*addr =3D ra - start;
> -	return true;
> -}
> -#else
> -static bool base_address(const void *rebased_addr, unsigned long *addr)
> +#ifndef CONFIG_RELOC
> +bool base_address(const void *rebased_addr, unsigned long *addr)
>  {
>  	*addr =3D (unsigned long)rebased_addr;
>  	return true;
> diff --git a/lib/stack.h b/lib/stack.h
> index 6edc84344b51..f8def4ad4d49 100644
> --- a/lib/stack.h
> +++ b/lib/stack.h
> @@ -10,6 +10,8 @@
>  #include <libcflat.h>
>  #include <asm/stack.h>
> =20
> +bool base_address(const void *rebased_addr, unsigned long *addr);
> +
>  #ifdef HAVE_ARCH_BACKTRACE_FRAME
>  extern int arch_backtrace_frame(const void *frame, const void **return_a=
ddrs,
>  				int max_depth, bool current_frame);
> diff --git a/lib/x86/stack.c b/lib/x86/stack.c
> index 58ab6c4b293a..7ba73becbd69 100644
> --- a/lib/x86/stack.c
> +++ b/lib/x86/stack.c
> @@ -1,6 +1,23 @@
>  #include <libcflat.h>
>  #include <stack.h>
> =20
> +#ifdef CONFIG_RELOC
> +extern char _text, _etext;
> +
> +bool base_address(const void *rebased_addr, unsigned long *addr)
> +{
> +	unsigned long ra =3D (unsigned long)rebased_addr;
> +	unsigned long start =3D (unsigned long)&_text;
> +	unsigned long end =3D (unsigned long)&_etext;
> +
> +	if (ra < start || ra >=3D end)
> +		return false;
> +
> +	*addr =3D ra - start;
> +	return true;
> +}
> +#endif
> +
>  int arch_backtrace_frame(const void *frame, const void **return_addrs,
>  			 int max_depth, bool current_frame)
>  {


