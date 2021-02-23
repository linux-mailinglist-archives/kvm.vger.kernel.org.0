Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F9C322B5A
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 14:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhBWNYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 08:24:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232441AbhBWNX7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 08:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614086551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XCdSW0hy14Xm5N5F++0E25LPG0UixPo9zSJmCjDyI6M=;
        b=e5JTBGY3Z8nzbkRCq0tLhI5W/LhKl3uZllFKsMqCI7fSeEjJf2JuyP9nwMjDtSjRbJsLh3
        gG0W5nvbtm9nR+FAMapX3TxzgQHwUWspiX3lmU+nFKsYHsSAff3/iYLwo2Wfn0nKrI6WRW
        qGCqM3wL4O7C3G0C4DhGQS4qBuhRMa0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-cc8ZrSypMrujPzCOnTh2mQ-1; Tue, 23 Feb 2021 08:22:27 -0500
X-MC-Unique: cc8ZrSypMrujPzCOnTh2mQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13252107ACED;
        Tue, 23 Feb 2021 13:22:26 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB9AA614FF;
        Tue, 23 Feb 2021 13:22:21 +0000 (UTC)
Date:   Tue, 23 Feb 2021 14:22:19 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 3/5] s390x: css: implementing Set
 CHannel Monitor
Message-ID: <20210223142219.0f42a303.cohuck@redhat.com>
In-Reply-To: <1613669204-6464-4-git-send-email-pmorel@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
        <1613669204-6464-4-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 18:26:42 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We implement the call of the Set CHannel Monitor instruction,
> starting the monitoring of the all Channel Sub System, and
> initializing channel subsystem monitoring.
> 
> Initial tests report the presence of the extended measurement block
> feature, and verify the error reporting of the hypervisor for SCHM.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  21 +++++++++-
>  lib/s390x/css_lib.c | 100 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/css.c         |  35 ++++++++++++++++
>  3 files changed, 155 insertions(+), 1 deletion(-)

(...)

> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 65b58ff..4c8a6ae 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -265,6 +265,106 @@ retry:
>  	return -1;
>  }
>  
> +/*
> + * schib_update_mb: update the subchannel Mesurement Block

s/Mesurement/Measurement/

I guess that one is hard to get out of one's fingers :)

> + * @schid: Subchannel Identifier
> + * @mb   : 64bit address of the measurement block
> + * @mbi : the measurement block offset
> + * @flags : PMCW_MBUE to enable measurement block update
> + *	    PMCW_DCTME to enable device connect time
> + *	    0 to disable measurement
> + * @format1: set if format 1 is to be used
> + */
> +static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
> +			    uint16_t flags, bool format1)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
> +		return false;
> +	}
> +
> +	/* Update the SCHIB to enable the measurement block */
> +	if (flags) {
> +		pmcw->flags |= flags;
> +
> +		if (format1)
> +			pmcw->flags2 |= PMCW_MBF1;
> +		else
> +			pmcw->flags2 &= ~PMCW_MBF1;
> +
> +		pmcw->mbi = mbi;
> +		schib.mbo = mb;
> +	} else {
> +		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
> +	}
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
> +		return false;
> +	}
> +
> +	/*
> +	 * Read the SCHIB again
> +	 */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * css_enable_mb: enable the subchannel Mesurement Block

s/Mesurement/Measurement/

> + * @schid: Subchannel Identifier
> + * @mb   : 64bit address of the measurement block
> + * @format1: set if format 1 is to be used
> + * @mbi : the measurement block offset
> + * @flags : PMCW_MBUE to enable measurement block update
> + *	    PMCW_DCTME to enable device connect time
> + */
> +bool css_enable_mb(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
> +		   bool format1)
> +{
> +	int retry_count = MAX_ENABLE_RETRIES;
> +	struct pmcw *pmcw = &schib.pmcw;
> +
> +	while (retry_count-- &&
> +	       !schib_update_mb(schid, mb, mbi, flags, format1))
> +		mdelay(10); /* the hardware was not ready, give it some time */
> +
> +	return schib.mbo == mb && pmcw->mbi == mbi;
> +}
> +
> +/*
> + * css_disable_mb: enable the subchannel Mesurement Block

s/enable/disable/
s/Mesurement/Measurement/

> + * @schid: Subchannel Identifier
> + */
> +bool css_disable_mb(int schid)
> +{
> +	int retry_count = MAX_ENABLE_RETRIES;
> +
> +	while (retry_count-- &&
> +	       !schib_update_mb(schid, 0, 0, 0, 0))
> +		mdelay(10); /* the hardware was not ready, give it some time */
> +
> +	return retry_count > 0;
> +}
> +
>  static struct irb irb;
>  
>  void css_irq_io(void)

(...)

I'd still have split out the subchannel-modifying functions into a
separate patch, but no strong opinion.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

