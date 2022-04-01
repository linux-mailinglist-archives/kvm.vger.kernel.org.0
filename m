Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4054EF7FC
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 18:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344139AbiDAQeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350714AbiDAQdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 12:33:46 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E6A2E6A6E;
        Fri,  1 Apr 2022 09:06:48 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1naJma-0000Rv-AD; Fri, 01 Apr 2022 18:05:52 +0200
Message-ID: <8529068e-7d2b-dc54-e259-182ba733105f@maciej.szmigiero.name>
Date:   Fri, 1 Apr 2022 18:05:46 +0200
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
 <f4cdaf45-c869-f3bb-2ba2-3c0a4da12a6d@maciej.szmigiero.name>
 <YkZCeoDhMg1wOU1f@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
In-Reply-To: <YkZCeoDhMg1wOU1f@google.com>
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

On 1.04.2022 02:08, Sean Christopherson wrote:
> On Fri, Apr 01, 2022, Maciej S. Szmigiero wrote:
>> On 31.03.2022 01:20, Sean Christopherson wrote:
>>> Re-executing the INTn is wrong, the instruction has already completed decode and
>>> execution.  E.g. if there's there's a code breakpoint on the INTn, rewinding will
>>> cause a spurious #DB.
>>>
>>> KVM's INT3 shenanigans are bonkers, but I guess there's no better option given
>>> that the APM says "Software interrupts cannot be properly injected if the processor
>>> does not support the NextRIP field.".  What a mess.
>>
>> Note that KVM currently always tries to re-execute the current instruction
>> when asked to re-inject a #BP or a #OF, even when nrips are enabled.
> 
> Yep, and my vote is to fix that.

The only issue I have with making SVM re-inject a #BP or a #OF in the
nrips case is that this might introduce some regression with respect to
host-side guest debugging.

On the other hand, VMX does re-inject these unconditionally so it might
not be a problem after all.

>> Also, #BP (and #OF, too) is returned as type SVM_EXITINTINFO_TYPE_EXEPT,
>> not as SVM_EXITINTINFO_TYPE_SOFT (soft interrupt), so it should be
>> re-injected accordingly.
> 
> Ahhh, SVM doesn't differentiate between software exceptions and hardware exceptions.
> Finally found the relevant section in the APM:
> 
>    Despite the instruction name, the events raised by the INT1 (also known as ICEBP),
>    INT3 and INTO instructions (opcodes F1h, CCh and CEh) are considered exceptions for
>    the purposes of EXITINTINFO, not software interrupts. Only events raised by the INTn
>    instruction (opcode CDh) are considered software interrupts.
> 
> VMX has separate identifiers for software interrupts and for software exceptions,

I guess the sentence above was supposed to read "for *hardware exceptions*
and for software exceptions", just like in the previous paragraph about SVM.

> where as SVM unconditionally treats #BP and #OF as soft:
> 
>    Injecting an exception (TYPE = 3) with vectors 3 or 4 behaves like a trap raised by
>    INT3 and INTO instructions
> 
> Now I'm curious why Intel doesn't do the same...

Perhaps it's just a result of VMX and SVM being developed independently,
in parallel.

>>> Anyways, for the common nrips=true case, I strongly prefer that we properly fix
>>> the non-nested case and re-inject software interrupts, which should in turn
>>> naturally fix this nested case.
>>
>> This would also need making the #BP or #OF current instruction
>> re-execution conditional on (at least) nrips support.
>>
>> I am not sure, however, whether this won't introduce any regressions.
>> That's why this patch set changed the behavior here only for the
>> L1 -> L2 case.
>>
>> Another issue is whether a L1 hypervisor can legally inject a #VC
>> into its L2 (since these are never re-injected).
> 
> I would expect to work, and it's easy to find out.  I know VMX allows injecting
> non-existent exceptions, but the APM is vague as usual and says VMRUN will fail...

I've done a quick test right now and a VMRUN attempt with #VC event
injection does seem to fail.
So we don't need to worry about not re-injecting a #VC.

>    If the VMM attempts to inject an event that is impossible for the guest mode
> 
>> We still need L1 -> L2 event injection detection to restore the NextRIP
>> field when re-injecting an event that uses it.
> 
> You lost me on this one.  KVM L0 is only (and always!) responsible for saving the
> relevant info into vmcb12, why does it need to detect where the vectoring exception
> came from?

Look at the description of patch 4 of this patch set - after some
L2 VMEXITs handled by L0 (in other words, which do *not* result in
a nested VMEXIT to L1) the VMCB02 NextRIP field will be zero
(APM 15.7.1 "State Saved on Exit" describes when this happens).

If we attempt to re-inject some types of events with the NextRIP field
being zero the return address pushed on stack will also be zero, which
will obviously do bad things to the L2 when it returns from
an (exception|interrupt) handler.

>>> And for nrips=false, my vote is to either punt
>>> and document it as a "KVM erratum", or straight up make nested require nrips.
>>
>> A quick Internet search shows that the first CPUs with NextRIP were the
>> second-generation Family 10h CPUs (Phenom II, Athlon II, etc.).
>> They started being released in early 2009, so we probably don't need to
>> worry about the non-nrips case too much.
>>
>> For the nested case, orthodox reading of the aforementioned APM sentence
>> would mean that a L1 hypervisor is not allowed either to make use of such
>> event injection in the non-nrips case.
> 
> Heh, my reading of it is that it's not disallowed, it just won't work correctly,
> i.e. the INTn won't be skipped.

Either way, we probably don't need to worry that this case don't get handled
100% right.

Thanks,
Maciej
