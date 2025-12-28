Return-Path: <kvm+bounces-66726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49121CE5753
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 21:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4EB82300983B
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 20:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832FA275AFD;
	Sun, 28 Dec 2025 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="B1E0wpsM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="b+8+aWpM"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8170F38DD3;
	Sun, 28 Dec 2025 20:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766954878; cv=none; b=EwSbI9O+a6eucsgVl3JcXWrAIVoDoVb5pZ/xJJusL2J7qWJdlEFRW6LjGkPvMkstRk3YrSFufUf9/VnldvLXqFqd9YJQUu++Q9hsuVuMRYh2KMQ5QJ+j/Mc5ohfNrxygkO9A4eGTHEiyGMY4RpNMIJkcYocH7Q/l38TqavVtgOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766954878; c=relaxed/simple;
	bh=YymCIV37LwleL4G3xZsnr9uhARJyzYmZKmlEssmIjDc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DQE/iLAYS/gSIJYEcTHRKz0z5Zwk1wI1OHaJB7Nfrp6l6qdgK5Dhxhp7IA/Kxrosf5b0ePje5980M/hp9+rH5SJiIVFRHo3pubOU1DoEz/wB1jsgZsQX0QeGsxJjNkFsA+j5raxMx4ZzDuTMPP+iG2BrwkD14wBjWV5ahWxY12k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=B1E0wpsM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=b+8+aWpM; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 687037A003E;
	Sun, 28 Dec 2025 15:47:53 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Sun, 28 Dec 2025 15:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1766954873;
	 x=1767041273; bh=zCs4nzBuBnhRnTykVVN9yu/lt4v+RVgzy+LGuBY9dno=; b=
	B1E0wpsMvUgsX1Dy4Tq+/nCqmI7VDfVd1v9Hducm5h6hMYU0qImbGoSRxVcd3Iek
	6oHsQ9RcveXZ/0L514JyEftWJXnpWJ+CG6o8YGm7KRcM5LOZrsPq0FdgPeZJetIc
	WtplHshqgTXlbezh2/lSPw4bBcJM0GUh5g99vKKObCZ9oTC8U7kEwPowd9GBD7Eh
	6a2/lke4285/q4ubCaJ7q3CbJ2AYZbPJQU83CBg7EMeOW+hvxthlPC1pTbxiQkql
	cI3Zirs7xKlLyVjP5/v/SiIokLufWTsP6rcyiut3Xg9d5TbuynEB2EwabsseiGpa
	svVnHIj+nXLyRSm6KBf7Zw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1766954873; x=
	1767041273; bh=zCs4nzBuBnhRnTykVVN9yu/lt4v+RVgzy+LGuBY9dno=; b=b
	+8+aWpMML/R/KdgsmsVRl2tF89OE7xPUh6/lQa6CvvBPLYbUZKAyL18AUG+UgDGp
	5Awgq0ae9q4EIDttxDB+BsuiMDsPgWSNF/aq82+Gk+NtGEsX0Xaq5wx0wg4hxxoe
	mSUQld+gFBQpXyxsCGaCKO1NaUAcSavSeVmafCO2RgITbklT/6tJ3J9FEl/oTOyQ
	L8u4Uk654M00lEUDi/Qy7xhADC3+0SRketawlv68pZR4FevtSt2hTiK0TEOOa5sf
	vmmFtfQZaEmkL2Ovs6EYTobYLGje4wh2LRLUZDc1lt5TIqfcXFyn0n7XXJ34/fdK
	EIN12P4RdlvuYMSChwlhQ==
X-ME-Sender: <xms:eJdRaX6pByRjYFLodUhBal1Wo9pNxfC9NLe77vZUOFVlyPxCHZldDQ>
    <xme:eJdRaYmXWDFC0N2cWjBVoMY81deCzwgjZiNkno7DMLP7NPSWSZJdJAtIlEkVU478A
    kohxUTMvh5boYaWjHowvcKVrDr2CiLl7xUjWA8Qy4H9gbkUqp_qVw>
