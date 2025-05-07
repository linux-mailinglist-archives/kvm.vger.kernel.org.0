Return-Path: <kvm+bounces-45702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CAEAADB3B
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 11:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69AC61C2556E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 09:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD5872603;
	Wed,  7 May 2025 09:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F4nSP2Fz"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36BB23C4E1;
	Wed,  7 May 2025 09:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746609303; cv=none; b=sRk69KjBgJB6Q9Hy9TlUo1q3ZiH1++bRTqig8FS96g932xjZSDjlx81uTPyAF4Y+OhOpy+HgFtvyIVCvc7sZU5Er0Fysyfp6DR0QijtL1dq98m3Cs2fK8LNvZlAnEULUnEMSD8oVcD1gjqaJmIYDN2mn7c01TFZyIrGyFMGd45w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746609303; c=relaxed/simple;
	bh=8bzrdEFI6hGktiNjZu3XxSN3Ansccky9WP6hM1uEFvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSwKHAj/FgKjMq7eKydUBWXbD90gsvy9/cametHrZDGOaGE8C7SNmS+nWUUxDFT3RAqqMZippYLmM7clPGwz/9KC+U7jFczQSJdTaUsZdxPo4eADea/QrbR/22Rxj3b6Lbgt50APondy/ctQ74xzD+POLe7C4Wuwqu616BRBGpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F4nSP2Fz; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N6hxa7ktAI16FThLApG5BUFDutIZOY100z1nEuVdsWU=; b=F4nSP2FzZ8rKSWMhBjzEjDSXfc
	z0A3zK1IOTGReBK/EpHD0aBhmsW2oNP7kbHRgPHTTUtnt2kktsrF0yOEe9ra4dEXCAT6KXzpP2uYR
	Jg7RfQ5RUR9fBMXgRHAHWTHyhL612ZYnAnxFuYwPGXKLjWNlE7hym93yt0n6z+e953H8AFlgNea9a
	myU1RrJLqJdpzCqyrZ//9TIuXE/t4qfzOgfQQordbCIfzKm/FPAHg7E3lDASVhcvEKnCVLFLag3Zf
	N3Jfo8TXjFZ2GG1cmRMpkskB3h0cpZq3nLpZS97h6EU4nb3/arJfY4jA5mP0vK2K4rW9oPj1WAjq8
	f6/K3HEA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uCarT-0000000FogU-247e;
	Wed, 07 May 2025 09:14:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C9D82300780; Wed,  7 May 2025 11:14:42 +0200 (CEST)
Date: Wed, 7 May 2025 11:14:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-perf-users@vger.kernel.org, linux-edac@vger.kernel.org,
	kvm@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/9] x86/nmi: Add support to handle NMIs with source
 information
Message-ID: <20250507091442.GB4439@noisy.programming.kicks-ass.net>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-6-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507012145.2998143-6-sohil.mehta@intel.com>

On Tue, May 06, 2025 at 06:21:41PM -0700, Sohil Mehta wrote:
> The NMI-source bitmap is delivered as FRED event data to the kernel.
> When available, use NMI-source based filtering to determine the exact
> handlers to run.
> 
> Activate NMI-source based filtering only for Local NMIs. While handling
> platform NMI types (such as SERR and IOCHK), do not use the source
> bitmap. They have only one handler registered per type, so there is no
> need to disambiguate between multiple handlers.
> 
> Some third-party chipsets may send NMI messages with a hardcoded vector
> of 2, which would result in bit 2 being set in the NMI-source bitmap.
> Skip the local NMI handlers in this situation.
> 
> Bit 0 of the source bitmap is set by the hardware whenever a source
> vector was not used while generating an NMI, or the originator could not
> be reliably identified. Poll all the registered handlers in that case.
> 
> When multiple handlers need to be executed, adhere to the existing
> priority scheme and execute the handlers registered with NMI_FLAG_FIRST
> before others.
> 
> The logic for handling legacy NMIs is unaffected since the source bitmap
> would always be zero.
> 
> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
> ---
> v5: Significantly simplify NMI-source handling logic.
>     Get rid of a separate lookup table for NMI-source vectors.
>     Adhere to existing priority scheme for handling NMIs.
> ---
>  arch/x86/kernel/nmi.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index a1d672dcb6f0..183e3e717326 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c

>  static int nmi_handle(unsigned int type, struct pt_regs *regs)
>  {
>  	struct nmi_desc *desc = nmi_to_desc(type);
> +	unsigned long source_bitmap = 0;

	unsigned long source = ~0UL;

>  	nmi_handler_t ehandler;
>  	struct nmiaction *a;
>  	int handled=0;
> @@ -148,16 +164,40 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
>  
>  	rcu_read_lock();
>  
> +	/*
> +	 * Activate NMI source-based filtering only for Local NMIs.
> +	 *
> +	 * Platform NMI types (such as SERR and IOCHK) have only one
> +	 * handler registered per type, so there is no need to
> +	 * disambiguate between multiple handlers.
> +	 *
> +	 * Also, if a platform source ends up setting bit 2 in the
> +	 * source bitmap, the local NMI handlers would be skipped since
> +	 * none of them use this reserved vector.
> +	 *
> +	 * For Unknown NMIs, avoid using the source bitmap to ensure all
> +	 * potential handlers have a chance to claim responsibility.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL)
> +		source_bitmap = fred_event_data(regs);

	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
		source = fred_event_data(regs);
		if (source & BIT(0))
			source = ~0UL;
	}

>  	/*
>  	 * NMIs are edge-triggered, which means if you have enough
>  	 * of them concurrently, you can lose some because only one
>  	 * can be latched at any given time.  Walk the whole list
>  	 * to handle those situations.
> +	 *
> +	 * However, NMI-source reporting does not have this limitation.
> +	 * When NMI-source information is available, only run the
> +	 * handlers that match the reported vectors.
>  	 */
>  	list_for_each_entry_rcu(a, &desc->head, list) {
>  		int thishandled;
>  		u64 delta;
>  
> +		if (source_bitmap && !match_nmi_source(source_bitmap, a))
> +			continue;

		if (!(souce & BIT(a->source_vector)))
			continue;

>  		delta = sched_clock();
>  		thishandled = a->handler(type, regs);
>  		handled += thishandled;

