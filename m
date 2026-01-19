Return-Path: <kvm+bounces-68519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2255D3B060
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 17:20:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 817B5300A999
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 16:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484692E36F1;
	Mon, 19 Jan 2026 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="m6EoWVWn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com [209.85.222.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE362C178D
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768839631; cv=none; b=eTgDzJgmTqmbewIPaibEdAjRRskaDA+6Cf0SIaMGW4tGIwW+MVKpdD/yQNLTwN4mMkE98scJJGtoXrlpZjJZ16AQ3+dgpHjgT5pgOCs9a8OsN8eaWAEwj8mc5A1YJ/vBpl5XRk+FmavJO+yZzfZU2WJ//CmLMa6/1HPUjJCovcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768839631; c=relaxed/simple;
	bh=lLsaw5dNuTdwtV9+A4M72uMo0bYM3iY+i5XXMuIoHPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y82OcIbeNWbduMWVt7jxbhVL5w04cC/BGzM0Bfaez70mJxdxAhefe+T9pVY2aOPbErU48IQgnrzUaXf9zwfVjFHXmOzk6vt/amnIKOjSe3r7+dzPwKd6QA3E4fj6J45IFQDZSCTy4Y4Y1LGA+CFgkdlVxEx1AwmzlWPT4E8Ej3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=m6EoWVWn; arc=none smtp.client-ip=209.85.222.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f196.google.com with SMTP id af79cd13be357-8c5384ee23fso484379385a.1
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 08:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768839629; x=1769444429; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8e3LOQmDLtNbqPr2ZRZYrAEb0+eSE57gTBol5BlL7sE=;
        b=m6EoWVWnIVusJQRbMHxn9aEAeSSb390h7gBoTRonBl6NZ/MkAC/rFCgzdXlNJ4XME7
         9dZzu/OoNI3lxr13d1wWJkDhcf/LD/YI15fPMmp5zpzlLERICp/DLmz8s4FXlBjtSOgf
         RdxNNLdTL1QPH10d9qhOfwHLTwj3v1a68164c4TpRD4n9GAaMoLfVx5kX6Hn1caX3p4y
         ye0uJ1IUkkNojEb0wm3XZt+KWwJoz9bq+YReA3uBye/V18EnZL1lSB+cChEuAMEPhN6+
         VZ/GkzhmUyHlcQBcDVVgq3rQiPPdTiAWntlzk5eAEeZZuzn+F9EjaJx1JgAf45zMO8tm
         XZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768839629; x=1769444429;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8e3LOQmDLtNbqPr2ZRZYrAEb0+eSE57gTBol5BlL7sE=;
        b=koZIqXsVg/xx1n4aTMgF0h8od20Spbi+ZEHtRC0+cFCUE5hbHuqnXqmPZymiWneQIp
         0PaS1kUW52JIsVAFxTRGrpcXn5u/eUHwtmJ506KNabzNPOzzmqn0ICj2RD9eoIeHINd3
         my762YxVN/+aYnry3LGgmdRNGsRsoclROHeW5CLZLEIB2hruLK8/SOtm6tu2Nmlw9/fG
         S5gDw/VKfjcnftyfXI3m7lCOmgHLVdlvEt8WwkwVtGFP3uZArJsQxWAXT33CwnmYEMzE
         75h1FhsSXCYJuHq1mSCcCuk5RH3nmD/1+AcB6X/y8QPmDhO/xPYCn2UiRvFeIAhzHGBw
         UP7w==
X-Forwarded-Encrypted: i=1; AJvYcCXBtuI3eFlTDJAiJ/udDyPP76MX+8IJ/bHSchuX6anfyxAuWuvwrLM6Vrnad1vZ3PHEqg4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNcoE5599bIPjUWeiS1tjM55dvEWmSeEac4aPLax33IO4AGoLs
	/Kemrgz2D+jF2ZZFFxJA7Jxt2ctZDUBWRVNrqT3CPSlkl0G3D5M1nHSjY6BUmefa48U=
