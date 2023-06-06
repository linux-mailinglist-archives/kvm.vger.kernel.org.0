Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE2723DAE
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbjFFJfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbjFFJeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:34:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8666D1734
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 02:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686044014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfCVlNZr5FMM7IYZiy0Efi0L7IH3DzTFtcUbvK87ioM=;
        b=d2pXKN9m1YM1xDrlHUYZ2LBo+kKBceAjWJ6MldiJDtGO6e27h4/a0p/yGnmmYvcZ9Au4vk
        k0szG4jM4JgNitoHSAabDdsSawUx+TaLRlWM0DqD2NqpWIKDR3i3RojoFdq8hw489ntsTv
        1Aco0Mth7+PTGBx0O0WR0SQJS9mhWK0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-dbkc3YO-OUKVmcW0LBiUmA-1; Tue, 06 Jun 2023 05:33:33 -0400
X-MC-Unique: dbkc3YO-OUKVmcW0LBiUmA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f8390332c0so89124371cf.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 02:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686044012; x=1688636012;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NfCVlNZr5FMM7IYZiy0Efi0L7IH3DzTFtcUbvK87ioM=;
        b=Pd2xcXYS4rWYxQqooF5nD1eDHiNWIIrhJg0j9jsjp2QGuQ1rSrnM2skpC7aiXfMs5o
         XIjNJNKrYkQWmdpkp4HX1OHr1WoQWDCwhOk1Pv4yUG3wUhMadc6Q8mxuuoqUuD0ti+5x
         g4iArVqi+TEJwfvo+XT+zzqmLQzAHPAzcJT3LaqYMlktewzwPHGncFWfXIyt2YilRquu
         xZCh3uSRmN62Ew2jzAPVHtpXIeQNGGk9DH7mHHXa4Mcl8CmScZCyacyMb4l1YpHgjVzG
         UWHAXLqoFWUn2tCgoyB/vdLckFTTVwFy2kpqodTrYKzQrVE8DJC4TIRxSkCuOlsHxYqk
         pH6w==
X-Gm-Message-State: AC+VfDw1NoYDdF3HqS5YJp70DS//3N4NU/OI4nOR3tVP8q1j9HFLzelg
        kcsBJ4e+9+SH5vIYxn9+AK9+3tLTszm7jX1YojB8krwKd+Fyk2SjDMZAHkjQSftky02uu5e/llW
        IQucmrQUmJfZo
X-Received: by 2002:ac8:7c54:0:b0:3f5:1626:6a3d with SMTP id o20-20020ac87c54000000b003f516266a3dmr1313724qtv.42.1686044012697;
        Tue, 06 Jun 2023 02:33:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5n5fSaR9rhGQJeywpdZviphMffC6+N0hasH8JtAg/z6WKXKQqm2K/P4sycA2R8M1LOqxyk5Q==
X-Received: by 2002:ac8:7c54:0:b0:3f5:1626:6a3d with SMTP id o20-20020ac87c54000000b003f516266a3dmr1313701qtv.42.1686044012476;
        Tue, 06 Jun 2023 02:33:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id r12-20020ac85e8c000000b003f9ad6acba4sm634844qtx.79.2023.06.06.02.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:33:31 -0700 (PDT)
Message-ID: <bdcf630c-b6a7-0649-8419-15f98f6b1a0c@redhat.com>
Date:   Tue, 6 Jun 2023 11:33:27 +0200
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
 <16d9fda4-3ead-7d5e-9f54-ef29fbd932ac@redhat.com>
 <87zg64nhqh.wl-maz@kernel.org>
 <d0b77823-c04c-4ee0-cb55-2cc20a48903b@redhat.com>
 <86r0rfkpwd.wl-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <86r0rfkpwd.wl-maz@kernel.org>
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

On 5/17/23 16:12, Marc Zyngier wrote:
> On Wed, 17 May 2023 09:59:45 +0100,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>Hi Marc,
>> On 5/16/23 22:28, Marc Zyngier wrote:
>>> On Tue, 16 May 2023 17:53:14 +0100,
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
>>>>
>>>> I have started testing this and when booting my fedora guest I get
>>>>
>>>> [  151.796544] kvm [7617]: Unsupported guest sys_reg access at:
>>>> 23f425fd0 [80000209]
>>>> [  151.796544]  { Op0( 3), Op1( 3), CRn(14), CRm( 3), Op2( 1), func_write },
>>>>
>>>> as soon as the host has kvm-arm.mode=nested
>>>>
>>>> This seems to be triggered very early by EDK2
>>>> (ArmPkg/Drivers/TimerDxe/TimerDxe.c).
>>>>
>>>> If I am not wrong this CNTV_CTL_EL0. Do you have any idea?
>>>
>>> So here's my current analysis:
>>>
>>> I assume you are running EDK2 as the L1 guest in a nested
>>> configuration. I also assume that you are not running on an Apple
>>> CPU. If these assumptions are correct, then EDK2 runs at vEL2, and is
>>> in nVHE mode.
>>>
>>> Finally, I'm going to assume that your implementation has FEAT_ECV and
>>> FEAT_NV2, because I can't see how it could fail otherwise.
>> all the above is correct.
>>>
>>> In these precise conditions, KVM sets the CNTHCTL_EL2.EL1TVT bit so
>>> that we can trap the EL0 virtual timer and faithfully emulate it (it
>>> is otherwise written to memory, which isn't very helpful).
>>
>> indeed
>>>
>>> As it turns out, we don't handle these traps. I didn't spot it because
>>> my test machines are all Apple boxes that don't have a nVHE mode, so
>>> nothing on the nVHE path is getting *ANY* coverage. Hint: having
>>> access to such a machine would help (shipping address on request!).
>>> Otherwise, I'll eventually kill the nVHE support altogether.
>>>
>>> I have written the following patch, which compiles, but that I cannot
>>> test with my current setup. Could you please give it a go?
>>
>> with the patch below, my guest boots nicely. You did it great on the 1st
>> shot!!! So this fixes my issue. I will continue testing the v10.
> 
> Thanks a lot for reporting the issue and testing my hacks. I'll
> eventually fold it into the rest of the series.
> 
> By the way, what are you using as your VMM? I'd really like to
> reproduce your setup.
Sorry I missed your reply. I am using libvirt + qemu (feat Miguel's RFC)
and fedora L1 guest.

Thanks to your fix, this boots fine. But at the moment it does not
reboot and hangs in edk2 I think. Unfortunately this time I have no
trace on host :-( While looking at your series I will add some traces.

Eric
> 
> Cheers,
> 
> 	M.
> 

