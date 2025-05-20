Return-Path: <kvm+bounces-47128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C76CFABD9DB
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 178033ADF1E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 13:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3512244663;
	Tue, 20 May 2025 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szO+qO3d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E7D242D9A
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747748798; cv=none; b=FE9VdZgls8YR8lGWLbQEdnfbh3AGDCTuJDPb1YWxbzOXtPTEy+Lf8gXVslzWVOEDdB/HoxblqiBVRFJjIm0wN78YUmc4/gFSGVmtKxKCGPW3g04a5gTfNah8smE7tQrez55tnFRE9cz46Xb39CPFda5nb6TE5N7KplwB8r3MIEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747748798; c=relaxed/simple;
	bh=EmO/O0CjHbDCkV6qxr+vwvS7jSVGPFTTNExecXLuFrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fE7SZacNo6bpJiiMyYHE3ErqcK7F5c+cZfpXXL/8GRrnfFhidwT2Ylz5Fa0HEEwIyJvGu1xRkLlweJsP7xn3+kjzCltHQkC6iz0DU6+einjAj82vv50BWKd88PbBa43HaovQP0aCqG/IxuXBqPeFyhkpdVJ/t1UkqMD9gWhcGHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szO+qO3d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA2DC4CEE9;
	Tue, 20 May 2025 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747748797;
	bh=EmO/O0CjHbDCkV6qxr+vwvS7jSVGPFTTNExecXLuFrw=;
	h=From:To:Cc:Subject:Date:From;
	b=szO+qO3dtU+T2IBdOZC30yWH7DIkEIoACIqyQQ0I2gLJKe0qvGh1rUMjMTKv+a6s1
	 CpUrxNeIdiPvaplAQTzX8u6qPu9TPaw5t/ng7/0tf0YNxVahnG0iCu4G0tW6MoE8/S
	 RKow48p6CD6hsqzhDoDfdl8mYD+VajsWQp+84p6zfzMAXiSWNtdHnwromXxhND3eos
	 O3+YZPkDfY4tFSaRfvWNjrTpaLOsWwDII/Gc3Yaji9q9L6JgvWd8BywpoxXClR6laA
	 Hnzhg/l56xo3Dygemaltgpx5wtspyozBQ0n3xOsg2PYEFgI/31Lj6iAn0dPfDLgXSx
	 pg980LCSjY/ag==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kvm@vger.kernel.org,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH vfio-next 0/3] mlx5 VFIO PCI DMA conversion
Date: Tue, 20 May 2025 16:46:29 +0300
Message-ID: <cover.1747747694.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Alex,

This series presents subset of new DMA-API patchset [1] specific
for VFIO subsystem, with some small changes:
1. Change commit message in first patch.
2. Removed WARN_ON_ONCE DMA_NONE checks from third patch.

------------------------------------------------------------------
It is based on Marek's dma-mapping-for-6.16-two-step-api branch, so merging
now will allow us to reduce possible rebase errors in mlx5 vfio code and give
enough time to start to work on second driver conversion. Such conversion will
allow us to generalize the API for VFIO kernel drivers, in similar way that
was done for RDMA, HMM and block layers.

Thanks

[1] [PATCH v10 00/24] Provide a new two step DMA mapping API
https://lore.kernel.org/all/cover.1745831017.git.leon@kernel.org/

Leon Romanovsky (3):
  vfio/mlx5: Explicitly use number of pages instead of allocated length
  vfio/mlx5: Rewrite create mkey flow to allow better code reuse
  vfio/mlx5: Enable the DMA link API

 drivers/vfio/pci/mlx5/cmd.c  | 371 +++++++++++++++++------------------
 drivers/vfio/pci/mlx5/cmd.h  |  35 ++--
 drivers/vfio/pci/mlx5/main.c |  87 ++++----
 3 files changed, 235 insertions(+), 258 deletions(-)

-- 
2.49.0


