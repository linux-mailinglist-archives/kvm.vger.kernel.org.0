Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF8B33D376
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 13:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbhCPL7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 07:59:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233477AbhCPL7Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 07:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615895959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AK4EbJjy+Y6rbhB5ZAXdVwEjCD172TgICTnCKYN+6zQ=;
        b=LQOe8/5VaBupGRasTtn5qWkvA4X7qHPVPFaSUmsfs75g739Q1jHdVX8jOvoo+nbKLYOwlS
        cbd/STGs+Ida1WB4/7ywMyFDDNeInws36KaLfk4Bt2DvPZwNaxdcVixE8AkG5p+8puzKHh
        LlMAg5jz5aZrioSVZGat1CdYMSN+GFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-1_Lyp8JmOj6Hmn2gtDTucw-1; Tue, 16 Mar 2021 07:59:17 -0400
X-MC-Unique: 1_Lyp8JmOj6Hmn2gtDTucw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 406F910866A8;
        Tue, 16 Mar 2021 11:59:15 +0000 (UTC)
Received: from gondolin (ovpn-113-185.ams2.redhat.com [10.36.113.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C291F5D9D3;
        Tue, 16 Mar 2021 11:59:09 +0000 (UTC)
Date:   Tue, 16 Mar 2021 12:59:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
Message-ID: <20210316125906.46c3620c.cohuck@redhat.com>
In-Reply-To: <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:55:53 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The vfio_device->group value has a get obtained during
> vfio_add_group_dev() which gets moved from the stack to vfio_device->group
> in vfio_group_create_device().
> 
> The reference remains until we reach the end of vfio_del_group_dev() when
> it is put back.
> 
> Thus anything that already has a kref on the vfio_device is guaranteed a
> valid group pointer. Remove all the extra reference traffic.
> 
> It is tricky to see, but the get at the start of vfio_del_group_dev() is
> actually pairing with the put hidden inside vfio_device_put() a few lines
> below.
> 
> A later patch merges vfio_group_create_device() into vfio_add_group_dev()
> which makes the ownership and error flow on the create side easier to
> follow.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

