Return-Path: <kvm+bounces-68097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CA8D21A7C
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 23:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 09769300720B
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF21C33D6E8;
	Wed, 14 Jan 2026 22:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="CMNdH9Kf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X1GJn2M7"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5B357717;
	Wed, 14 Jan 2026 22:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768431050; cv=none; b=FpkpjGQ7cxixWYbXAX6IE9eBoDc9hyNUrBBAU1iSDNV/eXiQzB+WtRzfLlHP64zaaVwHlMVGowH8nDeuwxfJ+W12F4s+XHpvAhjHSVIOxB8ZScaPiUgxqaQYioJoljuG8DYelbxXDHf/jZ7PHbEDSTptQ4EsDVSYngBsaeXAuhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768431050; c=relaxed/simple;
	bh=g//UZzu7MsgYucd6N3xPydbKHc3HPUhKc/0ChTjYf+4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtlExvZoGQ0JW0a5Uz4Is0k9kqdqRtGWFUAjuHwsu55Ce1Elsqs4cEZPgAa2xaLsFRk8ngu4dcpWMNPyaqyTSnH2dA7Ek1q1lAqvuH42l920tGyNOhWfbiy/IooXZWuboWhJPGWOhJPiNzPemqMzd0NcO7KQLsSGimBb26GlfO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=CMNdH9Kf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X1GJn2M7; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id E9420EC0166;
	Wed, 14 Jan 2026 17:50:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 14 Jan 2026 17:50:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768431043;
	 x=1768517443; bh=O3ziLGsY2aZqDAycUIMKi54XxQLNGeT4ykW3yhvseLE=; b=
	CMNdH9Kft15bdPIpCCfxc5fDI/9DQAXp1MARAoRSDvvMbONbxiWQ+oofuLJSzV4h
	o4HtTegiYlRMJcFFkeknozE2fZdx2Kfp0Vu51mRQzh7m9WU1ExE7qQaVizgkXfUy
	A/SRKWAnpjyfL6RQwEvY1HNe5bXvaXmasCRwje5F/P895rGJeEHFaXq3G5swzYrD
	cZXpAFwVV60LCCHMyzbwh2qJzbt3gYAXaAV4jZqIowFLx1YqT0my2c66n8RZPQS/
	BFj55Ov2vBeUz9z228BR9r2LC6s0bNgDE9wa2xftm8viYwH0gVW8GCVJA+IoK8al
	yDcR5mdr52fTFBUrldcAqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768431043; x=
	1768517443; bh=O3ziLGsY2aZqDAycUIMKi54XxQLNGeT4ykW3yhvseLE=; b=X
	1GJn2M7DiwqG9RZ/W8zuuk1yrp6dpSa5zQ0BXtM4bL2yfIkWakPzHH/IhR/ZHyTf
	aMDuTR7ugr4xsXz6n3dCWv+H5nQAU+xuwfsblSo27ET+a/msWWGC0qSAVu+PBhTV
	3y3iqqwblAoGATwQ1ohuexTrk7Zj9rlnY77uU9hD3TWMtHTN+iG8zn3KceeS3h/S
	9ue4mI4AJLUS4u7VHm6pgSJQ4j2jUqhI0xiBAgRyqFWPvl+eWiQU1IigZ5yRHq6a
	nGIqnzXeJY4uW1+YEzCPudyZU4dF9DWMX4DWkOkOAAkUVFo+cAaZfWJOe8FHWc15
	7Vxsw2Go5kBYbyFD75ARw==
X-ME-Sender: <xms:wx1oaZPL7t2ZSumB5rble6XDRhK7cJ_xdxv_vk_znWoNjbC6uT0h7w>
    <xme:wx1oaW7eRr7noNP8Gn5QaMw5IaqI8rfCnzNJp6UMVON1wA98sMSVyCA_l7ZuaH8uE
    GGeOxWsM4m816gYvCBAsc2afmH58a0TBOED4r082xy_a8FAljBntA>
X-ME-Received: <xmr:wx1oaXT_cy9AYRNyajkNg_n-4_cjuusj5T6kGxCEIJdtZeYPO17wCqJtcFc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeggedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegudevhfejueefveduieeuueeifeettdekveekhffgvdetfeelueehgfdt
    heffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepiedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepihhlphhordhjrghrvhhinhgvnheslhhinhhugidrih
    hnthgvlhdrtghomhdprhgtphhtthhopegrnhhthhhonhihrdhpihhghhhinhesnhhokhhi
    rgdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqphgtihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehnrghthhgrnhgtsehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgsehnvh
    hiughirgdrtghomh
