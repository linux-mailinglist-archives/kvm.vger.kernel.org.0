Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B5E332CC9
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCIRFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230527AbhCIRFa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 12:05:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615309529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZaPQle1s4vQJ7l/T/1jmE4NMxnXpoLBlxvr0zUvSN50=;
        b=e3o1D9o9yCk9Jc97Y68uwwTs3p5Z9BcPU/rWPP4Q6tkvdiWKSTXunv/rIev1BNd0ytrAUF
        rh7g1CQSUTm78A/QlVPFCI/km7gJEXc6IK0hNX9Vm3HnVmblYe07S6G+FmhvrtrzDWyjew
        Om2SThklcYOFo7FzHyIrppB6idqrJ70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-E0vHVWtbOR2wR-QAp_IqUQ-1; Tue, 09 Mar 2021 12:05:23 -0500
X-MC-Unique: E0vHVWtbOR2wR-QAp_IqUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8911B1084C99;
        Tue,  9 Mar 2021 17:05:21 +0000 (UTC)
Received: from gondolin (ovpn-113-144.ams2.redhat.com [10.36.113.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8BFC62665;
        Tue,  9 Mar 2021 17:05:06 +0000 (UTC)
Date:   Tue, 9 Mar 2021 18:05:04 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v5 5/6] s390x: css: testing measurement
 block format 0
Message-ID: <20210309180504.715b7997.cohuck@redhat.com>
In-Reply-To: <1615294277-7332-6-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
        <1615294277-7332-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Mar 2021 13:51:16 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We test the update of the measurement block format 0, the
> measurement block origin is calculated from the mbo argument
> used by the SCHM instruction and the offset calculated using
> the measurement block index of the SCHIB.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     | 12 ++++++
>  lib/s390x/css_lib.c |  4 --
>  s390x/css.c         | 95 ++++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 98 insertions(+), 13 deletions(-)
> 

(...)

> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 95d9a78..8f09383 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -365,10 +365,6 @@ void css_irq_io(void)
>  		       lowcore_ptr->io_int_param, sid);
>  		goto pop;
>  	}
> -	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
> -			lowcore_ptr->subsys_id_word,
> -			lowcore_ptr->io_int_param,
> -			lowcore_ptr->io_int_word);

Hm, why are you removing it? If you are doing some general cleanup, it
probably belongs into patch 2?

>  	report_prefix_pop();
>  
>  	report_prefix_push("tsch");
> diff --git a/s390x/css.c b/s390x/css.c
> index a763814..b63826e 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -74,18 +74,12 @@ static void test_sense(void)
>  		return;
>  	}
>  
> -	ret = register_io_int_func(css_irq_io);
> -	if (ret) {
> -		report(0, "Could not register IRQ handler");
> -		return;
> -	}
> -

This (and the cleanup changes) definitely belongs into patch 2.

>  	lowcore_ptr->io_int_param = 0;
>  
>  	senseid = alloc_io_mem(sizeof(*senseid), 0);
>  	if (!senseid) {
>  		report(0, "Allocation of senseid");
> -		goto error_senseid;
> +		return;
>  	}
>  
>  	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> @@ -137,8 +131,24 @@ error:
>  	free_io_mem(ccw, sizeof(*ccw));
>  error_ccw:
>  	free_io_mem(senseid, sizeof(*senseid));
> -error_senseid:
> -	unregister_io_int_func(css_irq_io);
> +}
> +
> +static void sense_id(void)
> +{
> +	struct ccw1 *ccw;
> +
> +	senseid = alloc_io_mem(sizeof(*senseid), 0);
> +	assert(senseid);
> +
> +	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> +	assert(ccw);

You're allocating senseid and ccw every time... wouldn't it be better
to allocate them once and pass them in as a parameter? (Not that it
should matter much, I guess.)

> +
> +	assert(!start_ccw1_chain(test_device_sid, ccw));
> +
> +	assert(wait_and_check_io_completion(test_device_sid) >= 0);
> +
> +	free_io_mem(ccw, sizeof(*ccw));
> +	free_io_mem(senseid, sizeof(*senseid));
>  }
>  
>  static void css_init(void)
> @@ -183,6 +193,72 @@ static void test_schm(void)
>  	report_prefix_pop();
>  }
>  
> +#define SCHM_UPDATE_CNT 10
> +static bool start_measuring(uint64_t mbo, uint16_t mbi, bool fmt1)
> +{
> +	int i;
> +
> +	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
> +		report_abort("Enabling measurement block failed");
> +		return false;
> +	}
> +
> +	for (i = 0; i < SCHM_UPDATE_CNT; i++)
> +		sense_id();
> +
> +	return true;
> +}
> +
> +/*
> + * test_schm_fmt0:
> + * With measurement block format 0 a memory space is shared
> + * by all subchannels, each subchannel can provide an index
> + * for the measurement block facility to store the measurements.
> + */
> +static void test_schm_fmt0(void)
> +{
> +	struct measurement_block_format0 *mb0;
> +	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	/* Allocate zeroed Measurement block */
> +	mb0 = alloc_io_mem(shared_mb_size, 0);
> +	if (!mb0) {
> +		report_abort("measurement_block_format0 allocation failed");
> +		return;
> +	}
> +
> +	schm(NULL, 0); /* Stop any previous measurement */
> +	schm(mb0, SCHM_MBU);
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index 0");
> +	report(start_measuring(0, 0, false) &&
> +	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
> +	       "SSCH measured %d", mb0->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	/* Clear the measurement block for the next test */
> +	memset(mb0, 0, shared_mb_size);
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index 1");
> +	if (start_measuring(0, 1, false))
> +		report(mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
> +		       "SSCH measured %d", mb0[1].ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	/* Stop the measurement */
> +	css_disable_mb(test_device_sid);
> +	schm(NULL, 0);
> +
> +	free_io_mem(mb0, shared_mb_size);
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -193,6 +269,7 @@ static struct {
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
> +	{ "measurement block format0", test_schm_fmt0 },
>  	{ NULL, NULL }
>  };
>  

