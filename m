Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337671172A8
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfLIRWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:22:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39430 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfLIRWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:22:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575912152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=noDkAJEmQu0wtJN53uMOBzDUnhFTHRn2FT5y0EkBN34=;
        b=cDjiIqkgi4AlwuaIYQB2X0miztMDC4FNegS4bEqpxyvKvHyjj6DyFuV+qgPeJSpDFh2ShE
        MnXuNNKGbYE/BQ23uORL9FnlY5lZunX5G+lejBvmxCv1z9TFVtorPiqRCusETn9Eg2Ul/8
        04MPhm+oMRLUsTmIBjFsJZoGyzCmQOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-EiYsUmQ5PNy3JXj9ilaNBQ-1; Mon, 09 Dec 2019 12:22:29 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D944100A176;
        Mon,  9 Dec 2019 17:22:27 +0000 (UTC)
Received: from gondolin (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8152A4B8F;
        Mon,  9 Dec 2019 17:22:15 +0000 (UTC)
Date:   Mon, 9 Dec 2019 18:22:13 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 8/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20191209182213.69e14263.cohuck@redhat.com>
In-Reply-To: <1575649588-6127-9-git-send-email-pmorel@linux.ibm.com>
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
        <1575649588-6127-9-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: EiYsUmQ5PNy3JXj9ilaNBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  6 Dec 2019 17:26:27 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> When a channel is enabled we can start a SENSE command using the SSCH
> instruction to recognize the control unit and device.
> 
> This tests the success of SSCH, the I/O interruption and the TSCH
> instructions.
> 
> The test expects a device with a control unit type of 0xC0CA as the
> first subchannel of the CSS.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h |  13 ++++
>  s390x/css.c     | 164 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 177 insertions(+)
> 

> +static void irq_io(void)
> +{
> +	int ret = 0;
> +	char *flags;
> +
> +	report_prefix_push("Interrupt");
> +	if (lowcore->io_int_param != 0xcafec0ca) {
> +		report("Bad io_int_param: %x", 0, lowcore->io_int_param);

Use a #define for the intparm and print got vs. expected on mismatch?

> +		report_prefix_pop();
> +		return;
> +	}
> +	report("io_int_param: %x", 1, lowcore->io_int_param);

Well, at that moment you already know what the intparm is, don't you? :)

> +	report_prefix_pop();
> +
> +	ret = tsch(lowcore->subsys_id_word, &irb);
> +	dump_irb(&irb);
> +	flags = dump_scsw_flags(irb.scsw.ctrl);
> +
> +	if (ret)
> +		report("IRB scsw flags: %s", 0, flags);

I think you should also distinguish between cc 1 (not status pending)
and cc 3 (not operational) here (or at least also print that info).

> +	else
> +		report("IRB scsw flags: %s", 1, flags);
> +	report_prefix_pop();
> +}
> +
> +static int start_subchannel(int code, char *data, int count)
> +{
> +	int ret;
> +	struct pmcw *p = &schib.pmcw;
> +	struct orb *orb_p = &orb[0];
> +
> +	/* Verify that a test subchannel has been set */
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return 0;
> +	}
> +
> +	/* Verify that the subchannel has been enabled */
> +	ret = stsch(test_device_sid, &schib);
> +	if (ret) {
> +		report("Err %d on stsch on sid %08x", 0, ret, test_device_sid);
> +		return 0;
> +	}
> +	if (!(p->flags & PMCW_ENABLE)) {
> +		report_skip("Device (sid %08x) not enabled", test_device_sid);
> +		return 0;
> +	}
> +
> +	report_prefix_push("Start Subchannel");
> +	/* Build the CCW chain with a single CCW */
> +	ccw[0].code = code;
> +	ccw[0].flags = 0; /* No flags need to be set */
> +	ccw[0].count = count;
> +	ccw[0].data_address = (int)(unsigned long)data;
> +	orb_p->intparm = 0xcafec0ca;
> +	orb_p->ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
> +	if ((unsigned long)&ccw[0] >= 0x80000000UL) {
> +		report("Data above 2G! %016lx", 0, (unsigned long)&ccw[0]);

Check for data under 2G before you set up data_address as well?

> +		report_prefix_pop();
> +		return 0;
> +	}
> +	orb_p->cpa = (unsigned int) (unsigned long)&ccw[0];
> +
> +	ret = ssch(test_device_sid, orb_p);
> +	if (ret) {
> +		report("ssch cc=%d", 0, ret);
> +		report_prefix_pop();
> +		return 0;
> +	}
> +	report_prefix_pop();
> +	return 1;
> +}
> +
> +/*
> + * test_sense
> + * Pre-requisits:
> + * 	We need the QEMU PONG device as the first recognized
> + *	device by the enumeration.
> + *	./s390x-run s390x/css.elf -device ccw-pong,cu_type=0xc0ca
> + */
> +static void test_sense(void)
> +{
> +	int ret;
> +
> +	ret = register_io_int_func(irq_io);
> +	if (ret) {
> +		report("Could not register IRQ handler", 0);
> +		goto unreg_cb;
> +	}
> +
> +	enable_io_irq();
> +
> +	ret = start_subchannel(CCW_CMD_SENSE_ID, buffer, sizeof(senseid));
> +	if (!ret) {
> +		report("start_subchannel failed", 0);
> +		goto unreg_cb;
> +	}
> +
> +	senseid.cu_type = buffer[2] | (buffer[1] << 8);
> +	delay(100);

Hm... registering an interrupt handler and then doing a random delay
seems a bit odd. I'd rather expect something like

(a) check for an indication that an interrupt has arrived (global
    variable)
(b) wait for a bit
(c) if timeout has not yet been hit: goto (a)

Or do a tpi loop, if this can't be done fully asynchronous?

Also, I don't understand what you are doing with the buffer and
senseid: Can't you make senseid a pointer to buffer, so that it can
simply access the fields after they have been filled by sense id?

Lastly, it might make sense if the reserved field of senseid has been
filled with 0xff; that way you can easily distinguish 'device is not a
pong device' from 'senseid has not been filled out correctly'.

> +
> +	/* Sense ID is non packed cut_type is at offset +1 byte */
> +	if (senseid.cu_type == PONG_CU)
> +		report("cu_type: expect c0ca, got %04x", 1, senseid.cu_type);
> +	else
> +		report("cu_type: expect c0ca, got %04x", 0, senseid.cu_type);
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

