Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A221FC949
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 10:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgFQIyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 04:54:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24355 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgFQIyr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 04:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592384085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OyBmfaQpnotnRsL5tWB9CmbAwI11duXRS+HA1U897D0=;
        b=U1E32HYw1L3ZWYckby0O8vtfAbk9Lm7Xgn6h0mTWeV7qcwmVbgdrfO5L1JFY+9ernlR63T
        8TzNG9cNzeu2Ev0qxj0pQfvecpYNkVvPRBcVLugm2Nt2mayVXYIIP3zvh4VFyfQZZzFQ7B
        LCcsY8fmoxETa2ArArPapifET0f9vIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-IALioR1mPViDYoJIBrw-UQ-1; Wed, 17 Jun 2020 04:54:41 -0400
X-MC-Unique: IALioR1mPViDYoJIBrw-UQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F1EB18A8227;
        Wed, 17 Jun 2020 08:54:40 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96E097CAA5;
        Wed, 17 Jun 2020 08:54:36 +0000 (UTC)
Date:   Wed, 17 Jun 2020 10:54:33 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 11/12] s390x: css: msch, enable test
Message-ID: <20200617105433.6a79e92c.cohuck@redhat.com>
In-Reply-To: <1592213521-19390-12-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
        <1592213521-19390-12-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jun 2020 11:32:00 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> A second step when testing the channel subsystem is to prepare a channel
> for use.
> This includes:
> - Get the current subchannel Information Block (SCHIB) using STSCH
> - Update it in memory to set the ENABLE bit
> - Tell the CSS that the SCHIB has been modified using MSCH
> - Get the SCHIB from the CSS again to verify that the subchannel is
>   enabled.
> - If the command succeeds but subchannel is not enabled retry a
>   predefined retries count.
> - If the command fails, report the failure and do not retry, even
>   if cc indicates a busy/status pending as we do not expect this.
> 
> This tests the MSCH instruction to enable a channel succesfuly.
> This some retries are done and in case of error, and if the retries
> count is exceeded, a report is made.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css_lib.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/css.c         | 15 ++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index b0a0294..06a76db 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -15,6 +15,7 @@
>  #include <string.h>
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
> +#include <asm/time.h>
>  
>  #include <css.h>
>  
> @@ -68,3 +69,62 @@ out:
>  		    scn, scn_found, dev_found);
>  	return schid;
>  }
> +
> +int css_enable(int schid)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int retry_count = 0;
> +	int cc;
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch failed with cc=%d", cc);

Mention the schid in the message?

> +		return cc;
> +	}
> +
> +	if (pmcw->flags & PMCW_ENABLE) {
> +		report_info("stsch: sch %08x already enabled", schid);
> +		return 0;
> +	}
> +
> +retry:
> +	/* Update the SCHIB to enable the channel */
> +	pmcw->flags |= PMCW_ENABLE;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	cc = msch(schid, &schib);
> +	if (cc) {
> +		/*
> +		 * If the subchannel is status pending or
> +		 * if a function is in progress,
> +		 * we consider both cases as errors.
> +		 */
> +		report_info("msch failed with cc=%d", cc);
> +		return cc;
> +	}
> +
> +	/*
> +	 * Read the SCHIB again to verify the enablement
> +	 */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch failed with cc=%d", cc);

Also add the schid here? Maybe also add a marker to distinguish the two
cases?

> +		return cc;
> +	}
> +
> +	if (pmcw->flags & PMCW_ENABLE) {
> +		report_info("Subchannel %08x enabled after %d retries",
> +			    schid, retry_count);
> +		return 0;
> +	}
> +
> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
> +		mdelay(10); /* the hardware was not ready, give it some time */
> +		goto retry;
> +	}
> +
> +	report_info("msch: enabling sch %08x failed after %d retries. pmcw flags: %x",
> +		    schid, retry_count, pmcw->flags);
> +	return -1;
> +}

With the messages updated,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

