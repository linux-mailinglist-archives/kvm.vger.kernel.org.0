Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5F75192E
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 08:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbjGMG5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 02:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbjGMG5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 02:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7032681
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 23:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689231406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lSfaM4EPoEeF4z7Qgex6LNIuT76L7/QwYWl4NyCE8YM=;
        b=NZRPCiDiUYyWo1/Qa+ZDZQROLw+T6hZ5NPsrcw0M9dc89sz3Kl+zCozdnTnhXtE/v28dMk
        YiBhODUfr7HwUgc3dXL4gdbHVWQs31Ri9CJSu7c8/Gzrr8An7o4hQ+/Ej0acXgQcDvLaXC
        d1hEay5pG+YFukMsf+hwvopXr2TIbdo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-At7-Wm6ENG27W-rHlyp3vA-1; Thu, 13 Jul 2023 02:56:45 -0400
X-MC-Unique: At7-Wm6ENG27W-rHlyp3vA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-634dacfa27bso4147086d6.3
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 23:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689231405; x=1691823405;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSfaM4EPoEeF4z7Qgex6LNIuT76L7/QwYWl4NyCE8YM=;
        b=k020q+KLtzG1PCudHsWrOLjKj4OgimDgblna68wB3IBD1j87+hpYlVH0jKZUg4YikX
         kPYsNB9syuZJcubTx1E+YIKmdEiHeprEjkmpXkJYuNy1dT4hAF8kM/jWbYASgGoZpCAL
         9OzZBDlKKj20ZRG7uVGYwPB9/55P6vwPEJAMs45bwuTLy0vsUDqoj7PpZxg/ezfGAhbs
         RrtJP+/+YAqR5NB8MTH3fgCsEXWId/mzHqiLjJgAUGiQ7Qdu+3hevOZfiiDf3GU8TLGB
         imQuK2vcgEaHEzKV+tg93VuxSYzMhRq3ua7ids8jY1/HuXXnKuVDeIJ3fSqnyFcmUvwm
         enkQ==
X-Gm-Message-State: ABy/qLZ1gCkim/2wY4n8LdffQ83T0bHBV6ZsBRvGBebnwGVYBiU+U704
        HbZyrohrdAGIBOPEVosnawNRN2zinF8hY+EecF8z4xyhpy5Rrn8BDYN2dVWgHXWXFdGnTDEJwC5
        s7HRSlNP5wZty
X-Received: by 2002:a0c:f293:0:b0:636:18a7:db23 with SMTP id k19-20020a0cf293000000b0063618a7db23mr669132qvl.46.1689231404842;
        Wed, 12 Jul 2023 23:56:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHiX1pBQzr75ZWL+X5B08uQOMTA5ltOO5gAJNSxA45VXlkgTDu0cLWvc4arX+rw6ra5vyofag==
X-Received: by 2002:a0c:f293:0:b0:636:18a7:db23 with SMTP id k19-20020a0cf293000000b0063618a7db23mr669128qvl.46.1689231404511;
        Wed, 12 Jul 2023 23:56:44 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id a20-20020a0ce354000000b005ef442226bbsm2856131qvm.8.2023.07.12.23.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 23:56:44 -0700 (PDT)
Message-ID: <53d9d63f-e207-23a6-faea-8bad8b22a375@redhat.com>
Date:   Thu, 13 Jul 2023 08:56:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
 <20230712114149.1291580-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/6] lib: s390x: introduce bitfield for
 PSW mask
In-Reply-To: <20230712114149.1291580-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/2023 13.41, Nico Boehr wrote:
> Changing the PSW mask is currently little clumsy, since there is only the
> PSW_MASK_* defines. This makes it hard to change e.g. only the address
> space in the current PSW without a lot of bit fiddling.
> 
> Introduce a bitfield for the PSW mask. This makes this kind of
> modifications much simpler and easier to read.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 26 +++++++++++++++++++++++++-
>   s390x/selftest.c         | 40 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bb26e008cc68..53279572a9ee 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -37,12 +37,36 @@ struct stack_frame_int {
>   };
>   
>   struct psw {
> -	uint64_t	mask;
> +	union {
> +		uint64_t	mask;
> +		struct {
> +			uint8_t reserved00:1;
> +			uint8_t per:1;
> +			uint8_t reserved02:3;
> +			uint8_t dat:1;
> +			uint8_t io:1;
> +			uint8_t ext:1;
> +			uint8_t key:4;
> +			uint8_t reserved12:1;
> +			uint8_t mchk:1;
> +			uint8_t wait:1;
> +			uint8_t pstate:1;
> +			uint8_t as:2;
> +			uint8_t cc:2;
> +			uint8_t prg_mask:4;
> +			uint8_t reserved24:7;
> +			uint8_t ea:1;
> +			uint8_t ba:1;
> +			uint32_t reserved33:31;
> +		};
> +	};
>   	uint64_t	addr;
>   };
> +_Static_assert(sizeof(struct psw) == 16, "PSW size");
>   
>   #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
>   
> +
>   struct short_psw {
>   	uint32_t	mask;
>   	uint32_t	addr;
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index 13fd36bc06f8..8d81ba312279 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -74,6 +74,45 @@ static void test_malloc(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_psw_mask(void)
> +{
> +	uint64_t expected_key = 0xF;
> +	struct psw test_psw = PSW(0, 0);
> +
> +	report_prefix_push("PSW mask");
> +	test_psw.dat = 1;
> +	report(test_psw.mask == PSW_MASK_DAT, "DAT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_DAT, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.io = 1;
> +	report(test_psw.mask == PSW_MASK_IO, "IO matches expected=0x%016lx actual=0x%016lx", PSW_MASK_IO, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.ext = 1;
> +	report(test_psw.mask == PSW_MASK_EXT, "EXT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_EXT, test_psw.mask);
> +
> +	test_psw.mask = expected_key << (63 - 11);
> +	report(test_psw.key == expected_key, "PSW Key matches expected=0x%lx actual=0x%x", expected_key, test_psw.key);

Patch looks basically fine to me, but here my mind stumbled a little bit. 
This test is written the other way round than the others. Nothing wrong with 
that, it just feels a little bit inconsistent. I'd suggest to either do:

	test_psw.mask = 0;
	test_psw.key = expected_key;
	report(test_psw.mask == expected_key << (63 - 11), ...);

or maybe even switch all the other tests around instead, so you could get 
rid of the "test_psw.mask = 0" lines, e.g. :

	test_psw.mask == PSW_MASK_IO;
	report(test_psw.io, "IO matches ...");

etc.

  Thomas

