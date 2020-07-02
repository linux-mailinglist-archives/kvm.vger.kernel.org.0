Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B712F212F87
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 00:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGBWac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 18:30:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:33166 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGBWac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 18:30:32 -0400
IronPort-SDR: /+uu6vBm3TTkeELGuzMiELa0hCwBhECRETk+u41TuMzmWKvRQsMZiHFBms2a2K28I7XR9u9Ii/
 4N45HfwVcfUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="165105694"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="165105694"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 15:30:32 -0700
IronPort-SDR: AoX6z7b952IgJfuZpUh7lLEbsAT13vsfdzjjbueafDO/JsHVoWA2qFNKpfVSocNGFgEyqp6LVd
 W+HHxOQhD7FQ==
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="426100622"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.34]) ([10.255.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 15:30:29 -0700
Subject: Re: [PATCH v2 7/7] KVM: X86: Move kvm_apic_set_version() to
 kvm_update_vcpu_model()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
 <20200623115816.24132-8-xiaoyao.li@intel.com>
 <20200702190009.GJ3575@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <e3f0b5dd-b82b-55ce-6a89-2bffc89c9c72@intel.com>
Date:   Fri, 3 Jul 2020 06:30:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200702190009.GJ3575@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/3/2020 3:00 AM, Sean Christopherson wrote:
> On Tue, Jun 23, 2020 at 07:58:16PM +0800, Xiaoyao Li wrote:
>> Obviously, kvm_apic_set_version() fits well in kvm_update_vcpu_model().
> 
> Same as the last patch, it would be nice to explicitly document that there
> are no dependencies between kvm_apic_set_version() and kvm_update_cpuid().

Sure, will do.

Thanks!

>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 5decc2dd5448..3428f4d84b42 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -129,6 +129,8 @@ void kvm_update_vcpu_model(struct kvm_vcpu *vcpu)
>>   			apic->lapic_timer.timer_mode_mask = 3 << 17;
>>   		else
>>   			apic->lapic_timer.timer_mode_mask = 1 << 17;
>> +
>> +		kvm_apic_set_version(vcpu);
>>   	}
>>   
>>   	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
>> @@ -226,7 +228,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>>   	}
>>   
>>   	cpuid_fix_nx_cap(vcpu);
>> -	kvm_apic_set_version(vcpu);
>>   	kvm_update_cpuid(vcpu);
>>   	kvm_update_vcpu_model(vcpu);
>>   
>> @@ -255,7 +256,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>>   		goto out;
>>   	}
>>   
>> -	kvm_apic_set_version(vcpu);
>>   	kvm_update_cpuid(vcpu);
>>   	kvm_update_vcpu_model(vcpu);
>>   out:
>> -- 
>> 2.18.2
>>

