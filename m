Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF5C4F1BAD
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380869AbiDDVWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379672AbiDDRsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:48:05 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087F92E9CD;
        Mon,  4 Apr 2022 10:46:07 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbQm6-000327-H6; Mon, 04 Apr 2022 19:45:58 +0200
Message-ID: <20d050db-78f2-2a78-b319-a84f726a0bf9@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 19:45:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-2-seanjc@google.com>
 <112c2108-7548-f5bd-493d-19b944701f1b@maciej.szmigiero.name>
 <YkspIjFMwpMYWV05@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
In-Reply-To: <YkspIjFMwpMYWV05@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4.04.2022 19:21, Sean Christopherson wrote:
> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
>>> @@ -1606,7 +1622,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>>>    	nested_copy_vmcb_control_to_cache(svm, ctl);
>>>    	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>>> -	nested_vmcb02_prepare_control(svm);
>>> +	nested_vmcb02_prepare_control(svm, save->rip);
>>
>> 					   ^
>> I guess this should be "svm->vmcb->save.rip", since
>> KVM_{GET,SET}_NESTED_STATE "save" field contains vmcb01 data,
>> not vmcb{0,1}2 (in contrast to the "control" field).
> 
> Argh, yes.  Is userspace required to set L2 guest state prior to KVM_SET_NESTED_STATE?
> If not, this will result in garbage being loaded into vmcb02.

I'm not sure about particular KVM API guarantees,
but looking at the code I guess it is supposed to handle both cases:
1) VMM loads the usual basic KVM state via KVM_SET_{S,}REGS then immediately
issues KVM_SET_NESTED_STATE to load the remaining nested data.

Assuming that it was the L2 that was running at the save time,
at first the basic L2 state will be loaded into vmcb01,
then at KVM_SET_NESTED_STATE time:
> if (is_guest_mode(vcpu))
>     svm_leave_nested(vcpu);
> else
>     svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;

The !is_guest_mode(vcpu) branch will be taken (since the new VM haven't entered
the guest mode yet), which will copy the basic L2 state from vmcb01 to vmcb02 and
then the remaining code will restore vmcb01 save and vmcb{0,1}2 control normally and
then enter the guest mode.

2) VMM first issues KVM_SET_NESTED_STATE then immediately loads the basic state.

Sane as the above, only some initial VM state will be copied into vmcb02 from vmcb01
by the code mentioned above, then vmcb01 save and vmcb{0,1}2 control will be restored
and guest mode will be entered.
If the VMM then immediately issues KVM_SET_{S,}REGS then it will restore L2 basic state
straight into vmcb02.

However, this all is my guess work from just looking at the relevant code,
I haven't run any tests to make sure that I haven't missed something.

Thanks,
Maciej
