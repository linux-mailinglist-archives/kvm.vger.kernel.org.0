Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BCD589455
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbiHCWRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiHCWRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:17:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04EA533A16
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 15:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659565063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5PFxMgYfFCdZL4v0oQUXz30WFkkB8QIe0HmjbyswfQI=;
        b=R5I1gEWzbEqnPFY/97ZzY3TCL9vxzkaAxDURU9+Zf4pQa/BDfkvaN+EbHOxaFARtuBNvFi
        4u79OQrfFXkTHRvdJ9MAqbkmdwGIfhFCRwLxoFztR1+ZEHzhCqo61yfX4dWkgzBcoPjXn4
        gNbttr9tNrqird2+TTNfD19hb8c2FAk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-KO-Kt6M0MvuyqvZngLKKhQ-1; Wed, 03 Aug 2022 18:17:41 -0400
X-MC-Unique: KO-Kt6M0MvuyqvZngLKKhQ-1
Received: by mail-wm1-f72.google.com with SMTP id ay19-20020a05600c1e1300b003a315c2c1c0so1637835wmb.7
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 15:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5PFxMgYfFCdZL4v0oQUXz30WFkkB8QIe0HmjbyswfQI=;
        b=b+69AN/jT40bPTtM3yCrbK1FiKxXMtxUUjXy1Q94sTyDlxRXcjroRKqWN+lpwqht14
         x8cCqx9GnTuFtvJRzNCZgDoSlxezpCozty7iSsV7tuBYBVubhR3WzO16IFtGw0r6EMH5
         iOU0leBMlPgxzG9zGZJR02xmJX+vVm2vVlAYFf6bKRKwG5/GSQDKPilRtitrPAoz+gbq
         a0Mh+P4Pag1H1UEKghZ/laeYBF2WmI4zttVJ//jlk7BAchQ86Gk7W+th8czMDjIm8ZRL
         IYI6hKsRInUMxvcfJgRyifg4Ek9ScNQdNuPBhbxTOem5iyk4oICaI0UHsQ10RpunAne/
         0JRg==
X-Gm-Message-State: ACgBeo2h8n4SqCMvKm+X6XCYFWnGNlnmCJX/eQWRuD2SNkOCDFk87dvH
        Ui+I3u/nGFMPOYkf7fGQyYM0n1kIn5Bmu036LCsOMndddcrE7jj0dTTiscApT3E9OqG8k4PrNfa
        m8FJU7SpmLTK1
X-Received: by 2002:a05:600c:1e8d:b0:3a5:74d:c61c with SMTP id be13-20020a05600c1e8d00b003a5074dc61cmr394777wmb.70.1659565060805;
        Wed, 03 Aug 2022 15:17:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6mP1RbPaA6+u4RyBxggtu94n8BuENrjyAV18zoCadth/3F+oj3NjNAQW/G9Tz0XdjMeqIDKw==
X-Received: by 2002:a05:600c:1e8d:b0:3a5:74d:c61c with SMTP id be13-20020a05600c1e8d00b003a5074dc61cmr394765wmb.70.1659565060527;
        Wed, 03 Aug 2022 15:17:40 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-42-112-229.web.vodafone.de. [109.42.112.229])
        by smtp.gmail.com with ESMTPSA id i18-20020adfaad2000000b0021d70a871cbsm19626133wrc.32.2022.08.03.15.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 15:17:39 -0700 (PDT)
Message-ID: <b1383c10-fa60-56b5-7d57-7d6d59efd572@redhat.com>
Date:   Thu, 4 Aug 2022 00:17:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: verify EQBS/SQBS is
 unavailable
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220803135851.384805-1-nrb@linux.ibm.com>
 <20220803135851.384805-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220803135851.384805-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/2022 15.58, Nico Boehr wrote:
> QEMU doesn't provide EQBS/SQBS instructions, so we should check they
> result in an exception.

I somewhat fail to see the exact purpose of this patch... QEMU still doesn't 
emulate a lot of other instructions, too, so why are we checking now these 
QBS instructions? Why not all the others? Why do we need a test to verify 
that there is an exception in this case - was there a bug somewhere that 
didn't cause an exception in certain circumstances?

> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/intercept.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 9e826b6c79ad..48eb2d22a2cc 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -197,6 +197,34 @@ static void test_diag318(void)
>   
>   }
>   
> +static void test_qbs(void)
> +{
> +	report_prefix_push("qbs");

You should definitely add a comment here, explaining why this is only a test 
for QEMU and saying that this could be removed as soon as QEMU implements 
these instructions later - otherwise this would be very confusing to the 
readers later (if they forget or cannot check the commit message).

> +	if (!host_is_qemu()) {
> +		report_skip("QEMU-only test");
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("sqbs");
> +	expect_pgm_int();
> +	asm volatile(
> +		"	.insn   rsy,0xeb000000008a,0,0,0(0)\n"
> +		: : : "memory", "cc");
> +	check_pgm_int_code(PGM_INT_CODE_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("eqbs");
> +	expect_pgm_int();
> +	asm volatile(
> +		"	.insn   rrf,0xb99c0000,0,0,0,0\n"
> +		: : : "memory", "cc");
> +	check_pgm_int_code(PGM_INT_CODE_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}

  Thomas


