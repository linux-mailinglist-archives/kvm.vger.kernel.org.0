Return-Path: <kvm+bounces-25463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7634496580C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF994B22BF7
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810221581E2;
	Fri, 30 Aug 2024 07:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hWPYb+WA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C861531D0;
	Fri, 30 Aug 2024 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725001523; cv=none; b=ekYou9y82dupQTBvhNvj69S5mDfwjxUWDA/XEQUWHRcVpDCjDleoOl/J4P+zFpY1mV2FK7nKLwbZZ7ZnGrPgDUfIh0mpnXMX3mmg+d3CUBcXq6GY/rVMRyjBnw4BKdQGQI1l4EEEcDWmPeFEs3BVhhUQFLCj/LfYFa0JzYxQ+r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725001523; c=relaxed/simple;
	bh=fs7dwCcIGstjP+8EDLC7kaBlHBE+/dzsUlL4+b4g1A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJW7VPk7qtCUmU54qD/1FGuNZfzJBcUP9qBefEaYlD7KWNy9Qr/h5Y21GoC/TBPl+ppIWT8G1JXdnFV7wWJDDOdX9UXk+bwRTYlUevBxhMqafIeTBngqEHaPA29ARCJPZC4Im5uVAixV+t3XIS8yZUHr2DAfw0ZRNZp40fiPqw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hWPYb+WA; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725001522; x=1756537522;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fs7dwCcIGstjP+8EDLC7kaBlHBE+/dzsUlL4+b4g1A8=;
  b=hWPYb+WAalEHSUYhF5wkvpvUUIY0QRtPmbCgh1IYQ/rVmxfn6K0Vo9J7
   lvQZwRKi7Ju0lzhccIHyi99N5l/7YCa348cL6mkVSyAdpRjiYvSrtmn0Q
   sua2BloyMmcrVymQRkk7FmkUBn7ZE+F9Gxk3D+Hh/sksS35eBOrv4HNvI
   eJELDdXHMzcEwL+jVweVwSI27WUNnkSP0blPy+maQOm3zmQUatnUvnwOe
   oc3pR1+oploRew5JLVEDxCXhW1k2iVCd18xdA/Wt+HF0KfGti1P9PEx9z
   0ipjJ70ewFrg2GzFupB8GFuuwfesZ/VUSJh3v9idNpWgOPafMfxr3+lD7
   A==;
X-CSE-ConnectionGUID: 3Sj8UGVhRe2KnSUcahwSMw==
X-CSE-MsgGUID: p6i2J6y1QNK47vb8z6aG3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23495459"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23495459"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:05:22 -0700
X-CSE-ConnectionGUID: gWAF0oB3R/iao1boJz3F7Q==
X-CSE-MsgGUID: mb7SY/8sSaSNPXvLqiy6oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="68708882"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 30 Aug 2024 00:05:17 -0700
Date: Fri, 30 Aug 2024 15:02:49 +0800
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
Message-ID: <ZtFumVbgXf9RBNxP@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-12-aik@amd.com>
 <ZtBIr5IrnZF4z3cp@yilunxu-OptiPlex-7050>
 <db05ceb5-d38b-45b8-81c9-c84c0d8fbd96@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db05ceb5-d38b-45b8-81c9-c84c0d8fbd96@amd.com>

