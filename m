Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BF267A6D
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2019 16:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfGMOXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jul 2019 10:23:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:20899 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfGMOXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jul 2019 10:23:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 07:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,486,1557212400"; 
   d="scan'208";a="174701302"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.255.30.205]) ([10.255.30.205])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2019 07:23:00 -0700
Subject: Re: [PATCH v7 3/3] KVM: vmx: handle vm-exit for UMWAIT and TPAUSE
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
References: <20190712082907.29137-1-tao3.xu@intel.com>
 <20190712082907.29137-4-tao3.xu@intel.com>
 <20190712160352.GD29659@linux.intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <babf6abf-3e03-1e33-8dd9-ee847957be6f@intel.com>
Date:   Sat, 13 Jul 2019 22:22:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712160352.GD29659@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/2019 12:03 AM, Sean Christopherson wrote:
> On Fri, Jul 12, 2019 at 04:29:07PM +0800, Tao Xu wrote:
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -5213,6 +5213,9 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>>   	case EXIT_REASON_ENCLS:
>>   		/* SGX is never exposed to L1 */
>>   		return false;
>> +	case EXIT_REASON_UMWAIT: case EXIT_REASON_TPAUSE:
> 
> Grouped case statements are usually stacked vertically, e.g.:
> 
> 	case EXIT_REASON_UMWAIT:
> 	case EXIT_REASON_TPAUSE:
>Ok, thank you for your suggestion.

>> +		return nested_cpu_has2(vmcs12,
>> +			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
>>   	default:
>>   		return true;
>>   	}
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0787f140d155..e026b1313dc3 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5349,6 +5349,20 @@ static int handle_monitor(struct kvm_vcpu *vcpu)
>>   	return handle_nop(vcpu);
>>   }
>>   
>> +static int handle_umwait(struct kvm_vcpu *vcpu)
>> +{
>> +	kvm_skip_emulated_instruction(vcpu);
>> +	WARN(1, "this should never happen\n");
> 
> Blech.  I'm guessing this code was copy-pasted from handle_xsaves() and
> handle_xrstors().  The blurb of "this should never happen" isn't very
> helpful, e.g. the WARN itself makes it pretty obvious that we don't expect
> to reach this point.  WARN_ONCE would also be preferable, no need to spam
> the log in the event things go completely haywire.
> 
> Rather than propagate ugly code, what about defining a common helper, e.g.
> 
> static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
> {
> 	kvm_skip_emulated_instruction(vcpu);
> 	WARN_ONCE(1, "Unexpected VM-Exit = 0x%x", vmcs_read32(VM_EXIT_REASON));
> 	return 1;
> }
> 
> ...
> {
> 	[EXIT_REASON_XSAVES]                  = handle_unexpected_vmexit,
> 	[EXIT_REASON_XRSTORS]                 = handle_unexpected_vmexit,
> 
> 	[EXIT_REASON_UMWAIT]                  = handle_unexpected_vmexit,
> 	[EXIT_REASON_TPAUSE]                  = handle_unexpected_vmexit,
> 
> }
> 
Thank you Sean, I will do this in next version of patch.

>> +	return 1;
>> +}
>> +
>> +static int handle_tpause(struct kvm_vcpu *vcpu)
>> +{
>> +	kvm_skip_emulated_instruction(vcpu);
>> +	WARN(1, "this should never happen\n");
>> +	return 1;
>> +}
>> +
>>   static int handle_invpcid(struct kvm_vcpu *vcpu)
>>   {
>>   	u32 vmx_instruction_info;
>> @@ -5559,6 +5573,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>>   	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
>>   	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>>   	[EXIT_REASON_ENCLS]		      = handle_encls,
>> +	[EXIT_REASON_UMWAIT]                  = handle_umwait,
>> +	[EXIT_REASON_TPAUSE]                  = handle_tpause,
>>   };
>>   
>>   static const int kvm_vmx_max_exit_handlers =
>> -- 
>> 2.20.1
>>

