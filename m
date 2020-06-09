Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405021F3346
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 07:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgFIFHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 01:07:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32645 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725772AbgFIFHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 01:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591679261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=4HEKBfWtkZz3zDE5s7NlYMIZiplqjV3odsm7ZYpAiek=;
        b=PTGnQB+UEzHgVXYGGISfKoBc2k6ELCNgg8Pn8kzYCJY3d7Wnu8WWAcinPIQUwUA6azGJ2I
        14kaTM7DGOZUPgV+MYsG8t8PQNcdFX8ph0k28vN+K+amJVgYo/7vX7ewi/UMKl5bDPMp8l
        WFKjRk70XVWI5zmyOsiDlWe5TDxbyQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-FOUW4EbzMZafgQDog2DTEg-1; Tue, 09 Jun 2020 01:07:39 -0400
X-MC-Unique: FOUW4EbzMZafgQDog2DTEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB002107ACF4;
        Tue,  9 Jun 2020 05:07:38 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E6A1385;
        Tue,  9 Jun 2020 05:07:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 07/12] s390x: define function to wait
 for interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-8-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0005ec91-d4ac-2892-a800-76c96e7b34a0@redhat.com>
Date:   Tue, 9 Jun 2020 07:07:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-8-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.12, Pierre Morel wrote:
> Allow the program to wait for an interrupt.
> 
> The interrupt handler is in charge to remove the WAIT bit
> when it finished handling the interrupt.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/asm/arch_def.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 12045ff..e0ced12 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -10,9 +10,11 @@
>  #ifndef _ASM_S390X_ARCH_DEF_H_
>  #define _ASM_S390X_ARCH_DEF_H_
>  
> +#define PSW_MASK_IO			0x0200000000000000UL
>  #define PSW_MASK_EXT			0x0100000000000000UL
>  #define PSW_MASK_DAT			0x0400000000000000UL
>  #define PSW_MASK_SHORT_PSW		0x0008000000000000UL
> +#define PSW_MASK_WAIT			0x0002000000000000UL
>  #define PSW_MASK_PSTATE			0x0001000000000000UL
>  #define PSW_MASK_BA			0x0000000080000000UL
>  #define PSW_MASK_EA			0x0000000100000000UL
> @@ -253,6 +255,18 @@ static inline void load_psw_mask(uint64_t mask)
>  		: "+r" (tmp) :  "a" (&psw) : "memory", "cc" );
>  }
>  
> +static inline void wait_for_interrupt(uint64_t irq_mask)
> +{
> +	uint64_t psw_mask = extract_psw_mask();
> +
> +	load_psw_mask(psw_mask | irq_mask | PSW_MASK_WAIT);
> +	/*
> +	 * After being woken and having processed the interrupt, let's restore
> +	 * the PSW mask.
> +	 */
> +	load_psw_mask(psw_mask);
> +}
> +
>  static inline void enter_pstate(void)
>  {
>  	uint64_t mask;
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

