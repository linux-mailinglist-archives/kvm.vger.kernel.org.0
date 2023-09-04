Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4025791323
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbjIDISL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjIDISK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:18:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C18AFC
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 01:18:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F30B82185A;
        Mon,  4 Sep 2023 08:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693815486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3AS0IT6yUk9p3q1y8aqClBmPuqem0MEXVXeHPyOtLN0=;
        b=EsdMLVkQhMdJdW3ChKjTt7QZpyFqhgVOfXZEIyJevWjiwpNHKTqgEAr6tzp10EquHnJj/5
        WfXydtcQzaIuBQIyqa3hkTHhbPRXWZUMouUw7Syad5l3OlU5G8/br8hMtZ3epZFPrA9Kvb
        aIe8AetuvPaXGlJGA73o4h3o8oTVmYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693815486;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3AS0IT6yUk9p3q1y8aqClBmPuqem0MEXVXeHPyOtLN0=;
        b=i4grlFnZ0XX1OZGWGPcHPDTVT9RpPlba0+Rfms9z/Td95wrFWNVRg3oOPYA1+ktetfrt+K
        jjrx0GMTPHx0o7Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B7FA51358B;
        Mon,  4 Sep 2023 08:18:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0IudK72S9WSJVgAAMHmgww
        (envelope-from <cfontana@suse.de>); Mon, 04 Sep 2023 08:18:05 +0000
Message-ID: <cfee780b-27ab-8a49-9d42-72fd2a425a17@suse.de>
Date:   Mon, 4 Sep 2023 10:18:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
Content-Language: en-US
To:     Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, qemu-trivial@nongnu.org,
        Marc Zyngier <maz@kernel.org>
References: <20230831190052.129045-1-coltonlewis@google.com>
 <20230901-16232ff17690fc32a0feb5df@orel> <ZPI6KNqGGTxxHhCh@google.com>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <ZPI6KNqGGTxxHhCh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I think this discussion from ~2015 could potentially be be historically relevant for context,
at the time we had the problem with CNTVOFF IIRC so KVM_REG_ARM_TIMER_CNT being read and rewritten causing time warps in the guest:

https://patchwork.kernel.org/project/linux-arm-kernel/patch/1435157697-28579-1-git-send-email-marc.zyngier@arm.com/

I could not remember or find if/where the problem was fixed in the end in QEMU,

Ciao,

Claudio

On 9/1/23 21:23, Colton Lewis wrote:
> On Fri, Sep 01, 2023 at 09:35:47AM +0200, Andrew Jones wrote:
>> On Thu, Aug 31, 2023 at 07:00:52PM +0000, Colton Lewis wrote:
>>> Due to recent KVM changes, QEMU is setting a ptimer offset resulting
>>> in unintended trap and emulate access and a consequent performance
>>> hit. Filter out the PTIMER_CNT register to restore trapless ptimer
>>> access.
>>>
>>> Quoting Andrew Jones:
>>>
>>> Simply reading the CNT register and writing back the same value is
>>> enough to set an offset, since the timer will have certainly moved
>>> past whatever value was read by the time it's written.  QEMU
>>> frequently saves and restores all registers in the get-reg-list array,
>>> unless they've been explicitly filtered out (with Linux commit
>>> 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array). So, to
>>> restore trapless ptimer accesses, we need a QEMU patch to filter out
>>> the register.
>>>
>>> See
>>> https://lore.kernel.org/kvmarm/gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com/T/#m0770023762a821db2a3f0dd0a7dc6aa54e0d0da9
>>
>> The link can be shorter with
>>
>> https://lore.kernel.org/all/20230823200408.1214332-1-coltonlewis@google.com/
> 
> I will keep that in mind next time.
> 
>>> for additional context.
>>>
>>> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
>>
>> Thanks for the testing and posting, Colton. Please add your s-o-b and a
>> Tested-by tag as well.
> 
> Assuming it is sufficient to add here instead of reposting the whole patch:
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> Tested-by: Colton Lewis <coltonlewis@google.com>
> 
>>> ---
>>>  target/arm/kvm64.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>>> index 4d904a1d11..2dd46e0a99 100644
>>> --- a/target/arm/kvm64.c
>>> +++ b/target/arm/kvm64.c
>>> @@ -672,6 +672,7 @@ typedef struct CPRegStateLevel {
>>>   */
>>>  static const CPRegStateLevel non_runtime_cpregs[] = {
>>>      { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
>>> +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
>>>  };
>>>
>>>  int kvm_arm_cpreg_level(uint64_t regidx)
>>> --
>>> 2.42.0.283.g2d96d420d3-goog
>>>
> 

