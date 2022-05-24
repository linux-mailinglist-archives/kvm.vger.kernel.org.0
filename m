Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8800532B46
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbiEXN1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbiEXN1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:27:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E0499685;
        Tue, 24 May 2022 06:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653398855; x=1684934855;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LTX2UBWyZPxM/YfG41N0TTsGOt0UgmCLk93ZM314zHw=;
  b=Hhu772+eEp0IywcIrndF2P8mbJAcmk+ueg7blgeKtlDNUq5be/a2dK9v
   lRBNlA1FnpYPPpCOtjtGguE6XrFWWdwqV5L8BtRS2I9wrzH1rIkJYTAwT
   ZFUb92ty+24akNE9pxXBS7QhgZSWdTThDgrRZSE3s3Xx+92JjWkrxvECZ
   m/03Kth70khVAxwL9iAgZLFKqZc2sux2fDNmkJTrvkMroRqc4nvkQL0z3
   akFDlHHTFm2DbCYe7yCiY3Az+z++zhkTYZiM6tvI48RA4Gq1+YJoaMFvA
   Trp0R91Lx3xZV7z/ToqStmEWUmnfs+Df6HYvACl3aWv7O0pK4olwLYe2b
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273642329"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="273642329"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:27:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="572658162"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.171.56]) ([10.249.171.56])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:27:32 -0700
Message-ID: <26464954-f9d5-31e6-ba34-7b1f606328cc@intel.com>
Date:   Tue, 24 May 2022 21:27:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH v6 2/3] KVM: selftests: Add a test to get/set triple fault
 event
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
 <20220421072958.16375-3-chenyi.qiang@intel.com> <YoVHAIGcFgJit1qp@google.com>
 <5c5a7597-d6e3-7a05-ead8-659c45aea222@intel.com>
 <You1Eq6fp8F3YF5Z@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <You1Eq6fp8F3YF5Z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/2022 12:23 AM, Sean Christopherson wrote:
> On Mon, May 23, 2022, Chenyi Qiang wrote:
>>
>>
>> On 5/19/2022 3:20 AM, Sean Christopherson wrote:
>>> On Thu, Apr 21, 2022, Chenyi Qiang wrote:
>>>> +#ifndef __x86_64__
>>>> +# error This test is 64-bit only
>>>
>>> No need, all of KVM selftests are 64-bit only.
>>>
>>>> +#endif
>>>> +
>>>> +#define VCPU_ID			0
>>>> +#define ARBITRARY_IO_PORT	0x2000
>>>> +
>>>> +/* The virtual machine object. */
>>>> +static struct kvm_vm *vm;
>>>> +
>>>> +static void l2_guest_code(void)
>>>> +{
>>>> +	/*
>>>> +	 * Generate an exit to L0 userspace, i.e. main(), via I/O to an
>>>> +	 * arbitrary port.
>>>> +	 */
>>>
>>> I think we can test a "real" triple fault without too much effort by abusing
>>> vcpu->run->request_interrupt_window.  E.g. map the run struct into L2, clear
>>> PIN_BASED_EXT_INTR_MASK in vmcs12, and then in l2_guest_code() do:
>>>
>>> 	asm volatile("cli");
>>>
>>> 	run->request_interrupt_window = true;
>>>
>>
>> Maybe, A GUEST_SYNC to main() to change the request_interrupt_window also
>> works.
> 
> Hmm, yes, that should work too.  Feel free to punt on writing this sub-test.  As
> mentioned below, KVM should treat a pending triple fault as a pending "exception",
> i.e. userspace shouldn't see KVM_EXIT_IRQ_WINDOW_OPEN with a pending triple fault,
> and so the test should actually assert that the triple fault occurs in L2.  But I
> can roll that test into the KVM fix if you'd like.

If the KVM_EXIT_IRQ_WINDOW_OPEN can't see the pending triple fault, only 
asserting the triple fault may not have meaning in this selftest. 
Anyway, feel free to add the pending triple fault test in your KVM fix 
patches.

> 
>>> 	asm volatile("sti; ud2");
>>>
>>
>> How does the "real" triple fault occur here? Through UD2?
> 
> Yeah.  IIRC, by default L2 doesn't have a valid IDT, so any fault will escalate to
> a triple fault.
> 
>>> 	asm volatile("inb %%dx, %%al"
>>> 		     : : [port] "d" (ARBITRARY_IO_PORT) : "rax"); 	
>>>
>>> The STI shadow will block the IRQ-window VM-Exit until after the ud2, i.e. until
>>> after the triple fault is pending.
>>>
>>> And then main() can
>>>
>>>     1. verify it got KVM_EXIT_IRQ_WINDOW_OPEN with a pending triple fault
>>>     2. clear the triple fault and re-enter L1+l2
>>>     3. continue with the existing code, e.g. verify it got KVM_EXIT_IO, stuff a
>>>        pending triple fault, etc...
>>>
>>> That said, typing that out makes me think we should technically handle/prevent this
>>> in KVM since triple fault / shutdown is kinda sorta just a special exception.
