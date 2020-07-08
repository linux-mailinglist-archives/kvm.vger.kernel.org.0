Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D9A217CA0
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 03:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgGHBhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 21:37:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:59221 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgGHBhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 21:37:37 -0400
IronPort-SDR: iQbWdsCtOTsKWazuy6hIuUQqk7uhTTdVewqI4hIqyIn6ZOAS6lYWUhgtEQ/DSbL5o4YVxrHnly
 RMl6YbhjaxKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="232582294"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="232582294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 18:37:37 -0700
IronPort-SDR: Vvf6AL5bT8mZ+d6zfaN2kALkJJH7b8qtgKq1xVzXO6nqINjS3PPqll+73TU7AeiK6LT1ow+9hr
 g4akaZyJM51g==
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="388677428"
Received: from unknown (HELO [10.239.13.102]) ([10.239.13.102])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 18:37:34 -0700
Subject: Re: [PATCH v12 07/11] KVM: vmx/pmu: Unmask LBR fields in the
 MSR_IA32_DEBUGCTLMSR emualtion
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xu, Like" <like.xu@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-8-like.xu@linux.intel.com>
 <654d931c-a724-ed69-6501-52ce195a6f44@intel.com>
 <ea424570-c93f-2624-3e85-d7255b609da4@intel.com>
 <20200707202155.GL20096@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <1e1c2e15-ac02-b44b-6de9-87530e050855@intel.com>
Date:   Wed, 8 Jul 2020 09:37:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707202155.GL20096@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/8/2020 4:21 AM, Sean Christopherson wrote:
> On Sat, Jun 13, 2020 at 05:42:50PM +0800, Xu, Like wrote:
>> On 2020/6/13 17:14, Xiaoyao Li wrote:
>>> On 6/13/2020 4:09 PM, Like Xu wrote:
[...]
>>>> @@ -237,6 +238,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu,
>>>> struct msr_data *msr_info)
>>>>                return 1;
>>>>            msr_info->data = vcpu->arch.perf_capabilities;
>>>>            return 0;
>>>> +    case MSR_IA32_DEBUGCTLMSR:
>>>> +        msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>>>
>>> Can we put the emulation of MSR_IA32_DEBUGCTLMSR in vmx_{get/set})_msr().
>>> AFAIK, MSR_IA32_DEBUGCTLMSR is not a pure PMU related MSR that there is
>>> bit 2 to enable #DB for bus lock.
>> We already have "case MSR_IA32_DEBUGCTLMSR" handler in the vmx_set_msr()
>> and you may apply you bus lock changes in that handler.
> 
> Hrm, but that'd be weird dependency as vmx_set_msr() would need to check for
> #DB bus lock support but not actually write GUEST_IA32_DEBUGCTL, or we'd end
> up writing it twice when both bus lock and LBR are supported.

Yeah. That's what I concerned as well.

> I don't see anything in the series that takes action on writes to
> MSR_IA32_DEBUGCTLMSR beyond updating the VMCS, i.e. AFAICT there isn't any
> reason to call into the PMU, VMX can simply query vmx_get_perf_capabilities()
> to check if it's legal to enable DEBUGCTLMSR_LBR_MASK.
> 
> A question for both LBR and bus lock: would it make sense to cache the
> guest's value in vcpu_vmx so that querying the guest value doesn't require
> a VMREAD?  I don't have a good feel for how frequently it would be accessed.

Cache the guest's value is OK, even though #DB bus lock bit wouldn't be 
toggled frequently in a normal OS.

