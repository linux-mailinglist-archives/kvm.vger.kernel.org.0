Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A026ED5F7
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 22:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjDXUMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 16:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjDXUMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 16:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C13A1AE
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682367076;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=57+1CoIbrom/szrhzshu5SQyw+6RojrTHlQMs4SQFiA=;
        b=Xm6F6H2v4iFbheeP2eBn5he6or4VV/bHh4fdfVkVmZmJ1fZVFVk62cQqMBJzw4/COhKkos
        6XF90p/PfMNSCZ79E9bRLaLiywWH47Gskud286p1GqpquvXm/qQ6fsV/nbLbVSuBeTciGm
        q4r+Z5gMuqwa0vTVCO/3nDMVPMYWHfM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-wJ89NkPyP6i7O4joBJUYJA-1; Mon, 24 Apr 2023 16:11:15 -0400
X-MC-Unique: wJ89NkPyP6i7O4joBJUYJA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f16ef3be6eso28936625e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 13:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682367073; x=1684959073;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57+1CoIbrom/szrhzshu5SQyw+6RojrTHlQMs4SQFiA=;
        b=YLJU7iIIZJYF1BzTTMcXL3O6tVtZB2KSWH0bCZu+tzod6hr07dzzjxAPrQANLDc1lA
         TZdfRj05K0Gest1wJikhdryHLpYWMDQs10fHJ3QNI5IOKWkrTtLL3Pklxhny2zJ6y+jz
         dI9bqUXzI9AEL241wCwE/Wz1D2PGlCMs6JM6/t6rohQmjPeZC6ZkxlRtT3bm0oJVkg6X
         Ftc1RoFMuX04ZM13iw7gdre5PHkOUW1fvi/iNMklfKdP4CgF9JG6PyQN5Pkwq2O1glJJ
         xf3e9smEezmEHW3Zuya9UqBNoLoBaM6M2BOWIB5fQDarJGNRUKNbbwDPaxw6I/H7FVzM
         aWxw==
X-Gm-Message-State: AAQBX9dzgVSQCcsSYT429IJOHqn93zLNV6Beacpn/ovBaa5LVJMdRqzY
        YXMThAWSgI9uLTuHNE/yuOOCsOEQUjvs2aPiBvmEvSIAOj3n8NZQ/g881J4n4WH2DahFqQ5TRQR
        P1bwV7uM4psbYywB/jVZf
X-Received: by 2002:a5d:494e:0:b0:2f7:85e0:de75 with SMTP id r14-20020a5d494e000000b002f785e0de75mr11256920wrs.19.1682367073461;
        Mon, 24 Apr 2023 13:11:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350b+GY5FQw1XbCO68U7WIdFpic0MlAznH0ayFhJEMTBm31qyz11+BAcGh7VOsIb+N9AaNXAWGw==
X-Received: by 2002:a5d:494e:0:b0:2f7:85e0:de75 with SMTP id r14-20020a5d494e000000b002f785e0de75mr11256899wrs.19.1682367073137;
        Mon, 24 Apr 2023 13:11:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id eo9-20020a05600c82c900b003f0ad8d1c69sm10025559wmb.25.2023.04.24.13.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 13:11:12 -0700 (PDT)
Message-ID: <48ea7b8f-8bc3-def5-3bfa-e4a1ee41971a@redhat.com>
Date:   Mon, 24 Apr 2023 22:11:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/6] arm: pmu: Add extra DSB barriers in
 the mem_access loop
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-4-eric.auger@redhat.com>
 <ZEJkozep6M4EqxPW@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZEJkozep6M4EqxPW@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 4/21/23 12:25, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Mar 15, 2023 at 12:07:22PM +0100, Eric Auger wrote:
>> The mem access loop currently features ISB barriers only. However
>> the mem_access loop counts the number of accesses to memory. ISB
>> do not garantee the PE cannot reorder memory access. Let's
>> add a DSB ISH before the write to PMCR_EL0 that enables the PMU
>> and after the last iteration, before disabling the PMU.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>
>> ---
>>
>> This was discussed in https://lore.kernel.org/all/YzxmHpV2rpfaUdWi@monolith.localdoman/
>> ---
>>  arm/pmu.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index b88366a8..dde399e2 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -301,6 +301,7 @@ static void mem_access_loop(void *addr, long loop, uint32_t pmcr)
>>  {
>>  	uint64_t pmcr64 = pmcr;
>>  asm volatile(
>> +	"       dsb     ish\n"
> I think it might still be possible to reorder memory accesses which are
> part of the loop after the DSB above and before the PMU is enabled below.
> But the DSB above is needed to make sure previous memory accesses, which
> shouldn't be counted as part of the loop, are completed.
>
> I would put another DSB after the ISB which enables the PMU, that way all
> memory accesses are neatly sandwitches between two DSBs.
>
> Having 3 DSBs might look like overdoing it, but I reason it to be correct.
> What do you think?
I need more time to investigate this. I will come back to you next week
as I am OoO this week. Sorry for the inconvenience.
Thank you for the review!

Eric
>
> Thanks,
> Alex
>
>>  	"       msr     pmcr_el0, %[pmcr]\n"
>>  	"       isb\n"
>>  	"       mov     x10, %[loop]\n"
>> @@ -308,6 +309,7 @@ asm volatile(
>>  	"       ldr	x9, [%[addr]]\n"
>>  	"       cmp     x10, #0x0\n"
>>  	"       b.gt    1b\n"
>> +	"       dsb     ish\n"
>>  	"       msr     pmcr_el0, xzr\n"
>>  	"       isb\n"
>>  	:
>> -- 
>> 2.38.1
>>
>>

