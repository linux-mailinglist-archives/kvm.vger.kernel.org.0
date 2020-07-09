Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8021975D
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGIE1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:27:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:46071 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgGIE1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:27:35 -0400
IronPort-SDR: VYsZwWaDRowTytfAmkuoHGsExILrUTWgsfEXC+DS/yqz1mcKApUwWuQkg6EM/K/srVUTWGuXoz
 lu+l4H2XXhxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="135391578"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="135391578"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:27:34 -0700
IronPort-SDR: dnvwWvlKNPMO2IRCeIKMG/bv/8gUa0egKKHD3eldJQHeRDU3Fkyp7dn44A6ukSugUCp/wDetqs
 JRSAcz406wYw==
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="483647137"
Received: from unknown (HELO [10.239.13.102]) ([10.239.13.102])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:27:31 -0700
Subject: Re: [PATCH v3 0/8] Refactor handling flow of KVM_SET_CPUID*
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
 <55ce27bc-7ff7-3552-0e2d-ce69c66fd68e@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <e6432b0d-c509-28e0-7720-a4a0e22ea4d9@intel.com>
Date:   Thu, 9 Jul 2020 12:27:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <55ce27bc-7ff7-3552-0e2d-ce69c66fd68e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/8/2020 8:10 PM, Paolo Bonzini wrote:
> On 08/07/20 08:50, Xiaoyao Li wrote:
>> This serial is the extended version of
>> https://lkml.kernel.org/r/20200528151927.14346-1-xiaoyao.li@intel.com
>>
>> First two patches are bug fixing, and the others aim to refactor the flow
>> of SET_CPUID* as:
>>
>> 1. cpuid check: check if userspace provides legal CPUID settings;
>>
>> 2. cpuid update: Update some special CPUID bits based on current vcpu
>>                   state, e.g., OSXSAVE, OSPKE, ...
>>
>> 3. update vcpu model: Update vcpu model (settings) based on the final CPUID
>>                        settings.
>>
>> v3:
>>   - Add a note in KVM api doc to state the previous CPUID configuration
>>     is not reliable if current KVM_SET_CPUID* fails [Jim]
>>   - Adjust Patch 2 to reduce code churn [Sean]
>>   - Commit message refine to add more justification [Sean]
>>   - Add a new patch (7)
>>
>> v2:
>> https://lkml.kernel.org/r/20200623115816.24132-1-xiaoyao.li@intel.com
>>   - rebase to kvm/queue: a037ff353ba6 ("Merge branch 'kvm-master' into HEAD")
>>   - change the name of kvm_update_state_based_on_cpuid() to
>>     kvm_update_vcpu_model() [Sean]
>>   - Add patch 5 to rename kvm_x86_ops.cpuid_date() to
>>     kvm_x86_ops.update_vcpu_model()
>>
>> v1:
>> https://lkml.kernel.org/r/20200529085545.29242-1-xiaoyao.li@intel.com
>>
>> Xiaoyao Li (8):
>>    KVM: X86: Reset vcpu->arch.cpuid_nent to 0 if SET_CPUID* fails
>>    KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
>>    KVM: X86: Introduce kvm_check_cpuid()
>>    KVM: X86: Split kvm_update_cpuid()
>>    KVM: X86: Rename cpuid_update() to update_vcpu_model()
>>    KVM: X86: Move kvm_x86_ops.update_vcpu_model() into
>>      kvm_update_vcpu_model()
>>    KVM: lapic: Use guest_cpuid_has() in kvm_apic_set_version()
>>    KVM: X86: Move kvm_apic_set_version() to kvm_update_vcpu_model()
>>
>>   Documentation/virt/kvm/api.rst  |   4 ++
>>   arch/x86/include/asm/kvm_host.h |   2 +-
>>   arch/x86/kvm/cpuid.c            | 107 ++++++++++++++++++++------------
>>   arch/x86/kvm/cpuid.h            |   3 +-
>>   arch/x86/kvm/lapic.c            |   4 +-
>>   arch/x86/kvm/svm/svm.c          |   4 +-
>>   arch/x86/kvm/vmx/nested.c       |   2 +-
>>   arch/x86/kvm/vmx/vmx.c          |   4 +-
>>   arch/x86/kvm/x86.c              |   1 +
>>   9 files changed, 81 insertions(+), 50 deletions(-)
>>
> 
> Queued patches 1/2/3/7/8, thanks.

Paolo,

I notice that you queued patch 8 into kvm/queue branch as
commit 84dd4897524e "KVM: X86: Move kvm_apic_set_version() to 
kvm_update_vcpu_model()"

Can you change the subject of that commit to "KVM: X86: Move 
kvm_apic_set_version() to kvm_update_cpuid()" ?

> Paolo
> 

