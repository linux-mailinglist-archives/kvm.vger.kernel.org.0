Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5D82136A0
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 10:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgGCIll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 04:41:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53671 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725972AbgGCIll (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 04:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593765698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=r2jBZcuBwWGijXXDI7M2uXvkOIJpvB5u2D6velgT19I=;
        b=KEv/WHfs+uC8kME2LuJoWer8Qp/8rLHCiJg0LHIeBbtQR/UjWw9KyXZSTgkTQXwRU4A+gX
        rw/6ABoYY/H5to1GmHx5P54iZoKSH1n649LLQ+Tsw71dmuSgg0XRZOX5uMO2isvezzSxXg
        f7Apzhl76rwBIJDT5Nb4FR/XizqBinI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-P_eJTm3iMXu-XB-OdAQQMQ-1; Fri, 03 Jul 2020 04:41:37 -0400
X-MC-Unique: P_eJTm3iMXu-XB-OdAQQMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2B738015CB;
        Fri,  3 Jul 2020 08:41:35 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-87.ams2.redhat.com [10.36.112.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC3485F9DC;
        Fri,  3 Jul 2020 08:41:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v10 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, drjones@redhat.com
References: <1593707480-23921-1-git-send-email-pmorel@linux.ibm.com>
 <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d8b2ed8c-3948-1cba-47af-ef2a8cdf27ed@redhat.com>
Date:   Fri, 3 Jul 2020 10:41:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/07/2020 18.31, Pierre Morel wrote:
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
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
[...]
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 0ddceb1..9c22644 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -11,6 +11,8 @@
>  #ifndef CSS_H
>  #define CSS_H
>  
> +#define lowcore_ptr ((struct lowcore *)0x0)

I'd prefer if you could either put this into the css_lib.c file or in
lib/s390x/asm/arch_def.h.

>  /* subchannel ID bit 16 must always be one */
>  #define SCHID_ONE	0x00010000
>  
> @@ -62,9 +64,13 @@ struct orb {
>  } __attribute__ ((aligned(4)));
>  
>  struct scsw {
> +#define SCSW_SC_PENDING	0x00000001
> +#define SCSW_SC_PRIMARY	0x00000004
>  	uint32_t ctrl;
>  	uint32_t ccw_addr;
>  	uint8_t  dev_stat;
> +#define SCSW_SCHS_PCI	0x80
> +#define SCSW_SCHS_IL	0x40
>  	uint8_t  sch_stat;
>  	uint16_t count;
>  };
> @@ -73,6 +79,7 @@ struct pmcw {
>  	uint32_t intparm;
>  #define PMCW_DNV        0x0001
>  #define PMCW_ENABLE     0x0080
> +#define PMCW_ISC_SHIFT	11
>  	uint16_t flags;
>  	uint16_t devnum;
>  	uint8_t  lpm;
> @@ -100,6 +107,19 @@ struct irb {
>  	uint32_t emw[8];
>  } __attribute__ ((aligned(4)));
>  
> +#define CCW_CMD_SENSE_ID	0xe4
> +#define CSS_SENSEID_COMMON_LEN	8
> +struct senseid {
> +	/* common part */
> +	uint8_t reserved;        /* always 0x'FF' */
> +	uint16_t cu_type;        /* control unit type */
> +	uint8_t cu_model;        /* control unit model */
> +	uint16_t dev_type;       /* device type */
> +	uint8_t dev_model;       /* device model */
> +	uint8_t unused;          /* padding byte */
> +	uint8_t padding[256 - 10]; /* Extra padding for CCW */
> +} __attribute__ ((aligned(4))) __attribute__ ((packed));
> +
>  /* CSS low level access functions */
>  
>  static inline int ssch(unsigned long schid, struct orb *addr)
> @@ -251,6 +271,16 @@ void dump_orb(struct orb *op);
>  
>  int css_enumerate(void);
>  #define MAX_ENABLE_RETRIES      5
> -int css_enable(int schid);
> +int css_enable(int schid, int isc);
> +
> +

In case you respin: Remove one empty line?

> +/* Library functions */
> +int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
> +int start_single_ccw(unsigned int sid, int code, void *data, int count,
> +		     unsigned char flags);
> +void css_irq_io(void);
> +int css_residual_count(unsigned int schid);
>  
> +#define IO_SCH_ISC	3
> +void enable_io_isc(uint8_t isc);
>  #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 6e5ffed..249330f 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -16,6 +16,7 @@
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
>  #include <asm/time.h>
> +#include <asm/arch_def.h>
>  
>  #include <css.h>
>  
> @@ -70,7 +71,17 @@ out:
>  	return schid;
>  }
>  
> -int css_enable(int schid)
> +/*
> + * css_enable: enable Subchannel
> + * @schid: Subchannel Identifier
> + * @isc: Interruption subclass for this subchannel as a number
> + * Return value:
> + *   On success: 0
> + *   On error the CC of the faulty instruction
> + *      or -1 if the retry count is exceeded.
> + *
> + */
> +int css_enable(int schid, int isc)
>  {
>  	struct pmcw *pmcw = &schib.pmcw;
>  	int retry_count = 0;
> @@ -92,6 +103,9 @@ retry:
>  	/* Update the SCHIB to enable the channel */
>  	pmcw->flags |= PMCW_ENABLE;
>  
> +	/* Set Interruption Subclass to IO_SCH_ISC */
> +	pmcw->flags |= (isc << PMCW_ISC_SHIFT);
> +
>  	/* Tell the CSS we want to modify the subchannel */
>  	cc = msch(schid, &schib);
>  	if (cc) {
> @@ -114,6 +128,7 @@ retry:
>  		return cc;
>  	}
>  
> +	report_info("stsch: flags: %04x", pmcw->flags);
>  	if (pmcw->flags & PMCW_ENABLE) {
>  		report_info("stsch: sch %08x enabled after %d retries",
>  			    schid, retry_count);
> @@ -129,3 +144,134 @@ retry:
>  		    schid, retry_count, pmcw->flags);
>  	return -1;
>  }
> +
> +static struct irb irb;
> +
> +void css_irq_io(void)
> +{
> +	int ret = 0;
> +	char *flags;
> +	int sid;
> +
> +	report_prefix_push("Interrupt");
> +	sid = lowcore_ptr->subsys_id_word;
> +	/* Lowlevel set the SID as interrupt parameter. */
> +	if (lowcore_ptr->io_int_param != sid) {
> +		report(0,
> +		       "io_int_param: %x differs from subsys_id_word: %x",
> +		       lowcore_ptr->io_int_param, sid);
> +		goto pop;
> +	}
> +	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
> +			lowcore_ptr->subsys_id_word,
> +			lowcore_ptr->io_int_param,
> +			lowcore_ptr->io_int_word);
> +	report_prefix_pop();
> +
> +	report_prefix_push("tsch");
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
> +	lowcore_ptr->io_old_psw.mask &= ~PSW_MASK_WAIT;
> +}
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
> + * In the future, we want to implement support for CCW chains;
> + * for that, we will need to work with ccw1 pointers.
> + */
> +static struct ccw1 unique_ccw;
> +
> +int start_single_ccw(unsigned int sid, int code, void *data, int count,
> +		     unsigned char flags)
> +{
> +	int cc;
> +	struct ccw1 *ccw = &unique_ccw;
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
> +/*
> + * css_residual_count
> + * We expect no residual count when the ORB request was successful
> + * The residual count is valid when the subchannel is status pending
> + * with primary status and device status only or device status and
> + * subchannel status with PCI or incorrect length.
> + * Return value:
> + * Success: the residual count
> + * Not meaningful: -1 (-1 can not be a valid count)
> + */
> +int css_residual_count(unsigned int schid)
> +{
> +
> +	if (!(irb.scsw.ctrl & (SCSW_SC_PENDING | SCSW_SC_PRIMARY)))
> +		goto fail;
> +
> +	if (irb.scsw.dev_stat)
> +		if (irb.scsw.sch_stat & ~(SCSW_SCHS_PCI | SCSW_SCHS_IL))
> +			goto fail;
> +
> +	return irb.scsw.count;
> +
> +fail:
> +	report_info("sch  status %02x", irb.scsw.sch_stat);
> +	report_info("dev  status %02x", irb.scsw.dev_stat);
> +	report_info("ctrl status %08x", irb.scsw.ctrl);
> +	report_info("count       %04x", irb.scsw.count);
> +	report_info("ccw addr    %08x", irb.scsw.ccw_addr);
> +	return -1;
> +}
> +
> +/*
> + * enable_io_isc: setup ISC in Control Register 6
> + * @isc: The interruption Sub Class as a bitfield
> + */
> +void enable_io_isc(uint8_t isc)
> +{
> +	uint64_t value;
> +
> +	value = (uint64_t)isc << 24;
> +	lctlg(6, value);
> +}
> diff --git a/s390x/css.c b/s390x/css.c
> index 72aec43..60e6434 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -19,7 +19,11 @@
>  
>  #include <css.h>
>  
> +#define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
> +static unsigned long cu_type = DEFAULT_CU_TYPE;
> +
>  static int test_device_sid;
> +static struct senseid senseid;
>  
>  static void test_enumerate(void)
>  {
> @@ -40,17 +44,104 @@ static void test_enable(void)
>  		return;
>  	}
>  
> -	cc = css_enable(test_device_sid);
> +	cc = css_enable(test_device_sid, IO_SCH_ISC);
>  
>  	report(cc == 0, "Enable subchannel %08x", test_device_sid);
>  }
>  
> +/*
> + * test_sense
> + * Pre-requisits:
> + * - We need the test device as the first recognized
> + *   device by the enumeration.
> + */
> +static void test_sense(void)
> +{
> +	int ret;
> +	int len;
> +
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return;
> +	}
> +
> +	ret = css_enable(test_device_sid, IO_SCH_ISC);
> +	if (ret) {
> +		report(0,
> +		       "Could not enable the subchannel: %08x",
> +		       test_device_sid);
> +		return;
> +	}
> +
> +	ret = register_io_int_func(css_irq_io);
> +	if (ret) {
> +		report(0, "Could not register IRQ handler");
> +		goto unreg_cb;
> +	}
> +
> +	lowcore_ptr->io_int_param = 0;
> +
> +	memset(&senseid, 0, sizeof(senseid));
> +	ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
> +			       &senseid, sizeof(senseid), CCW_F_SLI);
> +	if (ret) {
> +		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
> +		       test_device_sid, ret);
> +		goto unreg_cb;
> +	}

