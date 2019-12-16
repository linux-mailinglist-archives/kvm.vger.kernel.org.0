Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060F7121ED4
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 00:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLPXRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 18:17:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43230 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726705AbfLPXRC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 18:17:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576538221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3tAtNALxr1oOpTMQ1PlOaAzpjjcezAUmdZUsGLw1ANI=;
        b=fGKEIYEdSl30RcfJMqSHdLhk3kEsEOv9A+vPHzFEBnt7ehLJw0sFf1kqOqeIdNcDqJ8bxn
        hXwrG15UxKy4dxkCHY4dWMcLQUft4aGElI+2Acfr9faWJWDCxf1g0oHpDLY4c+Dkytw1T6
        xb/W+PvuHvSbu5trBYqRLTfb+ood/uk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-w-xh_1QINty9oy20tRskiA-1; Mon, 16 Dec 2019 18:16:57 -0500
X-MC-Unique: w-xh_1QINty9oy20tRskiA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F33A1801E77;
        Mon, 16 Dec 2019 23:16:54 +0000 (UTC)
Received: from x1.home (ovpn-116-53.phx2.redhat.com [10.3.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59CD768863;
        Mon, 16 Dec 2019 23:16:53 +0000 (UTC)
Date:   Mon, 16 Dec 2019 16:16:52 -0700
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
Subject: Re: [PATCH v10 Kernel 2/5] vfio iommu: Adds flag to indicate dirty
 pages tracking capability support
Message-ID: <20191216161652.30681b05@x1.home>
In-Reply-To: <1576527700-21805-3-git-send-email-kwankhede@nvidia.com>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
        <1576527700-21805-3-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Dec 2019 01:51:37 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Flag VFIO_IOMMU_INFO_DIRTY_PGS in VFIO_IOMMU_GET_INFO indicates that driver
> support dirty pages tracking.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 3 ++-
>  include/uapi/linux/vfio.h       | 5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 2ada8e6cdb88..3f6b04f2334f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2234,7 +2234,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  			info.cap_offset = 0; /* output, no-recopy necessary */
>  		}
>  
> -		info.flags = VFIO_IOMMU_INFO_PGSIZES;
> +		info.flags = VFIO_IOMMU_INFO_PGSIZES |
> +			     VFIO_IOMMU_INFO_DIRTY_PGS;

Type1 shouldn't advertise it until it's supported though, right?
Thanks,

Alex

>  
>  		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index a0817ba267c1..81847ed54eb7 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -900,8 +900,9 @@ struct vfio_device_ioeventfd {
>  struct vfio_iommu_type1_info {
>  	__u32	argsz;
>  	__u32	flags;
> -#define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
> -#define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
> +#define VFIO_IOMMU_INFO_PGSIZES   (1 << 0) /* supported page sizes info */
> +#define VFIO_IOMMU_INFO_CAPS      (1 << 1) /* Info supports caps */
> +#define VFIO_IOMMU_INFO_DIRTY_PGS (1 << 2) /* supports dirty page tracking */
>  	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
>  };

