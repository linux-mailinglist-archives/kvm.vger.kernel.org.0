Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB232A6DE
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578969AbhCBPyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:54:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:24436 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347334AbhCBCym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 21:54:42 -0500
IronPort-SDR: MGul3XlqCh8eF0ltbz9vf5HWc0rcYwRQSlqg0RhPdzZnjLEFhB54FW0dpYiAm86IYt/HO5HEld
 BWoGxOCpPKtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="186721906"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="186721906"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 18:52:56 -0800
IronPort-SDR: 0Y5NNDMqa45GgezOLyZGo9r8aF1T93aO2XijT0PR13FtODXOlI0A+3m/eiyJiE90gfi0q2nXh+
 VjuEKKEMRVeA==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="406507788"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 18:52:54 -0800
Subject: Re: [PATCH v2 1/4] KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for
 Arch LBR
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-2-like.xu@linux.intel.com>
 <YD1r2G1UQjVXkUk5@google.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <d194f89a-cd56-6f32-4797-ae11956bf5ba@linux.intel.com>
Date:   Tue, 2 Mar 2021 10:52:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YD1r2G1UQjVXkUk5@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/2 6:34, Sean Christopherson wrote:
> On Wed, Feb 03, 2021, Like Xu wrote:
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
>> +	if (depth && best)
> 
>> +		return (best->eax & 0xff) & (1ULL << (depth / 8 - 1));
> 
> I believe this will genereate undefined behavior if depth > 64.  Or if depth < 8.
> And I believe this check also needs to enforce that depth is a multiple of 8.
> 
>     For each bit n set in this field, the IA32_LBR_DEPTH.DEPTH value 8*(n+1) is
>     supported.
> 
> Thus it's impossible for 0-7, 9-15, etc... to be legal depths.

Thank you! How about:

	best = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
	if (best && depth && !(depth % 8))
		return (best->eax & 0xff) & (1ULL << (depth / 8 - 1));

	return false;

> 
> 
>> +
>> +	return false;
>> +}
>> +
> 

