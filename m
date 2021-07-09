Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B393C2AFC
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhGIVxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:53:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhGIVxl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Jul 2021 17:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625867456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYFRJYtkCRYSwbBeuspb80ScbjnAcRth61HuqIcGc/M=;
        b=bvXmd4zZNog+gkjdsV33CSmmQYZ8uhhhgt+uYNuo1COTDsCUOKlEt+3F5ISbwfooQIsWW7
        EC91aHyxVbDX7jitBoitaOuNZ04edRLaLsPsVO5hvPE4+VFNbtfpUyOj7N9b8uCCny3TMp
        KZTl2Dq/MawnWlpIJo/OhLoMxbvffEs=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-f_KdlB_-PWy-kD3c1ZnOkg-1; Fri, 09 Jul 2021 17:50:55 -0400
X-MC-Unique: f_KdlB_-PWy-kD3c1ZnOkg-1
Received: by mail-oo1-f71.google.com with SMTP id q1-20020a0568200281b029025a8f02e31dso5678125ood.23
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 14:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cYFRJYtkCRYSwbBeuspb80ScbjnAcRth61HuqIcGc/M=;
        b=N4/Ae7fM7QY9bRNDycNbMZ98RdcfrAMQLGDMjzdsvhIpTfvvGf6Pepj/cDKcbOQKYt
         9kqakR+AvWq83EP2YJa+peLylp4RFs8wNlOOXfotICDaqjLB+p3zSrhtSStFahbLYBje
         mvzN5f3xKPFn9RR+Qf44WzddOtrLbIYLFVcsx20KV4a+wElO0EyRhToL8Ew6uCmzjH78
         WNEDDKCeT8clHwITK+S3RIW5GFbD/36taL2F4ZqjyBn/iXjdpXF1TylEE44EYZ3YHSEY
         7oqxxuS0R/1KzGfuptVMj9hlGnkrGskj0aj/pbO2evSE1m5OxbK6uKe6+o+bAnTaqgwP
         Bzfg==
X-Gm-Message-State: AOAM531eHYrq3uuVrP7VxuM3+pOk00WAyQiwYsyeV4zdMbSoHbbd0OqD
        70tZ138MjOlNEzDboNHbjfY1LHxt7VSEEL7LU4OiQi6o82/o9bPK5vylBPpscjVgMX5M2mY0IBM
        bOV2tHOw38qaZ
X-Received: by 2002:a9d:6c07:: with SMTP id f7mr24276992otq.50.1625867454898;
        Fri, 09 Jul 2021 14:50:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+FH/VKC81T3oJHpy4CfTZrogqZcbjZ5kiSX2v2Sq28gDIrDnUNTIBqPRDiCXLbKtbcCZA7w==
X-Received: by 2002:a9d:6c07:: with SMTP id f7mr24276979otq.50.1625867454680;
        Fri, 09 Jul 2021 14:50:54 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id f3sm1490493otc.49.2021.07.09.14.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 14:50:54 -0700 (PDT)
Date:   Fri, 9 Jul 2021 15:50:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210709155052.2881f561.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

A couple first pass comments...

