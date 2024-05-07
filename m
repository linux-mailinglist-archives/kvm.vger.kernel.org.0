Return-Path: <kvm+bounces-16805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7434D8BDD34
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 306382846B6
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED8714D2A8;
	Tue,  7 May 2024 08:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kt76PVGU"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5327197;
	Tue,  7 May 2024 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715070959; cv=none; b=WUbuPftRMxnmZRliHd7s8YthKYsmZdrobiPu1TrXAo3/XQ0+GDto4z6bmeb9f8g/OQ0w7q+9XC/LFyWKdkfTX4SfrwSIX/wFOoZXWW7h4l7LIfTKsu/9tGqBt3TufnfzTy9qeroPo1PSDNk7iwYDBX5Q3KE+hO30e4Q8aef7Vds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715070959; c=relaxed/simple;
	bh=187h6QhehzgPuQwq5YOrfgctS4r9XhcRxlDEN4DzZuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJzblP6ELIBFBgYyi0fBYQHfFxxXYyGLRDvgxktSjdZMizamP/AtsH4fkLvBFNwgWOWzMj51OAcHkflvRlR3DulyJCZ+NIAXN+hHrTdjLUZf/XauzIigv2PRXtSgXl9e4RzIvT7+N6PjVtWyWJp1cvhPfQ3Tgqhm+q5feGOWhPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kt76PVGU; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eMOSmiPr7+fXT7b1/qb26SLQ7/HDimZf83JbehT1XAk=; b=kt76PVGU66UoeUZqjholmDoQrQ
	j0GvBB2pYHIi155XPvx5HpNvbmHitlurVgQzyYpDSKnef3nlZTAI2f1ebbqhonvyO3neyvjzxILqV
	9YCvXZR0X+i5UBnAqRx8wUJN3JLfoBuCdv2abDlTxek/4ehzYCms+84MyYSjg+hBZgrRvv9xlMw+C
	OegDbKS1/NYkjF83U/ZNm0mV8RVlz8W7NR+AkVGQvyPuW4Gu4T0kkCbAeAd3BF06o61l2g6gwiLwz
	Ao3I4icnb8qF/Mv0Aqdl81kenZ2PZZBoJtrkpNkk1bRk0qBT8YF8WMT9+TPJbgmrIwkeq/nGCbfLd
	32/aMjJw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4GEb-000000021LQ-3d1b;
	Tue, 07 May 2024 08:33:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6495D300362; Tue,  7 May 2024 10:31:33 +0200 (CEST)
Date: Tue, 7 May 2024 10:31:33 +0200
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
Subject: Re: [PATCH v2 06/54] perf: Support get/put passthrough PMU interfaces
Message-ID: <20240507083133.GQ40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-7-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-7-mizhang@google.com>

On Mon, May 06, 2024 at 05:29:31AM +0000, Mingwei Zhang wrote:


> +int perf_get_mediated_pmu(void)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&perf_mediated_pmu_mutex);
> +	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
> +		goto end;
> +
> +	if (atomic_read(&nr_include_guest_events)) {
> +		ret = -EBUSY;
> +		goto end;
> +	}
> +	refcount_set(&nr_mediated_pmu_vms, 1);
> +end:
> +	mutex_unlock(&perf_mediated_pmu_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);

Blergh... it seems I never got my perf guard patches merged :/, but
could we please write this like:

int perf_get_mediated_pmu(void)
{
	guard(mutex)(&perf_mediated_pmu_mutex);
	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
		return 0;

	if (atomic_read(&nr_include_guest_events))
		return -EBUSY;

	refcount_set(&nr_mediated_pmu_vms, 1);
	return 0;
}

And avoid adding more unlock goto thingies?

