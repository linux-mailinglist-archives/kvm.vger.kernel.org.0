Return-Path: <kvm+bounces-72749-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YM3cLOiuqGmfwQAAu9opvQ
	(envelope-from <kvm+bounces-72749-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:15:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27EAF208627
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 89C063022549
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 22:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C78A38C2D5;
	Wed,  4 Mar 2026 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="TTMtMoYP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KvKVso4o"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0D83542E1;
	Wed,  4 Mar 2026 22:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772662488; cv=none; b=A3eePzhpSwkjJ7Dt46JXwShRXpCP/i1OoWFPjDh3+zYCdgM+8wI4Gz1/sZGqctn3bAHd9+oCyXi58cQ8nHZ1Eb0cj3grBJEIehiF2Cu8t2lc7wNuLOx79gbhHfGhqRcptM4HAZodd0BmhiR6U5G6xtc9ftwScE+8YTShs6eehVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772662488; c=relaxed/simple;
	bh=zS5wactH0c+aZMGnILpmV9xQhUB7NhvMKwTRwD7yhOk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyZTBclvZOWnxdCotvVF1vwIjgzpKogXID9/vRwq6XdyKu0iUhMzGiQ14V2lO/AZ8se/8bBVDApw0uaiJX8T06+LgRQNsKiyeis+e1AidEm/C+RN26y24S9jrqUpH+czmf7iVZadIU9S36j+fbfrC2ovCYSOekqEYE6mMtL8zw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=TTMtMoYP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KvKVso4o; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BEBCA7A014B;
	Wed,  4 Mar 2026 17:14:45 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Wed, 04 Mar 2026 17:14:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772662485;
	 x=1772748885; bh=XMEDMfVN8UQr/tBQ2ylyKHqSSktj29Lsx+eea8cPjmw=; b=
	TTMtMoYPcwgbYLbxd8RE/l971xH8WofDOTsegSlfxtJM5clr9wubMGSMr+81nP8M
	T9c7Hw7tbcXRybDBoThXP+51hCjRs/tgcF7anodvqhwylVtGpXfF34gF1iqFhyCg
	0TcTwStOfNynt0Umcno9GMSIGF/3SM1pmP8DT7QkKZj6UhhtckWmSs2/DGCfOAWv
	bSUAiJoM8HjteA2b5YM2xE/ybRUg/FA3uSaz6I2tBOsuuhmSVZFYKVlxcRr2GEH8
	jF09rhjjYOw+5Lhw2GFVoQGNlog3k4ldjQgwGTfi/Jwc1Rz2nbK2ZLG2iTuKiRJm
	+W6KrH99w2OdABfcPP7izA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772662485; x=
	1772748885; bh=XMEDMfVN8UQr/tBQ2ylyKHqSSktj29Lsx+eea8cPjmw=; b=K
	vKVso4oyWnc/IKv5MUd+VvGe3qsGBD4d2m1AO7Kxo09se5UZjtcNf7LNmGgda7hc
	Q0wFjC1W7KQaqdH54XSSx+TfaI/Rp4pa2yYpR7T4H23YM1I/2Freb9Z3ylj/iAwB
	bcwLV0RYoXGvlffnEcsjWbXTusBERAeJW7bUBwHKENwc38uJB88vJd4jLOIacK47
	IgqaNLUhMKA+YNcyPrLg8aOQVfXRWO9cBfyG+rhlCkCHzq2+zf/dMA5Ieewm3FeL
	TsK23rYcasEPualACAXIDZQc+XAdmmd1Q6VQ0dJIZSkITQf08IBKxzEZF3J0MPqn
	0v4xOd+4Ht/BIEzBTUQQw==
X-ME-Sender: <xms:1a6oaUBO5EK8MM7drT1RIOPm0su6FGKD0maBEZdYyUWzCU6bLNYTXw>
    <xme:1a6oaVBZ7VstO_Lu2Zsf-rOPmxOpb-bQ4XhefpEzt8nK2bgr9KFAljkUvvEWBScB4
    V3C2ds_WwW8Juym6XSJs3zdTleQckMtQxbkTsOF1IN2AQkjZ8WRPw>
X-ME-Received: <xmr:1a6oaTEmK7ZxJzz6XQX0xDK5CgkaT6yONo36VV_gYZGq6HVw51AOAikP5Vo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegieejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:1a6oaU7cVuoyUCfHRN97L2ZQiBS6djlMgSHcyND_YrFUbMcFBMV4-g>
    <xmx:1a6oaSRhss06FAHv99J8UiIWbvKMT8W9BKOK_sVJkx8J95BJul-DxQ>
    <xmx:1a6oaX5FJeABajaGbrLJ7wVgJvBYrBKfPE6opkPMv2pQU8GPh3vhNA>
    <xmx:1a6oaXTfqscMjW59cTECtxMUE37J6i9msu2GhmyJC_bRPZWArRNgSA>
    <xmx:1a6oabRDJbB8f4bBl9cgVONg7let4MZfbNYLVatBVsoMvaimEaI3BLto>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 17:14:44 -0500 (EST)
Date: Wed, 4 Mar 2026 15:14:43 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 10/15] vfio/nvgrace-egm: Clear Memory before
 handing out to VM
