Return-Path: <kvm+bounces-28739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 795D499C7C7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 12:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA46BB235FB
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 10:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FE51A38D3;
	Mon, 14 Oct 2024 10:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q3zcjKYW"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9795C195811;
	Mon, 14 Oct 2024 10:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903320; cv=none; b=NxwA2RxXYYWSNW3KgPSoHaXBfNlhnYGvuIa+ssLScwgrPU/F4ffVujn+nibSKWF38nzVFF+u7pArzqHJxrMbkp6yxCZMspnmyZqGG4YC2YRpFpXvx1U8dMSQqnjmgjjuOf8pBYEBXX96dXHP7hnfUc1d4cUk1jo2G7m98oXyLI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903320; c=relaxed/simple;
	bh=Wv8sheBY9wyuuQECNz9jMXKquIBWVGBbSPFlBvDzmdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdwHJbcGGL372SSPbncY3dvq7/SXjFlR5YIdbq2ZZlpR3ZTQ+mKvdSVN47H8d4lUdkIfwZjayN/lmS9lvn8x5VtLJ3veJNQFf14fCDRlz1eMCtSflYsReSwkKk9/eK9m15umKTLaGMgmFCfhpf4pOfI0uyKIMDQV/T04fpUB3gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q3zcjKYW; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w3x6GHag03/bv+m3o3GPI6JrLsYF4G1ACh00ZNPF3aY=; b=q3zcjKYWTFQ3YOrbR+FNOvIptJ
	KGzYRKIyJbp/0zDclGmpW37bvjmpP9G/XzayP9wgQ1bqTWayG+H/H5MY4n+8fN7VOD2LUQ+4c3dQ+
	tAPHVsDpMzXjjZ1Muj+K87+Sf6PFcgTomQS9YNCAwXavAB3LLKLJSWRxo4VWqCdrWf3X5WazbxAw8
	H9x/hkgXd4KanqnjbBa6gh9o1Yv8XDRG2pF7Kc0lp5YlGHdGqDC8urAgdHOQlnqFQedwgvT+ws+SP
	gqtSTyRP0sAvdrZHyDAl8fT65rprX9OY93Xr7/jjqRAykF9DwAsv1Q9MUhexFUnjSA87Q8gigDU42
	jke87rDw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0IjB-00000006JqI-3HlN;
	Mon, 14 Oct 2024 10:55:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0CB2A30015F; Mon, 14 Oct 2024 12:55:05 +0200 (CEST)
Date: Mon, 14 Oct 2024 12:55:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@linux.intel.com>
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
	Like Xu <like.xu.linux@gmail.com>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
Message-ID: <20241014105504.GB16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
 <20241011184237.GQ17263@noisy.programming.kicks-ass.net>
 <a3326ee7-5ff0-4745-9e33-3ed5eec94c24@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3326ee7-5ff0-4745-9e33-3ed5eec94c24@linux.intel.com>

On Fri, Oct 11, 2024 at 03:49:44PM -0400, Liang, Kan wrote:
> 
> 
> On 2024-10-11 2:42 p.m., Peter Zijlstra wrote:
> > 
> > Can you rework this one along these lines?
> 
> Sure.

Thanks!

