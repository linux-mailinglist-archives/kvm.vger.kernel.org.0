Return-Path: <kvm+bounces-68545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 97496D3B8AC
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 21:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 34636303D926
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 20:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F6B2DB7AF;
	Mon, 19 Jan 2026 20:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="DqugQzcF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="0YYnUgZC"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428E22F6900;
	Mon, 19 Jan 2026 20:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768855203; cv=none; b=SXh6vKnjgGjOEkzy+oGLyyDqp/bR97zi7ak8shPZj+5Yz/vYvuBpxBUVTOEBsIchqmNhwNCmHxEXw79YZM0eAc1Wh4Y2B5cKWtLIHQ4e4w/kwzMrvz5yinEaoVq5OKdk8lkUUEHInfOyn2Uv3aeHLrIf9VOSmxBM5D0x62urmrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768855203; c=relaxed/simple;
	bh=FknW2M970s7MUl7V9VDr8K/I/GxEA/gKZhSmLfuZsxs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajVUXF7yFRbk8QSRc9DXf7fdZAOaQ64v4nXXqtqtex0sp0GhwpgI9pCiL+rTzObI3orzFwZY0tjZ3lO/GpR0T3nnhABGDRplFGN1VKW/tgo3BhtjvEISz1x/V8Lqkd03cD9Mybtp+fb7U+0EHVyURp7agNQTRiyHMIVXviZsbx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=DqugQzcF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=0YYnUgZC; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id DE2CBEC00CC;
	Mon, 19 Jan 2026 15:39:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 19 Jan 2026 15:39:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768855188;
	 x=1768941588; bh=99J6Ru8E+YVFAgUBedh9KT02xWCUPTen4E35Kp8bBEU=; b=
	DqugQzcFqY0Hrv+92vyVgahsQP39fAyc6dNEPZDcXT4+Mi4h3yNNUGr5PuXwFhSW
	LsCuS4lXkk8WHr/8KZchXU5A6dV+MT9BkOGTl6dGnJ3DMbRxG8PPMLhqAgTToux5
	jFbIAYFcFgCnydNGb1MMIOgdPG9PX3lzutHUaS9R6uSeLXvfhTrFRnIhaPFhZfo3
	goT6JH0k722rmrITX+8dtKUTkYzAS+A1L5h0y3KJAqV0kEYJTvN8PV1wNtKq836+
	zy2bcv2I3O18A3eZttzvN+9R3N+etoc9fSClJKr74PRzhd4IEltzrMuJOjocrmGe
	GlFcn3W00IULgTFp6nkUlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768855188; x=
	1768941588; bh=99J6Ru8E+YVFAgUBedh9KT02xWCUPTen4E35Kp8bBEU=; b=0
	YYnUgZCYr/VrZsgW2jOaM6O2UzljfIwT9RG4nvJVKdd4zsRbBoxUB1EI1TzAwxkZ
	W2pXj4oX271jXeHbaaJ/SMRkkCz2vbS+uN3aJT1uoSDw+SBw2ABuTFnifQBr7K3K
	M+8lAU51f2fBHEKO57G+eVUE2xIPoadJMxSuL6wj267YAjT1xJRnGnr8B4a9TwVT
	wraRtd7gNw84ZMa5Miqk4cAk4pfdXN+QtwWf+Zd8YsY50+0irim8p2REpspjgVdi
	y0zB4w8CHQDZ6W/oQzFlMjuMnhWwkjG3+lX8ue2cXXxYe9U3cJmPBcjyW8BARYeD
	M66S28jjWh8LxZ4Zlfa7A==
X-ME-Sender: <xms:lJZuaZmD-ubprdlfv4l3VZQT8-o0BQX2id1703ECP_6iZNvmMZYLVA>
    <xme:lJZuaQTMh7hDkrKKm8s9I3bG3i56xYyVzQ--ViZ5Dq2BDxZmELpUXbrGawEXuLoIs
    nOmv6cXqI5X-advaDhlPWLth4MMLdZtGn00IL9M8Y9BETFRKPTwnw>
