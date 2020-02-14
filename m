Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6639715D88B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 14:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgBNNeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 08:34:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32114 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728083AbgBNNeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 08:34:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581687248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l7aMxDi0mAhQvw9oGCvK/t3d5+SiBEkXdJDHyytIXQc=;
        b=a7ExFgCToe1+CCy+8uKmbC+QzisXNbIebdEMffbH+T/IFdfKFE8PKuxEeT4SOPdavhqW6q
        gKQzFpjjgQlCfeNpXhagb/qyG2h7vhiAN/eppb39H4ez9JF0ry/c/OWeIbRyZmvU+aesO2
        EE1L+fWIeZSyJsEdcMG02xfPfn3ge38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-eMAnR9l5N-24-ILozPcilg-1; Fri, 14 Feb 2020 08:34:05 -0500
X-MC-Unique: eMAnR9l5N-24-ILozPcilg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEEA1107B7D4;
        Fri, 14 Feb 2020 13:34:03 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 921B826FB6;
        Fri, 14 Feb 2020 13:34:02 +0000 (UTC)
Date:   Fri, 14 Feb 2020 14:34:00 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/9] vfio-ccw: Wire up the CRW irq and CRW region
Message-ID: <20200214143400.175c9e5e.cohuck@redhat.com>
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
> 
(...)
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

You could pass in a source indication, maybe? Presumably, at least one
of the callers further up the chain knows...

> +	 *
> +	 * FIXME Sort of a lie, since we're converting a CRW
> +	 * reported by a channel-path into one issued to each
> +	 * subchannel, but still saying it's coming from the path.

It's still channel-path related, though :)

The important point is probably is that userspace needs to be aware
that the same channel-path related event is reported on all affected
subchannels, and they therefore need some appropriate handling on their
side.

> +	 */
> +	crw->rsc = CRW_RSC_CPATH;
> +	crw->rsid = (link->chpid.cssid << 8) | link->chpid.id;
> +	crw->erc = erc;
> +
> +	list_add_tail(&vc_crw->next, &private->crw);
> +	queue_work(vfio_ccw_work_q, &private->crw_work);
> +}
> +
>  static int vfio_ccw_chp_event(struct subchannel *sch,
>  			      struct chp_link *link, int event)
>  {
(...)

