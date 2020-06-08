Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1251F1C79
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 17:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgFHP4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 11:56:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47944 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730231AbgFHP4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 11:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591631771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=pVM91eqGNwsG4VqzhYU/SRoON7DAVTrgbBCNKcX/erc=;
        b=MbhDsAtvYjBUYcyu1gULumrsaqUnpmlNi1Qk5sAtMIRlWImvV2m0bkX20JRjaHJYMREUyT
        c93AOTcyDM4PuE6N8PH5xvBjFlivweki2ChJw+RrP9wJI4irONA7UQYCU+Fa5AeDBgGoGy
        0DhUheyRPNMyiikUjZkU91NDkTEolLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40--j5TbWd0PVikb6n1AMW7Hw-1; Mon, 08 Jun 2020 11:56:07 -0400
X-MC-Unique: -j5TbWd0PVikb6n1AMW7Hw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D6CE1883607;
        Mon,  8 Jun 2020 15:56:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D5B47F4FB;
        Mon,  8 Jun 2020 15:55:59 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 06/12] s390x: clock and delays
 caluculations
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-7-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2f449a7b-2701-abcc-42b7-5b7441c10761@redhat.com>
Date:   Mon, 8 Jun 2020 17:55:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-7-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.12, Pierre Morel wrote:
> The hardware gives us a good definition of the microsecond,
> let's keep this information and let the routine accessing
> the hardware keep all the information and return microseconds.
> 
> Calculate delays in microseconds and take care about wrapping
> around zero.
> 
> Define values with macros and use inlines to keep the
> milliseconds interface.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/time.h | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 1791380..eb15941 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -13,14 +13,39 @@
>  #ifndef ASM_S390X_TIME_H
>  #define ASM_S390X_TIME_H
>  
> -static inline uint64_t get_clock_ms(void)
> +#define STCK_SHIFT	(63 - 51)

Could you maybe rather call this STCK_SHIFT_US instead, so that it is
clear that we refer to the microsecond bit here?

> +#define STCK_MAX	((1 << (STCK_SHIFT + 1)) - 1)

Hmm, is that really right? Shouldn't that rather be

 ((1 << (51 + 1)) - 1)

instead?

(you want to have a max. value for the 52 bits that count the
microseconds, not a max value for the remainder bits, do you?)

> +static inline uint64_t get_clock_us(void)
>  {
>  	uint64_t clk;
>  
>  	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
>  
>  	/* Bit 51 is incrememented each microsecond */
> -	return (clk >> (63 - 51)) / 1000;
> +	return clk >> STCK_SHIFT;
> +}
> +
> +static inline void udelay(unsigned long us)
> +{
> +	unsigned long startclk = get_clock_us();
> +	unsigned long c;
> +
> +	do {
> +		c = get_clock_us();
> +		if (c < startclk)
> +			c += STCK_MAX;
> +	} while (c < (startclk + us));

You could omit the parentheses around "startclk + us" here.

> +}
> +
> +static inline void mdelay(unsigned long ms)
> +{
> +	udelay(ms * 1000);
> +}
> +
> +static inline uint64_t get_clock_ms(void)
> +{
> +	return get_clock_us() / 1000;
>  }
>  
>  #endif
> 

 Thomas

