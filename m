Return-Path: <kvm+bounces-33678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BE29EFFBC
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 00:01:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A210728328F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14FE1DE4FF;
	Thu, 12 Dec 2024 23:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwuDMNtb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23611153800
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 23:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734044455; cv=none; b=V9hMmLreApwz8ZSMD1qMuCtKTiOAwRAq4UMtYwCBr8aUVfWYpp7zK5/HD7SCHxw/7mET9qioZmyW+2v0VhJ8QbLd0pEDP5YQBfKI7nW3TCLwysbqZVyZlY6KPn6q/O66txC1gwgXJbt88xWhMDrAviwZ2fXPoUn9qz4agHp7oO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734044455; c=relaxed/simple;
	bh=POweKR+oQWm79y6ZIx54huzt4wDLXVfmR5iAl/hBXto=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9kgrFxT6WNEFSXUUTQ0Bs60KXDEVpNq4kdtDp9HJ7SwjaMw+AXBevo02K1TGjzIwPpD8dc9avq5CUup1a+aG5xP+NmcDFZQgIdkLpPrGw/DKuEwjuEviBFHDl3P45fDn3roejFoXN2e750pI5LuA2q9/mRXa5QNSIfIxsInYR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MwuDMNtb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734044451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7XBtDygKdM3mSZBwxLArXSK70He1n+QHay7eKi5azak=;
	b=MwuDMNtblIsu/Cc7WFpGdruzfAwlo4QXevlIyqduOyMwQzXzhdqNMGrVxxnFeu/DG4PxPC
	H6ygD6cMSByvADcMwdZGJoMFfrwgIrBkoHW42rdymMEM0Igx5kkUQdFNmSgb+FZoSNQW+/
	61cPA5U+ETwV5ylManYghrQfxpBksPw=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-xne2Xr5-PWOas5MyUaYafA-1; Thu, 12 Dec 2024 18:00:50 -0500
X-MC-Unique: xne2Xr5-PWOas5MyUaYafA-1
X-Mimecast-MFC-AGG-ID: xne2Xr5-PWOas5MyUaYafA
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83b7cce903cso6418039f.2
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 15:00:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734044450; x=1734649250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XBtDygKdM3mSZBwxLArXSK70He1n+QHay7eKi5azak=;
        b=i3nyM6oWzgvXEQDd69Nsv+1FaNo2QYey9RpLGnNhhLMp0yYlyz1JCugNkBc6GT9QtI
         qw0ONKN2Tm7XyzAyUCUiyN2SMoNXkIE/z8bo0GU5reC5G7xboTVAt/mbf9cxJjCoOFCS
         iydeR6+2RP8nCaVx1pBHe0AZaQTVO3zXm4t21dtpNmKPRPsg/7j9N+AoxPbgzB6kLCnE
         /cS7l1vTYg143F/jzTLoBA9WMMoSpkOzP6A9BNmNePsgTOStfbUhmL5758Hfmf/y3Dds
         hxpQUuIvT7AbOX2iLr/66tIycKVeQ5UcfJnjEpImMGCF22IK1xmZ1TjtblI4g2kUlLCu
         FdeQ==
X-Gm-Message-State: AOJu0YzFIZWrgyWJZvpofIlwIIpcqwVRuWlX9diZRIQ4Roi5q/YxDtLJ
	FEbwcKQLomZcfjT1NK0A1o1F96rZGMNrBa338oCakqIOxUsQHyuQEFmPIIymhrxvchRGV9tVVkX
	S5LN31bF/ciMZ+cT0FOnpyByV1OzpvdggDTXQDaN5HO60hRdPGw==
X-Gm-Gg: ASbGncv0n/yPshDkPsWQK8OLjzb2wOuiUMQqH9b7s4KODDTFaGApl1Cyh8FNxa5b0h5
	OTdBFgQ0xBDFVcEGoUefd3+7zW0C+ylUwQvUUd/Qeq/KdpY0MLT5xntKbUDqq4yzXmo+Z/4KJVL
	zXUNKMzAckQQLgzFLytJIiUc0CcOjZI5lzRRdRUTsKo32vIjqb5lDC6CHkCXD0wq6QDYQ9jtEas
	Qwqg/pzrvG74Q1fmbycYoXCG9V8jMvw5mzwUM1rcgOvAg3rIe8Lghk5b8vW
X-Received: by 2002:a92:c248:0:b0:3a7:bfad:5032 with SMTP id e9e14a558f8ab-3afeda2ec75mr1714305ab.1.1734044450029;
        Thu, 12 Dec 2024 15:00:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3ygWV263dn1mSnvphnYMpQmK5x7SPwwquGoo5b5qgP1bdCLIh79fu2gpZUeeOztuHiLVElA==
X-Received: by 2002:a92:c248:0:b0:3a7:bfad:5032 with SMTP id e9e14a558f8ab-3afeda2ec75mr1714225ab.1.1734044449677;
        Thu, 12 Dec 2024 15:00:49 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a814886a1fsm38900965ab.58.2024.12.12.15.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 15:00:49 -0800 (PST)
