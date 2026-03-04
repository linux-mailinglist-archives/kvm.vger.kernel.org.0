Return-Path: <kvm+bounces-72765-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIIvAlzFqGlnxAAAu9opvQ
	(envelope-from <kvm+bounces-72765-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:50:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B830209247
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3E08930421C5
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B16382366;
	Wed,  4 Mar 2026 23:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="oqDURzXU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="J9oJ8SAE"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5433382E7;
	Wed,  4 Mar 2026 23:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772668122; cv=none; b=tQ7rCV3JNToy1OuAAOfwI36WNG1G/RvD9qfLM62c2/JXMgFznePVFCQuTaYMbM0XpmewhSYmrBqpzT1X9gRqk3hJMemSU6y8YtBdgdUb8Dm/B3JvFlLJQlrfQy2AVKSBDTAT6fY70GtlJairuerwmDBGwbLQK4RjVh/xrmmedL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772668122; c=relaxed/simple;
	bh=Dr10Lij63SnxQpzVRiJDFpBq/pxd/nKkxWEWJ/RFG8U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVvgZkKyOcLWfTKyLQlBTF3TBdeX1s4x4+1IzOI0oVVOXCn7WY6fplJTtpNwWTyh2eQh+adNSvLd7wSv5569FOE80+BAN51TE9MXcqLiN+5M3SST0LhtiN2JqjICxrNN3fitcL6V1yRZf3KQ2eoAFma74YFaiukgb+hmpyS/73s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=oqDURzXU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=J9oJ8SAE; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 4BEAF1D00150;
	Wed,  4 Mar 2026 18:48:39 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 04 Mar 2026 18:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772668119;
	 x=1772754519; bh=3mOskS7PxuDxXt92IKRpDzkB9vYUmNu9ssp+DhgjTbM=; b=
	oqDURzXU9O0WeacR0Y7wDvAo5FITo6dy50tsXS6Bl+SMmCK5goSsJ54GBr9W/RsH
	vh3Mrpe+Tb6w+YUGC6fEGozAFzRme7n+Nc+XtBelieUHBOki+KPScLwFJRBnABJC
	rl3Dc5Z+F+TLmTCl56k6E+98HhnLEhWP3g5R2pptmNzGFe4gbif01RP3yl0hcTAf
	TIaSonsmq0ZFDNPUhZc1WC4XfhUhPsISkeia4YaHg2CzrjmnwBajX550xUPaqjEo
	q4drC4G1CAGhufiC6AvYyDbb3oGW6qd2CwaqrZNQ2X4LMQFUhjgCVONdo7Vh9hHE
	uOem+17Hz19pR6wLZRvN3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772668119; x=
	1772754519; bh=3mOskS7PxuDxXt92IKRpDzkB9vYUmNu9ssp+DhgjTbM=; b=J
	9oJ8SAEone3EpsHDgBLZnz/FGEoq9HPEE/BJ7IGY2KggYP/j86v+ogAj5cMxYxnK
	Pn+aLr7N3HAAcJJzZW2E80nQAWqRyq/mZLCdjUwqVJdGKG310fUtD8pjd5pLkB68
	5jW4vQiK0Z/Tvn9irqEGJlqkoXnMhp6ftynTPlIvQbLo0ckxbIEe5ZF3m2uhOYyP
	FOMwGbgc0uDE4aAdiN35PVTQOHGt/wZbwByWlDffkZ2Xua11otTOpANJb6OW9f2A
	UMlyDzI1p3weoPgg+1685YDjkYUSKOp8zn3sMDKkaudMV5YMcqJ1eEWdsGIkeDo7
	dCV5CujghGvkPGcigdUyw==
X-ME-Sender: <xms:1sSoaT4kIfiPtAL0aaHyGCe3QgneHVgGeR04CzcqzV59fPeKyLrPag>
    <xme:1sSoaXaqPrkjSSml5oYmp-1iwlQpqNGCMPfNqQbqnSxz6TJifTLE6rodGQvbzROEq
    _yYw8FRyRxjiHSWGg8TouBJjF-X3XLhmrnLhmuCCJIyXDdGc-yMTks>
X-ME-Received: <xmr:1sSoaV_XukN6MGMW9prcObi4_n8A6FHJX0GqRJ5PWHk7bVzzBKH0D6CrOGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegkeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhi
    thgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepmhho
    tghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphht
    thhopegtjhhirgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepiihhihifsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehkjhgrjhhusehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:1sSoaeSgHITnIVLRQgyAaLn9L4x4NenSk702q-tJQta9r84FulkNZw>
    <xmx:1sSoaQLZzUNZ1MvAcxGH0PyqTMxawM7NuumHNSPOAkke_aNTHFjHhw>
    <xmx:1sSoaQTDMNygn_f4ifZuV0NMH8ufyxh2Doi9l-ayeiKZspOKJaC4wg>
    <xmx:1sSoaYK13VbwblXB-j2ObodFIQGRfaITaDef1Zq7A443onK7xKz7Gw>
    <xmx:18SoacvbRYwoUAM0Cmu6NW8VyDv5ebhhb6sDW6dtUx03lzqotoCkwvUK>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 18:48:37 -0500 (EST)
Date: Wed, 4 Mar 2026 16:48:36 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 15/15] vfio/nvgrace-egm: register EGM PFNMAP
 range with memory_failure
