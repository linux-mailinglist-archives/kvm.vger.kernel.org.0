Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EA66BEE82
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 17:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCQQiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 12:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCQQiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 12:38:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EDDE5015
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 09:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679071030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/y8zeyjefSkAOA8QaVCpOrFBrFGYMJHgyLbILMS2iqI=;
        b=Itg1dqZFtmvV3Hi3nAKcNbD0tFFUWhaV68GVG4OkNjDGec9x46VhWSMFBRNvsTsmJyaYeK
        c8/C1EZNtiwUbKMffADm7yJShx9I11B3uTti+6aBSxcCQ0EZizYUbDLyY4JdTuGrWW5XCr
        okAU7QkClBks+nPvmv+kYZglChNTqdc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-y6bOqFewNo-83eMZv65nqQ-1; Fri, 17 Mar 2023 12:37:09 -0400
X-MC-Unique: y6bOqFewNo-83eMZv65nqQ-1
Received: by mail-wm1-f69.google.com with SMTP id bd26-20020a05600c1f1a00b003ed23f09060so2113487wmb.3
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 09:37:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071028;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/y8zeyjefSkAOA8QaVCpOrFBrFGYMJHgyLbILMS2iqI=;
        b=KXTNM8Xls8Pb0pDroHeNgv+0Z04Ev9Z1dKXCwFhtfXdcoEMxTEfIj8ZBTcGjOYuqSE
         wp6TyNrB/gQP5EJjoIwCKVFFu/5N56xHNde3O0oGfL7fw1DrJ75O2Sm/yJaq2aYyAmGg
         uemC+HyBeF0gHPldEJ8lDCCAvbJRw4DdUjnlyxYXU7SwnAIptC+QlVhcncTUsBb73WAz
         voAWR5NY4cDXg3LS3GhfxMfqvA1osthsMtr0uNILdNOASzYHOQl79pFsbqrxGDHbBMKb
         ohi+QHZzcF0MOvnIfPWQV0qG0BFimYNZGmjJ0z1Nq3pWopby+9SY5axbpIMi2RCDGp/s
         2P8g==
X-Gm-Message-State: AO0yUKUvC7/bQuOu+qe59FjvvyfHf4jbXHNilkNx+bjFQpxDkyJfl09q
        byUrKa5SAsrgbGfDQRoJiouUpM2dUX569P3nvDV3eakaNGpO0N1N2qz/iZspphuMx/rEwkGX5I9
        ac/tfmXDEj9FgfC2y9hgWbSk=
X-Received: by 2002:a05:600c:1ca3:b0:3ed:2606:d236 with SMTP id k35-20020a05600c1ca300b003ed2606d236mr16059363wms.38.1679071028477;
        Fri, 17 Mar 2023 09:37:08 -0700 (PDT)
X-Google-Smtp-Source: AK7set9Ka1YJT0wlT1v41EY76h2N25wauHSUbnsUXmKdCysd1FXD0NvtHiK6LvC3TM0IMjwUTmDwSQ==
X-Received: by 2002:a05:600c:1ca3:b0:3ed:2606:d236 with SMTP id k35-20020a05600c1ca300b003ed2606d236mr16059346wms.38.1679071028165;
        Fri, 17 Mar 2023 09:37:08 -0700 (PDT)
Received: from [192.168.8.107] (tmo-099-146.customers.d1-online.com. [80.187.99.146])
        by smtp.gmail.com with ESMTPSA id l26-20020a05600c2cda00b003dd1bd0b915sm8514948wmc.22.2023.03.17.09.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:37:07 -0700 (PDT)
Message-ID: <d9d18828-596f-cd92-887d-aa3c7cbb6e6f@redhat.com>
Date:   Fri, 17 Mar 2023 17:37:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230315155445.1688249-1-nsg@linux.ibm.com>
 <20230315155445.1688249-4-nsg@linux.ibm.com>
 <86aa2246-07ff-8fb9-ad97-3b68e8b8f109@redhat.com>
 <8deaddfe-dc69-ec3c-4c8c-a76ee17e6513@redhat.com>
 <20230317163654.211830c0@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x/spec_ex: Add test of EXECUTE
 with odd target address
In-Reply-To: <20230317163654.211830c0@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/2023 16.36, Claudio Imbrenda wrote:
> On Fri, 17 Mar 2023 15:11:35 +0100
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> On 17/03/2023 15.09, Thomas Huth wrote:
>>> On 15/03/2023 16.54, Nina Schoetterl-Glausch wrote:
>>>> The EXECUTE instruction executes the instruction at the given target
>>>> address. This address must be halfword aligned, otherwise a
>>>> specification exception occurs.
>>>> Add a test for this.
>>>>
>>>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>>> ---
>>>>    s390x/spec_ex.c | 25 +++++++++++++++++++++++++
>>>>    1 file changed, 25 insertions(+)
>>>>
>>>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>>>> index 83b8c58e..5fa05dba 100644
>>>> --- a/s390x/spec_ex.c
>>>> +++ b/s390x/spec_ex.c
>>>> @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
>>>>        return 0;
>>>>    }
>>>> +static int odd_ex_target(void)
>>>> +{
>>>> +    uint64_t pre_target_addr;
>>>> +    int to = 0, from = 0x0dd;
>>>> +
>>>> +    asm volatile ( ".pushsection .text.ex_odd\n"
>>>> +        "    .balign    2\n"
>>>> +        "pre_odd_ex_target:\n"
>>>> +        "    . = . + 1\n"
>>>> +        "    lr    %[to],%[from]\n"
>>>> +        "    .popsection\n"
>>>> +
>>>> +        "    larl    %[pre_target_addr],pre_odd_ex_target\n"
>>>> +        "    ex    0,1(%[pre_target_addr])\n"
>>>> +        : [pre_target_addr] "=&a" (pre_target_addr),
>>>> +          [to] "+d" (to)
>>>> +        : [from] "d" (from)
>>>> +    );
>>>> +
>>>> +    assert((pre_target_addr + 1) & 1);
>>>> +    report(to != from, "did not perform ex with odd target");
>>>> +    return 0;
>>>> +}
>>>
>>> Can this be triggered with KVM, or is this just a test for TCG?
>>
>> With "triggered" I mean: Can this cause an interception in KVM?
> 
> AFAIK no, but KVM and TCG are not the only things we might want to test.

Ok, fair, KVM unit tests are not for KVM only anymore since quite a while, 
so if this is helpful elsewhere, I'm fine with this.

Acked-by: Thomas Huth <thuth@redhat.com>

