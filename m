Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A37322B78
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 14:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhBWN3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 08:29:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232755AbhBWN3H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 08:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614086860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5VFS9IheNaRwVtaLk7fZ8B/Vddicb/zZXH2138JOcE=;
        b=bpn28QDVHOs2lT6LDRpki8WEwvHE0OuuyR1WXCqC3iy2WmnOlWseBG+XRWP7h2VP20uJcn
        OtLh9OBBrG0vjS2m3IXo+NLE7MpExg6Gqsm8zEAob/mawOQTjAguyS85Hdvq0QQ1Ou84i1
        4uV9/fuoIOUMHYQBcZsEQWWaDaW0qX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-ZtrkoKj8M2-MuedEBxvnjA-1; Tue, 23 Feb 2021 08:27:38 -0500
X-MC-Unique: ZtrkoKj8M2-MuedEBxvnjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3418106BB4C;
        Tue, 23 Feb 2021 13:27:37 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E7C110016FA;
        Tue, 23 Feb 2021 13:27:33 +0000 (UTC)
Date:   Tue, 23 Feb 2021 14:27:30 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: css: testing measurement
 block format 0
Message-ID: <20210223142730.4509bfc3.cohuck@redhat.com>
In-Reply-To: <1613669204-6464-5-git-send-email-pmorel@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
        <1613669204-6464-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 18:26:43 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We test the update of the measurement block format 0, the
> measurement block origin is calculated from the mbo argument
> used by the SCHM instruction and the offset calculated using
> the measurement block index of the SCHIB.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h | 12 +++++++++
>  s390x/css.c     | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
> 

(...)

> diff --git a/s390x/css.c b/s390x/css.c
> index fc693f3..b65aa89 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -191,6 +191,72 @@ static void test_schm(void)
>  	report_prefix_pop();
>  }
>  
> +#define SCHM_UPDATE_CNT 10
> +static bool start_measure(uint64_t mbo, uint16_t mbi, bool fmt1)

Maybe "start_measuring"? Or "start_measurements"?

> +{
> +	int i;
> +
> +	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
> +		report(0, "Enabling measurement_block_format");
> +		return false;
> +	}
> +
> +	for (i = 0; i < SCHM_UPDATE_CNT; i++) {
> +		if (!do_test_sense()) {
> +			report(0, "Error during sense");
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * test_schm_fmt0:
> + * With measurement block format 0 a memory space is shared
> + * by all subchannels, each subchannel can provide an index
> + * for the measurement block facility to store the measures.

s/measures/measurements/

> + */
> +static void test_schm_fmt0(void)
> +{
> +	struct measurement_block_format0 *mb0;
> +	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
> +
> +	report_prefix_push("Format 0");
> +
> +	/* Allocate zeroed Measurement block */
> +	mb0 = alloc_io_mem(shared_mb_size, 0);
> +	if (!mb0) {
> +		report_abort("measurement_block_format0 allocation failed");
> +		goto end;
> +	}
> +
> +	schm(NULL, 0); /* Stop any previous measurement */

Probably not strictly needed, but cannot hurt.

> +	schm(mb0, SCHM_MBU);
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index 0");
> +	report(start_measure(0, 0, false) &&
> +	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
> +	       "SSCH measured %d", mb0->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	/* Clear the measurement block for the next test */
> +	memset(mb0, 0, shared_mb_size);
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index 1");
> +	report(start_measure(0, 1, false) &&
> +	       mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
> +	       "SSCH measured %d", mb0[1].ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	schm(NULL, 0); /* Stop the measurement */

Shouldn't you call css_disable_mb() here as well?

> +	free_io_mem(mb0, shared_mb_size);
> +end:
> +	report_prefix_pop();
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -201,6 +267,7 @@ static struct {
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
> +	{ "measurement block format0", test_schm_fmt0 },
>  	{ NULL, NULL }
>  };
>  

