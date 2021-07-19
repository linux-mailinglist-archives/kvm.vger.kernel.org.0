Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82013CD710
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241190AbhGSOE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 10:04:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232531AbhGSOE5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 10:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626705937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UyRUtFYmxkhkvXTjyXTCYNWwlpNIWrI0mswGdMQlRtQ=;
        b=Wdu1east2v0SBdCNc0fMzGXRTpVgXkf0207PnYYEshUPqpWAdi7ymS40+dgFwkxKWJ3uGn
        9pXwJAvJ1tjOVPmYK37/jYe3aYeJ/3qSAYa88ITq1jzoq//msdF8SPAUB0eCpBsMAztP9s
        EuuM5aTIUkZQSjKTjqIurtSoc6VXNsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-9dUSJg9oPkyuOzaJb7ANGg-1; Mon, 19 Jul 2021 10:45:35 -0400
X-MC-Unique: 9dUSJg9oPkyuOzaJb7ANGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E37FC804140;
        Mon, 19 Jul 2021 14:45:31 +0000 (UTC)
Received: from localhost (ovpn-112-158.ams2.redhat.com [10.36.112.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F18E760CC9;
        Mon, 19 Jul 2021 14:45:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH 10/13] vfio/mbochs: Fix close when multiple device FDs
 are open
In-Reply-To: <10-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <10-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 19 Jul 2021 16:45:22 +0200
Message-ID: <87o8ay9xbx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 14 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> mbochs_close() iterates over global device state and frees it. Currently
> this is done every time a device FD is closed, but if multiple device FDs
> are open this could corrupt other still active FDs.
>
> Change this to use close_device() so it only runs on the last close.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mbochs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

