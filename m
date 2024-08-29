Return-Path: <kvm+bounces-25338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D61C09640FF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 12:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91C832829C2
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 10:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E638D18E039;
	Thu, 29 Aug 2024 10:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lur3fVn3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E701155303;
	Thu, 29 Aug 2024 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724926280; cv=none; b=UpRX4en7MSvby/T7CY9XcRysWkHxpY1y2dC4+dRfWIr5zUy6u/c+A8FuopPkLpdUSDPyHSC0kaLZ+hwyMWX2APgkrruyYsPvhb3lYHUd9g64c7VkcPRGN5XgWRLGkyFPpmqqCYd2LQLIBbqOrFPq1j+3eCYi+W4/Y6ICDNrnZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724926280; c=relaxed/simple;
	bh=94IiuIvOyuRU0qMnj7v0g0Xw4A2gYZ1syGqXRZ+CIaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQtmo2eqlId7KGPLHFKaahu5HgHXkFM8XYDdHi1pQe/mLQm8VhBv6bcf9thwCrwDMEBRcz52A8f8Oi5XyE0XmXkc1ncC7/P+8Iqd1BqIuh4zQ4FE1XEwD1zwcwsqr6lUjTsjBURBmyarLU8hJ2Arj/ou/r+kde3/4hTZkzly9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lur3fVn3; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724926279; x=1756462279;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=94IiuIvOyuRU0qMnj7v0g0Xw4A2gYZ1syGqXRZ+CIaU=;
  b=Lur3fVn3K0P+DXtLjRblEZhhvxJ0prfShysdZO6Nn+43ePTKCOm5uYLu
   oXP9aMmgBArS4lGWyMq3cT7b5Me7EpfXZ8k/T467uKgmFQtbyiBZvzDpL
   YTe8U4lidfpX7+KR0QZAGitSuoGct+++35MDesc8ER38BgMQDzieCjPBA
   Ptfw8AogfsapkJZiURO8TEz6xC6O/xtk0eK5yQwhoSsYMyA8HOtDBE4Jv
   GeOAvKz2zRilJ4NJw4NOr2d6nFL/3Unn8wP8oEjRmWWsg1zXGI1EOb8qT
   YgA3Gmrl1QoGuLpoK3RQXt3BcxNkzp05siloz2fVcW8yZ4cGo1cW4ZYzB
   w==;
X-CSE-ConnectionGUID: 3MVVDX6bSCKF/KaUjR7ocQ==
X-CSE-MsgGUID: E/3WAqCQT+mZSZNJwxUpHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="48890783"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="48890783"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 03:11:18 -0700
X-CSE-ConnectionGUID: Ajut8FPHT1+YMFmHPeQN8g==
X-CSE-MsgGUID: uJo872E1Td+a1ZuXluMi9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="63726679"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 29 Aug 2024 03:11:14 -0700
Date: Thu, 29 Aug 2024 18:08:47 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Message-ID: <ZtBIr5IrnZF4z3cp@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-12-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-12-aik@amd.com>

> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 76b7f6085dcd..a4e9db212adc 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -15,6 +15,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
> +#include <linux/tsm.h>
>  #include "vfio.h"
>  
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> @@ -29,8 +30,14 @@ struct kvm_vfio_file {
>  #endif
>  };
>  
> +struct kvm_vfio_tdi {
> +	struct list_head node;
> +	struct vfio_device *vdev;
> +};
> +
>  struct kvm_vfio {
>  	struct list_head file_list;
> +	struct list_head tdi_list;
>  	struct mutex lock;
>  	bool noncoherent;
>  };
> @@ -80,6 +87,22 @@ static bool kvm_vfio_file_is_valid(struct file *file)
>  	return ret;
>  }
>  
> +static struct vfio_device *kvm_vfio_file_device(struct file *file)
> +{
> +	struct vfio_device *(*fn)(struct file *file);
> +	struct vfio_device *ret;
> +
> +	fn = symbol_get(vfio_file_device);
> +	if (!fn)
> +		return NULL;
> +
> +	ret = fn(file);
> +
> +	symbol_put(vfio_file_device);
> +
> +	return ret;
> +}
> +
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
>  static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>  {
> @@ -297,6 +320,103 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
>  	return -ENXIO;
>  }
>  
> +static int kvm_dev_tsm_bind(struct kvm_device *dev, void __user *arg)
> +{
> +	struct kvm_vfio *kv = dev->private;
> +	struct kvm_vfio_tsm_bind tb;
> +	struct kvm_vfio_tdi *ktdi;
> +	struct vfio_device *vdev;
> +	struct fd fdev;
> +	int ret;
> +
> +	if (copy_from_user(&tb, arg, sizeof(tb)))
> +		return -EFAULT;
> +
> +	ktdi = kzalloc(sizeof(*ktdi), GFP_KERNEL_ACCOUNT);
> +	if (!ktdi)
> +		return -ENOMEM;
> +
> +	fdev = fdget(tb.devfd);
> +	if (!fdev.file)
> +		return -EBADF;
> +
> +	ret = -ENOENT;
> +
> +	mutex_lock(&kv->lock);
> +
> +	vdev = kvm_vfio_file_device(fdev.file);
> +	if (vdev) {
> +		ret = kvm_arch_tsm_bind(dev->kvm, vdev->dev, tb.guest_rid);
> +		if (!ret) {
> +			ktdi->vdev = vdev;
> +			list_add_tail(&ktdi->node, &kv->tdi_list);
> +		} else {
> +			vfio_put_device(vdev);
> +		}
> +	}
> +
> +	fdput(fdev);
> +	mutex_unlock(&kv->lock);
> +	if (ret)
> +		kfree(ktdi);
> +
> +	return ret;
> +}
> +
> +static int kvm_dev_tsm_unbind(struct kvm_device *dev, void __user *arg)
> +{
> +	struct kvm_vfio *kv = dev->private;
> +	struct kvm_vfio_tsm_bind tb;
> +	struct kvm_vfio_tdi *ktdi;
> +	struct vfio_device *vdev;
> +	struct fd fdev;
> +	int ret;
> +
> +	if (copy_from_user(&tb, arg, sizeof(tb)))
> +		return -EFAULT;
> +
> +	fdev = fdget(tb.devfd);
> +	if (!fdev.file)
> +		return -EBADF;
> +
> +	ret = -ENOENT;
> +
> +	mutex_lock(&kv->lock);
> +
> +	vdev = kvm_vfio_file_device(fdev.file);
> +	if (vdev) {
> +		list_for_each_entry(ktdi, &kv->tdi_list, node) {
> +			if (ktdi->vdev != vdev)
> +				continue;
> +
> +			kvm_arch_tsm_unbind(dev->kvm, vdev->dev);
> +			list_del(&ktdi->node);
> +			kfree(ktdi);
> +			vfio_put_device(vdev);
> +			ret = 0;
> +			break;
> +		}
> +		vfio_put_device(vdev);
> +	}
> +
> +	fdput(fdev);
> +	mutex_unlock(&kv->lock);
> +	return ret;
> +}
> +
> +static int kvm_vfio_set_device(struct kvm_device *dev, long attr,
> +			       void __user *arg)
> +{
> +	switch (attr) {
> +	case KVM_DEV_VFIO_DEVICE_TDI_BIND:
> +		return kvm_dev_tsm_bind(dev, arg);

I think the TDI bind operation should be under the control of the device
owner (i.e. VFIO driver), rather than in this bridge driver. The TDI bind
means TDI would be transitioned to CONFIG_LOCKED state, and a bunch of
device configurations breaks the state (TDISP spec 11.4.5/8/9). So the
VFIO driver should be fully aware of the TDI bind and manage unwanted
breakage.

Thanks,
Yilun

