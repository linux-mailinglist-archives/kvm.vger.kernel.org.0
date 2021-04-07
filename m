Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C8C356DAA
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 15:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhDGNpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 09:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233321AbhDGNpH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 09:45:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617803097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+qfQSPZh07voq3kELp2Besk6GzaixAE/JVns2pfUdis=;
        b=jFbtwzOGOH/WfMbv0pgS4lHisMheikRRo9RJSq/ATCNPU+pWV4o1pWaaLuodk+Iq0JqZ+a
        U+eLDd2u99ZsfeonaRAgBuUDDU5htKoje42FOFep/V3D6T9O+Qhf3YtR2FVAl6Hw4Hic0P
        BGi/yLkcslAVW/kHxw9XzJW+uwl2zjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-aPoKjIlxODKAQJre3BW9AA-1; Wed, 07 Apr 2021 09:44:54 -0400
X-MC-Unique: aPoKjIlxODKAQJre3BW9AA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D89D660E;
        Wed,  7 Apr 2021 13:44:52 +0000 (UTC)
Received: from gondolin (ovpn-113-88.ams2.redhat.com [10.36.113.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7570760C04;
        Wed,  7 Apr 2021 13:44:47 +0000 (UTC)
Date:   Wed, 7 Apr 2021 15:44:44 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <oren@nvidia.com>, <nitzanc@nvidia.com>
Subject: Re: [PATCH 1/3] virtio: update reset callback to return status
Message-ID: <20210407154444.04d6304b.cohuck@redhat.com>
In-Reply-To: <20210407120924.133294-1-mgurtovoy@nvidia.com>
References: <20210407120924.133294-1-mgurtovoy@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 12:09:22 +0000
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> The reset device operation, usually is an operation that might fail from
> various reasons. For example, the controller might be in a bad state and
> can't answer to any request. Usually, the paravirt SW based virtio
> devices always succeed in reset operation but this is not the case for
> HW based virtio devices.
> 
> This commit is also a preparation for adding a timeout mechanism for
> resetting virtio devices.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/remoteproc/remoteproc_virtio.c |  3 ++-
>  drivers/virtio/virtio.c                | 22 +++++++++++++++-------
>  drivers/virtio/virtio_mmio.c           |  3 ++-
>  drivers/virtio/virtio_pci_legacy.c     |  3 ++-
>  drivers/virtio/virtio_pci_modern.c     |  3 ++-
>  drivers/virtio/virtio_vdpa.c           |  3 ++-
>  include/linux/virtio_config.h          |  5 +++--
>  7 files changed, 28 insertions(+), 14 deletions(-)

You missed drivers/s390/virtio/virtio_ccw.c.

virtio_ccw_reset() should probably return -ENOMEM on allocation failure
and forward the return code of ccw_io_helper().

