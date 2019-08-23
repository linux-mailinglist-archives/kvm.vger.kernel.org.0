Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C549AD86
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390489AbfHWKpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 06:45:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388010AbfHWKpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 06:45:00 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CD3D88306;
        Fri, 23 Aug 2019 10:44:59 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4855600CD;
        Fri, 23 Aug 2019 10:44:58 +0000 (UTC)
Date:   Fri, 23 Aug 2019 12:44:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] vfio-ccw: add some logging
Message-ID: <20190823124456.5230ed70.cohuck@redhat.com>
In-Reply-To: <81414605-c676-6e7e-4ee8-8dbfe7ae0a76@linux.ibm.com>
References: <20190816151505.9853-1-cohuck@redhat.com>
        <20190816151505.9853-2-cohuck@redhat.com>
        <81414605-c676-6e7e-4ee8-8dbfe7ae0a76@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 23 Aug 2019 10:44:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Aug 2019 11:54:26 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 8/16/19 11:15 AM, Cornelia Huck wrote:
> > Usually, the common I/O layer logs various things into the s390
> > cio debug feature, which has been very helpful in the past when
> > looking at crash dumps. As vfio-ccw devices unbind from the
> > standard I/O subchannel driver, we lose some information there.
> > 
> > Let's introduce some vfio-ccw debug features and log some things
> > there. (Unfortunately we cannot reuse the cio debug feature from
> > a module.)  
> 
> Boo :(

Yeah, that would have been even more useful :(

> 
> > 
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> >  drivers/s390/cio/vfio_ccw_drv.c     | 50 ++++++++++++++++++++++++++--
> >  drivers/s390/cio/vfio_ccw_fsm.c     | 51 ++++++++++++++++++++++++++++-
> >  drivers/s390/cio/vfio_ccw_ops.c     | 10 ++++++
> >  drivers/s390/cio/vfio_ccw_private.h | 17 ++++++++++
> >  4 files changed, 124 insertions(+), 4 deletions(-)
> >   
> 
> ...snip...
> 
> > diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> > index 49d9d3da0282..4a1e727c62d9 100644
> > --- a/drivers/s390/cio/vfio_ccw_fsm.c
> > +++ b/drivers/s390/cio/vfio_ccw_fsm.c  
> 
> ...snip...
> 
> > @@ -239,18 +258,32 @@ static void fsm_io_request(struct vfio_ccw_private *private,
> >  		/* Don't try to build a cp if transport mode is specified. */
> >  		if (orb->tm.b) {
> >  			io_region->ret_code = -EOPNOTSUPP;
> > +			VFIO_CCW_MSG_EVENT(2,
> > +					   "%pUl (%x.%x.%04x): transport mode\n",
> > +					   mdev_uuid(mdev), schid.cssid,
> > +					   schid.ssid, schid.sch_no);
> >  			errstr = "transport mode";
> >  			goto err_out;
> >  		}
> >  		io_region->ret_code = cp_init(&private->cp, mdev_dev(mdev),
> >  					      orb);
> >  		if (io_region->ret_code) {
> > +			VFIO_CCW_MSG_EVENT(2,
> > +					   "%pUl (%x.%x.%04x): cp_init=%d\n",
> > +					   mdev_uuid(mdev), schid.cssid,
> > +					   schid.ssid, schid.sch_no,
> > +					   io_region->ret_code);
> >  			errstr = "cp init";
> >  			goto err_out;
> >  		}
> >  
> >  		io_region->ret_code = cp_prefetch(&private->cp);
> >  		if (io_region->ret_code) {
> > +			VFIO_CCW_MSG_EVENT(2,
> > +					   "%pUl (%x.%x.%04x): cp_prefetch=%d\n",
> > +					   mdev_uuid(mdev), schid.cssid,
> > +					   schid.ssid, schid.sch_no,
> > +					   io_region->ret_code);
> >  			errstr = "cp prefetch";
> >  			cp_free(&private->cp);
> >  			goto err_out;
> > @@ -259,23 +292,36 @@ static void fsm_io_request(struct vfio_ccw_private *private,
> >  		/* Start channel program and wait for I/O interrupt. */
> >  		io_region->ret_code = fsm_io_helper(private);
> >  		if (io_region->ret_code) {
> > +			VFIO_CCW_MSG_EVENT(2,
> > +					   "%pUl (%x.%x.%04x): fsm_io_helper=%d\n",
> > +					   mdev_uuid(mdev), schid.cssid,
> > +					   schid.ssid, schid.sch_no,
> > +					   io_region->ret_code);  
> 
> I suppose these ones could be squashed into err_out, and use errstr as
> substitution for the message text.  But this is fine.
> 
> >  			errstr = "cp fsm_io_helper";
> >  			cp_free(&private->cp);
> >  			goto err_out;
> >  		}
> >  		return;
> >  	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
> > +		VFIO_CCW_MSG_EVENT(2,
> > +				   "%pUl (%x.%x.%04x): halt on io_region\n",
> > +				   mdev_uuid(mdev), schid.cssid,
> > +				   schid.ssid, schid.sch_no);
> >  		/* halt is handled via the async cmd region */
> >  		io_region->ret_code = -EOPNOTSUPP;
> >  		goto err_out;
> >  	} else if (scsw->cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
> > +		VFIO_CCW_MSG_EVENT(2,
> > +				   "%pUl (%x.%x.%04x): clear on io_region\n",
> > +				   mdev_uuid(mdev), schid.cssid,
> > +				   schid.ssid, schid.sch_no);  
> 
> The above idea would need errstr to be set to something other than
> "request" here, which maybe isn't a bad thing anyway.  :)

The trace event tries to cover all of the different error cases in one
go, so it is not quite optimal (but still useful). For the sprintf
event, I tried to include better error-specific information (also, I'm
probably a bit paranoid with regard to strings in the sprintf view :)

We could probably enhance the trace event here, and we should evaluate
adding more of them, as they and the dbf complement each other.

> 
> >  		/* clear is handled via the async cmd region */
> >  		io_region->ret_code = -EOPNOTSUPP;
> >  		goto err_out;
> >  	}
> >  
> >  err_out:
> > -	trace_vfio_ccw_io_fctl(scsw->cmd.fctl, get_schid(private),
> > +	trace_vfio_ccw_io_fctl(scsw->cmd.fctl, schid,
> >  			       io_region->ret_code, errstr);
> >  }
> >  

(...)

> This all looks pretty standard compared to the existing cio stuff, and
> would be a good addition for vfio-ccw.

I pretty much copied some of the basic stuff over. We can always add
more later :)

> 
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> 

Thanks!

I'll go ahead and queue this for the next release, unless someone
objects.
