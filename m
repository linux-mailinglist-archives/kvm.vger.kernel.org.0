Return-Path: <kvm+bounces-72736-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCyXEfqBqGmYvAAAu9opvQ
	(envelope-from <kvm+bounces-72736-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:03:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C5A206CC2
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDE0A30BEE42
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988483DFC69;
	Wed,  4 Mar 2026 18:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Wr6SjCdm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="acn14Vrz"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFFC3DA5C5;
	Wed,  4 Mar 2026 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772650588; cv=none; b=I84AS8VM4lZxZEyhQDk8+euBLrVLBa13OztbAz06k0BhnidpWrIGaY+/X2MKwYrVGyfZMJIH6Hd+m/ofMvO2XQbWAfXjtAZ8VfPqSx4w1L7YiIl0T5KTyegqPvTZEGvt70sk9jMi6exKCibgjkXMKcsnvulVfDDH/xYcn3W7wUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772650588; c=relaxed/simple;
	bh=o5mxjcrUTO1e/rfTjOubP8FIc2xA/XGnQKKV7L7JJqk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jm+3KLuFHbjgNXnjOcXCJgvBLtNSL7LCSYiDLWmEphHicLclFHKpBR9nXjrkj0UR2mvGBpcuwwl5i3udYFt0x7rqU9VpbypmcvkaZ2aR2I3U4JRB/1PMBS8NBgQZfn25ljoke5GcVzXkDYfn+vTPE7ufSRRLOBbAGMxT23ktnxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Wr6SjCdm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=acn14Vrz; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A2D9D7A01FA;
	Wed,  4 Mar 2026 13:56:24 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 04 Mar 2026 13:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772650584;
	 x=1772736984; bh=sbSWzbQS94ebstzjW8+fmge4YhBDt5utZ8M0362CsxU=; b=
	Wr6SjCdmeWf3LzMuf2dRTuNj4AIWEX57e5k5blWaYtwtq++GLVv9uRmJcFMFsU0n
	Ivpapnx/QL3qnQzt/MrDEt4aF4ntBptuLrjByXiB+DrzWNn08wOJobh29o4o0nDY
	rnaTJhyqyLpxkJqObHaeq+503tr/h1IqYy6BlyMOeDMTrm+5A6RWtb9gsxdnawoT
	2wG3svMCcXJA+lTXxAp1Eg5IIm4/svvfKILH5WiqH8ZHP8BAIZKDuSXKcliI6nD+
	/IuuNST4eraP3m62agh4kS/590mGsL786gaduoyAVKJWo78LPB7z2ifsuv9/5h2L
	WawrdPm/W2Va2sp2a06PbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772650584; x=
	1772736984; bh=sbSWzbQS94ebstzjW8+fmge4YhBDt5utZ8M0362CsxU=; b=a
	cn14Vrzo2BffY2ZM91captvE8FpxcaYnkRMuGbBcG9Ca57m1VS5yj0z5DOFDdVoB
	B4S2ooKs6R/bP1sKaiA7X+QrnPG3RcabpiS2GiMrJNXjhS6vuSpodY3aUdM8kzVy
	61ibAqB57FU9Mtd6fnwLPzXLDRAId47slGsb1R82CaKt6CJuJn5+iKEPv+VaLLIT
	vef1nuF37BWnWSyuE1Qd1E9HmIbkF5HANRaR0w6BEIPzBhxHR298wCdnG0WNZBBG
	cXgFTkYZ+8aV6BFjbY+27TBlIWyzXXnBdgfhQEmmNJOQqDTtDNnLz/dsnYjdIrBh
	F7jO9kkHtzlpJh3zM0Aqg==
X-ME-Sender: <xms:WICoacuwzkTF3Aq5mYKuUYBfTlN7_Jw6xtdK53J7Ifz_Jy6__D6eUw>
    <xme:WICoaervezRWLvmlA-1NMqWdUHK5FCejOL1a6vJQRG5VLOLkiCmQoX0Jp9pCfhH2Z
    LTp9LZKbtkjiUlWCR6yozOv6xfmpKJYkK3b0_1_3j-AS0wDJlYXVw>
X-ME-Received: <xmr:WICoabLqc-mC2-rZ_Poseyx_gOmhZ4guSabrfKljUsHyOxMT7BtnilTLPVs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegvdekucetufdoteggodetrf
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
X-ME-Proxy: <xmx:WICoaesYbeG0o4YleqzLHkqPAIXKX-NbULuYUTCs00gNHgegXXTLvA>
    <xmx:WICoaYBR9qSyCLp5VqyI_hO2uHm5IriL378CROga_xb2ATJyBoHqdg>
    <xmx:WICoaW4z-uxFgLiOjvEgBQsTIUFjyYv0tRtwqvTZBB8pDozcCwiQ2w>
    <xmx:WICoaQBL4MD1PycwbnCYuBAP2LkpIrjj9ntgAyxL-UlYDKjGd_rn7Q>
    <xmx:WICoaafD3K0g51PBfYmADYze2ACY-ObCsieu9xFLQbwDTlsWSSaPUAOW>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 13:56:22 -0500 (EST)
Date: Wed, 4 Mar 2026 11:56:21 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 06/15] vfio/nvgrace-egm: Introduce egm class and
 register char device numbers
