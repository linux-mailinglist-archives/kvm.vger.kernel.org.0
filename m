Return-Path: <kvm+bounces-72763-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAg0AFDCqGkIxAAAu9opvQ
	(envelope-from <kvm+bounces-72763-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:37:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B0585208FE7
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0AAD33048753
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF591376489;
	Wed,  4 Mar 2026 23:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="c1RLTDs7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="csNYM4OH"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62911347513;
	Wed,  4 Mar 2026 23:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772667457; cv=none; b=RoH7CuMAfY36cgbB6HCheT2lIZ7/+/7ZgQiJj2vflrMjbGTQ66Vzly3/VBOUQv5xNBdKg3gPMX5GQNE7pRSdkAbpPxBbS5Q6rltfzLHa8P2R20a3oa/XWdsB47ARDZUJrzT3msYDis1AW7YdjQ5r+lSpyFfn4BBC//u/cVs/ySM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772667457; c=relaxed/simple;
	bh=9UkovD+5OfUO2/5Wbn51oCfKkeXzvKlEduRtMnvuaaE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IFr9eU5wq7HyDj10NpnOFika10tD4UmBmw4VpTKWwutrP4E7SKS7MUYHXBTBHlgWR7XDht3rnoNBes3Io/3dQf0PtMkHAYVW4A374IbFUCLeU/Aoc/FytDznFqrzlZelbOLJtU34v+8SUvWlakPjgHY/tppjVWHm2kY3i6Ahgcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=c1RLTDs7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=csNYM4OH; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 849211D00144;
	Wed,  4 Mar 2026 18:37:34 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 04 Mar 2026 18:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772667454;
	 x=1772753854; bh=gjapZ/aa2uDgkzi/5gk2HpNeU0QfSB0Vx+tsPbU75t4=; b=
	c1RLTDs7dXBHvTvRSTQ+lj/uNWU7H6vnWHWdU6l1gyMymh9g/yqqzdfa2mSHb0vh
	iOT9EWk9eNdcbinjzF9AGZ0G1dNt0/RiCFRMSi5Mbemwg+9Z/FkZFqMioZaYDzdm
	qFpPabw2GejgGCLKc3h1y4xyr0vszWy6gA88vkEp8wXJ78o+VkUOOtbfSlnABbCe
	Fo9PycTrEg5wdRqBTaIFV0KwOB1tbZ/FgMLviBrWVDucbzT2gw3Atfd4QGPd2xJm
	8nGlbQdpmnlsoAoYgkUjKatloHxHo/plQ8KgNgWTLIF0vGQ3ttXXxBCBSHVmtzQt
	scBAv/rdKBiGPkNPaEgAlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772667454; x=
	1772753854; bh=gjapZ/aa2uDgkzi/5gk2HpNeU0QfSB0Vx+tsPbU75t4=; b=c
	sNYM4OHEyENwiy+0DsvCMU04vd/NvIkBrCMNjcCddQXKj0NhDuSzcegPOkNKBADi
	Z7b7Zu4Rn+0XdiemnLYUAPQnv8mSQc6W/QJx2ad6Wq7ekH8gvxtrr2LZVfYnAViP
	gCUmUPFvxai0VohVS+bMpQ8vJYBVhO9cBx5BY1/ootJgPbAj7CYTGKKXusbBBly0
	+ygkUvDL5RZUJrHXUNuOVqRp41VWjJJoGJjL2k4+FjS1pTjTrWWSUDlB3DYR8xlj
	oU5/xkifVwvY+ABOgbrUuwB1b39C7e4uRtsY05ToHm9IIvOLKaKt0+N+0Uypedb6
	lFjPJl4ggPUzSUdIJ5WzA==
X-ME-Sender: <xms:PcKoaXAZcPhjN2V_m6snVFE4MVvWbxfmsZRQe15eD-3wN-dBH-LUwA>
    <xme:PcKoaSu8VULVKksjzrPTLwXN6aROz9vFPRiHIVA2o9UuTlahETgu9e1VnRMixeN6_
    xGmfoPqfVUnTQwxtQ7RSnHq-agN3RE-Zn_kePQ7MogkuTSf5b6L>
X-ME-Received: <xmr:PcKoaV9IniZ1dKJbUq4hM_BZQCXirHQYUWHUNg93j1X2QujNH7TGerJIn4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthhqre
    dtredtjeenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepteelheehfeduhedtfeegjefgie
    ejkedttddtuddtfeekffdvgedvkedvudetffegnecuffhomhgrihhnpehgrdhlshenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiessh
    hhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudegpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepvh
    hsvghthhhisehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtghomhdprhgtphhtthhope
    hjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehskhholhhothhhuhhmthhhohesnhhv
    ihguihgrrdgtohhmpdhrtghpthhtoheptghjihgrsehnvhhiughirgdrtghomhdprhgtph
    htthhopeiihhhifiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepkhhjrghjuhesnhhv
    ihguihgrrdgtohhm
X-ME-Proxy: <xmx:PcKoaZRpHF4K3mPlmIogOE4ktQcDIgeu7JGHn4oL6-B4h3J7yJjBTQ>
    <xmx:PcKoaXV_3ydUNGKm9PETLTFUKzorgVtHvpEGBP6Eh0GTRVNlM1mbwQ>
    <xmx:PcKoab_iaP3KnM2wg8pX9OqE9eqOMASRYIIRAqqXpB4aV47cQVHR5A>
    <xmx:PcKoaX22Lw5c2Y7kOG8aF2z7YytjXvqRzBdajcfhqUnNAD1gpJ4m1g>
    <xmx:PsKoaZdlvQZUd14BxPZwz8TiHcP_O8MJuMiUZq41K39XBF8WR9uN5hBV>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 18:37:32 -0500 (EST)
Date: Wed, 4 Mar 2026 16:37:31 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 14/15] vfio/nvgrace-gpu: Add link from pci to EGM
Message-ID: <20260304163731.41f6620a@shazbot.org>
In-Reply-To: <20260223155514.152435-15-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-15-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B0585208FE7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72763-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:dkim,shazbot.org:mid,nvidia.com:email]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:13 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> To replicate the host EGM topology in the VM in terms of
> the GPU affinity, the userspace need to be aware of which
> GPUs belong to the same socket as the EGM region.
>=20
> Expose the list of GPUs associated with an EGM region
> through sysfs. The list can be queried from the auxiliary
> device path.
>=20
> On a 2-socket, 4 GPU Grace Blackwell setup, the GPUs shows
> up at /sys/class/egm/egmX.
>=20
> E.g. ls /sys/class/egm/egm4/

