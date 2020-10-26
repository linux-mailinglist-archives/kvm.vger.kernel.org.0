Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF0629868D
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 06:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768813AbgJZFbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 01:31:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:59405 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768799AbgJZFbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 01:31:42 -0400
IronPort-SDR: SZr3QPqWCNb2VQJvzOLP1lCWllkYXeUm60HgscWf/2LsScDJYIiSPheLGCoGU4C/CWswfouaPm
 M/347w+OvVBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="168004179"
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="168004179"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2020 22:31:40 -0700
IronPort-SDR: fsc1bsyo4Ds+/OwR+SjIoEJtCTgoIqIIzIMma15t+HxFdyP5Gq9ihWWrFV6o/gDA4yLTYcB2Jz
 g+wI7imqg51A==
X-IronPort-AV: E=Sophos;i="5.77,417,1596524400"; 
   d="scan'208";a="535233013"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.131]) ([10.238.0.131])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2020 22:31:37 -0700
Subject: Re: [RESEND v4 2/2] KVM: VMX: Enable bus lock VM exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201012033542.4696-1-chenyi.qiang@intel.com>
 <20201012033542.4696-3-chenyi.qiang@intel.com>
 <20201020221943.GB9031@linux.intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <be3f9775-c6d3-c2ca-dd60-bd627e6db38b@intel.com>
Date:   Mon, 26 Oct 2020 13:31:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201020221943.GB9031@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/21/2020 6:19 AM, Sean Christopherson wrote:
> On Mon, Oct 12, 2020 at 11:35:42AM +0800, Chenyi Qiang wrote:
>> @@ -6138,6 +6149,26 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>>   	return 0;
>>   }
>>   
>> +static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>> +{
>> +	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
>> +
>> +	/*
>> +	 * Even when current exit reason is handled by KVM internally, we
>> +	 * still need to exit to user space when bus lock detected to inform
>> +	 * that there is a bus lock in guest.
>> +	 */
>> +	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
>> +		if (ret > 0)
>> +			vcpu->run->exit_reason = KVM_EXIT_BUS_LOCK;
>> +		else
>> +			vcpu->run->flags |= KVM_RUN_BUS_LOCK;
> 
> This should always set flags.KVM_RUN_BUS_LOCK, e.g. so that userspace can
> always check flags.KVM_RUN_BUS_LOCK instead of having to check both the flag
> and the exit reason.  As is, it's really bad because the flag is undefined,
> which could teach userspace to do the wrong thing.
> 

Got it.

>> +		return 0;
>> +	}
>> +	vcpu->run->flags &= ~KVM_RUN_BUS_LOCK;
> 
> Hmm, I feel like explicitly clearing flags is should be unnecessary.  By
> that, I mean that's it's necessary in the current patch, bit I think we should
> figure out how to make that not be the case.  With the current approach, every
> chunk of code that needs to set a flag also needs to clear it, which increases
> the odds of missing a case and ending up with a flag in an undefined state.
> 
> The easiest way I can think of is to add another prep patch that zeros
> run->flags at the beginning of kvm_arch_vcpu_ioctl_run(), and changes
> post_kvm_run_save() to do:
> 
> 	if (is_smm(vcpu))
> 		kvm_run->flags |= KVM_RUN_X86_SMM;
> 
> Then this patch can omit clearing KVM_RUN_BUS_LOCK, and doesn't have to touch
> the SMM flag.
> 

Make sense, I will add the prep patch.

>> +	return ret;
>> +}
>> +
>>   /*
>>    * Software based L1D cache flush which is used when microcode providing
>>    * the cache control MSR is not loaded.
