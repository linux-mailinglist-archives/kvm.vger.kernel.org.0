Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA70B77D203
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbjHOSjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbjHOSjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:39:09 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1D910F4
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:39:07 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVywb-0003qC-5m; Tue, 15 Aug 2023 20:39:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=V7LyDajPd2j7OjnaJ3Wg6n9H9j6BjVZz5x4UENeBh10=; b=ketDkaQScTSmOun9/lfkJF6Utx
        jTdRdQmUE8u96nBxulFWxCc+Eh/hUeWBargEQCMOauUcVjmFj5OrfeDsmnbe1pw6af8op/G4nXLjp
        PnQkZofy0BdzPtr0hHwMGNPO3Czn/NpHAPdUE4BBWrLlOVhEyvTorRuBej/z3UpgMzqVt5bZEhoOF
        pEQeuRV2XIjfQrtVlMhAkN9iWDrnIMAbVypsm0SaTU+YxREEu8+4aqJY/yWvXkPQJc/nmyXYEPnUW
        88J0hDf2VYRMm5SCrltSZnw0jxoedvu/U9c6pZEA0Abu35uP/pwswnFfRj4kWoB6eRkhKIyumRsLX
        N+LKJmyw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVywa-0002Px-8O; Tue, 15 Aug 2023 20:39:04 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVywK-0007qK-6e; Tue, 15 Aug 2023 20:38:48 +0200
Message-ID: <7f24846a-d97d-4eea-bc2a-66cbcca71d53@rbox.co>
Date:   Tue, 15 Aug 2023 20:38:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] sync_regs() TOCTOU issues
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <169100872740.1737125.14417847751002571677.b4-ty@google.com>
 <ZNrLYOiQuImD1g8A@google.com> <2c823911-4712-4d06-bfb5-e6ee3f7023a7@rbox.co>
 <ZNucb6NQ6ozi1vqz@google.com> <428bed16-f407-4e90-9bbe-e3eaa8b5fdec@rbox.co>
 <ZNvAy4lsMsSeuvgq@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZNvAy4lsMsSeuvgq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/15/23 20:15, Sean Christopherson wrote:
> On Tue, Aug 15, 2023, Michal Luczaj wrote:
>> On 8/15/23 17:40, Sean Christopherson wrote:
>>> On Tue, Aug 15, 2023, Michal Luczaj wrote:
>>>>> @@ -115,6 +116,7 @@ static void *race_events_exc(void *arg)
>>>>>  	for (;;) {
>>>>>  		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
>>>>>  		WRITE_ONCE(events->flags, 0);
>>>>> +		WRITE_ONCE(events->exception.nr, GP_VECTOR);
>>>>>  		WRITE_ONCE(events->exception.pending, 1);
>>>>>  		WRITE_ONCE(events->exception.nr, 255);
>>>>
>>>> Here you're setting events->exception.nr twice. Is it deliberate?
>>>
>>> Heh, yes and no.  It's partly leftover from a brief attempt to gracefully eat the
>>> fault in the guest.
>>>
>>> However, unless there's magic I'm missing, race_events_exc() needs to set a "good"
>>> vector in every iteration, otherwise only the first iteration will be able to hit
>>> the "check good, consume bad" scenario.
>>
>> I think I understand what you mean. I see things slightly different: because
>>
>> 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
>> 		...
>> 	} else {
>> 		events->exception.pending = 0;
>> 		events->exception_has_payload = 0;
>> 	}
>>
>> zeroes exception.pending on every iteration, even though exception.nr may
>> already be > 31, KVM does not necessary return -EINVAL at
>>
>> 	if ((events->exception.injected || events->exception.pending) &&
>> 	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
>> 		return -EINVAL;
>>
>> It would if the racer set exception.pending before this check, but if it does it
>> after the check, then KVM goes
>>
>> 	vcpu->arch.exception.pending = events->exception.pending;
>> 	vcpu->arch.exception.vector = events->exception.nr;
>>
>> which later triggers the WARN. That said, if I you think setting and re-setting
>> exception.nr is more efficient (as in: racy), I'm all for it.
> 
> My goal isn't to make it easier to hit the *known* TOCTOU, it's to make the test
> more valuable after that known bug has been fixed.

Aha! Yup, turns out I did not understand what you meant after all :) Sorry.

> I.e. I don't want to rely on
> KVM to update kvm_run (which was arguably a bug even if there weren't a TOCTOU
> issue).  It's kinda silly, because realistically this test is likely only ever
> going to find TOCTOU bugs, but so long as the test can consistently the known bug,
> my preference is to make it as "generic" as possible from a coverage perspective.

Sure, that makes sense.

