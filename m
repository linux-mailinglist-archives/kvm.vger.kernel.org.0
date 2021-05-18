Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAAC38739B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 09:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbhERH4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 03:56:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:6291 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240382AbhERH4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 03:56:45 -0400
IronPort-SDR: +eEq+CNmZg2mxrVjHuEGKSAPritqby+sEJxal9wB5E9RNhhKirkMXKV+JBI8KR9jHeaEN9LuUb
 VEaCpjp0vocw==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="197567722"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="197567722"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 00:55:20 -0700
IronPort-SDR: /3B3uMeIMrkmVOQIwdCVW1cvukL66BLkMbptcCsQwVGKmkQKzhUzHtQNgGSy6T0w+DcFjRl1Bn
 KgbXL8rshUBA==
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="472830856"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 00:55:15 -0700
Subject: Re: [PATCH v6 05/16] KVM: x86/pmu: Introduce the ctrl_mask value for
 fixed counter
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-6-like.xu@linux.intel.com>
 <YKImwdg7LO/OPvVJ@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <1fb87ea1-d7e6-0ca3-f3ed-4007a7e5a7d7@intel.com>
Date:   Tue, 18 May 2021 15:55:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKImwdg7LO/OPvVJ@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/17 16:18, Peter Zijlstra wrote:
> On Tue, May 11, 2021 at 10:42:03AM +0800, Like Xu wrote:
>> The mask value of fixed counter control register should be dynamic
>> adjusted with the number of fixed counters. This patch introduces a
>> variable that includes the reserved bits of fixed counter control
>> registers. This is needed for later Ice Lake fixed counter changes.
>>
>> Co-developed-by: Luwei Kang <luwei.kang@intel.com>
>> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 1 +
>>   arch/x86/kvm/vmx/pmu_intel.c    | 6 +++++-
>>   2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 55efbacfc244..49b421bd3dd8 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -457,6 +457,7 @@ struct kvm_pmu {
>>   	unsigned nr_arch_fixed_counters;
>>   	unsigned available_event_types;
>>   	u64 fixed_ctr_ctrl;
>> +	u64 fixed_ctr_ctrl_mask;
>>   	u64 global_ctrl;
>>   	u64 global_status;
>>   	u64 global_ovf_ctrl;
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index d9dbebe03cae..ac7fe714e6c1 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -400,7 +400,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_CORE_PERF_FIXED_CTR_CTRL:
>>   		if (pmu->fixed_ctr_ctrl == data)
>>   			return 0;
>> -		if (!(data & 0xfffffffffffff444ull)) {
>> +		if (!(data & pmu->fixed_ctr_ctrl_mask)) {
> Don't we already have hardware with more than 3 fixed counters?

Yes, so we update this mask based on the value of pmu->nr_arch_fixed_counters:

+    for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+        pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));

I assume this comment will not result in any code changes for this patch.
