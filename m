Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D90810250E
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 14:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfKSNA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 08:00:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49407 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727255AbfKSNA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 08:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574168455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kAHQiLH9UqfzMCC88vTiRTdOZqRxM2ZuAmXqckgqzHE=;
        b=GNMobbGLfOmthBAlqNbd8OCgR2jSEvFBMjt8oySUkUnEUorm6wXRFH17eZKTY6B5ozo1gg
        Z8KNcDo37CrVUaYcE9XEt8wLJY+huD29h/Uu9G34jasozlSfpniCF6xlKTeMKaYL4O056M
        xrcSSN4qXH+U5lx2E9OjTmyzJc8JkhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-msw7tUWEP0SiWG3QhRXvpw-1; Tue, 19 Nov 2019 08:00:52 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03EA710921EE;
        Tue, 19 Nov 2019 13:00:51 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ED4C627DE;
        Tue, 19 Nov 2019 13:00:49 +0000 (UTC)
Date:   Tue, 19 Nov 2019 14:00:46 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [RFC PATCH v1 03/10] vfio-ccw: Use subchannel lpm in the orb
Message-ID: <20191119140046.4b81edd8.cohuck@redhat.com>
In-Reply-To: <20191115025620.19593-4-farman@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
        <20191115025620.19593-4-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: msw7tUWEP0SiWG3QhRXvpw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 03:56:13 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
>=20
> The subchannel logical path mask (lpm) would have the most
> up to date information of channel paths that are logically
> available for the subchannel.
>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>=20
> Notes:
>     v0->v1: [EF]
>      - None; however I am greatly confused by this one.  Thoughts?

I think it's actually wrong.

>=20
>  drivers/s390/cio/vfio_ccw_cp.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_c=
p.c
> index 3645d1720c4b..d4a86fb9d162 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -779,9 +779,7 @@ union orb *cp_get_orb(struct channel_program *cp, u32=
 intparm, u8 lpm)
>  =09orb->cmd.intparm =3D intparm;
>  =09orb->cmd.fmt =3D 1;
>  =09orb->cmd.key =3D PAGE_DEFAULT_KEY >> 4;
> -
> -=09if (orb->cmd.lpm =3D=3D 0)
> -=09=09orb->cmd.lpm =3D lpm;

In the end, the old code will use the lpm from the subchannel
structure, if userspace did not supply anything to be used.

> +=09orb->cmd.lpm =3D lpm;

The new code will always discard any lpm userspace has supplied and
replace it with the lpm from the subchannel structure. This feels
wrong; what if the I/O is supposed to be restricted to a subset of the
paths?

If we want to include the current value of the subchannel lpm in the
requests, we probably want to AND the masks instead.

> =20
>  =09chain =3D list_first_entry(&cp->ccwchain_list, struct ccwchain, next)=
;
>  =09cpa =3D chain->ch_ccw;

