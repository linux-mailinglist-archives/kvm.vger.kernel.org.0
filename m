Return-Path: <kvm+bounces-72707-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGUXLVxpqGl3uQAAu9opvQ
	(envelope-from <kvm+bounces-72707-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:18:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AC9B2050BC
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:18:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A45B4305C6CF
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD682BA3D;
	Wed,  4 Mar 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="pg9cIHsZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hCej84yE"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7DD376BD7;
	Wed,  4 Mar 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772644456; cv=none; b=fcl85p8FcLGpALvjYC4K/YJghApA3TFmpkj1O5DoTZ9LQnh1OgagTsTfDGkCGF+lPH8B/GQul0635BBM1Tb9OLi6N6evgpuVP5XdrftdAK75U6RcdHf+Q9kdPMve0LXYYdNs9mvSKIW5USpwXHj8CQl8YZGUU200rQpOvFZyvEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772644456; c=relaxed/simple;
	bh=iYPeUlLS/TQzASnaAJyUVeGoWHPq/wu3J9R1wi1XGwM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1wUg8f0VrmwrOub5IgdkFRDK5VYZd6P5uVCuLr75sGMz6dinGlI7wgOdOwGtQT7CtKHrknnKxUr5eI0iS7Ir5qcfD6py7ZKBSAwxLb9iozuRhd69NQhCPF/2wIoa+z2oPT7EvkJi7uO8zpF36UTjeKeDgcC2e80lk3X84dKb9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=pg9cIHsZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hCej84yE; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 1E39CEC0AC0;
	Wed,  4 Mar 2026 12:14:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Wed, 04 Mar 2026 12:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772644451;
	 x=1772730851; bh=0nmBTKsFYigcGr1deb6GB6EkiPrY+XhvU/IoNkQbcoo=; b=
	pg9cIHsZjcjr15uWEwWMaZOu4juOEqOuLkx10ZDcOYeXo/lm7uC5WZkNPMbn3Osq
	VPsObUNBMpTonsuD2k/uR3uU42g9vL4JmsyEBhdIcGQPa5fbEvqD9tvrEWEtpyGi
	ejhwqkU9U7p39sXiSQzSG3KMTY4246Q2luWaUDmnncDnEpOYM7lTBhGtGOG/hT5m
	Dsi2nQVNVi4oCsiG+5YpqWVArF/76GHVyDYT4ml+eqDKzS15TPimQqbqJwehrbV/
	j0UEv8/JREoR/ES3C9zkAdY2gCctywgchkAaWxEahAYUYwE45ZojLLG+cK8cWh6n
	+nDHHDwmiewnAgwDG6GyRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772644451; x=
	1772730851; bh=0nmBTKsFYigcGr1deb6GB6EkiPrY+XhvU/IoNkQbcoo=; b=h
	Cej84yEcT1xSwm0Guyceo2pmM9mQbN3dFmtI67UNbeYmGjuQoS7uTgWpWu75fjhw
	NFXMwgFjlewo9rF4XJEcC4nzCpA2vD7FmnmqFttMUUrJUvQH6K385soqCT1eqjmM
	Q7cI08j1fvd6hJMcpzlBtduBenPYBYACYUIJrF5lPQ1TJSgTk40KPv+Z0fxc33xr
	ubvHWlShEG3NRsWCaUbDFSH9udsQadTt+KFNaTTawXD+ezRVVPLJ8UjMpRzUQd6C
	rFfLKC/cF4drcBj/6pTLnjknGIy8uiWwY7D4DcAkIP9qLwPMYunal5MGocVJYPOy
	n8kLNr+oNIask7O9ENj2Q==
X-ME-Sender: <xms:YmioaczxnhZYhBbQhDuBSOo3fmQXkH-Atug6WJzBUjYd41CaAr2_aw>
    <xme:YmioaVeDem8hDkQLUC_Ijm0x_k6p80a-nJ27FF9EDFiGpEh0akt3fRJxO_HTuVLvT
    HZhkfETeGona13Zmzdhk_8Wek8ywDvpUxaesCQbdRpO37iwIr8O5A>
X-ME-Received: <xmr:YmioaRueyC4N7GQNWma7piAwDw5BkDhynm5_KLhDeshlzGmhPBco_GK_UUM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegtdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudegpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehskhholhhothhhuhhmthhhohesnhhvihguihgrrd
    gtohhmpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtphhtthho
    pehvshgvthhhihesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesnhhvihguih
    grrdgtohhmpdhrtghpthhtohepmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthht
    ohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtoheptghjihgrsehnvhhiughirgdrtg
    homhdprhgtphhtthhopeiihhhifiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepkhhj
    rghjuhesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:YmioaaDSefJk9vC1ir6hTpfkdxN8B9rrHdDG01n-iNRRNugrat876Q>
    <xmx:YmioaZEBFn_7Yto4gIdyDzMKJwP9llb_F9Wo7aERlkg57mqjiuj2tg>
    <xmx:YmioaatwU1IrtUY32QtrjaT1rYfrjLH7FpFvO7JBE2IX6oke27njuw>
    <xmx:YmioafkrIG_9DShgRMZWvi3KjRtywAt2jFoQfgW6CNFRxyxYHD7hzA>
    <xmx:Y2ioaeMCZKgonXa4IRNCRXKuhWZVpyoiIvlH3vIiae8RJWUSBI-UHZje>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 12:14:09 -0500 (EST)
Date: Wed, 4 Mar 2026 10:14:09 -0700
From: Alex Williamson <alex@shazbot.org>
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, Neo Jia <cjia@nvidia.com>, Zhi Wang
 <zhiw@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, Yishai Hadas
 <yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 03/15] vfio/nvgrace-gpu: track GPUs associated
 with the EGM regions
