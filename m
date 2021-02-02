Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E59D30C7EF
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbhBBRgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:36:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237453AbhBBReE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:34:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612287158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EF2EIr89oP/RO3AL1RbsXLbunAXz87srDu9phun6pF0=;
        b=Pqtmrj1nkDK0BG6MNoW8yyaI+u4AdueOk4jlLlL6ODDkQtKg2mACEeFUZI7kZK3qRzAleS
        bZpc19rZIzKjzkh5D6ItnwnoXGyTcnokCADZvcXdt/7pvGfxjDEGkXU/r2yWKIRF5o+xXM
        dEjeBq2lmAMhUyazHwE9d0ZkcCBheKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-UA6zBaWNO9moZe579buZ0w-1; Tue, 02 Feb 2021 12:32:37 -0500
X-MC-Unique: UA6zBaWNO9moZe579buZ0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0109A801B1D;
        Tue,  2 Feb 2021 17:32:36 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B05FF60C5F;
        Tue,  2 Feb 2021 17:32:30 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 3/5] s390x: css: implementing Set
 CHannel Monitor
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-4-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <3a0aade0-510b-adaa-e956-3dddc23388ba@redhat.com>
Date:   Tue, 2 Feb 2021 18:32:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611930869-25745-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/2021 15.34, Pierre Morel wrote:
> We implement the call of the Set CHannel Monitor instruction,
> starting the monitoring of the all Channel Sub System, and
> the initialization of the monitoring on a Sub Channel.
> 
> An initial test reports the presence of the extended measurement
> block feature.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h     | 17 +++++++++-
>   lib/s390x/css_lib.c | 77 +++++++++++++++++++++++++++++++++++++++++++++
>   s390x/css.c         |  7 +++++
>   3 files changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index f8bfa37..938f0ab 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -82,6 +82,7 @@ struct pmcw {
>   	uint32_t intparm;
>   #define PMCW_DNV	0x0001
>   #define PMCW_ENABLE	0x0080
> +#define PMCW_MBUE	0x0010
>   #define PMCW_ISC_MASK	0x3800
>   #define PMCW_ISC_SHIFT	11
>   	uint16_t flags;
> @@ -94,6 +95,7 @@ struct pmcw {
>   	uint8_t  pom;
>   	uint8_t  pam;
>   	uint8_t  chpid[8];
> +#define PMCW_MBF1	0x0004
>   	uint32_t flags2;
>   };
>   #define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
> @@ -101,7 +103,8 @@ struct pmcw {
>   struct schib {
>   	struct pmcw pmcw;
>   	struct scsw scsw;
> -	uint8_t  md[12];
> +	uint64_t mbo;
> +	uint8_t  md[4];
>   } __attribute__ ((aligned(4)));
>   
>   struct irb {
> @@ -305,6 +308,7 @@ struct chsc_scsc {
>   	u32 reserved3;
>   	struct chsc_header res;
>   	u32 format;
> +#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
>   	u64 general_char[255];
>   	u64 chsc_char[254];
>   };
> @@ -346,4 +350,15 @@ static inline int chsc(void *p, uint16_t code, uint16_t len)
>   #define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
>   #define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
>   
> +static inline void schm(void *mbo, unsigned int flags)
> +{
> +	register void *__gpr2 asm("2") = mbo;
> +	register long __gpr1 asm("1") = flags;
> +
> +	asm("schm" : : "d" (__gpr2), "d" (__gpr1));
> +}
> +
> +int css_enable_mb(int schid, uint64_t mb, int format1, uint16_t mbi,
> +		  uint16_t flags);
> +
>   #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index f300969..9e0f568 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -205,6 +205,83 @@ retry:
>   	return -1;
>   }
>   
> +/*
> + * css_enable_mb: enable the subchannel Mesurement Block
> + * @schid: Subchannel Identifier
> + * @mb   : 64bit address of the measurement block
> + * @format1: set if format 1 is to be used
> + * @mbi : the measurement block offset
> + * @flags : PMCW_MBUE to enable measurement block update
> + *	    PMCW_DCTME to enable device connect time
> + * Return value:
> + *   On success: 0
> + *   On error the CC of the faulty instruction
> + *      or -1 if the retry count is exceeded.
> + */
> +int css_enable_mb(int schid, uint64_t mb, int format1, uint16_t mbi,
> +		  uint16_t flags)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int retry_count = 0;
> +	int cc;
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
> +		return cc;
> +	}
> +
> +retry:
> +	/* Update the SCHIB to enable the measurement block */
> +	pmcw->flags |= flags;
> +
> +	if (format1)
> +		pmcw->flags2 |= PMCW_MBF1;
> +	else
> +		pmcw->flags2 &= ~PMCW_MBF1;
> +
> +	pmcw->mbi = mbi;
> +	schib.mbo = mb;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	cc = msch(schid, &schib);
> +	if (cc) {
> +		/*
> +		 * If the subchannel is status pending or
> +		 * if a function is in progress,
> +		 * we consider both cases as errors.
> +		 */
> +		report_info("msch: sch %08x failed with cc=%d", schid, cc);
> +		return cc;
> +	}
> +
> +	/*
> +	 * Read the SCHIB again to verify the measurement block origin
> +	 */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return cc;
> +	}
> +
> +	if (schib.mbo == mb) {
> +		report_info("stsch: sch %08x successfully modified after %d retries",
> +			    schid, retry_count);
> +		return 0;
> +	}
> +
> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
> +		mdelay(10); /* the hardware was not ready, give it some time */
> +		goto retry;
> +	}

"goto retries" are always a good indication that you likely should use a 
proper loop instead. And maybe put the code in the loop body into a separate 
function?

  Thomas

