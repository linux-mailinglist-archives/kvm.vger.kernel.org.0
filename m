Return-Path: <kvm+bounces-72711-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPRJNBdvqGkkugAAu9opvQ
	(envelope-from <kvm+bounces-72711-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:42:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F39205526
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B539C3026077
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE423C6A27;
	Wed,  4 Mar 2026 17:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="YEoT0v08";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PFEK0y6c"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1040C3A4526;
	Wed,  4 Mar 2026 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772645833; cv=none; b=OEbO8TyPL4u30EufnmQdOfK/YL0L5WM4B3GJHYlmvbJCyCc8P9VHnN7bwph5mFnytDLuvnhHSa2UnezbBPDCnjJgsIKcb0OGw8WNQUQIpB1hL6Zo5Elz/uHSbWJvpQp7d4riB/Ra90QupF/5BgLck4JT9t8b0aVzyQjDcwtvewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772645833; c=relaxed/simple;
	bh=TDwnxfKFFtxLwUo8WPv0xYnSvf9MRRp9O6kGck/X7bc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaGXMgXsYDDc8XD1i77Armw192y/PtbVUMCF9klvm2c2N0GJDFwvNRRvPtW721PNZEOsU5EFaNHn0eGpwDZEfM02rYrEfaxads0MHQKn9b87eltPdnbX7LPAsYNeXeVl5G9G2vf2Uvoo9lV26wqGAKu66dfZ251DKMe67WDITCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=YEoT0v08; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PFEK0y6c; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 3DEB9EC0252;
	Wed,  4 Mar 2026 12:37:10 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 04 Mar 2026 12:37:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772645830;
	 x=1772732230; bh=GF1sFuK7qL53Z0d3vrdXkKeEbDwG1wWaAzO81Y/5Aco=; b=
	YEoT0v08wf39k7Db83EtWbT9xlhOAB7QFckS7dFm76XWijeXmU+rWkLbGQzU6qrs
	abJMn3rl4AqukhtQhcVKiZAGtvHHIEeB8ni3W1QZ5n1mlPT/ut9oZq/k/kBm2KLj
	XxrbYHCiAKNwfYFEWHoZBtG7ffjXc8Od9r06Nuk5radEVpT5Ce6TBv2y6j/oQhVo
	rn+xST7O936cTTbvvfOI4/v7VFV1eCe/51U7N06e4GfTyhwmPYYlj7Q6OMQR5Uj9
	qSOHkVGzcwnKV02ixWHizy3lCqDtZ3tpYhV7Jx7+KeOC57g39SQC7K1VLNg544FP
	HMq4aVwdVTqYIQ2+2LL2pQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772645830; x=
	1772732230; bh=GF1sFuK7qL53Z0d3vrdXkKeEbDwG1wWaAzO81Y/5Aco=; b=P
	FEK0y6cqNuwUd2hN2TFm/nZDbWeMNRkwV3dRyJUftOrrhclBmbjdq0/Iwwv3XEci
	fuurEPHVChTcwi0b/MKGHi0JIYY2W1UZvEA4QcV7i+ClqeoubNe9OltiV/iZqxGu
	6lY3plth9gDVmLq8W+DfCKaVO/QsA1B7boBf6rgiq6X5CooVSs9g4f3R08fbWkS1
	YYPasfhusIVImzDKPK72qyojJSt5kXuH7rjenN0YTI9czCWGpcLo7W81to53bEn9
	Z7TZgRX2zPNnddXYE+n5Inq1o+FyqBUiHNhF7FYk9M4el4MbVSEzhVbYEjab145O
	ZSEyyucTAwY6PCZ7YOQqA==
X-ME-Sender: <xms:xW2oaUCokzcUiZBq-0AAm1NtteQtuBRYQrGi1htJYzOtlIlBuAcaqA>
    <xme:xW2oabtqiB493UmNw09YhzpgLsxCUDsOBaMMpnzVY1kbysub3D0kJt2W1QPbahCt3
    NjAl3HXy_3APFed9Feggi8vPtHvAUoKP7H4C6YoidPYRxMhU1pkow>
X-ME-Received: <xmr:xW2oaa_7xz1BU4JsuktDhWe7pvkDWDe-o6Ve_2eyCsSk5wtfD3m4q_U-yrY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieeguddvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:xm2oaaSit191Etk5gKLWpcQ1-2j7DIymC4Xx1zQO7AbqWZ213c5J-g>
    <xmx:xm2oaUUr-8bGgaZz5puCPyvPOaFbciConwXiUJ9R2xg5AflaN6XeJA>
    <xmx:xm2oaU_qTVx7pG7frPaHCkr-eqjtL-9285elvDuh64F-0LatpbHVtg>
    <xmx:xm2oac1OPxNzrmiAp9IKPOY4N-jLA4UQHBlLorxWQNZVpluc0s7nxg>
    <xmx:xm2oaacpQi0cAUVch09Z4SA36xHpH_GlMgqmSh802IKkgRZ7OJhForGr>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 12:37:08 -0500 (EST)
Date: Wed, 4 Mar 2026 10:37:07 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 04/15] vfio/nvgrace-gpu: Introduce functions to
 fetch and save EGM info
