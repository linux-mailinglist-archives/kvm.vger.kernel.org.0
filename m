Return-Path: <kvm+bounces-65220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 714B0C9F7BB
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 16:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C11C0304D557
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 15:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1574D32D7DA;
	Wed,  3 Dec 2025 15:20:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0892FB97A
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775224; cv=none; b=FPtf570VmrY6LnmxTz5IvKDSdHWS0+nnLvak5NzqzboO8LvjziizLU68x08LnEt/apZSeoTlv2kDGIsATQQ1aZxrauaFh1jYgALHQxS3EQ9SpUVzwo4XFPqcmYIu3sDwDsVKl3Bqz1XjaJ24bDB9WbE+R8MSlCO/ORDhra1ZwrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775224; c=relaxed/simple;
	bh=unslt5gGvxCkzQ3extZLzSTvy6lEfMNMpoA78YAUcrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzrWTs+p9QEjH8StX+HofirrSZIXzQ1xgiZUCFCxa2M39mVxVC8nYnN+C6Ja/MFOSwHbXajrwVXxDoUryjPQy41koseJBSyNq07SjeI9pZqhCr9GmHsho4C7d4BC6jeNNb4s1ayyfPw7TUPa57VVGT5A9CW31iagbLTNwsYL6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4147A339;
	Wed,  3 Dec 2025 07:20:13 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1881E3F59E;
	Wed,  3 Dec 2025 07:20:18 -0800 (PST)
Date: Wed, 3 Dec 2025 15:20:16 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 4/4] KVM: arm64: Convert VTCR_EL2 to config-driven
 sanitisation
Message-ID: <aTBVMIxeVbiZq0ee@raptor>
References: <20251129144525.2609207-1-maz@kernel.org>
 <20251129144525.2609207-5-maz@kernel.org>
 <aTAijieCI8055FL0@raptor>
 <86ikenpvna.wl-maz@kernel.org>
 <aTBDRx1oeGDs2SFl@raptor>
 <86h5u7pq7u.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h5u7pq7u.wl-maz@kernel.org>

Hi Marc,

On Wed, Dec 03, 2025 at 02:58:13PM +0000, Marc Zyngier wrote:
> On Wed, 03 Dec 2025 14:03:51 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Wed, Dec 03, 2025 at 01:00:57PM +0000, Marc Zyngier wrote:
> > > On Wed, 03 Dec 2025 11:44:14 +0000,
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > > > 
> > > > Hi Marc,
> > > > 
> > > > On Sat, Nov 29, 2025 at 02:45:25PM +0000, Marc Zyngier wrote:
> > > > > Describe all the VTCR_EL2 fields and their respective configurations,
> > > > > making sure that we correctly ignore the bits that are not defined
> > > > > for a given guest configuration.
> > > > > 
> > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > > ---
> > > > >  arch/arm64/kvm/config.c | 69 +++++++++++++++++++++++++++++++++++++++++
> > > > >  arch/arm64/kvm/nested.c |  3 +-
> > > > >  2 files changed, 70 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> > > > > index a02c28d6a61c9..c36e133c51912 100644
> > > > > --- a/arch/arm64/kvm/config.c
> > > > > +++ b/arch/arm64/kvm/config.c
> > > > > @@ -141,6 +141,7 @@ struct reg_feat_map_desc {
> > > > >  #define FEAT_AA64EL1		ID_AA64PFR0_EL1, EL1, IMP
> > > > >  #define FEAT_AA64EL2		ID_AA64PFR0_EL1, EL2, IMP
> > > > >  #define FEAT_AA64EL3		ID_AA64PFR0_EL1, EL3, IMP
> > > > > +#define FEAT_SEL2		ID_AA64PFR0_EL1, SEL2, IMP
> > > > >  #define FEAT_AIE		ID_AA64MMFR3_EL1, AIE, IMP
> > > > >  #define FEAT_S2POE		ID_AA64MMFR3_EL1, S2POE, IMP
> > > > >  #define FEAT_S1POE		ID_AA64MMFR3_EL1, S1POE, IMP
> > > > > @@ -202,6 +203,8 @@ struct reg_feat_map_desc {
> > > > >  #define FEAT_ASID2		ID_AA64MMFR4_EL1, ASID2, IMP
> > > > >  #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
> > > > >  #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
> > > > > +#define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
> > > > > +#define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
> > > > >  #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
> > > > >  #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
> > > > >  #define FEAT_IESB		ID_AA64MMFR2_EL1, IESB, IMP
> > > > > @@ -219,6 +222,7 @@ struct reg_feat_map_desc {
> > > > >  #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
> > > > >  #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
> > > > >  #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
> > > > > +#define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
> > > > >  
> > > > >  static bool not_feat_aa64el3(struct kvm *kvm)
> > > > >  {
> > > > > @@ -362,6 +366,28 @@ static bool feat_pmuv3p9(struct kvm *kvm)
> > > > >  	return check_pmu_revision(kvm, V3P9);
> > > > >  }
> > > > >  
> > > > > +#define has_feat_s2tgran(k, s)						\
> > > > > +  ((kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, TGRAN##s) && \
> > > > > +    !kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, TGRAN##s, NI))	     ||	\
> > > > 
> > > > Wouldn't that read better as kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN##s, IMP)?
> > > > I think that would also be correct.
> > > 
> > > Sure, I don't mind either way,
> > > 
> > > > 
> > > > > +   kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, IMP))
> > > > 
> > > > A bit unexpected to treat the same field first as an enum, then as an integer,
> > > > but it saves one line.
> > > 
> > > It potentially saves more if the encoding grows over time. I don't
> > > think it matters.
> > 
> > Doesn't, was just aestethics and saves someone having to check the values to
> > make sure it wasn't an error.
> > 
> > > 
> > > > 
> > > > > +
> > > > > +static bool feat_lpa2(struct kvm *kvm)
> > > > > +{
> > > > > +	return ((kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT)    ||
> > > > > +		 !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP))	&&
> > > > > +		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT)   ||
> > > > > +		 !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))	&&
> > > > > +		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4_2, 52_BIT)  ||
> > > > > +		 !has_feat_s2tgran(kvm, 4))				&&
> > > > > +		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16_2, 52_BIT) ||
> > > > > +		 !has_feat_s2tgran(kvm, 16)));
> > > > > +}
> > > > 
> > > > That was a doozy, but looks correct to me if the intention was to have the check
> > > > as relaxed as possible - i.e, a VM can advertise 52 bit support for one granule,
> > > > but not the other (same for stage 1 and stage 2).
> > > 
> > > Not quite. The intent is that, for all the possible granules, at all
> > > the possible stages, either the granule size isn't implemented at all,
> > > or it supports 52 bits. I think this covers it, but as you said, this
> > > is a bit of a bran fsck.
> > 
> > Hm... this sounds like something that should be sanitised in
> > set_id_aa64mmfr0_el1(). Sorry, but I just can't tell if TGran{4,16,64} are
> > writable by userspace.
> 
> Everything in ID_AA64MMFR0_EL1 is writable, except for ASIDBITS.

