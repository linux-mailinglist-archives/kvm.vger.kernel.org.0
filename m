Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E6052CFA3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiESJqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbiESJqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C0621F60E
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652953570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hI6W8P9fA9nR+fpH4a9T05sDfeZ0jypbZAGOWKRF+9U=;
        b=Xrz74zX4uqU322rGMDM2hS4zVhCLXrjxA71mqNZ+G9uTbVJ+XDxU5hzudJbBGIzPj8xDdM
        gvzbG7NLSwBrm8t/5BxBOUr4ki+ed5yAneSYw4TqzM3ebxKx+Ntld3NBPgxrJjO9spN9hQ
        blr1D2cW1ZSzSsn4IG3twPfC3rq/Je4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-8TkNTbMlNMiAwYZo4hNH9A-1; Thu, 19 May 2022 05:46:09 -0400
X-MC-Unique: 8TkNTbMlNMiAwYZo4hNH9A-1
Received: by mail-wr1-f71.google.com with SMTP id l14-20020a05600012ce00b0020d06e7152cso1370948wrx.11
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hI6W8P9fA9nR+fpH4a9T05sDfeZ0jypbZAGOWKRF+9U=;
        b=eSTszHqfjjXrI3aRYrH3OwQ9V6ad14D6EiwxMr/9cFbEiRKV8ucQ111x2CkN+3O2PV
         MjYN5cPxYQl3hAbX81Xd9qLiZi5OJrw7CWewXXy8CL3LWc3UuvDHqti3zJ7v08axyj02
         DFHWbn/YN1VOIVcUp9s87gulKA9lVfq+6ICksnUqlQX9Lp8OdNx+4lJbQ13ESLdp9CED
         YzWHwFsDWlzER72pjEMUC42UydF0ZFXJob1FRx3qcc1WvFj82PV6v8qqhjiTRU2H3Soy
         mZfsFhFAzqJV7iSE4p0woCEJGSEQAUekeDJ1GS6+BOzZ8LgLZtbcL1CSuJ88jszTbSHD
         4uSA==
X-Gm-Message-State: AOAM5315qgeVzChRZp+PDJbJ0A0QTxupgqCQqE2U79iG57YcANk2vprP
        ZCl5GAfAIiQFADL19+NYYEjlq9PWaTmoS5MY94sNsnZ6YXRHCbnoCnUn/pY6HK4aHQYi5rTy5Zy
        b+MJ1wmmAS84P
X-Received: by 2002:a05:600c:5022:b0:394:5caf:2b46 with SMTP id n34-20020a05600c502200b003945caf2b46mr3524565wmr.156.1652953568067;
        Thu, 19 May 2022 02:46:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYUOEqyPkfiXdwd3qRcUwYjVAJCYVd80xcXpeUyq2ofDkX+MI1awx166V7xgBxLa8yAS7dKg==
X-Received: by 2002:a05:600c:5022:b0:394:5caf:2b46 with SMTP id n34-20020a05600c502200b003945caf2b46mr3524548wmr.156.1652953567863;
        Thu, 19 May 2022 02:46:07 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-176-97.web.vodafone.de. [109.43.176.97])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b00397335c8ad4sm637941wmb.1.2022.05.19.02.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 02:46:07 -0700 (PDT)
Message-ID: <52befa6f-409c-8ace-7aa7-7aa7837d6584@redhat.com>
Date:   Thu, 19 May 2022 11:46:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH] s390x: Ignore gcc 12 warnings for low
 addresses
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
References: <20220516144332.3785876-1-scgl@linux.ibm.com>
 <20220517140206.6a58760f@p-imbrenda>
 <15aee36c-de22-5f2a-d32b-b74cddebfc1c@redhat.com>
 <79585ac9-61cc-52a6-6df4-ca1530dbbc9f@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <79585ac9-61cc-52a6-6df4-ca1530dbbc9f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/2022 13.07, Janis Schoetterl-Glausch wrote:
> On 5/17/22 18:09, Thomas Huth wrote:
>> On 17/05/2022 14.02, Claudio Imbrenda wrote:
>>> On Mon, 16 May 2022 16:43:32 +0200
>>> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
>>>
>>>> gcc 12 warns if a memory operand to inline asm points to memory in the
>>>> first 4k bytes. However, in our case, these operands are fine, either
>>>> because we actually want to use that memory, or expect and handle the
>>>> resulting exception.
>>>> Therefore, silence the warning.
>>>
>>> I really dislike this
>>
>> I agree the pragmas are ugly. But maybe we should mimic what the kernel
>> is doing here?
>>
>> $ git show 8b202ee218395
>> commit 8b202ee218395319aec1ef44f72043e1fbaccdd6
>> Author: Sven Schnelle <svens@linux.ibm.com>
>> Date:   Mon Apr 25 14:17:42 2022 +0200
>>
>>      s390: disable -Warray-bounds
>>          gcc-12 shows a lot of array bound warnings on s390. This is caused
>>      by the S390_lowcore macro which uses a hardcoded address of 0.
>>          Wrapping that with absolute_pointer() works, but gcc no longer knows
>>      that a 12 bit displacement is sufficient to access lowcore. So it
>>      emits instructions like 'lghi %r1,0; l %rx,xxx(%r1)' instead of a
>>      single load/store instruction. As s390 stores variables often
>>      read/written in lowcore, this is considered problematic. Therefore
>>      disable -Warray-bounds on s390 for gcc-12 for the time being, until
>>      there is a better solution.
>>
>> ... so we should maybe disable it in the Makefile, too, until the
>> kernel folks found a nicer solution?
>>
>>   Thomas
>>
> 
> Neat, wasn't aware of that commit.
> 
> I don't think we need to concern ourselves with performance in this case and can define
> 
> +#define HIDE_PTR(ptr)                          \
> +({                                             \
> +       uint64_t __ptr;                         \
> +       asm ("" : "=d" (__ptr) : "0" (ptr));    \
> +       (typeof(ptr))__ptr;                     \
> +})
> +
> 
> in some header (which?).
> 
> Another alternative would be to define some extern symbols for the addresses we want to use.
> It might be nice to have a symbol for the lowcore anyway, then we can get rid of
> 
> static struct lowcore *lc;
> struct lowcore *lc = (struct lowcore *)0x0;
> ...
> 
> in a bunch of tests.

I like that idea.

> And use that symbol to derive the addresses we want to use.
> emulator.c uses -1 to generate an addressing exception, we either need another symbol for
> that or use another invalid address. (Can't get to -1 from lowcore/0 because the max array
> size is signed int64 max)

Maybe use INT64_MAX or something similar? Would that work?

  Thomas

