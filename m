Return-Path: <kvm+bounces-72748-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCg9BKSvqGmfwQAAu9opvQ
	(envelope-from <kvm+bounces-72748-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:18:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F25320869F
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7EF40309F6F1
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 22:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6202B39B954;
	Wed,  4 Mar 2026 22:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="rtesIB1D";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UVUaebiN"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FD436D9FB;
	Wed,  4 Mar 2026 22:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772661884; cv=none; b=W0/q+ra+Z5o7moWlWg+3gmjAXfdlyl/VtWu07rVMPB7lzh719kpi42UuVHWVCJXinIyNbc4klw855sJjXKK7xRDvyQTSqOYBIOZYd3/EJrrF2zpD0KrGp1oaiPuPij9R+lB3qO9XH+udc9pP2BnBVm/1IJ5MMaEG8pYq8bEgHYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772661884; c=relaxed/simple;
	bh=ZJiGD84DzBfUTbqzmlDxZ7pnB01F8l8SBBEGCfy1Yyg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IELnRdajrgSVVarR4IuzQUhXq7Jp1QtTfxWQMozhC+zvHUcPMC1IbJvgYZKdPPnGNVfI8JlRb67qqQuSJmqF7sLXRJ6L1IvcSW7gUpGGsQKvg5MR1MPUQT1CSAgoqvepnxZ09C64MTmLdXay2BsYRHCVR+0oGPRHqDZ1HAk3BSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=rtesIB1D; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UVUaebiN; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 627171D00238;
	Wed,  4 Mar 2026 17:04:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Wed, 04 Mar 2026 17:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772661880;
	 x=1772748280; bh=Xfp8hP8zU5VEktYbpj1A0zt7oRH6k1QGpsbAoxunKPo=; b=
	rtesIB1DqxEJYE1NxUPZUAUU77MLtpp3VWcpOJ+UsBRMP7/aDjtDkNWuTkn9ISUI
	rY9W/fKTnrTUgGxHMa31xNEDR1keAJtID52DACPMMNu+1Bpq9ylOTkG4FLcHEInT
	g+eVdk9gtXmuYngWh0BGdNKUimWTQlAWXzxMdbuED9QxcymTFPKggabPYnA/6dvF
	gQD9b0+a1whRe1RMQXW8X19EKVo6eMgSivt5GNomFwVv/NHk2kLsI60QR70zcaVF
	S4fxNsgjSLqkp0TA1gNDzeH2pJ8IcPzFJPQX8qXRCx0ew/cPuFTXovyNxeUCaG58
	dNRWKcKXozsdH2zGydAR2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772661880; x=
	1772748280; bh=Xfp8hP8zU5VEktYbpj1A0zt7oRH6k1QGpsbAoxunKPo=; b=U
	VUaebiNBseQVfeuWVEU9hyuzK9e55hSgUS4yL3nMAPmy1dXDu5xX9ww6k8CQhezE
	FQQx1RA2+VsTdfyUXmnnjfw6ziWTMc2UiNxQs3qoWtRYhcDLvEcitTxJcgDvUNKG
	2zdLV4UAvgKAeWlRXNH4jl2hORBwhwcu8JN9/IhllmxCWTEig4TT1uapagdxKlWM
	W+2+UkZls4fua0qLMP7d6La8x2xcqnDGTghMBjCH9iaDMAFHB/ZfsqlNmXOEBB1C
	X5gqrypf/KF9DHEPsuIEkV4JXMJSPGnjmqrSnE7Xwd9UJTFP94VnwJnEurG6J4aB
	zynudYl/aXFcmyNCeDpdQ==
X-ME-Sender: <xms:d6yoaZ2OkjeRQEG0Y2_se0ahZk4sTxUTcTdje5xkq1ou7wpluzzfIw>
    <xme:d6yoaVQOxCRGX4hk45bSNohQK1dsOx-tHe06v639HmZhmceWBlI5oEBQMPZ_Te_gK
    fvTgjSUD5I796Pfnrf_KB6ODWddYPrZZK2i5v984_SLSCUEavb5Ig>
X-ME-Received: <xmr:d6yoadQZNPkOscy1WYeF5jtFtKIEMNUJDn2lUCnXNBMwQDPy6TPPUx9ZTdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegieehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:d6yoaWW28S-R4Vn53zvpZA5LEjHfNbjAiSiab9vy66FjoE7Y2Ls_Sg>
    <xmx:d6yoaXL6YDEyBpcBkkYxlTuM7YMgeIudxn2lBNLn2zoGHB9Db5S9aw>
    <xmx:d6yoaXiORSU0Ziwn2sYpQjB0pq6qE1vglUpPqSMUEVWbN4uyymqyyA>
    <xmx:d6yoaUIK-QWtKslKyxlFQdzjr_LqV-fVk8sRAPD0Td9TLYUAGzqwLA>
    <xmx:eKyoaRjnvBrfZBImQ6rwIzGZahcPiGJIZjto93hrFC_-VlMrUjIOd3Jc>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 17:04:38 -0500 (EST)
Date: Wed, 4 Mar 2026 15:04:37 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 09/15] vfio/nvgrace-egm: Add chardev ops for EGM
 management
