Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6BD4F5AB7
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352880AbiDFKX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357288AbiDFKWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:22:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C6917AB3;
        Tue,  5 Apr 2022 23:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649227625; x=1680763625;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JRb3SzOQESj6NEoJIznEzSTJmuuLPgnO38vSPHZXK34=;
  b=VQNeVav8WhLbRDu6n+sxEPXljbYva9FqwFJOjY54tHMoOHWklA1xJiqI
   OAwNZZtrYqupTpffVbEUHKppu1Wt3x6J9GP2536B4wt7/MmUKN0V6WWvB
   8fxHh+TKUycRuD9X6GZRCYoElh3SH054WmgoeCY1VX9wx9l2UIAUzwm0i
   oTahWijIXigBbrlMHuifG0uE4h3OOS5cLWF5TqAFYu3XVW7PdLS3RrGSw
   TT5CAGkljg1uS+TKH8jSW900aSpreiIwOCB5LRDpn/spWeKt7/E4Pmgru
   fGW4NgAnfR7Ym+BUl7czWyNBz8yS8a7UvrnO5WNdbYCt1aZCLmKDeMtJC
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="260959912"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="260959912"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 23:47:04 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="549413737"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.170.41]) ([10.249.170.41])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 23:47:02 -0700
Message-ID: <9b45d2bc-9bb3-53a1-3eb3-4b1bf6987268@intel.com>
Date:   Wed, 6 Apr 2022 14:46:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v5 1/3] KVM: X86: Save&restore the triple fault request
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com> <YkzRSHHDMaVBQrxd@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YkzRSHHDMaVBQrxd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/2022 7:31 AM, Sean Christopherson wrote:
> On Fri, Mar 18, 2022, Chenyi Qiang wrote:
>> For the triple fault sythesized by KVM, e.g. the RSM path or
>> nested_vmx_abort(), if KVM exits to userspace before the request is
>> serviced, userspace could migrate the VM and lose the triple fault.
>> Fix this issue by adding a new event KVM_VCPUEVENT_TRIPLE_FAULT in
>> get/set_vcpu_events() to track the triple fault request.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   Documentation/virt/kvm/api.rst  | 6 ++++++
>>   arch/x86/include/uapi/asm/kvm.h | 1 +
>>   arch/x86/kvm/x86.c              | 9 ++++++++-
>>   3 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 691ff84444bd..9682b0a438bd 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -1146,6 +1146,9 @@ The following bits are defined in the flags field:
>>     fields contain a valid state. This bit will be set whenever
>>     KVM_CAP_EXCEPTION_PAYLOAD is enabled.
>>   
>> +- KVM_VCPUEVENT_TRIPLE_FAULT may be set to signal that there's a
>> +  triple fault request waiting to be serviced.
> 
> Please avoid "request" in the docs, as before, that's a KVM implemenation detail.
> For this one, maybe "there's a pending triple fault event"?
> 
>> +
>>   ARM/ARM64:
>>   ^^^^^^^^^^
>>   
>> @@ -1241,6 +1244,9 @@ can be set in the flags field to signal that the
>>   exception_has_payload, exception_payload, and exception.pending fields
>>   contain a valid state and shall be written into the VCPU.
>>   
>> +KVM_VCPUEVENT_TRIPLE_FAULT can be set in flags field to signal that a
>> +triple fault request should be made.
> 
> 
> And here, "to signal that KVM should synthesize a triple fault for the guest"?
> 
>> +
>>   ARM/ARM64:
>>   ^^^^^^^^^^
>>   
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index bf6e96011dfe..d8ef0d993e86 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -325,6 +325,7 @@ struct kvm_reinject_control {
>>   #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
>>   #define KVM_VCPUEVENT_VALID_SMM		0x00000008
>>   #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
>> +#define KVM_VCPUEVENT_TRIPLE_FAULT	0x00000020
>>   
>>   /* Interrupt shadow states */
>>   #define KVM_X86_SHADOW_INT_MOV_SS	0x01
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4fa4d8269e5b..fee402a700df 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4891,6 +4891,9 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>>   	if (vcpu->kvm->arch.exception_payload_enabled)
>>   		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
>>   
>> +	if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))
>> +		events->flags |= KVM_VCPUEVENT_TRIPLE_FAULT;
>> +
>>   	memset(&events->reserved, 0, sizeof(events->reserved));
>>   }
>>   
>> @@ -4903,7 +4906,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>   			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
>>   			      | KVM_VCPUEVENT_VALID_SHADOW
>>   			      | KVM_VCPUEVENT_VALID_SMM
>> -			      | KVM_VCPUEVENT_VALID_PAYLOAD))
>> +			      | KVM_VCPUEVENT_VALID_PAYLOAD
>> +			      | KVM_VCPUEVENT_TRIPLE_FAULT))
>>   		return -EINVAL;
>>   
>>   	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
>> @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>   		}
>>   	}
>>   
>> +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
>> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>> +
>>   	kvm_make_request(KVM_REQ_EVENT, vcpu);
> 
> Looks correct, but this really needs a selftest, at least for the SET path since
> the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
> e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
> exit.
> 
> Aha!  And for the GET path, abuse KVM_X86_SET_MCE with CR4.MCE=0 to coerce KVM into
> making a KVM_REQ_TRIPLE_FAULT, that way there's no need to try and hit a timing
> window to intercept the request.

OK, will cook a selftest to verify it.

