Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6723A357EA1
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 11:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDHJCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 05:02:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhDHJB7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 05:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617872507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bd0XkAkp0u7oQzy6N4znighkJ1TVo4lYhUV0ZZUVvFQ=;
        b=VbYK43mImQgewJCSXKUU+1GOhJzvK4QH2DV9d2dz+tPkSeE3orATc+rOpaAHmux68eu0fC
        bjdVx4KQFk3dHbzgZWGopYaDcrDUElGhcVnqa53lNILiw5TcqaYtoRF4tzCa5S7IAZt6Eq
        xK0ARj65mdXpDNQ78NavvdgeNKc1AL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-h-I7I4jcP2S4GNT2yL1UHg-1; Thu, 08 Apr 2021 05:01:45 -0400
X-MC-Unique: h-I7I4jcP2S4GNT2yL1UHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F14418766D2;
        Thu,  8 Apr 2021 09:01:44 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-53.pek2.redhat.com [10.72.13.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAED65C1C4;
        Thu,  8 Apr 2021 09:01:34 +0000 (UTC)
Subject: Re: [PATCH v2 2/3] virito_pci: add timeout to reset device operation
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     oren@nvidia.com, nitzanc@nvidia.com, cohuck@redhat.com
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <20210408081109.56537-2-mgurtovoy@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2bead2b3-fa23-dc1e-3200-ddfa24944b75@redhat.com>
Date:   Thu, 8 Apr 2021 17:01:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408081109.56537-2-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/4/8 ÏÂÎç4:11, Max Gurtovoy Ð´µÀ:
> According to the spec after writing 0 to device_status, the driver MUST
> wait for a read of device_status to return 0 before reinitializing the
> device. In case we have a device that won't return 0, the reset
> operation will loop forever and cause the host/vm to stuck. Set timeout
> for 3 minutes before giving up on the device.
>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>   drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index cc3412a96a17..dcee616e8d21 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
>   {
>   	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>   	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +	unsigned long timeout = jiffies + msecs_to_jiffies(180000);
>   
>   	/* 0 status means a reset. */
>   	vp_modern_set_status(mdev, 0);
> @@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
>   	 * device_status to return 0 before reinitializing the device.
>   	 * This will flush out the status write, and flush in device writes,
>   	 * including MSI-X interrupts, if any.
> +	 * Set a timeout before giving up on the device.
>   	 */
> -	while (vp_modern_get_status(mdev))
> +	while (vp_modern_get_status(mdev)) {
> +		if (time_after(jiffies, timeout)) {


What happens if the device finish the rest after the timeout?

Thanks


> +			dev_err(&vdev->dev, "virtio: device not ready. "
> +				"Aborting. Try again later\n");
> +			return -EAGAIN;
> +		}
>   		msleep(1);
> +	}
>   	/* Flush pending VQ/configuration callbacks. */
>   	vp_synchronize_vectors(vdev);
>   	return 0;

