Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0651D1029D4
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 17:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfKSQxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 11:53:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36717 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727560AbfKSQxD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 11:53:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574182382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WtCrvrYHqr0JuN+r6XCjVqi8dVNXxOLu/cvUH61kzk=;
        b=HnBGkfz8KyQDytivsp7oYJsjMcKY3NIwABydvD7Ki7hLDFtsbGJXxuOyRqo4GJundzZeHY
        AL5RVhnHbvr9AMSP8RDWf62z5LMaKKQRsvqul5//FouLOOtoxwoTexrRMMVLaQrKviEvt5
        u88wMZ75kf6ADusQ5OUh+oN/sLAgvqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-pYJGrtfPOGSc61KbSQQwyQ-1; Tue, 19 Nov 2019 11:52:58 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56C471802CE0;
        Tue, 19 Nov 2019 16:52:57 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14C6A28DE8;
        Tue, 19 Nov 2019 16:52:55 +0000 (UTC)
Date:   Tue, 19 Nov 2019 17:52:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 05/10] vfio-ccw: Introduce a new schib region
Message-ID: <20191119175253.3e688369.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-6-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-6-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: pYJGrtfPOGSc61KbSQQwyQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:15 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
>=20
> The schib region can be used by userspace to get the SCHIB for the
> passthrough subchannel. This can be useful to get information such
> as channel path information via the SCHIB.PMCW.
>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>=20
> Notes:
>     v0->v1: [EF]
>      - Clean up checkpatch (#include, whitespace) errors
>      - Remove unnecessary includes from vfio_ccw_chp.c
>      - Add ret=3D-ENOMEM in error path for new region
>      - Add call to vfio_ccw_unregister_dev_regions() during error exit
>        path of vfio_ccw_mdev_open()
>      - New info on the module prologue
>      - Reorder cleanup of regions
>=20
>  drivers/s390/cio/Makefile           |  2 +-
>  drivers/s390/cio/vfio_ccw_chp.c     | 75 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     | 14 +++++-
>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>  include/uapi/linux/vfio.h           |  1 +
>  include/uapi/linux/vfio_ccw.h       |  5 ++
>  7 files changed, 117 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
>=20

> diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.=
h
> index cbecbf0cd54f..7c0a834e5d7a 100644
> --- a/include/uapi/linux/vfio_ccw.h
> +++ b/include/uapi/linux/vfio_ccw.h
> @@ -34,4 +34,9 @@ struct ccw_cmd_region {
>  =09__u32 ret_code;
>  } __packed;
>

Let's add a comment:
- that reading this region triggers a stsch()
- that this region is guarded by a capability

?
 =20
> +struct ccw_schib_region {
> +#define SCHIB_AREA_SIZE 52
> +=09__u8 schib_area[SCHIB_AREA_SIZE];
> +} __packed;
> +
>  #endif

Seems sane; but I need to continue reading this and the QEMU series to
see how it is used.

Oh, and please update Documentation/s390/vfio-ccw.rst :)

