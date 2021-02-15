Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A07A31B858
	for <lists+kvm@lfdr.de>; Mon, 15 Feb 2021 12:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhBOLso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 06:48:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230120AbhBOLsg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Feb 2021 06:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613389629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D22s3OuQqHDBBIq03XJttdJ4KRGjRR6pC+JhDOVlOkU=;
        b=TDGsJ949jBseFKP6fQWYQ4ItTPjlLEjEIGJDLqcu0Cz2Slrwe3v6VgGGLttz1c9tgzXtPd
        z3tvnrSpcne4eKhEVvGOWuNQUz4VZ4/bgzHrbYTQUt0CNgkTXHyYa2I6PLlX8a6fRhUP6n
        NttjlsewznBQrxxnc7C/M8PNlcbpvMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-sJoUwJx-PS2WINi8H1HfSw-1; Mon, 15 Feb 2021 06:47:07 -0500
X-MC-Unique: sJoUwJx-PS2WINi8H1HfSw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44288100CCC1;
        Mon, 15 Feb 2021 11:47:06 +0000 (UTC)
Received: from gondolin (ovpn-113-55.ams2.redhat.com [10.36.113.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDBD75C3F8;
        Mon, 15 Feb 2021 11:47:04 +0000 (UTC)
Date:   Mon, 15 Feb 2021 12:47:02 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio/s390: implement virtio-ccw revision 2 correctly
Message-ID: <20210215124702.23a093b8.cohuck@redhat.com>
In-Reply-To: <20210212170411.992217-1-cohuck@redhat.com>
References: <20210212170411.992217-1-cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Feb 2021 18:04:11 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> CCW_CMD_READ_STATUS was introduced with revision 2 of virtio-ccw,
> and drivers should only rely on it being implemented when they
> negotiated at least that revision with the device.
> 
> However, virtio_ccw_get_status() issued READ_STATUS for any
> device operating at least at revision 1. If the device accepts
> READ_STATUS regardless of the negotiated revision (which it is
> free to do),

So, looking at the standard again, the device is actually required to
reject the READ_STATUS if only rev 1 had been negotiated... regardless
of that, I don't think we should change QEMU's behaviour, as it would
affect existing guests (they would lose access to the status bits as
observed by the device, including DEVICE_NEEDS_RESET.)

> everything works as intended; a device rejecting the
> command should also be handled gracefully. For correctness, we
> should really limit the command to revision 2 or higher, though.
> 
> We also negotiated the revision to at most 1, as we never bumped
> the maximum revision; let's do that now.
> 
> Fixes: 7d3ce5ab9430 ("virtio/s390: support READ_STATUS command for virtio-ccw")
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
> 
> QEMU does not fence off READ_STATUS for revisions < 2, which is probably
> why we never noticed this. I'm not aware of other hypervisors that do
> fence it off, nor any that cannot deal properly with an unknown command.
> 
> Not sure whether this is stable worthy?

Maybe it is, given the MUST reject clause in the standard?

> 
> ---
>  drivers/s390/virtio/virtio_ccw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 5730572b52cd..54e686dca6de 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -117,7 +117,7 @@ struct virtio_rev_info {
>  };
>  
>  /* the highest virtio-ccw revision we support */
> -#define VIRTIO_CCW_REV_MAX 1
> +#define VIRTIO_CCW_REV_MAX 2
>  
>  struct virtio_ccw_vq_info {
>  	struct virtqueue *vq;
> @@ -952,7 +952,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
>  	u8 old_status = vcdev->dma_area->status;
>  	struct ccw1 *ccw;
>  
> -	if (vcdev->revision < 1)
> +	if (vcdev->revision < 2)
>  		return vcdev->dma_area->status;
>  
>  	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));

