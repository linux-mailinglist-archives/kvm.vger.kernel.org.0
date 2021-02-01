Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADEF30A4B7
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 10:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhBAJy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 04:54:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:22956 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232779AbhBAJyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 04:54:24 -0500
IronPort-SDR: uY24XbNcq6vei11v5bj+xqSbebmbXxqgQXUzzgOmaNr9cmwuCVPUT87MMU1CSbrUufFg3xEfj+
 IJQNk33kQrxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="244743500"
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="244743500"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 01:53:42 -0800
IronPort-SDR: zVgiQr9TeuhQr64iMqqAOliYb0ySwY8kR4MwpSNzx53MsS9MjlTIbS0Agn4tk/kVXb9/2FGrW5
 vpv7eI1WUvMw==
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="390834248"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.32]) ([10.238.1.32])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 01:53:40 -0800
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
Message-ID: <a311a49b-ea77-99bf-0d0b-b613aed621a4@intel.com>
Date:   Mon, 1 Feb 2021 17:53:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
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
> Even if this is the case, the MSR intercepts and the entry/exit controls 
> should only be done if CR4.PKS=1.  If the guest does not use PKS, KVM 
> should behave as if these patches did not exist.
> 

Hi Paolo,

Per the MSR intercepts and entry/exit controls, IA32_PKRS access is 
independent of the CR4.PKS bit, it just depends on CPUID enumeration. If 
the guest doesn't set CR4.PKS but still has the CPUID capability, 
modifying on PKRS should be supported but has no effect. IIUC, we can 
not ignore these controls if CR4.PKS=0.

Thanks
Chenyi

> Paolo
> 