Aaah, ok so a bit set in the 'mask' argument to ID_FILTERED means the bit is
writable (the comment for ID_FILTERED doesn't explain that).

> 
> > 
> > > 
> > > This is essentially a transliteration of the MRS:
> > > 
> > > (FEAT_LPA2 && FEAT_S2TGran4K) <=> (UInt(ID_AA64MMFR0_EL1.TGran4_2) >= 3))
> > > (FEAT_LPA2 && FEAT_S2TGran16K) <=> (UInt(ID_AA64MMFR0_EL1.TGran16_2) >= 3))
> > > (FEAT_LPA2 && FEAT_TGran4K) <=> (SInt(ID_AA64MMFR0_EL1.TGran4) >= 1))
> > > (FEAT_LPA2 && FEAT_TGran16K) <=> (UInt(ID_AA64MMFR0_EL1.TGran16) >= 2))
> > > FEAT_S2TGran4K <=> (((UInt(ID_AA64MMFR0_EL1.TGran4_2) == 0) && FEAT_TGran4K) || (UInt(ID_AA64MMFR0_EL1.TGran4_2) >= 2))
> > > FEAT_S2TGran16K <=> (((UInt(ID_AA64MMFR0_EL1.TGran16_2) == 0) && FEAT_TGran16K) || (UInt(ID_AA64MMFR0_EL1.TGran16_2) >= 2))
> > > FEAT_TGran4K <=> (SInt(ID_AA64MMFR0_EL1.TGran4) >= 0)
> > > FEAT_TGran16K <=> (UInt(ID_AA64MMFR0_EL1.TGran16) >= 1)
> > 
> > How about (untested):
> > 
> > static bool feat_lpas2(struct kvm *kvm)
> > {
> > 	if (kvm_has_feat_exact(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP) ||
> > 	    kvm_has_feat_exact(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP) ||
> > 	    kvm_has_feat_exact(kvm, ID_AA64MMFR0_EL1, TGRAN4_2, IMP) ||
> > 	    kvm_has_feat_exact(kvm, ID_AA64MMFR0_EL1, TGRAN16_2, IMP))
> > 		return false;
> > 
> > 	return true;
> > }
> 
> The combination (TGRAN4=NI, TGRAN2_4=TGRAN4, TGRAN16=52_BIT,
> TGRAN16_2=52_BIT) is a valid LPA2 configuration, which the test above
> rejects.

Thank you for taking the time to entertain my comments. It's not clear to me why
the combination is rejected since there are no IMP values in your example, but I
trust your judgement and I don't want to waste your time on nitpicking.

My Reviewed-by stands, by the way, in case that wasn't clear.

Thanks,
Alex

