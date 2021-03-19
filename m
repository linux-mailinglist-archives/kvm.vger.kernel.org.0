Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A69341AA4
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 12:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCSLBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 07:01:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhCSLBQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 07:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616151676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWAZa32fvhswZthoCzKc0XITfC5qFoyAhLX2EeHybE4=;
        b=cGjNSgzfC4bX4MQdSA3SWGRmtU+oQUQDxwDqc67dXLBNtxS/9b3OXpeujUbESQt3XSmquu
        fSkVnUwbKOKNZ9Gq/gmPKD1Xohs2Sh/HgaP/cGSb8kZaMZNT8afmduo8fOhsWOAticJfSh
        Pc6TMVPgmgOznkzkw5sWReg6fufyzZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-ti_eso0rOB6WBcf7gzjreQ-1; Fri, 19 Mar 2021 07:01:14 -0400
X-MC-Unique: ti_eso0rOB6WBcf7gzjreQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89AF15704E;
        Fri, 19 Mar 2021 11:01:12 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1678710013D6;
        Fri, 19 Mar 2021 11:01:07 +0000 (UTC)
Date:   Fri, 19 Mar 2021 12:01:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 3/6] s390x: lib: css: upgrading IRQ
 handling
Message-ID: <20210319120105.182c8684.cohuck@redhat.com>
In-Reply-To: <1616073988-10381-4-git-send-email-pmorel@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
        <1616073988-10381-4-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Mar 2021 14:26:25 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Until now we had very few usage of interrupts, to be able to handle
> several interrupts coming up asynchronously we need to take care
> to save the previous interrupt before handling the next one.

An alternative would be to keep I/O interrupts disabled until you are
done with processing any information that might be overwritten.

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  29 +++++++++++
>  lib/s390x/css_lib.c | 117 ++++++++++++++++++++++++++++++++++----------
>  2 files changed, 120 insertions(+), 26 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 460b0bd..65fc335 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -425,4 +425,33 @@ struct measurement_block_format1 {
>  	uint32_t irq_prio_delay_time;
>  };
>  
> +struct irq_entry {
> +	struct irq_entry *next;
> +	struct irb irb;
> +	uint32_t sid;

I'm wondering whether that set of information make sense for saving.

We basically have some things in the lowcore that get overwritten by
subsequent I/O interrupts (in addition to the sid the intparm and the
interrupt identification word which contains the isc), and the irb,
which only gets overwritten if you do a tsch into the same memory area.
So, if you need to save some things, I'd suggest to add the intparm and
the interrupt identification word to it. Not sure whether the irb can
be handled independently? Need to read code first :)

> +};

(...)

