Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC4919A7CB
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 10:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbgDAIvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 04:51:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43876 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbgDAIvQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 04:51:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585731075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k51ON82VcZwelzrYwCOEF4ihu17AnECiYNHTB0XAM+E=;
        b=IBOtP8h8eusnqkzIAQsLCUlagNjSJW/Bp/pZ9JHZDinreolGJelSZa+0XGWjTd1hsF5cTb
        K0KZPdlUaCaDU7Tah8oX9lqqXC8Rnr6EWG7F0HwDSyQGzY1X8aZgu3Vfp+QI08Te+s3jBx
        cwQkU+9fU/aFjcrgxxyp73xObqO2cbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-dy1z8-k7M5OxSU80lgCm-A-1; Wed, 01 Apr 2020 04:51:13 -0400
X-MC-Unique: dy1z8-k7M5OxSU80lgCm-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9B6E18A6ECE;
        Wed,  1 Apr 2020 08:51:11 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BFC0699DF3;
        Wed,  1 Apr 2020 08:51:02 +0000 (UTC)
Subject: Re: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
To:     "Liu, Yi L" <yi.l.liu@intel.com>, alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hao.wu@intel.com
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <cb68e9ab-77b0-7e97-a661-4836962041d9@redhat.com>
Date:   Wed, 1 Apr 2020 10:51:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,
On 3/22/20 1:32 PM, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> VFIO exposes IOMMU nesting translation (a.k.a dual stage translation)
> capability to userspace. Thus applications like QEMU could support
> vIOMMU with hardware's nesting translation capability for pass-through
> devices. Before setting up nesting translation for pass-through devices,
> QEMU and other applications need to learn the supported 1st-lvl/stage-1
> translation structure format like page table format.
> 
> Take vSVA (virtual Shared Virtual Addressing) as an example, to support
> vSVA for pass-through devices, QEMU setup nesting translation for pass-
> through devices. The guest page table are configured to host as 1st-lvl/
> stage-1 page table. Therefore, guest format should be compatible with
> host side.
> 
> This patch reports the supported 1st-lvl/stage-1 page table format on the
> current platform to userspace. QEMU and other alike applications should
> use this format info when trying to setup IOMMU nesting translation on
> host IOMMU.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 56 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  1 +
>  2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 9aa2a67..82a9e0b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2234,11 +2234,66 @@ static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_iommu_get_stage1_format(struct vfio_iommu *iommu,
> +					 u32 *stage1_format)
vfio_pasid_format() to be homogeneous with vfio_pgsize_bitmap() which
does the same kind of enumeration of the vfio_iommu domains
> +{
> +	struct vfio_domain *domain;
> +	u32 format = 0, tmp_format = 0;
> +	int ret;
ret = -EINVAL;
> +
> +	mutex_lock(&iommu->lock);
> +	if (list_empty(&iommu->domain_list)) {
goto out_unlock;
> +		mutex_unlock(&iommu->lock);
> +		return -EINVAL;
> +	}
> +
> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> +		if (iommu_domain_get_attr(domain->domain,
> +			DOMAIN_ATTR_PASID_FORMAT, &format)) {
I can find DOMAIN_ATTR_PASID_FORMAT in Jacob's v9 but not in v10
> +			ret = -EINVAL;
could be removed
> +			format = 0;
> +			goto out_unlock;
> +		}
> +		/*
> +		 * format is always non-zero (the first format is
> +		 * IOMMU_PASID_FORMAT_INTEL_VTD which is 1). For
> +		 * the reason of potential different backed IOMMU
> +		 * formats, here we expect to have identical formats
> +		 * in the domain list, no mixed formats support.
> +		 * return -EINVAL to fail the attempt of setup
> +		 * VFIO_TYPE1_NESTING_IOMMU if non-identical formats
> +		 * are detected.
> +		 */
> +		if (tmp_format && tmp_format != format) {
> +			ret = -EINVAL;
could be removed
> +			format = 0;
> +			goto out_unlock;
> +		}
> +
> +		tmp_format = format;
> +	}
> +	ret = 0;
> +
> +out_unlock:
> +	if (format)
if (!ret) ? then you can remove the format = 0 in case of error.
> +		*stage1_format = format;
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
>  					 struct vfio_info_cap *caps)
>  {
>  	struct vfio_info_cap_header *header;
>  	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
> +	u32 formats = 0;
> +	int ret;
> +
> +	ret = vfio_iommu_get_stage1_format(iommu, &formats);
> +	if (ret) {
> +		pr_warn("Failed to get stage-1 format\n");
trace triggered by userspace to be removed?
> +		return ret;
> +	}
>  
>  	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
>  				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
> @@ -2254,6 +2309,7 @@ static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
>  		/* nesting iommu type supports PASID requests (alloc/free) */
>  		nesting_cap->nesting_capabilities |= VFIO_IOMMU_PASID_REQS;
What is the meaning for ARM?
>  	}
> +	nesting_cap->stage1_formats = formats;
as spotted by Kevin, since a single format is supported, rename
>  
>  	return 0;
>  }
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ed9881d..ebeaf3e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -763,6 +763,7 @@ struct vfio_iommu_type1_info_cap_nesting {
>  	struct	vfio_info_cap_header header;
>  #define VFIO_IOMMU_PASID_REQS	(1 << 0)
>  	__u32	nesting_capabilities;
> +	__u32	stage1_formats;
>  };
>  
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> 
Thanks

Eric

