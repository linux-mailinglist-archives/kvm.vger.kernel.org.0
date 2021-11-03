Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8409C443DF0
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 09:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhKCIEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 04:04:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230430AbhKCIEV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 04:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635926486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fIILqwkU/7TDHXCXV8IG2GdVMuc/ij7JsyUzGUT7X4w=;
        b=R3AH0VVOXuCFFO1g01DzDmjOXOOLN02pnB6HfpVgl/SXVqO+EuKHrMcty8dgJ6qXCSw9xV
        eBfjqWK2vCmsVlazSxIOmP7XSow2Q8Xzs68vJx0qgEqXX4S3Rq3e+1ga1N8uGSWxwgz+PL
        YauUmxI0DNn1Ndmkn4jl1XBDveSPnGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-mgPKjlHjOdG3_nx_fSHyVw-1; Wed, 03 Nov 2021 04:01:25 -0400
X-MC-Unique: mgPKjlHjOdG3_nx_fSHyVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61E64A40C4;
        Wed,  3 Nov 2021 08:01:24 +0000 (UTC)
Received: from [10.39.192.84] (unknown [10.39.192.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FCF4197FC;
        Wed,  3 Nov 2021 08:01:22 +0000 (UTC)
Message-ID: <8aee772e-cb44-4d3d-16bd-186b90257407@redhat.com>
Date:   Wed, 3 Nov 2021 09:01:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 4/7] s390x: css: registering IRQ
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-5-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <1630059440-15586-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2021 12.17, Pierre Morel wrote:
> Registering IRQ for the CSS level.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h     | 21 +++++++++++++++++++++
>   lib/s390x/css_lib.c | 27 +++++++++++++++++++++++++--
>   2 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 2005f4d7..0422f2e7 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -402,4 +402,25 @@ struct measurement_block_format1 {
>   	uint32_t irq_prio_delay_time;
>   };
>   
> +#include <asm/arch_def.h>
> +static inline void disable_io_irq(void)
> +{
> +	uint64_t mask;
> +
> +	mask = extract_psw_mask();
> +	mask &= ~PSW_MASK_IO;
> +	load_psw_mask(mask);
> +}
> +
> +static inline void enable_io_irq(void)
> +{
> +	uint64_t mask;
> +
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_IO;
> +	load_psw_mask(mask);
> +}
> +
> +int register_css_irq_func(void (*f)(void));
> +int unregister_css_irq_func(void (*f)(void));
>   #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 484f9c41..a89fc93c 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -350,8 +350,29 @@ bool css_disable_mb(int schid)
>   	return retry_count > 0;
>   }
>   
> -static struct irb irb;
> +static void (*css_irq_func)(void);
> +
> +int register_css_irq_func(void (*f)(void))
> +{
> +	if (css_irq_func)
> +		return -1;
> +	css_irq_func = f;
> +	assert(register_io_int_func(css_irq_io) == 0);

It's unlikely that we ever disable assert() in the k-u-t, but anyway, I'd 
prefer not to put function calls within assert() statements, just in case. 
So could you please replace this with:

	rc = register_io_int_func(css_irq_io);
	assert(rc == 0);

?

> +	enable_io_isc(0x80 >> IO_SCH_ISC);
> +	return 0;
> +}
>   
> +int unregister_css_irq_func(void (*f)(void))
> +{
> +	if (css_irq_func != f)
> +		return -1;
> +	enable_io_isc(0);
> +	unregister_io_int_func(css_irq_io);
> +	css_irq_func = NULL;
> +	return 0;
> +}
> +
> +static struct irb irb;
>   void css_irq_io(void)
>   {
>   	int ret = 0;
> @@ -386,7 +407,9 @@ void css_irq_io(void)
>   		report(0, "tsch reporting sch %08x as not operational", sid);
>   		break;
>   	case 0:
> -		/* Stay humble on success */
> +		/* Call upper level IRQ routine */
> +		if (css_irq_func)
> +			css_irq_func();
>   		break;
>   	}
>   pop:
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

