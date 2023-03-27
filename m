Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1376CA7DE
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjC0Oj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjC0Ojz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:39:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87538358B
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679927948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoDLXhYZX6z7BtIjLUpiIi7lTU4JmFeBrYERY2LWfk0=;
        b=NwYdjZN5xaKKJ3/+9FJMMRk2/m6cu4cyCipO7i+2+bUE1i4K5VrTl7/GDdsbvlaZ4rRgdb
        t658V60eajZ+xkPFgXUMpy8T1NmKLKSsuVWnBk0THaIWuZtJyK8bUQxekWIn8sT5h6cEXx
        kWuExuWZD70Q8ksHvKTPGNctvQ6TvgM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-D8joogq7NTG1k_XlOAn-fQ-1; Mon, 27 Mar 2023 10:39:05 -0400
X-MC-Unique: D8joogq7NTG1k_XlOAn-fQ-1
Received: by mail-qk1-f200.google.com with SMTP id d72-20020ae9ef4b000000b007467a30076fso4075053qkg.18
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679927945;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XoDLXhYZX6z7BtIjLUpiIi7lTU4JmFeBrYERY2LWfk0=;
        b=moi8rIdWun0FqVeazt1FIVwd2ZxNQUOMwP7BSyupMm95UupwoYFkclCvg8HbJ/QPBD
         Y8rgLIuV8yc+Pqm/Z2hNohdHF2fQwqK10UjHLWnsEsxXzVnRlmZK1CFfj+MlDnoz7Azz
         i3GcpIjqmkKk5OKDoLk8dVEsfYysu1KQz2PmwzYD0k9RyFPi5yTQdSAMxaj6RE9rhLkI
         fMHJdKGh3zj7z8kp1V3uyWOaVXjGnz9t/mCg5vRM6xutseHoUVgyYgP6xHXqDg6T/Dhf
         8rJBbLnwUQu6chXGMxfC1Tivfq+2Rby+RL8609KX7YDcXk503Qsyslt+8vMqg7GlcuJj
         hOWA==
X-Gm-Message-State: AO0yUKWU5LAaWOmR98bnAc2pUHgz6WtkDymOrYiGqBF1Bk3V6xza0F3I
        EWa/MQbTs+qq44oYlSq7eo/NL7D3kZgIZPUTOULSp20RekmerRp5kO7sH9D0frVkbmZgA1EfWxd
        rV3AnnXbzC13V
X-Received: by 2002:a05:622a:1648:b0:3b8:6ae9:b10d with SMTP id y8-20020a05622a164800b003b86ae9b10dmr20414132qtj.2.1679927944793;
        Mon, 27 Mar 2023 07:39:04 -0700 (PDT)
X-Google-Smtp-Source: AK7set+AIVfKyZ43ZdQzZE7WjGbMC2MuGN2mWA2dKyIEH1RqiiXs9Z6es282UQxXRqnv8qSeMs3zsw==
X-Received: by 2002:a05:622a:1648:b0:3b8:6ae9:b10d with SMTP id y8-20020a05622a164800b003b86ae9b10dmr20414102qtj.2.1679927944544;
        Mon, 27 Mar 2023 07:39:04 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-5.web.vodafone.de. [109.43.177.5])
        by smtp.gmail.com with ESMTPSA id y3-20020a37f603000000b0074382b756c2sm16747347qkj.14.2023.03.27.07.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 07:39:03 -0700 (PDT)
Message-ID: <229dd5e2-b757-d28b-b9db-0d9efce4c5d1@redhat.com>
Date:   Mon, 27 Mar 2023 16:39:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v3 03/13] powerpc: Add some checking to exception
 handler install
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-4-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230327124520.2707537-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/2023 14.45, Nicholas Piggin wrote:
> Check to ensure exception handlers are not being overwritten or
> invalid exception numbers are used.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Since v2:
> - New patch
> 
>   lib/powerpc/processor.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> index ec85b9d..70391aa 100644
> --- a/lib/powerpc/processor.c
> +++ b/lib/powerpc/processor.c
> @@ -19,11 +19,23 @@ static struct {
>   void handle_exception(int trap, void (*func)(struct pt_regs *, void *),
>   		      void * data)
>   {
> +	if (trap & 0xff) {

You could check for the other "invalid exception handler" condition here 
already, i.e. if (trap & ~0xf00) ...

I'd maybe simply do an "assert(!(trap & ~0xf00))" here.

> +		printf("invalid exception handler %#x\n", trap);
> +		abort();
> +	}
> +
>   	trap >>= 8;
>   
>   	if (trap < 16) {

... then you could get rid of the if-statement here and remove one level of 
indentation in the code below.

> +		if (func && handlers[trap].func) {
> +			printf("exception handler installed twice %#x\n", trap);
> +			abort();
> +		}
>   		handlers[trap].func = func;
>   		handlers[trap].data = data;
> +	} else {
> +		printf("invalid exception handler %#x\n", trap);
> +		abort();
>   	}
>   }
>   

  Thomas

