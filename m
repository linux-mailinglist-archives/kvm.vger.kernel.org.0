Return-Path: <kvm+bounces-61259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E83C129AF
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 02:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1ADD1A224D1
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFECF265281;
	Tue, 28 Oct 2025 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="fMCPwrKW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CkhFTCz5"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04BF54652;
	Tue, 28 Oct 2025 01:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761616661; cv=none; b=FSHonAlC/7nHB+nTsh57WPXRWZaa/W3fTivUVCK2CY4kkuCQyvdt8nFahlzAdq5+Ca7dArAoMoTwyIvNAi9hWfGsIcrGOnj3mSfyejgm4Np9LyzpYo/HYRvryQ5vKAGWnpj2u8pnDFcHR2ZKOnj2VQgp1DLnh7AcdQ7JnrWb9kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761616661; c=relaxed/simple;
	bh=8fcf2xi8Tp6koExwjk5eGsIG6oSBBq2uYlg7ArkbYRg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lemVE5UouAUqGcYRa6T6d6eEid8FUqCREzK7Scd8Pmbx0oW9Qr+vOX1w7sSdIqsnyLELkiid6qBfLYdzkHmh4CuRYVIPCz6hY9BaoHlpgZKG9KyWJEMFuyb7jPabGqv/294++yDKvqqS4wo0L6XiVtZ8n+P8hsVhS7eS7D5DoZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=fMCPwrKW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CkhFTCz5; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id B6727EC0406;
	Mon, 27 Oct 2025 21:57:36 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 27 Oct 2025 21:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761616656;
	 x=1761703056; bh=XBjHA7L9P0wzKRSxKX3F3G/r6tzRjlUTprVSDB/LgG4=; b=
	fMCPwrKWS4rMUBQ4nT0/2jFBfkpOWqzGMZs6rE5XKj6UWPLzzc8FHCabwMqleGB4
	wlT9M5Wexu/oQZB8OExQGUyywmdPCNbbVp9+bKGx7qMOuJad1HPh8FTnBi/cJh/Q
	HYZNM6ywm9sVze+cCLp4AiOqlxx3QIhWxd7gglTsx6P/Y/Or0V6o1EB0qus6qgVQ
	YkbjVQqbhj69cfnJv5P4ROw9P5aoAugkVPPNLpd8WIJRyBLoLZHAo07iEI6tVSur
	tMyHkp8fn5JUEWdmH1+Z2kIDm/sM3v3TyLjgUNPRPtldjINO2fIwI228Yfs2MgvT
	00tnPc9aiZpX2Pydk82xFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761616656; x=
	1761703056; bh=XBjHA7L9P0wzKRSxKX3F3G/r6tzRjlUTprVSDB/LgG4=; b=C
	khFTCz5HE7AsKaqVXHC1iTjZAr4ucmXRyG6CkHqYHxW03BlivgzPMpIlcE3XHoIt
	iiM3fl3aJ0iboDivzhlLLKS9MsE03e9V15BE3UBMLs+WnJGhyG2kXtisrbE+DnH8
	zMSfpRCia4FA3u9bijZGNk2eANPy1uTF3I7cQMdRMvhmlnNNZEHJ0cNlwJjwXOlP
	hrkB7ygt9TX5nr+KABfv3Dt4KfOF9tLFnUvbegCfyJrhzpDT3jjfLAeEO4WcAuhr
	TUD+Su9WixNSgKf44YWoFjkvhEW09bULcF7r7lXQNjNGZMx8c4xdOx2C/rEX7Tfs
	CSO4g01RF4MK9gos9kSbg==
X-ME-Sender: <xms:DyMAaaGeUoBAQHHsIvDr5l2a0qM61NXO1ly9e_IbON_1z9Mr8xvXrg>
    <xme:DyMAaUqgC5wmQO6YB7WiueT46RIX0eIrA_2DFH26SOFzoP2mYCX2Pd4uXucsJK1pJ
    eJgZat4jjui7RsXy80jVb52sDr1iJ0DOPUqa-jHBOIJXd2KyhMQVQ>
