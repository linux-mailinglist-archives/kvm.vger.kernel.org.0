Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1B22451F2
	for <lists+kvm@lfdr.de>; Sat, 15 Aug 2020 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgHOVch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Aug 2020 17:32:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39288 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726912AbgHOVca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Aug 2020 17:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597527147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0QF9s7ohj4aNl8eau7he4E9tQctsoC4pp/nsapCJL4=;
        b=CT+5vwiQTLnHtPepWrbzAXpGG7+YeR8TJ4+mb+o9ykDxZI0MwUxUhWFceqGGrpSZMLhSFU
        iR5aWZADL2p3XqFsxb33ASJMxVAV5OZm7iD2JOEWvbvDJfpZFN4yy+JTAfw3/d72KFboAA
        UqV6yuNt1olejz3TFUv8Ozr2akC+pQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-XMeVB9CSPX2lvLUrfoyLuA-1; Sat, 15 Aug 2020 12:30:55 -0400
X-MC-Unique: XMeVB9CSPX2lvLUrfoyLuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38FBE1015DC2;
        Sat, 15 Aug 2020 16:30:38 +0000 (UTC)
Received: from [10.36.113.93] (ovpn-113-93.ams2.redhat.com [10.36.113.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C147E7A426;
        Sat, 15 Aug 2020 16:30:28 +0000 (UTC)
Subject: Re: [PATCH v6 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-10-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0db97d4a-7c74-9fac-0763-0ed56dcc5eaa@redhat.com>
Date:   Sat, 15 Aug 2020 18:30:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1595917664-33276-10-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/28/20 8:27 AM, Liu Yi L wrote:
> When an IOMMU domain with nesting attribute is used for guest SVA, a
> system-wide PASID is allocated for binding with the device and the domain.
> For security reason, we need to check the PASID passed from user-space.
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
> index b2fe54e..88f4647 100644
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
> index c85b8d5..b9b29ad 100644
> --- a/drivers/iommu/intel/svm.c
> +++ b/drivers/iommu/intel/svm.c
> @@ -323,7 +323,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
>  	dmar_domain = to_dmar_domain(domain);
>  
>  	mutex_lock(&pasid_mutex);
> -	svm = ioasid_find(INVALID_IOASID_SET, data->hpasid, NULL);
> +	svm = ioasid_find(dmar_domain->ioasid_sid, data->hpasid, NULL);
A question about the locking strategy. We don't take the
device_domain_lock here. Could you clarify whether it is safe?


>  	if (IS_ERR(svm)) {
>  		ret = PTR_ERR(svm);
>  		goto out;
> @@ -440,6 +440,7 @@ int intel_svm_unbind_gpasid(struct iommu_domain *domain,
>  			    struct device *dev, u32 pasid)
>  {
>  	struct intel_iommu *iommu = intel_svm_device_to_iommu(dev);
> +	struct dmar_domain *dmar_domain;
>  	struct intel_svm_dev *sdev;
>  	struct intel_svm *svm;
>  	int ret = -EINVAL;
> @@ -447,8 +448,10 @@ int intel_svm_unbind_gpasid(struct iommu_domain *domain,
>  	if (WARN_ON(!iommu))
>  		return -EINVAL;
>  
> +	dmar_domain = to_dmar_domain(domain);
> +
>  	mutex_lock(&pasid_mutex);
> -	svm = ioasid_find(INVALID_IOASID_SET, pasid, NULL);
> +	svm = ioasid_find(dmar_domain->ioasid_sid, pasid, NULL);
same here.
>  	if (!svm) {
>  		ret = -EINVAL;
>  		goto out;
> 
Thanks

Eric

