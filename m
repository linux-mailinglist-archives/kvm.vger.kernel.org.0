Return-Path: <kvm+bounces-70515-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oBzLBOhnhmm4MwQAu9opvQ
	(envelope-from <kvm+bounces-70515-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:15:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDEB103AFB
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3AC9C3043465
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 22:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517CA30F803;
	Fri,  6 Feb 2026 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="FbYkmeVP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eBahRD4D"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE2C30ACE3;
	Fri,  6 Feb 2026 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416089; cv=none; b=smZNHgARwETpYKA6opheCuF6WOhk+1MCsdk6f/yoM05ADB4+Ag9Nxm3tvatcZ611keBwZRYH4RXIqphNQQ0/Df0mFy/H/lQtIE6N7uSf1VYrx53Dfsfex+grWJAY1hRFA7QRZe+rQUyqZmO6YqgajVPnZe6ITJvMA2d364oFzhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416089; c=relaxed/simple;
	bh=1E4rFn1VCpcMyxGuxoR2kE1jxlZDUtY3dCLCqym/ff8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pg+dHGf+Re80Apbe/E1w29hPDzuMKOzlRK4NLI2B/qBPZdXXoEZBT/y88RnFKq3wER9ftIivvKn9hmWxBrKcepd1wHknOB91sfMzlyVGXmD5Afk3gVC00PdZlXDKC8xAIjmgHh52GQz0aRncd5WYWyZ5Z3zwNKl9YgtZT90SX/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=FbYkmeVP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eBahRD4D; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 89C1F7A010F;
	Fri,  6 Feb 2026 17:14:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 06 Feb 2026 17:14:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770416088;
	 x=1770502488; bh=JEypNavNi9UjAOn/VSgCKdRPMxSg0dIinMfd7X1nSZk=; b=
	FbYkmeVPUoRyx33dcc2vaw5x6/vfFQjhyFmKb8M0egFOFqiaByN+atUu+3Tx8Vgo
	wUM0EW8tYY0ke6aJgRW2OpVbHDDT8byPVWptGEFXFGwnY+oO3O3vg75mzOjeQAKK
	31nyXj+MAiFspHcgifEPzfzqZPw/ULDhSfmgDfrErX9Q4CpY0mC8y3/n0nJv7AWn
	D2u1h3Bci+E/1kfbx0EV2nozf5gvWREyCffwGfuBre81EP52Ip4P8a2pA7CilVc7
	q9+CKfhFbh9FFnVYBDFodcZ0wojEejD/DDRSflsbh3gxqImXjy0Aek6Jr9Nl340N
	xiUXMlzN8HbcrH7byvYBYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770416088; x=
	1770502488; bh=JEypNavNi9UjAOn/VSgCKdRPMxSg0dIinMfd7X1nSZk=; b=e
	BahRD4D0y0rZqyCDuvwEW8qBW/9bJa7BUPOPdN2E683GPxPlCdxJ5yed7zcFfxi2
	aB1DgM5NS8HJUwrMLJV9we9YWY2KFrBCviI0Zqx1GiSZrY/ynSOHJ13G1gPpb5wP
	Wbstemjxwp/U90lbnksgyDOhMj96tC5KgdB/sXXBDKOrEyJiuKHMuPUD42FtL0nH
	xmwqWxarjEaiXAIiQb22p4MWXM8xc/jM+MjHccO6POM2Y7+pIXCPRtZA+klMuf9F
	C9ijKsQjPiecbKi9bRe2E8XGj+W+2EfcyqO4ISOVmulyurFFtvvLea/N58DDv0mf
	8jvJOAl6f4474l7SsgV1w==
X-ME-Sender: <xms:2GeGaZVsdCMtedYC7i3oZEC8xlsyCvJd5LrdSE87LQBtKxawfifxxw>
    <xme:2GeGaRWdRuqDBePaE28Nik--6xV5M-8kNdLQe-woBz_vrV2l8zsIcOTZaoq3fILop
    FJCgkmPtEMCUVY2LoKY5aV61R-Aj7ghLcP3BAVivthQehrqLy5ggg8>
X-ME-Received: <xmr:2GeGaYc776CUGSuDVLvhNUdBvZkwKOQ8jMSNNvfYNd-_FK1DtK_bRzIP2do>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeelfeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepfedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepihhorghnrgdrtghiohhrnhgvihesnhigphdrtghomh
    dprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:2GeGaaUjXXKhGbLtlMX26N64rmd5Zq-P1ukKfES4czwIBtk6x88miQ>
    <xmx:2GeGaRd1nb_yO7ryed-jYai9B9icXpo8X3ydNgaN8aBjRa72QiopMA>
    <xmx:2GeGaWNFoFOdkzkBy18nAGAZoCZXhRW3gL9aGn1DpTOmVH704jrBWA>
    <xmx:2GeGafiKwtgLipSge9QA9U6FkAbujCYeysVFgbB_Izn0GPUPU97iCg>
    <xmx:2GeGaQ4m_Axu3WB-JHFPQkZDNOL7yw0OZaTrw0zKttZOCpLUVRvo1LuU>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Feb 2026 17:14:47 -0500 (EST)
Date: Fri, 6 Feb 2026 15:14:46 -0700
From: Alex Williamson <alex@shazbot.org>
To: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/fsl-mc: add myself as maintainer
Message-ID: <20260206151446.5cc59eb1@shazbot.org>
In-Reply-To: <20260204100913.3197966-1-ioana.ciornei@nxp.com>
References: <20260204100913.3197966-1-ioana.ciornei@nxp.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70515-lists,kvm=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7CDEB103AFB
X-Rspamd-Action: no action

On Wed,  4 Feb 2026 12:09:12 +0200
Ioana Ciornei <ioana.ciornei@nxp.com> wrote:

> Add myself as maintainer of the vfio/fsl-mc driver. The driver is still
> highly in use on Layerscape DPAA2 SoCs.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  MAINTAINERS                       | 3 ++-
>  drivers/vfio/fsl-mc/Kconfig       | 5 +----
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 --
>  3 files changed, 3 insertions(+), 7 deletions(-)

I was rather looking forward to removing this, but welcome aboard.
Applied to vfio next branch for v6.20/7.0.  Thanks,

Alex

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 26898ca27409..66882df493cc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27677,8 +27677,9 @@ F:	include/uapi/linux/vfio.h
>  F:	tools/testing/selftests/vfio/
>  
>  VFIO FSL-MC DRIVER
> +M:	Ioana Ciornei <ioana.ciornei@nxp.com>
>  L:	kvm@vger.kernel.org
> -S:	Obsolete
> +S:	Maintained
>  F:	drivers/vfio/fsl-mc/
>  
>  VFIO HISILICON PCI DRIVER
> diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
> index 43c145d17971..7d1d690348f0 100644
> --- a/drivers/vfio/fsl-mc/Kconfig
> +++ b/drivers/vfio/fsl-mc/Kconfig
> @@ -2,12 +2,9 @@ menu "VFIO support for FSL_MC bus devices"
>  	depends on FSL_MC_BUS
>  
>  config VFIO_FSL_MC
> -	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices (DEPRECATED)"
> +	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
>  	select EVENTFD
>  	help
> -	  The vfio-fsl-mc driver is deprecated and will be removed in a
> -	  future kernel release.
> -
>  	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
>  	  (Management Complex) devices. This is required to passthrough
>  	  fsl-mc bus devices using the VFIO framework.
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index ba47100f28c1..3985613e6830 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -531,8 +531,6 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  	struct device *dev = &mc_dev->dev;
>  	int ret;
>  
> -	dev_err_once(dev, "DEPRECATION: vfio-fsl-mc is deprecated and will be removed in a future kernel release\n");
> -
>  	vdev = vfio_alloc_device(vfio_fsl_mc_device, vdev, dev,
>  				 &vfio_fsl_mc_ops);
>  	if (IS_ERR(vdev))


