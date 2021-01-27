Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F5030557C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 09:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhA0ITC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 03:19:02 -0500
Received: from mga12.intel.com ([192.55.52.136]:28009 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233433AbhA0IB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 03:01:57 -0500
IronPort-SDR: GKchp/Z0CdiRUue+jAS9glrbTB4H3HqgPrcjMi9omGCIpNrJdd+PtZ6hgSktnKGW8OpYjRByry
 d1gBeUA4ZDTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159205375"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="159205375"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 23:56:02 -0800
IronPort-SDR: YzrXAU9p2ySptudqCtzH9ZZeMVaeIugJCS4jLIXJFSFvXghfopsQbswjup9H1WFQYr0E+nEfIO
 IOQX1uyqXPdg==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388211654"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.32]) ([10.238.1.32])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 23:56:00 -0800
Subject: Re: [RFC 2/7] KVM: VMX: Expose IA32_PKRS MSR
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-3-chenyi.qiang@intel.com>
 <62f5f5ba-cbe9-231d-365a-80a656208e37@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <24789af6-e85f-6485-50a0-98c0c4195112@intel.com>
Date:   Wed, 27 Jan 2021 15:55:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <62f5f5ba-cbe9-231d-365a-80a656208e37@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/2021 2:01 AM, Paolo Bonzini wrote:
> On 07/08/20 10:48, Chenyi Qiang wrote:
>> +{
>> +    struct vcpu_vmx *vmx = to_vmx(vcpu);
>> +    unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
>> +    bool pks_supported = guest_cpuid_has(vcpu, X86_FEATURE_PKS);
>> +
>> +    /*
>> +     * set intercept for PKRS when the guest doesn't support pks
>> +     */
>> +    vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PKRS, MSR_TYPE_RW, 
>> !pks_supported);
>> +
>> +    if (pks_supported) {
>> +        vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
>> +        vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
>> +    } else {
>> +        vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
>> +        vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
>> +    }
> 
> Is the guest expected to do a lot of reads/writes to the MSR (e.g. at 
> every context switch)?
> 

In current design for PKS, the PMEM stray write protection is the only 
implemented use case, and PKRS is only temporarily changed during 
specific code paths. Thus reads/writes to MSR is not so frequent, I think.

> Even if this is the case, the MSR intercepts and the entry/exit controls 
> should only be done if CR4.PKS=1.  If the guest does not use PKS, KVM 
> should behave as if these patches did not exist.
> 


I pass through the PKRS and enable the entry/exit controls when PKS is 
supported, and just want to narrow down the window of MSR switch during 
the VMX transition. But yeah, I should also consider the enabling status 
of guest PKS according to CR4.PKS, will fix it in next version.

> Paolo
> 
