Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A879BF05E3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390861AbfKETYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:24:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390445AbfKETYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:24:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572981887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDuBnBaNcz8J1ZA9jKrH09ICdJTi+Igu4uXAX/Exyik=;
        b=cMpyYal1g/Djkze8godCU20iiRMcdGaGqFi+iFTz1GN0Xwo/Y+NR+bHkaPtcSlrB0lpv6K
        nI5sWZ/bONQ+q3VUvjmVzTcpfxq3bEIsmiTiCEIU5oMnbuKYkVf+rGxAGEMg4Qnc4f2Zq9
        YF4we70bCCGSo5ZMl035GahES2wiP7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-6BnFi5GPOCeK7zC2FOeztA-1; Tue, 05 Nov 2019 14:24:43 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DEE62A3;
        Tue,  5 Nov 2019 19:24:41 +0000 (UTC)
Received: from x1.home (ovpn-116-110.phx2.redhat.com [10.3.116.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88F5A5C1BB;
        Tue,  5 Nov 2019 19:24:37 +0000 (UTC)
Date:   Tue, 5 Nov 2019 12:24:36 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     <cohuck@redhat.com>, <eric.auger@redhat.com>, <aik@ozlabs.ru>,
        <mpe@ellerman.id.au>, <bhelgaas@google.com>, <tglx@linutronix.de>,
        <hexin.op@gmail.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VFIO: PCI: eliminate unnecessary overhead in
 vfio_pci_reflck_find
Message-ID: <20191105122436.5bd5282f@x1.home>
In-Reply-To: <1572433030-6267-1-git-send-email-linmiaohe@huawei.com>
References: <1572433030-6267-1-git-send-email-linmiaohe@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 6BnFi5GPOCeK7zC2FOeztA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Oct 2019 18:57:10 +0800
linmiaohe <linmiaohe@huawei.com> wrote:

> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> The driver of the pci device may not equal to vfio_pci_driver,
> but we fetch vfio_device from pci_dev unconditionally in func
> vfio_pci_reflck_find. This overhead, such as the competition
> of vfio.group_lock, can be eliminated by check pci_dev_driver
> with vfio_pci_driver first.
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 379a02c36e37..1e21970543a6 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1466,15 +1466,14 @@ static int vfio_pci_reflck_find(struct pci_dev *p=
dev, void *data)
>  =09struct vfio_device *device;
>  =09struct vfio_pci_device *vdev;
> =20
> -=09device =3D vfio_device_get_from_dev(&pdev->dev);
> -=09if (!device)
> -=09=09return 0;
> -
>  =09if (pci_dev_driver(pdev) !=3D &vfio_pci_driver) {
> -=09=09vfio_device_put(device);
>  =09=09return 0;
>  =09}
> =20
> +=09device =3D vfio_device_get_from_dev(&pdev->dev);
> +=09if (!device)
> +=09=09return 0;
> +
>  =09vdev =3D vfio_device_data(device);
> =20
>  =09if (vdev->reflck) {

I believe this introduces a race.  When we hold a reference to the vfio
device, an unbind from a vfio bus driver will be blocked in
vfio_del_group_dev().  Therefore if we test the driver is vfio-pci
while holding this reference, we know that it cannot be released and
the device_data is a valid vfio_pci_device.  Testing the driver prior
to acquiring a vfio device reference is meaningless as we have no
guarantee that the driver has not changed by the time we acquire a
reference.  Are you actually seeing contention here or was this a code
inspection optimization?  Thanks,

Alex

