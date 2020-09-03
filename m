Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071CF25C24B
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 16:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgICOOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 10:14:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729210AbgICOOQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 10:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599142430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0HZj8Fjtd+TJ8+nY3F25eaagzLSvWKMqED4dPK0Qo8=;
        b=FaSPhwc44Xe4R9Ub6UCvn4vQySp1/Jl5o3yFU2nTDRSlhHbaG54TN4iX0mV23nuMrKksfD
        5+bkAlGSx/IUlUMQfFqhNRgPZHh13drPfMd+QlQSa6n+iUkhGqycOBYrVsLghFdS702EQY
        GFF94y1y0EegXj9PnOFSWgN+hgU04dY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-0_InniYDM--af73vdO89cw-1; Thu, 03 Sep 2020 10:13:46 -0400
X-MC-Unique: 0_InniYDM--af73vdO89cw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1594C10ABDD9;
        Thu,  3 Sep 2020 14:13:45 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82E1E7E408;
        Thu,  3 Sep 2020 14:13:43 +0000 (UTC)
Subject: Re: [PATCH v4 03/10] vfio/fsl-mc: Implement VFIO_DEVICE_GET_INFO
 ioctl
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-4-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c201d6b8-a824-76ff-124a-177093d7a23f@redhat.com>
Date:   Thu, 3 Sep 2020 16:13:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-4-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 8/26/20 11:33 AM, Diana Craciun wrote:
> Allow userspace to get fsl-mc device info (number of regions
> and irqs).
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 85e007be3a5d..5a5460d01f00 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -33,10 +33,29 @@ static void vfio_fsl_mc_release(void *device_data)
>  static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  			      unsigned long arg)
>  {
> +	unsigned long minsz;
> +	struct vfio_fsl_mc_device *vdev = device_data;
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +
>  	switch (cmd) {
>  	case VFIO_DEVICE_GET_INFO:
>  	{
> -		return -ENOTTY;
> +		struct vfio_device_info info;
> +
> +		minsz = offsetofend(struct vfio_device_info, num_irqs);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		info.flags = VFIO_DEVICE_FLAGS_FSL_MC;
> +		info.num_regions = mc_dev->obj_desc.region_count;
> +		info.num_irqs = mc_dev->obj_desc.irq_count;
> +
> +		return copy_to_user((void __user *)arg, &info, minsz) ?
> +			-EFAULT : 0;
>  	}
>  	case VFIO_DEVICE_GET_REGION_INFO:
>  	{
> 