If we end up with a sysfs representation of the EGM device, why did we
go to the trouble of naming them based on their PXM?

Shouldn't we just have a node association in sysfs rather than the GPUs?

AIUI, the PXM value doesn't necessarily align to the kernel's node
index anyway, so what is the value of exposing the PXM?  If the node
association is learned through sysfs, we could just use an ida for
assigning minors and avoid the address space problem of PXM values
aligning to reserved minor numbers.

> 0008:01:00.0=C2=A0 0009:01:00.0=C2=A0 dev=C2=A0 device=C2=A0 egm_size=C2=
=A0 power=C2=A0 subsystem=C2=A0 uevent
>=20
> Suggested-by: Matthew R. Ochs <mochs@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 47 +++++++++++++++++++++++++-
>  1 file changed, 46 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nv=
grace-gpu/egm_dev.c
> index 6d716c3a3257..3bdd5bb41e1b 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -56,6 +56,50 @@ int nvgrace_gpu_fetch_egm_property(struct pci_dev *pde=
v, u64 *pegmphys,
>  	return ret;
>  }
> =20
> +static struct device *egm_find_chardev(struct nvgrace_egm_dev *egm_dev)
> +{
> +	char name[32] =3D { 0 };
> +
> +	scnprintf(name, sizeof(name), "egm%lld", egm_dev->egmpxm);

%llu

> +	return device_find_child_by_name(&egm_dev->aux_dev.dev, name);
> +}
> +
> +static int nvgrace_egm_create_gpu_links(struct nvgrace_egm_dev *egm_dev,
> +					struct pci_dev *pdev)
> +{
> +	struct device *chardev_dev =3D egm_find_chardev(egm_dev);
> +	int ret;
> +
> +	if (!chardev_dev)
> +		return 0;
> +
> +	ret =3D sysfs_create_link(&chardev_dev->kobj,
> +				&pdev->dev.kobj,
> +				dev_name(&pdev->dev));
> +
> +	put_device(chardev_dev);
> +
> +	if (ret && ret !=3D -EEXIST)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void remove_egm_symlinks(struct nvgrace_egm_dev *egm_dev,
> +				struct pci_dev *pdev)
> +{
> +	struct device *chardev_dev;
> +
> +	chardev_dev =3D egm_find_chardev(egm_dev);
> +	if (!chardev_dev)
> +		return;
> +
> +	sysfs_remove_link(&chardev_dev->kobj,
> +			  dev_name(&pdev->dev));
> +
> +	put_device(chardev_dev);
> +}
> +
>  int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
>  {
>  	struct gpu_node *node;
> @@ -68,7 +112,7 @@ int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pc=
i_dev *pdev)
> =20
>  	list_add_tail(&node->list, &egm_dev->gpus);
> =20
> -	return 0;
> +	return nvgrace_egm_create_gpu_links(egm_dev, pdev);
>  }
> =20
>  void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
> @@ -77,6 +121,7 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struc=
t pci_dev *pdev)
> =20
>  	list_for_each_entry_safe(node, tmp, &egm_dev->gpus, list) {
>  		if (node->pdev =3D=3D pdev) {
> +			remove_egm_symlinks(egm_dev, pdev);
>  			list_del(&node->list);
>  			kfree(node);
>  		}

This is really broken layering for nvgrace-gpu to be adding sysfs
attributes to the chardev devices.  Thanks,

Alex

