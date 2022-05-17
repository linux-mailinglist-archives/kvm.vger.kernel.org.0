Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518D552A7A9
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350810AbiEQQKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346044AbiEQQKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:10:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C7C44B1ED
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652803800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dBaB3W2FuHWqmpt97cJIpSBxO7PYRb9m6Mm3MSir9dU=;
        b=g8xtxxK2MKk0bGsjCIhvFsGPkvYipK5fWFzOb4f6zusVvmC4UKxwEjM5Se4O/P+eW4WxRQ
        806c7vKsB2xejz6p9N4Hzgtv9VYOa6ej3C0CdEFy8vBgFUS8l9ISMRf/ccAorSmKNBokR/
        OmMUGgZe+evXBU/E+5lGIXANeR18fH4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-BPcSW-reOa6LVs9MlINycg-1; Tue, 17 May 2022 12:09:58 -0400
X-MC-Unique: BPcSW-reOa6LVs9MlINycg-1
Received: by mail-ed1-f70.google.com with SMTP id w23-20020aa7da57000000b0042acd76347bso1009110eds.2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dBaB3W2FuHWqmpt97cJIpSBxO7PYRb9m6Mm3MSir9dU=;
        b=L8XItzbxTCGpadqA9/pBjERVz341raE9KUGEjSdGwcp75AXPXS5CgA7eT3Z7FnWY8o
         BaL2RqxNGnQlnR6q13psYLiUFD95xz3LjMXgSsMz5JRc/99M2UWGyoVPvof1GPFYBZEo
         sE/hfc8nNnFlWCysakQbA/dIBLF1MVypVgt8Uc8nggOOg3eJ7E/ZeuLXaWyDvTK1MkOH
         ziNfXgIyjKwdtDABHlFLSjIzrcVc77hFmqtrKO7dSjKD4e9JunoTvO74Qju+STcCGXNN
         VYMVkWG21znbnzoIB/vEPBZb68RepYNnht/BB9zNZr2V0tCt4yZqOVPbUqvkF7HI7heC
         ts2Q==
X-Gm-Message-State: AOAM531wc8bPkzT3xiW5Nq+6o27W6zR7LoCAW4GB7+c4tjJ+gAyloszT
        38Kk4a0nhkx2+kRsL5M0D75zMI3aohp4WcL508cnYXxCPSk/kqCNmEz4dLM41oNIf8EvjfyInrz
        UCZirp9X9z+n0
X-Received: by 2002:a05:6402:26d3:b0:427:c57f:5333 with SMTP id x19-20020a05640226d300b00427c57f5333mr20094919edd.61.1652803797620;
        Tue, 17 May 2022 09:09:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydRjANi6Lqx7MMjNhrc932vVyT+VzWjGzlHQ03dSs5dhLKzuSFi4kWT7SDZem17pSy3WNxdA==
X-Received: by 2002:a05:6402:26d3:b0:427:c57f:5333 with SMTP id x19-20020a05640226d300b00427c57f5333mr20094903edd.61.1652803797447;
        Tue, 17 May 2022 09:09:57 -0700 (PDT)
Received: from [192.168.8.104] (tmo-082-126.customers.d1-online.com. [80.187.82.126])
        by smtp.gmail.com with ESMTPSA id hy3-20020a1709068a6300b006f3ef214e16sm1234782ejc.124.2022.05.17.09.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 09:09:56 -0700 (PDT)
Message-ID: <15aee36c-de22-5f2a-d32b-b74cddebfc1c@redhat.com>
Date:   Tue, 17 May 2022 18:09:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH] s390x: Ignore gcc 12 warnings for low
 addresses
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
References: <20220516144332.3785876-1-scgl@linux.ibm.com>
 <20220517140206.6a58760f@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220517140206.6a58760f@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/2022 14.02, Claudio Imbrenda wrote:
> On Mon, 16 May 2022 16:43:32 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> gcc 12 warns if a memory operand to inline asm points to memory in the
>> first 4k bytes. However, in our case, these operands are fine, either
>> because we actually want to use that memory, or expect and handle the
>> resulting exception.
>> Therefore, silence the warning.
> 
> I really dislike this

I agree the pragmas are ugly. But maybe we should mimic what the kernel
is doing here?

$ git show 8b202ee218395
commit 8b202ee218395319aec1ef44f72043e1fbaccdd6
Author: Sven Schnelle <svens@linux.ibm.com>
Date:   Mon Apr 25 14:17:42 2022 +0200

     s390: disable -Warray-bounds
     
     gcc-12 shows a lot of array bound warnings on s390. This is caused
     by the S390_lowcore macro which uses a hardcoded address of 0.
     
     Wrapping that with absolute_pointer() works, but gcc no longer knows
     that a 12 bit displacement is sufficient to access lowcore. So it
     emits instructions like 'lghi %r1,0; l %rx,xxx(%r1)' instead of a
     single load/store instruction. As s390 stores variables often
     read/written in lowcore, this is considered problematic. Therefore
     disable -Warray-bounds on s390 for gcc-12 for the time being, until
     there is a better solution.

... so we should maybe disable it in the Makefile, too, until the
kernel folks found a nicer solution?

  Thomas

