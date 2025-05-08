Return-Path: <kvm+bounces-45988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4453AB04EA
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 22:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 897F53B7FC0
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 20:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C5121D5B6;
	Thu,  8 May 2025 20:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JMlKqetr"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EDD1D63F5;
	Thu,  8 May 2025 20:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746737368; cv=none; b=J+uxW9slsbnJ+mWbLj/xyf0MgSUkc/koj+GCLJIgH2chNzaDd8RWCp/YNhFgnAzX+swxxV8Wjq5P1/oDZeippRpV5Z6c36ZQWaFB58Ad6iqzvhFlqtPh/xMDv/3XYlMe8T2r93Uz6Nik+m0y3NekZu44CSMHA6APqOMPTIo0z58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746737368; c=relaxed/simple;
	bh=QkqgnDA/kdh8NiKMnLO2InJpAElzsZBA/UFEt5uNoHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXLGmoVLpjkrb/3k6+4VTyG835exGDRcfDIJwMfa717KvpYTLAG7iYRHRO6WVDhA0f+23Gu6gc0mRvBzAY+kwjzirg/UX3CVpJ99yVe/CGDBLuvBV7tcEzTqLe+pgqzO5Jg0t9cheB+91Cfl7ZJqFnFthSheCNaqJQI1U8kiMyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JMlKqetr; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hWA3Okv8QojCnFmChBVRHVH95q4ija3JUXWql+dARaA=; b=JMlKqetrrMtUUObbeNQXONoIA7
	RnErBFgdchc1XcYIkkweQHs8M85/xeMPkYrP+Lin6DGHro+LgTJe9UsJPvYs1l3vvlFppiWEf8BtU
	kJ71zS+0yd44w9BqgNw+HsgX259VwwAMdbbSY5U0cRoNh/E5BAXogPBxkwH4KV79UxGbors38PxB2
	XOwhcrhaN50pNLdptVsvmZkr/AXoovtXirRdNbN9iB7rJ7zPuG3JOLZw6Ir7fPHsrnLl2YCCTCn/z
	KNyjVfDwwCjamwCOgc7yAQUpxjLPGvf6jXrYhp84A1iuXhUFAo4iq76C5pmlIHHwSKBpxtzZxrxmm
	EswnLwQg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uD8B1-0000000GAKv-02ZU;
	Thu, 08 May 2025 20:49:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 61CB0300348; Thu,  8 May 2025 22:49:06 +0200 (CEST)
Date: Thu, 8 May 2025 22:49:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>,
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
Message-ID: <20250508204906.GJ4439@noisy.programming.kicks-ass.net>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-6-sohil.mehta@intel.com>
 <20250507091442.GB4439@noisy.programming.kicks-ass.net>
 <55527575-e3b8-4cf6-b09c-b81437e0c892@intel.com>
 <20250508121544.GH4439@noisy.programming.kicks-ass.net>
 <D368D488-6D4E-4590-8E98-A7D7CD5E7F20@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D368D488-6D4E-4590-8E98-A7D7CD5E7F20@zytor.com>

On Thu, May 08, 2025 at 01:23:04PM -0700, H. Peter Anvin wrote:
> On May 8, 2025 5:15:44 AM PDT, Peter Zijlstra <peterz@infradead.org> wrote:

> >> Looks good, except when fred_event_data() returns 0. I don't expect it
> >> to happen in practice. But, maybe with new hardware and eventually
> >> different hypervisors being involved, it is a possibility.
> >> 
> >> We can either call it a bug that an NMI happened without source
> >> information. Or be extra nice and do this:
> >> 
> >> if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
> >> 	source = fred_event_data(regs);
> >> 	if (!source || (source & BIT(0)))
> >> 		source = ~0UL;
> >> }
> >
> >Perhaps also WARN about the !source case?
> 
> A 0 should be interpreted such that NMI source is not available, e.g.
> due to a broken hypervisor or similar.

I'm reading that as an agreement for WARN-ing on 0. We should definitely
WARN on broken hypervisors and similar.

