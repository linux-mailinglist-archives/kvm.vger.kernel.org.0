Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B131FC895
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 10:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgFQI2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 04:28:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45847 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726025AbgFQI2g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 04:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592382515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3GjgZLiUiOxM4KW4wCX/5fbom+hzlu3qzH3FU/CI2Q=;
        b=cTNkPciZgl17dMb9SqRz7giUq5tVeQh/Kc9Fze08QYzr0+/rZv/1wrWLa4fQb5+/HsakCD
        vUiSpEShEuBGcKSfsEXLTLFkxnPBYedeQtYSkBe8BQBHmwFmOdXFAP9yO/3UiT3Ccc/j3Y
        du62zusVXt2Vg2WP5HGCgejYH4yUgfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-EvvX-GE5NZO2aV2eIq5a0w-1; Wed, 17 Jun 2020 04:28:31 -0400
X-MC-Unique: EvvX-GE5NZO2aV2eIq5a0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B44E18C31F2;
        Wed, 17 Jun 2020 08:28:30 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2791512FE;
        Wed, 17 Jun 2020 08:28:26 +0000 (UTC)
Date:   Wed, 17 Jun 2020 10:27:03 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 06/12] s390x: clock and delays
 caluculations
Message-ID: <20200617102704.7755e11a.cohuck@redhat.com>
In-Reply-To: <1592213521-19390-7-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
        <1592213521-19390-7-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jun 2020 11:31:55 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

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
> index 1791380..7f1d891 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -13,14 +13,39 @@
>  #ifndef ASM_S390X_TIME_H
>  #define ASM_S390X_TIME_H
>  
> -static inline uint64_t get_clock_ms(void)
> +#define STCK_SHIFT_US	(63 - 51)
> +#define STCK_MAX	((1UL << 52) - 1)
> +
> +static inline uint64_t get_clock_us(void)
>  {
>  	uint64_t clk;
>  
>  	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
>  
>  	/* Bit 51 is incrememented each microsecond */

That comment may now be a tad non-obvious, because the details are
hidden behind the #define? Anyway, no strong opinion.

> -	return (clk >> (63 - 51)) / 1000;
> +	return clk >> STCK_SHIFT_US;
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
> +	} while (c < startclk + us);
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

Acked-by: Cornelia Huck <cohuck@redhat.com>

