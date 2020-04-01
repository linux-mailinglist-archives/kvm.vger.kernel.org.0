Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8A519B88F
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 00:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbgDAWj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 18:39:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34695 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387801AbgDAWj7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 18:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585780799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k+QivSXL5xhLG7M9lhqztlvCh/YTXTzVLqfa0HHMNH8=;
        b=ids4QEDaAGpfUaMUzyz0WUmWZiPbIb3JzMxH/JRsCO9OAb3KyPGjRlMvX1wELi8mG6dlIS
        AKImGokl0hHmtx+EOf1vjU1VZJAgeT276WsQfaKade2XzrFZeeGE7TiPVEPdtXY0SZnKaE
        xIY2c2S4zQUfqoCTH2NgMG91b3CBqKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-qsuGeAdaM0m_TotbpNGXTg-1; Wed, 01 Apr 2020 18:39:56 -0400
X-MC-Unique: qsuGeAdaM0m_TotbpNGXTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0915A800D4E;
        Wed,  1 Apr 2020 22:39:55 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 749B389F0A;
        Wed,  1 Apr 2020 22:39:51 +0000 (UTC)
Date:   Wed, 1 Apr 2020 16:39:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] vfio: Ignore -ENODEV when getting MSI cookie
Message-ID: <20200401163950.61741738@w520.home>
In-Reply-To: <20200401102724.161712-1-andre.przywara@arm.com>
References: <20200401102724.161712-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Apr 2020 11:27:24 +0100
Andre Przywara <andre.przywara@arm.com> wrote:

> When we try to get an MSI cookie for a VFIO device, that can fail if
> CONFIG_IOMMU_DMA is not set. In this case iommu_get_msi_cookie() returns
> -ENODEV, and that should not be fatal.
> 
> Ignore that case and proceed with the initialisation.
> 
> This fixes VFIO with a platform device on the Calxeda Midway (no MSIs).
> 
> Fixes: f6810c15cf973f ("iommu/arm-smmu: Clean up early-probing workarounds")
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Acked-by: Robin Murphy <robin.murphy@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 9fdfae1cb17a..85b32c325282 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1787,7 +1787,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  	if (resv_msi) {
>  		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
> -		if (ret)
> +		if (ret && ret != -ENODEV)
>  			goto out_detach;
>  	}
>  

Applied to vfio next branch for v5.7.  Thanks,

Alex

