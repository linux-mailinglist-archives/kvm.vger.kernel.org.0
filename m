Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDB452D0AC
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiESKi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiESKiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:38:21 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222FD64717;
        Thu, 19 May 2022 03:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652956701; x=1684492701;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/+Ar4sd87TUDOASn0zO7g0WfAL0BwgYVf7TqUGts/js=;
  b=KijP/hShzmnERom0QJbK/+jzmuPMok7+xszxbTWl8NJPkkymazwuL/zq
   v7CqYWEDv7GQ4a2giHes2ynKi4oNsGPc1YpNg3+Aom49/o1nNo57N4+iw
   3xAa1//KAKUQXoeP4k4PpU6Jk9bvkc/Bhw/+ROEJ2GzzMgKXpdAI7MUsy
   9xgnfuxOTExaBSS2O7oiPoWwQbZPSfmcqdEQ5XfL4K/fLPLX15Lpe1b/v
   puZD6he25MslAJtydy93CmlwK2yB8miRemgH/wBBCliMzCayYL2wcAvzT
   D4CJmvZB4uoAjmU3R6Htg6llrwXNXZpiFHcKMTHAcBY2VFHSn267WJgRt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="358541618"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="358541618"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 03:38:20 -0700
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="598489820"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.255.31.60]) ([10.255.31.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 03:38:18 -0700
Message-ID: <a3212daa-16d8-71a8-ef65-f73af268c089@intel.com>
Date:   Thu, 19 May 2022 18:38:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH v6 3/3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
 <20220421072958.16375-4-chenyi.qiang@intel.com> <YoVzf8tPgONxjmZM@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YoVzf8tPgONxjmZM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/19/2022 6:30 AM, Sean Christopherson wrote:
> On Thu, Apr 21, 2022, Chenyi Qiang wrote:
>> @@ -1504,6 +1511,8 @@ struct kvm_x86_ops {
>>   	 * Returns vCPU specific APICv inhibit reasons
>>   	 */
>>   	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>> +
>> +	bool has_notify_vmexit;
> 
> I'm pretty sure I suggested this, but seeing it in code, it kinda sorta makes things
> worst if we don't first consolidate the existing flags.  kvm_x86_ops works, but we'd
> definitely be taking liberties with the "ops" part.
> 
> What about adding struct kvm_caps to collect these flags/settings that don't fit
> into kvm_cpu_caps because they're not a CPUID feature flag?  kvm_x86_ops has the
> advantage of kinda being read-only after init since VMX modifies vmx_x86_ops,
> but IMO that's not enough reason to shove this into kvm_x86_ops.  And long term,
> we might be able find a way to mark kvm_caps as full __ro_after_init.
> 
> If no one objects, the attached patch can slide in before this patch, then
> has_notifiy_vmexit can land in kvm_caps.
> 
> struct kvm_caps {
> 	/* control of guest tsc rate supported? */
> 	bool has_tsc_control;
> 	/* maximum supported tsc_khz for guests */
> 	u32  max_guest_tsc_khz;
> 	/* number of bits of the fractional part of the TSC scaling ratio */
> 	u8   tsc_scaling_ratio_frac_bits;
> 	/* maximum allowed value of TSC scaling ratio */
> 	u64  max_tsc_scaling_ratio;
> 	/* 1ull << kvm_caps.tsc_scaling_ratio_frac_bits */
> 	u64  default_tsc_scaling_ratio;
> 	/* bus lock detection supported? */
> 	bool has_bus_lock_exit;
> 
> 	u64 supported_mce_cap;
> 	u64 supported_xcr0;
> 	u64 supported_xss;
> };
> 

Thanks Sean for your patch. I think an unintentional change is mixed in it:

@@ -4739,7 +4725,8 @@ static int 
kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
  	return (kvm_arch_interrupt_allowed(vcpu) &&
  		kvm_cpu_accept_dm_intr(vcpu) &&
  		!kvm_event_needs_reinjection(vcpu) &&
-		!vcpu->arch.exception.pending);
+		!vcpu->arch.exception.pending &&
+		!kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu));
  }

Maybe this should belong to the patch 1?

>> @@ -6090,6 +6094,18 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   		}
>>   		mutex_unlock(&kvm->lock);
>>   		break;
>> +	case KVM_CAP_X86_NOTIFY_VMEXIT:
>> +		r = -EINVAL;
>> +		if ((u32)cap->args[0] & ~KVM_X86_NOTIFY_VMEXIT_VALID_BITS)
>> +			break;
>> +		if (!kvm_x86_ops.has_notify_vmexit)
>> +			break;
>> +		if (!(u32)cap->args[0] & KVM_X86_NOTIFY_VMEXIT_ENABLED)
>> +			break;
>> +		kvm->arch.notify_window = cap->args[0] >> 32;
> 
> Setting notify_vmexit and notify_vmexit_flags needs to be done under kvm->lock,
> and changing notify_window if kvm->created_vcpus > 0 needs to disallowed, otherwise
> init_vmcs() will use the wrong value.
> 
> notify_vmexit_flags could be changed on the fly, but I doubt that's worth
> supporting as even the smallest amount of complexity will go unused.
> 
> So I think this?
> 

Make sense.

> 	case KVM_CAP_X86_NOTIFY_VMEXIT:
> 		r = -EINVAL;
> 		if ((u32)cap->args[0] & ~KVM_X86_NOTIFY_VMEXIT_VALID_BITS)
> 			break;
> 		if (!kvm_x86_ops.has_notify_vmexit)
> 			break;
> 		if (!(u32)cap->args[0] & KVM_X86_NOTIFY_VMEXIT_ENABLED)
> 			break;
> 		mutex_lock(&kvm->lock);
> 		if (!kvm->created_vcpus) {
> 			kvm->arch.notify_window = cap->args[0] >> 32;
> 			kvm->arch.notify_vmexit_flags = (u32)cap->args[0];
> 			r = 0;
> 		}
> 		mutex_unlock(&kvm->lock);
> 		break;

