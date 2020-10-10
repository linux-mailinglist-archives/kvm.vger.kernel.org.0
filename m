Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E995128A1AB
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgJJVp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731110AbgJJTCT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Oct 2020 15:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602356536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpTY/19B0CDH9zVrgG82JXhZ+L19dEoW0NN8qYH+ph0=;
        b=EigVXi/agTbVqp+9DMhjOgYK3zAy8E/ReqScMN0ZXMmCqOARlzViBC5Ap/txAx7GkE5tGK
        wNRu3bhiu3zMWlxHegc907jCtP/oiSz8u6Bj1TFyG0LpgpavEmFFhFymBDo3lZvhkThwNM
        YYDSyVNa2ZaA6UQiPU+7+S0Hsv/HApo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-Uu6AbL9YPpihCWJcaW9g0A-1; Sat, 10 Oct 2020 13:50:44 -0400
X-MC-Unique: Uu6AbL9YPpihCWJcaW9g0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 624FC107ACF6;
        Sat, 10 Oct 2020 17:50:43 +0000 (UTC)
Received: from [10.36.113.210] (ovpn-113-210.ams2.redhat.com [10.36.113.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E82BF5C1D0;
        Sat, 10 Oct 2020 17:50:38 +0000 (UTC)
Subject: Re: [PATCH v6 10/10] vfio/fsl-mc: Add support for device reset
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
 <20201005173654.31773-11-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <829321cf-0d95-c72a-dbd6-8fc034d8bba8@redhat.com>
Date:   Sat, 10 Oct 2020 19:50:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201005173654.31773-11-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 10/5/20 7:36 PM, Diana Craciun wrote:
> Currently only resetting the DPRC container is supported which
> will reset all the objects inside it. Resetting individual
> objects is possible from the userspace by issueing commands
> towards MC firmware.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index d95568cd8021..d009f873578c 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -217,6 +217,10 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  			return -EINVAL;
>  
>  		info.flags = VFIO_DEVICE_FLAGS_FSL_MC;
> +
> +		if (is_fsl_mc_bus_dprc(mc_dev))
> +			info.flags |= VFIO_DEVICE_FLAGS_RESET;
> +
>  		info.num_regions = mc_dev->obj_desc.region_count;
>  		info.num_irqs = mc_dev->obj_desc.irq_count;
>  
> @@ -299,7 +303,19 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  	}
>  	case VFIO_DEVICE_RESET:
>  	{
> -		return -ENOTTY;
> +		int ret;
> +		struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +
> +		/* reset is supported only for the DPRC */
> +		if (!is_fsl_mc_bus_dprc(mc_dev))
> +			return -ENOTTY;
> +
> +		ret = dprc_reset_container(mc_dev->mc_io, 0,
> +					   mc_dev->mc_handle,
> +					   mc_dev->obj_desc.id,
> +					   DPRC_RESET_OPTION_NON_RECURSIVE);
> +		return ret;
> +
>  	}
>  	default:
>  		return -ENOTTY;
> 

