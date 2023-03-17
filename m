Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4276BEAC3
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 15:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCQOM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 10:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjCQOMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 10:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C7260AAB
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 07:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679062300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/idMOlH3j3khBngSypGuD3NSbDuaGpvt2I83Bzbdzhg=;
        b=bmwnsG0yRLH9SbyBEpGDgtaeR05IBLHGjrMH01Be4Lj/+i/Nn+l6HSiXbfvFceBWaP38oW
        M5+0zYOQDdH2bcLMLxvGl2CPxnXM1m9GdejVE44j7DOf0eOnE9i0QMelDIz0ELMiHcISmu
        kpfnE3E/+3syOHYW2LAraG2tHjuKMtI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-nqw4dQLLNfiRwDm4vjtkGA-1; Fri, 17 Mar 2023 10:11:38 -0400
X-MC-Unique: nqw4dQLLNfiRwDm4vjtkGA-1
Received: by mail-wr1-f69.google.com with SMTP id o3-20020a5d6483000000b002cc4fe0f7fcso835332wri.7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 07:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679062297;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/idMOlH3j3khBngSypGuD3NSbDuaGpvt2I83Bzbdzhg=;
        b=MClHNmwWgb1fRxhwwHO7BNweLHTNkXWrdrT+8fSSGwQwpBBYSYCGH1K2DrSL9M7pYK
         rtY7ZuZEf2QFC0hIGn1FaQjcTnbFMxwpxDocZTW1JzWu3NaRzkIL5qewHz1Jiv7Iyuc1
         lCwvfioZYiDw149wsQmNZomFekiRNRc4HJQAIrFjHLmqaXA/n/+yP7mbrEnYYyfH7Ay3
         TURAEX3Ww3gWkPt3f0gtNce1kDYFQ5HM/tiP3i4X5fX2mQzb7o/fgUqD0BsmOw4EJbqZ
         mpRZV0AcjJfASjdcmG2OOCMEdbnRDkZrcNdV7pbjPgndeKDJD71SCZyXY+AyakfFKMYB
         ZRLg==
X-Gm-Message-State: AO0yUKXCF9MoJbQ+0FC8Cn7xFff/n1YWztW0CxM0hDn+YScFmh2BrZ39
        6gTkVtltEvHp2WlUgvg7lQJBOH8nZtdUh5QTft9xgUecTMF5A+rnHaBNfmUInWPZR5iJrs5zVGg
        snaXY054twLZ+Ade4CkX2ml0=
X-Received: by 2002:adf:ee82:0:b0:2c9:b9bf:e20c with SMTP id b2-20020adfee82000000b002c9b9bfe20cmr2446406wro.2.1679062297777;
        Fri, 17 Mar 2023 07:11:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set8VV5hpf0OyaSrG3QwT/NFHugVc8teY0e6S4hDgw5s/BMbRRrMTQif6dAKPo0QEL2ukYcMVSw==
X-Received: by 2002:adf:ee82:0:b0:2c9:b9bf:e20c with SMTP id b2-20020adfee82000000b002c9b9bfe20cmr2446387wro.2.1679062297542;
        Fri, 17 Mar 2023 07:11:37 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id n2-20020adffe02000000b002cfeffb442bsm2054306wrr.57.2023.03.17.07.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 07:11:36 -0700 (PDT)
Message-ID: <8deaddfe-dc69-ec3c-4c8c-a76ee17e6513@redhat.com>
Date:   Fri, 17 Mar 2023 15:11:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x/spec_ex: Add test of EXECUTE
 with odd target address
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230315155445.1688249-1-nsg@linux.ibm.com>
 <20230315155445.1688249-4-nsg@linux.ibm.com>
 <86aa2246-07ff-8fb9-ad97-3b68e8b8f109@redhat.com>
In-Reply-To: <86aa2246-07ff-8fb9-ad97-3b68e8b8f109@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/2023 15.09, Thomas Huth wrote:
> On 15/03/2023 16.54, Nina Schoetterl-Glausch wrote:
>> The EXECUTE instruction executes the instruction at the given target
>> address. This address must be halfword aligned, otherwise a
>> specification exception occurs.
>> Add a test for this.
>>
>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> ---
>>   s390x/spec_ex.c | 25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>
>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>> index 83b8c58e..5fa05dba 100644
>> --- a/s390x/spec_ex.c
>> +++ b/s390x/spec_ex.c
>> @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
>>       return 0;
>>   }
>> +static int odd_ex_target(void)
>> +{
>> +    uint64_t pre_target_addr;
>> +    int to = 0, from = 0x0dd;
>> +
>> +    asm volatile ( ".pushsection .text.ex_odd\n"
>> +        "    .balign    2\n"
>> +        "pre_odd_ex_target:\n"
>> +        "    . = . + 1\n"
>> +        "    lr    %[to],%[from]\n"
>> +        "    .popsection\n"
>> +
>> +        "    larl    %[pre_target_addr],pre_odd_ex_target\n"
>> +        "    ex    0,1(%[pre_target_addr])\n"
>> +        : [pre_target_addr] "=&a" (pre_target_addr),
>> +          [to] "+d" (to)
>> +        : [from] "d" (from)
>> +    );
>> +
>> +    assert((pre_target_addr + 1) & 1);
>> +    report(to != from, "did not perform ex with odd target");
>> +    return 0;
>> +}
> 
> Can this be triggered with KVM, or is this just a test for TCG?

With "triggered" I mean: Can this cause an interception in KVM?

  Thomas

