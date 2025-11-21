Return-Path: <kvm+bounces-64173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AF149C7AE3E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 17:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5C1F6362490
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113262EC0AE;
	Fri, 21 Nov 2025 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="b2bmLzWx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="K2lXWo4V"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20B72E975E;
	Fri, 21 Nov 2025 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743198; cv=none; b=rdH1R2jO5+V4hYMCZl4dYitZz2VqcQc6dqTiNyL4VKwCAvbcY10zFZRWIq9UTn1BftLkBd3kLEvXc9ozPQa+Iz7gzh+Wwb+XB9XcW5s7wIUQv6qTYIWDkjsRESKbj0B7G9YuSPPldjS8KNmMpSC5dKXlRFhNAuncoJEK+FbhCuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743198; c=relaxed/simple;
	bh=pLSteAI+oJUzoyvG4+tMoWY1EZbLNK4r86RmjO8ULyI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhAO/h2S+3zJtRNvq0ZdKTg4tnYTP0B6ad8HmgHmYNxGM9T9QWNgZ6xhvK3oSPTjM5bUE5DzSu3Ykmcp5trRx7PEht6hsHwTR67hILWJahYDm7V2wTu9XCVRPjBKaaiRqov0a+/WiQDickKSsrzKvxKAlV1wwfRPAzl4GLlfj6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=b2bmLzWx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=K2lXWo4V; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 4EBB41D0017D;
	Fri, 21 Nov 2025 11:39:55 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 21 Nov 2025 11:39:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763743195;
	 x=1763829595; bh=gZnVbq4nb10sh36i+y6sNyy30aoKRE+ijpOQ0H6EJTc=; b=
	b2bmLzWx4KOr6gZkfIhMYmOUp+Emv3W1biPmXGjmOa7tUEYDpLEQJgzlwXp548t8
	asbIImbnvtZ3p9jsciwpX2Rkh+P5t1Z8zSfxtbU6fZ2DIhmxvC3lHmLRDyFPK0D+
	Uc2xF/LZHAZgKyPT0AEo9cNRKx7NgSglZOhSWJojUCXOOjpPRjaub7h5RF1lu/Up
	eJGYMuXPHuNsZeWxeRDLzTyCNEIbbsmqjmAdOoQO8o6LSU10NeA67bWAEXNLU/h/
	5QTLhXzHoAT9c79f5G/H4HAdLuzdVIN+ydHLkWhiTgbr3v9idjQB3mMcWM9A/WEe
	7O3ph3FS/9VGqvMG+NtqRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763743195; x=
	1763829595; bh=gZnVbq4nb10sh36i+y6sNyy30aoKRE+ijpOQ0H6EJTc=; b=K
	2lXWo4VJSyEErYjnh5hClTsH03KYVsS62intwYyuUpRun+GUUJAnbD/XRoassgwO
	gzf58Gu4jnKQxk32WW6uRjyQRfcARvCm6kheCjwfe7gvWhNX6r8DoOEFMt2uwh3z
	ANbgYIpdYyoy6aaO2yIgO4fSUEfNHHy6eYLxehiESRsqfamBjbbK7RvvmNyM1K8g
	itQ7zpvQ8idTXSOqu0aNj6bf3Fr//soarg6bbxQsfhViow/lgu5SK+1usCdof64G
	UX4sVn0OGv2Pz6BBb2E52ayKMd4gZYSz9YjSLby4aI8vUwscDVgkH6zVe0kkiRMU
	n9lzifPbvBPl0EZiATLQw==
X-ME-Sender: <xms:2ZUgaX6Jo33Z8YYWdo5lnF3dUPoedLPOBMbrXIgBWauBemtTElWKrg>
    <xme:2ZUgaX7PLOLB-mIzGmsag2PTpm-zTeFyh79jnWrvyrvFiJT8ZMIeQSwXzj4oiaGuw
    bJg689aJt0siJ80CsT87QAN7q6q71TBqHAhuiSHoXfmaO-1S6AfxM0>
