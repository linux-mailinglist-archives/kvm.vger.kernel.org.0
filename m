Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD931EC10
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 17:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhBRQLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 11:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhBRNSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 08:18:30 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AE7C061756
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 05:17:49 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v62so3827760wmg.4
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 05:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dme-org.20150623.gappssmtp.com; s=20150623;
        h=to:cc:subject:in-reply-to:references:from:date:message-id
         :mime-version;
        bh=KBsy4+M5lR3eSmVo0u6hu7tNek39L40IUnAneMNB5ac=;
        b=AHi6bFWssp81XnIMNZ8D/ruIf7GhE2yv6WmRGyLd+EwD5HU8Mv3uLeSou/inUtxwxb
         XS6hEtpqPpvdkKEx1V9SJHegnM7LWImBQxwElWhpi7IL9QYWvOx1bf8JmRK0hUos7UBM
         i9lwp0i+JACp+UHmTPo1UqNOLyP71Edj3MptO6WoF/BCGIRiiRC4bRrpawBJrNxP+1H5
         Mr5j+JMgfxdIbfzCA9HuNNtXGwiQ7is87plEuAZ1tQzvTqM7edxRC2OL5htRt6N9hM1n
         ALBu03rWXOLqN8uc/fcyV0EO9fJV4306Xdx7XxFmN7on8PoulgybEVxpr8T/bhLSBGb/
         nzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:subject:in-reply-to:references:from:date
         :message-id:mime-version;
        bh=KBsy4+M5lR3eSmVo0u6hu7tNek39L40IUnAneMNB5ac=;
        b=aBsO+RSlfF2vByKpi3Wk6Md1zC+m2dykspidIJl2fGf5fd6SYizgN7OjnbK7Qowonw
         XFczZJZTR5Ozj99jBlZLO8eEI1nqdzx8dGNTKfLpGuzmw5UkLxfPRL97I/DP3p9Dp5iB
         WTkxnOeaEDaORsAZL5Rr5iu5gogGaty5LZA9KHpqtlTO6e53ZOqgYt2HI0wqvDEo78t/
         KHHk3seelZZlqIqs5lFipnkAu4V1NjADQIVVtKYtbGih4sgafWr+wngZ98Rb1NxIacPk
         VGcSF08cdZGInc4/pH/HTrNZKz5DLokc5IWaaP2BRZgW/zxzpM2D8eM7/NHIyq1fyj7T
         Zz7w==
X-Gm-Message-State: AOAM530hUpA95aya6hSPhTFS4N6rwFdveqOtkqgGtRyPhq00a8h7jIo/
        mWSQxTfv4YWh/ZsNTVicT2+tTfqJ6FQXi0YBVtM=
X-Google-Smtp-Source: ABdhPJzWk5s8LJ2kFDAbJjFbOoUoKBs9vVVetv+kordzFiHu0PES0GcDfjRAu8Qnji6LneILmYCcXA==
X-Received: by 2002:a1c:8096:: with SMTP id b144mr3667628wmd.169.1613654268328;
        Thu, 18 Feb 2021 05:17:48 -0800 (PST)
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net. [2001:8b0:bb71:7140:64::1])
        by smtp.gmail.com with ESMTPSA id s23sm7942062wmc.29.2021.02.18.05.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 05:17:47 -0800 (PST)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 81cd362e;
        Thu, 18 Feb 2021 13:17:46 +0000 (UTC)
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER
 is valid
In-Reply-To: <8f9d4ef7-ddad-160b-2d94-69f4370e8702@redhat.com>
References: <20210218100450.2157308-1-david.edmondson@oracle.com>
 <708f2956-fa0f-b008-d3d2-93067f95783c@redhat.com>
 <cuntuq9ilg4.fsf@dme.org>
 <8f9d4ef7-ddad-160b-2d94-69f4370e8702@redhat.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Thu, 18 Feb 2021 13:17:46 +0000
Message-ID: <cunr1ldikg5.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2021-02-18 at 14:01:40 +01, Paolo Bonzini wrote:

