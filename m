Return-Path: <kvm+bounces-28659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 382B799AE46
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 23:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4E391F255B0
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0DA1C8FAE;
	Fri, 11 Oct 2024 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7iaSghv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB9F19D8B7
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728683263; cv=none; b=t4qh7iIKuvZFNFUtDNKJQdsNffpJag/9BMgymzRuKB/XWcTDZbnDH67JZFhUOADgBqp0gQwQydKTMDddKanLP4+PLMFXIa9+WyU7GVBGYi64yWFtMKj8Kf+X+5dWtbu5nH78W78Z6sYulEA4arBPO3/m9gQEoVPWEY/w5wzoh2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728683263; c=relaxed/simple;
	bh=ix4thBlpRIL6pfM9YON38TDCTRXcpVvSIDwZJJiPPXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSJyAkf7XaCG0BlVcO8tUzha3kdIUVCBdE//8XOWTpQzn7P6ig6rinlsyN6Bq1X7JRc54120DFxjI4uF/PQ72jd89K5r0PU48FgepxnYy+5X0yAbArwkopqCXdUw+OP0735pf2dz8tJdqFl6URCJDz7psWcEou3Lf07N6elG+7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7iaSghv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728683259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=353w8Ns/H+ncPZlQRfFNeLbshCnD91tEa17jCVYDyBM=;
	b=L7iaSghvMS77FYQp454q8OIvXaQIpzEGbY6A4YlMlzCoIJHP2AkQqLOiOBKFO2VjuCuphL
	ElABGewV8UVsXerUBKYz+1D9V75asSi8AQT8ITbngn8pr15IHG9bbbZrg6HHfn4+SWMEuz
	h+lwksb6ZFpG2JpWAqZMPKnrZbA4r94=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657--Q2Dq93lMCqpRK4p3jNeEQ-1; Fri, 11 Oct 2024 17:47:38 -0400
X-MC-Unique: -Q2Dq93lMCqpRK4p3jNeEQ-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5e98ef63cf5so109336eaf.3
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 14:47:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728683258; x=1729288058;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=353w8Ns/H+ncPZlQRfFNeLbshCnD91tEa17jCVYDyBM=;
        b=Q9kwuzomKJzBHmmv9+A4j/4nLL5K9FG0uKHhMkeCzslgb74ObXX6nQJNdJhJEQ6yq5
         OF85vzUU5MLzprnjyqvDZZ9wpxczc/H86NTBaH0bkHwUTLertYXug3aXqDyuUORKcBgh
         7TzXfOIAwe2PqhEy+u4kauKmob5LxWpIoueOzLI1jGvsqrnpsmzQun18YG8pg0JR8Vj+
         w3q4J16AH+6hamfHpEbO8/lcpI97aIoYCi8g8K5t4vmuenXHq9VGB7Rw9Mnu/39dU1s2
         BED3ZJIS01IAKj22g96DCfVIqhZKMbHuwMKKg4cuH8948FJonDhf5N84SA6gRV61f64X
         zm3A==
X-Gm-Message-State: AOJu0YzKwTtCSWGEdTul0RDhEzWdXQ9FID+0aqe08AMOvvltybJEWnEu
	qLS3YD9sOgwephYoO+zVUhnZpVdyEImHxFy9wzZVx1uH98px9Sh3SzGtUT36OCIElcmJmC2nCql
	a86C7kYWIgBLKpddRGZH93+L25CkPNGgk3CZChF7iB0aAjxn5Pw==
X-Received: by 2002:a05:6808:7085:b0:3e0:5141:66b2 with SMTP id 5614622812f47-3e5c90b9b3dmr728427b6e.2.1728683257505;
        Fri, 11 Oct 2024 14:47:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeZXcoyNz7p0zGGSdSLQO0BSkMoItypf+gpZHE+e0EioaeD9lbG7PoDGJ+thpbOP3mngmcWA==
X-Received: by 2002:a05:6808:7085:b0:3e0:5141:66b2 with SMTP id 5614622812f47-3e5c90b9b3dmr728406b6e.2.1728683257004;
        Fri, 11 Oct 2024 14:47:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e50a2b7f8dsm812829b6e.17.2024.10.11.14.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 14:47:36 -0700 (PDT)
