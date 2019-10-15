Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D196BD7A66
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 17:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfJOPth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 11:49:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733265AbfJOPtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 11:49:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D81B10CC209;
        Tue, 15 Oct 2019 15:49:36 +0000 (UTC)
Received: from [10.36.116.245] (ovpn-116-245.ams2.redhat.com [10.36.116.245])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3A9B60127;
        Tue, 15 Oct 2019 15:49:31 +0000 (UTC)
Subject: Re: [PATCH] vfio/type1: Initialize resv_msi_base
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20191015151650.30788-1-joro@8bytes.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7d4ae060-a6aa-074f-2184-d220fbbd4014@redhat.com>
Date:   Tue, 15 Oct 2019 17:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191015151650.30788-1-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Tue, 15 Oct 2019 15:49:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joerg,

On 10/15/19 5:16 PM, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> After enabling CONFIG_IOMMU_DMA on X86 a new warning appears when
> compiling vfio:
> 
> drivers/vfio/vfio_iommu_type1.c: In function ‘vfio_iommu_type1_attach_group’:
> drivers/vfio/vfio_iommu_type1.c:1827:7: warning: ‘resv_msi_base’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
>    ~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The warning is a false positive, because the call to iommu_get_msi_cookie()
> only happens when vfio_iommu_has_sw_msi() returned true. And that only
> happens when it also set resv_msi_base.
> 
> But initialize the variable anyway to get rid of the warning.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 96fddc1dafc3..d864277ea16f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1658,7 +1658,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	struct bus_type *bus = NULL;
>  	int ret;
>  	bool resv_msi, msi_remap;
> -	phys_addr_t resv_msi_base;
> +	phys_addr_t resv_msi_base = 0;
>  	struct iommu_domain_geometry geo;
>  	LIST_HEAD(iova_copy);
>  	LIST_HEAD(group_resv_regions);
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
