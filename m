Return-Path: <kvm+bounces-72761-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJkgEeW+qGmXwwAAu9opvQ
	(envelope-from <kvm+bounces-72761-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:23:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8893D208F53
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 48B0F3022441
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D51136D9FB;
	Wed,  4 Mar 2026 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="GiweCoI9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="56OIhlWs"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52F36B045;
	Wed,  4 Mar 2026 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772666583; cv=none; b=a9Q003f++uMTZofCVQ+R2Q/WxwJ7/IF94Bkbgi6PGDmayASjzWVBTJ9Nr9JklP+0DUUg+J64LcUphg++Wm69g/P1XxwDv0OFTbyx0dLZhcsgI2J6YRjO/Cvp7hZvDK9NPRI4HTfqmoc/H1UvuENaTe3by10gn97HArC2Evqu6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772666583; c=relaxed/simple;
	bh=j4yfbRuybF0tlN/UcVbdnNExnpuxuwbQy/VB26k/FW8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiN+2IBL73HRT2sGtxIyL/TgJ3yGiAJf6GfsPbMsvFaHeprTZxqXExWiVkTy1yHbfOMqibcgCIkyyeAwX2h3enqlZrvOFmEHWIG2GENXuju/W0s3Ja1VWjRBlMEMSfnGBK/5BLrPA6Qb1/0bhXYmy30Rb93W32Ke8sbDaZOq89Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=GiweCoI9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=56OIhlWs; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C97167A0251;
	Wed,  4 Mar 2026 18:22:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 04 Mar 2026 18:23:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772666579;
	 x=1772752979; bh=oSeQmLBPqhPGYkx8aifh0t+OHTNfMgkm6tILVMOgWls=; b=
	GiweCoI9SBHa/RNnaY00VS8NyNinpWd43e0eZlX4LqKGU2LeUsYCKmMMx4yRKHlk
	rMoUAgJCf3JT+4kCk1NR08+aAFK7If4mzhfkFQRTJ/r+8pgTObLdM/9teJocDnCF
	tmFZqqx3vqrzl75VVqP66qKz/r6se0ZR03gmyWsGRZ0RIeUs2Yprqxt1vGId89rx
	apehFuOYyUjpE256Mo7ejD4a3POLEVhlkKts2Y1ID6Q7KwIFtocKo74EUXS0ikb3
	cyUhgQcMgqPJfkKPMzNeYu5FNzXodXUBjR4sIuUOj6YwxzdOb33HbAyx889b4lFn
	X+4qJCAxhlrL6JOfgg9DgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772666579; x=
	1772752979; bh=oSeQmLBPqhPGYkx8aifh0t+OHTNfMgkm6tILVMOgWls=; b=5
	6OIhlWsioa0NbWoATadbAs3ld7O9LBT0jUWoKtd6eYNhfcg1iHTXpryJHJZFJBFe
	fW8l6vybJICjL/soLakd12A0INP8E/TsJHHufz7dCRfduHEe3U65j9mJFyC92M1O
	C2lzQfSUmDsi2Atmwp/3ZhTGWCbLNJCZCVVwpzWtWF/15vfn/UrGVcJHPa+s4Smp
	IZmueTmF5v3X86VLQHgdS9Km9KbbWZ5JI7U9GotqtlWE26NsYdQzqu7DkKzeUvrb
	hQZaFIE6yYEUI7wxfZdpsiOUO3BlIcd7+3pdV68GhWIhsBL3go6UPgibvOnEXZYe
	FEpoyIK1Y727GSjhWX70w==
X-ME-Sender: <xms:076oacNnetwPNS_Hqi6MJXQPn4ZRpgS7ZCzSL1JuRAvLPBbskJ9KVA>
    <xme:076oaYKnm8tibbZsKU2xXMsfF8bRoLoP2kWLu_XknSHJE5dJlgpsPd5selhjiJCFU
    J1Kb2f3rYRemQCQc9lymFhdJD35Uga6rMF6XX_eikKS7u4jhX2B>
X-ME-Received: <xmr:076oaWqmB9HmZOPgpcpZsNzTQF2TKLMkl2Z1nlrYbXQHiIpYckOTDFWQNZk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegkeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhi
    thgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepmhho
    tghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphht
    thhopegtjhhirgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepiihhihifsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehkjhgrjhhusehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:076oaUNWm9MMPxC6QmIRKwyoA-4L_AKb_kmLTumSd8nC2iWrmscbTA>
    <xmx:076oafh_4yrzQbSRudLlc3IDiWLhvsliIYawPVTj5ZuQnAuOW9oaUw>
    <xmx:076oaYbMVvEnV5UG8bC7xqmcOZNRV2PoIRgJLL5uwMRxRN78xWAujQ>
    <xmx:076oaTgK-b-7LAZvTqkVFFy-42VDLzaZYM9uZ8qyO1NXZVBXoXyVmw>
    <xmx:076oaZYlEcERMcv1D4Uqg7RKyxIKTdVjk8HpAQfl9XGkbAusnCrNeWm_>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 18:22:58 -0500 (EST)
Date: Wed, 4 Mar 2026 16:22:56 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 13/15] vfio/nvgrace-egm: expose the egm size
 through sysfs
