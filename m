Return-Path: <kvm+bounces-39175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC3BA44DC3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8F043B7C89
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A097521148F;
	Tue, 25 Feb 2025 20:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1o+YzKQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8571448E3;
	Tue, 25 Feb 2025 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515726; cv=none; b=sAopNrkMYS+SNcrEPCtupiUD23TLIGfeUxN0Qtk3GR1TqzsT+YQqOpgP9eJQgxpyLqtkLpg4lYn9E60I64Jj3ywtd0aXHdjENd1foqXP5ZTzpBWjhGWqi8u7xu89/kbV5JVH4pmcpCYpM94wVfIZ4T2N3h5/Iv04U15JgciLcw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515726; c=relaxed/simple;
	bh=7Wg1p0f2ypkxnC0TFBuDHULqBARMpNOuEl5fgz8O5K4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=OKkkLlMrIiTBLy2y30CoeHBqDTIjkPSOumJE9yiUVQkGPbFtIu/pZnlXTns8oLTN4+SsOGU/41F7c2KNjpPnC08YXs2R1uwnej0LEuamYL3DAljoG9S3+uL1dszuCx5Z3B3Aar5jvvfJW5qBPIKvkeVeEf1A9yK9le/TxF5nxdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1o+YzKQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4012C4CEDD;
	Tue, 25 Feb 2025 20:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740515726;
	bh=7Wg1p0f2ypkxnC0TFBuDHULqBARMpNOuEl5fgz8O5K4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=u1o+YzKQTjiHFa378K9/JNzh8aDmB6+8eSlzj2e0oqKfk3HNpjqojfcknEQf7dasY
	 03hMuuQtgsENKquMorrWqUGoeNDbnhT8OWNv2SkWWLV2eGDqCJKtwkf01YgUUcP3em
	 0vF1gkPM7D3w3aowShgQuXbYAygbru0he6FEP1lpDrHz9VHeTVcmNxKMqIdyJgFqm4
	 XCKGzWr5q/xPyIjix/RGoEOSV0Bbd2ZAqusDGXt9sZ/henPtK7X/J0rhcR9MmW6NaV
	 yjkjWzQ+We+5C2wMW9aH5ZtmatdkVY+qCKe3UQk5io0s0ECF90mFWsoYbS4vjIrMLR
	 29Dh1G9eqw+eQ==
Date: Tue, 25 Feb 2025 14:35:24 -0600
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
Message-ID: <20250225203524.GA516498@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bcd6de5f40b2ee6d4d6758e3d2473172bd9b990.camel@linux.ibm.com>

On Tue, Feb 25, 2025 at 09:59:13AM +0100, Niklas Schnelle wrote:
> On Mon, 2025-02-24 at 14:53 -0600, Bjorn Helgaas wrote:
> > On Fri, Feb 14, 2025 at 02:10:51PM +0100, Niklas Schnelle wrote:
> > > With the introduction of memory I/O (MIO) instructions enbaled in commit
> > > 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> > > gained support for direct user-space access to mapped PCI resources.
> > > Even without those however user-space can access mapped PCI resources
> > > via the s390 specific MMIO syscalls. There is thus nothing fundamentally
> > > preventing s390 from supporting VFIO_PCI_MMAP, allowing user-space
> > > drivers to access PCI resources without going through the pread()
> > > interface. To actually enable VFIO_PCI_MMAP a few issues need fixing
> > > however.
> > > 
> > > Firstly the s390 MMIO syscalls do not cause a page fault when
> > > follow_pte() fails due to the page not being present. This breaks
> > > vfio-pci's mmap() handling which lazily maps on first access.
> > > 
> > > Secondly on s390 there is a virtual PCI device called ISM which has
> > > a few oddities. For one it claims to have a 256 TiB PCI BAR (not a typo)
> > > which leads to any attempt to mmap() it fail with the following message:
> > > 
> > >     vmap allocation for size 281474976714752 failed: use vmalloc=<size> to increase size
> > > 
> > > Even if one tried to map this BAR only partially the mapping would not
> > > be usable on systems with MIO support enabled. So just block mapping
> > > BARs which don't fit between IOREMAP_START and IOREMAP_END. Solve this
> > > by keeping the vfio-pci mmap() blocking behavior around for this
> > > specific device via a PCI quirk and new pdev->non_mappable_bars
> > > flag.
> > > 
> > > As noted by Alex Williamson With mmap() enabled in vfio-pci it makes
> > > sense to also enable HAVE_PCI_MMAP with the same restriction for pdev->
> > > non_mappable_bars. So this is added in patch 3 and I tested this with
> > > another small test program.
> > > 
> > > Note:
> > > For your convenience the code is also available in the tagged
> > > b4/vfio_pci_mmap branch on my git.kernel.org site below:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/
> > > 
> > > Thanks,
> > > Niklas
> > > 
> > > Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
> > > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > > ---
> > > Changes in v6:
> > > - Add a patch to also enable PCI resource mmap() via sysfs and proc
> > >   exlcluding pdev->non_mappable_bars devices (Alex Williamson)
> > > - Added Acks
> > > - Link to v5: https://lore.kernel.org/r/20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com
> > 
> > I think the series would be more readable if patch 2/3 included all
> > the core changes (adding pci_dev.non_mappable_bars, the 3/3
> > pci-sysfs.c and proc.c changes to test it, and I suppose the similar
> > vfio_pci_core.c change), and we moved all the s390 content from 2/3 to
> > 3/3.
> 
> Maybe we could do the following:
> 
> 1/3: As is
> 
> 2/3: Introduces pdev->non_mappable_bars and the checks in vfio and
> proc.c/pci-sysfs.c. To make the flag handle the vfio case with
> VFIO_PCI_MMAP gone, a one-line change in s390 will set pdev-
> >non_mappable_bars = 1 for all PCI devices.

What if you moved the vfio_pci_core.c change to patch 3?  Then I think
patch 2 would do nothing at all (since there's nothing that sets
non_mappable_bars), and all the s390 stuff would be in patch 3?

Not sure if that's possible, but I think it's a little confusing to
have the s390 changes split across patch 2 and 3.

> 3/3: Changes setting pdev->non_mappable_bars = 1 in s390 to only the
> ISM device using the quirk handling and adds HAVE_PCI_MMAP.
> 
> Thanks,
> Niklas

