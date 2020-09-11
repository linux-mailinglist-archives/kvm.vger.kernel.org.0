Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DECA2668FC
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgIKTjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:39:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725886AbgIKTjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 15:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599853146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XkONE/g0FLpiBamkrJndr/ZIJkzwsHn+tlSk2RJm3GY=;
        b=dx0vpN/lMZvssfUSPlJBWlQ4paQwJThQX+5rRkbkY19DSbr108vS7KKBqev9tqoUMd2Frl
        Fs7D+QCnAfjLAu9j2zMvxTkJee1v1zr3drQF1EM/asH3dQQll8oXf5CD+WX563cHwuV+vg
        8GbvmPMbZ+PT9SL2ugDZ+3S5Ds5ArnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-ArsGl1IMO6KvtIClzxqg5A-1; Fri, 11 Sep 2020 15:39:04 -0400
X-MC-Unique: ArsGl1IMO6KvtIClzxqg5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A81181CAFF;
        Fri, 11 Sep 2020 19:39:02 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F79E60C04;
        Fri, 11 Sep 2020 19:38:55 +0000 (UTC)
Date:   Fri, 11 Sep 2020 13:38:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, jasowang@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 01/16] iommu: Report domain nesting info
Message-ID: <20200911133854.0e6a919c@w520.home>
In-Reply-To: <1599734733-6431-2-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <1599734733-6431-2-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Sep 2020 03:45:18 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> IOMMUs that support nesting translation needs report the capability info
> to userspace. It gives information about requirements the userspace needs
> to implement plus other features characterizing the physical implementation.
> 
> This patch introduces a new IOMMU UAPI struct that gives information about
> the nesting capabilities and features. This struct is supposed to be returned
> by iommu_domain_get_attr() with DOMAIN_ATTR_NESTING attribute parameter, with
> one domain whose type has been set to DOMAIN_ATTR_NESTING.
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
> v6 -> v7:
> *) rephrase the commit message, replace the @data[] field in struct
>    iommu_nesting_info with union per comments from Eric Auger.
> 
> v5 -> v6:
> *) rephrase the feature notes per comments from Eric Auger.
> *) rename @size of struct iommu_nesting_info to @argsz.
> 
> v4 -> v5:
> *) address comments from Eric Auger.
> 
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
>  include/uapi/linux/iommu.h | 76 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 1ebc23d..ff987e4 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -341,4 +341,80 @@ struct iommu_gpasid_bind_data {
>  	} vendor;
>  };
>  
> +/*
> + * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info.
> + *
> + * @flags:	VT-d specific flags. Currently reserved for future
> + *		extension. must be set to 0.
> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> + *		register.
> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> + *		extended capability register.
> + */
> +struct iommu_nesting_info_vtd {
> +	__u32	flags;
> +	__u64	cap_reg;
> +	__u64	ecap_reg;
> +};


The vendor union has 8-byte alignment, so flags here will be 8-byte
aligned, followed by a compiler dependent gap before the 8-byte fields.
We should fill that gap with padding to make it deterministic for
userspace.  Thanks,

Alex

> +
> +/*
> + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
> + *			       userspace should check it before using
> + *			       nesting capability.
> + *
> + * @argsz:	size of the whole structure.
> + * @flags:	currently reserved for future extension. must set to 0.
> + * @format:	PASID table entry format, the same definition as struct
> + *		iommu_gpasid_bind_data @format.
> + * @features:	supported nesting features.
> + * @addr_width:	The output addr width of first level/stage translation
> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> + *		support.
> + * @vendor:	vendor specific data, structure type can be deduced from
> + *		@format field.
> + *
> + * +===============+======================================================+
> + * | feature       |  Notes                                               |
> + * +===============+======================================================+
> + * | SYSWIDE_PASID |  IOMMU vendor driver sets it to mandate userspace    |
> + * |               |  to allocate PASID from kernel. All PASID allocation |
> + * |               |  free must be mediated through the IOMMU UAPI.       |
> + * +---------------+------------------------------------------------------+
> + * | BIND_PGTBL    |  IOMMU vendor driver sets it to mandate userspace to |
> + * |               |  bind the first level/stage page table to associated |
> + * |               |  PASID (either the one specified in bind request or  |
> + * |               |  the default PASID of iommu domain), through IOMMU   |
> + * |               |  UAPI.                                               |
> + * +---------------+------------------------------------------------------+
> + * | CACHE_INVLD   |  IOMMU vendor driver sets it to mandate userspace to |
> + * |               |  explicitly invalidate the IOMMU cache through IOMMU |
> + * |               |  UAPI according to vendor-specific requirement when  |
> + * |               |  changing the 1st level/stage page table.            |
> + * +---------------+------------------------------------------------------+
> + *
> + * data struct types defined for @format:
> + * +================================+=====================================+
> + * | @format                        | data struct                         |
> + * +================================+=====================================+
> + * | IOMMU_PASID_FORMAT_INTEL_VTD   | struct iommu_nesting_info_vtd       |
> + * +--------------------------------+-------------------------------------+
> + *
> + */
> +struct iommu_nesting_info {
> +	__u32	argsz;
> +	__u32	flags;
> +	__u32	format;
> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> +	__u32	features;
> +	__u16	addr_width;
> +	__u16	pasid_bits;
> +	__u8	padding[12];
> +	/* Vendor specific data */
> +	union {
> +		struct iommu_nesting_info_vtd vtd;
> +	} vendor;
> +};
> +
>  #endif /* _UAPI_IOMMU_H */

