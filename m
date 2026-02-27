Return-Path: <kvm+bounces-72229-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHzBGvIDomkGyQQAu9opvQ
	(envelope-from <kvm+bounces-72229-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:52:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C13A91BDF8F
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D12CE30514A0
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DAF146AF1D;
	Fri, 27 Feb 2026 20:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Wls0viGZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="evdJ60kj"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FE233A9EF;
	Fri, 27 Feb 2026 20:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772225493; cv=none; b=tQZ5CNMHhtwornifFBBWfu/njDGBztXgu+4mVAOI1r1HFaeszePWXEAAXMtVTSihMA7NS7zWr9l1hJ254XxWwXBciKoZEYJsU8HQiBG3eGkypA463/zXxMAVLULcA+GTt5A9qnOGybE+DCGo0tPSKECL+bzSPe0a7yCRgK7w0eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772225493; c=relaxed/simple;
	bh=pFL2OtyE4IwOTsf9kwlnN+dSmcMsyT2KLzxsCrSFL/A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTrvg9Vfyb82tlVcYGu4ghUYbxBTN7zPvAYo8t3fa1fjS7Q/lfS5BAclcLEGlcVLJqjSLTXagCq0o3SlENQGoNanBSR9XuinK/NjjjXVZS4Q5o6Ht+67gfknIWtCCEuarak8k15vqPPH0OXoqJx2UWy7/o42tZbjtwfdIE4cZ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Wls0viGZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=evdJ60kj; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4F6E57A022D;
	Fri, 27 Feb 2026 15:51:30 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 15:51:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772225490;
	 x=1772311890; bh=dHAFARK9/GwC5LQVntwuJiI1ujfKXWQd1sCvWsn3DKQ=; b=
	Wls0viGZdTxV4f0VHZGAnusVmS0dWD9tsEKznd9w8f6q07APE1d/HXZK/cd+Gbqe
	qg9sW5sBV3Ap0QaaFrUkAtzN2G387XhMEq4xAo9eHs39FqQ2ijzO9HX6zK/bguFD
	cTz7lQ3R/7z2eNHmymYe5Bo0E8tokQPdGRNrFrSuZI/ZaO9dEwWy5n2AeSanjM16
	md8kmCO1jGFGLZ/rBwDqiDyCMCyFrQqUbCilon567kffjkoFtD3EDC/LkzaAXbBP
	KnuzI2DyOPm28ghRO2Tkfiqf1zjHCk4kK/ux66eD976bqm/gycDvSCzxIiISsBXH
	sWWuvfxsWtv3ewwtlfAuvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772225490; x=
	1772311890; bh=dHAFARK9/GwC5LQVntwuJiI1ujfKXWQd1sCvWsn3DKQ=; b=e
	vdJ60kjug1ypkrrxjJD+oJQGsOvd+9BzpglO9Jl/mOmEvB/u+M10tZhUB1a9NN5d
	dUkzgDgcA1xqcFkpUuPJVVXZ+LrLhlM9Ld+a1DZu+RWyd70y9LSMrVpMFVm3saB2
	pwZi7oDVkLMBADf6jihMCqbJzqIjGj+czbjMa4rHKvknWFbfC3Z1R50RvZYp4Lg9
	FiXx8Ow65I+I/XLbEFJzpUvgbqOOUAuHTZLCUzjvZlLTVfP8Up9pSZ61zy8nzRmT
	42AxXxdV1aJi9A9LWjuHzLNEFNPqnIR3bvEPmY3+ygXZlwekHgc28bgDGssj/zHz
	i0dyPga7WBzSMt1US+iWw==
X-ME-Sender: <xms:0QOiafKNmSksLs9RRvcYRMSiJfF-CAc2VNSupAXKA_Nz_S30UcXWdA>
    <xme:0QOiafQKo7u5vRTJKVKucqpP1OOcVVucf1o6ORECQxjvjTQAwnupHjmuOgXnsOhhD
    WR2H2aXGyPpBnz9_Y8LMPLt8zrwA-pp6yIYLhcp7kaIpEmoiOG95g>
X-ME-Received: <xmr:0QOiaTgufTnF0o8RDtH_metnpmvq3iQr2ohCfmg2j2__c924wQhvuBKOi-4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvhedttdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegudevhfejueefveduieeuueeifeettdekveekhffgvdetfeelueehgfdt
    heffhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepvddupdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjuhhlihgrnhhrsehlihhnuhigrdhisghmrdgtoh
    hmpdhrtghpthhtohepshgthhhnvghllhgvsehlihhnuhigrdhisghmrdgtohhmpdhrtghp
    thhtohepfihinhhtvghrrgeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehtsh
    eslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehosggvrhhprghrsehlihhnuhig
    rdhisghmrdgtohhmpdhrtghpthhtohepghgsrgihvghrsehlihhnuhigrdhisghmrdgtoh
    hmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohephihishhhrghi
    hhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvh
    hiughirgdrtghomh
X-ME-Proxy: <xmx:0QOiaRuZz7B8FOz0_CdgRF47jJWtOrVH-jX9mPBUdB7SimpUUuARAg>
    <xmx:0QOiaWgj1VcsIWrLw0abfi9FBEvt5HlgEuUugninJp8nc8Yhk8dlpg>
    <xmx:0QOiaQF53hA9phQjeNeZQf_Dvgwav6ItStXXEuOkB2dry6OPCWy_pw>
    <xmx:0QOiaXLIyH6u0Ynv55of7SFS1D5_-oiXgFi1AT8F_Bjga0x0hLxCYg>
    <xmx:0gOiae-xMQFXE4geg7TQA75jVkGgt_VsmrSfr2xjEPfv0b0sfoGk1Rmf>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 15:51:28 -0500 (EST)
Date: Fri, 27 Feb 2026 13:51:26 -0700
From: Alex Williamson <alex@shazbot.org>
To: Julian Ruess <julianr@linux.ibm.com>
Cc: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
 oberpar@linux.ibm.com, gbayer@linux.ibm.com, Jason Gunthorpe
 <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
 hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-pci@vger.kernel.org, alex@shazbot.org
Subject: Re: [PATCH v2 1/3] vfio/pci: Rename vfio_config_do_rw() to
 vfio_pci_config_rw_single() and export it
Message-ID: <20260227135126.5f3c900f@shazbot.org>
In-Reply-To: <20260224-vfio_pci_ism-v2-1-f010945373fa@linux.ibm.com>
References: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
	<20260224-vfio_pci_ism-v2-1-f010945373fa@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-72229-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim]
