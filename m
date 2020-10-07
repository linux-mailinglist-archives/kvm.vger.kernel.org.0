Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E740B2868F6
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJGUWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:22:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbgJGUWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 16:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602102119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZDrXh4cE65yGFS+V0oC4Ce+GkKCDRoNl54roC654jNU=;
        b=AH7hhy1firtKrBSSe+Y8XmqdmOff7htEcBcDRr6te4pDgSTlw5A1KaEE9X5uWH14Fm/HBq
        iE/vPo6C4+QnZAUpUQaMoysdyQL/HzwebDgrDi/iQn6t7H1OyCtJpvpceIgRIFLGFPM5m9
        DS+DcCyhdML9SjYcdf+3anm+wZ5dezY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-FOuCiWzlNRyN4XHwLZNBSA-1; Wed, 07 Oct 2020 16:21:54 -0400
X-MC-Unique: FOuCiWzlNRyN4XHwLZNBSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 193678070FD;
        Wed,  7 Oct 2020 20:21:52 +0000 (UTC)
Received: from w520.home (ovpn-113-244.phx2.redhat.com [10.3.113.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60D245D9DD;
        Wed,  7 Oct 2020 20:21:51 +0000 (UTC)
Date:   Wed, 7 Oct 2020 14:21:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] vfio: Introduce capability definitions for
 VFIO_DEVICE_GET_INFO
Message-ID: <20201007142150.44773a1f@w520.home>
In-Reply-To: <1602096984-13703-4-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
        <1602096984-13703-4-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 14:56:22 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Allow the VFIO_DEVICE_GET_INFO ioctl to include a capability chain.
> Add a flag indicating capability chain support, and introduce the
> definitions for the first set of capabilities which are specified to
> s390 zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  include/uapi/linux/vfio.h      | 11 ++++++
>  include/uapi/linux/vfio_zdev.h | 78 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+)
>  create mode 100644 include/uapi/linux/vfio_zdev.h
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9204705..836a25b 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -201,8 +201,10 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>  #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
>  #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
> +#define VFIO_DEVICE_FLAGS_CAPS	(1 << 6)	/* Info supports caps */


FYI, I'm going to change this to (1 << 7) because the new fsl-mc bus
driver patches are claiming a new device type with (1 << 6) and I don't
want the conflict to be magically resolved on merge.  Thanks,

Alex

>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
> +	__u32   cap_offset;	/* Offset within info struct of first cap */
>  };
>  #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
>  
> @@ -218,6 +220,15 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_API_CCW_STRING		"vfio-ccw"
>  #define VFIO_DEVICE_API_AP_STRING		"vfio-ap"
>  
> +/*
> + * The following capabilities are unique to s390 zPCI devices.  Their contents
> + * are further-defined in vfio_zdev.h
> + */
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_BASE		1
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_GROUP		2
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_UTIL		3
> +#define VFIO_DEVICE_INFO_CAP_ZPCI_PFIP		4
> +
>  /**
>   * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
>   *				       struct vfio_region_info)
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> new file mode 100644
> index 0000000..b430939
> --- /dev/null
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * VFIO Region definitions for ZPCI devices
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
> +#include <linux/vfio.h>
> +
> +/**
> + * VFIO_DEVICE_INFO_CAP_ZPCI_BASE - Base PCI Function information
> + *
> + * This capability provides a set of descriptive information about the
> + * associated PCI function.
> + */
> +struct vfio_device_info_cap_zpci_base {
> +	struct vfio_info_cap_header header;
> +	__u64 start_dma;	/* Start of available DMA addresses */
> +	__u64 end_dma;		/* End of available DMA addresses */
> +	__u16 pchid;		/* Physical Channel ID */
> +	__u16 vfn;		/* Virtual function number */
> +	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
> +	__u8 pft;		/* PCI Function Type */
> +	__u8 gid;		/* PCI function group ID */
> +};
> +
> +/**
> + * VFIO_DEVICE_INFO_CAP_ZPCI_GROUP - Base PCI Function Group information
> + *
> + * This capability provides a set of descriptive information about the group of
> + * PCI functions that the associated device belongs to.
> + */
> +struct vfio_device_info_cap_zpci_group {
> +	struct vfio_info_cap_header header;
> +	__u64 dasm;		/* DMA Address space mask */
> +	__u64 msi_addr;		/* MSI address */
> +	__u64 flags;
> +#define VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH 1 /* Program-specified TLB refresh */
> +	__u16 mui;		/* Measurement Block Update Interval */
> +	__u16 noi;		/* Maximum number of MSIs */
> +	__u16 maxstbl;		/* Maximum Store Block Length */
> +	__u8 version;		/* Supported PCI Version */
> +};
> +
> +/**
> + * VFIO_DEVICE_INFO_CAP_ZPCI_UTIL - Utility String
> + *
> + * This capability provides the utility string for the associated device, which
> + * is a device identifier string made up of EBCDID characters.  'size' specifies
> + * the length of 'util_str'.
> + */
> +struct vfio_device_info_cap_zpci_util {
> +	struct vfio_info_cap_header header;
> +	__u32 size;
> +	__u8 util_str[];
> +};
> +
> +/**
> + * VFIO_DEVICE_INFO_CAP_ZPCI_PFIP - PCI Function Path
> + *
> + * This capability provides the PCI function path string, which is an identifier
> + * that describes the internal hardware path of the device. 'size' specifies
> + * the length of 'pfip'.
> + */
> +struct vfio_device_info_cap_zpci_pfip {
> +	struct vfio_info_cap_header header;
> +	__u32 size;
> +	__u8 pfip[];
> +};
> +
> +#endif

