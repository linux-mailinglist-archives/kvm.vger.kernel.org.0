Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA01F55B6
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 15:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgFJNYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 09:24:44 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24835 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726306AbgFJNYn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 09:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591795482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmumuHmMHhqlAParqxNQ/YNCBmzeBy/qMSsDffXs8Eo=;
        b=F3MhEMEMEwNjAnp+CNNbEkTJqNIxnT4deUFL6c6RGfW2ru4IDllHnvknKnrolDWXeqaRVL
        jRp1d1sRUmXTZJRCrMXPG9Yujf6gSUBtGbJSEwHlryKdB3dGrRz1XBM1rq2Ipti9Hzx4Oi
        tQi4uv87Ag/ocq7qbiG3pP5f3qAEGag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-HMY6qF-2Pqqun-sbMdrMqQ-1; Wed, 10 Jun 2020 09:24:40 -0400
X-MC-Unique: HMY6qF-2Pqqun-sbMdrMqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E45148014D9;
        Wed, 10 Jun 2020 13:24:38 +0000 (UTC)
Received: from gondolin (ovpn-112-196.ams2.redhat.com [10.36.112.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F39CE709D7;
        Wed, 10 Jun 2020 13:24:33 +0000 (UTC)
Date:   Wed, 10 Jun 2020 15:24:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
Message-ID: <20200610152431.358fded7.cohuck@redhat.com>
In-Reply-To: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jun 2020 15:11:51 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Protected Virtualisation protects the memory of the guest and
> do not allow a the host to access all of its memory.
> 
> Let's refuse a VIRTIO device which does not use IOMMU
> protected access.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 5730572b52cd..06ffbc96587a 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
>  	if (!ccw)
>  		return;
>  
> +	/* Protected Virtualisation guest needs IOMMU */
> +	if (is_prot_virt_guest() &&
> +	    !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
> +			status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
> +

set_status seems like an odd place to look at features; shouldn't that
rather be done in finalize_features?

>  	/* Write the status to the host. */
>  	vcdev->dma_area->status = status;
>  	ccw->cmd_code = CCW_CMD_WRITE_STATUS;

