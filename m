Return-Path: <kvm+bounces-68343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 186FAD33BC0
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:13:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B90DA30C7C72
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D679F340A67;
	Fri, 16 Jan 2026 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="GFCcjZPG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oJUtK6/c"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E20F225760;
	Fri, 16 Jan 2026 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768583248; cv=none; b=WpxhOr61ylMgkKqgk3K5ITyEyp6qgc67zwVIuwxbVVD9opWHcfN/MkFVKn3QC+l9knfR408gMTOcudG7hnsEWeR5ARS2qEu+nsNMnmM2b3vlj+dQ2tPk7vsydA8loZFvfWwJzzXE8yNNI6tF/G4QIcVou7xqtdRjiJ2Rz50EK+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768583248; c=relaxed/simple;
	bh=7zvL/ewtx4ZhPc+58i7vApUSr0EHDK7NMcwOu+Lm63o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frzxISveophdphd06LjqtV1PsmptJpSdhq7OJrf6ExvIkPpj74yI66fJFncWweUA1NLCVPDYYiu+G1nPiR5/2m8o6soKgJsOX7lDyGnx+gHNE18Q1q1WACAs6kmTOP9Mgl3s+cBNfURUeFnUGMREIgQzWhsiufbRk7P6faHFsAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=GFCcjZPG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oJUtK6/c; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BFB471400083;
	Fri, 16 Jan 2026 12:07:25 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Fri, 16 Jan 2026 12:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768583245;
	 x=1768669645; bh=fZfhcxUuRhh+8zxgSurwHPh1rKBn1eKgmHwxFyByx44=; b=
	GFCcjZPGtgYvpfahB+xCAhgqw7nO4+dGJ8LaEeDAqTyO06OvXnc7ORpwQn5zLDKr
	cEue67EP1YaBwx4YtJXO+/bN+VVQ8IOojEhpepOLYBzxF786w6w2wlTn0v4EpcR/
	YtISVhhXqXLn/Es7RVkgq6Qc3fzEJq0RtVqXltIbuaacstB8ykYcNBS1VJMqAl2h
	mSpIebbRtSnI9K1JHaXLrUWmYhQHSjzPfnUou2acwjCpPgt11k9WKE2enAz9CECl
	WPWZpCvOJBw8ntNxoLDOd4OEtjmX3d3jazymrVtWtGZfVntkSbpfTd0F2TQfKYDv
	nMXmKzit0uxTSm8RsHbE2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768583245; x=
	1768669645; bh=fZfhcxUuRhh+8zxgSurwHPh1rKBn1eKgmHwxFyByx44=; b=o
	JUtK6/cy6LX8KG0eYdJ7Nj0HK7LhRmMvZGr4AidIraAy3NafFKnTtgGYH1jqqrha
	g8H7sexRa6OX2oHGh/CeegnSCnTtcWuuIK8F7xl0rUP04GYiMPfzEpIdGA1WfSzf
	iJT3ZVZrPElfThHGalo00jGVfQhsh2GBR2X7wARMmWVXn0B92k5eMhzRffgRMroL
	r5mYm3mOR/07LyI1AyWwvQwxwjIxyR3SEoXXTp0r51qfQnOj4e/jL8CUGPOVmKS0
	WiEi0izMluX8JIPEBgPzqQl3sHqdhLH2OfeCf1qz1UJ7ezj9nkiXPLna9pibAqCr
	/5/BCKVLKh7OC+W0BkTXg==
X-ME-Sender: <xms:TXBqaT3wD7funZF4DK5edR7ovQKX6nBAvmAciHdl1Xc0qhUp_vhcww>
    <xme:TXBqabaHyYWXQoiZYiJpWzqa-DjkC_VjLtUogiBmsAW4-mvW50aCedu0gIxp_RXPR
    aS1aFlfBoluzsdiRLHBQLhYfaeloS1hfXwu7D4J8XSYDHgedbuPnw>
X-ME-Received: <xmr:TXBqabIb-lwWT-frYCRtXWXXlo1Et0IdvTUnVuY_85_aVXPsL31EGdY64OE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdelhedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepiedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhhiuhhlohhnghhfrghngheshhhurgifvghirdgtoh
    hmpdhrtghpthhtoheprghlvgigrdifihhllhhirghmshhonhesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhonhgrth
    hhrghnrdgtrghmvghrohhnsehhuhgrfigvihdrtghomhdprhgtphhtthhopehkvhhmsehv
    ghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:TXBqaaHVp76kBNmsi_UnNVPa-J9WD8oxYJZ9l9iy7afEqinYx8_tFg>
    <xmx:TXBqaSsS2ZO4xP94ChtaARLMKNUo_Y7Rk7qtlFlG7EpR_fobJ0JeIA>
    <xmx:TXBqaZtiMQKi9zwABFjF8NYgbBKpA8aPCIVA1CfonKecXpBaYzsvTA>
    <xmx:TXBqaQAaxonVlzvYJzFuAj-AXUfB-c8TRIjT0D2aBzPzRYOFNvm_Qg>
    <xmx:TXBqaVsHlqsOrgLokVS93syW0S_Uo-Pjxd_pk8kWrI6nD_o3T2S82b2U>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jan 2026 12:07:24 -0500 (EST)
Date: Fri, 16 Jan 2026 10:07:22 -0700
From: Alex Williamson <alex@shazbot.org>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] hisi_acc_vfio_pci: fix the queue parameter anomaly
 issue
Message-ID: <20260116100722.5bdb30d4@shazbot.org>
In-Reply-To: <20260104070706.4107994-5-liulongfang@huawei.com>
References: <20260104070706.4107994-1-liulongfang@huawei.com>
	<20260104070706.4107994-5-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 4 Jan 2026 15:07:06 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> When the number of QPs initialized by the device, as read via vft, is zero,
> it indicates either an abnormal device configuration or an abnormal read
> result.
> Returning 0 directly in this case would allow the live migration operation
> to complete successfully, leading to incorrect parameter configuration after
> migration and preventing the service from recovering normal functionality.
> Therefore, in such situations, an error should be returned to roll back the
> live migration operation.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 394f1952a7ed..e0cc20f5f38b 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -406,7 +406,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>  	struct device *dev = &vf_qm->pdev->dev;
>  	u32 que_iso_state;
> -	int ret;
> +	int qp_num, ret;
>  
>  	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
>  		return 0;
> @@ -423,18 +423,18 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>  	}
>  
>  	/* VF qp num check */
> -	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
> -	if (ret <= 0) {
> +	qp_num = qm_get_vft(vf_qm, &vf_qm->qp_base);
> +	if (qp_num <= 0) {
>  		dev_err(dev, "failed to get vft qp nums\n");
> -		return ret;
> +		return -EINVAL;
>  	}

Do you really want to clobber the errno or should this be something
like:

		return qp_num < 0 ? qp_num : -EINVAL;

And if you do that it might make sense to continue to use ret rather
than add the new variable.  Thanks,

Alex

>  
> -	if (ret != vf_data->qp_num) {
> +	if (qp_num != vf_data->qp_num) {
>  		dev_err(dev, "failed to match VF qp num\n");
>  		return -EINVAL;
>  	}
>  
> -	vf_qm->qp_num = ret;
> +	vf_qm->qp_num = qp_num;
>  
>  	/* VF isolation state check */
>  	ret = qm_read_regs(pf_qm, QM_QUE_ISO_CFG_V, &que_iso_state, 1);


