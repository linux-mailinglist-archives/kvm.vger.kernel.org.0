Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14963255627
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgH1IO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:14:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728218AbgH1IOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 04:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598602455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eVltF15+grxY0nM9D89n418UBRFi0LUbuLcAjdjJCm0=;
        b=ePNwo0SinGDDtZPgkALtpMjGiA1G6V16wkn0quLY7Z+0F0zr2tKVDFRsrH7BiB5T6GtHZU
        9fovJDLnh67UurIRAkVmR9km3dkA+RcT3XxrujPniF20NcP3dHHuLG90qMLtXYZHRmVGbL
        LOg+d/KK8jd4Qh9amGoLjhNVYSFdtrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-rbeO0EZjMYKEozcGg-8PkA-1; Fri, 28 Aug 2020 04:14:11 -0400
X-MC-Unique: rbeO0EZjMYKEozcGg-8PkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F17C802B47;
        Fri, 28 Aug 2020 08:14:09 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56FCA74E1E;
        Fri, 28 Aug 2020 08:14:00 +0000 (UTC)
Date:   Fri, 28 Aug 2020 10:13:57 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
Message-ID: <20200828101357.2ccbc39a.cohuck@redhat.com>
In-Reply-To: <b1c6bad8-3ec6-183c-3e35-9962e9c721c7@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-3-akrowiak@linux.ibm.com>
        <20200825121334.0ff35d7a.cohuck@redhat.com>
        <b1c6bad8-3ec6-183c-3e35-9962e9c721c7@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Aug 2020 10:24:07 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 8/25/20 6:13 AM, Cornelia Huck wrote:
> > On Fri, 21 Aug 2020 15:56:02 -0400
> > Tony Krowiak<akrowiak@linux.ibm.com>  wrote:

> >>   /**
> >> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a li=
st
> >> - * @matrix_mdev: the associated mediated matrix
> >> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
> >>    * @apqn: The queue APQN
> >>    *
> >> - * Retrieve a queue with a specific APQN from the list of the
> >> - * devices of the vfio_ap_drv.
> >> - * Verify that the APID and the APQI are set in the matrix.
> >> + * Retrieve a queue with a specific APQN from the AP queue devices at=
tached to
> >> + * the AP bus.
> >>    *
> >> - * Returns the pointer to the associated vfio_ap_queue
> >> + * Returns the pointer to the vfio_ap_queue with the specified APQN, =
or NULL.
> >>    */
> >> -static struct vfio_ap_queue *vfio_ap_get_queue(
> >> -					struct ap_matrix_mdev *matrix_mdev,
> >> -					int apqn)
> >> +static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
> >>   {
> >> +	struct ap_queue *queue;
> >>   	struct vfio_ap_queue *q;
> >> -	struct device *dev;
> >>  =20
> >> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> >> -		return NULL;
> >> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm)) =20
> > I think you should add some explanation to the patch description why
> > testing the matrix bitmasks is not needed anymore. =20
>=20
> As a result of this comment, I took a closer look at the code to
> determine the reason for eliminating the matrix_mdev
> parameter. The reason is because the code below (i.e., find the device
> and get the driver data) was also repeated in the vfio_ap_irq_disable_apq=
n()
> function, so I replaced it with a call to the function above; however, the
> vfio_ap_irq_disable_apqn() function=C2=A0 does not have a reference to the
> matrix_mdev, so I eliminated the matrix_mdev parameter. Note that the
> vfio_ap_irq_disable_apqn() is called for each APQN assigned to a matrix
> mdev, so there is no need to test the bitmasks there.
>=20
> The other place from which the function above is called is
> the handle_pqap() function which does have a reference to the
> matrix_mdev. In order to ensure the integrity of the instruction
> being intercepted - i.e., PQAP(AQIC) enable/disable IRQ for aN
> AP queue - the testing of the matrix bitmasks probably ought to
> be performed, so it will be done there instead of in the
> vfio_ap_get_queue() function above.

Should you add a comment that vfio_ap_get_queue() assumes that the
caller makes sure that this is only called for APQNs that are assigned
to a matrix?

>=20
>=20
> > +	queue =3D ap_get_qdev(apqn);
> > +	if (!queue)
> >   		return NULL;
> >  =20
> > -	dev =3D driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> > -				 &apqn, match_apqn);
> > -	if (!dev)
> > -		return NULL;
> > -	q =3D dev_get_drvdata(dev);
> > -	q->matrix_mdev =3D matrix_mdev;
> > -	put_device(dev);
> > +	q =3D dev_get_drvdata(&queue->ap_dev.device);
> > +	put_device(&queue->ap_dev.device);
> >  =20
> >   	return q;
> >   }
> > (...)
> > =20
>=20

