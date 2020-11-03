Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840812A4E3A
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgKCSTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:19:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729075AbgKCSTN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 13:19:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604427552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/hWu+N+wOTe562y79WDJHfHrZYi3ZnAqNsDEEWdHNM=;
        b=ijWnBu820WSzt/327gvE1FiZssZ8/BjoJvpqW9BxGPzA7jNGMYJnM5UqpbSiRkHdDcdwrv
        bJ+ulpTuyMn3C08VdgFlzvx0EQySIa34nOmFv6ZmArj1UbFQkMF8zQqOWJR+JLR7i+msh+
        lbgcfjmkjYKP+kqvyveOGC9AMnED148=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-VCYS1BjpMkqsO61RFv8BAQ-1; Tue, 03 Nov 2020 13:19:08 -0500
X-MC-Unique: VCYS1BjpMkqsO61RFv8BAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D7751009E23;
        Tue,  3 Nov 2020 18:19:07 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4843A2C31E;
        Tue,  3 Nov 2020 18:19:03 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:19:02 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/fsl-mc: return -EFAULT if copy_to_user() fails
Message-ID: <20201103111902.1ac78ae3@w520.home>
In-Reply-To: <20201023113450.GH282278@mwanda>
References: <20201023113450.GH282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Applied this and the following patch to vfio for-linus branch with
Diana's acks for v5.10.  Thanks,

Alex


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

