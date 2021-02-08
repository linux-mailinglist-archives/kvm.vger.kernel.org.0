Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDBB313360
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 14:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhBHNd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 08:33:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230414AbhBHNdW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 08:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612791116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dahq/nm+R81ocWaGeMo2dHc+enIoZRDUj+J9qHhMRUI=;
        b=WmOZEbGxGzRzzfAu4Hl3HJNyULwtxbVzJoGvdDe/44ZxnC/WZo7pjSphymme76HtF2g1Ah
        u4UdeLGPH1Gm1fR2U6mw1dl5Rd/RMkJEhS01OMzLFxNfWq4jRFPkIWI9iyLJqlIK40ejTW
        oDvh/5r9hqZiOXL3WpKgR/uhb2dT46E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-fg8DxFWQPkuy-15RotwxpA-1; Mon, 08 Feb 2021 08:31:52 -0500
X-MC-Unique: fg8DxFWQPkuy-15RotwxpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2C4251B2;
        Mon,  8 Feb 2021 13:31:50 +0000 (UTC)
Received: from [10.36.112.10] (ovpn-112-10.ams2.redhat.com [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB4D75D743;
        Mon,  8 Feb 2021 13:31:45 +0000 (UTC)
Subject: Re: [RFC v4 2/3] vfio/platform: change cleanup order
To:     Vikas Gupta <vikas.gupta@broadcom.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        ashwin.kamath@broadcom.com, zachary.schroff@broadcom.com,
        manish.kurup@broadcom.com
References: <20201214174514.22006-1-vikas.gupta@broadcom.com>
 <20210129172421.43299-1-vikas.gupta@broadcom.com>
 <20210129172421.43299-3-vikas.gupta@broadcom.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1925f884-770a-9ec4-018f-02f2c2a881cc@redhat.com>
Date:   Mon, 8 Feb 2021 14:31:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210129172421.43299-3-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 1/29/21 6:24 PM, Vikas Gupta wrote:
> In the case of msi, vendor specific msi module may require
> region access to handle msi cleanup so we need to cleanup region
> after irq cleanup only.
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/platform/vfio_platform_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index f2b1f0c3bfcc..1cc040e3ed1f 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -243,8 +243,8 @@ static void vfio_platform_release(void *device_data)
>  			WARN_ON(1);
>  		}
>  		pm_runtime_put(vdev->device);
> -		vfio_platform_regions_cleanup(vdev);
>  		vfio_platform_irq_cleanup(vdev);
> +		vfio_platform_regions_cleanup(vdev);
>  	}
>  
>  	mutex_unlock(&driver_lock);
> 