X-ME-Received: <xmr:DyMAabaKozkE-aiN5CyAOcfGce3-BH501DN0QbH4P4oTCedl9ziH-hsO1Vc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheelheelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeeipdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrmhgrshhtrhhosehfsgdrtghomhdprhgtphhtthhope
    grlhgvjhgrnhgurhhordhjrdhjihhmvghnvgiisehorhgrtghlvgdrtghomhdprhgtphht
    thhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:DyMAaVWyObzMWBMDLNjQbYK6v1tCWgVYwg2FX5-_wYHaFGWtSV7q-g>
    <xmx:DyMAac_CLSUgKQ_nbyf4IYopgYeJ4ygCtQYqVx_S4PQMX76U-UOKUw>
    <xmx:DyMAaW_wIwmhHHRjmbWEzsl6hbkKDhe5kJGJS2OQIBFk3IVAHKVtUg>
    <xmx:DyMAaUT16AGKI_s2d_WpjUBmGkBGUJ29zspdlPqMLtqAVcRNveWzKA>
    <xmx:ECMAaRJYfQ_doyWOfakKQj4p0wvG2dLTZU6X4Fg3Cb-3U9Kp80930WoL>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Oct 2025 21:57:35 -0400 (EDT)
Date: Mon, 27 Oct 2025 19:57:32 -0600
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251027195732.2b7d1d3f@shazbot.org>
In-Reply-To: <aP+Xr1DrNM7gYD8v@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
	<20251015132452.321477fa@shazbot.org>
	<3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
	<aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
	<20251016160138.374c8cfb@shazbot.org>
	<aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
	<20251020153633.33bf6de4@shazbot.org>
	<aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
	<aP+Xr1DrNM7gYD8v@devgpu012.nha5.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Oct 2025 09:02:55 -0700
Alex Mastro <amastro@fb.com> wrote:

> On Tue, Oct 21, 2025 at 09:25:55AM -0700, Alex Mastro wrote:
> > On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:     
> > > Along with the tag, it would probably be useful in that same commit to
> > > expand on the scope of the issue in the commit log.  I believe we allow
> > > mappings to be created at the top of the address space that cannot be
> > > removed via ioctl, but such inconsistency should result in an
> > > application error due to the failed ioctl and does not affect cleanup
> > > on release.  
> 
> I want to make sure I understand the cleanup on release path. Is my supposition
> below correct?
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 916cad80941c..7f8d23b06680 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1127,6 +1127,7 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
>  static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  			     bool do_accounting)
>  {
> +	// end == 0 due to overflow
>  	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
>  	struct vfio_domain *domain, *d;
>  	LIST_HEAD(unmapped_region_list);
> @@ -1156,6 +1157,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	}
>  
>  	iommu_iotlb_gather_init(&iotlb_gather);
> +	// doesn't enter the loop, never calls iommu_unmap

If it were only that, I think the iommu_domain_free() would be
sufficient, but it looks like we're also missing the unpin.  Freeing
the IOMMU domain isn't going to resolve that.  So it actually appears
we're leaking those pinned pages and this isn't as self-resolving as I
had thought.  I imagine if you ran your new unit test to the point where
we'd pinned and failed to unpin the majority of memory you'd start to
see system-wide problems.  Thanks,

Alex

>  	while (iova < end) {
>  		size_t unmapped, len;
>  		phys_addr_t phys, next;
> @@ -1210,6 +1212,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  {
>  	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
> +	// go here
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> @@ -2394,6 +2397,8 @@ static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
>  	struct rb_node *node;
>  
>  	while ((node = rb_first(&iommu->dma_list)))
> +		// eventually, we attempt to remove the end of address space
> +		// mapping
>  		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
>  }
>  
> @@ -2628,6 +2633,8 @@ static void vfio_release_domain(struct vfio_domain *domain)
>  		kfree(group);
>  	}
>  
> +	// Is this backstop what saves us? Even though we didn't do individual
> +	// unmaps, the "leaked" end of address space mappings get freed here?
>  	iommu_domain_free(domain->domain);
>  }
>  
> @@ -2643,10 +2650,12 @@ static void vfio_iommu_type1_release(void *iommu_data)
>  		kfree(group);
>  	}
>  
> +	// start here
>  	vfio_iommu_unmap_unpin_all(iommu);
>  
>  	list_for_each_entry_safe(domain, domain_tmp,
>  				 &iommu->domain_list, next) {
> +		// eventually...
>  		vfio_release_domain(domain);
>  		list_del(&domain->next);
>  		kfree(domain);


