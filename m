Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881D710EBE3
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 15:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfLBOzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 09:55:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43297 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727362AbfLBOzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 09:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575298518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7+NT+nRoFU0sjsNvgM20HKCZwM7S6EELcwlN+zDwMvY=;
        b=Id8We91FtiWLBlg8P6mzeY0QN/pNnhVQY0uea+2XujTgKd+jIIjUjDDxz+xRa3AkmhwVV2
        Em2knsaTX6jaCE9oQWD5ZtZ7wHU87xSOfmBl2rmI5HPKzDCTLlvhVF2FaBxloMR0Qf8hPK
        9/krKnlNCxNjeQwGrBAIomH/1yedyHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-OpI7Z2yuNumx0vxDl9LzFA-1; Mon, 02 Dec 2019 09:55:17 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4229A8024E9;
        Mon,  2 Dec 2019 14:55:16 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F3085D6A0;
        Mon,  2 Dec 2019 14:55:12 +0000 (UTC)
Date:   Mon, 2 Dec 2019 15:55:10 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 8/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20191202155510.410666a0.cohuck@redhat.com>
In-Reply-To: <1574945167-29677-9-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
        <1574945167-29677-9-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: OpI7Z2yuNumx0vxDl9LzFA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019 13:46:06 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> When a channel is enabled we can start a SENSE command using the SSCH
> instruction to recognize the control unit and device.
> 
> This tests the success of SSCH, the I/O interruption and the TSCH
> instructions.
> 
> The test expect a device with a control unit type of 0xC0CA.

s/expect/expects/

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h |  13 +++++
>  s390x/css.c     | 137 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 150 insertions(+)
> 

(...)

> diff --git a/s390x/css.c b/s390x/css.c
> index e42dc2f..534864f 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -11,12 +11,28 @@
>   */
>  
>  #include <libcflat.h>
> +#include <alloc_phys.h>
> +#include <asm/page.h>
> +#include <string.h>
> +#include <asm/interrupt.h>
> +#include <asm/arch_def.h>
> +#include <asm/clock.h>
>  
>  #include <css.h>
>  
>  #define SID_ONE		0x00010000
> +#define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
> +
> +struct lowcore *lowcore = (void *)0x0;
>  
>  static struct schib schib;
> +#define NB_CCW  100

s/NB_CCW/NUM_CCWS/ ?

I was scratching my head a bit when I first saw that define.

> +static struct ccw ccw[NB_CCW];
> +#define NB_ORB  100
> +static struct orb orb[NB_ORB];
> +static struct irb irb;
> +static char buffer[0x1000] __attribute__ ((aligned(8)));
> +static struct senseid senseid;
>  
>  static const char *Channel_type[3] = {
>  	"I/O", "CHSC", "MSG"
> @@ -24,6 +40,34 @@ static const char *Channel_type[3] = {
>  
>  static int test_device_sid;
>  

(...)

> +void handle_io_int(void)
> +{
> +	int ret = 0;
> +	char *flags;
> +
> +	report_prefix_push("Interrupt");
> +	if (lowcore->io_int_param != 0xcafec0ca) {
> +		report("Bad io_int_param: %x", 0, lowcore->io_int_param);
> +		report_prefix_pop();
> +		return;
> +	}

Should you accommodate unsolicited interrupts as well?

> +	report("io_int_param: %x", 1, lowcore->io_int_param);
> +	report_prefix_pop();
> +
> +	ret = tsch(lowcore->subsys_id_word, &irb);
> +	dump_irb(&irb);
> +	flags = dump_scsw_flags(irb.scsw.ctrl);
> +
> +	if (ret)
> +		report("IRB scsw flags: %s", 0, flags);
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
> +	if (!test_device_sid) {
> +		report_skip("No device");
> +		return 0;
> +	}
> +	ret = stsch(test_device_sid, &schib);

That schib is a global variable, isn't it? Why do you need to re-check?

> +	if (ret) {
> +		report("Err %d on stsch on sid %08x", 0, ret, test_device_sid);
> +		return 0;
> +	}
> +	if (!(p->flags & PMCW_ENABLE)) {
> +		report_skip("Device (sid %08x) not enabled", test_device_sid);
> +		return 0;
> +	}
> +	ccw[0].code = code ;

Extra ' ' before ';'

> +	ccw[0].flags = CCW_F_PCI;

Huh, what's that PCI for?

> +	ccw[0].count = count;
> +	ccw[0].data = (int)(unsigned long)data;

Can you be sure that data is always below 2G?

> +	orb_p->intparm = 0xcafec0ca;
> +	orb_p->ctrl = ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
> +	orb_p->cpa = (unsigned int) (unsigned long)&ccw[0];
> +
> +	report_prefix_push("Start Subchannel");
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
> +static void test_sense(void)
> +{
> +	int success;
> +
> +	enable_io_irq();
> +
> +	success = start_subchannel(CCW_CMD_SENSE_ID, buffer, sizeof(senseid));
> +	if (!success) {
> +		report("start_subchannel failed", 0);
> +		return;
> +	}
> +
> +	senseid.cu_type = buffer[2] | (buffer[1] << 8);
> +	delay(1000);
> +
> +	/* Sense ID is non packed cut_type is at offset +1 byte */
> +	if (senseid.cu_type == PONG_CU)
> +		report("cu_type: expect c0ca, got %04x", 1, senseid.cu_type);
> +	else
> +		report("cu_type: expect c0ca, got %04x", 0, senseid.cu_type);
> +}

I'm not really convinced by that logic here. This will fall apart if
you don't have your pong device exactly in the right place, and it does
not make it easy to extend this for more devices in the future.

What about the following:
- do a stsch() loop (basically re-use your first patch)
- for each I/O subchannel with dnv=1, do SenseID
- use the first (?) device with a c0ca CU type as your test device

Or maybe I'm overthinking this? It just does not strike me as very
robust and reusable.

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

