Return-Path: <kvm+bounces-68526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23687D3B3FD
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D614D309F40D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 16:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A25D30DD1F;
	Mon, 19 Jan 2026 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="LA4MQ6LH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D099D2BE048
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841927; cv=none; b=Eu9jp3BB0Xh9nJ4Hm/VPWmhbJ5yGqXFVznqOqlJjOXqQv1003kQ7lz6qsljJ9SBTdMfxlFtMcCj7xCbrl/i+wLxGPbsvmkM4Tz0zvuM29ebG/NLQzYyRYGuFVO7oTMpLhTmJrlRPZrkcMydxFGXn3eGccniNundiPcMWyxnlB4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841927; c=relaxed/simple;
	bh=nsqjKuZBX2xVAZ9wDedc6M6Km3uKRKGPzdUMml50yUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEZ740WU52A04hPtdRYekZNX7olBhc163OG2+uoAedvxv/jvf1ozWYUn4elJLBxNVJcGyMS0V+svDYVem397DayhrWC4wRaklyTy4BdY0Wm8GOoUSwUUqOJLoN4X7ErnjhW9UOyK+TdVpls7Xrza2RyxnvmAq7TmxMuQFUF1iCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=LA4MQ6LH; arc=none smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-88a379ca088so38126376d6.0
        for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 08:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768841925; x=1769446725; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ljxKTxaVdu8I0ces4FnKFMKgo+H8JcchtOlXOe2X8IE=;
        b=LA4MQ6LHmA3jMregg3JwmBDrlNIC6TKyIIRoqsj/MeU1Dsh3Q71mCDdmTdHoGQtVsN
         ZRrHL9mWWJsxeN2FDE1Hjtj6PvZ0arDGUT1e9HZIsSvIjnYe2SpfFRD5sasqcKL3JyXl
         aXI23p8ZI+7yyjhTbA4fRhrjxEC6exVDsBNDz+P/kmEtSJV/CknvREmwrZDJHWYUyb2E
         mNm2hs1qb8JDJ2XVCs7DEo3chAG5VztyMJLYH9BsfjRnrxw4x2H9PKSoWLzxnrG26WNg
         OrhsagYWLmM4Ktp7WrpWShtGcDuHTGATcf0yOQitnpMXIYgJTMfX9eYKKquGpVpl2F4D
         tA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841925; x=1769446725;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljxKTxaVdu8I0ces4FnKFMKgo+H8JcchtOlXOe2X8IE=;
        b=nfVseCCDsBuaK0dVCeWCefZ3XMGxSfZ8BNgkUOHqTn2Y+9xXtRjlDRtuRKC26QoAlu
         rLfpgD2dfV3sv+yqgv8vhTvN/vSEQBN7OP3y7aHjTsB7axTReMo6fqwTG2AIspLWo8zj
         Txlj6asIApzzwLK6Eos2Px++xh2f/ZhDMYFDaolfYDUZ34Ri1cee5isdvINAVSnQ5TZv
         DPAfR6AdMU4AzqXzIAiB+0eMEEnMtlrWLWm7D+sLINIKkm0luU1Kf6KBq4pAnz/x0GRL
         0v4rrJi8Yv5ue4rE2AVF9XhBsZ8IweEPP4JfEzyCvw6YAoqrvtkJIaBjqBgIM8/OYegC
         xkUg==
X-Forwarded-Encrypted: i=1; AJvYcCV9iwT770jQ9p6Ydu6KS7pX+ZzXNbBJESre5d5NHzBpNg18NbTv6AUKj0XFa0w2nSC3NfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA2MgArR0sBYYo4R3xwwncOmD5r44H+IfmvnQ7gL0YG+AD9O68
	Z0VuXaGU/GcBIfVFGGMZl61UYuhNobM6aAakpjALM9eYeyRnzNhTceyWv6t4H/SSSfg=
