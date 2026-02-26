Return-Path: <kvm+bounces-72099-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJSiITTPoGmTmwQAu9opvQ
	(envelope-from <kvm+bounces-72099-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:54:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A051B0A0D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:54:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE9EC30FD77D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AED846AED8;
	Thu, 26 Feb 2026 22:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="o83TYSm/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mQieDi29"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6657319605;
	Thu, 26 Feb 2026 22:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772146354; cv=none; b=aj0Oh2xLhvNo+1gI0NeWGWCl7ZQP5hrPOWM7SZ4C/aTt24QXl2raV91blcKjJkxEp7xvzMoMRFZz43rZP+TeqxNjNIMc+ezFhX3Xd28pa3rxTOaogJbbZ4tJ5178dhXPdE4WNAwNBTyBggMe1vnFNy/XziCvy4i9RZmJTbvBbNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772146354; c=relaxed/simple;
	bh=JawCH7WtDz0spnzoZkOEOSJffQRudj3mIpBqcruV83E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ml5S49qOebhasW6eqXHGNTL/o3jBzJ0DRs/qjXVk/ev5+44ltgTnsrPfIjmEBwPB39wlnZjPq9yed7GGz/MUy6gbMGKSJGbWh5Zec327hTpNlJQRd8dt3XXzm5pItAcWg80TDzbdhCNc6kSmBFzK77aHDR1Ohsb07K3K839P4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=o83TYSm/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mQieDi29; arc=none smtp.client-ip=202.12.124.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id EBF011300BCC;
	Thu, 26 Feb 2026 17:52:28 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Thu, 26 Feb 2026 17:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772146348;
	 x=1772153548; bh=44uo4P/92yZYJcD163y8UHc8z0ZnnckxsAr9PpEhJjk=; b=
	o83TYSm/N5K9/2/Rtg8QOuuro4N9DEyyzUyMSplPsN/HHQ4SFtKbd1kGwp9qti8C
	CvLnqaRv1nJft8p4Y0Kfx3UPhzpppkvrC3+lmXar4Ih+r8yDS0BN+r95ELWuTHYO
	LCH/xD+NNQ8d3oFyo9vLoYiOMntUFokn9INVsNwb636AF3cZMrDdHlVhQMR4hO1e
	7s/OGnE5phRQfxWBF2pc2Hg3jHNw/z+Oa4xIIRlaqUKDmzxaCH0q3AglMZJTnAod
	GTcOFeay+bxbwjKYMCmBRbqswfGfBbi04mYW7an6R05gtlnDK29AoHRFU/SkoAEi
	tVIotca6drSoW2xWOmNd8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772146348; x=
	1772153548; bh=44uo4P/92yZYJcD163y8UHc8z0ZnnckxsAr9PpEhJjk=; b=m
	QieDi29aKWQhWaRpHtkJFXYVNhddIFR7f1/l5RV2JXj5JOe+34TRrGuQiPCDv/8q
	sjM36sYZIDHM2TGPHAxCACtHKdowQytZzI4RflFQSb3CxaENKe8Em93flZZh1XI2
	fjmRj009hat7tVQzvk6S123bFzQGqrO6/M+F9i94o1mZyJkarnMR7K8UZ54Bh24T
	fNJNab9xC16c8ohNRSoahEGm5WdPpm7ZXwjCDtv+SC8JsjDGZsJdZDeAb0FOwzzL
	1pOU0SrAsFwH342Fb6sIn9fs1m27yGiPdJBtFl9p6I7LXjWkkQds8iaA3hT0mKZu
	hLXSXHpBe9Y8dHfXiA/Fw==
X-ME-Sender: <xms:q86gaa0GCSBc5XmrtJOtc0A3ut03vk8J3s-GIS1-0yrWmZ63HMf-Og>
    <xme:q86gaZ5VAVB5eigFLbsLhd_u2X8uOaH9nw78UFOeqIQwSAW7uVUtjwvXEDRvbgHdF
    R2BaaKt1sSzbyyFclW2_Jo4xob0FFO9o6HKaqosuZvM9_8eUFDN2Q>
X-ME-Received: <xmr:q86gaXHtzv04BUksDBjPA5ncTtb6reAZXM-aGVQmLA7HEu2rMLsN3egnp9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeejfeegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:q86gaZ8IOgmE5jQ4E_zPNAkwAsNuDaoq9Ee8ASHZkDmvLycmY9W6Qw>
    <xmx:q86gaRM74BtYK0cfgvaow8GWkJUAe5HqLvyQVzPqdfUk8SyqK2o53g>
    <xmx:q86gadwTYJEI1Vb6JEv1mtsNrc-X6xUY5EjAoX5Q4RHmZ-5N99K_Ug>
    <xmx:q86gabsZUyLA7ivoaXFaN-s7syAAkj4Ajry4CbETBa0CDmMYZBV4dg>
    <xmx:rM6gab3exeKbhLg9LIZVoPa_QSXQHzpDienbmSCle7GUjyeehzyyTTDv>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 Feb 2026 17:52:23 -0500 (EST)
Date: Thu, 26 Feb 2026 15:52:22 -0700
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
Subject: Re: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files
 after Live Update
Message-ID: <20260226155222.5452a741@shazbot.org>
In-Reply-To: <20260129212510.967611-7-dmatlack@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-7-dmatlack@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev,shazbot.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72099-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,shazbot.org:mid,shazbot.org:dkim,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 26A051B0A0D
X-Rspamd-Action: no action

On Thu, 29 Jan 2026 21:24:53 +0000
David Matlack <dmatlack@google.com> wrote:

> From: Vipin Sharma <vipinsh@google.com>
> 
> Enable userspace to retrieve preserved VFIO device files from VFIO after
> a Live Update by implementing the retrieve() and finish() file handler
> callbacks.
> 
> Use an anonymous inode when creating the file, since the retrieved
> device file is not opened through any particular cdev inode, and the
> cdev inode does not matter in practice.
> 
> For now the retrieved file is functionally equivalent a opening the
> corresponding VFIO cdev file. Subsequent commits will leverage the
> preserved state associated with the retrieved file to preserve bits of
> the device across Live Update.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/device_cdev.c             | 21 ++++++---
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 60 +++++++++++++++++++++++++-
>  drivers/vfio/vfio_main.c               | 13 ++++++
>  include/linux/vfio.h                   | 12 ++++++
>  4 files changed, 98 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 8ceca24ac136..935f84a35875 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -16,14 +16,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
>  	device->cdev.owner = THIS_MODULE;
>  }
>  
> -/*
> - * device access via the fd opened by this function is blocked until
> - * .open_device() is called successfully during BIND_IOMMUFD.
> - */
> -int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> +int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep)
>  {
> -	struct vfio_device *device = container_of(inode->i_cdev,
> -						  struct vfio_device, cdev);
>  	struct vfio_device_file *df;
>  	int ret;
>  
> @@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>  	vfio_device_put_registration(device);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);

