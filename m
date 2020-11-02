Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6612A3622
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 22:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgKBVps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 16:45:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbgKBVpr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 16:45:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604353546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTFZ8lzIl2cNFfLo0OSYv8YB3iqFe9fcgW+Rx9EOOi4=;
        b=EZXJYvqS9u4JsSQYfelCKqJXM3uqmhXUbur8pOAdoKalo+UP/qPIXXqqbl3KWQeAk2Oez+
        7v8YmcDzW6HJnAP0pytaNbFmBsKURwZcFaxAtHJI3Ntmjg+BsvrOwufwtutuEDyoaN/GkP
        Sd3585ZaGErsvVSjarwrINCnWbnVhqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-20h8hIN2MDemDpI5kdMj1Q-1; Mon, 02 Nov 2020 16:45:42 -0500
X-MC-Unique: 20h8hIN2MDemDpI5kdMj1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C123D802B61;
        Mon,  2 Nov 2020 21:45:40 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49A0C68433;
        Mon,  2 Nov 2020 21:45:37 +0000 (UTC)
Date:   Mon, 2 Nov 2020 14:45:36 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/fsl-mc: return -EFAULT if copy_to_user() fails
Message-ID: <20201102144536.42a0e066@w520.home>
In-Reply-To: <20201023113450.GH282278@mwanda>
References: <20201023113450.GH282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thanks, Dan.

Diana, can I get an ack for this?  Thanks,

Alex

On Fri, 23 Oct 2020 14:34:50 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The copy_to_user() function returns the number of bytes remaining to be
> copied, but this code should return -EFAULT.
> 
> Fixes: df747bcd5b21 ("vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 0113a980f974..21f22e3da11f 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -248,7 +248,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  		info.size = vdev->regions[info.index].size;
>  		info.flags = vdev->regions[info.index].flags;
>  
> -		return copy_to_user((void __user *)arg, &info, minsz);
> +		if (copy_to_user((void __user *)arg, &info, minsz))
> +			return -EFAULT;
> +		return 0;
>  	}
>  	case VFIO_DEVICE_GET_IRQ_INFO:
>  	{
> @@ -267,7 +269,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  		info.flags = VFIO_IRQ_INFO_EVENTFD;
>  		info.count = 1;
>  
> -		return copy_to_user((void __user *)arg, &info, minsz);
> +		if (copy_to_user((void __user *)arg, &info, minsz))
> +			return -EFAULT;
> +		return 0;
>  	}
>  	case VFIO_DEVICE_SET_IRQS:
>  	{

