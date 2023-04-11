Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775086DD4B8
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 10:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjDKICM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 04:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDKICJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 04:02:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55D82D60
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 01:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681200081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAs2OJP8pKZ8Gc7qYRAVj20lAWot/W5/JtvlgMjcymc=;
        b=ax3984RU6V6C6jUybRKXDW0uFSq7Y7COsB2NLUDJXV4yNKRWOMf1W7chRP1JeWombvHnBD
        Jr7wpgZBKylCqGf1FINiDssSIJjupSrB+D2rVf0dn0hF6y5E4RuzEzI4nz5Y4m0YZuQ9oQ
        mCUi9BcJHNIZYlVfZnBolzmA4cObNI0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-JZIqWZ3EMTumM9ewcA0K-w-1; Tue, 11 Apr 2023 04:01:20 -0400
X-MC-Unique: JZIqWZ3EMTumM9ewcA0K-w-1
Received: by mail-wm1-f70.google.com with SMTP id o4-20020a05600c510400b003eea8d25f06so1418606wms.1
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 01:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681200079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AAs2OJP8pKZ8Gc7qYRAVj20lAWot/W5/JtvlgMjcymc=;
        b=2eFARufHzYKGgX904IL+zUewaJvFXRzqueYT8D2cF+scXcJDpXvX558XJ0Ir7v6uCU
         hH0CXb+ZkylM+zt1WMz6VevCaHLcvSSWF/H91SGdHtE3euvA+7LbV7Pw5LZe1AZ0fFkA
         C3w1I0omW8KmA/Ito6TGlYAQr+zvJpCK0buQY0BEs4mqG/wSpaEhZq7xfkudeVUT+6nF
         2FExbNRdG1j2ijFFI5WjFS/4RDf7RSrDslFwKxJfYCnNrgkC8vc3+pWqOrfEoftS/fx/
         P7jfWaKmn8HrKKZL7qjVHwhG0tlFIZT3p9+/Gkkt+iyv9Kz0+JkmS0CF2BJFNw2CD4Rh
         bbbQ==
X-Gm-Message-State: AAQBX9d0idIvTICxGp6E0kvNeAdSBRuxYKk7abavml5qRIrC+tpizaEM
        2r5iDHEshyso7H9Lk/Fj4pHEPTgt46JvgAuVb/LnHCSYNc/gHswYluGxtSgatRnD+VoffpTv99V
        /5B9F0Q0f2wN3
X-Received: by 2002:a7b:c018:0:b0:3ed:6c71:9dc8 with SMTP id c24-20020a7bc018000000b003ed6c719dc8mr10030669wmb.22.1681200079602;
        Tue, 11 Apr 2023 01:01:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yr97rLlD8PFTK8VWVrLEgughHb9CikcjDOH75PCtAjE2MRvEZvWpzNfYrgSzNCVsNcn5GU5w==
X-Received: by 2002:a7b:c018:0:b0:3ed:6c71:9dc8 with SMTP id c24-20020a7bc018000000b003ed6c719dc8mr10030637wmb.22.1681200079083;
        Tue, 11 Apr 2023 01:01:19 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-153.web.vodafone.de. [109.43.179.153])
        by smtp.gmail.com with ESMTPSA id f3-20020a7bc8c3000000b003ee10fb56ebsm16269220wml.9.2023.04.11.01.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 01:01:18 -0700 (PDT)
Message-ID: <916aac4f-97b8-70c2-de39-87438eb4aea4@redhat.com>
Date:   Tue, 11 Apr 2023 10:01:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH] x86: Link with "-z noexecstack" to
 suppress irrelevant linker warnings
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20230406220839.835163-1-seanjc@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230406220839.835163-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2023 00.08, Sean Christopherson wrote:
> Explicitly tell the linker KUT doesn't need an executable stack to
> suppress gcc-12 warnings about the default behavior of having an
> executable stack being deprecated.  The entire thing is irrelevant for KUT
> (and other freestanding environments) as KUT creates its own stacks, i.e.
> there's no loader/libc that consumes the magic ".note.GNU-stack" section.
> 
>    ld -nostdlib -m elf_x86_64 -T /home/seanjc/go/src/kernel.org/kvm-unit-tests/x86/flat.lds
>       -o x86/vmx.elf x86/vmx.o x86/cstart64.o x86/access.o x86/vmx_tests.o lib/libcflat.a
>    ld: warning: setjmp64.o: missing .note.GNU-stack section implies executable stack
>    ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> 
> Link: https://lkml.kernel.org/r/ZC7%2Bc42p2IRWtHfT%40google.com
> Cc: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   x86/Makefile.common | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 365e199f..c57d418a 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -62,7 +62,7 @@ else
>   # We want to keep intermediate file: %.elf and %.o
>   .PRECIOUS: %.elf %.o
>   
> -%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
> +%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS) -z noexecstack
>   %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
>   	$(LD) $(LDFLAGS) -T $(SRCDIR)/x86/flat.lds -o $@ \
>   		$(filter %.o, $^) $(FLATLIBS)

Reviewed-by: Thomas Huth <thuth@redhat.com>

