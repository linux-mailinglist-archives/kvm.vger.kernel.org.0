Return-Path: <kvm+bounces-16815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD2E8BDE08
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDC24285539
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E40414D715;
	Tue,  7 May 2024 09:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QmGG+5jt"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B8C14D703;
	Tue,  7 May 2024 09:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073770; cv=none; b=hoVPGHt5wXesB3sk/yKfUxl1kQNvbmrcwg+lbrKur+n41gsI+dZ30hIktuluk7ufaWjIy0kmCe0bS/kBsC4GdpTuESFxu+/Vy7R9WoXHHTgBLDAve0rak8vy4p7819DfgG/pafW4PG2v5NJSS2CAS61rDRaDJOeKcFjMITOS94U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073770; c=relaxed/simple;
	bh=wdzCCOHmM3lGliUWgg+Zqbsr30m7nx+Bj7nwCmHejc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXjCIL58Ws0yMdQFudS3ow+nQZ41UDQ6RbHW1nVk9KHy8wZ/+mFUSPDkBJ2Q86Vd2nCbvBXYRbkWBNiP6/mS7aQIYUzCzBjOFLPITIgaVJftf3v/OjPyUVBkJhJdiOYCGirKo1BV0E7FbEP5t+2XIds69/z3TOBb9o728KIDyMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QmGG+5jt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2TUgL5QKLzrTGjBmSVBfkXnSIlm/MWgcenf2oxiy4q8=; b=QmGG+5jthMJWqTCmeQCJAscVOV
	1LlciFAre6GUXRZUC3RF6ItJUUEEDKAtRHYRMA5BgbHU8e+AxFd/1iA+DhzbmtL2UReM/zwI58OKC
	IaqR1K+YKQkfDBjFrmKcH0nUW+inD5O1a61lvEtsRHjyUnuyZbQcmWWoSm7w/4NcrqzYMF3+dp5js
	XDsG2ZeRM111fxTopLgiiJGramLWYTV8fi2LHxAwpgAHDrPXDDCC1EsM+V0/4SF+jA8TNF+p/DMTc
	Wx1u6okm0T+Iu44veAi8OX5ugRYSO52Qxtt1Ki1/CvhKsAqlXkBgTUHQhRlkbxXi5/0wvqmGahzd9
	eODa9Cxw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4H21-0000000Cv4t-3aA5;
	Tue, 07 May 2024 09:22:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 797333006AB; Tue,  7 May 2024 11:22:41 +0200 (CEST)
Date: Tue, 7 May 2024 11:22:41 +0200
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
Subject: Re: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI
 handler
Message-ID: <20240507092241.GV40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-13-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-13-mizhang@google.com>

On Mon, May 06, 2024 at 05:29:37AM +0000, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
> Add x86 specific function to switch PMI handler since passthrough PMU and host
> PMU use different interrupt vectors.
> 
> x86_perf_guest_enter() switch PMU vector from NMI to KVM_GUEST_PMI_VECTOR,
> and guest LVTPC_MASK value should be reflected onto HW to indicate whether
> guest has cleared LVTPC_MASK or not, so guest lvt_pc is passed as parameter.
> 
> x86_perf_guest_exit() switch PMU vector from KVM_GUEST_PMI_VECTOR to NMI.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/events/core.c            | 17 +++++++++++++++++
>  arch/x86/include/asm/perf_event.h |  3 +++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 09050641ce5d..8167f2230d3a 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -701,6 +701,23 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
>  }
>  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>  
> +void x86_perf_guest_enter(u32 guest_lvtpc)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
> +			       (guest_lvtpc & APIC_LVT_MASKED));
> +}
> +EXPORT_SYMBOL_GPL(x86_perf_guest_enter);
> +
> +void x86_perf_guest_exit(void)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> +}
> +EXPORT_SYMBOL_GPL(x86_perf_guest_exit);

Urgghh... because it makes sense for this bare APIC write to be exported
?!?

Can't this at the very least be hard tied to perf_guest_{enter,exit}() ?

