Return-Path: <kvm+bounces-45700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AEA6AADA09
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 10:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 781E64E331B
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 08:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBA8221D98;
	Wed,  7 May 2025 08:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WvRWxpmd"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED053273F9;
	Wed,  7 May 2025 08:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746606163; cv=none; b=QluZ4P1QKVQ5FYGDkABnEYTI2qe+NBgWSLmyKS6VlgsVPSnCjUYjM3dKD7YVAWbRvrXIkMw1/L70pZACk5TfzySvIJSD6XhyNJTpXK2oSZXV7XultoahwFpVmBvrQZKpL4dKnlk4kN8vNhJuv+iTOJcOjDN1y6TymF+krYuN0m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746606163; c=relaxed/simple;
	bh=pm/x4yL4ynHqji5f94ZWEII9oNZb9GpYQx4Qg6pHT/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M42wWx6SmkQyl35tJ2nAaJjq7nhB7IF1ra6yjPxDMOMABetY7DZd/GJ5g+QELh4FQT7SXhKFtjB20QtwzAhxKqzEnOK5U3jkVo2mX+8nbh98229f+dgTdvYuaw+LjBEoZb80RAaQ7+mJ+gLdS3V2mGW8EZsstqRWGoTvmtQFxig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WvRWxpmd; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dZYqAlHezITuF/Jo/pYWYXAIRG3sFn0xWBaAQsF1gug=; b=WvRWxpmdFQwb7Y8W2h0NSxfsEL
	UWuCjylwSxWE4S3uF5d6bftzRw9LMfYxyHMpa193wXJzmLv11yd5cu3T9W3gWFU36XJCXsL0kJnmM
	NKBCnHY2NZcfgRStd2Zk7dw/1FTdNnJIficcCFz7ESA7R5+XkXBd62b8sxRW2LLOMBpeZDpa2s5aQ
	2TRD+MGG+Kpu2RE5jFIUVqIHWkYlSbq3jID2qJLRrLB2ELd53QFo0T9wnAHMM94n+4vFSR4UTQBo3
	D5viJw6wGtHnBXYwer75H2S+OiOSrmVT74MogNJ309Kt60Cq3FtWwxTVPo3ELXFaZ4b9D4ilPw+kU
	LZupus0Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uCa2i-0000000FoF4-3Rza;
	Wed, 07 May 2025 08:22:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 66035300780; Wed,  7 May 2025 10:22:16 +0200 (CEST)
Date: Wed, 7 May 2025 10:22:16 +0200
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
Subject: Re: [PATCH v5 4/9] x86/nmi: Assign and register NMI-source vectors
Message-ID: <20250507082216.GA4439@noisy.programming.kicks-ass.net>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-5-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507012145.2998143-5-sohil.mehta@intel.com>

On Tue, May 06, 2025 at 06:21:40PM -0700, Sohil Mehta wrote:

> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index f0a577bf7bba..b9beb216f2d0 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -57,6 +57,38 @@ struct nmiaction {
>  	u8			source_vector;
>  };
>  
> +/**
> + * NMI-source vectors are used to identify the origin of an NMI and to
> + * route the NMI directly to the appropriate handler.
> + *
> + * On CPUs that support NMI-source reporting with FRED, receiving an NMI
> + * with a valid vector sets the corresponding bit in the NMI-source
> + * bitmap. The bitmap is delivered as FRED event data on the stack.
> + * Multiple NMIs are coalesced in the NMI-source bitmap until the next
> + * NMI delivery.
> + *
> + * If an NMI is received without a vector or beyond the defined range,
> + * the CPU sets bit 0 of the NMI-source bitmap.
> + *
> + * Vector 2 is reserved for external NMIs related to the Local APIC -
> + * LINT1. Some third-party chipsets may send NMI messages with a
> + * hardcoded vector of 2, which would result in bit 2 being set in the
> + * NMI-source bitmap.
> + *
> + * The vectors are in no particular priority order. Add new vector
> + * assignments sequentially in the list below.
> + */
> +#define NMIS_VECTOR_NONE	0	/* Reserved - Set for all unidentified sources */
> +#define NMIS_VECTOR_TEST	1	/* NMI selftest */
> +#define NMIS_VECTOR_EXTERNAL	2	/* Reserved - Match External NMI vector 2 */
> +#define NMIS_VECTOR_SMP_STOP	3	/* Panic stop CPU */
> +#define NMIS_VECTOR_BT		4	/* CPU backtrace */
> +#define NMIS_VECTOR_KGDB	5	/* Kernel debugger */
> +#define NMIS_VECTOR_MCE		6	/* MCE injection */
> +#define NMIS_VECTOR_PMI		7	/* PerfMon counters */
> +
> +#define NMIS_VECTORS_MAX	16	/* Maximum number of NMI-source vectors */

Are these really independent NMI vectors, or simply NMI source reporting bits?

Because if they are not NMI vectors, naming them such is confusing.

Specifically, is there a latch per source?

> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index be93ec7255bf..a1d672dcb6f0 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -184,6 +184,11 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
>  
>  	raw_spin_lock_irqsave(&desc->lock, flags);
>  
> +	WARN_ON_ONCE(action->source_vector >= NMIS_VECTORS_MAX);
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) || type != NMI_LOCAL)
> +		action->source_vector = 0;

How about:

	WARN_ON_ONCE(type != NMI_LOCAL && action->source_vector);

instead?

