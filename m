Return-Path: <kvm+bounces-22240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD37593C3DB
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:16:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 679C1283ACD
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A19619D880;
	Thu, 25 Jul 2024 14:16:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AAB19D08E
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721916979; cv=none; b=lTyTi3D5rxzchKgAU8jL+dMQkv1Ic0Kp7zYQK4PvE+hnz9+7iIeXeZmkLF3mK1gII7v/iCwOA9pVBrzo+uNKJuE1VQsqKS3OxOUPnMCit0dfHm4rqLZ/DBpc/z3t4g/PYUy6kDCvAXNCVCysAzhfd4HslzRUA2PbTRexKmw6gnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721916979; c=relaxed/simple;
	bh=Ml9ShYcKFidlwTDQkYFYVAyX4vu55MFh1dE9BlFPR/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiDa4xg3xfT4V7f4QIhF6h/+X4yf2bYAlNOiQjoqjgjcCi0CX6hvJdThGKZqE+BwGsrIdpvI0wHGVMZS+RXa6030+qdg8FwsaEq5L5W2QmVxqjPGEkMmHlHO+zAjf/0YiN/b73i2dZ1K6yO1Rw4R9exIXBj6etzaAu6uBGWWXF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B980A1007;
	Thu, 25 Jul 2024 07:16:42 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 723A13F73F;
	Thu, 25 Jul 2024 07:16:15 -0700 (PDT)
Date: Thu, 25 Jul 2024 15:16:12 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <ZqJeLDGJwWEFMKD4@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708165800.1220065-1-maz@kernel.org>

Hi Marc,

On Mon, Jul 08, 2024 at 05:57:58PM +0100, Marc Zyngier wrote:
> In order to plug the brokenness of our current AT implementation,
> we need a SW walker that is going to... err.. walk the S1 tables
> and tell us what it finds.
> 
> Of course, it builds on top of our S2 walker, and share similar
> concepts. The beauty of it is that since it uses kvm_read_guest(),
> it is able to bring back pages that have been otherwise evicted.
> 
> This is then plugged in the two AT S1 emulation functions as
> a "slow path" fallback. I'm not sure it is that slow, but hey.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> [..]
> +static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +{
> +	bool perm_fail, ur, uw, ux, pr, pw, pan;
> +	struct s1_walk_result wr = {};
> +	struct s1_walk_info wi = {};
> +	int ret, idx, el;
> +
> +	/*
> +	 * We only get here from guest EL2, so the translation regime
> +	 * AT applies to is solely defined by {E2H,TGE}.
> +	 */
> +	el = (vcpu_el2_e2h_is_set(vcpu) &&
> +	      vcpu_el2_tge_is_set(vcpu)) ? 2 : 1;
> +
> +	ret = setup_s1_walk(vcpu, &wi, &wr, vaddr, el);
> +	if (ret)
> +		goto compute_par;
> +
> +	if (wr.level == S1_MMU_DISABLED)
> +		goto compute_par;
> +
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +	ret = walk_s1(vcpu, &wi, &wr, vaddr);
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +
> +	if (ret)
> +		goto compute_par;
> +
> +	/* FIXME: revisit when adding indirect permission support */
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3) &&
> +	    !wi.nvhe) {
> +		u64 sctlr;
> +
> +		if (el == 1)
> +			sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		else
> +			sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +
> +		ux = (sctlr & SCTLR_EL1_EPAN) && !(wr.desc & PTE_UXN);
> +	} else {
> +		ux = false;
> +	}
> +
> +	pw = !(wr.desc & PTE_RDONLY);
> +
> +	if (wi.nvhe) {
> +		ur = uw = false;
> +		pr = true;
> +	} else {
> +		if (wr.desc & PTE_USER) {
> +			ur = pr = true;
> +			uw = pw;
> +		} else {
> +			ur = uw = false;
> +			pr = true;
> +		}
> +	}
> +
> +	/* Apply the Hierarchical Permission madness */
> +	if (wi.nvhe) {
> +		wr.APTable &= BIT(1);
> +		wr.PXNTable = wr.UXNTable;
> +	}
> +
> +	ur &= !(wr.APTable & BIT(0));
> +	uw &= !(wr.APTable != 0);
> +	ux &= !wr.UXNTable;
> +
> +	pw &= !(wr.APTable & BIT(1));
> +
> +	pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
> +
> +	perm_fail = false;
> +
> +	switch (op) {
> +	case OP_AT_S1E1RP:
> +		perm_fail |= pan && (ur || uw || ux);
> +		fallthrough;
> +	case OP_AT_S1E1R:
> +	case OP_AT_S1E2R:
> +		perm_fail |= !pr;
> +		break;
> +	case OP_AT_S1E1WP:
> +		perm_fail |= pan && (ur || uw || ux);
> +		fallthrough;
> +	case OP_AT_S1E1W:
> +	case OP_AT_S1E2W:
> +		perm_fail |= !pw;
> +		break;
> +	case OP_AT_S1E0R:
> +		perm_fail |= !ur;
> +		break;
> +	case OP_AT_S1E0W:
> +		perm_fail |= !uw;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	if (perm_fail) {
> +		struct s1_walk_result tmp;

I was wondering if you would consider initializing 'tmp' to the empty struct
here. That makes it consistent with the initialization of 'wr' in the !perm_fail
case and I think it will make the code more robust wrt to changes to
compute_par_s1() and what fields it accesses.

Thanks,
Alex

> +
> +		tmp.failed = true;
> +		tmp.fst = ESR_ELx_FSC_PERM | wr.level;
> +		tmp.s2 = false;
> +		tmp.ptw = false;
> +
> +		wr = tmp;
> +	}
> +
> +compute_par:
> +	return compute_par_s1(vcpu, &wr);
> +}