X-ME-Received: <xmr:lJZuaTKJuKZ92ROav0txsLKh546Qr_yEYp2vogHDdsByXsRE2W-4jr_3k0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeekheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprghnthhhohhnhidrphhighhhihhnsehnohhkihgrrd
    gtohhmpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehlihhnuhigqdhptghisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epihhlphhordhjrghrvhhinhgvnheslhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:lJZuaeA8Grnqq--_oVmuwEghPcG_0RZSlROGWr6ryuk-sOnFAwKgew>
    <xmx:lJZuaUC-b2TSoYPSKUnJKBbPC5prQuKXrc_bpgftYJy9D_rtCfsGqQ>
    <xmx:lJZuaYCrIpHHx5FXQEWtbBJV_kHtUO97t_cH5mc6Xo8Xz4pW0qyYZA>
    <xmx:lJZuaXrC7UCUW_UkYOwvgSVT9pou9oIAFd6O3h7Nk3gyjy5us9vhmQ>
    <xmx:lJZuaWtS5Z_mC1G4ACj31yFAsrcInI9yhQJ2RAeZI5uAclD-bhK1r4L3>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jan 2026 15:39:47 -0500 (EST)
Date: Mon, 19 Jan 2026 13:38:14 -0700
From: Alex Williamson <alex@shazbot.org>
To: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH v2] vfio/pci: Lock upstream bridge for 
 vfio_pci_core_disable()
Message-ID: <20260119133814.1e022a63@shazbot.org>
In-Reply-To: <BN0PR08MB695171D3AB759C65B6438B5D838DA@BN0PR08MB6951.namprd08.prod.outlook.com>
References: <BN0PR08MB695171D3AB759C65B6438B5D838DA@BN0PR08MB6951.namprd08.prod.outlook.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jan 2026 15:31:26 +0000
"Anthony Pighin (Nokia)" <anthony.pighin@nokia.com> wrote:

> The commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
> added locking of the upstream bridge to the reset function. To catch
> paths that are not properly locked, the commit 920f6468924f ("Warn on
> missing cfg_access_lock during secondary bus reset") added a warning
> if the PCI configuration space was not locked during a secondary bus reset
> request.
> 
> When a VFIO PCI device is released from userspace ownership, an attempt
> to reset the PCI device function may be made. If so, and the upstream bridge
> is not locked, the release request results in a warning:
> 
>    pcieport 0000:00:00.0: unlocked secondary bus reset via:
>    pci_reset_bus_function+0x188/0x1b8
> 
> Add missing upstream bridge locking to vfio_pci_core_disable().
> 
> Fixes: 7e89efc6e9e4 ("PCI: Lock upstream bridge for pci_reset_function()")
> Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
> ---
> V1 -> V2:
>   - Reworked commit log for clarity
>   - Corrected indentation
>   - Added a Fixes: tag
> 
> 
>  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)

Applied to vfio next branch for v6.20/7.0.  Thanks,

Alex
 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a11e6f450f7..72c33b399800 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
>  
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  {
> +	struct pci_dev *bridge;
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_dummy_resource *dummy_res, *tmp;
>  	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
> @@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	 * We can not use the "try" reset interface here, which will
>  	 * overwrite the previously restored configuration information.
>  	 */
> -	if (vdev->reset_works && pci_dev_trylock(pdev)) {
> -		if (!__pci_reset_function_locked(pdev))
> -			vdev->needs_reset = false;
> -		pci_dev_unlock(pdev);
> +	if (vdev->reset_works) {
> +		bridge = pci_upstream_bridge(pdev);
> +		if (bridge && !pci_dev_trylock(bridge))
> +			goto out_restore_state;
> +		if (pci_dev_trylock(pdev)) {
> +			if (!__pci_reset_function_locked(pdev))
> +				vdev->needs_reset = false;
> +			pci_dev_unlock(pdev);
> +		}
> +		if (bridge)
> +			pci_dev_unlock(bridge);
>  	}
>  
> +out_restore_state:
>  	pci_restore_state(pdev);
>  out:
>  	pci_disable_device(pdev);


