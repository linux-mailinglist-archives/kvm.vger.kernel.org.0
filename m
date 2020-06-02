Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13041EC340
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 21:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgFBTy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 15:54:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39090 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726589AbgFBTy7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 15:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591127697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VCnU65iJzriTQ16ffNx4Cnz5ZN96Q2FzmUgCNdS3hKU=;
        b=PC5DA0FCq6jsBFdOuiBdyxZx7By0dOpNY0qY3J8+EAaSMeQV1yyJ44FjJgHCjsPKibEBcY
        PbtjC7F5V3ViSKFBZCh1Jaf8Oa7JlSu+VEGKoEjS4Jkz6LeAM4FNzX6rAWO0PKTSFNAYM1
        7LaProNCJsB1R2DsAK88tE9mg2QKQyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-JSv_jKh9NHuigJEcvSCsrQ-1; Tue, 02 Jun 2020 15:54:54 -0400
X-MC-Unique: JSv_jKh9NHuigJEcvSCsrQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD10C80058E;
        Tue,  2 Jun 2020 19:54:51 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1832110013C3;
        Tue,  2 Jun 2020 19:54:50 +0000 (UTC)
Date:   Tue, 2 Jun 2020 13:54:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] vfio iommu: Use shift operation for 64-bit integer
 division
Message-ID: <20200602135448.56707f25@x1.home>
In-Reply-To: <1591123357-18297-1-git-send-email-kwankhede@nvidia.com>
References: <1591123357-18297-1-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Jun 2020 00:12:36 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Fixes compilation error with ARCH=i386.
> 
> Error fixed by this commit:
> ld: drivers/vfio/vfio_iommu_type1.o: in function `vfio_dma_populate_bitmap':
> >> vfio_iommu_type1.c:(.text+0x666): undefined reference to `__udivdi3'  
> 
> Fixes: d6a4c185660c (vfio iommu: Implementation of ioctl for dirty pages tracking)
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 97a29bc04d5d..9d9c8709a24c 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -227,11 +227,12 @@ static void vfio_dma_bitmap_free(struct vfio_dma *dma)
>  static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>  {
>  	struct rb_node *p;
> +	unsigned long pgshift = __ffs(pgsize);
>  
>  	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
>  		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
>  
> -		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
> +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) >> pgshift, 1);
>  	}
>  }
>  

Applied and pushed both to the vfio next branch.  Thanks!

Alex