Date: Fri, 11 Oct 2024 15:47:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <alison.schofield@intel.com>,
 <dan.j.williams@intel.com>, <dave.jiang@intel.com>, <dave@stgolabs.net>,
 <jonathan.cameron@huawei.com>, <ira.weiny@intel.com>,
 <vishal.l.verma@intel.com>, <alucerop@amd.com>, <clg@redhat.com>,
 <qemu-devel@nongnu.org>, <acurrid@nvidia.com>, <cjia@nvidia.com>,
 <smitra@nvidia.com>, <ankita@nvidia.com>, <aniketa@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiwang@kernel.org>
Subject: Re: [RFC 1/1] vfio: support CXL device in VFIO stub
Message-ID: <20241011154734.2d466fba.alex.williamson@redhat.com>
In-Reply-To: <20240921071440.1915876-2-zhiw@nvidia.com>
References: <20240921071440.1915876-1-zhiw@nvidia.com>
	<20240921071440.1915876-2-zhiw@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 21 Sep 2024 00:14:40 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

> To support CXL device passthrough, vfio-cxl-core is introduced. This
> is the QEMU part.
> 
> Get the CXL caps from the vfio-cxl-core. Trap and emulate the HDM
> decoder registers. Map the HDM decdoers when the guest commits a HDM
> decoder.

It seems like this could all essentially be handled as a quirk, setting
things up based on the CXL flag or CXL device info capability, and the
update could be done in the quirk write handler rather than a new
change notifier callback.  Thanks,

Alex

> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  hw/vfio/common.c              |   3 +
>  hw/vfio/pci.c                 | 134 ++++++++++++++++++++++++++++++++++
>  hw/vfio/pci.h                 |  10 +++
>  include/hw/pci/pci.h          |   2 +
>  include/hw/vfio/vfio-common.h |   1 +
>  linux-headers/linux/vfio.h    |  14 ++++
>  6 files changed, 164 insertions(+)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 9aac21abb7..6dea606f62 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -237,6 +237,9 @@ void vfio_region_write(void *opaque, hwaddr addr,
>          break;
>      }
>  
> +    if (region->notify_change)
> +        region->notify_change(opaque, addr, data, size);
> +
>      if (pwrite(vbasedev->fd, &buf, size, region->fd_offset + addr) != size) {
>          error_report("%s(%s:region%d+0x%"HWADDR_PRIx", 0x%"PRIx64
>                       ",%d) failed: %m",
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index a205c6b113..431a588252 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -23,6 +23,7 @@
>  #include <sys/ioctl.h>
>  
>  #include "hw/hw.h"
> +#include "hw/cxl/cxl_component.h"
>  #include "hw/pci/msi.h"
>  #include "hw/pci/msix.h"
>  #include "hw/pci/pci_bridge.h"
> @@ -2743,6 +2744,72 @@ int vfio_populate_vga(VFIOPCIDevice *vdev, Error **errp)
>      return 0;
>  }
>  
> +static bool read_region(VFIORegion *region, uint32_t *val, uint64_t offset)
> +{
> +    VFIODevice *vbasedev = region->vbasedev;
> +
> +    if (pread(vbasedev->fd, val, 4, region->fd_offset + offset) != 4) {
> +        error_report("%s(%s, 0x%lx, 0x%x, 0x%x) failed: %m",
> +                     __func__,vbasedev->name, offset, *val, 4);
> +        return false;
> +    }
> +    return true;
> +}
> +
> +static void vfio_cxl_hdm_regs_changed(void *opaque, hwaddr addr,
> +                                      uint64_t data, unsigned size)
> +{
> +    VFIORegion *region = opaque;
> +    VFIODevice *vbasedev = region->vbasedev;
> +    VFIOPCIDevice *vdev = container_of(vbasedev, VFIOPCIDevice, vbasedev);
> +    VFIOCXL *cxl = &vdev->cxl;
> +    MemoryRegion *address_space_mem = pci_get_bus(&vdev->pdev)->address_space_mem;
> +    uint64_t offset, reg_offset, index;
> +    uint32_t cur_val, write_val;
> +
> +    if (size != 4 || (addr & 0x3))
> +        error_report("hdm_regs_changed: unsupported size or unaligned addr!\n");
> +
> +    offset = addr - cxl->hdm_regs_offset;
> +    index = (offset - 0x10) / 0x20;
> +    reg_offset = offset - 0x20 * index;
> +
> +    if (reg_offset != 0x20)
> +        return;
> +
> +#define READ_REGION(val, offset) do { \
> +    if (!read_region(region, val, offset)) \
> +        return; \
> +    } while(0)
> +
> +    write_val = (uint32_t)data;
> +    READ_REGION(&cur_val, cxl->hdm_regs_offset + 0x20 * index + reg_offset);
> +
> +    if (!(cur_val & (1 << 10)) && (write_val & (1 << 9))) {
> +        memory_region_transaction_begin();
> +        memory_region_del_subregion(address_space_mem, cxl->region.mem);
> +        memory_region_transaction_commit();
> +    } else if (cur_val & (1 << 10) && !(write_val & (1 << 9))) {
> +        /* commit -> not commit */
> +        uint32_t base_hi, base_lo;
> +        uint64_t base;
> +
> +        /* locked */
> +        if (cur_val & (1 << 8))
> +            return;
> +
> +        READ_REGION(&base_lo, cxl->hdm_regs_offset +  0x20 * index + 0x10);
> +        READ_REGION(&base_hi, cxl->hdm_regs_offset +  0x20 * index + 0x14);
> +
> +        base = ((uint64_t)base_hi << 32) | (uint64_t)(base_lo >> 28);
> +
> +        memory_region_transaction_begin();
> +        memory_region_add_subregion_overlap(address_space_mem,
> +                                            base, cxl->region.mem, 0);
> +        memory_region_transaction_commit();
> +    }
> +}
> +
>  static void vfio_populate_device(VFIOPCIDevice *vdev, Error **errp)
>  {
>      VFIODevice *vbasedev = &vdev->vbasedev;
> @@ -2780,6 +2847,11 @@ static void vfio_populate_device(VFIOPCIDevice *vdev, Error **errp)
>          }
>  
>          QLIST_INIT(&vdev->bars[i].quirks);
> +
> +        if (vbasedev->flags & VFIO_DEVICE_FLAGS_CXL &&
> +            i == vdev->cxl.hdm_regs_bar_index) {
> +            vdev->bars[i].region.notify_change = vfio_cxl_hdm_regs_changed;
> +        }
>      }
>  
>      ret = vfio_get_region_info(vbasedev,
> @@ -2974,6 +3046,62 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
>      vdev->req_enabled = false;
>  }
>  
> +static int vfio_cxl_setup(VFIOPCIDevice *vdev)
> +{
> +    VFIODevice *vbasedev = &vdev->vbasedev;
> +    struct VFIOCXL *cxl = &vdev->cxl;
> +    struct vfio_device_info_cap_cxl *cap;
> +    g_autofree struct vfio_device_info *info = NULL;
> +    struct vfio_info_cap_header *hdr;
> +    struct vfio_region_info *region_info;
> +    int ret;
> +
> +    if (!(vbasedev->flags & VFIO_DEVICE_FLAGS_CXL))
> +        return 0;
> +
> +    info = vfio_get_device_info(vbasedev->fd);
> +    if (!info) {
> +        return -ENODEV;
> +    }
> +
> +    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_CXL);
> +    if (!hdr) {
> +        return -ENODEV;
> +    }
> +
> +    cap = (void *)hdr;
> +
> +    cxl->hdm_count = cap->hdm_count;
> +    cxl->hdm_regs_bar_index = cap->hdm_regs_bar_index;
> +    cxl->hdm_regs_size = cap->hdm_regs_size;
> +    cxl->hdm_regs_offset = cap->hdm_regs_offset;
> +    cxl->dpa_size = cap->dpa_size;
> +
> +    ret = vfio_get_dev_region_info(vbasedev,
> +            VFIO_REGION_TYPE_PCI_VENDOR_TYPE | PCI_VENDOR_ID_CXL,
> +            VFIO_REGION_SUBTYPE_CXL, &region_info);
> +    if (ret) {
> +        error_report("does not support requested CXL feature");
> +        return ret;
> +    }
> +
> +    ret = vfio_region_setup(OBJECT(vdev), vbasedev, &cxl->region,
> +            region_info->index, "cxl region");
> +    if (ret) {
> +        error_report("fail to setup CXL region");
> +        return ret;
> +    }
> +
> +    g_free(region_info);
> +
> +    if (vfio_region_mmap(&cxl->region)) {
> +        error_report("Failed to mmap %s cxl region",
> +                     vdev->vbasedev.name);
> +        return -EFAULT;
> +    }
> +    return 0;
> +}
> +
>  static void vfio_realize(PCIDevice *pdev, Error **errp)
>  {
>      VFIOPCIDevice *vdev = VFIO_PCI(pdev);
> @@ -3083,6 +3211,12 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>          goto error;
>      }
>  
> +    ret = vfio_cxl_setup(vdev);
> +    if (ret) {
> +        vfio_put_group(group);
> +        goto error;
> +    }
> +
>      vfio_populate_device(vdev, &err);
>      if (err) {
>          error_propagate(errp, err);
> diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
> index a2771b9ff3..6c5f5c1ea5 100644
> --- a/hw/vfio/pci.h
> +++ b/hw/vfio/pci.h
> @@ -118,6 +118,15 @@ typedef struct VFIOMSIXInfo {
>  #define TYPE_VFIO_PCI "vfio-pci"
>  OBJECT_DECLARE_SIMPLE_TYPE(VFIOPCIDevice, VFIO_PCI)
>  
> +typedef struct VFIOCXL {
> +    uint8_t hdm_count;
> +    uint8_t hdm_regs_bar_index;
> +    uint64_t hdm_regs_size;
> +    uint64_t hdm_regs_offset;
> +    uint64_t dpa_size;
> +    VFIORegion region;
> +} VFIOCXL;
> +
>  struct VFIOPCIDevice {
>      PCIDevice pdev;
>      VFIODevice vbasedev;
> @@ -177,6 +186,7 @@ struct VFIOPCIDevice {
>      bool clear_parent_atomics_on_exit;
>      VFIODisplay *dpy;
>      Notifier irqchip_change_notifier;
> +    VFIOCXL cxl;
>  };
>  
>  /* Use uin32_t for vendor & device so PCI_ANY_ID expands and cannot match hw */
> diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> index b70a0b95ff..fbf5786d00 100644
> --- a/include/hw/pci/pci.h
> +++ b/include/hw/pci/pci.h
> @@ -117,6 +117,8 @@ extern bool pci_available;
>  #define PCI_DEVICE_ID_REDHAT_UFS         0x0013
>  #define PCI_DEVICE_ID_REDHAT_QXL         0x0100
>  
> +#define PCI_VENDOR_ID_CXL                0x1e98
> +
>  #define FMT_PCIBUS                      PRIx64
>  
>  typedef uint64_t pcibus_t;
> diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
> index da43d27352..1c998c3ed6 100644
> --- a/include/hw/vfio/vfio-common.h
> +++ b/include/hw/vfio/vfio-common.h
> @@ -56,6 +56,7 @@ typedef struct VFIORegion {
>      uint32_t nr_mmaps;
>      VFIOMmap *mmaps;
>      uint8_t nr; /* cache the region number for debug */
> +    void (*notify_change)(void *, hwaddr, uint64_t, unsigned);
>  } VFIORegion;
>  
>  typedef struct VFIOMigration {
> diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
> index 16db89071e..22fb50ed34 100644
> --- a/linux-headers/linux/vfio.h
> +++ b/linux-headers/linux/vfio.h
> @@ -214,6 +214,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
>  #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
>  #define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
> +#define VFIO_DEVICE_FLAGS_CXL	(1 << 9)	/* vfio-cdx device */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> @@ -255,6 +256,16 @@ struct vfio_device_info_cap_pci_atomic_comp {
>  	__u32 reserved;
>  };
>  
> +#define VFIO_DEVICE_INFO_CAP_CXL               6
> +struct vfio_device_info_cap_cxl {
> +	struct vfio_info_cap_header header;
> +	__u8 hdm_count;
> +	__u8 hdm_regs_bar_index;
> +	__u64 hdm_regs_size;
> +	__u64 hdm_regs_offset;
> +	__u64 dpa_size;
> +};
> +
>  /**
>   * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
>   *				       struct vfio_region_info)
> @@ -371,6 +382,9 @@ struct vfio_region_info_cap_type {
>  /* sub-types for VFIO_REGION_TYPE_GFX */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
>  
> +/* sub-types for VFIO CXL region */
> +#define VFIO_REGION_SUBTYPE_CXL                 (1)
> +
>  /**
>   * struct vfio_region_gfx_edid - EDID region layout.
>   *


