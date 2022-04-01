Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC424EFA4A
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 21:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351503AbiDATLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 15:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241780AbiDATLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 15:11:09 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD92617D;
        Fri,  1 Apr 2022 12:09:17 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1naMdl-00012l-6n; Fri, 01 Apr 2022 21:08:57 +0200
Message-ID: <ff29e77c-f16d-d9ef-9089-0a929d3c2fbf@maciej.szmigiero.name>
Date:   Fri, 1 Apr 2022 21:08:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <19c757487eeeff5344ff3684fe9c090235b07d05.1646944472.git.maciej.szmigiero@oracle.com>
 <YkdFSuezZ1XNTTfx@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/5] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
In-Reply-To: <YkdFSuezZ1XNTTfx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1.04.2022 20:32, Sean Christopherson wrote:
> On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> The next_rip field of a VMCB is *not* an output-only field for a VMRUN.
>> This field value (instead of the saved guest RIP) in used by the CPU for
>> the return address pushed on stack when injecting a software interrupt or
>> INT3 or INTO exception.
>>
>> Make sure this field gets synced from vmcb12 to vmcb02 when entering L2 or
>> loading a nested state.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 4 ++++
>>   arch/x86/kvm/svm/svm.h    | 1 +
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index d736ec6514ca..9656f0d6815c 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -366,6 +366,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>>   	to->nested_ctl          = from->nested_ctl;
>>   	to->event_inj           = from->event_inj;
>>   	to->event_inj_err       = from->event_inj_err;
>> +	to->next_rip            = from->next_rip;
>>   	to->nested_cr3          = from->nested_cr3;
>>   	to->virt_ext            = from->virt_ext;
>>   	to->pause_filter_count  = from->pause_filter_count;
>> @@ -638,6 +639,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>>   	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
>>   	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
>>   	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
>> +	/* The return address pushed on stack by the CPU for some injected events */
>> +	svm->vmcb->control.next_rip            = svm->nested.ctl.next_rip;
> 
> This needs to be gated by nrips being enabled _and_ exposed to L1, i.e.
> 
> 	if (svm->nrips_enabled)
> 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;

It can be done, however what if we run on a nrips-capable CPU,
but don't expose this capability to the L1?

The CPU will then push whatever value was left in this field as
the return address for some L1 injected events.

Although without nrips feature the L1 shouldn't even attempt event
injection, copying this field anyway will make it work if L1 just
expects this capability based on the current CPU model rather than
by checking specific CPUID feature bits.

> though I don't see any reason to add the condition to the copy to/from cache flows.
>
>>   	if (!nested_vmcb_needs_vls_intercept(svm))
>>   		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>> @@ -1348,6 +1351,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
>>   	dst->nested_ctl           = from->nested_ctl;
>>   	dst->event_inj            = from->event_inj;
>>   	dst->event_inj_err        = from->event_inj_err;
>> +	dst->next_rip             = from->next_rip;
>>   	dst->nested_cr3           = from->nested_cr3;
>>   	dst->virt_ext              = from->virt_ext;
>>   	dst->pause_filter_count   = from->pause_filter_count;
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 93502d2a52ce..f757400fc933 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -138,6 +138,7 @@ struct vmcb_ctrl_area_cached {
>>   	u64 nested_ctl;
>>   	u32 event_inj;
>>   	u32 event_inj_err;
>> +	u64 next_rip;
>>   	u64 nested_cr3;
>>   	u64 virt_ext;
>>   	u32 clean;
> 
> I don't know why this struct has
> 
> 	u8 reserved_sw[32];
> 
> but presumably it's for padding, i.e. probably should be reduced to 24 bytes.

Apparently the "reserved_sw" field stores Hyper-V enlightenments state -
see commit 66c03a926f18 ("KVM: nSVM: Implement Enlightened MSR-Bitmap feature")
and nested_svm_vmrun_msrpm() in nested.c.

Thanks,
Maciej
