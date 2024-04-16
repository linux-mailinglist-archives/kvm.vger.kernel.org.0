Return-Path: <kvm+bounces-14815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D0F8A72B6
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 743EB1F2114D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB63913440C;
	Tue, 16 Apr 2024 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPLsoXoM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA212EBCE
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713290251; cv=none; b=Q+WWYp6f4gUr8mOEwLbodcHYIdbg0u5Q/blP5ZlJIbFPpWK4eK3nCYnOUdghxp/0O5XfO0qNA8o9qEV7Lm5LJOH/6NdggR9gDQELyyjWBLSOYzHL6AO9uU8MAx/MWBFcUqIolVNIAFAbSuF3XuBb96hss8UTB2RFXpdWM4dbEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713290251; c=relaxed/simple;
	bh=xExRpy8wXynFCJbYy6xypyJfQ2V5WASMyCaCDSKAMyw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+c4YYayda+PuaV7NMDoYxFWe11S4Fz0aeJ5B6V7F2Z4hRix4ULiTRdbW7jyg7wbIFar3N5hBOQKchVNyFvQOqVEM++JeZqTNKoQomTEnLYd8gaRTphZ2IRC7Du74HY2sjTX/QOL38/irauXuLfrvVKaLvj4hSVi3+LuvHTwUDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPLsoXoM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713290248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mu2etZt/hXOiQ3aQe8PNUaAel6IFW0QLmXxEDQFkoRY=;
	b=jPLsoXoMX3ruEpuQ7ZuGMFdJga0csKbjT1DFJBoT+m+8juCQYSyWMyfbltIa6t2tYCYxSg
	rtB6r8u54CBOy+PZHw5HmQ9krDFtheAyjhmfCdpAaPMvQ+44LrZDgT1ENAUPJnkVP/H2ny
	gv8R4a0JYPa+beiNbfp/fjco/NKALNE=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-LSTDnX_WOyenHTSzuO9zFg-1; Tue, 16 Apr 2024 13:57:26 -0400
X-MC-Unique: LSTDnX_WOyenHTSzuO9zFg-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6ea9a4ec443so3721668a34.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 10:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713290246; x=1713895046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mu2etZt/hXOiQ3aQe8PNUaAel6IFW0QLmXxEDQFkoRY=;
        b=IPdRWYlBvOfmz1mMkvllqDab02Cnb7OM4CGlS1z50Oh/quEmtVYGf9mrUL9aHJUJpe
         /J8cr9PldxVGeqot3ieZy9jI9QMRA/CV2cYnnf3ITt1/9lkhni5w7tT695M1S8QSsGbo
         Yi9PNsvXJbbwpzBW8owLxV+8Tz/S40LRETTjBPfkN84Pz5jbb79qWfhPt7sfsSYw5c7N
         MnAC4De8oNvyt/e5ksGXSvQo8ta9/fcgWkrzl5iGx8CPDLPUmH6xB/ObJF1wxZB3RZdK
         7OZ/6Tg0Of9nJjXYiIj2fKFQeplQESy+ZFJM6YWLMlOZtTBi7jF1gbeIO4K8fAkJaMc4
         kNCw==
X-Forwarded-Encrypted: i=1; AJvYcCXV4WkwmIq4SjvjxJ721/BhAewvHo2bpmnx7IoTGkzm6FtB0clcO575/SC4m3f8AJhm0fKQSA+eKwMj5eurGds47LG4
X-Gm-Message-State: AOJu0YyRlVGOzzyz2muaJaXQmr/+upzVkaSAJCPwHIWOv7WoI/b2odUe
	R2w/6oVN6JtixAPEFymthDtOXCmsFZuYI594US1WmY1G1PmDZ7cV40B8BBzpC8zeokMt5SxkO3i
	KdS0X+Z9YQxJUijKc8IBlSyShgm0be9RKO8ttGV/BQnKRHFEG5Q==
X-Received: by 2002:a05:6830:1114:b0:6ea:1849:e5c1 with SMTP id w20-20020a056830111400b006ea1849e5c1mr1321881otq.4.1713290245876;
        Tue, 16 Apr 2024 10:57:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsSk/jqSr2cDIr7T3FTPUv7PdsMyxNDWd8b4/STa4VRgh/ghgt1p9s6oeHLRR/ZlUXeSMUwQ==
X-Received: by 2002:a05:6830:1114:b0:6ea:1849:e5c1 with SMTP id w20-20020a056830111400b006ea1849e5c1mr1321872otq.4.1713290245552;
        Tue, 16 Apr 2024 10:57:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id j13-20020a9d768d000000b006eb85b34e48sm585924otl.54.2024.04.16.10.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 10:57:25 -0700 (PDT)
Date: Tue, 16 Apr 2024 11:57:22 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
 robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 baolu.lu@linux.intel.com, zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20240416115722.78d4509f.alex.williamson@redhat.com>
