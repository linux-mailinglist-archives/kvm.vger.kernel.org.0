Return-Path: <kvm+bounces-31282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3595C9C2082
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5180E1C22FD3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3BB21A712;
	Fri,  8 Nov 2024 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yrlsi7At"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3F51E5708;
	Fri,  8 Nov 2024 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731080079; cv=none; b=QNpvjT07YTxhbm35bDjH2GbY94o0nKFARh5Zhju0T9vKc1J7hXlxQNoj6l7ZiiWof6vrcH+QA/GqY/g7/YjV18xYv56Ylr4BEjp8M/J9cSlaU2KuTd9OPzUCBJ+99aUpOkz8mvzfkFoTJ0Cai/a15tw7wIDgZpx7JluQ3DfYAC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731080079; c=relaxed/simple;
	bh=U/9AlEbPsyJXfUCtQk5OJgeixtftufu+eceurvg7r3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1l8r6SBDl930jaNLeieKCUJkIptpd5Zu8tZw+h21V2zX+QeqdrGJt1rcfxDPIVlChl695hOVKFM8pNkhrd/oz13Bcw/ySJlSSJM+jKd/OdBkake4rLCxeJeYSCtbSXm4WqU6GkmhPXBhi1afGFc4xWfI3HtV/YV4tmr9WWUwWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yrlsi7At; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vjqYkG8ff4c+T4YdMOMbIeQIrZmZCxBiG8+gykwYd68=; b=Yrlsi7At3LEJP0uIS6NkE1jR0Z
	oEDQN829mzVxadI/xT+kHJyj5id3FRDTMankwY09OZVfoGLKoqsmLmgVU1Lu1pazKwCxc0rCgk1MQ
	xtxACAOrflTnYJ1gsq35M/GrEku0PXrYo1NmUlRg3/xm/yNXfSqjxdFSGnOXTyYmYxf2oekxv9FLP
	wEOzongRu606SdS0S8qnLTBPFqmALtmejbk/mXmEr2UTL7qA+UAscv+0HOvdCrD1PTIU4PbUBjS+W
	/Lg0PXKc83CciAUL2IEcvj4nySJ8JJocIaAq2CpM/eee1apM5FIwT9nN1SxiZwdtiiRR7++R4EU95
	TbKChe7A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t9Qzz-000000090KC-0Eqo;
	Fri, 08 Nov 2024 15:34:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2EC8930049D; Fri,  8 Nov 2024 16:34:11 +0100 (CET)
Date: Fri, 8 Nov 2024 16:34:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v7 4/5] x86: perf: Refactor misc flag assignments
Message-ID: <20241108153411.GF38786@noisy.programming.kicks-ass.net>
References: <20241107190336.2963882-1-coltonlewis@google.com>
 <20241107190336.2963882-5-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107190336.2963882-5-coltonlewis@google.com>

On Thu, Nov 07, 2024 at 07:03:35PM +0000, Colton Lewis wrote:
> Break the assignment logic for misc flags into their own respective
> functions to reduce the complexity of the nested logic.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/x86/events/core.c            | 32 +++++++++++++++++++++++--------
>  arch/x86/include/asm/perf_event.h |  2 ++
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index d19e939f3998..9fdc5fa22c66 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -3011,16 +3011,35 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
>  	return regs->ip + code_segment_base(regs);
>  }
>  
> +static unsigned long common_misc_flags(struct pt_regs *regs)
> +{
> +	if (regs->flags & PERF_EFLAGS_EXACT)
> +		return PERF_RECORD_MISC_EXACT_IP;
> +
> +	return 0;
> +}
> +
> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> +{
> +	unsigned long guest_state = perf_guest_state();
> +	unsigned long flags = common_misc_flags(regs);

This is double common_misc and makes no sense

> +
> +	if (!(guest_state & PERF_GUEST_ACTIVE))
> +		return flags;
> +
> +	if (guest_state & PERF_GUEST_USER)
> +		return flags & PERF_RECORD_MISC_GUEST_USER;
> +	else
> +		return flags & PERF_RECORD_MISC_GUEST_KERNEL;

And this is just broken garbage, right?

> +}

Did you mean to write:

unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
{
	unsigned long guest_state = perf_guest_state();
	unsigned long flags = 0;

	if (guest_state & PERF_GUEST_ACTIVE) {
		if (guest_state & PERF_GUEST_USER)
			flags |= PERF_RECORD_MISC_GUEST_USER;
		else
			flags |= PERF_RECORD_MISC_GUEST_KERNEL;
	}

	return flags;
}

>  unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>  {
>  	unsigned int guest_state = perf_guest_state();
> -	int misc = 0;
> +	unsigned long misc = common_misc_flags(regs);

Because here you do the common thing..

>  
>  	if (guest_state) {
> -		if (guest_state & PERF_GUEST_USER)
> -			misc |= PERF_RECORD_MISC_GUEST_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> +		misc |= perf_arch_guest_misc_flags(regs);

And here you mix in the guest things.

>  	} else {
>  		if (user_mode(regs))
>  			misc |= PERF_RECORD_MISC_USER;

