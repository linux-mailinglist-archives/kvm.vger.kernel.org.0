Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A474F9AD9
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiDHQnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiDHQnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:43:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B652A10E9;
        Fri,  8 Apr 2022 09:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649436079; x=1680972079;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aAbi/qmKq+r/hL4lQDiEEDWm+BnU3Db3wanrG3/Vskg=;
  b=RjnOTixhwA9lwoKCBk2+xaerM8hMPcB47cZjmyeOTLzJCbS2JSxn0LBD
   taT1hPg2zYxrZUo5uddpjvwlZT+fvhzQIEuQeRztUqxT+2kJRsSG6sStz
   oWUeZzW6Lv95vmEJlLUrBSvCflKl07AKzA5IB6UFhJVrUnhNvNnQUIN9K
   kVn20bf5SYiMVKl5YHwbtJ7bIk8FWezleaM21bejZDqj6ggzf8gu5S4tQ
   5CbsM82QnMtWxc+XtatlzH0elCB+rrx5JxERE8l1YEQ7iYEpcVkHzM7eb
   SGGaifQVyR2UriXi9Kjo9T2BgH+pODCU0ulORxV/FU1hL/sBpQeqXzH2/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="243768602"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="243768602"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 09:41:19 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="571547038"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.213.22]) ([10.254.213.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 09:41:14 -0700
Message-ID: <b8f753b0-1b57-3e42-3516-27cc0359c584@intel.com>
Date:   Sat, 9 Apr 2022 00:41:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 8/8] KVM: VMX: enable IPI virtualization
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
        "Gao, Chao" <chao.gao@intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-9-guang.zeng@intel.com> <YkZlhI7nAAqDhT0D@google.com>
 <54df6da8-ad68-cc75-48db-d18fc87430e9@intel.com>
 <YksxiAnNmdR2q65S@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YksxiAnNmdR2q65S@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/5/2022 1:57 AM, Sean Christopherson wrote:
> On Sun, Apr 03, 2022, Zeng Guang wrote:
>> On 4/1/2022 10:37 AM, Sean Christopherson wrote:
>>>> @@ -4219,14 +4226,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>>>>    	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
>>>>    	if (cpu_has_secondary_exec_ctrls()) {
>>>> -		if (kvm_vcpu_apicv_active(vcpu))
>>>> +		if (kvm_vcpu_apicv_active(vcpu)) {
>>>>    			secondary_exec_controls_setbit(vmx,
>>>>    				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
>>>>    				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
>>>> -		else
>>>> +			if (enable_ipiv)
>>>> +				tertiary_exec_controls_setbit(vmx,
>>>> +						TERTIARY_EXEC_IPI_VIRT);
>>>> +		} else {
>>>>    			secondary_exec_controls_clearbit(vmx,
>>>>    					SECONDARY_EXEC_APIC_REGISTER_VIRT |
>>>>    					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
>>>> +			if (enable_ipiv)
>>>> +				tertiary_exec_controls_clearbit(vmx,
>>>> +						TERTIARY_EXEC_IPI_VIRT);
>>> Oof.  The existing code is kludgy.  We should never reach this point without
>>> enable_apicv=true, and enable_apicv should be forced off if APICv isn't supported,
>>> let alone seconary exec being support.
>>>
>>> Unless I'm missing something, throw a prep patch earlier in the series to drop
>>> the cpu_has_secondary_exec_ctrls() check, that will clean this code up a smidge.
>> cpu_has_secondary_exec_ctrls() check can avoid wrong vmcs write in case mistaken
>> invocation.
> KVM has far bigger problems on buggy invocation, and in that case the resulting
> printk + WARN from the failed VMWRITE is a good thing.


SDM doesn't define VMWRITE failure for such case. But it says the logical
processor operates as if all the secondary processor-based VM-execution
controls were 0 if "activate secondary controls" primary processor-based
VM-execution control is 0. So we may add WARN() to detect this kind of
buggy invocation instead.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 61e075e16c19..6c370b507b45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4200,22 +4200,22 @@ static void vmx_refresh_apicv_exec_ctrl(struct 
kvm_vcpu *vcpu)
         struct vcpu_vmx *vmx = to_vmx(vcpu);

         pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
-       if (cpu_has_secondary_exec_ctrls()) {
-               if (kvm_vcpu_apicv_active(vcpu)) {
-                       secondary_exec_controls_setbit(vmx,
- SECONDARY_EXEC_APIC_REGISTER_VIRT |
- SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-                       if (enable_ipiv)
-                               tertiary_exec_controls_setbit(vmx,
- TERTIARY_EXEC_IPI_VIRT);
-               } else {
-                       secondary_exec_controls_clearbit(vmx,
- SECONDARY_EXEC_APIC_REGISTER_VIRT |
- SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-                       if (enable_ipiv)
- tertiary_exec_controls_clearbit(vmx,
- TERTIARY_EXEC_IPI_VIRT);
-               }
+
+       WARN(!cpu_has_secondary_exec_ctrls(),
+                    "VMX: unexpected vmwrite with inactive secondary 
exec controls");
+
+       if (kvm_vcpu_apicv_active(vcpu)) {
+               secondary_exec_controls_setbit(vmx,
+                             SECONDARY_EXEC_APIC_REGISTER_VIRT |
+ SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+               if (enable_ipiv)
+                       tertiary_exec_controls_setbit(vmx, 
TERTIARY_EXEC_IPI_VIRT);
+       } else {
+               secondary_exec_controls_clearbit(vmx,
+                             SECONDARY_EXEC_APIC_REGISTER_VIRT |
+ SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+               if (enable_ipiv)
+                       tertiary_exec_controls_clearbit(vmx, 
TERTIARY_EXEC_IPI_VIRT);
         }

         vmx_update_msr_bitmap_x2apic(vcpu);

>
>>>> +	 */
>>>> +	if (vmx_can_use_ipiv(vcpu->kvm)) {
>>>> +		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
>>>> +
>>>> +		mutex_lock(&vcpu->kvm->lock);
>>>> +		err = vmx_alloc_pid_table(kvm_vmx);
>>>> +		mutex_unlock(&vcpu->kvm->lock);
>>> This belongs in vmx_vm_init(), doing it in vCPU creation is a remnant of the
>>> dynamic resize approach that's no longer needed.
>> We cannot allocate pid table in vmx_vm_init() as userspace has no chance to
>> set max_vcpu_ids at this stage. That's the reason we do it in vCPU creation
>> instead.
> Ah, right.  Hrm.  And that's going to be a recurring problem if we try to use the
> dynamic kvm->max_vcpu_ids to reduce other kernel allocations.
>
> Argh, and even kvm_arch_vcpu_precreate() isn't protected by kvm->lock.
>
> Taking kvm->lock isn't problematic per se, I just hate doing it so deep in a
> per-vCPU flow like this.
>
> A really gross hack/idea would be to make this 64-bit only and steal the upper
> 32 bits of @type in kvm_create_vm() for the max ID.
>
> I think my first choice would be to move kvm_arch_vcpu_precreate() under kvm->lock.
> None of the architectures that have a non-nop implemenation (s390, arm64 and x86)
> do significant work, so holding kvm->lock shouldn't harm performance.  s390 has to
> acquire kvm->lock in its implementation, so we could drop that.  And looking at
> arm64, I believe its logic should also be done under kvm->lock.
>
> It'll mean adding yet another kvm_x86_ops, but I like that more than burying the
> code deep in vCPU creation.
>
> Paolo, any thoughts on this?

Sounds reasonable. I will prepare patch to refactor the 
kvm_arch_vcpu_precreate()
and make pid table allocation done there.

Thanks.