> @@ -422,38 +464,38 @@ static struct irb irb;
>  void css_irq_io(void)
>  {
>  	int ret = 0;
> -	char *flags;
> -	int sid;
> +	struct irq_entry *irq;
>  
>  	report_prefix_push("Interrupt");
> -	sid = lowcore_ptr->subsys_id_word;
> +	irq = alloc_irq();
> +	assert(irq);
> +
> +	irq->sid = lowcore_ptr->subsys_id_word;
>  	/* Lowlevel set the SID as interrupt parameter. */
> -	if (lowcore_ptr->io_int_param != sid) {
> +	if (lowcore_ptr->io_int_param != irq->sid) {
>  		report(0,
>  		       "io_int_param: %x differs from subsys_id_word: %x",
> -		       lowcore_ptr->io_int_param, sid);
> +		       lowcore_ptr->io_int_param, irq->sid);
>  		goto pop;
>  	}
>  	report_prefix_pop();
>  
>  	report_prefix_push("tsch");
> -	ret = tsch(sid, &irb);
> +	ret = tsch(irq->sid, &irq->irb);
>  	switch (ret) {
>  	case 1:
> -		dump_irb(&irb);
> -		flags = dump_scsw_flags(irb.scsw.ctrl);
> -		report(0,
> -		       "I/O interrupt, but tsch returns CC 1 for subchannel %08x. SCSW flags: %s",
> -		       sid, flags);
> +		report_info("no status pending on %08x : %s", irq->sid,
> +			    dump_scsw_flags(irq->irb.scsw.ctrl));

This is not what you are looking at here, though?

The problem is that the hypervisor gave you cc 1 (stored, not status
pending) while you just got an interrupt; the previous message logged
that, while the new one does not. (The scsw flags are still
interesting, as it gives further information about the mismatch.)

>  		break;
>  	case 2:
>  		report(0, "tsch returns unexpected CC 2");
>  		break;
>  	case 3:
> -		report(0, "tsch reporting sch %08x as not operational", sid);
> +		report(0, "tsch reporting sch %08x as not operational", irq->sid);
>  		break;
>  	case 0:
>  		/* Stay humble on success */
> +		save_irq(irq);
>  		break;
>  	}
>  pop:
> @@ -498,47 +540,70 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>  int wait_and_check_io_completion(int schid)
>  {
>  	int ret = 0;
> -
> -	wait_for_interrupt(PSW_MASK_IO);
> +	struct irq_entry *irq = NULL;
>  
>  	report_prefix_push("check I/O completion");
>  
> -	if (lowcore_ptr->io_int_param != schid) {
> +	disable_io_irq();
> +	irq = get_irq();
> +	while (!irq) {
> +		wait_for_interrupt(PSW_MASK_IO);
> +		disable_io_irq();

Isn't the disable_io_irq() redundant here?

(In general, I'm a bit confused about the I/O interrupt handling here.
Might need to read through the whole thing again.)

> +		irq = get_irq();
> +		report_info("next try");
> +	}
> +	enable_io_irq();
> +
> +	assert(irq);
> +
> +	if (irq->sid != schid) {
>  		report(0, "interrupt parameter: expected %08x got %08x",
> -		       schid, lowcore_ptr->io_int_param);
> +		       schid, irq->sid);
>  		ret = -1;
>  		goto end;

You're still expecting that there's only one subchannel enabled for I/O
interrupts at the same time, right?

>  	}
>  
>  	/* Verify that device status is valid */
> -	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
> -		report(0, "No status pending after interrupt. Subch Ctrl: %08x",
> -		       irb.scsw.ctrl);
> -		ret = -1;
> +	if (!(irq->irb.scsw.ctrl & SCSW_SC_PENDING)) {

Confused. An I/O interrupt for a subchannel that is not status pending
is surely an issue?

> +		ret = 0;
>  		goto end;
>  	}
>  
> -	if (!(irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
> +	/* clear and halt pending are valid even without secondary or primary status */
> +	if (irq->irb.scsw.ctrl & (SCSW_FC_CLEAR | SCSW_FC_HALT)) {

Can you factor out the new/changed checks here into a separate patch?
Would make the change easier to follow.

Also, you might want to check other things for halt/clear as well?

> +		ret = 0;
> +		goto end;
> +	}
> +
> +	/* For start pending we need at least one of primary or secondary status */
> +	if (!(irq->irb.scsw.ctrl & (SCSW_SC_SECONDARY | SCSW_SC_PRIMARY))) {
>  		report(0, "Primary or secondary status missing. Subch Ctrl: %08x",
> -		       irb.scsw.ctrl);
> +		       irq->irb.scsw.ctrl);

I'm wondering whether that is actually true. Maybe need to double check
what happens with deferred ccs etc.

>  		ret = -1;
>  		goto end;
>  	}
>  
> -	if (!(irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
> +	/* For start pending we also need to have device or channel end information */
> +	if (!(irq->irb.scsw.dev_stat & (SCSW_DEVS_DEV_END | SCSW_DEVS_SCH_END))) {
>  		report(0, "No device end or sch end. Dev. status: %02x",
> -		       irb.scsw.dev_stat);
> +		       irq->irb.scsw.dev_stat);

Again, not sure whether that is true in any case (surely for the good
path, and I think for unit check as well; but ISTR that there can be
error conditions where we won't get another interrupt for the same I/O,
but device end is not set, because the error occurred before we even
reached the device... should those be logged?)

>  		ret = -1;
>  		goto end;
>  	}
>  
> -	if (irb.scsw.sch_stat & ~SCSW_SCHS_IL) {
> -		report_info("Unexpected Subch. status %02x", irb.scsw.sch_stat);
> +	/* We only accept the SubCHannel Status for Illegal Length */

It's more like that we just don't deal with any of the other subchannel
status flags, right?

> +	if (irq->irb.scsw.sch_stat & ~SCSW_SCHS_IL) {
> +		report_info("Unexpected Subch. status %02x",
> +			    irq->irb.scsw.sch_stat);
>  		ret = -1;
>  		goto end;
>  	}
>  
>  end:
> +	if (ret)
> +		dump_irb(&irq->irb);
> +
> +	put_irq(irq);
>  	report_prefix_pop();
>  	return ret;
>  }

