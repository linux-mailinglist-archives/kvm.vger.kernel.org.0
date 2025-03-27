Return-Path: <kvm+bounces-42086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73103A727DB
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 01:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11772179A0E
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 00:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0ECC2E0;
	Thu, 27 Mar 2025 00:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nxBt8+8L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C772E3392
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 00:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743036298; cv=none; b=d1UwCgsmJxFwImS8ALGEB2VCHbwvscag/vM+1g94t7NXUeYPKNwXYDhS0a7S1FWEfxJ8iXWiPsV5/5xgfAgka77ee7TAlZzdbxZ6ebYNtThjI+unDJPDsLJe6nbHoIclWGiX8lbzHlFpPcgu8qGiQ6mgdXdxNlOU3VgYsXnyrGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743036298; c=relaxed/simple;
	bh=1E4OhdxDCA+uUeKjgwsdCTwJzIJ0Qula+rwvE/bkIEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9yvZqDE8o8AqTvNb/IwYNVtzVp/+rVb1c7dw5nLYHjQ9Zb2fsdEEGGH5ANjTizO1oLYiyTKqjRnVQxymxSGg9kgIX45xxv7L22k1/BGoEWRCo72GbfI1dLAsa27BNB1gPuGyzYxs2n4Z0LpUvocZmEBHeBNx8+v62dDbRsohvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nxBt8+8L; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743036297; x=1774572297;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1E4OhdxDCA+uUeKjgwsdCTwJzIJ0Qula+rwvE/bkIEY=;
  b=nxBt8+8LoR26VfB8ZWYfhLMe0fryEMJy3C2pdSnjjJv6/S4jSRCcyvRl
   kr84Bva6ee6PZ55sja5DgJIZDh4AH1rs0/icVx85QQ0It3OPhjjXzv9jn
   KStBQej+dHggU2Cd8YgG119W3NyOTKEl2WDld7pMPr937ULQCL0Zuw4ca
   1AyJbd3eB90zunZehT2ElfRuErw5ucB5BhOLQtaiP85vjOPb4rdgZP8Xv
   rC5+edwXID/JtwJ+qMKGnPWtcdX+MdVdfjeP2H6Vx3T7ZNTOmQAL2PCKs
   n5Rf/qwjioGbsXZ5vM9slmII29ovfW0U9N551wMZkF9kOZcXCtdFdY63Q
   g==;
X-CSE-ConnectionGUID: JZD/25irTyu52ZWegbILPw==
X-CSE-MsgGUID: C5j4TklYReq/kpqTTaEgbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="55716619"
X-IronPort-AV: E=Sophos;i="6.14,279,1736841600"; 
   d="scan'208";a="55716619"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 17:44:52 -0700
X-CSE-ConnectionGUID: YIbrI9zcR7KAaP4Tjq0uDA==
X-CSE-MsgGUID: MQK7FOH/RfO2gqkRsn9DOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,279,1736841600"; 
   d="scan'208";a="130014402"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 17:44:48 -0700
Message-ID: <a8e4649d-5402-4c3a-bc86-1d1b76122541@linux.intel.com>
Date: Thu, 27 Mar 2025 08:44:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] target/i386: Call KVM_CAP_PMU_CAPABILITY iotcl to
 enable/disable PMU
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Zhao Liu
 <zhao1.liu@intel.com>, Zide Chen <zide.chen@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Das Sandipan
 <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
 <20250324123712.34096-3-dapeng1.mi@linux.intel.com>
 <3a01b0d8-8f0b-4068-8176-37f61295f87f@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <3a01b0d8-8f0b-4068-8176-37f61295f87f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/26/2025 2:46 PM, Dongli Zhang wrote:
> Hi Dapeng,
>
> PATCH 1-4 from the below patchset are already reviewed. (PATCH 5-10 are for PMU
> registers reset).
>
> https://lore.kernel.org/all/20250302220112.17653-1-dongli.zhang@oracle.com/
>
> They require only trivial modification. i.e.:
>
> https://github.com/finallyjustice/patchset/tree/master/qemu-amd-pmu-mid/v03
>
> Therefore, since PATCH 5-10 are for another topic, any chance if I re-send 1-4
> as a prerequisite for the patch to explicitly call KVM_CAP_PMU_CAPABILITY?

any option is fine for me, spiting it into two separated ones or still keep
in a whole patch series. I would rebase this this patchset on top of your
v3 patches.


>
> In addition, I have a silly question. Can mediated vPMU coexist with legacy
> perf-based vPMU, that is, something like tdp and tdp_mmu? Or the legacy
> perf-based vPMU is going to be purged from the most recent kernel?

No, they can't. As long as mediated vPMU is enabled, it would totally
replace the legacy perf-based vPMU. The legacy perf-based vPMU code would
still be kept in the kernel in near future, but the long-term target is to
totally remove the perf-based vPMU once mediated vPMU is mature.


>
> If they can coexist, how about add property to QEMU control between
> legacy/modern? i.e. by default use legacy and change to modern as default in the
> future once the feature is stable.
>
> Thank you very much!
>
> Dongli Zhang
>
> On 3/24/25 5:37 AM, Dapeng Mi wrote:
>> After introducing mediated vPMU, mediated vPMU must be enabled by
>> explicitly calling KVM_CAP_PMU_CAPABILITY to enable. Thus call
>> KVM_CAP_PMU_CAPABILITY to enable/disable PMU base on user configuration.
>>
>> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  target/i386/kvm/kvm.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index f41e190fb8..d3e6984844 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2051,8 +2051,25 @@ full:
>>      abort();
>>  }
>>  
>> +static bool pmu_cap_set = false;
>>  int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>  {
>> +    KVMState *s = kvm_state;
>> +    X86CPU *x86_cpu = X86_CPU(cpu);
>> +
>> +    if (!pmu_cap_set && kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
>> +        int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>> +                                  KVM_PMU_CAP_DISABLE & !x86_cpu->enable_pmu);
>> +        if (r < 0) {
>> +            error_report("kvm: Failed to %s pmu cap: %s",
>> +                         x86_cpu->enable_pmu ? "enable" : "disable",
>> +                         strerror(-r));
>> +            return r;
>> +        }
>> +
>> +        pmu_cap_set = true;
>> +    }
>> +
>>      return 0;
>>  }
>>  

