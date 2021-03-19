Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAEA342178
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhCSQKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:10:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhCSQJd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 12:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616170172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1I3gDClOrML3K1MwDJ3AQs0luwCHTgaIywIrNOZ7RnU=;
        b=HGYp/fIavSFAKRltESZ2SQbuWkBiVVeTvRKY44pXMzL3ZdO1FkPQ3CrEUozj52g2CC2gP8
        ZVMN+L6euGGpVtD4q1WazanywXl5U/Yc1eLJC0+NcZMjz3nQfsivDdvXT3map1Q0H5YKze
        dtkOS1SXJJpBWMyso+eHj26HvMKhdMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-aIQtqWArOvOtOHatcAZUpQ-1; Fri, 19 Mar 2021 12:09:27 -0400
X-MC-Unique: aIQtqWArOvOtOHatcAZUpQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD6F5800D53;
        Fri, 19 Mar 2021 16:09:26 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33C915C1D1;
        Fri, 19 Mar 2021 16:09:22 +0000 (UTC)
Date:   Fri, 19 Mar 2021 17:09:19 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 3/6] s390x: lib: css: upgrading IRQ
 handling
Message-ID: <20210319170919.172ee8d5.cohuck@redhat.com>
In-Reply-To: <d5e2e4cf-8f76-2099-f0d6-edcb32696bf2@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
        <1616073988-10381-4-git-send-email-pmorel@linux.ibm.com>
        <20210319120105.182c8684.cohuck@redhat.com>
        <d5e2e4cf-8f76-2099-f0d6-edcb32696bf2@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Mar 2021 16:55:15 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 3/19/21 12:01 PM, Cornelia Huck wrote:
> > On Thu, 18 Mar 2021 14:26:25 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:

> >> @@ -422,38 +464,38 @@ static struct irb irb;
> >>   void css_irq_io(void)
> >>   {
> >>   	int ret = 0;
> >> -	char *flags;
> >> -	int sid;
> >> +	struct irq_entry *irq;
> >>   
> >>   	report_prefix_push("Interrupt");
> >> -	sid = lowcore_ptr->subsys_id_word;
> >> +	irq = alloc_irq();
> >> +	assert(irq);
> >> +
> >> +	irq->sid = lowcore_ptr->subsys_id_word;
> >>   	/* Lowlevel set the SID as interrupt parameter. */
> >> -	if (lowcore_ptr->io_int_param != sid) {
> >> +	if (lowcore_ptr->io_int_param != irq->sid) {
> >>   		report(0,
> >>   		       "io_int_param: %x differs from subsys_id_word: %x",
> >> -		       lowcore_ptr->io_int_param, sid);
> >> +		       lowcore_ptr->io_int_param, irq->sid);
> >>   		goto pop;
> >>   	}
> >>   	report_prefix_pop();
> >>   
> >>   	report_prefix_push("tsch");
> >> -	ret = tsch(sid, &irb);
> >> +	ret = tsch(irq->sid, &irq->irb);
> >>   	switch (ret) {
> >>   	case 1:
> >> -		dump_irb(&irb);
> >> -		flags = dump_scsw_flags(irb.scsw.ctrl);
> >> -		report(0,
> >> -		       "I/O interrupt, but tsch returns CC 1 for subchannel %08x. SCSW flags: %s",
> >> -		       sid, flags);
> >> +		report_info("no status pending on %08x : %s", irq->sid,
> >> +			    dump_scsw_flags(irq->irb.scsw.ctrl));  
> > 
> > This is not what you are looking at here, though?
> > 
> > The problem is that the hypervisor gave you cc 1 (stored, not status
> > pending) while you just got an interrupt; the previous message logged
> > that, while the new one does not. (The scsw flags are still
> > interesting, as it gives further information about the mismatch.)  
> 
> I can keep the old message.
> How ever I do not think it is a reason to report a failure.
> Do you agree with replaacing report(0,) with report_info()

I don't really see how we could get an I/O interrupt for a subchannel
that is not status pending, unless we have other code racing with this
one that cleared the status pending already (and that would be a bug in
our test program.) Or are you aware in anything in the architecture
that could make the status pending go away again (other than the
subchannel becoming not operational?)

> 
> >   
> >>   		break;
> >>   	case 2:
> >>   		report(0, "tsch returns unexpected CC 2");
> >>   		break;
> >>   	case 3:
> >> -		report(0, "tsch reporting sch %08x as not operational", sid);
> >> +		report(0, "tsch reporting sch %08x as not operational", irq->sid);
> >>   		break;
> >>   	case 0:
> >>   		/* Stay humble on success */
> >> +		save_irq(irq);
> >>   		break;
> >>   	}
> >>   pop:
> >> @@ -498,47 +540,70 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
> >>   int wait_and_check_io_completion(int schid)
> >>   {
> >>   	int ret = 0;
> >> -
> >> -	wait_for_interrupt(PSW_MASK_IO);
> >> +	struct irq_entry *irq = NULL;
> >>   
> >>   	report_prefix_push("check I/O completion");
> >>   
> >> -	if (lowcore_ptr->io_int_param != schid) {
> >> +	disable_io_irq();
> >> +	irq = get_irq();
> >> +	while (!irq) {
> >> +		wait_for_interrupt(PSW_MASK_IO);
> >> +		disable_io_irq();  
> > 
> > Isn't the disable_io_irq() redundant here?  
> 
> No because wait for interrupt re-enable the interrupts
> I will add a comment

Hm, I thought it restored the previous status.

> 
> > 
> > (In general, I'm a bit confused about the I/O interrupt handling here.
> > Might need to read through the whole thing again.)

But also see this comment :)

> >   
> >> +		irq = get_irq();
> >> +		report_info("next try");
> >> +	}
> >> +	enable_io_irq();

