Return-Path: <kvm+bounces-72746-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGfqKq+TqGkLvwAAu9opvQ
	(envelope-from <kvm+bounces-72746-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 21:18:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D4BE207896
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 21:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 288ED3053BB3
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 20:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D9F369995;
	Wed,  4 Mar 2026 20:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="UL/pg55H";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JyPdP7JB"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DED32D8DA8;
	Wed,  4 Mar 2026 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772655414; cv=none; b=oQI2leIPw+Q96jWDvTRhLatnWpnP4Xct7MNzPvjH2GdZ5lantJx12XHqf16mBNuA9WBV8LeG/LY+pn+E/czAcwMgw4Rdu1/px2Q86KaI7reWmrt9cO9au5JcCibd8fAPBQb4rI9fDPJ7iK52GII2StgcwoAqyY6214BSUE4rABs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772655414; c=relaxed/simple;
	bh=KRujG7fBCMkZA1gJHXWnh19vKm0F6lCwwhHWOpUBJus=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6zT4WdxsbOSZ5SlbrQ9RID+gYoq4FO5ch27OIODpL5O7dbwMzU+2sJji7njxTUSPOHMZdUGJHurq2YN2UM7qjt3vqGv7uinVxm6UWqPRKmgALZibGd0R+Z+DdqXB2K4t5DWx7CwTmqlANVK9j+E/+3F7TFIE0MJe0HaSiHaV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=UL/pg55H; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JyPdP7JB; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 13DF97A01C1;
	Wed,  4 Mar 2026 15:16:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 04 Mar 2026 15:16:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772655409;
	 x=1772741809; bh=lI425ulSLKBbEpcwXpPxoaZBEMvse/7EwDEH5AR63m4=; b=
	UL/pg55H+NHT1SB5zTEfp4IM+oP3XlXoc5p2kTAWmiijUBcrLMwSvnwgMFVms5fH
	TvaxJNYD+gu/E2HW2ZPSKhsyFwpUb3PO+N/VPnDYAKQtAc2xYoEAxFiAsplRKlj1
	AzGEYg4Rrb66wWLsmi0iUmvR7XoemNO+vV0LnpddTPl8InTYy37fo1IUCzi8tONG
	9vwe2seWm3xO16wVaxBBOQuOPyePUjlai30HtBalv9gFu59LosV2JnLtMtocKuRx
	Q5uMCyteaKNBFkKUbLlEIoOi66jMe8yetYg32LYJU4w/DPg3hmXRiEQ3D4fgLFDg
	zfH/2sqpthlSLC3eN228kQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772655409; x=
	1772741809; bh=lI425ulSLKBbEpcwXpPxoaZBEMvse/7EwDEH5AR63m4=; b=J
	yPdP7JBzt7Z99oqPeL8wRQ8tZjpa96XWCenP+ECRRgG1rdVI7D0mL47ACX670Raw
	DMl2ItwEaqE+Z2KqE7h+wmZ5tTMDe0RRbCKfo6mOf7BCQZh1s+YgvFJLurdN3BL6
	MiBm5dr1VnBkpmeuybetXfh3a6gug73+P3qGuwL+dNomkUqHM2WtAyHujaVNIssS
	b/iSwE1iVf3Ayo7i0FOPfq6MAuTuFNVSZd+g9tKDA7RQ6Wq0LMGG61WzqtdKtU9t
	/ZSMnGJWSpp3IMY8zztmEUXDR2x6kXRuD7K5iDh6CE2zxO9wogeB4+kRVOdajhak
	sSfu4j1/QxhebJbzwUDsg==
X-ME-Sender: <xms:MZOoaS9xENn37164pe5dbiCXqyqAuXZBh6PStlBvjGK598SNjjf63g>
    <xme:MZOoaX6yhHvmi_qk93zCG1fhUwAzVzNS5DDCA77Meyg-Mk53OjYOe-vMs2JDejRIu
    m-hrPgcKCCjaRSEXnvigoZuZOMAJSHTzPmcucH3TwXi4MfNfic>
X-ME-Received: <xmr:MZOoaba7b78yNFwkJB57bWwWWMR7_cOLKWHNQbOcPJfa011gOBzupzBwNco>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieeggeefucetufdoteggodetrf
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
X-ME-Proxy: <xmx:MZOoaZ-vHmOaELY_fmZyWaqQ1Rz9thrHkmn1NmL2numWmDCHqRWvTw>
    <xmx:MZOoaSQ06XCbUxBXf07iuujzZCQAvyNQE2NqDOOhft3YT4jjzamUFQ>
    <xmx:MZOoaUILNCLJJaapZC_69urw33uhpZq745SnUhDBWfzVfeVZLvpaWw>
    <xmx:MZOoaUSo2TGx9MMdVqfCBBr6_IROO10eSfYGAGG1CeuMaQiLmemkIA>
    <xmx:MZOoaTJ6_a2A66lJzoNz6IzaJsX2B8eCfvY0ECLcoj-IhKDeiFjTBreB>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 15:16:48 -0500 (EST)
Date: Wed, 4 Mar 2026 13:16:46 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 08/15] vfio/nvgrace-egm: Expose EGM region as
 char device
