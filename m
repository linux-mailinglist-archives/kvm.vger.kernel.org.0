Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D521D961E
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgESMTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 08:19:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:36945 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgESMTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 08:19:33 -0400
IronPort-SDR: Gxym/W1Kj+m/3DJV9cA6o5QyEx9bnyGn2rC9Vs2sVszqBTHHZfVIIRNyXY1kritd/2gNpSLcJC
 TkIP2rlmtzxg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 05:19:26 -0700
IronPort-SDR: QfB7argupf+FUWa+bhIJr6fsy7smat1tPhaRmXGFHm1AobVRirjPuKwY/YuamwcgvFBPwIZNT5
 vFVSZI/1Ppqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="288939620"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.98]) ([10.249.171.98])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 05:19:22 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 07/11] KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES for
 LBR record format
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-8-like.xu@linux.intel.com>
 <20200519105335.GF279861@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <07806259-d9dd-53ec-1b63-84d8e081a296@intel.com>
Date:   Tue, 19 May 2020 20:19:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519105335.GF279861@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/19 18:53, Peter Zijlstra wrote:
> On Thu, May 14, 2020 at 04:30:50PM +0800, Like Xu wrote:
>> @@ -203,6 +206,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>>   		msr_info->data = pmu->global_ovf_ctrl;
>>   		return 0;
>> +	case MSR_IA32_PERF_CAPABILITIES:
>> +		if (!msr_info->host_initiated &&
>> +			!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
>> +			return 1;
> I know this is KVM code, so maybe they feel differently, but I find the
> above indentation massively confusing. Consider using: "set cino=:0(0"
> if you're a vim user.
Nice tip and I'll apply it. Thanks.
>
>> +		msr_info->data = vcpu->arch.perf_capabilities;
>> +		return 0;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
>>   			u64 val = pmc_read_counter(pmc);
>> @@ -261,6 +270,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			return 0;
>>   		}
>>   		break;
>> +	case MSR_IA32_PERF_CAPABILITIES:
>> +		if (!msr_info->host_initiated ||
>> +			!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
>> +			return 1;
> Idem.
>
>> +		if (!(data & ~vmx_get_perf_capabilities()))
>> +			return 1;
>> +		if ((data ^ vmx_get_perf_capabilities()) & PERF_CAP_LBR_FMT)
>> +			return 1;
>> +		vcpu->arch.perf_capabilities = data;
>> +		return 0;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
>>   			if (!msr_info->host_initiated)

