Return-Path: <kvm+bounces-64459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 70863C835F9
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E61A54E563C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 05:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B54285071;
	Tue, 25 Nov 2025 05:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1ysJge4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83962940D;
	Tue, 25 Nov 2025 05:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764046979; cv=none; b=g2ipCkDaZpaTWgM0ztlxCxTFOZUh+lZU+MzsDki8STgqXBnYMhQqkpTRiAihvvfDuoa+qR0duSNYZHl0KarQfZAGTXjfXjjRRcXkA/QII09wm6Qz3qckZ9Kx2xrVGig/uYTb0Qko2dic1KZt/9BFXGnq+7q2O7k1jh8vBEc2k3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764046979; c=relaxed/simple;
	bh=CxuoyWDMjnvPVlANis+bdBxUp4A0mu3YzVIP24vTdmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=E6FuE5AFGKoA5CwA0W9CgXJZ16yXCJeshNX5imyC8qFtEoWD90omVN2Wl7hK7oqP4uFxu9IklHryFuPuuqP1vvnmnKrua7D4u5YwpRn7WKAYt+PfWx/NpKRSYYvVdTvY8j7rJxoTUBxjtXYj6pczDuJZo7IMAF+5XdzS0HZywlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1ysJge4; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764046977; x=1795582977;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=CxuoyWDMjnvPVlANis+bdBxUp4A0mu3YzVIP24vTdmw=;
  b=X1ysJge4dMvMTTCJ2AFaJurTJ8dkWlpzJC3o9pPRIA04F7kUBEt2pERP
   Eqx2o2GOAuuUx0hyiudy6uBd7P42bZskEWVPMSo6IwMpUu+fiWRWY3Zmi
   tvB6BnihANRGqKmsYf0hPlaomieYmW1KfruY8x/sVncF1+jSxDMKRY5gh
   BFelyKHfSZ2l6qQq5cIzl2pUeI0R2MiRvy36ZO5axmLWIXJaMK+bAgtZ9
   afLoTPxezVQT88B+Xeg/GNU36BvzKpwmNeQEW3QLXeDURH4l++db5bqsB
   pyPuwBK6EYeGgoGf7xmQnSRW85dona8dqBUU+quXVQBaN9KvS1hxn8Wmq
   Q==;
X-CSE-ConnectionGUID: JlyGnxrdRpKVNvGegQOy1w==
X-CSE-MsgGUID: g7sYsIDcQR65B2q0JyZDrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66219499"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="66219499"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 21:02:56 -0800
X-CSE-ConnectionGUID: rs3B5ijhTVGv+kSjCL9fAA==
X-CSE-MsgGUID: urT/xi6OQOK7RTeKmDyI0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="191669191"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.213]) ([10.124.240.213])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 21:02:48 -0800
Message-ID: <83067602-325a-4655-a1b7-e6bd6a31eed4@linux.intel.com>
Date: Tue, 25 Nov 2025 13:02:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/44] KVM: x86/pmu: Load/save GLOBAL_CTRL via
 entry/exit fields for mediated PMU
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-29-seanjc@google.com> <aSUK8FuWT4lpMP3F@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aSUK8FuWT4lpMP3F@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/25/2025 9:48 AM, Sean Christopherson wrote:
> On Wed, Aug 06, 2025, Sean Christopherson wrote:
>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>
>> When running a guest with a mediated PMU, context switch PERF_GLOBAL_CTRL
>> via the dedicated VMCS fields for both host and guest.  For the host,
>> always zero GLOBAL_CTRL on exit as the guest's state will still be loaded
>> in hardware (KVM will context switch the bulk of PMU state outside of the
>> inner run loop).  For the guest, use the dedicated fields to atomically
>> load and save PERF_GLOBAL_CTRL on all entry/exits.
>>
>> Note, VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL was introduced by Sapphire
>> Rapids, and is expected to be supported on all CPUs with PMU v4+.  WARN if
>> that expectation is not met.  Alternatively, KVM could manually save
>> PERF_GLOBAL_CTRL via the MSR save list, but the associated complexity and
>> runtime overhead is unjustified given that the feature should always be
>> available on relevant CPUs.
> This is wrong, PMU v4 has been supported since Skylake.

Yes, the v4+ restriction is to meet the requirement of existence of
IA32_PERF_GLOBAL_STATUS_SET MSR which is needed to restore the guest
global_ctrl.


>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 7ab35ef4a3b1..98f7b45ea391 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -787,7 +787,23 @@ static bool intel_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_
>>  	 * Require v4+ for MSR_CORE_PERF_GLOBAL_STATUS_SET, and full-width
>>  	 * writes so that KVM can precisely load guest counter values.
>>  	 */
>> -	return host_pmu->version >= 4 && host_perf_cap & PERF_CAP_FW_WRITES;
>> +	if (host_pmu->version < 4 || !(host_perf_cap & PERF_CAP_FW_WRITES))
>> +		return false;
>> +
>> +	/*
>> +	 * All CPUs that support a mediated PMU are expected to support loading
>> +	 * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
>> +	 */
>> +	if (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
>> +			 !cpu_has_save_perf_global_ctrl()))
>> +		return false;
> And so this WARN fires due to cpu_has_save_perf_global_ctrl() being false.  The
> bad changelog is mine, but the code isn't entirely my fault.  I did suggest the
> WARN in v3[1], probably because I forgot when PMU v4 was introduced and no one
> corrected me.
>
> v4 of the series[2] then made cpu_has_save_perf_global_ctrl() a hard requirement,
> based on my miguided feedback.
>
>    * Only support GLOBAL_CTRL save/restore with VMCS exec_ctrl, drop the MSR
>      save/retore list support for GLOBAL_CTRL, thus the support of mediated
>      vPMU is constrained to SapphireRapids and later CPUs on Intel side.
>
> Doubly frustrating is that this was discussed in the original RFC, where Jim
> pointed out[3] that requiring VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL would prevent
> enabling the mediated PMU on Skylake+, and I completely forgot that conversation
> by the time v3 of the series rolled around :-(

VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL is introduced from SPR and later. I
remember the original requirements includes to support Skylake and Icelake,
but I ever thought there were some offline sync and the requirement changed...

My bad, I should double confirm this at then.


>
> As mentioned in the discussion with Jim, _if_ PMU v4 was introduced with ICX (or
> later), then I'd be in favor of making VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL a hard
> requirement.  But losing supporting Skylake+ is a bit much.
>
> There are a few warts with nVMX's use of the auto-store list that need to be
> cleaned up, but on the plus side it's also a good excuse to clean up
> {add,clear}_atomic_switch_msr(), which have accumulated some cruft and quite a
> bit of duplicate code.  And while I still dislike using the auto-store list, the
> code isn't as ugly as it was back in v3 because we _can_ make the "load" VMCS
> controls mandatory without losing support for any CPUs (they predate PMU v4).

Yes, xxx_atomic_switch_msr() helpers need to be cleaned up and optimized. I
suppose we can have an independent patch-set to clean up and support
global_ctrl with auto-store list for Skylake and Icelake.


>
> [1] https://lore.kernel.org/all/ZzyWKTMdNi5YjvEM@google.com
> [2] https://lore.kernel.org/all/20250324173121.1275209-1-mizhang@google.com
> [3] https://lore.kernel.org/all/CALMp9eQ+-wcj8QMmFR07zvxFF22-bWwQgV-PZvD04ruQ=0NBBA@mail.gmail.com

