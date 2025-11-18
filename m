Return-Path: <kvm+bounces-63437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 334B2C66B1D
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A16A5353939
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF54521FF26;
	Tue, 18 Nov 2025 00:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Kya3iORN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="upxy7Wwn"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026258635D;
	Tue, 18 Nov 2025 00:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763426735; cv=none; b=Qqgw1Oikwa9MTi+ZLTR/9KXO1IkQB8h3KLwuSswS50PORG26B59zKl58kwy+yDPcBKSvS9jNk2KTeEIi/biEah6FzTtMi0tJmK0HDHyjZsGP2y6Lb15qlsg8t/7mCRvzhJNU0ckfYyjVvxpYAlZqn9glWLqmzJ1YqXsyLYvymLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763426735; c=relaxed/simple;
	bh=hj2K5dNEiMA1k/xijFaleEe5OR0Qzv+DeEoqjE6hU1s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=saPGE9zNBfTlh9TqtYqn8Oo6OBWhsJiW4HbZ+xd5E0gtwfPWhFErBXWiRJhKlsL2jVvK2waasypZXUSy6iDNh2/h/Sj3m4yPf7WGBHwUHmdtoJdvKXACgeFyjsawLjtd+xm6RIOV39tao3+KNKM8RiMF/fQsxp2ok34OQPbfBnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Kya3iORN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=upxy7Wwn; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 59C167A01E7;
	Mon, 17 Nov 2025 19:45:30 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Mon, 17 Nov 2025 19:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763426730;
	 x=1763513130; bh=JOKc4KHecIX33DHMlO1jCO/Rqz8RC6b7gUu8q/FL67U=; b=
	Kya3iORNp6Vwd3NTk7O8s5dQIEvDwcepjwFXDc7EgV+JqQ7Hs76Bzx8Sp+eYKMca
	uDnXBRaEh+ANWwm2/RgZ8ziN5YnOhk08I7e9XL+O+G89ztGUyrhqcmku6OiEniXI
	k3WlKzaks8I/JFm4naeK0BDc2YwgR+Kxfgzi6aIZfh/JW1jL68TumYNJyvy4m+Ez
	K6Wm/NJcCbv6QuqD3a5aqoMXNNFxAPx9ZDMiDCMfby+U3EplR2F1sywo+5cSpKh0
	A4tV2H6N2KDl2CtQAFrEEoFGTY3b+5a6RSQ0EvfYlZmG15U6Qw8NN2rYMoIwy47M
	wFIMJ84IgegZCArRlDnezw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763426730; x=
	1763513130; bh=JOKc4KHecIX33DHMlO1jCO/Rqz8RC6b7gUu8q/FL67U=; b=u
	pxy7WwnljudWwQ/QviO45QkYft1IDGmoCk1cBHigQZg0Q9Dkz0WXU4AtWIxAUL3K
	zqDZxrLZGNfm3vEMyF8s7cFY7vi73zToUklOWmo48sCt/fDhCfrC6yK5V3lPeLir
	HlLK5Ag8Phok7CL0fpHi/wOsuJWF+yuMmhnJuh0vEmNkN06dIP+lZ8/wEPG2IRQ6
	2AARFoD23KIExwUyzSU17dASbCmkGRGy8x9NZgiCetZpOL94odjJOpwnkGb7Ed/P
	L0vMEkZ06hGDGl7CuJoWoX4qyHvtPqGC1ijoTgn81rCG7rh/swVhhA0NA19Bv1XV
	PNFvMF804SV4MUtlTKkFg==
X-ME-Sender: <xms:qcEbaUcCF-uG_tUwSf_kwZDNHyEJgMYI_yWYj8vCurw8kFtULDs9hQ>
    <xme:qcEbaRPTJ-Ilne8b60LYTjx5ja6sYsXg-xJQfATnPB5D5By988aLHlwEW4B-itzWr
    UjwBBuS_oXzk9Uasn1B6uq5dj1TWv_cl5oZ0HDYKTsnB7mRiaAwuQ>
X-ME-Received: <xmr:qcEbacJD5PBRwU2OV4CUobmNwVorRYqbONuzPP1kH4B-LZ3Evr_GlKH6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvudelleegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:qcEbaXk3MliZRIDvvRtSTZ9oZUoajAtJQ2tJiCyCqjmmPJK3FSj4AA>
    <xmx:qcEbabZ6tQwmwwNxK1E5k6z2lKBX2wzsidwXpu19BmlxgnQ4yCeE5g>
    <xmx:qcEbaWjy7sHduwBKOguAOZWx_h0IXOv8XbXy9ueBE7yxWWXs2PGdJQ>
    <xmx:qcEbaZzysBCezy_Atw_0xVGg7RZG5zFsktZVibXGTsRwgk2sg1jLUQ>
    <xmx:qsEbae4VwMz9cmmSJe5xDdXmuUVF6cTuzkHL02hrZvO_TpJm9hrcXxh3>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Nov 2025 19:45:27 -0500 (EST)
Date: Mon, 17 Nov 2025 17:45:25 -0700
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
Subject: Re: [PATCH v1 6/6] vfio/nvgrace-gpu: vfio/nvgrace-gpu: wait for the
 GPU mem to be ready
Message-ID: <20251117174525.3690c712.alex@shazbot.org>
In-Reply-To: <20251117124159.3560-7-ankita@nvidia.com>
References: <20251117124159.3560-1-ankita@nvidia.com>
	<20251117124159.3560-7-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Nov 2025 12:41:59 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Speculative prefetches from CPU to GPU memory until the GPU
> is not ready after reset can cause harmless corrected RAS events
> to be logged. It is thus expected that the mapping not be
> re-established until the GPU is ready post reset.
> 
> Wait for the GPU to be ready on the first fault before establishing
> CPU mapping to the GPU memory. The GPU readiness can be checked
> through BAR0 registers as is already being done at the device probe.
> 
> The state is checked on the first fault/huge_fault request using
> a flag. Unset the flag on every reset request.
> 
> So intercept the following calls to the GPU reset, unset
> gpu_mem_mapped. Then use it to determine whether to wait before
> mapping.
> 1. VFIO_DEVICE_RESET ioctl call
> 2. FLR through config space.

If we need a stall after reset based on some device specific readiness
criteria, shouldn't we just implement a device specific reset?  We can
create a reset callback that uses pcie_reset_flr() then pci_iomap()s
the BAR to poll the device.  See for example delay_250ms_after_flr()
and nvme_disable_and_flr().  Thanks,

Alex

