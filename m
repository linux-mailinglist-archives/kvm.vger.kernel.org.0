Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4B16220FA
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiKIAwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiKIAwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:52:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB6830550
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667955104;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CA553UdMHM5fe7exANwpCbWYCtvriI9MY8mWlunIGdY=;
        b=Hh14qiyoPuaWFyx3HjeMjFo2j070SskFkNxqk/veYl3MM3bSY7KlJNaueVt0xkrvayvG6j
        Z65GHCUCM1GnFXh7KUDg7k+11pxhSMYgUH3iLzfbydTaQPDj8knXmqiQdF86Tv53ubz2N5
        ENae01BVMMoWTH8ANkbcyLzPabWyQN4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-lAi4c7PLNBi9hDTwzs2qeQ-1; Tue, 08 Nov 2022 19:51:40 -0500
X-MC-Unique: lAi4c7PLNBi9hDTwzs2qeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 648BA101A528;
        Wed,  9 Nov 2022 00:51:30 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C38D140EBF3;
        Wed,  9 Nov 2022 00:51:23 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        oliver.upton@linux.dev, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com> <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
 <Y2rurDmCrXZaxY8F@google.com>
 <49c18201-b73a-b654-7f8a-77befa80c61b@redhat.com>
 <Y2r1ErahBE3+Dsv8@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <672eb11b-19db-9a9f-1898-8d2af0d45724@redhat.com>
Date:   Wed, 9 Nov 2022 08:51:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2r1ErahBE3+Dsv8@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 11/9/22 8:32 AM, Sean Christopherson wrote:
> On Wed, Nov 09, 2022, Gavin Shan wrote:
>> On 11/9/22 8:05 AM, Sean Christopherson wrote:
>>> On Wed, Nov 09, 2022, Gavin Shan wrote:
>>>> On 11/9/22 12:25 AM, Sean Christopherson wrote:
>>>>> I have no objection to disallowing userspace from disabling the combo, but I
>>>>> think it's worth requiring cap->args[0] to be '0' just in case we change our minds
>>>>> in the future.
>>>>>
>>>>
>>>> I assume you're suggesting to have non-zero value in cap->args[0] to enable the
>>>> capability.
>>>>
>>>>       if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>>>>           !kvm->dirty_ring_size || !cap->args[0])
>>>>           return r;
>>>
>>> I was actually thinking of taking the lazy route and requiring userspace to zero
>>> the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
>>> forget that `cap->flags` exists.
>>>
>>> Just this?
>>>
>>> 	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>>> 	    !kvm->dirty_ring_size || cap->flags)
>>> 		return r;
>>>
>>> It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
>>> that's seems quite unlikely and not the end of the world if it does happen.  And
>>> on the other hand, requiring '0' is less weird and less annoying for userspace
>>> _now_.
>>>
>>
>> I don't quiet understand the term "lazy route".
> 
> "lazy" in that requiring a non-zero value would mean adding another #define,
> otherwise the extensibility is limited to two values.  Again, unlikely to matter,
> but it wouldn't make sense to go through the effort to provide some extensibility
> and then only allow for one possible extension.  If KVM is "lazy" and just requires
> flags to be '0', then there's no need for more #defines, and userspace doesn't
> have to pass more values in its enabling.
> 

Thanks for the explanation. I understand the term 'lazy route' now. Right,
cap->flags is good place to hold #defines in future. cap->args[0] doesn't
suite strictly here.

>> So you're still thinking of the possibility to allow disabling the capability
>> in future?
> 
> Yes, or more likely, tweaking the behavior of ring+bitmap.  As is, the behavior
> is purely a fallback for a single case where KVM can't push to the dirty ring due
> to not having a running vCPU.  It's possible someone might come up with a use case
> where they want KVM to do something different, e.g. fallback to the bitmap if the
> ring is full.
> 
> In other words, it's mostly to hedge against futures we haven't thought of.  Reserving
> cap->flags is cheap and easy for both KVM and userspace, so there's no real reason
> not to do so.
> 

Agreed that it's cheap to reserve cap->flags. I will change the code accordingly
in v10.

>> If so, cap->flags or cap->args[0] can be used. For now, we just
>> need a binding between cap->flags/args[0] with the operation of enabling the
>> capability. For example, "cap->flags == 0x0" means to enable the capability
>> for now, and "cap->flags != 0x0" to disable the capability in future.
>>
>> The suggested changes look good to me in either way. Sean, can I grab your
>> reviewed-by with your comments addressed?
> 
> I'll look at v10, I don't like providing reviews that are conditional on changes
> that are more than nits.
> 
> That said, there're no remaining issues that can't be sorted out on top, so don't
> hold up v10 if I don't look at it in a timely manner for whatever reason.  I agree
> with Marc that it'd be good to get this in -next sooner than later.
> 

Sure. I would give v9 a few days, prior to posting v10. I'm not sure if other people
still have concerns. If there are more comments, I want to address all of them
in v10 :)

Thanks,
Gavin


