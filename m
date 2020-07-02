Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6147212BB0
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGBRzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 13:55:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31690 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728042AbgGBRzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 13:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593712512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7QTdTMTUaPeS9uufDmmu78eQSwCA8n+MLasIB1vQ58=;
        b=d1qts+do1dxWh/5+Oyp5JMvyDeTk6WbnYKhbfnemADozt2RVojEhVRgnQ7Mdsxdm6l+KQW
        f3cNFiPgaUFGoO4GLCKUs2K0myJEnVMnrw4aOiCAQmJ5hrWFjatxpUUyvOqqg4bzv4i/JU
        +zjefhRzexlYft3sjdqLbNg0J9XYLU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-dln7jSl0PfmDf3E1d450jA-1; Thu, 02 Jul 2020 13:55:04 -0400
X-MC-Unique: dln7jSl0PfmDf3E1d450jA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1088B1005513;
        Thu,  2 Jul 2020 17:55:02 +0000 (UTC)
Received: from x1.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C96779255;
        Thu,  2 Jul 2020 17:54:54 +0000 (UTC)
Date:   Thu, 2 Jul 2020 11:54:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/14] iommu: Report domain nesting info
Message-ID: <20200702115454.058bd198@x1.home>
In-Reply-To: <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jun 2020 01:55:15 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> IOMMUs that support nesting translation needs report the capability info
> to userspace, e.g. the format of first level/stage paging structures.
> 
> This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
> nesting info after setting DOMAIN_ATTR_NESTING.
> 
> v2 -> v3:
> *) remvoe cap/ecap_mask in iommu_nesting_info.
> *) reuse DOMAIN_ATTR_NESTING to get nesting info.
> *) return an empty iommu_nesting_info for SMMU drivers per Jean'
>    suggestion.
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
>  drivers/iommu/arm-smmu-v3.c | 29 ++++++++++++++++++++--
>  drivers/iommu/arm-smmu.c    | 29 ++++++++++++++++++++--
>  include/uapi/linux/iommu.h  | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 113 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index f578677..0c45d4d 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +					void *data)
> +{
> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
> +	u32 size;
> +
> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -ENODEV;
> +
> +	size = sizeof(struct iommu_nesting_info);
> +
> +	/*
> +	 * if provided buffer size is not equal to the size, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size != size) {
> +		info->size = size;
> +		return 0;
> +	}
> +
> +	/* report an empty iommu_nesting_info for now */
> +	memset(info, 0x0, size);
> +	info->size = size;
> +	return 0;
> +}
> +
>  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  				    enum iommu_attr attr, void *data)
>  {
> @@ -3028,8 +3054,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  	case IOMMU_DOMAIN_UNMANAGED:
>  		switch (attr) {
>  		case DOMAIN_ATTR_NESTING:
> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
> -			return 0;
> +			return arm_smmu_domain_nesting_info(smmu_domain, data);
>  		default:
>  			return -ENODEV;
>  		}
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 243bc4c..908607d 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1506,6 +1506,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +					void *data)
> +{
> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
> +	u32 size;
> +
> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -ENODEV;
> +
> +	size = sizeof(struct iommu_nesting_info);
> +
> +	/*
> +	 * if provided buffer size is not equal to the size, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size != size) {
> +		info->size = size;
> +		return 0;
> +	}
> +
> +	/* report an empty iommu_nesting_info for now */
> +	memset(info, 0x0, size);
> +	info->size = size;
> +	return 0;
> +}
> +
>  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  				    enum iommu_attr attr, void *data)
>  {
> @@ -1515,8 +1541,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  	case IOMMU_DOMAIN_UNMANAGED:
>  		switch (attr) {
>  		case DOMAIN_ATTR_NESTING:
> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
> -			return 0;
> +			return arm_smmu_domain_nesting_info(smmu_domain, data);
>  		default:
>  			return -ENODEV;
>  		}
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 1afc661..898c99a 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -332,4 +332,63 @@ struct iommu_gpasid_bind_data {
>  	} vendor;
>  };
>  
> +/*
> + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
> + *				user space should check it before using
> + *				nesting capability.
> + *
> + * @size:	size of the whole structure
> + * @format:	PASID table entry format, the same definition with
> + *		@format of struct iommu_gpasid_bind_data.
> + * @features:	supported nesting features.
> + * @flags:	currently reserved for future extension.
> + * @data:	vendor specific cap info.
> + *
> + * +---------------+----------------------------------------------------+
> + * | feature       |  Notes                                             |
> + * +===============+====================================================+
> + * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs used  |
> + * |               |  in the system should be allocated by host kernel  |
> + * +---------------+----------------------------------------------------+
> + * | BIND_PGTBL    |  bind page tables to host PASID, the PASID could   |
> + * |               |  either be a host PASID passed in bind request or  |
> + * |               |  default PASIDs (e.g. default PASID of aux-domain) |
> + * +---------------+----------------------------------------------------+
> + * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU       |
> + * +---------------+----------------------------------------------------+

Agree with the previous comments on these descriptions and Kevin's
suggestions.

> + *
> + */
> +struct iommu_nesting_info {
> +	__u32	size;
> +	__u32	format;
> +	__u32	features;
> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> +	__u32	flags;
> +	__u8	data[];

How does the user determine which vendor structure is provided in
data[]?  Thanks,

Alex

> +};
> +
> +/*
> + * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
> + *
> + *
> + * @flags:	VT-d specific flags. Currently reserved for future
> + *		extension.
> + * @addr_width:	The output addr width of first level/stage translation
> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> + *		support.
> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> + *		register.
> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> + *		extended capability register.
> + */
> +struct iommu_nesting_info_vtd {
> +	__u32	flags;
> +	__u16	addr_width;
> +	__u16	pasid_bits;
> +	__u64	cap_reg;
> +	__u64	ecap_reg;
> +};
> +
>  #endif /* _UAPI_IOMMU_H */

