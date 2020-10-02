Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC8D281D1F
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJBUui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgJBUui (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601671836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ppiftakzyBBrl92VlbgA0nk1YkhmL3NI1QLA+tO7wYc=;
        b=Pr3hbwoB5uXxyo2hEfwYvjuEzdeJ/mu7CDGlsTnz9Ge5dRBpaoMT8DupUqUVKfT8i5YWry
        HpcyjCmdPEEvopu1HEnYgKUhhqaPIPaOjC/qMGjqR+E1TDja0h1uMpL4PkXhLfraLAaKnC
        vwsggksnsgfRUxGarJQvDsguzPk73BE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-dYdmsqkhOJav0D66QukkzQ-1; Fri, 02 Oct 2020 16:50:32 -0400
X-MC-Unique: dYdmsqkhOJav0D66QukkzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B1B9802B7F;
        Fri,  2 Oct 2020 20:50:31 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3686E5D9D3;
        Fri,  2 Oct 2020 20:50:28 +0000 (UTC)
Date:   Fri, 2 Oct 2020 14:50:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, bharatb.linux@gmail.com,
        linux-kernel@vger.kernel.org, eric.auger@redhat.com
Subject: Re: [PATCH v5 10/10] vfio/fsl-mc: Add support for device reset
Message-ID: <20201002145027.35519087@x1.home>
In-Reply-To: <20200929090339.17659-11-diana.craciun@oss.nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
        <20200929090339.17659-11-diana.craciun@oss.nxp.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 12:03:39 +0300
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> Currently only resetting the DPRC container is supported which
> will reset all the objects inside it. Resetting individual
> objects is possible from the userspace by issueing commands
> towards MC firmware.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 0aff99cdf722..e1b2dea8a5fe 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -299,7 +299,19 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
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

This should also result in setting the VFIO_DEVICE_FLAGS_RESET bit in
vfio_device_info.flags for the appropriate devices.  Thanks,

Alex