Message-ID: <20260304131646.272b93ea@shazbot.org>
In-Reply-To: <20260223155514.152435-9-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-9-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D4BE207896
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
	TAGGED_FROM(0.00)[bounces-72746-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,nvidia.com:email,messagingengine.com:dkim]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:07 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The EGM module expose the various EGM regions as a char device. A
> usermode app such as Qemu may mmap to the region and use as VM sysmem.
> Each EGM region is represented with a unique char device /dev/egmX
> bearing a distinct minor number.
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
>  drivers/vfio/pci/nvgrace-gpu/egm.c | 99 ++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> index 6fd6302a004a..d7e4f61a241c 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -10,15 +10,114 @@
>  
>  static dev_t dev;
>  static struct class *class;
> +static DEFINE_XARRAY(egm_chardevs);
> +
> +struct chardev {
> +	struct device device;
> +	struct cdev cdev;
> +};
> +
> +static int nvgrace_egm_open(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}
> +
> +static int nvgrace_egm_release(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}
> +
> +static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	return 0;

At this point it seems none of these stubs should return success.

> +}
> +
> +static const struct file_operations file_ops = {
> +	.owner = THIS_MODULE,
> +	.open = nvgrace_egm_open,
> +	.release = nvgrace_egm_release,
> +	.mmap = nvgrace_egm_mmap,
> +};
> +
> +static void egm_chardev_release(struct device *dev)
> +{
> +	struct chardev *egm_chardev = container_of(dev, struct chardev, device);
> +
> +	kfree(egm_chardev);
> +}
> +
> +static struct chardev *
> +setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
> +{
> +	struct chardev *egm_chardev;
> +	int ret;
> +
> +	egm_chardev = kzalloc(sizeof(*egm_chardev), GFP_KERNEL);
> +	if (!egm_chardev)
> +		goto create_err;

return ERR_PTR(-ENOMEM);  Same for remaining returns.

> +
> +	device_initialize(&egm_chardev->device);
> +
> +	/*
> +	 * Use the proximity domain number as the device minor
> +	 * number. So the EGM corresponding to node X would be
> +	 * /dev/egmX.
> +	 */
> +	egm_chardev->device.devt = MKDEV(MAJOR(dev), egm_dev->egmpxm);

As in previous comment, we have no guarantee that the PXM value is in
the range 0-3 of the reserved minor numbers.

> +	egm_chardev->device.class = class;
> +	egm_chardev->device.release = egm_chardev_release;
> +	egm_chardev->device.parent = &egm_dev->aux_dev.dev;
> +	cdev_init(&egm_chardev->cdev, &file_ops);
> +	egm_chardev->cdev.owner = THIS_MODULE;
> +
> +	ret = dev_set_name(&egm_chardev->device, "egm%lld", egm_dev->egmpxm);
> +	if (ret)
> +		goto error_exit;
> +
> +	ret = cdev_device_add(&egm_chardev->cdev, &egm_chardev->device);
> +	if (ret)
> +		goto error_exit;
> +
> +	return egm_chardev;
> +
> +error_exit:
> +	put_device(&egm_chardev->device);
> +create_err:
> +	return NULL;
> +}
> +
> +static void del_egm_chardev(struct chardev *egm_chardev)
> +{
> +	cdev_device_del(&egm_chardev->cdev, &egm_chardev->device);
> +	put_device(&egm_chardev->device);
> +}
>  
>  static int egm_driver_probe(struct auxiliary_device *aux_dev,
>  			    const struct auxiliary_device_id *id)
>  {
> +	struct nvgrace_egm_dev *egm_dev =
> +		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +	struct chardev *egm_chardev;
> +
> +	egm_chardev = setup_egm_chardev(egm_dev);
> +	if (!egm_chardev)
> +		return -EINVAL;

Use IS_ERR() and don't clobber the return value.

> +
> +	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev, GFP_KERNEL);

Return value unchecked.  Isn't this xarray just replacing stuffing this
in drvdata?  Why?

> +
>  	return 0;
>  }
>  
>  static void egm_driver_remove(struct auxiliary_device *aux_dev)
>  {
> +	struct nvgrace_egm_dev *egm_dev =
> +		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
> +	struct chardev *egm_chardev = xa_erase(&egm_chardevs, egm_dev->egmpxm);
> +
> +	if (!egm_chardev)
> +		return;
> +
> +	del_egm_chardev(egm_chardev);

No evidence yet of lifecycle management if there's an outstanding
opened chardev.  Thanks,

Alex

>  }
>  
>  static const struct auxiliary_device_id egm_id_table[] = {


