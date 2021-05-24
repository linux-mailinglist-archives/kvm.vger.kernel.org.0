Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A0938F3C3
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhEXTgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232911AbhEXTgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 15:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621884890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CB4tuVxYidgwWnrOV1JzZiFyrKPFsHJNssi+kbM4WkE=;
        b=R3i3Fff0ngXe7Cc5kRnzrkHbs+n4wPWhONMzBH+m18p7y9rsrv15Byx/mScD66WoUuIHVv
        akg2bl6mB7g5T+Tl74XiKhGHcVVydqDmyx4+xWR4IwZkZ23VXh4Y7qUW+bXrKc7KgnKMGx
        qru5BZ06ONU1YJkLO68vDMKK1qDytsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-8FnvB1YMNbK51YWHXALhpw-1; Mon, 24 May 2021 15:34:48 -0400
X-MC-Unique: 8FnvB1YMNbK51YWHXALhpw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBF001883522;
        Mon, 24 May 2021 19:34:46 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02AFB5D9F0;
        Mon, 24 May 2021 19:34:42 +0000 (UTC)
Date:   Mon, 24 May 2021 13:34:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <oren@nvidia.com>, <eric.auger@redhat.com>
Subject: Re: [PATCH 1/3] vfio/platform: fix module_put call in error flow
Message-ID: <20210524133442.42dd2c46@x1.home.shazbot.org>
In-Reply-To: <20210518192133.59195-1-mgurtovoy@nvidia.com>
References: <20210518192133.59195-1-mgurtovoy@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 22:21:31 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> The ->parent_module is the one that use in try_module_get. It should
> also be the one the we use in module_put during vfio_platform_open().
> 
> Fixes: 32a2d71c4e808 ("vfio: platform: introduce vfio-platform-base module")
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
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

The series looks good to me.  This one is an obvious fix, so I'll queue
that for v5.13 and save the latter two for the v5.14 merge window.
Please do make use of cover letters in the future.  Thanks,

Alex