Message-ID: <20260304164836.11ece0f5@shazbot.org>
In-Reply-To: <20260223155514.152435-16-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-16-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5B830209247
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72765-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,messagingengine.com:dkim,nvidia.com:email,shazbot.org:dkim,shazbot.org:mid]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:14 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> EGM carveout memory is mapped directly into userspace (QEMU) and is not
> added to the kernel. It is not managed by the kernel page allocator and
> has no struct pages. The module can thus utilize the Linux memory manager's
> memory_failure mechanism for regions with no struct pages. The Linux MM
> code exposes register/unregister APIs allowing modules to register such
> memory regions for memory_failure handling.
> 
> Register the EGM PFN range with the MM memory_failure infrastructure on
> open, and unregister it on the last close. Provide a PFN-to-VMA offset
> callback that validates the PFN is within the EGM region and the VMA,
> then converts it to a file offset and records the poisoned offset in the
> existing hashtable for reporting to userspace.

So the idea is that we kill the process owning the VMA and add the page
to the hash such that the next user process avoids it, and this is what
encourages userspace to consume the bad page list?

> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 100 +++++++++++++++++++++++++++++
>  1 file changed, 100 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index 2e4024c25e8a..5b60db6294a8 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -6,6 +6,7 @@
>  #include <linux/vfio_pci_core.h>
>  #include <linux/nvgrace-egm.h>
>  #include <linux/egm.h>
> +#include <linux/memory-failure.h>
>  
>  #define MAX_EGM_NODES 4
>  
> @@ -23,6 +24,7 @@ struct chardev {
>  	struct cdev cdev;
>  	atomic_t open_count;
>  	DECLARE_HASHTABLE(htbl, 0x10);
> +	struct pfn_address_space pfn_address_space;
>  };
>  
>  static struct nvgrace_egm_dev *
> @@ -34,6 +36,94 @@ egm_chardev_to_nvgrace_egm_dev(struct chardev *egm_chardev)
>  	return container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
>  }
>  
> +static int pfn_memregion_offset(struct chardev *egm_chardev,
> +				unsigned long pfn,
> +				pgoff_t *pfn_offset_in_region)
> +{
> +	unsigned long start_pfn, num_pages;
> +	struct nvgrace_egm_dev *egm_dev =
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +
> +	start_pfn = PHYS_PFN(egm_dev->egmphys);
> +	num_pages = egm_dev->egmlength >> PAGE_SHIFT;
> +
> +	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
> +		return -EFAULT;
> +
> +	*pfn_offset_in_region = pfn - start_pfn;
> +
> +	return 0;
> +}
> +
> +static int track_ecc_offset(struct chardev *egm_chardev,
> +			    unsigned long mem_offset)
> +{
> +	struct h_node *cur_page, *ecc_page;
> +
> +	hash_for_each_possible(egm_chardev->htbl, cur_page, node, mem_offset) {
> +		if (cur_page->mem_offset == mem_offset)
> +			return 0;
> +	}
> +
> +	ecc_page = kzalloc(sizeof(*ecc_page), GFP_NOFS);
> +	if (!ecc_page)
> +		return -ENOMEM;
> +
> +	ecc_page->mem_offset = mem_offset;
> +
> +	hash_add(egm_chardev->htbl, &ecc_page->node, ecc_page->mem_offset);
> +
> +	return 0;
> +}