On Fri, 9 Jul 2021 07:48:44 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:
> 2.2. /dev/vfio device uAPI
> ++++++++++++++++++++++++++
> 
> /*
>   * Bind a vfio_device to the specified IOMMU fd
>   *
>   * The user should provide a device cookie when calling this ioctl. The 
>   * cookie is later used in IOMMU fd for capability query, iotlb invalidation
>   * and I/O fault handling.
>   *
>   * User is not allowed to access the device before the binding operation
>   * is completed.
>   *
>   * Unbind is automatically conducted when device fd is closed.
>   *
>   * Input parameters:
>   *	- iommu_fd;
>   *	- cookie;
>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define VFIO_BIND_IOMMU_FD	_IO(VFIO_TYPE, VFIO_BASE + 22)

I believe this is an ioctl on the device fd, therefore it should be
named VFIO_DEVICE_BIND_IOMMU_FD.

> 
> 
> /*
>   * Report vPASID info to userspace via VFIO_DEVICE_GET_INFO
>   *
>   * Add a new device capability. The presence indicates that the user
>   * is allowed to create multiple I/O address spaces on this device. The
>   * capability further includes following flags:
>   *
>   *	- PASID_DELEGATED, if clear every vPASID must be registered to 
>   *	  the kernel;
>   *	- PASID_CPU, if set vPASID is allowed to be carried in the CPU 
>   *	  instructions (e.g. ENQCMD);
>   *	- PASID_CPU_VIRT, if set require vPASID translation in the CPU; 
>   * 
>   * The user must check that all devices with PASID_CPU set have the 
>   * same setting on PASID_CPU_VIRT. If mismatching, it should enable 
>   * vPASID only in one category (all set, or all clear).
>   *
>   * When the user enables vPASID on the device with PASID_CPU_VIRT
>   * set, it must enable vPASID CPU translation via kvm fd before attempting
>   * to use ENQCMD to submit work items. The command portal is blocked 
>   * by the kernel until the CPU translation is enabled.
>   */
> #define VFIO_DEVICE_INFO_CAP_PASID		5
> 
> 
> /*
>   * Attach a vfio device to the specified IOASID
>   *
>   * Multiple vfio devices can be attached to the same IOASID, and vice 
>   * versa. 
>   *
>   * User may optionally provide a "virtual PASID" to mark an I/O page 
>   * table on this vfio device, if PASID_DELEGATED is not set in device info. 
>   * Whether the virtual PASID is physically used or converted to another 
>   * kernel-allocated PASID is a policy in the kernel.
>   *
>   * Because one device is allowed to bind to multiple IOMMU fd's, the
>   * user should provide both iommu_fd and ioasid for this attach operation.
>   *
>   * Input parameter:
>   *	- iommu_fd;
>   *	- ioasid;
>   *	- flag;
>   *	- vpasid (if specified);
>   * 
>   * Return: 0 on success, -errno on failure.
>   */
> #define VFIO_ATTACH_IOASID		_IO(VFIO_TYPE, VFIO_BASE + 23)
> #define VFIO_DETACH_IOASID		_IO(VFIO_TYPE, VFIO_BASE + 24)

Likewise, VFIO_DEVICE_{ATTACH,DETACH}_IOASID

...
> 3. Sample structures and helper functions
> --------------------------------------------------------
> 
> Three helper functions are provided to support VFIO_BIND_IOMMU_FD:
> 
> 	struct iommu_ctx *iommu_ctx_fdget(int fd);
> 	struct iommu_dev *iommu_register_device(struct iommu_ctx *ctx,
> 		struct device *device, u64 cookie);
> 	int iommu_unregister_device(struct iommu_dev *dev);
> 
> An iommu_ctx is created for each fd:
> 
> 	struct iommu_ctx {
> 		// a list of allocated IOASID data's
> 		struct xarray		ioasid_xa;
> 
> 		// a list of registered devices
> 		struct xarray		dev_xa;
> 	};
> 
> Later some group-tracking fields will be also introduced to support 
> multi-devices group.
> 
> Each registered device is represented by iommu_dev:
> 
> 	struct iommu_dev {
> 		struct iommu_ctx	*ctx;
> 		// always be the physical device
> 		struct device 		*device;
> 		u64			cookie;
> 		struct kref		kref;
> 	};
> 
> A successful binding establishes a security context for the bound
> device and returns struct iommu_dev pointer to the caller. After this
> point, the user is allowed to query device capabilities via IOMMU_
> DEVICE_GET_INFO.

If we have an initial singleton group only restriction, I assume that
both iommu_register_device() would fail for any devices that are not in
a singleton group and vfio would only expose direct device files for
the devices in singleton groups.  The latter implementation could
change when multi-device group support is added so that userspace can
assume that if the vfio device file exists, this interface is available.
I think this is confirmed further below.

> For mdev the struct device should be the pointer to the parent device. 

I don't get how iommu_register_device() differentiates an mdev from a
pdev in this case.

