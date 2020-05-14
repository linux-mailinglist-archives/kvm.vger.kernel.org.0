Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3404A1D2F96
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgENMYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 08:24:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726345AbgENMYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 08:24:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589459061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5/2+2/oLzk3bZS5Lc98J2uG1FT9rgLkL5gmfXSANbpw=;
        b=CZSZGj/HRUO0aeMOPPB2TIqbc9/C+Mz/V0wxMqc0QILLZuCieLpvwu/JmpI08WPx2Z02Jg
        9C4xAwyylSuetFA5N34oeZPuoKkQNhUbRXQMlpwNQnANNtyoCZUkuFAqvhO/sNWvO/Jsaw
        8h2xMod4zH4fj3maFwvidJb24jN0fSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-VqxEizDbMG-pBBl-nHZNqQ-1; Thu, 14 May 2020 08:24:20 -0400
X-MC-Unique: VqxEizDbMG-pBBl-nHZNqQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3763D108BD13;
        Thu, 14 May 2020 12:24:19 +0000 (UTC)
Received: from gondolin (unknown [10.40.192.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA8285D9E8;
        Thu, 14 May 2020 12:24:14 +0000 (UTC)
Date:   Thu, 14 May 2020 14:24:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 09/10] s390x: css: ssch/tsch with
 sense and interrupt
Message-ID: <20200514142411.6e369fe4.cohuck@redhat.com>
In-Reply-To: <1587725152-25569-10-git-send-email-pmorel@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
        <1587725152-25569-10-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 12:45:51 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We add a new css_lib file to contain the I/O function we may

s/function/functions/

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
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |   1 +
>  lib/s390x/css.h          |  20 ++++++
>  lib/s390x/css_lib.c      |  55 +++++++++++++++
>  s390x/Makefile           |   1 +
>  s390x/css.c              | 149 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 226 insertions(+)
>  create mode 100644 lib/s390x/css_lib.c
> 

(...)

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
> +		       "I/O interrupt, but sch not status pending: %s", flags);

"...but tsch reporting sch as not status pending" ?

A buggy implementation might give the wrong cc for tsch, but still
indicate status pending in the control block.

> +		break;
> +	case 2:
> +		report(0, "TSCH returns unexpected CC 2");
> +		break;
> +	case 3:
> +		report(0, "Subchannel %08x not operational", sid);

"tsch reporting subchannel %08x as not operational" ?

> +		break;
> +	case 0:
> +		/* Stay humble on success */
> +		break;
> +	}
> +pop:
> +	report_prefix_pop();
> +	lowcore->io_old_psw.mask &= ~PSW_MASK_WAIT;
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
> +	ret = start_subchannel(CCW_CMD_SENSE_ID, &senseid, sizeof(senseid));

You're always send the full (extended) sense id block. What if the the
machine you're running on doesn't support extended sense id? Would the
SLI ccw flag help?

> +	if (!ret) {
> +		report(0, "start_senseid failed");

"ssch failed for SENSE ID on sch <sch>" ?

> +		goto unreg_cb;
> +	}
> +
> +	wfi(PSW_MASK_IO);
> +
> +	if (lowcore->io_int_param != test_device_sid) {
> +		report(0,
> +		       "No interrupts. io_int_param: expect 0x%08x, got 0x%08x",
> +		       test_device_sid, lowcore->io_int_param);

Doesn't irq_io() already moan here?

> +		goto unreg_cb;
> +	}
> +
> +	report_info("reserved %02x cu_type %04x cu_model %02x dev_type %04x dev_model %02x",
> +		    senseid.reserved, senseid.cu_type, senseid.cu_model,
> +		    senseid.dev_type, senseid.dev_model);
> +
> +	if (senseid.cu_type == PONG_CU)
> +		report(1, "cu_type: expect 0x%04x got 0x%04x",
> +		       PONG_CU_TYPE, senseid.cu_type);
> +	else
> +		report(0, "cu_type: expect 0x%04x got 0x%04x",
> +		       PONG_CU_TYPE, senseid.cu_type);
> +
> +unreg_cb:
> +	unregister_io_int_func(irq_io);
> +}
> +

