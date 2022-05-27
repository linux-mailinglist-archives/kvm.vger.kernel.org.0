Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560ED535DAA
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 11:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350701AbiE0JzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 05:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbiE0JzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 05:55:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741EB3C73B;
        Fri, 27 May 2022 02:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653645313; x=1685181313;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZyWOtJY59nmOplfP/uzgYfu+eDMjfw81LAwJrsXTNIA=;
  b=S4plgQPK1XNFoG/oshKqLnRuINkHubDLVP2uV8t6+5mV03128NbiiCuX
   QMsxGi8b0Yj37wLsTPxoGM8/asblPSwQMm7ajfynkdOEk6RNXNyxT047i
   nljXMy5gji6nVzmAem3846kiLukKooCSBQjCOtzpguqjCaquX9/vPjHOR
   hFtcEtxE55/11/jQyOdr0VYKxz3wXT1bD65pDnmvs4k7ZXew530U1bi2q
   bKD6I4d/uDHp0aidtVyBp3b3+0PthLort23KFj9JTDB9ARXbYjn377Uye
   JHxC8+tTK+n5LhrQHvt05smfIyOPw0mkMTEr8NA8tSlexA1EZh1GuApJV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="256509345"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="256509345"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:55:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="705049445"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.236]) ([10.254.211.236])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:55:10 -0700
Message-ID: <dac0543e-368a-a19e-510a-b9536dc25af6@intel.com>
Date:   Fri, 27 May 2022 17:55:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH v7 8/8] KVM: VMX: Enable PKS for nested VM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chenyi.qiang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20220424101557.134102-9-lei4.wang@intel.com> <Yobt1XwOfb5M6Dfa@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <Yobt1XwOfb5M6Dfa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/2022 9:24 AM, Sean Christopherson wrote:
> Nit, use "KVM: nVMX:" for the shortlog scope.

Will change it.

> On Sun, Apr 24, 2022, Lei Wang wrote:
>> @@ -2433,6 +2437,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>>   		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>   			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>> +
>> +		if (vmx->nested.nested_run_pending &&
>> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
>> +			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
> As mentioned in the BNDCFGS thread, this does the wrong thing for SMM.  But, after
> a lot of thought, handling this in nested_vmx_enter_non_root_mode() would be little
> more than a band-aid, and a messy one at that, because KVM's SMM emulation is
> horrifically broken with respect to nVMX.
>
> Entry does to SMM does not modify _any_ state that is not saved in SMRAM.  That
> we're having to deal with this crap is a symptom of KVM doing the complete wrong
> thing by piggybacking nested_vmx_vmexit() and nested_vmx_enter_non_root_mode().
>
> The SDM's description of CET spells this out very, very clearly:
>
>    On processors that support CET shadow stacks, when the processor enters SMM,
>    the processor saves the SSP register to the SMRAM state save area (see Table 31-3)
>    and clears CR4.CET to 0. Thus, the initial execution environment of the SMI handler
>    has CET disabled and all of the CET state of the interrupted program is still in the
>    machine. An SMM that uses CET is required to save the interrupted program’s CET
>    state and restore the CET state prior to exiting SMM.
>
> It mostly works because no guest SMM handler does anything with most of the MSRs,
> but it's all wildy wrong.  A concrete example of a lurking bug is if vmcs12 uses
> the VM-Exit MSR load list, in which case the forced nested_vmx_vmexit() will load
> state that is never undone.
>
> So, my very strong vote is to ignore SMM and let someone who actually cares about
> SMM fix that mess properly by adding custom flows for exiting/re-entering L2 on
> SMI/RSM.

OK, I will leave the mess alone.

>>   	}
>>   
>>   	if (nested_cpu_has_xsaves(vmcs12))
>> @@ -2521,6 +2529,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>   	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>>   	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>>   		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> ERROR: trailing whitespace
> #85: FILE: arch/x86/kvm/vmx/nested.c:3407:
> +^Iif (kvm_cpu_cap_has(X86_FEATURE_PKS) && $

Sorry for my carelessness, will remove the trailing whitespace.

>> +	    (!vmx->nested.nested_run_pending ||
>> +	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
>> +		vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
>> +
>>   	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>>   
>>   	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
>> @@ -2897,6 +2910,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>>   					   vmcs12->host_ia32_perf_global_ctrl)))
>>   		return -EINVAL;
>>   
>> +	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
>> +	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
>> +		return -EINVAL;
>> +
>>   #ifdef CONFIG_X86_64
>>   	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
>>   #else
>> @@ -3049,6 +3066,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>>   	if (nested_check_guest_non_reg_state(vmcs12))
>>   		return -EINVAL;
>>   
>> +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
>> +	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
>> +		return -EINVAL;
>> +
>>   	return 0;
>>   }
>>   
>> @@ -3384,6 +3405,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>>   	    (!from_vmentry ||
>>   	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>>   		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
>> +	    (!from_vmentry ||
> This should be "!vmx->nested.nested_run_pending" instead of "!from_vmentry" to
> avoid the unnecessary VMREAD when restoring L2 with a pending VM-Enter.

Will fix that.

>> +	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
>> +		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
>>   
>>   	/*
>>   	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> ...
>
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 91723a226bf3..82f79ac46d7b 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -222,6 +222,8 @@ struct nested_vmx {
>>   	u64 vmcs01_debugctl;
>>   	u64 vmcs01_guest_bndcfgs;
>>   
> Please pack these together, i.e. don't have a blank line between the various
> vmcs01_* fields.

OK, will check them and remove the blank lines.

