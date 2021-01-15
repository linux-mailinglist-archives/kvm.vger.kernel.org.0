Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F1C2F71B6
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 05:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbhAOEs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 23:48:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbhAOEs0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 23:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610686019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5qlVp+V62hJFOmojeKBtO6bnSDZxjgJebYHvIlsbcQM=;
        b=B+w76z7Lex0cFEQnQSBvlE5nhM3X4NJTL6P5z1S9MHhVZs4pBJ6dAoGY0CD6+X8766LHNz
        ajJUoJk6hEALN/Me+X0sQ0h9kyX1sqFeOUCbV/EPN+ZEcHROClAMEyINgRZFBGXbe5IH9f
        S03kvOhYh3moKlUpOJiCSIXqFJ3ubm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-WfDJ3MOTPVeX0K0c1Yjy4Q-1; Thu, 14 Jan 2021 23:46:55 -0500
X-MC-Unique: WfDJ3MOTPVeX0K0c1Yjy4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6E30802B45;
        Fri, 15 Jan 2021 04:46:51 +0000 (UTC)
Received: from [10.72.13.19] (ovpn-13-19.pek2.redhat.com [10.72.13.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A958771D52;
        Fri, 15 Jan 2021 04:46:29 +0000 (UTC)
Subject: Re: [RFC PATCH v3 1/2] iommu: Add capability IOMMU_CAP_VIOMMU
To:     Lu Baolu <baolu.lu@linux.intel.com>, tglx@linutronix.de,
        ashok.raj@intel.com, kevin.tian@intel.com, dave.jiang@intel.com,
        megha.dey@intel.com, dwmw2@infradead.org
Cc:     alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, will@kernel.org, joro@8bytes.org,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com, leon@kernel.org
References: <20210114013003.297050-1-baolu.lu@linux.intel.com>
 <20210114013003.297050-2-baolu.lu@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f2a50326-58de-919a-5992-130224c5725a@redhat.com>
Date:   Fri, 15 Jan 2021 12:46:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210114013003.297050-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/14 上午9:30, Lu Baolu wrote:
> Some vendor IOMMU drivers are able to declare that it is running in a VM
> context. This is very valuable for the features that only want to be
> supported on bare metal. Add a capability bit so that it could be used.
>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   drivers/iommu/intel/iommu.c  | 20 ++++++++++++++++++++
>   drivers/iommu/virtio-iommu.c |  9 +++++++++
>   include/linux/iommu.h        |  1 +
>   3 files changed, 30 insertions(+)
>
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index cb205a04fe4c..8eb022d0e8aa 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5738,12 +5738,32 @@ static inline bool nested_mode_support(void)
>   	return ret;
>   }
>   
> +static inline bool caching_mode_enabled(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	bool ret = false;
> +
> +	rcu_read_lock();
> +	for_each_active_iommu(iommu, drhd) {
> +		if (cap_caching_mode(iommu->cap)) {
> +			ret = true;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>   static bool intel_iommu_capable(enum iommu_cap cap)
>   {
>   	if (cap == IOMMU_CAP_CACHE_COHERENCY)
>   		return domain_update_iommu_snooping(NULL) == 1;
>   	if (cap == IOMMU_CAP_INTR_REMAP)
>   		return irq_remapping_enabled == 1;
> +	if (cap == IOMMU_CAP_VIOMMU)
> +		return caching_mode_enabled();


This part I don't understand. Does it mean Intel IOMMU can't be used in 
VM without caching mode?

Thanks


>   
>   	return false;
>   }
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index 2bfdd5734844..719793e103db 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -931,7 +931,16 @@ static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
>   	return iommu_fwspec_add_ids(dev, args->args, 1);
>   }
>   
> +static bool viommu_capable(enum iommu_cap cap)
> +{
> +	if (cap == IOMMU_CAP_VIOMMU)
> +		return true;
> +
> +	return false;
> +}
> +
>   static struct iommu_ops viommu_ops = {
> +	.capable		= viommu_capable,
>   	.domain_alloc		= viommu_domain_alloc,
>   	.domain_free		= viommu_domain_free,
>   	.attach_dev		= viommu_attach_dev,
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index b95a6f8db6ff..1d24be667a03 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -94,6 +94,7 @@ enum iommu_cap {
>   					   transactions */
>   	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
>   	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
> +	IOMMU_CAP_VIOMMU,		/* IOMMU can declar running in a VM */
>   };
>   
>   /*

