Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487A41FCA39
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 11:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgFQJyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 05:54:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33560 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgFQJyz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 05:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592387692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWRj4R3mtyJYcrPbSyH2aI8Q3wWLCi8uedkdMukjCws=;
        b=YFy3lPyfG7smWESeZUlgsVyD//dsJUX+EFIblWQi7TC03eGpCKhHR8BV0g7utCtzXMDrCl
        bJnmCy4L1Eh6s0COehvzL13bSB0UO3sFWjR3g94dv5w/u2mcTMH4Jg43HA2v+tKjjVZ2Y0
        dAvr+iw5dhhmbxOseWmudty/xKYG5/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-2zpNrnMtOK6D6iJlRjD9ZQ-1; Wed, 17 Jun 2020 05:54:50 -0400
X-MC-Unique: 2zpNrnMtOK6D6iJlRjD9ZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 894CC101C2DF;
        Wed, 17 Jun 2020 09:54:49 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78FC619D7B;
        Wed, 17 Jun 2020 09:54:45 +0000 (UTC)
Date:   Wed, 17 Jun 2020 11:54:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 12/12] s390x: css: ssch/tsch with
 sense and interrupt
Message-ID: <20200617115442.036735c5.cohuck@redhat.com>
In-Reply-To: <1592213521-19390-13-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
        <1592213521-19390-13-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jun 2020 11:32:01 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> After a channel is enabled we start a SENSE_ID command using
> the SSCH instruction to recognize the control unit and device.
> 
> This tests the success of SSCH, the I/O interruption and the TSCH
> instructions.
> 
> The SENSE_ID command response is tested to report 0xff inside
> its reserved field and to report the same control unit type
> as the cu_type kernel argument.
> 
> Without the cu_type kernel argument, the test expects a device
> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.

0x3832 is any virtio-ccw device; you could also test for the cu model
to make sure that it is a net device, but that probably doesn't add
much additional coverage.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  20 +++++++
>  lib/s390x/css_lib.c |  46 +++++++++++++++
>  s390x/css.c         | 140 +++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 205 insertions(+), 1 deletion(-)

(...)

> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 06a76db..c3d93d3 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -128,3 +128,49 @@ retry:
>  		    schid, retry_count, pmcw->flags);
>  	return -1;
>  }
> +
> +int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
> +{
> +	struct orb orb = {
> +		.intparm = sid,
> +		.ctrl = ORB_CTRL_ISIC|ORB_CTRL_FMT|ORB_LPM_DFLT,
> +		.cpa = (unsigned int) (unsigned long)ccw,
> +	};
> +
> +	return ssch(sid, &orb);
> +}
> +
> +/*
> + * In the next revisions we will implement the possibility to handle
> + * CCW chains doing this we will need to work with ccw1 pointers.

"In the future, we want to implement support for CCW chains; for that,
we will need to work with ccw1 pointers."

?

> + * For now we only need a unique CCW.
> + */
> +static struct ccw1 unique_ccw;
> +
> +int start_subchannel(unsigned int sid, int code, void *data, int count,
> +		     unsigned char flags)
> +{
> +	int cc;
> +	struct ccw1 *ccw = &unique_ccw;

Hm... it might better to call this function "start_single_ccw" or
something like that.

> +
> +	report_prefix_push("start_subchannel");
> +	/* Build the CCW chain with a single CCW */
> +	ccw->code = code;
> +	ccw->flags = flags; /* No flags need to be set */
> +	ccw->count = count;
> +	ccw->data_address = (int)(unsigned long)data;
> +
> +	cc = start_ccw1_chain(sid, ccw);
> +	if (cc) {
> +		report(0, "start_ccw_chain failed ret=%d", cc);
> +		report_prefix_pop();
> +		return cc;
> +	}
> +	report_prefix_pop();
> +	return 0;
> +}
> +
> +int sch_read_len(int sid)
> +{
> +	return unique_ccw.count;
> +}

This function is very odd... it takes a subchannel id as a parameter,
which it ignores, and instead returns the count field of the static ccw
used when starting I/O. What is the purpose of this function? Grab the
data length for the last I/O operation that was started on the
subchannel? If yes, it might be better to store that information along
with the sid? If it is the length for the last I/O operation that the
code _thinks_ it started, it might be better to reuse that information
from further up in the function instead.

> diff --git a/s390x/css.c b/s390x/css.c
> index 6948d73..6b618a1 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -16,10 +16,18 @@
>  #include <string.h>
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
> +#include <kernel-args.h>
>  
>  #include <css.h>
>  
> +#define DEFAULT_CU_TYPE		0x3832

