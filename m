Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08F530BCF6
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 12:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhBBLZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 06:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231293AbhBBLYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 06:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612265002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JBKHPjk6x41Zxs6Yt8JX4pz4Bnku1mhHjwDqemu0bMI=;
        b=PIPaL1asF2plLPcKmQRuh24XpwSX/BVG6V8kaF/FshFIqeZVk3F7TLOrf8RCyX6xIHnEg/
        qMzCNKRVBUmHTLrAkWg6saVMi8G8aJ0vkI+4bRFUt6EDP7aQS69jLFnSpZ4eWMlwh+AS36
        oRMMUbfu6+vLbXwl/qQkMLLTSDLZSJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-DfZjf_KzOf6k9o836jiJcg-1; Tue, 02 Feb 2021 06:23:19 -0500
X-MC-Unique: DfZjf_KzOf6k9o836jiJcg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89CA21F764;
        Tue,  2 Feb 2021 11:23:18 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDA9310016FB;
        Tue,  2 Feb 2021 11:23:13 +0000 (UTC)
Date:   Tue, 2 Feb 2021 12:23:11 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 2/5] s390x: css: simplifications of
 the tests
Message-ID: <20210202122311.3c1ead1c.cohuck@redhat.com>
In-Reply-To: <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
        <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 15:34:26 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> In order to ease the writing of tests based on:
> - interrupt
> - enabling a subchannel
> - using multiple I/O on a channel without disabling it
> 
> We do the following simplifications:
> - the I/O interrupt handler is registered on CSS initialization
> - We do not enable again a subchannel in senseid if it is already
>   enabled
> - we add a css_enabled() function to test if a subchannel is enabled
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 37 ++++++++++++++++++++++++----------
>  s390x/css.c         | 49 +++++++++++++++++++++++++--------------------
>  3 files changed, 54 insertions(+), 33 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index bc0530d..f8bfa37 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -278,6 +278,7 @@ int css_enumerate(void);
>  
>  #define IO_SCH_ISC      3
>  int css_enable(int schid, int isc);
> +bool css_enabled(int schid);
>  
>  /* Library functions */
>  int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index fe05021..f300969 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -118,6 +118,31 @@ out:
>  	return schid;
>  }
>  
> +/*
> + * css_enable: enable the subchannel with the specified ISC
> + * @schid: Subchannel Identifier
> + * Return value:
> + *   true if the subchannel is enabled
> + *   false otherwise
> + */
> +bool css_enabled(int schid)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return false;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		report_info("stsch: sch %08x not enabled", schid);
> +		return 0;
> +	}
> +	return true;
> +}
>  /*
>   * css_enable: enable the subchannel with the specified ISC
>   * @schid: Subchannel Identifier
> @@ -167,18 +192,8 @@ retry:
>  	/*
>  	 * Read the SCHIB again to verify the enablement
>  	 */
> -	cc = stsch(schid, &schib);
> -	if (cc) {
> -		report_info("stsch: updating sch %08x failed with cc=%d",
> -			    schid, cc);
> -		return cc;
> -	}
> -
> -	if ((pmcw->flags & flags) == flags) {
> -		report_info("stsch: sch %08x successfully modified after %d retries",
> -			    schid, retry_count);
> +	if (css_enabled(schid))

This is a slightly different test now. Previously, you also checked
whether the ISC matched the requested one. Not sure how valuable that
test was.

>  		return 0;
> -	}
>  
>  	if (retry_count++ < MAX_ENABLE_RETRIES) {
>  		mdelay(10); /* the hardware was not ready, give it some time */
> diff --git a/s390x/css.c b/s390x/css.c
> index 18dbf01..230f819 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -56,36 +56,27 @@ static void test_enable(void)
>   * - We need the test device as the first recognized
>   *   device by the enumeration.
>   */
> -static void test_sense(void)
> +static bool do_test_sense(void)
>  {
>  	struct ccw1 *ccw;
> +	bool retval = false;
>  	int ret;
>  	int len;
>  
>  	if (!test_device_sid) {
>  		report_skip("No device");
> -		return;
> +		return retval;
>  	}
>  
> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
> -	if (ret) {
> -		report(0, "Could not enable the subchannel: %08x",
> -		       test_device_sid);
> -		return;
> +	if (!css_enabled(test_device_sid)) {
> +		report(0, "enabled subchannel: %08x", test_device_sid);

Isn't that a _not_ enabled subchannel?

> +		return retval;
>  	}
>  
> -	ret = register_io_int_func(css_irq_io);
> -	if (ret) {
> -		report(0, "Could not register IRQ handler");
> -		return;
> -	}
> -
> -	lowcore_ptr->io_int_param = 0;
> -
>  	senseid = alloc_io_mem(sizeof(*senseid), 0);
>  	if (!senseid) {
>  		report(0, "Allocation of senseid");
> -		goto error_senseid;
> +		return retval;
>  	}
>  
>  	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> @@ -129,16 +120,21 @@ static void test_sense(void)
>  	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
>  		    senseid->reserved, senseid->cu_type, senseid->cu_model,
>  		    senseid->dev_type, senseid->dev_model);
> +	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
> +		    senseid->cu_type);
>  
> -	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
> -	       (uint16_t)cu_type, senseid->cu_type);
> +	retval = senseid->cu_type == cu_type;
>  
>  error:
>  	free_io_mem(ccw, sizeof(*ccw));
>  error_ccw:
>  	free_io_mem(senseid, sizeof(*senseid));
> -error_senseid:
> -	unregister_io_int_func(css_irq_io);
> +	return retval;
> +}
> +
> +static void test_sense(void)
> +{
> +	report(do_test_sense(), "Got CU type expected");
>  }
>  
>  static void css_init(void)
> @@ -146,8 +142,17 @@ static void css_init(void)
>  	int ret;
>  
>  	ret = get_chsc_scsc();
> -	if (!ret)
> -		report(1, " ");
> +	if (ret)
> +		return;

Shouldn't you report a failure here?

> +
> +	ret = register_io_int_func(css_irq_io);
> +	if (ret) {
> +		report(0, "Could not register IRQ handler");
> +		return;
> +	}
> +	lowcore_ptr->io_int_param = 0;
> +
> +	report(1, "CSS initialized");
>  }
>  
>  static struct {

