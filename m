Return-Path: <kvm+bounces-8349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF16084E385
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 15:54:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E25571C27C49
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410857B3DF;
	Thu,  8 Feb 2024 14:53:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD49F7B3C7;
	Thu,  8 Feb 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707404035; cv=none; b=RD1KzXszHaQ15lFq/shJXgClGSmoqykgAIih8+OUzET43N4r4JEcWD6v8uDnNcnX0Vq6J53yqWY/hxJZqCL9ux8yXYL4dna9kPracizDaFKps89u7qWM+APiXAsY3Ys2BDnnAlP0NwTMT7anusvIyjA5XokNxz7mDEeZjCZji/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707404035; c=relaxed/simple;
	bh=DsYyp3kIXmVn6CNV5p3iHd0W1LhJ8FsJgy2h91cPUvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCOlgyq4pj2xGVnEMZHHcEIO/BzRPvktUwh7iNRBkk14oedeUjY7hXG31CR7DS7wRtDM3MrkgYElT5KfStW6QkUm/0HOkU1DHLqkNCd4Bn8dgcvqYWd5zRnoISIXte9yRbJJKYtsYkwfIliUR/orG6djTvBpvd4uz9Qe+BZQ2dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95689C433F1;
	Thu,  8 Feb 2024 14:53:47 +0000 (UTC)
Date: Thu, 8 Feb 2024 14:53:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, will@kernel.org, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v6 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Message-ID: <ZcTq-ecgVAP892X2@arm.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-5-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207204652.22954-5-ankita@nvidia.com>

+ David H

On Thu, Feb 08, 2024 at 02:16:52AM +0530, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The code to map the MMIO in S2 as NormalNC is enabled when conveyed
> that the device is WC safe using a new flag VM_VFIO_ALLOW_WC.
> 
> Make vfio-pci set the VM_VFIO_ALLOW_WC flag.
> 
> This could be extended to other devices in the future once that
> is deemed safe.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..c3f95ec7fc3a 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1863,7 +1863,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>  	 * change vm_flags within the fault handler.  Set them now.
>  	 */
> -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_set(vma, VM_VFIO_ALLOW_WC | VM_IO | VM_PFNMAP |
> +			VM_DONTEXPAND | VM_DONTDUMP);
>  	vma->vm_ops = &vfio_pci_mmap_ops;
>  
>  	return 0;

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

