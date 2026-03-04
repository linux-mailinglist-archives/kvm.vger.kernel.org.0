Return-Path: <kvm+bounces-72751-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KohIyq0qGliwgAAu9opvQ
	(envelope-from <kvm+bounces-72751-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:37:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B72208B96
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 23:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6AC1230387FB
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 22:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612643976BB;
	Wed,  4 Mar 2026 22:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Bc/sIF2L";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ulxMpdmB"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F965332EBB;
	Wed,  4 Mar 2026 22:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772663826; cv=none; b=W/OBqWNh1Ao43gimAmiepK/dhENIGTvA23kH0JCA7lvF6DyWY70BuykKEmvzF6+eItxUr5TLxJcD4NQtEky4KFHCMgkSsyNMmqfb/pLgRrwTdSkeiFQhmYcj3ysz9OakWU/7rHSBp73l/4fEpSUIsezLRq6OSelvICE7Fat5zCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772663826; c=relaxed/simple;
	bh=I+wBYd/VbLPB5EBcZUXdmH2JcnblhQuTFgiK2rzHtcY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RP42HbvXfnM3ZoJN6LiHWpSE8zYZHqzxWSW3sCrV/Vwd36n3wLmLLlPA/b0nGLHoeilrtGotma9OjvrFi4g479F5CETbYPEzY5td9eihWy1LtiBw6TDlLaxnWpsxkpDcZIRZ1hn2Ke2i2QOyYunIwV6dINa+gvHZH6e0resot7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Bc/sIF2L; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ulxMpdmB; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id EC7731D000F9;
	Wed,  4 Mar 2026 17:37:02 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 04 Mar 2026 17:37:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772663822;
	 x=1772750222; bh=hrooC1fDdzJBlpvLA6iV8p27egcYITdbR0uz/yB9Vbw=; b=
	Bc/sIF2LU8DmhiflC76Qb2ESBAgjFWKe+aoIPDD45Y3msuJpDh++vGjsUq0I0WF0
	2oepCXp749aZ/4tRsme0row/F42vCjO5JufIe+05wH3R/0OQWQfvcsku2TjV96PI
	m39Hucsj0KEQE50ETcmR063n3TDI/ORinMEjjtDR2TQvsbPisIvECr0+sZBi8vHO
	anzjenXAxH4zsF5zsdWkXzcAjziYkumqU4rWtAeVbca7VHvPMD1bAht+MTSHYDUb
	wHh0uid7EUNACtKBI5928naSDx9QdbTGcCuTtdrWDlxLqO+ILr/qDC0wUX1WeuQj
	lur+8NN+0LWMtJSV9Y4evg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772663822; x=
	1772750222; bh=hrooC1fDdzJBlpvLA6iV8p27egcYITdbR0uz/yB9Vbw=; b=u
	lxMpdmBxjivH0H1yq7rmAFBmDBBEy90Dz4tU2ht5yffeVju9CjVnmpDuKRanYpKL
	MFTwN7spiSe/yXMx4f0uOhvCrUPHSz+HqcU+1HbyIYzkDHqzhrRPuinwO+uE8Pd2
	sBThxgNzX8VsDNt9CMnqdLt8gCIFuCcMlTPJX5v9VN4fWXKf6o+kJuBID1nhdNGN
	EieUCwqi1eUh+MoI7tFqDFilBygIj377jPOo6JrIBmB8p/rJH8zWcYLocKkJXY5c
	XJGcZq+RSd64zQvm0XncDmWoaZFansiIItGZ216otGtl58wyxVzCePF2ATZ/EX3E
	fVq5XxAcAO4LIs9cEEICQ==
X-ME-Sender: <xms:DrSoaa6O0F70Bmw_shZnQJyLTa4V7leJ8R6gfK0Dv5PZtVHM3h1Cug>
    <xme:DrSoaZFb5VuP7acOwCdllhV6SuhEftYiD945-Bw9eBXnaAdUlqwSq9RIUuX4gkb6C
    UF0m7GI13pD4AYVT1hRfGKmERN5zTLNWLcPj1GY_51EcP97_qHKTQ>
X-ME-Received: <xmr:DrSoac3KAngKATotzbxuTStvS0NwL4M8o9cNFLNeP5eaWxxfg0JC4pJeCRM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegjedvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:DrSoaWrGfvSS2FZTqlYnRIQzrUOUryRkecD7oVVgxDAwG31QMEZCag>
    <xmx:DrSoaZNKcbgY-XH8tl10-6LuuX1qBh8GR7gcJYgE-wsPtKow6mJJhg>
    <xmx:DrSoaYVSocsFQYXMTalIdkE3Enn28cF5bMSCW0boF_q8E47czrzWKQ>
    <xmx:DrSoacsxK08D7IG1rmuvIqeHv9k_XlGBaVsbbSdtiPlr4kO3_Tagag>
    <xmx:DrSoaY2jaht9hyK0R9l7IUJvQPJhi4iz6oYPA-atVl4D5TTqWAlyeqgn>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 17:37:01 -0500 (EST)
Date: Wed, 4 Mar 2026 15:37:00 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 11/15] vfio/nvgrace-egm: Fetch EGM region retired
 pages list