Date: Thu, 12 Dec 2024 16:00:47 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yunxiang Li <Yunxiang.Li@amd.com>
Cc: <kvm@vger.kernel.org>, <kevin.tian@intel.com>, <yishaih@nvidia.com>,
 <ankita@nvidia.com>, <jgg@ziepe.ca>
Subject: Re: [PATCH 3/3] vfio/pci: Expose setup ROM at ROM bar when needed
Message-ID: <20241212160047.09bbe902.alex.williamson@redhat.com>
In-Reply-To: <20241212205050.5737-3-Yunxiang.Li@amd.com>
References: <20241212205050.5737-1-Yunxiang.Li@amd.com>
	<20241212205050.5737-3-Yunxiang.Li@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Dec 2024 15:50:50 -0500
Yunxiang Li <Yunxiang.Li@amd.com> wrote:

> If ROM bar is missing for any reason, we can fallback to using pdev->rom
> to expose the ROM content to the guest. This fixes some passthrough use
> cases where the upstream bridge does not have enough address window.
> 
> Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |  4 ++++
>  drivers/vfio/pci/vfio_pci_core.c   | 35 +++++++++++++++---------------
>  drivers/vfio/pci/vfio_pci_rdwr.c   | 14 ++++++++++--
>  3 files changed, 34 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index e41c3a965663e..4c673d842fb35 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -511,6 +511,10 @@ static void vfio_bar_fixup(struct vfio_pci_core_device *vdev)
>  		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
>  		mask |= PCI_ROM_ADDRESS_ENABLE;
>  		*vbar &= cpu_to_le32((u32)mask);
> +	} else if (pdev->rom && pdev->romlen) {
> +		mask = ~(roundup_pow_of_two(pdev->romlen) - 1);
> +		mask |= PCI_ROM_ADDRESS_ENABLE;
> +		*vbar &= cpu_to_le32((u32)mask);
>  	} else {
>  		*vbar = 0;
>  	}
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b49dd9cdc072a..3120c1e9f22cb 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1049,30 +1049,31 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
>  		break;
>  	case VFIO_PCI_ROM_REGION_INDEX: {
>  		void __iomem *io;
> -		size_t size;
> +		size_t dont_care;

It still receives the size even if we don't consume it.

>  		u16 cmd;
>  
>  		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>  		info.flags = 0;
> +		info.size = 0;
>  
> -		/* Report the BAR size, not the ROM size */
> -		info.size = pci_resource_len(pdev, info.index);
> -		if (!info.size)
> -			break;
> -
> -		/*
> -		 * Is it really there?  Enable memory decode for implicit access
> -		 * in pci_map_rom().
> -		 */
> -		cmd = vfio_pci_memory_lock_and_enable(vdev);
> -		io = pci_map_rom(pdev, &size);
> -		if (io) {
> +		if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
> +			/* Check ROM content is valid. Need to enable memory

Incorrect comment style.

> +			 * decode for ROM access in pci_map_rom().
> +			 */
> +			cmd = vfio_pci_memory_lock_and_enable(vdev);
> +			io = pci_map_rom(pdev, &dont_care);
> +			if (io) {
> +				info.flags = VFIO_REGION_INFO_FLAG_READ;
> +				/* Report the BAR size, not the ROM size. */
> +				info.size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
> +				pci_unmap_rom(pdev, io);
> +			}
> +			vfio_pci_memory_unlock_and_restore(vdev, cmd);
> +		} else if (pdev->rom && pdev->romlen) {
>  			info.flags = VFIO_REGION_INFO_FLAG_READ;
> -			pci_unmap_rom(pdev, io);
> -		} else {
> -			info.size = 0;
> +			/* Report BAR size as power of two. */
> +			info.size = roundup_pow_of_two(pdev->romlen);
>  		}
> -		vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  
>  		break;
>  	}
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 4bed9fd5af50f..4ea983cf499d9 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -243,6 +243,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  
>  	if (pci_resource_start(pdev, bar))
>  		end = pci_resource_len(pdev, bar);
> +	else if (bar == PCI_ROM_RESOURCE && pdev->rom && pdev->romlen)
> +		end = roundup_pow_of_two(pdev->romlen);
>  	else
>  		return -EINVAL;
>  
> @@ -259,7 +261,12 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  		 * excluded range at the end of the actual ROM.  This makes
>  		 * filling large ROM BARs much faster.
>  		 */
> -		io = pci_map_rom(pdev, &x_start);
> +		if (pci_resource_start(pdev, bar)) {
> +			io = pci_map_rom(pdev, &x_start);
> +		} else {
> +			io = ioremap(pdev->rom, pdev->romlen);
> +			x_start = pdev->romlen;
> +		}
>  		if (!io)
>  			return -ENOMEM;
>  		x_end = end;
> @@ -267,7 +274,10 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  		done = vfio_pci_core_do_io_rw(vdev, 1, io, buf, pos,
>  					      count, x_start, x_end, 0);
>  
> -		pci_unmap_rom(pdev, io);
> +		if (pci_resource_start(pdev, bar))
> +			pci_unmap_rom(pdev, io);
> +		else
> +			iounmap(io);
>  	} else {
>  		done = vfio_pci_core_setup_barmap(vdev, bar);
>  		if (done)

It's not clear why the refactoring of the previous patch was really
necessary simply to have an alternate map and unmap path.  Thanks,

Alex


