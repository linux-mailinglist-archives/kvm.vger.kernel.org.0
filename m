Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCC2225285
	for <lists+kvm@lfdr.de>; Sun, 19 Jul 2020 17:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgGSPiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jul 2020 11:38:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27856 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbgGSPiH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jul 2020 11:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595173085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFa20iOvNaIpC3/ExmrY2AxI8kzsflBaDnsmuPlGFx8=;
        b=VPEzdOYYFpg9+s49DFJLApYnfK4jIS4asUSiuKOjt1cTugrIQx9++EJkct569yiNWOP95e
        2uhEXHJJmIlPfeOT/phW7kE35SkErDYIeA341d1FuJabrqNKrsWnSihJF4Teo1tXnRPDqr
        z851lMMCH2dM4vtbv9otIcox2ViREJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-bjCNlHG2Os-xmHBRAOqNFQ-1; Sun, 19 Jul 2020 11:38:01 -0400
X-MC-Unique: bjCNlHG2Os-xmHBRAOqNFQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 805CD80183C;
        Sun, 19 Jul 2020 15:37:59 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 727001A90F;
        Sun, 19 Jul 2020 15:37:50 +0000 (UTC)
Subject: Re: [PATCH v5 08/15] iommu: Pass domain to sva_unbind_gpasid()
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-9-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <27ac7880-bdd3-2891-139e-b4a7cd18420b@redhat.com>
Date:   Sun, 19 Jul 2020 17:37:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-9-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 7/12/20 1:21 PM, Liu Yi L wrote:
> From: Yi Sun <yi.y.sun@intel.com>
> 
> Current interface is good enough for SVA virtualization on an assigned
> physical PCI device, but when it comes to mediated devices, a physical
> device may attached with multiple aux-domains. Also, for guest unbind,
> the PASID to be unbind should be allocated to the VM. This check requires
> to know the ioasid_set which is associated with the domain.
> 
> So this interface needs to pass in domain info. Then the iommu driver is
> able to know which domain will be used for the 2nd stage translation of
> the nesting mode and also be able to do PASID ownership check. This patch
> passes @domain per the above reason.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
> v2 -> v3:
> *) pass in domain info only
> *) use ioasid_t for pasid instead of int type
> 
> v1 -> v2:
> *) added in v2.
> ---
>  drivers/iommu/intel/svm.c   | 3 ++-
>  drivers/iommu/iommu.c       | 2 +-
>  include/linux/intel-iommu.h | 3 ++-
>  include/linux/iommu.h       | 3 ++-
>  4 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
> index b9a9c55..d2c0e1a 100644
> --- a/drivers/iommu/intel/svm.c
> +++ b/drivers/iommu/intel/svm.c
> @@ -432,7 +432,8 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
>  	return ret;
>  }
>  
> -int intel_svm_unbind_gpasid(struct device *dev, int pasid)
> +int intel_svm_unbind_gpasid(struct iommu_domain *domain,
> +			    struct device *dev, ioasid_t pasid)
int -> ioasid_t proto change is not described in the commit message,
>  {
>  	struct intel_iommu *iommu = intel_svm_device_to_iommu(dev);
>  	struct intel_svm_dev *sdev;
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 7910249..d3e554c 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2151,7 +2151,7 @@ int __iommu_sva_unbind_gpasid(struct iommu_domain *domain, struct device *dev,
>  	if (unlikely(!domain->ops->sva_unbind_gpasid))
>  		return -ENODEV;
>  
> -	return domain->ops->sva_unbind_gpasid(dev, data->hpasid);
> +	return domain->ops->sva_unbind_gpasid(domain, dev, data->hpasid);
>  }
>  EXPORT_SYMBOL_GPL(__iommu_sva_unbind_gpasid);
>  
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 0d0ab32..18f292e 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -738,7 +738,8 @@ extern int intel_svm_enable_prq(struct intel_iommu *iommu);
>  extern int intel_svm_finish_prq(struct intel_iommu *iommu);
>  int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
>  			  struct iommu_gpasid_bind_data *data);
> -int intel_svm_unbind_gpasid(struct device *dev, int pasid);
> +int intel_svm_unbind_gpasid(struct iommu_domain *domain,
> +			    struct device *dev, ioasid_t pasid);
>  struct iommu_sva *intel_svm_bind(struct device *dev, struct mm_struct *mm,
>  				 void *drvdata);
>  void intel_svm_unbind(struct iommu_sva *handle);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index e84a1d5..ca5edd8 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -303,7 +303,8 @@ struct iommu_ops {
>  	int (*sva_bind_gpasid)(struct iommu_domain *domain,
>  			struct device *dev, struct iommu_gpasid_bind_data *data);
>  
> -	int (*sva_unbind_gpasid)(struct device *dev, int pasid);
> +	int (*sva_unbind_gpasid)(struct iommu_domain *domain,
> +				 struct device *dev, ioasid_t pasid);
>  
>  	int (*def_domain_type)(struct device *dev);
>  
> 
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

