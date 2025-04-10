Return-Path: <kvm+bounces-43108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2FE8A84F44
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 23:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3022E18912A4
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 21:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E85202F87;
	Thu, 10 Apr 2025 21:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZXM0QZ82"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC5B1CA84
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 21:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744321603; cv=none; b=YJD8IuhuYor0IIH3xZvSKPN/uLXYr5YiLwHpYoCxVZilVa8Jaz8YuhfKpdDoxPe6rhA2uMGu52JJTbOEixJp7nTPEQX6fKh8pFmxsQfn7wOgdHwReany+90hgPSwgVkwSqT7AmoOxKMCtnfMV8scPMdg/3GYPwiZ8dsTk9e6ag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744321603; c=relaxed/simple;
	bh=zOgV6cFWWME+6OMyPM6xZIj8Q5wf1bgIP4T5JxozyVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b0+ux7FpQ88pj7NsE48n/17VqNuzLsLLQJrCelBSc1YW4+iRz0zP9t2Voxyv/893P7HDrGhzuqWA5Y8C6z6swcsQ7oqwxRkQPgV1gRp6Xf8Ehgl2j6KJ5tTzedgccHk/bzlihl8lZ4FFksElRkaBpYK7f4WZ9JRJ1GbpJc+o60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZXM0QZ82; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af2f03fcc95so1429481a12.1
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 14:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744321601; x=1744926401; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bePW1gPXhpZiNQfmRfdXBMgDPxsflce7ce13WuBvjOk=;
        b=ZXM0QZ82CbYlOMBpZYdTmwawg4jfRc0bsm3rmw1cbV5qmxz1rtVqAU8JJiaxroZXoH
         cbtkTiiiaHh8Uk8IPNY5Ad+wn3V7DX8Pj0Z2Sb+/Vm97xBuxDX/m9JSh2eUhw+SfOtgF
         2LeUmTJKGc9Xn3y1itUrAG0nWi/0Jz+5TP+4CvQfbgG8OmK1HRPEdaVPLRKZYAEm2+HE
         gJ9Wb15Wpu9Moe21ufsgYB7u4L13L4Mpv9EpwGJ7OAWuTtiEwg+r+FfcjgMq3GwFxX4I
         b2OzPkJk1NUoIfE8gfJKbJ5+fpt/3YJw6V+10KOim8JV5Hmn9w8diCCgpN5YF7htN58u
         3nvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744321601; x=1744926401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bePW1gPXhpZiNQfmRfdXBMgDPxsflce7ce13WuBvjOk=;
        b=l4T0NPhBSLDVmCRvSoSCRbTTf3tY3B7hbwayv5lpFEtmXIGOtqIYt9GikMssJF+1bs
         VV6a7/f4+aWgth8F6sThgnG1SRyc1bbkG2RAWwCAVvw6GsuS1WdsqH5WfUpnOSjKghz/
         c4TvKK8+9dUe4LmNgPSCEp944c4SYUciWKIwe5QhEZIK3tGK4Gu2G/LC+ew0vfNQuv8J
         FiGXwufRs8k3yx07snCa4adUVnszKqk2dFYpwYFhj+IyKcv33fGU468jMkDoGCj3xfgp
         EBDY5IGlxYYfJ6AwtZJJ5/oxwpgzSVaqxY5s3Zl4NbxrQ56jAXkYQRijrLg8apQZtvZA
         1OPw==
X-Forwarded-Encrypted: i=1; AJvYcCVWsbJ83zGLpzEj6pVQ5FmlNAZYa1z8eQxC764+mertOieFRdvk4q8GxWIIXX9MaU0z4L0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxnC8KUKNB7Bl2yC6VbDUUfljuGWdljsVO6odjdoc6hm4QZaOY
	MCC0LRh23dEg7MmUXlhC2+GHpzW39tMGkT2htjGXnl4ZDXH9BCrkHHgAXU8mgdz3jAdN7gZ7oQF
	MQQ==
X-Google-Smtp-Source: AGHT+IGWt+83fSC3c/N6JQbwOG/2CXc24wmCtoeKQKr6bofBcQejdMxPHdo+4k7C01b/9gYVsUy3Mw36Jn0=
X-Received: from pfbhu1.prod.google.com ([2002:a05:6a00:6981:b0:737:30c9:fe46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cf82:b0:1f5:9431:46e7
 with SMTP id adf61e73a8af0-201799984fcmr644100637.42.1744321601003; Thu, 10
 Apr 2025 14:46:41 -0700 (PDT)
Date: Thu, 10 Apr 2025 14:46:39 -0700
In-Reply-To: <20250324160617.15379-1-bp@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324160617.15379-1-bp@kernel.org>
Message-ID: <Z_g8Py8Ow85Uj6RT@google.com>
Subject: Re: [PATCH] KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> WRMSR_XX_BASE_NS is bit 1 so put it there, add some new bits as
> comments only.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> ---
>  arch/x86/kvm/cpuid.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 121edf1f2a79..e98ab18f784b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1160,6 +1160,7 @@ void kvm_set_cpu_caps(void)
>  
>  	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
>  		F(NO_NESTED_DATA_BP),
> +		F(WRMSR_XX_BASE_NS),
>  		/*
>  		 * Synthesize "LFENCE is serializing" into the AMD-defined entry
>  		 * in KVM's supported CPUID, i.e. if the feature is reported as
> @@ -1173,10 +1174,14 @@ void kvm_set_cpu_caps(void)
>  		SYNTHESIZED_F(LFENCE_RDTSC),
>  		/* SmmPgCfgLock */
>  		F(NULL_SEL_CLR_BASE),
> +		/* UpperAddressIgnore */
>  		F(AUTOIBRS),
>  		EMULATED_F(NO_SMM_CTL_MSR),
> +		/* FSRS */
> +		/* FSRC */

I'm going to skip these, as they aren't yet publicly documented, and there are
patches proposed to add actual support.  I wouldn't care all that much if these
didn't collide with Intel's version (the proposed patches name them AMD_FSxx).

https://lore.kernel.org/all/20241204134345.189041-2-davydov-max@yandex-team.ru

>  		/* PrefetchCtlMsr */
> -		F(WRMSR_XX_BASE_NS),
> +		/* GpOnUserCpuid */
> +		/* EPSF */

FWIW, this one's also not in the APM (though the only APM I can find is a year old),
though it's in tools/x86/kcpuid.

>  		SYNTHESIZED_F(SBPB),
>  		SYNTHESIZED_F(IBPB_BRTYPE),
>  		SYNTHESIZED_F(SRSO_NO),
> -- 
> 2.43.0
> 

