Return-Path: <kvm+bounces-48219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B305ACBD57
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 00:29:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA635173A49
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 22:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E86D253932;
	Mon,  2 Jun 2025 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dLkDnC/k"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992681CAA7D;
	Mon,  2 Jun 2025 22:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748903337; cv=none; b=ZLGst31l65zI2XSP+gFVO98yBKwRNKpXPw3FCfLALIKljvz/PJJZDT11CXqGtZYfPy1Bh4uvdGQB2DbLEgKDxR+1vt3sfimQM4ejrRbHmrbGYmFvYE6YwDsnDdlqJ03XPIy7DsGv94NU1lLeD7BbcW0XcenaK28sK6tPyt33d+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748903337; c=relaxed/simple;
	bh=H0NjcqbIYmVFaD2SMYEyho+w8OcsQD4+OwNZPON43z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQb1li3UvAApjomJMBNnxIEI28vYM9is0tgVo7EcDzoRNn704JBCS6aCzZn+PFYmUTbEjwoOtPZqsgc5Ubz1B4ZcnKjQXtseak7GrKmlBkaFZkTtA1mVGm+SCvxc8HUO9HfOgfBTG4iDzNdpPe5dVg0mRlMLU23IIx7+vA7jGPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dLkDnC/k; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 2 Jun 2025 15:28:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748903323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JyAngPhIQbmFxpOkTVU6v6SdO9Gi9CMJI3HF9w1IXag=;
	b=dLkDnC/krH+92XTW3f77z4XEc02c1hJe+EH6+S9Z68FVr0z1NxsEAVDVlaC67uXYBNARf5
	tCEutPsJK9/pSDzJbkCAypP2Z3TdXW7P4ubIClxG9UPWTzvQZlOid6b344V0BZ0Uk0J01N
	GU5QSzmYCVMCnAdtrS7dnQRq/qWpdrU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 06/17] KVM: arm64: Introduce method to partition the PMU
Message-ID: <aD4llDZwb_sC_Ptj@linux.dev>
References: <20250602192702.2125115-1-coltonlewis@google.com>
 <20250602192702.2125115-7-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602192702.2125115-7-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 02, 2025 at 07:26:51PM +0000, Colton Lewis wrote:
>  static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>  {
> +	u8 hpmn = vcpu->kvm->arch.arm_pmu->hpmn;
> +
>  	preempt_disable();
>  
>  	/*
>  	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
>  	 * to disable guest access to the profiling and trace buffers
>  	 */
> -	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
> -					 *host_data_ptr(nr_event_counters));
> -	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
> +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
> +	vcpu->arch.mdcr_el2 |= (MDCR_EL2_HPMD |
> +				MDCR_EL2_TPM |

This isn't safe, as there's no guarantee that kvm_arch::arm_pmu is
pointing that the PMU for this CPU. KVM needs to derive HPMN from some
per-CPU state, not anything tied to the VM/vCPU.

> +/**
> + * kvm_pmu_partition() - Partition the PMU
> + * @pmu: Pointer to pmu being partitioned
> + * @host_counters: Number of host counters to reserve
> + *
> + * Partition the given PMU by taking a number of host counters to
> + * reserve and, if it is a valid reservation, recording the
> + * corresponding HPMN value in the hpmn field of the PMU and clearing
> + * the guest-reserved counters from the counter mask.
> + *
> + * Passing 0 for @host_counters has the effect of disabling partitioning.
> + *
> + * Return: 0 on success, -ERROR otherwise
> + */
> +int kvm_pmu_partition(struct arm_pmu *pmu, u8 host_counters)
> +{
> +	u8 nr_counters;
> +	u8 hpmn;
> +
> +	if (!kvm_pmu_reservation_is_valid(host_counters))
> +		return -EINVAL;
> +
> +	nr_counters = *host_data_ptr(nr_event_counters);
> +	hpmn = kvm_pmu_hpmn(host_counters);
> +
> +	if (hpmn < nr_counters) {
> +		pmu->hpmn = hpmn;
> +		/* Inform host driver of available counters */
> +		bitmap_clear(pmu->cntr_mask, 0, hpmn);
> +		bitmap_set(pmu->cntr_mask, hpmn, nr_counters);
> +		clear_bit(ARMV8_PMU_CYCLE_IDX, pmu->cntr_mask);
> +		if (pmuv3_has_icntr())
> +			clear_bit(ARMV8_PMU_INSTR_IDX, pmu->cntr_mask);
> +
> +		kvm_debug("Partitioned PMU with HPMN %u", hpmn);
> +	} else {
> +		pmu->hpmn = nr_counters;
> +		bitmap_set(pmu->cntr_mask, 0, nr_counters);
> +		set_bit(ARMV8_PMU_CYCLE_IDX, pmu->cntr_mask);
> +		if (pmuv3_has_icntr())
> +			set_bit(ARMV8_PMU_INSTR_IDX, pmu->cntr_mask);
> +
> +		kvm_debug("Unpartitioned PMU");
> +	}
> +
> +	return 0;
> +}

Hmm... Just in terms of code organization I'm not sure I like having KVM
twiddling with *host* support for PMUv3. Feels like the ARM PMU driver
should own partitioning and KVM just takes what it can get.

> @@ -239,6 +245,13 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>  	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
>  		return;
>  
> +	if (reserved_host_counters) {
> +		if (kvm_pmu_partition_supported())
> +			WARN_ON(kvm_pmu_partition(pmu, reserved_host_counters));
> +		else
> +			kvm_err("PMU Partition is not supported");
> +	}
> +

Hasn't the ARM PMU been registered with perf at this point? Surely the
driver wouldn't be very pleased with us ripping counters out from under
its feet.

Thanks,
Oliver

