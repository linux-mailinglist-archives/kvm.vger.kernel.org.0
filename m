Return-Path: <kvm+bounces-64256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D54C7BB8A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B55A64EB123
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA9C303A13;
	Fri, 21 Nov 2025 21:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="PfcwoStc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XLiilcUG"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A13A2836B5;
	Fri, 21 Nov 2025 21:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763759332; cv=none; b=HrU+BaspYJswkhj5rzbLc0GUT3jCPXMLUoNSPkHPMdrWAnDyZyPIhAjpb0CrLm0F2kkdWKEJHL0oQ1t8LoTxVrvX8itPWgQ/AilsPjH0bZsxUy5WomE1iq/4cAT9DslkhEogUJhjUTc3if4n3h1HhinfYRLd+HpAIQ7zzDF7mao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763759332; c=relaxed/simple;
	bh=pYwUSs2O3ia3hyXGLPsRjLDxIz4SYFJC1lUtpqW8skY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=boajEIZCmHy7frXKRQ+PY5LfKUIcDMVs7gmEb37LiNH1+IgwtP/7iDJRUKJrVrTy6MTXZ5GbQHN3HwMtrGfTnsEMgvTaCeI4vWjhP9r8EBiqzbbAcSy0D0ikcblOI1tYcUC8oIRt8dt97MSxI/HsWDmYh1JEj1ue+Gs7GuTWAIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=PfcwoStc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XLiilcUG; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AE1F114001F3;
	Fri, 21 Nov 2025 16:08:46 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 21 Nov 2025 16:08:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763759326;
	 x=1763845726; bh=dY2pTydoRTRSH0PAf81N5GRIej0nbVKAPTLhqJ2Vb2Y=; b=
	PfcwoStcU07txRiwY+7SQU5mJIXW5j6+ChDcgN8y+mv2DlEnVPzi1WiWaZnFC59v
	LKORw6UraQ223MUDDOurSF2pJTkM+E2zX4tQtVK48E9GakaS4W/Wica3AECbxat6
	g6BcRZiYBq1KDe4MvyHyzpL3E2V0fSp8H99X+oY5t8izJDxemgNDVvJQIDwa7JDz
	G6x7FvHLj5XDYhNOuOI2fl+YPZJJ7HODWzbScsM20ZNG/4QxAktYFaweutyX4ZUr
	/9tSgKM1r1kOwKYiCALk1vrRqHo/xqTQW0ADyl/YNE2cXg73OoYc43NQMhz2nYcB
	NMuVobTTHeWu2CQZ2deKWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763759326; x=
	1763845726; bh=dY2pTydoRTRSH0PAf81N5GRIej0nbVKAPTLhqJ2Vb2Y=; b=X
	LiilcUG/u9rqUkw+ju7XhOtIc6fvtCIweA41ugPTytbhvRNvYLFo9t8/aq0x98jI
	dCeT9RVXMEZw+iO3xaoznP6MZ0dZCt8OmfdGwtJ5P+l+G6+/B7qG8wqkkkavPfyg
	wtr07J/VQJb5HfHErA5izxE5u0fIm3vDxGZBErMKDVv0IlNb/dJ4kwIFB022+qyR
	zxOtA+cjbNQICAuyKKOeUsFjRcq2TQeRagRJiEzlWO/QjVCGQ+SLX16XzYc8mih4
	MV/why233DzbW5VIdzYyTR9QS3n45A5gj47k4UeeoqGz6hlrRl2pfJkq7FOr6JpD
	fbjkIKmtAjyufcgPHAkeQ==
X-ME-Sender: <xms:3tQgaaVrP71pPWEaOx9BKl5chTHyG7QDVJhks1T88NPQt0gBI_1mCA>
    <xme:3tQgaYSuL3TAzDUZTs009UtNyg3HXHGjIHrw8zyXHmQBSND2X6855I3uQ1ZzrTjRn
    OaxINyqV_nzjZvLpEtruErIvFVi9RY6ySoOT033c4dboI_H_z5r>