X-ME-Proxy: <xmx:wx1oabAApIEmyBXxIanjnYvnA3nvuxCtQlU-m2UJjkwq7EDzka-scQ>
    <xmx:wx1oafFG9rgrz5ASlSQ305aMH4Pehvx5TGwjbhsa8eFBaJzryD9LaA>
    <xmx:wx1oadAodPe0gjOp8l4gKczVfjNSMtiWKz5b1S9_hfeHT3eQBLuKXw>
    <xmx:wx1oafUUlQC5kEi1XRT7HUc8c9kzEBpc6Ww7F1urCYxbkeKGqKKf3g>
    <xmx:wx1oadEGVqDAiCinkzFKiotV2qSKYvMC5PPLw-KqV9D-H_x8QuEDlr6W>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Jan 2026 17:50:42 -0500 (EST)
Date: Wed, 14 Jan 2026 15:50:41 -0700
From: Alex Williamson <alex@shazbot.org>
To: Ilpo =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>
Cc: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, Nathan Chen <nathanc@nvidia.com>, Jason
 Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/pci: Lock upstream bridge for
 vfio_pci_core_disable()
Message-ID: <20260114155041.60f87930@shazbot.org>
In-Reply-To: <1ccd984a-a852-2e98-12c5-3547581a3eb7@linux.intel.com>
References: <BN0PR08MB695173DD697AB6E404803FEA838EA@BN0PR08MB6951.namprd08.prod.outlook.com>
	<1ccd984a-a852-2e98-12c5-3547581a3eb7@linux.intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Jan 2026 10:36:08 +0200 (EET)
Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com> wrote:

> On Tue, 13 Jan 2026, Anthony Pighin (Nokia) wrote:
>=20
> > Fix the following on VFIO detach: =20
>=20
> Fix the following warning that occurs during VFIO detach:
>=20
> > [  242.271584] pcieport 0000:00:00.0: unlocked secondary bus reset via:
> >                pci_reset_bus_function+0x188/0x1b8
> >=20
> > Commit 920f6468924f ("Warn on missing cfg_access_lock during secondary
> > bus reset") added a warning if the PCI configuration space was not
> > locked during a secondary bus reset request. That was in response to
> > commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
> > such that remaining paths would be made more visible.
> >=20
> > Address the vfio_pci_core_disable() path. =20
>=20
> Similar comments as to the other patch.
>=20
> Why these are not submitted in a series (they seem to fix very similar=20
> cases, just for different call chains)?

They're related but independent fixes.  IMO it's easier for clear
ownership between maintainers and avoiding unnecessary conflicts or
shared branches to post them separately.

Let's also add the Fixes: tag on this one since it needs a respin for
the other comments.  Thanks,

Alex

>=20
> > Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 3a11e6f450f7..aa2c21020ea8 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
> > =20
> >  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> >  {
> > +	struct pci_dev *bridge;
> >  	struct pci_dev *pdev =3D vdev->pdev;
> >  	struct vfio_pci_dummy_resource *dummy_res, *tmp;
> >  	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
> > @@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_d=
evice *vdev)
> >  	 * We can not use the "try" reset interface here, which will
> >  	 * overwrite the previously restored configuration information.
> >  	 */
> > -	if (vdev->reset_works && pci_dev_trylock(pdev)) {
> > -		if (!__pci_reset_function_locked(pdev))
> > -			vdev->needs_reset =3D false;
> > -		pci_dev_unlock(pdev);
> > +	if (vdev->reset_works) {
> > +		bridge =3D pci_upstream_bridge(pdev);
> > +		if (bridge && !pci_dev_trylock(bridge))
> > +				goto out_restore_state; =20
>=20
> Misaligned.
>=20
> > +		if (pci_dev_trylock(pdev)) {
> > +			if (!__pci_reset_function_locked(pdev))
> > +				vdev->needs_reset =3D false;
> > +			pci_dev_unlock(pdev);
> > +		}
> > +		if (bridge)
> > +			pci_dev_unlock(bridge);
> >  	}
> > =20
> > +out_restore_state:
> >  	pci_restore_state(pdev);
> >  out:
> >  	pci_disable_device(pdev);
> > --=20
> > 2.43.0
> >  =20
>=20


