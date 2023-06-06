Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81F5723D6F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbjFFJag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjFFJac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:30:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA3DE5F
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 02:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686043783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvVw+wYo/gtmiGwGSDdmcHXZMo6R18G9lGqfmaFlyIc=;
        b=QzhgUE5WqziYoHXADD10paJMORru3Ue0HebMwKu42kV+2rc7VUyci4t0iBiT5QqSv96k1Z
        BzBuoBu+KU6NWMgtpzc0/+k8U0sPalgLpeokq7dfbPDGW1UcsmOGmGoVBRdzKtfZxZnrsk
        Ov5V0BUN1znb+o55jgzMlHoxcqWjUGI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-O_hzsVOEM0SxBIw3ydysCQ-1; Tue, 06 Jun 2023 05:29:43 -0400
X-MC-Unique: O_hzsVOEM0SxBIw3ydysCQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-62856d3d316so61670736d6.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 02:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686043782; x=1688635782;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VvVw+wYo/gtmiGwGSDdmcHXZMo6R18G9lGqfmaFlyIc=;
        b=kJwND0oe7dlZwnXunIGXkQPdqpjwhuNGNxNGW30WB5D8e2mBn6sfpK3YBo5f61ww2Z
         Q7kcZ8pTigRwnwZ49A8TMs+p9JB9S4ygMiwDfY3Fm3JRHWpznKhR9SqfKhCVP2BilPWz
         P7VpGHZWkK13ICLEbgBr62rxgOCdMiIr4cWgPyvnogSqJcLMd86RDyH56KtbC0lrwlqz
         Zc4pbEJy+kVbcKrMxbvYTu/okOoXUivyt9nuyEBz+KXHfIc+k7rT5AWyoE8s0d2uXUYd
         TdHkNsnTP4xWJplq/sVuAuekLweGRXVKsF5bX8ZVQhWXVIozZplygjuN6FEyu/fg37Ke
         /C8w==
X-Gm-Message-State: AC+VfDycmFWgq+iKcDM+HwRaLrLq0s9mVAkv/89AiqjADMTn8PZ1AOdL
        p6FrjMU01OuiRLQQufAzQKff2gXUI9sv5nzCW7RXzFw4I3lzXAMfo59KNhSIQLgOty73oFcrQZ0
        cL/3r1dMky16g
X-Received: by 2002:ad4:5ae6:0:b0:621:170:68b7 with SMTP id c6-20020ad45ae6000000b00621017068b7mr2000585qvh.35.1686043782470;
        Tue, 06 Jun 2023 02:29:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5WKwmouv2fJWc37kUbEfU577Kxfql4Y418iSiwFMDnsPR2/phC23oilrE3UxHMMSY31bx5IA==
X-Received: by 2002:ad4:5ae6:0:b0:621:170:68b7 with SMTP id c6-20020ad45ae6000000b00621017068b7mr2000569qvh.35.1686043782212;
        Tue, 06 Jun 2023 02:29:42 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w5-20020a0cc245000000b006260c683bf2sm5253563qvh.53.2023.06.06.02.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:29:41 -0700 (PDT)
Message-ID: <c46da9eb-a02d-1b1d-9c1b-9f900a5e9e6d@redhat.com>
Date:   Tue, 6 Jun 2023 11:29:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <9cf2356b-f990-1cd2-c7e6-a984e9f604c6@redhat.com>
 <87r0qpnj2t.wl-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <87r0qpnj2t.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,
On 6/6/23 09:30, Marc Zyngier wrote:
> Hey Eric,
> 
> On Mon, 05 Jun 2023 12:28:12 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 5/15/23 19:30, Marc Zyngier wrote:
>>> This is the 4th drop of NV support on arm64 for this year.
>>>
>>> For the previous episodes, see [1].
>>>
>>> What's changed:
>>>
>>> - New framework to track system register traps that are reinjected in
>>>   guest EL2. It is expected to replace the discrete handling we have
>>>   enjoyed so far, which didn't scale at all. This has already fixed a
>>>   number of bugs that were hidden (a bunch of traps were never
>>>   forwarded...). Still a work in progress, but this is going in the
>>>   right direction.
>>>
>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>   the L0 IPA space. This fixes a number of subtle issues, depending on
>>>   how the initial guest was created.
>>>
>>> - Consequently, the patch series has gone longer again. Boo. But
>>>   hopefully some of it is easier to review...
>>>
>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>>
>>> Andre Przywara (1):
>>>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>>
>> I guess you have executed kselftests on L1 guests. Have all the tests
>> passed there? On my end it stalls in the KVM_RUN.
> 
> No, I hardly run any kselftest, because they are just not designed to
> run at EL2 at all. There's some work to be done there, but I just
> don't have the bandwidth for that (hint, wink...)

oh OK, I missed that point. If nobody is working on this I can start
looking at it. Would be interesting to run them on nested guest too.
> 
>>
>> for instance
>> tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c fails in
>> test_guest_raz(vcpu) on the KVM_RUN. Even with a basic
>>
>> static void guest_main(void)
>> {
>> GUEST_DONE();
>> }
> 
> My guess is that the test harness expects things to run at EL1.
> Depending on the value you get for HCR_EL2, you could get all sort of
> odd behaviours. Also, the harness configures EL1 only, which is
> unlikely to work at EL2. My conclusion is that "processor.c" needs to
> be taught about EL2, at the very least.
> 
>>
>> I get
>>  aarch32_id_regs-768     [002] .....   410.544665: kvm_exit: IRQ:
>> HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] d....   410.544666: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] .....   410.544675: kvm_exit: IRQ:
>> HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] d....   410.544676: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-768     [002] .....   410.544685: kvm_exit: IRQ:
>> HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
>>
>> looping forever instead of
>>
>> aarch32_id_regs-1085576 [079] d..1. 1401295.068739: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] ...1. 1401295.068745: kvm_exit: TRAP:
>> HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] d..1. 1401295.068790: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] ...1. 1401295.068792: kvm_exit: TRAP:
>> HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] d..1. 1401295.068794: kvm_entry: PC:
>> 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] ...1. 1401295.068795: kvm_exit: TRAP:
>> HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
>>  aarch32_id_regs-1085576 [079] d..1. 1401295.068797: kvm_entry: PC:
>> 0x0000000000401ec4
>> ../..
>>
>> Any idea or any known restriction wrt kselftests?
> 
> See above. I'd love someone to actually start looking into it and
> devise a testing harness that would run both at EL{0,1,2} *at the same
> time* so that we can start exercising some of the trap behaviours that
> the architecture mandates.
> 
> Also, Alexandru had a some KUT tests a few years ago, but I don't know
> what happened of them.

Yeah I remember that one too. Alexandru, do you have plans to revive it?
That would be also interesting to run kuts on nested, giving a chance to
have incremental and more unitary testing.

Thanks!

Eric

> 
> Thanks,
> 
> 	M.
> 

