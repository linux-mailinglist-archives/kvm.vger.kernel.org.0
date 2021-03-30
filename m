Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21D734EC41
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhC3PZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:25:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232370AbhC3PYr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617117886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xLeIxab6mDQDke52x6DpNdNSBo2bnI3mGCEhq0K8Rj4=;
        b=H+VfOKKPE+QkgZ7G5q/CT0XC9mIsQdhuxximuj/HvUYSJjNPk7trNn2v7f1TyHm/i8H7zh
        WfL34RlkGmtJlk7H0gP+22BwuUbTVHj7TeKXTo6H3KIq0FeZ4U7QXsDJu6eaTcIRX2Ngzu
        atW7sGIjqgNJFhIBLidUa8vsb6YXA0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-0zBLyW5ZPFSHSmqchkwttw-1; Tue, 30 Mar 2021 11:24:42 -0400
X-MC-Unique: 0zBLyW5ZPFSHSmqchkwttw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38B95E49E1;
        Tue, 30 Mar 2021 15:24:40 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8393160871;
        Tue, 30 Mar 2021 15:24:34 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:24:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 02/18] vfio/mdev: Add missing typesafety around
 mdev_device
Message-ID: <20210330172431.724282c1.cohuck@redhat.com>
In-Reply-To: <2-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <2-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:55:19 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The mdev API should accept and pass a 'struct mdev_device *' in all
> places, not pass a 'struct device *' and cast it internally with
> to_mdev_device(). Particularly in its struct mdev_driver functions, the
> whole point of a bus's struct device_driver wrapper is to provide type
> safety compared to the default struct device_driver.
> 
> Further, the driver core standard is for bus drivers to expose their
> device structure in their public headers that can be used with
> container_of() inlines and '&foo->dev' to go between the class levels, and
> '&foo->dev' to be used with dev_err/etc driver core helper functions. Move
> 'struct mdev_device' to mdev.h
> 
> Once done this allows moving some one instruction exported functions to
> static inlines, which in turns allows removing one of the two grotesque
> symbol_get()'s related to mdev in the core code.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       |  4 +-
>  drivers/vfio/mdev/mdev_core.c                 | 64 ++-----------------
>  drivers/vfio/mdev/mdev_driver.c               |  4 +-
>  drivers/vfio/mdev/mdev_private.h              | 23 +------
>  drivers/vfio/mdev/mdev_sysfs.c                | 26 ++++----
>  drivers/vfio/mdev/vfio_mdev.c                 |  7 +-
>  drivers/vfio/vfio_iommu_type1.c               | 25 ++------
>  include/linux/mdev.h                          | 58 +++++++++++++----
>  8 files changed, 83 insertions(+), 128 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

