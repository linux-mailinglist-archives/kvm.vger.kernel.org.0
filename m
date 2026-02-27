Return-Path: <kvm+bounces-72113-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAS/I+reoGk4nwQAu9opvQ
	(envelope-from <kvm+bounces-72113-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:01:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF3A1B119B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 336E4309FCB8
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7F1309DC0;
	Fri, 27 Feb 2026 00:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="KfdyHubK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZglLpMDr"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E3618A6D4;
	Fri, 27 Feb 2026 00:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772150442; cv=none; b=ejzDHrf8ZyDvnYINe8yQ+AmG+4gDJfum7v5CgxNKVKU7LWts7Joro3t5e4QmgsOXkXgSh8Lp+HVVp/3JiQFHYpeVlvrRWTqgyQrSd07mibkg6DIWFN6WDuxt2bj5c9MzvMiB5VffYkelmWTmpJrxGNROYwgV+bG0GrNrluaI45E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772150442; c=relaxed/simple;
	bh=HzdAag1U7o4sXDozY+dYlvFhjNUh9q66cL4sCv1B3fc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pB8BCCrSvRYPFFDF5ycXAWgHCmE4BEvalXEXcGiwLRqueb5eHdjfJ8C6C5uztfjeGyFJbiMO/DeVIherUUmOVp9yc+4FyKdEOgJrWkoWR40B2cbcF/jtO/vSMkeRNq3lbYbuDZMhI7hGr01XYL9N77ZkZiPzJCxjMd9hAKtxVqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=KfdyHubK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZglLpMDr; arc=none smtp.client-ip=202.12.124.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id C7E2F13010DF;
	Thu, 26 Feb 2026 19:00:36 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 26 Feb 2026 19:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772150436;
	 x=1772157636; bh=7/IXhnnADeIhqB8XjstCGNDdQ5WTGWIX32H4Qcjj2Qw=; b=
	KfdyHubK7T6mgbCHRhIr5mD6ruTZ/iS4/fLNIWNjGnhl1gAn6fwi3ppJ06Gd2dJg
	4j+2iEI1NgIVGtQ1kbajwBmSZ3kucQpabC7rYBW1w7C9Ns95JC7G2sCDHFGTcMha
	kv7zoWe4YzeFKlalXC30X01vESpzdydowfQQQlWMPV+oZxWYLCz283lVR3zv2Nju
	eVuYQ9dFy2UDeoXJmZYe7S7vvDRP/TCyDm8hpE/sG7rbMKSh1TvkY8QDSsY8Cpg1
	4cwajHsmuyHaZiq7C2NI+9LmP/V6+FqeD6vXWgw/vHSpDK1AbcXQc1HLUA6FGUn8
	/XDw5I/P8HNRXjdutcMDoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772150436; x=
	1772157636; bh=7/IXhnnADeIhqB8XjstCGNDdQ5WTGWIX32H4Qcjj2Qw=; b=Z
	glLpMDrdH3ybIl6Jfbe8ZlqPwGEGiWIaKq84xdJ3XK72dVh252bgdeEHLhNGg88w
	3pDfMb8G+6ch5QZiYiTb2vdJac0ZiodwaNo8erWlfsW8wftbBkxgQ4hNNT4SzETg
	9xNYNGzd4JBoge3B2Vd6F//62u+9NBZ8XoKc5pbywbz8xoA1EsZcAiF6eo4hfyBI
	JQaANqURgm9EvX0L6bVDkSvv6JL/0ItofsOMGisEwrBldJgavCTL7e3d4uzr8Pqy
	wuJsoR33BNh7JMaPMshYytFmb9FjXE8o89NSJtN+p3BgZBE7aDmAMqP3zTdWMVzY
	8D3Z60+RKBqTkQZw6Ixcg==
X-ME-Sender: <xms:o96gaWTEnV5FxcL75W1_K7e8Bz0ZcR-1S0u_5NyytHtXv8SBEpirYQ>
    <xme:o96gaYmGfC4xz6mPRb4i8ZcE1LMJgkqCiSZk9yheAKn241ll_R_etVV_6kTxHHE7w
    H8cKRlU2sq26FM569T0VHWBriy5PaH5bhbbLCiPC0f2S_CXrBMYJA>
X-ME-Received: <xmr:o96gaYDj2UgYwWTCfXWlvCbKyPOUQXrlnfVEIrq7NLCPnXZSaSIprk1Y1HE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejgeejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:o96gaQJHyq02-tY5B_dgovb6RPEIgf6Zra2A8BonvF1GTzX4maPZjQ>
    <xmx:o96gaTq9myJ60d7pE_4qLYmIRw3gnIkLVp-szI7JBnBn6iTrqiLQZw>
    <xmx:o96gaXeIGbQgQvAmt_4Ob1Gt3PjoRrw-qPHspQrSOhWEA3H5bkLJxg>
    <xmx:o96gaboB8XLmP2v_WRvZDm7kWd2k5QB2M1rchi9hpS9YGiFsZlw84w>
    <xmx:pN6gacyXTZuNPPKKceRhRy0cZc3qSkBNvPabhXzUVrNJ42U27GWaTM6T>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 19:00:32 -0500 (EST)
Date: Thu, 26 Feb 2026 17:00:30 -0700
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
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260226170030.5a938c74@shazbot.org>
In-Reply-To: <20260129212510.967611-11-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
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
	TAGGED_FROM(0.00)[bounces-72113-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:mid,shazbot.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 2AF3A1B119B
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 21:24:57 +0000
David Matlack <dmatlack@google.com> wrote:

> From: Vipin Sharma <vipinsh@google.com>
> 
> Do not reset the device when a Live Update preserved vfio-pci device is
> retrieved and first enabled. vfio_pci_liveupdate_freeze() guarantees the
> device is reset prior to Live Update, so there's no reason to reset it
> again after Live Update.
> 
> Since VFIO normally uses the initial reset to detect if the device
> supports function resets, pass that from the previous kernel via
> struct vfio_pci_core_dev_ser.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c       | 22 +++++++++++++++++-----
>  drivers/vfio/pci/vfio_pci_liveupdate.c |  1 +
>  include/linux/kho/abi/vfio_pci.h       |  2 ++
>  include/linux/vfio_pci_core.h          |  1 +
>  4 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index b01b94d81e28..c9f73f597797 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -515,12 +515,24 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (ret)
>  		goto out_power;
>  
> -	/* If reset fails because of the device lock, fail this path entirely */
> -	ret = pci_try_reset_function(pdev);
> -	if (ret == -EAGAIN)
> -		goto out_disable_device;
> +	if (vdev->liveupdate_incoming_state) {
> +		/*
> +		 * This device was preserved by the previous kernel across a
> +		 * Live Update, so it does not need to be reset.
> +		 */
> +		vdev->reset_works = vdev->liveupdate_incoming_state->reset_works;
> +	} else {
> +		/*
> +		 * If reset fails because of the device lock, fail this path
> +		 * entirely.
> +		 */
> +		ret = pci_try_reset_function(pdev);
> +		if (ret == -EAGAIN)
> +			goto out_disable_device;
> +
> +		vdev->reset_works = !ret;
> +	}

This could maybe be incrementally cleaner in a
int vfio_pci_core_probe_reset(struct vfio_pci_core_device *vdev)
helper.

>  
> -	vdev->reset_works = !ret;
>  	pci_save_state(pdev);
>  	vdev->pci_saved_state = pci_store_saved_state(pdev);

Isn't this a problem too?  In the first kernel we store the initial,
post reset state of the device, now we're storing some arbitrary state.
This is the state we're restore when the device is closed.

>  	if (!vdev->pci_saved_state)
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index 1ad7379c70c4..c52d6bdb455f 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -57,6 +57,7 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  
>  	ser->bdf = pci_dev_id(pdev);
>  	ser->domain = pci_domain_nr(pdev->bus);
> +	ser->reset_works = vdev->reset_works;
>  
>  	args->serialized_data = virt_to_phys(ser);
>  	return 0;
> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
> index 9bf58a2f3820..6c3d3c6dfc09 100644
> --- a/include/linux/kho/abi/vfio_pci.h
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -34,10 +34,12 @@
>   *
>   * @bdf: The device's PCI bus, device, and function number.
>   * @domain: The device's PCI domain number (segment).
> + * @reset_works: Non-zero if the device supports function resets.
>   */
>  struct vfio_pci_core_device_ser {
>  	u16 bdf;
>  	u16 domain;
> +	u8 reset_works;
>  } __packed;
>  
>  #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 350c30f84a13..95835298e29e 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/uuid.h>
>  #include <linux/notifier.h>
> +#include <linux/kho/abi/vfio_pci.h>
>  
>  #ifndef VFIO_PCI_CORE_H
>  #define VFIO_PCI_CORE_H

Wouldn't a forward declaration do, and the kho/abi include can be kept
out of the public header?  Also should be in the previous patch?
Thanks,

Alex

