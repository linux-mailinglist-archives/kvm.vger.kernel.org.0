Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F27A77B65F
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 12:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbjHNKQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 06:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbjHNKQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 06:16:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB37133
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 03:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692008114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yO4ixNcrplGZ+NAzDMsq0PAPN989Nujk0uRoLq5dtlU=;
        b=HCTt2eB5xa5DZZtp2K46ZL/MAIy52cc+mueTNYvq8q9jKkXtP01Ri/Ob/8T0cZm1K+1NiX
        3jD6ZmPcas3pOQncX0lp/C40OqI4s3QPX7VSCtjY2YT/P1SBrL+8oUjgJQKaUBQLTgzyr0
        aVagz5hjTeS5UTW0Y6qCpTqvvTU27wo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-dO8Wwh3MPNy7zhQO4w3L-A-1; Mon, 14 Aug 2023 06:15:13 -0400
X-MC-Unique: dO8Wwh3MPNy7zhQO4w3L-A-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fe32caefd8so3686032e87.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 03:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692008111; x=1692612911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yO4ixNcrplGZ+NAzDMsq0PAPN989Nujk0uRoLq5dtlU=;
        b=RcH31maVda6ULs7d1Mwi1WL7DrFxBBugVsMmpWxdE5suY40orbCD2M0xptVVuUcMTZ
         JoqStfChjkLkwJ0n1BM5Fvgzmljy6oG9Ku0VsToFoEb6F3t8IMX2TKJ03zMw5WC9MXYl
         Bt7D3L2niKQmrDAKoFudBN5e4OqqwNLlwCHk/ECDofFwzwon/YdSDeTMJPkstBmoS4Px
         k8a1gDg3PBG/gsAyj6vYtRL8TA1CfUBadJDD8pH5CY0SchQLOy86I/LfQzPd/9us21GY
         6f0oD6kMMIDJ7A1AEAfQUqsyMvNt2/ivXnxjSuANZeOBNpaCgVJw+4oqchPnB0BlzQEO
         2kjQ==
X-Gm-Message-State: AOJu0YwusSZENfKsb1wzemgT7323nsosM1a7dsPKz8bSycHR4M5ZLX4C
        II1s+wieMa1J3+AgZ75pXKVSYjK6AYt+cRjhL0wLHV+hoXxI2hmjaMYpxrfAFu/F9K2bT4Qq9Pa
        SiBi5brQ86xSu
X-Received: by 2002:a05:6512:e82:b0:4fe:536f:4b12 with SMTP id bi2-20020a0565120e8200b004fe536f4b12mr5593165lfb.53.1692008111724;
        Mon, 14 Aug 2023 03:15:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEca0li3s2cCXU3KqOsIHIl+enh83DStfRjmgDfbqbNRd44kTmw2r9zOvatsjVNqOxQyJB2A==
X-Received: by 2002:a05:6512:e82:b0:4fe:536f:4b12 with SMTP id bi2-20020a0565120e8200b004fe536f4b12mr5593146lfb.53.1692008111297;
        Mon, 14 Aug 2023 03:15:11 -0700 (PDT)
Received: from [192.168.8.105] (dynamic-046-114-244-033.46.114.pool.telefonica.de. [46.114.244.33])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c205000b003fe26bf65e7sm13778145wmg.13.2023.08.14.03.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 03:15:10 -0700 (PDT)
Message-ID: <ff259694-eb1b-771a-faaf-b8119b899615@redhat.com>
Date:   Mon, 14 Aug 2023 12:15:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH 2/2] Link with "-z noexecstack" to avoid
 warning from newer versions of ld
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Nico_B=c3=b6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Nico Boehr <nrb@linux.ibm.com>
References: <20230623125416.481755-1-thuth@redhat.com>
 <20230623125416.481755-3-thuth@redhat.com> <ZJWrKtnflTrskPkX@google.com>
 <fc70263c-b7af-d8e0-14f4-4ffcde67aa3e@redhat.com>
 <ZJoSYnZGYrAj11RN@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <ZJoSYnZGYrAj11RN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 27/06/2023 00.34, Sean Christopherson wrote:
> On Fri, Jun 23, 2023, Thomas Huth wrote:
>> On 23/06/2023 16.24, Sean Christopherson wrote:
>>> On Fri, Jun 23, 2023, Thomas Huth wrote:
>>>> Newer versions of ld (from binutils 2.40) complain on s390x and x86:
>>>>
>>>>    ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies
>>>>                 executable stack
>>>>    ld: NOTE: This behaviour is deprecated and will be removed in a
>>>>              future version of the linker
>>>>
>>>> We can silence these warnings by using "-z noexecstack" for linking
>>>> (which should not have any real influence on the kvm-unit-tests since
>>>> the information from the ELF header is not used here anyway, so it's
>>>> just cosmetics).
>>>>
>>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>>> ---
>>>>    Makefile | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/Makefile b/Makefile
>>>> index 0e5d85a1..20f7137c 100644
>>>> --- a/Makefile
>>>> +++ b/Makefile
>>>> @@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>>>>    autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>>>> -LDFLAGS += -nostdlib
>>>> +LDFLAGS += -nostdlib -z noexecstack
>>>
>>> Drat, the pull request[1] I sent to Paolo yesterday only fixes x86[2].
...
>>> Paolo, want me to redo the pull request to drop the x86-specific patch?
>>
>> I can also respin my patch on top of your series later ... the problem
>> currently also only seems to happen on x86 and s390x, on ppc64 and aarch64,
>> the linker does not complain ... so maybe it's even better to do it
>> per-architecture only anyway? Opinions?
> 
> I don't think it makes sense to do this per-arch, other architectures likely aren't
> problematic purely because of linker specific behavior, e.g. see
> 
> https://patches.linaro.org/project/binutils/patch/1506025575-1559-1-git-send-email-jim.wilson@linaro.org

Ok, I've pushed now my patches since other people were running into this 
issue, too (see 
https://lore.kernel.org/kvm/20230809091717.1549-1-nrb@linux.ibm.com/ ).

Sean, could you please rebase your series now?

  Thanks,
   Thomas


