Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE23A1E665C
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 17:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404531AbgE1Pkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 11:40:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:26482 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404383AbgE1Pkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 11:40:32 -0400
IronPort-SDR: yoXXCkfH8taa2aIKmIuUYKwNICND5YJJmquQHwBVvrBd7RDb2naKMEi2KiDbkPwwqE64rsLyVi
 OXDHF/d9VfVQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 08:40:31 -0700
IronPort-SDR: KOgzxl9gfcD5mTiB9IER1X+pGcXi3LOqDn7qdHo+JXYQRMDr66UDPVTEEA0XGGPVoXmW+AzV5Z
 VfJukaq/kbrQ==
X-IronPort-AV: E=Sophos;i="5.73,445,1583222400"; 
   d="scan'208";a="267254410"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.96]) ([10.249.174.96])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 08:40:29 -0700
Subject: Re: [PATCH] KVM: X86: Call kvm_x86_ops.cpuid_update() after CPUIDs
 fully updated
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200528151927.14346-1-xiaoyao.li@intel.com>
 <b639a333-d7fe-74fd-ee11-6daede184676@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <1f45de43-af43-24da-b7d3-00b9d2bd517c@intel.com>
Date:   Thu, 28 May 2020 23:40:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <b639a333-d7fe-74fd-ee11-6daede184676@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/28/2020 11:22 PM, Paolo Bonzini wrote:
> On 28/05/20 17:19, Xiaoyao Li wrote:
>> kvm_x86_ops.cpuid_update() is used to update vmx/svm settings based on
>> updated CPUID settings. So it's supposed to be called after CPUIDs are
>> fully updated, not in the middle stage.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Are you seeing anything bad happening from this?

Not yet.

IMO changing the order is more reasonable and less confusing.

> Paolo
> 
>> ---
>>   arch/x86/kvm/cpuid.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index cd708b0b460a..753739bc1bf0 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -208,8 +208,11 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>>   	vcpu->arch.cpuid_nent = cpuid->nent;
>>   	cpuid_fix_nx_cap(vcpu);
>>   	kvm_apic_set_version(vcpu);
>> -	kvm_x86_ops.cpuid_update(vcpu);
>>   	r = kvm_update_cpuid(vcpu);
>> +	if (r)
>> +		goto out;
>> +
>> +	kvm_x86_ops.cpuid_update(vcpu);
>>   
>>   out:
>>   	vfree(cpuid_entries);
>> @@ -231,8 +234,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>>   		goto out;
>>   	vcpu->arch.cpuid_nent = cpuid->nent;
>>   	kvm_apic_set_version(vcpu);
>> -	kvm_x86_ops.cpuid_update(vcpu);
>>   	r = kvm_update_cpuid(vcpu);
>> +	if (r)
>> +		goto out;
>> +
>> +	kvm_x86_ops.cpuid_update(vcpu);
>>   out:
>>   	return r;
>>   }
>>
> 

