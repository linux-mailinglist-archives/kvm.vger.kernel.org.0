Return-Path: <kvm+bounces-31459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A45A29C3EB6
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:50:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A99F281C84
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA96219D091;
	Mon, 11 Nov 2024 12:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkJuLSHy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA1919CD0E;
	Mon, 11 Nov 2024 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329358; cv=none; b=jQtne7Tu7tN9y8TcN0QkeAw3ki+BFWjccj2e/FYo+N0FzKD3d1RkISdEFyRe4ZuEA9HlFYFsGMNKZC9a8kCSgOBmgWUjCaCLnDm1YUcPUNi5LQo611bRZwcx7MiWuvEnGNet09eebZhVph1l4BFi1fTY6sDgLJyocvGgPLd3d6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329358; c=relaxed/simple;
	bh=DdPm7AxEHQ6dfU3WfACtcr6a+uPBdfir/vELQ7rFD7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOkncf/stXgmSE1hbLOIW5gl08t5CkXsweMbPAOOuWVNtHh104dhvugcQZpWKGQJGbYNSvZuJjY1J15iVMWOJglSm2Tro2qnzW9itO40N1qzp3SelDLbYKdiNTX6CePyXTZuod7JQEt25TS3u1Ngwz1jfmzYJ4c6ZV5KPRSoj44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkJuLSHy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34373C4CECF;
	Mon, 11 Nov 2024 12:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731329356;
	bh=DdPm7AxEHQ6dfU3WfACtcr6a+uPBdfir/vELQ7rFD7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZkJuLSHyS/aHzlOCXxnaOpUXaWquX1G07IRS99kYT1iruTbuUN4eP1ju0z7JYlthe
	 PYpm4s1j5hg5E9bOrlJsxc8S7El5dZr+R0s/EEDK0i4XS5UTdUjnGNyqt7/Snz56sd
	 rrQQKEKhtQhgt58wl9C81Wpfa3Gf1cpO06FdupPxnFuub8WQF2qxb5PV7+LuVIW0sm
	 iuvTZfwR5uw8xmx6nOJKT9HQ1Y4DYCR5uROQ6Qk/AoT7Htnnlz7dZae0Ty44yL9N7g
	 d6Yilcxco7tS8Z3xmjdwb35tnqBu4du87IRR2lrmka0sDb8PIq1LW+XlcQqdWAqtSE
	 mXbKUXEI3DNUQ==
Date: Mon, 11 Nov 2024 12:49:10 +0000
From: Will Deacon <will@kernel.org>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, jgg@nvidia.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, alex.williamson@redhat.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v4 12/13] iommu/arm-smmu-v3: Make set_dev_pasid() op
 support replace
Message-ID: <20241111124909.GB19874@willie-the-truck>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-13-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104131842.13303-13-yi.l.liu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Nov 04, 2024 at 05:18:41AM -0800, Yi Liu wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> set_dev_pasid() op is going to be enhanced to support domain replacement
> of a pasid. This prepares for this op definition.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 9 +++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 2 +-
>  3 files changed, 5 insertions(+), 8 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

