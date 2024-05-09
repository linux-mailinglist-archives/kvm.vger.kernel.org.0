Return-Path: <kvm+bounces-17076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2659C8C0891
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 02:43:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6BF3283035
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 00:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06B325575;
	Thu,  9 May 2024 00:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ELcBKb+o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70B92556F;
	Thu,  9 May 2024 00:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715215429; cv=none; b=M/62zgjvo4G7E5LrAM1ZUSNRsbuCVzurdbVy59e3+SjxcRtx75WmWIKfyJUmGQdSjpIC9ptJdhrRA9b7c4BeVRtlYZAwr8PeiXtxTfb1lkjldKn7oaHAcXTqU7j/j3dA3RPPpucn7R+x1k9aN0yhVTShAoCp5UJmjUmFJvDmQS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715215429; c=relaxed/simple;
	bh=in5v/ZrobJpfxZcspwLC9z3aIjA3Y0ZLL29j3K9SoIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V2JNdRUG67mwUAHXHcpU2SkFiojgO6yp6aGmO8CEY4lioHMnNP049V9zX7BgkKz1mVD5QNiP991FBFITVMv89EUq9+O1Mri5H1mjVO7iNOFw5r2m4mt+iPCf17fkufB3L/sKOWucqa2Gq+yv497nXu0ykbmnh1nOlLUjLme5xNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ELcBKb+o; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715215428; x=1746751428;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=in5v/ZrobJpfxZcspwLC9z3aIjA3Y0ZLL29j3K9SoIY=;
  b=ELcBKb+oqT0mZt1dzIOWpO4aydEpQ+1/qPiYeWc0G8VUYOVpx5o6umMN
   k1XfxUzvOXmyw8zk7IeYgvv277l49Z46KIx/7iByQ8Zl/ePhDZVVNjv6P
   /yla9pvtWuWL8x/SkXYJdpRMWyW836Lt+eqCr0ktIPQHe6bz8f0/SsAWw
   mr4gpQ8M8yrNPnOGSc9cm2Y46t/+kCkP9B5gzneXj+MimmwMGL1nPpEbb
   FxdcCPbyl3Qt8UzS6cGbdRj9tUz2S2DsEB9N5whtgatUed5Qwbp79dKtr
   +Ytli0O5Upq2iB3zh6/WB0u9HwuNzjVTV4rqTK++XrYwRmf0D1HdXy++a
   Q==;
X-CSE-ConnectionGUID: M/+Ao8qqSsm8UtwijIsM+g==
X-CSE-MsgGUID: 275CspQAQRqTqqqu+lPIJA==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="14916311"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="14916311"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 17:43:46 -0700
X-CSE-ConnectionGUID: 59sv42ZETmWO9vs3nRHvlA==
X-CSE-MsgGUID: 8eY1/QrjSWq5qf/DKGfVxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="29021025"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 17:43:41 -0700
Message-ID: <9b93c6bb-0182-4729-a935-2c05f1160a73@linux.intel.com>
Date: Thu, 9 May 2024 08:43:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/54] KVM: x86/pmu: Avoid legacy vPMU code when
 accessing global_ctrl in passthrough vPMU
To: "Chen, Zide" <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-27-mizhang@google.com>
 <d19e06e7-ed97-4361-a628-014e5670cf22@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <d19e06e7-ed97-4361-a628-014e5670cf22@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/9/2024 5:48 AM, Chen, Zide wrote:
>
> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
>> Avoid calling into legacy/emulated vPMU logic such as reprogram_counters()
>> when passthrough vPMU is enabled. Note that even when passthrough vPMU is
>> enabled, global_ctrl may still be intercepted if guest VM only sees a
>> subset of the counters.
>>
>> Suggested-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/pmu.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index bd94f2d67f5c..e9047051489e 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -713,7 +713,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  		if (pmu->global_ctrl != data) {
>>  			diff = pmu->global_ctrl ^ data;
>>  			pmu->global_ctrl = data;
>> -			reprogram_counters(pmu, diff);
>> +			if (!is_passthrough_pmu_enabled(vcpu))
>> +				reprogram_counters(pmu, diff);
> Since in [PATCH 44/54], reprogram_counters() is effectively skipped in
> the passthrough case, is this patch still needed?
Zide, reprogram_counters() and reprogram_counter() are two different
helpers. Both they need to be skipped in passthrough mode.
>
>>  		}
>>  		break;
>>  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:

