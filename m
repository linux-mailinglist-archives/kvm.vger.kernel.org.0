Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9973E2330
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 08:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243259AbhHFGVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 02:21:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:11288 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhHFGVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 02:21:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="299904801"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="299904801"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 23:20:51 -0700
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="481283967"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.133]) ([10.238.0.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 23:20:46 -0700
Subject: Re: [PATCH v3 3/6] KVM: VMX: Detect Tertiary VM-Execution control
 when setup VMCS config
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20210805151317.19054-1-guang.zeng@intel.com>
 <20210805151317.19054-4-guang.zeng@intel.com> <YQxns0wQ74d4X5VD@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <561628db-6155-8e31-6f07-3c7f18810e65@intel.com>
Date:   Fri, 6 Aug 2021 14:20:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQxns0wQ74d4X5VD@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/6/2021 6:35 AM, Sean Christopherson wrote:
> On Thu, Aug 05, 2021, Zeng Guang wrote:
>> +u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
> Make this static and drop the declaration from vmx.h, there's no nested user (yet),
> and I'm also working on a patch to rework how prepare_vmcs02_early() gets KVMs
> desires without having to call these heleprs, i.e. I want to bury all of these in
> vmx.c.
OK. Thus it could be static.
>> +{
>> +	return vmcs_config.cpu_based_3rd_exec_ctrl;
>> +}
>> +
>>   /*
>>    * Adjust a single secondary execution control bit to intercept/allow an
>>    * instruction in the guest.  This is usually done based on whether or not a
>> @@ -4319,6 +4354,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>   		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
>>   	}
>>   
>> +	if (cpu_has_tertiary_exec_ctrls())
>> +		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
>> +
>>   	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
>>   		vmcs_write64(EOI_EXIT_BITMAP0, 0);
>>   		vmcs_write64(EOI_EXIT_BITMAP1, 0);
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 945c6639ce24..448006bd8fa7 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -478,6 +478,7 @@ static inline u32 vmx_vmexit_ctrl(void)
>>   
>>   u32 vmx_exec_control(struct vcpu_vmx *vmx);
>>   u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx);
>> +u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx);
>>   
>>   static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
>>   {
>> -- 
>> 2.25.1
>>
