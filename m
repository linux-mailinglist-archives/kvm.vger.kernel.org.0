Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E56321E04
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhBVRXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:23:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16415 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhBVRXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 12:23:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6033e8590002>; Mon, 22 Feb 2021 09:22:33 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 17:22:33 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 22 Feb 2021 17:22:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oC06WsMuW2cuPpSzw9TxGE4wqIU+w9HsD03TSDXMHvHU4aueeW/d+jh1yXtcCV07lTON2VLllqoern4+kb+2G4pYFHZbZa5tUTI+b1TxdBiWF8M7J23x6AZE+/fYh5qJRQEQZ/vP0qwfxcjSO3KLPWPEy2yY5YvTW8uMpdvRiWlKfSpGsHhyyU7asIBYNG01yTNGh/ETdFevn8fVUtNyL0HbYYw8z48id/m/9ja8glMuuj87/5+h0VsXRO/lSg4v106Ujoj2StlhakcOFpW8CygFLsArPDxfaIqjTXmqJ4elP9ZIuSGFHNgQVGVdQqkSxU4ESouT3vGs1JDnqm1Big==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8sLryL/ZP0p1XdKIDarogJY/SJmBjUcOL4B+1Amq78=;
 b=XfvOjF9LQdtXLv03M1lHqpZ7umZ6nYHZZi+hDPnjUZABn/0mvpf7sxM7OE6f7VXvDP7t6X0o8jr1E0wf8QIJILv6l/mkvLElE1iFBbMD+/tGj0ReawwCZmiPsCbI6S65GLtlJg8vEVBKg0/T48edTPEot35H31YrV+ApFh98P04m/B0t7RJF7CFyHURW6m+y2Q9PqhVKdyBUt5sxZlMeJ8UOsEQTCtOJf96eELTQvPEMVfryIGIouSTcbcMKvwIVQ3uUKVC4S3A3JNz23CFgr5a9v7QIuP+28uyvx2AdBO8T4/qNjAhAoszQ7MYE+4arv3CPyriNenbBoP5QSsn16g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3516.namprd12.prod.outlook.com (2603:10b6:5:18b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Mon, 22 Feb
 2021 17:22:32 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.045; Mon, 22 Feb 2021
 17:22:32 +0000
Date:   Mon, 22 Feb 2021 13:22:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 04/10] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210222172230.GO4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401267316.16443.11184767955094847849.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161401267316.16443.11184767955094847849.stgit@gimli.home>
X-ClientProxiedBy: BL1PR13CA0484.namprd13.prod.outlook.com
 (2603:10b6:208:2c7::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0484.namprd13.prod.outlook.com (2603:10b6:208:2c7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.8 via Frontend Transport; Mon, 22 Feb 2021 17:22:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEEuk-00ESeq-HZ; Mon, 22 Feb 2021 13:22:30 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614014553; bh=y8sLryL/ZP0p1XdKIDarogJY/SJmBjUcOL4B+1Amq78=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=M8PkYZHeehhlIpFDPc1qr9UDSnMTIO1DR08Hei0HN/HnmfLC3FPsUsVkb2lEHhkGx
         Jqvf2704mv0NO5/C47eoV1CPHW0kQD4urSfMNP+DB51apkmN0cg9G6xLhmv80Ipgyu
         F3Y4YGRf9uAmf5x0ixuKEWPXFxpwl/GXcPSwZzmQos4beS92d27osDTfnBhkNG1LxM
         7lLngyM5GBf7UmwgRoNMut0CL9ml206jza/wLGUCG+mUU+UQhSnFK/DNpOcscC3Fxk
         O5D7tmP1sjuTNT1yMfrKt765MZTXRTtXAvMTg5N/exCYoilith0dCtJKDf9PcyImUb
         w4KuT14rFKcIw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 09:51:13AM -0700, Alex Williamson wrote:

> +	vfio_device_unmap_mapping_range(vdev->device,
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));

Isn't this the same as invalidating everything? I see in
vfio_pci_mmap():

	if (index >= VFIO_PCI_ROM_REGION_INDEX)
		return -EINVAL;

> @@ -2273,15 +2112,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
>  
>  	vdev = vfio_device_data(device);
>  
> -	/*
> -	 * Locking multiple devices is prone to deadlock, runaway and
> -	 * unwind if we hit contention.
> -	 */
> -	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
> +	if (!down_write_trylock(&vdev->memory_lock)) {
>  		vfio_device_put(device);
>  		return -EBUSY;
>  	}

And this is only done as part of VFIO_DEVICE_PCI_HOT_RESET?

It looks like VFIO_DEVICE_PCI_HOT_RESET effects the entire slot?

How about putting the inode on the reflck structure, which is also
per-slot, and then a single unmap_mapping_range() will take care of
everything, no need to iterate over things in the driver core.

Note the vm->pg_off space doesn't have any special meaning, it is
fine that two struct vfio_pci_device's are sharing the same address
space and using an incompatible overlapping pg_offs

> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 9cd1882a05af..ba37f4eeefd0 100644
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -101,6 +101,7 @@ struct vfio_pci_mmap_vma {
>  
>  struct vfio_pci_device {
>  	struct pci_dev		*pdev;
> +	struct vfio_device	*device;

Ah, I did this too, but I didn't use a pointer :)

All the places trying to call vfio_device_put() when they really want
a vfio_pci_device * become simpler now. Eg struct vfio_devices wants
to have an array of vfio_pci_device, and get_pf_vdev() only needs to
return one pointer.

Jason
