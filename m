Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF6C63879A
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 11:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiKYKez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 05:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKYKex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 05:34:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B431ED8
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669372436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Oi4m/W/2SSPPi5o2EUwMBbTdGxsAxK/9z7KiPk6moI=;
        b=I3j5HdnFenLdv8XnNZBieubGSqUlS7Uw6OwBfZx/8Gt8CdRfKPmC46fVDiy8y3ZHbF0E5/
        35AUWEjm7gB8nDbQFaXBfLcyixn9cPufU8jNCLYWHxOe3XV7Ew/jYh204UoGLbEhEG/OOB
        9JXFXltJmpmjQvwaOa8Srz9nVt5FLDc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-eQwieEoJMAm7DBNLh20QLQ-1; Fri, 25 Nov 2022 05:33:54 -0500
X-MC-Unique: eQwieEoJMAm7DBNLh20QLQ-1
Received: by mail-wr1-f69.google.com with SMTP id j30-20020adfa55e000000b00241b49be1a3so760015wrb.4
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:33:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Oi4m/W/2SSPPi5o2EUwMBbTdGxsAxK/9z7KiPk6moI=;
        b=drEr1tzpEMeVvA2WnOUo4wVxhyJBA4PG4h3zEIGZXLtXMY6WstjxFTkY7PTGwrWFs0
         WYYsgub5o91ICJD5lmsrhHpwe5+3YUSw4xe505eCjVjxrvIA5VgdZPooHOKg829SQxFn
         IoM7F7TM6yAMfFdwuChk2am52TcN3g6c7jXkIc/RHbowkDKO06rdECJsUEAEJTf1mjkW
         cxdQ5DMZ9SKaJEkCak9qS6uKA68WSTRI9GXgw5HRJyOqInUY2WX9iLeZoNeDzT/EObmv
         CsUJvZ5tmzBRzPcbTIwRmG4In9QamlqW4Wvc71CTFrRsGcGbMCAhu6wm93Tg8W6VVcQQ
         aKzQ==
X-Gm-Message-State: ANoB5pk04zaNO1+DKNOth5cos4+LBAdMEtuMLUbPWzp86gBDLTX0/6X+
        9+YOW5ouGXDPIPeDbJh3L3+ApwUCCMjUi9svOdIUjWK9fFWByBJRUfmuN1NVW97ep+JbgIRQKmH
        0JggZmLtjyJBO
X-Received: by 2002:a05:6000:1084:b0:241:f866:6bc8 with SMTP id y4-20020a056000108400b00241f8666bc8mr5452075wrw.501.1669372432426;
        Fri, 25 Nov 2022 02:33:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6ETzV1fiQjfkcSIVWGqHR4UA3YXKERcs0TgEe41qDDpN3aaNLiFruFmCOGd8KqeOajkCk2gw==
X-Received: by 2002:a05:6000:1084:b0:241:f866:6bc8 with SMTP id y4-20020a056000108400b00241f8666bc8mr5452060wrw.501.1669372432229;
        Fri, 25 Nov 2022 02:33:52 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-41.web.vodafone.de. [109.43.176.41])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d6a8b000000b0022584c82c80sm3438659wru.19.2022.11.25.02.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 02:33:51 -0800 (PST)
Message-ID: <0b5c1b10-e511-3981-e501-3b18eb91c6aa@redhat.com>
Date:   Fri, 25 Nov 2022 11:33:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] lib: x86: Use portable format macros for uint32_t
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20221124123149.91339-1-likexu@tencent.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221124123149.91339-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/2022 13.31, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Compilation of the files fails on ARCH=i386 with i686-elf gcc on macos_i386
> because they use "%d" format specifier that does not match the actual size of
> uint32_t:
> 
> In function 'rdpmc':
> lib/libcflat.h:141:24: error: format '%d' expects argument of type 'int',
> but argument 6 has type 'uint32_t' {aka 'long unsigned int'} [-Werror=format=]
>    141 |                 printf("%s:%d: assert failed: %s: " fmt "\n",           \
>        |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Use PRId32 instead of "d" to take into account macos_i386 case.
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> Nit, tested on macOS 13.0.1 only instead of cirrus-ci-macos-i386.

Thanks, this fixed the cirrus-ci job, indeed, too:

https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3379034443

  Thomas


