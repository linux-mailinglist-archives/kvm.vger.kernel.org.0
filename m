Return-Path: <kvm+bounces-46711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E63DAB8E10
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 19:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAA361BC4E81
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDFE258CDC;
	Thu, 15 May 2025 17:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZRZ64b9d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C593715A864
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 17:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747331250; cv=none; b=XjF9SQo2bMVFGtncFF3fz3yGG49FoNMZKRboIXSa/ZQ+yIPCHk9Kmbjy15nVZCODqOw2R1wjfP18X4YtLOp+cBJ22mMwiP5Xk6SpmXqOVbYKa5NGS8wvboxJLtU/N8DhID5fVY1YpV8wS1tM1W6L48sxfd0gkTzkJjJcw0HGsBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747331250; c=relaxed/simple;
	bh=MhjDPfwr/QIcR1EH0Tzfd1UVd+kzuvdjTbhcCM2IlQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c6RyNyqBtmA4RdeVDUWWxSiNXEHzvVuumShsPggdT3fKEsd1fs6T3VabxBh54y0ZnkXbRCZ2wgZ5ucl5WPkqr3qjR1rVW7qTny5vUmvuKiB62apfTIxqNtDb1fK5mQ27XHWC/JLG8GQC4yBYNLlngcRs7ixO+0oLB0k5oCCGblA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZRZ64b9d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747331247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T7b4KdbKNsyRd/r0nUry1VnuJgBGzE7K3mHWwpLqrFc=;
	b=ZRZ64b9d7xS/Hsen9nGHBMqG3bplKS/5SH2chcHHibMUXqiPLPjLvB1regYXSsV8ANzpHs
	dGcXG9AUe0W2wGd0yNv46ULEe37lfcdItlg7V7lAXmJ3X/e+3l/DSPens5V/LrpMUk4bKe
	vHnDtwGJ88sNinMrxHJC3Z+El59Z2Bc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-dDCEVGvYMUKmTvPKr4fShA-1; Thu, 15 May 2025 13:47:26 -0400
X-MC-Unique: dDCEVGvYMUKmTvPKr4fShA-1
X-Mimecast-MFC-AGG-ID: dDCEVGvYMUKmTvPKr4fShA_1747331246
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-862543270d7so20423739f.0
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 10:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747331241; x=1747936041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7b4KdbKNsyRd/r0nUry1VnuJgBGzE7K3mHWwpLqrFc=;
        b=DuPEZxdOZzX+CICNQfMsRjiv2QQ0m6kQccK5L4HV5ZW2G41I5K15EE6zErrntF5Xyu
         eDveDNNCLY5Jgse1fCxds5BvfOPScAx6N5AmDkZ1dkcK4hccBI8EhChSImAMZBynVMzl
         ddvtcl5yovZE+TRjwkeotIQcckkS3Bk0UGWfy9kmnFPqLM2s2Is3GWgx7dQ1tXylSUKV
         fVf1103XTPK8b9iRZURwTtz4qYowsE7o8C+la2VvR6OjWJkC+MlrpjPb6TA6sBwm9re6
         dUUt5Jnhi0UZZbQmsIr0p7I/3sPGJm382xdo2A+KbTP6STbzXa1NUV4yor4smCPR8bs2
         2IPg==
X-Forwarded-Encrypted: i=1; AJvYcCX4aLtmHx/seNTqWt+YN38A8aUu7zR/aqyuuuNPrpxjJeg0QZDD3Z7B0MARpuMD873bALY=@vger.kernel.org
X-Gm-Message-State: AOJu0YypnzgwbHKRZfcYxTkkmC+BkvOlMuW8Jg/fHzbKEYGwD4tb4fHb
	ivKE3mBC3csoItENq+NTMGJj79NgyFTwuS4U39/qJK0gdpkuiOX166pb3TuqRSgKlCFR5WVE/i6
	9ACuibylVgRMOmOodsM3KxnjVQMrb2ZlveEyrhKIHDXdbZB5F5GcVVw==
