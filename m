Return-Path: <kvm+bounces-66340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D60CD016D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 14:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF684305A103
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44FC4322B95;
	Fri, 19 Dec 2025 13:39:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EB4320CA8
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151584; cv=none; b=eqxcTqFFE0VXTnxac+mFkylbdDeB4TBHRIQN+Ziow9k+QWn3K4RlyB4OD8QxGu+29IGgTizBwBf20H0vxH/BTUEoXWj9B/McHugehNki8+R6/yJqIsu7L0AFyipKMX0QVKX80J9qEQb94GkF9KmiWo4TXkGlhj2oQlb/xrSULYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151584; c=relaxed/simple;
	bh=yrnEo/iFh6LxFGW3M4Eejbp1T9k2pjI267gslL3ql9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=N/9cqmDTRWphLZ1IqTpyjn8350dZesvkEiypGlxTqtPbho1vWPrHsY4U6C9uTnFO548+8sV8PNmlXHnr5v8VtM86gB+91sLIQGrkPuC1BROo4T6poaKAaTXGlDV/1bOLjOkeLTIvoO4mcMfVMshmKcH9NNp7SRaFfW3857X4aRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3ECCDFEC;
	Fri, 19 Dec 2025 05:39:34 -0800 (PST)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 085403F73F;
	Fri, 19 Dec 2025 05:39:38 -0800 (PST)
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
Date: Fri, 19 Dec 2025 13:38:50 +0000
Message-ID: <aURFlcm6szeSfLmH@devkitleo>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210173024.561160-2-maz@kernel.org>
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Dec 10, 2025 at 05:30:19PM +0000, Marc Zyngier wrote:
> The current XN implementation is tied to the EL2 translation regime,
> and fall flat on its face with the EL2&0 one that is used for hVHE,
> as the permission bit for privileged execution is a different one.
> 
> Fixes: 6537565fd9b7f ("KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index fc02de43c68dd..be68b89692065 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -87,7 +87,15 @@ typedef u64 kvm_pte_t;
>  
>  #define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
>  
> -#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
> +
> +#define KVM_PTE_LEAF_ATTR_HI_S1_XN					\
> +	({ cpus_have_final_cap(ARM64_KVM_HVHE) ?			\
> +			(__KVM_PTE_LEAF_ATTR_HI_S1_UXN |		\
> +			 __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :		\
> +			__KVM_PTE_LEAF_ATTR_HI_S1_XN; })
>  
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
>  
> -- 
> 2.47.3
> 

Cool,
Is this according to the following in Arm ARM?

Figure D8-16
Stage 1 attribute fields in VMSAv8-64 Block and Page descriptors

Thanks!
Leo

