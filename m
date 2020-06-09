Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711991F355B
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 09:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgFIHre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 03:47:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35832 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgFIHre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 03:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591688852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=MLFyVwvpfs4WvEJvaQZNS3AkLtxwL8TwbqqwpOjnHrA=;
        b=P4cdjRGk9UzjDzJlIu3xDEEpW2emckqqeQbdS14QyKsAE4BAoWQ7gCUpw4Lxfi0khVUSqV
        vFijgj6JV1eMnkuIPB74ubXTC3gjY72EYELlm7wuZYL0bYGRALlm+56W32BiF+LXmFhRRE
        KBGXRc9LvUeN9N5i/D+Y/S5hjok0/ik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-Zz8pZEygPQuUpSl8MyEMGQ-1; Tue, 09 Jun 2020 03:47:30 -0400
X-MC-Unique: Zz8pZEygPQuUpSl8MyEMGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD10B80572E;
        Tue,  9 Jun 2020 07:47:29 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 95BEF82022;
        Tue,  9 Jun 2020 07:47:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 11/12] s390x: css: msch, enable test
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-12-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f888f043-6177-5bcc-f84f-437015457cf3@redhat.com>
Date:   Tue, 9 Jun 2020 09:47:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-12-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.13, Pierre Morel wrote:
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
>  s390x/css.c         | 18 ++++++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index dc5a512..831a116 100644
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
> diff --git a/s390x/css.c b/s390x/css.c
> index f0e8f47..6f58d4a 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -40,11 +40,29 @@ static void test_enumerate(void)
>  	}
>  }
>  
> +static void test_enable(void)
> +{
> +	int cc;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	cc = css_enable(test_device_sid);
> +
> +	if (cc)
> +		report(0, "Failed to enable subchannel %08x", test_device_sid);
> +	else
> +		report(1, "Subchannel %08x enabled", test_device_sid);

Could you please write this as:

	report(cc == 1, "Enable subchannel %08x", test_device_sid);

... checking for a right value is the whole point of the first parameter
of report() :-)

 Thanks,
  Thomas

