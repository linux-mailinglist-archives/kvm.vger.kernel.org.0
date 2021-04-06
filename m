Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1B3355C44
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbhDFTiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:38:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242679AbhDFTiM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 15:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617737884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CdLng19W5LYZEztCULVl6EDAF0QSKZ/kbT35H54v7uo=;
        b=Ll+kriKbNF95UlvKFlz1tJ6sP1vwkbDCLvKeB0WwIcv1GTkCYb0wb5lS9fOIwaqXPysOby
        zBNL1QHKnmEelfNGQBZcFKKG/58mBD309N1tm0fviIw/oZ4Rd6UNwsA4CVCaUEJTOTKylL
        54fcXh1bTzfkMt3DhCydvXZwkiCsbWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-HLhu_tLKPZSyNpGWcDPLUA-1; Tue, 06 Apr 2021 15:38:01 -0400
X-MC-Unique: HLhu_tLKPZSyNpGWcDPLUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B2895B371;
        Tue,  6 Apr 2021 19:37:57 +0000 (UTC)
Received: from omen (ovpn-112-85.phx2.redhat.com [10.3.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D562119D61;
        Tue,  6 Apr 2021 19:37:56 +0000 (UTC)
Date:   Tue, 6 Apr 2021 13:37:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>
Subject: Re: [PATCH v1] vfio/type1: Remove the almost unused check in
 vfio_iommu_type1_unpin_pages
Message-ID: <20210406133756.4520772c@omen>
In-Reply-To: <20210406135009.1707-1-lushenming@huawei.com>
References: <20210406135009.1707-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Apr 2021 21:50:09 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> The check i > npage at the end of vfio_iommu_type1_unpin_pages is unused
> unless npage < 0, but if npage < 0, this function will return npage, which
> should return -EINVAL instead. So let's just check the parameter npage at
> the start of the function. By the way, replace unpin_exit with break.
> 
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 45cbfd4879a5..fd4213c41743 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -960,7 +960,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
>  	bool do_accounting;
>  	int i;
>  
> -	if (!iommu || !user_pfn)
> +	if (!iommu || !user_pfn || npage <= 0)
>  		return -EINVAL;
>  
>  	/* Supported for v2 version only */
> @@ -977,13 +977,13 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
>  		iova = user_pfn[i] << PAGE_SHIFT;
>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>  		if (!dma)
> -			goto unpin_exit;
> +			break;
> +
>  		vfio_unpin_page_external(dma, iova, do_accounting);
>  	}
>  
> -unpin_exit:
>  	mutex_unlock(&iommu->lock);
> -	return i > npage ? npage : (i > 0 ? i : -EINVAL);
> +	return i > 0 ? i : -EINVAL;
>  }
>  
>  static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,

Very odd behavior previously.  Applied to vfio next branch for v5.13.
Thanks,

Alex

