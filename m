Return-Path: <kvm+bounces-34038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEAB49F604D
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 09:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07DEA169AA9
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 08:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5B5189B9F;
	Wed, 18 Dec 2024 08:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="jwMYFleB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11ACC14F9E2
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 08:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734511216; cv=none; b=FHaLgO02mZhJBO32bfCh1mE8+a7PEjFPUyVPto3KbDUWXcJ45mJw3oTpy4kwO+CmHs2ymW3MRbVzpPlNxm/GnGKtAEKuuOH7mDBs+rsiD99+RlWPd8yxZw9c/0/0GaeBSPtJwAk5NuwY2vIh+sRhnRtAY/6xs8ZaAIhNV9tKX8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734511216; c=relaxed/simple;
	bh=MV6KyVfXoz6PKOZWMTqYD+2szsG/qGUie4tUdM4jbnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EU3jvzzyn3fQa22Ii1d13I355J0Zfu0t1U7jzyPJ+V5roM0+nfs8aM9aPFcbj5SWu626jP08nXvvSxokuh1H/xowIdgko8ClnuA8Ax6Wkr2rh0hgDnRlRsc5GJiXhyjpCAMD+S2twWmh9bRNaoJd5N+YoH4lXMTMpZ7MlsXNF64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=jwMYFleB; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p54921e31.dip0.t-ipconnect.de [84.146.30.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 0E86A2C1E66;
	Wed, 18 Dec 2024 09:40:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1734511213;
	bh=MV6KyVfXoz6PKOZWMTqYD+2szsG/qGUie4tUdM4jbnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jwMYFleBfIH5EjtdopEG/WNOvS6eQh8D3OcZO1Wj8ZvCyPCcOIiNrumrQk4OhXsHT
	 qKLufnH0qpRJlNDW1YiVLK0wbx0jslFfBhitJokECoashxDH75zWKiloFer2QwNzCO
	 KxQ40EdBXw7PfbzijsGydBKZj3jTo3b0nKkZL3yXh5+e9I/oWayJ5H+AlEYUq7gqW+
	 V6etIZb71h68c9fZLxSE1YKaBkHDai0VNJmVzz9RBqu3r5a22qWyJZHUk0bQTFOT4F
	 fYQ83+/myzHP4tnuMod9kRd0b9QaXekuiMXICmcsVPhUNTk7/bhQ+cTiIamMYixaO9
	 N5gvZXAEWLdGA==
Date: Wed, 18 Dec 2024 09:40:11 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Yi Liu <yi.l.liu@intel.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v6 0/7] Support attaching PASID to the blocked_domain
Message-ID: <Z2KKaxftA52hAXN3@8bytes.org>
References: <20241204122928.11987-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204122928.11987-1-yi.l.liu@intel.com>

On Wed, Dec 04, 2024 at 04:29:21AM -0800, Yi Liu wrote:
> Jason Gunthorpe (1):
>   iommu/arm-smmu-v3: Make the blocked domain support PASID
> 
> Yi Liu (6):
>   iommu: Prevent pasid attach if no ops->remove_dev_pasid
>   iommu: Consolidate the ops->remove_dev_pasid usage into a helper
>   iommu: Detaching pasid by attaching to the blocked_domain
>   iommu/vt-d: Make the blocked domain support PASID
>   iommu/amd: Make the blocked domain support PASID
>   iommu: Remove the remove_dev_pasid op
> 
>  drivers/iommu/amd/iommu.c                   | 10 +++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 +++----
>  drivers/iommu/intel/iommu.c                 | 15 ++++++---
>  drivers/iommu/iommu.c                       | 35 +++++++++++++--------
>  include/linux/iommu.h                       |  5 ---
>  5 files changed, 48 insertions(+), 29 deletions(-)

Applied, thanks.

