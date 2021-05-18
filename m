Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C163F388260
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 23:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352613AbhERVsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 17:48:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236298AbhERVsR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 17:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621374418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FuWvlQIHVtiLs5PcrSK5tHyRzGUj0cP2/B1i7ADxOx4=;
        b=EKwzM2Vs4eYuoyBLf45tS4ntFeIFU1P/HZYSry+ct8wsgIYG4uT4mWpeUdTCsAvtj4xsiu
        KDCQ4xTjR41WDn5hHthcBTPl7seooodx0+iyR7KubslnVe3v5zsvyYBQ0dlE2dzbav11k5
        ThK3l3ZqBoe/gYHgPZqbxZESLMIw3MQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-7fhLPdPRPAaQAtUZ5nyfNA-1; Tue, 18 May 2021 17:46:55 -0400
X-MC-Unique: 7fhLPdPRPAaQAtUZ5nyfNA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 466A88186E1;
        Tue, 18 May 2021 21:46:54 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FF2960877;
        Tue, 18 May 2021 21:46:47 +0000 (UTC)
Date:   Tue, 18 May 2021 15:46:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <eric.auger@redhat.com>
Subject: Re: [PATCH -next] vfio: platform: reset: add missing iounmap() on
 error in vfio_platform_amdxgbe_reset()
Message-ID: <20210518154647.6541bac2.alex.williamson@redhat.com>
In-Reply-To: <20210513050924.627625-1-yangyingliang@huawei.com>
References: <20210513050924.627625-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 May 2021 13:09:24 +0800
Yang Yingliang <yangyingliang@huawei.com> wrote:

> Add the missing iounmap() before return from vfio_platform_amdxgbe_reset()
> in the error handling case.
> 
> Fixes: 0990822c9866 ("VFIO: platform: reset: AMD xgbe reset module")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/vfio/platform/reset/vfio_platform_amdxgbe.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
> index abdca900802d..c6d823a27bd6 100644
> --- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
> +++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
> @@ -61,8 +61,10 @@ static int vfio_platform_amdxgbe_reset(struct vfio_platform_device *vdev)
>  	if (!xpcs_regs->ioaddr) {
>  		xpcs_regs->ioaddr =
>  			ioremap(xpcs_regs->addr, xpcs_regs->size);
> -		if (!xpcs_regs->ioaddr)
> +		if (!xpcs_regs->ioaddr) {
> +			iounmap(xgmac_regs->ioaddr);
>  			return -ENOMEM;
> +		}
>  	}
>  
>  	/* reset the PHY through MDIO*/

This actually introduces multiple bugs.  vfio-platform has common code
for calling iounmap when the device is released and the struct
vfio_platform_region ioaddr member is re-used throughout the code.
Performing an iounmap() without setting the value to NULL essentially
introduces use-after-free and double free bugs.  There's no bug in the
original afaict, the iounmap occurs lazily on release.  Thanks,

Alex

