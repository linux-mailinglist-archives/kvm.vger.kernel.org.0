Return-Path: <kvm+bounces-72106-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCU1JTHUoGmrnAQAu9opvQ
	(envelope-from <kvm+bounces-72106-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:16:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C8901B0D41
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0FFAC3045038
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C22312811;
	Thu, 26 Feb 2026 23:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="gVXvAPiI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JgC6lC5v"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3C724E4A8;
	Thu, 26 Feb 2026 23:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772147723; cv=none; b=BT2MEeHGtZt2TIfJRgdFW+YkWTlAaMH7JAfwrijDot55FqJ8noz3iLnA+LdPCccSKpY5VAIb/k1qU0/cLMe5beK0PQoUN7O5BOk9zHOutIpR5ldbbvvZESRIo/x55PkBYSU4O2y9hwxY3LwKUiamkYszqb9PHWj0l78zmDyl9HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772147723; c=relaxed/simple;
	bh=xoQ+8FizHIoR331h2dUG2sUBkZkq/IFhkR0HUVL42SE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NjmJshvBg0FCiLcIXiGeqSxdRxCCSKNR6Am9/7Xqr3puxOq81HRSrptWLtDa1fuO6uvXkGYjt3UwmwTZAtMW6XJy11jkKKGmLoK3jhfX4J3/rEEdiAF3LRVGcJW/uoyKY1l6lCz9hkegVkV9Pye+6iW/ni99TcLloGZE+1pG6P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=gVXvAPiI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JgC6lC5v; arc=none smtp.client-ip=202.12.124.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 8F7561300FF1;
	Thu, 26 Feb 2026 18:15:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 26 Feb 2026 18:15:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772147718;
	 x=1772154918; bh=yr+JJ9YtD7fwvp/AM3VRdjXUZyKz3WadH0Ul1izy0Z0=; b=
	gVXvAPiIdt7JQHCG4TOy7SMG+5ql/toI+tvIZ+D4ZaWDiyRdMAQd/1KZyuxAtUzt
	hlzCnMbNtPNy8ufmzc6m6AWzKO7yp6VXXmkQhx6H62452wB7LtgjW8L56vilmyYU
	WILdSXDRUyk0L2K+OCYAvjn3kaFdVLwV0KvrHxGJXnJO93b6jF81uQGlVbEllWrz
	0j6fXXSRa74mG0ktKv12Xcgcs4zAv/2q4LlfcBwFoHAMWlyRmIq04c99KYkgRqej
	4K0IyixSiJ7JrkyoyBbj1TxyoTrmj3bZik1TT94WuYSIh7iqTuZq0KWaDkIacTk7
	JfkWg7Y3Q3B0a73/khWDNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772147718; x=
	1772154918; bh=yr+JJ9YtD7fwvp/AM3VRdjXUZyKz3WadH0Ul1izy0Z0=; b=J
	gC6lC5vVC3gTJr1nCXt15HaLHDwk1aDrvyLUae67J4THeyPePTlSb7Do3ZsKZyns
	991HwVvfggEf+EaP/DL+O/nt3U6xHIrsa3e9Lyw0AnjdwChPGbbfzX6vB4PrYfE6
	UcXqmeDaAqxhds4eCgitvxgHDxHuwg6VpNOwUEZYE3URL4gcyGo3oynuEUeePwuc
	xuL3zs5Zx/Iv628XmCXiRlKNkVxs6WdQXzZyPzGl6eZ9+nL2RvcTt/i4gt4RuBe6
	n0ZXbMXki7yADbt8Ht4iQR4b4sQvDVpw5W4cvaAmEb98XepC6/BP5k6bNjPXMvic
	NRTmZhx6sl82fET4Pm7/w==
X-ME-Sender: <xms:BdSgaevBS-DP0E4PhF3SquCgA8u8bMx79QdHt-Vjk3m_hxwfIAJbCA>
    <xme:BdSgaQTDzIFDQe1gPvHOw9yHE4rE_oDxrvCrkjQ2qkM5VG5_HgMGBJT_dstvuGGEi
    GvhyqsFvZiERYQTpESNKdtPuXb0TlJSRYKrsev-NlUF20Z3SoM5BQ>
X-ME-Received: <xmr:BdSgad8lvkPNqEfr4rQXnoahwH0W1hQor4jiORwyCDcQBz72kZJkh_IX66A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejfeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:BdSgaXXjLybHbzutmuhIRci-8jpP40Xadl469qn5-4LoLe3S2Wb6cA>
    <xmx:BdSgaTGscqQPoDKst3DW8n1f1L054xbRkQYM5nsXRgP6lM_pPySt-g>
    <xmx:BdSgaaIxA5UEkBwT4LITTYN9WAf2Xehxe7ABZ29EHJuN-_uzDIhtMw>
    <xmx:BdSgaQmrDmIe8VjUAllvJFp9dMnIhHtKyOV3nfzNMEfOEE4pPVy9gQ>
    <xmx:BtSgaWy6imTK0zo4upPI5vovhFFHOcrzJtk4VSYMJJddYDd92-Nd46Y9>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 18:15:14 -0500 (EST)
Date: Thu, 26 Feb 2026 16:15:12 -0700
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
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <20260226161512.532609ec@shazbot.org>
In-Reply-To: <20260129212510.967611-9-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-9-dmatlack@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72106-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 0C8901B0D41
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 21:24:55 +0000
David Matlack <dmatlack@google.com> wrote:

> Enforce that files for incoming (preserved by previous kernel) VFIO
> devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD rather than by
> opening the corresponding VFIO character device or via
> VFIO_GROUP_GET_DEVICE_FD.
> 
> Both of these methods would result in VFIO initializing the device
> without access to the preserved state of the device passed by the
> previous kernel.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/device_cdev.c |  4 ++++
>  drivers/vfio/group.c       |  9 +++++++++
>  include/linux/vfio.h       | 18 ++++++++++++++++++
>  3 files changed, 31 insertions(+)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 935f84a35875..355447e2add3 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -57,6 +57,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>  	struct vfio_device *device = container_of(inode->i_cdev,
>  						  struct vfio_device, cdev);
>  
> +	/* Device file must be retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD */
> +	if (vfio_liveupdate_incoming_is_preserved(device))
> +		return -EBUSY;
> +
>  	return __vfio_device_fops_cdev_open(device, filep);
>  }
>  
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index d47ffada6912..63fc4d656215 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -311,6 +311,15 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
>  	if (IS_ERR(device))
>  		return PTR_ERR(device);
>  
> +	/*
> +	 * This device was preserved across a Live Update. Accessing it via
> +	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
> +	 */
> +	if (vfio_liveupdate_incoming_is_preserved(device)) {
> +		vfio_device_put_registration(device);
> +		return -EBUSY;

Is this an EPERM issue then?

> +	}
> +
>  	fd = FD_ADD(O_CLOEXEC, vfio_device_open_file(device));
>  	if (fd < 0)
>  		vfio_device_put_registration(device);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index dc592dc00f89..0921847b18b5 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -16,6 +16,7 @@
>  #include <linux/cdev.h>
>  #include <uapi/linux/vfio.h>
>  #include <linux/iova_bitmap.h>
> +#include <linux/pci.h>
>  
>  struct kvm;
>  struct iommufd_ctx;
> @@ -431,4 +432,21 @@ static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
>  
>  struct vfio_device *vfio_find_device(const void *data, device_match_t match);
>  
> +#ifdef CONFIG_LIVEUPDATE
> +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> +{
> +	struct device *d = device->dev;
> +
> +	if (dev_is_pci(d))
> +		return to_pci_dev(d)->liveupdate_incoming;
> +
> +	return false;
> +}
> +#else
> +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> +{
> +	return false;
> +}
> +#endif

Why does this need to be in the public header versus
drivers/vfio/vfio.h?

