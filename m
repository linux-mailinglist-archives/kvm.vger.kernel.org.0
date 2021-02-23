Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9A1322B7C
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhBWNb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 08:31:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232655AbhBWNb1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 08:31:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614087000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSWdvo347njL+CLR2QBkSptIhJRRO13Vs6LTYTryDno=;
        b=ZbG/8aVbnba5N/AnoFSjmzonyY9MDVrOLt8F+BYj3vKH7CN87MdQ9Jb6+Pq9Wdj8W2aL7H
        O8PSOFCgqSjTi0miixdF+b0H+LeB8h2QYTKS7S8hgP1hZzpzX1Ea1AgciNJCKM76oqjlWt
        vNMk5CyJPttnUb7118bJcyTBp7yU3OM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-6H-3devQMIufPt1SXmOSuA-1; Tue, 23 Feb 2021 08:29:56 -0500
X-MC-Unique: 6H-3devQMIufPt1SXmOSuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA20B18B9EF0;
        Tue, 23 Feb 2021 13:29:54 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3320513F6;
        Tue, 23 Feb 2021 13:29:48 +0000 (UTC)
Date:   Tue, 23 Feb 2021 14:29:46 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 5/5] s390x: css: testing measurement
 block format 1
Message-ID: <20210223142946.2ac05ca7.cohuck@redhat.com>
In-Reply-To: <1613669204-6464-6-git-send-email-pmorel@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
        <1613669204-6464-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 18:26:44 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Measurement block format 1 is made available by the extended
> measurement block facility and is indicated in the SCHIB by
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
>  lib/s390x/css.h     | 16 ++++++++++++++
>  lib/s390x/css_lib.c | 25 ++++++++++++++++++++-
>  s390x/css.c         | 53 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+), 1 deletion(-)
> 

(...)

> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 4c8a6ae..1f09f93 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -298,7 +298,7 @@ static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
>  			pmcw->flags2 &= ~PMCW_MBF1;
>  
>  		pmcw->mbi = mbi;
> -		schib.mbo = mb;
> +		schib.mbo = mb & ~0x3f;

Merge this into the patch introducing the function?

>  	} else {
>  		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
>  	}
> @@ -527,3 +527,26 @@ void enable_io_isc(uint8_t isc)
>  	value = (uint64_t)isc << 24;
>  	lctlg(6, value);
>  }
> +
> +void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report(0, "stsch: sch %08x failed with cc=%d", schid, cc);
> +		return;
> +	}
> +
> +	/* Update the SCHIB to enable the measurement block */
> +	pmcw->flags |= PMCW_MBUE;
> +	pmcw->flags2 |= PMCW_MBF1;
> +	schib.mbo = mb;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	expect_pgm_int();
> +	cc = msch(schid, &schib);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +}
> diff --git a/s390x/css.c b/s390x/css.c
> index b65aa89..576df48 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -257,6 +257,58 @@ end:
>  	report_prefix_pop();
>  }
>  
> +/*
> + * test_schm_fmt1:
> + * With measurement block format 1 the mesurement block is
> + * dedicated to a subchannel.
> + */
> +static void test_schm_fmt1(void)
> +{
> +	struct measurement_block_format1 *mb1;
> +
> +	report_prefix_push("Format 1");
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		goto end;
> +	}
> +
> +	if (!css_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
> +		report_skip("Extended measurement block not available");
> +		goto end;
> +	}
> +
> +	/* Allocate zeroed Measurement block */
> +	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
> +	if (!mb1) {
> +		report_abort("measurement_block_format1 allocation failed");
> +		goto end;
> +	}
> +
> +	schm(NULL, 0); /* Stop any previous measurement */
> +	schm(0, SCHM_MBU);
> +
> +	/* Expect error for non aligned MB */
> +	report_prefix_push("Unaligned MB origin");
> +	msch_with_wrong_fmt1_mbo(test_device_sid, (uint64_t)mb1 + 1);
> +	report_prefix_pop();
> +
> +	/* Clear the measurement block for the next test */
> +	memset(mb1, 0, sizeof(*mb1));
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index");
> +	report(start_measure((u64)mb1, 0, true) &&
> +	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
> +	       "SSCH measured %d", mb1->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	schm(NULL, 0); /* Stop the measurement */

Same here, I think you should call css_disable_mb().

> +	free_io_mem(mb1, sizeof(struct measurement_block_format1));
> +end:
> +	report_prefix_pop();
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -268,6 +320,7 @@ static struct {
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
>  	{ "measurement block format0", test_schm_fmt0 },
> +	{ "measurement block format1", test_schm_fmt1 },
>  	{ NULL, NULL }
>  };
>  

