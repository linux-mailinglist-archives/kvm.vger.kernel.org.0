Return-Path: <kvm+bounces-54896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD483B2ADDA
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 18:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B88D3BD5BC
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 16:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E0733A02B;
	Mon, 18 Aug 2025 16:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bwEc88ku"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93562278146;
	Mon, 18 Aug 2025 16:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755533544; cv=none; b=N7MdopQ93NHrWR9USgWpOwpGCYONSAs00DaH/m2vrgtTjgqnmHQ5N26pzuVubXsVOxkjJQ8XFvo4wWX1gFiNqZ2Cw3HJMR6fqGSAgvJmLsUAkELaS7N7dP+gJMQZwRqw1krFWYxuKKXqKhq+u7u1WF2dXOFFmSVDMd/h1QvpX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755533544; c=relaxed/simple;
	bh=0KlOKuDfOUdk5ngaWQoAWmJ0VU24ir66fy6JVhYV5wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8bENesrk8fvnY5ZrXgxxu8jcUj5jQH6VwPcjZNvgxrtSiV8EQKJBPeu6nWPGpDzQk6LuGsnn6KMak/+BH1chGv/HbKeKjclcHb62uawrbJ+4QJZj1Dgyool5htm6s/YZ+cz1uoIfLdhBTSaxM69VMuGa+L50fP98SoviNz6TuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bwEc88ku; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KmfCSi8O/XddsGKdRcKOqeDj7Pe6vE7Gax1joOuFhh4=; b=bwEc88kumrWiUkBPFis3R2xC8x
	1VSU964ojxy4pizILXyaiupvjmCF+9S/j3hMn/7+0O6Nq5XCPfRh9SWhm98h0t2UFUjmA1dzWRZgt
	tbkFmQuB/mZqY6ky3oZFaXzKbsxU61JtKuUNYn7rd7psdx+2eesyLw8rFRzpJQ1Win9JV+gpfxIJX
	B0ERXsVVo7c2wl1HSeiIdqRZ4++3ImaZyhHbocKrxLR1Y5j1GlmqWCDYwxZ0RlMOOcuzzqa8ePrTH
	qkSXaxaLa6fA1jK8eqoW/9WZ9mA8to8qlNfcQ4735MGvUb9ThF8/IOfNGNvoRXzwQSiekxnBpg4fR
	SmVuRZ6Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uo2Sx-0000000HRhy-0oaa;
	Mon, 18 Aug 2025 16:12:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7731030029B; Mon, 18 Aug 2025 18:12:10 +0200 (CEST)
Date: Mon, 18 Aug 2025 18:12:10 +0200
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
Message-ID: <20250818161210.GJ3289052@noisy.programming.kicks-ass.net>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
 <aJ9VQH87ytkWf1dH@google.com>
 <aJ9YbZTJAg66IiVh@google.com>
 <20250818143204.GH3289052@noisy.programming.kicks-ass.net>
 <aKNF7jc4qr9ab-Es@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKNF7jc4qr9ab-Es@google.com>

On Mon, Aug 18, 2025 at 08:25:34AM -0700, Sean Christopherson wrote:

> > OK, so *IF* doing the VM-exit during PMI is sound, this is something
> > that needs a comment somewhere. 
> 
> I'm a bit lost here.  Are you essentially asking if it's ok to take a VM-Exit
> while the guest is handling a PMI?  If so, that _has_ to work, because there are
> myriad things that can/will trigger a VM-Exit at any point while the guest is
> active.

Yes, that's what I'm asking. Why is this VM-exit during PMI nonsense not
subject to the same failures that mandates the mid/late PMI ACK.

And yes, I realize this needs to work. But so far I'm not sure I
understand why that is a safe thing to do.

Like I wrote, I suspect writing all the PMU MSRs serializes things
sufficiently, but if that is the case, that needs to be explicitly
mentioned. Because that also doesn't explain why we needs mid-ack
instead of late-ack on ADL e-cores for instance.

Could it perhaps be that we don't let the guests do PEBS because DS
doesn't virtualize? And thus we don't have the malformed PEBS record?

