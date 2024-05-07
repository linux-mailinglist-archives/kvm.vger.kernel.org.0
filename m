Return-Path: <kvm+bounces-16819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4348BDEC0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3F73B25768
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7F51514E8;
	Tue,  7 May 2024 09:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qo4OUGJZ"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF3C14E2C5;
	Tue,  7 May 2024 09:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074773; cv=none; b=Y5ODKJA0lOFn1wBKeqogYmIIcf5vSPKgMhTJHIbQ7wJjRbUNSZksU+t0H5MeKvCsd0AenLGq7c4gZBj2mT6N9nHttxv+mhkkxhgbru3oFUcM5cBzAPO6NS6PwGmomjnFvs5PKnymNR6acS1U8nYofj036rLJybu5hG7DSd38GVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074773; c=relaxed/simple;
	bh=AYOyhIEpiuNQMuH38yxE/++jlyxmKOd1PKS6KT/Sujo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsVnPV5z530fJfx+NVCVLg76ZzNUKsyWzvUdp8zU3Q5lggeK7cp3r3LWdS8LdY23Gs8iyjRU1JONSXVevp1UYHsdm7Et6DOOTtbXPqfD9D7s2PsN9o69sI7ByvbzYjjDaaCIVc/dOmQj2mzZOcThXSTflqfHmhr6WFEhgXARZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qo4OUGJZ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W1PZPBpa/Q6hYr5oZpfOfmMK/HERTYsNDqeT4P1bipI=; b=Qo4OUGJZOhjIdIIkkGX65s3m0H
	kzG/nqJh/Bv6qFIRSSo1wIU/TLkyAY+dZ47gZYcZL4/fxeEaEaepk/nzHpQlybDtR2G3SE54tAZfk
	1S+IYODW1u1GAnDQA2JlBy2LDC/HSSEhQhxLYSRibh/zXQyba4B8HeI8paVrnNjGteMM1zJWYL5Jj
	WkdA86amnBsNg+ZuUhBRKU+LmsrwPkm0CmXzEsGAks1OtmpR3K5WM9W9+cr5E0rplrxDUq3XAnZk9
	g4W0L+wYtM9iCfvMYUVRWBev6KE2cmJw6nan9oSrqddl/6mAncABG/aC4MgTQg1SfGAGFuYXB9toa
	UVMIMXzA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4HIC-0000000CwV5-0NQJ;
	Tue, 07 May 2024 09:39:24 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B9C44300362; Tue,  7 May 2024 11:39:23 +0200 (CEST)
Date: Tue, 7 May 2024 11:39:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
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
Subject: Re: [PATCH v2 38/54] KVM: x86/pmu: Call perf_guest_enter() at PMU
 context switch
Message-ID: <20240507093923.GX40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-39-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-39-mizhang@google.com>

On Mon, May 06, 2024 at 05:30:03AM +0000, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
> perf subsystem should stop and restart all the perf events at the host
> level when entering and leaving passthrough PMU respectively. So invoke
> the perf API at PMU context switch functions.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/events/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index f5a043410614..6fe467bca809 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -705,6 +705,8 @@ void x86_perf_guest_enter(u32 guest_lvtpc)
>  {
>  	lockdep_assert_irqs_disabled();
>  
> +	perf_guest_enter();
> +
>  	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>  			       (guest_lvtpc & APIC_LVT_MASKED));
>  }
> @@ -715,6 +717,8 @@ void x86_perf_guest_exit(void)
>  	lockdep_assert_irqs_disabled();
>  
>  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> +
> +	perf_guest_exit();
>  }
>  EXPORT_SYMBOL_GPL(x86_perf_guest_exit);

*sigh*.. why does this patch exist? Please merge with the one that
introduces these functions.

This is making review really hard.

