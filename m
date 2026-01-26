Return-Path: <kvm+bounces-69180-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAbUMrD2d2l4mwEAu9opvQ
	(envelope-from <kvm+bounces-69180-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 00:20:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 372A08E2F6
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 00:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7DB14302688F
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C86930C36E;
	Mon, 26 Jan 2026 23:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="f3hyTbHK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="r488ig1g"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B04926299;
	Mon, 26 Jan 2026 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769469610; cv=none; b=KEChBMAbJLDqGKJ8yFOL+BDS+u+sKxV5SJgaSTRooZgBoZ9Ioj84NL6TfLRhIU6NaZN40kyUwy+7oqYCbmHcBCB4HxhWh65HKG84vJwrOwJqAMDiGPsVc9fXy9RiOUJoptAnoGmV94MTEGs+knsdKOXUPdReRsUkWh3TZBr6e1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769469610; c=relaxed/simple;
	bh=zV7Vr/hZ2akCYC+Y1eGsDgBAUPLNCtv15jkvvafElr8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Va4RQ6sRug/CpQ6oY83TUasIfVDGiHWDD4eJPNpKi2NT65IKsSk7JERjnhc/OJDxOEOHootscn5mThJFomhDU7dkWj63WWEweIOpeZ5la1v+5yGRiH7BUq3W2cdmFXdde0Dfvtz850GU7h46sh5VrS6dv3w7JQzPsijPaY4rPAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=f3hyTbHK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=r488ig1g; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6422714000F1;
	Mon, 26 Jan 2026 18:20:07 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 26 Jan 2026 18:20:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1769469607;
	 x=1769556007; bh=jXt48Rn6BOT1FkTtY0di482CEFq7NJ5RTyxmq7JSwPg=; b=
	f3hyTbHKN28MkfkkY9BPk4tMHRmjtMyiSlpvLt8Oq42On64OV4Ip+7FAdtwMBVK7
	xR5BJAZapVQeuFKt4SGZ0HlBvp5+ADQC6vwjZf7pD/uoK+4CRXeHsV85BiTc3vD8
	OlXg8RznlCSdszj6zD74k4vUoGAUvQn7GuZLty72wQfysSov6sKW3jBFP+nbYjp4
	lCIEL8zu9l7jxppkbSGolGXc9wEsMk9V5FsjmwU7jSP+CTLxQcaZE6zkTV+RFHP1
	8V0SziQclyq+QMNThDmI7suutW7jIrh23e+kPq8B72WHngC0R9vL7yCLjHcdr/io
	iHS1xZRAMjQWk65iuVxVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1769469607; x=
	1769556007; bh=jXt48Rn6BOT1FkTtY0di482CEFq7NJ5RTyxmq7JSwPg=; b=r
	488ig1gllqTW37B9y8ZeMpKBUfaV9JLrVDLxW8ZB+xlLkoaWJje2Cxg1/AHZPXDE
	SvlpmQx07mCEsCgdAT7X11Lbvn8Jl67T15QQ6PPTpFxvFkIsDZwjXIEUU4VPe9yh
	ugNWd6N7pXhHsTWROn6Q00Gu+5wD+YkVytAEtuEdQFacNj6NgQYpYdvpmMzq9cCY
	xqtVD4BgmTbzGiVjC+BB33vJd+jzt179C+U53/i0NZknZffnLdE29/I9+PM9eLfj
	d6yun4nIbQbJOmP4UuQo3S4Yt7txm7DT/uho2x0t1P3gL3kE/ntJWKuI8hlqH3Zh
	rsas2v/8sVB8gJ7o2Efvw==
X-ME-Sender: <xms:pvZ3afFIUr9i83IUiS49cAoQ7D09JNcKtCrTDUhT9JdG4rZZXi3zSw>
    <xme:pvZ3aYWSdYCyvoEMTi96nQESzgaswdMuEYjAvrrnhcvfLRzgsoTvxSnd4b-yhDldn
    ljdsTs-NMj8Y6qnAFh2sP44b42oOP9So6mLUMSWY3NiNDu7KwZu5Q>
X-ME-Received: <xmr:pvZ3aTUxEj8L-U0eGV2G79RI6-BqzidaNigJQ_Rx4kK9NYr0emsf6DkTD4o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduheekleejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepkedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepuggrnhdrjhdrfihilhhlihgrmhhssehinhhtvghlrd
    gtohhmpdhrtghpthhtoheprghnthhhohhnhidrphhighhhihhnsehnohhkihgrrdgtohhm
    pdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhptghisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhl
    phhordhjrghrvhhinhgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhope
    hjghhrohhsshesshhushgvrdgtohhmpdhrtghpthhtohepshhsthgrsggvlhhlihhnihes
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhlvghkshgrnhgurhgpthihshhhtghhvg
    hnkhhosegvphgrmhdrtghomh
X-ME-Proxy: <xmx:pvZ3aeJxhLht3kV4TFGBRGepZF8TvDIOQxKFcvad-RC67Re6AEN0Ew>
    <xmx:pvZ3aTBeKw4X2kyrHYpj-vo6cWa1l0QqXxPsZ1sD3xE0XwGEUXmRYg>
    <xmx:pvZ3aefv4oDXq1yzW8Yi0yDOommSLAK9k0X7hkPxvNaRHIvIik418g>
    <xmx:pvZ3aS3fncAsgDC4ETxoqAi1woqGdhuy3rC5UJvq0eWJvP8qFvp0Rw>
    <xmx:p_Z3abEgNp4KleFAchxKk7uvoXtd3NnInFRhiCgnSft9hgO86LVaiQ8Z>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Jan 2026 18:20:05 -0500 (EST)
Date: Mon, 26 Jan 2026 16:20:04 -0700
From: Alex Williamson <alex@shazbot.org>
To: <dan.j.williams@intel.com>
Cc: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
 <linux-pci@vger.kernel.org>, Ilpo =?UTF-8?B?SsOkcnZpbmVu?=
 <ilpo.jarvinen@linux.intel.com>, <jgross@suse.com>,
 <sstabellini@kernel.org>, <oleksandr_tyshchenko@epam.com>
Subject: Re: [PATCH v2] vfio/pci: Lock upstream bridge for 
 vfio_pci_core_disable()
Message-ID: <20260126162004.62db4391@shazbot.org>
In-Reply-To: <697135069627e_309510030@dwillia2-mobl4.notmuch>
References: <BN0PR08MB695171D3AB759C65B6438B5D838DA@BN0PR08MB6951.namprd08.prod.outlook.com>
	<697135069627e_309510030@dwillia2-mobl4.notmuch>
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
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	TAGGED_FROM(0.00)[bounces-69180-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nokia.com:email,messagingengine.com:dkim,intel.com:email]
X-Rspamd-Queue-Id: 372A08E2F6
X-Rspamd-Action: no action

On Wed, 21 Jan 2026 12:20:22 -0800
<dan.j.williams@intel.com> wrote:

> Anthony Pighin (Nokia) wrote:
> > The commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
> > added locking of the upstream bridge to the reset function. To catch
> > paths that are not properly locked, the commit 920f6468924f ("Warn on
> > missing cfg_access_lock during secondary bus reset") added a warning
> > if the PCI configuration space was not locked during a secondary bus reset
> > request.
> > 
> > When a VFIO PCI device is released from userspace ownership, an attempt
> > to reset the PCI device function may be made. If so, and the upstream bridge
> > is not locked, the release request results in a warning:
> > 
> >    pcieport 0000:00:00.0: unlocked secondary bus reset via:
> >    pci_reset_bus_function+0x188/0x1b8
> > 
> > Add missing upstream bridge locking to vfio_pci_core_disable().
> > 
> > Fixes: 7e89efc6e9e4 ("PCI: Lock upstream bridge for pci_reset_function()")
> > Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
> > ---
> > V1 -> V2:
> >   - Reworked commit log for clarity
> >   - Corrected indentation
> >   - Added a Fixes: tag
> > 
> > 
> >  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 3a11e6f450f7..72c33b399800 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
> >  
> >  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> >  {
> > +	struct pci_dev *bridge;
> >  	struct pci_dev *pdev = vdev->pdev;
> >  	struct vfio_pci_dummy_resource *dummy_res, *tmp;
> >  	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
> > @@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> >  	 * We can not use the "try" reset interface here, which will
> >  	 * overwrite the previously restored configuration information.
> >  	 */
> > -	if (vdev->reset_works && pci_dev_trylock(pdev)) {
> > -		if (!__pci_reset_function_locked(pdev))
> > -			vdev->needs_reset = false;
> > -		pci_dev_unlock(pdev);
> > +	if (vdev->reset_works) {
> > +		bridge = pci_upstream_bridge(pdev);
> > +		if (bridge && !pci_dev_trylock(bridge))
> > +			goto out_restore_state;
> > +		if (pci_dev_trylock(pdev)) {
> > +			if (!__pci_reset_function_locked(pdev))
> > +				vdev->needs_reset = false;
> > +			pci_dev_unlock(pdev);
> > +		}
> > +		if (bridge)
> > +			pci_dev_unlock(bridge);  
> 
> This looks ok, but a bit unfortunate that it duplicates what
> mlxsw_pci_reset_at_pci_disable() is also open coding. It leaves Octeon
> (orphaned) and Xen to rediscover the same bug. At a minimum I copied the Xen
> folks for their awareness, but it feels like __pci_reset_function_locked()
> really is no longer suitable to be exported to drivers with this new locking
> requirement. It wants a wrapper that contains this detail.

Even pci_try_reset_function() was missed when when this new locking
requirement was added, so adding yet another core wrapper function
doesn't guarantee we won't hit such problems.

The device_lock requirement for PCI reset has been particularly
problematic over the years, leading to the trylock nonsense we use to
avoid deadlocks.  Even the previously converted mlxsw call path cannot
acquire the bridge device lock since they already expect to hold the
reset target device lock, deferring to only acquiring the
pci_cfg_access_lock().

The above vfio-pci code may ultimately choose something similar because
even when userspace has correctly shutdown the VM before unbinding the
device from vfio-pci, the fput is run through a workqueue and may not
be able to acquire device lock here.

I don't know what a wrapper to handle all these variant would look
like.  Maybe we need to bubble up the warning to the existing wrapper
so we can see it without having specific hardware that triggers the bus
reset path.  Thanks,

Alex

