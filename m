Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85303E8D4D
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 11:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhHKJgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 05:36:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236472AbhHKJgb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 05:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628674567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yiNoHAcyou5Ou5txT8iiagT+7oEX1cAH3gpbVtY4zz4=;
        b=EjfG/KwA7lwlupl/9e3X3+G2oXesIL7y7W4UaDgMWF3E7altS7Z1ls2K6CVT8I3JP/2XU1
        RpvAIBOYT7SVQQy7FGiQB6hTssmWIovVOYLTRzLMH/s+GhP7eaHvuuvuLpvvCVjsLrboR9
        35eYDuqiIaViBRo5jBKX5K8YKnK85wc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-h_CveXh8MYqqsgCZvVLxhQ-1; Wed, 11 Aug 2021 05:36:04 -0400
X-MC-Unique: h_CveXh8MYqqsgCZvVLxhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E78CD801A92;
        Wed, 11 Aug 2021 09:35:59 +0000 (UTC)
Received: from localhost (unknown [10.39.192.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2FB9620DE;
        Wed, 11 Aug 2021 09:35:51 +0000 (UTC)
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
Subject: Re: [PATCH v4 08/14] vfio/pci: Move to the device set infrastructure
In-Reply-To: <8-v4-9ea22c5e6afb+1adf-vfio_reflck_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <8-v4-9ea22c5e6afb+1adf-vfio_reflck_jgg@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 11 Aug 2021 11:35:50 +0200
Message-ID: <87zgtouxvt.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> From: Yishai Hadas <yishaih@nvidia.com>
>
> PCI wants to have the usual open/close_device() logic with the slight
> twist that the open/close_device() must be done under a singelton lock
> shared by all of the vfio_devices that are in the PCI "reset group".
>
> The reset group, and thus the device set, is determined by what devices
> pci_reset_bus() touches, which is either the entire bus or only the slot.
>
> Rely on the core code to do everything reflck was doing and delete reflck
> entirely.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 162 +++++++---------------------
>  drivers/vfio/pci/vfio_pci_private.h |   7 --
>  2 files changed, 37 insertions(+), 132 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

