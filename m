Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BCA1F6054
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 05:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgFKDKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 23:10:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52678 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726279AbgFKDKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 23:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591845023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j7nAz4g7AJWZ/u0Oz9E2EcJapBTF/UxDuv9a+vP4pMQ=;
        b=NlcYwDO7/Vq8y3X+ljU7HyjuIK11JAWZJkMItPJ8fw6RX9jYrtAMW2Jt4L+vl6uVtiaFUb
        GlvN+8ljYf0/la0knMw1TYZ7t7i+LdPq60R2gvYqquUI+G6u2Vq9F5UGZSUNujEjAdlXWz
        uR0YRFN22NlIOZvcByTNQKtS9as5Ns8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-28PUtISXOqKJhlRrBZDLPw-1; Wed, 10 Jun 2020 23:10:19 -0400
X-MC-Unique: 28PUtISXOqKJhlRrBZDLPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51AE21883600;
        Thu, 11 Jun 2020 03:10:18 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A3EB60BF3;
        Thu, 11 Jun 2020 03:10:09 +0000 (UTC)
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <467d5b58-b70c-1c45-4130-76b6e18c05af@redhat.com>
Date:   Thu, 11 Jun 2020 11:10:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/6/10 下午9:11, Pierre Morel wrote:
> Protected Virtualisation protects the memory of the guest and
> do not allow a the host to access all of its memory.
>
> Let's refuse a VIRTIO device which does not use IOMMU
> protected access.
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   drivers/s390/virtio/virtio_ccw.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 5730572b52cd..06ffbc96587a 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
>   	if (!ccw)
>   		return;
>   
> +	/* Protected Virtualisation guest needs IOMMU */
> +	if (is_prot_virt_guest() &&
> +	    !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
> +			status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
> +
>   	/* Write the status to the host. */
>   	vcdev->dma_area->status = status;
>   	ccw->cmd_code = CCW_CMD_WRITE_STATUS;


I wonder whether we need move it to virtio core instead of ccw.

I think the other memory protection technologies may suffer from this as 
well.

Thanks

