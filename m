Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC0A72660A
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 18:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjFGQcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 12:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjFGQb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 12:31:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878401FEB
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 09:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686155441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HekEEfWls+yjC0wx5sh4Q+X+c3/wbXjytqzkk9aIR5M=;
        b=ctbmoKOwAbvYlm1nc600mNuzs9G6uyR4p4uDTHUQ1Cz8R8yRGGzG6Iy529CzNJfhxMC+rh
        hMj9gaVF5GE9xaOjeZylKWN/oQHrx9mlfAvtdf8QQ0Uz4SbRZALY85qxuxz72FgJnZSTzG
        4/GnZQaTzwtCg8Io7BNIaOnqafsGWoY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-0T2_QQDAMIWzBm5x9K2AOg-1; Wed, 07 Jun 2023 12:30:39 -0400
X-MC-Unique: 0T2_QQDAMIWzBm5x9K2AOg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30c5d31b567so2737995f8f.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 09:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686155438; x=1688747438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HekEEfWls+yjC0wx5sh4Q+X+c3/wbXjytqzkk9aIR5M=;
        b=d28wt0h4lbNOg5MTcNee1h79RcrpKj33GsYFCaJkVzReKbWa6XujaMD77AzSHxLTJ0
         VhooB5HKXlPFpB/vZb+77M9JdhtkP/xAGEJP0WnFdRF6lYg+OcKVRLEJFaKzsevH98ic
         wRj2LZju3DM7PDBudN2aBm46oqin1ly1mPkmzhYAu2gWQbHONAWSXuceU2OBoeMw8lbR
         OCO8DpgbKC1jJXEGL451EAUC4qwgOi+xHlWNjJRGTY09fa8IOU6MYZK0fJPKAtQw48Mg
         KiEBdldCDcbJM6bsuqhOdg/CxZtu7uh6uPzsqy5CIrMYP4EaWv1j9Mf4MFQoq0nrbE71
         N/sQ==
X-Gm-Message-State: AC+VfDw5eWfWdQ9DzCg7HeqyS2M9FWCgTY90MN83xmksiNucwK0y50xc
        vfytSbbCXaZ5Tka/lgD0LfVyNbd5DDeLXOw3eph7+IOM04OQoZ2FPvSea8fMUe+vnpzs714aLOc
        zBLsretQ7xA0w
X-Received: by 2002:adf:ec4b:0:b0:2f5:9800:8d3e with SMTP id w11-20020adfec4b000000b002f598008d3emr4750025wrn.47.1686155438135;
        Wed, 07 Jun 2023 09:30:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4VO0yXsaDCa13QI5VCRbwasu1zCREpbQXmBes0MME4iDLfvpzAqo1Bs6btj/3l4HLCo7DP3Q==
X-Received: by 2002:adf:ec4b:0:b0:2f5:9800:8d3e with SMTP id w11-20020adfec4b000000b002f598008d3emr4750000wrn.47.1686155437820;
        Wed, 07 Jun 2023 09:30:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q15-20020a5d574f000000b0030e5a63e2dbsm2290628wrw.80.2023.06.07.09.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 09:30:37 -0700 (PDT)
Message-ID: <4b0bbd22-6fce-b8a7-1df5-f06778a0d28f@redhat.com>
Date:   Wed, 7 Jun 2023 18:30:35 +0200
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
 <c46da9eb-a02d-1b1d-9c1b-9f900a5e9e6d@redhat.com>
 <87o7lso91y.wl-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <87o7lso91y.wl-maz@kernel.org>
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

On 6/6/23 18:22, Marc Zyngier wrote:
> On Tue, 06 Jun 2023 10:29:36 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>> On 6/6/23 09:30, Marc Zyngier wrote:
>>> Hey Eric,
>>>
>>> On Mon, 05 Jun 2023 12:28:12 +0100,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 5/15/23 19:30, Marc Zyngier wrote:
>>>>> This is the 4th drop of NV support on arm64 for this year.
>>>>>
>>>>> For the previous episodes, see [1].
>>>>>
>>>>> What's changed:
>>>>>
>>>>> - New framework to track system register traps that are reinjected in
>>>>>   guest EL2. It is expected to replace the discrete handling we have
>>>>>   enjoyed so far, which didn't scale at all. This has already fixed a
>>>>>   number of bugs that were hidden (a bunch of traps were never
>>>>>   forwarded...). Still a work in progress, but this is going in the
>>>>>   right direction.
>>>>>
>>>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>>>   the L0 IPA space. This fixes a number of subtle issues, depending on
>>>>>   how the initial guest was created.
>>>>>
>>>>> - Consequently, the patch series has gone longer again. Boo. But
>>>>>   hopefully some of it is easier to review...
>>>>>
>>>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>>>>
>>>>> Andre Przywara (1):
>>>>>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>>>>
>>>> I guess you have executed kselftests on L1 guests. Have all the tests
>>>> passed there? On my end it stalls in the KVM_RUN.
>>>
>>> No, I hardly run any kselftest, because they are just not designed to
>>> run at EL2 at all. There's some work to be done there, but I just
>>> don't have the bandwidth for that (hint, wink...)
>>
>> oh OK, I missed that point. If nobody is working on this I can start
>> looking at it. Would be interesting to run them on nested guest too.
> 
> If you want to pick this up, it would be extremely helpful. And no,
> nobody is really looking into it at the moment, so it's all yours!

OK I will study that then :-)

Eric
> 
> Thanks,
> 
> 	M.
> 

