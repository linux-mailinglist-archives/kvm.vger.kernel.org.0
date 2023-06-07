Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3710072662F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjFGQlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 12:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjFGQld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 12:41:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B161FC1
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 09:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686156049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fpkg50D6BVyUdGWRdCuQ66DDXaJBlAuKv87LtulExp0=;
        b=B+i/hZOdfanFCz9PHzmh9fCdmeoi8jEuWM4HjoBzBbMT3WV4FTh9iSO/9526+hg3pKwy8s
        0IjGFHI5bI1T64nUA8eDU8lP9oHyykKt2xHw0wvEFWNGZ9A92TzJ2uP4Y5W6Mn2lqe0+M4
        avBFs308H2krF4Gpb31wQ2amem7ZKv0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-bZKRSZHIPz2VervrFq7qjw-1; Wed, 07 Jun 2023 12:40:48 -0400
X-MC-Unique: bZKRSZHIPz2VervrFq7qjw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f6f2f18ecbso36242885e9.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 09:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156047; x=1688748047;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fpkg50D6BVyUdGWRdCuQ66DDXaJBlAuKv87LtulExp0=;
        b=gQwVoqVkLT9I5u7xqzebtlVT3IvHDKtOjmUCbZzUX1Daub8DMMGvCWHJTL6eoXya3s
         cjrLDnaC8s9eCbGCtBRgaGEehubhr5umZHOs6oCDifUtXTm7jv0y3+pb01fQ3CXOF/Rp
         dsu0T1C3MlLSwauLMURtxUhLnDSGRUICj4qGRUDw8GgVjRkw1adyvRbif4AwQnpkEaQy
         SbQcghmGdEKYRHIrNYROKVViBJyxZl5t14U89BrXbVa1haeg7XqQVZChmCYCBxs5E/fX
         BJlNbpxosBZkhuPj+GqH5DH3a/x+gOXRJQrECl4W3Qe6Fn5PLPDEpq0VRxxyieH0WeY0
         qK3Q==
X-Gm-Message-State: AC+VfDzWoOnWZkyQ43jr99mQZkn8aDWbNkUpVmQ4xxIEKtp7ZHnGtYCi
        9peKE1qJizqlDULeu3n3Q2Tdlg41eykgIIz1EwOXhR/6t5HtcRs3pL0Ng8gzu2amnXyMfpHlvfp
        /ZcAbQii/2HoY
X-Received: by 2002:a05:6000:1cce:b0:30d:efef:a40f with SMTP id bf14-20020a0560001cce00b0030defefa40fmr4915596wrb.62.1686156046908;
        Wed, 07 Jun 2023 09:40:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5XMneL4EviomZ4OYMrrfdd3d8PQXtvG7fWds6bVLPZsT+ziKUWyAOoGfsD7MMkowwkUBkpKg==
X-Received: by 2002:a05:6000:1cce:b0:30d:efef:a40f with SMTP id bf14-20020a0560001cce00b0030defefa40fmr4915568wrb.62.1686156046566;
        Wed, 07 Jun 2023 09:40:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n2-20020a5d4c42000000b00306415ac69asm15802982wrt.15.2023.06.07.09.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 09:40:46 -0700 (PDT)
Message-ID: <14268e71-686d-9c51-901b-6985ad91537f@redhat.com>
Date:   Wed, 7 Jun 2023 18:40:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Content-Language: en-US
To:     Miguel Luis <miguel.luis@oracle.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
 <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
 <86r0rfkpwd.wl-maz@kernel.org>
 <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
 <054769EB-0722-45FB-8670-23CC7915AAA9@oracle.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <054769EB-0722-45FB-8670-23CC7915AAA9@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Miguel,