How do concurrent faults work?  No locking on the hash table.

> +
> +static int nvgrace_egm_pfn_to_vma_pgoff(struct vm_area_struct *vma,
> +					unsigned long pfn,
> +					pgoff_t *pgoff)
> +{
> +	struct chardev *egm_chardev = vma->vm_file->private_data;
> +	pgoff_t vma_offset_in_region = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	pgoff_t pfn_offset_in_region;
> +	int ret;
> +
> +	ret = pfn_memregion_offset(egm_chardev, pfn, &pfn_offset_in_region);
> +	if (ret)
> +		return ret;
> +
> +	/* Ensure PFN is not before VMA's start within the region */
> +	if (pfn_offset_in_region < vma_offset_in_region)
> +		return -EFAULT;
> +
> +	/* Calculate offset from VMA start */
> +	*pgoff = vma->vm_pgoff +
> +		 (pfn_offset_in_region - vma_offset_in_region);
> +
> +	/* Track and save the poisoned offset */
> +	return track_ecc_offset(egm_chardev, *pgoff << PAGE_SHIFT);
> +}
> +
> +static int
> +nvgrace_egm_vfio_pci_register_pfn_range(struct inode *inode,
> +					struct chardev *egm_chardev)

What does this have to do with vfio-pci?  It's not even a device
address space.  Thanks,

Alex

> +{
> +	struct nvgrace_egm_dev *egm_dev =
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +	unsigned long pfn, nr_pages;
> +	int ret;
> +
> +	pfn = PHYS_PFN(egm_dev->egmphys);
> +	nr_pages = egm_dev->egmlength >> PAGE_SHIFT;
> +
> +	egm_chardev->pfn_address_space.node.start = pfn;
> +	egm_chardev->pfn_address_space.node.last = pfn + nr_pages - 1;
> +	egm_chardev->pfn_address_space.mapping = inode->i_mapping;
> +	egm_chardev->pfn_address_space.pfn_to_vma_pgoff = nvgrace_egm_pfn_to_vma_pgoff;
> +
> +	ret = register_pfn_address_space(&egm_chardev->pfn_address_space);
> +
> +	return ret;
> +}
> +
>  static int nvgrace_egm_open(struct inode *inode, struct file *file)
>  {
>  	struct chardev *egm_chardev =
> @@ -41,6 +131,7 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
>  	struct nvgrace_egm_dev *egm_dev =
>  		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
>  	void *memaddr;
> +	int ret;
>  
>  	if (atomic_cmpxchg(&egm_chardev->open_count, 0, 1) != 0)
>  		return -EBUSY;
> @@ -77,6 +168,13 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
>  
>  	file->private_data = egm_chardev;
>  
> +	ret = nvgrace_egm_vfio_pci_register_pfn_range(inode, egm_chardev);
> +	if (ret && ret != -EOPNOTSUPP) {
> +		file->private_data = NULL;
> +		atomic_dec(&egm_chardev->open_count);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -85,6 +183,8 @@ static int nvgrace_egm_release(struct inode *inode, struct file *file)
>  	struct chardev *egm_chardev =
>  		container_of(inode->i_cdev, struct chardev, cdev);
>  
> +	unregister_pfn_address_space(&egm_chardev->pfn_address_space);
> +
>  	file->private_data = NULL;
>  
>  	atomic_dec(&egm_chardev->open_count);


