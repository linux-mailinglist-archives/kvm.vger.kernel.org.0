Return-Path: <kvm+bounces-70158-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNZ4LXIDg2l8ggMAu9opvQ
	(envelope-from <kvm+bounces-70158-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:29:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F9A0E3231
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:29:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58895301C6FA
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 08:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06F43939A6;
	Wed,  4 Feb 2026 08:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ozkXa3oR"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB36392C4D
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 08:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770193759; cv=none; b=RuTfQBHOb0iytNXtT5fymAe/dU2Au+iHimf/XZbEMOXbfHfyH8YPtO9RJjmr8IPcyz/uHSYCJn70AG4Cn5tqti/v5e+HN68y3lgPBuTnkPOVChnkv+eKfF9nTJC7w3xQzR2AvVQaHbAgUcYJB/RXb7fnjClcKpxSlGKP0tbyva8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770193759; c=relaxed/simple;
	bh=ogq1XUSaR3OVUt/O17RmJdqbpaMKcMlDWDhDVswPWxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rI1c1jb+AcQYseBIlZfnYQUJ543Q0aPPcRCqVHVaWAovXZ+PTzNgoWiI3nnQrOS0Fdj9uUI59D/9TQhHi5yvW7x+Ww0y39iYrLeIYTrs0mE9eZJ9d9/oiYS5qxfcfmJBAt9tZYQmun++T6Ao3rvkcHYru2c3KZPAFWeHMS3b6uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ozkXa3oR; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <3f88cd49-68f1-4276-a067-b7c6beadb27c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770193746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJvGt7s8JNtP3SsZ3S09HKPpVrd466t4v0LgkkRbzps=;
	b=ozkXa3oRSqL0pW6TZmVec7dzzDltMBrBxgtPsbRrpkqaxkwxYhT4d29cvEPDbyN7trAdBR
	NgULJ6hqoKqhEMhjpdn1Q7jx3QjfMzCl5ffzYqrZpwwwZsJol11tJ5L0/AeZ8LmC1AXSv0
	KFerAdFSk6IOSNvoHurxVupZFuuHYMU=
Date: Wed, 4 Feb 2026 16:28:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 02/16] KVM: arm64: nv: Implement nested Stage-2 page
 table walk logic
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 wanghaibin.wang@huawei.com
References: <20240614144552.2773592-1-maz@kernel.org>
 <20240614144552.2773592-3-maz@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20240614144552.2773592-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70158-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zenghui.yu@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 2F9A0E3231
X-Rspamd-Action: no action

Hi Marc,

[ chewing through the NV code.. ;-) ]

On 6/14/24 10:45 PM, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Based on the pseudo-code in the ARM ARM, implement a stage 2 software
> page table walker.

[...]

> +static u32 compute_fsc(int level, u32 fsc)
> +{
> +	return fsc | (level & 0x3);
> +}
> +
> +static int get_ia_size(struct s2_walk_info *wi)
> +{
> +	return 64 - wi->t0sz;
> +}
> +
> +static int check_base_s2_limits(struct s2_walk_info *wi,
> +				int level, int input_size, int stride)
> +{
> +	int start_size, ia_size;
> +
> +	ia_size = get_ia_size(wi);
> +
> +	/* Check translation limits */
> +	switch (BIT(wi->pgshift)) {
> +	case SZ_64K:
> +		if (level == 0 || (level == 1 && ia_size <= 42))

It looks broken as the pseudocode checks the limits based on
*implemented PA size*, rather than on ia_size, which is essentially the
input address size (64 - T0SZ) programmed by L1 hypervisor. They're
different.

We can probably get the implemented PA size by:

AArch64.PAMax()
{
	parange = get_idreg_field_enum(kvm, ID_AA64MMFR0_EL1, PARANGE);
	return id_aa64mmfr0_parange_to_phys_shift(parange);
}

Not sure if I've read the spec correctly.

> +			return -EFAULT;
> +		break;
> +	case SZ_16K:
> +		if (level == 0 || (level == 1 && ia_size <= 40))
> +			return -EFAULT;
> +		break;
> +	case SZ_4K:
> +		if (level < 0 || (level == 0 && ia_size <= 42))
> +			return -EFAULT;
> +		break;
> +	}
> +
> +	/* Check input size limits */
> +	if (input_size > ia_size)

This is always false for the current code. ;-)

> +		return -EFAULT;
> +
> +	/* Check number of entries in starting level table */
> +	start_size = input_size - ((3 - level) * stride + wi->pgshift);
> +	if (start_size < 1 || start_size > stride + 4)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/* Check if output is within boundaries */
> +static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
> +{
> +	unsigned int output_size = wi->max_oa_bits;
> +
> +	if (output_size != 48 && (output & GENMASK_ULL(47, output_size)))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +/*
> + * This is essentially a C-version of the pseudo code from the ARM ARM
> + * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
> + * that pseudocode in trying to understand this.
> + *
> + * Must be called with the kvm->srcu read lock held
> + */
> +static int walk_nested_s2_pgd(phys_addr_t ipa,
> +			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
> +{
> +	int first_block_level, level, stride, input_size, base_lower_bound;
> +	phys_addr_t base_addr;
> +	unsigned int addr_top, addr_bottom;
> +	u64 desc;  /* page table entry */
> +	int ret;
> +	phys_addr_t paddr;
> +
> +	switch (BIT(wi->pgshift)) {
> +	default:
> +	case SZ_64K:
> +	case SZ_16K:
> +		level = 3 - wi->sl;
> +		first_block_level = 2;
> +		break;
> +	case SZ_4K:
> +		level = 2 - wi->sl;
> +		first_block_level = 1;
> +		break;
> +	}
> +
> +	stride = wi->pgshift - 3;
> +	input_size = get_ia_size(wi);
> +	if (input_size > 48 || input_size < 25)
> +		return -EFAULT;
> +
> +	ret = check_base_s2_limits(wi, level, input_size, stride);
> +	if (WARN_ON(ret))
> +		return ret;
> +
> +	base_lower_bound = 3 + input_size - ((3 - level) * stride +
> +			   wi->pgshift);
> +	base_addr = wi->baddr & GENMASK_ULL(47, base_lower_bound);
> +
> +	if (check_output_size(wi, base_addr)) {
> +		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);

With a wrongly programmed base address, we should report the ADDRSZ
fault at level 0 (as per R_BFHQH and the pseudocode). It's easy to fix.

> +static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
> +{
> +	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
> +
> +	switch (vtcr & VTCR_EL2_TG0_MASK) {
> +	case VTCR_EL2_TG0_4K:
> +		wi->pgshift = 12;	 break;
> +	case VTCR_EL2_TG0_16K:
> +		wi->pgshift = 14;	 break;
> +	case VTCR_EL2_TG0_64K:
> +	default:	    /* IMPDEF: treat any other value as 64k */
> +		wi->pgshift = 16;	 break;
> +	}
> +
> +	wi->sl = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
> +	/* Global limit for now, should eventually be per-VM */
> +	wi->max_oa_bits = min(get_kvm_ipa_limit(),
                              ^^^

Should we use AArch64.PAMax() instead? As the output address size is
never larger than the implemented PA size.

Now I'm wondering if we can let kvm_get_pa_bits() just return PAMax for
(based on the exposed (to-L1) AA64MFR0.PARange value) and use it when
possible.

Thanks,
Zenghui

