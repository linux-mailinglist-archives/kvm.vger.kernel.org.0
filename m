Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BB0155EA4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 20:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgBGTi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 14:38:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:64008 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgBGTi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 14:38:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 11:38:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="236456658"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 07 Feb 2020 11:38:26 -0800
Date:   Fri, 7 Feb 2020 11:43:45 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        kevin.tian@intel.com, joro@8bytes.org, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com
Subject: Re: [RFC v3 2/8] vfio/type1: Make per-application (VM) PASID quota
 tunable
Message-ID: <20200207114345.2071a482@jacob-builder>
In-Reply-To: <1580299912-86084-3-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-3-git-send-email-yi.l.liu@intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jan 2020 04:11:46 -0800
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> From: Liu Yi L <yi.l.liu@intel.com>
> 
> The PASID quota is per-application (VM) according to vfio's PASID
> management rule. For better flexibility, quota shall be user tunable
> . This patch provides a VFIO based user interface for which quota can
> be adjusted. However, quota cannot be adjusted downward below the
> number of outstanding PASIDs.
> 
> This patch only makes the per-VM PASID quota tunable. While for the
> way to tune the default PASID quota, it may require a new vfio module
> option or other way. This may be another patchset in future.
> 
One issue we need to solve is how to share PASIDs at the system
level, e.g. Both VMs and baremetal drivers could use PASIDs.

This patch is granting quota to a guest w/o knowing the remaining
system capacity. So guest PASID allocation could fail even within its
quota.

The solution I am thinking is to enforce quota at IOASID common
code, since IOASID APIs already used to manage system-wide allocation.
How about the following changes to IOASID?
1. introduce quota in ioasid_set (could have a soft limit for better
sharing)

2. introduce an API to create a set with quota before allocation, e.g.
ioasid_set_id = ioasid_alloc_set(size, token)
set_id will be used for ioasid_alloc() instead of token.

3. introduce API to adjust set quota ioasid_adjust_set_size(set_id,
size)

4. API to check remaining PASIDs ioasid_get_capacity(set_id); //return
system capacity if set_id == 0;

5. API to set system capacity, ioasid_set_capacity(nr_pasids), e.g. if
system has 20 bit PASIDs, IOMMU driver needs to call
ioasid_set_capacity(1<<20) during boot.

6. Optional set level APIs. e.g. ioasid_free_set(set_id), frees all
IOASIDs in the set.

With these APIs, this patch could query PASID capacity at both system
and set level and adjust quota within range. i.e.
1. IOMMU vendor driver(or other driver to use PASID w/o IOMMU) sets
system wide capacity during boot.
2. VFIO Call ioasid_alloc_set() when allocating vfio_mm(), set default
quota
3. Adjust quota per set with ioasid_adjust_set_size() as the tunable in
this patch.

Thoughts?

> Previous discussions:
> https://patchwork.kernel.org/patch/11209429/
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 33
> +++++++++++++++++++++++++++++++++ include/uapi/linux/vfio.h       |
> 22 ++++++++++++++++++++++ 2 files changed, 55 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c index e836d04..1cf75f5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2243,6 +2243,27 @@ static int vfio_iommu_type1_pasid_free(struct
> vfio_iommu *iommu, return ret;
>  }
>  
> +static int vfio_iommu_type1_set_pasid_quota(struct vfio_iommu *iommu,
> +					    u32 quota)
> +{
> +	struct vfio_mm *vmm = iommu->vmm;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	mutex_lock(&vmm->pasid_lock);
> +	if (vmm->pasid_count > quota) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	vmm->pasid_quota = quota;
> +	ret = quota;
> +
> +out_unlock:
> +	mutex_unlock(&vmm->pasid_lock);
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long
> arg) {
> @@ -2389,6 +2410,18 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data, default:
>  			return -EINVAL;
>  		}
> +	} else if (cmd == VFIO_IOMMU_SET_PASID_QUOTA) {
> +		struct vfio_iommu_type1_pasid_quota quota;
> +
> +		minsz = offsetofend(struct
> vfio_iommu_type1_pasid_quota,
> +				    quota);
> +
> +		if (copy_from_user(&quota, (void __user *)arg,
> minsz))
> +			return -EFAULT;
> +
> +		if (quota.argsz < minsz)
> +			return -EINVAL;
> +		return vfio_iommu_type1_set_pasid_quota(iommu,
> quota.quota); }
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 298ac80..d4bf415 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -835,6 +835,28 @@ struct vfio_iommu_type1_pasid_request {
>   */
>  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE +
> 22) 
> +/**
> + * @quota: the new pasid quota which a userspace application (e.g.
> VM)
> + * is configured.
> + */
> +struct vfio_iommu_type1_pasid_quota {
> +	__u32	argsz;
> +	__u32	flags;
> +	__u32	quota;
> +};
> +
> +/**
> + * VFIO_IOMMU_SET_PASID_QUOTA - _IOW(VFIO_TYPE, VFIO_BASE + 23,
> + *				struct
> vfio_iommu_type1_pasid_quota)
> + *
> + * Availability of this feature depends on PASID support in the
> device,
> + * its bus, the underlying IOMMU and the CPU architecture. In VFIO,
> it
> + * is available after VFIO_SET_IOMMU.
> + *
> + * returns: latest quota on success, -errno on failure.
> + */
> +#define VFIO_IOMMU_SET_PASID_QUOTA	_IO(VFIO_TYPE, VFIO_BASE +
> 23) +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU
> -------- */ 
>  /*

[Jacob Pan]
