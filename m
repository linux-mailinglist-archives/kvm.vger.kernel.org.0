Return-Path: <kvm+bounces-56999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0745EB49866
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:35:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B730C177C36
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 18:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669D03164B7;
	Mon,  8 Sep 2025 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HAsBAkyY"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC15E3126DB
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757356523; cv=none; b=i7qKjrTSjtIrN9ForI/ar9yugImk1AbZrSO/L1JPwI9+1bxB6qNpHuHt2X2bUjgpdJnzeEITJPupJR7rPuYSv22v3h0uUPSGw4V66HcQ+dw9MGdb58Ep2s6Oj/zSCS5AWwMV+v+pUFBnIvOKDRISqe4lN0tUTXYCDr4V4oc++ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757356523; c=relaxed/simple;
	bh=dlrMzmtgDooJRaygJTiyRgwY1eyCXZ5UCOaIPf+bSUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltHp9EA5Th1vYJwGQQ2Eprj12uZk7bfjnoCzjoD3TWcqM72Z8aSjK0zruNMLNqps1JFJgGQeKPTJkUEqTltcPKaPpp5x2EAUQpfBg+sfedNY2UgS5IV7/96fHN79ikvrb81sDix9MDV5EbhsSjrX5135o8alaLVV0gLYE5g5IuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HAsBAkyY; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Sep 2025 13:35:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757356518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lkuo2vtcPBI8KCVrZXN4XmC1CQHITD4TVLCqLgVMYS8=;
	b=HAsBAkyY1Ce6wujWfrXvwJdZksEDrjRsLyMTYoHBPQGhk5mqubkjRjx2YKJbOEP9+sn9FT
	oIIguioEYkspE1ixj3vUl1G8esS7KH37L5bPar2ie0EIwjK3J7fCDvus3sPZoadAOzVSw5
	YIeaT+C6Gbz00sH3Zs/q8saoUQc6APc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] Better backtraces for leaf functions
Message-ID: <20250908-c34647c9836098b0484b7430@orel>
References: <20250724181759.1974692-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724181759.1974692-1-minipli@grsecurity.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 24, 2025 at 08:17:59PM +0200, Mathias Krause wrote:
> Leaf functions are problematic for backtraces as they lack the frame
> pointer setup epilogue. If such a function causes a fault, the original
> caller won't be part of the backtrace. That's problematic if, for
> example, memcpy() is failing because it got passed a bad pointer. The
> generated backtrace will look like this, providing no clue what the
> issue may be:
> 
> 	STACK: @401b31 4001ad
>   0x0000000000401b31: memcpy at lib/string.c:136 (discriminator 3)
>         	for (i = 0; i < n; ++i)
>       > 		a[i] = b[i];
> 
>   0x00000000004001ac: gdt32_end at x86/cstart64.S:127
>         	lea __environ(%rip), %rdx
>       > 	call main
>         	mov %eax, %edi
> 
> By abusing profiling, we can force the compiler to emit a frame pointer
> setup epilogue even for leaf functions, making the above backtrace
> change like this:
> 
> 	STACK: @401c21 400512 4001ad
>   0x0000000000401c21: memcpy at lib/string.c:136 (discriminator 3)
>         	for (i = 0; i < n; ++i)
>       > 		a[i] = b[i];
> 
>   0x0000000000400511: main at x86/hypercall.c:91 (discriminator 24)
> 
>       > 	memcpy((void *)~0xbadc0de, (void *)0xdeadbeef, 42);
> 
>   0x00000000004001ac: gdt32_end at x86/cstart64.S:127
>         	lea __environ(%rip), %rdx
>       > 	call main
>         	mov %eax, %edi
> 
> Above backtrace includes the failing memcpy() call, making it much
> easier to spot the bug.
> 
> Enable "fake profiling" if supported by the compiler to get better
> backtraces. The runtime overhead should be negligible for the gained
> debugability as the profiling call is actually a NOP.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  Makefile | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 9dc5d2234e2a..470da8f5e625 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -95,6 +95,17 @@ CFLAGS += $(wmissing_parameter_type)
>  CFLAGS += $(wold_style_declaration)
>  CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>  
> +ifneq ($(KEEP_FRAME_POINTER),)
> +# Fake profiling to force the compiler to emit a frame pointer setup also in
> +# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
> +#
> +# Note:
> +# We need to defer the cc-option test until -fno-pic or -no-pie have been
> +# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
> +# during compilation makes this do "The Right Thing."
> +fomit_frame_pointer += $(call cc-option, -pg -mnop-mcount, "")
> +endif
> +

My riscv cross compiler doesn't seem to need this, i.e. we already get
memcpy() in the trace with just -fno-omit-frame-pointer.

Also, while arm doesn't currently have memcpy() in the trace, adding
-mno-omit-leaf-frame-pointer works for the cross compiler I'm using
for it.

And, neither the riscv nor the arm cross compilers I'm using have
-mnop-mcount.

So, I think something like this should be put in arch-specific makefiles.

Thanks,
drew

>  autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
>  
>  LDFLAGS += -nostdlib $(no_pie) -z noexecstack
> -- 
> 2.30.2
> 

