Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A191E3EAE
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 12:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbgE0KJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 06:09:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57345 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729766AbgE0KJR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 06:09:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590574156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9HaviUrTiAbs1UoheBfRsIoYcyxJMuV7YIs0k4bLVxk=;
        b=h3dJzk4cS6N04zk3zbzAyh7neq3RjcfJcxabVJaEZm7SMnf3gl+0QTgrId3XP+g3oyki+z
        K4wx2rKMYHcU/lYP8f4hdeEVqsoi4fBSYWTtVaTdOEGhkme2TutIhHhNFnBqT090uFqBHQ
        KqsEBSZ3XUndX1qYtjmT5Ayvm6kmq90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-6PY6oArxMIyrvaxnJJym5Q-1; Wed, 27 May 2020 06:09:13 -0400
X-MC-Unique: 6PY6oArxMIyrvaxnJJym5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC52A8014D4;
        Wed, 27 May 2020 10:09:12 +0000 (UTC)
Received: from gondolin (ovpn-112-223.ams2.redhat.com [10.36.112.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9F7160C05;
        Wed, 27 May 2020 10:09:08 +0000 (UTC)
Date:   Wed, 27 May 2020 12:09:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 11/12] s390x: css: ssch/tsch with
 sense and interrupt
Message-ID: <20200527120905.5fb20a4e.cohuck@redhat.com>
In-Reply-To: <1589818051-20549-12-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-12-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 18:07:30 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We add a new css_lib file to contain the I/O functions we may
> share with different tests.
> First function is the subchannel_enable() function.
> 
> When a channel is enabled we can start a SENSE_ID command using
> the SSCH instruction to recognize the control unit and device.
> 
> This tests the success of SSCH, the I/O interruption and the TSCH
> instructions.
> 
> The test expects a device with a control unit type of 0xC0CA as the
> first subchannel of the CSS.

It might make sense to extend this to be able to check for any expected
type (e.g. 0x3832, should my suggestion to split css tests and css-pong
tests make sense.)

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  20 ++++++
>  lib/s390x/css_lib.c |  55 +++++++++++++++++
>  s390x/Makefile      |   1 +
>  s390x/css.c         | 145 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 221 insertions(+)
>  create mode 100644 lib/s390x/css_lib.c

(...)

> +int enable_subchannel(unsigned int sid)
> +{
> +	struct schib schib;
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int try_count = 5;
> +	int cc;
> +
> +	if (!(sid & SID_ONE))
> +		return -1;

Hm... this error is indistinguishable for the caller from a cc 1 for
the msch. Use something else (as this is a coding error)?

> +
> +	cc = stsch(sid, &schib);
> +	if (cc)
> +		return -cc;
> +
> +	do {
> +		pmcw->flags |= PMCW_ENABLE;
> +
> +		cc = msch(sid, &schib);
> +		if (cc)
> +			return -cc;
> +
> +		cc = stsch(sid, &schib);
> +		if (cc)
> +			return -cc;
> +
> +	} while (!(pmcw->flags & PMCW_ENABLE) && --try_count);
> +
> +	return try_count;

How useful is that information for the caller? I don't see the code
below making use of it.

> +}
> +
> +int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
> +{
> +	struct orb orb;
> +
> +	orb.intparm = sid;

Just an idea: If you use something else here (maybe the cpa), and set
the intparm to the sid in msch, you can test something else: Does msch
properly set the intparm, and is that intparm overwritten by a
successful ssch, until the next ssch or msch comes around?

> +	orb.ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
> +	orb.cpa = (unsigned int) (unsigned long)ccw;

Use a struct initializer, so that unset fields are 0?

> +
> +	return ssch(sid, &orb);
> +}

(...)

> +/*
> + * test_sense
> + * Pre-requisits:
> + * - We need the QEMU PONG device as the first recognized
> + *   device by the enumeration.
> + * - ./s390x-run s390x/css.elf -device ccw-pong,cu_type=0xc0ca
> + */
> +static void test_sense(void)
> +{
> +	int ret;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	ret = enable_subchannel(test_device_sid);
> +	if (ret < 0) {
> +		report(0,
> +		       "Could not enable the subchannel: %08x",
> +		       test_device_sid);
> +		return;
> +	}
> +
> +	ret = register_io_int_func(irq_io);
> +	if (ret) {
> +		report(0, "Could not register IRQ handler");
> +		goto unreg_cb;
> +	}
> +
> +	lowcore->io_int_param = 0;
> +
> +	ret = start_subchannel(CCW_CMD_SENSE_ID, &senseid, sizeof(senseid),
> +			       CCW_F_SLI);

Clear senseid, before actually sending the program?

> +	if (!ret) {
> +		report(0, "ssch failed for SENSE ID on sch %08x",
> +		       test_device_sid);
> +		goto unreg_cb;
> +	}
> +
> +	wait_for_interrupt(PSW_MASK_IO);
> +
> +	if (lowcore->io_int_param != test_device_sid)
> +		goto unreg_cb;
> +
> +	report_info("reserved %02x cu_type %04x cu_model %02x dev_type %04x dev_model %02x",
> +		    senseid.reserved, senseid.cu_type, senseid.cu_model,
> +		    senseid.dev_type, senseid.dev_model);
> +

I'd also recommend checking that senseid.reserved is indeed 0xff -- in
combination with senseid clearing before the ssch, that ensures that
the senseid structure has actually been written to and is not pure
garbage. (It's also a cu type agnostic test :)

It also might make sense to check how much data you actually got, as
you set SLI.


> +	report((senseid.cu_type == PONG_CU),
> +	       "cu_type: expect 0x%04x got 0x%04x",
> +	       PONG_CU_TYPE, senseid.cu_type);
> +
> +unreg_cb:
> +	unregister_io_int_func(irq_io);
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
>  } tests[] = {
>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
> +	{ "sense (ssch/tsch)", test_sense },
>  	{ NULL, NULL }
>  };
>  
> @@ -145,6 +289,7 @@ int main(int argc, char *argv[])
>  	int i;
>  
>  	report_prefix_push("Channel Subsystem");
> +	enable_io_isc();
>  	for (i = 0; tests[i].name; i++) {
>  		report_prefix_push(tests[i].name);
>  		tests[i].func();

