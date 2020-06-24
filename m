Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301F120691B
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 02:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbgFXAkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 20:40:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:5063 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgFXAkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 20:40:17 -0400
IronPort-SDR: qTpRyEPjTfSu2eBUZYRGqgxCVIIFpMVDv12Wxua2ksdPaWEFQtZ10ESRWEL25e+tDTPh7A9wj0
 XHBMmwQDHOWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="228964118"
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="228964118"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 17:40:16 -0700
IronPort-SDR: 4rbmInvG3yqk+WGpQtfSk6qnzq3kaKehHPA+gtmKCH/MeZoC06bDIFTP15RgNt94gjrQ2xLe45
 gvXEiYEPfrSw==
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="452446201"
Received: from cli46-mobl2.ccr.corp.intel.com (HELO [10.255.29.15]) ([10.255.29.15])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 17:40:13 -0700
Subject: Re: [PATCH v2 1/7] KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if
 SET_CPUID fails
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
 <20200623115816.24132-2-xiaoyao.li@intel.com>
 <CALMp9eRsWqM-OAKO+y7EpoX7Oq1Qee0vAzgOBpYixUVH8Df1JA@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <59535ddb-373a-952f-f049-91d8f142c6a9@intel.com>
Date:   Wed, 24 Jun 2020 08:40:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRsWqM-OAKO+y7EpoX7Oq1Qee0vAzgOBpYixUVH8Df1JA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/2020 2:20 AM, Jim Mattson wrote:
> On Tue, Jun 23, 2020 at 4:58 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> It needs to invalidate CPUID configruations if usersapce provides
> 
> Nits: configurations, userspace

oh, I'll fix it.

>> illegal input.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 8a294f9747aa..1d13bad42bf9 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -207,6 +207,8 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>>          kvm_apic_set_version(vcpu);
>>          kvm_x86_ops.cpuid_update(vcpu);
>>          r = kvm_update_cpuid(vcpu);
>> +       if (r)
>> +               vcpu->arch.cpuid_nent = 0;
>>
>>          kvfree(cpuid_entries);
>>   out:
>> @@ -230,6 +232,8 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>>          kvm_apic_set_version(vcpu);
>>          kvm_x86_ops.cpuid_update(vcpu);
>>          r = kvm_update_cpuid(vcpu);
>> +       if (r)
>> +               vcpu->arch.cpuid_nent = 0;
>>   out:
>>          return r;
>>   }
>> --
>> 2.18.2
> 
> What if vcpu->arch.cpuid_nent was greater than 0 before the ioctl in question?
>

Nice catch!

If considering it, then we have to restore the old CPUID configuration. 
So how about making it simpler to just add one line of comment in API doc:
If KVM_SET_CPUID{2} fails, the old valid configuration is cleared as a 
side effect.