> On 18/02/21 13:56, David Edmondson wrote:
>> On Thursday, 2021-02-18 at 12:54:52 +01, Paolo Bonzini wrote:
>> 
>>> On 18/02/21 11:04, David Edmondson wrote:
>>>> When dumping the VMCS, retrieve the current guest value of EFER from
>>>> the kvm_vcpu structure if neither VM_EXIT_SAVE_IA32_EFER or
>>>> VM_ENTRY_LOAD_IA32_EFER is set, which can occur if the processor does
>>>> not support the relevant VM-exit/entry controls.
>>>
>>> Printing vcpu->arch.efer is not the best choice however.  Could we dump
>>> the whole MSR load/store area instead?
>> 
>> I'm happy to do that, and think that it would be useful, but it won't
>> help with the original problem (which I should have explained more).
>> 
>> If the guest has EFER_LMA set but we aren't using the entry/exit
>> controls, vm_read64(GUEST_IA32_EFER) returns 0, causing dump_vmcs() to
>> erroneously dump the PDPTRs.
>
> Got it now.  It would sort of help, because while dumping the MSR 
> load/store area you could get hold of the real EFER, and use it to 
> decide whether to dump the PDPTRs.

Okay, I'll do that and come back. Thanks!

> Thanks,
>
> Paolo
>
>
>>> Paolo
>>>
>>>> Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
>>>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>>>> ---
>>>>    arch/x86/kvm/vmx/vmx.c | 14 +++++++++-----
>>>>    arch/x86/kvm/vmx/vmx.h |  2 +-
>>>>    2 files changed, 10 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index eb69fef57485..74ea4fe6f35e 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -5754,7 +5754,7 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
>>>>    	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
>>>>    }
>>>>    
>>>> -void dump_vmcs(void)
>>>> +void dump_vmcs(struct kvm_vcpu *vcpu)
>>>>    {
>>>>    	u32 vmentry_ctl, vmexit_ctl;
>>>>    	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
>>>> @@ -5771,7 +5771,11 @@ void dump_vmcs(void)
>>>>    	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
>>>>    	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
>>>>    	cr4 = vmcs_readl(GUEST_CR4);
>>>> -	efer = vmcs_read64(GUEST_IA32_EFER);
>>>> +	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
>>>> +	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
>>>> +		efer = vmcs_read64(GUEST_IA32_EFER);
>>>> +	else
>>>> +		efer = vcpu->arch.efer;
>>>>    	secondary_exec_control = 0;
>>>>    	if (cpu_has_secondary_exec_ctrls())
>>>>    		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
>>>> @@ -5955,7 +5959,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>>>>    	}
>>>>    
>>>>    	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
>>>> -		dump_vmcs();
>>>> +		dump_vmcs(vcpu);
>>>>    		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
>>>>    		vcpu->run->fail_entry.hardware_entry_failure_reason
>>>>    			= exit_reason;
>>>> @@ -5964,7 +5968,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>>>>    	}
>>>>    
>>>>    	if (unlikely(vmx->fail)) {
>>>> -		dump_vmcs();
>>>> +		dump_vmcs(vcpu);
>>>>    		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
>>>>    		vcpu->run->fail_entry.hardware_entry_failure_reason
>>>>    			= vmcs_read32(VM_INSTRUCTION_ERROR);
>>>> @@ -6049,7 +6053,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>>>>    
>>>>    unexpected_vmexit:
>>>>    	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
>>>> -	dump_vmcs();
>>>> +	dump_vmcs(vcpu);
>>>>    	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>>>>    	vcpu->run->internal.suberror =
>>>>    			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>>> index 9d3a557949ac..f8a0ce74798e 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.h
>>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>>> @@ -489,6 +489,6 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
>>>>    	return is_unrestricted_guest(vcpu) || __vmx_guest_state_valid(vcpu);
>>>>    }
>>>>    
>>>> -void dump_vmcs(void);
>>>> +void dump_vmcs(struct kvm_vcpu *vcpu);
>>>>    
>>>>    #endif /* __KVM_X86_VMX_H */
>>>>
>> 
>> dme.
>> 

dme.
-- 
But he said, leave me alone, I'm a family man.
