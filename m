Return-Path: <kvm+bounces-66727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE9DCE5756
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 21:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 82B4C30010FA
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 20:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F3F27FB34;
	Sun, 28 Dec 2025 20:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="NFKUvsh7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TlYe/woh"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0DB22256F;
	Sun, 28 Dec 2025 20:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766954889; cv=none; b=Hh4sOXpZI9GxkyCgOv2Jk+iIcvlb2141FgLcgMTk8rUpbY7S+DPBL98xHkJplwzJkiuUc6kZ8EZNLlaBXTMr0Q7BppeaNtc8D8L+h09GJ6zlMAt4i0hvKFwSz5DcEx3P2+Mu02xiyWEchzCP0nhgSs/ohn6fp7taXdZdlBMqOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766954889; c=relaxed/simple;
	bh=Ol9zMwLZf+HQas0pyHTmH8ZqnpB+E40UMR1Tr1zIdPo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NA7VTTawGEeYQrKx+T7dPtrilcVMMT/MgMvHzW7j9hRp5olYgC5oRe5jZYJgd9QEctDOc0NwUeb6/+839G78N0m4Lp4VekaT/v16y6VI4VZ/Hc9zwzlUMLOyIthsJnLhlbNxmo9/hJNvZdz8nDsfEnZ9Ef8PyfmYDbzCmriXvPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=NFKUvsh7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TlYe/woh; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 83AFD7A031C;
	Sun, 28 Dec 2025 15:48:04 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sun, 28 Dec 2025 15:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1766954884;
	 x=1767041284; bh=stmomKs5w9KPTMilxwJpAtcHDNCZFqnQi0xKX7GpdkU=; b=
	NFKUvsh7sSjNnclgLQtHS2XztgLH8JgYCzfSZ/kpkL/FRblqetbygnKnfOGFve5x
	KuAStxpdY4SniMQ2mTE3KaRw812BJYC4YQacXsXWz7qIDGJoPyNh5mVqDzfCdx90
	rcBhpOW36Eo38+25lzOqz8PUrdndDSTrArLrq45sFAzPXuzsKE5LKaOUrRhW59TR
	kC2Pql5z7OdotdwgmEbtTl+pWmI/aQUAfQ7lDAqzTNeArsRZQd9Suc7ytUQSK34y
	n73hzfgF/kyugFNvUT8n1qIhcJY6t4qJXP2jjyJOVv/rC3L3+I9EcrsDNv84NZ1w
	CufRHJTx9Pj9kWG7TOa9AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1766954884; x=
	1767041284; bh=stmomKs5w9KPTMilxwJpAtcHDNCZFqnQi0xKX7GpdkU=; b=T
	lYe/wohkAHFaxZThgD5iVL+k83+yaVrPMr7N4KYqMGDyCptqeJSCTCFegmni8hsb
	42ZTXY6rhFH14ur8/eczdRqY9dscooc9xcUeMz8WVHEhRyc69dZkMtu3g1fCl44j
	FB1Vc41Wp3Z9OUCSdQJesnN/r9WLVCBkFgikR4lKRbDXfi+7OnVxPmIGJI7ILM9n
	HsNfsg4bcCv1chgDCWwUG0ZcCUBn5gOiGThkYE8pAxbErhdbKgJlpDqW3k2z0Luq
	0rxHL8VWzbBwYcDWSeqtIatCnm0IgQ+DlHi+9jXMNQE1PBvY7bFmn9k7NJzkfkts
	BhxIERT41aL5+cRgZ9ikg==
X-ME-Sender: <xms:g5dRafxwV9FsC59vj4kA2h1ktk9jtz8eLQiY-DjkWk1sb5vEuWDEEg>
    <xme:g5dRaTHuPh9-N_qthCAPpCWqGQBCt2UB3DU5xmbNfhSIaRWZQ7E5PqxNK-2KKlXr1
    VPxnGE2efsoalXXjz7NoW04NyjuMlLAUuu2PiLqR9BB0kQkJkDMgA>
