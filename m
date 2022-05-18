Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE0B52BDC3
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbiEROeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238656AbiEROd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 10:33:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5415A1AEC4E
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 07:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652884436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S0qz9PSvGbMs60yKx28nBLXwqA08nBMklYt7Mvsb4Pk=;
        b=JlJOFk8Utvno2ggT67gfHhqEvb6f0WOyEhs4ylgtyaii8xWhbZ+jixQxcFdUsMKubP3X9G
        1uvBbsZtcTA+7Y4ZxNjTgz00mO7c4aFRhlPPX2RnheHNryeEyq3lLHhO1XdRpHV3R6qQVJ
        LQJ74Ngxy27lvFZfIOpcb9OSxQjzrLA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-wbzepTBYMAaGcwa582-DTA-1; Wed, 18 May 2022 10:33:55 -0400
X-MC-Unique: wbzepTBYMAaGcwa582-DTA-1
Received: by mail-ed1-f72.google.com with SMTP id r8-20020a056402018800b00428b43999feso1762938edv.5
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 07:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=S0qz9PSvGbMs60yKx28nBLXwqA08nBMklYt7Mvsb4Pk=;
        b=OZGqg0SjQxw3jgvystve2WEzEHMUCwzVe3om3uZe8Pm/PmkXXn2xl1L9CFSE0tHQLp
         M5AnBnBddT6XEJ+GrxMcFeT6nUF0nktgfAlM+w3BYo7MBESY7MHFj8xs/v5LyRuUAlQ0
         e0gGsz9NvxeZosJsBXo/Q6HNUdTexe8GbbOIpBFiwEMYSB7/2O9r6hJrz2Z0QYsTul/H
         YEC/Rr/zCvwr30eveSdwmpZOQCMprtu8jCix4bRfVHKFYNIMsIyVAdyCvHnVNvi3HuC6
         SlUChS44wlSQk4PW6546fcOindgqqPJmio1oWJhOBeFcFFCJUbsUWBE3bCcACwXb9vYx
         bpIA==
X-Gm-Message-State: AOAM533FuHlt4gx+Q12m65+6D8EfwUV4dlA4y4YTUPh+bfj6KGCwsmoW
        N/rPJMbHBr9XntAPwz6h2ElQvML96Ym29u9jCX243/OUxowhuZdxg3Z41fqKX82NLn4un93UMkJ
        GTmhPu4YeqM4K
X-Received: by 2002:a05:6402:348c:b0:42a:e4e5:c63a with SMTP id v12-20020a056402348c00b0042ae4e5c63amr4607334edc.419.1652884433862;
        Wed, 18 May 2022 07:33:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5Uure55BHoOkTp7UVKFreQZ5rHKj7fvnOcH/AKP9Y2Tq1lVxIdQXxgxNVGpBLQ6V8bwpceQ==
X-Received: by 2002:a05:6402:348c:b0:42a:e4e5:c63a with SMTP id v12-20020a056402348c00b0042ae4e5c63amr4607302edc.419.1652884433583;
        Wed, 18 May 2022 07:33:53 -0700 (PDT)
Received: from [172.29.4.249] ([45.90.93.190])
        by smtp.gmail.com with ESMTPSA id k23-20020aa7d8d7000000b0042aa153e73esm1440476eds.12.2022.05.18.07.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 07:33:53 -0700 (PDT)
Message-ID: <cfe448f7-0b4e-680d-46a7-33ad25a4c09b@redhat.com>
Date:   Wed, 18 May 2022 16:33:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-4-pmorel@linux.ibm.com>
 <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
 <20220512115250.2e20bfdf@p-imbrenda>
 <70a7d93c-c1b1-fa72-0eb4-02e3e2235f94@redhat.com>
 <bae4e416-b0e9-31c6-c9d0-df6b5a5fd46f@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <bae4e416-b0e9-31c6-c9d0-df6b5a5fd46f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.05.22 16:21, Pierre Morel wrote:
> 
> 
> On 5/12/22 12:01, David Hildenbrand wrote:
>>>>
>>>> I think we prefer something like u16 when copying to user space.
>>>
>>> but then userspace also has to expect a u16, right?
>>
>> Yep.
>>
> 
> Yes but in fact, inspired by previous discussion I had on the VFIO 
> interface, that is the reason why I did prefer an int.
> It is much simpler than a u16 and the definition of a bit.
> 
> Despite a bit in a u16 is what the s3990 achitecture proposes I thought 
> we could make it easier on the KVM/QEMU interface.
> 
> But if the discussion stops here, I will do as you both propose change 
> to u16 in KVM and userland and add the documentation for the interface.

In general, we pass via the ABI fixed-sized values -- u8, u16, u32, u64
... instead of int. Simply because sizeof(int) is in theory variable
(e.g., 32bit vs 64bit).

Take a look at arch/s390/include/uapi/asm/kvm.h and you won't find any
usage of int or bool.

Having that said, I'll let the maintainers decide. Using e.g., u8 is
just the natural thing to do on a Linux ABI, but we don't really support
32 bit ... maybe we'll support 128bit at one point? ;)

-- 
Thanks,

David / dhildenb

