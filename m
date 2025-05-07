Return-Path: <kvm+bounces-45703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE044AADB4D
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 11:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9CCF4C1831
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 09:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B74233144;
	Wed,  7 May 2025 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZaQwk9zx"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C2148832;
	Wed,  7 May 2025 09:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746609459; cv=none; b=aSkfDnjInBLTY4qwoSEa6dpvtC6PkfBLPbph1ehydaOzj/ROt4ziyNyxNMc+4kxjGMPmb/HPX2fNJoxdD2ypRUZXx3cb3OBGpPvKfd4Tcqr7YV2GpmcuMLxYgQ+in5i6Blo6Tk4fx76lya3CMwqL8xQa4bqoZleujPdnt8QIXhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746609459; c=relaxed/simple;
	bh=ykltQ9huLE0r8rln1hz74oZpmC0expnXFTghDd8zakY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/xHKujZx+wXq3Xv3xcDOzj21iNgc8FNstTwrLxp4//Li7bKLrxS00HtHFSlicW/u4+4mr43yIK/Q/dEpK+FO3vuZfKPV5I411bB5W3Ngs9rLYnYvpAFwWekJNTWIsDA8ilYmYtX2JRDmUmgX4i5cDTIzszvG3qytSs+CA5L8ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZaQwk9zx; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HqrE5RjgXWImFxmKS250rNaTgk4WttiwOVrF0xe9MXw=; b=ZaQwk9zxEbTKBGtOWN53DLzGRq
	xHT9z066aC/eoSE/s7yqlD6A/Ga4KA0rmybAx9Upg5QY3eQ+hz83cgqxibsE4AlDV/V4b87BjC58L
	xUSpU5riVmhqqjuaWjP4o8dM8SZSCQEqNCjm9x+oMgzPhld32iKX18F0/YnkMGWYGsHXS/1QLJM+p
	aNSEjBYRdJHjjFaxuJDX72UQkVjpK2nvMbfe92HFXCr3ICDQxETns9h3PQ75f8VDP9tMeHtQG7UD8
	rGH2k7mJcBJWbtAnxOiiKQdypI65Mg5MMJzS1L3fIubxLv0AzsZW4z3YbsaRgsl4prOYDIy5Yxxkq
	0H+YCyVg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uCau3-0000000Foi8-1z5i;
	Wed, 07 May 2025 09:17:24 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0BC04300780; Wed,  7 May 2025 11:17:23 +0200 (CEST)
Date: Wed, 7 May 2025 11:17:22 +0200
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
Subject: Re: [PATCH v5 6/9] x86/nmi: Prepare for the new NMI-source vector
 encoding
Message-ID: <20250507091722.GC4439@noisy.programming.kicks-ass.net>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-7-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507012145.2998143-7-sohil.mehta@intel.com>

On Tue, May 06, 2025 at 06:21:42PM -0700, Sohil Mehta wrote:

> +/*
> + * Prepare the delivery mode and vector for the ICR.
> + *
> + * NMI-source vectors have the NMI delivery mode encoded within them to
> + * differentiate them from the IDT vectors. IDT vector 0x2 (NMI_VECTOR)
> + * is treated as an NMI request but without any NMI-source information.
> + */
> +static inline u16 __prepare_ICR_DM_vector(u16 dm_vector)
> +{
> +	u16 vector = dm_vector & APIC_VECTOR_MASK;
> +	u16 dm = dm_vector & APIC_DM_MASK;
> +
> +	if (dm == APIC_DM_NMI) {
> +		/*
> +		 * Pre-FRED, the actual vector is ignored for NMIs, but
> +		 * zero it if NMI-source reporting is not supported to
> +		 * avoid breakage on misbehaving hardware or hypervisors.
> +		 */
> +		if (!cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
> +			vector = 0;
> +
> +		return dm | vector;
> +	}
> +
> +	if (vector == NMI_VECTOR)
> +		return APIC_DM_NMI;
> +	else

Please drop that else, that's pointless.

> +		return APIC_DM_FIXED | vector;
> +}

