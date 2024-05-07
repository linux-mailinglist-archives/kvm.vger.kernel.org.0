Return-Path: <kvm+bounces-16811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 443E18BDDED
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01CA328469A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6421A14E2CD;
	Tue,  7 May 2024 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k1NnmCQ1"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30E714D6EE;
	Tue,  7 May 2024 09:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073454; cv=none; b=SGDpdSU3Ego/wrWDtOoj6CdJ4cKjzybswnIGObCIGiqXARETjyWjiJPdB16qTIbOc5dNlcaQ9zRaYH4o53OPU+zcPAfexd0gYFNOkI3t4Cd7XgZvwUUkqKEPD7svGgtQFqN/WFAqb5ixmIF+oQ4K0/TeUAMD21ZvhkzDbBM02bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073454; c=relaxed/simple;
	bh=a32cyfvlMh4aEtGJPyoYnXKfJiwuax3qOmYvgqm+4vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8AMITMIn+H2rzK1JAi+yYUoW/wGA31tVlQZ1GaRUN+vyzSDnEx5o0JPWSEIX5iwmxl/8jXrHmw59P9GP1s7cwxq4k6EEjPHhsMA9O8wTlX1PaeqILC8IZeKhCIw4/VgZLxfhiIz90FpPjQF+E2cvchLy6FMj5GQmPJHLCmbtkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k1NnmCQ1; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WC0BBrqC68QBx6s1vgNdV1KecXC354L3Y91PyPKtWuE=; b=k1NnmCQ1ocduc+hYb7yDRcJxuM
	yQ1Q2CdW5mhhQ+8N3RQ++R+uw2TQohCYJn5j7EQolyYLA3JCJCkYdlJAxLi3qrV1y71503er4cOO7
	XXyMgthxYmpo/zd52MMYExurC88LYFy3M5pWiXkTEuizOtPVsM/V/88aNpbGl7Gi467IHwJzzCapm
	qaFcLBw2RQaeuIRMXcZeuNFq3c/9SwdeTUeO8PeMpdpgeBXKJrUzxi/X7OC7ytsL82VisnHY+Ka3h
	1h47AhorahXzuQHjFVOrazEV43lcV+yVRCpEaSrKFDeWLeqrf4uDaVovh6382V66heH9ww3zl1GkR
	lBSiwZjQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4GsY-000000022EK-3qjj;
	Tue, 07 May 2024 09:15:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0BD353006AB; Tue,  7 May 2024 11:12:52 +0200 (CEST)
Date: Tue, 7 May 2024 11:12:52 +0200
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
Subject: Re: [PATCH v2 09/54] perf: core/x86: Register a new vector for KVM
 GUEST PMI
Message-ID: <20240507091252.GT40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-10-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-10-mizhang@google.com>

On Mon, May 06, 2024 at 05:29:34AM +0000, Mingwei Zhang wrote:

> +void kvm_set_guest_pmi_handler(void (*handler)(void))
> +{
> +	if (handler) {
> +		kvm_guest_pmi_handler = handler;
> +	} else {
> +		kvm_guest_pmi_handler = dummy_handler;
> +		synchronize_rcu();
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_guest_pmi_handler);

Just for my edification, after synchronize_rcu() nobody should observe
the old handler, but what guarantees there's not still one running?

I'm thinking the fact that these handlers run with IRQs disabled, and
synchronize_rcu() also very much ensures all prior non-preempt sections
are complete?



