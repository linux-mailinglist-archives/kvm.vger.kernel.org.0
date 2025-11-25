Return-Path: <kvm+bounces-64565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 702B5C872A6
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4D4964E2C2D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224662E4257;
	Tue, 25 Nov 2025 20:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="1eLcx+xG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="0+m3gJbI"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCFC1D61A3;
	Tue, 25 Nov 2025 20:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103982; cv=none; b=P8vBplSkTeiQrQHf6YFfwHrN4qcezdnrGwxOW+MoRaqUTmJJnVlJIC9l8PptPg4SXoL44c7yx2U9KcVnxZs/5JWRZ5vDXendsCyLRlEnlkXzBJtvoPWwaorVe2Rffsqh551GGhraLJmzkyy2XEEr95v3A3HjN+1JCbP2ZQVviJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103982; c=relaxed/simple;
	bh=0ySHNVGY0A8ODZR+dlYCKirbuDTeOUFkfN6Pj/zrEzs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRLe8paEf/4jyya8Jw4PzDCl+2on/YlF9ZdFm2tybBOX3GKV4P9b5wzLgoAk7xLlrqM6VpTqOfMIb64kCI4pCtVgZ8+0MYtx23gO4bPb9ZafXPG1R88HmdhoQt+Kjg7hMwMoGDwsqHaeCRiahbS0HgSvxFvvRhmfOLvn4hC6e5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=1eLcx+xG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=0+m3gJbI; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A85967A01ED;
	Tue, 25 Nov 2025 15:52:58 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 25 Nov 2025 15:52:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764103978;
	 x=1764190378; bh=oeqWFmmGXGKlrK37kiF27K0HdSHYmMK2D7HExAf1V3Y=; b=
	1eLcx+xGZFo8iPp5o8dgkgYZ7MFPfEhg78WInDeoCq3WQEVhKwXP3p96nEl4nOMY
	BuiQj59NurWd+Z7UTM2jYshgCzpehXd7GP6VvoS026Bg6cxtHO2eTR0LWcq6l9WK
	S8ZTDXEtzg+UjjYVv9vfmsqiAPgeL/EL5GHuyUpHMPmQx6QC3UlduoqUcSOgqpON
	rtMXuH1vPamXjLMe6WhQltOed4h2/8zHS1pE2SS7dc+bbqNzfX+yxZ9sKPZauYIG
	xmE8t1k8paoHwFmHXjGLuS0F/6LhCp6rTzd8yCDKtB5iGBIFim9Xy2GJVQA8szX9
	vITeUziyzmaiZHAErQZaUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764103978; x=
	1764190378; bh=oeqWFmmGXGKlrK37kiF27K0HdSHYmMK2D7HExAf1V3Y=; b=0
	+m3gJbIbq7U7fFcVfNnwQMIKasyN9crPsVuTFqOK9/9BO2Z4jIrykchn3uKRTBcK
	/tzxFT9fGGeG/DGb1+/xDb6xLQD/WTPH6z6wmUkogoZ55pAZXSLd0NKzOgX4abPs
	/SS23lvl7UyuACOCIir3xluBCZvjFrLTzXphEKsBh77eCcWYNn2dV0VWBZ+0q3qU
	vwew4sCs4UfovwX1/Tulpd8rCsmcL2w9j3Tr94u98lGZIb4u+SLFWimgSdjoy2a6
	6pW195jBwdpZ/qBz6F+K8u7rCNwOOs9N0RYea3Ifk9uCnzYlDPIQrCYJEKnVWUGj
	z2DrqUCuWKLwi2M9MnO0A==
X-ME-Sender: <xms:KhcmaawvG4LflzALCocEgJXqxWtZB-N2xaL3-MWJuSUe0ELuYh7WIA>
    <xme:KhcmaRTl014Jq3rPqjfAHBq-yXzAhl3g71KT2UTs7g-bBtQD1Gko1COO1fBaP4KcU
    JoGrfOYsn30w-RoYRO2XxQvUN9FzNNys46Wi33re-aDOOpNClyo>
X-ME-Received: <xmr:KhcmaS_UQBVWy1P0h9L1kSw8Cjjbq7pzTuSpwQpLoyB0Dyrm7MjryzNI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgedvgeejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:KhcmaeKj2adlcMCpC6oY38VROsJ-CaAQbgsX-Ryzspv2dCHKFEj6Ug>
    <xmx:KhcmaWv5MGGlIOpJqtEZ8xk5KQg9UY4lsZpvJLNuKvVCCiut7GLz8Q>
    <xmx:KhcmaXmDNnOyWA2CY2ds2UaJaT4R_IjDzsBaCUjf2xC8l2yr0yPTGA>
    <xmx:Khcmadn8KlIj_VPISVMhqKAmSUSrEb9fb_6XCTjDRrue5XObL9xoSA>
    <xmx:KhcmaYFHHhwe4WBdNKX7uIScu3glYkBY1ObL_ScxRWHKC8DahTM_LMsR>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Nov 2025 15:52:56 -0500 (EST)
Date: Tue, 25 Nov 2025 13:52:47 -0700
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
Subject: Re: [PATCH v6 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after
 reset
Message-ID: <20251125135247.62878956.alex@shazbot.org>
In-Reply-To: <20251125173013.39511-6-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-6-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Nov 2025 17:30:12 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Introduce a new flag reset_done to notify that the GPU has just
> been reset and the mapping to the GPU memory is zapped.
> 
> Implement the reset_done handler to set this new variable. It
> will be used later in the patches to wait for the GPU memory
> to be ready before doing any mapping or access.
> 
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 2b736cb82f38..7d5544280ed2 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
>  	/* Lock to control device memory kernel mapping */
>  	struct mutex remap_lock;
>  	bool has_mig_hw_bug;
> +	/* GPU has just been reset */
> +	bool reset_done;
>  };
>  
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> @@ -1047,12 +1049,27 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
>  

/*
 * Comment explaining why this can't use lockdep_assert_held_write but
 * in vfio use cases relies on this for serialization against faults and
 * read/write.
 */

Thanks,
Alex


> +static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +	struct nvgrace_gpu_pci_core_device *nvdev =
> +		container_of(core_device, struct nvgrace_gpu_pci_core_device,
> +			     core_device);
> +
> +	nvdev->reset_done = true;
> +}
> +
> +static const struct pci_error_handlers nvgrace_gpu_vfio_pci_err_handlers = {
> +	.reset_done = nvgrace_gpu_vfio_pci_reset_done,
> +	.error_detected = vfio_pci_core_aer_err_detected,
> +};
> +
>  static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
>  	.name = KBUILD_MODNAME,
>  	.id_table = nvgrace_gpu_vfio_pci_table,
>  	.probe = nvgrace_gpu_probe,
>  	.remove = nvgrace_gpu_remove,
> -	.err_handler = &vfio_pci_core_err_handlers,
> +	.err_handler = &nvgrace_gpu_vfio_pci_err_handlers,
>  	.driver_managed_dma = true,
>  };
>  


