Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102FB19C873
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389244AbgDBSBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:01:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35235 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388648AbgDBSBT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 14:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585850477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TuJXTu9rJu0+h7TGYhV5Gmdmq14OC6YvWqcRaZtvH2U=;
        b=XOG5R+pUydmZxMk4LdYWYOAvNtG0yL/y87IlCP4qM6ApWA6NWXRSMZ8vT993XLjauaA71L
        AU177nag0DeWEYJkzCIvO/huphCSJB+0eZYubCS3gAuBgVe8v2LYPhYL3Ivk+63ULrHj//
        Xri46tyedOTDaQFBCBlq0+lOD16HZC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-36_XwoHxOCqhaXgOqqEFPQ-1; Thu, 02 Apr 2020 14:01:14 -0400
X-MC-Unique: 36_XwoHxOCqhaXgOqqEFPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20E749A682;
        Thu,  2 Apr 2020 18:01:02 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FB115E000;
        Thu,  2 Apr 2020 18:01:01 +0000 (UTC)
Date:   Thu, 2 Apr 2020 12:01:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, joro@8bytes.org,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: Re: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
 userspace
Message-ID: <20200402120100.19e43c72@w520.home>
In-Reply-To: <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Mar 2020 05:32:00 -0700
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> From: Liu Yi L <yi.l.liu@intel.com>
> 
> This patch reports PASID alloc/free availability to userspace (e.g. QEMU)
> thus userspace could do a pre-check before utilizing this feature.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 28 ++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  8 ++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index e40afc0..ddd1ffe 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2234,6 +2234,30 @@ static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> +					 struct vfio_info_cap *caps)
> +{
> +	struct vfio_info_cap_header *header;
> +	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
> +
> +	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
> +				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
> +	if (IS_ERR(header))
> +		return PTR_ERR(header);
> +
> +	nesting_cap = container_of(header,
> +				struct vfio_iommu_type1_info_cap_nesting,
> +				header);
> +
> +	nesting_cap->nesting_capabilities = 0;
> +	if (iommu->nesting) {
> +		/* nesting iommu type supports PASID requests (alloc/free) */
> +		nesting_cap->nesting_capabilities |= VFIO_IOMMU_PASID_REQS;
> +	}
> +
> +	return 0;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2283,6 +2307,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		if (ret)
>  			return ret;
>  
> +		ret = vfio_iommu_info_add_nesting_cap(iommu, &caps);
> +		if (ret)
> +			return ret;
> +
>  		if (caps.size) {
>  			info.flags |= VFIO_IOMMU_INFO_CAPS;
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 298ac80..8837219 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -748,6 +748,14 @@ struct vfio_iommu_type1_info_cap_iova_range {
>  	struct	vfio_iova_range iova_ranges[];
>  };
>  
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  2
> +
> +struct vfio_iommu_type1_info_cap_nesting {
> +	struct	vfio_info_cap_header header;
> +#define VFIO_IOMMU_PASID_REQS	(1 << 0)
> +	__u32	nesting_capabilities;
> +};
> +
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>  
>  /**

I think this answers my PROBE question on patch 1/.  Should the
quota/usage be exposed to the user here?  Thanks,

Alex

