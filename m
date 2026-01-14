Return-Path: <kvm+bounces-68068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E46D20A99
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5F13130299E2
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C3A32D7F0;
	Wed, 14 Jan 2026 17:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fyikEMag"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A2631B833
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413143; cv=none; b=MhyuDLCibN+W/t8glRLDRLXKFuhGdyfgpegz53VFjeBodsEtKbM2S4jn40WdMmXDbfLFM+XaHvHmesZA/QsSvKBpA99bMFxRYNPNF/wIaJOb+WiN8kTa+aah6JysxuAeY9JunJFPNyZVJqLgBcT3ZNre5IqIW0dWHZKSfaO23is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413143; c=relaxed/simple;
	bh=s8UrTc392o6lgGr0L0SSPIY4h/zvAKey5JF2ZjeBBA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxIk1AKyLyTvxb5nH/IWyFfsty2ZEY0kTf55YNSJwnbzSVUiHi50KW4pDVbAyP3RGQXr3tM4GCOWFP0/S3mxn2wvJKMB1dS8uFSZv4TUncV3b3CjUiZo9Zgwg0P1hrMWjvwfLsL33ekLFS5kCmtEDlJguLojJkEBHOR8WT+cBoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fyikEMag; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c21417781so5718693a91.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 09:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768413141; x=1769017941; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pmyLXiVJv4yYyt6EQN1fkH3Mxfa9cv7lABbhV6MoYwk=;
        b=fyikEMag7Qzv++PWevUW6btBPcVLKL3VAO+vnZQnHKvTLM4fKtAYy+Rpurwn59/vCL
         DDKuS45AdONwBkohH5r9SiQ7EiyZiIm/jMwCYFtTjsdLxZ+2VsL5eLr/BAjgRSPWGEum
         aSJbPtUP1QeovCF8fi0NNNxAG/gWme8uK0z9UQa23yAUrx/3oru3NkYL8kVVU7qkjbYI
         yPoxpN725g1h2/hVyaqwSQm7IFVzlovZci6TfbS174DJ+TP87QdvNmzBtWd2K8GqrNmJ
         q1XrvjfzrVQq6XGkBJlOaQ5ivsd+Ku6ZutrUZzKI65x0YJHbpbwZm1bJkDh0drmIGH2D
         cOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413141; x=1769017941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmyLXiVJv4yYyt6EQN1fkH3Mxfa9cv7lABbhV6MoYwk=;
        b=nz9kSEWs97z/XwsNcnx2mMJRtc11YgRfLs2PJ9isxZ8k2BV/LiXube+32KJLM1qgz+
         Sb5THv7RhJD6B/gUBk6jr28HcG+dRZvo8mNEqEul9lH0sIGXVnOH2GpJbCT0yDJ7KsMo
         qptnKiZTSt5cAmt/uOvu3rEco8gLuH9EJXBhOXTvTOpZQ1fqjOo6XkUlnLXwDcoN9k9O
         SSlYwyuNcArB2jDSt5r+gAKIKVS4Q51xlP87rN8sSeX0GaGB4PIg5lKYU5QOjycXt3K4
         Rrl4C9mjLHxEPGYBXduuFX7RETVCqUlNKfmELwwssa9h/KPl+osJ8J2cN/ppEdm2DfT5
         +jaw==
X-Forwarded-Encrypted: i=1; AJvYcCWO0Lj+uWpos7bJRdDknIMxaeojzfF2jISNwiu1z2YBrbZv83BmcGLp8rY/mr1T0EhKqxA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP6zVigH08anc94kf4MCcCDvK/KWscasbo21zkMHywwY6AsOwS
	pRwNvI2NZ/3LIgC5eDVuCC7cD0eWUUXRAiA0yqoSrPVw6cWELklt22yeE4CVnZ1m2Q==
X-Gm-Gg: AY/fxX6GwX2SvQKMj1sJNHeBQGR2PROR+QFntt0a+CHHmgAqZotF+Lc/SkebdDV0SrN
	SKGfC8muJpDHAJd95dPkOpNkVgg6AzgURRiN5YQ/7DCrtZgnZciIZmmuAt+N9iDji1LSOg3OZoo
	lGIFYMnpgN3aVINa/uMZvYVSROLGpVexcrBNGsFoo/RNgIy3UsJGV9ePJE2NTbkgAj2Pw35D5sy
	eBtsg/SZ0lzP4rpP6fYhlvTi5XXMuQd6peGfu/4KPgBXv8HTsPdp9AOm82n59fhNcmnn8C2VVwN
	uZV3CncIPxBToeWyCk21XTHoTPivQxG9TuXBxKpIwTIOAY9pqLKwM/KLHXgMmyM4cyIkmLvHl2v
	qEHotdBCv+ysQtXMGwhv2WzV34lnh2PyfcOFgRPITJ+Z/S7kDZddvKPCd6yZf/gQo9aKet11XkA
	Tvjkn6UgDHwBTqSbOI+JCLre3/Fak1scbU3cGjY32HycRJ
X-Received: by 2002:a17:90b:388b:b0:341:d265:1e82 with SMTP id 98e67ed59e1d1-3510b143697mr2850122a91.29.1768413141066;
        Wed, 14 Jan 2026 09:52:21 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352678af465sm86170a91.11.2026.01.14.09.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:52:19 -0800 (PST)
Date: Wed, 14 Jan 2026 17:52:15 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 3/3] vfio: selftests: Add vfio_dma_mapping_mmio_test
Message-ID: <aWfXzwN4RCSsuF3u@google.com>
References: <20260113-map-mmio-test-v2-0-e6d34f09c0bb@fb.com>
 <20260113-map-mmio-test-v2-3-e6d34f09c0bb@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113-map-mmio-test-v2-3-e6d34f09c0bb@fb.com>

On 2026-01-13 03:08 PM, Alex Mastro wrote:

> +FIXTURE_SETUP(vfio_dma_mapping_mmio_test)
> +{
> +	self->iommu = iommu_init(variant->iommu_mode);
> +	self->device = vfio_pci_device_init(device_bdf, self->iommu);
> +	self->iova_allocator = iova_allocator_init(self->iommu);
> +	self->bar = largest_mapped_bar(self->device);
> +
> +	if (!self->bar)
> +		SKIP(return, "No mappable BAR found on device %s", device_bdf);
> +
> +	if (self->bar->info.size < 2 * getpagesize())
> +		SKIP(return, "BAR too small (size=0x%llx)", self->bar->info.size);

It seems like the selftest should only skip map_partial_bar if the BAR
is less than 2 pages. map_full_bar would still be a valid test to run.