Message-ID: <20260304153700.59fa72d2@shazbot.org>
In-Reply-To: <20260223155514.152435-12-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-12-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 35B72208B96
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
	TAGGED_FROM(0.00)[bounces-72751-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,messagingengine.com:dkim,shazbot.org:dkim,shazbot.org:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:10 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> It is possible for some system memory pages on the EGM to
> have retired pages with uncorrectable ECC errors. A list of
> pages known with such errors (referred as retired pages) are
> maintained by the Host UEFI. The Host UEFI populates such list
> in a reserved region. It communicates the SPA of this region
> through a ACPI DSDT property.
> 
> nvgrace-egm module is responsible to store the list of retired page
> offsets to be made available for usermode processes. The module:
> 1. Get the reserved memory region SPA and maps to it to fetch
> the list of bad pages.
> 2. Calculate the retired page offsets in the EGM and stores it.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c     | 75 ++++++++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 32 +++++++++--
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  5 +-
>  drivers/vfio/pci/nvgrace-gpu/main.c    |  8 +--
>  include/linux/nvgrace-egm.h            |  2 +
>  5 files changed, 112 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index de7771a4145d..077de3833046 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -8,6 +8,11 @@
>  
>  #define MAX_EGM_NODES 4
>  
> +struct h_node {
> +	unsigned long mem_offset;
> +	struct hlist_node node;
> +};
> +
>  static dev_t dev;
>  static struct class *class;
>  static DEFINE_XARRAY(egm_chardevs);
> @@ -16,6 +21,7 @@ struct chardev {
>  	struct device device;
>  	struct cdev cdev;
>  	atomic_t open_count;
> +	DECLARE_HASHTABLE(htbl, 0x10);
>  };
>  
>  static struct nvgrace_egm_dev *
> @@ -174,20 +180,88 @@ static void del_egm_chardev(struct chardev *egm_chardev)
>  	put_device(&egm_chardev->device);
>  }
>  
> +static void cleanup_retired_pages(struct chardev *egm_chardev)
> +{
> +	struct h_node *cur_page;
> +	unsigned long bkt;
> +	struct hlist_node *temp_node;
> +
> +	hash_for_each_safe(egm_chardev->htbl, bkt, temp_node, cur_page, node) {
> +		hash_del(&cur_page->node);
> +		kvfree(cur_page);
> +	}
> +}
> +
> +static int nvgrace_egm_fetch_retired_pages(struct nvgrace_egm_dev *egm_dev,
> +					   struct chardev *egm_chardev)
> +{
> +	u64 count;
> +	void *memaddr;
> +	int index, ret = 0;
> +
> +	memaddr = memremap(egm_dev->retiredpagesphys, PAGE_SIZE, MEMREMAP_WB);

We're reading some data structure in physical memory, how does that
data structure have any relation to the kernel PAGE_SIZE, which might
be 4K or 64K?

> +	if (!memaddr)
> +		return -ENOMEM;
> +
> +	count = *(u64 *)memaddr;

So the first 8-bytes contains a page count.

> +	if (count > PAGE_SIZE / sizeof(count))
> +		return -EINVAL;

So if it's a 64K table and we're on a 4K host, this can unnecessarily
fail, or fail to incorporate the vast majority of pages.

Also the 0th index is the count itself, so there can only be 511
entries with 4K page, not 512.  This is off-by-one and the loop below
can exceed the map range.

AI also tells me that the hash table is vastly oversized for containing
either 511 or 8191 entries.

Also we didn't menunmap on this error condition.

> +
> +	for (index = 0; index < count; index++) {
> +		struct h_node *retired_page;
> +
> +		/*
> +		 * Since the EGM is linearly mapped, the offset in the
> +		 * carveout is the same offset in the VM system memory.
> +		 *
> +		 * Calculate the offset to communicate to the usermode
> +		 * apps.
> +		 */
> +		retired_page = kzalloc(sizeof(*retired_page), GFP_KERNEL);
> +		if (!retired_page) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		retired_page->mem_offset = *((u64 *)memaddr + index + 1) -
> +					   egm_dev->egmphys;
> +		hash_add(egm_chardev->htbl, &retired_page->node,
> +			 retired_page->mem_offset);
> +	}
> +
> +	memunmap(memaddr);
> +
> +	if (ret)
> +		cleanup_retired_pages(egm_chardev);
> +
> +	return ret;
> +}
> +
>  static int egm_driver_probe(struct auxiliary_device *aux_dev,
>  			    const struct auxiliary_device_id *id)
>  {
>  	struct nvgrace_egm_dev *egm_dev =
>  		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
>  	struct chardev *egm_chardev;
> +	int ret;
>  
>  	egm_chardev = setup_egm_chardev(egm_dev);
>  	if (!egm_chardev)
>  		return -EINVAL;
>  
> +	hash_init(egm_chardev->htbl);
> +
> +	ret = nvgrace_egm_fetch_retired_pages(egm_dev, egm_chardev);
> +	if (ret)
> +		goto error_exit;
> +
>  	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev, GFP_KERNEL);
>  
>  	return 0;
> +
> +error_exit:
> +	del_egm_chardev(egm_chardev);
> +	return ret;
>  }
>  
>  static void egm_driver_remove(struct auxiliary_device *aux_dev)
> @@ -199,6 +273,7 @@ static void egm_driver_remove(struct auxiliary_device *aux_dev)
>  	if (!egm_chardev)
>  		return;
>  
> +	cleanup_retired_pages(egm_chardev);
>  	del_egm_chardev(egm_chardev);
>  }
>  
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> index 20291504aca8..6d716c3a3257 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -18,22 +18,41 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
>  }
>  
>  int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> -				   u64 *pegmlength)
> +				   u64 *pegmlength, u64 *pretiredpagesphys)
>  {
>  	int ret;
>  
>  	/*
> -	 * The memory information is present in the system ACPI tables as DSD
> -	 * properties nvidia,egm-base-pa and nvidia,egm-size.
> +	 * The EGM memory information is present in the system ACPI tables
> +	 * as DSD properties nvidia,egm-base-pa and nvidia,egm-size.
>  	 */
>  	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-size",
>  				       pegmlength);
>  	if (ret)
> -		return ret;
> +		goto error_exit;
>  
>  	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
>  				       pegmphys);
> +	if (ret)
> +		goto error_exit;
> +
> +	/*
> +	 * SBIOS puts the list of retired pages on a region. The region
> +	 * SPA is exposed as "nvidia,egm-retired-pages-data-base".
> +	 */
> +	ret = device_property_read_u64(&pdev->dev,
> +				       "nvidia,egm-retired-pages-data-base",
> +				       pretiredpagesphys);
> +	if (ret)
> +		goto error_exit;
> +
> +	/* Catch firmware bug and avoid a crash */
> +	if (*pretiredpagesphys == 0) {
> +		dev_err(&pdev->dev, "Retired pages region is not setup\n");
> +		ret = -EINVAL;
> +	}
>  
> +error_exit:
>  	return ret;
>  }
>  
> @@ -74,7 +93,8 @@ static void nvgrace_gpu_release_aux_device(struct device *device)
>  
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmphys, u64 egmlength, u64 egmpxm)
> +			      u64 egmphys, u64 egmlength, u64 egmpxm,
> +			      u64 retiredpagesphys)
>  {
>  	struct nvgrace_egm_dev *egm_dev;
>  	int ret;
> @@ -86,6 +106,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
>  	egm_dev->egmpxm = egmpxm;
>  	egm_dev->egmphys = egmphys;
>  	egm_dev->egmlength = egmlength;
> +	egm_dev->retiredpagesphys = retiredpagesphys;
> +
>  	INIT_LIST_HEAD(&egm_dev->gpus);
>  
>  	egm_dev->aux_dev.id = egmpxm;
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> index 2e1612445898..2f329a05685d 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -16,8 +16,9 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
>  
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmphys, u64 egmlength, u64 egmpxm);
> +			      u64 egmphys, u64 egmlength, u64 egmpxm,
> +			      u64 retiredpagesphys);
>  
>  int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> -				   u64 *pegmlength);
> +				   u64 *pegmlength, u64 *pretiredpagesphys);
>  #endif /* EGM_DEV_H */
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 0bb427cca31f..11bbecda1ad2 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -78,7 +78,7 @@ static struct list_head egm_dev_list;
>  static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  {
>  	struct nvgrace_egm_dev_entry *egm_entry = NULL;
> -	u64 egmphys, egmlength, egmpxm;
> +	u64 egmphys, egmlength, egmpxm, retiredpagesphys;
>  	int ret = 0;
>  	bool is_new_region = false;
>  
> @@ -91,7 +91,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
>  		goto exit;
>  
> -	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength);
> +	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength,
> +					     &retiredpagesphys);
>  	if (ret)
>  		goto exit;
>  
> @@ -114,7 +115,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  
>  	egm_entry->egm_dev =
>  		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
> -					      egmphys, egmlength, egmpxm);
> +					      egmphys, egmlength, egmpxm,
> +					      retiredpagesphys);
>  	if (!egm_entry->egm_dev) {
>  		ret = -EINVAL;
>  		goto free_egm_entry;
> diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
> index b9956e7e5a0e..9e0d190c7da0 100644
> --- a/include/linux/nvgrace-egm.h
> +++ b/include/linux/nvgrace-egm.h
> @@ -7,6 +7,7 @@
>  #define NVGRACE_EGM_H
>  
>  #include <linux/auxiliary_bus.h>
> +#include <linux/hashtable.h>

This is implementation, it should be in the c file not the public
header.  Thanks,

Alex

>  
>  #define NVGRACE_EGM_DEV_NAME "egm"
>  #define EGM_OFFSET_SHIFT   40
> @@ -20,6 +21,7 @@ struct nvgrace_egm_dev {
>  	struct auxiliary_device aux_dev;
>  	phys_addr_t egmphys;
>  	size_t egmlength;
> +	phys_addr_t retiredpagesphys;
>  	u64 egmpxm;
>  	struct list_head gpus;
>  };


