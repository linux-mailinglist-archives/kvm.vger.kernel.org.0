Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F295139E9
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350068AbiD1QhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 12:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345895AbiD1QhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 12:37:01 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FA5B18A6;
        Thu, 28 Apr 2022 09:33:45 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nk75B-0004vP-A0; Thu, 28 Apr 2022 18:33:33 +0200
Message-ID: <6a017aa4-aebe-1b46-ddca-376fecdfba9f@maciej.szmigiero.name>
Date:   Thu, 28 Apr 2022 18:33:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20220423021411.784383-1-seanjc@google.com>
 <20220423021411.784383-3-seanjc@google.com>
 <61ad22d6de1f6a51148d2538f992700cac5540d4.camel@redhat.com>
 <4baa5071-3fb6-64f3-bcd7-2ffc1181d811@maciej.szmigiero.name>
 <b8a02f2eab780262c172cd4bbffd801ca8a37e98.camel@redhat.com>
 <YmqtCNFxCSF2hENP@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2 02/11] KVM: SVM: Don't BUG if userspace injects a soft
 interrupt with GIF=0
In-Reply-To: <YmqtCNFxCSF2hENP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.04.2022 17:04, Sean Christopherson wrote:
> On Thu, Apr 28, 2022, Maxim Levitsky wrote:
>> On Thu, 2022-04-28 at 15:27 +0200, Maciej S. Szmigiero wrote:
>>> On 28.04.2022 09:35, Maxim Levitsky wrote:
>>>> On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
>>>>> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>>>>
>>>>> Don't BUG/WARN on interrupt injection due to GIF being cleared if the
>>>>> injected event is a soft interrupt, which are not actually IRQs and thus
>>>>
>>>> Are any injected events subject to GIF set? I think that EVENTINJ just injects
>>>> unconditionaly whatever hypervisor puts in it.
>>>
>>> That's right, EVENTINJ will pretty much always inject, even when the CPU
>>> is in a 'wrong' state (like for example, injecting a hardware interrupt
>>> or a NMI with GIF masked).
>>>
>>> But KVM as a L0 is not supposed to inject a hardware interrupt into guest
>>> with GIF unset since the guest is obviously not expecting it then.
>>> Hence this WARN_ON().
>>
>> If you mean L0->L1 injection, that sure, but if L1 injects interrupt to L2,
>> then it should always be allowed to do so.
> 
> Yes, L1 can inject whatever it wants, whenever it wants.
> 
> I kept the WARN_ON() under the assumption that KVM would refuse to inject IRQs
> stuffed by userspace if GIF is disabled, but looking at the code again, I have
> no idea why I thought that.  KVM_SET_VCPU_EVENTS blindly takes whatever userspace
> provides, I don't see anything that would prevent userspace from shoving in a
> hardware IRQ.

You both are right, while KVM itself would not inject IRQ with GIF masked and
a nested VMRUN would enable GIF unconditionally, userspace via KVM_SET_VCPU_EVENTS
does not have this restriction.

Will remove this WARN_ON() then.

Thanks,
Maciej
