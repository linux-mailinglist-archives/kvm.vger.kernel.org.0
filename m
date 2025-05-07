Return-Path: <kvm+bounces-45762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA47BAAEE04
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A0889E269E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 21:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E672C242D87;
	Wed,  7 May 2025 21:48:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AD3DDC3;
	Wed,  7 May 2025 21:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654483; cv=none; b=rGFDjUuzdEoOBJKm9Hg3QKgH2SWux9JTKJ/1Ay6LTD1M8Hk+S/+O8O/EgIzK+pwoXwUQx1wtCltfhBTyb/jVA57EILXisOlLG/8GzXKIYnf2G+YJxqMaANh8mWNqHioZMe0xguViS8WpDkMG/H+vI01PcpmG7rcM1g7kd9mbPzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654483; c=relaxed/simple;
	bh=nfqBh82m0tQXIWKaHq3eRRzESiJPd4iCDQ+UVW1fl5E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jX7tgegHmsg0Qf0QHAnRw2U3fO/9f1j8zAn6hDSgCq9dKVZEPmZDfctjKJ/R7OApGFoNpceeNv4TOLouNBHL6QsSByKWbyzFu6KwjShOWCOweLawYkjzKsTKoMi4FMx6LgvnwPiNAzIx7qWcUWGvuXq5rAbJT0CLkpXLuTT1IMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881F5C4CEE2;
	Wed,  7 May 2025 21:47:58 +0000 (UTC)
Date: Wed, 7 May 2025 17:48:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, "H
 . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter
 Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, Tony Luck
 <tony.luck@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly
 Kuznetsov <vkuznets@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, Zhang Rui
 <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Brian Gerst <brgerst@gmail.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan
 <jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>, Kai Huang
 <kai.huang@intel.com>, Nikolay Borisov <nik.borisov@suse.com>,
 linux-perf-users@vger.kernel.org, linux-edac@vger.kernel.org,
 kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] x86/nmi: Include NMI-source information in
 tracepoint and debug prints
Message-ID: <20250507174809.10cfc5ac@gandalf.local.home>
In-Reply-To: <20250507012145.2998143-10-sohil.mehta@intel.com>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
	<20250507012145.2998143-10-sohil.mehta@intel.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 May 2025 18:21:45 -0700
Sohil Mehta <sohil.mehta@intel.com> wrote:

> diff --git a/include/trace/events/nmi.h b/include/trace/events/nmi.h
> index 18e0411398ba..6e4a1ff70a44 100644
> --- a/include/trace/events/nmi.h
> +++ b/include/trace/events/nmi.h
> @@ -10,29 +10,32 @@
>  
>  TRACE_EVENT(nmi_handler,
>  
> -	TP_PROTO(void *handler, s64 delta_ns, int handled),
> +	TP_PROTO(void *handler, s64 delta_ns, int handled, unsigned long source_bitmap),

Even though x86 is currently the only architecture using the nmi
tracepoint, this "source_bitmap" makes it become very x86 specific.

This file should be moved into arch/x86/include/asm/trace/

And that would require adding to the Makefile:

CFLAGS_nmi.o := -I $(src)/../include/asm/trace

>  
> -	TP_ARGS(handler, delta_ns, handled),
> +	TP_ARGS(handler, delta_ns, handled, source_bitmap),
>  
>  	TP_STRUCT__entry(
>  		__field(	void *,		handler	)
>  		__field(	s64,		delta_ns)
>  		__field(	int,		handled	)
> +		__field(	unsigned long,	source_bitmap)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->handler = handler;
>  		__entry->delta_ns = delta_ns;
>  		__entry->handled = handled;
> +		__entry->source_bitmap = source_bitmap;
>  	),
>  
> -	TP_printk("%ps() delta_ns: %lld handled: %d",
> +	TP_printk("%ps() delta_ns: %lld handled: %d source_bitmap: 0x%lx",
>  		__entry->handler,
>  		__entry->delta_ns,
> -		__entry->handled)
> +		__entry->handled,
> +		__entry->source_bitmap)
>  );
>  
>  #endif /* _TRACE_NMI_H */
>  
> -/* This part ust be outside protection */
> +/* This part must be outside protection */

And this would need to have:

#undef TRACE_INCLUDE_PATH
#undef TRACE_INCLUDE_FILE
#define TRACE_INCLUDE_PATH .
#define TRACE_INCLUDE_FILE nmi

-- Steve

>  #include <trace/define_trace.h>

