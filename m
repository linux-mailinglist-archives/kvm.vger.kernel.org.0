Return-Path: <kvm+bounces-9169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A922C85B857
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 490CE1F294B9
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC6860BBC;
	Tue, 20 Feb 2024 09:56:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53F260244;
	Tue, 20 Feb 2024 09:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708422970; cv=none; b=USu5Pj4+lDUwa6j5cQdkDnAq/ZCwBfu/JVJXsxKPRbhKJRDBjY9BqULAkx2dZHUOWHvEjQha5OoivUxHEalg+pOAOIOes6UVm6EZd5KMMZjn+HNC7uDvIlNpuyV8clYi9fgb0tnLv6sJpdwtQeMYpG1FtjgMkbzk2PE7vZsTLrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708422970; c=relaxed/simple;
	bh=neaD1FxsjzQ5jsLnH0UcC4xovILhlo04Z/jp6nHSC7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZXHdACqpX/sAp12eBWSMhd46APuS90zyStuXHbi23gxqQ/0CN+GJ65GNUIwJkbPLJQvmi8HAXg76C13rDDLBry//9eHnxtS/Nud9fQtO3hwdnFzeUW/ug+mAwPAcOWnClbr8cyrXiSeBsOCm1P8IY5E+wExf3fh4s1y2c3Erno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD13C433C7;
	Tue, 20 Feb 2024 09:56:02 +0000 (UTC)
Date: Tue, 20 Feb 2024 09:56:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, will@kernel.org, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	shahuang@redhat.com, ricarkol@google.com, linux-mm@kvack.org,
	lpieralisi@kernel.org, rananta@google.com, ryan.roberts@arm.com,
	david@redhat.com, linus.walleij@linaro.org, bhe@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	kvmarm@lists.linux.dev, mochs@nvidia.com, zhiw@nvidia.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Message-ID: <ZdR3MI_4pqV0EZcR@arm.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-5-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220072926.6466-5-ankita@nvidia.com>

On Tue, Feb 20, 2024 at 12:59:26PM +0530, ankita@nvidia.com wrote:
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..c93bea18fc4b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1862,8 +1862,24 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	/*
>  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>  	 * change vm_flags within the fault handler.  Set them now.
> +	 *
> +	 * VM_ALLOW_ANY_UNCACHED: The VMA flag is implemented for ARM64,
> +	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
> +	 * rather than DEVICE_nGnRE, which allows guest mappings
> +	 * supporting combining attributes (WC). ARM does not

Nitpick: "supporting write-combining" (if you plan to respin).

-- 
Catalin

