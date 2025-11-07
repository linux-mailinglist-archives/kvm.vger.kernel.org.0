Return-Path: <kvm+bounces-62302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB305C40BAF
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 17:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0110F188445B
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 16:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6FC42EBDF0;
	Fri,  7 Nov 2025 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1OqoxtV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9AE1DE8AE;
	Fri,  7 Nov 2025 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762531285; cv=none; b=X2o+jSgd/sEkieoSsHJLzPhtEZJslTg9vU1LCyApi0nN7B1kylXXrZ8DGo1QbrBpu1TWLBttzybEMyOcF8MmMvQBbQMqkkTHudXXTpme0M0U9l8Syy9o8rUKxxFlJ+KX/wYVeJHs+UMDC9cy/jtJlTOZxJ2X9h9r8Xuw1+w0Mlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762531285; c=relaxed/simple;
	bh=SAXkSml11M5xQ5oAowfwGP1WfIbbhD9Zwsc1+gFtZVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gE5bBhg+qvsgoRdDnfV9IRjE9MFxMtgCa7aJ6jruVf1wiXM6knGj4pWj7db4h7VRxedWTkHsqJ8HDx+v61GFnJWcB5VidzFLNt6aIL0PER+l4gkoRPu6W16xFsoST5DW3QzpL8uMxANXyPq4oLSp6Jb+CqpZgpf4naH7//Q5Ngc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1OqoxtV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30C3C4CEF8;
	Fri,  7 Nov 2025 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762531285;
	bh=SAXkSml11M5xQ5oAowfwGP1WfIbbhD9Zwsc1+gFtZVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G1OqoxtV7XlT2wwuQ5Uez60kwG8g2e3K4oXYvr5lCUmDLnRe2lDqJfqpdyozZ9Kfs
	 9cK/Pp4gs2exlM5ZaZgfE/mSts/OwwIwkCNUlopoOf55C/E/oCxFH4g1GkpuhBOQLc
	 GevH4WEkQ/xUCsGWGMcEuw40zHNAV2BFJUHAJFbr5fa5pHtu6BKUEsKKzGsJoGHBVK
	 LIruon02MTTCyGk7ziSVANwsf4TxGmKVozxHLsq3vvxJUR+H9wB9GZSvIotqrUV4ud
	 cVhLCCIpj3frChH2BVoHb8jxb4jO/OzKabXV1PHaTXuqZVIniF59yBQsetybD1Wq21
	 bF79hpL4xdXKw==
Date: Fri, 7 Nov 2025 18:01:20 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251107160120.GD15456@unreal>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
 <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>

On Thu, Nov 06, 2025 at 10:15:07PM -0800, Randy Dunlap wrote:
> 
> 
> On 11/6/25 6:16 AM, Leon Romanovsky wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >  1 file changed, 72 insertions(+), 23 deletions(-)
> > 
> > diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> > index d0b241628cf1..69adea45f73e 100644
> > --- a/Documentation/driver-api/pci/p2pdma.rst
> > +++ b/Documentation/driver-api/pci/p2pdma.rst
> > @@ -9,22 +9,47 @@ between two devices on the bus. This type of transaction is henceforth
> >  called Peer-to-Peer (or P2P). However, there are a number of issues that
> >  make P2P transactions tricky to do in a perfectly safe way.
> >  
> > -One of the biggest issues is that PCI doesn't require forwarding
> > -transactions between hierarchy domains, and in PCIe, each Root Port
> > -defines a separate hierarchy domain. To make things worse, there is no
> > -simple way to determine if a given Root Complex supports this or not.
> > -(See PCIe r4.0, sec 1.3.1). Therefore, as of this writing, the kernel
> > -only supports doing P2P when the endpoints involved are all behind the
> > -same PCI bridge, as such devices are all in the same PCI hierarchy
> > -domain, and the spec guarantees that all transactions within the
> > -hierarchy will be routable, but it does not require routing
> > -between hierarchies.
> > -
> > -The second issue is that to make use of existing interfaces in Linux,
> > -memory that is used for P2P transactions needs to be backed by struct
> > -pages. However, PCI BARs are not typically cache coherent so there are
> > -a few corner case gotchas with these pages so developers need to
> > -be careful about what they do with them.
> > +For PCIe the routing of TLPs is well defined up until they reach a host bridge
> 
> Define what TLP means?

In PCIe "world", TLP is very well-known and well-defined acronym, which
means Transaction Layer Packet.

>                                    well-defined

Thanks

diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
index 69adea45f73e..7530296a5dea 100644
--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -9,17 +9,17 @@ between two devices on the bus. This type of transaction is henceforth
 called Peer-to-Peer (or P2P). However, there are a number of issues that
 make P2P transactions tricky to do in a perfectly safe way.

-For PCIe the routing of TLPs is well defined up until they reach a host bridge
-or root port. If the path includes PCIe switches then based on the ACS settings
-the transaction can route entirely within the PCIe hierarchy and never reach the
-root port. The kernel will evaluate the PCIe topology and always permit P2P
-in these well defined cases.
+For PCIe the routing of Transaction Layer Packets (TLPs) is well-defined up
+until they reach a host bridge or root port. If the path includes PCIe switches
+then based on the ACS settings the transaction can route entirely within
+the PCIe hierarchy and never reach the root port. The kernel will evaluate
+the PCIe topology and always permit P2P in these well-defined cases.

 However, if the P2P transaction reaches the host bridge then it might have to
 hairpin back out the same root port, be routed inside the CPU SOC to another
 PCIe root port, or routed internally to the SOC.

-As this is not well defined or well supported in real HW the kernel defaults to
+As this is not well-defined or well supported in real HW the kernel defaults to
 blocking such routing. There is an allow list to allow detecting known-good HW,
 in which case P2P between any two PCIe devices will be permitted.

@@ -39,7 +39,7 @@ delegates lifecycle management to the providing driver. It is expected that
 drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
 to provide an invalidation shutdown. These MMIO pages have no struct page, and
 if used with mmap() must create special PTEs. As such there are very few
-kernel uAPIs that can accept pointers to them, in particular they cannot be used
+kernel uAPIs that can accept pointers to them; in particular they cannot be used
 with read()/write(), including O_DIRECT.

 Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
@@ -154,7 +154,7 @@ access happens.
 Usage With DMABUF
 =================

-DMABUF provides an alternative to the above struct page based
+DMABUF provides an alternative to the above struct page-based
 client/provider/orchestrator system. In this mode the exporting driver will wrap
 some of its MMIO in a DMABUF and give the DMABUF FD to userspace.

@@ -162,10 +162,10 @@ Userspace can then pass the FD to an importing driver which will ask the
 exporting driver to map it.

 In this case the initiator and target pci_devices are known and the P2P subsystem
-is used to determine the mapping type. The phys_addr_t based DMA API is used to
+is used to determine the mapping type. The phys_addr_t-based DMA API is used to
 establish the dma_addr_t.

-Lifecycle is controlled by DMABUF move_notify(), when the exporting driver wants
+Lifecycle is controlled by DMABUF move_notify(). When the exporting driver wants
 to remove() it must deliver an invalidation shutdown to all DMABUF importing
 drivers through move_notify() and synchronously DMA unmap all the MMIO.


