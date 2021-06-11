Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE923A4226
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 14:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhFKMm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 08:42:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231458AbhFKMm4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 08:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623415258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lE67WyKbl741YpDCTe3QkT0OdknMJfyRErLnc4JjkJk=;
        b=gmHiyy+rfv5j2yi7QRC2PkYcb9mQABxBMMyIjVZKsaRlAWJ8lM/VQABlE6HtousKsJdBYA
        2xT/20ycYgz58WA8VaC7sjWP9ZxreGheBjBHrAuJOMDF+0QRAg8pu8bto/6NdqAyxr2erM
        PGl+brf/ZWF6mSosGc0vktgrKRE0Fig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-tDRVUUZtNSy-5sW1P9P8dw-1; Fri, 11 Jun 2021 08:40:50 -0400
X-MC-Unique: tDRVUUZtNSy-5sW1P9P8dw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F5111923762;
        Fri, 11 Jun 2021 12:40:47 +0000 (UTC)
Received: from localhost (ovpn-113-95.ams2.redhat.com [10.36.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D32A260C05;
        Fri, 11 Jun 2021 12:40:42 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 06/10] vfio/mdev: Remove CONFIG_VFIO_MDEV_DEVICE
In-Reply-To: <6-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <6-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Fri, 11 Jun 2021 14:40:41 +0200
Message-ID: <87czsszi9i.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> For some reason the vfio_mdev shim mdev_driver has its own module and
> kconfig. As the next patch requires access to it from mdev.ko merge the
> two modules together and remove VFIO_MDEV_DEVICE.
>
> A later patch deletes this driver entirely.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/s390/vfio-ap.rst   |  1 -
>  arch/s390/Kconfig                |  2 +-
>  drivers/gpu/drm/i915/Kconfig     |  2 +-
>  drivers/vfio/mdev/Kconfig        |  7 -------
>  drivers/vfio/mdev/Makefile       |  3 +--
>  drivers/vfio/mdev/mdev_core.c    | 16 ++++++++++++++--
>  drivers/vfio/mdev/mdev_private.h |  2 ++
>  drivers/vfio/mdev/vfio_mdev.c    | 24 +-----------------------
>  samples/Kconfig                  |  6 +++---
>  9 files changed, 23 insertions(+), 40 deletions(-)

I think you missed my earlier

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