...
> 4.3. IOASID nesting (software)
> ++++++++++++++++++++++++++++++
> 
> Same usage scenario as 4.2, with software-based IOASID nesting 
> available. In this mode it is the kernel instead of user to create the
> shadow mapping.
> 
> The flow before guest boots is same as 4.2, except one point. Because 
> giova_ioasid is nested on gpa_ioasid, locked accounting is only 
> conducted for gpa_ioasid which becomes the only root.
> 
> There could be a case where different gpa_ioasids are created due
> to incompatible format between dev1/dev2 (e.g. about IOMMU 
> enforce-snoop). In such case the user could further created a dummy
> IOASID (HVA->HVA) as the root parent for two gpa_ioasids to avoid 
> duplicated accounting. But this scenario is not covered in following 
> flows.

This use case has been noted several times in the proposal, it probably
deserves an example.

> 
> To save space we only list the steps after boots (i.e. both dev1/dev2
> have been attached to gpa_ioasid before guest boots):
> 
> 	/* After boots */
> 	/* Create GIOVA space nested on GPA space
> 	 * Both page tables are managed by the kernel
> 	 */
> 	alloc_data = {.user_pgtable = false; .parent = gpa_ioasid};
> 	giova_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);

So the user would use IOMMU_DEVICE_GET_INFO on the iommu_fd with device
cookie2 after the VFIO_DEVICE_BIND_IOMMU_FD to learn that software
nesting is supported before proceeding down this path?

> 
> 	/* Attach dev2 to the new address space (child)
> 	 * Note dev2 is still attached to gpa_ioasid (parent)
> 	 */
> 	at_data = { .fd = iommu_fd; .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Setup a GIOVA [0x2000] ->GPA [0x1000] mapping for giova_ioasid, 
> 	 * based on the vIOMMU page table. The kernel is responsible for
> 	 * creating the shadow mapping GIOVA [0x2000] -> HVA [0x40001000]
> 	 * by walking the parent's I/O page table to find out GPA [0x1000] ->
> 	 * HVA [0x40001000].
> 	 */
> 	dma_map = {
> 		.ioasid	= giova_ioasid;
> 		.iova	= 0x2000;	// GIOVA
> 		.vaddr	= 0x1000;	// GPA
> 		.size	= 4KB;
> 	};
> 	ioctl(iommu_fd, IOMMU_MAP_DMA, &dma_map);
> 
> 4.4. IOASID nesting (hardware)
> ++++++++++++++++++++++++++++++
> 
> Same usage scenario as 4.2, with hardware-based IOASID nesting
> available. In this mode the I/O page table is managed by userspace
> thus an invalidation interface is used for the user to request iotlb
> invalidation.
> 
> 	/* After boots */
> 	/* Create GIOVA space nested on GPA space.
> 	 * Claim it's an user-managed I/O page table.
> 	 */
> 	alloc_data = {
> 		.user_pgtable	= true;
> 		.parent		= gpa_ioasid;
> 		.addr		= giova_pgtable;
> 		// and format information;
> 	};
> 	giova_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
> 
> 	/* Attach dev2 to the new address space (child)
> 	 * Note dev2 is still attached to gpa_ioasid (parent)
> 	 */
> 	at_data = { .fd = iommu_fd; .ioasid = giova_ioasid};
> 	ioctl(device_fd2, VFIO_ATTACH_IOASID, &at_data);
> 
> 	/* Invalidate IOTLB when required */
> 	inv_data = {
> 		.ioasid	= giova_ioasid;
> 		// granular/cache type information
> 	};
> 	ioctl(iommu_fd, IOMMU_INVALIDATE_CACHE, &inv_data);
> 
> 	/* See 4.6 for I/O page fault handling */
> 	
> 4.5. Guest SVA (vSVA)
> +++++++++++++++++++++
> 
> After boots the guest further creates a GVA address spaces (vpasid1) on 
> dev1. Dev2 is not affected (still attached to giova_ioasid).
> 
> As explained in section 1.4, the user should check the PASID capability
> exposed via VFIO_DEVICE_GET_INFO and follow the required uAPI
> semantics when doing the attaching call:

And this characteristic lives in VFIO_DEVICE_GET_INFO rather than
IOMMU_DEVICE_GET_INFO because this is a characteristic known by the
vfio device driver rather than the system IOMMU, right?  Thanks,

Alex

