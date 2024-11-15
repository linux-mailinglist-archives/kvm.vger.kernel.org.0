Return-Path: <kvm+bounces-31941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974179CEE5F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 16:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51D222842FA
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 15:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1E51D47C7;
	Fri, 15 Nov 2024 15:20:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A129B16F282;
	Fri, 15 Nov 2024 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731684058; cv=none; b=tqIteR/ayanlukIY2mmaIPNzrXlRiJcsSJHnqnVX6gLF1waGhCfLlKyucgezFH7bIn7wrafP7sqTcLKsrPuITW7jFd7nI7LdxGVLxEugpBsVBXHeSCVE+cQv+fEoHQs0a94fotSvcL7W7Y0njOMUM/EzE/dMrorJRdDN1cn8iVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731684058; c=relaxed/simple;
	bh=JbWDWW5tcxAeACyNg24Ej49B8z9HdbzJKyezVhofJkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FWBAJQxS+ntfQ6pyOar1zcNc9HFOUnBCNAMmba7ZL5aou6WZ8ydX0w74DI3diWg+53+snRkYk68vP+hpEtvXXHNNQGBCnYNKVyv3wwn19LqrdDGpRsq6ov9lzt9Nrw//C81+CloxZU+pOYYXBjOXuH8cRBGAH3Vhr04ouPFm8Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA1C01424;
	Fri, 15 Nov 2024 07:21:18 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9488D3F6A8;
	Fri, 15 Nov 2024 07:20:38 -0800 (PST)
Message-ID: <ddd40bc3-7f2a-43c2-8918-a10c63bd05ba@arm.com>
Date: Fri, 15 Nov 2024 15:20:36 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/15] iommu/riscv: report iommu capabilities
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org,
 will@kernel.org, anup@brainfault.org, atishp@atishpatra.org,
 tglx@linutronix.de, alex.williamson@redhat.com, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-21-ajones@ventanamicro.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20241114161845.502027-21-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/11/2024 4:18 pm, Andrew Jones wrote:
> From: Tomasz Jeznach <tjeznach@rivosinc.com>
> 
> Report RISC-V IOMMU capabilities required by VFIO subsystem
> to enable PCIe device assignment.

IOMMU_CAP_DEFERRED_FLUSH has nothing at all to do with VFIO. As far as I 
can tell from what's queued, riscv_iommu_unmap_pages() isn't really 
implementing the full optimisation to get the most out of it either.

I guess IOMMU_CAP_CACHE_COHERENCY falls out of the assumption of a 
coherent IOMMU and lack of PBMT support making everything implicitly 
IOMMU_CACHE all the time whether you want it or not, but clarifying that 
might be nice (especially since there's some chance that something will 
eventually come along to break it...)

Thanks,
Robin.

> Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   drivers/iommu/riscv/iommu.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> index 8a05def774bd..3fe4ceba8dd3 100644
> --- a/drivers/iommu/riscv/iommu.c
> +++ b/drivers/iommu/riscv/iommu.c
> @@ -1462,6 +1462,17 @@ static struct iommu_group *riscv_iommu_device_group(struct device *dev)
>   	return generic_device_group(dev);
>   }
>   
> +static bool riscv_iommu_capable(struct device *dev, enum iommu_cap cap)
> +{
> +	switch (cap) {
> +	case IOMMU_CAP_CACHE_COHERENCY:
> +	case IOMMU_CAP_DEFERRED_FLUSH:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>   static int riscv_iommu_of_xlate(struct device *dev, const struct of_phandle_args *args)
>   {
>   	return iommu_fwspec_add_ids(dev, args->args, 1);
> @@ -1526,6 +1537,7 @@ static void riscv_iommu_release_device(struct device *dev)
>   static const struct iommu_ops riscv_iommu_ops = {
>   	.pgsize_bitmap = SZ_4K,
>   	.of_xlate = riscv_iommu_of_xlate,
> +	.capable = riscv_iommu_capable,
>   	.identity_domain = &riscv_iommu_identity_domain,
>   	.blocked_domain = &riscv_iommu_blocking_domain,
>   	.release_domain = &riscv_iommu_blocking_domain,

