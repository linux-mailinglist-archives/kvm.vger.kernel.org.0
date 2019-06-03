Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F289A33B67
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 00:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfFCWcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 18:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfFCWci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 18:32:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 495A5C05D3F4;
        Mon,  3 Jun 2019 22:32:38 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3928964027;
        Mon,  3 Jun 2019 22:32:37 +0000 (UTC)
Date:   Mon, 3 Jun 2019 16:32:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        jean-philippe.brucker@arm.com, will.deacon@arm.com,
        robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com,
        marc.zyngier@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com
Subject: Re: [PATCH v8 24/29] vfio: VFIO_IOMMU_BIND/UNBIND_MSI
Message-ID: <20190603163227.4d00476a@x1.home>
In-Reply-To: <20190526161004.25232-25-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-25-eric.auger@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 03 Jun 2019 22:32:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 May 2019 18:09:59 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> This patch adds the VFIO_IOMMU_BIND/UNBIND_MSI ioctl which aim
> to pass/withdraw the guest MSI binding to/from the host.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v6 -> v7:
> - removed the dev arg
> 
> v3 -> v4:
> - add UNBIND
> - unwind on BIND error
> 
> v2 -> v3:
> - adapt to new proto of bind_guest_msi
> - directly use vfio_iommu_for_each_dev
> 
> v1 -> v2:
> - s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
> ---
>  drivers/vfio/vfio_iommu_type1.c | 64 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       | 29 +++++++++++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6fda4fbc9bfa..18142cb078a3 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1832,6 +1832,42 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
>  	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
>  }
>  
> +static int
> +vfio_bind_msi(struct vfio_iommu *iommu,
> +	      dma_addr_t giova, phys_addr_t gpa, size_t size)
> +{
> +	struct vfio_domain *d;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		ret = iommu_bind_guest_msi(d->domain, giova, gpa, size);
> +		if (ret)
> +			goto unwind;
> +	}
> +	goto unlock;
> +unwind:
> +	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
> +		iommu_unbind_guest_msi(d->domain, giova);
> +	}
> +unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static void
> +vfio_unbind_msi(struct vfio_iommu *iommu, dma_addr_t giova)
> +{
> +	struct vfio_domain *d;
> +
> +	mutex_lock(&iommu->lock);
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		iommu_unbind_guest_msi(d->domain, giova);
> +	}
> +	mutex_unlock(&iommu->lock);
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -1936,6 +1972,34 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  					    &ustruct);
>  		mutex_unlock(&iommu->lock);
>  		return ret;
> +	} else if (cmd == VFIO_IOMMU_BIND_MSI) {
> +		struct vfio_iommu_type1_bind_msi ustruct;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_bind_msi,
> +				    size);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz || ustruct.flags)
> +			return -EINVAL;
> +
> +		return vfio_bind_msi(iommu, ustruct.iova, ustruct.gpa,
> +				     ustruct.size);
> +	} else if (cmd == VFIO_IOMMU_UNBIND_MSI) {
> +		struct vfio_iommu_type1_unbind_msi ustruct;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_unbind_msi,
> +				    iova);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz || ustruct.flags)
> +			return -EINVAL;
> +
> +		vfio_unbind_msi(iommu, ustruct.iova);
> +		return 0;
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 055aa9b9745a..2774a1ab37ae 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -798,6 +798,35 @@ struct vfio_iommu_type1_cache_invalidate {
>  };
>  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
>  
> +/**
> + * VFIO_IOMMU_BIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 25,
> + *			struct vfio_iommu_type1_bind_msi)
> + *
> + * Pass a stage 1 MSI doorbell mapping to the host so that this
> + * latter can build a nested stage2 mapping
> + */
> +struct vfio_iommu_type1_bind_msi {
> +	__u32   argsz;
> +	__u32   flags;
> +	__u64	iova;
> +	__u64	gpa;
> +	__u64	size;
> +};
> +#define VFIO_IOMMU_BIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 25)
> +
> +/**
> + * VFIO_IOMMU_UNBIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 26,
> + *			struct vfio_iommu_type1_unbind_msi)
> + *
> + * Unregister an MSI mapping
> + */
> +struct vfio_iommu_type1_unbind_msi {
> +	__u32   argsz;
> +	__u32   flags;
> +	__u64	iova;
> +};
> +#define VFIO_IOMMU_UNBIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 26)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

And another pair of ioctls.  Maybe think about how we can reduce the
ioctl bloat of this series.  I don't want to impose an awkward
interface for the sake of fewer ioctls, but I also don't want us
casually burning through ioctls.
