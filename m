Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60462191589
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 17:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgCXP7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:59:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20714 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728514AbgCXP7E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 11:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585065543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g9GH0AxTxxPnTMHoFAwV0WldN4rEqKu8hLAG7FJIXO4=;
        b=cz7NKrPL3hSddhC280qIjsg/azQAbf4v0gmP0arZklhGzG3CvHmmiecP8lSiGUPGTMYZwl
        vl0X4ImTj2HSSP6I4OD9gF9LtOeSU+hyzhe+EYQiT29Eia1hE0o7fJwDNf1KySKkZ3KTIq
        my0TnFDn8f5q5McRAz6wyMpdcSgisSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-OPqt8yezM1qi376RPohOXA-1; Tue, 24 Mar 2020 11:58:59 -0400
X-MC-Unique: OPqt8yezM1qi376RPohOXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B4C013FC;
        Tue, 24 Mar 2020 15:58:58 +0000 (UTC)
Received: from gondolin (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECE7519C70;
        Tue, 24 Mar 2020 15:58:56 +0000 (UTC)
Date:   Tue, 24 Mar 2020 16:58:54 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/9] vfio-ccw: Register a chp_event callback for
 vfio-ccw
Message-ID: <20200324165854.3d862d5b.cohuck@redhat.com>
In-Reply-To: <459a60d1-699d-2f16-bb59-23f11b817b81@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
        <20200206213825.11444-3-farman@linux.ibm.com>
        <20200214131147.0a98dd7d.cohuck@redhat.com>
        <459a60d1-699d-2f16-bb59-23f11b817b81@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Feb 2020 11:35:21 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On 2/14/20 7:11 AM, Cornelia Huck wrote:
> > On Thu,  6 Feb 2020 22:38:18 +0100
> > Eric Farman <farman@linux.ibm.com> wrote:

> > (...)  
> >> @@ -257,6 +258,48 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
> >>  	return rc;
> >>  }
> >>  
> >> +static int vfio_ccw_chp_event(struct subchannel *sch,
> >> +			      struct chp_link *link, int event)
> >> +{
> >> +	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
> >> +	int mask = chp_ssd_get_mask(&sch->ssd_info, link);
> >> +	int retry = 255;
> >> +
> >> +	if (!private || !mask)
> >> +		return 0;
> >> +
> >> +	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
> >> +			   mdev_uuid(private->mdev), sch->schid.cssid,
> >> +			   sch->schid.ssid, sch->schid.sch_no,
> >> +			   mask, event);
> >> +
> >> +	if (cio_update_schib(sch))
> >> +		return -ENODEV;
> >> +
> >> +	switch (event) {
> >> +	case CHP_VARY_OFF:
> >> +		/* Path logically turned off */
> >> +		sch->opm &= ~mask;
> >> +		sch->lpm &= ~mask;
> >> +		break;
> >> +	case CHP_OFFLINE:
> >> +		/* Path is gone */
> >> +		cio_cancel_halt_clear(sch, &retry);  
> > 
> > Any reason you do this only for CHP_OFFLINE and not for CHP_VARY_OFF?  
> 
> Hrm...  No reason that I can think of.  I can fix this.
> 
> >   
> >> +		break;
> >> +	case CHP_VARY_ON:
> >> +		/* Path logically turned on */
> >> +		sch->opm |= mask;
> >> +		sch->lpm |= mask;
> >> +		break;
> >> +	case CHP_ONLINE:
> >> +		/* Path became available */
> >> +		sch->lpm |= mask & sch->opm;  
> > 
> > If I'm not mistaken, this patch introduces the first usage of sch->opm
> > in the vfio-ccw code.   
> 
> Correct.
> 
> > Are we missing something?  
> 
> Maybe?  :)
> 
> >Or am I missing
> > something? :)
> >   
> 
> Since it's only used in this code, for acting as a step between
> vary/config off/on, maybe this only needs to be dealing with the lpm
> field itself?

Ok, I went over this again and also looked at what the standard I/O
subchannel driver does, and I think this is fine, as the lpm basically
factors in the opm already. (Will need to keep this in mind for the
following patches.)

> 
> >> +		break;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static struct css_device_id vfio_ccw_sch_ids[] = {
> >>  	{ .match_flags = 0x1, .type = SUBCHANNEL_TYPE_IO, },
> >>  	{ /* end of list */ },  
> > (...)
> >   
> 

