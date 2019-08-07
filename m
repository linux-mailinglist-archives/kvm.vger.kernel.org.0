Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA684A70
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 13:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfHGLO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 07:14:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37987 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfHGLO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 07:14:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so58253048wmj.3
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2019 04:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=y61pF4RFnTPgiXMb8UiIVaCdJYhXdQcP+s8W9hR9nwo=;
        b=O3yvD6fpvVfYGDx6Re+DwnMP9oOqGR5TsDquvR1sYSaCWorC4Hcm6E7S/mOKmwB9e+
         u+tOHWg5wlo0W+LAcWVZW22RMs8rEvuzApLfgHgHq8Z9P73B4X8+ab0hEw8jm0oAmxCT
         RWtKgerkFC61ajf9qMqEZh/q+s5djid6Zp7ROnLcj1nlazbxxaLEx47X5acxqeWBGrpl
         gzyVg5BWxfs2jiU5wvzQ16oCs7T6qoIcfIUiZfLQEbgkfI3A9m53GBXpFA0Fc1aP7cbX
         pOFzl5LQHZ1HRDy8F/BqQYQzmQjNYI461rQ+bQanMKDDFhSpupVfeonRHhjBGV6n9Orm
         vPgQ==
X-Gm-Message-State: APjAAAXrdSLU3g5TKGVSm21UNMS0y9hFFpXYzqRQ2w9OB2xXZyOK/H51
        IHfKzqW+jLd/oTnpbG0PcxCHBQ==
X-Google-Smtp-Source: APXvYqySk4wLcLXbgC9LugXvVMKqcLx1M5vgu9IFBiN0rZ3l0tz8mjMAqRwOV7B5OOWem7zw56Z0yQ==
X-Received: by 2002:a1c:c2d5:: with SMTP id s204mr10535657wmf.174.1565176493432;
        Wed, 07 Aug 2019 04:14:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f12sm100626534wrg.5.2019.08.07.04.14.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 04:14:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 5/5] x86: KVM: svm: remove hardcoded instruction length from intercepts
