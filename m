Return-Path: <kvm+bounces-35100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BD3A09BCE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 20:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DC4616ACA4
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 19:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700D4214A88;
	Fri, 10 Jan 2025 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="ULCkposT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167E924B248
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 19:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736537068; cv=none; b=mxtbDhsTO42+WET/2+9KKiBQ3q9k1QWnDv743+hGdYYxg3ZK9fjmv+qghyeUyRFQJuagxjEKMVjVDMb5/bUKOr/tWy+qVFO+9HnNWd8Uxd8X4ZV/3Y982PJeF/kFjCLfugxsg8mNjgr+0O6UQ1kOXMMCd9EePgUjyoO0C6of42k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736537068; c=relaxed/simple;
	bh=GAXiVwRl5hX0nr5x2c6GDMtUgYBmYNxhBnIp/PYb1FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUZzgP84Vjbf3dS9m81N/vvvtjKBpT26oCa7imBFgZrhuc1Rz/idX69R+oGX0/RJxebT4Wy5vYZwYRW+I/AvvcVDLYQuOBnFs/She6Ljwq09U55/UpsiMAQUzLHiH6pfIsUuDBAJLPeBOTX3jooEJ2IFOAPE6ChFEt8VU4ZG29I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=ULCkposT; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4363ae65100so26133955e9.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 11:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1736537065; x=1737141865; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ACopzyajfJRcuBL6kkHr9KV+I23S42u7LRA+BIOf1M=;
        b=ULCkposT/Gm25LgersU71BEgkzgTyUegXvreUI6kRtUy0RkZ/aQGSFkVbIfktpsygl
         1OlM6J+tyMQeqX0c86M6SVJT+O1+L6VI+wyjRPs8v6+Ip7cM+ZrZ177hSGcNNc/4R/t9
         Xj+2sID7HgJMgmlxUNDIBxWUoQxIFlxUp1Cws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736537065; x=1737141865;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ACopzyajfJRcuBL6kkHr9KV+I23S42u7LRA+BIOf1M=;
        b=SEggVH8Sx1Ati3ST35nzBS+zREAHgXIunYIuFJ44yBMTLQuAtmaupEEIONC8jwz23G
         yJcYzXFoxEwh+tjabO/YpMqbO9lLuxdWQwq3HGZ0wNrH8yjzFrgez16a5usNJy9cTP69
         R+LMqSGDewcv3dj4TASqoBGh81Ea659eSiUAiwTSgQmZztCNZgWShJvFuUoXHUEb7I3t
         +AZ9WK0jNJe2lMHj5TuXTh3zd5R0W+Pb8TDAJ/MMBvEqF2UQdmbU1KGK9Y1iCqFem5Zg
         l3GoXjtTnQQOiItSVHGBUGoMwnN8eugOdgyQxLeJmoTUQSdIUl/kb2Y5NwUHclTMTxPU
         NqyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEJEhCqas+8txYZxySSxTpPMvWZO3oWap6IswsmlSQPMjdDIElG/Q1UsXljtPJaIaRyzM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5xVnrO4GhcX/AgqNqvaCDoYvKeVDuvQGutIoOrTIwhQZgbdEL
	OI38rEZNM6R8ZDJb3/7ZB3vji6XGqNsn5lGUTgiJ5cIZK8ue2U03nYdKiNt4T0s=
X-Gm-Gg: ASbGncuqJvRXb0GroLaXgtSSIeLGEDpu8GJb2JkOQ45J3vLTdWy3Lb9g0dtYtFuzwZg
	rWYmoDmU7zJbOG9+J51rpevi3fuqhvNhHIJhwSfBKkuXBetSS3NBq32unHKMbVDfl99TOcFLI4g
	XcM0hNm+s7rHvtegDdZPN5QsqXobJWa+50FvuLHZSBBVxXOxUyl6Jbpsl41aWOamGm1y5x5x7Dy
	P4XiswL64ZJOWA2Qb6V9CQbIPZSUhYU4bbBLwePiG9dvmpY+hMO/7azVrnj4lz8vOye
X-Google-Smtp-Source: AGHT+IGQsKQI4LrL1qdpFjuY9ZWEttHxIv9pv69yZaLOwftdrmmCEXmYM32sp7WuieWtkMyPIHFCuw==
X-Received: by 2002:a05:600c:a0a:b0:434:a04d:1670 with SMTP id 5b1f17b1804b1-436e25548e3mr2817985e9.0.1736537065429;
        Fri, 10 Jan 2025 11:24:25 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e37d11csm5313117f8f.16.2025.01.10.11.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 11:24:24 -0800 (PST)
Date: Fri, 10 Jan 2025 20:24:22 +0100
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leonro@nvidia.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, aik@amd.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, daniel.vetter@ffwll.ch,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 01/12] dma-buf: Introduce dma_buf_get_pfn_unlocked()
 kAPI
Message-ID: <Z4Fz5oiia1JGWIgG@phenom.ffwll.local>
Mail-Followup-To: Xu Yilun <yilun.xu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leonro@nvidia.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, aik@amd.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <20250107142719.179636-2-yilun.xu@linux.intel.com>
 <b1f3c179-31a9-4592-a35b-b96d2e8e8261@amd.com>
 <20250108132358.GP5556@nvidia.com>
 <f3748173-2bbc-43fa-b62e-72e778999764@amd.com>
 <20250108145843.GR5556@nvidia.com>
 <5a858e00-6fea-4a7a-93be-f23b66e00835@amd.com>
 <20250108162227.GT5556@nvidia.com>
 <Z368Mmxjqa4U0jHK@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z368Mmxjqa4U0jHK@yilunxu-OptiPlex-7050>
X-Operating-System: Linux phenom 6.12.3-amd64 

On Thu, Jan 09, 2025 at 01:56:02AM +0800, Xu Yilun wrote:
> > > > 5) iommufd and kvm are both using CPU addresses without DMA. No
> > > > exporter mapping is possible
> > > 
> > > We have customers using both KVM and XEN with DMA-buf, so I can clearly
> > > confirm that this isn't true.
> > 
> > Today they are mmaping the dma-buf into a VMA and then using KVM's
> > follow_pfn() flow to extract the CPU pfn from the PTE. Any mmapable
> > dma-buf must have a CPU PFN.
> 
> Yes, the final target for KVM is still the CPU PFN, just with the help
> of CPU mapping table.
> 
> I also found the xen gntdev-dmabuf is calculating pfn from mapped
> sgt.

See the comment, it's ok because it's a fake device with fake iommu and
the xen code has special knowledge to peek behind the curtain.
-Sima
 
> From Christion's point, I assume only sgl->dma_address should be
> used by importers but in fact not. More importers are 'abusing' sg dma
> helpers.
> 
> That said there are existing needs for importers to know more about the
> real buffer resource, for mapping, or even more than mapping,
> e.g. dmabuf_imp_grant_foreign_access()
-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

