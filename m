Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B760102AA5
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 18:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfKSRRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 12:17:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34558 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbfKSRRj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 12:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574183857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4w84LSGNFwaIbpyY3U45DNFmTaahZa6scPBa8cCijMM=;
        b=Jot/2G4MuCzBdS/Fnp9N/03MnJYrT+Bx4oqS/tsowx8fngPChCkJKYrcGLBirKJUo2vk1l
        P+UuPOeNlFTnkNvcASH9ZfwuwJHDxMUmzGMeCbEZBnJDyIzf6N+hQ2vP7XbII6kvj2PiIu
        bSWMs5ecKwZe4s+5iFQZg4xg/esKb7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-0QpEjqleMui08JarvqBoBQ-1; Tue, 19 Nov 2019 12:17:32 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92092801E7E;
        Tue, 19 Nov 2019 17:17:30 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 582964DA42;
        Tue, 19 Nov 2019 17:17:29 +0000 (UTC)
Date:   Tue, 19 Nov 2019 18:17:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 06/10] vfio-ccw: Introduce a new CRW region
Message-ID: <20191119181726.440dd30d.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-7-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-7-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 0QpEjqleMui08JarvqBoBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:16 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
>=20
> This region can be used by userspace to get channel report
> words from vfio-ccw driver.

I think this needs a bit more explanation; this is for channel report
words concerning vfio-ccw devices that are supposed to be relayed to
the guest, IIUC?

>=20
> We provide space for two CRWs, per the limit in the
> base driver (see crw_collect_info()).

That rationale seems a bit sketchy.

As far as I know, current systems provide at most two crws chained
together for an event (one for the ssid + one for the subchannel id in
case of a subchannel event, one crw for other events); and that's the
reason why we provide space for two crws (unless there's something
upcoming which would need three crws chained together?)

>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>=20
> Notes:
>     v0->v1: [EF]
>      - Clean up checkpatch (whitespace) errors
>      - Add ret=3D-ENOMEM in error path for new region
>      - Add io_mutex for region read (originally in last patch)
>      - Change crw1/crw2 to crw0/crw1
>      - Reorder cleanup of regions
>=20
>  drivers/s390/cio/vfio_ccw_chp.c     | 53 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     |  4 +++
>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>  include/uapi/linux/vfio.h           |  1 +
>  include/uapi/linux/vfio_ccw.h       |  5 +++
>  6 files changed, 86 insertions(+)
>=20
> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_=
chp.c
> index 826d08379fe3..d1e8bfef06be 100644
> --- a/drivers/s390/cio/vfio_ccw_chp.c
> +++ b/drivers/s390/cio/vfio_ccw_chp.c
> @@ -73,3 +73,56 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_cc=
w_private *private)
>  =09=09=09=09=09    VFIO_REGION_INFO_FLAG_READ,
>  =09=09=09=09=09    private->schib_region);
>  }
> +
> +static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private=
,
> +=09=09=09=09=09char __user *buf, size_t count,
> +=09=09=09=09=09loff_t *ppos)
> +{
> +=09unsigned int i =3D VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REG=
IONS;
> +=09loff_t pos =3D *ppos & VFIO_CCW_OFFSET_MASK;
> +=09struct ccw_crw_region *region;
> +=09int ret;
> +
> +=09if (pos + count > sizeof(*region))
> +=09=09return -EINVAL;
> +
> +=09mutex_lock(&private->io_mutex);
> +=09region =3D private->region[i].data;
> +
> +=09if (copy_to_user(buf, (void *)region + pos, count))
> +=09=09ret =3D -EFAULT;
> +=09else
> +=09=09ret =3D count;
> +

Can userspace read the same crw(s) multiple times? How can it find out
if there's something new in there?

> +=09mutex_unlock(&private->io_mutex);
> +=09return ret;
> +}
> +

(...)

> diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.=
h
> index 7c0a834e5d7a..88b125aad279 100644
> --- a/include/uapi/linux/vfio_ccw.h
> +++ b/include/uapi/linux/vfio_ccw.h
> @@ -39,4 +39,9 @@ struct ccw_schib_region {
>  =09__u8 schib_area[SCHIB_AREA_SIZE];
>  } __packed;
>

I think this one wants an explaining comment as well.
 =20
> +struct ccw_crw_region {
> +=09__u32 crw0;
> +=09__u32 crw1;
> +} __packed;
> +
>  #endif

