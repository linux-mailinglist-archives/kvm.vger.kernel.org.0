Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDF1738845
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjFUPBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjFUPA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:00:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86F61FE0
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687359221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GeZs+jwlXBX1tLofoVAWxWqbasSnP0VwG7VyNj9+EHg=;
        b=AcS1LFSJGQsXw7cHOZCbSvAf6sd8ideD9xfLpQpHDSZdr/oVCtPlztNY60iC6/Ek5e3Ust
        8G9cblalhf0V1xEhH8ai0gBaNAo5LwDfEmr36BsS8Z6rir/78U166gp6LKmjor2DxaXEOy
        wHQ3nblGsMRqfElIIcxr1SIl5g3lAmU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-4vWXKcVkOWuzTLb1epZj9A-1; Wed, 21 Jun 2023 10:53:37 -0400
X-MC-Unique: 4vWXKcVkOWuzTLb1epZj9A-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f8f1b55a6fso24284075e9.2
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687359215; x=1689951215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GeZs+jwlXBX1tLofoVAWxWqbasSnP0VwG7VyNj9+EHg=;
        b=BP4j8SQR+llq0VMeKmWh+AYWWrDoBLHaQGVKzDTKcGlw6vXo+YTpX39hs5BR/fiNsM
         Ihv265ntWChEIqs/wJ95vaJrWB/TNHh5ebNOSbJJAaveRwy+SvGFfMnTHts7no+T+lhy
         dYifgiv1X7ZQ0BURAgnztDCaSLBrCke9Su7MHHiCJ6H7F39EjKPoPXEbl4kACAqNxZBz
         j2UIGfup9h0VBZZ68QvV8jyT0BcXltTsK1qcR5NZfN+vtRtlS5oHORmP4xfHkogDn/q6
         YcYS/QldwWGMyLmSpn5a1R50hCNhoIbeBl0rsfO/PuWzKjSl7lP2NdpPjLgx5aINnbZS
         +osQ==
X-Gm-Message-State: AC+VfDy6OFtKbcVDW6xn/4s9h1b0iC0tr3y/x4O8DX7zxeF/jaPMQ/FB
        vEJFp1vdIQquTyo50szwDVNwOD1CboTk0mJJk+LzSKGFLnbYnC+gDwcMppu7kQ78+M4A7ZF/4km
        RLIvkBUas1iXgEiXg7ybB
X-Received: by 2002:a7b:c449:0:b0:3f4:a09f:1877 with SMTP id l9-20020a7bc449000000b003f4a09f1877mr10594900wmi.23.1687359215250;
        Wed, 21 Jun 2023 07:53:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7kRklZYhudrDIRDRvq8YcUS+UQyVgGseZ4iznRyerpUi+anoSLkz9E7sW+j+pZOTiyYd9AAA==
X-Received: by 2002:a7b:c449:0:b0:3f4:a09f:1877 with SMTP id l9-20020a7bc449000000b003f4a09f1877mr10594885wmi.23.1687359214959;
        Wed, 21 Jun 2023 07:53:34 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-207.web.vodafone.de. [109.43.177.207])
        by smtp.gmail.com with ESMTPSA id t20-20020a1c7714000000b003f900678815sm5174357wmi.39.2023.06.21.07.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jun 2023 07:53:34 -0700 (PDT)
Message-ID: <f9164de8-e358-089c-00b3-35ba669aedcb@redhat.com>
Date:   Wed, 21 Jun 2023 16:53:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests v4 01/12] powerpc: Report instruction address and
 MSR in unhandled exception error
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
 <20230608075826.86217-2-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230608075826.86217-2-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2023 09.58, Nicholas Piggin wrote:
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Since v3:
> - New patch
> 
>   lib/powerpc/processor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> index ec85b9d8..05b4b04f 100644
> --- a/lib/powerpc/processor.c
> +++ b/lib/powerpc/processor.c
> @@ -38,7 +38,7 @@ void do_handle_exception(struct pt_regs *regs)
>   		return;
>   	}
>   
> -	printf("unhandled cpu exception %#lx\n", regs->trap);
> +	printf("unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n", regs->trap, regs->nip, regs->msr);

<bikeshedding> Why NIA and not NIP ? </bikeshedding>

  Thomas