X-Gm-Gg: ASbGnctRwOVk9+MvMkIgG1UVY1fSFVSzino1b6zmOZAokA5nAXrU7D+MusX6MVNwFDW
	+jlyOZFegUmEz3JB3VbVVH/3RKxiN6cCkhhEEu+keqehkgwOuY+qeCEanZEq9L2hVEkFQDLngUi
	Cs769FCtLj8oXBzJUvVSpKY92obcoh12RoYxVO2E6TUYqXkKsxbQrfs2ynC2hV1+yqTUS0ND6zb
	CzAlh6zVb2ib6zonKc5ZczJKrOsTef2vOfKlIN1iYlDKUa6clpCgEtAu+u5Fzj2Y6znX60d3hV1
	l6/m7ZkCtju8MWs=
X-Received: by 2002:a05:6e02:1c07:b0:3d9:3a09:4166 with SMTP id e9e14a558f8ab-3db8433504fmr2349595ab.5.1747331240651;
        Thu, 15 May 2025 10:47:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3cALS/KaFwvbgaRvO5il6QKvBR9bLbfiYqAnl1ZnLudPcbMy7c5wnBqVyX0fmSpHBueQe3A==
X-Received: by 2002:a05:6e02:1c07:b0:3d9:3a09:4166 with SMTP id e9e14a558f8ab-3db8433504fmr2349365ab.5.1747331240176;
        Thu, 15 May 2025 10:47:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db843cfa7csm632665ab.14.2025.05.15.10.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 10:47:18 -0700 (PDT)
Date: Thu, 15 May 2025 11:47:15 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, kvm@vger.kernel.org, Yishai
 Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
 <kevin.tian@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] Please pull mlx5 VFIO PCI DMA conversion
Message-ID: <20250515114715.0f718ce0.alex.williamson@redhat.com>
In-Reply-To: <20250513104811.265533-1-leon@kernel.org>
References: <20250513104811.265533-1-leon@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 May 2025 13:48:10 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> Hi Alex,
> 
> Please accept this pull request, which presents subset of new DMA-API
> patchset [1] specific for VFIO subsystem.
> 
> It is based on Marek's dma-mapping-for-6.16-two-step-api branch, so merging
> now will allow us to reduce possible rebase errors in mlx5 vfio code and give
> enough time to start to work on second driver conversion. Such conversion will
> allow us to generalize the API for VFIO kernel drivers, in similiar way that
> was done for RDMA, HMM and block layers.

Hi Leon,

Pull requests are not my typical workflow.  Are these mlx5-vfio-pci
changes intended to enter mainline through the vfio tree or your rdma
tree?  Why do the commits not include a review/ack from Yishai?

Typically I'd expect a patch series for the mlx5-vfio-pci changes that
I would apply, with Yishai's approval, to a shared branch containing the
commits Marek has already accepted.  I'm not sure why we're preempting
that process here.  Thanks,

Alex

> [1] [PATCH v10 00/24] Provide a new two step DMA mapping API
> https://lore.kernel.org/all/cover.1745831017.git.leon@kernel.org/
> 
> ----------------------------------------------------------------
> The following changes since commit 3ee7d9496342246f4353716f6bbf64c945ff6e2d:
> 
>   docs: core-api: document the IOVA-based API (2025-05-06 08:36:54 +0200)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/vfio-dma-two-step
> 
> for you to fetch changes up to 855c89a25e1756b7699b863afd4d6afcbd0de0d6:
> 
>   vfio/mlx5: Enable the DMA link API (2025-05-13 03:58:27 -0400)
> 
> ----------------------------------------------------------------
> Convert mlx5 VFIO PCI driver to new two step DMA API
> 
> This PR is based on newly accepted DMA API, which allows us
> to avoid building scatter-gather lists just to batch mapping
> and unmapping of pages.
> 
> VFIO PCI live migration code is building a very large "page list"
> for the device. Instead of allocating a scatter list entry per
> allocated page it can just allocate an array of 'struct page *',
> saving a large amount of memory.
> 
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> 
> ----------------------------------------------------------------
> Leon Romanovsky (3):
>       vfio/mlx5: Explicitly use number of pages instead of allocated length
>       vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>       vfio/mlx5: Enable the DMA link API
> 
>  drivers/vfio/pci/mlx5/cmd.c  | 375 +++++++++++++++++++++----------------------
>  drivers/vfio/pci/mlx5/cmd.h  |  35 ++--
>  drivers/vfio/pci/mlx5/main.c |  87 +++++-----
>  3 files changed, 239 insertions(+), 258 deletions(-)
> 


