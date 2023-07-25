Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803EC761D6D
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjGYPeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbjGYPd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40886BB
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690299193;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M/jYtmMtGkG0hmXFdCqZpADpJ+V9me7HzfGXEew3QqE=;
        b=ewxU6n97ooq5xcrTnRw6wLmIKyaEPI0gV6ZV8+MvSdky/u8jyE+lSPduShSXqgmp7eMTVb
        hpPXTN9zOQ4yvyWC0UgAhPZ8A6DLrMvwLZWKa7kPHNSQKj7dMwLSH+NsHPU1618TNc/ZKE
        v8tqiW3R3J5Q0MSkUwYfR6BIoTNtR+M=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-pae2vIdKPi-UMKqctEdxcw-1; Tue, 25 Jul 2023 11:33:10 -0400
X-MC-Unique: pae2vIdKPi-UMKqctEdxcw-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6bc56f23c65so578134a34.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690299190; x=1690903990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/jYtmMtGkG0hmXFdCqZpADpJ+V9me7HzfGXEew3QqE=;
        b=OVLyM/2MMqVNDTQT/iDgv9/L+aMmMnqpYg7WF+sTp/x0mis6+ovN+rwy2ltC8EFsN6
         8fpUR9cPscJehPul2nwnqI0/ZYi8fQnCKHwZGu5xcYbL8SJDm5JnbUL+qUQarFildvH5
         NttoDPST7txcSqhFLNN/X8jn/Hb3XdbVLpfdrtijxqWx9iVM7jXC5h1wn15vP/pPs5EY
         tJ4ZuI/P6TcLVVpt8zWsNjXwrataIWblcelrfDjG/5Iq3NBRDXYxPWt3oKQFp8zaCi3u
         S/FazvoViqrDbVo7YbFheQQsA/aoIgSbJ3Vhk3CZT8KFTsEzF3tBDROwSIEjWcKXaxfq
         OzRQ==
X-Gm-Message-State: ABy/qLaQZTQX/6DpxrSm53BZrrd/w2/BWzxewjQML5K9yci1dj4Uwcjp
        jch8cDk1usO77kn3VQIghnruxctB7MS2zU0pI4dG5pI42I9nkAXaT1gYBKqKuhHTeazgG9R5P7a
        Q0JDoQRHQANd8
X-Received: by 2002:a05:6830:19ea:b0:6b9:70c9:e1c8 with SMTP id p42-20020a05683019ea00b006b970c9e1c8mr9491939otp.5.1690299190306;
        Tue, 25 Jul 2023 08:33:10 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGwfD9i4saEq5guvbIWPCxEwI68/tV8TiZIrRY5wvsOxzfEZyHvgM2q/hdbebuHSMMnAyAXgQ==
X-Received: by 2002:a05:6830:19ea:b0:6b9:70c9:e1c8 with SMTP id p42-20020a05683019ea00b006b970c9e1c8mr9491923otp.5.1690299190029;
        Tue, 25 Jul 2023 08:33:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id d28-20020a05620a137c00b0076c44db9b08sm1407701qkl.113.2023.07.25.08.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 08:33:09 -0700 (PDT)
Message-ID: <6a0fc302-e78f-1a17-5b3c-421771b90b73@redhat.com>
Date:   Tue, 25 Jul 2023 17:33:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm64: Define name for the original
 RES1 bit but now functinal bit
Content-Language: en-US
To:     Shaoqin Huang <shahuang@redhat.com>, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20230724073949.1297331-1-shahuang@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230724073949.1297331-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shaoqin,

On 7/24/23 09:39, Shaoqin Huang wrote:
> According the talk[1], because the architecture get updated, what used to be a
> RES1 bit becomes a functinal bit. So we can define the name for these bits, this
> also increase the readability.
>
> [1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman
>
> v1:
> https://lore.kernel.org/all/20230719031926.752931-1-shahuang@redhat.com/
> Thanks, Eric for the suggestions:
> - Rephrase the commit title in patch 1.
> - Use the _BITULL().
> - Delete the SCTLR_EL1_RES1 and unwind its definition into
> INIT_SCTLR_EL1_MMU_OFF.
>
> Shaoqin Huang (2):
>   arm64: Use _BITULL() to define SCTLR_EL1 bit fields
>   arm64: Define name for these bits used in SCTLR_EL1

for the series
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

>
>  lib/arm64/asm/sysreg.h | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
>

