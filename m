Return-Path: <kvm+bounces-65504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F19CAD063
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 12:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E419B305058A
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 11:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A42D2EB87B;
	Mon,  8 Dec 2025 11:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oZb0VXak"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5C22D877E;
	Mon,  8 Dec 2025 11:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765194727; cv=none; b=khswgB7HOKlFKhfZcSZdpphrEBmJQ4/Y1R0me+WxJsqHbxLsOLqo/qW/UXeGklDHbhllkDYnx+j9zfqDxQ7qoc+sxyacaLJsYMD48j5qagFZLFESVvRizMJWX/VSnLcy2jLK32w4q6T+3PcV0s06mTNRDlzKy/HShff3dzxF2bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765194727; c=relaxed/simple;
	bh=4FADccRZqPbzotcTGTpPdhOrIlxkICNwS3BZDu1/VH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bv1y+ZU06+szdkaEiAIRdE3wYdjHbDuEy2+S0JjIf9EEn1IT5ejWzFon7e0CP7ZisgL9BlqoI0UMJ/hyqceWPq4xuPhn4VPf+gKTe/rA2xohQ6hqto2Qu0aPhhgYo6o5IDOOuD9HpiAmK4IHE/FeMPcjQJzNp+3rOfk7T4VtaeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oZb0VXak; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iPXwGwvEAAx1QdhY0az6JjqaxPOleQ46LMOtvOvZTJE=; b=oZb0VXakegLWXQ5mbsFuowE7GM
	DV34MR9DukwCZjUTx8pB/UtWn7yzdSsZgCfI8rfgihkL7mKaA5tuiBmo0kHZPfq/dZnSFY0+kEqUe
	cAU+NExfBqZ3SLOaQJDsBd6kgaHEESbSKU0TPNvPiH3GDJohzU9/m0PDPAJNrujeN0rF4ZmLFAgL4
	O0rhb5HB06eAuj11P/DfJQ9tH1k3SPKG9S6ZfQUHHo41QlumJOsPf6iWl1NCDUFvGfYVaQzogMQAM
	q+J+KTnlnUaPGrJ0IJhvALjg9pQPoLk/z4TcES7CdMXs3ExRkhx9iI2dyI5Nj9+GcqpObncERbfnL
	s8qIDapg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSZmX-00000009jjc-1PBF;
	Mon, 08 Dec 2025 11:51:57 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6040D30301A; Mon, 08 Dec 2025 12:51:56 +0100 (CET)
Date: Mon, 8 Dec 2025 12:51:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
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
	Mingwei Zhang <mizhang@google.com>,
	Xudong Hao <xudong.hao@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v6 04/44] perf: Add APIs to create/release mediated guest
 vPMUs
Message-ID: <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206001720.468579-5-seanjc@google.com>

On Fri, Dec 05, 2025 at 04:16:40PM -0800, Sean Christopherson wrote:

> +static atomic_t nr_include_guest_events __read_mostly;
> +
> +static atomic_t nr_mediated_pmu_vms __read_mostly;
> +static DEFINE_MUTEX(perf_mediated_pmu_mutex);

> +static int mediated_pmu_account_event(struct perf_event *event)
> +{
> +	if (!is_include_guest_event(event))
> +		return 0;
> +
> +	guard(mutex)(&perf_mediated_pmu_mutex);
> +
> +	if (atomic_read(&nr_mediated_pmu_vms))
> +		return -EOPNOTSUPP;
> +
> +	atomic_inc(&nr_include_guest_events);
> +	return 0;
> +}
> +
> +static void mediated_pmu_unaccount_event(struct perf_event *event)
> +{
> +	if (!is_include_guest_event(event))
> +		return;
> +
> +	atomic_dec(&nr_include_guest_events);
> +}

> +int perf_create_mediated_pmu(void)
> +{
> +	guard(mutex)(&perf_mediated_pmu_mutex);
> +	if (atomic_inc_not_zero(&nr_mediated_pmu_vms))
> +		return 0;
> +
> +	if (atomic_read(&nr_include_guest_events))
> +		return -EBUSY;
> +
> +	atomic_inc(&nr_mediated_pmu_vms);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(perf_create_mediated_pmu);
> +
> +void perf_release_mediated_pmu(void)
> +{
> +	if (WARN_ON_ONCE(!atomic_read(&nr_mediated_pmu_vms)))
> +		return;
> +
> +	atomic_dec(&nr_mediated_pmu_vms);
> +}
> +EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);

These two things are supposed to be symmetric, but are implemented
differently; what gives?

That is, should not both have the general shape:

	if (atomic_inc_not_zero(&A))
		return 0;

	guard(mutex)(&lock);

	if (atomic_read(&B))
		return -EBUSY;

	atomic_inc(&A);
	return 0;

Similarly, I would imagine both release variants to have the underflow
warn on like:

	if (WARN_ON_ONCE(!atomic_read(&A)))
		return;

	atomic_dec(&A);

Hmm?

Also, EXPORT_SYMBOL_FOR_KVM() ?

I can make these edits when applying, if/when we get to applying. Let me
continue reading.


