Return-Path: <kvm+bounces-66680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EACECDD5F0
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 07:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84D4D303D309
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 06:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C0B2DA750;
	Thu, 25 Dec 2025 06:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4dzvruN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAB213B7A3;
	Thu, 25 Dec 2025 06:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766644028; cv=none; b=svJMmRcSkLmIpzsucdTeV0+BHIE7j7LnDVS/FvGkQUJuD64ZaFdZUPJfwGhrV++fqBgYvTHJ5agPkCv4JlZZF6Hb5Rdgy14fWcVYgdqyu3rlh8IwphoOeF5O0blvczoIUv1KsB3fK72gGka9GnkzQw53q5kuQYqBDetFAZuDTJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766644028; c=relaxed/simple;
	bh=p1XfubM0YWj6WnMP8u+aCWSf2k0v8QcI9Wgv+fon5Ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bOPpssthunWgKo8FO9F1PkCw6oVFpKzpRrPDNKvEIAUhHh4QwTl0euQNdzFhSoQp8UXaQjfoyplm9SWS4FwsQG0dIBe4iYNOAcZDVOuffDBDQ+pdG6k+1xWDztJQMvj+zQNI1bgTPAaLvEzMjvkn5/S0tPiYfcbidlkX9PQonG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4dzvruN; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766644027; x=1798180027;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p1XfubM0YWj6WnMP8u+aCWSf2k0v8QcI9Wgv+fon5Ck=;
  b=E4dzvruNcXQE5dw9kyc+jRTBrmIE7QvS576jan+va5QuBsyRkHFlktZH
   vS/jnf6/P0u400jmA2rsbb2BQmmm2qun4SR/Xcsa79iHWj80++5q4vlVY
   LKhE+gXWjunWXMVTVyp5HlAFlMe6KxxmVMYU42qVkeWNEDxNUeAuPrK/F
   9/JZZhfCsAIv1FOKpt0qc53RNF+jHSoTLTBLNWwelZh8DMgTQFjje2r+a
   6cCb3dznAgHmk8riR5vVQZH4dMfne9Dey9KfneJg/RkABA1/qKC6rLnH8
   5BpiLgNRR4KWcJuxdFqdzXA1+moZ/16Jr51pec23Hvjhg9nbFNbDKoV17
   g==;
X-CSE-ConnectionGUID: /AgsTTqTRZCbVBdJhPrzBA==
X-CSE-MsgGUID: JWq67hiDS4OIqIjTpn9ujw==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="68340493"
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="68340493"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 22:27:06 -0800
X-CSE-ConnectionGUID: DUtRii2LTCeg4q7vXPJ1zA==
X-CSE-MsgGUID: a7dRTs5tS6S+a0BISdFYdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="200649863"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 22:26:59 -0800
Message-ID: <43d1cde6-2277-4f3c-8e7d-59e6edb2228a@linux.intel.com>
Date: Thu, 25 Dec 2025 14:26:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/44] KVM: x86/pmu: Snapshot host (i.e. perf's)
 reported PMU capabilities
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>,
 Sandipan Das <sandipan.das@amd.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-16-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 12/6/2025 8:16 AM, Sean Christopherson wrote:
> Take a snapshot of the unadulterated PMU capabilities provided by perf so
> that KVM can compare guest vPMU capabilities against hardware capabilities
> when determining whether or not to intercept PMU MSRs (and RDPMC).
>
> Reviewed-by: Sandipan Das <sandipan.das@amd.com>
> Tested-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 487ad19a236e..7c219305b61d 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -108,6 +108,8 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
>  	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
>  
> +	perf_get_x86_pmu_capability(&kvm_host_pmu);
> +
>  	/*
>  	 * Hybrid PMUs don't play nice with virtualization without careful
>  	 * configuration by userspace, and KVM's APIs for reporting supported

Hi Sean,

It looks a merging error here. We don't need this patch.

The original patch "51f34b1 ("KVM: x86/pmu: Snapshot host (i.e. perf's)
reported PMU capabilities")" had been merged into upstream and subsequently
we submitted a new patch "034417c1439a ("KVM: x86/pmu: Don't try to get
perf capabilities for hybrid CPUs")" to fix the warning introduced from
previous patch  "51f34b1 ("KVM: x86/pmu: Snapshot host (i.e. perf's)
reported PMU capabilities")". Thanks.

-Dapeng Mi