On Fri, Aug 30, 2024 at 02:00:30PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 29/8/24 20:08, Xu Yilun wrote:
> > > diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> > > index 76b7f6085dcd..a4e9db212adc 100644
> > > --- a/virt/kvm/vfio.c
> > > +++ b/virt/kvm/vfio.c
> > > @@ -15,6 +15,7 @@
> > >   #include <linux/slab.h>
> > >   #include <linux/uaccess.h>
> > >   #include <linux/vfio.h>
> > > +#include <linux/tsm.h>
> > >   #include "vfio.h"
> > >   #ifdef CONFIG_SPAPR_TCE_IOMMU
> > > @@ -29,8 +30,14 @@ struct kvm_vfio_file {
> > >   #endif
> > >   };
> > > +struct kvm_vfio_tdi {
> > > +	struct list_head node;
> > > +	struct vfio_device *vdev;
> > > +};
> > > +
> > >   struct kvm_vfio {
> > >   	struct list_head file_list;
> > > +	struct list_head tdi_list;
> > >   	struct mutex lock;
> > >   	bool noncoherent;
> > >   };
> > > @@ -80,6 +87,22 @@ static bool kvm_vfio_file_is_valid(struct file *file)
> > >   	return ret;
> > >   }
> > > +static struct vfio_device *kvm_vfio_file_device(struct file *file)
> > > +{
> > > +	struct vfio_device *(*fn)(struct file *file);
> > > +	struct vfio_device *ret;
> > > +
> > > +	fn = symbol_get(vfio_file_device);
> > > +	if (!fn)
> > > +		return NULL;
> > > +
> > > +	ret = fn(file);
> > > +
> > > +	symbol_put(vfio_file_device);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >   #ifdef CONFIG_SPAPR_TCE_IOMMU
> > >   static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
> > >   {
> > > @@ -297,6 +320,103 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
> > >   	return -ENXIO;
> > >   }
> > > +static int kvm_dev_tsm_bind(struct kvm_device *dev, void __user *arg)
> > > +{
> > > +	struct kvm_vfio *kv = dev->private;
> > > +	struct kvm_vfio_tsm_bind tb;
> > > +	struct kvm_vfio_tdi *ktdi;
> > > +	struct vfio_device *vdev;
> > > +	struct fd fdev;
> > > +	int ret;
> > > +
> > > +	if (copy_from_user(&tb, arg, sizeof(tb)))
> > > +		return -EFAULT;
> > > +
> > > +	ktdi = kzalloc(sizeof(*ktdi), GFP_KERNEL_ACCOUNT);
> > > +	if (!ktdi)
> > > +		return -ENOMEM;
> > > +
> > > +	fdev = fdget(tb.devfd);
> > > +	if (!fdev.file)
> > > +		return -EBADF;
> > > +
> > > +	ret = -ENOENT;
> > > +
> > > +	mutex_lock(&kv->lock);
> > > +
> > > +	vdev = kvm_vfio_file_device(fdev.file);
> > > +	if (vdev) {
> > > +		ret = kvm_arch_tsm_bind(dev->kvm, vdev->dev, tb.guest_rid);
> > > +		if (!ret) {
> > > +			ktdi->vdev = vdev;
> > > +			list_add_tail(&ktdi->node, &kv->tdi_list);
> > > +		} else {
> > > +			vfio_put_device(vdev);
> > > +		}
> > > +	}
> > > +
> > > +	fdput(fdev);
> > > +	mutex_unlock(&kv->lock);
> > > +	if (ret)
> > > +		kfree(ktdi);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int kvm_dev_tsm_unbind(struct kvm_device *dev, void __user *arg)
> > > +{
> > > +	struct kvm_vfio *kv = dev->private;
> > > +	struct kvm_vfio_tsm_bind tb;
> > > +	struct kvm_vfio_tdi *ktdi;
> > > +	struct vfio_device *vdev;
> > > +	struct fd fdev;
> > > +	int ret;
> > > +
> > > +	if (copy_from_user(&tb, arg, sizeof(tb)))
> > > +		return -EFAULT;
> > > +
> > > +	fdev = fdget(tb.devfd);
> > > +	if (!fdev.file)
> > > +		return -EBADF;
> > > +
> > > +	ret = -ENOENT;
> > > +
> > > +	mutex_lock(&kv->lock);
> > > +
> > > +	vdev = kvm_vfio_file_device(fdev.file);
> > > +	if (vdev) {
> > > +		list_for_each_entry(ktdi, &kv->tdi_list, node) {
> > > +			if (ktdi->vdev != vdev)
> > > +				continue;
> > > +
> > > +			kvm_arch_tsm_unbind(dev->kvm, vdev->dev);
> > > +			list_del(&ktdi->node);
> > > +			kfree(ktdi);
> > > +			vfio_put_device(vdev);
> > > +			ret = 0;
> > > +			break;
> > > +		}
> > > +		vfio_put_device(vdev);
> > > +	}
> > > +
> > > +	fdput(fdev);
> > > +	mutex_unlock(&kv->lock);
> > > +	return ret;
> > > +}
> > > +
> > > +static int kvm_vfio_set_device(struct kvm_device *dev, long attr,
> > > +			       void __user *arg)
> > > +{
> > > +	switch (attr) {
> > > +	case KVM_DEV_VFIO_DEVICE_TDI_BIND:
> > > +		return kvm_dev_tsm_bind(dev, arg);
> > 
> > I think the TDI bind operation should be under the control of the device
> > owner (i.e. VFIO driver), rather than in this bridge driver.
> 
> This is a valid point, although this means teaching VFIO about the KVM
> lifetime (and KVM already holds references to VFIO groups) and

Not sure if I understand, VFIO already knows KVM lifetime via
vfio_device_get_kvm_safe(), is it?

> guest BDFns (which have no meaning for VFIO in the host kernel).

KVM is not aware of the guest BDF today.

I think we need to pass a firmware recognizable TDI identifier, which
is actually a magic number and specific to vendors. For TDX, it is the
FUNCTION_ID. So I didn't think too much to whom the identifier is
meaningful.

> 
> > The TDI bind
> > means TDI would be transitioned to CONFIG_LOCKED state, and a bunch of
> > device configurations breaks the state (TDISP spec 11.4.5/8/9). So the
> > VFIO driver should be fully aware of the TDI bind and manage unwanted
> > breakage.
> 
> VFIO has no control over TDI any way, cannot even know what state it is in
> without talking to the firmware.

I think VFIO could talk to the firmware, that's part of the reason we are
working on the TSM module independent to KVM.

> When TDI goes into ERROR, this needs to be
> propagated to the VM. At the moment (afaik) it does not tell the

I assume when TDISP ERROR happens, an interrupt (e.g. AER) would be sent
to OS and VFIO driver is the one who handles it in the first place. So
maybe there has to be some TDI stuff in VFIO?

Thanks,
Yilun

> userspace/guest about IOMMU errors and it probably should but the existing
> mechanism should be able to do so. Thanks,
> 
> 
> > 
> > Thanks,
> > Yilun
> 
> -- 
> Alexey
> 

