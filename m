Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F054D582B
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 03:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345643AbiCKCfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 21:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240600AbiCKCfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 21:35:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E41F9A998;
        Thu, 10 Mar 2022 18:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646966041; x=1678502041;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6hjwpjIh14O0IwM84C9uAbgePGM7mJklebnz9kkGYuE=;
  b=Z7UStXwCqGh6aaeh13sU3XJNAuqvt2RtY3sOACcwOeTxrzT9MbbyJmfi
   YdybJvQLUCJCWJMDzJUWINHHi0dDi0aWigokMMsYrvG+0iJ+696Ifvozm
   P9ToeGgUBxWHvtkbLuYvZz7462QDQiGnZmd+Mb19JAzLFA053LGV7ql7b
   oSuoQeDdGsljoByIk4Q0g7PZVoxGSPQQmJoT0hEjkEqO+7uxoVx50RKnh
   9Tk7EL/2M9c76MxkKqr+gaaPUeGE30sgCyj5euXF8sZ3WBaD0uIoX4uiT
   RsLkQrP7zWvc2lztx3YPc3TMSafASWSp31yxHsM0YiA0JOyJajozsr0nd
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="237655344"
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="237655344"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 18:34:01 -0800
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="538818726"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.255.28.225]) ([10.255.28.225])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 18:33:56 -0800
Message-ID: <5f2012f7-80ba-c034-a098-cede4184a125@intel.com>
Date:   Fri, 11 Mar 2022 10:33:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v4 1/3] KVM: X86: Extend KVM_SET_VCPU_EVENTS to inject a
 SHUTDOWN event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220310084001.10235-1-chenyi.qiang@intel.com>
 <20220310084001.10235-2-chenyi.qiang@intel.com> <Yio4qknizH25MBkP@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <Yio4qknizH25MBkP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/11/2022 1:43 AM, Sean Christopherson wrote:
> On Thu, Mar 10, 2022, Chenyi Qiang wrote:
>> In some fatal case, the target vcpu would run into unexpected behavior
>> and should get shutdown (e.g. VM context is corrupted and not valid in
>> VMCS). User space would be informed in such case. To kill the target
>> vcpu, extend KVM_SET_VCPU_EVENTS ioctl to inject a synthesized SHUTDOWN
>> event with a new bit set in flags field. KVM would accordingly make
>> KVM_REQ_TRIPLE_FAULT request to trigger the real shutdown exit. Noting
>> that the KVM_REQ_TRIPLE_FAULT request also applies to the nested case,
>> so that only the target L2 vcpu would be killed.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   Documentation/virt/kvm/api.rst  | 3 +++
>>   arch/x86/include/uapi/asm/kvm.h | 1 +
>>   arch/x86/kvm/x86.c              | 6 +++++-
>>   3 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 691ff84444bd..d1971ef613e7 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -1241,6 +1241,9 @@ can be set in the flags field to signal that the
>>   exception_has_payload, exception_payload, and exception.pending fields
>>   contain a valid state and shall be written into the VCPU.
>>   
>> +KVM_VCPUEVENT_SHUTDOWN can be set in flags field to synthesize a SHUTDOWN
>> +event for a vcpu from user space.
>> +
>>   ARM/ARM64:
>>   ^^^^^^^^^^
>>   
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index bf6e96011dfe..44757bd6122d 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -325,6 +325,7 @@ struct kvm_reinject_control {
>>   #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
>>   #define KVM_VCPUEVENT_VALID_SMM		0x00000008
>>   #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
>> +#define KVM_VCPUEVENT_SHUTDOWN		0x00000020
>>   
>>   /* Interrupt shadow states */
>>   #define KVM_X86_SHADOW_INT_MOV_SS	0x01
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4fa4d8269e5b..53c8592066c8 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4903,7 +4903,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>   			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
>>   			      | KVM_VCPUEVENT_VALID_SHADOW
>>   			      | KVM_VCPUEVENT_VALID_SMM
>> -			      | KVM_VCPUEVENT_VALID_PAYLOAD))
>> +			      | KVM_VCPUEVENT_VALID_PAYLOAD
>> +			      | KVM_VCPUEVENT_SHUTDOWN))
>>   		return -EINVAL;
>>   
>>   	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
>> @@ -4976,6 +4977,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>   		}
>>   	}
>>   
>> +	if (events->flags & KVM_VCPUEVENT_SHUTDOWN)
>> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> 
> Huh.  I think we need to make this bidirection and add it to get_vcpu_events()
> as well, and treat it as a bug fix.  In direct triple fault cases, i.e. hardware
> detected and morphed to VM-Exit, KVM will never lose the triple fault.  But for
> triple faults sythesized by KVM, e.g. the RSM path or nested_vmx_abort(), if KVM
> exits to userspace before the request is serviced, userspace could migrate the
> VM and lose the triple fault.

Good catch. Then the name of this definition is not quit fit now. How 
about changing to KVM_VCPUEVENT_SYTHESIZED_TRIPLE_FAULT?