Message-ID: <20260304115621.003240f7@shazbot.org>
In-Reply-To: <20260223155514.152435-7-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-7-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C3C5A206CC2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72736-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:dkim,shazbot.org:mid,messagingengine.com:dkim,nvidia.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:05 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The EGM regions are exposed to the userspace as char devices. A unique
> char device with a different minor number is assigned to EGM region
> belonging to a different Grace socket.
> 
> Add a new egm class and register a range of char device numbers for
> the same.
> 
> Setting MAX_EGM_NODES as 4 as the 4-socket is the largest configuration
> on Grace based systems.

Should this be a Kconfig option or have a driver module parameter or is
this a long term limit?

The use of "nodes" here is a bit confusing too since the KVM Forum
slides show each GB "node" is composed of 2-sockets.  Should this be
something like MAX_NUM_EGM?
 
> Suggested-by: Aniket Agashe <aniketa@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 36 ++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index 999808807019..6bab4d94cb99 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -4,14 +4,50 @@
>   */
>  
>  #include <linux/vfio_pci_core.h>
> +#include <linux/nvgrace-egm.h>
> +
> +#define MAX_EGM_NODES 4
> +
> +static dev_t dev;
> +static struct class *class;
> +
> +static char *egm_devnode(const struct device *device, umode_t *mode)
> +{
> +	if (mode)
> +		*mode = 0600;
> +
> +	return NULL;
> +}
>  
>  static int __init nvgrace_egm_init(void)
>  {
> +	int ret;
> +
> +	/*
> +	 * Each EGM region on a system is represented with a unique
> +	 * char device with a different minor number. Allow a range
> +	 * of char device creation.
> +	 */
> +	ret = alloc_chrdev_region(&dev, 0, MAX_EGM_NODES,
> +				  NVGRACE_EGM_DEV_NAME);

This reserves a range of 4 minor numbers, 0-3, but then in 8/
we use the PXM number as the minor value, which according to 13/ seems
to result in egm4 and egm5 chardevs.  So we're stomping on minor values
outside what we've reserved.  Thanks,

Alex

> +	if (ret < 0)
> +		return ret;
> +
> +	class = class_create(NVGRACE_EGM_DEV_NAME);
> +	if (IS_ERR(class)) {
> +		unregister_chrdev_region(dev, MAX_EGM_NODES);
> +		return PTR_ERR(class);
> +	}
> +
> +	class->devnode = egm_devnode;
> +
>  	return 0;
>  }
>  
>  static void __exit nvgrace_egm_cleanup(void)
>  {
> +	class_destroy(class);
> +	unregister_chrdev_region(dev, MAX_EGM_NODES);
>  }
>  
>  module_init(nvgrace_egm_init);


