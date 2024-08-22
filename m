Return-Path: <kvm+bounces-24838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1E995BC87
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 18:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A69D91F22AB6
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE391CDFC7;
	Thu, 22 Aug 2024 16:56:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A712C190;
	Thu, 22 Aug 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724345783; cv=none; b=eBheBySNu43y/qr+M4xBvBvm01qtZLUPw6tmJLEmdfc9KcyhOJIOUwH0Eup5KmBqlmzqHvuZIBq4oBAIzNC2ZP1G3C4j0lUmkF8ykWm60rFPEX3tcwSaCNDL+QlzVsHMM6D4FpXWA8lAFKYW2J9mhdaZwv3dVP8a+jF/IqF2/ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724345783; c=relaxed/simple;
	bh=BKp79S86nhQLGwk5mzBpD8fy4UNWVR7StHU3C/+44Ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qrd2A558432X3TWw720n6HY/Kbml90mihWQzYChHfUgwqnp/b13+upKU8rBnzGomciKoDjRHa2f8tjFRXK1NHTYNrgAOvTbkspZWJvAtggbV8MqcfuOaY87qdIqjyqFlQY7EonzotfrNUq9AaE9Aj2aJ4VxPfoXjEEsi6UPf4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18C92DA7;
	Thu, 22 Aug 2024 09:56:45 -0700 (PDT)
Received: from [10.57.72.240] (unknown [10.57.72.240])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF3653F58B;
	Thu, 22 Aug 2024 09:56:15 -0700 (PDT)
Message-ID: <b777e1b1-d8a8-41fa-964c-ef74942e3c3d@arm.com>
Date: Thu, 22 Aug 2024 17:56:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/43] arm64: RME: Add wrappers for RMI calls
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-7-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240821153844.60084-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 21/08/2024 16:38, Steven Price wrote:
> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
> 

Patch looks good to me, some minor nits below

> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v2:
>   * Make output arguments optional.
>   * Mask RIPAS value rmi_rtt_read_entry()
>   * Drop unused rmi_rtt_get_phys()
> ---
>   arch/arm64/include/asm/rmi_cmds.h | 508 ++++++++++++++++++++++++++++++
>   1 file changed, 508 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
> 
> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> new file mode 100644
> index 000000000000..5288fed4c11a
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -0,0 +1,508 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RMI_CMDS_H
> +#define __ASM_RMI_CMDS_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#include <asm/rmi_smc.h>
> +
> +struct rtt_entry {
> +	unsigned long walk_level;
> +	unsigned long desc;
> +	int state;
> +	int ripas;
> +};
> +
> +/**
> + * rmi_data_create() - Create a Data Granule
> + * @rd: PA of the RD
> + * @data: PA of the target granule
> + * @ipa: IPA at which the granule will be mapped in the guest
> + * @src: PA of the source granule
> + * @flags: RMI_MEASURE_CONTENT if the contents should be measured
> + *
> + * Create a new Data Granule, copying contents from a Non-secure Granule.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_data_create(unsigned long rd, unsigned long data,
> +				  unsigned long ipa, unsigned long src,
> +				  unsigned long flags)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE, rd, data, ipa, src,
> +			     flags, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_data_create_unknown() - Create a Data Granule with unknown contents
> + * @rd: PA of the RD
> + * @data: PA of the target granule
> + * @ipa: IPA at which the granule will be mapped in the guest
> + *
> + * Create a new Data Granule with unknown contents
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_data_create_unknown(unsigned long rd,
> +					  unsigned long data,
> +					  unsigned long ipa)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE_UNKNOWN, rd, data, ipa, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_data_destroy() - Destroy a Data Granule
> + * @rd: PA of the RD
> + * @ipa: IPA at which the granule is mapped in the guest
> + * @data_out: PA of the granule which was destroyed
> + * @top_out: Top IPA of non-live RTT entries
> + *
> + * Transitions the granule to DESTROYED state, the address cannot be used by
> + * the guest for the lifetime of the Realm.

This may be confusing. Could we extend the above sentence to indicate 
something like:

"Unmap a protected ipa from stage2, transitioning it to DESTROYED.
The IPA cannot be used by the guest unless it is transitioned to
RAM again by the Realm"


> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_data_destroy(unsigned long rd, unsigned long ipa,
> +				   unsigned long *data_out,
> +				   unsigned long *top_out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_DESTROY, rd, ipa, &res);
> +
> +	if (data_out)
> +		*data_out = res.a1;
> +	if (top_out)
> +		*top_out = res.a2;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_features() - Read feature register
> + * @index: Feature register index
> + * @out: Feature register value is written to this pointer
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_features(unsigned long index, unsigned long *out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
> +
> +	if (out)
> +		*out = res.a1;
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_granule_delegate() - Delegate a Granule
> + * @phys: PA of the Granule
> + *
> + * Delegate a Granule for use by the Realm World.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_granule_delegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_DELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_granule_undelegate() - Undelegate a Granule
> + * @phys: PA of the Granule
> + *
> + * Undelegate a Granule to allow use by the Normal World. Will fail if the
> + * Granule is in use.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_granule_undelegate(unsigned long phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_UNDELEGATE, phys, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_psci_complete() - Complete pending PSCI command
> + * @calling_rec: PA of the calling REC
> + * @target_rec: PA of the target REC
> + * @status: Status of the PSCI request
> + *
> + * Completes a pending PSCI command which was called with an MPIDR argument, by
> + * providing the corresponding REC.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_psci_complete(unsigned long calling_rec,
> +				    unsigned long target_rec,
> +				    unsigned long status)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, target_rec,
> +			     status, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_realm_activate() - Active a Realm
> + * @rd: PA of the RD
> + *
> + * Mark a Realm as Active signalling that creation is complete and allowing
> + * execution of the Realm.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_activate(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_realm_create() - Create a Realm
> + * @rd: PA of the RD
> + * @params_ptr: PA of Realm parameters
> + *
> + * Create a new Realm using the given parameters.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_create(unsigned long rd, unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_CREATE, rd, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_realm_destroy() - Destroy a Realm
> + * @rd: PA of the RD
> + *
> + * Destroys a Realm, all objects belonging to the Realm must be destroyed first.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_destroy(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_aux_count() - Get number of auxiliary Granules required
> + * @rd: PA of the RD
> + * @aux_count: Number of pages written to this pointer
> + *
> + * A REC may require extra auxiliary pages to be delegated for the RMM to
> + * store metadata (not visible to the normal world) in. This function provides
> + * the number of pages that are required.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
> +
> +	if (aux_count)
> +		*aux_count = res.a1;
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_create() - Create a REC
> + * @rd: PA of the RD
> + * @rec: PA of the target REC
> + * @params_ptr: PA of REC parameters
> + *
> + * Create a REC using the parameters specified in the struct rec_params pointed
> + * to by @params_ptr.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_create(unsigned long rd, unsigned long rec,
> +				 unsigned long params_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rd, rec, params_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_destroy() - Destroy a REC
> + * @rec: PA of the target REC
> + *
> + * Destroys a REC. The REC must not be running.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_destroy(unsigned long rec)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_DESTROY, rec, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_enter() - Enter a REC
> + * @rec: PA of the target REC
> + * @run_ptr: PA of RecRun structure
> + *
> + * Starts (or continues) execution within a REC.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_create() - Creates an RTT
> + * @rd: PA of the RD
> + * @rtt: PA of the target RTT
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: Depth of the RTT within the tree
> + *
> + * Creates an RTT (Realm Translation Table) at the specified address and level
> + * within the realm.

minor nit:

"Creates an RTT (Realm Translation Table) at the specified level for the 
translation of the specified address" ?


> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_create(unsigned long rd, unsigned long rtt,
> +				 unsigned long ipa, long level)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rd, rtt, ipa, level, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_destroy() - Destroy an RTT
> + * @rd: PA of the RD
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: Depth of the RTT within the tree
> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
> + * @out_top: Pointer to write the top IPA of non-live RTT entries
> + *
> + * Destroys an RTT. The RTT must be empty.

minor nit: To be more precise, "The RTT must be non-live, i.e, none of 
the entries in the table are in ASSIGNED or TABLE state".

e.g, it is perfectly fine to destroy an RTT mapping UNPROTECTED leaf
mappings.

Thanks
Suzuki

> + *
> + * Return: RMI return code.
> + */
> +static inline int rmi_rtt_destroy(unsigned long rd,
> +				  unsigned long ipa,
> +				  long level,
> +				  unsigned long *out_rtt,
> +				  unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rd, ipa, level, &res);
> +
> +	if (out_rtt)
> +		*out_rtt = res.a1;
> +	if (out_top)
> +		*out_top = res.a2;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_fold() - Fold an RTT
> + * @rd: PA of the RD
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: Depth of the RTT within the tree
> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
> + *
> + * Folds an RTT. If all entries with the RTT are 'homogeneous' the RTT can be
> + * folded into the parent and the RTT destroyed.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_fold(unsigned long rd, unsigned long ipa,
> +			       long level, unsigned long *out_rtt)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rd, ipa, level, &res);
> +
> +	if (out_rtt)
> +		*out_rtt = res.a1;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_init_ripas() - Set RIPAS for new Realm
> + * @rd: PA of the RD
> + * @base: Base of target IPA region
> + * @top: Top of target IPA region
> + * @out_top: Top IPA of range whose RIPAS was modified
> + *
> + * Sets the RIPAS of a target IPA range to RAM, for a Realm in the NEW state.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long base,
> +				     unsigned long top, unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, base, top, &res);
> +
> +	if (out_top)
> +		*out_top = res.a1;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_map_unprotected() - Map NS pages into a Realm
> + * @rd: PA of the RD
> + * @ipa: Base IPA of the mapping
> + * @level: Depth within the RTT tree
> + * @desc: RTTE descriptor
> + *
> + * Create a mapping from an Unprotected IPA to a Non-secure PA.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_map_unprotected(unsigned long rd,
> +					  unsigned long ipa,
> +					  long level,
> +					  unsigned long desc)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_MAP_UNPROTECTED, rd, ipa, level,
> +			     desc, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_read_entry() - Read an RTTE
> + * @rd: PA of the RD
> + * @ipa: IPA for which to read the RTTE
> + * @level: RTT level at which to read the RTTE
> + * @rtt: Output structure describing the RTTE
> + *
> + * Reads a RTTE (Realm Translation Table Entry).
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long ipa,
> +				     long level, struct rtt_entry *rtt)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_RTT_READ_ENTRY,
> +		rd, ipa, level
> +	};
> +
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	rtt->walk_level = regs.a1;
> +	rtt->state = regs.a2 & 0xFF;
> +	rtt->desc = regs.a3;
> +	rtt->ripas = regs.a4 & 0xFF;
> +
> +	return regs.a0;
> +}
> +
> +/**
> + * rmi_rtt_set_ripas() - Set RIPAS for an running realm
> + * @rd: PA of the RD
> + * @rec: PA of the REC making the request
> + * @base: Base of target IPA region
> + * @top: Top of target IPA region
> + * @out_top: Pointer to write top IPA of range whose RIPAS was modified
> + *
> + * Completes a request made by the Realm to change the RIPAS of a target IPA
> + * range.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
> +				    unsigned long base, unsigned long top,
> +				    unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, base, top, &res);
> +
> +	if (out_top)
> +		*out_top = res.a1;
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rtt_unmap_unprotected() - Remove a NS mapping
> + * @rd: PA of the RD
> + * @ipa: Base IPA of the mapping
> + * @level: Depth within the RTT tree
> + * @out_top: Pointer to write top IPA of non-live RTT entries
> + *
> + * Removes a mapping at an Unprotected IPA.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
> +					    unsigned long ipa,
> +					    long level,
> +					    unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNMAP_UNPROTECTED, rd, ipa,
> +			     level, &res);
> +
> +	if (out_top)
> +		*out_top = res.a1;
> +
> +	return res.a0;
> +}
> +
> +#endif


