Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698E6F78FF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfKKQkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:40:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59707 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbfKKQkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573490452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6V3+R1B+3hBYZaTTuhiBOwhwyNFcmbVPeH92ygUSuhw=;
        b=AkkqywgDFXe2gb+GxX4pEaRJmeSUjyCo1FHRnP8EIIhsOKoAymB+qioH0UyzzxkjAgJWQG
        ddtEP7kWuncfuoVPA4PKR6nDhNmErZDn8MntO4Gx+ccAaDxROp40N1Eao7c63Aq8ctbKkT
        H8a/ukOgphda5GjBKuUUnwtQ6ymV6JA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-LlkbJaj-NGiMWiaaH33eGw-1; Mon, 11 Nov 2019 11:40:49 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D5BD107ACE5;
        Mon, 11 Nov 2019 16:40:47 +0000 (UTC)
Received: from gondolin (ovpn-117-4.ams2.redhat.com [10.36.117.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 838905EE1A;
        Mon, 11 Nov 2019 16:40:42 +0000 (UTC)
Date:   Mon, 11 Nov 2019 17:40:39 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 06/37] s390: UV: Add import and export to UV library
Message-ID: <20191111174039.608f53fb.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-7-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: LlkbJaj-NGiMWiaaH33eGw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:28 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> The convert to/from secure (or also "import/export") ultravisor calls
> are need for page management, i.e. paging, of secure execution VM.
>=20
> Export encrypts a secure guest's page and makes it accessible to the
> guest for paging.
>=20
> Import makes a page accessible to a secure guest.
> On the first import of that page, the page will be cleared by the
> Ultravisor before it is given to the guest.
>=20
> All following imports will decrypt a exported page and verify
> integrity before giving the page to the guest.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 51 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 0bfbafcca136..99cdd2034503 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -15,6 +15,7 @@
>  #include <linux/errno.h>
>  #include <linux/bug.h>
>  #include <asm/page.h>
> +#include <asm/gmap.h>
> =20
>  #define UVC_RC_EXECUTED=09=090x0001
>  #define UVC_RC_INV_CMD=09=090x0002
> @@ -279,6 +280,54 @@ static inline int uv_cmd_nodata(u64 handle, u16 cmd,=
 u32 *ret)
>  =09return rc ? -EINVAL : 0;
>  }
> =20
> +/*
> + * Requests the Ultravisor to encrypt a guest page and make it
> + * accessible to the host for paging (export).
> + *
> + * @paddr: Absolute host address of page to be exported
> + */
> +static inline int uv_convert_from_secure(unsigned long paddr)
> +{
> +=09struct uv_cb_cfs uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_CONV_FROM_SEC_STOR,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.paddr =3D paddr
> +=09};
> +=09if (!uv_call(0, (u64)&uvcb))
> +=09=09return 0;
> +=09return -EINVAL;

No possibility for other return codes here (e.g. -EFAULT)? (Asking
because you look at a rc in the control block in the reverse function.)

> +}
> +
> +/*
> + * Requests the Ultravisor to make a page accessible to a guest
> + * (import). If it's brought in the first time, it will be cleared. If
> + * it has been exported before, it will be decrypted and integrity
> + * checked.
> + *
> + * @handle: Ultravisor guest handle
> + * @gaddr: Guest 2 absolute address to be imported
> + */
> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned long =
gaddr)
> +{
> +=09int cc;
> +=09struct uv_cb_cts uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.guest_handle =3D gmap->se_handle,
> +=09=09.gaddr =3D gaddr
> +=09};
> +
> +=09cc =3D uv_call(0, (u64)&uvcb);
> +
> +=09if (!cc)
> +=09=09return 0;
> +=09if (uvcb.header.rc =3D=3D 0x104)
> +=09=09return -EEXIST;
> +=09if (uvcb.header.rc =3D=3D 0x10a)
> +=09=09return -EFAULT;
> +=09return -EINVAL;
> +}
> +
>  void setup_uv(void);
>  void adjust_to_uv_max(unsigned long *vmax);
>  #else
> @@ -286,6 +335,8 @@ void adjust_to_uv_max(unsigned long *vmax);
>  static inline void setup_uv(void) {}
>  static inline void adjust_to_uv_max(unsigned long *vmax) {}
>  static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret) { return =
0; }
> +static inline int uv_convert_from_secure(unsigned long paddr) { return 0=
; }
> +static inline int uv_convert_to_secure(unsigned long handle, unsigned lo=
ng gaddr) { return 0; }
>  #endif
> =20
>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                   =
       \

