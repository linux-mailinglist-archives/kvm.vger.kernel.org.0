Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46753DD0E3
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 09:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhHBHA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 03:00:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:27827 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232297AbhHBHA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 03:00:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="193681317"
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="193681317"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 00:00:10 -0700
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="509949522"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.133]) ([10.238.0.133])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 00:00:03 -0700
Subject: Re: [PATCH 3/6] KVM: VMX: Detect Tertiary VM-Execution control when
 setup VMCS config
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
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-4-guang.zeng@intel.com> <YQHwa42jixqPPvVm@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <05faffb4-c22d-1cd5-7582-823de9dd109a@intel.com>
Date:   Mon, 2 Aug 2021 14:59:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQHwa42jixqPPvVm@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2021 8:03 AM, Sean Christopherson wrote:
> On Fri, Jul 16, 2021, Zeng Guang wrote:
>> @@ -4204,6 +4234,13 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
>>   #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
>>   	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
>>   
>> +static void vmx_compute_tertiary_exec_control(struct vcpu_vmx *vmx)
>> +{
>> +	u32 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
> This is incorrectly truncating the value.
>
>> +
>> +	vmx->tertiary_exec_control = exec_control;
>> +}
>> +
>>   static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>>   {
>>   	struct kvm_vcpu *vcpu = &vmx->vcpu;
>> @@ -4319,6 +4356,11 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>>   		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
>>   	}
>>   
>> +	if (cpu_has_tertiary_exec_ctrls()) {
>> +		vmx_compute_tertiary_exec_control(vmx);
>> +		tertiary_exec_controls_set(vmx, vmx->tertiary_exec_control);
> IMO, the existing vmx->secondary_exec_control is an abomination that should not
> exist.  Looking at the code, it's actually not hard to get rid, there's just one
> annoying use in prepare_vmcs02_early() that requires a bit of extra work to get
> rid of.
>
> Anyways, for tertiary controls, I'd prefer to avoid the same mess and instead
> follow vmx_exec_control(), both in functionality and in name:
>
>    static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
>    {
> 	return vmcs_config.cpu_based_3rd_exec_ctrl;
>    }
>
> and:
>
> 	if (cpu_has_tertiary_exec_ctrls())
> 		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
>
> and then the next patch becomes:
>
>    static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
>    {
> 	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
>
> 	if (!kvm_vcpu_apicv_active(vcpu))
> 		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
>
> 	return exec_control;
>    }
>
>
> And I'll work on a patch to purge vmx->secondary_exec_control.
Ok, it looks much concise. I will change as you suggest. Thanks.
>> +	}
>> +
>>   	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
>>   		vmcs_write64(EOI_EXIT_BITMAP0, 0);
>>   		vmcs_write64(EOI_EXIT_BITMAP1, 0);
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 945c6639ce24..c356ceebe84c 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -266,6 +266,7 @@ struct vcpu_vmx {
>>   	u32		      msr_ia32_umwait_control;
>>   
>>   	u32 secondary_exec_control;
>> +	u64 tertiary_exec_control;
>>   
>>   	/*
>>   	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
>> -- 
>> 2.25.1
>>