X-ME-Received: <xmr:2ZUgaVHfb-pRse0iK9F_iLXspF0Fy_10xaI6d0tb9dvuxhBRHlxdhuzG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfedtgeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepvdehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhkihht
    rgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtg
    hpthhtohephihishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehkvghvihhnrdhtih
    grnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrnhhikhgvthgrsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohephihunhigihgrnhhgrdhl
    ihesrghmugdrtghomh
X-ME-Proxy: <xmx:2ZUgaVztOXAVk4umxZU9sDVJoWcxXH6Qt1ZUQTNGOtEgwB8d-isSBA>
    <xmx:2ZUgaV3eq7wpsKF5NuujsR4FAUcXh8wqcb45qNXRP2LNKVc8aaQnoA>
    <xmx:2ZUgaYNqU7vDHeF26H-1FdgXDzgKcLCTLeT_V5V-a48KYOAMXCTj_g>
    <xmx:2ZUgaRtYRKcMMmLw9G-ANYrre5_VbPUIfnDOsfllvClHSQE__gPIDw>
    <xmx:25Ugaclw6dOTBGyfTH5TuRt1cpR17rsuAQdGEWF28gQnpuwefzsqs-Nf>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Nov 2025 11:39:51 -0500 (EST)
Date: Fri, 21 Nov 2025 09:39:49 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
 <kevin.tian@intel.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
 <mochs@nvidia.com>, <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
 <zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
 <bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
 <apopple@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <danw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: Re: [PATCH v3 5/7] vfio: move barmap to a separate function and
 export
Message-ID: <20251121093949.54f647a6.alex@shazbot.org>
In-Reply-To: <20251121141141.3175-6-ankita@nvidia.com>
References: <20251121141141.3175-1-ankita@nvidia.com>
	<20251121141141.3175-6-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Nov 2025 14:11:39 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Move the code to map the BAR to a separate function.
> 
> This would be reused by the nvgrace-gpu module.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 38 ++++++++++++++++++++++----------
>  include/linux/vfio_pci_core.h    |  1 +
>  2 files changed, 27 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 29dcf78905a6..d1ff1c0aa727 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1717,6 +1717,29 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
>  #endif
>  };
>  
> +int vfio_pci_core_barmap(struct vfio_pci_core_device *vdev, unsigned int index)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int ret;
> +
> +	if (vdev->barmap[index])
> +		return 0;
> +
> +	ret = pci_request_selected_regions(pdev,
> +					   1 << index, "vfio-pci");
> +	if (ret)
> +		return ret;
> +
> +	vdev->barmap[index] = pci_iomap(pdev, index, 0);
> +	if (!vdev->barmap[index]) {
> +		pci_release_selected_regions(pdev, 1 << index);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_core_barmap);

Looks a lot like vfio_pci_core_setup_barmap() ;)

Thanks,
Alex


> +
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
>  {
>  	struct vfio_pci_core_device *vdev =
> @@ -1761,18 +1784,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	 * Even though we don't make use of the barmap for the mmap,
>  	 * we need to request the region and the barmap tracks that.
>  	 */
> -	if (!vdev->barmap[index]) {
> -		ret = pci_request_selected_regions(pdev,
> -						   1 << index, "vfio-pci");
> -		if (ret)
> -			return ret;
> -
> -		vdev->barmap[index] = pci_iomap(pdev, index, 0);
> -		if (!vdev->barmap[index]) {
> -			pci_release_selected_regions(pdev, 1 << index);
> -			return -ENOMEM;
> -		}
> -	}
> +	ret = vfio_pci_core_barmap(vdev, index);
> +	if (ret)
> +		return ret;
>  
>  	vma->vm_private_data = vdev;
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index a097a66485b4..75f04d613e0c 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -121,6 +121,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
>  		size_t count, loff_t *ppos);
>  vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf, unsigned long pfn,
>  			    unsigned int order);
> +int vfio_pci_core_barmap(struct vfio_pci_core_device *vdev, unsigned int index);
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
>  void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
>  int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);


