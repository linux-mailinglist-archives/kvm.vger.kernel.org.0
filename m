Return-Path: <kvm+bounces-11638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F95878E3E
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 06:45:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26F2B1C2218B
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 05:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BEC91E884;
	Tue, 12 Mar 2024 05:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtlHgFOR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F7525742;
	Tue, 12 Mar 2024 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710222314; cv=none; b=JTS5ePo7KvGDhBF/TIQ39bzW22d/jvcVowGqRlDSV4bSGRhTMrjhskLP3zJnBNnJ7zbDNyLw1m+Gbg4knyfTF97i5l1ed8cpN8vyb5ek32bnvJUszJ1r6USIOCNVWgXvQGO/RCCcZ1MFRzXOdHsTVK3x9UNUqx3e2iuyPBMl5QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710222314; c=relaxed/simple;
	bh=GOxn/4eVruIEi7HrVevp33vbMyZtD/J7uxQzZT6p2d8=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=bnYkVmkYiS1YoXl3nr94dszXOhZLplz8S36Sc5HJf2Aud56qVEylgFthjRufn5FtwdFYsbaOizthNwzVczmUXdhdtOA0ofZcIENXShOfJj2IuAF06B5LViqc+JVv3ZT1AO9Fx9Q4i16/xNmomrzQTKVDmis+2yeUaYJZQ9XHWFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtlHgFOR; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dd10a37d68so43954065ad.2;
        Mon, 11 Mar 2024 22:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710222312; x=1710827112; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fW/EcKaMbEkneZDxVrHKCHliy210kWmaiqbzUm1tuZw=;
        b=GtlHgFORgJPq+8ZN+/O9EHOM0UyzJ9HR/gXrTFIdvUAKV96D0GArTsDIghidh5bnir
         kpDBapOVxUod0FH5hUW9Xg5ff1Iyl1imDRPWg1RkecFqNUYvs1s9zklJ8Op5xqbhA1HL
         kUnVzCRWPyeLrc0WJidHUnWzPxBxfsfnovqDEYpKggjuBg4hWSkgQvWf1mE+JTD6axY4
         ivzmeBhtvx1J7bOuSK1qy4vfc+fqYpEl45cBhvbQ1DuA7YdlfOQeYgW5IYCYLRnpA9kA
         BPetFvo/5JhLnANtiQ3GwKTMrNeyiUYhWb5sKaexiOgxuVYGz4+GH9ow8L6UruYF0K1b
         LGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710222312; x=1710827112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fW/EcKaMbEkneZDxVrHKCHliy210kWmaiqbzUm1tuZw=;
        b=e8rHOpWPcOZMIdmKUTYN68H47ZuBlEQdBTOaFDZ9n/Zdzb7ThamB6ka5fvFx2X9fYt
         XF8DYF9Ix0U//wCHiobga7hqh9fUeVkfqKueztNKSrnN0Q5uVMIaTPb11ZAAZw9mKrUU
         L2Ra7wn5L7kCK8nWKkwMIW3IwkT23+HDpU8DAtnUglU+D8u5wTLyQu+nm31D0mGGhCrt
         vGOe+AxS09LbXU74fNmIL9e4kIzZb749qvTIHq+xV22Qrw5MrpcHRjXRa8HGQu8eFj2Q
         BG/p/GbgJqyA1ksvs9VbvQaEUSQdpBP38q0p4esGXYdzJOdelJuq9OA/NT5jjDUX+KQX
         SPeg==
X-Forwarded-Encrypted: i=1; AJvYcCV39I1gf5oVKD0iV6DZk6eFC4FKS+Y11Hkk5DjSlrgNWZAteFVP1I5lfrmsOaEz7mC67ebIZ9rW9oeDwhx9O34qjXvwq+uJpyJ763T/XdgXs4Rv0mChs4GCI1IyksBdDA==
X-Gm-Message-State: AOJu0YyH8zeYcqlNjYOPp1RIVCMHHZka3b9ZPLlBsL4/e4t7pFpuZGNS
	KIxTxBEO63arbG+xwOrU5IfVQT8jgyGqZuKiXiG1KFkRxC3g9c904cUG/G3Sfcw=
