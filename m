Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A62102C0E
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 19:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfKSSwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 13:52:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39998 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726792AbfKSSwq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 13:52:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574189564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JuMkPOzv8VeJXYGJBQTPhlZqCOImMDcOGmpGVs0eZK8=;
        b=CiWH6m5khjhnVHB/FJGmhASLX84YtSDGzaJpxSV76a4irnxHyKRrUEgd+3fA2vElAk82At
        WrJp/8Sdp7znBtOGCZvqw1DwlE+VSFd/19ViNb8tOS+PHSr2rVDHZqRfqmsSHfz/zXNLXQ
        GPdZXqslExdTOQKY4RFNT82JN1pFORI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-F8I3Fj-9P4yHv0ybIZ-m1w-1; Tue, 19 Nov 2019 13:52:41 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04E2712D7D1;
        Tue, 19 Nov 2019 18:52:40 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C315766095;
        Tue, 19 Nov 2019 18:52:38 +0000 (UTC)
Date:   Tue, 19 Nov 2019 19:52:36 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 08/10] vfio-ccw: Wire up the CRW irq and CRW
 region
Message-ID: <20191119195236.35189d5b.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-9-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-9-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: F8I3Fj-9P4yHv0ybIZ-m1w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:18 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
>=20
> Use an IRQ to notify userspace that there is a CRW
> pending in the region, related to path-availability
> changes on the passthrough subchannel.

Thinking a bit more about this, it feels a bit odd that a crw for a
chpid ends up on one subchannel. What happens if we have multiple
subchannels passed through by vfio-ccw that use that same chpid?

>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>=20
> Notes:
>     v0->v1: [EF]
>      - Place the non-refactoring changes from the previous patch here
>      - Clean up checkpatch (whitespace) errors
>      - s/chp_crw/crw/
>      - Move acquire/release of io_mutex in vfio_ccw_crw_region_read()
>        into patch that introduces that region
>      - Remove duplicate include from vfio_ccw_drv.c
>      - Reorder include in vfio_ccw_private.h
>=20
>  drivers/s390/cio/vfio_ccw_drv.c     | 27 +++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     |  4 ++++
>  drivers/s390/cio/vfio_ccw_private.h |  4 ++++
>  include/uapi/linux/vfio.h           |  1 +
>  4 files changed, 36 insertions(+)
>=20
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_=
drv.c
> index d1b9020d037b..ab20c32e5319 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -108,6 +108,22 @@ static void vfio_ccw_sch_io_todo(struct work_struct =
*work)
>  =09=09eventfd_signal(private->io_trigger, 1);
>  }
> =20
> +static void vfio_ccw_crw_todo(struct work_struct *work)
> +{
> +=09struct vfio_ccw_private *private;
> +=09struct crw *crw;
> +
> +=09private =3D container_of(work, struct vfio_ccw_private, crw_work);
> +=09crw =3D &private->crw;
> +
> +=09mutex_lock(&private->io_mutex);
> +=09memcpy(&private->crw_region->crw0, crw, sizeof(*crw));

This looks a bit inflexible. Should we want to support subchannel crws
in the future, we'd need to copy two crws.

Maybe keep two crws (they're not that large, anyway) in the private
structure and copy the second one iff the first one has the chaining
bit on?

> +=09mutex_unlock(&private->io_mutex);
> +
> +=09if (private->crw_trigger)
> +=09=09eventfd_signal(private->crw_trigger, 1);
> +}
> +
>  /*
>   * Css driver callbacks
>   */
> @@ -187,6 +203,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>  =09=09goto out_free;
> =20
>  =09INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
> +=09INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
>  =09atomic_set(&private->avail, 1);
>  =09private->state =3D VFIO_CCW_STATE_STANDBY;
> =20
> @@ -303,6 +320,11 @@ static int vfio_ccw_chp_event(struct subchannel *sch=
,
>  =09case CHP_OFFLINE:
>  =09=09/* Path is gone */
>  =09=09cio_cancel_halt_clear(sch, &retry);
> +=09=09private->crw.rsc =3D CRW_RSC_CPATH;
> +=09=09private->crw.rsid =3D 0x0 | (link->chpid.cssid << 8) |

What's the leading '0x0' for?

> +=09=09=09=09    link->chpid.id;
> +=09=09private->crw.erc =3D CRW_ERC_PERRN;
> +=09=09queue_work(vfio_ccw_work_q, &private->crw_work);
>  =09=09break;
>  =09case CHP_VARY_ON:
>  =09=09/* Path logically turned on */
> @@ -312,6 +334,11 @@ static int vfio_ccw_chp_event(struct subchannel *sch=
,
>  =09case CHP_ONLINE:
>  =09=09/* Path became available */
>  =09=09sch->lpm |=3D mask & sch->opm;
> +=09=09private->crw.rsc =3D CRW_RSC_CPATH;
> +=09=09private->crw.rsid =3D 0x0 | (link->chpid.cssid << 8) |
> +=09=09=09=09    link->chpid.id;
> +=09=09private->crw.erc =3D CRW_ERC_INIT;
> +=09=09queue_work(vfio_ccw_work_q, &private->crw_work);

Isn't that racy? Imagine you get one notification for a chpid and queue
it. Then, you get another notification for another chpid and queue it
as well. Depending on when userspace reads, it gets different chpids.
Moreover, a crw may be lost... or am I missing something obvious?

Maybe you need a real queue for the generated crws?

>  =09=09break;
>  =09}
> =20

