Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC6581FB8
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 08:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiG0GEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 02:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiG0GEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 02:04:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E7B62A735
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 23:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658901890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGGpQRG5NfENu58Dnc3u06GYqyWqp8yCHbeIgRFF6sk=;
        b=SMi568g0TIo+NmyxbTBGQz2xrNpQOkUead91kyC1DVGKHFji73CYVVc3Zuqzgr3J4gR15r
        ONVCNYuqdQTfv3s6wnG4g8Gb+X9aR7+QXxVC6GGnQTkzGZypBwFrLUDTnm8uppgDPamJ0q
        BknhCcQVx3PqI/9ROm4qjat+FQdzhFI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-ZkkTvdjeN7mDD_24mXmtxw-1; Wed, 27 Jul 2022 02:04:48 -0400
X-MC-Unique: ZkkTvdjeN7mDD_24mXmtxw-1
Received: by mail-ed1-f69.google.com with SMTP id i5-20020a05640242c500b0043c17424381so4178297edc.13
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 23:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qGGpQRG5NfENu58Dnc3u06GYqyWqp8yCHbeIgRFF6sk=;
        b=Ws7pynztEltOZ7w2R4WjcUbpq0NeU31Oyx1ppgD8Tnria8MGEm42flaXiZ7tXbNA+A
         R+KomuaLy/3L2bo3USxC9IDqFHP2CqNp6fjAlYMDhQJqNlq0R0fCR7aKexmxY1YQAIn1
         wEW97EbbKCSBU4Mn/LQBUgYhEhqvJa4tk7L79F4J5MdUfLFOfqWR3zDbawgopfDmGHlG
         FyOGQ2ouX2wK3o2NpqdtZ72ZuIfW8TnrkeG2v3CyEAES37xQZY5XSsYTqMbSCMHjUBcZ
         /svfMTlvBJWKDLPLIV/mCPOkHYOf3MGaeY/Arx/uXWnEc/+CXI7Ona7SjKbsIgBXDga5
         fCHg==
X-Gm-Message-State: AJIora+HoBjjwwlQa7/4rQvXotX9ScfyWNaQX7DU4skUgxM3OCdh2v+k
        tNfcPz6OFGGAJZpPSrNLkJyIrXUZa/xAFeRQ8uLtEUIHl+8CP1Q0KhPranIVt9Z3hG31oSA0y5x
        X+pdWIlqcDJRJ
X-Received: by 2002:a17:907:3e9a:b0:72b:44d4:4482 with SMTP id hs26-20020a1709073e9a00b0072b44d44482mr16692431ejc.34.1658901887403;
        Tue, 26 Jul 2022 23:04:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uRr6c6hKucig/dga4T4gDTN96hAhDHJNAMluMMelMIe5+TUBIId14Pd3/MqiqqUugiwAMbKg==
X-Received: by 2002:a17:907:3e9a:b0:72b:44d4:4482 with SMTP id hs26-20020a1709073e9a00b0072b44d44482mr16692423ejc.34.1658901887179;
        Tue, 26 Jul 2022 23:04:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id kv5-20020a17090778c500b006feec47dae9sm7102671ejc.157.2022.07.26.23.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 23:04:46 -0700 (PDT)
Message-ID: <162240da-39c5-bed2-166c-58d34bcd4130@redhat.com>
Date:   Wed, 27 Jul 2022 08:04:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH kvm-unit-tests] x86: add and use *_BIT constants for CR0,
 CR4, EFLAGS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20220726151232.92584-1-pbonzini@redhat.com>
 <YuAlHgkpBZS0QJ5e@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YuAlHgkpBZS0QJ5e@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/22 19:32, Sean Christopherson wrote:
> On Tue, Jul 26, 2022, Paolo Bonzini wrote:
>> The "BIT" macro cannot be used in top-level assembly statements
>> (it can be used in functions through the "i" constraint).  To
>> avoid having to hard-code EFLAGS.AC being bit 18, define the
>> constants for CR0, CR4 and EFLAGS bits in terms of new macros
>> for just the bit number.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> 
> ...
> 
>> diff --git a/x86/smap.c b/x86/smap.c
>> index 0994c29..3f63ee1 100644
>> --- a/x86/smap.c
>> +++ b/x86/smap.c
>> @@ -39,7 +39,7 @@ asm ("pf_tss:\n"
>>   #endif
>>   	"add $"S", %"R "sp\n"
>>   #ifdef __x86_64__
>> -	"orl $" xstr(X86_EFLAGS_AC) ", 2*"S"(%"R "sp)\n"  // set EFLAGS.AC and retry
> 
> I don't understand, this compiles cleanly on both gcc and clang, and generates the
> correct code.  What am I missing?

I saw a failure on older binutils where 1UL is not accepted by the 
assembler.

An alternative is to have some kind of __ASSEMBLY__ symbol as in Linux.

Paolo

