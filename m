Return-Path: <kvm+bounces-53515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C77B13127
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6ACC21897732
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A6E223DE9;
	Sun, 27 Jul 2025 18:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="poRJcUeo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0DA21E0AF
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753640624; cv=none; b=rdGL7KaF/eqSsSJ5YVYPkgULk1gWo5Xs9Denp9B0Hk24a0W4kccSDzahyKIKxeq8MshDk5IinlvN4eDUEU//hJYeqG3Q6ESoVyogAAwAJ+xs0g2UpwHD93Hp0R3kRPRNuUfZmMW2YVRvC5JmbjnrdqAcONiWa/JGbTntCVbRIlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753640624; c=relaxed/simple;
	bh=h7MQ6ex2EMeNlvkeuOgYMTzfjvh/nHgJVsvyjAW8amc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QvxD4Q7hqTw31EWwNpNa/SPGIejVXZrF3GP/Ju33N0u3XpHVcz65l1VjpY7A/GtV3IdyI/CAAbwxVDzwo0PMCX2PfhbmqnOrOYBqJV4gfa6Sf2D7dsvG7KLwYoGnztfUseUY1DusvR4EJSMauLKkYCsApzO8YCxfN+OAUVwKtY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=poRJcUeo; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4562b2d98bcso42855e9.1
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753640619; x=1754245419; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0+YWcq0J8mTIEv4/p6jJj9LZGs1/CV68DscAEDmKqo4=;
        b=poRJcUeo0Qa9DJGvaliGPPUjt8DqietgrKc6rY5oqtxErxuVGKJpG/xifsKyaxSkoJ
         imjYx10iBNvV2dYD/ugxcV4XlqSJfjL2Zir/sDTlq4Ro81Mw1UkYdALfBaDPFloDbE0R
         oJFpwpc2ZMzi+wltu5olZvk6KPeLJbDyD816jyoAthmznfqxNf8MmMjbW9NTvAHyJF6J
         aDMq/LKyrtZxOdpcJg5L2gxv799HG/AEAQX7f1afjWxJas6lMUNIR8+sTVMmB8mhbWmh
         B+QYOV3VyVrGLL8SwdyX3pCS9nGwZwgncWvJjCVDrrYEzRZcR6xwB0DUPeS3iLAOugn6
         qW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753640619; x=1754245419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+YWcq0J8mTIEv4/p6jJj9LZGs1/CV68DscAEDmKqo4=;
        b=MC6Mmgv1s4BfP/CskRGxghpfHcfLhQ7lt1GUsRn2g5wvdSIpyvsoeb+Kb+yQfqyyES
         OKLcXSJDCdwgXYJcNIxDzAtRhcTW31nZ0pke1rUX6dLX8Js/lw2uVH72mEilMHQhZvaL
         u7xXzedkGLMBcDJUgrjuJVAY501nhlq8L3rZ2ftGsld0ICUnfUAT6HHRJjJLHI45XDXm
         62ClYfCygQfw2oKKlkhxcDLtxK7UZEqxQEtgSCqFRgwFQlqftLMtjunL9C3GWJ0BVxRT
         sMzTWNQY19aj2VsCxIx7BxAsLn1IVbpkJPmMXzlfNzw+7CqPJhxAU89yNyBevdAxcSgt
         D2yA==
X-Gm-Message-State: AOJu0YyqWWgmTPlZxwf/PRrtZY0rSQ4QEDOTcnUtOc7LP43tiofgJR/G
	GCfGCiZ5mpg5RCKPCnQdc4YPqAi23wZ1Du0vDJn30MakhVq31tVBEHCxZTLPM2OtPQ3NU8MzPbr
	00uYRHQ==
X-Gm-Gg: ASbGnctJVOSq0g+I1jo1DCpFi+3+9pkIYq9fm3dw7H3bZkr+x1jHxHYNkwc+uWAqN6H
	MCnzhCGZv2vVAuL7tEUW2uYqJniYrT7KHj7WTo3j10USAxjzQKHKRqeK7HcM/PXCPtq005YEcBy
	e/KFqbyCcFjgktQQiCC/PNdqMvRWdpl/hdJvqnafvIGhpJTiiqkgnI/q3jlk61MsFKpbX5RE04o
	r1wWaAHrW/stfu47t9NYLm0TXEuBwgwV9mkfpBfiN+FkBn/ZvD3AliJAJI/ghECNK1YUwuVkLc/
	Vv/HuSAuIh/9KII1HPzxoxZD8TQl8IoZfcqhYk9c7Yz4jYCZaqFYlkGPl6oGGnzK4HnTEGMXoi2
	Yti5Vyn2yXDI3E6mzLiIdnMqWTp8WjyrtI5fwF4qx/Ucq7/ZCRhFIVxQzRCAT
X-Google-Smtp-Source: AGHT+IFBwcrFgoQIzXuxqGtREYX2mEfT8dEBFQWx5go3NqXNFgvgKMSR19uyu66gNpeMAJjRXc9zEQ==
X-Received: by 2002:a05:600c:c05a:b0:453:5ffb:e007 with SMTP id 5b1f17b1804b1-4587c1f7b91mr1230165e9.4.1753640617900;
        Sun, 27 Jul 2025 11:23:37 -0700 (PDT)
