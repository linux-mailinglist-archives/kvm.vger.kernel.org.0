Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028A21DAFB7
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 12:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgETKIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 06:08:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58186 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726224AbgETKIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 06:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589969320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UcWON8E7vVA9RaONAcWnZZZmaga+7CkifeGerQ7VIUg=;
        b=gBuavHpcr8jPu41MKP+Si673j0aAg8cOwedOX8abR/oCg1tlC7/+vYkHlBy6qtfhbbPwzm
        Lfa418f5yfygiybP6uCRbNt+XjaFP9qaxC5AJ6aiQmZy3DOlQk2z6iSJ3vkuCCTVyb5jqf
        Ro5aqYBED5+jx2dS9eXgyrrgc9lEO3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-CQeOVtbiMc2dbdFNIFsnPQ-1; Wed, 20 May 2020 06:08:39 -0400
X-MC-Unique: CQeOVtbiMc2dbdFNIFsnPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C41A6800688;
        Wed, 20 May 2020 10:08:35 +0000 (UTC)
Received: from gondolin (ovpn-113-5.ams2.redhat.com [10.36.113.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D6091943D;
        Wed, 20 May 2020 10:08:28 +0000 (UTC)
Date:   Wed, 20 May 2020 12:08:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v22 3/8] vfio iommu: Cache pgsize_bitmap in
 struct vfio_iommu
Message-ID: <20200520120825.7d8144ba.cohuck@redhat.com>
In-Reply-To: <1589781397-28368-4-git-send-email-kwankhede@nvidia.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
        <1589781397-28368-4-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 11:26:32 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Calculate and cache pgsize_bitmap when iommu->domain_list is updated
> and iommu->external_domain is set for mdev device.
> Add iommu->lock protection when cached pgsize_bitmap is accessed.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 88 +++++++++++++++++++++++------------------
>  1 file changed, 49 insertions(+), 39 deletions(-)
> 

(...)

> @@ -805,15 +806,14 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	iommu->dma_avail++;
>  }
>  
> -static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> +static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)

Minor nit: I'd have renamed this function to
vfio_update_pgsize_bitmap().

>  {
>  	struct vfio_domain *domain;
> -	unsigned long bitmap = ULONG_MAX;
>  
> -	mutex_lock(&iommu->lock);
> +	iommu->pgsize_bitmap = ULONG_MAX;
> +
>  	list_for_each_entry(domain, &iommu->domain_list, next)
> -		bitmap &= domain->domain->pgsize_bitmap;
> -	mutex_unlock(&iommu->lock);
> +		iommu->pgsize_bitmap &= domain->domain->pgsize_bitmap;
>  
>  	/*
>  	 * In case the IOMMU supports page sizes smaller than PAGE_SIZE

(...)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

