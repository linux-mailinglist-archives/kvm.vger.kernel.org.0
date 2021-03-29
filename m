Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C72334C579
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhC2IAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:00:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231472AbhC2IAi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:00:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617004838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s4TH4xT94b+6YIUHfgIhTtKd1QJnaofOrzeq1/cImcY=;
        b=F0BpYE622sKp1/YaUJ9FBMqj/YUztbd3zmjQgmSXBNCTrEzul1fsSzcDMgVrhXgeu8GDtf
        S4QsemqMWVX5/xMP9n2L7tuoxbkAew+0gRJvmL2aFLdqMUwuBSxQTB/YzEL3Z5K3bjBCi9
        kxN3OKjzERsAZgjDQOJ4V2PsdkDMVrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-16FfA3qzOpmX6lPkDyXkxQ-1; Mon, 29 Mar 2021 04:00:35 -0400
X-MC-Unique: 16FfA3qzOpmX6lPkDyXkxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC510185303A;
        Mon, 29 Mar 2021 08:00:34 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5704909F6;
        Mon, 29 Mar 2021 08:00:22 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: lib: css: disabling a
 subchannel
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <82844be1-dd8f-e205-0966-309bf7c732f6@redhat.com>
Date:   Mon, 29 Mar 2021 10:00:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/2021 10.39, Pierre Morel wrote:
> Some tests require to disable a subchannel.
> Let's implement the css_disable() function.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/s390x/css.h     |  1 +
>   lib/s390x/css_lib.c | 67 +++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 68 insertions(+)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 7e3d261..b0de3a3 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -284,6 +284,7 @@ int css_enumerate(void);
>   #define IO_SCH_ISC      3
>   int css_enable(int schid, int isc);
>   bool css_enabled(int schid);
> +int css_disable(int schid);
>   
>   /* Library functions */
>   int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index efc7057..f5c4f37 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -186,6 +186,73 @@ bool css_enabled(int schid)
>   	}
>   	return true;
>   }
> +
> +/*
> + * css_disable: disable the subchannel
> + * @schid: Subchannel Identifier
> + * Return value:
> + *   On success: 0
> + *   On error the CC of the faulty instruction
> + *      or -1 if the retry count is exceeded.
> + */
> +int css_disable(int schid)
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
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		report_info("stsch: sch %08x already disabled", schid);
> +		return 0;
> +	}
> +
> +retry:

I have to saythat I really dislike writing loops with gotos if it can be 
avoided easily. What about:

for (retry_count = 0; retry_count < MAX_ENABLE_RETRIES; retry_count++) ?

(and maybe rename that variable to "retries" to keep it short?)

> +	/* Update the SCHIB to disable the subchannel */
> +	pmcw->flags &= ~PMCW_ENABLE;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	cc = msch(schid, &schib);
> +	/*
> +	 * If the subchannel is status pending or if a function is in progress,
> +	 * we consider both cases as errors.
> +	 */
> +	if (cc) {
> +		report_info("msch: sch %08x failed with cc=%d", schid, cc);
> +		return cc;
> +	}
> +
> +	/* Read the SCHIB again to verify the enablement */

"verify the disablement" ?

> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return cc;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		if (retry_count)
> +			report_info("stsch: sch %08x successfully disabled after %d retries",
> +				    schid, retry_count);
> +		return 0;
> +	}
> +
> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
> +		/* the hardware was not ready, give it some time */
> +		mdelay(10);
> +		goto retry;
> +	}
> +
> +	report_info("msch: modifying sch %08x failed after %d retries. pmcw flags: %04x",
> +		    schid, retry_count, pmcw->flags);
> +	return -1;
> +}
>   /*
>    * css_enable: enable the subchannel with the specified ISC
>    * @schid: Subchannel Identifier
> 

  Thomas

