Return-Path: <kvm+bounces-45845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8B0AAF98C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5A1A3A13C5
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 12:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D502253F3;
	Thu,  8 May 2025 12:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hbvaA7DU"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47E6136A;
	Thu,  8 May 2025 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746706567; cv=none; b=EGNwwA3KnrJ+zEHf8CSZcf0J2rKc+ecFVYvKe8NLRhe8cofLjmbzF/1+CDZEokCh2utmKweSGA7ogqlqspqgDrztWRuToYW3iS0VwYWkZJKcQAxSKco3hQjRjV4AXB1J38NiYVXqeY513lnuVnsfaEYeThCeOdLeKd/BDFSTeCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746706567; c=relaxed/simple;
	bh=Sld0Gmq2W3ac2adnW1x7WQNzxebTEB2s99xXHqcK4/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIsJjdS0XN35Y0GnfT59sFyQa1MfFMwXxvfLhlg5ghpULaUJOxXZXkRsC0DM/axTFJtGhE9dr8AM2Gh3HV5IYPqBJjgPauLOJu9jba+vJEe6YInRtGoxxUUu91Q6fvMqohygRthWVFg62yeGrKw6VfH2OxDpVWxucJ7XDC6+kO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hbvaA7DU; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9BWvRgIIiJKpl7FhGWRbkXSkt9i/d2nayBtfYXn3Jwk=; b=hbvaA7DU/b99tEN1KDtOOXAkrg
	Zj5jUSd3xWjUl1g265LOT2rDJfRSpkC9lsM3sLH/cCc8YVVCs9Y3XgKezsYU/I3f9i3sZOy5FS9w1
	rswzlSYPYHlbUb1Xg9PLpi5KNGOYMxTEpISZ29emDYUSWLXF1Xi+ihBkMla/nFBwatK6jzkqyYaTI
	9PkMkS7YxlTOtq52GJKdfA1kStxvWfJmkx96ZqMkzbUUHGpoaFtTkp6pTFvlu5t4F/679WCK6MeU9
	a3HIs+DMfWv1QrcKcdgRWBHOGnP4m20NQoR7auIr4QkijR4QISNUthlIVTGPKRmAe6o7cX+cOunAV
	8QOLkavA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uD0AD-0000000G28P-1dAj;
	Thu, 08 May 2025 12:15:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C254130026A; Thu,  8 May 2025 14:15:44 +0200 (CEST)
Date: Thu, 8 May 2025 14:15:44 +0200
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
Message-ID: <20250508121544.GH4439@noisy.programming.kicks-ass.net>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-6-sohil.mehta@intel.com>
 <20250507091442.GB4439@noisy.programming.kicks-ass.net>
 <55527575-e3b8-4cf6-b09c-b81437e0c892@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55527575-e3b8-4cf6-b09c-b81437e0c892@intel.com>

On Wed, May 07, 2025 at 02:48:34PM -0700, Sohil Mehta wrote:
> On 5/7/2025 2:14 AM, Peter Zijlstra wrote:
> > On Tue, May 06, 2025 at 06:21:41PM -0700, Sohil Mehta wrote:
> >>
> >> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> >> index a1d672dcb6f0..183e3e717326 100644
> >> --- a/arch/x86/kernel/nmi.c
> >> +++ b/arch/x86/kernel/nmi.c
> > 
> >>  static int nmi_handle(unsigned int type, struct pt_regs *regs)
> >>  {
> >>  	struct nmi_desc *desc = nmi_to_desc(type);
> >> +	unsigned long source_bitmap = 0;
> > 
> > 	unsigned long source = ~0UL;
> > 
> 
> Thanks! This makes the logic even simpler by getting rid of
> match_nmi_source(). A minor change described further down.
> 
> Also, do you prefer "source" over "source_bitmap"? I had it as such to
> avoid confusion between source_vector and source_bitmap.

Yeah, I was lazy typing. Perhaps just call it bitmap then?

> >>  	nmi_handler_t ehandler;
> >>  	struct nmiaction *a;
> >>  	int handled=0;
> >> @@ -148,16 +164,40 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
> >>  
> >>  	rcu_read_lock();
> >>  
> >> +	/*
> >> +	 * Activate NMI source-based filtering only for Local NMIs.
> >> +	 *
> >> +	 * Platform NMI types (such as SERR and IOCHK) have only one
> >> +	 * handler registered per type, so there is no need to
> >> +	 * disambiguate between multiple handlers.
> >> +	 *
> >> +	 * Also, if a platform source ends up setting bit 2 in the
> >> +	 * source bitmap, the local NMI handlers would be skipped since
> >> +	 * none of them use this reserved vector.
> >> +	 *
> >> +	 * For Unknown NMIs, avoid using the source bitmap to ensure all
> >> +	 * potential handlers have a chance to claim responsibility.
> >> +	 */
> >> +	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL)
> >> +		source_bitmap = fred_event_data(regs);
> > 
> > 	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
> > 		source = fred_event_data(regs);
> > 		if (source & BIT(0))
> > 			source = ~0UL;
> > 	}
> > 
> 
> Looks good, except when fred_event_data() returns 0. I don't expect it
> to happen in practice. But, maybe with new hardware and eventually
> different hypervisors being involved, it is a possibility.
> 
> We can either call it a bug that an NMI happened without source
> information. Or be extra nice and do this:
> 
> if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
> 	source = fred_event_data(regs);
> 	if (!source || (source & BIT(0)))
> 		source = ~0UL;
> }

Perhaps also WARN about the !source case?