In-Reply-To: <20190806161133.GF27766@linux.intel.com>
References: <20190806060150.32360-1-vkuznets@redhat.com> <20190806060150.32360-6-vkuznets@redhat.com> <20190806161133.GF27766@linux.intel.com>
Date:   Wed, 07 Aug 2019 13:14:51 +0200
Message-ID: <87ftmddy6s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Aug 06, 2019 at 08:01:50AM +0200, Vitaly Kuznetsov wrote:
>> Various intercepts hard-code the respective instruction lengths to optimize
>> skip_emulated_instruction(): when next_rip is pre-set we skip
>> kvm_emulate_instruction(vcpu, EMULTYPE_SKIP). The optimization is, however,
>> incorrect: different (redundant) prefixes could be used to enlarge the
>> instruction. We can't really avoid decoding.
>> 
>> svm->next_rip is not used when CPU supports 'nrips' (X86_FEATURE_NRIPS)
>> feature: next RIP is provided in VMCB. The feature is not really new
>> (Opteron G3s had it already) and the change should have zero affect.
>> 
>> Remove manual svm->next_rip setting with hard-coded instruction lengths.
>> The only case where we now use svm->next_rip is EXIT_IOIO: the instruction
>> length is provided to us by hardware.
>> 
>> Reported-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/svm.c | 15 ++-------------
>>  1 file changed, 2 insertions(+), 13 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 793a60461abe..dce215250d1f 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -2905,13 +2905,11 @@ static int nop_on_interception(struct vcpu_svm *svm)
>>  
>>  static int halt_interception(struct vcpu_svm *svm)
>>  {
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 1;
>>  	return kvm_emulate_halt(&svm->vcpu);
>>  }
>>  
>>  static int vmmcall_interception(struct vcpu_svm *svm)
>>  {
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>  	return kvm_emulate_hypercall(&svm->vcpu);
>>  }
>>  
>> @@ -3699,7 +3697,6 @@ static int vmload_interception(struct vcpu_svm *svm)
>>  
>>  	nested_vmcb = map.hva;
>>  
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>  	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>>  
>>  	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
>> @@ -3726,7 +3723,6 @@ static int vmsave_interception(struct vcpu_svm *svm)
>>  
>>  	nested_vmcb = map.hva;
>>  
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>  	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>>  
>>  	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
>> @@ -3740,8 +3736,8 @@ static int vmrun_interception(struct vcpu_svm *svm)
>>  	if (nested_svm_check_permissions(svm))
>>  		return 1;
>>  
>> -	/* Save rip after vmrun instruction */
>> -	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
>> +	if (!kvm_skip_emulated_instruction(&svm->vcpu))
>> +		return 1;
>
> This is broken, e.g. KVM shouldn't resume the guest on single-step strap,
> nor should it skip the meat of VMRUN emulation.  There are also several
> pre-existing bugs, e.g. #GP can be injected due to invalid vmcb_gpa after
> %rip is incremented and single-step #DB can be suppressed on failed
> VMRUN (assuming that's not architectural behavior?).
>
> Calling kvm_skip_emulated_instruction() after nested_svm_vmrun() looks like
> it'd cause all kinds of problems, so I think the correct fix is to put the
> call to kvm_skip_emulated_instruction() inside nested_svm_vmrun(), after
> it maps the vmcb_gpa, e.g. something like this in the end (optionally
> moving nested_svm_vmrun_msrpm() inside nested_svm_run() to eliminate the
> weird goto handling).

I see, thank you for the suggestion, will do in the next version. I'll
split vmrun fix from removing hardcoded instruction lengths from other
intercepts.

>
> static int nested_svm_vmrun(struct vcpu_svm *svm)
> {
> 	int rc, ret;
> 	struct vmcb *nested_vmcb;
> 	struct vmcb *hsave = svm->nested.hsave;
> 	struct vmcb *vmcb = svm->vmcb;
> 	struct kvm_host_map map;
> 	u64 vmcb_gpa;
>
> 	vmcb_gpa = svm->vmcb->save.rax;
>
> 	rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(vmcb_gpa), &map);
> 	if (rc == -EINVAL)
> 		kvm_inject_gp(&svm->vcpu, 0);
> 		return 1;
> 	}
>
> 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
> 	if (rc)
> 		return ret;
>
> 	nested_vmcb = map.hva;
>
> 	if (!nested_vmcb_checks(nested_vmcb)) {
> 		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
> 		nested_vmcb->control.exit_code_hi = 0;
> 		nested_vmcb->control.exit_info_1  = 0;
> 		nested_vmcb->control.exit_info_2  = 0;
>
> 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
>
> 		return ret;
> 	}
>
> 	<  ... more existing code ... >
>
> 	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
>
> 	if (!nested_svm_vmrun_msrpm(svm)) {
> 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> 		svm->vmcb->control.exit_code_hi = 0;
> 		svm->vmcb->control.exit_info_1  = 0;
> 		svm->vmcb->control.exit_info_2  = 0;
>
> 		nested_svm_vmexit(svm);
> 	}
>
> 	return ret;
> }
>
> static int vmrun_interception(struct vcpu_svm *svm)
> {
> 	if (nested_svm_check_permissions(svm))
> 		return 1;
>
> 	return nested_svm_vmrun(svm)
> }
>
>>  
>>  	if (!nested_svm_vmrun(svm))
>>  		return 1;
>> @@ -3777,7 +3773,6 @@ static int stgi_interception(struct vcpu_svm *svm)
>>  	if (vgif_enabled(svm))
>>  		clr_intercept(svm, INTERCEPT_STGI);
>>  
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>  	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>>  	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>>  
>> @@ -3793,7 +3788,6 @@ static int clgi_interception(struct vcpu_svm *svm)
>>  	if (nested_svm_check_permissions(svm))
>>  		return 1;
>>  
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>  	ret = kvm_skip_emulated_instruction(&svm->vcpu);
>>  
>>  	disable_gif(svm);
>> @@ -3818,7 +3812,6 @@ static int invlpga_interception(struct vcpu_svm *svm)
>>  	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
>>  	kvm_mmu_invlpg(vcpu, kvm_rax_read(&svm->vcpu));
>>  
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>  	return kvm_skip_emulated_instruction(&svm->vcpu);
>>  }
>>  
>> @@ -3841,7 +3834,6 @@ static int xsetbv_interception(struct vcpu_svm *svm)
>>  	u32 index = kvm_rcx_read(&svm->vcpu);
>>  
>>  	if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
>> -		svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>  		return kvm_skip_emulated_instruction(&svm->vcpu);
>>  	}
>>  
>> @@ -3918,7 +3910,6 @@ static int task_switch_interception(struct vcpu_svm *svm)
>>  
>>  static int cpuid_interception(struct vcpu_svm *svm)
>>  {
>> -	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
>>  	return kvm_emulate_cpuid(&svm->vcpu);
>>  }
>>  
>> @@ -4248,7 +4239,6 @@ static int rdmsr_interception(struct vcpu_svm *svm)
>>  
>>  		kvm_rax_write(&svm->vcpu, msr_info.data & 0xffffffff);
>>  		kvm_rdx_write(&svm->vcpu, msr_info.data >> 32);
>> -		svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
>>  		return kvm_skip_emulated_instruction(&svm->vcpu);
>>  	}
>>  }
>> @@ -4454,7 +4444,6 @@ static int wrmsr_interception(struct vcpu_svm *svm)
>>  		return 1;
>>  	} else {
>>  		trace_kvm_msr_write(ecx, data);
>> -		svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
>>  		return kvm_skip_emulated_instruction(&svm->vcpu);
>>  	}
>>  }
>> -- 
>> 2.20.1
>> 

-- 
Vitaly
