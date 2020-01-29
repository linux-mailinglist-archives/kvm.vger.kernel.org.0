Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA514D425
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgA2X4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:56:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34768 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726750AbgA2X4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:56:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580342205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/FlUx/0EoEDOcXXUzpcXpnQOxR5qtEH6XDuKSHdNwAQ=;
        b=TfuynleXNs2ck5VXo9w6ZatE0dXFOAF/eNbqFuDYGC+OCsFPKUqjKattABi+ZTeauofMCT
        TiIvHp4MH1Sg41MTdgLNCWwaYQG+0sJFhYphj2OsJ3dBBfOO9vqfAQpMnqSPthu5o6ki51
        9XTYXDvkbo9m40g7HmAisFoY85PSLXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-Bc17NHRPPPGl2sn0Hbfd7g-1; Wed, 29 Jan 2020 18:56:42 -0500
X-MC-Unique: Bc17NHRPPPGl2sn0Hbfd7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDD621800D41;
        Wed, 29 Jan 2020 23:56:40 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 777451001B05;
        Wed, 29 Jan 2020 23:56:32 +0000 (UTC)
Date:   Wed, 29 Jan 2020 16:56:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, joro@8bytes.org,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 2/8] vfio/type1: Make per-application (VM) PASID quota
 tunable
Message-ID: <20200129165632.5f69b949@w520.home>
In-Reply-To: <1580299912-86084-3-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-3-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

If we give an unprivileged user the ability to increase their quota,
why do we even have a quota at all?  I figured we were going to have a
module option tunable so its under the control of the system admin.
Thanks,

Alex

> 
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
>  drivers/vfio/vfio_iommu_type1.c | 33 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       | 22 ++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index e836d04..1cf75f5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2243,6 +2243,27 @@ static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
>  	return ret;
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
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2389,6 +2410,18 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		default:
>  			return -EINVAL;
>  		}
> +	} else if (cmd == VFIO_IOMMU_SET_PASID_QUOTA) {
> +		struct vfio_iommu_type1_pasid_quota quota;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_pasid_quota,
> +				    quota);
> +
> +		if (copy_from_user(&quota, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (quota.argsz < minsz)
> +			return -EINVAL;
> +		return vfio_iommu_type1_set_pasid_quota(iommu, quota.quota);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 298ac80..d4bf415 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -835,6 +835,28 @@ struct vfio_iommu_type1_pasid_request {
>   */
>  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 22)
>  
> +/**
> + * @quota: the new pasid quota which a userspace application (e.g. VM)
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
> + *				struct vfio_iommu_type1_pasid_quota)
> + *
> + * Availability of this feature depends on PASID support in the device,
> + * its bus, the underlying IOMMU and the CPU architecture. In VFIO, it
> + * is available after VFIO_SET_IOMMU.
> + *
> + * returns: latest quota on success, -errno on failure.
> + */
> +#define VFIO_IOMMU_SET_PASID_QUOTA	_IO(VFIO_TYPE, VFIO_BASE + 23)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

