Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E875534D951
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 22:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhC2Uut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 16:50:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhC2Uui (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 16:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617051037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qSAQtkgCBkmkQdcFRcOwEbptP3D4iVyPclrZYy2MISY=;
        b=guIbo16bKlYiHdKh8F8RZYfb/OS29f/K9BUXmnNoB0xbJGA26+zDeLlsYIfszC6dyTgpye
        KAonmIPbA9XN50iCrlsOn5/YtlhEeJzHsi7+ll0njlRWQLdac1RB5JH60os5FL+R5NMQr9
        lnwCWEV0zI++wK4HFQ5m8FpSKYUvw8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-MQpgTfnyPDKDEHXuLT9VVQ-1; Mon, 29 Mar 2021 16:50:35 -0400
X-MC-Unique: MQpgTfnyPDKDEHXuLT9VVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB08581746C;
        Mon, 29 Mar 2021 20:50:33 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8488A1B5FF;
        Mon, 29 Mar 2021 20:50:30 +0000 (UTC)
Date:   Mon, 29 Mar 2021 14:50:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH rc vfio] vfio/nvlink: Add missing SPAPR_TCE_IOMMU
 depends
Message-ID: <20210329145030.3ad5c563@omen.home.shazbot.org>
In-Reply-To: <0-v1-83dba9768fc3+419-vfio_nvlink2_kconfig_jgg@nvidia.com>
References: <0-v1-83dba9768fc3+419-vfio_nvlink2_kconfig_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Mar 2021 16:00:16 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Compiling the nvlink stuff relies on the SPAPR_TCE_IOMMU otherwise there
> are compile errors:
> 
>  drivers/vfio/pci/vfio_pci_nvlink2.c:101:10: error: implicit declaration of function 'mm_iommu_put' [-Werror,-Wimplicit-function-declaration]
>                             ret = mm_iommu_put(data->mm, data->mem);
> 
> As PPC only defines these functions when the config is set.
> 
> Previously this wasn't a problem by chance as SPAPR_TCE_IOMMU was the only
> IOMMU that could have satisfied IOMMU_API on POWERNV.
> 
> Fixes: 179209fa1270 ("vfio: IOMMU_API should be selected")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Example .config builds OK after this.
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index ac3c1dd3edeff1..4abddbebd4b236 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -42,6 +42,6 @@ config VFIO_PCI_IGD
>  
>  config VFIO_PCI_NVLINK2
>  	def_bool y
> -	depends on VFIO_PCI && PPC_POWERNV
> +	depends on VFIO_PCI && PPC_POWERNV && SPAPR_TCE_IOMMU
>  	help
>  	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs

Applied to vfio for-linus branch for v5.12.  Thanks,

Alex

