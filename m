Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31503AFDFD
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFVHix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:38:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhFVHix (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:38:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624347397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=78AoyZGEww4eX5wQlfZVTd7MSU26Lj9OFW0KxEtUtQE=;
        b=B6p8kfjExJWqRuGGc24NsF+t5i2PXegtnCPiE5Wn6UfnNodLpoP5cAaT4o3MPmvGNEvyGg
        QowsYQ+Rb2T9ZNQdPdIDSnzjLXhVBpkrwIzbM7Jvr19wM/UPWAL9hfhT/GugcSHxcCIkjC
        zKWeorO74N3M++hSdXF2MYGyP19e/WY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-pxLU9-dhOj-wFCzJg0AnTg-1; Tue, 22 Jun 2021 03:36:35 -0400
X-MC-Unique: pxLU9-dhOj-wFCzJg0AnTg-1
Received: by mail-wm1-f72.google.com with SMTP id f22-20020a1c6a160000b029018f49a7efb7so407630wmc.1
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 00:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=78AoyZGEww4eX5wQlfZVTd7MSU26Lj9OFW0KxEtUtQE=;
        b=iHORkJfsutIDrE4qhDbvOYaOoiSIe35r2Qy7fcqZULiQ6+1zBvVQWI0bmbBdSaHSt3
         yFsI6E1eGPIuY+CjO1nb5tkP8amhbhho2XKGPVmn/wPNSkMSGJWYgKcig8ERsxKJBJHC
         UIz+hDbYdzw+ugSiMJdOTLo9n7Yt4TN3P8UwE2JrcwziEYII18kKG0B7Jf4GdB03GzNH
         bN/LeXJlubVDd9NNSAIngMtt5BShCP17ZRLkrXBOFDIxZxCBf7MY75lj5cKyQtmxusi2
         UHAtyjU9WTrnwjhd5HP53asU0Pi1FNsb929vbCEkp6jl71tkyH8bldyirJU2e1WuMMB/
         HqBw==
X-Gm-Message-State: AOAM5328a8uSjM0ZNGIkd9pZKjLBQjkeSndqXcFKA2t9mZuDnoAvSZP5
        TjeVJszUOcleYR7I9wyKfiaLeAk2kbwQxXqypPQZrD/zNir2M+52fSee9T+jOXsCJrGqG794OfL
        h04PtifIQmc5l
X-Received: by 2002:adf:eb82:: with SMTP id t2mr2972074wrn.337.1624347394709;
        Tue, 22 Jun 2021 00:36:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoJfk+r77PGl9RauhygLIUoORvlmYjxRTavo4pfmYHwGkkYTTwPzciyLPGKqOafwCbcG6JMQ==
X-Received: by 2002:adf:eb82:: with SMTP id t2mr2972065wrn.337.1624347394545;
        Tue, 22 Jun 2021 00:36:34 -0700 (PDT)
Received: from thuth.remote.csb (pd9575f2f.dip0.t-ipconnect.de. [217.87.95.47])
        by smtp.gmail.com with ESMTPSA id u18sm1355827wmj.15.2021.06.22.00.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 00:36:33 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
To:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210621140356.1210771-1-hca@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7edaf85c-810b-e0f9-5977-6e89270f0709@redhat.com>
Date:   Tue, 22 Jun 2021 09:36:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621140356.1210771-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/2021 16.03, Heiko Carstens wrote:
> Using register asm statements has been proven to be very error prone,
> especially when using code instrumentation where gcc may add function
> calls, which clobbers register contents in an unexpected way.
> 
> Therefore get rid of register asm statements in kvm code, even though
> there is currently nothing wrong with them. This way we know for sure
> that this bug class won't be introduced here.
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1296fc10f80c..4b7b24f07790 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>   
>   static inline int plo_test_bit(unsigned char nr)
>   {
> -	register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
> +	unsigned long function = (unsigned long) nr | 0x100;
>   	int cc;
>   
>   	asm volatile(
> +		"	lgr	0,%[function]\n"
>   		/* Parameter registers are ignored for "test bit" */
>   		"	plo	0,0,0,0(0)\n"
>   		"	ipm	%0\n"
>   		"	srl	%0,28\n"
>   		: "=d" (cc)
> -		: "d" (r0)
> -		: "cc");
> +		: [function] "d" (function)
> +		: "cc", "0");
>   	return cc == 0;
>   }
>   
>   static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
>   {
> -	register unsigned long r0 asm("0") = 0;	/* query function */
> -	register unsigned long r1 asm("1") = (unsigned long) query;
> -
>   	asm volatile(
> -		/* Parameter regs are ignored */
> +		"	lghi	0,0\n"
> +		"	lgr	1,%[query]\n"
> +		/* Parameter registers are ignored */
>   		"	.insn	rrf,%[opc] << 16,2,4,6,0\n"
>   		:
> -		: "d" (r0), "a" (r1), [opc] "i" (opcode)
> -		: "cc", "memory");
> +		: [query] "d" ((unsigned long)query), [opc] "i" (opcode)

Wouldn't it be better to keep the "a" constraint instead of "d" to avoid 
that the compiler ever passes the "query" value in r0 ?
Otherwise the query value might get trashed if it is passed in r0...

> +		: "cc", "memory", "0", "1");
>   }

With "a" instead of "d":

Reviewed-by: Thomas Huth <thuth@redhat.com>

