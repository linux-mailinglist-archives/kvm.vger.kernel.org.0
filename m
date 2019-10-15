Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEE1D77C3
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 15:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbfJONxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 09:53:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbfJONxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 09:53:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 174616907A;
        Tue, 15 Oct 2019 13:53:43 +0000 (UTC)
Received: from gondolin (dhcp-192-233.str.redhat.com [10.33.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6DA95C1D4;
        Tue, 15 Oct 2019 13:53:41 +0000 (UTC)
Date:   Tue, 15 Oct 2019 15:53:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] vfio-ccw: Trace the FSM jumptable
Message-ID: <20191015155339.0d714c75.cohuck@redhat.com>
In-Reply-To: <96431f2f-774c-0be2-54ef-ebcaa4ae7298@linux.ibm.com>
References: <20191014180855.19400-1-farman@linux.ibm.com>
        <20191014180855.19400-3-farman@linux.ibm.com>
        <96431f2f-774c-0be2-54ef-ebcaa4ae7298@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 15 Oct 2019 13:53:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Oct 2019 12:01:12 +0200
Steffen Maier <maier@linux.ibm.com> wrote:

> On 10/14/19 8:08 PM, Eric Farman wrote:
> > It would be nice if we could track the sequence of events within
> > vfio-ccw, based on the state of the device/FSM and our calling
> > sequence within it.  So let's add a simple trace here so we can
> > watch the states change as things go, and allow it to be folded
> > into the rest of the other cio traces.
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   drivers/s390/cio/vfio_ccw_private.h |  1 +
> >   drivers/s390/cio/vfio_ccw_trace.c   |  1 +
> >   drivers/s390/cio/vfio_ccw_trace.h   | 26 ++++++++++++++++++++++++++
> >   3 files changed, 28 insertions(+)

(...)

> > diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
> > index 2a2937a40124..24a8152acfdf 100644
> > --- a/drivers/s390/cio/vfio_ccw_trace.h
> > +++ b/drivers/s390/cio/vfio_ccw_trace.h
> > @@ -17,6 +17,32 @@
> > 
> >   #include <linux/tracepoint.h>
> > 
> > +TRACE_EVENT(vfio_ccw_fsm_event,
> > +	TP_PROTO(struct subchannel_id schid, int state, int event),
> > +	TP_ARGS(schid, state, event),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(u8, cssid)
> > +		__field(u8, ssid)
> > +		__field(u16, schno)
> > +		__field(int, state)
> > +		__field(int, event)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->cssid = schid.cssid;
> > +		__entry->ssid = schid.ssid;
> > +		__entry->schno = schid.sch_no;
> > +		__entry->state = state;
> > +		__entry->event = event;
> > +	),
> > +
> > +	TP_printk("schid=%x.%x.%04x state=%x event=%x",  
> 
> /sys/kernel/debug/tracing/events](0)# grep -R '%[^%]*x'
> 
> Many existing TPs often seem to format hex output with a 0x prefix (either 
> explicit with 0x%x or implicit with %#x). Since some of your other TPs also 
> output decimal integer values, I wonder if a distinction would help 
> unexperienced TP readers.

I generally agree. However, we explicitly don't want to do that for
schid formatting (as it should match the bus id). For event, it might
become relevant should we want to introduce a high number of new events
in the future (currently, there's a grand total of four events.)

> 
> > +		__entry->cssid, __entry->ssid, __entry->schno,
> > +		__entry->state,
> > +		__entry->event)
> > +);
> > +
> >   TRACE_EVENT(vfio_ccw_io_fctl,
> >   	TP_PROTO(int fctl, struct subchannel_id schid, int errno, char *errstr),
> >   	TP_ARGS(fctl, schid, errno, errstr),
> >   
> 
> 

