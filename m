Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED06BEAC1
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 15:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjCQOK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 10:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjCQOK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 10:10:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B0828E56
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 07:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679062170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uK0/pTXr/F+lyO2sa6yT/NUjkjBpRjwT+MDqQ6YwpII=;
        b=aqwWdiCOlAQNzeUunKbAFMh9fG23TyIf+gmL/R5bUpAbA3HNbWZt2lMLcYv1sYNeffQbWA
        VBEkXLgjdtOQx2NE8QVshGpP6b04SYOAZxB/AFGkUlq7vJDKY4mEPrQMxdYCWi46Y9EvHy
        mL9/IlsrghiUraDcYWNtwv7tTYnr2R4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-8mv0OPAHP7OLZ9upJP_CpA-1; Fri, 17 Mar 2023 10:09:29 -0400
X-MC-Unique: 8mv0OPAHP7OLZ9upJP_CpA-1
Received: by mail-wr1-f70.google.com with SMTP id v4-20020adfc5c4000000b002cff4b4ba24so850587wrg.20
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 07:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679062167;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uK0/pTXr/F+lyO2sa6yT/NUjkjBpRjwT+MDqQ6YwpII=;
        b=z3kWEHH8aHHvOXjNevPZ07EkNajtwkZDY66qvCA2cb8KZwLghmVZPmYMds9h5Lyzn/
         6FMaMouTh/u8gxzxiZ0sFSCeRAZ40ol/cDuq2wN8+K4229yi21GhutDctjZE0MpLGml6
         5OALcwX1qsWXYwsg2kJXBP4BN7x4yG6y4VOQESfVcTFPAgCJAzYB5/Llk2M0LJ1L6vMe
         cMuE7WGMUAeXKXPXcPVXoQ53UZjA/zr9++B/VbD31GNwiQlh5ZfjPj7X03Osj7LoUsFa
         hcx5beqYXs6daJKaixQGq2p30z2/yIFHJZZf6EjbjztK/0UU43wELavLyRnX59hSNmuA
         Oj6Q==
X-Gm-Message-State: AO0yUKVi2cBTCUiUkv+ZGQZRkk2yt5bm+RSnJKxV193EiM2nWZ131VrL
        Npq8xBBtwEkfk3qm4qk4pqQrPSTCOjs8HQIts2QHn0yx7O7Dy+pKgW8BySMUa8TkaSHuUsylMgN
        zBHhwrCBCRFiN
X-Received: by 2002:a7b:c315:0:b0:3ed:5eed:555d with SMTP id k21-20020a7bc315000000b003ed5eed555dmr4952380wmj.10.1679062166906;
        Fri, 17 Mar 2023 07:09:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set/BtdC+zXTv9Q+tY4cGpGhLkVt0/QTyq85Qkl+yYpSHBhGLM7tZyptLAQJXwEbLtX0BGgfx9g==
X-Received: by 2002:a7b:c315:0:b0:3ed:5eed:555d with SMTP id k21-20020a7bc315000000b003ed5eed555dmr4952358wmj.10.1679062166645;
        Fri, 17 Mar 2023 07:09:26 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id e8-20020adffd08000000b002c592535839sm2068597wrr.17.2023.03.17.07.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 07:09:25 -0700 (PDT)
Message-ID: <86aa2246-07ff-8fb9-ad97-3b68e8b8f109@redhat.com>
Date:   Fri, 17 Mar 2023 15:09:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x/spec_ex: Add test of EXECUTE
 with odd target address
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230315155445.1688249-1-nsg@linux.ibm.com>
 <20230315155445.1688249-4-nsg@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230315155445.1688249-4-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/2023 16.54, Nina Schoetterl-Glausch wrote:
> The EXECUTE instruction executes the instruction at the given target
> address. This address must be halfword aligned, otherwise a
> specification exception occurs.
> Add a test for this.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   s390x/spec_ex.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 83b8c58e..5fa05dba 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
>   	return 0;
>   }
>   
> +static int odd_ex_target(void)
> +{
> +	uint64_t pre_target_addr;
> +	int to = 0, from = 0x0dd;
> +
> +	asm volatile ( ".pushsection .text.ex_odd\n"
> +		"	.balign	2\n"
> +		"pre_odd_ex_target:\n"
> +		"	. = . + 1\n"
> +		"	lr	%[to],%[from]\n"
> +		"	.popsection\n"
> +
> +		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
> +		"	ex	0,1(%[pre_target_addr])\n"
> +		: [pre_target_addr] "=&a" (pre_target_addr),
> +		  [to] "+d" (to)
> +		: [from] "d" (from)
> +	);
> +
> +	assert((pre_target_addr + 1) & 1);
> +	report(to != from, "did not perform ex with odd target");
> +	return 0;
> +}

Can this be triggered with KVM, or is this just a test for TCG?
In the latter case, Ilya also added a test for this to QEMU's TCG test suite:

  https://lists.gnu.org/archive/html/qemu-devel/2023-03/msg04872.html

... so if this is only about TCG, it should already be covered there.

  Thomas

