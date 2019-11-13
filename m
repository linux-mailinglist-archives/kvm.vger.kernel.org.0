Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46F6FAE7C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 11:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfKMK2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 05:28:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726991AbfKMK2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 05:28:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573640928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3autvsTwXRgzZBTKOSol7i8PLRsHWJaglOb54UD7HU=;
        b=SHOXGRX3rcR4z4H1YHY6lZrNEq10OmV2K4ipquB+Pzo1G1mMEtjIjC/qC4o/jnZW0c4qb4
        8ofes+PJ4FXwFSMMdUy8cgwctqBqqCe/AofVkZjxfYfn8w9Qpzic9tH+IK0+YsyToz6gHe
        DWvqCh9qWTyWCVDTs9/3LqMNPY47n18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-O4B3qXHWOICjFPSgG9e9iw-1; Wed, 13 Nov 2019 05:28:45 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE0398E8E06;
        Wed, 13 Nov 2019 10:28:43 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F9DB5C1D8;
        Wed, 13 Nov 2019 10:28:36 +0000 (UTC)
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <07705597-8e8f-28d4-f9a1-d3d5dc9a4555@redhat.com>
Date:   Wed, 13 Nov 2019 11:28:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-5-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: O4B3qXHWOICjFPSgG9e9iw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Let's add a KVM interface to create and destroy protected VMs.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
[...]
> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned lon=
g size,
> +=09=09       unsigned long tweak)
> +{
> +=09int i, rc =3D 0;
> +=09struct uv_cb_unp uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_UNPACK_IMG,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.guest_handle =3D kvm_s390_pv_handle(kvm),
> +=09=09.tweak[0] =3D tweak
> +=09};
> +
> +=09if (addr & ~PAGE_MASK || size & ~PAGE_MASK)
> +=09=09return -EINVAL;

Also check for size =3D=3D 0 ?

> +
> +

Remove one of the two empty lines, please.

> +=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
> +=09=09 addr, size);
> +=09for (i =3D 0; i < size / PAGE_SIZE; i++) {
> +=09=09uvcb.gaddr =3D addr + i * PAGE_SIZE;
> +=09=09uvcb.tweak[1] =3D i * PAGE_SIZE;
> +retry:
> +=09=09rc =3D uv_call(0, (u64)&uvcb);
> +=09=09if (!rc)
> +=09=09=09continue;
> +=09=09/* If not yet mapped fault and retry */
> +=09=09if (uvcb.header.rc =3D=3D 0x10a) {
> +=09=09=09rc =3D gmap_fault(kvm->arch.gmap, uvcb.gaddr,
> +=09=09=09=09=09FAULT_FLAG_WRITE);
> +=09=09=09if (rc)
> +=09=09=09=09return rc;
> +=09=09=09goto retry;
> +=09=09}
> +=09=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %=
x",
> +=09=09=09 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
> +=09=09break;

A break at the end of the for-loop ... that's really not what I'd expect.

Could you please invert the logic here, i.e.:

    if (uvcb.header.rc !=3D 0x10a) {
        VM_EVENT(...)
        break;
    }
    rc =3D gmap_fault(...)
    ...

I think you might even get rid of that ugly "goto", too, that way?

> +=09}
> +=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x rrc %x",
> +=09=09 uvcb.header.rc, uvcb.header.rrc);
> +=09return rc;
> +}

 Thomas

