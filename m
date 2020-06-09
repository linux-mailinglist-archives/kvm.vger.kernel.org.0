Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351531F3510
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 09:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFIHkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 03:40:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725948AbgFIHkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 03:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591688399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=WZwzMP1k1ndmRdarO3nApuGiXVv/vP51ZsfU96280tw=;
        b=DYp6mo9SCBzaxyDcHPTs72ZuaqMG1kGskBJUUL0cG/3XJNFWjTm9ajUmdWFQ2ob/SFQ9Fd
        GRvMEKbQj7+XhksHkJW/qwkZGipCV9MHnhBzEx8xDrMF7DeukZExHRzXRxH1O5Ouf+3hO6
        GynmaOTg7w2d5/2ktme/2bNYioha8fQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-4KhDgccVOFqsFL61qACNaA-1; Tue, 09 Jun 2020 03:39:48 -0400
X-MC-Unique: 4KhDgccVOFqsFL61qACNaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1816D107ACCA;
        Tue,  9 Jun 2020 07:39:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97E9810013D4;
        Tue,  9 Jun 2020 07:39:42 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 10/12] s390x: css: stsch, enumeration
 test
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-11-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <af39687e-4512-d147-5011-11d03b68e1bf@redhat.com>
Date:   Tue, 9 Jun 2020 09:39:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1591603981-16879-11-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/2020 10.12, Pierre Morel wrote:
> First step for testing the channel subsystem is to enumerate the css and
> retrieve the css devices.
> 
> This tests the success of STSCH I/O instruction, we do not test the
> reaction of the VM for an instruction with wrong parameters.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css_lib.c | 70 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/Makefile      |  2 ++
>  s390x/css.c         | 64 +++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  4 files changed, 140 insertions(+)
>  create mode 100644 lib/s390x/css_lib.c
>  create mode 100644 s390x/css.c
> 
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> new file mode 100644
> index 0000000..dc5a512
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
> +			report_info("Unexpected error %d on subchannel %08x",
> +				    cc, scn | SCHID_ONE);

Should this maybe even be a report_abort() instead? Or leave the error
reporting to the caller...

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
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 3cb97da..afd2c9b 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -17,6 +17,7 @@ tests += $(TEST_DIR)/stsi.elf
>  tests += $(TEST_DIR)/skrf.elf
>  tests += $(TEST_DIR)/smp.elf
>  tests += $(TEST_DIR)/sclp.elf
> +tests += $(TEST_DIR)/css.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> @@ -53,6 +54,7 @@ cflatobjs += lib/s390x/mmu.o
>  cflatobjs += lib/s390x/smp.o
>  cflatobjs += lib/s390x/kernel-args.o
>  cflatobjs += lib/s390x/css_dump.o
> +cflatobjs += lib/s390x/css_lib.o
>  
>  OBJDIRS += lib/s390x
>  
> diff --git a/s390x/css.c b/s390x/css.c
> new file mode 100644
> index 0000000..f0e8f47
> --- /dev/null
> +++ b/s390x/css.c
> @@ -0,0 +1,64 @@
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
> +		return;
> +	}
> +
> +	switch (test_device_sid) {
> +	case 0:
> +		report (0, "No I/O device found");
> +		break;
> +	default:	/* 1 or 2 should never happened for STSCH */
> +		report(0, "Unexpected cc=%d during enumeration",
> +		       test_device_sid);
> +			return;
> +	}

Ok, so here is now the test failure for the cc=1 or 2 that should never
happen. That means currently you print out the CC for this error twice.
One time should be enough, either here, or use an report_abort() in the
css_enumerate(), I'd say.

Anyway, can you please replace this switch statement with a "if
(!test_device_sid)" instead? Or do you plan to add more "case"
statements later?

 Thomas

