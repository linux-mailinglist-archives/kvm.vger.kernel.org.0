Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33DD77B5A1
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 11:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjHNJih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 05:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbjHNJiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 05:38:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3AA1995
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 02:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692005832;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G2CQ2r2nKutez4n7L0Q2/gUAsc9OoG5P9/PB8IXCPoc=;
        b=Hpujj8lcNEYXt+kFjltBxIeNRJx574wc60zR9ja6wgQLMceoY9/EUTmRfs1Cq5W4GHuxkR
        8L7bd08g/TFL0YCyZMoiUHIYkUfdnNGZUKNtpGV09hRt0DXaZJHyX8h/MqfuUVLKkbyX7T
        tjX43Kjh9/LOr5JHO7AZ/BwPyosJI0I=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-05voS3evOdKaDL4M-sMNag-1; Mon, 14 Aug 2023 05:37:11 -0400
X-MC-Unique: 05voS3evOdKaDL4M-sMNag-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-41043815a38so13328041cf.0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 02:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692005830; x=1692610630;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G2CQ2r2nKutez4n7L0Q2/gUAsc9OoG5P9/PB8IXCPoc=;
        b=FoXvbBxNMSHO4IhPx2jMwXFt8eMP+bzS2+VpRnJL7xxSGPU9fJd4CFfwgW26JQbqr0
         23mZ5K5fcDFkWksILStWFHBJTy3hWSsP9EILtaZhrU43jmexgFfCqtYitKqOKFOX5sif
         Mv8OBmXHJopxWocBrSpQB1yUeDRZ5HVRgBVkxhe10ymOuQGBXmFeahamGyrI3zFNeS5L
         kaVG5dyZY/qLtebNQ//UOnIn39CePob4O7PiWJzF84kLfk5GcALlepoLjQCr9RnxRAg6
         thOB664tczV3lZ4lt/HVAuBKg+HeR/x5yJJi69AFFvTGo9jwbOxOR1bzeEq/f4rBVprD
         jCKQ==
X-Gm-Message-State: AOJu0Ywkyi5GQvojYLNrDp3U7Czfs38K+zbEo1DO8LiwdEMAWCzS5EXg
        7eR2snXGVrb43dNd1tjL7ZrHNCfl9nISQETkDzCufF1mf70JXrxDUP7NE2HGSBvB1u0xtUqreti
        diHqDX1Rx6BZq
X-Received: by 2002:ac8:5810:0:b0:410:31c4:f460 with SMTP id g16-20020ac85810000000b0041031c4f460mr12629762qtg.1.1692005830621;
        Mon, 14 Aug 2023 02:37:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJr+VgF7cwi7o4O7By8vYXhInX3L9u/p0leCSsoLsabz50pa39tlAYfaMySbJvuaIj6fvQBQ==
X-Received: by 2002:ac8:5810:0:b0:410:31c4:f460 with SMTP id g16-20020ac85810000000b0041031c4f460mr12629747qtg.1.1692005830379;
        Mon, 14 Aug 2023 02:37:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t4-20020ac86a04000000b00405447ee5e8sm2971171qtr.55.2023.08.14.02.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 02:37:09 -0700 (PDT)
Message-ID: <3f22f28e-f106-392f-102e-cba8ee3c0ab5@redhat.com>
Date:   Mon, 14 Aug 2023 11:37:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 23/27] KVM: arm64: nv: Add SVC trap forwarding
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-24-maz@kernel.org>
 <2a751a64-559e-cb17-4359-7f368c1b42ca@redhat.com>
 <87wmy3p4ac.wl-maz@kernel.org>
 <527eddd0-b069-3b58-d82e-97b758c128ab@redhat.com>
 <861qgaghen.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <861qgaghen.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/11/23 09:36, Marc Zyngier wrote:
> On Thu, 10 Aug 2023 18:30:25 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>> On 8/10/23 12:42, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On Thu, 10 Aug 2023 09:35:41 +0100,
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>> Hi Marc,
>>>>
>>>> On 8/8/23 13:47, Marc Zyngier wrote:
>>>>> HFGITR_EL2 allows the trap of SVC instructions to EL2. Allow these
>>>>> traps to be forwarded. Take this opportunity to deny any 32bit activity
>>>>> when NV is enabled.
>>>> I can't figure out how HFGITR_EL2.{SVC_EL1, SVC_EL0 and ERET} are
>>>> handled. Please could you explain.
>>> - SVC: KVM itself never traps it, so any trap of SVC must be the
>>>   result of a guest trap -- we don't need to do any demultiplexing. We
>>>   thus directly inject the trap back. This is what the comment in
>>>   handle_svc() tries to capture, but obviously fails to convey the
>>>   point.
>> Thank you for the explanation. Now I get it and this helps.
>>> - ERET: This is already handled since 6898a55ce38c ("KVM: arm64: nv:
>>>   Handle trapped ERET from virtual EL2"). Similarly to SVC, KVM never
>>>   traps it unless we run NV.
>> OK
>>> Now, looking into it, I think I'm missing the additional case where
>>> the L2 guest runs at vEL1. I'm about to add the following patchlet:
>>>
>>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>>> index 3b86d534b995..617ae6dea5d5 100644
>>> --- a/arch/arm64/kvm/handle_exit.c
>>> +++ b/arch/arm64/kvm/handle_exit.c
>>> @@ -222,7 +222,22 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>>>  	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
>>>  		return kvm_handle_ptrauth(vcpu);
>>>  
>>> -	kvm_emulate_nested_eret(vcpu);
>>> +	/*
>>> +	 * If we got here, two possibilities:
>>> +	 *
>>> +	 * - the guest is in EL2, and we need to fully emulate ERET
>>> +	 *
>>> +	 * - the guest is in EL1, and we need to reinject the
>>> +         *   exception into the L1 hypervisor.
>> but in the case the guest was running in vEL1 are we supposed to trap
>> and end up here? in kvm_emulate_nested_eret I can see
>> "the current EL is always the vEL2 since we set the HCR_EL2.NV bit only
>> when entering the vEL2".
> If the guest is running at vEL1, the only ways to trap ERET are:
>
> - if the guest hypervisor has set HFGITR_EL2.ERET, because the host
>   KVM never sets that bit on its own
>
> - or if the guest hypervisor has set HCR_EL2.NV (which we don't really
>   handle so far, as we don't expose FEAT_NV to guests).
>
> If the guest is running at vEL2, then it is HCR_EL2.NV that is
> responsible for the trap, and we perform the ERET emulation.

makes sense to me. Explanation about HFGITR_EL2.ERET case is helpful and
may be worth to be added as a comment.
>
>> But I am still catching up on the already landed
>>
>> [PATCH 00/18] KVM: arm64: Prefix patches for NV support
>> <https://lore.kernel.org/all/20230209175820.1939006-1-maz@kernel.org/>
>> so please forgive me my confusion ;-)
> Confusion is the whole purpose of NV, so don't worry, you're in good
> company here! :D
:-)

Eric
>
> Thanks,
>
> 	M.
>

