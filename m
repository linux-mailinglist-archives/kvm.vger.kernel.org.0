Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02411DB070
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 12:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETKma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 06:42:30 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgETKm3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 06:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589971348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nWScQxGnuCxPTRKRuxipi99sMG+Yz5m1VAv7OprXKT0=;
        b=P7hUF+ZZdeqdNFvWuKVlhBe4ri5U34zUY8nC2NIo5CvkHAYk7FPZ4UsKVccYXRCNKOeBHt
        LMYbtPS+naUDO7J7beDo9iTMUuzYv+Ti0g8mW8bn6p3HEd/GVE372lJDnIiU2yJDLsazHI
        m4qvMc9zge/Ihejg89Gb4MVmwlLukY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-3mnn2BlhP42Db2pWcYmIUQ-1; Wed, 20 May 2020 06:42:23 -0400
X-MC-Unique: 3mnn2BlhP42Db2pWcYmIUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D583F18FE861;
        Wed, 20 May 2020 10:42:20 +0000 (UTC)
Received: from gondolin (ovpn-113-5.ams2.redhat.com [10.36.113.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F8532E05D;
        Wed, 20 May 2020 10:42:03 +0000 (UTC)
Date:   Wed, 20 May 2020 12:42:00 +0200
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
Subject: Re: [PATCH Kernel v22 7/8] vfio iommu: Add migration capability to
 report supported features
Message-ID: <20200520124200.0b4f3562.cohuck@redhat.com>
In-Reply-To: <1589781397-28368-8-git-send-email-kwankhede@nvidia.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
        <1589781397-28368-8-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 11:26:36 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Added migration capability in IOMMU info chain.
> User application should check IOMMU info chain for migration capability
> to use dirty page tracking feature provided by kernel module.
> User application must check page sizes supported and maximum dirty
> bitmap size returned by this capability structure for ioctls used to get
> dirty bitmap.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++++++++-
>  include/uapi/linux/vfio.h       | 22 ++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 1 deletion(-)

(...)

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index a1dd2150971e..aa8aa9dcf02a 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1013,6 +1013,28 @@ struct vfio_iommu_type1_info_cap_iova_range {
>  	struct	vfio_iova_range iova_ranges[];
>  };
>  
> +/*
> + * The migration capability allows to report supported features for migration.
> + *
> + * The structures below define version 1 of this capability.
> + *
> + * The existence of this capability indicates IOMMU kernel driver supports

s/indicates/indicates that/

> + * dirty page tracking.
> + *
> + * pgsize_bitmap: Kernel driver returns supported page sizes bitmap for dirty
> + * page tracking.

"bitmap of supported page sizes for dirty page tracking" ?

> + * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
> + * size in bytes to be used by user application for ioctls to get dirty bitmap.

"maximum supported dirty bitmap size in bytes that can be used by user
applications when getting the dirty bitmap" ?

> + */
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
> +
> +struct vfio_iommu_type1_info_cap_migration {
> +	struct	vfio_info_cap_header header;
> +	__u32	flags;
> +	__u64	pgsize_bitmap;
> +	__u64	max_dirty_bitmap_size;		/* in bytes */
> +};
> +
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>  
>  /**

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

