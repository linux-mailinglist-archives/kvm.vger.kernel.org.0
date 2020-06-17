Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069151FC937
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 10:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgFQItK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 04:49:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgFQItJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 04:49:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592383747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+4Xq7y4rnuCEF/KPdw2fGtQ1+O064AYPQ/zMkG4Q04=;
        b=dIfctxcVQMweqRkhD6NEhc2Ja/6CUZ0wMsdYeR9R6k0e/Au1DZD8mrkR0o2V8jvMNdVa7D
        poC/WD+XfdZl3XnZr5AUE96GubYqGwJbF1pu5lu/ivjUGRD9d14+heU91DIDVi8dg2mJaC
        CsCDmN50MzWT60LcbjZqeBLHWWa75w4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-VrlLXOZAP6CdhFHj8CkkRg-1; Wed, 17 Jun 2020 04:49:05 -0400
X-MC-Unique: VrlLXOZAP6CdhFHj8CkkRg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9550F18A8227;
        Wed, 17 Jun 2020 08:49:04 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C16F19D7D;
        Wed, 17 Jun 2020 08:49:00 +0000 (UTC)
Date:   Wed, 17 Jun 2020 10:48:57 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 10/12] s390x: css: stsch, enumeration
 test
Message-ID: <20200617104857.1bdab6a5.cohuck@redhat.com>
In-Reply-To: <1592213521-19390-11-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
        <1592213521-19390-11-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jun 2020 11:31:59 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> First step for testing the channel subsystem is to enumerate the css and
> retrieve the css devices.

Maybe worth adding a note:

"We currently don't enable multiple subchannel sets and therefore only
look in subchannel set 0."

> 
> This tests the success of STSCH I/O instruction, we do not test the
> reaction of the VM for an instruction with wrong parameters.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css_lib.c | 70 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/Makefile      |  2 ++
>  s390x/css.c         | 55 +++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  4 files changed, 131 insertions(+)
>  create mode 100644 lib/s390x/css_lib.c
>  create mode 100644 s390x/css.c
> 
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> new file mode 100644
> index 0000000..b0a0294
> --- /dev/null
> +++ b/lib/s390x/css_lib.c
> @@ -0,0 +1,70 @@
> +/*
> + * Channel Subsystem tests library
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#include <libcflat.h>
> +#include <alloc_phys.h>
> +#include <asm/page.h>
> +#include <string.h>
> +#include <interrupt.h>
> +#include <asm/arch_def.h>
> +
> +#include <css.h>
> +
> +static struct schib schib;
> +
> +/*
> + * css_enumerate:
> + * On success return the first subchannel ID found.
> + * On error return an invalid subchannel ID containing cc
> + */
> +int css_enumerate(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int scn_found = 0;
> +	int dev_found = 0;
> +	int schid = 0;
> +	int cc;
> +	int scn;
> +
> +	for (scn = 0; scn < 0xffff; scn++) {
> +		cc = stsch(scn | SCHID_ONE, &schib);
> +		switch (cc) {
> +		case 0:		/* 0 means SCHIB stored */
> +			break;
> +		case 3:		/* 3 means no more channels */
> +			goto out;
> +		default:	/* 1 or 2 should never happened for STSCH */

s/happened/happen/

> +			report_abort("Unexpected error %d on subchannel %08x",
> +				     cc, scn | SCHID_ONE);
> +			return cc;
> +		}
> +
> +		/* We currently only support type 0, a.k.a. I/O channels */
> +		if (PMCW_CHANNEL_TYPE(pmcw) != 0)
> +			continue;
> +
> +		/* We ignore I/O channels without valid devices */
> +		scn_found++;
> +		if (!(pmcw->flags & PMCW_DNV))
> +			continue;
> +
> +		/* We keep track of the first device as our test device */
> +		if (!schid)
> +			schid = scn | SCHID_ONE;
> +		report_info("Found subchannel %08x", scn | SCHID_ONE);
> +		dev_found++;
> +	}
> +
> +out:
> +	report_info("Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
> +		    scn, scn_found, dev_found);
> +	return schid;
> +}

(...)

> diff --git a/s390x/css.c b/s390x/css.c
> new file mode 100644
> index 0000000..230adf5
> --- /dev/null
> +++ b/s390x/css.c
> @@ -0,0 +1,55 @@
> +/*
> + * Channel Subsystem tests
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_phys.h>
> +#include <asm/page.h>
> +#include <string.h>
> +#include <interrupt.h>
> +#include <asm/arch_def.h>
> +
> +#include <css.h>
> +
> +static int test_device_sid;
> +
> +static void test_enumerate(void)
> +{
> +	test_device_sid = css_enumerate();
> +	if (test_device_sid & SCHID_ONE) {
> +		report(1, "First device schid: 0x%08x", test_device_sid);

Maybe "Schid of first I/O device" ?

> +		return;
> +	}
> +	report(0, "No I/O device found");
> +}
> +
> +static struct {
> +	const char *name;
> +	void (*func)(void);
> +} tests[] = {
> +	{ "enumerate (stsch)", test_enumerate },
> +	{ NULL, NULL }
> +};
> +
> +int main(int argc, char *argv[])
> +{
> +	int i;
> +
> +	report_prefix_push("Channel Subsystem");
> +	for (i = 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		tests[i].func();
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

