Return-Path: <kvm+bounces-70988-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDKcI+DxjWlw8wAAu9opvQ
	(envelope-from <kvm+bounces-70988-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 16:29:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D81CB12EEFD
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 16:29:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D2F5313B8CC
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9661EEA5F;
	Thu, 12 Feb 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="RscQ3NJ/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MGOkiXiB"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57099F4F1;
	Thu, 12 Feb 2026 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770910018; cv=none; b=d36Y+H0ii21bwUBo9AlXt8SA4JjPXm9KsIObMlwARjhmqquwKfcK1YIGjfkilqFH7/WF2ypFhO6PrLtPUrMEiLC86AdVVSitBrN5Y1vgNJ+qZaWEwf+INjLv5KpSp8CAU3u52HqfHxZ5GgM88u5GJ117ERxkwZrJYqomEBK/h24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770910018; c=relaxed/simple;
	bh=zo8EfRvL4ErM4vuWDCr9QM8yJQQnDfW6TzDH3cUDgZs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s+VmNJ4Rfchdd4C+fi3MGbhIiRcxhWS6ZICsQ4l4+qoosAOxxNSe57mOky/Lepor9hHlzXPNpQqvcLEtuSQS5lokXIeWTgSi7OmEbb7fKD0x3azfNUdW1J4eqwj+Q+TDdy4PMOnJVnpoUv5PFSRP5PypOJcbr5iwBCOhIbtL+eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=RscQ3NJ/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MGOkiXiB; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F04517A012C;
	Thu, 12 Feb 2026 10:26:53 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 12 Feb 2026 10:26:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770910013;
	 x=1770996413; bh=fGs6hFzdbPYEGWzAEwqMf/QHmFwxHFZ3J98kX4iykqU=; b=
	RscQ3NJ/NSZyYBoxHEzXalqKlWDA8RDopHlXsCgcGEZnwsx0B73WP6TCcheRtnNG
	YT1rn9zntXsrKGWXRUvPx9BsKrx9SwuF028xpccWP92gbQOe4DFtnGFu7cMkIdrP
	6iwv5ID8YcR5E79qMjnK8h3dqEuLtd4gKbThQ3xGE838+uotJCHc56oLkS3nmxHE
	jvcJooeXhBddWXorRqA1BGP90a5Q+ZtoxxgNAbfnHdMc+RomWdChVMyewn2/+Bi3
	2cMtMie+3DeRmJYvzooA894HgOJOKJ0gI+dTlIZgGnM0pMll+YkvYSEFxljOWbcY
	BKv1T0e6ZA914BK7mjtwIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770910013; x=
	1770996413; bh=fGs6hFzdbPYEGWzAEwqMf/QHmFwxHFZ3J98kX4iykqU=; b=M
	GOkiXiBIS3cLMVP3rPgrzitzMGRSST5oKrf6s1BJgbgdJlX27lLNjyDRiXHg4sEw
	ASBAGW2XMgaiIR/753F3vgtzWpzAMI2/XnC0kQGLY42TseWROk2oSLRahVhEgZBo
	sXiiE+7ZhIFkIcYNybF6Z5TiX8w8t7q/gKwu2pAlzjd4CsLcSRrhTv8rwvgcodDy
	YWJP6Xd5+Wcskpdn1rc9Y5QyYkixvxEGPFDXwpXOts4qMqGKOpHftqSZDPrqcpxx
	tKYpP/TeoEyA4vlHqrfjGoQrMUD9q+EePq2f5AMap1A6/9NCaCPkGV1vETyoq7Nx
	8pNs8H9g4i0fmATEIBB0A==
X-ME-Sender: <xms:PfGNaWcCELajyZzojmVKNYJI2bEUi4GR4STsN9bQiCkhkPdcVjRAKQ>
    <xme:PfGNaULXFz4VrkJ2u4WthKEQ3KgKJzbA5SjzKE2QUYocQU5fZI9p9svduVIQ7C2B5
    yG_rt-3FfrDLJC7DLrD_TmTJS_JkO8SifbjcjZo12f0q7iRNTj0AA>
X-ME-Received: <xmr:PfGNaQAzIdH522q77e9nWA5IhPyyE4DoOvu-UEyEyvWtdyOAkIEFOlrkFG0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdehjedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepvddtpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjuhhlihgrnhhrsehlihhnuhigrdhisghmrdgtoh
    hmpdhrtghpthhtohepshgthhhnvghllhgvsehlihhnuhigrdhisghmrdgtohhmpdhrtghp
    thhtohepfihinhhtvghrrgeslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehtsh
    eslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehosggvrhhprghrsehlihhnuhig
    rdhisghmrdgtohhmpdhrtghpthhtohepghgsrgihvghrsehlihhnuhigrdhisghmrdgtoh
    hmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohephihishhhrghi
    hhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvh
    hiughirgdrtghomh
X-ME-Proxy: <xmx:PfGNadjH0FTgv0cvFaRyZ1qlmvf4KM2nrdnsSpF2aEiI-hbzE9BRKw>
    <xmx:PfGNaaN5WQo1kTb9jrPplf1IcjuTjt2zBJIB_sMgnSWh-1Sr_J5CFA>
    <xmx:PfGNaUZO7kbUOl2mC5RPcwaHzLW8_1dpTIeKgHF1w9xwlnqeKCNzkw>
    <xmx:PfGNaf9dQ3q44LK_tYQAJ2rtd_HG63Avi10SfeJP7h56AhCvRfbBrg>
    <xmx:PfGNadmCIw9vKifu5z8BULVpQ-hPNPMPXVjPwqEog-YB2MiMi-X4zlz4>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Feb 2026 10:26:52 -0500 (EST)
Date: Thu, 12 Feb 2026 08:26:50 -0700
From: Alex Williamson <alex@shazbot.org>
To: Julian Ruess <julianr@linux.ibm.com>
Cc: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
 oberpar@linux.ibm.com, gbayer@linux.ibm.com, Jason Gunthorpe
 <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
 hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
Message-ID: <20260212082650.5b233d0a@shazbot.org>
In-Reply-To: <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
References: <20260212-vfio_pci_ism-v1-0-333262ade074@linux.ibm.com>
	<20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70988-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:mid,shazbot.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D81CB12EEFD
X-Rspamd-Action: no action

On Thu, 12 Feb 2026 15:02:15 +0100
Julian Ruess <julianr@linux.ibm.com> wrote:

> Extend VFIO_PCI_OFFSET_SHIFT to 48 to use the vfio-pci
> VFIO_PCI_OFFSET_TO_INDEX() mechanism with the 256 TiB pseudo-BAR 0 of
> the ISM device on s390. This bar is never mapped.

Why does the entirety of vfio-pci need to adapt to the BAR requirements
of this device?  There's a variant driver included here that implements
its own read/write handlers and doesn't support mmap, so you're already
halfway there to implement your own region offsets independent of the
conventions of the rest of vfio-pci.  Thanks,

Alex
 
> Acked-by: Alexandra Winter <wintera@linux.ibm.com>
> Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 4 ++--
>  include/linux/vfio_pci_core.h    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a11e6f450f70105f17a3a621520c195d99e0671..3d70bf6668c7a69c4b46674195954d1ada662006 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1647,7 +1647,7 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
>  	u64 pgoff;
>  
>  	pgoff = vma->vm_pgoff &
> -		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +		((1UL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>  
>  	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
>  }
> @@ -1751,7 +1751,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
>  	req_len = vma->vm_end - vma->vm_start;
>  	pgoff = vma->vm_pgoff &
> -		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +		((1UL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>  	req_start = pgoff << PAGE_SHIFT;
>  
>  	if (req_start + req_len > phys_len)
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 1ac86896875cf5c9b5cc8ef25fae8bbd4394de05..12781707f086a330161990dc3579ec0d75887da8 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -20,7 +20,7 @@
>  #ifndef VFIO_PCI_CORE_H
>  #define VFIO_PCI_CORE_H
>  
> -#define VFIO_PCI_OFFSET_SHIFT   40
> +#define VFIO_PCI_OFFSET_SHIFT   48
>  #define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
>  #define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
>  #define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
> 


