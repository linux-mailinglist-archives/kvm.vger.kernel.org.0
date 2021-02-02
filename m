Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EC930BCB9
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 12:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhBBLNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 06:13:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230073AbhBBLNC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 06:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612264295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2oVg/Uf05KcV5nMGrP9DGalUbJY3Gt5M2iu6wQi4DjQ=;
        b=eIsJcfy4sVmrpXVV02scNv6M8A+Byi87/s4oZ0PFg1TdYZeRml08CS+P1S7dtreY1Gzp+k
        NjZAuAVCAiqLR0yxW7bdP5f6EsWcDsTOatnOEg1CtQH0WM74E0+UNfhiOpcMtn/zCe5Z/s
        iwMXUmMz4WX4FXIf+0AGRqQDF7tgxuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28---2nXXPQOFWCMH_eVUEF2A-1; Tue, 02 Feb 2021 06:11:31 -0500
X-MC-Unique: --2nXXPQOFWCMH_eVUEF2A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53AF91DDE1;
        Tue,  2 Feb 2021 11:11:30 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A467B60C69;
        Tue,  2 Feb 2021 11:11:25 +0000 (UTC)
Date:   Tue, 2 Feb 2021 12:11:23 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/5] s390x: css: Store CSS
 Characteristics
Message-ID: <20210202121123.2397d844.cohuck@redhat.com>
In-Reply-To: <1611930869-25745-2-git-send-email-pmorel@linux.ibm.com>
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
        <1611930869-25745-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 15:34:25 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> CSS characteristics exposes the features of the Channel SubSystem.
> Let's use Store Channel Subsystem Characteristics to retrieve
> the features of the CSS.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     | 57 +++++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/css_lib.c | 50 ++++++++++++++++++++++++++++++++++++++-
>  s390x/css.c         | 12 ++++++++++
>  3 files changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 3e57445..bc0530d 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -288,4 +288,61 @@ int css_residual_count(unsigned int schid);
>  void enable_io_isc(uint8_t isc);
>  int wait_and_check_io_completion(int schid);
>  
> +/*
> + * CHSC definitions
> + */
> +struct chsc_header {
> +	u16 len;
> +	u16 code;
> +};
> +
> +/* Store Channel Subsystem Characteristics */
> +struct chsc_scsc {
> +	struct chsc_header req;
> +	u32 reserved1;
> +	u32 reserved2;
> +	u32 reserved3;
> +	struct chsc_header res;
> +	u32 format;
> +	u64 general_char[255];
> +	u64 chsc_char[254];

Both the kernel and QEMU use arrays of 32 bit values to model that. Not
a problem, just a stumbling block when comparing code :)

> +};
> +extern struct chsc_scsc *chsc_scsc;
> +
> +#define CSS_GENERAL_FEAT_BITLEN	(255 * 64)
> +#define CSS_CHSC_FEAT_BITLEN	(254 * 64)
> +
> +int get_chsc_scsc(void);
> +
> +static inline int _chsc(void *p)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"	.insn   rre,0xb25f0000,%2,0\n"
> +		"	ipm     %0\n"
> +		"	srl     %0,28\n"
> +		: "=d" (cc), "=m" (p)
> +		: "d" (p), "m" (p)
> +		: "cc");
> +
> +	return cc;
> +}
> +
> +#define CHSC_SCSC	0x0010
> +#define CHSC_SCSC_LEN	0x0010
> +
> +static inline int chsc(void *p, uint16_t code, uint16_t len)
> +{
> +	struct chsc_header *h = p;
> +
> +	h->code = code;
> +	h->len = len;
> +	return _chsc(p);
> +}

I'm wondering how useful this function is. For store channel subsystem
characteristics, you indeed only need to fill in code and len, but
other commands may need more fields filled out in the header, and
filling in code and len is not really extra work. I guess it depends
whether you plan to add more commands in the future.

Also maybe move the definitions to the actual invocation of scsc?

> +
> +#include <bitops.h>
> +#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
> +#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
> +
>  #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 3c24480..fe05021 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -15,11 +15,59 @@
>  #include <asm/arch_def.h>
>  #include <asm/time.h>
>  #include <asm/arch_def.h>
> -
> +#include <alloc_page.h>
>  #include <malloc_io.h>
>  #include <css.h>
>  
>  static struct schib schib;
> +struct chsc_scsc *chsc_scsc;
> +
> +int get_chsc_scsc(void)
> +{
> +	int i, n;
> +	int ret = 0;
> +	char buffer[510];
> +	char *p;
> +
> +	report_prefix_push("Channel Subsystem Call");
> +
> +	if (chsc_scsc) {
> +		report_info("chsc_scsc already initialized");
> +		goto end;
> +	}
> +
> +	chsc_scsc = alloc_pages(0);
> +	report_info("scsc_scsc at: %016lx", (u64)chsc_scsc);
> +	if (!chsc_scsc) {
> +		ret = -1;
> +		report(0, "could not allocate chsc_scsc page!");
> +		goto end;
> +	}
> +
> +	ret = chsc(chsc_scsc, CHSC_SCSC, CHSC_SCSC_LEN);
> +	if (ret) {
> +		report(0, "chsc: CC %d", ret);
> +		goto end;
> +	}

Shouldn't you check the response code in the chsc area as well?

> +
> +	for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++)
> +		if (css_general_feature(i)) {
> +			n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
> +			p += n;
> +		}
> +	report_info("General features: %s", buffer);
> +
> +	for (i = 0, p = buffer, ret = 0; i < CSS_CHSC_FEAT_BITLEN; i++)
> +		if (css_chsc_feature(i)) {
> +			n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
> +			p += n;
> +		}
> +	report_info("CHSC features: %s", buffer);
> +
> +end:
> +	report_prefix_pop();
> +	return ret;
> +}
>  
>  /*
>   * css_enumerate:

(...)

