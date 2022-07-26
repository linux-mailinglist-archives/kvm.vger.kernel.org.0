Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF5E580F46
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 10:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238651AbiGZIk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 04:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238667AbiGZIkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 04:40:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A16A031378
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658824800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jnLzNF+6OcoMEvrKmkFd1HMwXl60lRxz1H1qHwN/3uU=;
        b=iazgLlq54orzDe5whhuCzLrAPYVEEXdsXSFglnxHLxPKNaXDwH2pEVhauqhRsawYKrTzBh
        3xyofnkrFPWqx2JaYE8OAp4/jV9/EuUIoL0kjnIzQKv8zevWkdRHGkO9QzxKW0kqAsMtmj
        sfqsYRPQ5sWFwX35lZGVZOqiBA5w9L8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-nmXRwxhPMhyDs25CO82w2A-1; Tue, 26 Jul 2022 04:39:58 -0400
X-MC-Unique: nmXRwxhPMhyDs25CO82w2A-1
Received: by mail-wm1-f70.google.com with SMTP id a18-20020a05600c225200b003a30355c0feso5100794wmm.6
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:39:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jnLzNF+6OcoMEvrKmkFd1HMwXl60lRxz1H1qHwN/3uU=;
        b=AaGBcVQyFXLowgsuD4AvCdc5ZKfOMxu1uKPMNyQvRUZ2ZVQ7JUFW9txyGnEc1pbo5O
         yQXHPT3jXvxHX3yJKVTMiYDwSzrmnxGHACW1fNM/FGItyDLoUDYUqq0LQdJA/ndVPpIT
         QybwHDHtnUqVCNyXgEIxRQ96p+On9cxB4BOuwJDQCfG2yoNWmhhNUuRPLBHPaXvdE0D8
         tgVnRk9yDJUk9o8Yz7S1yWeYdxSm4TswaburaTjMiRfwuxBkjhPi4E08EwKAXPKhdBtw
         DkoKAGNGZSmfli7tfLgs+tai0JStoWKGucRANI9omXJuH8oP/UdwQWYi0nOUdUj6XFs+
         K8FQ==
X-Gm-Message-State: AJIora/hkTeE21KAcrAdvs1f0fwK3kTV9gMnZ5dk1ZQ/MmDZEbTQW9fw
        ulDqn4GnpSiI8Grs9J6n8lVjPj5fnPHEPNCY9jIWLNHhTi5W86GuISyVYiIHi27+2xbSHsK9zyZ
        YesiITPFAYy8Z
X-Received: by 2002:a05:600c:19d2:b0:3a3:3aca:a83d with SMTP id u18-20020a05600c19d200b003a33acaa83dmr11867200wmq.88.1658824797737;
        Tue, 26 Jul 2022 01:39:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v+q9Tsx9iGT/2UKhx+ODI8y2RawmqoKiw+69IkzdKckFxGFD+acWJtvD8CB2aSj5eocrA2wA==
X-Received: by 2002:a05:600c:19d2:b0:3a3:3aca:a83d with SMTP id u18-20020a05600c19d200b003a33acaa83dmr11867187wmq.88.1658824797455;
        Tue, 26 Jul 2022 01:39:57 -0700 (PDT)
Received: from [10.33.198.128] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id n186-20020a1ca4c3000000b003a32438c518sm20607069wme.6.2022.07.26.01.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 01:39:57 -0700 (PDT)
Message-ID: <7c6399f9-2380-4033-c6e6-75928d47e1a4@redhat.com>
Date:   Tue, 26 Jul 2022 10:39:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH kvm-unit-tests] s390x: fix build with clang
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com
References: <20220726083725.32454-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220726083725.32454-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/07/2022 10.37, Paolo Bonzini wrote:
> Reported by Travis CI:
> 
> /home/travis/build/kvm-unit-tests/kvm-unit-tests/lib/s390x/fault.c:43:56: error: static_assert with no message is a C++17 extension [-Werror,-Wc++17-extensions]
>                  _Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
>                                                                       ^
>                                                                       , ""
> 1 error generated.
> make: *** [<builtin>: lib/s390x/fault.o] Error 1
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   lib/s390x/fault.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
> index 1cd6e26..a882d5d 100644
> --- a/lib/s390x/fault.c
> +++ b/lib/s390x/fault.c
> @@ -40,7 +40,7 @@ static void print_decode_pgm_prot(union teid teid)
>   			"LAP",
>   			"IEP",
>   		};
> -		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
> +		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES, "ESOP2 prot codes");
>   		int prot_code = teid_esop2_prot_code(teid);
>   
>   		printf("Type: %s\n", prot_str[prot_code]);

Reviewed-by: Thomas Huth <thuth@redhat.com>

