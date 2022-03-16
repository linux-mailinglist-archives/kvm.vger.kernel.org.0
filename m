Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3DE4DAED2
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 12:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348162AbiCPLYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 07:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355280AbiCPLYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 07:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B59773C4B1
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 04:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647429785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xt/N28QarI8r1Ey9RthCWgxM9Kl6RJSxLZpSUL7Ruh8=;
        b=QQIcW7HyBnm4/jIzAJvuncPU8uAz2L24gBYRhhc/1cUsG6tnu6+3uP6oNj8YuVF+UCCBpJ
        blhiUksLdpV8Zc/Ila8BEQPC27KGoE3xnAGyj0k5Zj43d8tr0B8ukgq+VVKttE2sN04+H7
        4xjwk/Kv2SNmA7m6WdKeuBdM4iTpaco=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-bega1SeCM9-0ZVINv6eXjQ-1; Wed, 16 Mar 2022 07:23:04 -0400
X-MC-Unique: bega1SeCM9-0ZVINv6eXjQ-1
Received: by mail-wm1-f71.google.com with SMTP id z16-20020a05600c0a1000b0038bebbd8548so1967676wmp.3
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 04:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xt/N28QarI8r1Ey9RthCWgxM9Kl6RJSxLZpSUL7Ruh8=;
        b=XNGe/cUoUkZpfLP1unPLZ9UQ34kkMpvF/ZK8kgB7ghjBslGbT7yFuVSDjxnK8DItGd
         7x9G1ZLAxJtXMX//iosg2ji7+BD38KGraRzS2R4cwgd9HQntutBHgQ4zeWDiWlrAcBV2
         vG2exconE68J+bpcy4N/GNcyqeC4/M1a6OxeLwNj8Xc7Qp20D6tnzpEhtJyohNIzFMNb
         6mF5KrvQ96m/IVzyZSgSQtSvzFDY/KB52X6oPVrw6d0vcBC77G/ooxKP8h6ytIwkHhei
         quwWxazuiAmo2QDV2PicAhCPSixAYSgqNNMgYr6ihR/aaQVj8etsAjfOzhO/5W3NBeGc
         Ppqg==
X-Gm-Message-State: AOAM532Zj7Pa8aEleWT03Q3qG/nm0p3R7LshHiS+RBpoefahwXDVsJbH
        gz+rfQSBRWfYlNwS08CNwXQlIOST8fGLE60WtUIXghF/oLN/RN5f7ZS3VtfqHPlgFa2E+vfeS0L
        KH2nLC0PJW6wR
X-Received: by 2002:a5d:6c6f:0:b0:203:7796:2d4 with SMTP id r15-20020a5d6c6f000000b00203779602d4mr24587231wrz.393.1647429783530;
        Wed, 16 Mar 2022 04:23:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAnPuLOz8nAlJGOBG77saKiRJ8ls+OBK3GUlU71ooLY1rrlYp8LeBeAIzIwrq47S10XPh7Sw==
X-Received: by 2002:a5d:6c6f:0:b0:203:7796:2d4 with SMTP id r15-20020a5d6c6f000000b00203779602d4mr24587194wrz.393.1647429783234;
        Wed, 16 Mar 2022 04:23:03 -0700 (PDT)
Received: from [192.168.42.76] (tmo-065-170.customers.d1-online.com. [80.187.65.170])
        by smtp.gmail.com with ESMTPSA id u8-20020a5d4348000000b00203dbfa4ff2sm1440376wrr.34.2022.03.16.04.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 04:23:02 -0700 (PDT)
Message-ID: <ba668d50-e960-0dd3-6069-1fe89ac549be@redhat.com>
Date:   Wed, 16 Mar 2022 12:22:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 10/27] Replace config-time define HOST_WORDS_BIGENDIAN
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     marcandre.lureau@redhat.com, qemu-devel@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Peter Xu <peterx@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Yanan Wang <wangyanan55@huawei.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Vikram Garhwal <fnu.vikram@xilinx.com>,
        "open list:virtio-blk" <qemu-block@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Huacai Chen <chenhuacai@kernel.org>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>,
        "open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>,
        "open list:ARM PrimeCell and..." <qemu-arm@nongnu.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "open list:PowerPC TCG CPUs" <qemu-ppc@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eduardo Habkost <eduardo@habkost.net>,
        "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
References: <20220316095308.2613651-1-marcandre.lureau@redhat.com>
 <9c101703-6aff-4188-a56a-8114281f75f4@redhat.com>
 <20220316121535.16631f9c.pasic@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220316121535.16631f9c.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/2022 12.15, Halil Pasic wrote:
> On Wed, 16 Mar 2022 11:28:59 +0100
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> On 16/03/2022 10.53, marcandre.lureau@redhat.com wrote:
>>> From: Marc-André Lureau <marcandre.lureau@redhat.com>
>>>
>>> Replace a config-time define with a compile time condition
>>> define (compatible with clang and gcc) that must be declared prior to
>>> its usage. This avoids having a global configure time define, but also
>>> prevents from bad usage, if the config header wasn't included before.
>>>
>>> This can help to make some code independent from qemu too.
>>>
>>> gcc supports __BYTE_ORDER__ from about 4.6 and clang from 3.2.
>>>
>>> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
>>> ---
>> [...]
>>> @@ -188,7 +188,7 @@ CPU_CONVERT(le, 64, uint64_t)
>>>     * a compile-time constant if you pass in a constant.  So this can be
>>>     * used to initialize static variables.
>>>     */
>>> -#if defined(HOST_WORDS_BIGENDIAN)
>>> +#if HOST_BIG_ENDIAN
>>>    # define const_le32(_x)                          \
>>>        ((((_x) & 0x000000ffU) << 24) |              \
>>>         (((_x) & 0x0000ff00U) <<  8) |              \
>>> @@ -211,7 +211,7 @@ typedef union {
>>>    
>>>    typedef union {
>>>        float64 d;
>>> -#if defined(HOST_WORDS_BIGENDIAN)
>>> +#if HOST_BIG_ENDIAN
>>>        struct {
>>>            uint32_t upper;
>>>            uint32_t lower;
>>> @@ -235,7 +235,7 @@ typedef union {
>>>    
>>>    typedef union {
>>>        float128 q;
>>> -#if defined(HOST_WORDS_BIGENDIAN)
>>> +#if HOST_BIG_ENDIAN
>>>        struct {
>>>            uint32_t upmost;
>>>            uint32_t upper;
>>> diff --git a/include/qemu/compiler.h b/include/qemu/compiler.h
>>> index 0a5e67fb970e..7fdd88adb368 100644
>>> --- a/include/qemu/compiler.h
>>> +++ b/include/qemu/compiler.h
>>> @@ -7,6 +7,8 @@
>>>    #ifndef COMPILER_H
>>>    #define COMPILER_H
>>>    
>>> +#define HOST_BIG_ENDIAN (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)
>>
>> Why don't you do it this way instead:
>>
>> #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
>> #define HOST_WORDS_BIGENDIAN 1
>> #endif
>>
>> ... that way you could avoid the churn in all the other files?
>>
> 
> I guess "prevents from bad usage, if the config header wasn't included
> before" from the commit message is the answer to that question. I agree
> that it is more robust. If we keep the #if defined we really can't
> differentiate between "not defined because not big-endian" and "not
> defined because the appropriate header was not included."
> 

Ok, fair point, now I got it.

Acked-by: Thomas Huth <thuth@redhat.com>

