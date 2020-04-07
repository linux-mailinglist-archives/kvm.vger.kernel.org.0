Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A471A074C
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 08:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgDGGaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 02:30:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726448AbgDGGaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 02:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586241046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SpsaTZYGy7YBxzuHq9LC7fCPwlUeSBFi31qENFztN10=;
        b=EYtfGYvNQS9ZFMyeXosO/USnh0NDYpgHzgd+QRuRRy5zcFCJa18IzqyaSjW6IXzkxH5Onm
        n4XVf/KpPFTxQxnOxETQxQ0mRNwY/C59v4XkgzVAddCtPjgqXkDAnOnizv8DsbL+i9Gjfw
        cYGeKGQrYVAoEylP4D+C4MMwec5I6D8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-35UkpaakNWu57W11KthT9Q-1; Tue, 07 Apr 2020 02:30:41 -0400
X-MC-Unique: 35UkpaakNWu57W11KthT9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 446EFDB60;
        Tue,  7 Apr 2020 06:30:40 +0000 (UTC)
Received: from gondolin (ovpn-112-38.ams2.redhat.com [10.36.112.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCCCD1001B3F;
        Tue,  7 Apr 2020 06:30:38 +0000 (UTC)
Date:   Tue, 7 Apr 2020 08:30:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/9] vfio-ccw: Introduce a new CRW region
Message-ID: <20200407083035.09ca4dfc.cohuck@redhat.com>
In-Reply-To: <db43381a-6769-07f1-7d4d-9c6c680bde4e@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
        <20200206213825.11444-6-farman@linux.ibm.com>
        <20200406154057.6016c4a7.cohuck@redhat.com>
        <db43381a-6769-07f1-7d4d-9c6c680bde4e@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Apr 2020 17:43:42 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> (Ah, didn't see this come in earlier.)
> 
> On 4/6/20 9:40 AM, Cornelia Huck wrote:
> > On Thu,  6 Feb 2020 22:38:21 +0100
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> >> From: Farhan Ali <alifm@linux.ibm.com>
> >>
> >> This region provides a mechanism to pass Channel Report Word(s)
> >> that affect vfio-ccw devices, and need to be passed to the guest
> >> for its awareness and/or processing.
> >>
> >> The base driver (see crw_collect_info()) provides space for two
> >> CRWs, as a subchannel event may have two CRWs chained together
> >> (one for the ssid, one for the subcahnnel).  All other CRWs will
> >> only occupy the first one.  Even though this support will also
> >> only utilize the first one, we'll provide space for two also.
> >>
> >> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> >> ---
> >>
> >> Notes:
> >>     v1-v2:
> >>      - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
> >>      - Add a block comment to struct ccw_crw_region [CH]
> >>     
> >>     v0->v1: [EF]
> >>      - Clean up checkpatch (whitespace) errors
> >>      - Add ret=-ENOMEM in error path for new region
> >>      - Add io_mutex for region read (originally in last patch)
> >>      - Change crw1/crw2 to crw0/crw1
> >>      - Reorder cleanup of regions
> >>
> >>  Documentation/s390/vfio-ccw.rst     | 15 ++++++++
> >>  drivers/s390/cio/vfio_ccw_chp.c     | 56 +++++++++++++++++++++++++++++
> >>  drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
> >>  drivers/s390/cio/vfio_ccw_ops.c     |  4 +++
> >>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
> >>  include/uapi/linux/vfio.h           |  1 +
> >>  include/uapi/linux/vfio_ccw.h       |  9 +++++
> >>  7 files changed, 108 insertions(+)
> >>  
> > 
> > (...)
> >   
> >> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
> >> index 826d08379fe3..8fde94552149 100644
> >> --- a/drivers/s390/cio/vfio_ccw_chp.c
> >> +++ b/drivers/s390/cio/vfio_ccw_chp.c
> >> @@ -73,3 +73,59 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private)
> >>  					    VFIO_REGION_INFO_FLAG_READ,
> >>  					    private->schib_region);
> >>  }
> >> +
> >> +static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
> >> +					char __user *buf, size_t count,
> >> +					loff_t *ppos)
> >> +{
> >> +	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
> >> +	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
> >> +	struct ccw_crw_region *region;
> >> +	int ret;
> >> +
> >> +	if (pos + count > sizeof(*region))
> >> +		return -EINVAL;
> >> +
> >> +	if (list_empty(&private->crw))
> >> +		return 0;  
> 
> This is actually nonsense, because the list isn't introduced for a
> couple of patches.
> 
> >> +
> >> +	mutex_lock(&private->io_mutex);
> >> +	region = private->region[i].data;
> >> +
> >> +	if (copy_to_user(buf, (void *)region + pos, count))
> >> +		ret = -EFAULT;
> >> +	else
> >> +		ret = count;
> >> +
> >> +	mutex_unlock(&private->io_mutex);
> >> +	return ret;
> >> +}  
> > 
> > Would it make sense to clear out the crw after it has been read by
> > userspace?  
> 
> Yes, I fixed this up in my in-progress v3 last week.  Sorry to waste
> some time, I should have mentioned it when I changed my branch locally.
> 
> I changed the list_empty() check above to bail out if the region is
> already zero, which I guess is why the userspace check looks for both.
> But if we only look at the contents of the region, then checking both is
> unnecessary.  Just do the copy and be done with it.

Yes, that makes sense.

> 
> > 
> > In patch 7, you add a notification for a new crw via eventfd, but
> > nothing is preventing userspace from reading this even if not
> > triggered. I also don't see the region being updated there until a new
> > crw is posted.
> > 
> > Or am I missing something?
> >   
> 