X-ME-Received: <xmr:3tQgaR2XxqXYRuDOm-s9BGYRrHcrVTnGQZEsE_WONIP-NWlRcIlPZC1X>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfedtleelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedviedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepugguuhhtihhlvgesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgseii
    ihgvphgvrdgtrgdprhgtphhtthhopeihihhshhgrihhhsehnvhhiughirgdrtghomhdprh
    gtphhtthhopehskhholhhothhhuhhmthhhohesnhhvihguihgrrdgtohhmpdhrtghpthht
    ohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheprghnihhkvg
    htrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepvhhsvghthhhisehnvhhiughirgdr
    tghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:3tQgaRJbfc9ZADWft-8LbVHn5bGtP5SK8KFzCAY5fPxQ-fwuYGDPAg>
    <xmx:3tQgaa9PNo1w8e_l82eA71gzQ0nOVy3VRA-hcdUYiyVYZeuV-C4N6A>
    <xmx:3tQgaamm7UM8a68Ofa9W-mObIlyrSiCOj2DG4x32ReqABlhZkWccOQ>
    <xmx:3tQgadXSj_gw21G6-htctaj4v0GYIUSUoPS1yISh0CRxrG8zixxRDg>
    <xmx:3tQgaTJfJJ7TQU0P31Vby6g9bWj3buhgIfpmM-X4pkQgrEsGJs4FWaHF>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Nov 2025 16:08:44 -0500 (EST)
Date: Fri, 21 Nov 2025 14:08:42 -0700
From: Alex Williamson <alex@shazbot.org>
To: Donald Dutile <ddutile@redhat.com>
Cc: ankita@nvidia.com, jgg@ziepe.ca, yishaih@nvidia.com,
 skolothumtho@nvidia.com, kevin.tian@intel.com, aniketa@nvidia.com,
 vsethi@nvidia.com, mochs@nvidia.com, Yunxiang.Li@amd.com,
 yi.l.liu@intel.com, zhangdongdong@eswincomputing.com, avihaih@nvidia.com,
 bhelgaas@google.com, peterx@redhat.com, pstanner@redhat.com,
 apopple@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 zhiw@nvidia.com, danw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com
Subject: Re: [PATCH v3 5/7] vfio: move barmap to a separate function and
 export
Message-ID: <20251121140842.30884fc2.alex@shazbot.org>
In-Reply-To: <9b25494c-0271-4469-a7f4-71876eadd4e3@redhat.com>
References: <20251121141141.3175-1-ankita@nvidia.com>
	<20251121141141.3175-6-ankita@nvidia.com>
	<20251121093949.54f647a6.alex@shazbot.org>
	<9b25494c-0271-4469-a7f4-71876eadd4e3@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Nov 2025 15:58:19 -0500
Donald Dutile <ddutile@redhat.com> wrote:

> On 11/21/25 11:39 AM, Alex Williamson wrote:
> > On Fri, 21 Nov 2025 14:11:39 +0000
> > <ankita@nvidia.com> wrote:  
> >> +
> >>   int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
> >>   {
> >>   	struct vfio_pci_core_device *vdev =
> >> @@ -1761,18 +1784,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
> >>   	 * Even though we don't make use of the barmap for the mmap,
> >>   	 * we need to request the region and the barmap tracks that.
> >>   	 */
> >> -	if (!vdev->barmap[index]) {
> >> -		ret = pci_request_selected_regions(pdev,
> >> -						   1 << index, "vfio-pci");
> >> -		if (ret)
> >> -			return ret;
> >> -
> >> -		vdev->barmap[index] = pci_iomap(pdev, index, 0);
> >> -		if (!vdev->barmap[index]) {
> >> -			pci_release_selected_regions(pdev, 1 << index);
> >> -			return -ENOMEM;
> >> -		}
> >> -	}
> >> +	ret = vfio_pci_core_barmap(vdev, index);
> >> +	if (ret)
> >> +		return ret;
> >>     
> so, vfio_pci_core_mmap() should be calling vfio_pci_core_setup_barmap() vs. what it does above currently?

Yeah, it probably should have happened in 8bccc5b80678 ("vfio/pci:
Expose vfio_pci_core_setup_barmap()") when the static function in
vfio_pci_rdwr.c was exported.  Better late than never.  Thanks,

Alex

