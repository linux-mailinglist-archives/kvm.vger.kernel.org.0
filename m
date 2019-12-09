Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151C5116C8E
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 12:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLILwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 06:52:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29628 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727074AbfLILwp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 06:52:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575892363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=HO9YnI0edOq15BVVil81KEHXKZDdMZ9PkpOq5nGxdek=;
        b=TNgusKRfFOnTlklcyLEMgwO9Wkop6CL5w6nOAdt0YWxsjqgLsJWY6gpwYXjnEPbMTdyvvt
        N3H7tCyJCvc3UdjGL/4pYShxRA9ALBhBWL4GAcfFalslR/odjQHwvI8HUZuUX06rJg+IkG
        WFspBL8Er48mQr34C4tA7e0ZzQNeVsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-11XjnCPsPQ-HhTiJN_05Sg-1; Mon, 09 Dec 2019 06:52:40 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E5C12A7E4C;
        Mon,  9 Dec 2019 11:52:39 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7251B5D9D6;
        Mon,  9 Dec 2019 11:52:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 6/9] s390x: css: stsch, enumeration test
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-7-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <977b5622-4890-19b5-693a-ae0295fcb883@redhat.com>
Date:   Mon, 9 Dec 2019 12:52:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1575649588-6127-7-git-send-email-pmorel@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 11XjnCPsPQ-HhTiJN_05Sg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2019 17.26, Pierre Morel wrote:
> First step for testing the channel subsystem is to enumerate the css and
> retrieve the css devices.
> 
> This tests the success of STSCH I/O instruction.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  s390x/Makefile      |  2 ++
>  s390x/css.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  4 files changed, 89 insertions(+)
>  create mode 100644 s390x/css.c
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 6f19bb5..d37227b 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -82,6 +82,7 @@ struct pmcw {
>  	uint8_t  chpid[8];
>  	uint16_t flags2;
>  };
> +#define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags >> 21)
>  
>  struct schib {
>  	struct pmcw pmcw;
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 3744372..9ebbb84 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
>  tests += $(TEST_DIR)/stsi.elf
>  tests += $(TEST_DIR)/skrf.elf
>  tests += $(TEST_DIR)/smp.elf
> +tests += $(TEST_DIR)/css.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> @@ -50,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
>  cflatobjs += lib/s390x/interrupt.o
>  cflatobjs += lib/s390x/mmu.o
>  cflatobjs += lib/s390x/smp.o
> +cflatobjs += lib/s390x/css_dump.o
>  
>  OBJDIRS += lib/s390x
>  
> diff --git a/s390x/css.c b/s390x/css.c
> new file mode 100644
> index 0000000..3d4a986
> --- /dev/null
> +++ b/s390x/css.c
> @@ -0,0 +1,82 @@
> +/*
> + * Channel Subsystem tests
> + *
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +
> +#include <css.h>
> +
> +#define SID_ONE		0x00010000
> +
> +static struct schib schib;
> +
> +static const char *Channel_type[4] = {
> +	"I/O", "CHSC", "MSG", "EADM"
> +};
> +
> +static int test_device_sid;
> +
> +static void test_enumerate(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int scn;
> +	int cc, i;
> +	int found = 0;
> +
> +	for (scn = 0; scn < 0xffff; scn++) {
> +		cc = stsch(scn|SID_ONE, &schib);
> +		if (!cc && (pmcw->flags & PMCW_DNV)) {
> +			report_info("SID %04x Type %s PIM %x", scn,
> +				     Channel_type[PMCW_CHANNEL_TYPE(pmcw)],
> +				     pmcw->pim);
> +			for (i = 0; i < 8; i++)  {
> +				if ((pmcw->pim << i) & 0x80) {
> +					report_info("CHPID[%d]: %02x", i,
> +						    pmcw->chpid[i]);
> +					break;
> +				}
> +			}
> +			found++;
> +		}
> +		if (cc == 3) /* cc = 3 means no more channel in CSS */
> +			break;
> +		if (found && !test_device_sid)
> +			test_device_sid = scn|SID_ONE;
> +	}
> +	if (!found) {
> +		report("Tested %d devices, none found", 0, scn);
> +		return;
> +	}
> +	report("Tested %d devices, %d found", 1, scn, found);

I'm sorry, but since last Friday, you now have to swap the first two
parameters of the report() function. (that was unfortunately necessary
to fix an issue with Clang)

 Thomas

