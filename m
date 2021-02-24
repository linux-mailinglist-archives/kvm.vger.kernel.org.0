Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBCD323A2C
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 11:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhBXKHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 05:07:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232476AbhBXKHo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 05:07:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614161178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fPNDEU+TZt3Qi1Ymt7+NYKPO62gWZ8+e83cdmz4VRwg=;
        b=H8zVrufNNH0LGWBmOrIeTaOQcKLHKR10IRbKaDarH45BcfcAUoMIm50Mrz1QwLY4Ac1t5s
        OessfBwWDn75a4XjZ8vKl60oxw5uMa5ILAKN8mNRnabY3Z4gm1cdw1Fu/SRVWuv1wagXOv
        C8RT2yDXVuGKRm5qXhEzYp3r6tCaazw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-HYrsgBtpMgKbiP1ptZfH0g-1; Wed, 24 Feb 2021 05:06:15 -0500
X-MC-Unique: HYrsgBtpMgKbiP1ptZfH0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45A5A193578E;
        Wed, 24 Feb 2021 10:06:14 +0000 (UTC)
Received: from localhost (ovpn-115-137.ams2.redhat.com [10.36.115.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0698A5D9D0;
        Wed, 24 Feb 2021 10:06:07 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:06:07 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Subject: Re: [RFC v3 1/5] KVM: add initial support for KVM_SET_IOREGION
Message-ID: <YDYlD3ncm2bq7xSx@stefanha-x1.localdomain>
References: <cover.1613828726.git.eafanasova@gmail.com>
 <f77bbc58289508b5b0633521cf8c03eb0303707a.1613828727.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CRPE6zOJJRoRnbtL"
Content-Disposition: inline
In-Reply-To: <f77bbc58289508b5b0633521cf8c03eb0303707a.1613828727.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--CRPE6zOJJRoRnbtL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 21, 2021 at 03:04:37PM +0300, Elena Afanasova wrote:
> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> new file mode 100644
> index 000000000000..e09ef3e2c9d7
> --- /dev/null
> +++ b/virt/kvm/ioregion.c
> @@ -0,0 +1,265 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/kvm_host.h>
> +#include <linux/fs.h>
> +#include <kvm/iodev.h>
> +#include "eventfd.h"
> +
> +void
> +kvm_ioregionfd_init(struct kvm *kvm)
> +{
> +	INIT_LIST_HEAD(&kvm->ioregions_fast_mmio);
> +	INIT_LIST_HEAD(&kvm->ioregions_mmio);
> +	INIT_LIST_HEAD(&kvm->ioregions_pio);
> +}
> +
> +struct ioregion {
> +	struct list_head     list;

Linux struct list_head gives no clue about which list this belongs to.
You can help readers by adding a comment:

/* struct kvm ioregions_fast_mmio/ioregions_mmio/ioregions_pio */

> +	u64                  paddr;  /* guest physical address */
> +	u64                  size;   /* size in bytes */
> +	struct file         *rf;

+	struct file         *rf;     /* responses are read from this */

> +	struct file         *wf;

+	struct file         *wf;     /* commands are written to this */

--CRPE6zOJJRoRnbtL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2JQ4ACgkQnKSrs4Gr
c8hi0QgAnn5KpXfa2MS9EqXZ3GDIoac+3jTn2m9CIg/32SLAJocsTtqA+wt3JZU4
YtmmZzGqgzI52Wsr8cFsVXFUQBIvjoTLxQOnCbjC+gnqoznHb0oIeuTpmFVYiPl3
+x1cTENxaJqJvNrg6ZzCeDAzIl9nVnEF+z/YL4k6rzOLJWO7J0+p7JY8oCF3jRdp
FKgnj5ClOV62ijt71Za0Bg0PDqpIUfM3GViKe0QnuDaU+FYw5Y8e9WOQwQfoE/Pr
FGCvsLLrdPQl3Wz/vhMWKmbtHKYt5lVRDnx4A0iamCRrprutOmMZwcii1NZHvxh0
udVZibdTScxA8NUSE4aQW/vFs69oOg==
=0td+
-----END PGP SIGNATURE-----

--CRPE6zOJJRoRnbtL--

