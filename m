Return-Path: <kvm+bounces-27936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8657A990739
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 17:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B31131C211AD
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 15:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8582C1AA7AC;
	Fri,  4 Oct 2024 15:15:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B33E1741DC;
	Fri,  4 Oct 2024 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728054900; cv=none; b=FQe0B+xQZsECc+p2urxAxOLndHg3x2sq5axglqUigDwa7FBd34CG63JyBpOG1AgNEUahyzfgBfzYfvaDGTAt2/+IxIsV1ev4E8cfHdwFSu3Gh5kl1mbU7aEnHlhPyQw3yA9rB4KVIuF/e2xQ9nNzrWpuzQ9AdYVnKoxqS2euKHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728054900; c=relaxed/simple;
	bh=XuU41cUY651vrvEuIIokCiSfp8fKXEBCuJCdw/qwKDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UH9XORg7JuVMWxuORrn2q8/8py6DWxLBvPbmDz9bxloSrkI7Mst9Yd8JzsiBFhVLVMgH+WiEOAWWE8CmTWmXOlnYzlnN0Y3h7MvPIXhZJApsklA4j6zd0IDYW9xr5Kd5Q+JECh/OLRoSPkr6vro+75GF+FscBCQRrNvoR0DZ420=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3131339;
	Fri,  4 Oct 2024 08:15:26 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 493D13F640;
	Fri,  4 Oct 2024 08:14:52 -0700 (PDT)
Date: Fri, 4 Oct 2024 16:14:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
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
Subject: Re: [PATCH v5 1/5] arm: perf: Drop unused functions
Message-ID: <ZwAGZ5YB-eYemlYR@J2N7QTR9R3.cambridge.arm.com>
References: <20240920174740.781614-1-coltonlewis@google.com>
 <20240920174740.781614-2-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240920174740.781614-2-coltonlewis@google.com>

On Fri, Sep 20, 2024 at 05:47:36PM +0000, Colton Lewis wrote:
> For arm's implementation, perf_instruction_pointer() and
> perf_misc_flags() are equivalent to the generic versions in
> include/linux/perf_event.h so arch/arm doesn't need to provide its
> own versions. Drop them here.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm/include/asm/perf_event.h |  7 -------
>  arch/arm/kernel/perf_callchain.c  | 17 -----------------
>  2 files changed, 24 deletions(-)
> 
> diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
> index bdbc1e590891..c08f16f2e243 100644
> --- a/arch/arm/include/asm/perf_event.h
> +++ b/arch/arm/include/asm/perf_event.h
> @@ -8,13 +8,6 @@
>  #ifndef __ARM_PERF_EVENT_H__
>  #define __ARM_PERF_EVENT_H__
>  
> -#ifdef CONFIG_PERF_EVENTS
> -struct pt_regs;
> -extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
> -extern unsigned long perf_misc_flags(struct pt_regs *regs);
> -#define perf_misc_flags(regs)	perf_misc_flags(regs)
> -#endif
> -
>  #define perf_arch_fetch_caller_regs(regs, __ip) { \
>  	(regs)->ARM_pc = (__ip); \
>  	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
> diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
> index 1d230ac9d0eb..a2601b1ef318 100644
> --- a/arch/arm/kernel/perf_callchain.c
> +++ b/arch/arm/kernel/perf_callchain.c
> @@ -96,20 +96,3 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	arm_get_current_stackframe(regs, &fr);
>  	walk_stackframe(&fr, callchain_trace, entry);
>  }
> -
> -unsigned long perf_instruction_pointer(struct pt_regs *regs)
> -{
> -	return instruction_pointer(regs);
> -}
> -
> -unsigned long perf_misc_flags(struct pt_regs *regs)
> -{
> -	int misc = 0;
> -
> -	if (user_mode(regs))
> -		misc |= PERF_RECORD_MISC_USER;
> -	else
> -		misc |= PERF_RECORD_MISC_KERNEL;
> -
> -	return misc;
> -}
> -- 
> 2.46.0.792.g87dc391469-goog
> 

