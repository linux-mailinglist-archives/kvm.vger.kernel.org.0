Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED035319D29
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 12:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBLLR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 06:17:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhBLLRY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 06:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613128557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17yJ1jw3xbqfxBt88m+skOHFcZW/nd7tq99klhh9LIA=;
        b=eIzOZJH2Y8rV3JcAjcMjs8AyQ2lFoT7MMzplrrK36d4pxyBx2jKOZtkD0Qe02dj3ZNQPIx
        bMWFr6sFex9h+Rehnl4jy26fbX9N6ZZCvqOUcqNkEN4PEllvPiCYqZpOoE9ubfbiE0aVw8
        Do8duUB/2NrZSVeyHqLARGv0TPFBkSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-E6B6qlt9P5yG0OReY0UpyQ-1; Fri, 12 Feb 2021 06:15:53 -0500
X-MC-Unique: E6B6qlt9P5yG0OReY0UpyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2697871220;
        Fri, 12 Feb 2021 11:15:52 +0000 (UTC)
Received: from gondolin (ovpn-113-189.ams2.redhat.com [10.36.113.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AF9A60BF1;
        Fri, 12 Feb 2021 11:15:47 +0000 (UTC)
Date:   Fri, 12 Feb 2021 12:15:45 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: css: testing measurement
 block format 1
Message-ID: <20210212121545.44e13bd8.cohuck@redhat.com>
In-Reply-To: <1612963214-30397-6-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
        <1612963214-30397-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Feb 2021 14:20:14 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Measurement block format 1 is made available by the extended
> mesurement block facility and is indicated in the SCHIB by

s/mesurement/measurement/

> the bit in the PMCW.
> 
> The MBO is specified in the SCHIB of each channel and the MBO
> defined by the SCHM instruction is ignored.
> 
> The test of the MB format 1 is just skipped if the feature is
> not available.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h | 14 ++++++++++++++
>  s390x/css.c     | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)

(...)

> +static void test_schm_fmt1(void)
> +{
> +	struct measurement_block_format1 *mb1;
> +
> +	report_prefix_push("Format 1");
> +
> +	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
> +	if (!mb1) {
> +		report_abort("measurement_block_format1 allocation failed");
> +		goto end;
> +	}
> +
> +	schm(NULL, 0); /* Clear previous MB address */

Same comment as for the last patch.

> +	schm(0, SCHM_MBU);
> +
> +	/* Expect error for non aligned MB */
> +	report_prefix_push("Unaligned MB origin");
> +	report_xfail(start_measure((u64)mb1 + 1, 0, true), mb1->ssch_rsch_count != 0,
> +		     "SSCH measured %d", mb1->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	memset(mb1, 0, sizeof(*mb1));
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index");
> +	report(start_measure((u64)mb1, 0, true) &&
> +	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
> +	       "SSCH measured %d", mb1->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	free_io_mem(mb1, sizeof(struct measurement_block_format1));

Also here, you need to stop the measurements before freeing the block.

> +end:
> +	report_prefix_pop();
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -257,6 +292,7 @@ static struct {
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
>  	{ "measurement block format0", test_schm_fmt0 },
> +	{ "measurement block format1", test_schm_fmt1 },
>  	{ NULL, NULL }
>  };
>  