In-Reply-To: <20240412082121.33382-5-yi.l.liu@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<20240412082121.33382-5-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Apr 2024 01:21:21 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> Today, vfio-pci hides the PASID capability of devices from userspace. Unlike
> other PCI capabilities, PASID capability is going to be reported to user by
> VFIO_DEVICE_FEATURE. Hence userspace could probe PASID capability by it.
> This is a bit different from the other capabilities which are reported to
> userspace when the user reads the device's PCI configuration space. There
> are two reasons for this.
> 
>  - First, userspace like Qemu by default exposes all the available PCI
>    capabilities in vfio-pci config space to the guest as read-only, so
>    adding PASID capability in the vfio-pci config space will make it
>    exposed to the guest automatically while an old Qemu doesn't really
>    support it.
> 
>  - Second, the PASID capability does not exist on VFs (instead shares the
>    cap of the PF). Creating a virtual PASID capability in vfio-pci config
>    space needs to find a hole to place it, but doing so may require device
>    specific knowledge to avoid potential conflict with device specific
>    registers like hidden bits in VF's config space. It's simpler to move
>    this burden to the VMM instead of maintaining a quirk system in the kernel.
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 50 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h        | 14 +++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d94d61b92c1a..ca64e461d435 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1495,6 +1495,54 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
>  	return 0;
>  }
>  
> +static int vfio_pci_core_feature_pasid(struct vfio_device *device, u32 flags,
> +				       struct vfio_device_feature_pasid __user *arg,
> +				       size_t argsz)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +	struct vfio_device_feature_pasid pasid = { 0 };
> +	struct pci_dev *pdev = vdev->pdev;
> +	u32 capabilities = 0;
> +	u16 ctrl = 0;
> +	int ret;
> +
> +	/*
> +	 * Due to no PASID capability per VF, to be consistent, we do not
> +	 * support SET of the PASID capability for both PF and VF.
> +	 */
> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(pasid));
> +	if (ret != 1)
> +		return ret;
> +
> +	/* VF shares the PASID capability of its PF */
> +	if (pdev->is_virtfn)
> +		pdev = pci_physfn(pdev);
> +
> +	if (!pdev->pasid_enabled)
> +		goto out;
> +
> +#ifdef CONFIG_PCI_PASID
> +	pci_read_config_dword(pdev, pdev->pasid_cap + PCI_PASID_CAP,
> +			      &capabilities);
> +	pci_read_config_word(pdev, pdev->pasid_cap + PCI_PASID_CTRL,
> +			     &ctrl);
> +#endif
> +
> +	pasid.width = (capabilities >> 8) & 0x1f;
> +
> +	if (ctrl & PCI_PASID_CTRL_EXEC)
> +		pasid.capabilities |= VFIO_DEVICE_PASID_CAP_EXEC;
> +	if (ctrl & PCI_PASID_CTRL_PRIV)
> +		pasid.capabilities |= VFIO_DEVICE_PASID_CAP_PRIV;

I agree with Kevin here, let's make use of and add helpers to avoid
#ifdef blocks of code.

> +
> +out:
> +	if (copy_to_user(arg, &pasid, sizeof(pasid)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  				void __user *arg, size_t argsz)
>  {
> @@ -1508,6 +1556,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> +	case VFIO_DEVICE_FEATURE_PASID:
> +		return vfio_pci_core_feature_pasid(device, flags, arg, argsz);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9591dc24b75c..e50e55c67ab4 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1513,6 +1513,20 @@ struct vfio_device_feature_bus_master {
>  };
>  #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
>  
> +/**
> + * Upon VFIO_DEVICE_FEATURE_GET, return the PASID capability for the device.
> + * Zero width means no support for PASID.

Why would we do that rather than reporting the feature as unsupported?
Just return -ENOTTY if PASID is not supported or enabled.

> + */
> +struct vfio_device_feature_pasid {
> +	__u16 capabilities;
> +#define VFIO_DEVICE_PASID_CAP_EXEC	(1 << 0)
> +#define VFIO_DEVICE_PASID_CAP_PRIV	(1 << 1)
> +	__u8 width;
> +	__u8 __reserved;
> +};

Building on Kevin's comment on the cover letter, if we could describe
an offset for emulating a PASID capability, this seems like the place
we'd do it.  I think we're not doing that because we'd like an in-band
mechanism for a device to report unused config space, such as a DVSEC
capability, so that it can be implemented on a physical device.  As
noted in the commit log here, we'd also prefer not to bloat the kernel
with more device quirks.

In an ideal world we might be able to jump start support of that DVSEC
option by emulating the DVSEC capability on top of the PASID capability
for PFs, but unfortunately the PASID capability is 8 bytes while the
DVSEC capability is at least 12 bytes, so we can't implement that
generically either.

I don't know there's any good solution here or whether there's actually
any value to the PASID capability on a PF, but do we need to consider
leaving a field+flag here to describe the offset for that scenario?
Would we then allow variant drivers to take advantage of it?  Does this
then turn into the quirk that we're trying to avoid in the kernel
rather than userspace and is that a problem?  Thanks,

Alex

> +
> +#define VFIO_DEVICE_FEATURE_PASID 11
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**


