Return-Path: <kvm+bounces-67766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88499D135D8
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:58:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D60C13061DEB
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4582D9EDB;
	Mon, 12 Jan 2026 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hAOuj8RG"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E5F2BE057
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229542; cv=none; b=bItd5IyN97mRHw9iE4i5D6e2X/Pi1FwAE+gmygUVvA16/3m8O7apTMD60MbV8nAbQ+Sil3/OHmd+KDTWdJlI2cIHxCJT6SjH1+fHYIuhUORtM+BPAUTpDyF75YbQm8a/iso/3eqFflJbzWr1z0LsfVwygAmiEVXiZWGqV/RNWvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229542; c=relaxed/simple;
	bh=q2mR/OHTn2UbcE3dRB5yeU0YZiEWina5M+3+/TonMyk=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXyBNjywSjB7oE0LiZCwYo2AjJiUpr03/O9gagh5DETOVYZLmg1tOSwpNx9VZwnVYMqyOQQFl4Cq8YxgJfoKsk8pNX1oLBmS0dsSsmJF1S49AP3oNMq7KO31BNN1Zrw2BkYkfR/gVdbRfUH5cl6Kom86iwQcQeYY4zGNsjFhOfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hAOuj8RG; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=z0I/IuDr5e/p5VG7rg1G1pUt6aLWSS3AqPMeVbUXfoA=;
	b=hAOuj8RGzhlXWeW4YZ8AkAKAAXFCTN8VCU5tsGVDAAjOuMLcKuQlv0O+f33Ng9/IQI5FrGl+2
	nqoExJHHRELmDBuQjZqMjEPazcAMdHlzLtlkR8s7O0ZPh6xeZ8GMWhXWB5/fLfis11Gd7StvTaP
	z7ArLwm/Mv1QhZfG/WNmxwA=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dqZzY3pChz1vp0g;
	Mon, 12 Jan 2026 22:50:01 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqb1n676JzHnGfH;
	Mon, 12 Jan 2026 22:51:57 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A59340569;
	Mon, 12 Jan 2026 22:52:14 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:52:13 +0000
Date: Mon, 12 Jan 2026 14:52:11 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v3 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Message-ID: <20260112145211.0000333c@huawei.com>
In-Reply-To: <20260109170400.1585048-11-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-11-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:42 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> As part of booting the system and initialising KVM, create and
> populate a mask of the implemented PPIs. This mask allows future PPI
> operations (such as save/restore or state, or syncing back into the
> shadow state) to only consider PPIs that are actually implemented on
> the host.
> 
> The set of implemented virtual PPIs matches the set of implemented
> physical PPIs for a GICv5 host. Therefore, this mask represents all
> PPIs that could ever by used by a GICv5-based guest on a specific
> host.
> 
> Only architected PPIs are currently supported in KVM with
> GICv5. Moreover, as KVM only supports a subset of all possible PPIS
> (Timers, PMU, GICv5 SW_PPI) the PPI mask only includes these PPIs, if
> present. The timers are always assumed to be present; if we have KVM
> we have EL2, which means that we have the EL1 & EL2 Timer PPIs. If we
> have a PMU (v3), then the PMUIRQ is present. The GICv5 SW_PPI is
> always assumed to be present.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
One minor comment below.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 23d0a495d855e..85f9ee5b0ccad 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -8,6 +8,8 @@
>  
>  #include "vgic.h"
>  
> +static struct vgic_v5_ppi_caps *ppi_caps;
> +
>  /*
>   * Probe for a vGICv5 compatible interrupt controller, returning 0 on success.
>   * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
> @@ -53,3 +55,37 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  
>  	return 0;
>  }
> +
> +/*
> + * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine which
> + * ones are, and generate a mask.
> + */
> +void vgic_v5_get_implemented_ppis(void)
> +{
> +	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
> +		return;
> +
> +	/* Never freed again */
> +	ppi_caps = kzalloc(sizeof(*ppi_caps), GFP_KERNEL);
> +	if (!ppi_caps)
> +		return;
> +
> +	ppi_caps->impl_ppi_mask[0] = 0;
> +	ppi_caps->impl_ppi_mask[1] = 0;

You just kzalloc() the structure so these are already 0.  Given
it's so close I'm not sure there is any 'documentation' value in setting
them here.

> +
> +	/*
> +	 * If we have KVM, we have EL2, which means that we have support for the
> +	 * EL1 and EL2 P & V timers.
> +	 */
> +	ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_CNTHP);
> +	ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_CNTV);
> +	ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_CNTHV);
> +	ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_CNTP);
> +
> +	/* The SW_PPI should be available */
> +	ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_SW_PPI);
> +
> +	/* The PMUIRQ is available if we have the PMU */
> +	if (system_supports_pmuv3())
> +		ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
> +}

