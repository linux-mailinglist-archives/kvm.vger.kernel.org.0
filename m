Return-Path: <kvm+bounces-28792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE9C99D5C2
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE08D1F23258
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E4B1C7287;
	Mon, 14 Oct 2024 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EPhGIrRM"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED6F231C8A;
	Mon, 14 Oct 2024 17:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728927970; cv=none; b=kSx5AM/f1CxHQQV54JbBNShD3J45ymS9n03R4Qwzd70UU1OBgj8Ahm96sVzjx+YWQJO2v/a6K5TqcRBPclIFnOslZNMo7Ri+ZhwhonMvAgN/+rY5yDCuz+oiXAXTPqmX9o7mozhcfmZ93B2KyCWaJJgfkq+Q0sz2i9t77YIgxKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728927970; c=relaxed/simple;
	bh=vED9v2hLde1CKXeo6oSAvcJDNcienUzaeXKUufeKwn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXzCh5bin8uhcik+6O+dSf18jfes8d3rWTRp+PnsxprtTOdo4TcIwir4RCWsM9aGkaAZDLDNneFC8lyBN0Vuzm2X3XFLd4q4VZ5AAqgEL61+J+6o1zbiLXexfWOoK5JAKU3Xr/fHZuxRMR0eHHq/a2AHdO3z3Fmq1hpQ8oZ6tOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EPhGIrRM; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oc5ce6Iuua2zo7G2B72/r1kuUsbBkQ7NYoc7EKCZBH8=; b=EPhGIrRMtTySWnQRaSL1akxYDE
	SqCvCDXt5jBCE2ky652NCJoNGcCXrC+J+GU0VF9jLgX61+Z8oDYC2gynMdVhZpbozzyb0/u7Vh6hn
	qiFROHgNFnYJMgcxOVQ+IXlFIVfiUGDdHFAP0O152Ygg7NE/FGKqsHIHKnMAhEfFIeMf4WSNi4VpB
	9xVvM9wDx8ujrnqm4stn0dytvgGb1+ja6zRUa9v8eJckK6gWI/LrIHR84WbEiG+pap9GXbloRAK46
	1IOI4/5hVGTX/BPS0GH4QdaH1hJ36CnFHllb95JsBeAtSS2KOqFlen83Zt/dCtJf9h6gj497xbZl8
	U5GuzK0Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0P8n-00000006OW6-0ywV;
	Mon, 14 Oct 2024 17:45:57 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D36BE3004AF; Mon, 14 Oct 2024 19:45:56 +0200 (CEST)
Date: Mon, 14 Oct 2024 19:45:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
Message-ID: <20241014174556.GJ16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
 <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
 <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
 <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>
 <20241014115903.GF16066@noisy.programming.kicks-ass.net>
 <c4d61d85-fb4f-40c4-8400-4a5b907c79a7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d61d85-fb4f-40c4-8400-4a5b907c79a7@linux.intel.com>

On Mon, Oct 14, 2024 at 12:15:11PM -0400, Liang, Kan wrote:
> 
> 
> On 2024-10-14 7:59 a.m., Peter Zijlstra wrote:
> > On Mon, Sep 23, 2024 at 08:49:17PM +0200, Mingwei Zhang wrote:
> > 
> >> The original implementation is by design having a terrible performance
> >> overhead, ie., every PMU context switch at runtime requires a SRCU
> >> lock pair and pmu list traversal. To reduce the overhead, we put
> >> "passthrough" pmus in the front of the list and quickly exit the pmu
> >> traversal when we just pass the last "passthrough" pmu.
> > 
> > What was the expensive bit? The SRCU memory barrier or the list
> > iteration? How long is that list really?
> 
> Both. But I don't think there is any performance data.
> 
> The length of the list could vary on different platforms. For a modern
> server, there could be hundreds of PMUs from uncore PMUs, CXL PMUs,
> IOMMU PMUs, PMUs of accelerator devices and PMUs from all kinds of
> devices. The number could keep increasing with more and more devices
> supporting the PMU capability.
> 
> Two methods were considered.
> - One is to add a global variable to track the "passthrough" pmu. The
> idea assumes that there is only one "passthrough" pmu that requires the
> switch, and the situation will not be changed in the near feature.
> So the SRCU memory barrier and the list iteration can be avoided.
> It's implemented in the patch
> 
> - The other one is always put the "passthrough" pmus in the front of the
> list. So the unnecessary list iteration can be avoided. It does nothing
> for the SRCU lock pair.

PaulMck has patches that introduce srcu_read_lock_lite(), which would
avoid the smp_mb() in most cases.

  https://lkml.kernel.org/r/20241011173931.2050422-6-paulmck@kernel.org

We can also keep a second list, just for the passthrough pmus. A bit
like sched_cb_list.

