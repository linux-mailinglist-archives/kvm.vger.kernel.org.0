Return-Path: <kvm+bounces-38708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C53A3DC09
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B4F33BE553
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CD433985;
	Thu, 20 Feb 2025 14:05:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253941BC073
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060305; cv=none; b=dm1HeAf8SyvKbAHy3gciBGdiBsT1QjGYDDJb51AvmrdPPqXEVIyjA1FQTIlx9+O7/V3pmbh7NuqWjj6Pl4DwXopI4Q0xbD+ONHPawjg8N1Y8QMc0Vuf+V1s0XG+hVVEZ3JT0lyaJYigIampzezfy4rdbrVnw2VnhcEvb2DdK6m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060305; c=relaxed/simple;
	bh=DsUB/d1181LQ8ifJXchCQ3n6n+oj+LmWRm/KiQipQIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5olwNyozIn9uSx4vrUAgAqAKpAGS3GR4QZYkIwowpcdihc0X3qxzDEsHP82DWsYawDusUtnDfZ0eA2qidcgJZbSxWUUTeRnIw192RcTDN9KpbXA4aZRAqPQXQ7KMDU9EAb/y+D8il6f0wlEOhbcGIfFprESPFQMFGYucCRPniA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B1EE16F3;
	Thu, 20 Feb 2025 06:05:21 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD4383F59E;
	Thu, 20 Feb 2025 06:05:01 -0800 (PST)
Date: Thu, 20 Feb 2025 14:04:59 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: Re: [PATCH v2 00/14] KVM: arm64: NV userspace ABI
Message-ID: <20250220140459.GB2562076@e124191.cambridge.arm.com>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>

On Thu, Feb 20, 2025 at 01:48:53PM +0000, Marc Zyngier wrote:
> Since the previous incarnation of the ABI was proved to be subtly
> wrong, I have reworked it to be more in line with the current way KVM
> operates.
> 
> No more late NV-specific adjustment nor writable ID_AA64MMFR0_EL1.VH.
> The NV configuration is now entirely selected from the vcpu flags.
> I've preserved the KVM_ARM_VCPU_EL2 flag which enables NV with VHE,
> and added KVM_ARM_VCPU_EL2_E2H0 which alters the NV behaviour to only
> allow nVHE guests without recursive NV support.
> 
> This series is actually very little new code. The bulk of it is
> converting the feature downgrade to be per-idreg, essentially going
> back to the state before 44241f34fac96 ("KVM: arm64: nv: Use accessors
> for modifying ID registers"), only slightly modernised. This then
> becomes part of the reset value computing.
> 
> The rest is simply what you'd expect in terms of being able to write
> the ID_AA64MMFR4_EL1.NV_frac field, making the correct bits RES0 when
> needed, probing for capabilities and handling the init flags.
> 
> Patches on top of -rc3, with the integration branch at the usual
> location.
> 
> * From v1 [1]
> 
>   - Fixed mishandling of ID_UNALLOCATED(), resulting in extra
>     consolidation and simplify the macro maze a bit
> 
>   - Picked up Oliver's RBs (thanks!)
> 
>   - Rebased on top of -rc3
> 
> [1] https://lore.kernel.org/r/20250215173816.3767330-1-maz@kernel.org
> 
> Marc Zyngier (14):
>   arm64: cpufeature: Handle NV_frac as a synonym of NV2
>   KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest and userspace
>   KVM: arm64: Mark HCR.EL2.E2H RES0 when ID_AA64MMFR1_EL1.VH is zero
>   KVM: arm64: Mark HCR.EL2.{NV*,AT} RES0 when ID_AA64MMFR4_EL1.NV_frac
>     is 0
>   KVM: arm64: Advertise NV2 in the boot messages
>   KVM: arm64: Consolidate idreg callbacks
>   KVM: arm64: Make ID_REG_LIMIT_FIELD_ENUM() more widely available
>   KVM: arm64: Enforce NV limits on a per-idregs basis
>   KVM: arm64: Move NV-specific capping to idreg sanitisation
>   KVM: arm64: Allow userspace to limit NV support to nVHE
>   KVM: arm64: Make ID_AA64MMFR4_EL1.NV_frac writable
>   KVM: arm64: Advertise FEAT_ECV when possible
>   KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
>   KVM: arm64: Document NV caps and vcpu flags
> 
>  Documentation/virt/kvm/api.rst      |  14 +-
>  arch/arm64/include/asm/kvm_host.h   |   2 +-
>  arch/arm64/include/asm/kvm_nested.h |   1 +
>  arch/arm64/include/uapi/asm/kvm.h   |   1 +
>  arch/arm64/kernel/cpufeature.c      |  15 +-
>  arch/arm64/kvm/arm.c                |  11 +-
>  arch/arm64/kvm/nested.c             | 285 +++++++++++++++-------------
>  arch/arm64/kvm/sys_regs.c           |  44 ++---
>  arch/arm64/kvm/sys_regs.h           |  10 +
>  include/uapi/linux/kvm.h            |   2 +
>  10 files changed, 217 insertions(+), 168 deletions(-)
> 

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

