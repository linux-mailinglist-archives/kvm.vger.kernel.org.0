Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D05D243C26
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 17:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHMPHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 11:07:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30687 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbgHMPHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 11:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597331233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k1/COf1rYZPBo+t1nqm+FQLIB91ekTH/x8nDL3/8R0g=;
        b=ad0MW8Dg7hddkj/YkxukfzSgqXmI/rLo9BpAVhA1Nt88+VQQl5vkLoKLMcg2yERnAu4JgK
        khuIr4gTH3uJA1Y1Eh4mYtHK2QNasGEMTxJa+qi/CZ6hTILN3qhX6WSPJ0gByypHa1aiJe
        8y61wCJlWeAXsW8fUuSSokEV6yqtJ+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-JpFIrVg6ObCUBU0HBSwDUQ-1; Thu, 13 Aug 2020 11:07:10 -0400
X-MC-Unique: JpFIrVg6ObCUBU0HBSwDUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A00A9100CA88;
        Thu, 13 Aug 2020 15:07:08 +0000 (UTC)
Received: from [10.36.113.93] (ovpn-113-93.ams2.redhat.com [10.36.113.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD7745C1A3;
        Thu, 13 Aug 2020 15:06:57 +0000 (UTC)
Subject: Re: [PATCH v6 06/15] iommu/vt-d: Support setting ioasid set to domain
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-7-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ae43dda5-01aa-adb1-d21d-2525cf4f4d95@redhat.com>
Date:   Thu, 13 Aug 2020 17:06:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1595917664-33276-7-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/28/20 8:27 AM, Liu Yi L wrote:
> From IOMMU p.o.v., PASIDs allocated and managed by external components
> (e.g. VFIO) will be passed in for gpasid_bind/unbind operation. IOMMU
> needs some knowledge to check the PASID ownership, hence add an interface
> for those components to tell the PASID owner.
> 
> In latest kernel design, PASID ownership is managed by IOASID set where
> the PASID is allocated from. This patch adds support for setting ioasid
> set ID to the domains used for nesting/vSVA. Subsequent SVA operations
> will check the PASID against its IOASID set for proper ownership.
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
> v5 -> v6:
> *) address comments against v5 from Eric Auger.
> 
> v4 -> v5:
> *) address comments from Eric Auger.
> ---
>  drivers/iommu/intel/iommu.c | 23 +++++++++++++++++++++++
>  include/linux/intel-iommu.h |  4 ++++
>  include/linux/iommu.h       |  1 +
>  3 files changed, 28 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ed4b71c..b2fe54e 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1793,6 +1793,7 @@ static struct dmar_domain *alloc_domain(int flags)
>  	if (first_level_by_default())
>  		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
>  	domain->has_iotlb_device = false;
> +	domain->ioasid_sid = INVALID_IOASID_SET;
>  	INIT_LIST_HEAD(&domain->devices);
>  
>  	return domain;
> @@ -6040,6 +6041,28 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
>  		}
>  		spin_unlock_irqrestore(&device_domain_lock, flags);
>  		break;
> +	case DOMAIN_ATTR_IOASID_SID:
> +	{
> +		int sid = *(int *)data;

> +
> +		spin_lock_irqsave(&device_domain_lock, flags);
> +		if (!(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE)) {
> +			ret = -ENODEV;
> +			spin_unlock_irqrestore(&device_domain_lock, flags);
> +			break;
> +		}
> +		if (dmar_domain->ioasid_sid != INVALID_IOASID_SET &&
> +		    dmar_domain->ioasid_sid != sid) {
> +			pr_warn_ratelimited("multi ioasid_set (%d:%d) setting",
> +					    dmar_domain->ioasid_sid, sid);
> +			ret = -EBUSY;
> +			spin_unlock_irqrestore(&device_domain_lock, flags);
> +			break;
> +		}
> +		dmar_domain->ioasid_sid = sid;
> +		spin_unlock_irqrestore(&device_domain_lock, flags);
> +		break;
nit: Adding a small helper
int__set_ioasid_sid(struct dmar_domain *dmar_domain, int sid_id)

may simplify the lock handling


> +	}
>  	default:
>  		ret = -EINVAL;
>  		break;
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 3f23c26..0d0ab32 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -549,6 +549,10 @@ struct dmar_domain {
>  					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
>  	u64		max_addr;	/* maximum mapped address */
>  
> +	int		ioasid_sid;	/*
> +					 * the ioasid set which tracks all
id of the ioasid set?
> +					 * PASIDs used by the domain.
> +					 */
>  	int		default_pasid;	/*
>  					 * The default pasid used for non-SVM
>  					 * traffic on mediated devices.
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 4a02c9e..b1ff702 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -124,6 +124,7 @@ enum iommu_attr {
>  	DOMAIN_ATTR_FSL_PAMUV1,
>  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
>  	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
> +	DOMAIN_ATTR_IOASID_SID,
>  	DOMAIN_ATTR_MAX,
>  };
>  
> 
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric

