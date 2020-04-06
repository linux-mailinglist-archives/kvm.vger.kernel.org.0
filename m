Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDB619F73B
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 15:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgDFNxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 09:53:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726910AbgDFNxF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 09:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586181184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yKKr8qTGdHhz4Tkke8VXol1oo8WYWzltyaOXhCA4Ji4=;
        b=NEmcJr9NREHxFnkP4bHJaSYJho3Q+eolXXrPQk0VYyXPUjTHHAJHdHAG2HukcU1YIPcNQu
        Lk8yKS90o0gtgSf4zIq4qbqULwRoh2S2BdoVjNjXopjq3STH+3XF77szCN5/7t8EPrtQPm
        QCcL7RI00JC1tRPdpP70cO4b00RUedQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-eK_2ZfYfN4ys-ourygtS3A-1; Mon, 06 Apr 2020 09:53:00 -0400
X-MC-Unique: eK_2ZfYfN4ys-ourygtS3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5559D800D6C;
        Mon,  6 Apr 2020 13:52:59 +0000 (UTC)
Received: from gondolin (ovpn-113-129.ams2.redhat.com [10.36.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D07FF19C6A;
        Mon,  6 Apr 2020 13:52:57 +0000 (UTC)
Date:   Mon, 6 Apr 2020 15:52:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/9] vfio-ccw: Wire up the CRW irq and CRW region
Message-ID: <20200406155255.3c8f06e5.cohuck@redhat.com>
In-Reply-To: <20200206213825.11444-8-farman@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
        <20200206213825.11444-8-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 22:38:23 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
> 
> Use an IRQ to notify userspace that there is a CRW
> pending in the region, related to path-availability
> changes on the passthrough subchannel.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v1->v2:
>      - Remove extraneous 0x0 in crw.rsid assignment [CH]
>      - Refactor the building/queueing of a crw into its own routine [EF]
>     
>     v0->v1: [EF]
>      - Place the non-refactoring changes from the previous patch here
>      - Clean up checkpatch (whitespace) errors
>      - s/chp_crw/crw/
>      - Move acquire/release of io_mutex in vfio_ccw_crw_region_read()
>        into patch that introduces that region
>      - Remove duplicate include from vfio_ccw_drv.c
>      - Reorder include in vfio_ccw_private.h
> 
>  drivers/s390/cio/vfio_ccw_chp.c     |  5 ++
>  drivers/s390/cio/vfio_ccw_drv.c     | 73 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     |  4 ++
>  drivers/s390/cio/vfio_ccw_private.h |  9 ++++
>  include/uapi/linux/vfio.h           |  1 +
>  5 files changed, 92 insertions(+)

[I may have gotten all muddled up from staring at this, but please bear
with me...]

> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
> index 8fde94552149..328b4e1d1972 100644
> --- a/drivers/s390/cio/vfio_ccw_chp.c
> +++ b/drivers/s390/cio/vfio_ccw_chp.c
> @@ -98,6 +98,11 @@ static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
>  		ret = count;
>  
>  	mutex_unlock(&private->io_mutex);
> +
> +	/* Notify the guest if more CRWs are on our queue */
> +	if (!list_empty(&private->crw) && private->crw_trigger)
> +		eventfd_signal(private->crw_trigger, 1);

Here we possibly arm the eventfd again, but don't do anything regarding
queued crws and the region.

> +
>  	return ret;
>  }
>  
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 1e1360af1b34..c48c260a129d 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -108,6 +108,31 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  		eventfd_signal(private->io_trigger, 1);
>  }
>  
> +static void vfio_ccw_crw_todo(struct work_struct *work)
> +{
> +	struct vfio_ccw_private *private;
> +	struct vfio_ccw_crw *crw;
> +
> +	private = container_of(work, struct vfio_ccw_private, crw_work);
> +
> +	/* FIXME Ugh, need better control of this list */
> +	crw = list_first_entry_or_null(&private->crw,
> +				       struct vfio_ccw_crw, next);
> +
> +	if (crw) {
> +		list_del(&crw->next);
> +
> +		mutex_lock(&private->io_mutex);
> +		memcpy(&private->crw_region->crw0, crw->crw, sizeof(*crw->crw));
> +		mutex_unlock(&private->io_mutex);
> +
> +		kfree(crw);
> +
> +		if (private->crw_trigger)
> +			eventfd_signal(private->crw_trigger, 1);
> +	}
> +}

This function copies one outstanding crw and arms the eventfd.

> +
>  /*
>   * Css driver callbacks
>   */

(...)

> @@ -276,6 +309,44 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
>  	return rc;
>  }
>  
> +static void vfio_ccw_alloc_crw(struct vfio_ccw_private *private,
> +			       struct chp_link *link,
> +			       unsigned int erc)
> +{
> +	struct vfio_ccw_crw *vc_crw;
> +	struct crw *crw;
> +
> +	/*
> +	 * If unable to allocate a CRW, just drop the event and
> +	 * carry on.  The guest will either see a later one or
> +	 * learn when it issues its own store subchannel.
> +	 */
> +	vc_crw = kzalloc(sizeof(*vc_crw), GFP_ATOMIC);
> +	if (!vc_crw)
> +		return;
> +
> +	/*
> +	 * Build in the first CRW space, but don't chain anything
> +	 * into the second one even though the space exists.
> +	 */
> +	crw = &vc_crw->crw[0];
> +
> +	/*
> +	 * Presume every CRW we handle is reported by a channel-path.
> +	 * Maybe not future-proof, but good for what we're doing now.
> +	 *
> +	 * FIXME Sort of a lie, since we're converting a CRW
> +	 * reported by a channel-path into one issued to each
> +	 * subchannel, but still saying it's coming from the path.
> +	 */
> +	crw->rsc = CRW_RSC_CPATH;
> +	crw->rsid = (link->chpid.cssid << 8) | link->chpid.id;
> +	crw->erc = erc;
> +
> +	list_add_tail(&vc_crw->next, &private->crw);
> +	queue_work(vfio_ccw_work_q, &private->crw_work);

This function allocates a new crw and queues it. After that, it
triggers the function doing the copy-to-region-and-notify stuff.

> +}
> +
>  static int vfio_ccw_chp_event(struct subchannel *sch,
>  			      struct chp_link *link, int event)
>  {
> @@ -303,6 +374,7 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
>  	case CHP_OFFLINE:
>  		/* Path is gone */
>  		cio_cancel_halt_clear(sch, &retry);
> +		vfio_ccw_alloc_crw(private, link, CRW_ERC_PERRN);
>  		break;
>  	case CHP_VARY_ON:
>  		/* Path logically turned on */
> @@ -312,6 +384,7 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
>  	case CHP_ONLINE:
>  		/* Path became available */
>  		sch->lpm |= mask & sch->opm;
> +		vfio_ccw_alloc_crw(private, link, CRW_ERC_INIT);
>  		break;
>  	}
>  

These two (path online/offline handling) are the only code paths
triggering an update to the queued crws.

Aren't we missing copying in a new queued crw after userspace had done
a read?

