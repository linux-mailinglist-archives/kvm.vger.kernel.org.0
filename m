Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18656E92F8
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 23:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfJ2WU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 18:20:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51839 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725909AbfJ2WU0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Oct 2019 18:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572387625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5eWT9nPy+R5O4U/dHhPn5efOlyKUPzVBsOetLDlPYDU=;
        b=ZJqLNtPx8t6Dsd2vNGTSkF0rZnjWsErulJaYS8hyITSvEvUl2zIS5Q0PAIBeEkteUhzfZI
        Nyo+OumAxmssXG7f4hk4AXoZ8Q/Tw/tKvGMkd8hqvYl2uIjNlj6xc52uq3WV9e8BMv9H/Y
        flyBgsRGRWuNMyDjy42HVnwl/kFfTXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-dv88SZ0uMyG58oCKmZGY9g-1; Tue, 29 Oct 2019 18:20:22 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 835A45E6;
        Tue, 29 Oct 2019 22:20:20 +0000 (UTC)
Received: from gondolin (ovpn-116-60.ams2.redhat.com [10.36.116.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1D7919D70;
        Tue, 29 Oct 2019 22:20:13 +0000 (UTC)
Date:   Tue, 29 Oct 2019 23:19:17 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, freude@linux.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com
Subject: Re: [PATCH] s390: vfio-ap: disable IRQ in remove callback results
 in kernel OOPS
Message-ID: <20191029231917.0e6a62b9.cohuck@redhat.com>
In-Reply-To: <1572386946-22566-1-git-send-email-akrowiak@linux.ibm.com>
References: <1572386946-22566-1-git-send-email-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: dv88SZ0uMyG58oCKmZGY9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Oct 2019 18:09:06 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> From: aekrowia <akrowiak@linux.ibm.com>

Some accident seems to have happened to your git config.

>=20
> When an AP adapter card is configured off via the SE or the SCLP
> Deconfigure Adjunct Processor command and the AP bus subsequently detects
> that the adapter card is no longer in the AP configuration, the card
> device representing the adapter card as well as each of its associated
> AP queue devices will be removed by the AP bus. If one or more of the
> affected queue devices is bound to the VFIO AP device driver, its remove
> callback will be invoked for each queue to be removed. The remove callbac=
k
> resets the queue and disables IRQ processing. If interrupt processing was
> never enabled for the queue, disabling IRQ processing will fail resulting
> in a kernel OOPS.
>=20
> This patch verifies IRQ processing is enabled before attempting to disabl=
e
> interrupts for the queue.
>=20
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Signed-off-by: aekrowia <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio=
_ap_drv.c
> index be2520cc010b..42d8308fd3a1 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -79,7 +79,8 @@ static void vfio_ap_queue_dev_remove(struct ap_device *=
apdev)
>  =09apid =3D AP_QID_CARD(q->apqn);
>  =09apqi =3D AP_QID_QUEUE(q->apqn);
>  =09vfio_ap_mdev_reset_queue(apid, apqi, 1);
> -=09vfio_ap_irq_disable(q);
> +=09if (q->saved_isc !=3D VFIO_AP_ISC_INVALID)
> +=09=09vfio_ap_irq_disable(q);

Hm... would it make sense to move that check into vfio_ap_irq_disable()
instead? Or are we sure that in all other cases the irq processing had
been enabled before?

Also, if that oops is reasonably easy to trigger, it would probably
make sense to cc:stable. (Or is this a new problem?)

>  =09kfree(q);
>  =09mutex_unlock(&matrix_dev->lock);
>  }

