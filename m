Return-Path: <kvm+bounces-16989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1423B8BF8CB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCAA11F246B0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266117581A;
	Wed,  8 May 2024 08:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HJ/Y2DdP"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B262F54756;
	Wed,  8 May 2024 08:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715157446; cv=none; b=aWoET6cmGaOn8NM2F9n17cDUS6PvltOJvExCe7aCR/n50ZghnUg/rLXaA7QC4L780lJZZG6ye5rO/1k6z8iDpudOcbWDbnREb628UvebYawpaUPoSLeOIqvhqu6ogFA+mh2oJV0cjW4lKQxUwmZ0C7Y8Ct3v0m1DlAw4fsiTs0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715157446; c=relaxed/simple;
	bh=tBuUKc9AMVWbaCfQv2/GY41fFFQdNYK6ff/LQ9uiVpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIW1YEzA3XzqySuJTZlKkFNMwlFQ0xLu0s7cPS2+xZ+gWGre0HrNflSPsA7kz7fb7e4AGen/rh+S8IHLuPBKxmpSQrm4ufzAGIS3gJrd7iCZTUayJDOXXOqYRdlt7kSuXgNXMRfPShPtJ50Ffma0TUcEqeLN4ltaj3HG0WdJ88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HJ/Y2DdP; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5R/JBUNAdnzGjy8YoDVUwFmeG75we7yd6OkuH85LpjI=; b=HJ/Y2DdPWy2qu6TVz4HEj4j90D
	QN2dqb0gFmwjHTI2E7LIAK0f7Isn5F6D4FaGXuR2r48Z9cgX/fKIEJTu3TwTBvAZ7wufSFBTN9qea
	Oxi+I3KqsVb7ntko7rLBlJNt2vPszaJnTlFI4BOKS6mYnw6Cl24CIYxnIAvTZjpZ1ixqHf1WUknNr
	+Bx7t8Jkrw/Potzzr4x9nXZn8zu4OnkFU2DzxSz1iLwhDDx6oSSQNYAwmOqHVijEmFATy0NQZvxw7
	aSNxu2t8fbfuEWeN+1qNYsX1htp2HcJecOuq4yGPvB77c8OK6VE9ol+0P2gar/67q0O1weE4ccf35
	+8DHdwVg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4cnU-00000002Qt7-1MFX;
	Wed, 08 May 2024 08:37:09 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F011C3002AF; Wed,  8 May 2024 10:37:07 +0200 (CEST)
Date: Wed, 8 May 2024 10:37:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI
 handler
Message-ID: <20240508083707.GH30852@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-13-mizhang@google.com>
 <20240507092241.GV40213@noisy.programming.kicks-ass.net>
 <34245468-00fc-49aa-951e-d7d786084d08@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34245468-00fc-49aa-951e-d7d786084d08@linux.intel.com>

On Wed, May 08, 2024 at 02:58:30PM +0800, Zhang, Xiong Y wrote:
> On 5/7/2024 5:22 PM, Peter Zijlstra wrote:
> > On Mon, May 06, 2024 at 05:29:37AM +0000, Mingwei Zhang wrote:
> >> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

> >> +void x86_perf_guest_enter(u32 guest_lvtpc)
> >> +{
> >> +	lockdep_assert_irqs_disabled();
> >> +
> >> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
> >> +			       (guest_lvtpc & APIC_LVT_MASKED));
> >> +}
> >> +EXPORT_SYMBOL_GPL(x86_perf_guest_enter);
> >> +
> >> +void x86_perf_guest_exit(void)
> >> +{
> >> +	lockdep_assert_irqs_disabled();
> >> +
> >> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> >> +}
> >> +EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
> > 
> > Urgghh... because it makes sense for this bare APIC write to be exported
> > ?!?
> Usually KVM doesn't access HW except vmx directly and requests other
> components to access HW to avoid confliction, APIC_LVTPC is managed by x86
> perf driver, so I added two functions here and exported them.

Yes, I understand how you got here. But as with everything you export,
you should ask yourself, should I export this. The above
x86_perf_guest_enter() function allows any module to write random LVTPC
entries. That's not a good thing to export.

I utterly detest how KVM is a module and ends up exporting a ton of
stuff that *really* should not be exported.

