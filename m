Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755CB281DC7
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 23:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJBVo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 17:44:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgJBVo0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 17:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601675064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dIUcpI90aSUwNTpPMvVsD/mHHXAF5R2q8TjeCL/HeFE=;
        b=OYSBnC2pNHdxTCldN/IhS04jfsOT5f/qkUFV0IawJ6jD0x2VsDP6zeqQijklVWdRQzOwKM
        6eSt5bYikRt4RlIwmiH61emU0zXzNZi3XRGIz7D5EBB0rrfKeeMQSTfvdefyzXAa1cFYmF
        H6o1EzY+t2vYbNQ3Gdeg4JjsGYU7Zto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-A2XFeJ3kMfmQGEod4k17Tw-1; Fri, 02 Oct 2020 17:44:20 -0400
X-MC-Unique: A2XFeJ3kMfmQGEod4k17Tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF451803F74;
        Fri,  2 Oct 2020 21:44:18 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 400FB55793;
        Fri,  2 Oct 2020 21:44:18 +0000 (UTC)
Date:   Fri, 2 Oct 2020 15:44:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] vfio-pci/zdev: define the vfio_zdev header
Message-ID: <20201002154417.20c2a7ef@x1.home>
In-Reply-To: <1601668844-5798-4-git-send-email-mjrosato@linux.ibm.com>
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
        <1601668844-5798-4-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 16:00:42 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> We define a new device region in vfio.h to be able to get the ZPCI CLP
> information by reading this region from userspace.
> 
> We create a new file, vfio_zdev.h to define the structure of the new
> region defined in vfio.h
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  include/uapi/linux/vfio.h      |   5 ++
>  include/uapi/linux/vfio_zdev.h | 118 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 123 insertions(+)
>  create mode 100644 include/uapi/linux/vfio_zdev.h
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9204705..65eb367 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -326,6 +326,11 @@ struct vfio_region_info_cap_type {
>   * to do TLB invalidation on a GPU.
>   */
>  #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
> +/*
> + * IBM zPCI specific hardware feature information for a devcie.  The contents
> + * of this region are mapped by struct vfio_region_zpci_info.
> + */
> +#define VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP	(2)
>  
>  /* sub-types for VFIO_REGION_TYPE_GFX */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> new file mode 100644
> index 0000000..1c8fb62
> --- /dev/null
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -0,0 +1,118 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Region definition for ZPCI devices
> + *
> + * Copyright IBM Corp. 2020
> + *
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *            Matthew Rosato <mjrosato@linux.ibm.com>
> + */
> +
> +#ifndef _VFIO_ZDEV_H_
> +#define _VFIO_ZDEV_H_
> +
> +#include <linux/types.h>
> +
> +/**
> + * struct vfio_region_zpci_info - ZPCI information
> + *
> + * This region provides zPCI specific hardware feature information for a
> + * device.
> + *
> + * The ZPCI information structure is presented as a chain of CLP features
> + * defined below. argsz provides the size of the entire region, and offset
> + * provides the location of the first CLP feature in the chain.
> + *
> + */
> +struct vfio_region_zpci_info {
> +	__u32 argsz;		/* Size of entire payload */
> +	__u32 offset;		/* Location of first entry */
> +};
> +
> +/**
> + * struct vfio_region_zpci_info_hdr - ZPCI header information
> + *
> + * This structure is included at the top of each CLP feature to define what
> + * type of CLP feature is presented / the structure version. The next value
> + * defines the offset of the next CLP feature, and is an offset from the very
> + * beginning of the region (vfio_region_zpci_info).
> + *
> + * Each CLP feature must have it's own unique 'id'.
> + */
> +struct vfio_region_zpci_info_hdr {
> +	__u16 id;		/* Identifies the CLP type */
> +	__u16	version;	/* version of the CLP data */
> +	__u32 next;		/* Offset of next entry */
> +};
> +
> +/**
> + * struct vfio_region_zpci_info_pci - Base PCI Function information
> + *
> + * This region provides a set of descriptive information about the associated
> + * PCI function.
> + */
> +#define VFIO_REGION_ZPCI_INFO_BASE	1
> +
> +struct vfio_region_zpci_info_base {
> +	struct vfio_region_zpci_info_hdr hdr;
> +	__u64 start_dma;	/* Start of available DMA addresses */
> +	__u64 end_dma;		/* End of available DMA addresses */
> +	__u16 pchid;		/* Physical Channel ID */
> +	__u16 vfn;		/* Virtual function number */
> +	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
> +	__u8 pft;		/* PCI Function Type */
> +	__u8 gid;		/* PCI function group ID */
> +};
> +
> +
> +/**
> + * struct vfio_region_zpci_info_group - Base PCI Function Group information
> + *
> + * This region provides a set of descriptive information about the group of PCI
> + * functions that the associated device belongs to.
> + */
> +#define VFIO_REGION_ZPCI_INFO_GROUP	2
> +
> +struct vfio_region_zpci_info_group {
> +	struct vfio_region_zpci_info_hdr hdr;
> +	__u64 dasm;		/* DMA Address space mask */
> +	__u64 msi_addr;		/* MSI address */
> +	__u64 flags;
> +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1 /* Use program-specified TLB refresh */
> +	__u16 mui;		/* Measurement Block Update Interval */
> +	__u16 noi;		/* Maximum number of MSIs */
> +	__u16 maxstbl;		/* Maximum Store Block Length */
> +	__u8 version;		/* Supported PCI Version */
> +};
> +
> +/**
> + * struct vfio_region_zpci_info_util - Utility String
> + *
> + * This region provides the utility string for the associated device, which is
> + * a device identifier string made up of EBCDID characters.  'size' specifies
> + * the length of 'util_str'.
> + */
> +#define VFIO_REGION_ZPCI_INFO_UTIL	3
> +
> +struct vfio_region_zpci_info_util {
> +	struct vfio_region_zpci_info_hdr hdr;
> +	__u32 size;
> +	__u8 util_str[];
> +};
> +
> +/**
> + * struct vfio_region_zpci_info_pfip - PCI Function Path
> + *
> + * This region provides the PCI function path string, which is an identifier
> + * that describes the internal hardware path of the device. 'size' specifies
> + * the length of 'pfip'.
> + */
> +#define VFIO_REGION_ZPCI_INFO_PFIP	4
> +
> +struct vfio_region_zpci_info_pfip {
> +struct vfio_region_zpci_info_hdr hdr;
> +	__u32 size;
> +	__u8 pfip[];
> +};
> +
> +#endif

Can you discuss why a region with embedded capability chain is a better
solution than extending the VFIO_DEVICE_GET_INFO ioctl to support a
capability chain and providing this info there?  This all appears to be
read-only info, so what's the benefit of duplicating yet another
capability chain in a region?  It would also be possible to define four
separate device specific regions, one for each of these capabilities
rather than creating this chain.  It just seems like a strange approach
TBH.  Thanks,

Alex

