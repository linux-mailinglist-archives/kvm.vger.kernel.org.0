Return-Path: <kvm+bounces-16812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4512C8BDDEF
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D96471F228B8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A4114D6F9;
	Tue,  7 May 2024 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="shjnb04W"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7781114D2BF;
	Tue,  7 May 2024 09:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073493; cv=none; b=iIw9/FJvmHaOb6PsxlRqAojOPY64gBTlXxOrk22TB5GS14Z3Uv27mzRU/ZSKzJQw6Z8EZJ8KiS5hAsTOf+DPT2TCS7T4vzzMReRSeYs5mfG0QnqpfeKmW1p0GlRW8A6Bm5Ef+2NRt4Nw6p7cm6tQDzZVhbcndnEtaY+F2dBNxMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073493; c=relaxed/simple;
	bh=3/isuBHST9KlkQ0KsFW+9CuiLTQNyc5DFbwkbcg7AEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UHa7tP2yeN2w9jlxCcPOmDjCG2EDb3b1NRKM0/nHLJFc4fsqpik07RoRF7TkZp4+j7ej2aabgPL6Gs37pjZ6cM62n8CBZp/JfClWKWU6/M6FSgIX7bVgSYig89ATSw+0jOpd75/DCaI0z4/pFlcpYsQPKpLMWA1jjfGIcXzHBYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=shjnb04W; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NHStpYxP899yFFJLxuY1x+8i7l/acHlVKz8oVs/ye/s=; b=shjnb04Wp+U9stADSh2nIRhhEf
	F2YntaQW7GLOLSpc3IPbkGWBzdMnm9fkD9XgtkU5gIiP/ns1Q46I7Ie03JYlA6zAPbHwjB0iHwoN8
	NmfNHggtEgIokQ3/SxOq/AwegreXIF1tFEvBs6NbFKY4hv1s7hfdIx8O6GrisdAGG53x6Xlv6m2fP
	B6cgHdsCN2wYzhOpjLOszWzIrRc6OfJZbrWZ9Ib0jC23EQaQWA5NAZCj4ffVc0nIoJ4MKkGSMr4vt
	sVue+XfK1yupQEe+hSOBOTMEP5D4I/qVUXxPm7H+5Ltshw2FQZmngeAuG7/c8OiaqnQiIrttgAPgs
	kbwCo7zQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4GxV-0000000CuIw-1zIb;
	Tue, 07 May 2024 09:18:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2379C300362; Tue,  7 May 2024 11:18:01 +0200 (CEST)
Date: Tue, 7 May 2024 11:18:01 +0200
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
Subject: Re: [PATCH v2 10/54] KVM: x86: Extract x86_set_kvm_irq_handler()
 function
Message-ID: <20240507091801.GU40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-11-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-11-mizhang@google.com>

On Mon, May 06, 2024 at 05:29:35AM +0000, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
> KVM needs to register irq handler for POSTED_INTR_WAKEUP_VECTOR and
> KVM_GUEST_PMI_VECTOR, a common function x86_set_kvm_irq_handler() is
> extracted to reduce exports function and duplicated code.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> ---
>  arch/x86/include/asm/irq.h |  3 +--
>  arch/x86/kernel/irq.c      | 27 +++++++++++----------------
>  arch/x86/kvm/vmx/vmx.c     |  4 ++--
>  3 files changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
> index 2483f6ef5d4e..050a247b69b4 100644
> --- a/arch/x86/include/asm/irq.h
> +++ b/arch/x86/include/asm/irq.h
> @@ -30,8 +30,7 @@ struct irq_desc;
>  extern void fixup_irqs(void);
>  
>  #if IS_ENABLED(CONFIG_KVM)
> -extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
> -void kvm_set_guest_pmi_handler(void (*handler)(void));
> +void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void));
>  #endif
>  
>  extern void (*x86_platform_ipi_callback)(void);
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 22c10e5c50af..3ada69c50951 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -302,27 +302,22 @@ static void dummy_handler(void) {}
>  static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
>  static void (*kvm_guest_pmi_handler)(void) = dummy_handler;
>  
> -void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
> +void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
>  {
> -	if (handler)
> +	if (!handler)
> +		handler = dummy_handler;
> +
> +	if (vector == POSTED_INTR_WAKEUP_VECTOR)
>  		kvm_posted_intr_wakeup_handler = handler;
> -	else {
> -		kvm_posted_intr_wakeup_handler = dummy_handler;
> -		synchronize_rcu();
> -	}
> -}
> -EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
> -
> -void kvm_set_guest_pmi_handler(void (*handler)(void))
> -{
> -	if (handler) {
> +	else if (vector == KVM_GUEST_PMI_VECTOR)
>  		kvm_guest_pmi_handler = handler;
> -	} else {
> -		kvm_guest_pmi_handler = dummy_handler;
> +	else
> +		WARN_ON_ONCE(1);
> +
> +	if (handler == dummy_handler)
>  		synchronize_rcu();
> -	}
>  }
> -EXPORT_SYMBOL_GPL(kvm_set_guest_pmi_handler);
> +EXPORT_SYMBOL_GPL(x86_set_kvm_irq_handler);

Can't you just squash this into the previous patch? I mean, what's the
point of this back and forth?

> +void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
>  {
> +	if (!handler)
> +		handler = dummy_handler;
> +
> +	if (vector == POSTED_INTR_WAKEUP_VECTOR)
>  		kvm_posted_intr_wakeup_handler = handler;
> +	else if (vector == KVM_GUEST_PMI_VECTOR)
>  		kvm_guest_pmi_handler = handler;
> +	else
> +		WARN_ON_ONCE(1);
> +
> +	if (handler == dummy_handler)
>  		synchronize_rcu();
>  }
> +EXPORT_SYMBOL_GPL(x86_set_kvm_irq_handler);

So what about:

 x86_set_kvm_irq_handler(foo, handler1);
 x86_set_kvm_irq_handler(foo, handler2);

 ?

I'm fairly sure you either want to enforce a NULL<->handler transition,
or add some additional synchronize stuff.

Hmm?


