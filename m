Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344B271F15D
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjFASFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjFASFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:05:46 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33CD1B5;
        Thu,  1 Jun 2023 11:05:37 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1q4mfy-0000do-Ji; Thu, 01 Jun 2023 20:05:30 +0200
Message-ID: <0c897867-42cb-60b0-aca7-7c8136411e1a@maciej.szmigiero.name>
Date:   Thu, 1 Jun 2023 20:05:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] KVM: SVM: vNMI pending bit is V_NMI_PENDING_MASK not
 V_NMI_BLOCKING_MASK
Content-Language: en-US, pl-PL
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>, vkuznets@redhat.com,
        jmattson@google.com, thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <be4ca192eb0c1e69a210db3009ca984e6a54ae69.1684495380.git.maciej.szmigiero@oracle.com>
 <ZGebCSwAA4W10atN@google.com>
 <af74ae7c-ae81-38ed-97bb-75e39088d4ef@maciej.szmigiero.name>
 <ZHjdu2CQU8RytUr7@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <ZHjdu2CQU8RytUr7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1.06.2023 20:04, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Maciej S. Szmigiero wrote:
>> On 19.05.2023 17:51, Sean Christopherson wrote:
>>> On Fri, May 19, 2023, Maciej S. Szmigiero wrote:
>>>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>>>
>>>> While testing Hyper-V enabled Windows Server 2019 guests on Zen4 hardware
>>>> I noticed that with vCPU count large enough (> 16) they sometimes froze at
>>>> boot.
>>>> With vCPU count of 64 they never booted successfully - suggesting some kind
>>>> of a race condition.
>>>>
>>>> Since adding "vnmi=0" module parameter made these guests boot successfully
>>>> it was clear that the problem is most likely (v)NMI-related.
>>>>
>>>> Running kvm-unit-tests quickly showed failing NMI-related tests cases, like
>>>> "multiple nmi" and "pending nmi" from apic-split, x2apic and xapic tests
>>>> and the NMI parts of eventinj test.
>>>>
>>>> The issue was that once one NMI was being serviced no other NMI was allowed
>>>> to be set pending (NMI limit = 0), which was traced to
>>>> svm_is_vnmi_pending() wrongly testing for the "NMI blocked" flag rather
>>>> than for the "NMI pending" flag.
>>>>
>>>> Fix this by testing for the right flag in svm_is_vnmi_pending().
>>>> Once this is done, the NMI-related kvm-unit-tests pass successfully and
>>>> the Windows guest no longer freezes at boot.
>>>>
>>>> Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
>>>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>>
>>> Reviewed-by: Sean Christopherson <seanjc@google.com>
>>>
>>
>> I can't see this in kvm/kvm.git trees or the kvm-x86 ones on GitHub -
>> is this patch planned to be picked up for -rc5 soon?
>>
>> Technically, just knowing the final commit id would be sufficit for my
>> purposes.
> 
> If Paolo doesn't pick it up by tomorrow, I'll apply it and send a fixes pull
> request for -rc5.

Thanks Sean.

