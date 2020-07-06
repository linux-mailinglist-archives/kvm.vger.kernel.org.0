Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB002154CD
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 11:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgGFJel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 05:34:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47518 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728299AbgGFJek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 05:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594028079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXJx1qpbfVbAj/VWczfs0WOvGfiINR1HbPqQDklC3XA=;
        b=L9JFn9DdG1FNtmowFK0mMwMcxsvoQa8Cxad/gIFXgF8HPWiiIKiIaT/AQAyiEHRV1OlUeL
        TbQdAQVny2+XRyyU5z0f7U9vJKDvQXs+KR+woEKdohDVg9F1rbqwcBHLOgkR5MoFjD+yaW
        1dKjG04oDx/Nxf5Rqdknw/NIWRPGcYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-Zdh8rqKPNx-qOLPflH5qHg-1; Mon, 06 Jul 2020 05:34:35 -0400
X-MC-Unique: Zdh8rqKPNx-qOLPflH5qHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69532107ACF3;
        Mon,  6 Jul 2020 09:34:33 +0000 (UTC)
Received: from [10.36.113.241] (ovpn-113-241.ams2.redhat.com [10.36.113.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 766BF5D9D7;
        Mon,  6 Jul 2020 09:34:24 +0000 (UTC)
Subject: Re: [PATCH v4 02/15] iommu: Report domain nesting info
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-3-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b9479f61-7f9e-e0ae-5125-ab15f59b1ece@redhat.com>
Date:   Mon, 6 Jul 2020 11:34:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1593861989-35920-3-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/4/20 1:26 PM, Liu Yi L wrote:
> IOMMUs that support nesting translation needs report the capability info
need to report
> to userspace, e.g. the format of first level/stage paging structures.
> 
> This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
> nesting info after setting DOMAIN_ATTR_NESTING.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v3 -> v4:
> *) split the SMMU driver changes to be a separate patch
> *) move the @addr_width and @pasid_bits from vendor specific
>    part to generic part.
> *) tweak the description for the @features field of struct
>    iommu_nesting_info.
> *) add description on the @data[] field of struct iommu_nesting_info
> 
> v2 -> v3:
> *) remvoe cap/ecap_mask in iommu_nesting_info.
> *) reuse DOMAIN_ATTR_NESTING to get nesting info.
> *) return an empty iommu_nesting_info for SMMU drivers per Jean'
>    suggestion.
> ---
>  include/uapi/linux/iommu.h | 78 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 1afc661..1bfc032 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -332,4 +332,82 @@ struct iommu_gpasid_bind_data {
>  	} vendor;
>  };
>  
> +/*
> + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
> + *				user space should check it before using
> + *				nesting capability.
alignment?
> + *
> + * @size:	size of the whole structure
> + * @format:	PASID table entry format, the same definition with
> + *		@format of struct iommu_gpasid_bind_data.
the same definition as struct iommu_gpasid_bind_data @format?
> + * @features:	supported nesting features.
> + * @flags:	currently reserved for future extension.
> + * @addr_width:	The output addr width of first level/stage translation
> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> + *		support.
> + * @data:	vendor specific cap info. data[] structure type can be deduced
> + *		from @format field.
> + *
> + * +===============+======================================================+
> + * | feature       |  Notes                                               |
> + * +===============+======================================================+
> + * | SYSWIDE_PASID |  PASIDs are managed in system-wide, instead of per   |
> + * |               |  device. When a device is assigned to userspace or   |
> + * |               |  VM, proper uAPI (userspace driver framework uAPI,   |
> + * |               |  e.g. VFIO) must be used to allocate/free PASIDs for |
> + * |               |  the assigned device.                                |
> + * +---------------+------------------------------------------------------+
> + * | BIND_PGTBL    |  The owner of the first level/stage page table must  |
> + * |               |  explicitly bind the page table to associated PASID  |
> + * |               |  (either the one specified in bind request or the    |
> + * |               |  default PASID of iommu domain), through userspace   |
> + * |               |  driver framework uAPI (e.g. VFIO_IOMMU_NESTING_OP). |
> + * +---------------+------------------------------------------------------+
> + * | CACHE_INVLD   |  The owner of the first level/stage page table must  |
> + * |               |  explicitly invalidate the IOMMU cache through uAPI  |
> + * |               |  provided by userspace driver framework (e.g. VFIO)  |
> + * |               |  according to vendor-specific requirement when       |
> + * |               |  changing the page table.                            |
> + * +---------------+------------------------------------------------------+
Do you foresee cases where BIND_PGTBL and CACHE_INVLD shouldn't be
exposed as features?
> + *
> + * @data[] types defined for @format:
> + * +================================+=====================================+
> + * | @format                        | @data[]                             |
> + * +================================+=====================================+
> + * | IOMMU_PASID_FORMAT_INTEL_VTD   | struct iommu_nesting_info_vtd       |
> + * +--------------------------------+-------------------------------------+
> + *
> + */
> +struct iommu_nesting_info {
> +	__u32	size;
> +	__u32	format;
> +	__u32	features;
> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
In other structs the values seem to be defined before the field
> +	__u32	flags;
> +	__u16	addr_width;
> +	__u16	pasid_bits;
> +	__u32	padding;
> +	__u8	data[];
> +};
> +
> +/*
> + * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
> + *
spurious line
> + *
> + * @flags:	VT-d specific flags. Currently reserved for future
> + *		extension.
> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> + *		register.
> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> + *		extended capability register.
> + */
> +struct iommu_nesting_info_vtd {
> +	__u32	flags;
> +	__u32	padding;
> +	__u64	cap_reg;
> +	__u64	ecap_reg;
> +};
> +
>  #endif /* _UAPI_IOMMU_H */
> 
Thanks

Eric

