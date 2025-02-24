Return-Path: <kvm+bounces-39046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CA8A42E54
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:53:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F5321899837
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 20:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C67264A76;
	Mon, 24 Feb 2025 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyckZLa0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F62262D11;
	Mon, 24 Feb 2025 20:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740430398; cv=none; b=ciRR9OGiG0zdFbN237ktJUL4X6lBQ1E1OSdOJg2B7VcD/Y1cnLDBv7n+S3YWr6r87sVeyayYW54A5euSyATHo9oeFJiu8ZxJ52yTPZIwgcrGUpBu7Y21wrS/JUiNpvk3o+SLjZxa40eyLacBiGL6Mh6BvhTse9ToVlHRHES0N7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740430398; c=relaxed/simple;
	bh=pREGhWg1kcj3syTH2EZjMgzcwFGBKmTgaY0Mxt8vcBk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=q+OTpjeTbYy6GEOUXAEVoE8StWTLMvAUuPS3yFVI5qG6BJTMGzfEbPKE/QpAB3985SIjmrUprIKnUmqfgEQfUtSeHNNVyo7LtMyVrbxF6Yv2kbDaErM/nuZh5sA1NTg0h7SZw/kjS9yMPZYkGRnf33lMVZr0ILFJdxo+C9W+NbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyckZLa0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239D9C4CED6;
	Mon, 24 Feb 2025 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740430396;
	bh=pREGhWg1kcj3syTH2EZjMgzcwFGBKmTgaY0Mxt8vcBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=fyckZLa0MhIBkOEp96YFckrMzMItxbfarxjlThBvHzF1sF/J0CFKnvNBp3FK5rDqV
	 qCOI1UPi2Y2K3/62XbfxPTdwTTxm1VfJVHLoz+UuI59cDt8HyYHaMMS8BE1+tzYx/e
	 dABMISnYyfMQrv8W5+6p6JWhfV8A9P/bQjC9ZHbNv8uLwVgdjepzG/FM6wLg9mBsc0
	 f/59WF5i2asjjpGrAb4623fte1gUsev2wdavllCS4G6YPnuOcYRfM8jgNkWsBGOtLd
	 Z9tWabzTxe1nvPrId3CMtisrbuovE4uESNGIdlatzdBqIbpnAUVaqk51ufZ7VZ4/49
	 sAX6TBzdjC5Cg==
Date: Mon, 24 Feb 2025 14:53:14 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Message-ID: <20250224205314.GA478317@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com>

On Fri, Feb 14, 2025 at 02:10:51PM +0100, Niklas Schnelle wrote:
> With the introduction of memory I/O (MIO) instructions enbaled in commit
> 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> gained support for direct user-space access to mapped PCI resources.
> Even without those however user-space can access mapped PCI resources
> via the s390 specific MMIO syscalls. There is thus nothing fundamentally
> preventing s390 from supporting VFIO_PCI_MMAP, allowing user-space
> drivers to access PCI resources without going through the pread()
> interface. To actually enable VFIO_PCI_MMAP a few issues need fixing
> however.
> 
> Firstly the s390 MMIO syscalls do not cause a page fault when
> follow_pte() fails due to the page not being present. This breaks
> vfio-pci's mmap() handling which lazily maps on first access.
> 
> Secondly on s390 there is a virtual PCI device called ISM which has
> a few oddities. For one it claims to have a 256 TiB PCI BAR (not a typo)
> which leads to any attempt to mmap() it fail with the following message:
> 
>     vmap allocation for size 281474976714752 failed: use vmalloc=<size> to increase size
> 
> Even if one tried to map this BAR only partially the mapping would not
> be usable on systems with MIO support enabled. So just block mapping
> BARs which don't fit between IOREMAP_START and IOREMAP_END. Solve this
> by keeping the vfio-pci mmap() blocking behavior around for this
> specific device via a PCI quirk and new pdev->non_mappable_bars
> flag.
> 
> As noted by Alex Williamson With mmap() enabled in vfio-pci it makes
> sense to also enable HAVE_PCI_MMAP with the same restriction for pdev->
> non_mappable_bars. So this is added in patch 3 and I tested this with
> another small test program.
> 
> Note:
> For your convenience the code is also available in the tagged
> b4/vfio_pci_mmap branch on my git.kernel.org site below:
> https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/
> 
> Thanks,
> Niklas
> 
> Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
> Changes in v6:
> - Add a patch to also enable PCI resource mmap() via sysfs and proc
>   exlcluding pdev->non_mappable_bars devices (Alex Williamson)
> - Added Acks
> - Link to v5: https://lore.kernel.org/r/20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com

I think the series would be more readable if patch 2/3 included all
the core changes (adding pci_dev.non_mappable_bars, the 3/3
pci-sysfs.c and proc.c changes to test it, and I suppose the similar
vfio_pci_core.c change), and we moved all the s390 content from 2/3 to
3/3.