X-ME-Received: <xmr:eJdRaa6cnktFC1Du_70gpyRojnIlUFNwEYvBzXGVZL_ZRvhHEz9dZBxUR0E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdejhedviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfgjfhggtgfgsehtjeertddttddvnecuhfhrohhmpeetlhgvgicuhghi
    lhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtth
    gvrhhnpeetteduleegkeeigedugeeluedvffegheeliedvtdefkedtkeekheffhedutefh
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlh
    gvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepiihilhhinhesshgvuhdrvgguuhdrtghnpdhrtghpthhtoh
    epjhhgghesiihivghpvgdrtggrpdhrtghpthhtohephihishhhrghihhesnhhvihguihgr
    rdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomh
    dprhgtphhtthhopehkvghvihhnrdhtihgrnhesihhnthgvlhdrtghomhdprhgtphhtthho
    pegsrhgvthhtrdgtrhgvvghlvgihsegrmhgurdgtohhmpdhrtghpthhtohepkhhvmhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhes
    vhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjihgrnhhhrghordiguhessh
    gvuhdrvgguuhdrtghn
X-ME-Proxy: <xmx:eJdRaRTi0mPXlxVxUVnQzaiJGYJTyQiz1saZxahs7X7Vyjkk0wt9Sw>
    <xmx:eJdRaQyyWpNc6lF3cGqu3eQL-cXo2l9lOak83Wc8ly6zaZXfut7fpw>
    <xmx:eJdRaRoAZViD41sbTq-NzcIBnHO2iB7y1owgxUHQER-yq6aXsV4oMA>
    <xmx:eJdRab13gsear2FNQNU-VxWnjbioUwWjv3Jz67awzGoFrjeqP1Ke0Q>
    <xmx:eZdRabm56C4G8En51o-7_SptKtq-olfzHO_Dbx-M6YeBnBLz1XqCiy6Q>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Dec 2025 15:47:51 -0500 (EST)
Date: Sun, 28 Dec 2025 13:47:49 -0700
From: Alex Williamson <alex@shazbot.org>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: jgg@ziepe.ca, yishaih@nvidia.com, skolothumtho@nvidia.com,
 kevin.tian@intel.com, brett.creeley@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] vfio/pds: Fix memory leak in pds_vfio_dirty_enable()
Message-ID: <20251228134749.128276c4.alex@shazbot.org>
In-Reply-To: <20251225143150.1117366-1-zilin@seu.edu.cn>
References: <20251225143150.1117366-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Dec 2025 14:31:50 +0000
Zilin Guan <zilin@seu.edu.cn> wrote:

> pds_vfio_dirty_enable() allocates memory for region_info. If
> interval_tree_iter_first() returns NULL, the function returns -EINVAL
> immediately without freeing the allocated memory, causing a memory leak.
> 
> Fix this by jumping to the out_free_region_info label to ensure
> region_info is freed.
> 
> Fixes: 2e7c6feb4ef52 ("vfio/pds: Add multi-region support")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>  drivers/vfio/pci/pds/dirty.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
> index 481992142f79..4915a7c1c491 100644
> --- a/drivers/vfio/pci/pds/dirty.c
> +++ b/drivers/vfio/pci/pds/dirty.c
> @@ -292,8 +292,11 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
>  	len = num_ranges * sizeof(*region_info);
>  
>  	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
> -	if (!node)
> -		return -EINVAL;
> +	if (!node) {
> +		err = -EINVAL;
> +		goto out_free_region_info;
> +	}
> +
>  	for (int i = 0; i < num_ranges; i++) {
>  		struct pds_lm_dirty_region_info *ri = &region_info[i];
>  		u64 region_size = node->last - node->start + 1;

Applied to vfio for-linus branch for v6.19.  Thanks,

Alex