On 6/6/23 19:52, Miguel Luis wrote:
> Hello Eric, Marc,
> 
>> On 6 Jun 2023, at 09:33, Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 5/17/23 16:12, Marc Zyngier wrote:
>>> On Wed, 17 May 2023 09:59:45 +0100,
>>> Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Marc,
>>>> Hi Marc,
>>>> On 5/16/23 22:28, Marc Zyngier wrote:
>>>>> On Tue, 16 May 2023 17:53:14 +0100,
>>>>> Eric Auger <eauger@redhat.com> wrote:
>>>>>>
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 5/15/23 19:30, Marc Zyngier wrote:
>>>>>>> This is the 4th drop of NV support on arm64 for this year.
>>>>>>>
>>>>>>> For the previous episodes, see [1].
>>>>>>>
>>>>>>> What's changed:
>>>>>>>
>>>>>>> - New framework to track system register traps that are reinjected in
>>>>>>>  guest EL2. It is expected to replace the discrete handling we have
>>>>>>>  enjoyed so far, which didn't scale at all. This has already fixed a
>>>>>>>  number of bugs that were hidden (a bunch of traps were never
>>>>>>>  forwarded...). Still a work in progress, but this is going in the
>>>>>>>  right direction.
>>>>>>>
>>>>>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>>>>>  the L0 IPA space. This fixes a number of subtle issues, depending on
>>>>>>>  how the initial guest was created.
>>>>>>>
>>>>>>> - Consequently, the patch series has gone longer again. Boo. But
>>>>>>>  hopefully some of it is easier to review...
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
>>>>>>
>>>>>> I have started testing this and when booting my fedora guest I get
>>>>>>
>>>>>> [  151.796544] kvm [7617]: Unsupported guest sys_reg access at:
>>>>>> 23f425fd0 [80000209]
>>>>>> [  151.796544]  { Op0( 3), Op1( 3), CRn(14), CRm( 3), Op2( 1), func_write },
>>>>>>
>>>>>> as soon as the host has kvm-arm.mode=nested
>>>>>>
>>>>>> This seems to be triggered very early by EDK2
>>>>>> (ArmPkg/Drivers/TimerDxe/TimerDxe.c).
>>>>>>
>>>>>> If I am not wrong this CNTV_CTL_EL0. Do you have any idea?
>>>>>
>>>>> So here's my current analysis:
>>>>>
>>>>> I assume you are running EDK2 as the L1 guest in a nested
>>>>> configuration. I also assume that you are not running on an Apple
>>>>> CPU. If these assumptions are correct, then EDK2 runs at vEL2, and is
>>>>> in nVHE mode.
>>>>>
>>>>> Finally, I'm going to assume that your implementation has FEAT_ECV and
>>>>> FEAT_NV2, because I can't see how it could fail otherwise.
>>>> all the above is correct.
>>>>>
>>>>> In these precise conditions, KVM sets the CNTHCTL_EL2.EL1TVT bit so
>>>>> that we can trap the EL0 virtual timer and faithfully emulate it (it
>>>>> is otherwise written to memory, which isn't very helpful).
>>>>
>>>> indeed
>>>>>
>>>>> As it turns out, we don't handle these traps. I didn't spot it because
>>>>> my test machines are all Apple boxes that don't have a nVHE mode, so
>>>>> nothing on the nVHE path is getting *ANY* coverage. Hint: having
>>>>> access to such a machine would help (shipping address on request!).
>>>>> Otherwise, I'll eventually kill the nVHE support altogether.
>>>>>
>>>>> I have written the following patch, which compiles, but that I cannot
>>>>> test with my current setup. Could you please give it a go?
>>>>
>>>> with the patch below, my guest boots nicely. You did it great on the 1st
>>>> shot!!! So this fixes my issue. I will continue testing the v10.
>>>
>>> Thanks a lot for reporting the issue and testing my hacks. I'll
>>> eventually fold it into the rest of the series.
>>>
>>> By the way, what are you using as your VMM? I'd really like to
>>> reproduce your setup.
>> Sorry I missed your reply. I am using libvirt + qemu (feat Miguel's RFC)
>> and fedora L1 guest.
>>
> 
> Following this subject, I’ve forward ported Alexandru’s KUT patches
> ( and I encourage others to do it also =) ) which expose an EL2 test that

Do you have a branch available with Alexandru's rebased kut series?

Thanks

Eric
> does three checks:
> 
> - whether VHE is supported and enabled
> - disable VHE
> - re-enable VHE  
> 
> I’m running qemu with virtualization=on as well to run this test and it is passing although
> problems seem to happen when running with virtualization=off, which I’m still looking into it.
> 
> Thanks
> Miguel
> 
>> Thanks to your fix, this boots fine. But at the moment it does not
>> reboot and hangs in edk2 I think. Unfortunately this time I have no
>> trace on host :-( While looking at your series I will add some traces.
>>
>> Eric
>>>
>>> Cheers,
>>>
>>> M.
> 
> 

