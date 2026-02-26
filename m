Return-Path: <kvm+bounces-72100-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKVSFpnRoGlHnAQAu9opvQ
	(envelope-from <kvm+bounces-72100-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:04:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF351B0BA3
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F06AB30C29FD
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9383EDAC5;
	Thu, 26 Feb 2026 23:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="pSKbpMBh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="itMG0KrX"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6F91D8E01;
	Thu, 26 Feb 2026 23:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772147041; cv=none; b=WHOBxijsIbx8fht1J3APrVD65d3zx9T60U52PzE7eteMuCdSU/+Mza29wUFgHVbbnRtjCfBywshItHmlYk1VYkGEC7bsItm/RkiBjy9nzIgdAihBSkdMVBV3sDprpD1xkXSoOXVZUlFPgXoz86otc/PtFNsjv7t1/MFcZvv5B8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772147041; c=relaxed/simple;
	bh=dl2BeNi/dbXlFLmX9rBlgtcZjTZOHkgihmeFDUNIhNU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/Jwztv/D56mRcSNYo+P2EH1byCIwm5L1JaqAOKsEvLp72dgYFe1wIaRJOZMCGAlU3PjOzdj608q1sg0je9VAbVHXMFGRLCQ1wzOg2zby6BSkQnRmXFu2ka4CH8jnf4fQ85DJC6e++YzK4zq02nkvvVxMoJ+OwpaZvtsfTE3+9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=pSKbpMBh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=itMG0KrX; arc=none smtp.client-ip=202.12.124.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 9F6221300BFE;
	Thu, 26 Feb 2026 18:03:57 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 26 Feb 2026 18:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772147037;
	 x=1772154237; bh=nMLSS/6smhC2Fkh6khLdkEUEvv92EQDMAOVxu9hbY5o=; b=
	pSKbpMBhjVCNUqBlCA9hD+PAOyjdKGsoXuEXpVYWW0tdWld7U/1w1NX2PmYBh/xn
	qo2DILVymgJ+aXiYyMFfT3jnhkE9B7opsAdiff9avzGjM/MXsGpc00dpMnvZH+v2
	+al57pngO7lZrPYnVu079A4SlbDzeFovpGchCvHqGWatoVsPVl6RrPEzl+P3nCb5
	oE0L2NS15px3cyVh5Qcf604sfEfRvQgZRC6Jb9ntHnIE5TaafEm1E6XlmLPIfc83
	f9ouaIu0hZGqkHCY8GCC1ZowDxp7Rgznbn690TZ/wsGjPCQ8o5VjZM/l+DRp9vbt
	dcjetnr74b8Jjy16XngAZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772147037; x=
	1772154237; bh=nMLSS/6smhC2Fkh6khLdkEUEvv92EQDMAOVxu9hbY5o=; b=i
	tMG0KrXlyEFXwalLMq9Sx0bQwBEAgP9bIZErOhRLK+YxLMjHGj/4pEB6yiISM9UB
	OiJQx272k4YcRkiIf1NT+lmiNDK1XLYNwsVvM+cKn2+iC29TRgWkNReqW7tf5oMC
	SO9UoppGBcBgwMXK9MJRMFWoE7UPMlhQAiitzOOkVRs2uOExtBYRRJe0ulaf1QZw
	HGVc3Isw7DmR0QVlIbuJdBI5a8GCLAEpiuM+klWIY5GnIXYK/PnDrGbdkB1LcKu5
	BYHX4zisQXoxrjyYzlkZ98AXUnJCkN7jYh1ZuTlqW76KnekpoRCowo/omVLticQX
	5gVCKqqyfQe8xrHK7Xt5w==
X-ME-Sender: <xms:XdGgacBk-a_O4YaEInjmWWDxabzQN4mLXC5qHVW4JFh-0mNlnVlFNQ>
    <xme:XdGgaULPU4sQfbMFfCtO-7kCODOOZLuyTwssclrsRpekwQfpSyKdg5TY_yhpHBy9o
    cLrLikyCCVk-iqtscnlq9KPMwGMdAm4lTFEkPGDHCSrMkkUucJ3Rg>
X-ME-Received: <xmr:XdGgaXpAlCE-PpaBMLNfI1-m1wWQpOlnWQ7LafEdb8Cgw61NBCBPYZGtKIs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejfeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeehpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtoheprghjrgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphht
    thhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfh
    gsrdgtohhmpdhrtghpthhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghs
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:XdGgabfq1Ai_EQPCKW27A1XJdpuSwGGpo_5-E1KoICM5d5hpf1B16g>
    <xmx:XdGgafpW__MOZjkcCeKPdqOzUegJkJbht_U9IShOJQZUvxnpHkhVuA>
    <xmx:XdGgaXQvCmNlF2J2dHS6vEVqYIZVfwQHxNyXMPN92lqXkjvDtj24dg>
    <xmx:XdGgaRwyXwCgwUD3I0SCQkXj7VyHRfPVqLTstyfDRwOu0X1MFBGsrQ>
    <xmx:XdGgaWSCrdHJXw1ROVKIfwjhuia4A0XZjl5nsXo6JfOBqvYYxsBNCQoN>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 18:03:54 -0500 (EST)
Date: Thu, 26 Feb 2026 16:03:53 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 " =?UTF-8?B?TWljaGHFgg==?= Winiarski" <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 "Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=" <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <20260226160353.6f3371bc@shazbot.org>
In-Reply-To: <20260129212510.967611-8-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-8-dmatlack@google.com>
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
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72100-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
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
X-Rspamd-Queue-Id: ADF351B0BA3
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 21:24:54 +0000
David Matlack <dmatlack@google.com> wrote:

> Notify the PCI subsystem about devices vfio-pci is preserving across
> Live Update by registering the vfio-pci liveupdate file handler with the
> PCI subsystem's FLB handler.
> 
> Notably this will ensure that devices preserved through vfio-pci will
> have their PCI bus numbers preserved across Live Update, allowing VFIO
> to use BDF as a key to identify the device across the Live Update and
> (in the future) allow the device to continue DMA operations across
> the Live Update.
> 
> This also enables VFIO to detect that a device was preserved before
> userspace first retrieves the file from it, which will be used in
> subsequent commits.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index 7f4117181fd0..ad915352303f 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  	if (IS_ERR(ser))
>  		return PTR_ERR(ser);
>  
> +	pci_liveupdate_outgoing_preserve(pdev);

Why do we get to ignore the return value here?

> +
>  	ser->bdf = pci_dev_id(pdev);
>  	ser->domain = pci_domain_nr(pdev->bus);
>  
> @@ -62,6 +64,9 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
>  	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>  }
>  
> @@ -171,6 +176,9 @@ static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_incoming_finish(to_pci_dev(device->dev));
>  	kho_restore_free(phys_to_virt(args->serialized_data));
>  }
>  
> @@ -192,10 +200,24 @@ static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
>  
>  int __init vfio_pci_liveupdate_init(void)
>  {
> +	int ret;
> +
>  	if (!liveupdate_enabled())
>  		return 0;
>  
> -	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	if (ret)
> +		return ret;
> +
> +	ret = pci_liveupdate_register_fh(&vfio_pci_liveupdate_fh);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +	return ret;
>  }
>  
>  void vfio_pci_liveupdate_cleanup(void)
> @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
>  	if (!liveupdate_enabled())
>  		return;
>  
> +	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));

This is propagation of a poor API choice in liveupdate, the unregister
should return void, it shouldn't be allowed to fail, IMO.  Thanks,

Alex

>  	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
>  }


