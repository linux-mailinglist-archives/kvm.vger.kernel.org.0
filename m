Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58304ECF7A
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 00:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351504AbiC3WTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 18:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiC3WTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 18:19:17 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7DF443D7;
        Wed, 30 Mar 2022 15:17:29 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nZgcj-00022J-9D; Thu, 31 Mar 2022 00:17:05 +0200
Message-ID: <8f9ae64a-dc64-6f46-8cd4-ffd2648a9372@maciej.szmigiero.name>
Date:   Thu, 31 Mar 2022 00:16:59 +0200
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
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
In-Reply-To: <YkTSul0CbYi/ae0t@google.com>
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

On 30.03.2022 23:59, Sean Christopherson wrote:
> On Thu, Mar 10, 2022, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> In SVM synthetic software interrupts or INT3 or INTO exception that L1
>> wants to inject into its L2 guest are forgotten if there is an intervening
>> L0 VMEXIT during their delivery.
>>
>> They are re-injected correctly with VMX, however.
>>
>> This is because there is an assumption in SVM that such exceptions will be
>> re-delivered by simply re-executing the current instruction.
>> Which might not be true if this is a synthetic exception injected by L1,
>> since in this case the re-executed instruction will be one already in L2,
>> not the VMRUN instruction in L1 that attempted the injection.
>>
>> Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err} until
>> it is either re-injected successfully or returned to L1 upon a nested
>> VMEXIT.
>> Make sure to always re-queue such event if returned in EXITINTINFO.
>>
>> The handling of L0 -> {L1, L2} event re-injection is left as-is to avoid
>> unforeseen regressions.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
> 
> ...
> 
>> @@ -3627,6 +3632,14 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>>   	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
>>   		return;
>>   
>> +	/* L1 -> L2 event re-injection needs a different handling */
>> +	if (is_guest_mode(vcpu) &&
>> +	    exit_during_event_injection(svm, svm->nested.ctl.event_inj,
>> +					svm->nested.ctl.event_inj_err)) {
>> +		nested_svm_maybe_reinject(vcpu);
> 
> Why is this manually re-injecting?  More specifically, why does the below (out of
> sight in the diff) code that re-queues the exception/interrupt not work?  The
> re-queued event should be picked up by nested_save_pending_event_to_vmcb12() and
> propagatred to vmcb12.

A L1 -> L2 injected event should either be re-injected until successfully
injected into L2 or propagated to VMCB12 if there is a nested VMEXIT
during its delivery.

svm_complete_interrupts() does not do such re-injection in some cases
(soft interrupts, soft exceptions, #VC) - it is trying to resort to
emulation instead, which is incorrect in this case.

I think it's better to split out this L1 -> L2 nested case to a
separate function in nested.c rather than to fill
svm_complete_interrupts() in already very large svm.c with "if" blocks
here and there.

Thanks,
Maciej
