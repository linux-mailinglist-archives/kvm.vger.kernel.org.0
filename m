Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BB6DC7EE
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 16:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634307AbfJRO5u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 18 Oct 2019 10:57:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56485 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393933AbfJRO5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 10:57:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F039D641C7;
        Fri, 18 Oct 2019 14:57:49 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F93360A35;
        Fri, 18 Oct 2019 14:57:49 +0000 (UTC)
Date:   Fri, 18 Oct 2019 08:57:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] vfio/type1: Initialize resv_msi_base
Message-ID: <20191018085748.2a86f826@x1.home>
In-Reply-To: <20191015151650.30788-1-joro@8bytes.org>
References: <20191015151650.30788-1-joro@8bytes.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 18 Oct 2019 14:57:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Oct 2019 17:16:50 +0200
Joerg Roedel <joro@8bytes.org> wrote:

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

Thanks Joerg!  Added to vfio for-linus branch with Connie and Eric's
reviews for v5.4.  Thanks,

Alex