X-Gm-Gg: AY/fxX47l74LckN6rKrhpxmOOf2qcr5iLMDY8t/TB2tq+abil6G6MF+qC+52HlntKnl
	HT8tLEGMYfWJV3od0S5l/eqzEFyNye10qc7pQW/0Uoeu64guKTF1tnIUcLWiVZiLDkj7XoM4X0x
	+nzoKNmCX3wToKyuW2GHZD+LQ2GEU3xOJGBK53Zh0sJmSwIDvGG6mpOo6DUL9TLgw0XwJxeXLr+
	4znl0ZCVlVoU0KGIk/iTsIeYFCXNMB9Qxo7i42awfVe+E8GHYCSrGKHTUo1+38OskY+BseuFvlz
	Wewl198iGlBs/vBwE6ss4t1nXHJJ28nGFzhb9r6gPDwc51aqKmb72rXftGgX4W3WAusfDOl5PhL
	fVr3sremT9BA5qZs6XhKJ3tEjRpeNHDMBMMnFsDqOVcnoyNJjfVB9nIU3M6qI23YFV5mkizkh+k
	P87pbQGXW9Dfz3ZKKBVCoxWGys1FXLXmV72NLLbkvvGKCuz/G2Qgg62IsBTSP54dI5b+s6rkhrZ
	NLq9A==
X-Received: by 2002:a05:620a:7102:b0:8b2:7679:4d2d with SMTP id af79cd13be357-8c6a6948169mr1559881085a.63.1768839628533;
        Mon, 19 Jan 2026 08:20:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6af506829sm597447585a.37.2026.01.19.08.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:20:27 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vhrzP-00000005HvQ-0mnE;
	Mon, 19 Jan 2026 12:20:27 -0400
Date: Mon, 19 Jan 2026 12:20:27 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/4] dma-buf: document revoke mechanism to invalidate
 shared buffers
Message-ID: <20260119162027.GD961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <f115c91bbc9c6087d8b32917b9e24e3363a91f33.camel@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f115c91bbc9c6087d8b32917b9e24e3363a91f33.camel@linux.intel.com>

On Sun, Jan 18, 2026 at 03:16:25PM +0100, Thomas Hellström wrote:
> > core
> > “revoked” state on the dma-buf object and a corresponding exporter-
> > triggered
> > revoke operation. Once a dma-buf is revoked, new access paths are
> > blocked so
> > that attempts to DMA-map, vmap, or mmap the buffer fail in a
> > consistent way.
> 
> This sounds like it does not match how many GPU-drivers use the
> move_notify() callback.
> 
> move_notify() would typically invalidate any device maps and any
> asynchronous part of that invalidation would be complete when the dma-
> buf's reservation object becomes idle WRT DMA_RESV_USAGE_BOOKKEEP
> fences.
> 
> However, the importer could, after obtaining the resv lock, obtain a
> new map using dma_buf_map_attachment(), and I'd assume the CPU maps
> work in the same way, I.E. move_notify() does not *permanently* revoke
> importer access.

I think this was explained a bit in this thread, but I wanted to
repeat the explanation to be really clear..

If the attachment is not pinned than calling move_notify() is as you
say. The importer should expect multiple move_notify() calls and
handle all of them. The exporter can move the location around and make
it revoked/unrevoked at will. If it is revoked then
dma_buf_map_attachment() fails, the importer could cache this and fail
DMAs until the next move_notify().

If the attachment is *pinned* then we propose to allow the importer to
revoke only and not require restoration. IOW a later move_notify()
that signals a previously failing dma_buf_map_attachment() is no
longer failing can be igmored by a pinned importer.

This at least matches what iommufd is able to do right now.

IOW, calling move_notify() on a pinned DMABUF is a special operationg
we are calling "revoke" and means that the exporter accepts that the
mapping is potentially gone from pinned importers forever. ie don't
use it lightly.

Jason

