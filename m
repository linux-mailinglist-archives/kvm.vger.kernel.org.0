Return-Path: <kvm+bounces-3160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 693AA80138D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18B71281A7F
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87E05102C;
	Fri,  1 Dec 2023 19:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="OEwK9Qa7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ACD128
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 11:29:29 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1d065be370aso4660775ad.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 11:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701458969; x=1702063769; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wKPTNfyUQ76RXlZglnCsaAsISjRqR/A1VMTCAWgJfNY=;
        b=OEwK9Qa7p/EWZV0m1JAeGbSFiojF7D4HhpryRtaChiKP53JIS697lzUALcU+x0SunW
         ggp8C4AbkHabG4WGJ03mFXAXPl21EWX1ZF+LO4egLwMmztiP3gu4TWXEGv7imedn7vpW
         GmSQQ5aa6Kzgn92kTFg8dhd3CF4JFtTq9Z1MGKIrDjw4j6New41pM5pVrIHWmxdsuNB+
         V5aiOgQxacqeuwzaNOZ04udkIC6xF+e5sQQeCf0Euq46tqX8FNAdayBz0mFf24jBBsUt
         1neDtB3baNdgbn0+pn+dbvbDzDNOojr6+l1TV5AaI7ByZGiYX4e3F/avFo0JITJyH5J4
         X/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701458969; x=1702063769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKPTNfyUQ76RXlZglnCsaAsISjRqR/A1VMTCAWgJfNY=;
        b=G4dHG1qff9c5luAD9V16Gu8JIcF+29w5gLS10IB3vv6/U6eRgoR4nEXbzDZ7kxibrj
         f0YsZlw9Nufnr+6u7+6YWtHKJpj9RtiOfvp+jO3bW2nQpugfOeKjm/0gmhM9Db/3dORM
         dru8+P+UhNw7/5vMzY+DLHoS0Ho3ZWS2TkhtFzMyxNaHsuLxg462VsJ0ZkxDa6CZj6Z4
         pyufhhtWgw6G9QHaBqNNFemkcpGO6hNUvtgD6d7mSr2RxHeuC7gZSxqLAIZMKoUb/iO0
         qxSQbqZjXaPdsnoq2QrUnbvTZHxRQ595W18Vbsr7SPk699xi99lRKbX+neMDmR0srm6N
         aaRQ==
X-Gm-Message-State: AOJu0YytcxSKWcmSKGdftpp5LRiK9n7lqhNETyzlXC/zzsF+6dkL656x
	XiXVERu0K0/8IwyggugkOL7ZDhAZNhrr/eN319c=
X-Google-Smtp-Source: AGHT+IFicvE4UTpgf7EEaTDeLovKnKQDD9u8jMl5SDOOOkrmTUmnQHfGJZN3OtHg/u3QSEBLkoWKEw==
X-Received: by 2002:a6b:6111:0:b0:7b0:3:6ac7 with SMTP id v17-20020a6b6111000000b007b000036ac7mr68941iob.16.1701458082221;
        Fri, 01 Dec 2023 11:14:42 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id dc30-20020a05620a521e00b00775bb02893esm1741124qkb.96.2023.12.01.11.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 11:14:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1r98yH-006HtX-8r;
	Fri, 01 Dec 2023 15:14:41 -0400
Date: Fri, 1 Dec 2023 15:14:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/12] iommu: Make iommu_queue_iopf() more generic
Message-ID: <20231201191441.GE1489931@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-10-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115030226.16700-10-baolu.lu@linux.intel.com>

On Wed, Nov 15, 2023 at 11:02:23AM +0800, Lu Baolu wrote:
> Make iommu_queue_iopf() more generic by making the iopf_group a minimal
> set of iopf's that an iopf handler of domain should handle and respond
> to. Add domain parameter to struct iopf_group so that the handler can
> retrieve and use it directly.
> 
> Change iommu_queue_iopf() to forward groups of iopf's to the domain's
> iopf handler. This is also a necessary step to decouple the sva iopf
> handling code from this interface.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  include/linux/iommu.h      |  4 +--
>  drivers/iommu/iommu-sva.h  |  6 ++---
>  drivers/iommu/io-pgfault.c | 55 +++++++++++++++++++++++++++++---------
>  drivers/iommu/iommu-sva.c  |  3 +--
>  4 files changed, 48 insertions(+), 20 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

