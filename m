Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4F41C7D50
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 00:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgEFW1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 18:27:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26161 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728888AbgEFW1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 18:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588804067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xtyZQxIBvrwGclxq/zCovldcHxaVBe7Li+rCCyfx+sE=;
        b=UWViOqlPL/UF7ecRxZj5wx52PoR0ZjCp4ldrlbKqxDxdQMBlikVb1ERi5ma2yttYbZZKWC
        17wom2FWhK7c+XKarNdM2ItSHJMbjmJ1pfut65jpjvt4HvXAQ8otpdHEKToVaYorD0Z38B
        0M/EATN0nE5ZMQJ5rPRDPuQR3GNXxlA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-5x6HgCc7N-mvSSmOZ1TKEg-1; Wed, 06 May 2020 18:27:43 -0400
X-MC-Unique: 5x6HgCc7N-mvSSmOZ1TKEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 055E78014D9;
        Wed,  6 May 2020 22:27:41 +0000 (UTC)
Received: from w520.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DCCE1001920;
        Wed,  6 May 2020 22:27:39 +0000 (UTC)
Date:   Wed, 6 May 2020 16:27:38 -0600
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
Subject: Re: [PATCH Kernel v18 6/7] vfio iommu: Add migration capability to
 report supported features
Message-ID: <20200506162738.6e08dbf2@w520.home>
In-Reply-To: <1588607939-26441-7-git-send-email-kwankhede@nvidia.com>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
        <1588607939-26441-7-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 May 2020 21:28:58 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Added migration capability in IOMMU info chain.
> User application should check IOMMU info chain for migration capability
> to use dirty page tracking feature provided by kernel module.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++++
>  include/uapi/linux/vfio.h       | 14 ++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 8b27faf1ec38..b38d278d7bff 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2378,6 +2378,17 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_iommu_migration_build_caps(struct vfio_info_cap *caps)
> +{
> +	struct vfio_iommu_type1_info_cap_migration cap_mig;
> +
> +	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
> +	cap_mig.header.version = 1;
> +	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
> +
> +	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2427,6 +2438,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		if (ret)
>  			return ret;
>  
> +		ret = vfio_iommu_migration_build_caps(&caps);
> +		if (ret)
> +			return ret;
> +
>  		if (caps.size) {
>  			info.flags |= VFIO_IOMMU_INFO_CAPS;
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index e3cbf8b78623..df9ce8aaafab 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1013,6 +1013,20 @@ struct vfio_iommu_type1_info_cap_iova_range {
>  	struct	vfio_iova_range iova_ranges[];
>  };
>  
> +/*
> + * The migration capability allows to report supported features for migration.
> + *
> + * The structures below define version 1 of this capability.
> + */
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
> +
> +struct vfio_iommu_type1_info_cap_migration {
> +	struct	vfio_info_cap_header header;
> +	__u32	flags;
> +	/* supports dirty page tracking */
> +#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)
> +};
> +

What about exposing the maximum supported dirty bitmap size and the
supported page sizes?  Thanks,

Alex

>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>  
>  /**

