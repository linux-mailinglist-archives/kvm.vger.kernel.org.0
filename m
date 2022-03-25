Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722F64E7CCF
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiCYV1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 17:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbiCYV1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 17:27:46 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB6AC12E8;
        Fri, 25 Mar 2022 14:26:09 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nXrRS-0001Yx-9B; Fri, 25 Mar 2022 22:25:54 +0100
Message-ID: <e64d9972-339c-c661-afbd-38f1f2ea476a@maciej.szmigiero.name>
Date:   Fri, 25 Mar 2022 22:25:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
 <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
 <YjzjIhyw6aqsSI7Q@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
In-Reply-To: <YjzjIhyw6aqsSI7Q@google.com>
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

On 24.03.2022 22:31, Sean Christopherson wrote:
> On Sun, Mar 13, 2022, Maxim Levitsky wrote:
>> On Fri, 2022-03-11 at 03:27 +0000, Sean Christopherson wrote:
>>> The main goal of this series is to fix KVM's longstanding bug of not
>>> honoring L1's exception intercepts wants when handling an exception that
>>> occurs during delivery of a different exception.  E.g. if L0 and L1 are
>>> using shadow paging, and L2 hits a #PF, and then hits another #PF while
>>> vectoring the first #PF due to _L1_ not having a shadow page for the IDT,
>>> KVM needs to check L1's intercepts before morphing the #PF => #PF => #DF
>>> so that the #PF is routed to L1, not injected into L2 as a #DF.
>>>
>>> nVMX has hacked around the bug for years by overriding the #PF injector
>>> for shadow paging to go straight to VM-Exit, and nSVM has started doing
>>> the same.  The hacks mostly work, but they're incomplete, confusing, and
>>> lead to other hacky code, e.g. bailing from the emulator because #PF
>>> injection forced a VM-Exit and suddenly KVM is back in L1.
>>>
>>> Everything leading up to that are related fixes and cleanups I encountered
>>> along the way; some through code inspection, some through tests (I truly
>>> thought this series was finished 10 commits and 3 days ago...).
>>>
>>> Nothing in here is all that urgent; all bugs tagged for stable have been
>>> around for multiple releases (years in most cases).
>>>
>> I am just curious. Are you aware that I worked on this few months ago?
> 
> Ah, so that's why I had a feeling of deja vu when factoring out kvm_queued_exception.
> I completely forgot about it :-/  In my defense, that was nearly a year ago[1][2], though
> I suppose one could argue 11 == "a few" :-)
> 
> [1] https://lore.kernel.org/all/20210225154135.405125-1-mlevitsk@redhat.com
> [2] https://lore.kernel.org/all/20210401143817.1030695-3-mlevitsk@redhat.com
> 
>> I am sure that you even reviewed some of my code back then.
> 
> Yep, now that I've found the threads I remember discussing the mechanics.
> 
>> If so, could you have had at least mentioned this and/or pinged me to continue
>> working on this instead of re-implementing it?
> 
> I'm invoking Hanlon's razor[*]; I certainly didn't intended to stomp over your
> work, I simply forgot.
> 
> As for the technical aspects, looking back at your series, I strongly considered
> taking the same approach of splitting pending vs. injected (again, without any
> recollection of your work).  I ultimately opted to go with the "immediated morph
> to pending VM-Exit" approach as it allows KVM to do the right thing in almost every
> case without requiring new ABI, and even if KVM screws up, e.g. queues multiple
> pending exceptions.  It also neatly handles one-off things like async #PF in L2.
> 
> However, I hadn't considered your approach, which addresses the ABI conundrum by
> processing pending=>injected immediately after handling the VM-Exit.  I can't think
> of any reason that wouldn't work, but I really don't like splitting the event
> priority logic, nor do I like having two event injection sites (getting rid of the
> extra calls to kvm_check_nested_events() is still on my wish list).  If we could go
> back in time, I would likely vote for properly tracking injected vs. pending, but
> since we're mostly stuck with KVM's ABI, I prefer the "immediately morph to pending
> VM-Exit" hack over the "immediately morph to 'injected' exception" hack.

So, what's the plan here: is your patch set Sean considered to supersede
Maxim's earlier proposed changes or will you post an updated patch set
incorporating at least some of them?

I am asking because I have a series that touches the same general area
of KVM [1] and would preferably have it based on the final form of the
event injection code to avoid unforeseen negative interactions between
these changes.

Thanks,
Maciej

[1]: https://lore.kernel.org/kvm/d04e096a-b12e-91e2-204e-b3643a62d705@maciej.szmigiero.name/