Message-ID: <20260304162256.7a4a7164@shazbot.org>
In-Reply-To: <20260223155514.152435-14-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-14-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8893D208F53
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72761-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:12 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> To allocate the EGM, the userspace need to know its size. Currently,
> there is no easy way for the userspace to determine that.
> 
> Make nvgrace-egm expose the size through sysfs that can be queried
> by the userspace from <char_dev_path>/egm_size.
> E.g. on a 2-socket system, it is present at
> /sys/class/egm/egm4
> /sys/class/egm/egm5
> 
> It also shows up at <aux_device path>/egm_size.
> /sys/devices/pci0008:00/0008:00:00.0/0008:01:00.0/nvgrace_gpu_vfio_pci.egm.4/egm/egm4/egm_size
> /sys/devices/pci0018:00/0018:00:00.0/0018:01:00.0/nvgrace_gpu_vfio_pci.egm.5/egm/egm5/egm_size
> 

But we like to de-privilege QEMU and even pass file handles, how does
QEMU know the EGM size without trawling through sysfs?  It seems there
needs to be a primary interface to learn the size through the chardev.

Also no Documentation/ABI/testing/ entry.

> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index 918979d8fcd4..2e4024c25e8a 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -365,6 +365,32 @@ static char *egm_devnode(const struct device *device, umode_t *mode)
>  	return NULL;
>  }
>  
> +static ssize_t egm_size_show(struct device *dev, struct device_attribute *attr,
> +			     char *buf)
> +{
> +	struct chardev *egm_chardev = container_of(dev, struct chardev, device);
> +	struct nvgrace_egm_dev *egm_dev =
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +
> +	return sysfs_emit(buf, "0x%lx\n", egm_dev->egmlength);

Should the size be in decimal, %zu?

> +}
> +
> +static DEVICE_ATTR_RO(egm_size);
> +
> +static struct attribute *attrs[] = {
> +	&dev_attr_egm_size.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group attr_group = {
> +	.attrs = attrs,
> +};

const?

> +
> +static const struct attribute_group *attr_groups[2] = {

No need to explicitly size the array, [].  Thanks,

Alex

> +	&attr_group,
> +	NULL
> +};
> +
>  static int __init nvgrace_egm_init(void)
>  {
>  	int ret;
> @@ -386,6 +412,7 @@ static int __init nvgrace_egm_init(void)
>  	}
>  
>  	class->devnode = egm_devnode;
> +	class->dev_groups = attr_groups;
>  
>  	ret = auxiliary_driver_register(&egm_driver);
>  	if (!ret)


