Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47DB25B7BC
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 02:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgICAws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 20:52:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:3119 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgICAwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 20:52:47 -0400
IronPort-SDR: qGDlemQJ5qO3Olpqvg138xEO7okIgIE5t/tv2JQEkM0Csm5jhSvAu/d+z05QTrPKx6wpQBZXHQ
 bzDwCZwAnU7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="219054318"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="219054318"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 17:52:46 -0700
IronPort-SDR: fR6rsbbP0eppyoZf/XqS7rhZqUYoZaA+iUqv5V1/UsAEJi2YONAezYMoj5ggx5wRzWrxCQ8LHM
 M38a9bbskKRw==
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="326007452"
Received: from hongjunt-mobl.ccr.corp.intel.com (HELO [10.254.210.138]) ([10.254.210.138])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 17:52:43 -0700
Subject: Re: [RFC v2 2/2] KVM: VMX: Enable bus lock VM exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200817014459.28782-1-chenyi.qiang@intel.com>
 <20200817014459.28782-3-chenyi.qiang@intel.com>
 <87sgc1x4yn.fsf@vitty.brq.redhat.com> <20200902224405.GK11695@sjchrist-ice>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <2e12df9d-4d56-d6c2-3470-9c990ab722c5@intel.com>
Date:   Thu, 3 Sep 2020 08:52:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200902224405.GK11695@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/2020 6:44 AM, Sean Christopherson wrote:
> On Tue, Sep 01, 2020 at 10:43:12AM +0200, Vitaly Kuznetsov wrote:
>>> @@ -6809,6 +6824,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>   	if (unlikely(vmx->exit_reason.failed_vmentry))
>>>   		return EXIT_FASTPATH_NONE;
>>>   
>>> +	/*
>>> +	 * check the exit_reason to see if there is a bus lock
>>> +	 * happened in guest.
>>> +	 */
>>> +	if (kvm_bus_lock_exit_enabled(vmx->vcpu.kvm)) {
>>> +		if (vmx->exit_reason.bus_lock_detected) {
>>> +			vcpu->stat.bus_locks++;
> 
> Why bother with stats?  Every bus lock exits to userspace, having quick
> stats doesn't seem all that interesting.

OK. We will remove it.

>>> +			vcpu->arch.bus_lock_detected = true;
>>> +		} else {
>>> +			vcpu->arch.bus_lock_detected = false;
>>
>> This is a fast path so I'm wondering if we can move bus_lock_detected
>> clearing somewhere else.
> 
> Why even snapshot vmx->exit_reason.bus_lock_detected?  I don't see any
> reason why vcpu_enter_guest() needs to handle the exit to userspace, e.g.
> it's just as easily handled in VMX code.

Because we want to handle the exit to userspace only in one place, i.e., 
after kvm_x86_ops.handle_exit(vcpu, exit_fastpath). Otherwise, we would 
have to check vmx->exit_reason.bus_lock_detected in every other handler, 
at least in those can preempt the bus lock VM-exit theoretically.

>>
>>> +		}
>>> +	}
>>> +
>>>   	vmx->loaded_vmcs->launched = 1;
>>>   	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
>>>   
>>> @@ -8060,6 +8088,9 @@ static __init int hardware_setup(void)
>>>   		kvm_tsc_scaling_ratio_frac_bits = 48;
>>>   	}
>>>   
>>> +	if (cpu_has_vmx_bus_lock_detection())
>>> +		kvm_has_bus_lock_exit = true;
>>> +
>>>   	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
>>>   
>>>   	if (enable_ept)
> 
> ...
> 
>>> @@ -4990,6 +4996,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>>   		kvm->arch.exception_payload_enabled = cap->args[0];
>>>   		r = 0;
>>>   		break;
>>> +	case KVM_CAP_X86_BUS_LOCK_EXIT:
>>> +		if (!kvm_has_bus_lock_exit)
>>> +			return -EINVAL;
>>
>> ... because userspace can check for -EINVAL when enabling the cap. Or we
>> can return e.g. -EOPNOTSUPP here. I don't have a strong opinion on the matter..
>>
>>> +		kvm->arch.bus_lock_exit = cap->args[0];
> 
> Assuming we even want to make this per-VM, I think it'd make sense to make
> args[0] a bit mask, e.g. to provide "off" and "exit" (this behavior) while
> allowing for future modes, e.g. log-only.

Good idea, will do it in next version.

>>> +		r = 0;
>>> +		break;
>>>   	default:
>>>   		r = -EINVAL;
>>>   		break;
>>> @@ -7732,12 +7744,23 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)

