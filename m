Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63ED77D152
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbjHORtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbjHORtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:49:17 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E71C10F4
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 10:49:15 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVyAJ-00HZD6-CU; Tue, 15 Aug 2023 19:49:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=R5WuOzGDFN+1rOMIT8hZsySyfINuutPq1ORkeWdblzs=; b=GUG7XeFuOCV9agJVSg0OQE6udn
        OyAEqYoVbUN4eoIQnng3S06yhJ+9oBurfjA3rtOU8WqLcF9s8bYq45D83t7IiOvXv7wdWfVlj0zUG
        MvDLCXwOYH1qY2Q1OXUpjdLV1iA0BRVQ9u769eJxqRoQSPeEs3qKE1KzAHuRiBcthoyJZvUQSZr5D
        glouVhJi26rpd1hiNcOTY0CL5GtBgObzJWozQ0ypiNZOJrlW/KfN0l0p4l/mGRddRAgzNL+k5m2ke
        qte3wp3S12esKx+gyRzWnqRhhbbBuVSXF1omrdfO9kK+if2S0/MtJCKxC7r0J+qcBTN3AfqVDciWa
        j0/BdpWw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVyAI-0002kW-SD; Tue, 15 Aug 2023 19:49:11 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVyAG-0004D1-Ey; Tue, 15 Aug 2023 19:49:08 +0200
Message-ID: <428bed16-f407-4e90-9bbe-e3eaa8b5fdec@rbox.co>
Date:   Tue, 15 Aug 2023 19:49:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] sync_regs() TOCTOU issues
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <169100872740.1737125.14417847751002571677.b4-ty@google.com>
 <ZNrLYOiQuImD1g8A@google.com> <2c823911-4712-4d06-bfb5-e6ee3f7023a7@rbox.co>
 <ZNucb6NQ6ozi1vqz@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZNucb6NQ6ozi1vqz@google.com>
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

On 8/15/23 17:40, Sean Christopherson wrote:
> On Tue, Aug 15, 2023, Michal Luczaj wrote:
>>> @@ -115,6 +116,7 @@ static void *race_events_exc(void *arg)
>>>  	for (;;) {
>>>  		WRITE_ONCE(run->kvm_dirty_regs, KVM_SYNC_X86_EVENTS);
>>>  		WRITE_ONCE(events->flags, 0);
>>> +		WRITE_ONCE(events->exception.nr, GP_VECTOR);
>>>  		WRITE_ONCE(events->exception.pending, 1);
>>>  		WRITE_ONCE(events->exception.nr, 255);
>>
>> Here you're setting events->exception.nr twice. Is it deliberate?
> 
> Heh, yes and no.  It's partly leftover from a brief attempt to gracefully eat the
> fault in the guest.
> 
> However, unless there's magic I'm missing, race_events_exc() needs to set a "good"
> vector in every iteration, otherwise only the first iteration will be able to hit
> the "check good, consume bad" scenario.

I think I understand what you mean. I see things slightly different: because

	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
		...
	} else {
		events->exception.pending = 0;
		events->exception_has_payload = 0;
	}

zeroes exception.pending on every iteration, even though exception.nr may
already be > 31, KVM does not necessary return -EINVAL at

	if ((events->exception.injected || events->exception.pending) &&
	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
		return -EINVAL;

It would if the racer set exception.pending before this check, but if it does it
after the check, then KVM goes

	vcpu->arch.exception.pending = events->exception.pending;
	vcpu->arch.exception.vector = events->exception.nr;

which later triggers the WARN. That said, if I you think setting and re-setting
exception.nr is more efficient (as in: racy), I'm all for it.

> For race_events_inj_pen(), it should be sufficient to set the vector just once,
> outside of the loop.  I do think it should be explicitly set, as subtly relying
> on '0' being a valid exception is a bit mean (though it does work).

Sure, I get it.
