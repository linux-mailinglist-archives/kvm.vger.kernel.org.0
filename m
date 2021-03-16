Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D74C33D9D8
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 17:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhCPQw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 12:52:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236447AbhCPQv5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 12:51:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615913516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9jpOCbZA/l2QnntOGpmGDMzGXgtWzYyqIgHe2qo/qA=;
        b=F0O5a3uykCpkPVbscTIuoMRL7Xq9wSFPs2V/wJZdfWxueoS4v/Ihfioqj1hs75yjs5eUO1
        dtEL709OgzQ1mvewU9ckTUct0fT9psoH86FSZlWrDzvBLmWVccjVIadTl5SizhfCUWZhLT
        j+z01JFVj2sck31/7kMQn6mqKoQGUGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-Th78Mf5hP4Wo6Qnw-bAr7g-1; Tue, 16 Mar 2021 12:51:55 -0400
X-MC-Unique: Th78Mf5hP4Wo6Qnw-bAr7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BD1783DD22;
        Tue, 16 Mar 2021 16:51:53 +0000 (UTC)
Received: from gondolin (ovpn-113-185.ams2.redhat.com [10.36.113.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 354C919069;
        Tue, 16 Mar 2021 16:51:45 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:51:42 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
Message-ID: <20210316175142.453bc818.cohuck@redhat.com>
In-Reply-To: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:55:59 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> vfio_pci_probe() is quite complicated, with optional VF and VGA sub
> components. Move these into clear init/uninit functions and have a linear
> flow in probe/remove.
> 
> This fixes a few little buglets:
>  - vfio_pci_remove() is in the wrong order, vga_client_register() removes
>    a notifier and is after kfree(vdev), but the notifier refers to vdev,
>    so it can use after free in a race.
>  - vga_client_register() can fail but was ignored
> 
> Organize things so destruction order is the reverse of creation order.
> 
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 116 +++++++++++++++++++++++-------------
>  1 file changed, 74 insertions(+), 42 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

