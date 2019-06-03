Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F046133B65
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 00:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFCWcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 18:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfFCWcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 18:32:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3321B81E00;
        Mon,  3 Jun 2019 22:32:31 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 237BD6090E;
        Mon,  3 Jun 2019 22:32:25 +0000 (UTC)
Date:   Mon, 3 Jun 2019 16:32:25 -0600
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
Subject: Re: [PATCH v8 22/29] vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE
Message-ID: <20190603163225.0d227810@x1.home>
In-Reply-To: <20190526161004.25232-23-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-23-eric.auger@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 03 Jun 2019 22:32:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 May 2019 18:09:57 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> From: "Liu, Yi L" <yi.l.liu@linux.intel.com>
> 
> This patch adds VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE ioctl
> which aims to pass/withdraw the virtual iommu guest configuration
> to/from the VFIO driver downto to the iommu subsystem.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v6 -> v7:
> - add a comment related to VFIO_IOMMU_DETACH_PASID_TABLE
> 
> v3 -> v4:
> - restore ATTACH/DETACH
> - add unwind on failure
> 
> v2 -> v3:
> - s/BIND_PASID_TABLE/SET_PASID_TABLE
> 
> v1 -> v2:
> - s/BIND_GUEST_STAGE/BIND_PASID_TABLE
> - remove the struct device arg
> ---
>  drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       | 22 ++++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 3ddc375e7063..b2d609d6fe83 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1758,6 +1758,43 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
>  	return ret;
>  }
>  
> +static void
> +vfio_detach_pasid_table(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *d;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		iommu_detach_pasid_table(d->domain);
> +	}
> +	mutex_unlock(&iommu->lock);
> +}
> +
> +static int
> +vfio_attach_pasid_table(struct vfio_iommu *iommu,
> +			struct vfio_iommu_type1_attach_pasid_table *ustruct)
> +{
> +	struct vfio_domain *d;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		ret = iommu_attach_pasid_table(d->domain, &ustruct->config);
> +		if (ret)
> +			goto unwind;
> +	}
> +	goto unlock;
> +unwind:
> +	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
> +		iommu_detach_pasid_table(d->domain);
> +	}
> +unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -1828,6 +1865,22 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +	} else if (cmd == VFIO_IOMMU_ATTACH_PASID_TABLE) {
> +		struct vfio_iommu_type1_attach_pasid_table ustruct;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_attach_pasid_table,
> +				    config);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz || ustruct.flags)
> +			return -EINVAL;
> +
> +		return vfio_attach_pasid_table(iommu, &ustruct);
> +	} else if (cmd == VFIO_IOMMU_DETACH_PASID_TABLE) {
> +		vfio_detach_pasid_table(iommu);
> +		return 0;
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 8f10748dac79..4316dd8cb5b5 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -14,6 +14,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> +#include <linux/iommu.h>
>  
>  #define VFIO_API_VERSION	0
>  
> @@ -763,6 +764,27 @@ struct vfio_iommu_type1_dma_unmap {
>  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
> +/**
> + * VFIO_IOMMU_ATTACH_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
> + *			struct vfio_iommu_type1_attach_pasid_table)
> + *
> + * Passes the PASID table to the host. Calling ATTACH_PASID_TABLE
> + * while a table is already installed is allowed: it replaces the old
> + * table. DETACH does a comprehensive tear down of the nested mode.
> + */
> +struct vfio_iommu_type1_attach_pasid_table {
> +	__u32	argsz;
> +	__u32	flags;
> +	struct iommu_pasid_table_config config;
> +};
> +#define VFIO_IOMMU_ATTACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 22)
> +
> +/**
> + * VFIO_IOMMU_DETACH_PASID_TABLE - - _IOWR(VFIO_TYPE, VFIO_BASE + 23)
> + * Detaches the PASID table
> + */
> +#define VFIO_IOMMU_DETACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 23)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

I'm tempted to suggest a "SET" rather than ATTACH/DETACH interface so
this could be done in one ioctl and make use of the flags provided.