Message-ID: <20260304101409.3c069046@shazbot.org>
In-Reply-To: <CH3PR12MB75483F6074324471868CC05EAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-4-ankita@nvidia.com>
	<CH3PR12MB75483F6074324471868CC05EAB72A@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8AC9B2050BC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	TAGGED_FROM(0.00)[bounces-72707-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ziepe.ca:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,shazbot.org:dkim,shazbot.org:email,shazbot.org:mid]
X-Rspamd-Action: no action

On Thu, 26 Feb 2026 14:55:37 +0000
Shameer Kolothum Thodi <skolothumtho@nvidia.com> wrote:

> > -----Original Message-----
> > From: Ankit Agrawal <ankita@nvidia.com>
> > Sent: 23 February 2026 15:55
> > To: Ankit Agrawal <ankita@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>;
> > Jason Gunthorpe <jgg@nvidia.com>; Matt Ochs <mochs@nvidia.com>;
> > jgg@ziepe.ca; Shameer Kolothum Thodi <skolothumtho@nvidia.com>;
> > alex@shazbot.org
> > Cc: Neo Jia <cjia@nvidia.com>; Zhi Wang <zhiw@nvidia.com>; Krishnakant
> > Jaju <kjaju@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>;
> > kevin.tian@intel.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH RFC v2 03/15] vfio/nvgrace-gpu: track GPUs associated with
> > the EGM regions
> > 
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > Grace Blackwell systems could have multiple GPUs on a socket and
> > thus are associated with the corresponding EGM region for that
> > socket. Track the GPUs as a list.
> > 
> > On the device probe, the device pci_dev struct is added to a
> > linked list of the appropriate EGM region.
> > 
> > Similarly on device remove, the pci_dev struct for the GPU
> > is removed from the EGM region.
> > 
> > Since the GPUs on a socket have the same EGM region, they have
> > the have the same set of EGM region information. Skip the EGM
> > region information fetch if already done through a differnt
> > GPU on the same socket.
> > 
> > Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> > ---
> >  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 29 ++++++++++++++++++++
> >  drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++
> >  drivers/vfio/pci/nvgrace-gpu/main.c    | 37 +++++++++++++++++++++++---
> >  include/linux/nvgrace-egm.h            |  6 +++++
> >  4 files changed, 72 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> > b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> > index faf658723f7a..0bf95688a486 100644
> > --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> > +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> > @@ -17,6 +17,33 @@ int nvgrace_gpu_has_egm_property(struct pci_dev
> > *pdev, u64 *pegmpxm)
> >  					pegmpxm);
> >  }
> > 
> > +int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
> > +{
> > +	struct gpu_node *node;
> > +
> > +	node = kzalloc(sizeof(*node), GFP_KERNEL);
> > +	if (!node)
> > +		return -ENOMEM;
> > +
> > +	node->pdev = pdev;
> > +
> > +	list_add_tail(&node->list, &egm_dev->gpus);
> > +
> > +	return 0;
> > +}
> > +
> > +void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
> > +{
> > +	struct gpu_node *node, *tmp;
> > +
> > +	list_for_each_entry_safe(node, tmp, &egm_dev->gpus, list) {  
> 
> Looks like this gpu list also will require a lock.

+1

> Can we get rid of this gpu list by having a refcount_t in struct nvgrace_egm_dev?

+1

In this implementation, a reference count seems sufficient and the
egm_dev list could be moved to egm_dev.c, where a get_or_create
function could handle the de-dupe and refcount and a put function could
deference and free.

We'd only need reference to the GPU pci_dev if we needed to invalidate
mappings across a GPU reset, or perhaps if we were exposing multiple
EGM devices per socket, one for each GPU route.

> > +		if (node->pdev == pdev) {
> > +			list_del(&node->list);
> > +			kfree(node);
> > +		}

Also why do we continue searching the list after a match is found?
Thanks,

Alex

> > +	}
> > +}
> > +
> >  static void nvgrace_gpu_release_aux_device(struct device *device)
> >  {
> >  	struct auxiliary_device *aux_dev = container_of(device, struct
> > auxiliary_device, dev);
> > @@ -37,6 +64,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev,
> > const char *name,
> >  		goto create_err;
> > 
> >  	egm_dev->egmpxm = egmpxm;
> > +	INIT_LIST_HEAD(&egm_dev->gpus);
> > +
> >  	egm_dev->aux_dev.id = egmpxm;
> >  	egm_dev->aux_dev.name = name;
> >  	egm_dev->aux_dev.dev.release = nvgrace_gpu_release_aux_device;
> > diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> > b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> > index c00f5288f4e7..1635753c9e50 100644
> > --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> > +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> > @@ -10,6 +10,10 @@
> > 
> >  int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
> > 
> > +int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
> > +
> > +void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
> > +
> >  struct nvgrace_egm_dev *
> >  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> >  			      u64 egmphys);
> > diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-
> > gpu/main.c
> > index 23028e6e7192..3dd0c57e5789 100644
> > --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> > +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> > @@ -77,9 +77,10 @@ static struct list_head egm_dev_list;
> > 
> >  static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
> >  {
> > -	struct nvgrace_egm_dev_entry *egm_entry;
> > +	struct nvgrace_egm_dev_entry *egm_entry = NULL;
> >  	u64 egmpxm;
> >  	int ret = 0;
> > +	bool is_new_region = false;
> > 
> >  	/*
> >  	 * EGM is an optional feature enabled in SBIOS. If disabled, there
> > @@ -90,6 +91,19 @@ static int nvgrace_gpu_create_egm_aux_device(struct
> > pci_dev *pdev)
> >  	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
> >  		goto exit;
> > 
> > +	list_for_each_entry(egm_entry, &egm_dev_list, list) {
> > +		/*
> > +		 * A system could have multiple GPUs associated with an
> > +		 * EGM region and will have the same set of EGM region
> > +		 * information. Skip the EGM region information fetch if
> > +		 * already done through a differnt GPU on the same socket.
> > +		 */
> > +		if (egm_entry->egm_dev->egmpxm == egmpxm)
> > +			goto add_gpu;
> > +	}
> > +
> > +	is_new_region = true;
> > +
> >  	egm_entry = kzalloc(sizeof(*egm_entry), GFP_KERNEL);
> >  	if (!egm_entry)
> >  		return -ENOMEM;
> > @@ -98,13 +112,24 @@ static int
> > nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
> >  		nvgrace_gpu_create_aux_device(pdev,
> > NVGRACE_EGM_DEV_NAME,
> >  					      egmpxm);
> >  	if (!egm_entry->egm_dev) {
> > -		kvfree(egm_entry);
> >  		ret = -EINVAL;
> > -		goto exit;
> > +		goto free_egm_entry;
> >  	}
> > 
> > -	list_add_tail(&egm_entry->list, &egm_dev_list);
> > +add_gpu:
> > +	ret = add_gpu(egm_entry->egm_dev, pdev);
> > +	if (ret)
> > +		goto free_dev;
> > 
> > +	if (is_new_region)
> > +		list_add_tail(&egm_entry->list, &egm_dev_list);  
> 
> So this is where you address the previous patch comment I suppose...
> If so, need to change the commit description there.
> 
> > +	return 0;
> > +
> > +free_dev:
> > +	if (is_new_region)
> > +		auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
> > +free_egm_entry:
> > +	kvfree(egm_entry);  
> 
> Suppose the add_gpu() above fails, then you will end up here with an existing 
> egm_entry which might be in use.
> 
> Thanks,
> Shameer
> 
> 


