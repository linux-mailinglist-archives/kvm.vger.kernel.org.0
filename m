Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A9BE45C4
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407208AbfJYIcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:32:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54164 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407258AbfJYIcE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 04:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571992322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dkz6zcz8r8KOvL7An1NT3Ed7AiJ1RteRZMwYRuZb8t0=;
        b=TgRCfhIPB4DCUTN3DpFUcFxfY/eTJ1fyaZUsyMODtA+8xTx24UF4xeK6JLdL00ohGY3Z7q
        1kvHidgk9D6ZqFv1mZSrFRkNF5J27g17ea6Uf1VHo8LAvtpHczljW77I4Q48AbZeZN02Ol
        h7J1odjF2cJKd7LfJINFkHgtJtO/D9w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-H3kRoLj1PjiqMx7O1jnItA-1; Fri, 25 Oct 2019 04:31:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B12CA800D41;
        Fri, 25 Oct 2019 08:31:57 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4A4B194B6;
        Fri, 25 Oct 2019 08:31:55 +0000 (UTC)
Subject: Re: [RFC 06/37] s390: UV: Add import and export to UV library
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-7-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <32166470-43c1-f454-440f-3f660b995ca2@redhat.com>
Date:   Fri, 25 Oct 2019 10:31:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-7-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: H3kRoLj1PjiqMx7O1jnItA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> The convert to/from secure (or also "import/export") ultravisor calls
> are need for page management, i.e. paging, of secure execution VM.
>=20
> Export encrypts a secure guest's page and makes it accessible to the
> guest for paging.

How does paging play along with pinning the pages (from=20
uv_convert_to_secure() -> kvm_s390_pv_pin_page()) in a follow up patch?=20
Can you paint me the bigger picture?

Just so I understand:

When a page is "secure", it is actually unencrypted but only the guest=20
can access it. If the host accesses it, there is an exception.

When a page is "not secure", it is encrypted but only the host can read=20
it. If the guest accesses it, there is an exception.

Based on these exceptions, you are able to request to convert back and=20
forth.


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
>   arch/s390/include/asm/uv.h | 51 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 51 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 0bfbafcca136..99cdd2034503 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -15,6 +15,7 @@
>   #include <linux/errno.h>
>   #include <linux/bug.h>
>   #include <asm/page.h>
> +#include <asm/gmap.h>
>  =20
>   #define UVC_RC_EXECUTED=09=090x0001
>   #define UVC_RC_INV_CMD=09=090x0002
> @@ -279,6 +280,54 @@ static inline int uv_cmd_nodata(u64 handle, u16 cmd,=
 u32 *ret)
>   =09return rc ? -EINVAL : 0;
>   }
>  =20
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
>   void setup_uv(void);
>   void adjust_to_uv_max(unsigned long *vmax);
>   #else
> @@ -286,6 +335,8 @@ void adjust_to_uv_max(unsigned long *vmax);
>   static inline void setup_uv(void) {}
>   static inline void adjust_to_uv_max(unsigned long *vmax) {}
>   static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret) { return=
 0; }
> +static inline int uv_convert_from_secure(unsigned long paddr) { return 0=
; }
> +static inline int uv_convert_to_secure(unsigned long handle, unsigned lo=
ng gaddr) { return 0; }
>   #endif
>  =20
>   #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                  =
        \
>=20


--=20

Thanks,

David / dhildenb

