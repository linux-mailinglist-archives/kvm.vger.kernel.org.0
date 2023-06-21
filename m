Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A70738893
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjFUPOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbjFUPOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:14:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCFA46BA
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 08:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687360108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VcvlcGOsdz8xmfczPODHKTAf1QOSvNikn1NEKXY6yqQ=;
        b=LYqNOcAzG9zPKHSZa/W2dPbEPA68DhzZVif+ODFSGubBK0SccyrMIa/egh4Ur/Vk159MCv
        +RJbny5MPogvuX4MN7aanBAdPtHEFexcZhjYom6/kCtbA4G21947ST+D+DRMX3p4qLvVp/
        QLGkZpUwFjbxWl9Kw6otlyo8e8b9YMs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-ipqkAjQCMRmgmphbn4rt8A-1; Wed, 21 Jun 2023 10:55:01 -0400
X-MC-Unique: ipqkAjQCMRmgmphbn4rt8A-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f858280d89so4289800e87.2
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687359299; x=1689951299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VcvlcGOsdz8xmfczPODHKTAf1QOSvNikn1NEKXY6yqQ=;
        b=dhOPA1Ni6AvN8jlWS0YetKMqAE96NYQ/OLrZxtYvGtZekjhd5zluBanApOJjijD1Qd
         +AQA0v8dECKS56YJgw9M2J0/a1yehkzA6Gax2hoI5dEiAcpiKLbIwbS4/TmiDpdbv/Jz
         juNW+e5YSzxom8QgouOs5lX9a4iokO7C5ei3BUhQ8nuekhZgDBw+Po3XFrgoJnqwntbO
         Ll4RD/Drl6C7URU2oZESRudjxxD8sSCAXTwUT9cy247dLGkd99NjqAOd3Q9NYM37Qnqi
         s0X2s3HNAgHVY+uEDwnEOLd60kjVTGouVHZPI/hrU5Qr5XoiGAqyBkh9hqTR6yOZKzx5
         j+BA==
X-Gm-Message-State: AC+VfDy8Oo0TCMv+/1x4pvxNX28NxzSOlFuVklrOXYZRNw2cQAWexbyZ
        DVRC4Fgdj10sVw9py7WzMQuy+41jmikaO/0VsZ4V+cNhD9yQ/X9bS1tSO6MDqMqlHw8P8saRAwe
        13UMjhGaGn2QauZY+X6Bw
X-Received: by 2002:a19:da12:0:b0:4f9:5622:4795 with SMTP id r18-20020a19da12000000b004f956224795mr2204136lfg.42.1687359299630;
        Wed, 21 Jun 2023 07:54:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5lKj8j3ZctUkIWEOuFj4T6DLcuWbUypmaju9CtFGHgHhgm9afUQ54tnfDfia7uz8bcTsc8ZA==
X-Received: by 2002:a19:da12:0:b0:4f9:5622:4795 with SMTP id r18-20020a19da12000000b004f956224795mr2204127lfg.42.1687359299272;
        Wed, 21 Jun 2023 07:54:59 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-207.web.vodafone.de. [109.43.177.207])
        by smtp.gmail.com with ESMTPSA id p20-20020a05600c205400b003f9a6f3f240sm9249173wmg.14.2023.06.21.07.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jun 2023 07:54:58 -0700 (PDT)
Message-ID: <daa0bae9-38ec-e3ab-5ed7-de214091d2e8@redhat.com>
Date:   Wed, 21 Jun 2023 16:54:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests v4 02/12] powerpc: Add some checking to exception
 handler install
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
 <20230608075826.86217-3-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230608075826.86217-3-npiggin@gmail.com>
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
> Check to ensure exception handlers are not being overwritten or
> invalid exception numbers are used.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Since v3:
> - Simplified code as suggested by Thomas.
> 
>   lib/powerpc/processor.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> index 05b4b04f..0550e4fc 100644
> --- a/lib/powerpc/processor.c
> +++ b/lib/powerpc/processor.c
> @@ -19,12 +19,16 @@ static struct {
>   void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
>   		      void * data)
>   {
> +	assert(!(trap & ~0xf00));
> +
>   	trap >>= 8;
>   
> -	if (trap < 16) {
> -		handlers[trap].func = func;
> -		handlers[trap].data = data;
> +	if (func && handlers[trap].func) {
> +		printf("exception handler installed twice %#x\n", trap);
> +		abort();
>   	}
> +	handlers[trap].func = func;
> +	handlers[trap].data = data;
>   }
>   
>   void do_handle_exception(struct pt_regs *regs)

Reviewed-by: Thomas Huth <thuth@redhat.com>

