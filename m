Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744B01997F7
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 15:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgCaN4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 09:56:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33728 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730216AbgCaN4y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 09:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585663013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OUBFwMaCdyw1jFUI5caI8I7JvXKZGkBxj0a10nSzzRk=;
        b=Xx0NsN32JpezzdSaL+HUH4PWW6uEmh92rHHGDbypcNFjyv8ge4CFNxtjJTrRR04LaScQtD
        MPkxkTQTDmfZkqsQMzL7dsHqYOs6qABnXr8qsK8IhvOA8CXVCsVkZ+s3pNdwyiOIRqkuwI
        OGf1ftQBV8OwuPyTathR6CpFhWeYmQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-B7sSyFA1Ogi6Y2t9tub8HQ-1; Tue, 31 Mar 2020 09:56:51 -0400
X-MC-Unique: B7sSyFA1Ogi6Y2t9tub8HQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33B061005509;
        Tue, 31 Mar 2020 13:56:50 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEA4F1036D00;
        Tue, 31 Mar 2020 13:56:44 +0000 (UTC)
Subject: Re: [RFC PATCH] vfio: Ignore -ENODEV when getting MSI cookie
To:     Andre Przywara <andre.przywara@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
References: <20200312181950.60664-1-andre.przywara@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <629dd065-4fc0-eed4-975a-db05dda8504d@redhat.com>
Date:   Tue, 31 Mar 2020 15:56:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200312181950.60664-1-andre.przywara@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 3/12/20 7:19 PM, Andre Przywara wrote:
> When we try to get an MSI cookie for a VFIO device, that can fail if
> CONFIG_IOMMU_DMA is not set. In this case iommu_get_msi_cookie() returns
> -ENODEV, and that should not be fatal.
> 
> Ignore that case and proceed with the initialisation.
> 
> This fixes VFIO with a platform device on the Calxeda Midway (no MSIs).
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Would you mind resending this as non RFC (+ R-b tags) so that it gets a
chance to be taken by Alex for 5.7

Thanks

Eric
> ---
> Hi,
> 
> not sure this is the right fix, or we should rather check if the
> platform doesn't support MSIs at all (which doesn't seem to be easy
> to do).
> Or is this because arm-smmu.c always reserves an IOMMU_RESV_SW_MSI
> region?
> 
> Also this seems to be long broken, actually since Eric introduced MSI
> support in 4.10-rc3, but at least since the initialisation order was
> fixed with f6810c15cf9.
> 
> Grateful for any insight.
> 
> Cheers,
> Andre
> 
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a177bf2c6683..467e217ef09a 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1786,7 +1786,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  	if (resv_msi) {
>  		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
> -		if (ret)
> +		if (ret && ret != -ENODEV)
>  			goto out_detach;
>  	}
>  
> 

