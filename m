Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24D32CA7D
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 03:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhCDCb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 21:31:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:37210 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhCDCbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 21:31:24 -0500
IronPort-SDR: oF86+uJZZZSkqH3OisORiQXPx0WGdwk903EZuRIJ11dZxF9r3Nsdl/n8TY/SP6NnC87H4QQKiE
 fApPXlOHv/2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="251371877"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="251371877"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:30:43 -0800
IronPort-SDR: XCTwrekLR25oUgm7t70oHJjwYrie2cMryVBSuuk6F0IM31TEET4e9GmZaANhm/dtGQLYb707Hh
 0MSP+iEAnDxg==
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="400276290"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:30:38 -0800
Subject: Re: [PATCH v3 5/9] KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for
 Arch LBR
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-6-like.xu@linux.intel.com>
 <YD/APUcINwvP53VZ@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <890a6f34-812a-5937-8761-d448a04f67d7@intel.com>
Date:   Thu, 4 Mar 2021 10:30:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YD/APUcINwvP53VZ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for your detailed review on the patch set.

On 2021/3/4 0:58, Sean Christopherson wrote:
> On Wed, Mar 03, 2021, Like Xu wrote:
>> @@ -348,10 +352,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>>   	return true;
>>   }
>>   
>> +/*
>> + * Check if the requested depth values is supported
>> + * based on the bits [0:7] of the guest cpuid.1c.eax.
>> + */
>> +static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
>> +{
>> +	struct kvm_cpuid_entry2 *best;
>> +
>> +	best = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
>> +	if (best && depth && !(depth % 8))
> This is still wrong, it fails to weed out depth > 64.

How come ? The testcases depth = {65, 127, 128} get #GP as expected.

>
> Not that this is a hot path, but it's probably worth double checking that the
> compiler generates simple code for "depth % 8", e.g. it can be "depth & 7)".

Emm, the "%" operation is quite normal over kernel code.

if (best && depth && !(depth % 8))
    10659:       48 85 c0                test   rax,rax
    1065c:       74 c7                   je     10625 <intel_pmu_set_msr+0x65>
    1065e:       4d 85 e4                test   r12,r12
    10661:       74 c2                   je     10625 <intel_pmu_set_msr+0x65>
    10663:       41 f6 c4 07             test   r12b,0x7
    10667:       75 bc                   jne    10625 <intel_pmu_set_msr+0x65>

It looks like the compiler does the right thing.
Do you see the room for optimization ？

>
>> +		return (best->eax & 0xff) & (1ULL << (depth / 8 - 1));
>> +
>> +	return false;
>> +}
>> +

