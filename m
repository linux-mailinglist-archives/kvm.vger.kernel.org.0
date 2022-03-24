Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CEE4E5FEB
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 09:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348774AbiCXIKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 04:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347283AbiCXIKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 04:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB52449920
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 01:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648109313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SU4E4d+EQ6sdIzJU8wyzsXPKrg3wnnVy1ZJmMoN/oGw=;
        b=DiHrk+H6PPj1OEZRT6Po60+6VVtz5oYEs+NUFRgUxuTZyLYrml+GkemXpilD9pMdXhAriy
        tzPA8zajQMdEJKVl5jIvd9/rj4n2cHBFR+aNqBmnL5w66piYmuw0FzoD/KR15om1P9UWGU
        QL0WpDiYeO5jWLvIr+0vCkhLaoA+Kr4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-dVR-ESqvNXS5tfMI9MaDnA-1; Thu, 24 Mar 2022 04:08:32 -0400
X-MC-Unique: dVR-ESqvNXS5tfMI9MaDnA-1
Received: by mail-wr1-f71.google.com with SMTP id s8-20020adfc548000000b00203eba1052eso1408213wrf.1
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 01:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SU4E4d+EQ6sdIzJU8wyzsXPKrg3wnnVy1ZJmMoN/oGw=;
        b=6kOcqyCuP4umRSFOKxofTU/9/zQ08AprEx4cQNuQdxrpHZdK4A5L56Eda1EL82NtKK
         d3BN0LvKo8rzVlGn1wJ4G+1GezduqDIXGpLWM6RK5/m4XI+USNjD28gHOmMSA6GeZjxO
         znnDOcCBcZJNpb8yKzfaj8wfd1+0dRBMWEcSSMLemF/Yp946JnypHsvidhiI+eb+KzOz
         S3+v7p/zaWaOWXQ0xRBxsaDojSe1NmHGzdggsQ0b/huXXulwGI7CpQ1QamGLyNtENluU
         rdjzyokxklYHcXXzOlYEh8y1huv+B8LS9xtt9hOHB6hzmZ4q7DHEmdfVI4Ur41iXqQV2
         OdOg==
X-Gm-Message-State: AOAM532i8zeTPe+1rlcnFvgZW7CZoIUduHEw7WuoDhIKfrFhNMgdjL6Y
        tovf2TPVhnRf8cHsU/ZMJS1PBzJmt5tfcHIUMyy32DO482NSKnuQtXTvKLryhktzoIBiUj0JGxK
        VYEAmt+9VwMRF
X-Received: by 2002:a1c:29c3:0:b0:350:9797:b38f with SMTP id p186-20020a1c29c3000000b003509797b38fmr13060142wmp.22.1648109311263;
        Thu, 24 Mar 2022 01:08:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHcnWjquihS0Yb64SRxvQtrTJwe4xJa7MDXtanktK95XA2/7IxPTOgHdNxbVyWqH3m6oZ4Mg==
X-Received: by 2002:a1c:29c3:0:b0:350:9797:b38f with SMTP id p186-20020a1c29c3000000b003509797b38fmr13060126wmp.22.1648109311024;
        Thu, 24 Mar 2022 01:08:31 -0700 (PDT)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com. [80.187.98.218])
        by smtp.gmail.com with ESMTPSA id e12-20020a5d6d0c000000b001a65e479d20sm2190191wrq.83.2022.03.24.01.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 01:08:30 -0700 (PDT)
Message-ID: <6d8edf09-0055-ff7a-22b5-92679f777f5b@redhat.com>
Date:   Thu, 24 Mar 2022 09:08:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH kvm-unit-tests v2 1/6] lib: s390x: smp: Retry SIGP SENSE
 on CC2
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220311173822.1234617-1-farman@linux.ibm.com>
 <20220311173822.1234617-2-farman@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220311173822.1234617-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/2022 18.38, Eric Farman wrote:
> The routine smp_cpu_stopped() issues a SIGP SENSE, and returns true
> if it received a CC1 (STATUS STORED) with the STOPPED or CHECK STOP
> bits enabled. Otherwise, it returns false.
> 
> This is misleading, because a CC2 (BUSY) merely indicates that the
> order code could not be processed, not that the CPU is operating.
> It could be operating but in the process of being stopped.
> 
> Convert the invocation of the SIGP SENSE to retry when a CC2 is
> received, so we get a more definitive answer.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/smp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 46e1b022..368d6add 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -78,7 +78,7 @@ bool smp_cpu_stopped(uint16_t idx)
>   {
>   	uint32_t status;
>   
> -	if (smp_sigp(idx, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
> +	if (smp_sigp_retry(idx, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
>   		return false;
>   	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
>   }

Reviewed-by: Thomas Huth <thuth@redhat.com>