Maybe append /* virtio-ccw */

> +static unsigned long cu_type = DEFAULT_CU_TYPE;
> +
> +struct lowcore *lowcore = (void *)0x0;
> +
>  static int test_device_sid;
> +static struct irb irb;
> +static struct senseid senseid;
>  
>  static void test_enumerate(void)
>  {
> @@ -45,20 +53,150 @@ static void test_enable(void)
>  	report(cc == 0, "Enable subchannel %08x", test_device_sid);
>  }
>  
> +static void enable_io_isc(void)
> +{
> +	/* Let's enable all ISCs for I/O interrupt */
> +	lctlg(6, 0x00000000ff000000);
> +}
> +
> +static void irq_io(void)
> +{
> +	int ret = 0;
> +	char *flags;
> +	int sid;
> +
> +	report_prefix_push("Interrupt");
> +	/* Lowlevel set the SID as interrupt parameter. */
> +	if (lowcore->io_int_param != test_device_sid) {
> +		report(0,
> +		       "Bad io_int_param: %x expected %x",
> +		       lowcore->io_int_param, test_device_sid);
> +		goto pop;
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("tsch");
> +	sid = lowcore->subsys_id_word;
> +	ret = tsch(sid, &irb);
> +	switch (ret) {
> +	case 1:
> +		dump_irb(&irb);
> +		flags = dump_scsw_flags(irb.scsw.ctrl);
> +		report(0,
> +		       "I/O interrupt, CC 1 but tsch reporting sch %08x as not status pending: %s",
> +		       sid, flags);
> +		break;
> +	case 2:
> +		report(0, "tsch returns unexpected CC 2");
> +		break;
> +	case 3:
> +		report(0, "tsch reporting sch %08x as not operational", sid);
> +		break;
> +	case 0:
> +		/* Stay humble on success */
> +		break;
> +	}
> +pop:
> +	report_prefix_pop();
> +	lowcore->io_old_psw.mask &= ~PSW_MASK_WAIT;
> +}
> +
> +/*
> + * test_sense
> + * Pre-requisits:
> + * - We need the test device as the first recognized
> + *   device by the enumeration.
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
> +	ret = css_enable(test_device_sid);
> +	if (ret) {
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
> +	memset(&senseid, 0, sizeof(senseid));
> +	ret = start_subchannel(test_device_sid, CCW_CMD_SENSE_ID,
> +			       &senseid, sizeof(senseid), CCW_F_SLI);
> +	if (ret) {
> +		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
> +		       test_device_sid, ret);
> +		goto unreg_cb;
> +	}
> +
> +	wait_for_interrupt(PSW_MASK_IO);
> +
> +	ret = sch_read_len(test_device_sid);
> +	if (ret < CSS_SENSEID_COMMON_LEN) {
> +		report(0,
> +		       "ssch succeeded for SENSE ID but report a too short length: %d",
> +		       ret);
> +		goto unreg_cb;
> +	}

Oh, so you want to check something even different: You know what you
put in the request, and you expect a certain minimal length back. But
that length is contained in the scsw, not in the started ccw, isn't it?

> +
> +	if (senseid.reserved != 0xff) {
> +		report(0,
> +		       "ssch succeeded for SENSE ID but reports garbage: %x",
> +		       senseid.reserved);
> +		goto unreg_cb;
> +	}
> +
> +	if (lowcore->io_int_param != test_device_sid)
> +		goto unreg_cb;

You probably want to check this further up? But doesn't irq_io()
already check this?

> +
> +	report_info("senseid length read: %d", ret);
> +	report_info("reserved %02x cu_type %04x cu_model %02x dev_type %04x dev_model %02x",
> +		    senseid.reserved, senseid.cu_type, senseid.cu_model,
> +		    senseid.dev_type, senseid.dev_model);
> +
> +	report(senseid.cu_type == cu_type, "cu_type: expect 0x%04x got 0x%04x",
> +	       (uint16_t) cu_type, senseid.cu_type);
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
> +static unsigned long value;
> +
>  int main(int argc, char *argv[])
>  {
> -	int i;
> +	int i, ret;
> +
> +	ret = kernel_arg(argc, argv, "cu_type=", &value);
> +	if (!ret)
> +		cu_type = (uint16_t)value;
> +	else
> +		report_info("Using cu_type default value: 0x%04lx", cu_type);
>  
>  	report_prefix_push("Channel Subsystem");
> +	enable_io_isc();
>  	for (i = 0; tests[i].name; i++) {
>  		report_prefix_push(tests[i].name);
>  		tests[i].func();

