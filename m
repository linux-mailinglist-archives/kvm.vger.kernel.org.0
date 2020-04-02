Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4F119C9E9
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 21:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389690AbgDBTUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 15:20:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732600AbgDBTUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 15:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585855234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Iy3b0tEw0WYsBUVVz0ZsRvSgmOMhz0jgg24jpdOh8c=;
        b=H+nBjtuhTVqtdDPJs0yDDwa8NjoEudI1jebsvx1JBx7eZx1gcS8+/c07GZ53/SW2fTgPvp
        Vq15K7Ec4vdcQ5rtWUgo19gQYNwDhVQiUqvw0b+7V5McF9fUz65GZaT//iCKu+pcUWNDwc
        l8PQssSIVtmeg52uXgOqdm8N8b+5TP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-l10McgFLN6-PWLYQYVF4GA-1; Thu, 02 Apr 2020 15:20:31 -0400
X-MC-Unique: l10McgFLN6-PWLYQYVF4GA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27D0818B641A;
        Thu,  2 Apr 2020 19:20:20 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D507C5D9C9;
        Thu,  2 Apr 2020 19:20:12 +0000 (UTC)
Date:   Thu, 2 Apr 2020 13:20:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, joro@8bytes.org,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: Re: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Message-ID: <20200402132012.390a7b54@w520.home>
In-Reply-To: <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Mar 2020 05:32:02 -0700
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

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
> +{
> +	struct vfio_domain *domain;
> +	u32 format = 0, tmp_format = 0;
> +	int ret;
> +
> +	mutex_lock(&iommu->lock);
> +	if (list_empty(&iommu->domain_list)) {
> +		mutex_unlock(&iommu->lock);
> +		return -EINVAL;
> +	}
> +
> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> +		if (iommu_domain_get_attr(domain->domain,
> +			DOMAIN_ATTR_PASID_FORMAT, &format)) {
> +			ret = -EINVAL;
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
> +		return ret;

Looks like this generates a warning and causes the iommu_get_info ioctl
to fail if the hardware doesn't support the pasid format attribute, or
the domain list is empty.  This breaks users on existing hardware.

> +	}
>  
>  	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
>  				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
> @@ -2254,6 +2309,7 @@ static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
>  		/* nesting iommu type supports PASID requests (alloc/free) */
>  		nesting_cap->nesting_capabilities |= VFIO_IOMMU_PASID_REQS;
>  	}
> +	nesting_cap->stage1_formats = formats;
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

