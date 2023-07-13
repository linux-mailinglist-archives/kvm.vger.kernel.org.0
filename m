Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79426751935
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbjGMG6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 02:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjGMG6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 02:58:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8977C268D
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 23:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689231473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FkUDksLkfPco+7wyI296HUS7y9CDt8j4euYQ6B06Lss=;
        b=PleqlY9BwqTEmUUNhJrkMcJ9fpOSsJqHK1XGZhPDmEjwswuuWoIMm/SfyuXcEtrcO+ckad
        nIMDC9E74E5fyAu3/6YLK5U4+9jlQN1nregsRlyMB7ynuvQluJneOuVqCFbZnlgRubJGWB
        Qk+8+jqScr05fX09HVpAOM0NlOGzZIM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-IcivmZXDPIisIxy30YNvsg-1; Thu, 13 Jul 2023 02:57:52 -0400
X-MC-Unique: IcivmZXDPIisIxy30YNvsg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7656a0f8565so105736585a.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 23:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689231472; x=1691823472;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FkUDksLkfPco+7wyI296HUS7y9CDt8j4euYQ6B06Lss=;
        b=gfqOoYZgyV5bWBLh+coOGfO4EFatDisszfCXLGlSzu+mafTs3yrGcWrAwASU9HytTt
         7jEG4tth0ZStAuMZl8WLSOAKCNKEl6R+MAFIfeNpR9RiOHcPFC/RC03Sv7TlISmse7Au
         wmlAJHk65P2CFKw7XrnYCvxP98PMwiUTJ9U3TrqTmlbM54nqHZT4el6SA7AAjpJvSGCC
         6Hzo87u4ZhDU/j1j/a9vlkvH6C2SguPcy+/fUV2z7wSMDxMi4dEEyO+tjN2LE9cKHAoG
         KwBn78irjpeWf2EBQJN/oOv4Xcf64zcpkMCmGam3OuBe+IR7LWdkoeYa8dcNRDRD7mrV
         tpqw==
X-Gm-Message-State: ABy/qLazNH3W2T86keAw+dCmMVBSotgsHqVE5bIimkJJF05H1HJZXulE
        sfwUs749UeIC5gVRkj4pBx9Ol2+w55rY7xgZ9o5AP5UyiX6iO5EIWk8wJgtClZrYWMx6oqCQvzv
        qbOdTkMlNItXc
X-Received: by 2002:a05:620a:394a:b0:767:e55c:d3ba with SMTP id qs10-20020a05620a394a00b00767e55cd3bamr1006453qkn.3.1689231471925;
        Wed, 12 Jul 2023 23:57:51 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEltUOn6hK/qYK9V7xYjCXYyprYEc23ogRF1mZF4E/ap9JA7M7qdA/lRoz3YOmRByG6OE2hJw==
X-Received: by 2002:a05:620a:394a:b0:767:e55c:d3ba with SMTP id qs10-20020a05620a394a00b00767e55cd3bamr1006443qkn.3.1689231471470;
        Wed, 12 Jul 2023 23:57:51 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id i6-20020a37c206000000b00767e669d5d6sm1967452qkm.50.2023.07.12.23.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 23:57:51 -0700 (PDT)
Message-ID: <4919d35f-7a3c-89c7-4287-c1a30508524d@redhat.com>
Date:   Thu, 13 Jul 2023 08:57:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH v5 1/6] lib: s390x: introduce bitfield for
 PSW mask
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
 <20230712114149.1291580-2-nrb@linux.ibm.com>
 <53d9d63f-e207-23a6-faea-8bad8b22a375@redhat.com>
