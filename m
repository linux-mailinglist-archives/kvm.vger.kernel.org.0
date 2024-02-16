Return-Path: <kvm+bounces-8870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B38857F29
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83EF61F264DA
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 14:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2260512D769;
	Fri, 16 Feb 2024 14:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="Sk58NeRY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F8F12BF24;
	Fri, 16 Feb 2024 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708093221; cv=none; b=LP5q57x9DiCmOaP5mGmaJ/1gmQr6rJgegrNOOI0mn5VMrkzExKx/4BEtf60+fdBqUkQpvX6C7lB+aK31bhrrKEzLeW6VijHmJlRo+pqPq13TLsUN8bQVHtJq+XEbW8dkGRSzPUA5mYhmbJ9MWYpCtfU4DJ7wp7IFcwZs1/rxzTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708093221; c=relaxed/simple;
	bh=bNxzB1iXQnVUL8kOxK+D7Fyr91Yu17rlVKWuwF3UjJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzJa2vajvIlULst/OXmh6xyjNLUbBmWav1o8dKH7nytWjs9e+eC7693d8XCrhVYkbdk6ctgWxlgmsTs3iIcv/8UQlTXTPjCsA+Joe96SOv4mmhfENDbiJyjL5G9e6g+pZmV5IPR4ZO61fh2yA2tWEw9nA06gdw2NOu6UtKM4Anw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=Sk58NeRY; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe0c3c.dip0.t-ipconnect.de [79.254.12.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id A60FC1C462F;
	Fri, 16 Feb 2024 15:20:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1708093217;
	bh=bNxzB1iXQnVUL8kOxK+D7Fyr91Yu17rlVKWuwF3UjJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sk58NeRYOzA7VCTE6M4STJkXGudBbVh3xWbOFXBaIE0CIjO0bDoba2613m3xMEJkf
	 Dz9zn4e+gu4809m5AYYcGtvASkTplVee+A0Zko251ZSTNH+aj9jdEY9FZoGz+O7xYu
	 VWzFSTmzl3vvTkciReKFX2RIIuJ5at2pzeVqKE0ym3WXBiDY9u8pZRGUEy7KsSaZj+
	 MgDtC2gXI2gIz4wpzn4CrnG4gGD3QC5zJnT67HcX/KeUdk8hYKUCfT4NsTZukP3aD0
	 Z3VATvpm0DXr3vH6k+1ivJ6fGqZXzl8fs+J/mcWLXtOZF3aRzoQRkxT0DfRZwPgoo+
	 TTG0g4f3RIRkA==
Date: Fri, 16 Feb 2024 15:20:16 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Joel Granados <j.granados@samsung.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 00/16] iommu: Prepare to deliver page faults to user
 space
Message-ID: <Zc9vIMa_DarGHVZq@8bytes.org>
References: <20240212012227.119381-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240212012227.119381-1-baolu.lu@linux.intel.com>

On Mon, Feb 12, 2024 at 09:22:11AM +0800, Lu Baolu wrote:
> Lu Baolu (16):
>   iommu: Move iommu fault data to linux/iommu.h
>   iommu/arm-smmu-v3: Remove unrecoverable faults reporting
>   iommu: Remove unrecoverable fault data
>   iommu: Cleanup iopf data structure definitions
>   iommu: Merge iopf_device_param into iommu_fault_param
>   iommu: Remove iommu_[un]register_device_fault_handler()
>   iommu: Merge iommu_fault_event and iopf_fault
>   iommu: Prepare for separating SVA and IOPF
>   iommu: Make iommu_queue_iopf() more generic
>   iommu: Separate SVA and IOPF
>   iommu: Refine locking for per-device fault data management
>   iommu: Use refcount for fault data access
>   iommu: Improve iopf_queue_remove_device()
>   iommu: Track iopf group instead of last fault
>   iommu: Make iopf_group_response() return void
>   iommu: Make iommu_report_device_fault() return void

Applied, thanks Baolu.

