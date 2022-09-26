Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C476E5EA908
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 16:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbiIZOwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 10:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiIZOvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 10:51:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C026F6
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 06:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664198239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nwm3H1a+y6Q/ANNgSpk2UwQQMq3N5bRTe9xIUQIog9Y=;
        b=UuAtqqm4xFKO4iMMfLCGahmdwavv7eikgYGMG+vRNt0kM2Zp7FcComBni3wEvpp8ZqvrD8
        mHff1isWpBHSqzAaAzgCPzTuJfewN9P8cZRznS8eIQYuSZVjBGTYNG+9XaeW2n0KcMYGIJ
        dMA5YJE2jjrzCtJdumWq/R8qoq3xA8g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-670-TBbdULL5Ny6_2yp-ujh3FA-1; Mon, 26 Sep 2022 09:17:18 -0400
X-MC-Unique: TBbdULL5Ny6_2yp-ujh3FA-1
Received: by mail-wr1-f72.google.com with SMTP id q17-20020adfab11000000b0022a44f0c5d9so1161424wrc.2
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 06:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Nwm3H1a+y6Q/ANNgSpk2UwQQMq3N5bRTe9xIUQIog9Y=;
        b=J6LMs7AqrNM3ahiAle5GW9r24f8UDeqTDi6oxlqVEmduWBK4SctusLrSm4cTJu5vMX
         d6+kOPAWt5m2UCFkqsSvVcFsMtl4NivkMC0ibur/IzwqQlZEdPW74ZHRUZb67Z4IATcq
         ayyUhjnuEBFlYErZkXNjNIarFTEoJ08ENFz6w0xGAWB2j2anwUyusoD4xlkQCDYxWYM4
         uorJgdVs8c3aBjPFTK9psckg33kOw315En21FzpoYU5dvPC2eRC+zvQHN2DiZZhGH4yi
         ue+qrIwro+xFNMlgEasH5bLBsdlT5S/yxlPEf8DnfJy7gH+wHlEExvR2fs3nlaM6J1Z+
         jeAA==
X-Gm-Message-State: ACrzQf3RBWZrdZERvFLY/K2UebIaE6ebaYog/az4aL+l5Fkgi2Ra3MTn
        vZiWorpAxepnyhJuar57SCuN2Wi5+dw376ZjkYEXXiGyXgWED/dhoTevxWKSdIF52krqDfcRahc
        MLt3fp77yTvWj
X-Received: by 2002:a05:600c:524b:b0:3b4:8c0c:f3b6 with SMTP id fc11-20020a05600c524b00b003b48c0cf3b6mr22702564wmb.50.1664198237627;
        Mon, 26 Sep 2022 06:17:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6JPkDV3BwAL1numipwCic6J57G+v6rsRrYWROByh5F54wlFjI9rrpuHy0oiftYbpo28VhQ4g==
X-Received: by 2002:a05:600c:524b:b0:3b4:8c0c:f3b6 with SMTP id fc11-20020a05600c524b00b003b48c0cf3b6mr22702546wmb.50.1664198237404;
        Mon, 26 Sep 2022 06:17:17 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-251.web.vodafone.de. [109.43.177.251])
        by smtp.gmail.com with ESMTPSA id bv4-20020a0560001f0400b00228d6bc8450sm15811081wrb.108.2022.09.26.06.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:17:16 -0700 (PDT)
Message-ID: <02e8a1a1-ab58-4122-af80-472e50ecec0c@redhat.com>
Date:   Mon, 26 Sep 2022 15:17:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v8 1/8] linux-headers: update to 6.0-rc3
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
        richard.henderson@linaro.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-2-mjrosato@linux.ibm.com>
 <597a2761-f718-4a2c-c012-a0d25bf3c7fb@redhat.com>
 <CAFEAcA-8zWssi4TVF5TvHet9gxNkRvNreW6-hmTR0DgOu53Msw@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <CAFEAcA-8zWssi4TVF5TvHet9gxNkRvNreW6-hmTR0DgOu53Msw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/2022 14.56, Peter Maydell wrote:
> On Mon, 26 Sept 2022 at 13:53, Thomas Huth <thuth@redhat.com> wrote:
>>
>> On 02/09/2022 19.27, Matthew Rosato wrote:
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>> ...
>>> diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
>>> index bf6e96011d..46de10a809 100644
>>> --- a/linux-headers/asm-x86/kvm.h
>>> +++ b/linux-headers/asm-x86/kvm.h
>>> @@ -198,13 +198,13 @@ struct kvm_msrs {
>>>        __u32 nmsrs; /* number of msrs in entries */
>>>        __u32 pad;
>>>
>>> -     struct kvm_msr_entry entries[0];
>>> +     struct kvm_msr_entry entries[];
>>>    };
>>
>> Yuck, this fails to compile with Clang:
>>
>>    https://gitlab.com/thuth/qemu/-/jobs/3084427423#L2206
>>
>>    ../target/i386/kvm/kvm.c:470:25: error: field 'info' with variable sized
>> type 'struct kvm_msrs' not at the end of a struct or class is a GNU
>> extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
>>           struct kvm_msrs info;
>>                           ^
>>
>> Anybody any ideas how to fix this best? Simply disable the compiler warning
>> in QEMU?
> 
> There's already a patchset on list that does that:
> https://patchew.org/QEMU/20220915091035.3897-1-chenyi.qiang@intel.com/

Perfect, that's exactly what I need, thanks! I'll add those patches to my queue.

  Thomas

