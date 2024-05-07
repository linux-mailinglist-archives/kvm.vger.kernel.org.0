Return-Path: <kvm+bounces-16929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF5178BEEEC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 23:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F105B214F8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 21:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F6077658;
	Tue,  7 May 2024 21:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BshdbJqD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEBD847C;
	Tue,  7 May 2024 21:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715118018; cv=none; b=YHq5nyIO+K6tt6posKZppl9ZXhJzZcWos9chgwhz0BnOOaXTR+t9WyHKP6+1xJzZAAiZRNtWdqUyaGBXdCmlvJFWH5DAG9hgzN54P1IOlEhxr66KOSwVk2M4wscCs9mjRcPM5IGFII7saTTYIuwBMPOp2tHI5bbNXdEgp9j0D7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715118018; c=relaxed/simple;
	bh=D20Hto0XD3UdbZ9eo8sqaEakAD3D3xJxtg30AyqFdL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DjH/za2SIIoM3/QL4NbHUCbl0yCu/GrOqV/6lkyGd71rtDqUS22Dw8xXx9N6cE67ufLCTUDPxf4mU3+5a63uhfNpburEcc3d3gIhYMOsce58PQGhBIpVV1j9O05XpYy8eMGXUJKfyw8+u62nm24F0Mk0yWbwU0OuX4+pwrH2Q2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BshdbJqD; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715118017; x=1746654017;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D20Hto0XD3UdbZ9eo8sqaEakAD3D3xJxtg30AyqFdL4=;
  b=BshdbJqDXXR0GD0Bj9FIKK91wayjDS2HfsDNE7OZyCi/YkUZT+kSrldE
   U9Fjz5tfOO+kGBsxRFDXZszeguPEM0t7wSTxqUPGDBqjnp9OeWTiH60VQ
   VrcVFOtC+Mg7IirHuzkw1sNNVNF6Np4pGcDzgvIUvGwCRVVY7h/GcY8Gq
   H6ATk29sku2gRkchfcPMpBMb3ja/zgGNtb1hQ6Y26YIBN6AVkUxX6QZKa
   qSPWEUSusZKCFzz4vxZbhbAEcqZxw2g+mqwmtxVLM18bTGYXy9pCClJPq
   hXYwMPxvcOQGvPIYl5rZrp8+KORameXH6Sn/4DNrwgDtHy+/OqjrTXGDn
   g==;
X-CSE-ConnectionGUID: c/SNDqcCRau9M/LgO6szDA==
X-CSE-MsgGUID: YVlPe/SFQZmQoJguj2IsmA==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11075454"
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="11075454"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 14:40:16 -0700
X-CSE-ConnectionGUID: jkXc046ETtetd+nqogpjcA==
X-CSE-MsgGUID: CqxJUta2QbmxYjSKhZFigQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="29190963"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.59]) ([10.24.10.59])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 14:40:16 -0700
Message-ID: <f49ebe98-c190-4767-bb0d-471776484fc8@intel.com>
Date: Tue, 7 May 2024 14:40:15 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI
 handler
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-13-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240506053020.3911940-13-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
> Add x86 specific function to switch PMI handler since passthrough PMU and host
> PMU use different interrupt vectors.
> 
> x86_perf_guest_enter() switch PMU vector from NMI to KVM_GUEST_PMI_VECTOR,
> and guest LVTPC_MASK value should be reflected onto HW to indicate whether
> guest has cleared LVTPC_MASK or not, so guest lvt_pc is passed as parameter.
> 
> x86_perf_guest_exit() switch PMU vector from KVM_GUEST_PMI_VECTOR to NMI.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/events/core.c            | 17 +++++++++++++++++
>  arch/x86/include/asm/perf_event.h |  3 +++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 09050641ce5d..8167f2230d3a 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -701,6 +701,23 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
>  }
>  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>  
> +void x86_perf_guest_enter(u32 guest_lvtpc)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
> +			       (guest_lvtpc & APIC_LVT_MASKED));

If CONFIG_KVM is not defined, KVM_GUEST_PMI_VECTOR is not available and
it causes compiling error.

