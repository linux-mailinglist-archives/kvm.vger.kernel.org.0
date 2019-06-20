Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C036C4C79D
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 08:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfFTGq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 02:46:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:33092 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfFTGq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 02:46:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 23:46:55 -0700
X-IronPort-AV: E=Sophos;i="5.63,395,1557212400"; 
   d="scan'208";a="154028475"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 19 Jun 2019 23:46:53 -0700
Subject: Re: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
To:     Wanpeng Li <kernellwp@gmail.com>, Tao Xu <tao3.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190620050301.1149-1-tao3.xu@intel.com>
 <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
Message-ID: <f358c914-ae58-9889-a8ef-6ea9f3b2650e@linux.intel.com>
Date:   Thu, 20 Jun 2019 14:46:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cwg7ogTN1w=xNyn+8CfxwofdxRykULFe217pXidzEhh6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/2019 2:40 PM, Wanpeng Li wrote:
> Hi,
> On Thu, 20 Jun 2019 at 13:06, Tao Xu <tao3.xu@intel.com> wrote:
>>
>> The helper vmx_xsaves_supported() returns the bit value of
>> SECONDARY_EXEC_XSAVES in vmcs_config.cpu_based_2nd_exec_ctrl, which
>> remains unchanged true if vmcs supports 1-setting of this bit after
>> setup_vmcs_config(). It should check the guest's cpuid not this
>> unchanged value when get/set msr.
>>
>> Besides, vmx_compute_secondary_exec_control() adjusts
>> SECONDARY_EXEC_XSAVES bit based on guest cpuid's X86_FEATURE_XSAVE
>> and X86_FEATURE_XSAVES, it should use updated value to decide whether
>> set XSS_EXIT_BITMAP.
>>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b93e36ddee5e..935cf72439a9 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1721,7 +1721,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                  return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
>>                                         &msr_info->data);
>>          case MSR_IA32_XSS:
>> -               if (!vmx_xsaves_supported())
>> +               if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
>> +                       !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>                          return 1;
>>                  msr_info->data = vcpu->arch.ia32_xss;
>>                  break;
>> @@ -1935,7 +1936,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                          return 1;
>>                  return vmx_set_vmx_msr(vcpu, msr_index, data);
>>          case MSR_IA32_XSS:
>> -               if (!vmx_xsaves_supported())
>> +               if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
>> +                       !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>                          return 1;
> 
> Not complete true.
> 
>>                  /*
>>                   * The only supported bit as of Skylake is bit 8, but
>> @@ -4094,7 +4096,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>>
>>          set_cr4_guest_host_mask(vmx);
>>
>> -       if (vmx_xsaves_supported())
>> +       if (vmx->secondary_exec_control & SECONDARY_EXEC_XSAVES)
>>                  vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
> 
> This is not true.
> 
> SDM 24.6.20:
> On processors that support the 1-setting of the “enable
> XSAVES/XRSTORS” VM-execution control, the VM-execution control fields
> include a 64-bit XSS-exiting bitmap.
> 
> It depends on whether or not processors support the 1-setting instead
> of “enable XSAVES/XRSTORS” is 1 in VM-exection control field. Anyway,

Yes, whether this field exist or not depends on whether processors 
support the 1-setting.

But if "enable XSAVES/XRSTORS" is clear to 0, XSS_EXIT_BITMAP doesn't 
work. I think in this case, there is no need to set this vmcs field?

> I will send a patch to fix the msr read/write for commit
> 203000993de5(kvm: vmx: add MSR logic for XSAVES), thanks for the
> report.
> 
> Regards,
> Wanpeng Li
> 
