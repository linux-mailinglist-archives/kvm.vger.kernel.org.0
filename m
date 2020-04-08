Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58F41A2728
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 18:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgDHQ2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 12:28:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27517 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728005AbgDHQ2D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 12:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586363282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/L4ALyvrKq9jt7009jD8vn4VfcLT3lIG5y3VVV2B/M=;
        b=bT62Mqf2xoy1ldKxsBWTXhULeMB7dRaUd2jYgBeWl2HGEm7P9dtccYA5PvrOsk8H5vTj6t
        Gr5QNr4kZl7TylokMutsk/fhkDB0YGDA49mR9tmN3/evdByBXpXGvAz+6ra2YzAjunL+8p
        dNPTd8Uc0F0BU53nyvrrxNklvF2/F2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140--NMhJJ6tPLq1BtIPxvulPQ-1; Wed, 08 Apr 2020 12:28:00 -0400
X-MC-Unique: -NMhJJ6tPLq1BtIPxvulPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFECDDB60;
        Wed,  8 Apr 2020 16:27:58 +0000 (UTC)
Received: from gondolin (ovpn-113-103.ams2.redhat.com [10.36.113.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 240DF5DA7C;
        Wed,  8 Apr 2020 16:27:52 +0000 (UTC)
Date:   Wed, 8 Apr 2020 18:27:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table
 for quick access
Message-ID: <20200408182750.6d9443f6.cohuck@redhat.com>
In-Reply-To: <e0d56b61-749a-3646-18e7-47bb5c8ca862@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-2-akrowiak@linux.ibm.com>
        <20200408124801.2d61bc5b.cohuck@redhat.com>
        <e0d56b61-749a-3646-18e7-47bb5c8ca862@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Apr 2020 11:38:07 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 4/8/20 6:48 AM, Cornelia Huck wrote:
> > On Tue,  7 Apr 2020 15:20:01 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> > =20
> >> Rather than looping over potentially 65535 objects, let's store the
> >> structures for caching information about queue devices bound to the
> >> vfio_ap device driver in a hash table keyed by APQN. =20
> > This also looks like a nice code simplification.
> > =20
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_drv.c     | 28 +++------
> >>   drivers/s390/crypto/vfio_ap_ops.c     | 90 ++++++++++++++-----------=
--
> >>   drivers/s390/crypto/vfio_ap_private.h | 10 ++-
> >>   3 files changed, 60 insertions(+), 68 deletions(-)
> >> =20
> > (...)

> >> - */
> >> -static struct vfio_ap_queue *vfio_ap_get_queue(
> >> -					struct ap_matrix_mdev *matrix_mdev,
> >> -					int apqn)
> >> +struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
> >>   {
> >>   	struct vfio_ap_queue *q;
> >> -	struct device *dev;
> >> -
> >> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> >> -		return NULL;
> >> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> >> -		return NULL; =20
> > These were just optimizations and therefore can be dropped now? =20
>=20
> The purpose of this function has changed from its previous incarnation.
> This function was originally called from the handle_pqap() function and
> served two purposes: It retrieved the struct vfio_ap_queue as driver data
> and linked the matrix_mdev to the=C2=A0 vfio_ap_queue. The linking of the
> matrix_mdev and the vfio_ap_queue are now done when queue devices
> are probed and when adapters and domains are assigned; so now, the
> handle_pqap() function calls this function to retrieve both the
> vfio_ap_queue as well as the matrix_mdev to which it is linked.=20
> Consequently,
> the above code is no longer needed.

Thanks for the explanation, that makes sense.

>=20
> > =20
> >> -
> >> -	dev =3D driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> >> -				 &apqn, match_apqn);
> >> -	if (!dev)
> >> -		return NULL;
> >> -	q =3D dev_get_drvdata(dev);
> >> -	q->matrix_mdev =3D matrix_mdev;
> >> -	put_device(dev);
> >>  =20
> >> -	return q;
> >> +	hash_for_each_possible(matrix_dev->qtable, q, qnode, apqn) {
> >> +		if (q && (apqn =3D=3D q->apqn))
> >> +			return q;
> >> +	} =20
> > Do we need any serialization here? Previously, the driver core made
> > sure we could get a reference only if the device was still registered;
> > not sure if we need any further guarantees now. =20
>=20
> The vfio_ap_queue structs are created when the queue device is
> probed and removed when the queue device is removed.

Ok, so anything further is not needed.

>=20
> > =20
> >> +
> >> +	return NULL;
> >>   }
> >>  =20
> >>   /** =20
> > (...)
> > =20
>=20

Looks good to me, then. With vfio_ap_get_queue made static and the
kerneldoc restored/updated:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

