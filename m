Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694E42252B5
	for <lists+kvm@lfdr.de>; Sun, 19 Jul 2020 18:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgGSQGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jul 2020 12:06:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23853 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726146AbgGSQGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jul 2020 12:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595174775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvn7ah9yf4ty3GXyVniTDmRhC/pcWFvbVoRwSMY5+K0=;
        b=PxlSaHQgPaJZMhUhB/ERIK4y6pavVRlBcWYXtvKNtRNJ73sHhVv4nkos/F2zsBgtm+NcCE
        +5rsoOdvQQDjWiJn7a0KiKutg06yZzQwcMan5qsPBqr1mpmtE6Bdklny3asgUi+uZ9PDfM
        0FFROadcd5wigd7FjDL+/X+dZWx16OM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-Oax_5lNPP8a5oDpzki4syg-1; Sun, 19 Jul 2020 12:06:13 -0400
X-MC-Unique: Oax_5lNPP8a5oDpzki4syg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5984A1005504;
        Sun, 19 Jul 2020 16:06:11 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 398A472E45;
        Sun, 19 Jul 2020 16:06:02 +0000 (UTC)
Subject: Re: [PATCH v5 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-10-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b55a09f7-c0ce-f2ff-a725-87a8e042ab80@redhat.com>
Date:   Sun, 19 Jul 2020 18:06:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-10-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/12/20 1:21 PM, Liu Yi L wrote:
> When an IOMMU domain with nesting attribute is used for guest SVA, a
> system-wide PASID is allocated for binding with the device and the domain.
> For security reason, we need to check the PASID passsed from user-space.
passed
> e.g. page table bind/unbind and PASID related cache invalidation.
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
>  drivers/iommu/intel/iommu.c | 10 ++++++++++
>  drivers/iommu/intel/svm.c   |  7 +++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 4d54198..a9504cb 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5436,6 +5436,7 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
>  		int granu = 0;
>  		u64 pasid = 0;
>  		u64 addr = 0;
> +		void *pdata;
>  
>  		granu = to_vtd_granularity(cache_type, inv_info->granularity);
>  		if (granu == -EINVAL) {
> @@ -5456,6 +5457,15 @@ intel_iommu_sva_invalidate(struct iommu_domain *domain, struct device *dev,
>  			 (inv_info->granu.addr_info.flags & IOMMU_INV_ADDR_FLAGS_PASID))
>  			pasid = inv_info->granu.addr_info.pasid;
>  
> +		pdata = ioasid_find(dmar_domain->ioasid_sid, pasid, NULL);
> +		if (!pdata) {
> +			ret = -EINVAL;
> +			goto out_unlock;
> +		} else if (IS_ERR(pdata)) {
> +			ret = PTR_ERR(pdata);
> +			goto out_unlock;
> +		}
> +
>  		switch (BIT(cache_type)) {
>  		case IOMMU_CACHE_INV_TYPE_IOTLB:
>  			/* HW will ignore LSB bits based on address mask */
> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
> index d2c0e1a..212dee0 100644
> --- a/drivers/iommu/intel/svm.c
> +++ b/drivers/iommu/intel/svm.c
> @@ -319,7 +319,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
>  	dmar_domain = to_dmar_domain(domain);
>  
>  	mutex_lock(&pasid_mutex);
> -	svm = ioasid_find(INVALID_IOASID_SET, data->hpasid, NULL);
I do not get what the call was supposed to do before that patch?
> +	svm = ioasid_find(dmar_domain->ioasid_sid, data->hpasid, NULL);
>  	if (IS_ERR(svm)) {
>  		ret = PTR_ERR(svm);
>  		goto out;
> @@ -436,6 +436,7 @@ int intel_svm_unbind_gpasid(struct iommu_domain *domain,
>  			    struct device *dev, ioasid_t pasid)
>  {
>  	struct intel_iommu *iommu = intel_svm_device_to_iommu(dev);
> +	struct dmar_domain *dmar_domain;
>  	struct intel_svm_dev *sdev;
>  	struct intel_svm *svm;
>  	int ret = -EINVAL;
> @@ -443,8 +444,10 @@ int intel_svm_unbind_gpasid(struct iommu_domain *domain,
>  	if (WARN_ON(!iommu))
>  		return -EINVAL;
>  
> +	dmar_domain = to_dmar_domain(domain);
> +
>  	mutex_lock(&pasid_mutex);
> -	svm = ioasid_find(INVALID_IOASID_SET, pasid, NULL);
> +	svm = ioasid_find(dmar_domain->ioasid_sid, pasid, NULL);
just to make sure, about the locking, can't domain->ioasid_sid change
under the hood?

Thanks

Eric
>  	if (!svm) {
>  		ret = -EINVAL;
>  		goto out;
> 

