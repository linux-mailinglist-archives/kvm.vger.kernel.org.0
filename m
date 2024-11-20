Return-Path: <kvm+bounces-32124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34FD49D3338
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 06:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52D01B210E8
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 05:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A1215747D;
	Wed, 20 Nov 2024 05:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WUh/O97/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4231547FD;
	Wed, 20 Nov 2024 05:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732081491; cv=none; b=O2nUfhDyGxnwCc+KyUc9DL461U2OKuwYL7Ya5H4IMXJ+kzeAsMTQ9ZgtThaJl0RLsXmDT0PGxtAr2/mxpX55Xj/kvh1+f4L3lu1uomv/UbwbAckczIJrDjyRz6Xk8EsqC834UsghoV1ZcYUQAbGVY72qwODiyRxieN6faFyYgZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732081491; c=relaxed/simple;
	bh=PF16y9VHLFev4Gyj0Yke/7yUsO5wo/HEHeDwzp/q6io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ScdFg2HFMc9BRshQrNjAQ660g+MULPDQYRfk8K23G9TuTu+rTu/ahJyRqU+RMJa7Z5PFjkT8Su3oJ7ZnO3mbr3D6Qwq0VD8vbZBerQA+zQ8XlAv1uu9ITR1dgKL02p+R3CFtK0tr3YZhL13KEjiOjCwbpBAy1Lxkoy1KySF7p94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WUh/O97/; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732081490; x=1763617490;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PF16y9VHLFev4Gyj0Yke/7yUsO5wo/HEHeDwzp/q6io=;
  b=WUh/O97/wyqrip5oJaYkvPPqF0yPbVT8er/LaynRXlc5k9kDx9SHe5Vi
   biGtEKMFUgUpUkcF8XGkf6OnNMZo7bqeoxkrtea1fKa2Ko+0ExkdbACJ/
   ljA9YgTIu+310IyIhheh5qV4XipE7kSUBgp4l9nQ9g0aiPtK+EGHxgQL9
   WauGy34btvJaUoRBBEa7f/o4eYHceJ/hka3LWcqievbgAIYT86OgT26we
   KOvHBCVrFqRdIl3R1zq3spP1qQyn3OjWMBn5swiadM9sXzSKz7Y0G87jo
   SP/Idw26/2OeXeqLXiJOJYsnNg//DljVIetBJzj0zkLUUMM7/YyBD5ccI
   Q==;
X-CSE-ConnectionGUID: nB8RWtLJTu2m56r/WCCd2Q==
X-CSE-MsgGUID: YmL7cxTbQBu5SO8/ZzPyoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="57523347"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="57523347"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:44:48 -0800
X-CSE-ConnectionGUID: RGs8Xpi+QBCqDyKPuNnBsA==
X-CSE-MsgGUID: COpI/VZoQi6tvrwlqMcboA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="89791784"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:44:43 -0800
Message-ID: <e0e402d8-de8b-40fa-9d1f-270d8033d33c@linux.intel.com>
Date: Wed, 20 Nov 2024 13:44:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 24/58] KVM: x86/pmu: Introduce macro
 PMU_CAP_PERF_METRICS
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-25-mizhang@google.com> <ZzzE_z5x7D_trxnq@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzzE_z5x7D_trxnq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/20/2024 1:03 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>
>> Define macro PMU_CAP_PERF_METRICS to represent bit[15] of
>> MSR_IA32_PERF_CAPABILITIES MSR. This bit is used to represent whether
>> perf metrics feature is enabled.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/vmx/capabilities.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index 41a4533f9989..d8317552b634 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -22,6 +22,7 @@ extern int __read_mostly pt_mode;
>>  #define PT_MODE_HOST_GUEST	1
>>  
>>  #define PMU_CAP_FW_WRITES	(1ULL << 13)
>> +#define PMU_CAP_PERF_METRICS	BIT_ULL(15)
> BIT() should suffice.  The 1ULL used for FW_WRITES is unnecessary.  Speaking of
> which, can you update the other #defines while you're at it?  The mix of styles
> annoys me :-)
>
> #define PMU_CAP_FW_WRITES	BIT(13)
> #define PMU_CAP_PERF_METRICS	BIT(15)
> #define PMU_CAP_LBR_FMT		GENMASK(5, 0)

Sure.  Could we further move all these  PERF_CAPBILITIES macros into
arch/x86/include/asm/msr-index.h? I just found there are already some
PERF_CAPBILITIES macros defined in this file and it looks a better place to
define these macros.

#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
#define PERF_CAP_ARCH_REG              BIT_ULL(7)
#define PERF_CAP_PEBS_FORMAT           0xf00
#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)


>>  #define PMU_CAP_LBR_FMT		0x3f
>>  
>>  struct nested_vmx_msrs {
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

