Return-Path: <kvm+bounces-32472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A5149D8CC3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 20:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2474168A19
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 19:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0A61BB6B3;
	Mon, 25 Nov 2024 19:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWjwq1AG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9340A38DE1
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 19:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732562344; cv=none; b=qJAb3vbECtNEMKPtofeVCCFedj291jmYzxtXq+CCQOchAxnbDpMh4bgIfg3Tb6OPGtEciMC/OMwoWxlSmmWRUBdZpB+8aPYz8laWfFvWGzI//jEhzoJn2c7LHJ7VPVbhlmRzHnqhi+47iUTLJyQ+a7QfWqeDtb9cAb8VdlHm08s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732562344; c=relaxed/simple;
	bh=k6hX2fYHng9cUwMlbGSrHAakemgtuwHC4CafAJRJZ0o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+tV3GiCRVf0lIl8LWDULXgV2gsHkeTcObxVeAxmPMrfOfSoHKmuJ+BTPBUpAu3Gm4kN4krEmtzQ50A4xM5p0K/jLA5p61gfwMhxhC1Fm6DqKxWu5oQX1RkFQEqLnbsj967fN7+Nl0zgV2EAsf/4n05UQb8Pfj3q1OW2foKgQJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWjwq1AG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732562341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0zri8sqtaJlRzMrRbu+onT3jDhAvSEGLiciJui4Cv6s=;
	b=ZWjwq1AG+g9Foq+VPD4PMN2RfzJ1vm/otsTI6F985hDW/njgbTemXCGSnqbnrSciIdYWCc
	myuCWNKHHa1S3PezpvAXz3f52LvnwcSRa5ys5sL1THQe21YexJSW1NYCcf55urX5EOvNmB
	fNRsF89N9CSe6meXYJF1Pl3pxnN8pJM=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-l7THSgwNP8OFPNGdVgVx5g-1; Mon, 25 Nov 2024 14:18:59 -0500
X-MC-Unique: l7THSgwNP8OFPNGdVgVx5g-1
X-Mimecast-MFC-AGG-ID: l7THSgwNP8OFPNGdVgVx5g
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5f1e36800f9so125893eaf.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:18:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732562338; x=1733167138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0zri8sqtaJlRzMrRbu+onT3jDhAvSEGLiciJui4Cv6s=;
        b=t3FogAvjbnd8y902mvueHCcV1ZxnWikYO1Ht7benBfl69ujYj1P8Hq/A4tjAg3IfIv
         YczvEsUNYH7aYmZDK1IFVKErig62opT0dNj3/whpqeed7MQzSd9fXYGDKJ+zDiqMZE6z
         h5BRa6+1vf47wnqY4EObIsBx5hIIg1rvWoZ8sxPeIMoXSzP5lnowb5aO4jbHLRfWrv+C
         3KJdZpFCnODPmsh+3dbwkQat2nPKNBcyn0ksVw9cXT2WxLEFc4m1glbsdLzaz77yYn85
         b8BKaXydcQQOt9mGB7i5Jma7P7L8x8y7Ka9VK1fzwlmApShZc15pDPvWWjsFcx/Ef2//
         1tOw==
X-Gm-Message-State: AOJu0YxLGcMVs31O3+i4R6mdmrbj4DzmJX8WwGEzmsGx6DdmeZHA9VsB
	erquKJ79HlWDmV4bxnfkfoiBFcmnc/hb1uzKfBhZg01JUO2UUCD2tXQ+tPodnNqc1G5MjtXrHD2
	RdW7zvTELwAGHMDrzManHylrODz1yWEi2mAvkk53+E0Y3NHIeig==
X-Gm-Gg: ASbGncukHsR7aID4efX/FQV15PaiEQRANFD4uGHvW4pSA2jV/a2Rdc2GabOD0qzFwb0
	HwImqHJ2lbaKOIgwBrb/L3LFJuQUo/NKMSAWN7STF0ADix8D2mFgG+tQk41BkEKDAfk2Jwafb9X
	2tEY85WoIGeZ8+pR71xUuvXf5nKWSHySLEAOJvetJqQXTRaG+s4iHT3wtskeUCdT8q+6v8iUpbp
	VUPoWLeWiTK1dt4igPaL1LmAMXOw7wMI58Cw3IolZGpJd4KSMuyOQ==
X-Received: by 2002:a05:6830:6e07:b0:717:fd59:8981 with SMTP id 46e09a7af769-71d595e0fdemr423497a34.3.1732562338640;
        Mon, 25 Nov 2024 11:18:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFz0oZtFfg3w8DhURqFJFME0yQlilbewXvlfKlUvQBYwyHfnmCXGMPiKQKJOcUq75ogOqTkIA==
