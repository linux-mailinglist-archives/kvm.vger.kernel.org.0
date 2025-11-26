Return-Path: <kvm+bounces-64755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADA0C8C24B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BC4B6348A25
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BA7342C8E;
	Wed, 26 Nov 2025 22:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ftypGC1y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iUcuvuM8"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C325733AD99;
	Wed, 26 Nov 2025 22:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764194612; cv=none; b=b21Nmb2gGlzijq0o+DDZ4+vHlSNY+4xzJeCNoBs7cXWuUh1KBAzKT9xSvCkmN9mDolTtZwXXyTd1ICerIGvk5mwK+/V3+cV5fOCKuAQT4AxJYCzGcFp4uFRb34ba/IyicgqkmDBV6wO36Im3gmtKf6SU/FVBkv7nsk7IvVYhMB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764194612; c=relaxed/simple;
	bh=B9cqU2qrqCKRm3yhgMeiRZaae5rPZsp4GBiJNhszAc4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isdnKM3tTpzmTgcUIiLc55sTAFB4cd9dTvyGlw4vxdYZu89p1PHKYgx776KfwKDLKQRhyK5fLsWLViJaZx6NDvQdZcZXd+E8BF3KxmCzxqNxc4Eza8COK3P1mjwTAZdjyyQAwS+uHj6RQ3TNhnEsORAPWQQKTwp9gRhKVCKWOds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ftypGC1y; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iUcuvuM8; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A6FD3140022F;
	Wed, 26 Nov 2025 17:03:27 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 26 Nov 2025 17:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764194607;
	 x=1764281007; bh=nbyKsqC2cGQ5C1k7wxKKBZug4oe+uhZbjNaMmpcIYEg=; b=
	ftypGC1yQiQxUDk22Rkl42Rt+tWr3Ax1ZjXBMT3xST9PnyB8gmll3ywx+ksY0XGr
	KWq3H4QKZhL3NgMnj1D8Ew8kUAhcZzn4M7O8KdTH2a1vw0UCp5EDxBSE/ueOlXbD
	jzICopNGsTOJiDeWeeByOPbWcHkjCt3aAOT8Xa826vkQ+AKcVGsP0gOO2YZa3irN
	IDmoenrCIl64EwESR2Amj7TLpSUedqxK0PcoOlExfnuRalK9Cql/kgpZaQvKvjqv
	XsVejiEGKpk4Fxj2Af2KOF9g4QCTrBQgCyjgFbZHv/1Qg6i3CLVCP7ldp1QfpmCV
	y97j5a1zJPw6uJPRIBq6ZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764194607; x=
	1764281007; bh=nbyKsqC2cGQ5C1k7wxKKBZug4oe+uhZbjNaMmpcIYEg=; b=i
	UcuvuM86c/1OB4LMKk5NHhsqzhdMAHLzE4D3TaStdTzP9OD6KyZv0bqbWR9JXPI3
	Sec82FbFWMjEBHUi2VrQrgdz1KKDZ9ZeXxaNr2L1lBrBEDuLPObQ21GRVRN5R5xW
	sPrMr9s13B9YYI8JDbmaaYnRpxQjl1k/IJfuKsaDQ8wrxH9kjFA6K7tv81GTlRBK
	V5s8ZkukyT7mGK1d9smsiFeYN5AMVfD5IwzgmahBiY6ke4vnVbhIj0kVSIScYKTe
	y2MbWCdaVLVsQiOmi5O+ZlTJShU2pdCe8y/196R9iId534KeUcHzYNwS97b3+/mv
	Eo3KyWrXb+8ntCzZMP3wA==
X-ME-Sender: <xms:LnknaQ1eisdbSyZLvXhPXRyYL_imr0UuXXFe1j8W-YwaCpK2ZERHeg>
    <xme:LnknaWHKQbIL9KyuqO8cctj_P_-b0-_yqzNmZJyKiaMejvN5P4p9f1GXJJlSHiX0X
    7wFJ90Tp28lZBjU33PFvAdOr0fNGI4IUtHl2cTjQvLnVTjaKIUE8gs>
X-ME-Received: <xmr:LnknafijCoBOEK93b-sf9GoBTDvY818k4g_GIXiLhcb3ddvFLI40x4XS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeehhedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepvdehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhkihht
    rgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtg
    hpthhtohephihishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehkvghvihhnrdhtih
    grnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrnhhikhgvthgrsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohephihunhigihgrnhhgrdhl
    ihesrghmugdrtghomh
X-ME-Proxy: <xmx:L3knaXeywUvrsKi8Ngcu5Mvi3jGEoBVMG0xnBGWt4LNfyW_9e2UfgA>
    <xmx:L3knadwMdU-KCZIp_cPxIiFdaDwgSMsiljMFPJrFrLYJQhtWWiACGQ>
    <xmx:L3knaZZQ1vlfSNnKT-BW7ge4A2oKitrKyqXMvs4vPnHvsA7odFRQ3w>
    <xmx:L3knaTJgOXPaWUcsqK7FpKd-GKMP_fDRv9L7S5lRsULOlqzs95_cKg>
    <xmx:L3knaZwXElMsfCH-VTuGytdvBaF4pehWd6uPR-Kf7aWfEFMW12cjneXJ>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 17:03:25 -0500 (EST)
Date: Wed, 26 Nov 2025 15:03:23 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
 <kevin.tian@intel.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
 <mochs@nvidia.com>, <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
 <zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
 <bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
 <apopple@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <danw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: Re: [PATCH v8 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Message-ID: <20251126150323.3b39e1f2.alex@shazbot.org>
In-Reply-To: <20251126192846.43253-7-ankita@nvidia.com>
References: <20251126192846.43253-1-ankita@nvidia.com>
	<20251126192846.43253-7-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Nov 2025 19:28:46 +0000
<ankita@nvidia.com> wrote:
> +/*
> + * If the GPU memory is accessed by the CPU while the GPU is not ready
> + * after reset, it can cause harmless corrected RAS events to be logged.
> + * Make sure the GPU is ready before establishing the mappings.
> + */
> +static int
> +nvgrace_gpu_check_device_ready(struct nvgrace_gpu_pci_core_device *nvdev)
> +{
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +	int ret;
> +
> +	lockdep_assert_held_read(&vdev->memory_lock);
> +
> +	if (!nvdev->reset_done)
> +		return 0;
> +
> +	ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
> +	if (ret)
> +		return ret;
> +
> +	nvdev->reset_done = false;
> +
> +	return 0;
> +}

It seems like we can call wait_device_ready here, generating ioread
accesses to BAR0, without knowing the memory-enable state of the device
in the command register.  Is there anything special about this device
relative to BAR0 accesses regardless of the memory-enable bit that
allows us to ignore that?

If not, do we need to test before wait_device_ready, such as:

	if (vdev->pm_runtime_engaged ||	!__vfio_pci_memory_enabled(vdev))
		return -EIO;

This opens up a small can of worms though that vfio-pci allows
read/write access regardless of pm_runtime_engaged by waking the device
around such accesses.  This driver doesn't currently participate in
runtime PM beyond the vfio-pci-core code.  Do we need to add runtime PM
wrappers in its read/write handlers and a separate wrapper here that
drops the pm_runtime_engaged test?

There's a comment in the driver indicating the device is tolerate of
certain accesses, independent of the memory-enable bit, so I don't know
how much is actually required here.  Thanks,

Alex

