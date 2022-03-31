Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F243C4EE482
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiCaXME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 19:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiCaXMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 19:12:03 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A3DEA76C;
        Thu, 31 Mar 2022 16:10:13 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1na3vO-000676-Nb; Fri, 01 Apr 2022 01:09:54 +0200
Message-ID: <f4cdaf45-c869-f3bb-2ba2-3c0a4da12a6d@maciej.szmigiero.name>
Date:   Fri, 1 Apr 2022 01:09:48 +0200
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
 <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
 <YkTSul0CbYi/ae0t@google.com>
 <8f9ae64a-dc64-6f46-8cd4-ffd2648a9372@maciej.szmigiero.name>
 <YkTlxCV9wmA3fTlN@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
In-Reply-To: <YkTlxCV9wmA3fTlN@google.com>
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

On 31.03.2022 01:20, Sean Christopherson wrote:
> On Thu, Mar 31, 2022, Maciej S. Szmigiero wrote:
>> On 30.03.2022 23:59, Sean Christopherson wrote:
>>> On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
>>>> @@ -3627,6 +3632,14 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>>>>    	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
>>>>    		return;
>>>> +	/* L1 -> L2 event re-injection needs a different handling */
>>>> +	if (is_guest_mode(vcpu) &&
>>>> +	    exit_during_event_injection(svm, svm->nested.ctl.event_inj,
>>>> +					svm->nested.ctl.event_inj_err)) {
>>>> +		nested_svm_maybe_reinject(vcpu);
>>>
>>> Why is this manually re-injecting?  More specifically, why does the below (out of
>>> sight in the diff) code that re-queues the exception/interrupt not work?  The
>>> re-queued event should be picked up by nested_save_pending_event_to_vmcb12() and
>>> propagatred to vmcb12.
>>
>> A L1 -> L2 injected event should either be re-injected until successfully
>> injected into L2 or propagated to VMCB12 if there is a nested VMEXIT
>> during its delivery.
>>
>> svm_complete_interrupts() does not do such re-injection in some cases
>> (soft interrupts, soft exceptions, #VC) - it is trying to resort to
>> emulation instead, which is incorrect in this case.
>>
>> I think it's better to split out this L1 -> L2 nested case to a
>> separate function in nested.c rather than to fill
>> svm_complete_interrupts() in already very large svm.c with "if" blocks
>> here and there.
> 
> Ah, I see it now.  WTF.
> 
> Ugh, commit 66fd3f7f901f ("KVM: Do not re-execute INTn instruction.") fixed VMX,
> but left SVM broken.
> 
> Re-executing the INTn is wrong, the instruction has already completed decode and
> execution.  E.g. if there's there's a code breakpoint on the INTn, rewinding will
> cause a spurious #DB.
> 
> KVM's INT3 shenanigans are bonkers, but I guess there's no better option given
> that the APM says "Software interrupts cannot be properly injected if the processor
> does not support the NextRIP field.".  What a mess.

Note that KVM currently always tries to re-execute the current instruction
when asked to re-inject a #BP or a #OF, even when nrips are enabled.

Also, #BP (and #OF, too) is returned as type SVM_EXITINTINFO_TYPE_EXEPT,
not as SVM_EXITINTINFO_TYPE_SOFT (soft interrupt), so it should be
re-injected accordingly.

> Anyways, for the common nrips=true case, I strongly prefer that we properly fix
> the non-nested case and re-inject software interrupts, which should in turn
> naturally fix this nested case.  

This would also need making the #BP or #OF current instruction
re-execution conditional on (at least) nrips support.

I am not sure, however, whether this won't introduce any regressions.
That's why this patch set changed the behavior here only for the
L1 -> L2 case.

Another issue is whether a L1 hypervisor can legally inject a #VC
into its L2 (since these are never re-injected).

We still need L1 -> L2 event injection detection to restore the NextRIP
field when re-injecting an event that uses it.

> And for nrips=false, my vote is to either punt
> and document it as a "KVM erratum", or straight up make nested require nrips.

A quick Internet search shows that the first CPUs with NextRIP were the
second-generation Family 10h CPUs (Phenom II, Athlon II, etc.).
They started being released in early 2009, so we probably don't need to
worry about the non-nrips case too much.

For the nested case, orthodox reading of the aforementioned APM sentence
would mean that a L1 hypervisor is not allowed either to make use of such
event injection in the non-nrips case.

> Note, that also requires updating svm_queue_exception(), which assumes it will
> only be handed hardware exceptions, i.e. hardcodes type EXEPT.  That's blatantly
> wrong, e.g. if userspace injects a software exception via KVM_SET_VCPU_EVENTS.

svm_queue_exception() uses SVM_EVTINJ_TYPE_EXEPT, which is correct even
for software exceptions (#BP or #OF).
It does work indeed, as the self test included in this patch set
demonstrates.

Thanks,
Maciej
