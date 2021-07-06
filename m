Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172CA3BDACA
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 17:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhGFQBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 12:01:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230108AbhGFQBM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 12:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625587113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CtgBxXlhJt8Wtll8aba26kDe6OF3hHBqz0hVb5nuD0E=;
        b=PnML8WqNifp7Om7/+Ec2pSuYDNB+uaoz1KBIn7uY3FdZA0tzCw+t576SGc1TKVVwp0mY4j
        60WLYJB20QCCDPN3KzYRpWCLRcrDrgDEzN+M/IS5Z0KONG+u6WTMFrsIYzpstSo9hfMJtH
        XuweCNEdpEKO2Rau91pFehh+ziSvNXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-3tmVkwYNON-NoZjdKr8Puw-1; Tue, 06 Jul 2021 11:58:30 -0400
X-MC-Unique: 3tmVkwYNON-NoZjdKr8Puw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1302E362F8;
        Tue,  6 Jul 2021 15:58:28 +0000 (UTC)
Received: from localhost (ovpn-113-13.ams2.redhat.com [10.36.113.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A55719D9D;
        Tue,  6 Jul 2021 15:58:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kernel@pengutronix.de, Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] s390/cio: Make struct css_driver::remove return
 void
In-Reply-To: <20210706154803.1631813-2-u.kleine-koenig@pengutronix.de>
Organization: Red Hat GmbH
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-2-u.kleine-koenig@pengutronix.de>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 06 Jul 2021 17:58:25 +0200
Message-ID: <87zguzfn8e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06 2021, Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>=
 wrote:

> The driver core ignores the return value of css_remove()
> (because there is only little it can do when a device disappears) and
> there are no pci_epf_drivers with a remove callback.

s/pci_epf/css/

>
> So make it impossible for future drivers to return an unused error code
> by changing the remove prototype to return void.
>
> The real motivation for this change is the quest to make struct
> bus_type::remove return void, too.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/s390/cio/chsc_sch.c     | 3 +--
>  drivers/s390/cio/css.c          | 7 ++++---
>  drivers/s390/cio/css.h          | 2 +-
>  drivers/s390/cio/device.c       | 5 ++---
>  drivers/s390/cio/eadm_sch.c     | 4 +---
>  drivers/s390/cio/vfio_ccw_drv.c | 3 +--
>  6 files changed, 10 insertions(+), 14 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

