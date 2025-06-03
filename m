Return-Path: <kvm+bounces-48260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EE4ACC035
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 08:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CFDD3A3897
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 06:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1030925D8E8;
	Tue,  3 Jun 2025 06:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U0uoxgea"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39425D522;
	Tue,  3 Jun 2025 06:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748932052; cv=none; b=ojwEwhuZnJG4Vn7vzbKRYQEjBzlxb8S7Qudlw5ajAwG5IdMrivbi3Wozoh+gW1yQH+AhMK9Q8qGmkBbk3lSfAWweJ9xnduZ/KmK0AO6nqvYdSpTnVeScbH9quRy2yW9DGFupLyjv0pQao+UFIvTG/XGeofSDol9qLOx6PGTDQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748932052; c=relaxed/simple;
	bh=IWFtaiDn/XO87fJC+ux27MBKi9oToFneDr8KRC5wsd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRofTm8vcIStCP6A7SUG/x0skL+9tGlYCgiksRhInOda7F7cRg2dXPCBX5+V1/5uhLmjBzHJM9cYfmlFnEWE8D08ZSt9ez1YFpZfXX1d0R79q9XUW+Wls6r6PJgOjlI2gEQ1n+JESHCemCwLxSQ7W6ldY9Z0hp2kaUVcN+3VgBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U0uoxgea; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748932051; x=1780468051;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=IWFtaiDn/XO87fJC+ux27MBKi9oToFneDr8KRC5wsd4=;
  b=U0uoxgeawyvclHb5hdYsWIOOoeDl3TmeUIODdYphdGDX0SSeGvKYbBYb
   iRBBsqsB7TgPFFOFiQ+o/e2hkw6dXDOZRRCaFQSB0KT3SR+bFovjsNl5Z
   htllbiJis8vmcHHiZ5UvxgzaHuvFBtXJQGBTByXj32aw1RIiVPZp6nJAb
   Hdxi2DXdDonz5owd04UFS0H6n7XFFlorvs/PsMfd/Yi4QTu7KXtVojEje
   IyF0FEpE57yGR6n1A6W7yizvRV8H6fDRrBwiHUGSWz6/xT/18b14iWlJf
   dm+j/eACdH511C6NS1g1R6Bi+iGS4MbkMhd7nrAm9rxom4g6/dHD5oGPa
   w==;
X-CSE-ConnectionGUID: RFnmvnBqS0qc7Hr1FFNIsw==
X-CSE-MsgGUID: RxgOwsoAQkiYQ9Xp/S241Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="62314591"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="62314591"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 23:27:29 -0700
X-CSE-ConnectionGUID: BBpJLW0fTIe4Bl5L9UVquA==
X-CSE-MsgGUID: NtyakwF0TsCvZXIGBKTDHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="149539306"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa003.jf.intel.com with ESMTP; 02 Jun 2025 23:27:23 -0700
Date: Tue, 3 Jun 2025 14:20:51 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com, yilun.xu@intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 17/30] iommufd/device: Add TSM Bind/Unbind for TIO
 support
Message-ID: <aD6UQy4KwKcdSvVE@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-18-yilun.xu@linux.intel.com>
 <yq5awm9ujouz.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5awm9ujouz.fsf@kernel.org>

On Mon, Jun 02, 2025 at 06:13:16PM +0530, Aneesh Kumar K.V wrote:
> Xu Yilun <yilun.xu@linux.intel.com> writes:
> 
> ....
> 
> > +/**
> > + * iommufd_device_tsm_bind - Move a device to TSM Bind state
> > + * @idev: device to attach
> > + * @vdev_id: Input a IOMMUFD_OBJ_VDEVICE
> > + *
> > + * This configures for device Confidential Computing(CC), and moves the device
> > + * to the TSM Bind state. Once this completes the device is locked down (TDISP
> > + * CONFIG_LOCKED or RUN), waiting for guest's attestation.
> > + *
> > + * This function is undone by calling iommufd_device_tsm_unbind().
> > + */
> > +int iommufd_device_tsm_bind(struct iommufd_device *idev, u32 vdevice_id)
> > +{
> > +	struct iommufd_vdevice *vdev;
> > +	int rc;
> > +
> > +	if (!dev_is_pci(idev->dev))
> > +		return -ENODEV;
> > +
> > +	vdev = container_of(iommufd_get_object(idev->ictx, vdevice_id, IOMMUFD_OBJ_VDEVICE),
> > +			    struct iommufd_vdevice, obj);
> > +	if (IS_ERR(vdev))
> > +		return PTR_ERR(vdev);
> > +
> > +	if (vdev->dev != idev->dev) {
> > +		rc = -EINVAL;
> > +		goto out_put_vdev;
> > +	}
> > +
> > +	mutex_lock(&idev->igroup->lock);
> > +	if (idev->vdev) {
> > +		rc = -EEXIST;
> > +		goto out_unlock;
> > +	}
> > +
> > +	rc = iommufd_vdevice_tsm_bind(vdev);
> > +	if (rc)
> > +		goto out_unlock;
> > +
> > +	idev->vdev = vdev;
> > +	refcount_inc(&vdev->obj.users);
> > +	mutex_unlock(&idev->igroup->lock);
> > +
> > +	/*
> > +	 * Pairs with iommufd_device_tsm_unbind() - catches caller bugs attempting
> > +	 * to destroy a bound device.
> > +	 */
> > +	refcount_inc(&idev->obj.users);
> >
> 
> Do we really need this refcount_inc? As I understand it, the objects

The idev refcount is not necessary, it is just to "catch caller bug".

> aren't being pinned directly. Instead, the reference count seems to be
> used more as a way to establish an object hierarchy, ensuring that
> objects are freed in the correct order.
> 
> In vfio_pci_core_close_device(), you’re decrementing the reference, and
> on the iommufd side, we’re covered because the VFIO bind operation takes
> a file reference (fget)—so iommufd_fops_release() won’t be called
> prematurely.

Correct.

> 
> Wouldn’t it be simpler to skip the reference count increment altogether
> and just call tsm_unbind in the virtual device’s destroy callback?
> (iommufd_vdevice_destroy())

The vdevice refcount is the main concern, there is also an IOMMU_DESTROY
ioctl. User could just free the vdevice instance if no refcount, while VFIO
is still in bound state. That seems not the correct free order.

Thanks,
Yilun

> 
> > +	goto out_put_vdev;
> > +
> > +out_unlock:
> > +	mutex_unlock(&idev->igroup->lock);
> > +out_put_vdev:
> > +	iommufd_put_object(idev->ictx, &vdev->obj);
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_device_tsm_bind, "IOMMUFD");
> 
> -aneesh