X-Received: by 2002:a05:6830:6e07:b0:717:fd59:8981 with SMTP id 46e09a7af769-71d595e0fdemr423492a34.3.1732562338270;
        Mon, 25 Nov 2024 11:18:58 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71d4ea51317sm913102a34.8.2024.11.25.11.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 11:18:57 -0800 (PST)
Date: Mon, 25 Nov 2024 12:18:56 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Avihai Horon <avihaih@nvidia.com>
Cc: <kvm@vger.kernel.org>, Yi Liu <yi.l.liu@intel.com>, Yishai Hadas
 <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb
 <maorg@nvidia.com>
Subject: Re: [PATCH v3] vfio/pci: Properly hide first-in-list PCIe extended
 capability
Message-ID: <20241125121856.56ee7fde.alex.williamson@redhat.com>
In-Reply-To: <20241124142739.21698-1-avihaih@nvidia.com>
References: <20241124142739.21698-1-avihaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 24 Nov 2024 16:27:39 +0200
Avihai Horon <avihaih@nvidia.com> wrote:

> There are cases where a PCIe extended capability should be hidden from
> the user. For example, an unknown capability (i.e., capability with ID
> greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
> chosen to be hidden from the user.
> 
> Hiding a capability is done by virtualizing and modifying the 'Next
> Capability Offset' field of the previous capability so it points to the
> capability after the one that should be hidden.
> 
> The special case where the first capability in the list should be hidden
> is handled differently because there is no previous capability that can
> be modified. In this case, the capability ID and version are zeroed
> while leaving the next pointer intact. This hides the capability and
> leaves an anchor for the rest of the capability list.
> 
> However, today, hiding the first capability in the list is not done
> properly if the capability is unknown, as struct
> vfio_pci_core_device->pci_config_map is set to the capability ID during
> initialization but the capability ID is not properly checked later when
> used in vfio_config_do_rw(). This leads to the following warning [1] and
> to an out-of-bounds access to ecap_perms array.
> 
> Fix it by checking cap_id in vfio_config_do_rw(), and if it is greater
> than PCI_EXT_CAP_ID_MAX, use an alternative struct perm_bits for direct
> read only access instead of the ecap_perms array.
> 
> Note that this is safe since the above is the only case where cap_id can
> exceed PCI_EXT_CAP_ID_MAX (except for the special capabilities, which
> are already checked before).
> 
> [1]
> 
> WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
> CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
> (snip)
> Call Trace:
>  <TASK>
>  ? show_regs+0x69/0x80
>  ? __warn+0x8d/0x140
>  ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>  ? report_bug+0x18f/0x1a0
>  ? handle_bug+0x63/0xa0
>  ? exc_invalid_op+0x19/0x70
>  ? asm_exc_invalid_op+0x1b/0x20
>  ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>  ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
>  vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
>  vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
>  vfio_device_fops_read+0x27/0x40 [vfio]
>  vfs_read+0xbd/0x340
>  ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
>  ? __rseq_handle_notify_resume+0xa4/0x4b0
>  __x64_sys_pread64+0x96/0xc0
>  x64_sys_call+0x1c3d/0x20d0
>  do_syscall_64+0x4d/0x120
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> ---
> Changes from v2:
> * Fix clang compilation error reported by kernel test robot.
> * Drop const qualifier of direct_ro_perms to avoid casting in
>   vfio_config_do_rw and to be aligned with other perms declaration.
> * Add Yi's R-b/T-b tags.

Applied to vfio next branch for v6.13.  Thanks,

Alex


> Changes from v1:
> * Use Alex's suggestion to fix the bug and adapt the commit message.
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 97422aafaa7b..ea2745c1ac5e 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -313,6 +313,10 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
>  	return count;
>  }
>  
> +static struct perm_bits direct_ro_perms = {
> +	.readfn = vfio_direct_config_read,
> +};
> +
>  /* Default capability regions to read-only, no-virtualization */
>  static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
>  	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> @@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>  		cap_start = *ppos;
>  	} else {
>  		if (*ppos >= PCI_CFG_SPACE_SIZE) {
> -			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
> +			/*
> +			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
> +			 * if we're hiding an unknown capability at the start
> +			 * of the extended capability list.  Use default, ro
> +			 * access, which will virtualize the id and next values.
> +			 */
> +			if (cap_id > PCI_EXT_CAP_ID_MAX)
> +				perm = &direct_ro_perms;
> +			else
> +				perm = &ecap_perms[cap_id];
>  
> -			perm = &ecap_perms[cap_id];
>  			cap_start = vfio_find_cap_start(vdev, *ppos);
>  		} else {
>  			WARN_ON(cap_id > PCI_CAP_ID_MAX);


