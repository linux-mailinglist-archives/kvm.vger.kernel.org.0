Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD694751A58
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 09:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjGMHv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 03:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjGMHv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 03:51:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142E5170E
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 00:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689234669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=To8JA7any/hBLG5IdjVEmv3s3KYZ8RU403NMNr+HSPw=;
        b=Lnybe5269dyiiot8yBlPlVZUoMPr1Ry8Ruit+xBXo38Lt19iK4FRWWJH5TSVvmIzH2uhm2
        shBuof3c9esd5oLfO2obImc9rx2JMdLVW3q6gMh0tBKujecp860ZIW+cUqOFi9SgyhzUsK
        2EupvMp/674HXR/uRfk0WM8KjOKggoM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-TOHq-u5oNYCxr2o9gG-eDA-1; Thu, 13 Jul 2023 03:51:07 -0400
X-MC-Unique: TOHq-u5oNYCxr2o9gG-eDA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7624ca834b5so65068685a.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 00:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689234667; x=1691826667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=To8JA7any/hBLG5IdjVEmv3s3KYZ8RU403NMNr+HSPw=;
        b=FoF3rztDb7LRjoHMfS6IAphYII97zKM88Zu+Yf118OZFh423QoEzVG9vaxcb7BtADY
         kuUCxE7hAYDfcCIocK7UOFlWGmTMbE85zTA8dXyMfHqcrMHn9nB+uCLDdZD9PNkIe140
         rXXlKJmDZTXCNpOIuEWoCHnX1rSsBp/YjlXEFqdGM3VUNx4b7yNlnB+RnyxiiddFTF9i
         Id3MHQTidX0rZU0zcbnV6xRey+190j/Scl8xf/Rj818uKx7ecnOgNXe7t3ZZcc7ZIhFX
         Z8EjePNG713jPj3/UoTzcU/5PiME0wz+5aFMxmKL5yAnpVZCWZXMbUh4PajXNiA4/PfQ
         lkaw==
X-Gm-Message-State: ABy/qLZTtVx0DMSZaFDVEW/rOHZpqaRLzruIB56B7MI/zp51yKi4OXKs
        DN294AM14fdajATeFi2wjQ/VefrRatvoFrFA4NfOjLvCxSkqBaSHgKivNwb2DEaE65c4f7qW82Y
        RPGGys0CkBI36c/Yt+lsO
X-Received: by 2002:a05:620a:4516:b0:767:dfc8:a944 with SMTP id t22-20020a05620a451600b00767dfc8a944mr1131150qkp.41.1689234667282;
        Thu, 13 Jul 2023 00:51:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEUD9CNUM6pwmJt+e9FkG4+g+mbIGrMPaT4T2LeILMDO4hAamyvLLqdQsotL+W1/HCO+2ceOQ==
X-Received: by 2002:a05:620a:4516:b0:767:dfc8:a944 with SMTP id t22-20020a05620a451600b00767dfc8a944mr1131145qkp.41.1689234667052;
        Thu, 13 Jul 2023 00:51:07 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id e10-20020a05620a12ca00b007592f2016f4sm2698226qkl.110.2023.07.13.00.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 00:51:06 -0700 (PDT)
Message-ID: <b518c14a-bc83-3cc2-016f-20de76d3e376@redhat.com>
Date:   Thu, 13 Jul 2023 09:51:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH v5 5/6] s390x: lib: sie: don't reenter SIE
 on pgm int
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
 <20230712114149.1291580-6-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230712114149.1291580-6-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/2023 13.41, Nico Boehr wrote:
> At the moment, when a PGM int occurs while in SIE, we will just reenter
> SIE after the interrupt handler was called.
> 
> This is because sie() has a loop which checks icptcode and re-enters SIE
> if it is zero.
> 
> However, this behaviour is quite undesirable for SIE tests, since it
> doesn't give the host the chance to assert on the PGM int. Instead, we
> will just re-enter SIE, on nullifing conditions even causing the
> exception again.
> 
> In sie(), check whether a pgm int code is set in lowcore. If it has,
> exit the loop so the test can react to the interrupt. Add a new function
> read_pgm_int_code() to obtain the interrupt code.
> 
> Note that this introduces a slight oddity with sie and pgm int in
> certain cases: If a PGM int occurs between a expect_pgm_int() and sie(),
> we will now never enter SIE until the pgm_int_code is cleared by e.g.
> clear_pgm_int().
> 
> Also add missing include of facility.h to mem.h.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/interrupt.h | 14 ++++++++++++++
>   lib/s390x/asm/mem.h       |  1 +
>   lib/s390x/sie.c           |  4 +++-
>   3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 55759002dce2..9e509d2f4f1e 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -99,4 +99,18 @@ static inline void low_prot_disable(void)
>   	ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
>   }
>   
> +/**
> + * read_pgm_int_code - Get the program interruption code of the last pgm int
> + * on the current CPU.
> + *
> + * This is similar to clear_pgm_int(), except that it doesn't clear the
> + * interruption information from lowcore.
> + *
> + * Returns 0 when none occurred.
> + */
> +static inline uint16_t read_pgm_int_code(void)
> +{
> +	return lowcore.pgm_int_code;
> +}
> +
>   #endif
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 64ef59b546a4..94d58c34f53f 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -8,6 +8,7 @@
>   #ifndef _ASMS390X_MEM_H_
>   #define _ASMS390X_MEM_H_
>   #include <asm/arch_def.h>
> +#include <asm/facility.h>
>   
>   /* create pointer while avoiding compiler warnings */
>   #define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index ffa8ec91a423..632740edd431 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -13,6 +13,7 @@
>   #include <libcflat.h>
>   #include <sie.h>
>   #include <asm/page.h>
> +#include <asm/interrupt.h>
>   #include <libcflat.h>
>   #include <alloc_page.h>
>   
> @@ -65,7 +66,8 @@ void sie(struct vm *vm)
>   	/* also handle all interruptions in home space while in SIE */
>   	irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
>   
> -	while (vm->sblk->icptcode == 0) {
> +	/* leave SIE when we have an intercept or an interrupt so the test can react to it */
> +	while (vm->sblk->icptcode == 0 && !read_pgm_int_code()) {
>   		sie64a(vm->sblk, &vm->save_area);
>   		sie_handle_validity(vm);
>   	}

Reviewed-by: Thomas Huth <thuth@redhat.com>

