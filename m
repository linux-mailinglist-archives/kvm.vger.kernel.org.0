Return-Path: <kvm+bounces-54786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C585AB28058
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8ADFAA19FE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 13:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0DC2E36EF;
	Fri, 15 Aug 2025 13:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZKKP5mMs"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9529AB18;
	Fri, 15 Aug 2025 13:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755263088; cv=none; b=JRrjDzu456TNV2eQM8UnVRbF+GvwK22UW/RRVpZNJbZIHEQYh+QtC2Wpn49uv7r/ISN9M9C4fIPzrXI8NXGYxRbO+GSKFZhLuO9GwvRtz+HwJcJHi5LWH10KwsOjG67oLM3oue16F8laNODODp3lygLTCmVDeLkSwPdcET4gUpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755263088; c=relaxed/simple;
	bh=WSLKKBF+CKIpEZOxuJC+jWHJV147Q9/yBQM5aB8ofh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p28PiC0UxKfsUxcBiLu5E5KmBIc/VkGcN83o9dLLropLk83JMTCROQls2iszOZLxikyRDgcJSzm05qq6yuYh65pVkuSfsRlOj7cLFZC5FE/Ky03CA8msg4cAu/1iMWlnG2z1K7fme52vMS2ilfN6tnPnEwXhNIU6FioP6270wRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZKKP5mMs; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Io7/GXj4Ah5f6/agCZ8UGExu5metz9Q7I/7GBoA/u94=; b=ZKKP5mMs2Zxf5m/v7uHZhDFsiX
	mp1GPKzLskGtDNbZrpBQ2yosQFTOZGFfxIhWK0w/s0KnIWcJMkl7XNy49lpeRsAThdqmQBZzJw2OU
	kFPVd0P7sSrjifBauCNhsIXqwJEKmMQD1S2cJp0lx1/GqizN0Huj77A6AnE20Z7oSdQY87jPYDsqT
	DRL06FaFojcPXdDQ1/ptaokHnsT3TLYWiP88zJpJeZwRIJBny6Xf9T4vXgE8R7j3tOf36Z1/bUCpH
	HBGUYwGq38df2bvnMtLj9UfwM882Yb0FJeLhwAKCV4uIaq3dAayrRxEsDRjBFuhrQZRAYkC8SqPdY
	NwyK31Lg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umu6n-0000000GiIQ-386b;
	Fri, 15 Aug 2025 13:04:38 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7C219300310; Fri, 15 Aug 2025 15:04:36 +0200 (CEST)
Date: Fri, 15 Aug 2025 15:04:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Kan Liang <kan.liang@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
Message-ID: <20250815130436.GA3289052@noisy.programming.kicks-ass.net>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806195706.1650976-10-seanjc@google.com>

On Wed, Aug 06, 2025 at 12:56:31PM -0700, Sean Christopherson wrote:

> @@ -2727,6 +2739,21 @@ static struct pmu pmu = {
>  	.filter			= x86_pmu_filter,
>  };
>  
> +void arch_perf_load_guest_context(unsigned long data)
> +{
> +	u32 masked = data & APIC_LVT_MASKED;
> +
> +	apic_write(APIC_LVTPC,
> +		   APIC_DM_FIXED | PERF_GUEST_MEDIATED_PMI_VECTOR | masked);
> +	this_cpu_write(x86_guest_ctx_loaded, true);
> +}

I'm further confused, why would this ever be masked?

