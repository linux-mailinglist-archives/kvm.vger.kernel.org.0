Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63642F61EF
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbhANN1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 08:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbhANN1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 08:27:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3668623A58;
        Thu, 14 Jan 2021 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610630790;
        bh=pUHiAeG5B7eg+14rQEcLNRaPP+p/BvCBAhX+WbpqzEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kL+7l6nV0RlFWn8vNRaoNotAHdkSEZNQTh1EFxa2ZZLqXOiOAX4Ji0NuL/7eL3sI1
         RrUcIt8olVZjn10misz9gXVu9x+wjWzv1XEs1+3xrIOFhUnMv6NOHcd4woFkej9cHi
         wi7c9P64wViO1q4AOuubR3XOUDvSP9Ck9vUbnyUm9o59jNS53aGBCttL/Ck2S2/LoC
         QCxgyFkZ4A1/xCrfN6uuejigAsjuTgY0hBtCzXaBTtKbgUE8Mfy1EP5+5G2TsdAqGl
         QQ9b3PJpBkzBDi+VyLBuULL4JiTiDtfC2GoHXkqt77ZrhzNIXbKJ+RYlfsJMq1H1nZ
         JdWjA4IjRRnjw==
Date:   Thu, 14 Jan 2021 15:26:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     tglx@linutronix.de, ashok.raj@intel.com, kevin.tian@intel.com,
        dave.jiang@intel.com, megha.dey@intel.com, dwmw2@infradead.org,
        alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, will@kernel.org, joro@8bytes.org,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v3 1/2] iommu: Add capability IOMMU_CAP_VIOMMU
Message-ID: <20210114132627.GA944463@unreal>
References: <20210114013003.297050-1-baolu.lu@linux.intel.com>
 <20210114013003.297050-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114013003.297050-2-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 09:30:02AM +0800, Lu Baolu wrote:
> Some vendor IOMMU drivers are able to declare that it is running in a VM
> context. This is very valuable for the features that only want to be
> supported on bare metal. Add a capability bit so that it could be used.

And how is it used? Who and how will set it?

>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel/iommu.c  | 20 ++++++++++++++++++++
>  drivers/iommu/virtio-iommu.c |  9 +++++++++
>  include/linux/iommu.h        |  1 +
>  3 files changed, 30 insertions(+)
>
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index cb205a04fe4c..8eb022d0e8aa 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5738,12 +5738,32 @@ static inline bool nested_mode_support(void)
>  	return ret;
>  }
>
> +static inline bool caching_mode_enabled(void)
> +{

Kernel coding style is not in favour of inline functions in *.c files.

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
>  static bool intel_iommu_capable(enum iommu_cap cap)
>  {
>  	if (cap == IOMMU_CAP_CACHE_COHERENCY)
>  		return domain_update_iommu_snooping(NULL) == 1;
>  	if (cap == IOMMU_CAP_INTR_REMAP)
>  		return irq_remapping_enabled == 1;
> +	if (cap == IOMMU_CAP_VIOMMU)
> +		return caching_mode_enabled();
>
>  	return false;
>  }
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index 2bfdd5734844..719793e103db 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -931,7 +931,16 @@ static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
>  	return iommu_fwspec_add_ids(dev, args->args, 1);
>  }
>
> +static bool viommu_capable(enum iommu_cap cap)
> +{
> +	if (cap == IOMMU_CAP_VIOMMU)
> +		return true;
> +
> +	return false;
> +}
> +
>  static struct iommu_ops viommu_ops = {
> +	.capable		= viommu_capable,
>  	.domain_alloc		= viommu_domain_alloc,
>  	.domain_free		= viommu_domain_free,
>  	.attach_dev		= viommu_attach_dev,
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index b95a6f8db6ff..1d24be667a03 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -94,6 +94,7 @@ enum iommu_cap {
>  					   transactions */
>  	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
>  	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
> +	IOMMU_CAP_VIOMMU,		/* IOMMU can declar running in a VM */
>  };
>
>  /*
> --
> 2.25.1
>
