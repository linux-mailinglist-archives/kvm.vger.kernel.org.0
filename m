Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6193C2740AB
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 13:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgIVLW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 07:22:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726606AbgIVLWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 07:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600773773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yWqXgKVOudzHOxmvqx4hQrEHAN/p0LKKU63yuRXDEKo=;
        b=QqHuGPPaQvfTLtUe2hv4cyTZdYji4x5V4V+7SH1GJJoGzJxJ41NTGV93T0+Hrkp6BRvel4
        M6jIGov58w/5TzhHaxtYfSS1Y2uhDJekZX/A6Gr5VOLOgeNTV9A5736nFcMN0tbfPU7gGm
        7wpwXZvCwmGPXVHLpMWGpTPF/VR27HA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239--ZDd0ej0N_e3pIzmhaBPTA-1; Tue, 22 Sep 2020 07:22:49 -0400
X-MC-Unique: -ZDd0ej0N_e3pIzmhaBPTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15F1A800469;
        Tue, 22 Sep 2020 11:22:47 +0000 (UTC)
Received: from gondolin (ovpn-112-114.ams2.redhat.com [10.36.112.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAC5B614F5;
        Tue, 22 Sep 2020 11:22:41 +0000 (UTC)
Date:   Tue, 22 Sep 2020 13:22:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio-pci/zdev: use a device region to retrieve zPCI
 information
Message-ID: <20200922132239.4be1e749.cohuck@redhat.com>
In-Reply-To: <1600529318-8996-5-git-send-email-mjrosato@linux.ibm.com>
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
        <1600529318-8996-5-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 19 Sep 2020 11:28:38 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Define a new configuration entry VFIO_PCI_ZDEV for VFIO/PCI.
> 
> When this s390-only feature is configured we initialize a new device
> region, VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP, to hold information provided
> by the underlying hardware.
> 
> This patch is based on work previously done by Pierre Morel.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig            |  13 ++
>  drivers/vfio/pci/Makefile           |   1 +
>  drivers/vfio/pci/vfio_pci.c         |   8 ++
>  drivers/vfio/pci/vfio_pci_private.h |  10 ++
>  drivers/vfio/pci/vfio_pci_zdev.c    | 242 ++++++++++++++++++++++++++++++++++++

Maybe you want to add yourself to MAINTAINERS for the zdev-specific
files? You're probably better suited to review changes to the
zpci-specific code :)

>  5 files changed, 274 insertions(+)
>  create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c

(...)

> +int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
> +{
> +	struct vfio_region_zpci_info *region;
> +	struct zpci_dev *zdev;
> +	size_t clp_offset;
> +	int size;
> +	int ret;
> +
> +	if (!vdev->pdev->bus)
> +		return -ENODEV;
> +
> +	zdev = to_zpci(vdev->pdev);
> +	if (!zdev)
> +		return -ENODEV;
> +
> +	/* Calculate size needed for all supported CLP features  */
> +	size = sizeof(*region) +
> +	       sizeof(struct vfio_region_zpci_info_qpci) +
> +	       sizeof(struct vfio_region_zpci_info_qpcifg) +
> +	       (sizeof(struct vfio_region_zpci_info_util) + CLP_UTIL_STR_LEN) +
> +	       (sizeof(struct vfio_region_zpci_info_pfip) +
> +		CLP_PFIP_NR_SEGMENTS);
> +
> +	region = kmalloc(size, GFP_KERNEL);
> +	if (!region)
> +		return -ENOMEM;
> +
> +	/* Fill in header */
> +	region->argsz = size;
> +	clp_offset = region->offset = sizeof(struct vfio_region_zpci_info);
> +
> +	/* Fill the supported CLP features */
> +	clp_offset = vfio_pci_zdev_add_qpci(zdev, region, clp_offset);
> +	clp_offset = vfio_pci_zdev_add_qpcifg(zdev, region, clp_offset);
> +	clp_offset = vfio_pci_zdev_add_util(zdev, region, clp_offset);
> +	clp_offset = vfio_pci_zdev_add_pfip(zdev, region, clp_offset);

So, the regions are populated once. Can any of the values in the
hardware structures be modified by a guest? Or changed from the
hardware side?

> +
> +	ret = vfio_pci_register_dev_region(vdev,
> +		PCI_VENDOR_ID_IBM | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
> +		VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP, &vfio_pci_zdev_regops,
> +		size, VFIO_REGION_INFO_FLAG_READ, region);
> +	if (ret)
> +		kfree(region);
> +
> +	return ret;
> +}

