Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E57F22528B
	for <lists+kvm@lfdr.de>; Sun, 19 Jul 2020 17:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgGSPi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jul 2020 11:38:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49059 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726024AbgGSPi1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jul 2020 11:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595173105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sR8yBAr1QJN2+zKIOTwWJ7EOYgUZ3st3D/33w4Kg/mw=;
        b=Gr7Ndx0Nqa/vbnzZ9aiT6N+o5FtrM8v7FDm+pyUb6sRKECj340BiroeJgzYPLHzf5jz7jy
        7SrU6tj70qWcUkP7TF0FhmRMFiaDCteo4Fc6i3HIznLyML/vVvX0Tn7e8RDqeTrWegXoL9
        BGTh1WYQDavrsb6B9lty0xgCAgn/3KU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-v8da0JohMCKKifB0kxUqEA-1; Sun, 19 Jul 2020 11:38:23 -0400
X-MC-Unique: v8da0JohMCKKifB0kxUqEA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 515678005B0;
        Sun, 19 Jul 2020 15:38:21 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FAA073044;
        Sun, 19 Jul 2020 15:38:12 +0000 (UTC)
Subject: Re: [PATCH v5 06/15] iommu/vt-d: Support setting ioasid set to domain
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-7-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e2c45f9d-af78-5da9-c7c2-061b476b6b0a@redhat.com>
Date:   Sun, 19 Jul 2020 17:38:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-7-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 7/12/20 1:21 PM, Liu Yi L wrote:
> From IOMMU p.o.v., PASIDs allocated and managed by external components
> (e.g. VFIO) will be passed in for gpasid_bind/unbind operation. IOMMU
> needs some knowledge to check the PASID ownership, hence add an interface
> for those components to tell the PASID owner.
> 
> In latest kernel design, PASID ownership is managed by IOASID set where
> the PASID is allocated from. This patch adds support for setting ioasid
> set ID to the domains used for nesting/vSVA. Subsequent SVA operations
> on the PASID will be checked against its IOASID set for proper ownership.
Subsequent SVA operations will check the PASID against its IOASID set
for proper ownership.
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
> v4 -> v5:
> *) address comments from Eric Auger.
> ---
>  drivers/iommu/intel/iommu.c | 22 ++++++++++++++++++++++
>  include/linux/intel-iommu.h |  4 ++++
>  include/linux/iommu.h       |  1 +
>  3 files changed, 27 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 72ae6a2..4d54198 100644
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
> @@ -6039,6 +6040,27 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
>  		}
>  		spin_unlock_irqrestore(&device_domain_lock, flags);
>  		break;
> +	case DOMAIN_ATTR_IOASID_SID:
> +	{
> +		int sid = *(int *)data;
> +
> +		if (!(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE)) {
> +			ret = -ENODEV;
> +			break;
> +		}
> +		spin_lock_irqsave(&device_domain_lock, flags);
I think the lock should be taken before the DOMAIN_FLAG_NESTING_MODE
check. Otherwise, the flags can be theretically changed inbetween the
check and the test below?

Thanks

Eric
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
> +					 * PASIDs used by the domain.
> +					 */
>  	int		default_pasid;	/*
>  					 * The default pasid used for non-SVM
>  					 * traffic on mediated devices.
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 7ca9d48..e84a1d5 100644
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

