Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EA81E3DC4
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 11:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgE0Jmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 05:42:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35349 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728033AbgE0Jmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 05:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590572570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0puwwXNhKN7RSE2QI0t2f9CXt8LITwCnQss5WUrmJk=;
        b=dri9J68mzN5V/NxhZGmQs3fXcQkHKwMgMaeFteDXKd9aR8EStEMBHUCTwZPPrNXAWCwEvI
        s3XmnPgjtrEZiKorR71N7kj8j3OgRJT1J4bzTbY3qNhcJq1h5seGHF0mhpHdF9duWkW13g
        1EGIeLHFVExHa6pdsUiseOU/BHr8NG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-c5Fq9dKQNkOJWehSURcLyQ-1; Wed, 27 May 2020 05:42:47 -0400
X-MC-Unique: c5Fq9dKQNkOJWehSURcLyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05F8C872FE0;
        Wed, 27 May 2020 09:42:46 +0000 (UTC)
Received: from gondolin (ovpn-112-223.ams2.redhat.com [10.36.112.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE72F7D982;
        Wed, 27 May 2020 09:42:41 +0000 (UTC)
Date:   Wed, 27 May 2020 11:42:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 09/12] s390x: css: msch, enable test
Message-ID: <20200527114239.65fa9473.cohuck@redhat.com>
In-Reply-To: <1589818051-20549-10-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-10-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 18:07:28 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> A second step when testing the channel subsystem is to prepare a channel
> for use.
> This includes:
> - Get the current subchannel Information Block (SCHIB) using STSCH
> - Update it in memory to set the ENABLE bit
> - Tell the CSS that the SCHIB has been modified using MSCH
> - Get the SCHIB from the CSS again to verify that the subchannel is
>   enabled.
> - If the subchannel is not enabled retry a predefined retries count.
> 
> This tests the MSCH instruction to enable a channel succesfuly.
> This is NOT a routine to really enable the channel, no retry is done,
> in case of error, a report is made.

Hm... so you retry if the subchannel is not enabled after cc 0, but you
don't retry if the cc indicates busy/status pending? Makes sense, as we
don't expect the subchannel to be busy, but a more precise note in the
patch description would be good :)

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index d7989d8..1b60a47 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -16,6 +16,7 @@
>  #include <string.h>
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
> +#include <asm/time.h>
>  
>  #include <css.h>
>  
> @@ -65,11 +66,77 @@ out:
>  	       scn, scn_found, dev_found);
>  }
>  
> +#define MAX_ENABLE_RETRIES	5
> +static void test_enable(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int retry_count = 0;
> +	int cc;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(test_device_sid, &schib);
> +	if (cc) {
> +		report(0, "stsch cc=%d", cc);
> +		return;
> +	}
> +
> +	if (pmcw->flags & PMCW_ENABLE) {
> +		report(1, "stsch: sch %08x already enabled", test_device_sid);
> +		return;
> +	}
> +
> +retry:
> +	/* Update the SCHIB to enable the channel */
> +	pmcw->flags |= PMCW_ENABLE;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	cc = msch(test_device_sid, &schib);
> +	if (cc) {
> +		/*
> +		 * If the subchannel is status pending or
> +		 * if a function is in progress,
> +		 * we consider both cases as errors.

Could also be cc 3, but that would be even more weird. Just logging the
cc seems fine, though.

> +		 */
> +		report(0, "msch cc=%d", cc);
> +		return;
> +	}
> +
> +	/*
> +	 * Read the SCHIB again to verify the enablement
> +	 */
> +	cc = stsch(test_device_sid, &schib);
> +	if (cc) {
> +		report(0, "stsch cc=%d", cc);
> +		return;
> +	}
> +
> +	if (pmcw->flags & PMCW_ENABLE) {
> +		report(1, "msch: sch %08x enabled after %d retries",
> +		       test_device_sid, retry_count);
> +		return;
> +	}
> +
> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
> +		mdelay(10); /* the hardware was not ready, let it some time */

s/let/give/

> +		goto retry;
> +	}
> +
> +	report(0,
> +	       "msch: enabling sch %08x failed after %d retries. pmcw: %x",
> +	       test_device_sid, retry_count, pmcw->flags);
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
>  } tests[] = {
>  	{ "enumerate (stsch)", test_enumerate },
> +	{ "enable (msch)", test_enable },
>  	{ NULL, NULL }
>  };
>  

Otherwise,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