Received: from google.com (232.38.195.35.bc.googleusercontent.com. [35.195.38.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b787d30092sm1542687f8f.82.2025.07.27.11.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:23:37 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:23:34 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 04/10] vfio: Update vfio header from linux
 kernel
Message-ID: <aIZupnBsfMQ2x0AR@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-4-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250525074917.150332-4-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:10PM +0530, Aneesh Kumar K.V (Arm) wrote:
> sync with include/uapi/linux/vfio.h from v6.14
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Reviewed-by: Mostafa Saleh <smostafa@google.com>

> ---
>  include/linux/types.h |   13 +
>  include/linux/vfio.h  | 1131 ++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 1132 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 5e20f10f8830..652c33bf5c87 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -36,6 +36,19 @@ typedef __u32 __bitwise __be32;
>  typedef __u64 __bitwise __le64;
>  typedef __u64 __bitwise __be64;
>  
> +/*
> + * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
> + * common 32/64-bit compat problems.
> + * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
> + * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
> + * aligned_64 type enforces 8-byte alignment so that structs containing
> + * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
> + * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
> + */
> +#define __aligned_u64 __u64 __attribute__((aligned(8)))
> +#define __aligned_be64 __be64 __attribute__((aligned(8)))
> +#define __aligned_le64 __le64 __attribute__((aligned(8)))
> +
>  struct list_head {
>  	struct list_head *next, *prev;
>  };
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 4e7ab4c52a4a..c8dbf8219c4f 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>  /*
>   * VFIO API definition
>   *
> @@ -8,8 +9,8 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> -#ifndef VFIO_H
> -#define VFIO_H
> +#ifndef _UAPIVFIO_H
> +#define _UAPIVFIO_H
>  
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> @@ -34,7 +35,7 @@
>  #define VFIO_EEH			5
>  
>  /* Two-stage IOMMU */
> -#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
> +#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
>  
>  #define VFIO_SPAPR_TCE_v2_IOMMU		7
>  
> @@ -45,6 +46,16 @@
>   */
>  #define VFIO_NOIOMMU_IOMMU		8
>  
> +/* Supports VFIO_DMA_UNMAP_FLAG_ALL */
> +#define VFIO_UNMAP_ALL			9
> +
> +/*
> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
> + * devices, so this capability is subject to change as groups are added or
> + * removed.
> + */
> +#define VFIO_UPDATE_VADDR		10
> +
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the
>   * structure length (argsz) and flags into structures passed between
> @@ -199,8 +210,14 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
>  #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>  #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
> +#define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
> +#define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
> +#define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
> +#define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
> +	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32   pad;
>  };
>  #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
>  
> @@ -214,6 +231,30 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_API_PLATFORM_STRING		"vfio-platform"
>  #define VFIO_DEVICE_API_AMBA_STRING		"vfio-amba"
>  #define VFIO_DEVICE_API_CCW_STRING		"vfio-ccw"
> +#define VFIO_DEVICE_API_AP_STRING		"vfio-ap"
> +
> +/*
> + * The following capabilities are unique to s390 zPCI devices.  Their contents
> + * are further-defined in vfio_zdev.h
> + */
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_BASE		1
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_GROUP		2
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_UTIL		3
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_PFIP		4
> +
> +/*
> + * The following VFIO_DEVICE_INFO capability reports support for PCIe AtomicOp
> + * completion to the root bus with supported widths provided via flags.
> + */
> +#define VFIO_DEVICE_INFO_CAP_PCI_ATOMIC_COMP	5
> +struct vfio_device_info_cap_pci_atomic_comp {
> +	struct vfio_info_cap_header header;
> +	__u32 flags;
> +#define VFIO_PCI_ATOMIC_COMP32	(1 << 0)
> +#define VFIO_PCI_ATOMIC_COMP64	(1 << 1)
> +#define VFIO_PCI_ATOMIC_COMP128	(1 << 2)
> +	__u32 reserved;
> +};
>  
>  /**
>   * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
> @@ -236,8 +277,8 @@ struct vfio_region_info {
>  #define VFIO_REGION_INFO_FLAG_CAPS	(1 << 3) /* Info supports caps */
>  	__u32	index;		/* Region index */
>  	__u32	cap_offset;	/* Offset within info struct of first cap */
> -	__u64	size;		/* Region size (bytes) */
> -	__u64	offset;		/* Region offset from start of device fd */
> +	__aligned_u64	size;	/* Region size (bytes) */
> +	__aligned_u64	offset;	/* Region offset from start of device fd */
>  };
>  #define VFIO_DEVICE_GET_REGION_INFO	_IO(VFIO_TYPE, VFIO_BASE + 8)
>  
> @@ -253,8 +294,8 @@ struct vfio_region_info {
>  #define VFIO_REGION_INFO_CAP_SPARSE_MMAP	1
>  
>  struct vfio_region_sparse_mmap_area {
> -	__u64	offset;	/* Offset of mmap'able area within region */
> -	__u64	size;	/* Size of mmap'able area */
> +	__aligned_u64	offset;	/* Offset of mmap'able area within region */
> +	__aligned_u64	size;	/* Size of mmap'able area */
>  };
>  
>  struct vfio_region_info_cap_sparse_mmap {
> @@ -292,14 +333,169 @@ struct vfio_region_info_cap_type {
>  	__u32 subtype;	/* type specific */
>  };
>  
> +/*
> + * List of region types, global per bus driver.
> + * If you introduce a new type, please add it here.
> + */
> +
> +/* PCI region type containing a PCI vendor part */
>  #define VFIO_REGION_TYPE_PCI_VENDOR_TYPE	(1 << 31)
>  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
> +#define VFIO_REGION_TYPE_GFX                    (1)
> +#define VFIO_REGION_TYPE_CCW			(2)
> +#define VFIO_REGION_TYPE_MIGRATION_DEPRECATED   (3)
> +
> +/* sub-types for VFIO_REGION_TYPE_PCI_* */
>  
> -/* 8086 Vendor sub-types */
> +/* 8086 vendor PCI sub-types */
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION	(1)
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG	(2)
>  #define VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG	(3)
>  
> +/* 10de vendor PCI sub-types */
> +/*
> + * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
> + *
> + * Deprecated, region no longer provided
> + */
> +#define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
> +
> +/* 1014 vendor PCI sub-types */
> +/*
> + * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
> + * to do TLB invalidation on a GPU.
> + *
> + * Deprecated, region no longer provided
> + */
> +#define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
> +
> +/* sub-types for VFIO_REGION_TYPE_GFX */
> +#define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
> +
> +/**
> + * struct vfio_region_gfx_edid - EDID region layout.
> + *
> + * Set display link state and EDID blob.
> + *
> + * The EDID blob has monitor information such as brand, name, serial
> + * number, physical size, supported video modes and more.
> + *
> + * This special region allows userspace (typically qemu) set a virtual
> + * EDID for the virtual monitor, which allows a flexible display
> + * configuration.
> + *
> + * For the edid blob spec look here:
> + *    https://en.wikipedia.org/wiki/Extended_Display_Identification_Data
> + *
> + * On linux systems you can find the EDID blob in sysfs:
> + *    /sys/class/drm/${card}/${connector}/edid
> + *
> + * You can use the edid-decode ulility (comes with xorg-x11-utils) to
> + * decode the EDID blob.
> + *
> + * @edid_offset: location of the edid blob, relative to the
> + *               start of the region (readonly).
> + * @edid_max_size: max size of the edid blob (readonly).
> + * @edid_size: actual edid size (read/write).
> + * @link_state: display link state (read/write).
> + * VFIO_DEVICE_GFX_LINK_STATE_UP: Monitor is turned on.
> + * VFIO_DEVICE_GFX_LINK_STATE_DOWN: Monitor is turned off.
> + * @max_xres: max display width (0 == no limitation, readonly).
> + * @max_yres: max display height (0 == no limitation, readonly).
> + *
> + * EDID update protocol:
> + *   (1) set link-state to down.
> + *   (2) update edid blob and size.
> + *   (3) set link-state to up.
> + */
> +struct vfio_region_gfx_edid {
> +	__u32 edid_offset;
> +	__u32 edid_max_size;
> +	__u32 edid_size;
> +	__u32 max_xres;
> +	__u32 max_yres;
> +	__u32 link_state;
> +#define VFIO_DEVICE_GFX_LINK_STATE_UP    1
> +#define VFIO_DEVICE_GFX_LINK_STATE_DOWN  2
> +};
> +
> +/* sub-types for VFIO_REGION_TYPE_CCW */
> +#define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
> +#define VFIO_REGION_SUBTYPE_CCW_SCHIB		(2)
> +#define VFIO_REGION_SUBTYPE_CCW_CRW		(3)
> +
> +/* sub-types for VFIO_REGION_TYPE_MIGRATION */
> +#define VFIO_REGION_SUBTYPE_MIGRATION_DEPRECATED (1)
> +
> +struct vfio_device_migration_info {
> +	__u32 device_state;         /* VFIO device state */
> +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_V1_RUNNING | \
> +				     VFIO_DEVICE_STATE_V1_SAVING |  \
> +				     VFIO_DEVICE_STATE_V1_RESUMING)
> +
> +#define VFIO_DEVICE_STATE_VALID(state) \
> +	(state & VFIO_DEVICE_STATE_V1_RESUMING ? \
> +	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_V1_RESUMING : 1)
> +
> +#define VFIO_DEVICE_STATE_IS_ERROR(state) \
> +	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_V1_SAVING | \
> +					      VFIO_DEVICE_STATE_V1_RESUMING))
> +
> +#define VFIO_DEVICE_STATE_SET_ERROR(state) \
> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_V1_SAVING | \
> +					     VFIO_DEVICE_STATE_V1_RESUMING)
> +
> +	__u32 reserved;
> +	__aligned_u64 pending_bytes;
> +	__aligned_u64 data_offset;
> +	__aligned_u64 data_size;
> +};
> +
> +/*
> + * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
> + * which allows direct access to non-MSIX registers which happened to be within
> + * the same system page.
> + *
> + * Even though the userspace gets direct access to the MSIX data, the existing
> + * VFIO_DEVICE_SET_IRQS interface must still be used for MSIX configuration.
> + */
> +#define VFIO_REGION_INFO_CAP_MSIX_MAPPABLE	3
> +
> +/*
> + * Capability with compressed real address (aka SSA - small system address)
> + * where GPU RAM is mapped on a system bus. Used by a GPU for DMA routing
> + * and by the userspace to associate a NVLink bridge with a GPU.
> + *
> + * Deprecated, capability no longer provided
> + */
> +#define VFIO_REGION_INFO_CAP_NVLINK2_SSATGT	4
> +
> +struct vfio_region_info_cap_nvlink2_ssatgt {
> +	struct vfio_info_cap_header header;
> +	__aligned_u64 tgt;
> +};
> +
> +/*
> + * Capability with an NVLink link speed. The value is read by
> + * the NVlink2 bridge driver from the bridge's "ibm,nvlink-speed"
> + * property in the device tree. The value is fixed in the hardware
> + * and failing to provide the correct value results in the link
> + * not working with no indication from the driver why.
> + *
> + * Deprecated, capability no longer provided
> + */
> +#define VFIO_REGION_INFO_CAP_NVLINK2_LNKSPD	5
> +
> +struct vfio_region_info_cap_nvlink2_lnkspd {
> +	struct vfio_info_cap_header header;
> +	__u32 link_speed;
> +	__u32 __pad;
> +};
> +
>  /**
>   * VFIO_DEVICE_GET_IRQ_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 9,
>   *				    struct vfio_irq_info)
> @@ -331,6 +527,9 @@ struct vfio_region_info_cap_type {
>   * then add and unmask vectors, it's up to userspace to make the decision
>   * whether to allocate the maximum supported number of vectors or tear
>   * down setup and incrementally increase the vectors as each is enabled.
> + * Absence of the NORESIZE flag indicates that vectors can be enabled
> + * and disabled dynamically without impacting other vectors within the
> + * index.
>   */
>  struct vfio_irq_info {
>  	__u32	argsz;
> @@ -461,18 +660,78 @@ enum {
>  
>  enum {
>  	VFIO_CCW_IO_IRQ_INDEX,
> +	VFIO_CCW_CRW_IRQ_INDEX,
> +	VFIO_CCW_REQ_IRQ_INDEX,
>  	VFIO_CCW_NUM_IRQS
>  };
>  
> +/*
> + * The vfio-ap bus driver makes use of the following IRQ index mapping.
> + * Unimplemented IRQ types return a count of zero.
> + */
> +enum {
> +	VFIO_AP_REQ_IRQ_INDEX,
> +	VFIO_AP_NUM_IRQS
> +};
> +
>  /**
> - * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IORW(VFIO_TYPE, VFIO_BASE + 12,
> + * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
>   *					      struct vfio_pci_hot_reset_info)
>   *
> + * This command is used to query the affected devices in the hot reset for
> + * a given device.
> + *
> + * This command always reports the segment, bus, and devfn information for
> + * each affected device, and selectively reports the group_id or devid per
> + * the way how the calling device is opened.
> + *
> + *	- If the calling device is opened via the traditional group/container
> + *	  API, group_id is reported.  User should check if it has owned all
> + *	  the affected devices and provides a set of group fds to prove the
> + *	  ownership in VFIO_DEVICE_PCI_HOT_RESET ioctl.
> + *
> + *	- If the calling device is opened as a cdev, devid is reported.
> + *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set to indicate this
> + *	  data type.  All the affected devices should be represented in
> + *	  the dev_set, ex. bound to a vfio driver, and also be owned by
> + *	  this interface which is determined by the following conditions:
> + *	  1) Has a valid devid within the iommufd_ctx of the calling device.
> + *	     Ownership cannot be determined across separate iommufd_ctx and
> + *	     the cdev calling conventions do not support a proof-of-ownership
> + *	     model as provided in the legacy group interface.  In this case
> + *	     valid devid with value greater than zero is provided in the return
> + *	     structure.
> + *	  2) Does not have a valid devid within the iommufd_ctx of the calling
> + *	     device, but belongs to the same IOMMU group as the calling device
> + *	     or another opened device that has a valid devid within the
> + *	     iommufd_ctx of the calling device.  This provides implicit ownership
> + *	     for devices within the same DMA isolation context.  In this case
> + *	     the devid value of VFIO_PCI_DEVID_OWNED is provided in the return
> + *	     structure.
> + *
> + *	  A devid value of VFIO_PCI_DEVID_NOT_OWNED is provided in the return
> + *	  structure for affected devices where device is NOT represented in the
> + *	  dev_set or ownership is not available.  Such devices prevent the use
> + *	  of VFIO_DEVICE_PCI_HOT_RESET ioctl outside of the proof-of-ownership
> + *	  calling conventions (ie. via legacy group accessed devices).  Flag
> + *	  VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
> + *	  affected devices are represented in the dev_set and also owned by
> + *	  the user.  This flag is available only when
> + *	  flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
> + *	  When set, user could invoke VFIO_DEVICE_PCI_HOT_RESET with a zero
> + *	  length fd array on the calling device as the ownership is validated
> + *	  by iommufd_ctx.
> + *
>   * Return: 0 on success, -errno on failure:
>   *	-enospc = insufficient buffer, -enodev = unsupported for device.
>   */
>  struct vfio_pci_dependent_device {
> -	__u32	group_id;
> +	union {
> +		__u32   group_id;
> +		__u32	devid;
> +#define VFIO_PCI_DEVID_OWNED		0
> +#define VFIO_PCI_DEVID_NOT_OWNED	-1
> +	};
>  	__u16	segment;
>  	__u8	bus;
>  	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
> @@ -481,6 +740,8 @@ struct vfio_pci_dependent_device {
>  struct vfio_pci_hot_reset_info {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID		(1 << 0)
> +#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED	(1 << 1)
>  	__u32	count;
>  	struct vfio_pci_dependent_device	devices[];
>  };
> @@ -491,6 +752,24 @@ struct vfio_pci_hot_reset_info {
>   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>   *				    struct vfio_pci_hot_reset)
>   *
> + * A PCI hot reset results in either a bus or slot reset which may affect
> + * other devices sharing the bus/slot.  The calling user must have
> + * ownership of the full set of affected devices as determined by the
> + * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl.
> + *
> + * When called on a device file descriptor acquired through the vfio
> + * group interface, the user is required to provide proof of ownership
> + * of those affected devices via the group_fds array in struct
> + * vfio_pci_hot_reset.
> + *
> + * When called on a direct cdev opened vfio device, the flags field of
> + * struct vfio_pci_hot_reset_info reports the ownership status of the
> + * affected devices and this ioctl must be called with an empty group_fds
> + * array.  See above INFO ioctl definition for ownership requirements.
> + *
> + * Mixed usage of legacy groups and cdevs across the set of affected
> + * devices is not supported.
> + *
>   * Return: 0 on success, -errno on failure.
>   */
>  struct vfio_pci_hot_reset {
> @@ -502,6 +781,683 @@ struct vfio_pci_hot_reset {
>  
>  #define VFIO_DEVICE_PCI_HOT_RESET	_IO(VFIO_TYPE, VFIO_BASE + 13)
>  
> +/**
> + * VFIO_DEVICE_QUERY_GFX_PLANE - _IOW(VFIO_TYPE, VFIO_BASE + 14,
> + *                                    struct vfio_device_query_gfx_plane)
> + *
> + * Set the drm_plane_type and flags, then retrieve the gfx plane info.
> + *
> + * flags supported:
> + * - VFIO_GFX_PLANE_TYPE_PROBE and VFIO_GFX_PLANE_TYPE_DMABUF are set
> + *   to ask if the mdev supports dma-buf. 0 on support, -EINVAL on no
> + *   support for dma-buf.
> + * - VFIO_GFX_PLANE_TYPE_PROBE and VFIO_GFX_PLANE_TYPE_REGION are set
> + *   to ask if the mdev supports region. 0 on support, -EINVAL on no
> + *   support for region.
> + * - VFIO_GFX_PLANE_TYPE_DMABUF or VFIO_GFX_PLANE_TYPE_REGION is set
> + *   with each call to query the plane info.
> + * - Others are invalid and return -EINVAL.
> + *
> + * Note:
> + * 1. Plane could be disabled by guest. In that case, success will be
> + *    returned with zero-initialized drm_format, size, width and height
> + *    fields.
> + * 2. x_hot/y_hot is set to 0xFFFFFFFF if no hotspot information available
> + *
> + * Return: 0 on success, -errno on other failure.
> + */
> +struct vfio_device_gfx_plane_info {
> +	__u32 argsz;
> +	__u32 flags;
> +#define VFIO_GFX_PLANE_TYPE_PROBE (1 << 0)
> +#define VFIO_GFX_PLANE_TYPE_DMABUF (1 << 1)
> +#define VFIO_GFX_PLANE_TYPE_REGION (1 << 2)
> +	/* in */
> +	__u32 drm_plane_type;	/* type of plane: DRM_PLANE_TYPE_* */
> +	/* out */
> +	__u32 drm_format;	/* drm format of plane */
> +	__aligned_u64 drm_format_mod;   /* tiled mode */
> +	__u32 width;	/* width of plane */
> +	__u32 height;	/* height of plane */
> +	__u32 stride;	/* stride of plane */
> +	__u32 size;	/* size of plane in bytes, align on page*/
> +	__u32 x_pos;	/* horizontal position of cursor plane */
> +	__u32 y_pos;	/* vertical position of cursor plane*/
> +	__u32 x_hot;    /* horizontal position of cursor hotspot */
> +	__u32 y_hot;    /* vertical position of cursor hotspot */
> +	union {
> +		__u32 region_index;	/* region index */
> +		__u32 dmabuf_id;	/* dma-buf id */
> +	};
> +	__u32 reserved;
> +};
> +
> +#define VFIO_DEVICE_QUERY_GFX_PLANE _IO(VFIO_TYPE, VFIO_BASE + 14)
> +
> +/**
> + * VFIO_DEVICE_GET_GFX_DMABUF - _IOW(VFIO_TYPE, VFIO_BASE + 15, __u32)
> + *
> + * Return a new dma-buf file descriptor for an exposed guest framebuffer
> + * described by the provided dmabuf_id. The dmabuf_id is returned from VFIO_
> + * DEVICE_QUERY_GFX_PLANE as a token of the exposed guest framebuffer.
> + */
> +
> +#define VFIO_DEVICE_GET_GFX_DMABUF _IO(VFIO_TYPE, VFIO_BASE + 15)
> +
> +/**
> + * VFIO_DEVICE_IOEVENTFD - _IOW(VFIO_TYPE, VFIO_BASE + 16,
> + *                              struct vfio_device_ioeventfd)
> + *
> + * Perform a write to the device at the specified device fd offset, with
> + * the specified data and width when the provided eventfd is triggered.
> + * vfio bus drivers may not support this for all regions, for all widths,
> + * or at all.  vfio-pci currently only enables support for BAR regions,
> + * excluding the MSI-X vector table.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_ioeventfd {
> +	__u32	argsz;
> +	__u32	flags;
> +#define VFIO_DEVICE_IOEVENTFD_8		(1 << 0) /* 1-byte write */
> +#define VFIO_DEVICE_IOEVENTFD_16	(1 << 1) /* 2-byte write */
> +#define VFIO_DEVICE_IOEVENTFD_32	(1 << 2) /* 4-byte write */
> +#define VFIO_DEVICE_IOEVENTFD_64	(1 << 3) /* 8-byte write */
> +#define VFIO_DEVICE_IOEVENTFD_SIZE_MASK	(0xf)
> +	__aligned_u64	offset;		/* device fd offset of write */
> +	__aligned_u64	data;		/* data to be written */
> +	__s32	fd;			/* -1 for de-assignment */
> +	__u32	reserved;
> +};
> +
> +#define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
> +
> +/**
> + * VFIO_DEVICE_FEATURE - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> + *			       struct vfio_device_feature)
> + *
> + * Get, set, or probe feature data of the device.  The feature is selected
> + * using the FEATURE_MASK portion of the flags field.  Support for a feature
> + * can be probed by setting both the FEATURE_MASK and PROBE bits.  A probe
> + * may optionally include the GET and/or SET bits to determine read vs write
> + * access of the feature respectively.  Probing a feature will return success
> + * if the feature is supported and all of the optionally indicated GET/SET
> + * methods are supported.  The format of the data portion of the structure is
> + * specific to the given feature.  The data portion is not required for
> + * probing.  GET and SET are mutually exclusive, except for use with PROBE.
> + *
> + * Return 0 on success, -errno on failure.
> + */
> +struct vfio_device_feature {
> +	__u32	argsz;
> +	__u32	flags;
> +#define VFIO_DEVICE_FEATURE_MASK	(0xffff) /* 16-bit feature index */
> +#define VFIO_DEVICE_FEATURE_GET		(1 << 16) /* Get feature into data[] */
> +#define VFIO_DEVICE_FEATURE_SET		(1 << 17) /* Set feature from data[] */
> +#define VFIO_DEVICE_FEATURE_PROBE	(1 << 18) /* Probe feature support */
> +	__u8	data[];
> +};
> +
> +#define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
> +
> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
> + *				   struct vfio_device_bind_iommufd)
> + * @argsz:	 User filled size of this data.
> + * @flags:	 Must be 0.
> + * @iommufd:	 iommufd to bind.
> + * @out_devid:	 The device id generated by this bind. devid is a handle for
> + *		 this device/iommufd bond and can be used in IOMMUFD commands.
> + *
> + * Bind a vfio_device to the specified iommufd.
> + *
> + * User is restricted from accessing the device before the binding operation
> + * is completed.  Only allowed on cdev fds.
> + *
> + * Unbind is automatically conducted when device fd is closed.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_bind_iommufd {
> +	__u32		argsz;
> +	__u32		flags;
> +	__s32		iommufd;
> +	__u32		out_devid;
> +};
> +
> +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
> +
> +/*
> + * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 19,
> + *					struct vfio_device_attach_iommufd_pt)
> + * @argsz:	User filled size of this data.
> + * @flags:	Must be 0.
> + * @pt_id:	Input the target id which can represent an ioas or a hwpt
> + *		allocated via iommufd subsystem.
> + *		Output the input ioas id or the attached hwpt id which could
> + *		be the specified hwpt itself or a hwpt automatically created
> + *		for the specified ioas by kernel during the attachment.
> + *
> + * Associate the device with an address space within the bound iommufd.
> + * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.  This is only
> + * allowed on cdev fds.
> + *
> + * If a vfio device is currently attached to a valid hw_pagetable, without doing
> + * a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl
> + * passing in another hw_pagetable (hwpt) id is allowed. This action, also known
> + * as a hw_pagetable replacement, will replace the device's currently attached
> + * hw_pagetable with a new hw_pagetable corresponding to the given pt_id.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_attach_iommufd_pt {
> +	__u32	argsz;
> +	__u32	flags;
> +	__u32	pt_id;
> +};
> +
> +#define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 19)
> +
> +/*
> + * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
> + *					struct vfio_device_detach_iommufd_pt)
> + * @argsz:	User filled size of this data.
> + * @flags:	Must be 0.
> + *
> + * Remove the association of the device and its current associated address
> + * space.  After it, the device should be in a blocking DMA state.  This is only
> + * allowed on cdev fds.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_detach_iommufd_pt {
> +	__u32	argsz;
> +	__u32	flags;
> +};
> +
> +#define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)
> +
> +/*
> + * Provide support for setting a PCI VF Token, which is used as a shared
> + * secret between PF and VF drivers.  This feature may only be set on a
> + * PCI SR-IOV PF when SR-IOV is enabled on the PF and there are no existing
> + * open VFs.  Data provided when setting this feature is a 16-byte array
> + * (__u8 b[16]), representing a UUID.
> + */
> +#define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
> +
> +/*
> + * Indicates the device can support the migration API through
> + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If this GET succeeds, the RUNNING and
> + * ERROR states are always supported. Support for additional states is
> + * indicated via the flags field; at least VFIO_MIGRATION_STOP_COPY must be
> + * set.
> + *
> + * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
> + * RESUMING are supported.
> + *
> + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
> + * is supported in addition to the STOP_COPY states.
> + *
> + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY means that
> + * PRE_COPY is supported in addition to the STOP_COPY states.
> + *
> + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY
> + * means that RUNNING_P2P, PRE_COPY and PRE_COPY_P2P are supported
> + * in addition to the STOP_COPY states.
> + *
> + * Other combinations of flags have behavior to be defined in the future.
> + */
> +struct vfio_device_feature_migration {
> +	__aligned_u64 flags;
> +#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> +#define VFIO_MIGRATION_P2P		(1 << 1)
> +#define VFIO_MIGRATION_PRE_COPY		(1 << 2)
> +};
> +#define VFIO_DEVICE_FEATURE_MIGRATION 1
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, execute a migration state change on the VFIO
> + * device. The new state is supplied in device_state, see enum
> + * vfio_device_mig_state for details
> + *
> + * The kernel migration driver must fully transition the device to the new state
> + * value before the operation returns to the user.
> + *
> + * The kernel migration driver must not generate asynchronous device state
> + * transitions outside of manipulation by the user or the VFIO_DEVICE_RESET
> + * ioctl as described above.
> + *
> + * If this function fails then current device_state may be the original
> + * operating state or some other state along the combination transition path.
> + * The user can then decide if it should execute a VFIO_DEVICE_RESET, attempt
> + * to return to the original state, or attempt to return to some other state
> + * such as RUNNING or STOP.
> + *
> + * If the new_state starts a new data transfer session then the FD associated
> + * with that session is returned in data_fd. The user is responsible to close
> + * this FD when it is finished. The user must consider the migration data stream
> + * carried over the FD to be opaque and must preserve the byte order of the
> + * stream. The user is not required to preserve buffer segmentation when writing
> + * the data stream during the RESUMING operation.
> + *
> + * Upon VFIO_DEVICE_FEATURE_GET, get the current migration state of the VFIO
> + * device, data_fd will be -1.
> + */
> +struct vfio_device_feature_mig_state {
> +	__u32 device_state; /* From enum vfio_device_mig_state */
> +	__s32 data_fd;
> +};
> +#define VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE 2
> +
> +/*
> + * The device migration Finite State Machine is described by the enum
> + * vfio_device_mig_state. Some of the FSM arcs will create a migration data
> + * transfer session by returning a FD, in this case the migration data will
> + * flow over the FD using read() and write() as discussed below.
> + *
> + * There are 5 states to support VFIO_MIGRATION_STOP_COPY:
> + *  RUNNING - The device is running normally
> + *  STOP - The device does not change the internal or external state
> + *  STOP_COPY - The device internal state can be read out
> + *  RESUMING - The device is stopped and is loading a new internal state
> + *  ERROR - The device has failed and must be reset
> + *
> + * And optional states to support VFIO_MIGRATION_P2P:
> + *  RUNNING_P2P - RUNNING, except the device cannot do peer to peer DMA
> + * And VFIO_MIGRATION_PRE_COPY:
> + *  PRE_COPY - The device is running normally but tracking internal state
> + *             changes
> + * And VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY:
> + *  PRE_COPY_P2P - PRE_COPY, except the device cannot do peer to peer DMA
> + *
> + * The FSM takes actions on the arcs between FSM states. The driver implements
> + * the following behavior for the FSM arcs:
> + *
> + * RUNNING_P2P -> STOP
> + * STOP_COPY -> STOP
> + *   While in STOP the device must stop the operation of the device. The device
> + *   must not generate interrupts, DMA, or any other change to external state.
> + *   It must not change its internal state. When stopped the device and kernel
> + *   migration driver must accept and respond to interaction to support external
> + *   subsystems in the STOP state, for example PCI MSI-X and PCI config space.
> + *   Failure by the user to restrict device access while in STOP must not result
> + *   in error conditions outside the user context (ex. host system faults).
> + *
> + *   The STOP_COPY arc will terminate a data transfer session.
> + *
> + * RESUMING -> STOP
> + *   Leaving RESUMING terminates a data transfer session and indicates the
> + *   device should complete processing of the data delivered by write(). The
> + *   kernel migration driver should complete the incorporation of data written
> + *   to the data transfer FD into the device internal state and perform
> + *   final validity and consistency checking of the new device state. If the
> + *   user provided data is found to be incomplete, inconsistent, or otherwise
> + *   invalid, the migration driver must fail the SET_STATE ioctl and
> + *   optionally go to the ERROR state as described below.
> + *
> + *   While in STOP the device has the same behavior as other STOP states
> + *   described above.
> + *
> + *   To abort a RESUMING session the device must be reset.
> + *
> + * PRE_COPY -> RUNNING
> + * RUNNING_P2P -> RUNNING
> + *   While in RUNNING the device is fully operational, the device may generate
> + *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
> + *   and the device may advance its internal state.
> + *
> + *   The PRE_COPY arc will terminate a data transfer session.
> + *
> + * PRE_COPY_P2P -> RUNNING_P2P
> + * RUNNING -> RUNNING_P2P
> + * STOP -> RUNNING_P2P
> + *   While in RUNNING_P2P the device is partially running in the P2P quiescent
> + *   state defined below.
> + *
> + *   The PRE_COPY_P2P arc will terminate a data transfer session.
> + *
> + * RUNNING -> PRE_COPY
> + * RUNNING_P2P -> PRE_COPY_P2P
> + * STOP -> STOP_COPY
> + *   PRE_COPY, PRE_COPY_P2P and STOP_COPY form the "saving group" of states
> + *   which share a data transfer session. Moving between these states alters
> + *   what is streamed in session, but does not terminate or otherwise affect
> + *   the associated fd.
> + *
> + *   These arcs begin the process of saving the device state and will return a
> + *   new data_fd. The migration driver may perform actions such as enabling
> + *   dirty logging of device state when entering PRE_COPY or PER_COPY_P2P.
> + *
> + *   Each arc does not change the device operation, the device remains
> + *   RUNNING, P2P quiesced or in STOP. The STOP_COPY state is described below
> + *   in PRE_COPY_P2P -> STOP_COPY.
> + *
> + * PRE_COPY -> PRE_COPY_P2P
> + *   Entering PRE_COPY_P2P continues all the behaviors of PRE_COPY above.
> + *   However, while in the PRE_COPY_P2P state, the device is partially running
> + *   in the P2P quiescent state defined below, like RUNNING_P2P.
> + *
> + * PRE_COPY_P2P -> PRE_COPY
> + *   This arc allows returning the device to a full RUNNING behavior while
> + *   continuing all the behaviors of PRE_COPY.
> + *
> + * PRE_COPY_P2P -> STOP_COPY
> + *   While in the STOP_COPY state the device has the same behavior as STOP
> + *   with the addition that the data transfers session continues to stream the
> + *   migration state. End of stream on the FD indicates the entire device
> + *   state has been transferred.
> + *
> + *   The user should take steps to restrict access to vfio device regions while
> + *   the device is in STOP_COPY or risk corruption of the device migration data
> + *   stream.
> + *
> + * STOP -> RESUMING
> + *   Entering the RESUMING state starts a process of restoring the device state
> + *   and will return a new data_fd. The data stream fed into the data_fd should
> + *   be taken from the data transfer output of a single FD during saving from
> + *   a compatible device. The migration driver may alter/reset the internal
> + *   device state for this arc if required to prepare the device to receive the
> + *   migration data.
> + *
> + * STOP_COPY -> PRE_COPY
> + * STOP_COPY -> PRE_COPY_P2P
> + *   These arcs are not permitted and return error if requested. Future
> + *   revisions of this API may define behaviors for these arcs, in this case
> + *   support will be discoverable by a new flag in
> + *   VFIO_DEVICE_FEATURE_MIGRATION.
> + *
> + * any -> ERROR
> + *   ERROR cannot be specified as a device state, however any transition request
> + *   can be failed with an errno return and may then move the device_state into
> + *   ERROR. In this case the device was unable to execute the requested arc and
> + *   was also unable to restore the device to any valid device_state.
> + *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
> + *   device_state back to RUNNING.
> + *
> + * The optional peer to peer (P2P) quiescent state is intended to be a quiescent
> + * state for the device for the purposes of managing multiple devices within a
> + * user context where peer-to-peer DMA between devices may be active. The
> + * RUNNING_P2P and PRE_COPY_P2P states must prevent the device from initiating
> + * any new P2P DMA transactions. If the device can identify P2P transactions
> + * then it can stop only P2P DMA, otherwise it must stop all DMA. The migration
> + * driver must complete any such outstanding operations prior to completing the
> + * FSM arc into a P2P state. For the purpose of specification the states
> + * behave as though the device was fully running if not supported. Like while in
> + * STOP or STOP_COPY the user must not touch the device, otherwise the state
> + * can be exited.
> + *
> + * The remaining possible transitions are interpreted as combinations of the
> + * above FSM arcs. As there are multiple paths through the FSM arcs the path
> + * should be selected based on the following rules:
> + *   - Select the shortest path.
> + *   - The path cannot have saving group states as interior arcs, only
> + *     starting/end states.
> + * Refer to vfio_mig_get_next_state() for the result of the algorithm.
> + *
> + * The automatic transit through the FSM arcs that make up the combination
> + * transition is invisible to the user. When working with combination arcs the
> + * user may see any step along the path in the device_state if SET_STATE
> + * fails. When handling these types of errors users should anticipate future
> + * revisions of this protocol using new states and those states becoming
> + * visible in this case.
> + *
> + * The optional states cannot be used with SET_STATE if the device does not
> + * support them. The user can discover if these states are supported by using
> + * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
> + * avoid knowing about these optional states if the kernel driver supports them.
> + *
> + * Arcs touching PRE_COPY and PRE_COPY_P2P are removed if support for PRE_COPY
> + * is not present.
> + */
> +enum vfio_device_mig_state {
> +	VFIO_DEVICE_STATE_ERROR = 0,
> +	VFIO_DEVICE_STATE_STOP = 1,
> +	VFIO_DEVICE_STATE_RUNNING = 2,
> +	VFIO_DEVICE_STATE_STOP_COPY = 3,
> +	VFIO_DEVICE_STATE_RESUMING = 4,
> +	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
> +	VFIO_DEVICE_STATE_PRE_COPY = 6,
> +	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
> +	VFIO_DEVICE_STATE_NR,
> +};
> +
> +/**
> + * VFIO_MIG_GET_PRECOPY_INFO - _IO(VFIO_TYPE, VFIO_BASE + 21)
> + *
> + * This ioctl is used on the migration data FD in the precopy phase of the
> + * migration data transfer. It returns an estimate of the current data sizes
> + * remaining to be transferred. It allows the user to judge when it is
> + * appropriate to leave PRE_COPY for STOP_COPY.
> + *
> + * This ioctl is valid only in PRE_COPY states and kernel driver should
> + * return -EINVAL from any other migration state.
> + *
> + * The vfio_precopy_info data structure returned by this ioctl provides
> + * estimates of data available from the device during the PRE_COPY states.
> + * This estimate is split into two categories, initial_bytes and
> + * dirty_bytes.
> + *
> + * The initial_bytes field indicates the amount of initial precopy
> + * data available from the device. This field should have a non-zero initial
> + * value and decrease as migration data is read from the device.
> + * It is recommended to leave PRE_COPY for STOP_COPY only after this field
> + * reaches zero. Leaving PRE_COPY earlier might make things slower.
> + *
> + * The dirty_bytes field tracks device state changes relative to data
> + * previously retrieved.  This field starts at zero and may increase as
> + * the internal device state is modified or decrease as that modified
> + * state is read from the device.
> + *
> + * Userspace may use the combination of these fields to estimate the
> + * potential data size available during the PRE_COPY phases, as well as
> + * trends relative to the rate the device is dirtying its internal
> + * state, but these fields are not required to have any bearing relative
> + * to the data size available during the STOP_COPY phase.
> + *
> + * Drivers have a lot of flexibility in when and what they transfer during the
> + * PRE_COPY phase, and how they report this from VFIO_MIG_GET_PRECOPY_INFO.
> + *
> + * During pre-copy the migration data FD has a temporary "end of stream" that is
> + * reached when both initial_bytes and dirty_byte are zero. For instance, this
> + * may indicate that the device is idle and not currently dirtying any internal
> + * state. When read() is done on this temporary end of stream the kernel driver
> + * should return ENOMSG from read(). Userspace can wait for more data (which may
> + * never come) by using poll.
> + *
> + * Once in STOP_COPY the migration data FD has a permanent end of stream
> + * signaled in the usual way by read() always returning 0 and poll always
> + * returning readable. ENOMSG may not be returned in STOP_COPY.
> + * Support for this ioctl is mandatory if a driver claims to support
> + * VFIO_MIGRATION_PRE_COPY.
> + *
> + * Return: 0 on success, -1 and errno set on failure.
> + */
> +struct vfio_precopy_info {
> +	__u32 argsz;
> +	__u32 flags;
> +	__aligned_u64 initial_bytes;
> +	__aligned_u64 dirty_bytes;
> +};
> +
> +#define VFIO_MIG_GET_PRECOPY_INFO _IO(VFIO_TYPE, VFIO_BASE + 21)
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
> + * state with the platform-based power management.  Device use of lower power
> + * states depends on factors managed by the runtime power management core,
> + * including system level support and coordinating support among dependent
> + * devices.  Enabling device low power entry does not guarantee lower power
> + * usage by the device, nor is a mechanism provided through this feature to
> + * know the current power state of the device.  If any device access happens
> + * (either from the host or through the vfio uAPI) when the device is in the
> + * low power state, then the host will move the device out of the low power
> + * state as necessary prior to the access.  Once the access is completed, the
> + * device may re-enter the low power state.  For single shot low power support
> + * with wake-up notification, see
> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
> + * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
> + * calling LOW_POWER_EXIT.
> + */
> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
> +
> +/*
> + * This device feature has the same behavior as
> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
> + * provides an eventfd for wake-up notification.  When the device moves out of
> + * the low power state for the wake-up, the host will not allow the device to
> + * re-enter a low power state without a subsequent user call to one of the low
> + * power entry device feature IOCTLs.  Access to mmap'd device regions is
> + * disabled on LOW_POWER_ENTRY_WITH_WAKEUP and may only be resumed after the
> + * low power exit.  The low power exit can happen either through LOW_POWER_EXIT
> + * or through any other access (where the wake-up notification has been
> + * generated).  The access to mmap'd device regions will not trigger low power
> + * exit.
> + *
> + * The notification through the provided eventfd will be generated only when
> + * the device has entered and is resumed from a low power state after
> + * calling this device feature IOCTL.  A device that has not entered low power
> + * state, as managed through the runtime power management core, will not
> + * generate a notification through the provided eventfd on access.  Calling the
> + * LOW_POWER_EXIT feature is optional in the case where notification has been
> + * signaled on the provided eventfd that a resume from low power has occurred.
> + */
> +struct vfio_device_low_power_entry_with_wakeup {
> +	__s32 wakeup_eventfd;
> +	__u32 reserved;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states as
> + * previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
> + * This device feature IOCTL may itself generate a wakeup eventfd notification
> + * in the latter case if the device had previously entered a low power state.
> + */
> +#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET start/stop device DMA logging.
> + * VFIO_DEVICE_FEATURE_PROBE can be used to detect if the device supports
> + * DMA logging.
> + *
> + * DMA logging allows a device to internally record what DMAs the device is
> + * initiating and report them back to userspace. It is part of the VFIO
> + * migration infrastructure that allows implementing dirty page tracking
> + * during the pre copy phase of live migration. Only DMA WRITEs are logged,
> + * and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> + *
> + * When DMA logging is started a range of IOVAs to monitor is provided and the
> + * device can optimize its logging to cover only the IOVA range given. Each
> + * DMA that the device initiates inside the range will be logged by the device
> + * for later retrieval.
> + *
> + * page_size is an input that hints what tracking granularity the device
> + * should try to achieve. If the device cannot do the hinted page size then
> + * it's the driver choice which page size to pick based on its support.
> + * On output the device will return the page size it selected.
> + *
> + * ranges is a pointer to an array of
> + * struct vfio_device_feature_dma_logging_range.
> + *
> + * The core kernel code guarantees to support by minimum num_ranges that fit
> + * into a single kernel page. User space can try higher values but should give
> + * up if the above can't be achieved as of some driver limitations.
> + *
> + * A single call to start device DMA logging can be issued and a matching stop
> + * should follow at the end. Another start is not allowed in the meantime.
> + */
> +struct vfio_device_feature_dma_logging_control {
> +	__aligned_u64 page_size;
> +	__u32 num_ranges;
> +	__u32 __reserved;
> +	__aligned_u64 ranges;
> +};
> +
> +struct vfio_device_feature_dma_logging_range {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_START 6
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
> + */
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 7
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_GET read back and clear the device DMA log
> + *
> + * Query the device's DMA log for written pages within the given IOVA range.
> + * During querying the log is cleared for the IOVA range.
> + *
> + * bitmap is a pointer to an array of u64s that will hold the output bitmap
> + * with 1 bit reporting a page_size unit of IOVA. The mapping of IOVA to bits
> + * is given by:
> + *  bitmap[(addr - iova)/page_size] & (1ULL << (addr % 64))
> + *
> + * The input page_size can be any power of two value and does not have to
> + * match the value given to VFIO_DEVICE_FEATURE_DMA_LOGGING_START. The driver
> + * will format its internal logging to match the reporting page size, possibly
> + * by replicating bits if the internal page size is lower than requested.
> + *
> + * The LOGGING_REPORT will only set bits in the bitmap and never clear or
> + * perform any initialization of the user provided bitmap.
> + *
> + * If any error is returned userspace should assume that the dirty log is
> + * corrupted. Error recovery is to consider all memory dirty and try to
> + * restart the dirty tracking, or to abort/restart the whole migration.
> + *
> + * If DMA logging is not enabled, an error will be returned.
> + *
> + */
> +struct vfio_device_feature_dma_logging_report {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 bitmap;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 8
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_GET read back the estimated data length that will
> + * be required to complete stop copy.
> + *
> + * Note: Can be called on each device state.
> + */
> +
> +struct vfio_device_feature_mig_data_size {
> +	__aligned_u64 stop_copy_length;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_MIG_DATA_SIZE 9
> +
> +/**
> + * Upon VFIO_DEVICE_FEATURE_SET, set or clear the BUS mastering for the device
> + * based on the operation specified in op flag.
> + *
> + * The functionality is incorporated for devices that needs bus master control,
> + * but the in-band device interface lacks the support. Consequently, it is not
> + * applicable to PCI devices, as bus master control for PCI devices is managed
> + * in-band through the configuration space. At present, this feature is supported
> + * only for CDX devices.
> + * When the device's BUS MASTER setting is configured as CLEAR, it will result in
> + * blocking all incoming DMA requests from the device. On the other hand, configuring
> + * the device's BUS MASTER setting as SET (enable) will grant the device the
> + * capability to perform DMA to the host memory.
> + */
> +struct vfio_device_feature_bus_master {
> +	__u32 op;
> +#define		VFIO_DEVICE_FEATURE_CLEAR_MASTER	0	/* Clear Bus Master */
> +#define		VFIO_DEVICE_FEATURE_SET_MASTER		1	/* Set Bus Master */
> +};
> +#define VFIO_DEVICE_FEATURE_BUS_MASTER 10
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**
> @@ -516,7 +1472,70 @@ struct vfio_iommu_type1_info {
>  	__u32	argsz;
>  	__u32	flags;
>  #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
> -	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
> +#define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
> +	__aligned_u64	iova_pgsizes;		/* Bitmap of supported page sizes */
> +	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32   pad;
> +};
> +
> +/*
> + * The IOVA capability allows to report the valid IOVA range(s)
> + * excluding any non-relaxable reserved regions exposed by
> + * devices attached to the container. Any DMA map attempt
> + * outside the valid iova range will return error.
> + *
> + * The structures below define version 1 of this capability.
> + */
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE  1
> +
> +struct vfio_iova_range {
> +	__u64	start;
> +	__u64	end;
> +};
> +
> +struct vfio_iommu_type1_info_cap_iova_range {
> +	struct	vfio_info_cap_header header;
> +	__u32	nr_iovas;
> +	__u32	reserved;
> +	struct	vfio_iova_range iova_ranges[];
> +};
> +
> +/*
> + * The migration capability allows to report supported features for migration.
> + *
> + * The structures below define version 1 of this capability.
> + *
> + * The existence of this capability indicates that IOMMU kernel driver supports
> + * dirty page logging.
> + *
> + * pgsize_bitmap: Kernel driver returns bitmap of supported page sizes for dirty
> + * page logging.
> + * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
> + * size in bytes that can be used by user applications when getting the dirty
> + * bitmap.
> + */
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  2
> +
> +struct vfio_iommu_type1_info_cap_migration {
> +	struct	vfio_info_cap_header header;
> +	__u32	flags;
> +	__u64	pgsize_bitmap;
> +	__u64	max_dirty_bitmap_size;		/* in bytes */
> +};
> +
> +/*
> + * The DMA available capability allows to report the current number of
> + * simultaneously outstanding DMA mappings that are allowed.
> + *
> + * The structure below defines version 1 of this capability.
> + *
> + * avail: specifies the current number of outstanding DMA mappings allowed.
> + */
> +#define VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL 3
> +
> +struct vfio_iommu_type1_info_dma_avail {
> +	struct	vfio_info_cap_header header;
> +	__u32	avail;
>  };
>  
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> @@ -526,12 +1545,21 @@ struct vfio_iommu_type1_info {
>   *
>   * Map process virtual addresses to IO virtual addresses using the
>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
> + *
> + * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
> + * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
> + * maintain memory consistency within the user application, the updated vaddr
> + * must address the same memory object as originally mapped.  Failure to do so
> + * will result in user memory corruption and/or device misbehavior.  iova and
> + * size must match those in the original MAP_DMA call.  Protection is not
> + * changed, and the READ & WRITE flags must be 0.
>   */
>  struct vfio_iommu_type1_dma_map {
>  	__u32	argsz;
>  	__u32	flags;
>  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
>  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
> +#define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
>  	__u64	vaddr;				/* Process virtual address */
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
> @@ -539,6 +1567,12 @@ struct vfio_iommu_type1_dma_map {
>  
>  #define VFIO_IOMMU_MAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 13)
>  
> +struct vfio_bitmap {
> +	__u64        pgsize;	/* page size for bitmap in bytes */
> +	__u64        size;	/* in bytes */
> +	__u64 __user *data;	/* one bit per page */
> +};
> +
>  /**
>   * VFIO_IOMMU_UNMAP_DMA - _IOWR(VFIO_TYPE, VFIO_BASE + 14,
>   *							struct vfio_dma_unmap)
> @@ -548,12 +1582,34 @@ struct vfio_iommu_type1_dma_map {
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
>   * succeed.
> + *
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
> + * before unmapping IO virtual addresses. When this flag is set, the user must
> + * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
> + * memory via vfio_bitmap.data and its size in the vfio_bitmap.size field.
> + * A bit in the bitmap represents one page, of user provided page size in
> + * vfio_bitmap.pgsize field, consecutively starting from iova offset. Bit set
> + * indicates that the page at that offset from iova is dirty. A Bitmap of the
> + * pages in the range of unmapped size is returned in the user-provided
> + * vfio_bitmap.data.
> + *
> + * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
> + * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
> + *
> + * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
> + * virtual addresses in the iova range.  DMA to already-mapped pages continues.
> + * Groups may not be added to the container while any addresses are invalid.
> + * This cannot be combined with the get-dirty-bitmap flag.
>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> +#define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
> +#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
> +	__u8    data[];
>  };
>  
>  #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
> @@ -565,6 +1621,57 @@ struct vfio_iommu_type1_dma_unmap {
>  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
> +/**
> + * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> + *                                     struct vfio_iommu_type1_dirty_bitmap)
> + * IOCTL is used for dirty pages logging.
> + * Caller should set flag depending on which operation to perform, details as
> + * below:
> + *
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_START flag set, instructs
> + * the IOMMU driver to log pages that are dirtied or potentially dirtied by
> + * the device; designed to be used when a migration is in progress. Dirty pages
> + * are logged until logging is disabled by user application by calling the IOCTL
> + * with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
> + *
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag set, instructs
> + * the IOMMU driver to stop logging dirtied pages.
> + *
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set
> + * returns the dirty pages bitmap for IOMMU container for a given IOVA range.
> + * The user must specify the IOVA range and the pgsize through the structure
> + * vfio_iommu_type1_dirty_bitmap_get in the data[] portion. This interface
> + * supports getting a bitmap of the smallest supported pgsize only and can be
> + * modified in future to get a bitmap of any specified supported pgsize. The
> + * user must provide a zeroed memory area for the bitmap memory and specify its
> + * size in bitmap.size. One bit is used to represent one page consecutively
> + * starting from iova offset. The user should provide page size in bitmap.pgsize
> + * field. A bit set in the bitmap indicates that the page at that offset from
> + * iova is dirty. The caller must set argsz to a value including the size of
> + * structure vfio_iommu_type1_dirty_bitmap_get, but excluding the size of the
> + * actual bitmap. If dirty pages logging is not enabled, an error will be
> + * returned.
> + *
> + * Only one of the flags _START, _STOP and _GET may be specified at a time.
> + *
> + */
> +struct vfio_iommu_type1_dirty_bitmap {
> +	__u32        argsz;
> +	__u32        flags;
> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_START	(1 << 0)
> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP	(1 << 1)
> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP	(1 << 2)
> +	__u8         data[];
> +};
> +
> +struct vfio_iommu_type1_dirty_bitmap_get {
> +	__u64              iova;	/* IO virtual address */
> +	__u64              size;	/* Size of iova range */
> +	struct vfio_bitmap bitmap;
> +};
> +
> +#define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*
> @@ -716,4 +1823,4 @@ struct vfio_iommu_spapr_tce_remove {
>  
>  /* ***************************************************************** */
>  
> -#endif /* VFIO_H */
> +#endif /* _UAPIVFIO_H */
> -- 
> 2.43.0
> 

