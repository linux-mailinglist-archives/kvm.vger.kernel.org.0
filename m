Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C19D443D7D
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhKCHDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:03:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhKCHDI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:03:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635922831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+gmChij/P9Gb2Yhlimu7btFzjYfRIbTFZmHgIkhtKtE=;
        b=Zg9UrHdACEEslkaacrtDJllsEze4BtH2JQ7Fo2pmWBEig+gUAG6jkBXkj3pqjz1N+abUb+
        fVec93SdI1nMO5tAB8yhn1mmmMFrXx7kwmV1kXP5PpzwE/ZyT5FuwqMuCmHUsk4lXln6TM
        f1aEqeVhbdUbRty9lpX8hig9UsgFsCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-59_okpkSM0G-Gykf2SdoAA-1; Wed, 03 Nov 2021 03:00:30 -0400
X-MC-Unique: 59_okpkSM0G-Gykf2SdoAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7595806689;
        Wed,  3 Nov 2021 07:00:29 +0000 (UTC)
Received: from [10.39.192.84] (unknown [10.39.192.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B12157CB9;
        Wed,  3 Nov 2021 07:00:10 +0000 (UTC)
Message-ID: <43587c22-e9c9-545d-1dad-5877b683a75c@redhat.com>
Date:   Wed, 3 Nov 2021 08:00:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-2-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/7] arm: virtio: move VIRTIO transport
 initialization inside virtio-mmio
In-Reply-To: <1630059440-15586-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the late reply - still trying to get my Inbox under control again ...

On 27/08/2021 12.17, Pierre Morel wrote:
> To be able to use different VIRTIO transport in the future we need
> the initialisation entry call of the transport to be inside the
> transport file and keep the VIRTIO level transport agnostic.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/virtio-mmio.c | 2 +-
>   lib/virtio-mmio.h | 2 --
>   lib/virtio.c      | 5 -----
>   3 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
> index e5e8f660..fb8a86a3 100644
> --- a/lib/virtio-mmio.c
> +++ b/lib/virtio-mmio.c
> @@ -173,7 +173,7 @@ static struct virtio_device *virtio_mmio_dt_bind(u32 devid)
>   	return &vm_dev->vdev;
>   }
>   
> -struct virtio_device *virtio_mmio_bind(u32 devid)
> +struct virtio_device *virtio_bind(u32 devid)
>   {
>   	return virtio_mmio_dt_bind(devid);
>   }
> diff --git a/lib/virtio-mmio.h b/lib/virtio-mmio.h
> index 250f28a0..73ddbd23 100644
> --- a/lib/virtio-mmio.h
> +++ b/lib/virtio-mmio.h
> @@ -60,6 +60,4 @@ struct virtio_mmio_device {
>   	void *base;
>   };
>   
> -extern struct virtio_device *virtio_mmio_bind(u32 devid);
> -
>   #endif /* _VIRTIO_MMIO_H_ */
> diff --git a/lib/virtio.c b/lib/virtio.c
> index 69054757..e10153b9 100644
> --- a/lib/virtio.c
> +++ b/lib/virtio.c
> @@ -123,8 +123,3 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
>   
>   	return ret;
>   }
> -
> -struct virtio_device *virtio_bind(u32 devid)
> -{
> -	return virtio_mmio_bind(devid);
> -}
> 

I agree that this needs to be improved somehow, but I'm not sure whether 
moving the function to virtio-mmio.c is the right solution. I guess the 
original idea was that virtio_bind() could cope with multiple transports, 
i.e. when there is support for virtio-pci, it could choose between mmio and 
pci on ARM, or between CCW and PCI on s390x.

So maybe this should rather get an "#if defined(__arm__) || 
defined(__aarch64__)" instead? Drew, what's your opinion here?

  Thomas

