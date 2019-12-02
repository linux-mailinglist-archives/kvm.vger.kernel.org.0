Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F09310EB7B
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 15:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfLBOW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 09:22:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27548 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727493AbfLBOW7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 09:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575296577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5MF/rEETLV43mP1AEMANIzjKv5PYmqcOZr6C1sDB+pU=;
        b=Tbk+VVloSdeZ1CrmWHu8AEWa9x7z4Hr2/RYueZno7ipg67IQEHgqBKwYulg0Mz5XCbUpyi
        LuRDvvKuDgUpNa+w7oww2L4vfFY7F6uzZXNOex1Zt3OD46d0qmzgsTwOGKF/rT1qZRnBHi
        pRNa/kk9qJV6TGQAX2YjI0t4qDevung=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-3bGzX0UaNqCfJAVeRvC0qw-1; Mon, 02 Dec 2019 09:22:53 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEA1210054E3;
        Mon,  2 Dec 2019 14:22:52 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 118D010013A7;
        Mon,  2 Dec 2019 14:22:48 +0000 (UTC)
Date:   Mon, 2 Dec 2019 15:22:46 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/9] s390x: css: stsch, enumeration
 test
Message-ID: <20191202152246.4d627b0e.cohuck@redhat.com>
In-Reply-To: <1574945167-29677-7-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
        <1574945167-29677-7-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 3bGzX0UaNqCfJAVeRvC0qw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019 13:46:04 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> First step by testing the channel subsystem is to enumerate the css and

s/by/for/

> retrieve the css devices.
> 
> This test the success of STSCH I/O instruction.

s/test/tests/

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/Makefile      |  4 ++-
>  s390x/css.c         | 86 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  3 files changed, 93 insertions(+), 1 deletion(-)
>  create mode 100644 s390x/css.c
> 

(...)

> diff --git a/s390x/css.c b/s390x/css.c
> new file mode 100644
> index 0000000..8186f55
> --- /dev/null
> +++ b/s390x/css.c
> @@ -0,0 +1,86 @@
> +/*
> + * Channel Sub-System tests

s/Sub-System/Subsystem/

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
> +static const char *Channel_type[3] = {
> +	"I/O", "CHSC", "MSG"

No EADM? :)

I don't think we plan to emulate anything beyond I/O in QEMU, though.

> +};
> +
> +static int test_device_sid;
> +
> +static void test_enumerate(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int sid;
> +	int ret, i;
> +	int found = 0;
> +
> +	for (sid = 0; sid < 0xffff; sid++) {
> +		ret = stsch(sid|SID_ONE, &schib);

This seems a bit odd. You are basically putting the subchannel number
into sid, OR in the one, and then use the resulting value as the sid
(subchannel identifier).

> +		if (!ret && (pmcw->flags & PMCW_DNV)) {
> +			report_info("SID %04x Type %s PIM %x", sid,

That's not a sid, but the subchannel number (see above).

> +				     Channel_type[pmcw->st], pmcw->pim);
> +			for (i = 0; i < 8; i++)  {
> +				if ((pmcw->pim << i) & 0x80) {
> +					report_info("CHPID[%d]: %02x", i,
> +						    pmcw->chpid[i]);
> +					break;
> +				}
> +			}
> +			found++;
> +	
> +		}

Here, you iterate over the 0-0xffff range, even if you got a condition
code 3 (indicating no more subchannels in that set). Is that
intentional?

> +		if (found && !test_device_sid)
> +			test_device_sid = sid|SID_ONE;

You set test_device_sid to the last valid subchannel? Why?

> +	}
> +	if (!found) {
> +		report("Found %d devices", 0, found);
> +		return;
> +	}
> +	ret = stsch(test_device_sid, &schib);

Why do you do a stsch() again?

> +	if (ret) {
> +		report("Err %d on stsch on sid %08x", 0, ret, test_device_sid);
> +		return;
> +	}
> +	report("Tested", 1);
> +	return;

I don't think you need this return statement.

Your test only enumerates devices in the first subchannel set. Do you
plan to enhance the test to enable the MSS facility and iterate over
all subchannel sets?

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
> +	report_prefix_push("Channel Sub-System");

s/Sub-System/Subsystem/

> +	for (i = 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		tests[i].func();
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}

(...)

