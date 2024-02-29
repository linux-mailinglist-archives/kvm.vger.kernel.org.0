Return-Path: <kvm+bounces-10347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F09186BF7D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53B1E1C2292B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF73374F7;
	Thu, 29 Feb 2024 03:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2AnhCxv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79591224DC;
	Thu, 29 Feb 2024 03:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709177522; cv=none; b=oNEf9vUQUk1B7zy5Fs2JgfEnUwq9u/XLXIKT6eoXyWIswwuvofoMAsp9GtXPky6axMUfE44C1KRje4F2Gzd1doEKswnnNOOX1p6+H8nlyTiSPij9I4GnD0COtV8GR1PeGFPZYDe6APHB9GZ23tr4JObM1d65wz0OfuOWxzQOhiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709177522; c=relaxed/simple;
	bh=EWwAT3MCMHWVFMTJaVaYpUhcP+iR62i7wY/pmUecdW4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=XBQ9Mo5yuX9KGD4CFiwch28M1FTpKz8UPT2YPa6blgfEhciNpIqUHUGOmQSA9zuWVRQ0r2FVfNoxVoST5RF6+FV6vFrSKEuP/dBGGhfT7BlN4uHKiE2BZ1Uxct23QToIWP5k0Njae+tBtSORKBYDg/RRDCPOaBVmkS+TbKqkdv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2AnhCxv; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-22007fe465bso262116fac.1;
        Wed, 28 Feb 2024 19:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709177519; x=1709782319; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CoFW6OKdyVFW2sqEZWn71FgR7RIK3QxGugFdW/eOQs=;
        b=N2AnhCxv05K6R/vtRuN6eBbN4cYHqVt55+TmtkdwsonL3/xQJYOPZzU6uyNskgAbV8
         Foj0e7AsKezl90dqjFXgenJI3+9qC4jwspkU1zUCvmcAP68uL7jYVCqNS4O6zyve5e6t
         44PHuSA40PRS2dl0dMWMo7VIFpNjZ2Tc052aUJ9mbUpwLxpoNd+TLp2Zk3s9JYtvdJnT
         6/bVx4ubwZ9owMmpm4a2Pz1IeQfzf/gidzk42bSeok7k3S0DyfZ6yw6ISABGpvb4hyNx
         SWy0J1QPZ5Sthuxe5Iv+wyVBnN+uAfDqG81DKZOGD+R8VlF1ey50kZWklIx058Zs7B9+
         5tdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709177519; x=1709782319;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4CoFW6OKdyVFW2sqEZWn71FgR7RIK3QxGugFdW/eOQs=;
        b=ZDHMOhYADYIVHSQlH1t6SuaeoWlcN5h7dAZAyuNwt6rqgIAqTDbZiCIy26QAFcIdoS
         jRuvAPLeKO845F809YgwdEjSQBo+8VIJhSJbCcACA8HAiTu5v/0EAjqudcm0svk+u2Ym
         j+Ichrjvda38plkABxTravexv9bp1E8VADURfX7csIt4qnsqDkqDDZlHrRge9CY89ISt
         wn0PkZQRPyFNZUQaJxBKw8D6m4X5G6IIhhriKNK0sA/2v35KN52AYVDFZa0mBYfB4ahT
         bk5kv8UZJIP23wTbBwNmTnIbDssfooPOukr7JKaqO04vUDgeW06F1pKBceRK7swkeSf3
         BbYA==
X-Forwarded-Encrypted: i=1; AJvYcCXCJIe2/i9CGZWiOaLfoYEJzifHuNM4P+kcxZyzbg+ty0nO1r9f6lDOapYGDU7XvTMBnnYhAQP/rB83F83H8DbOeSF7UB6tIiDaAWZ4Xpi/K66+bxhgAZzW+w9pBJF2xQ==
X-Gm-Message-State: AOJu0YxNPEwvbFGANw72gquhfkw9FdqQLC7iCdN2BWSmonAekZH1lvul
	jHOQ5TekWBTzmVSZj3hCUMEm60H2G33NYasMAqoHKq/bWd/DszWz