X-Rspamd-Queue-Id: C13A91BDF8F
X-Rspamd-Action: no action

On Tue, 24 Feb 2026 13:34:32 +0100
Julian Ruess <julianr@linux.ibm.com> wrote:

> A follow-up patch adds a new variant driver for s390 ISM devices. Since
> this device uses a 256=E2=80=AFTiB BAR 0 that is never mapped, the variant
> driver needs its own ISM_VFIO_PCI_OFFSET_MASK. To minimally mirror the
> functionality of vfio_pci_config_rw() with such a custom mask, export
> vfio_config_do_rw(). To better distinguish the now exported function
> from vfio_pci_config_rw(), rename it to vfio_pci_config_rw_single()
> emphasizing that it does a single config space read or write.
>=20
> Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 8 +++++---
>  drivers/vfio/pci/vfio_pci_priv.h   | 4 ++++
>  2 files changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_p=
ci_config.c
> index b4e39253f98da61a5e2b6dd0089b2f6aef4b85a0..a724fdd8f4860bd529c5c7501=
beb1f7156fae9b0 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1880,8 +1880,9 @@ static size_t vfio_pci_cap_remaining_dword(struct v=
fio_pci_core_device *vdev,
>  	return i;
>  }
> =20
> -static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char=
 __user *buf,
> -				 size_t count, loff_t *ppos, bool iswrite)
> +ssize_t vfio_pci_config_rw_single(struct vfio_pci_core_device *vdev,
> +			      char __user *buf, size_t count, loff_t *ppos,
> +			      bool iswrite)
>  {
>  	struct pci_dev *pdev =3D vdev->pdev;
>  	struct perm_bits *perm;
> @@ -1970,6 +1971,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_co=
re_device *vdev, char __user
> =20
>  	return ret;
>  }
> +EXPORT_SYMBOL(vfio_pci_config_rw_single);

EXPORT_SYMBOL_GPL.  Thanks,

Alex


> =20
>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __use=
r *buf,
>  			   size_t count, loff_t *ppos, bool iswrite)
> @@ -1981,7 +1983,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_dev=
ice *vdev, char __user *buf,
>  	pos &=3D VFIO_PCI_OFFSET_MASK;
> =20
>  	while (count) {
> -		ret =3D vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
> +		ret =3D vfio_pci_config_rw_single(vdev, buf, count, &pos, iswrite);
>  		if (ret < 0)
>  			return ret;
> =20
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci=
_priv.h
> index 27ac280f00b975989f6cbc02c11aaca01f9badf3..28a3edf65aeecfa06cd185663=
7cd33eec1fa3006 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -37,6 +37,10 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_devic=
e *vdev, uint32_t flags,
>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __use=
r *buf,
>  			   size_t count, loff_t *ppos, bool iswrite);
> =20
> +ssize_t vfio_pci_config_rw_single(struct vfio_pci_core_device *vdev,
> +			      char __user *buf, size_t count, loff_t *ppos,
> +			      bool iswrite);
> +
>  ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *=
buf,
>  			size_t count, loff_t *ppos, bool iswrite);
> =20
>=20