I'd maybe rather do something like:

	report(ret == 0, "SENSE ID on sch %08x has good CC (%d)", ...)
	if (ret)
		goto unreg_cb;

and avoid report(0, ...) statements. Also for the other tests below. But
maybe that's really just a matter of taste.

> +	wait_for_interrupt(PSW_MASK_IO);
> +
> +	if (lowcore_ptr->io_int_param != test_device_sid) {
> +		report(0, "ssch succeeded but interrupt parameter is wrong: expect %08x got %08x",
> +		       test_device_sid, lowcore_ptr->io_int_param);
> +		goto unreg_cb;
> +	}
> +
> +	ret = css_residual_count(test_device_sid);
> +	if (ret < 0) {
> +		report(0, "ssch succeeded for SENSE ID but can not get a valid residual count");
> +		goto unreg_cb;
> +	}
> +
> +	len = sizeof(senseid) - ret;
> +	if (ret && len < CSS_SENSEID_COMMON_LEN) {
> +		report(0,
> +		       "ssch succeeded for SENSE ID but report a too short length: %d",
> +		       ret);
> +		goto unreg_cb;
> +	}
> +
> +	if (ret && len)
> +		report_info("ssch succeeded for SENSE ID but report a shorter length: %d",
> +			    len);
> +
> +	if (senseid.reserved != 0xff) {
> +		report(0,
> +		       "ssch succeeded for SENSE ID but reports garbage: %x",
> +		       senseid.reserved);
> +		goto unreg_cb;
> +	}
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
> +	unregister_io_int_func(css_irq_io);
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
> @@ -59,6 +150,7 @@ int main(int argc, char *argv[])
>  	int i;
>  
>  	report_prefix_push("Channel Subsystem");
> +	enable_io_isc(0x80 >> IO_SCH_ISC);
>  	for (i = 0; tests[i].name; i++) {
>  		report_prefix_push(tests[i].name);
>  		tests[i].func();

Apart from the nits, I'm fine with the patch.

Acked-by: Thomas Huth <thuth@redhat.com>

