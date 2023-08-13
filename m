Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA377A5E0
	for <lists+kvm@lfdr.de>; Sun, 13 Aug 2023 11:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjHMJuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 05:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjHMJuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 05:50:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB87E10CE
        for <kvm@vger.kernel.org>; Sun, 13 Aug 2023 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691920205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vBzH8DX3gC9E1Jmln+XcFwun/a5hLI5hdLYcEoW5X28=;
        b=OlJ98Ysbi6cXPsQh+zyKHKeszLy/lRK+NGIwzaYq1lNa3yo4qo6sBFJsXKH3Tuc9G2uKzY
        opFm9k1PjZCpU32HN+8WUyqptKHDM08u67Ab63XBN0DvaPvGUp5o5UVW6hapBDk2MqsFWR
        A8J7YwHYb+wHD9/TShSfrlOCZvpMmQ8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-NEjbKxilMQGPVGf8XUWRMA-1; Sun, 13 Aug 2023 05:50:04 -0400
X-MC-Unique: NEjbKxilMQGPVGf8XUWRMA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3178ddc3d94so2025384f8f.1
        for <kvm@vger.kernel.org>; Sun, 13 Aug 2023 02:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691920203; x=1692525003;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vBzH8DX3gC9E1Jmln+XcFwun/a5hLI5hdLYcEoW5X28=;
        b=M5/C04zJTYiypGdLe5bxuJ6nfhi4azETWBn3W3gFQrC9fLyt/C8z135PCjv83NnKy/
         KNUMNTAOzbeHSFGSxytFMp9l6DyjXoHnvDxe8qY0g3OBa26ugo7EvDdJc6HN4knmk4OO
         ChVlX2EEzwWfp3HC+gl7vXOqh8Qm0hhwQusx36JqXD2E1pw2kRURk0YB82HWIChsfED2
         ROyKuWVBvwd7dp2iUn+W6aM2oVHdDlJY5w1VUG/BOXmPiYyCyFNjqJE/0MS0GMamFkPn
         ey4NAFElnDHOwHqBqJijJB6h+IA7O1a1t1uooLyHmpDNQBwG/lCx+D5/gVVP/B/bnKuX
         b0TA==
X-Gm-Message-State: AOJu0Yw0lFlZLP1wV4jPjDWDdhTspr5XBApvtuhDw0mRQEMR9XzFwmPP
        8FM3cb/0M7iIv6fH1LGRY+glxxPctRbLOsVkWFffy0QqCucXEExT3IjMYb/t4qyAKNuvKaR+0cY
        E1i5/1Z4awbrBhtxiO/g5
X-Received: by 2002:adf:dec2:0:b0:317:5a99:4549 with SMTP id i2-20020adfdec2000000b003175a994549mr4575277wrn.0.1691920203198;
        Sun, 13 Aug 2023 02:50:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnfuzkqCoVq8jy6EOVpp+9RneCX6vcEypZHDYoMLweq1/d7QPLQzBD+n4h+KFAZCkbhPdgSQ==
X-Received: by 2002:adf:dec2:0:b0:317:5a99:4549 with SMTP id i2-20020adfdec2000000b003175a994549mr4575272wrn.0.1691920202897;
        Sun, 13 Aug 2023 02:50:02 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-246.web.vodafone.de. [109.43.177.246])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b003142ea7a661sm11038784wrr.21.2023.08.13.02.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Aug 2023 02:50:02 -0700 (PDT)
Message-ID: <981405ed-060f-de0b-8125-29099ba8791a@redhat.com>
Date:   Sun, 13 Aug 2023 11:50:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH v1] s390x: explicitly mark stack as not
 executable
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230809091717.1549-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230809091717.1549-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/2023 11.17, Nico Boehr wrote:
> With somewhat recent GCC versions, we get this warning on s390x:
> 
>    /usr/bin/ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies executable stack
>    /usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> 
> We don't really care whether stack is executable or not since we set it
> up ourselves and we're running DAT off mostly anyways.
> 
> Silence the warning by explicitly marking the stack as not executable.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 706be7920406..afa47ccbeb93 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -79,7 +79,7 @@ CFLAGS += -O2
>   CFLAGS += -march=zEC12
>   CFLAGS += -mbackchain
>   CFLAGS += -fno-delete-null-pointer-checks
> -LDFLAGS += -nostdlib -Wl,--build-id=none
> +LDFLAGS += -nostdlib -Wl,--build-id=none -z noexecstack

I already did a similar patch some weeks ago:

  https://lore.kernel.org/kvm/20230623125416.481755-1-thuth@redhat.com/

... we need it for x86, too, so I guess I should go ahead and commit it - 
and ask Sean to respin his conflicting series.

  Thomas


