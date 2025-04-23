Return-Path: <kvm+bounces-43989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C9DA99656
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B31D41B859AB
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E8A28C5D2;
	Wed, 23 Apr 2025 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="npaeDpuZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B94528C5B6
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745428644; cv=none; b=ItQ9Nvdp0At9Pz9tLj19xCwNvVlgsREXYyYXp4iV4xfD51sgyHgC6+ilM7fxaeWyOGvGg4ciVNUgyrJjjMMlKJ/SSl+7k5PlEtZGx64WoUb9GdvxizsWGUbuziGruWAyWPVcQikuQLCHsTs0EOi2mq/LActLQVMQahYpqtPFSQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745428644; c=relaxed/simple;
	bh=EiBhyUfzV2Z7UDyJtWT+jDVz3vG5z4pmjKVdd/tf4pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNhjfVrKFSeBk/r6bcx6ql+BH44IrWbOJd4UYX2XAk8r4AXmciOfNKPvXMb3+IjbhMNwB8Sib+WVnJO7m/8aJ3lKqVx5EY9fFKQCLFWukgimV1qP9iXiwQ2S8JbifiQ+KEdmP3d00xboGwkJ38vMJVlvMU0xF9H0EmivRL4bfOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=npaeDpuZ; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4766631a6a4so837511cf.2
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 10:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1745428641; x=1746033441; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dFsItIzcNoABKT1tTnR+L3KluEl/QW6UiWkd3yuS4gc=;
        b=npaeDpuZ5VPkOZqrigtgKEO3dCkGR0IX2y98q9Ii9PH6a4ySKU1Jl4WwtNJ6vivJox
         7hEhKgYIFPYqeHFyrzJiO3d33Z8ckzVE0eaA8fEtLnT8cYn03BrtVZuBiETLqrfiK/nf
         gFTPKeLi7Cpt7+qx2b+ZjMHPmjzmah7oNakivA1lRSbQMUGY1if5wHCAKmZlpI9uAt6a
         Zy6Lvyyn98F2uzFdf2FiWobaepLTsF6ukZ61MMk+0nGEE0Blu0FjWpPxnQrpfafrFL4m
         rX9Cge4tjMFyn+s+tbrBkE7lZCL4t6Rs9j2pRiBe6X2c5Xq9grXs9D9XN/yfjfw31f4z
         4q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745428641; x=1746033441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFsItIzcNoABKT1tTnR+L3KluEl/QW6UiWkd3yuS4gc=;
        b=djoeStILOehdMgUUJHwFgVeT1frOs+aY/aKWBei8SpJYkOZr2zqCrhD1DidMsHRBZX
         PDqM06PERQVXuibEzD2npSDrQXYJwA6RZX0zc/3za1BXNtkOf3xywwLXRaaHrrB3xN5P
         ZEA4zw1tofrTf3XexuDnlh27HRnFuvpNzhNWYZFSlq+V2Bsi0HKlxvLM6G16gggmwOhE
         VsU6wNaBFgKjkODJaK/YDc0n5QA8ohOc7sc0T69f8pI5Qp8Ot0NGjxytCfr7imxg8JTX
         rzbfjLeYfxHrpf+IrEGtjfweo5C6ULv0hXJ/Gc5yvNSOWOzd2Dh4AjjM+dI+YR1YeXPf
         jCng==
X-Forwarded-Encrypted: i=1; AJvYcCUexP8RqdNXQkYTiHMM1OjEnQxUaBpEDzasH9DWWIUOocKHf/4Nvm97o95yt3irfAs25C8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQsqMeidxDIz7zpXu9jRSV2FZ12KnNbu5N7iFZQodT9baNnsP+
	l+p8ujVaDA5KYxEhQMtm9C4xxeF+dvtCaIlCLUejWDzNzm5wAQHyfJfM1cKLiEE=
X-Gm-Gg: ASbGnctYZjplGwfavKkIyQUnbtm98Eh/YMcdG3hbG+Gy+Zu9Xxjyc/r/RCWFfGMFyi6
	/Me69iWD41T14Nt42Cfq0eFWC2KV/sxYqtjWw+sj0i6WF3+WCprhPp0D32K78hwzUIeaXx4MS+O
	N/ScgEPuEbQx8Lht/YBYydNezDSLs7Tpe+PtuWyf85qyHzcmC4PRH161Sh7xyKMQ6wgZdyd/IX7
	DTcEhBX9m+AowdCKv3QKuMY8pB04IrOJhhWcV9wcXP4T8ojX8oVU+Ibt+OMseFhYIRBuCaUAzZu
	SFb7AaF+E0eiAD3fLgV+TubTG32RisGzB0kJN/YZ1tODixV7jgX3qaT/dlQ4AmQ5Co25p76AtMW
	CWfNO6kMNMRtvedh4yjo=
X-Google-Smtp-Source: AGHT+IFtKlYmuMPWfMKQK8kh2VV5wwxeBA4j6ePEQHIEvAPMlC2NtpfOcLZrcYI7RZQRiXVuJwSHAw==
X-Received: by 2002:ac8:7f51:0:b0:476:838c:b0ce with SMTP id d75a77b69052e-47e7607d5ddmr844071cf.13.1745428641397;
        Wed, 23 Apr 2025 10:17:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47ae9cf9f29sm70808611cf.71.2025.04.23.10.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 10:17:20 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u7diq-00000007LSZ-1iS9;
	Wed, 23 Apr 2025 14:17:20 -0300
Date: Wed, 23 Apr 2025 14:17:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
Message-ID: <20250423171720.GL1213339@ziepe.ca>
References: <cover.1745394536.git.leon@kernel.org>
 <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:13:01AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Introduce new sticky flag (HMM_PFN_DMA_MAPPED), which isn't overwritten
> by HMM range fault. Such flag allows users to tag specific PFNs with
> information if this specific PFN was already DMA mapped.
> 
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/linux/hmm.h | 17 +++++++++++++++
>  mm/hmm.c            | 51 ++++++++++++++++++++++++++++-----------------
>  2 files changed, 49 insertions(+), 19 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

This would be part of the RDMA bits

Jason

