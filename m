Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3CA1B76DB
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgDXNWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:22:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:26970 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726888AbgDXNWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 09:22:00 -0400
IronPort-SDR: aILh596cps8DEppJvtcPC+64xO9G7kbPYMvUOJCTRNrtxbqNXO2i21MRVMXyZnnT80Kz1hILim
 ibGFgrFR3A9A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 06:21:59 -0700
IronPort-SDR: oaGBBMiFEtDI0vHr8jOq2s7krzrgEp/x0I1rnzuhwhBFkLZwHscv+f2WsU0c9Aw8XimoJHEJpT
 y9XDrGw3VfhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="403297318"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.173.189]) ([10.249.173.189])
  by orsmga004.jf.intel.com with ESMTP; 24 Apr 2020 06:21:58 -0700
Subject: Re: [RFC PATCH 2/3] kvm: x86: Use KVM_DEBUGREG_NEED_RELOAD instead of
 KVM_DEBUGREG_BP_ENABLED
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-3-xiaoyao.li@intel.com>
 <20200423192949.GO17824@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <ea6e0343-8c51-52c7-ba7b-48d3d4e7177a@intel.com>
Date:   Fri, 24 Apr 2020 21:21:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423192949.GO17824@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/24/2020 3:29 AM, Sean Christopherson wrote:
> On Thu, Apr 16, 2020 at 06:15:08PM +0800, Xiaoyao Li wrote:
>> Once any #BP enabled in DR7, it will set KVM_DEBUGREG_BP_ENABLED, which
>> leads to reload DRn before every VM entry even if none of DRn changed.
>>
>> Drop KVM_DEBUGREG_BP_ENABLED flag and set KVM_DEBUGREG_NEED_RELOAD flag
>> for the cases that DRn need to be reloaded instead, to avoid unnecessary
>> DRn reload.
> 
> Loading DRs on every VM-Enter _is_ necessary if there are breakpoints
> enabled for the guest.  The hardware DR values are not "stable", e.g. they
> are loaded with the host's values immediately after saving the guest's
> value (if DR_EXITING is disabled) in vcpu_enter_guest(), notably iff the
> host has an active/enabled breakpoint.  

May bad, bbviously I didn't think about it.

> My bet is that DRs can be changed
> from interrupt context as well.
So set KVM_DEBUGREG_NEED_RELOAD in vcpu_load won't help.

> Loading DRs for the guest (not necessarily the same as the guest's DRs) is
> necessary if a breakpoint is enabled so that the #DB is actually hit in
> guest.  It's a similar concept to instructions that consume MSR values,
> e.g. SYSCALL, RDTSCP, etc..., even if KVM intercepts the MSR/DR, hardware
> still needs the correct value so that the guest behavior is correct.
> 
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 3 +--
>>   arch/x86/kvm/x86.c              | 4 ++--
>>   2 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index f465c76e6e5a..87e2d020351e 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -509,9 +509,8 @@ struct kvm_pmu {
>>   struct kvm_pmu_ops;
>>   
>>   enum {
>> -	KVM_DEBUGREG_BP_ENABLED = 1,
>> +	KVM_DEBUGREG_NEED_RELOAD = 1,
>>   	KVM_DEBUGREG_WONT_EXIT = 2,
>> -	KVM_DEBUGREG_NEED_RELOAD = 4,
>>   };
>>   
>>   struct kvm_mtrr_range {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index cce926658d10..71264df64001 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1086,9 +1086,8 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
>>   	else
>>   		dr7 = vcpu->arch.dr7;
>>   	kvm_x86_ops.set_dr7(vcpu, dr7);
>> -	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
>>   	if (dr7 & DR7_BP_EN_MASK)
>> -		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
>> +		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
>>   }
>>   
>>   static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
>> @@ -1128,6 +1127,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>>   		break;
>>   	}
>>   
>> +	vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.20.1
>>

