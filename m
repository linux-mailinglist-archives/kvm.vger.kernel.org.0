Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD01530A90
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 10:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiEWH1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 03:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiEWH0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 03:26:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9AB49A;
        Mon, 23 May 2022 00:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653290567; x=1684826567;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KWflf9hZ4EEzO/3N36rfafAnRxhbr/9bpirmiokHGHo=;
  b=hxQ++Y1zPePcU7OZpmvThaDATJ7bGaHDa3eHdYyasSI5Ewdt5MWchVlI
   aS/ZfgeVwJYt0K7E2mkOuZ3RlF7y4QsrhHU5dVb7Ome31IHXaHeE2Wind
   ANqc7pVAtb255NKu4L1phZnVYG5w5F7LJS+tsFQ3n08EeNLHQ3EVSdKxE
   FNkOWdJFJGbL8+XPent1GT1opVEVING6avsiA7XU76UKDW4/2hOav/KHu
   zwViYKKxKXvziqIXN3Mk4Q34jaPk3Hwpoxnp0DVySaIjpI9lYZ0FtGVhv
   3/gNMsu1IkYbYncocvPmcIVB02mCIYzZcrJDNw02Qfa2HiCG+tGwmAECZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="260727359"
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="260727359"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 23:46:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="600476753"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.175.93]) ([10.249.175.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 23:46:13 -0700
Message-ID: <5c5a7597-d6e3-7a05-ead8-659c45aea222@intel.com>
Date:   Mon, 23 May 2022 14:46:11 +0800
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
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YoVHAIGcFgJit1qp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/19/2022 3:20 AM, Sean Christopherson wrote:
> On Thu, Apr 21, 2022, Chenyi Qiang wrote:
>> +#ifndef __x86_64__
>> +# error This test is 64-bit only
> 
> No need, all of KVM selftests are 64-bit only.
> 
>> +#endif
>> +
>> +#define VCPU_ID			0
>> +#define ARBITRARY_IO_PORT	0x2000
>> +
>> +/* The virtual machine object. */
>> +static struct kvm_vm *vm;
>> +
>> +static void l2_guest_code(void)
>> +{
>> +	/*
>> +	 * Generate an exit to L0 userspace, i.e. main(), via I/O to an
>> +	 * arbitrary port.
>> +	 */
> 
> I think we can test a "real" triple fault without too much effort by abusing
> vcpu->run->request_interrupt_window.  E.g. map the run struct into L2, clear
> PIN_BASED_EXT_INTR_MASK in vmcs12, and then in l2_guest_code() do:
> 
> 	asm volatile("cli");
> 
> 	run->request_interrupt_window = true;
> 

Maybe, A GUEST_SYNC to main() to change the request_interrupt_window 
also works.

> 	asm volatile("sti; ud2");
> 

How does the "real" triple fault occur here? Through UD2?

> 	asm volatile("inb %%dx, %%al"
> 		     : : [port] "d" (ARBITRARY_IO_PORT) : "rax"); 	
> 
> The STI shadow will block the IRQ-window VM-Exit until after the ud2, i.e. until
> after the triple fault is pending.
> 
> And then main() can
> 
>    1. verify it got KVM_EXIT_IRQ_WINDOW_OPEN with a pending triple fault
>    2. clear the triple fault and re-enter L1+l2
>    3. continue with the existing code, e.g. verify it got KVM_EXIT_IO, stuff a
>       pending triple fault, etc...
> 
> That said, typing that out makes me think we should technically handle/prevent this
> in KVM since triple fault / shutdown is kinda sorta just a special exception.
> 
> Heh, and a potentially bad/crazy idea would be to use a reserved/magic vector in
> kvm_vcpu_events.exception to save/restore triple fault, e.g. we could steal
> NMI_VECTOR.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f2d0ee9296b9..d58c0cfd3cd3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4743,7 +4743,8 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>          return (kvm_arch_interrupt_allowed(vcpu) &&
>                  kvm_cpu_accept_dm_intr(vcpu) &&
>                  !kvm_event_needs_reinjection(vcpu) &&
> -               !vcpu->arch.exception.pending);
> +               !vcpu->arch.exception.pending &&
> +               !kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu));
>   }
> 
>   static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> 
> 
> 
