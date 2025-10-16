Return-Path: <kvm+bounces-60124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 510AFBE1AC2
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 08:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 90A844F2FC8
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 06:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F8A257AC6;
	Thu, 16 Oct 2025 06:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BG3eEDCS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48915219A67;
	Thu, 16 Oct 2025 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760595030; cv=none; b=OoBORi8XIAQumk4JSfnMStushfI1YczkQbSjGlq9JROt+uaCj3uh1L76iiL7X92eXbWKwRpjuE/RGlpLE2IK7+Sp7f/gUuCPmE3/iKhOsxR/G/A2mQjuJgrYt2vcQ0gzX5Js8GHxq2hVMT6SMjXzn2rG/jbcEyGOyON5Ff4W4jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760595030; c=relaxed/simple;
	bh=tT6N7q0N+tYnpCuKuxnxGLzsNtDaUUpQ+9IuABIG9g0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKxgrHCNhkppPwGexEHUy0x7YoYFAqCi1Q0pOwFtGcmM4bMe3jXU5J7gV67qFFbkYQFi5D12Ipu4NtebBmJ14nad4MdnyTeIlvFDIPnhrIVwkbCSDMaUCvOsaaIQ1wsQSfP4v9Eiq//1n1AOVoR1qywd7mIX57AhJsYEBMtt2og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BG3eEDCS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39906C4CEF1;
	Thu, 16 Oct 2025 06:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760595029;
	bh=tT6N7q0N+tYnpCuKuxnxGLzsNtDaUUpQ+9IuABIG9g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BG3eEDCSI/HeqTCyC/0LCNKBgZ3zo6ECD9ngmXBKIPPl5NBH22Bn7mghAB8et/H6G
	 Mk66piiBKnfchNsu3YfuJzNnwCXFrqb8msDY8Om7bdz82Hkljjp7CPmpHtnH9rNGgs
	 KlMJt91fqlCWGDLVdc6FP/YNLaLQ7lPh9mflRMeup/0Wzsexbxj6A0mkigA65Vzw0x
	 gbAD3ImrXMKJVAfq/R2QbmWKCY7eNvtD8O8jYdRtYFKQ5Hq1PrhccrO90mG8ylxJEA
	 UlVJ3lTR+OmS5SyBhCnebiq7W+a6V2pL6QQLerxSwT6B4ZcH42Z/KxX0dqJOEZ6gTV
	 xAaHdT8g/V/0w==
Date: Thu, 16 Oct 2025 09:10:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by
 default
Message-ID: <20251016061025.GA6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
 <aPBwEVJSzezdii1V@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPBwEVJSzezdii1V@Asurada-Nvidia>

On Wed, Oct 15, 2025 at 09:09:53PM -0700, Nicolin Chen wrote:
> Hi Leon,
> 
> On Mon, Oct 13, 2025 at 06:26:10PM +0300, Leon Romanovsky wrote:
> > @@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > +	ret = pcim_p2pdma_init(vdev->pdev);
> > +	if (ret != -EOPNOTSUPP)
> > +		return ret;
> >  	init_rwsem(&vdev->memory_lock);
> >  	xa_init(&vdev->ctx);
> 
> I think this should be:
> 	if (ret && ret != -EOPNOTSUPP)
> 		return ret;
> 
> Otherwise, init_rwsem() and xa_init() would be missed if ret==0.

You absolutely right.

Thanks

> 
> Thanks
> Nicolin
> 