X-Gm-Gg: AZuq6aKVU63A2rgrso4ANmu/uvG6ZkyUZpmO69vMcBW/33ORXc1uv32wimiR9++f5fK
	vOL+C+DPb/uYWifqqrt2uYnCYss0Ti1UE+B0Ri/KL44Dc10GWIRPrVWW9nXfNUhYCRvkhzbfq/q
	NVbfBXelUq2gLz67jrvZE/9MUX7qo3H/zkxmUlKoaV77mOnr1Ah2sNRGdOYuW6isz43A1AN6R2B
	q7nMfAq42fz4b5/Y613xv1oQvMp88B8rMJacegSHRmLKJLKfG9jP6OEfeW1eXYEVyKlmBqgjcuE
	D4+RrZUB7xTvn5YlBlNRkBnA6VQfhHioI0ZGZmpjbODG+NCi1/VfDd8wula4AviUqknj5IV3AiY
	KmFpbX1q3LCTg6AFBa8YuQx+RrX2yn2D2Udnj39ZKSBe2rajGY6Ak5ccF/FCZZ8sMQ63syTOsLU
	3oC1OYaBJ+FmXNvbkRgpUBHEIOw6Fqw6Wnmf9JA8oWEYjGmxybWXPYE8de7kg6tq4+aNS2lbmtG
	g/0MQ==
X-Received: by 2002:a05:6214:2523:b0:88a:2e39:957e with SMTP id 6a1803df08f44-8942dd9e90fmr129930286d6.57.1768841924690;
        Mon, 19 Jan 2026 08:58:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e5e526dsm87021366d6.12.2026.01.19.08.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:58:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vhsaR-00000005IQb-2Wqn;
	Mon, 19 Jan 2026 12:58:43 -0400
Date: Mon, 19 Jan 2026 12:58:43 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
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
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
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
Message-ID: <20260119165843.GH961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>

On Sun, Jan 18, 2026 at 02:08:44PM +0200, Leon Romanovsky wrote:
> Changelog:
> v2:
>  * Changed series to document the revoke semantics instead of
>    implementing it.
> v1: https://patch.msgid.link/20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com
> 
> -------------------------------------------------------------------------
> This series documents a dma-buf “revoke” mechanism: to allow a dma-buf
> exporter to explicitly invalidate (“kill”) a shared buffer after it has
> been distributed to importers, so that further CPU and device access is
> prevented and importers reliably observe failure.
> 
> The change in this series is to properly document and use existing core
> “revoked” state on the dma-buf object and a corresponding exporter-triggered
> revoke operation. Once a dma-buf is revoked, new access paths are blocked so
> that attempts to DMA-map, vmap, or mmap the buffer fail in a consistent way.

I think it would help to explain the bigger picture in the cover letter:


DMABUF has quietly allowed calling move_notify on pinned DMABUFs, even
though legacy importers using dma_buf_attach() would simply ignore
these calls.

RDMA saw this and needed to use allow_peer2peer=true, so implemented a
new-style pinned importer with an explicitly non-working move_notify()
callback.

This has been tolerable because the existing exporters are thought to
only call move_notify() on a pinned DMABUF under RAS events and we
have been willing to tolerate the UAF that results by allowing the
importer to continue to use the mapping in this rare case.

VFIO wants to implement a pin supporting exporter that will issue a
revoking move_notify() around FLRs and a few other user triggerable
operations. Since this is much more common we are not willing to
tolerate the security UAF caused by interworking with
non-move_notify() supporting drivers. Thus till now VFIO has required
dynamic importers, even though it never actually moves the buffer
location.

To allow VFIO to work with pinned importers, according to how DMABUF
was intended, we need to allow VFIO to detect if an importer is legacy
or RDMA and does not actually implement move_notify().

Introduce a new function that exporters can call to detect these less
capable importers. VFIO can then refuse to accept them during attach.

In theory all exporters that call move_notify() on pinned DMABUF's
should call this function, however that would break a number of widely
used NIC/GPU flows. Thus for now do not spread this further than VFIO
until we can understand how much of RDMA can implement the full
semantic.

In the process clarify how move_notify is intended to be used with
pinned DMABUFs.

Jason

