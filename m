Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0676E3D2627
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 16:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhGVOIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 10:08:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232328AbhGVOIO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 10:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626965328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zcazrHRmrdUI7TLRVzAfUPzPLR8CDoZHugRg17DaTr8=;
        b=gzJ2UcnwRzsSCIDR3eO9UIs5B/xJlPv/WHKx0ubjNKcCy25LrVDnXLGTBzBZWw4RF5pxo0
        6II2a1VsyqT5B2zMNRo35RnKZFHKgClc0ICj1pBdEdCrupI9KkjF53ugvRTwuXse9Brx1f
        7feZaSqKYiwRg7XLUYz28emaju1wnYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-RATX3Rf1PGqQpwFT7SpNWQ-1; Thu, 22 Jul 2021 10:48:47 -0400
X-MC-Unique: RATX3Rf1PGqQpwFT7SpNWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AB31804141;
        Thu, 22 Jul 2021 14:48:43 +0000 (UTC)
Received: from localhost (ovpn-112-132.ams2.redhat.com [10.36.112.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2648A5DA2D;
        Thu, 22 Jul 2021 14:48:33 +0000 (UTC)
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
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 07/14] vfio/platform: Use open_device() instead of
 open coding a refcnt scheme
In-Reply-To: <7-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <7-v2-b6a5582525c9+ff96-vfio_reflck_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 22 Jul 2021 16:48:31 +0200
Message-ID: <878s1y76bk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> Platform simply wants to run some code when the device is first
> opened/last closed. Use the core framework and locking for this.  Aside
> from removing a bit of code this narrows the locking scope from a global
> lock.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c  | 79 ++++++++-----------
>  drivers/vfio/platform/vfio_platform_private.h |  1 -
>  2 files changed, 32 insertions(+), 48 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