X-Google-Smtp-Source: AGHT+IFv14RRSVORaVxPGv7Pgc/FfkulvwmrU9WcDb6eZGl4gISl+ryDpVeng37EST8Ipt5IeQErUQ==
X-Received: by 2002:a17:902:e54f:b0:1db:5b41:c5ac with SMTP id n15-20020a170902e54f00b001db5b41c5acmr7737568plf.68.1710222312180;
        Mon, 11 Mar 2024 22:45:12 -0700 (PDT)
Received: from localhost ([1.146.55.44])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090322c700b001da1fae8a73sm3335793plg.12.2024.03.11.22.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 22:45:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Mar 2024 15:45:05 +1000
Message-Id: <CZRJ7KVBS2ZT.3144ZIHYUZRNY@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
 <lvivier@redhat.com>, <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>,
 <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 04/13] treewide: lib/stack: Make
 base_address arch specific
X-Mailer: aerc 0.15.2
References: <20240305170858.395836-15-andrew.jones@linux.dev>
 <20240305170858.395836-19-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-19-andrew.jones@linux.dev>

On Wed Mar 6, 2024 at 3:09 AM AEST, Andrew Jones wrote:
> Calculating the offset of an address is image specific, which is
> architecture specific. Until now, all architectures and architecture
> configurations which select CONFIG_RELOC were able to subtract
> _etext, but the EFI configuration of riscv cannot (it must subtract
> ImageBase). Make this function weak, such that an architecture may
> override it when necessary, to accommodate the image layout. Then,
> immediately supply the riscv override.
>

Thanks for making these changes. Looks good. For the generic parts,

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/riscv/stack.c | 18 ++++++++++++++++++
>  lib/stack.c       |  8 ++++----
>  lib/stack.h       |  2 ++
>  3 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
> index d865594b9671..2cd7f012738b 100644
> --- a/lib/riscv/stack.c
> +++ b/lib/riscv/stack.c
> @@ -2,6 +2,24 @@
>  #include <libcflat.h>
>  #include <stack.h>
> =20
> +#ifdef CONFIG_RELOC
> +extern char ImageBase, _text, _etext;
> +
> +bool arch_base_address(const void *rebased_addr, unsigned long *addr)
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
> index dd6bfa8dac6e..086fec544a81 100644
> --- a/lib/stack.c
> +++ b/lib/stack.c
> @@ -14,7 +14,7 @@
>  #ifdef CONFIG_RELOC
>  extern char _text, _etext;
> =20
> -static bool base_address(const void *rebased_addr, unsigned long *addr)
> +bool __attribute__((weak)) arch_base_address(const void *rebased_addr, u=
nsigned long *addr)
>  {
>  	unsigned long ra =3D (unsigned long)rebased_addr;
>  	unsigned long start =3D (unsigned long)&_text;
> @@ -27,7 +27,7 @@ static bool base_address(const void *rebased_addr, unsi=
gned long *addr)
>  	return true;
>  }
>  #else
> -static bool base_address(const void *rebased_addr, unsigned long *addr)
> +bool __attribute__((weak)) arch_base_address(const void *rebased_addr, u=
nsigned long *addr)
>  {
>  	*addr =3D (unsigned long)rebased_addr;
>  	return true;
> @@ -45,13 +45,13 @@ static void print_stack(const void **return_addrs, in=
t depth,
>  	/* @addr indicates a non-return address, as expected by the stack
>  	 * pretty printer script. */
>  	if (depth > 0 && !top_is_return_address) {
> -		if (base_address(return_addrs[0], &addr))
> +		if (arch_base_address(return_addrs[0], &addr))
>  			printf(" @%lx", addr);
>  		i++;
>  	}
> =20
>  	for (; i < depth; i++) {
> -		if (base_address(return_addrs[i], &addr))
> +		if (arch_base_address(return_addrs[i], &addr))
>  			printf(" %lx", addr);
>  	}
>  	printf("\n");
> diff --git a/lib/stack.h b/lib/stack.h
> index 6edc84344b51..df076d94bf8f 100644
> --- a/lib/stack.h
> +++ b/lib/stack.h
> @@ -34,4 +34,6 @@ static inline int backtrace_frame(const void *frame, co=
nst void **return_addrs,
>  }
>  #endif
> =20
> +bool __attribute__((weak)) arch_base_address(const void *rebased_addr, u=
nsigned long *addr);
> +
>  #endif


