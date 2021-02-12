Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF32319D20
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 12:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBLLOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 06:14:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhBLLOX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 06:14:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613128377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ja+9QvtFRC5vzb4SB/ON7VOK6ZLMQWc2RKbnFpTBT0A=;
        b=Ry2oVZt3uZJ5A6SGHfUIysnqmJmaPnLmbz4ic1fmLULpaI6XldDj5MosNXgoRauC5TeecG
        EEgs/1Ilhqgy0UTmEt3q5bsyWY0hHe5R3ju/58RWIaZ+hMe/QbVt+gQ48pyW8yxKwz8ikG
        Q7zJ3Zyl6WpKbrKgiPtXdv7gPpNTz0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-0bNkEUxuOEquAE-xmsTDIQ-1; Fri, 12 Feb 2021 06:12:55 -0500
X-MC-Unique: 0bNkEUxuOEquAE-xmsTDIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AF5C1007B15;
        Fri, 12 Feb 2021 11:12:54 +0000 (UTC)
Received: from gondolin (ovpn-113-189.ams2.redhat.com [10.36.113.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B020B67CE6;
        Fri, 12 Feb 2021 11:12:47 +0000 (UTC)
Date:   Fri, 12 Feb 2021 12:12:45 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] s390x: css: testing measurement
 block format 0
Message-ID: <20210212121245.061058ba.cohuck@redhat.com>
In-Reply-To: <1612963214-30397-5-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
        <1612963214-30397-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Feb 2021 14:20:13 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We tests the update of the mesurement block format 0, the

s/tests/test/
s/mesurement/measurement/

> mesurement block origin is calculated from the mbo argument
> used by the SCHM instruction and the offset calculated using
> the measurement block index of the SCHIB.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h | 14 +++++++++++++
>  s390x/css.c     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 

(...)

> +static void test_schm_fmt0(void)
> +{
> +	struct measurement_block_format0 *mb0;
> +
> +	report_prefix_push("Format 0");
> +
> +	mb0 = alloc_io_mem(sizeof(struct measurement_block_format0), 0);
> +	if (!mb0) {
> +		report_abort("measurement_block_format0 allocation failed");
> +		goto end;
> +	}
> +
> +	schm(NULL, 0); /* Clear previous MB address */

I think it would be better to clean out the mb after a particular test
has run, so that the following tests can start with a clean slate.

> +	schm(mb0, SCHM_MBU);
>  
> +	/* Expect error for non aligned MB */
> +	report_prefix_push("Unaligned MB index");
> +	report_xfail(start_measure(0, 0x01, false), mb0->ssch_rsch_count != 0,
> +		     "SSCH measured %d", mb0->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	memset(mb0, 0, sizeof(*mb0));
> +
> +	/* Expect success */
> +	report_prefix_push("Valid MB address and index");
> +	report(start_measure(0, 0, false) &&
> +	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
> +	       "SSCH measured %d", mb0->ssch_rsch_count);
> +	report_prefix_pop();
> +
> +	free_io_mem(mb0, sizeof(struct measurement_block_format0));

Before you free the memory, you really need to stop measurements
again... even though nothing happens right now, because you're not doing
I/O after this point.

> +end:
> +	report_prefix_pop();
>  }
>  
>  static struct {
> @@ -202,6 +256,7 @@ static struct {
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
>  	{ "measurement block (schm)", test_schm },
> +	{ "measurement block format0", test_schm_fmt0 },
>  	{ NULL, NULL }
>  };
>  

