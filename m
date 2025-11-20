Return-Path: <kvm+bounces-63804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AE9C72B82
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 09:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 010B335756C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 08:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301773019DE;
	Thu, 20 Nov 2025 08:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jyoe7Oe5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335D6372AB6;
	Thu, 20 Nov 2025 08:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763626000; cv=none; b=mPHwMi7kFIx3eH5JDrOB0WVa1xEmKw/Ml/NX7FkeMC8LD6S6MTEUp2RmziW7630BeCNjX2WfB3XU5tVzh3SMdeussUb9/TKrXxT59Jtkn9S2UtEtueBTxBVy1c0DLCH+a0kE4LW+X44X+LfxyK/OJO1rGnD0DLS5G98n2hMxDNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763626000; c=relaxed/simple;
	bh=mxT/rSlaqP+txsmWmS9/PssKwzGp7j3BhlaZuVwXZis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKJVZSCXFLtQZaqK+/XQ1aLWr5XYa4X0huCO3MjuwXwLPyE9ewJERBVkY0CRkMdwlvYcHdxkz19TzHZt8lAIgCHYGobNFBMZAr1VYWCmwhdfo73mu1V6nyp9XYCPGN43TF0b4uTnIwRI9I6xs/IM0FOwubA6n/Z5T1kvEtPaxCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jyoe7Oe5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124CEC4CEF1;
	Thu, 20 Nov 2025 08:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763625999;
	bh=mxT/rSlaqP+txsmWmS9/PssKwzGp7j3BhlaZuVwXZis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jyoe7Oe5fQPJ/c3G0Y3Le2MuwLeYij5ETlxaQsfHH0IeCeAp4SV8sma9/p4puBfJd
	 uSJLTrxHP3QFvgERIjsj/1tqk+X/okArVSEm8ZMhuoWrUm+nw49VGAhsvO+/F7roqB
	 earNWu4MD42Xdka7K6xqmgczk8orzPbhqOIDxQD+/aKHXhBiOGA4RplKw1T/I2rQ6a
	 ev9a2LBRLzTP1F+YYtsiwBQ2gNaHKtotSqd6c5JXDYnlHf0a974bbsQ8w3T/BC46cr
	 IlYGcGcRRMayKQVYgRTSLxtDvYEu5tk34YIf2hUPYoKt2aPFZV53WId4koKue3AXLS
	 Eq5b6O0Zpw2Lw==
Date: Thu, 20 Nov 2025 10:06:35 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
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
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251120080635.GT18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
 <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
 <20251120074137.GR18335@unreal>
 <209499e2-6a06-4291-ad4c-77230926c665@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <209499e2-6a06-4291-ad4c-77230926c665@amd.com>

On Thu, Nov 20, 2025 at 08:54:37AM +0100, Christian König wrote:
> On 11/20/25 08:41, Leon Romanovsky wrote:
> > On Thu, Nov 20, 2025 at 08:08:27AM +0100, Christian König wrote:
> >> On 11/19/25 20:31, Jason Gunthorpe wrote:
> >>> On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
> >>>
> >>>>>>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>>>>>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>>>>>> +		if (!dma->state) {
> >>>>>>> +			ret = -ENOMEM;
> >>>>>>> +			goto err_free_dma;
> >>>>>>> +		}
> >>>>>>> +
> >>>>>>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>>>>>
> >>>>>> Oh, that is a clear no-go for the core DMA-buf code.
> >>>>>>
> >>>>>> It's intentionally up to the exporter how to create the DMA
> >>>>>> addresses the importer can work with.
> >>>>>
> >>>>> I can't fully understand this remark?
> >>>>
> >>>> The exporter should be able to decide if it actually wants to use
> >>>> P2P when the transfer has to go through the host bridge (e.g. when
> >>>> IOMMU/bridge routing bits are enabled).
> >>>
> >>> Sure, but this is a simplified helper for exporters that don't have
> >>> choices where the memory comes from.
> >>
> >> That is extremely questionable as justification to put that in common DMA-buf code.
> >>
> >>> I fully expet to see changes to this to support more use cases,
> >>> including the one above. We should do those changes along with users
> >>> making use of them so we can evaluate what works best.
> >>
> >> Yeah, exactly that's my concern.
> >>
> >>>> But only take that as Acked-by, I would need at least a day (or
> >>>> week) of free time to wrap my head around all the technical details
> >>>> again. And that is something I won't have before January or even
> >>>> later.
> >>>
> >>> Sure, it is alot, and I think DRM community in general should come up
> >>> to speed on the new DMA API and how we are pushing to see P2P work
> >>> within Linux.
> >>>
> >>> So thanks, we can take the Acked-by and progress here. Interested
> >>> parties can pick it up from this point when time allows.
> >>
> >> Wait a second. After sleeping a night over it I think my initial take that we really should not put that into common DMA-buf code seems to hold true.
> >>
> >> This is the use case for VFIO, but I absolutely want to avoid other drivers from re-using this code until be have more experience with that.
> >>
> >> So to move forward I now strongly think we should keep that in VFIO until somebody else comes along and needs that helper.
> > 
> > It was put in VFIO at the beginning, but Christoph objected to it,
> > because that will require exporting symbol for pci_p2pdma_map_type().
> > which was universally agreed as not good idea.
> 
> Yeah, that is exactly what I object here :)
> 
> We can have the helper in DMA-buf *if* pci_p2pdma_map_type() is called by drivers or at least accessible. That's what I pointed out in the other mail before as well.
> 
> The exporter must be able to make decisions based on if the transaction would go over the host bridge or not.
> 
> Background is that in a lot of use cases you rather want to move the backing store into system memory instead of keeping it in local memory if the driver doesn't have direct access over a common upstream bridge.
> 
> Currently drivers decide that based on if IOMMU is enabled or not (and a few other quirks), but essentially you absolutely want a function which gives this information to exporters. For the VFIO use case it doesn't matter because you can't switch the BAR for system memory.
> 
> To unblock you, please add a big fat comment in the kerneldoc of the mapping explaining this and that it might be necessary for exporters to call pci_p2pdma_map_type() as well.

Thanks,

What do you think about it?

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index a69bb73db86d..05ec84a0157b 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -84,6 +84,11 @@ struct dma_buf_dma {
  * PAGE_SIZE aligned.
  *
  * A mapping must be unmapped by using dma_buf_free_sgt().
+ *
+ * NOTE: While this function is intended for DMA-buf importers, it is critical
+ * that the DMA-buf exporter is capable of performing peer-to-peer (P2P) DMA
+ * directly between PCI devices, without routing transactions through the host
+ * bridge.
  */
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
                                         struct p2pdma_provider *provider,
(END)


> 
> Regards,
> Christian.
> 
> > 
> > https://lore.kernel.org/all/aPYrEroyWVOvAu-5@infradead.org/
> > 
> > Thanks
> > 
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>> We can also have a mini-community call to give a summary/etc on these
> >>> topics.
> >>>
> >>> Thanks,
> >>> Jason
> >>
> 

