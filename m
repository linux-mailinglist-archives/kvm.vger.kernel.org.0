Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1EA25D36A
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIDIVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 04:21:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36946 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726151AbgIDIVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 04:21:39 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-vBvCEjuyPtSr0Qvj5kAg_g-1; Fri, 04 Sep 2020 04:21:36 -0400
X-MC-Unique: vBvCEjuyPtSr0Qvj5kAg_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E19E81F030;
        Fri,  4 Sep 2020 08:21:35 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE8AE811B1;
        Fri,  4 Sep 2020 08:21:30 +0000 (UTC)
Subject: Re: [PATCH v4 10/10] vfio/fsl-mc: Add support for device reset
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-11-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <629498a6-8329-1045-c1a4-ab334f3c8107@redhat.com>
Date:   Fri, 4 Sep 2020 10:21:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-11-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 8/26/20 11:33 AM, Diana Craciun wrote:
> Currently only resetting the DPRC container is supported which
> will reset all the objects inside it. Resetting individual
> objects is possible from the userspace by issueing commands
> towards MC firmware.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 27713aa86878..d17c5b3148ad 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -310,7 +310,20 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  	}
>  	case VFIO_DEVICE_RESET:
>  	{
> -		return -ENOTTY;
> +		int ret = 0;
initialization not needed
> +
spare empty line
> +		struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +
> +		/* reset is supported only for the DPRC */
> +		if (!is_fsl_mc_bus_dprc(mc_dev))
> +			return -ENOTTY;
it is an error case or do we just don't care?
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
Thanks

Eric

