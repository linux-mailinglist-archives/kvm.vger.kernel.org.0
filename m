Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882BFFB2AD
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 15:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKMOgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 09:36:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726957AbfKMOgO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 09:36:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xWDKgi8hyKELKckEbHa2ghQc5tatezsGk0pMWoMaq2s=;
        b=ca65f/kyIwwh3xKJu9kCRV480HzJRaDdn6G2j/7lPSfZXrldjVpuaKdHcP5wBdVBi5BT26
        q5iTbflAlKYGrNMIhGetCoQaDOYwvyaD+0SYFo1IAODhTfn4v/JtEGrKrWcw1IkGzhX/1n
        anI6MLkoMkeZk5JPeb5XUDv56LW3kPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-KDbfKjx1PSWMOQIlQvF8pA-1; Wed, 13 Nov 2019 09:36:12 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16AFB8C0861;
        Wed, 13 Nov 2019 14:36:11 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55AD64D74B;
        Wed, 13 Nov 2019 14:36:07 +0000 (UTC)
Date:   Wed, 13 Nov 2019 15:36:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH] Fix unpack
Message-ID: <20191113153605.09daa11c.cohuck@redhat.com>
In-Reply-To: <20191113140306.2952-1-frankja@linux.ibm.com>
References: <07705597-8e8f-28d4-f9a1-d3d5dc9a4555@redhat.com>
        <20191113140306.2952-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: KDbfKjx1PSWMOQIlQvF8pA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Nov 2019 09:03:06 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

You seem to have dropped some cc:s :(

> That should be easier to read :)
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/pv.c | 60 +++++++++++++++++++++++++++-------------------
>  1 file changed, 35 insertions(+), 25 deletions(-)
>=20
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 94cf16f40f25..fd73afb33b20 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -195,43 +195,53 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
>  =09return 0;
>  }
> =20
> -int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned lon=
g size,
> -=09=09       unsigned long tweak)
> +static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2])
>  {
> -=09int i, rc =3D 0;
> +=09int rc;
>  =09struct uv_cb_unp uvcb =3D {
>  =09=09.header.cmd =3D UVC_CMD_UNPACK_IMG,
>  =09=09.header.len =3D sizeof(uvcb),
>  =09=09.guest_handle =3D kvm_s390_pv_handle(kvm),
> -=09=09.tweak[0] =3D tweak
> +=09=09.gaddr =3D addr,
> +=09=09.tweak[0] =3D tweak[0],
> +=09=09.tweak[1] =3D tweak[1],
>  =09};
> =20
> -=09if (addr & ~PAGE_MASK || size & ~PAGE_MASK)
> -=09=09return -EINVAL;
> +=09rc =3D uv_call(0, (u64)&uvcb);
> +=09if (!rc)
> +=09=09return rc;
> +=09if (uvcb.header.rc =3D=3D 0x10a) {
> +=09=09/* If not yet mapped fault and retry */
> +=09=09rc =3D gmap_fault(kvm->arch.gmap, uvcb.gaddr,
> +=09=09=09=09FAULT_FLAG_WRITE);
> +=09=09if (!rc)
> +=09=09=09return -EAGAIN;
> +=09}
> +=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %x",
> +=09=09 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
> +=09return rc;
> +}
> =20
> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned lon=
g size,
> +=09=09       unsigned long tweak)
> +{
> +=09int rc =3D 0;
> +=09u64 tw[2] =3D {tweak, 0};
> +
> +=09if (addr & ~PAGE_MASK || !size || size & ~PAGE_MASK)
> +=09=09return -EINVAL;
> =20
>  =09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
>  =09=09 addr, size);
> -=09for (i =3D 0; i < size / PAGE_SIZE; i++) {
> -=09=09uvcb.gaddr =3D addr + i * PAGE_SIZE;
> -=09=09uvcb.tweak[1] =3D i * PAGE_SIZE;
> -retry:
> -=09=09rc =3D uv_call(0, (u64)&uvcb);
> -=09=09if (!rc)
> +=09while (tw[1] < size) {
> +=09=09rc =3D unpack_one(kvm, addr, tw);
> +=09=09if (rc =3D=3D -EAGAIN)
>  =09=09=09continue;
> -=09=09/* If not yet mapped fault and retry */
> -=09=09if (uvcb.header.rc =3D=3D 0x10a) {
> -=09=09=09rc =3D gmap_fault(kvm->arch.gmap, uvcb.gaddr,
> -=09=09=09=09=09FAULT_FLAG_WRITE);
> -=09=09=09if (rc)
> -=09=09=09=09return rc;
> -=09=09=09goto retry;
> -=09=09}
> -=09=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %=
x",
> -=09=09=09 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
> -=09=09break;
> +=09=09if (rc)
> +=09=09=09break;
> +=09=09addr +=3D PAGE_SIZE;
> +=09=09tw[1] +=3D PAGE_SIZE;
>  =09}
> -=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x rrc %x",
> -=09=09 uvcb.header.rc, uvcb.header.rrc);
> +=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished rc %x", rc);
>  =09return rc;
>  }

Yes, this looks more readable.

