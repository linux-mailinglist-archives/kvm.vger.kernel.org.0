Return-Path: <kvm+bounces-28758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0483D99C99C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35C9A1C22555
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B091A01C5;
	Mon, 14 Oct 2024 11:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lkrit7np"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4CB19E7E3;
	Mon, 14 Oct 2024 11:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728907153; cv=none; b=Spubp06QAkphqfmaboT6hMKUznZXCnnTswQSURCRD9nw8uiYKggD3bjAAy1rNsGWQvEq24SodXfZ//xfAuPc7QuuWEvx1yk+aJXz4pWabuFYik+LLiFlW8hYzBihmDE/4gw1zucfA36Z/3ax6pB3hOniPAlaA2pu6DJI+m5xm+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728907153; c=relaxed/simple;
	bh=QqO0oKLuKz0VKSfEeNa8chkl5KP/vdMO7xeRMAEx8YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dE8N4ziBX1AWVCRq5INmEqBPNTwlDMY6Kx+4Yatz7Me5EH54Fltyyk3wvyf5tpklsHS7YTqKm/6tW2hvm82GMVSmrXH2NGYqyZL9+SvSq6XzHjQudXeF1LX/g6LTZvLny28MAbu4pDHOnBxd/slzsAh4S0itg1urIPtbp4C7CVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lkrit7np; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QqO0oKLuKz0VKSfEeNa8chkl5KP/vdMO7xeRMAEx8YI=; b=lkrit7np/ZqM00raUxCKUDNE6Y
	FIBHRbCvFM0mEHm6XNjkk0mEmxcHvLPXu1wh5zvw4NVaFAbAVUj/Ldo1oyUJm6foKrdrsRKoYWlzC
	7+3Olquy8TRvZ7evlpv1j7/Pgf7o2ihoVKaxbo45XyuUx+jNIxBvFjh2aJiT8FeulfWNIGXByeH8Y
	/CZvLMRyJKgmyqBmWBNEQL9m/BcHP5UZPKkpHIGzFEHfYKb6sJztcEW735A/PUU7Fk3+isSWyYo/f
	gE86DZnHNoWmjLuBW0WYnigW3HODSePJmcA7Rsuu0hwvSQzG724azuLwJVrGaDTdm1ca0aeFs0Z42
	vGkkEXXQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0Jj6-00000006Kqk-0ojI;
	Mon, 14 Oct 2024 11:59:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6CC96300777; Mon, 14 Oct 2024 13:59:03 +0200 (CEST)
Date: Mon, 14 Oct 2024 13:59:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mingwei Zhang <mizhang@google.com>
Cc: Manali Shukla <manali.shukla@amd.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
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
Message-ID: <20241014115903.GF16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
 <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
 <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
 <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>

On Mon, Sep 23, 2024 at 08:49:17PM +0200, Mingwei Zhang wrote:

> The original implementation is by design having a terrible performance
> overhead, ie., every PMU context switch at runtime requires a SRCU
> lock pair and pmu list traversal. To reduce the overhead, we put
> "passthrough" pmus in the front of the list and quickly exit the pmu
> traversal when we just pass the last "passthrough" pmu.

What was the expensive bit? The SRCU memory barrier or the list
iteration? How long is that list really?


