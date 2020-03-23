Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F75218F3F9
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 12:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgCWL71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 07:59:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39212 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728174AbgCWL71 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 07:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584964766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VyjvP9l3FJXSBKAiaO4Zbc3n56DNlUk6OaDVmr68ffo=;
        b=c/9Y/kbqUhj4KCg5QzUEMzZ94aWfvWQfzxdghGzvDAlN7WmGzT+Mcr3AloqlpBPewcGZg0
        WhnNJBHg/ubGN5NYiEOP+BiUjNZH0mB5GYCbzf4t2XTIrVrGisx9q63RU+eawXnAqmI0Ju
        WuCpCVlHJqTH13LGIMMrlrvq+McRYjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-2Q_PMBJYOjCF6fwLcNmUBA-1; Mon, 23 Mar 2020 07:59:21 -0400
X-MC-Unique: 2Q_PMBJYOjCF6fwLcNmUBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67C9B477;
        Mon, 23 Mar 2020 11:59:19 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AACE7E31F;
        Mon, 23 Mar 2020 11:59:10 +0000 (UTC)
Subject: Re: [PATCH v14 Kernel 2/7] vfio iommu: Remove atomicity of ref_count
 of pinned pages
To:     Kirti Wankhede <kwankhede@nvidia.com>, alex.williamson@redhat.com,
        cjia@nvidia.com
Cc:     kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dgilbert@redhat.com,
        jonathan.davies@nutanix.com, eauger@redhat.com, aik@ozlabs.ru,
        pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@Alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, yan.y.zhao@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-3-git-send-email-kwankhede@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e81dda25-33af-9a6b-454c-fe3349142e9b@redhat.com>
Date:   Mon, 23 Mar 2020 12:59:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1584560474-19946-3-git-send-email-kwankhede@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kirti,

On 3/18/20 8:41 PM, Kirti Wankhede wrote:
> vfio_pfn.ref_count is always updated by holding iommu->lock, using atomic
> variable is overkill.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 9fdfae1cb17a..70aeab921d0f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -112,7 +112,7 @@ struct vfio_pfn {
>  	struct rb_node		node;
>  	dma_addr_t		iova;		/* Device address */
>  	unsigned long		pfn;		/* Host pfn */
> -	atomic_t		ref_count;
> +	unsigned int		ref_count;
>  };
>  
>  struct vfio_regions {

> @@ -233,7 +233,7 @@ static int vfio_add_to_pfn_list(struct vfio_dma *dma, dma_addr_t iova,
>  
>  	vpfn->iova = iova;
>  	vpfn->pfn = pfn;
> -	atomic_set(&vpfn->ref_count, 1);
> +	vpfn->ref_count = 1;
>  	vfio_link_pfn(dma, vpfn);
>  	return 0;
>  }
> @@ -251,7 +251,7 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
>  	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
>  
>  	if (vpfn)
> -		atomic_inc(&vpfn->ref_count);
> +		vpfn->ref_count++;
>  	return vpfn;
>  }
>  
> @@ -259,7 +259,8 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>  {
>  	int ret = 0;
>  
> -	if (atomic_dec_and_test(&vpfn->ref_count)) {
> +	vpfn->ref_count--;
> +	if (!vpfn->ref_count) {
>  		ret = put_pfn(vpfn->pfn, dma->prot);
>  		vfio_remove_from_pfn_list(dma, vpfn);
>  	}
> 

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

