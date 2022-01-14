Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D862E48E339
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 05:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbiANEUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 23:20:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:31328 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbiANEUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 23:20:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642134031; x=1673670031;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mR+QkcxS+hsmuxhnmTbO4mYMDoChB79aCqyY2Yh5Low=;
  b=NNFqX3uklFYgUBtdy4cuSn4qyGyhdRNnQSNwYf0Yx0O86iGOYXq7osua
   bPb60sOXYufGCkgVf/0doxHr6ex/D1G9L6WAmiAWGOlRkK8DOOqafUOCD
   ChGEURv1aL6Nj1Zc05GwwT2tq7Xg5GVsH/DqVVm9OMSmIaDL46pJb6ZFN
   uPota1ynkYxJ4P8eXtAxCihlImz53vABSh3Z2w6xS3iG08MVuh5Nfmh+K
   d2ud3vUaYq9RbEx2YSkwr+j/mj/9W74mHRQpGRevTs3gLA7G176f3gBCM
   lTQAiY804Dfn7THhIBeHbFumAhBb+z+aSR9xn20qOfIGT0CwA4bjtUNCa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="241741897"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="241741897"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 20:20:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="529989352"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.212.142]) ([10.254.212.142])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 20:20:25 -0800
Message-ID: <7fd4cb11-9920-6432-747e-633b96db0598@intel.com>
Date:   Fri, 14 Jan 2022 12:19:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v5 4/8] KVM: VMX: dump_vmcs() reports
 tertiary_exec_control field as well
Content-Language: en-US
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
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-5-guang.zeng@intel.com> <YeCTsVCwEkT2N6kQ@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YeCTsVCwEkT2N6kQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/2022 5:03 AM, Sean Christopherson wrote:
> On Fri, Dec 31, 2021, Zeng Guang wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> Add tertiary_exec_control field report in dump_vmcs()
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index fb0f600368c6..5716db9704c0 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5729,6 +5729,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>   	u32 vmentry_ctl, vmexit_ctl;
>>   	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
>> +	u64 tertiary_exec_control = 0;
>>   	unsigned long cr4;
>>   	int efer_slot;
>>   
>> @@ -5746,6 +5747,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>>   	if (cpu_has_secondary_exec_ctrls())
>>   		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> Gah, this (not your) code is silly.  I had to go look at the full source to see
> that secondary_exec_control isn't accessed uninitialized...
>
> Can you opportunistically tweak it to the below, and use the same patter for the
> tertiary controls?
>
> 	if (cpu_has_secondary_exec_ctrls())
> 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> 	else
> 		secondary_exec_control = 0;
Actually secondary_exec_control did zero initialization ahead .
yah, it's better to unify the code for both.
>>   
>> +	if (cpu_has_tertiary_exec_ctrls())
>> +		tertiary_exec_control = vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
>> +
>>   	pr_err("VMCS %p, last attempted VM-entry on CPU %d\n",
>>   	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
>>   	pr_err("*** Guest State ***\n");
>> @@ -5844,8 +5848,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>>   		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
>>   
>>   	pr_err("*** Control State ***\n");
>> -	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
>> -	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control);
>> +	pr_err("PinBased=0x%08x CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
>> +	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control,
>> +	       tertiary_exec_control);
> Can you provide a sample dump?  It's hard to visualize the output, e.g. I'm worried
> this will be overly log and harder to read than putting tertiary controls on their
> own line.

Sample dump here.
  
*** Control State ***

  PinBased=0x000000ff CPUBased=0xb5a26dfa SecondaryExec=0x061037eb 
TertiaryExec=0x0000000000000010
  EntryControls=0000d1ff ExitControls=002befff
  ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
  VMEntry: intr_info=00000000 errcode=00000000 ilen=00000000
  VMExit: intr_info=00000000 errcode=00000000 ilen=00000003
          reason=00000030 qualification=0000000000000784
>>   	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
>>   	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
>>   	       vmcs_read32(EXCEPTION_BITMAP),
>> -- 
>> 2.27.0
>>