I really dislike that we're exporting the underscore variant, which
implies it's an internal function that the caller should understand the
constraints, without outlining any constraints.

I'm not sure what a good alternative is.  We can drop fops since this
isn't called from file_operations.  Maybe vfio_device_cdev_open_file().

> +
> +/*
> + * device access via the fd opened by this function is blocked until
> + * .open_device() is called successfully during BIND_IOMMUFD.
> + */
> +int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> +{
> +	struct vfio_device *device = container_of(inode->i_cdev,
> +						  struct vfio_device, cdev);
> +
> +	return __vfio_device_fops_cdev_open(device, filep);
> +}
>  
>  static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
>  {
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index f01de98f1b75..7f4117181fd0 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -8,6 +8,8 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/kho/abi/vfio_pci.h>
>  #include <linux/liveupdate.h>
> @@ -108,13 +110,68 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
>  	return ret;
>  }
>  
> +static int match_device(struct device *dev, const void *arg)
> +{
> +	struct vfio_device *device = container_of(dev, struct vfio_device, device);
> +	const struct vfio_pci_core_device_ser *ser = arg;
> +	struct pci_dev *pdev;
> +
> +	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
> +	if (!pdev)
> +		return false;
> +
> +	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
> +}
> +
>  static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  {
> -	return -EOPNOTSUPP;
> +	struct vfio_pci_core_device_ser *ser;
> +	struct vfio_device *device;
> +	struct file *file;
> +	int ret;
> +
> +	ser = phys_to_virt(args->serialized_data);
> +
> +	device = vfio_find_device(ser, match_device);
> +	if (!device)
> +		return -ENODEV;
> +
> +	/*
> +	 * Simulate opening the character device using an anonymous inode. The
> +	 * returned file has the same properties as a cdev file (e.g. operations
> +	 * are blocked until BIND_IOMMUFD is called).
> +	 */
> +	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
> +					&vfio_device_fops, NULL,
> +					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto out;
> +	}
> +
> +	ret = __vfio_device_fops_cdev_open(device, file);
> +	if (ret) {
> +		fput(file);

Don't we end up calling vfio_device_fops.release with NULL
file->private_data here with inevitable segfaults?  Thanks,

Alex

> +		goto out;
> +	}
> +
> +	args->file = file;
> +
> +out:
> +	/* Drop the reference from vfio_find_device() */
> +	put_device(&device->device);
> +
> +	return ret;
> +}
> +
> +static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
> +{
> +	return args->retrieved;
>  }
>  
>  static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
>  {
> +	kho_restore_free(phys_to_virt(args->serialized_data));
>  }
>  
>  static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> @@ -123,6 +180,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
>  	.unpreserve = vfio_pci_liveupdate_unpreserve,
>  	.freeze = vfio_pci_liveupdate_freeze,
>  	.retrieve = vfio_pci_liveupdate_retrieve,
> +	.can_finish = vfio_pci_liveupdate_can_finish,
>  	.finish = vfio_pci_liveupdate_finish,
>  	.owner = THIS_MODULE,
>  };
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 276f615f0c28..89c5feef75d5 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -13,6 +13,7 @@
>  #include <linux/cdev.h>
>  #include <linux/compat.h>
>  #include <linux/device.h>
> +#include <linux/device/class.h>
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> @@ -1758,6 +1759,18 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
>  }
>  EXPORT_SYMBOL(vfio_dma_rw);
>  
> +struct vfio_device *vfio_find_device(const void *data, device_match_t match)
> +{
> +	struct device *device;
> +
> +	device = class_find_device(vfio.device_class, NULL, data, match);
> +	if (!device)
> +		return NULL;
> +
> +	return container_of(device, struct vfio_device, device);
> +}
> +EXPORT_SYMBOL_GPL(vfio_find_device);
> +
>  /*
>   * Module/class support
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 9aa1587fea19..dc592dc00f89 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -419,4 +419,16 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
>  void vfio_virqfd_disable(struct virqfd **pvirqfd);
>  void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
>  
> +#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
> +int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep);
> +#else
> +static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
> +					       struct file *filep)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
> +
> +struct vfio_device *vfio_find_device(const void *data, device_match_t match);
> +
>  #endif /* VFIO_H */


