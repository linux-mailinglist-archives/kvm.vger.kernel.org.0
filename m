Return-Path: <kvm+bounces-16988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 289658BF894
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABDAAB238D9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E32535D1;
	Wed,  8 May 2024 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O/pSF5l5"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10601DA53;
	Wed,  8 May 2024 08:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715157193; cv=none; b=H1iSZ33NzzHntGEGKBLdNXe7B2vZKExHvSuzKpjKpVGetHY89GEVPi/BGaBoi4p+Vo9laiPad1RVdZzKIt87wgHG47iZqjdY52ZSiNI3c+DrUx6eqiVTDPXYalTlb6UMDLJqZ9KbVcOUEz7rKvpjq+EsW452hoBb/kbL+udNAUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715157193; c=relaxed/simple;
	bh=IOtm/3CFrf/lpFlrDixYfk0QvdGnjLEun/oMf+afvDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddhO2wS1GMCOXZyrgBDztWR/z28jdlQS0aBqZzgaFQbz16aH4JU7H311yNq6vLMHgNFMrFXGdtZsRbqQPqeTF4zH6eS8PSnAk9on6PUIEMOtFyeO0lXf53xs+KBr9mEYw6zTSzX5EJ9kmkKRkAA34EeR2ekYe0reQsbqp111B1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O/pSF5l5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aUmeF8yoG8SvraYHh4Yuzha1l7+rfhoucyceYu0Ccak=; b=O/pSF5l5r1ElhIhyxzfxf/Inqx
	fCW5VHzKaj4GsfQIsZyT5UADbu1OvlnovRoQbPRQu70JCvajNIfRYAgoq1ltTENJcZbP3PWi8LUa/
	9HfBpGJuC9nvLVXpGljwS9A48vQWV/TXxBXG3gkzX5RGzD51n8XuMSCEG2NdvZh22UBwt8DDvPt+u
	dWao3n1xvdBHAIGA6/XT77KctjRS15giBcVdON2c0nlmvzUyti41RQ000U7fqfwDWJLcbGahUWBuw
	YePhKQ/yCqrwk8dJLwBMHeQPV3Ajl3CoFEE6wKeDyXe+PtxhjRqg0VohSouJjYRTsXdzwxbcvnLCO
	cM/kaHDw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4cjL-0000000FGKF-1eps;
	Wed, 08 May 2024 08:32:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0CECF3002AF; Wed,  8 May 2024 10:32:51 +0200 (CEST)
Date: Wed, 8 May 2024 10:32:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
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
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 06/54] perf: Support get/put passthrough PMU interfaces
Message-ID: <20240508083250.GG30852@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-7-mizhang@google.com>
 <20240507084113.GR40213@noisy.programming.kicks-ass.net>
 <f04e33c3-9da8-4372-bc21-ee68c00ac289@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f04e33c3-9da8-4372-bc21-ee68c00ac289@linux.intel.com>

On Wed, May 08, 2024 at 12:54:31PM +0800, Zhang, Xiong Y wrote:
> On 5/7/2024 4:41 PM, Peter Zijlstra wrote:
> > On Mon, May 06, 2024 at 05:29:31AM +0000, Mingwei Zhang wrote:

> >> +void perf_put_mediated_pmu(void)
> >> +{
> >> +	if (!refcount_dec_not_one(&nr_mediated_pmu_vms))
> >> +		refcount_set(&nr_mediated_pmu_vms, 0);
> > 
> > I'm sorry, but this made the WTF'o'meter go 'ding'.
> > 
> > Isn't that simply refcount_dec() ?
> when nr_mediated_pmu_vms is 1, refcount_dec(&nr_mediated_pmu_vms) has an
> error and call trace: refcount_t: decrement hit 0; leaking memory.
> 
> Similar when nr_mediated_pmu_vms is 0, refcount_inc(&nr_mediated_pmu_vms)
> has an error and call trace also: refcount_t: addition on 0; use_after_free.
> 
> it seems refcount_set() should be used to set 1 or 0 to refcount_t.

Ah, yes, you need refcount_dec_and_test() in order to free. But if this
is the case, then you simply shouldn't be using refcount.