Message-ID: <20260304103707.02e05918@shazbot.org>
In-Reply-To: <20260223155514.152435-5-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-5-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A9F39205526
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72711-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,shazbot.org:dkim,shazbot.org:mid,messagingengine.com:dkim]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:03 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The nvgrace-gpu module tracks the various EGM regions on the system.
> The EGM region information - Base SPA and size - are part of the ACPI
> tables. This can be fetched from the DSD table using the GPU handle.
> 
> When the GPUs are bound to the nvgrace-gpu module, it fetches the EGM
> region information from the ACPI table using the GPU's pci_dev. The
> EGM regions are tracked in a list and the information per region is
> maintained in the nvgrace_egm_dev.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 24 +++++++++++++++++++++++-
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++-
>  drivers/vfio/pci/nvgrace-gpu/main.c    |  8 ++++++--
>  include/linux/nvgrace-egm.h            |  2 ++
>  4 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> index 0bf95688a486..20291504aca8 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -17,6 +17,26 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
>  					pegmpxm);
>  }
>  
> +int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> +				   u64 *pegmlength)
> +{
> +	int ret;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,egm-base-pa and nvidia,egm-size.
> +	 */
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-size",
> +				       pegmlength);
> +	if (ret)
> +		return ret;
> +
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
> +				       pegmphys);
> +
> +	return ret;
> +}

What guarantees that all GPUs in the same PXM have the same properties?
AIUI we only consume the resulting properties for the first GPU
associated to the egm_dev.  Why do we even bother to retrieve the
properties for subsequent GPUs?

Nit, it's a bit inconsistent to partially write caller data on error
versus read to local variables and set the caller data only on success.
Thanks,

Alex

> +
>  int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
>  {
>  	struct gpu_node *node;
> @@ -54,7 +74,7 @@ static void nvgrace_gpu_release_aux_device(struct device *device)
>  
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmpxm)
> +			      u64 egmphys, u64 egmlength, u64 egmpxm)
>  {
>  	struct nvgrace_egm_dev *egm_dev;
>  	int ret;
> @@ -64,6 +84,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
>  		goto create_err;
>  
>  	egm_dev->egmpxm = egmpxm;
> +	egm_dev->egmphys = egmphys;
> +	egm_dev->egmlength = egmlength;
>  	INIT_LIST_HEAD(&egm_dev->gpus);
>  
>  	egm_dev->aux_dev.id = egmpxm;
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> index 1635753c9e50..2e1612445898 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -16,6 +16,8 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
>  
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmphys);
> +			      u64 egmphys, u64 egmlength, u64 egmpxm);
>  
> +int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> +				   u64 *pegmlength);
>  #endif /* EGM_DEV_H */
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 3dd0c57e5789..b356e941340a 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -78,7 +78,7 @@ static struct list_head egm_dev_list;
>  static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  {
>  	struct nvgrace_egm_dev_entry *egm_entry = NULL;
> -	u64 egmpxm;
> +	u64 egmphys, egmlength, egmpxm;
>  	int ret = 0;
>  	bool is_new_region = false;
>  
> @@ -91,6 +91,10 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
>  		goto exit;
>  
> +	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength);
> +	if (ret)
> +		goto exit;
> +
>  	list_for_each_entry(egm_entry, &egm_dev_list, list) {
>  		/*
>  		 * A system could have multiple GPUs associated with an
> @@ -110,7 +114,7 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  
>  	egm_entry->egm_dev =
>  		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
> -					      egmpxm);
> +					      egmphys, egmlength, egmpxm);
>  	if (!egm_entry->egm_dev) {
>  		ret = -EINVAL;
>  		goto free_egm_entry;
> diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
> index e42494a2b1a6..a66906753267 100644
> --- a/include/linux/nvgrace-egm.h
> +++ b/include/linux/nvgrace-egm.h
> @@ -17,6 +17,8 @@ struct gpu_node {
>  
>  struct nvgrace_egm_dev {
>  	struct auxiliary_device aux_dev;
> +	phys_addr_t egmphys;
> +	size_t egmlength;
>  	u64 egmpxm;
>  	struct list_head gpus;
>  };


