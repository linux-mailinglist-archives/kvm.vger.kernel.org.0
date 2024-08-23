Return-Path: <kvm+bounces-24959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5013F95D94D
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:37:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F39FC2868F8
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58E41C8FC4;
	Fri, 23 Aug 2024 22:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s07ZYOLi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011A81684A4;
	Fri, 23 Aug 2024 22:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724452661; cv=none; b=YQZHfrfAUu+DoWXcCjfFe62zLZprcW1D91BG8jwTTOtTvFntgqY7fnXvMaAMDzp3laN2A8RUUDul4+TNMro4ziA/yf40ke7ucNul+SMcfsENQEIQDpQlqjLOhbA5wt/PnFTVfssVua4u1+g0BSUf5yuciUPt4q+bkJ6uf7va3+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724452661; c=relaxed/simple;
	bh=EoII+OSsqXOv7iyDrVHXvCJ0w2dAKTY2a05EkquIc1w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Dbr7BH6bawJUMjGTaVHZrpneGay/KPu/BXWuo3pgIAj5nLX5wibXgJzLq7tw3XjmbBer0THmbFDacOePYl+80LsXnwemBoBXRHy1/7G27y0NXnY0QLPOjwWPCmEHwbj7xmQ1DgnMNtMsvUWdwYeEWl6FHRYT0WXo+8CJ2x5wcBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s07ZYOLi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6CCC32786;
	Fri, 23 Aug 2024 22:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724452660;
	bh=EoII+OSsqXOv7iyDrVHXvCJ0w2dAKTY2a05EkquIc1w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=s07ZYOLiedObiXWVvsXH+RgNuKSet7EOTnxGBuj8EmagTlb25W2Neqw9Vgcyds+dw
	 2gl8lemgm/FpM5TeI9y2nSTzjCvxOCm8O0Mnpz/HZbfnkIICSN420syuawDylvHqoD
	 Ohlj2GPpkmG6aBDr52twtaWGGu5aPiOzEzy2aI1QEWyL/8mIkAOoJqWwwDvhZtBIIm
	 tPdsjt+nPKeCNNL07CRJDv33GeQ5KApEHHhpkDrptgN2Tmq3fxkxYnJmAa2SpbFewL
	 J9hvxhgMi/hfqZVe6vaRhjLj0mrBHKUy/NC/AOlIm9lwLCxnzxkTPh//hEbQ8kkK1s
	 ZNQ/DTSoN0cbg==
Date: Fri, 23 Aug 2024 17:37:38 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 20/21] pci: Allow encrypted MMIO mapping via sysfs
Message-ID: <20240823223738.GA391927@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-21-aik@amd.com>

On Fri, Aug 23, 2024 at 11:21:34PM +1000, Alexey Kardashevskiy wrote:
> Add another resource#d_enc to allow mapping MMIO as
> an encrypted/private region.
> 
> Unlike resourceN_wc, the node is added always as ability to
> map MMIO as private depends on negotiation with the TSM which
> happens quite late.

Capitalize subject prefix.

Wrap to fill 75 columns.

> +++ b/include/linux/pci.h
> @@ -2085,7 +2085,7 @@ pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
>   */
>  int pci_mmap_resource_range(struct pci_dev *dev, int bar,
>  			    struct vm_area_struct *vma,
> -			    enum pci_mmap_state mmap_state, int write_combine);
> +			    enum pci_mmap_state mmap_state, int write_combine, int enc);

This interface is only used in drivers/pci and look like it should be
moved to drivers/pci/pci.h.

> @@ -46,6 +46,15 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>  
>  	vma->vm_ops = &pci_phys_vm_ops;
>  
> +	/*
> +	 * Calling remap_pfn_range() directly as io_remap_pfn_range()
> +	 * enforces shared mapping.

s/Calling/Call/

Needs some additional context about why io_remap_pfn_range() can't be
used here.

> +	 */
> +	if (enc)
> +		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> +				       vma->vm_end - vma->vm_start,
> +				       vma->vm_page_prot);
> +
>  	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>  				  vma->vm_end - vma->vm_start,
>  				  vma->vm_page_prot);

