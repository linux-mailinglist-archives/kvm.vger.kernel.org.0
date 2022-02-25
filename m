Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B34C44D7
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240709AbiBYMqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240706AbiBYMql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:46:41 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98BD21CD21;
        Fri, 25 Feb 2022 04:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645793169; x=1677329169;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hxjx1k1dTQ1X3VcpcvhZpVGbKp3swFMdHJk9USMfQsI=;
  b=nmUrBzBnIkNutN0FXJ1lbgAXJxqlwEX+JPafMJ+JXCz2I27yXG1zmGaN
   dbxjxslpP2xvO+ZVtHC8sklDwJHi7mOaAu9ePKNYPDAlgT1NDXaMILNfa
   SMYgGEDk0IiYcqDOyPGjD7j91RiWQU/TFHGKzeusiY/uvfz3ZpTSS+ihW
   GPOjnzD9mt4WQRb375fZmi5sQDZRxvTiJppRLjv7y7aOcOo61WudDkeO3
   VMj9C3D8frtrz3R8Nr7BgBk4lCiHhHT5G+3HxoR5zjC6zI743YimbUdVZ
   Ko4EfoSdYZF4BNhxUxp6ycY2+YKbiVIuEYNtpaE5z4qjFhdhcGBE1X7Lv
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="277121994"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="277121994"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 04:46:09 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="628832414"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.203]) ([10.255.30.203])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 04:46:07 -0800
Message-ID: <2809f506-a3ed-d2ec-dbeb-d7f2b3edbd37@intel.com>
Date:   Fri, 25 Feb 2022 20:46:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tao Xu <tao3.xu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
 <c7681cf8-7b99-eb43-0195-d35adb011f21@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c7681cf8-7b99-eb43-0195-d35adb011f21@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/2022 7:54 PM, Paolo Bonzini wrote:
> On 2/23/22 07:24, Chenyi Qiang wrote:
>> Nested handling
>> - Nested notify VM exits are not supported yet. Keep the same notify
>>    window control in vmcs02 as vmcs01, so that L1 can't escape the
>>    restriction of notify VM exits through launching L2 VM.
>> - When L2 VM is context invalid, synthesize a nested
>>    EXIT_REASON_TRIPLE_FAULT to L1 so that L1 won't be killed due to L2's
>>    VM_CONTEXT_INVALID happens.
>>
>> Notify VM exit is defined in latest Intel Architecture Instruction Set
>> Extensions Programming Reference, chapter 9.2.
>>
>> TODO: Allow to change the window size (to enable the feature) at runtime,
>> which can make it more flexible to do management.
> 
> I only have a couple questions, any changes in response to the question
> I can do myself.
> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 1dfe23963a9e..f306b642c3e1 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2177,6 +2177,9 @@ static void prepare_vmcs02_constant_state(struct 
>> vcpu_vmx *vmx)
>>       if (cpu_has_vmx_encls_vmexit())
>>           vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
>> +    if (notify_window >= 0)
>> +        vmcs_write32(NOTIFY_WINDOW, notify_window);
> 
> Is a value of 0 valid?  

Yes, 0 is valid. That's why there is an internal value to ensure even 0 
won't cause false positive

> Should it be changed to the recommended value of
> 128000 in hardware_setup()?
> 
>> +    case EXIT_REASON_NOTIFY:
>> +        return nested_cpu_has2(vmcs12,
>> +            SECONDARY_EXEC_NOTIFY_VM_EXITING);
> 
> This should be "return false" since you don't expose the secondary
> control to L1 (meaning, it will never be set).

Fine with either.

>> +         * L0 will synthensize a nested TRIPLE_FAULT to kill L2 when
>> +         * notify VM exit occurred in L2 and 
>> NOTIFY_VM_CONTEXT_INVALID is
>> +         * set in exit qualification. In this case, if notify VM exit
>> +         * occurred incident to delivery of a vectored event, the IDT
>> +         * vectoring info are recorded in VMCS. Drop the pending event
>> +         * in vmcs12, otherwise L1 VMM will exit to userspace with
>> +         * internal error due to delivery event.
>>           */
>> -        vmcs12_save_pending_event(vcpu, vmcs12);
>> +        if (to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_NOTIFY)
>> +            vmcs12_save_pending_event(vcpu, vmcs12);
> 
> I would prefer to call out the triple fault here:
> 
>                  /*
>                   * Transfer the event that L0 or L1 may have wanted to 
> inject into
>                   * L2 to IDT_VECTORING_INFO_FIELD.
>                   *
>                   * Skip this if the exit is due to a 
> NOTIFY_VM_CONTEXT_INVALID
>                   * exit; in that case, L0 will synthesize a nested 
> TRIPLE_FAULT
>                   * vmexit to kill L2.  No IDT vectoring info is 
> recorded for
>                   * triple faults, and __vmx_handle_exit does not expect 
> it.
>                   */
>                  if (!(to_vmx(vcpu)->exit_reason.basic == 
> EXIT_REASON_NOTIFY)
>                        && kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
>                          vmcs12_save_pending_event(vcpu, vmcs12);

looks good to me.

> What do you think?
> 
> Paolo
> 