Message-ID: <20260304150437.50503b55@shazbot.org>
In-Reply-To: <20260223155514.152435-10-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-10-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1F25320869F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72748-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,shazbot.org:dkim,shazbot.org:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,messagingengine.com:dkim]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:08 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> EGM module implements the mmap file_ops to manage the usermode app's
> VMA mapping to the EGM region. The appropriate region is determined
> from the minor number.
> 
> Note that the EGM memory region is invisible to the host kernel as it
> is not present in the host EFI map. The host Linux MM thus cannot manage
> the memory, even though it is accessible on the host SPA. The EGM module
> thus use remap_pfn_range() to perform the VMA mapping to the EGM region.
> 
> Suggested-by: Aniket Agashe <aniketa@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 41 +++++++++++++++++++++++++++++-
>  include/linux/nvgrace-egm.h        |  1 +
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index d7e4f61a241c..5786ebe374a5 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -17,19 +17,58 @@ struct chardev {
>  	struct cdev cdev;
>  };
>  
> +static struct nvgrace_egm_dev *
> +egm_chardev_to_nvgrace_egm_dev(struct chardev *egm_chardev)
> +{
> +	struct auxiliary_device *aux_dev =
> +		container_of(egm_chardev->device.parent, struct auxiliary_device, dev);
> +
> +	return container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +}
> +
>  static int nvgrace_egm_open(struct inode *inode, struct file *file)
>  {
> +	struct chardev *egm_chardev =
> +		container_of(inode->i_cdev, struct chardev, cdev);
> +
> +	file->private_data = egm_chardev;
> +

No reference taken to egm device, nothing blocks it being removed.

>  	return 0;
>  }
>  
>  static int nvgrace_egm_release(struct inode *inode, struct file *file)
>  {
> +	file->private_data = NULL;

Unnecessary.

> +
>  	return 0;
>  }
>  
>  static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -	return 0;
> +	struct chardev *egm_chardev = file->private_data;
> +	struct nvgrace_egm_dev *egm_dev =
> +		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
> +	u64 req_len, pgoff, end;
> +	unsigned long start_pfn;
> +
> +	pgoff = vma->vm_pgoff &
> +		((1U << (EGM_OFFSET_SHIFT - PAGE_SHIFT)) - 1);

I don't know what you're doing here with EGM_OFFSET_SHIFT other than
ignoring the high bits and creating aliases across the device file
address space for no(?) reason.  Looks like pointlessly copying vfio's
region segmentation.

> +
> +	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
> +	    check_add_overflow(PHYS_PFN(egm_dev->egmphys), pgoff, &start_pfn) ||
> +	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
> +		return -EOVERFLOW;
> +
> +	if (end > egm_dev->egmlength)
> +		return -EINVAL;
> +
> +	/*
> +	 * EGM memory is invisible to the host kernel and is not managed
> +	 * by it. Map the usermode VMA to the EGM region.
> +	 */
> +	return remap_pfn_range(vma, vma->vm_start,
> +			       start_pfn, req_len,
> +			       vma->vm_page_prot);

Obviously there are concerns about how this relates not only to the
state of the device in routing access, but also the lifetime of this as
there's no reference tracking whatsoever.  Thanks,

Alex

>  }
>  
>  static const struct file_operations file_ops = {
> diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
> index a66906753267..b9956e7e5a0e 100644
> --- a/include/linux/nvgrace-egm.h
> +++ b/include/linux/nvgrace-egm.h
> @@ -9,6 +9,7 @@
>  #include <linux/auxiliary_bus.h>
>  
>  #define NVGRACE_EGM_DEV_NAME "egm"
> +#define EGM_OFFSET_SHIFT   40
>  
>  struct gpu_node {
>  	struct list_head list;


