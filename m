Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E27391E21
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhEZR3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:29:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232922AbhEZR3g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 13:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622050084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p6XxipKydzrcITdhyVZGRf71Ytpka3MoF9cMJA3KZGw=;
        b=iiucR6NUd5TUs634DJKMV+G8LiLlErAzJXT8jzF38TOWxxYSLip4NwuVC6lJHUhaWsq2r3
        S9/xCNO4rc0oQXKKVWDxxZyOBvan8pthtU17AsCD2yEesHlGCcaucskO6Eg9UJR6fOeVSb
        9maDY883/DlZY2XyLtEM+ciFwuopfAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-0vfgcZ5zMTGHMMyieQGBJA-1; Wed, 26 May 2021 13:28:01 -0400
X-MC-Unique: 0vfgcZ5zMTGHMMyieQGBJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCD64800C60;
        Wed, 26 May 2021 17:27:59 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BABD19D9D;
        Wed, 26 May 2021 17:27:54 +0000 (UTC)
Subject: Re: [PATCH 1/3] vfio/platform: fix module_put call in error flow
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        cohuck@redhat.com, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc:     oren@nvidia.com
References: <20210518192133.59195-1-mgurtovoy@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e37f6e0f-4310-31eb-4da8-0d010a8f7cdb@redhat.com>
Date:   Wed, 26 May 2021 19:27:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210518192133.59195-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Max,

On 5/18/21 9:21 PM, Max Gurtovoy wrote:
> The ->parent_module is the one that use in try_module_get. It should
> also be the one the we use in module_put during vfio_platform_open().
> 
> Fixes: 32a2d71c4e808 ("vfio: platform: introduce vfio-platform-base module")
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks!

Eric

> ---
>  drivers/vfio/platform/vfio_platform_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 361e5b57e369..470fcf7dac56 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -291,7 +291,7 @@ static int vfio_platform_open(struct vfio_device *core_vdev)
>  	vfio_platform_regions_cleanup(vdev);
>  err_reg:
>  	mutex_unlock(&driver_lock);
> -	module_put(THIS_MODULE);
> +	module_put(vdev->parent_module);
>  	return ret;
>  }
>  
> 

