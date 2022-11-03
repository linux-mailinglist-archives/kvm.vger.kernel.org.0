Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151DD617377
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 01:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKCApk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 20:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiKCApj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 20:45:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5726E1260A
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 17:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667436284;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SSLSYckBlW+n3JxKkI9fBnOPYDTW+sybGJFFtiBCB1Y=;
        b=TW0puXgLDUC+G0qnJ7UymvlC3dU9lE82KaNMH+D3/cfYTUCi0k/y8DPJAfxo+iL8wiPc8f
        id0TZuay379rrOCJmgonvGwQFEhsaRxxFg9JBeen73xyJeu61HRIDo+Z45QrTeOeDdjfAO
        /m4mxd+bAQ0I9LfMUo/NyVTFiqtIIVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-7Sa5Kei4P9qdoyUA1xC4lA-1; Wed, 02 Nov 2022 20:44:43 -0400
X-MC-Unique: 7Sa5Kei4P9qdoyUA1xC4lA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2815D185A78F;
        Thu,  3 Nov 2022 00:44:42 +0000 (UTC)
Received: from [10.64.54.56] (vpn2-54-56.bne.redhat.com [10.64.54.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF32C40C6EE9;
        Thu,  3 Nov 2022 00:44:35 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, catalin.marinas@arm.com, dmatlack@google.com,
        will@kernel.org, pbonzini@redhat.com, oliver.upton@linux.dev,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com> <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n> <867d0de4b0.wl-maz@kernel.org>
 <Y2KWm8wiL3jBryMI@google.com> <871qqlgvba.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <c44d4e62-ffbb-bdba-f1a7-7fb6a0f44e75@redhat.com>
Date:   Thu, 3 Nov 2022 08:44:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <871qqlgvba.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 12:44 AM, Marc Zyngier wrote:
> On Wed, 02 Nov 2022 16:11:07 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, Nov 02, 2022, Marc Zyngier wrote:
>>> On Wed, 02 Nov 2022 14:29:26 +0000, Peter Xu <peterx@redhat.com> wrote:
>>>> However I don't see anything stops a simple "race" to trigger like below:
>>>>
>>>>            recycle thread                   vcpu thread
>>>>            --------------                   -----------
>>>>        if (!dirty_ring_soft_full)                                   <--- not full
>>>>                                          dirty_ring_push();
>>>>                                          if (dirty_ring_soft_full)  <--- full due to the push
>>>>                                              set_request(SOFT_FULL);
>>>>            clear_request(SOFT_FULL);                                <--- can wrongly clear the request?
>>>>
>>>
>>> Hmmm, well spotted. That's another ugly effect of the recycle thread
>>> playing with someone else's toys.
>>>
>>>> But I don't think that's a huge matter, as it'll just let the vcpu to have
>>>> one more chance to do another round of KVM_RUN.  Normally I think it means
>>>> there can be one more dirty GFN (perhaps there're cases that it can push >1
>>>> gfns for one KVM_RUN cycle?  I never figured out the details here, but
>>>> still..) pushed to the ring so closer to the hard limit, but we have had a
>>>> buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
>>>> that's still fine, but maybe worth a short comment here?
>>>>
>>>> I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
>>>> cycle.  It would be good if there's an answer to that from anyone.
>>>
>>> This is dangerous, and I'd rather not go there.
>>>
>>> It is starting to look like we need the recycle thread to get out of
>>> the way. And to be honest:
>>>
>>> +	if (!kvm_dirty_ring_soft_full(ring))
>>> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
>>>
>>> seems rather superfluous. Only clearing the flag in the vcpu entry
>>> path feels much saner, and I can't see anything that would break.
>>>
>>> Thoughts?
>>
>> I've no objections to dropping the clear on reset, I suggested it
>> primarily so that it would be easier to understand what action
>> causes the dirty ring to become not-full.  I agree that the explicit
>> clear is unnecessary from a functional perspective.
> 
> The core of the issue is that the whole request mechanism is a
> producer/consumer model, where consuming a request is a CLEAR
> action. The standard model is that the vcpu thread is the consumer,
> and that any thread (including the vcpu itself) can be a producer.
> 
> With this flag clearing being on a non-vcpu thread, you end-up with
> two consumers, and things can go subtly wrong.
> 
> I'd suggest replacing this hunk with a comment saying that the request
> will be cleared by the vcpu thread next time it enters the guest.
> 

Thanks, Marc. I will replace the hunk of code with the following
comments, as you suggested, in next respin.

     /*
      * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
      * by the VCPU thread next time when it enters the guest.
      */

I will post v8 after Peter/Sean/Oliver take a look on [PATCH v7 4/9].
I think we're settled on other patches.

Thanks,
Gavin

