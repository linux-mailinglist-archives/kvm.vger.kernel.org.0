Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9790330BD6B
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 12:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhBBLuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 06:50:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230058AbhBBLt7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 06:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612266513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58+78T5j/zr0YoqqIeJqBu8SPu3V3qztEXBV0KpmkVU=;
        b=Ocihw2GVJn5pLu3VaU2pNpTnCpMJxJNUVmPVJ0hZFtCQ9ZC5nybl2pevvpWrfNXxlnDGoj
        HWVM+hs0q7WAz6DKEMPmMq5aBIq2BtvDWxB78GJR28z82DNU2avuXhj3FVphCL1A2YbDkq
        /R5XOPG/dS8C7ZaZ7AyCb9eRIem5CA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-LDFRZODdM7eCJ48R-Yba7A-1; Tue, 02 Feb 2021 06:48:27 -0500
X-MC-Unique: LDFRZODdM7eCJ48R-Yba7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4220E107ACE6;
        Tue,  2 Feb 2021 11:48:26 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7DD1100164C;
        Tue,  2 Feb 2021 11:48:20 +0000 (UTC)
Date:   Tue, 2 Feb 2021 12:48:18 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 3/5] s390x: css: implementing Set
 CHannel Monitor
Message-ID: <20210202124818.6084bb36.cohuck@redhat.com>
In-Reply-To: <1611930869-25745-4-git-send-email-pmorel@linux.ibm.com>
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
        <1611930869-25745-4-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 15:34:27 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We implement the call of the Set CHannel Monitor instruction,
> starting the monitoring of the all Channel Sub System, and

"initializing channel subsystem monitoring" ?

> the initialization of the monitoring on a Sub Channel.

"enabling monitoring for a subchannel" ?

> 
> An initial test reports the presence of the extended measurement
> block feature.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     | 17 +++++++++-
>  lib/s390x/css_lib.c | 77 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/css.c         |  7 +++++
>  3 files changed, 100 insertions(+), 1 deletion(-)
> 

(...)

> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index f300969..9e0f568 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -205,6 +205,83 @@ retry:
>  	return -1;
>  }
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

Setting some invalid flags for measurements in the schib could lead to
an operand exception. Do we want to rely on the caller always getting
it right, or should we add handling for those invalid flags? (Might
also make a nice test case.)

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
> +
> +	report_info("msch: modifying sch %08x failed after %d retries. pmcw flags: %04x",
> +		    schid, retry_count, pmcw->flags);
> +	return -1;
> +}
> +
>  static struct irb irb;
>  
>  void css_irq_io(void)

(...)

