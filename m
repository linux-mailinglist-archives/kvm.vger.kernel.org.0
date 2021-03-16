Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1873E33D96A
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 17:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhCPQ3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 12:29:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237714AbhCPQ2n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 12:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615912123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TytJac2gNJXuV+nGBNcPludbBOtJAyjEg0gAFD8NdM=;
        b=D+zibJ18Zm/wQcEa6/seDJHBenTB+k8LX06Lvr8ObxcMH+23EqbqzSaGIcSxOlrTZz/5oU
        qN7Vh8g2+mh9jxFAkVbaYKKppqd6GP2MajD1aKSWquWYBWg/0D9EWuWDJFAVxUDj1nlKgv
        4xc/2Q6WOcbjQBsCAakK/09XGTTEAZ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-3XKfunlwMVC37ZxggmTyyg-1; Tue, 16 Mar 2021 12:28:37 -0400
X-MC-Unique: 3XKfunlwMVC37ZxggmTyyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19A591940922;
        Tue, 16 Mar 2021 16:28:35 +0000 (UTC)
Received: from gondolin (ovpn-113-185.ams2.redhat.com [10.36.113.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 787A21001281;
        Tue, 16 Mar 2021 16:28:25 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:28:22 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 05/14] vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
Message-ID: <20210316172822.0b44ff76.cohuck@redhat.com>
In-Reply-To: <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:55:57 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> vfio_add_group_dev() must be called only after all of the private data in
> vdev is fully setup and ready, otherwise there could be races with user
> space instantiating a device file descriptor and starting to call ops.
> 
> For instance vfio_fsl_mc_reflck_attach() sets vdev->reflck and
> vfio_fsl_mc_open(), called by fops open, unconditionally derefs it, which
> will crash if things get out of order.
> 
> This driver started life with the right sequence, but three commits added
> stuff after vfio_add_group_dev().
> 
> Fixes: 2e0d29561f59 ("vfio/fsl-mc: Add irq infrastructure for fsl-mc devices")
> Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
> Fixes: 704f5082d845 ("vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 43 ++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 21 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

