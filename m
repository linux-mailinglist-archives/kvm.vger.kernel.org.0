Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CF535A0F4
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 16:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhDIOYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 10:24:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233571AbhDIOYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 10:24:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617978250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mWB8fVtvsr+ttGoY+PfMzLEn/1c7gqQBkhb46FX5nXY=;
        b=B550uzej4eA864gJ70Lv8qolTpw2RVJFI0cLU9gI6Kms5/aAvvU5YI2mcZUxttOLDhlMIM
        jI//VaFIuwbym6ZhAYmdJ41l5+/M5wJKhu4kH8s3o/KvZ5rcVMueQuWkem7M/LzBl04fJr
        TuGWiOU/+A1rW9QVancz81bB04v+AOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-hGyyGkOOPFWQmHdgXIXzHg-1; Fri, 09 Apr 2021 10:24:07 -0400
X-MC-Unique: hGyyGkOOPFWQmHdgXIXzHg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 423631020C22;
        Fri,  9 Apr 2021 14:24:06 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-117-254.rdu2.redhat.com [10.10.117.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8324D19C66;
        Fri,  9 Apr 2021 14:24:01 +0000 (UTC)
Date:   Fri, 9 Apr 2021 08:24:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Zengtao (B)" <prime.zeng@hisilicon.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v1 01/14] vfio: Create vfio_fs_type with inode per
 device
Message-ID: <20210409082400.1004fcef@x1.home.shazbot.org>
In-Reply-To: <d9fdf4e8435244be826782daada0fd7b@hisilicon.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
        <161524004828.3480.1817334832614722574.stgit@gimli.home>
        <d9fdf4e8435244be826782daada0fd7b@hisilicon.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 04:54:23 +0000
"Zengtao (B)" <prime.zeng@hisilicon.com> wrote:

> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Alex Williamson [mailto:alex.williamson@re=
dhat.com]
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2021=E5=B9=B43=E6=9C=889=E6=97=A5=
 5:47
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: alex.williamson@redhat.com
> > =E6=8A=84=E9=80=81: cohuck@redhat.com; kvm@vger.kernel.org;
> > linux-kernel@vger.kernel.org; jgg@nvidia.com; peterx@redhat.com
> > =E4=B8=BB=E9=A2=98: [PATCH v1 01/14] vfio: Create vfio_fs_type with ino=
de per device
> >=20
> > By linking all the device fds we provide to userspace to an address spa=
ce
> > through a new pseudo fs, we can use tools like
> > unmap_mapping_range() to zap all vmas associated with a device.
> >=20
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/vfio.c |   54
> > +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 54 insertions(+)
> >=20
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c index
> > 38779e6fd80c..abdf8d52a911 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -32,11 +32,18 @@
> >  #include <linux/vfio.h>
> >  #include <linux/wait.h>
> >  #include <linux/sched/signal.h>
> > +#include <linux/pseudo_fs.h>
> > +#include <linux/mount.h> =20
> Minor: keep the headers in alphabetical order.

They started out that way, but various tree-wide changes ignoring that,
and likely oversights on my part as well, has left us with numerous
breaks in that rule already.

> >=20
> >  #define DRIVER_VERSION	"0.3"
> >  #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
> >  #define DRIVER_DESC	"VFIO - User Level meta-driver"
> >=20
> > +#define VFIO_MAGIC 0x5646494f /* "VFIO" */ =20
> Move to include/uapi/linux/magic.h ?=20

Hmm, yeah, I suppose it probably should go there.  Thanks.

FWIW, I'm still working on a next version of this series, currently
struggling how to handle an arbitrary number of vmas per user DMA
mapping.  Thanks,

Alex