Message-ID: <20260304151443.26eb33f0@shazbot.org>
In-Reply-To: <20260223155514.152435-11-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-11-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27EAF208627
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72749-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,shazbot.org:dkim,shazbot.org:mid,messagingengine.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:09 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The EGM region is invisible to the host Linux kernel and it does not
> manage the region. The EGM module manages the EGM memory and thus is
> responsible to clear out the region before handing out to the VM.
> 
> Clear EGM region on EGM chardev open. To avoid CPU lockup logs,
> zap the region in 1G chunks.
> 
> Suggested-by: Vikram Sethi <vsethi@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 43 ++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index 5786ebe374a5..de7771a4145d 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -15,6 +15,7 @@ static DEFINE_XARRAY(egm_chardevs);
>  struct chardev {
>  	struct device device;
>  	struct cdev cdev;
> +	atomic_t open_count;
>  };
>  
>  static struct nvgrace_egm_dev *
> @@ -30,6 +31,42 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
>  {
>  	struct chardev *egm_chardev =
>  		container_of(inode->i_cdev, struct chardev, cdev);
> +	struct nvgrace_egm_dev *egm_dev =
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +	void *memaddr;
> +
> +	if (atomic_cmpxchg(&egm_chardev->open_count, 0, 1) != 0)
> +		return -EBUSY;
> +
> +	/*
> +	 * nvgrace-egm module is responsible to manage the EGM memory as
> +	 * the host kernel has no knowledge of it. Clear the region before
> +	 * handing over to userspace.
> +	 */
> +	memaddr = memremap(egm_dev->egmphys, egm_dev->egmlength, MEMREMAP_WB);
> +	if (!memaddr) {
> +		atomic_dec(&egm_chardev->open_count);
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Clear in chunks of 1G to avoid CPU lockup logs.
> +	 */
> +	{
> +		size_t remaining = egm_dev->egmlength;
> +		u8 *chunk_addr = (u8 *)memaddr;
> +		size_t chunk_size;

Declare at the start of the function and remove this scope hack.

> +
> +		while (remaining > 0) {
> +			chunk_size = min(remaining, SZ_1G);

min_t(size_t,,);

> +			memset(chunk_addr, 0, chunk_size);
> +			cond_resched();
> +			chunk_addr += chunk_size;
> +			remaining -= chunk_size;
> +		}
> +	}

Aren't we going to want to do this asynchronously or run multiple
threads to avoid stalling VM launch? 

> +
> +	memunmap(memaddr);
>  
>  	file->private_data = egm_chardev;
>  
> @@ -38,8 +75,13 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
>  
>  static int nvgrace_egm_release(struct inode *inode, struct file *file)
>  {
> +	struct chardev *egm_chardev =
> +		container_of(inode->i_cdev, struct chardev, cdev);
> +
>  	file->private_data = NULL;
>  
> +	atomic_dec(&egm_chardev->open_count);
> +
>  	return 0;
>  }
>  
> @@ -108,6 +150,7 @@ setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
>  	egm_chardev->device.parent = &egm_dev->aux_dev.dev;
>  	cdev_init(&egm_chardev->cdev, &file_ops);
>  	egm_chardev->cdev.owner = THIS_MODULE;
> +	atomic_set(&egm_chardev->open_count, 0);

Already zero from kzalloc.  Thanks,

Alex

>  
>  	ret = dev_set_name(&egm_chardev->device, "egm%lld", egm_dev->egmpxm);
>  	if (ret)


