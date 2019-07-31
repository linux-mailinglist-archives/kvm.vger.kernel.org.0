Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D77CC46
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 20:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfGaSrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 14:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfGaSrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 14:47:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B10288311;
        Wed, 31 Jul 2019 18:47:14 +0000 (UTC)
Received: from [10.36.116.49] (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1628B6012E;
        Wed, 31 Jul 2019 18:47:08 +0000 (UTC)
Subject: Re: [PATCH] vfio: re-arrange vfio region definitions
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190717114956.16263-1-cohuck@redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <05e97697-70a3-51dd-dd2a-4a8bf6c380bb@redhat.com>
Date:   Wed, 31 Jul 2019 20:47:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190717114956.16263-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 31 Jul 2019 18:47:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Connie,

On 7/17/19 1:49 PM, Cornelia Huck wrote:
> It is easy to miss already defined region types. Let's re-arrange
> the definitions a bit and add more comments to make it hopefully
> a bit clearer.
> 
> No functional change.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  include/uapi/linux/vfio.h | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 8f10748dac79..d9bcf40240be 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -295,15 +295,23 @@ struct vfio_region_info_cap_type {
>  	__u32 subtype;	/* type specific */
>  };
>  
> +/*
> + * List of region types, global per bus driver.
> + * If you introduce a new type, please add it here.
> + */
> +
> +/* PCI region type containing a PCI vendor part */
>  #define VFIO_REGION_TYPE_PCI_VENDOR_TYPE	(1 << 31)
>  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
> +#define VFIO_REGION_TYPE_GFX                    (1)
> +#define VFIO_REGION_TYPE_CCW			(2)
>  
> -/* 8086 Vendor sub-types */
> +/* 8086 vendor PCI sub-types */
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION	(1)
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG	(2)
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG	(3)
>  
> -#define VFIO_REGION_TYPE_GFX                    (1)
> +/* GFX sub-types */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>  
>  /**
> @@ -353,20 +361,17 @@ struct vfio_region_gfx_edid {
>  #define VFIO_DEVICE_GFX_LINK_STATE_DOWN  2
>  };
>  
> -#define VFIO_REGION_TYPE_CCW			(2)
>  /* ccw sub-types */
>  #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
>  
> +/* 10de vendor PCI sub-types */
>  /*
> - * 10de vendor sub-type
> - *
>   * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
>   */
>  #define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
>  
> +/* 1014 vendor PCI sub-types*/
>  /*
> - * 1014 vendor sub-type
Maybe the 10de vendor sub-type and 1014 vendor sub-type could be put
just after /* 8086 vendor PCI sub-types */

More generally if it were possible to leave the subtypes close to their
parent type too, this would be beneficial I think.

Besides that becomes sensible to put all those definitions together.

Thanks

Eric
> - *
>   * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
>   * to do TLB invalidation on a GPU.
>   */
> 