X-Google-Smtp-Source: AGHT+IFB9PEwchGQbbJVMouwlE0FuOhB6jELVU4WqBvhZ3nzeCZtjl/MpeNpD6vcpNdJ4Et8AtDDpw==
X-Received: by 2002:a05:6870:40d5:b0:21f:df18:349b with SMTP id l21-20020a05687040d500b0021fdf18349bmr837242oal.35.1709177519588;
        Wed, 28 Feb 2024 19:31:59 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b006e5092fb3efsm183625pfn.159.2024.02.28.19.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 19:31:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Feb 2024 13:31:52 +1000
Message-Id: <CZH8V1T0Z3QN.1ZVFAXR4B96BZ@wheely>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
 <lvivier@redhat.com>, <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>,
 <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 03/13] treewide: lib/stack: Fix backtrace
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>
X-Mailer: aerc 0.15.2
References: <20240228150416.248948-15-andrew.jones@linux.dev>
 <20240228150416.248948-18-andrew.jones@linux.dev>
In-Reply-To: <20240228150416.248948-18-andrew.jones@linux.dev>

On Thu Feb 29, 2024 at 1:04 AM AEST, Andrew Jones wrote:
> We should never pass the result of __builtin_frame_address(0) to
> another function since the compiler is within its rights to pop the
> frame to which it points before making the function call, as may be
> done for tail calls. Nobody has complained about backtrace(), so
> likely all compilations have been inlining backtrace_frame(), not
> dropping the frame on the tail call, or nobody is looking at traces.
> However, for riscv, when built for EFI, it does drop the frame on the
> tail call, and it was noticed. Preemptively fix backtrace() for all
> architectures.
>
> Fixes: 52266791750d ("lib: backtrace printing")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/arm/stack.c   | 13 +++++--------
>  lib/arm64/stack.c | 12 +++++-------
>  lib/riscv/stack.c | 12 +++++-------
>  lib/s390x/stack.c | 12 +++++-------
>  lib/stack.h       | 24 +++++++++++++++++-------
>  lib/x86/stack.c   | 12 +++++-------
>  6 files changed, 42 insertions(+), 43 deletions(-)
>
> diff --git a/lib/arm/stack.c b/lib/arm/stack.c
> index 7d081be7c6d0..66d18b47ea53 100644
> --- a/lib/arm/stack.c
> +++ b/lib/arm/stack.c
> @@ -8,13 +8,16 @@
>  #include <libcflat.h>
>  #include <stack.h>
> =20
> -int backtrace_frame(const void *frame, const void **return_addrs,
> -		    int max_depth)
> +int arch_backtrace_frame(const void *frame, const void **return_addrs,
> +			 int max_depth, bool current_frame)
>  {
>  	static int walking;
>  	int depth;
>  	const unsigned long *fp =3D (unsigned long *)frame;
> =20
> +	if (current_frame)
> +		fp =3D __builtin_frame_address(0);
> +
>  	if (walking) {
>  		printf("RECURSIVE STACK WALK!!!\n");
>  		return 0;
> @@ -33,9 +36,3 @@ int backtrace_frame(const void *frame, const void **ret=
urn_addrs,
>  	walking =3D 0;
>  	return depth;
>  }
> -
> -int backtrace(const void **return_addrs, int max_depth)
> -{
> -	return backtrace_frame(__builtin_frame_address(0),
> -			       return_addrs, max_depth);
> -}
> diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
> index 82611f4b1815..f5eb57fd8892 100644
> --- a/lib/arm64/stack.c
> +++ b/lib/arm64/stack.c
> @@ -8,7 +8,8 @@
> =20
>  extern char vector_stub_start, vector_stub_end;
> =20
> -int backtrace_frame(const void *frame, const void **return_addrs, int ma=
x_depth)
> +int arch_backtrace_frame(const void *frame, const void **return_addrs,
> +			 int max_depth, bool current_frame)
>  {
>  	const void *fp =3D frame;
>  	static bool walking;
> @@ -17,6 +18,9 @@ int backtrace_frame(const void *frame, const void **ret=
urn_addrs, int max_depth)
>  	bool is_exception =3D false;
>  	unsigned long addr;
> =20
> +	if (current_frame)
> +		fp =3D __builtin_frame_address(0);
> +
>  	if (walking) {
>  		printf("RECURSIVE STACK WALK!!!\n");
>  		return 0;
> @@ -54,9 +58,3 @@ int backtrace_frame(const void *frame, const void **ret=
urn_addrs, int max_depth)
>  	walking =3D false;
>  	return depth;
>  }
> -
> -int backtrace(const void **return_addrs, int max_depth)
> -{
> -	return backtrace_frame(__builtin_frame_address(0),
> -			       return_addrs, max_depth);
> -}
> diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
> index 712a5478d547..d865594b9671 100644
> --- a/lib/riscv/stack.c
> +++ b/lib/riscv/stack.c
> @@ -2,12 +2,16 @@
>  #include <libcflat.h>
>  #include <stack.h>
> =20
> -int backtrace_frame(const void *frame, const void **return_addrs, int ma=
x_depth)
> +int arch_backtrace_frame(const void *frame, const void **return_addrs,
> +			 int max_depth, bool current_frame)
>  {
>  	static bool walking;
>  	const unsigned long *fp =3D (unsigned long *)frame;
>  	int depth;
> =20
> +	if (current_frame)
> +		fp =3D __builtin_frame_address(0);
> +
>  	if (walking) {
>  		printf("RECURSIVE STACK WALK!!!\n");
>  		return 0;
> @@ -24,9 +28,3 @@ int backtrace_frame(const void *frame, const void **ret=
urn_addrs, int max_depth)
>  	walking =3D false;
>  	return depth;
>  }
> -
> -int backtrace(const void **return_addrs, int max_depth)
> -{
> -	return backtrace_frame(__builtin_frame_address(0),
> -			       return_addrs, max_depth);
> -}
> diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
> index 9f234a12adf6..d194f654e94d 100644
> --- a/lib/s390x/stack.c
> +++ b/lib/s390x/stack.c
> @@ -14,11 +14,15 @@
>  #include <stack.h>
>  #include <asm/arch_def.h>
> =20
> -int backtrace_frame(const void *frame, const void **return_addrs, int ma=
x_depth)
> +int arch_backtrace_frame(const void *frame, const void **return_addrs,
> +			 int max_depth, bool current_frame)
>  {
>  	int depth =3D 0;
>  	struct stack_frame *stack =3D (struct stack_frame *)frame;
> =20
> +	if (current_frame)
> +		stack =3D __builtin_frame_address(0);
> +
>  	for (depth =3D 0; stack && depth < max_depth; depth++) {
>  		return_addrs[depth] =3D (void *)stack->grs[8];
>  		stack =3D stack->back_chain;
> @@ -28,9 +32,3 @@ int backtrace_frame(const void *frame, const void **ret=
urn_addrs, int max_depth)
> =20
>  	return depth;
>  }
> -
> -int backtrace(const void **return_addrs, int max_depth)
> -{
> -	return backtrace_frame(__builtin_frame_address(0),
> -			       return_addrs, max_depth);
> -}
> diff --git a/lib/stack.h b/lib/stack.h
> index 10fc2f793354..6edc84344b51 100644
> --- a/lib/stack.h
> +++ b/lib/stack.h
> @@ -11,17 +11,27 @@
>  #include <asm/stack.h>
> =20
>  #ifdef HAVE_ARCH_BACKTRACE_FRAME
> -extern int backtrace_frame(const void *frame, const void **return_addrs,
> -			   int max_depth);
> +extern int arch_backtrace_frame(const void *frame, const void **return_a=
ddrs,
> +				int max_depth, bool current_frame);
> +
> +static inline int backtrace_frame(const void *frame, const void **return=
_addrs,
> +				  int max_depth)
> +{
> +	return arch_backtrace_frame(frame, return_addrs, max_depth, false);
> +}
> +
> +static inline int backtrace(const void **return_addrs, int max_depth)
> +{
> +	return arch_backtrace_frame(NULL, return_addrs, max_depth, true);
> +}
>  #else
> -static inline int
> -backtrace_frame(const void *frame __unused, const void **return_addrs __=
unused,
> -		int max_depth __unused)
> +extern int backtrace(const void **return_addrs, int max_depth);
> +
> +static inline int backtrace_frame(const void *frame, const void **return=
_addrs,
> +				  int max_depth)
>  {
>  	return 0;
>  }
>  #endif
> =20
> -extern int backtrace(const void **return_addrs, int max_depth);
> -
>  #endif

Is there a reason to add the inline wrappers rather than just externs
and drop the arch_ prefix?

Do we want to just generally have all arch specific functions have an
arch_ prefix? Fine by me.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

I'm fine to rebase the powerpc patch on top of this if it goes in first.
Thanks for the heads up.

Thanks,
Nick