In-Reply-To: <53d9d63f-e207-23a6-faea-8bad8b22a375@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/2023 08.56, Thomas Huth wrote:
> On 12/07/2023 13.41, Nico Boehr wrote:
>> Changing the PSW mask is currently little clumsy, since there is only the
>> PSW_MASK_* defines. This makes it hard to change e.g. only the address
>> space in the current PSW without a lot of bit fiddling.
>>
>> Introduce a bitfield for the PSW mask. This makes this kind of
>> modifications much simpler and easier to read.
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 26 +++++++++++++++++++++++++-
>>   s390x/selftest.c         | 40 ++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 65 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index bb26e008cc68..53279572a9ee 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -37,12 +37,36 @@ struct stack_frame_int {
>>   };
>>   struct psw {
>> -    uint64_t    mask;
>> +    union {
>> +        uint64_t    mask;
>> +        struct {
>> +            uint8_t reserved00:1;
>> +            uint8_t per:1;
>> +            uint8_t reserved02:3;
>> +            uint8_t dat:1;
>> +            uint8_t io:1;
>> +            uint8_t ext:1;
>> +            uint8_t key:4;
>> +            uint8_t reserved12:1;
>> +            uint8_t mchk:1;
>> +            uint8_t wait:1;
>> +            uint8_t pstate:1;
>> +            uint8_t as:2;
>> +            uint8_t cc:2;
>> +            uint8_t prg_mask:4;
>> +            uint8_t reserved24:7;
>> +            uint8_t ea:1;
>> +            uint8_t ba:1;
>> +            uint32_t reserved33:31;
>> +        };
>> +    };
>>       uint64_t    addr;
>>   };
>> +_Static_assert(sizeof(struct psw) == 16, "PSW size");
>>   #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
>> +
>>   struct short_psw {
>>       uint32_t    mask;
>>       uint32_t    addr;
>> diff --git a/s390x/selftest.c b/s390x/selftest.c
>> index 13fd36bc06f8..8d81ba312279 100644
>> --- a/s390x/selftest.c
>> +++ b/s390x/selftest.c
>> @@ -74,6 +74,45 @@ static void test_malloc(void)
>>       report_prefix_pop();
>>   }
>> +static void test_psw_mask(void)
>> +{
>> +    uint64_t expected_key = 0xF;
>> +    struct psw test_psw = PSW(0, 0);
>> +
>> +    report_prefix_push("PSW mask");
>> +    test_psw.dat = 1;
>> +    report(test_psw.mask == PSW_MASK_DAT, "DAT matches expected=0x%016lx 
>> actual=0x%016lx", PSW_MASK_DAT, test_psw.mask);
>> +
>> +    test_psw.mask = 0;
>> +    test_psw.io = 1;
>> +    report(test_psw.mask == PSW_MASK_IO, "IO matches expected=0x%016lx 
>> actual=0x%016lx", PSW_MASK_IO, test_psw.mask);
>> +
>> +    test_psw.mask = 0;
>> +    test_psw.ext = 1;
>> +    report(test_psw.mask == PSW_MASK_EXT, "EXT matches expected=0x%016lx 
>> actual=0x%016lx", PSW_MASK_EXT, test_psw.mask);
>> +
>> +    test_psw.mask = expected_key << (63 - 11);
>> +    report(test_psw.key == expected_key, "PSW Key matches expected=0x%lx 
>> actual=0x%x", expected_key, test_psw.key);
> 
> Patch looks basically fine to me, but here my mind stumbled a little bit. 
> This test is written the other way round than the others. Nothing wrong with 
> that, it just feels a little bit inconsistent. I'd suggest to either do:
> 
>      test_psw.mask = 0;
>      test_psw.key = expected_key;
>      report(test_psw.mask == expected_key << (63 - 11), ...);
> 
> or maybe even switch all the other tests around instead, so you could get 
> rid of the "test_psw.mask = 0" lines, e.g. :
> 
>      test_psw.mask == PSW_MASK_IO;

s/==/=/ of course!

Sorry for that typo.

  Thomas


>      report(test_psw.io, "IO matches ...");
> 
> etc.
> 
>   Thomas
> 

