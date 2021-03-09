Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2984D332CAE
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 17:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCIQ5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 11:57:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhCIQ4z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 11:56:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615309015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q1egl+L1rZWa8ln2yZ0cI9KtimfXRm5vTfuSpGiRUEg=;
        b=VDCtNT5N1WsOymVPEKwNmTzEzXgtNEtibiR76cpixyyUzM3Z9Sf1w9VY7jTRA10Y+ivTTu
        ncdUspgqRntS69r/pFltYbTU61C09RoQTr+imk720lvC2D6ZAmYszzEHQBwvQtAEvvD373
        l+4jZDfscBrjBsqVw7D/Fq05wPFX8eU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-7cBjGNihM9CVZ_Z8JErhaw-1; Tue, 09 Mar 2021 11:56:52 -0500
X-MC-Unique: 7cBjGNihM9CVZ_Z8JErhaw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 199EE1019630;
        Tue,  9 Mar 2021 16:56:51 +0000 (UTC)
Received: from gondolin (ovpn-113-144.ams2.redhat.com [10.36.113.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 834E51001B2C;
        Tue,  9 Mar 2021 16:56:46 +0000 (UTC)
Date:   Tue, 9 Mar 2021 17:56:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v5 4/6] s390x: css: implementing Set
 CHannel Monitor
Message-ID: <20210309175644.2cf7d11d.cohuck@redhat.com>
In-Reply-To: <1615294277-7332-5-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
        <1615294277-7332-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Mar 2021 13:51:15 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We implement the call of the Set CHannel Monitor instruction,
> starting the monitoring of the all Channel Sub System, and
> initializing channel subsystem monitoring.
> 
> Initial tests report the presence of the extended measurement block
> feature, and verify the error reporting of the hypervisor for SCHM.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/css.h     | 16 ++++++++++++++--
>  lib/s390x/css_lib.c |  4 ++--
>  s390x/css.c         | 35 +++++++++++++++++++++++++++++++++++
>  3 files changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 3c50fa8..7158423 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -309,6 +309,7 @@ struct chsc_scsc {
>  	uint8_t reserved[9];
>  	struct chsc_header res;
>  	uint32_t res_fmt;
> +#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
>  	uint64_t general_char[255];
>  	uint64_t chsc_char[254];
>  };
> @@ -356,8 +357,19 @@ static inline int _chsc(void *p)
>  bool chsc(void *p, uint16_t code, uint16_t len);
>  
>  #include <bitops.h>
> -#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
> -#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
> +#define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
> +#define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)

I think the renaming belongs in patch 1?

> +
> +#define SCHM_DCTM	1 /* activate Device Connection TiMe */
> +#define SCHM_MBU	2 /* activate Measurement Block Update */
> +
> +static inline void schm(void *mbo, unsigned int flags)
> +{
> +	register void *__gpr2 asm("2") = mbo;
> +	register long __gpr1 asm("1") = flags;
> +
> +	asm("schm" : : "d" (__gpr2), "d" (__gpr1));
> +}
>  
>  bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
>  bool css_disable_mb(int schid);
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 77b39c7..95d9a78 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -94,7 +94,7 @@ bool get_chsc_scsc(void)
>  		return false;
>  
>  	for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++) {
> -		if (css_general_feature(i)) {
> +		if (css_test_general_feature(i)) {

and here...

>  			n = snprintf(p, sizeof(buffer), "%d,", i);
>  			p += n;
>  		}
> @@ -102,7 +102,7 @@ bool get_chsc_scsc(void)
>  	report_info("General features: %s", buffer);
>  
>  	for (i = 0, p = buffer; i < CSS_CHSC_FEAT_BITLEN; i++) {
> -		if (css_chsc_feature(i)) {
> +		if (css_test_chsc_feature(i)) {

...and here.

>  			n = snprintf(p, sizeof(buffer), "%d,", i);
>  			p += n;
>  		}

