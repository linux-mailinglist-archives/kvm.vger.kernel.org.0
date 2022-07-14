Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5252E5757C1
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 00:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240698AbiGNWlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 18:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGNWlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 18:41:46 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B3E71BE5;
        Thu, 14 Jul 2022 15:41:43 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oC7W3-0001Ki-Qf; Fri, 15 Jul 2022 00:41:03 +0200
Message-ID: <84646f56-dcb0-b0f8-f485-eb0d69a84c9c@maciej.szmigiero.name>
Date:   Fri, 15 Jul 2022 00:40:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        kvm@vger.kernel.org
References: <20220714124453.188655-1-mlevitsk@redhat.com>
 <52d44630-21ad-1291-4185-40d5728eaea6@maciej.szmigiero.name>
 <034401953bc935d997c143153938edb1034b52cd.camel@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] KVM: SVM: fix task switch emulation on INTn instruction.
In-Reply-To: <034401953bc935d997c143153938edb1034b52cd.camel@redhat.com>
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

On 14.07.2022 15:57, Maxim Levitsky wrote:
> On Thu, 2022-07-14 at 15:50 +0200, Maciej S. Szmigiero wrote:
>> On 14.07.2022 14:44, Maxim Levitsky wrote:
>>> Recently KVM's SVM code switched to re-injecting software interrupt events,
>>> if something prevented their delivery.
>>>
>>> Task switch due to task gate in the IDT, however is an exception
>>> to this rule, because in this case, INTn instruction causes
>>> a task switch intercept and its emulation completes the INTn
>>> emulation as well.
>>>
>>> Add a missing case to task_switch_interception for that.
>>>
>>> This fixes 32 bit kvm unit test taskswitch2.
>>>
>>> Fixes: 7e5b5ef8dca322 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")
>>>
>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>> ---
>>
>> That's a good catch, your patch looks totally sensible to me.
>> People running Win 3.x or OS/2 on top of KVM will surely be grateful for it :)
> 
> Yes and also people who run 32 bit kvm unit tests :)

It looks like more people need to do this regularly :)

> BTW, I do have a win98 VM which I run once in a while under KVM.
> On Intel it works very well, on AMD, only works without NPT and without MMU
> pre-fetching, due to fact that the OS doesn't correctly invalidate TLB entries.

Interesting, maybe it is related to some operation in 90s CPUs implicitly
invalidating (or just replacing) enough TLB entries to actually make it work
(usually) - just a guess.

> I do need to test KVM with OS/2 on one of the weekends.... ;-)
> 
> Thanks for the review,
> 	Best regards,
> 		Maxim Levitsky
> 

Thanks,
Maciej
