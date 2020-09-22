Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6AA274006
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 12:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIVKy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 06:54:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbgIVKyY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 06:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600772062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dpEhdICvzGe/Q7jOr7ZqeEuz8h6Dl2ELME+BxUXl1pc=;
        b=J88WeBsNe3RqGRIbZS/A0n626FtMvdkoo+aJ815wIra820eNojjrVkfO7AwglxV9sYXOd6
        c9zfGBTkuPnDeAsIHx7XscPiOQowDDCRkZI5ggPhRKRxB5hEncbImKGhmuoX6RcdBmjkFw
        3n2jERFA1TsZfDsFP7ILdMrN+EmL9uY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-aCb-NBV0PgezXXKXYSHEhw-1; Tue, 22 Sep 2020 06:54:18 -0400
X-MC-Unique: aCb-NBV0PgezXXKXYSHEhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CF601007479;
        Tue, 22 Sep 2020 10:54:17 +0000 (UTC)
Received: from gondolin (ovpn-112-114.ams2.redhat.com [10.36.112.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B91A78803;
        Tue, 22 Sep 2020 10:54:11 +0000 (UTC)
Date:   Tue, 22 Sep 2020 12:54:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] vfio-pci/zdev: define the vfio_zdev header
Message-ID: <20200922125409.4127797c.cohuck@redhat.com>
In-Reply-To: <1600529318-8996-4-git-send-email-mjrosato@linux.ibm.com>
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
        <1600529318-8996-4-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 19 Sep 2020 11:28:37 -0400
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
>  include/uapi/linux/vfio_zdev.h | 116 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 121 insertions(+)
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

This is not really for a 10de vendor, but for all pci devices accessed
via zpci, isn't it?

We obviously want to avoid collisions here; not really sure how to
cover all possible vendors. Maybe just pick a high number?

>  
>  /* sub-types for VFIO_REGION_TYPE_GFX */
>  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> new file mode 100644
> index 0000000..c9e4891
> --- /dev/null
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -0,0 +1,116 @@
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

"CLP features" == "features returned by the CLP instruction", I guess?
Maybe mention that explicitly?

> + * defined below. argsz provides the size of the entire region, and offset
> + * provides the location of the first CLP feature in the chain.
> + *
> + */
> +struct vfio_region_zpci_info {
> +	__u32 argsz;		/* Size of entire payload */
> +	__u32 offset;		/* Location of first entry */
> +} __packed;

This '__packed' annotation seems redundant. I think that all of these
structures should be defined in a way that packing is unneeded (which
seems to be the case on a quick browse.)

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

s/it's/its/

Is the 'id' something that is already provided by the CLP instruction?

> + */
> +struct vfio_region_zpci_info_hdr {
> +	__u16 id;		/* Identifies the CLP type */
> +	__u16	version;	/* version of the CLP data */
> +	__u32 next;		/* Offset of next entry */
> +} __packed;
> +
> +/**
> + * struct vfio_region_zpci_info_qpci - Initial Query PCI information
> + *
> + * This region provides an initial set of data from the Query PCI Function

What does 'initial' mean in this context? Information you get for a
freshly initialized function?

> + * CLP.
> + */
> +#define VFIO_REGION_ZPCI_INFO_QPCI	1
> +
> +struct vfio_region_zpci_info_qpci {
> +	struct vfio_region_zpci_info_hdr hdr;
> +	__u64 start_dma;	/* Start of available DMA addresses */
> +	__u64 end_dma;		/* End of available DMA addresses */
> +	__u16 pchid;		/* Physical Channel ID */
> +	__u16 vfn;		/* Virtual function number */
> +	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
> +	__u8 pft;		/* PCI Function Type */
> +	__u8 gid;		/* PCI function group ID */
> +} __packed;
> +
> +
> +/**
> + * struct vfio_region_zpci_info_qpcifg - Initial Query PCI Function Group info
> + *
> + * This region provides an initial set of data from the Query PCI Function
> + * Group CLP.
> + */
> +#define VFIO_REGION_ZPCI_INFO_QPCIFG	2
> +
> +struct vfio_region_zpci_info_qpcifg {
> +	struct vfio_region_zpci_info_hdr hdr;
> +	__u64 dasm;		/* DMA Address space mask */
> +	__u64 msi_addr;		/* MSI address */
> +	__u64 flags;
> +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1 /* Use program-specified TLB refresh */
> +	__u16 mui;		/* Measurement Block Update Interval */
> +	__u16 noi;		/* Maximum number of MSIs */
> +	__u16 maxstbl;		/* Maximum Store Block Length */
> +	__u8 version;		/* Supported PCI Version */
> +} __packed;
> +
> +/**
> + * struct vfio_region_zpci_info_util - Utility String
> + *
> + * This region provides the utility string for the associated device, which is
> + * a device identifier string.

Is there an upper boundary for this string?

Is this a classic NUL-terminated string, or a list of EBCDIC characters?

> + */
> +#define VFIO_REGION_ZPCI_INFO_UTIL	3
> +
> +struct vfio_region_zpci_info_util {
> +	struct vfio_region_zpci_info_hdr hdr;
> +	__u32 size;
> +	__u8 util_str[];
> +} __packed;
> +
> +/**
> + * struct vfio_region_zpci_info_pfip - PCI Function Path
> + *
> + * This region provides the PCI function path string, which is an identifier
> + * that describes the internal hardware path of the device.

Same question here.

> + */
> +#define VFIO_REGION_ZPCI_INFO_PFIP	4
> +
> +struct vfio_region_zpci_info_pfip {
> +struct vfio_region_zpci_info_hdr hdr;
> +	__u32 size;
> +	__u8 pfip[];
> +} __packed;
> +
> +#endif

