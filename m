Return-Path: <kvm+bounces-64947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AFE0C930C5
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 20:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BD343AD58B
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 19:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E08335564;
	Fri, 28 Nov 2025 19:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="bdVv6Tvc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Sovxl52B"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033F6334694;
	Fri, 28 Nov 2025 19:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764359103; cv=none; b=LxUHpnM7AHkqn2/WI24m8EZZPNUcsB/guO1mSWGiHesF/YaKgH3sL7ayc3Dfb+rWSLXpS5ZNSW+pTowvU7GtfjCzKJWVBhNM/megDrRYYrJvGBrTLH4XA3m2vw7o5eFzz/mxTF0G6HDi0hmiTq7YRZqIfCseG6kVehkZDnKLCW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764359103; c=relaxed/simple;
	bh=+wkljG214Hz09hs256WV1z8aBU3cBewNwN5l3xYeLhY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yt8zKUljZ88Xek1PcHCvLOQciZJpfnyKUYWJ5OUEtdYRw8tcbs/itQQrQxXZQgYo9/QUDt0G8uZf1+8KOaKLQjxYmwSZ7JpH8u1gp9t1uaZT3tTxZkSMRvFhU6jIyJG8dFOI+GEy8lEoT7nmDE9JkmosZtbwg1b50ElZcnSw/k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=bdVv6Tvc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Sovxl52B; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 958747A07D9;
	Fri, 28 Nov 2025 14:44:59 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 28 Nov 2025 14:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764359099;
	 x=1764445499; bh=Gzbi9f31LeGeuZleDQErpK+oNVqUxLg4p18tyJY+ZXg=; b=
	bdVv6Tvcr/5gbvnGuzW5VTtVR3ID+5xOleZ9ONKpEOADnsecJCgiO8KROyFJiFZz
	vuhsFXuCrJwW1nSuku7L0PVXfhb+DH2bp2E2hH1ShAOO9JQtJbEo5E/96jU1qavZ
	rvXMYuQNZcltRTCiP2TD/vC7jA7BSGe/WrpVGwW4QSKOlJuFxcZJmg4ppZWhFG2+
	KOzjZVIPsPiKH8HQBQVeK9TZRAKIaOAd3owY563gAQRrZ4aUHRy0++c5NeE+7dsP
	HyAE2cMzk94rktui2nXZO8fFsk1JAhHMaJDSbw+WKm5VYA+3F+daF9PGQ/R0fYNk
	Flzn83+d0z5+iKVP8qGz8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764359099; x=
	1764445499; bh=Gzbi9f31LeGeuZleDQErpK+oNVqUxLg4p18tyJY+ZXg=; b=S
	ovxl52BqMKlkHx/Ynu4ane2yTRfYTL6cB93dKngadfqbf134evyg+L+VpA5RrCEB
	MMxASAalOEsXDCucPpWIWWmif7wjzfSJp5n3t813gD4hEtrqJEYap2BfzTLv7iG4
	hbOE6rRKEMocRisUmumpRoWMUioyf6lIyiZNcoSrz9IMcb4brZzJpPsNhOvI44iT
	08pYU+q2guz5qnXg59te3f9GK0FC75WNY30vvULqAinvrY5v/BxDJUOLcGhmKhpa
	vJHx9cJj1z6NCHoHfNxAAXZnKhaycifXuXFL4fpww8HxJgRMPs4RtclvHQGfHhw3
	Z3NdRSnOQvYG7mnYXXx7g==
X-ME-Sender: <xms:u_spaaiUp33cP5h-9vnXBTGmBmX1pxg6Avq6ivq-qoxYPOiFsMLkuw>
    <xme:u_spaTOOkZn9xqNEJSGf5mzA2MDsZtdEGbAkFRH2eSnRTT6E00Xq-6URAsaG82kAz
    iwy4EKh7TctIAdA-hiqigm-TOsO2cswxl_NwSbc3u-ZRUl2CDk2e_w>
X-ME-Received: <xmr:u_spaZZvCHnmykFi5W718BokILHcZiridgnIRZPyk75-omm8qMpNbDTM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvhedtjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeehvddtueevjeduffejfeduhfeufe
    ejvdetgffftdeiieduhfejjefhhfefueevudenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedvhedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtph
    htthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopeihihhshhgrihhhsehnvhhi
    ughirgdrtghomhdprhgtphhtthhopehskhholhhothhhuhhmthhhohesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghp
    thhtoheprghnihhkvghtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepvhhsvghthh
    hisehnvhhiughirgdrtghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtgho
    mhdprhgtphhtthhopeihuhhngihirghnghdrlhhisegrmhgurdgtohhm
X-ME-Proxy: <xmx:u_spaQ9tEV8cDlevZ-v0OB2LshaM7YBMge0ziiPXrDgaMMhdXAZKXg>
    <xmx:u_spaU0Y3QbWvnuK6g2cWmy1jF1AjsorD-4gNMMMWsepnUTkx0LbgA>
    <xmx:u_spaR3TPuVhaTlmfGiqH2efNkdmRrPZq4IsbttP0XtbKfw3ln2XNg>
    <xmx:u_spaZyMhGUx0E5qy58q3ECjndNRSzvYGrpmTfpknqiYcT8OnIjNuA>
    <xmx:u_spacX-Xbc36IuYK9S2lKzEpsTg7DcMBuA9HbW4kKZeyS3EwFbA-xAd>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Nov 2025 14:44:57 -0500 (EST)
Date: Fri, 28 Nov 2025 12:44:39 -0700
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
Subject: Re: [PATCH v9 0/6] vfio/nvgrace-gpu: Support huge PFNMAP and wait
 for GPU ready post reset
Message-ID: <20251128124439.3a30cf93.alex@shazbot.org>
In-Reply-To: <20251127170632.3477-1-ankita@nvidia.com>
References: <20251127170632.3477-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Nov 2025 17:06:26 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's Grace based system have large GPU device memory. The device
> memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
> module could make use of the huge PFNMAP support added in mm [1].
> 
> To achieve this, nvgrace-gpu module is updated to implement huge_fault ops.
> The implementation establishes mapping according to the order request.
> Note that if the PFN or the VMA address is unaligned to the order, the
> mapping fallbacks to the PTE level.
> 
> Secondly, it is expected that the mapping not be re-established until
> the GPU is ready post reset. Presence of the mappings during that time
> could potentially leads to harmless corrected RAS events to be logged if
> the CPU attempts to do speculative reads on the GPU memory on the Grace
> systems.
> 
> It can take several seconds for the GPU to be ready. So it is desirable
> that the time overlaps as much of the VM startup as possible to reduce
> impact on the VM bootup time. The GPU readiness state is thus checked
> on the first fault/huge_fault request which amortizes the GPU readiness
> time. The GPU readiness is checked through BAR0 registers as is done
> at the device probe.
> 
> Patch 1 Refactor vfio_pci_mmap_huge_fault and export the code to map
> at the various levels.
> 
> Patch 2 implements support for huge pfnmap.
> 
> Patch 3 vfio_pci_core_mmap cleanup.
> 
> Patch 4 split the code to check the device readiness.
> 
> Patch 5 reset_done handler implementation
> 
> Patch 6 Ensures that the GPU is ready before re-establishing the mapping
> after reset.
> 
> Applied over 6.18-rc6.
> 
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
> 
> Changelog:
> [v9]

Applied to vfio next branch for v6.19.  Thanks,

Alex

