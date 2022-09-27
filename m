Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0195EC4F1
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 15:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiI0Nvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 09:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiI0Nv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 09:51:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D7ED74C1
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 06:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664286688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FO3faRGnYTdCOZAGTQ6ZNyixIREs/tMxgkofKFmZ/tg=;
        b=jA1126ydJueI1bROjsqW1AbaWdqBFf22+dC+WDuqRsJQkAY3HwnjP4coWWk8C6ZzbiGTAi
        9dp56LnrAdImPYr5nTZrGx3k7hJNkRKUCnGip2OkvcZREWKInaHCkRkmYDCpA5CDcs7W/V
        jQGRj163elLiwDlO0MdX9iaCPZyspSo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-9-oxVVBFDMOXiqCZTa9SOFUg-1; Tue, 27 Sep 2022 09:51:26 -0400
X-MC-Unique: oxVVBFDMOXiqCZTa9SOFUg-1
Received: by mail-ej1-f70.google.com with SMTP id dt13-20020a170907728d00b007825956d979so3910249ejc.15
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 06:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FO3faRGnYTdCOZAGTQ6ZNyixIREs/tMxgkofKFmZ/tg=;
        b=A7wpLj2eR+Mq3dQUD5oA+v2Q5pYfi9oKrq9cbBv3JSjbVREfVCNcmKNl9fomUX7ix0
         yvb6FsURAQ2UVNHHTtbWUJO84R/JMZB0AIr5GPKD3llaSl0s1DHaLHPKaegMceU8ZEgk
         sBdBoA7hFO8pCMIbqXWMh/M6b2yyg5NHFis6QyAKsrp2gA5FpPcOOPW4zUGKfyT6Zmzh
         lRF6IIwzeU/SwkD2LTNqDztJcCL3K0XKB1Xm4rcwaOdoR3P2EQs79TYaXjANRQj8BJME
         SHfqz6ajqD/Pe3/gP45p/SFMsELbdhvWERvfJ/stv50OgrlVsxtWgxOjdaf+1z7iDzel
         VGzA==
X-Gm-Message-State: ACrzQf2W2c7xJMxa+K8yXFss7pNerpLsm2YB9umZb5xCxe4HSWQx6Xzj
        Dzri8fX0psxTpyQhuER4tj7YQiIP+hlKYGI2OQuSbh3IBAcYyiWKRXJSySTo/Fg9v4VxBikp0O8
        SVdbbTzLk3Js2
X-Received: by 2002:a17:907:75ee:b0:77b:c559:2bcc with SMTP id jz14-20020a17090775ee00b0077bc5592bccmr21476135ejc.537.1664286685345;
        Tue, 27 Sep 2022 06:51:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7iFDlBK4OTuHMXt2o6BbASzCDRcVZUwbCl6zwkC8agp/aVE1DGoTZuCvtHjOzmRCnZSuWHgw==
X-Received: by 2002:a17:907:75ee:b0:77b:c559:2bcc with SMTP id jz14-20020a17090775ee00b0077bc5592bccmr21476116ejc.537.1664286685121;
        Tue, 27 Sep 2022 06:51:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id n9-20020a056402060900b004533fc582cbsm1294656edv.21.2022.09.27.06.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 06:51:24 -0700 (PDT)
Message-ID: <8c166f97-1dc2-c050-12bc-a387b02044fe@redhat.com>
Date:   Tue, 27 Sep 2022 15:51:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: selftests: Gracefully handle empty stack traces
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org
References: <20220922231724.3560211-1-dmatlack@google.com>
 <CAHVum0cBvORZo1k0p2MQVZQ8tLddpjOmDrmfV19zuTLUYMjrpA@mail.gmail.com>
 <YzIRTx/f/bECYvM7@google.com> <YzIeCzIdffRSRbec@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YzIeCzIdffRSRbec@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/22 23:47, David Matlack wrote:
> How about this?
> 
> diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
> index 71ade6100fd3..2b56bbff970c 100644
> --- a/tools/testing/selftests/kvm/lib/assert.c
> +++ b/tools/testing/selftests/kvm/lib/assert.c
> @@ -38,16 +38,28 @@ static void test_dump_stack(void)
>                   1];
>          char *c;
> 
> -       n = backtrace(stack, n);
>          c = &cmd[0];
>          c += sprintf(c, "%s", addr2line);
> -       /*
> -        * Skip the first 3 frames: backtrace, test_dump_stack, and
> -        * test_assert. We hope that backtrace isn't inlined and the other two
> -        * we've declared noinline.
> -        */
> -       for (i = 2; i < n; i++)
> -               c += sprintf(c, " %lx", ((unsigned long) stack[i]) - 1);
> +
> +       n = backtrace(stack, n);
> +       if (n > 2) {
> +               /*
> +                * Skip the first 2 frames, which should be test_dump_stack()
> +                * and test_assert(); both of which are declared noinline.
> +                */
> +               for (i = 2; i < n; i++)
> +                       c += sprintf(c, " %lx", ((unsigned long) stack[i]) - 1);
> +       } else {
> +               /*
> +                * Bail if the resulting stack trace would be empty. Otherwise,
> +                * addr2line will block waiting for addresses to be passed in
> +                * via stdin.
> +                */
> +               fputs("  (stack trace missing)\n", stderr);
> +               return;
> +       }
> +
>          c += sprintf(c, "%s", pipeline);
>   #pragma GCC diagnostic push
>   #pragma GCC diagnostic ignored "-Wunused-result"
> 

I think your original patch is better, just with

diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index c1ce54a41eca..be2cab00f541 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -36,11 +36,9 @@ static void test_dump_stack(void)
  		 n * (((sizeof(void *)) * 2) + 1) +
  		 /* Null terminator: */
  		 1];
-	char *c;
+	char *c = cmd;
  
  	n = backtrace(stack, n);
-	c = &cmd[0];
-	c += sprintf(c, "%s", addr2line);
  	/*
  	 * Skip the first 2 frames, which should be test_dump_stack() and
  	 * test_assert(); both of which are declared noinline.  Bail if the
@@ -51,6 +49,8 @@ static void test_dump_stack(void)
  		fputs("  (stack trace empty)\n", stderr);
  		return;
  	}
+
+	c += sprintf(c, "%s", addr2line);
  	for (i = 2; i < n; i++)
  		c += sprintf(c, " %lx", ((unsigned long) stack[i]) - 1);
  

squashed in to keep the "if" and backtrace() call as close as possible.

Paolo