X-ME-Received: <xmr:g5dRaUuqSLMb3ce8etAyOuFDY_oVJlRwH1dKdUYWHWAjF_OCY2Fbo2qzvs0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdejhedviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfgjfhggtgfgsehtjeertddttddvnecuhfhrohhmpeetlhgvgicuhghi
    lhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtth
    gvrhhnpeetteduleegkeeigedugeeluedvffegheeliedvtdefkedtkeekheffhedutefh
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlh
    gvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepuddupdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrlhhpvghrhigrshhinhgrkhdusehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepmhhitghhrghlrdifihhnihgrrhhskhhisehinhhtvghlrdgtohhm
    pdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohephihishhhrghihh
    esnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhi
    ughirgdrtghomhdprhgtphhtthhopehkvghvihhnrdhtihgrnhesihhnthgvlhdrtghomh
    dprhgtphhtthhopehthhhomhgrshdrhhgvlhhlshhtrhhomheslhhinhhugidrihhnthgv
    lhdrtghomhdprhgtphhtthhopehrohgurhhighhordhvihhvihesihhnthgvlhdrtghomh
    dprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:g5dRaTAhwtiqhhDwWv05hoX3qUoQ9Gn1XAq05zlaIo0yaU-jYb0Hwg>
    <xmx:g5dRafDXQzM9UNWhax1sGC4cY29v_LoG2k4LGcRHDW3wXBSwiTnzOw>
    <xmx:g5dRadpiIyTN_Sx3e8zMLgDrX6WthoI-enrA4zGbX7h7pSCUjdUVhA>
    <xmx:g5dRaaEAciTqumbPyQeyI1qJtoC49N-o2KRrUtM8A9_AUjcWlqKc7A>
    <xmx:hJdRabh8KzAYwhbu7ke6oEdxIrQpnjEkWKltGMkfIqNsnW8uzkzuaWgH>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Dec 2025 15:48:02 -0500 (EST)
Date: Sun, 28 Dec 2025 13:48:01 -0700
From: Alex Williamson <alex@shazbot.org>
To: Alper Ak <alperyasinak1@gmail.com>
Cc: michal.winiarski@intel.com, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
 <yishaih@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>, Kevin
 Tian <kevin.tian@intel.com>, Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=
 <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 kvm@vger.kernel.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/xe: Fix use-after-free in xe_vfio_pci_alloc_file()
Message-ID: <20251228134801.074ed34c.alex@shazbot.org>
In-Reply-To: <20251225151349.360870-1-alperyasinak1@gmail.com>
References: <20251225151349.360870-1-alperyasinak1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Dec 2025 18:13:49 +0300
Alper Ak <alperyasinak1@gmail.com> wrote:

> migf->filp is accessed after migf has been freed. Save the error
> value before calling kfree() to prevent use-after-free.
> 
> Fixes: 1f5556ec8b9e ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
> Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
> ---
>  drivers/vfio/pci/xe/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
> index 0156b53c678b..8e1595e00e18 100644
> --- a/drivers/vfio/pci/xe/main.c
> +++ b/drivers/vfio/pci/xe/main.c
> @@ -250,6 +250,7 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
>  	struct xe_vfio_pci_migration_file *migf;
>  	const struct file_operations *fops;
>  	int flags;
> +	int ret;
>  
>  	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
>  	if (!migf)
> @@ -259,8 +260,9 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
>  	flags = type == XE_VFIO_FILE_SAVE ? O_RDONLY : O_WRONLY;
>  	migf->filp = anon_inode_getfile("xe_vfio_mig", fops, migf, flags);
>  	if (IS_ERR(migf->filp)) {
> +		ret = PTR_ERR(migf->filp);
>  		kfree(migf);
> -		return ERR_CAST(migf->filp);
> +		return ERR_PTR(ret);
>  	}
>  
>  	mutex_init(&migf->lock);

Applied to vfio for-linus branch for v6.19.  Thanks,

Alex

