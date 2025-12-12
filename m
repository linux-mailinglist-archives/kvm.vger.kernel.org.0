Return-Path: <kvm+bounces-65879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A4FCB934F
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 17:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C4573046385
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF8D2B9A4;
	Fri, 12 Dec 2025 16:00:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5213B8D6B
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765555254; cv=none; b=mAW5hQCbhGUyb+y4FXmbkq24sfGUxonVaba5VHBew8CDqmKDfiNrW2lrkodTsjEbAQgVwGB16/rjKs61Wxe4uDd1aE2OZvhcF05javkWfdPAJ95is2CW45kpR3UylgSmtKmkESkRGgiKV58ImFN0Z3A4fWXTGBexsBGZhm65sbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765555254; c=relaxed/simple;
	bh=rdqGi02n6ox/C9X9JPwzpP1tYajoZ2f2ODncGJC4HD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1HF1fu2ihzLvdZg9ZWkktMP/9nCYsHBUQethSIp5XXkLZ2Ecvmgt33x050d1Ief2yOYqhHsUnvODguvgfYIQgYyFcJwtS+wKR1RmjXjzBlsxlUNH8qmlrAxZhacFBOyE7IS2nBr2U+0Id5tphmA019fbyjpBGGznftKmRzWyZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAD7D1063;
	Fri, 12 Dec 2025 08:00:42 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FEBA3F762;
	Fri, 12 Dec 2025 08:00:47 -0800 (PST)
Date: Fri, 12 Dec 2025 16:00:42 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: Honor UX/PX attributes for EL2 S1
 mappings
Message-ID: <20251212160042.GA978851@e124191.cambridge.arm.com>
References: <20251210173024.561160-1-maz@kernel.org>
 <20251210173024.561160-7-maz@kernel.org>
 <20251211151810.GA867614@e124191.cambridge.arm.com>
 <86tsxxng5b.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tsxxng5b.wl-maz@kernel.org>

On Thu, Dec 11, 2025 at 04:21:20PM +0000, Marc Zyngier wrote:
> On Thu, 11 Dec 2025 15:18:51 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > Question,
> > 
> > On Wed, Dec 10, 2025 at 05:30:24PM +0000, Marc Zyngier wrote:
> > > Now that we potentially have two bits to deal with when setting
> > > execution permissions, make sure we correctly handle them when both
> > > when building the page tables and when reading back from them.
> > > 
> > > Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_pgtable.h | 12 +++---------
> > >  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++++---
> > >  2 files changed, 24 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > index be68b89692065..095e6b73740a6 100644
> > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > @@ -87,15 +87,9 @@ typedef u64 kvm_pte_t;
> > >  
> > >  #define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
> > >  
> > > -#define __KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
> > > -#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
> > > -#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
> > > -
> > > -#define KVM_PTE_LEAF_ATTR_HI_S1_XN					\
> > > -	({ cpus_have_final_cap(ARM64_KVM_HVHE) ?			\
> > > -			(__KVM_PTE_LEAF_ATTR_HI_S1_UXN |		\
> > > -			 __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :		\
> > > -			__KVM_PTE_LEAF_ATTR_HI_S1_XN; })
> > > +#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
> > > +#define KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
> > > +#define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
> > >  
> > >  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
> > >  
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index e0bd6a0172729..97c0835d25590 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -342,6 +342,9 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> > >  	if (!(prot & KVM_PGTABLE_PROT_R))
> > >  		return -EINVAL;
> > >  
> > > +	if (!cpus_have_final_cap(ARM64_KVM_HVHE))
> > > +		prot &= ~KVM_PGTABLE_PROT_UX;
> > 
> > Trying to understand this part. We don't consider KVM_PGTABLE_PROT_UX below
> > when !HVHE, and we don't set it in kvm_pgtable_hyp_pte_prot() when !HVHE
> > either, so can it ever actually be set?
> 
> Because KVM_PGTABLE_PROT_X, which is directly passed by the high-level
> code, is defined as such:
> 
> 	KVM_PGTABLE_PROT_X			= KVM_PGTABLE_PROT_PX	|
> 						  KVM_PGTABLE_PROT_UX,
> 

This was the main missing part!

> We *could* make that value dependent on HVHE, but since that's in an
> enum, it is pretty ugly to do (not impossible though).
> 
> But it is in the following code that this becomes useful...
> 
> >
> > Otherwise LGTM!
> > 
> > Thanks,
> > Joey
> > 
> > > +
> > >  	if (prot & KVM_PGTABLE_PROT_X) {
> > >  		if (prot & KVM_PGTABLE_PROT_W)
> > >  			return -EINVAL;
> 
> ... here. If you were passed UX (and only that), and that you're
> !HVHE, you won't have execution at all, and can allow writes.
> 
> Does that make sense?

Yes, thanks!

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

