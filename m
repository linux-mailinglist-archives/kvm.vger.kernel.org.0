Return-Path: <kvm+bounces-10232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1A986ADF2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B53DE1F24B36
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D7E3BBCF;
	Wed, 28 Feb 2024 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PCgMa0SU"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568C173537
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709120773; cv=none; b=lHwlh8sepdFkgmK8hhQR1pTyWWLoVW/HXVHSSnLC5nQy/hi8qeHlbh2hba/Me/jfU/YfPP6U8PhAZ/2UePJMEEd+NkY0VpaMR8eEuxs2Roc/g2qYdoSJkbVWcmVXLP5mB+aw1D9uWGVwSY8rpc7A5sWnSZC0Dr9yirlFRfXNxK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709120773; c=relaxed/simple;
	bh=K36wJ3R/FFsOiqNuSEm5atNBHwnFBk1MHbeF0ukg918=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TI+eCrwwTNMYQArsjc82vRyqfSKTvAlIm/Vr7tIYPsnOr7cWGdYZc60Fc51dUqV9Lk7C1GPqo/B6eR8zZw8WSuhSOdTniqgFhTrWj/cbw6ZvXFkeMPsijpjlbZIrSRLXP7e4SmbhXuWywmF8sc6oYpIoaufLdzs5pjCYK0GhQW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PCgMa0SU; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 12:46:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709120768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTRGxQW5N7XqhNVjZVxsJ5EAjnYvN4qy0+rCqgNzMQI=;
	b=PCgMa0SUTBA5UUU6R6YwSiShMJ/wyIg404MEvg6KRuTrLJMB1b8AXsZ35umvCO2T9vt78m
	yQGsnTgsFmTaV9l2cM6x6h/wdj1UO8VNivowrYj5cpoxry5jXljACab3W/uH+QFeuQMcXO
	hThzEYpmKrTyl0CCM+rFirpcQYO5Sq0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 04/32] powerpc: interrupt stack backtracing
Message-ID: <20240228-9b32ddf7f58dc8f75b24e33c@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-5-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226101218.1472843-5-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:11:50PM +1000, Nicholas Piggin wrote:
> Add support for backtracing across interrupt stacks, and
> add interrupt frame backtrace for unhandled interrupts.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  lib/powerpc/processor.c |  4 ++-
>  lib/ppc64/asm/stack.h   |  3 +++
>  lib/ppc64/stack.c       | 55 +++++++++++++++++++++++++++++++++++++++++
>  powerpc/Makefile.ppc64  |  1 +
>  powerpc/cstart64.S      |  7 ++++--
>  5 files changed, 67 insertions(+), 3 deletions(-)
>  create mode 100644 lib/ppc64/stack.c
> 
> diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> index ad0d95666..114584024 100644
> --- a/lib/powerpc/processor.c
> +++ b/lib/powerpc/processor.c
> @@ -51,7 +51,9 @@ void do_handle_exception(struct pt_regs *regs)
>  		return;
>  	}
>  
> -	printf("unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n", regs->trap, regs->nip, regs->msr);
> +	printf("Unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n",
> +			regs->trap, regs->nip, regs->msr);
> +	dump_frame_stack((void *)regs->nip, (void *)regs->gpr[1]);
>  	abort();
>  }
>  
> diff --git a/lib/ppc64/asm/stack.h b/lib/ppc64/asm/stack.h
> index 9734bbb8f..94fd1021c 100644
> --- a/lib/ppc64/asm/stack.h
> +++ b/lib/ppc64/asm/stack.h
> @@ -5,4 +5,7 @@
>  #error Do not directly include <asm/stack.h>. Just use <stack.h>.
>  #endif
>  
> +#define HAVE_ARCH_BACKTRACE
> +#define HAVE_ARCH_BACKTRACE_FRAME
> +
>  #endif
> diff --git a/lib/ppc64/stack.c b/lib/ppc64/stack.c
> new file mode 100644
> index 000000000..fcb7fa860
> --- /dev/null
> +++ b/lib/ppc64/stack.c
> @@ -0,0 +1,55 @@
> +#include <libcflat.h>
> +#include <asm/ptrace.h>
> +#include <stack.h>
> +
> +extern char exception_stack_marker[];
> +
> +int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
> +{
> +	static int walking;
> +	int depth = 0;
> +	const unsigned long *bp = (unsigned long *)frame;
> +	void *return_addr;
> +
> +	asm volatile("" ::: "lr"); /* Force it to save LR */
> +
> +	if (walking) {
> +		printf("RECURSIVE STACK WALK!!!\n");
> +		return 0;
> +	}
> +	walking = 1;
> +
> +	bp = (unsigned long *)bp[0];
> +	return_addr = (void *)bp[2];
> +
> +	for (depth = 0; bp && depth < max_depth; depth++) {
> +		return_addrs[depth] = return_addr;
> +		if (return_addrs[depth] == 0)
> +			break;
> +		if (return_addrs[depth] == exception_stack_marker) {
> +			struct pt_regs *regs;
> +
> +			regs = (void *)bp + STACK_FRAME_OVERHEAD;
> +			bp = (unsigned long *)bp[0];
> +			/* Represent interrupt frame with vector number */
> +			return_addr = (void *)regs->trap;
> +			if (depth + 1 < max_depth) {
> +				depth++;
> +				return_addrs[depth] = return_addr;
> +				return_addr = (void *)regs->nip;
> +			}
> +		} else {
> +			bp = (unsigned long *)bp[0];
> +			return_addr = (void *)bp[2];
> +		}
> +	}
> +
> +	walking = 0;
> +	return depth;
> +}
> +
> +int backtrace(const void **return_addrs, int max_depth)
> +{
> +	return backtrace_frame(__builtin_frame_address(0), return_addrs,
> +			       max_depth);
> +}

I'm about to post a series which has a couple treewide tracing changes
in them. Depending on which series goes first the other will need to
accommodate.

Thanks,
drew

