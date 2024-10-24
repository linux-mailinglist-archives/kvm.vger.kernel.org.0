Return-Path: <kvm+bounces-29617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AC5D9AE204
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEBD0281A72
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552481C4A16;
	Thu, 24 Oct 2024 10:03:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208DA1BE223
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 10:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729764226; cv=none; b=rPB9I9+o9fd3DN7OD4mVd3W+sRTyael7dgcWMe3N2sfqaqfzopmHWX2Ma7ta7fr15TcJgMzCFI361sGU+eE6SKUOW22LNiLc1Pb0g9YgimTDIQEVD0vUWxVBZVoptrb0oJq4miIemyLkzrE4W9EAfck8TGM5wVpVbLC7WjSbByM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729764226; c=relaxed/simple;
	bh=FgP4I+aVtPPs74kssaZdbl/o/cecaTCT63kyAzjejC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0vZhy2EP+jmLGcyAbO8T992c6YyJVbmY9y8xsblVmU5eDxqFUIoVmh7oFy42SUHORFVTdwJ2vPH5+wMzQVvb011T6K/CaJNR14addIAnjtepecJmTE68D7r2RWzzhoGRwPoPeWOCLdjQ3pY51+lHc3iP+feoM9p4QDe6Drtj0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41098339;
	Thu, 24 Oct 2024 03:04:12 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 663FD3F71E;
	Thu, 24 Oct 2024 03:03:41 -0700 (PDT)
Date: Thu, 24 Oct 2024 11:03:36 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 08/37] KVM: arm64: Correctly access TCR2_EL1, PIR_EL1,
 PIRE0_EL1 with VHE
Message-ID: <20241024100336.GA1382116@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-9-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:16PM +0100, Marc Zyngier wrote:
> For code that accesses any of the guest registers for emulation
> purposes, it is crucial to know where the most up-to-date data is.
> 
> While this is pretty clear for nVHE (memory is the sole repository),
> things are a lot muddier for VHE, as depending on the SYSREGS_ON_CPU
> flag, registers can either be loaded on the HW or be in memory.
> 
> Even worse with NV, where the loaded state is by definition partial.
> 
> For these reasons, KVM offers the vcpu_read_sys_reg() and
> vcpu_write_sys_reg() primitives that always do the right thing.
> However, these primitive must know what register to access, and
> this is the role of the __vcpu_read_sys_reg_from_cpu() and
> __vcpu_write_sys_reg_to_cpu() helpers.
> 
> As it turns out, TCR2_EL1, PIR_EL1, PIRE0_EL1 and not described
> in the latter helpers, meaning that the AT code cannot use them
> to emulate S1PIE.
> 
> Add the three registers to the (long) list.
> 
> Fixes: 86f9de9db178 ("KVM: arm64: Save/restore PIE registers")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Joey Gouly <joey.gouly@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 329619c6fa961..1adf68971bb17 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1030,6 +1030,9 @@ static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
>  	case TTBR0_EL1:		*val = read_sysreg_s(SYS_TTBR0_EL12);	break;
>  	case TTBR1_EL1:		*val = read_sysreg_s(SYS_TTBR1_EL12);	break;
>  	case TCR_EL1:		*val = read_sysreg_s(SYS_TCR_EL12);	break;
> +	case TCR2_EL1:		*val = read_sysreg_s(SYS_TCR2_EL12);	break;
> +	case PIR_EL1:		*val = read_sysreg_s(SYS_PIR_EL12);	break;
> +	case PIRE0_EL1:		*val = read_sysreg_s(SYS_PIRE0_EL12);	break;
>  	case ESR_EL1:		*val = read_sysreg_s(SYS_ESR_EL12);	break;
>  	case AFSR0_EL1:		*val = read_sysreg_s(SYS_AFSR0_EL12);	break;
>  	case AFSR1_EL1:		*val = read_sysreg_s(SYS_AFSR1_EL12);	break;
> @@ -1076,6 +1079,9 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
>  	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	break;
>  	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	break;
>  	case TCR_EL1:		write_sysreg_s(val, SYS_TCR_EL12);	break;
> +	case TCR2_EL1:		write_sysreg_s(val, SYS_TCR2_EL12);	break;
> +	case PIR_EL1:		write_sysreg_s(val, SYS_PIR_EL12);	break;
> +	case PIRE0_EL1:		write_sysreg_s(val, SYS_PIRE0_EL12);	break;
>  	case ESR_EL1:		write_sysreg_s(val, SYS_ESR_EL12);	break;
>  	case AFSR0_EL1:		write_sysreg_s(val, SYS_AFSR0_EL12);	break;
>  	case AFSR1_EL1:		write_sysreg_s(val, SYS_AFSR1_EL12);	break;

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

