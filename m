Return-Path: <kvm+bounces-65779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44AFCCB63D9
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57217301AD11
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B6228D8DF;
	Thu, 11 Dec 2025 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X6Ncd6nB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD6D26B74A
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765464292; cv=pass; b=Ueqb7s+5TcE22/wJevrrHib3povGtRR3Fwco3a829NXaGsKxQm0t3bb7542H+Wi+h8GcprKs5+olRfH3aNpWcf+JGjOrpK8XWfGCHef5dbMxUmwucAuKDgjVAfzANlEAXAGhFHzkZChc3EPZUEL42sSvP7ZhqwbF4yzj/yjofzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765464292; c=relaxed/simple;
	bh=3CGcZybwvjN+IQozMP9lQLOCyI7PM6iI2TktH1ILG08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bvl/edzdtsHOnNIkIAOprtjbcGlLSwZxHqZ1cfivykYcKHRcQkYI7MfzKa+hztqqM5FgRdKYCT80yMRocaj3fNADtfRwMY4kHjcyNWFQj0U8Eb+kfRrhD8FeHpUs1zoTK9DKRNlDPvXvREwcH6CT30INWtA3sdQWH8nkDkuZWQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X6Ncd6nB; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee243b98caso386081cf.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:44:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765464289; cv=none;
        d=google.com; s=arc-20240605;
        b=JLWDOFqThQH15PhW1Bp0/5IVGf7aeyOS4tvdkERxMQPIQZvvQH3WjorQGYNMrfxGOj
         cNoJG5JtQN2+mLT9q8Tvjjx0sQDWkG7WRwY5pb6FcHknWJlvdVtxjWEtLY+LeZVTq7NQ
         MyRr/f2jjZNPZZRDXFcg2c84zSX6ikXO4oZOkmFi8ZxOXQFjZ4XoF/kPr5BroVxosgZj
         I+sDI4mUbTnCEmF4gXK1uWnOtiit2ladCGXJpEtH4JJ8eeM+x9ngV6ep39Mt9bZe08dV
         ugZqcGhHkInTe1a8qTqvsVBZaY+LyC6ZKsQEo8sefD7NJFLjxlJG+9amhzJ/B/vwFeII
         g7fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KSuq6GH+l9j6EhEIx7zNXfQeyv6VkbIy7sCSTIctR8A=;
        fh=z51a2P0j6dLN/blnSmx6tJWXnaMAvghxnW3oD10m8NQ=;
        b=IjMS5zGYKBO1Wu/ACc2glSmLaXHPb4Snh+qfqbBiPsvVs696OJzj0IhdrgolWH2TIu
         mdPLPg5U+wej4SOLJ24xl9zdoJ+hGPD7ZjuKgwWKxqISStMi7hOEidrgOiiFAt0WC2TH
         3PhY/WpbcdfMnkKSOmu089c2aUm8jOcNzY0ndAWREmZIyIx7SpeK5PN6fmj3XlETiwHO
         5ZU8JJiEZFqecRKTtC4MQZpxs/07g7KSXJUQnNCVmnkIgpo+3Bcq5YDEtHauKVKkEg4U
         hj5BnQkSIKM0WKlX7++vk7xRBonSM+oJAWk+aH5ioFv0COyauVvpNDkMKGi/wR7I/VnX
         lhtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765464289; x=1766069089; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KSuq6GH+l9j6EhEIx7zNXfQeyv6VkbIy7sCSTIctR8A=;
        b=X6Ncd6nBp4Rovd3GOxd7sQFs5bO3n3smMxgvW3HZBevEm/t2iUiyK9yAgvDVajY8Tm
         R6559eRNwgKOn6ntZ7QyYaCNglrOCN1BNll8WpfWibZ311jnsYvQ0x9cLMxb8BTRXYwG
         qfvVFTAIbzAEe+E8HlTKuJk/x2NUz5i8oqFCEPvaY3rtD1ysiFSCusfFPpPZuFbXE84R
         kYaC0lXqG73zK1ndQyir2vttiWa1DZzaYsrBr45PhRJsYoJ5yis38rKk5MfPE8LuL5ca
         NlRb92Hrbqm0TmKDnQ/tbF7GUDO4Ry2g/GHwjRDy7H0e6ac+UWAh0h9NGRWxdKsxWio5
         CSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765464289; x=1766069089;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSuq6GH+l9j6EhEIx7zNXfQeyv6VkbIy7sCSTIctR8A=;
        b=Cz9Ojrenw/sD3FDWLxvPg14ZryHa1DOountLFXjtqs4EA2Yz/W51dzlAw3LU5hG54x
         5Vju/7ID7MO7GvSNJ/btHyAXXvWiqTGdC6o4T6VuAGzmIobuerEOlGSBig3ij7yxMsUJ
         fcu2kbFXygYUQzNpukAt6uZHZOgrlSq9humUH+m6MZC9MbtOmjJnAE+oTqDtWP0qa8i3
         FEjPBSiHMvC9+4DwVKBH4Tu3z3CpHFU5coUkpamejejZHlFSfSOdfd+nQmmuQA4NQIXd
         MIxdgsjpxM4CT5nN2nNc5ptUlyx91DAYi//HkINn9N9N1A+OvFf1q+Xv7KeKA9aGnwHX
         1T6w==
X-Forwarded-Encrypted: i=1; AJvYcCXEOMZAnZ1fHcRwFYgZOZkXtxbUYKq+78Q5Byw1YbgeZ4urVq3sSo1xnoFCJCKr6tieACM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOl4N5Z3XVK+z7GJ+8RV9PVUJA34iE4NeX6WZBt/q07Fr57OSs
	h8Mb/rciq60DrzDhWFd+/mo8bSLcodHKTntvEju5Raaf3ysIB4AOFi3m9FBw2RfFJoQKUv560VW
	x7Q0JcOwp2YA2+wAR4ik8WpH7sQ3g63s5c4vMb3DU
X-Gm-Gg: AY/fxX41hMu5izv65Hz0VCWc6gytbT5Z23ZQmkRh1tT/3A3I8iN7L3DRUNnu0bB0/t1
	L6C0G3yEKQ4ReG0c290b58Apv+Yjexm2E6RaD0NcynAkE7awVhh9M3f9rgBFje+i1Hpfy5bjuUq
	jMWHaacOJEBdRDZt8EV/RekTRyIWevlrp7Hg/0vDrrvSAG05Gjb6Tll/j7o81o7Gpud9o7TVT8k
	fLpxwfVu5x0/tKAgUAYb0qpPTz+J8XtaZfq7ca1X2bgB4TSpbp8EEvtE3yhTFv9Nktlpsc7XTsp
	xYjamn8=
X-Google-Smtp-Source: AGHT+IFWKU+icarWvA6iCnZdZOf2gTsZLSRpOBVgzaM+BkqI//LgNJ2dMzQCF3c3aTVaf+Tt8N2sYXD5YPMUCqYbGng=
X-Received: by 2002:a05:622a:1b8f:b0:4f1:a60e:bc33 with SMTP id
 d75a77b69052e-4f1bd8686dfmr10411511cf.2.1765464288525; Thu, 11 Dec 2025
 06:44:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-6-maz@kernel.org>
In-Reply-To: <20251210173024.561160-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:44:11 +0000
X-Gm-Features: AQt7F2o1mYHWKzEWh_QN4YUXAwPvOiLsy5RXvpwAstbpCGIo1TVSuF-YNV16snc
Message-ID: <CA+EHjTxzoN_rg9RQsq0BLgp9zp29rAx5Zxrndas07d5sjSQXLQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> Describe all the VTCR_EL2 fields and their respective configurations,
> making sure that we correctly ignore the bits that are not defined
> for a given guest configuration.
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad

>  arch/arm64/kvm/config.c | 69 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/nested.c |  3 +-
>  2 files changed, 70 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 3845b188551b6..9c04f895d3769 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -141,6 +141,7 @@ struct reg_feat_map_desc {
>  #define FEAT_AA64EL1           ID_AA64PFR0_EL1, EL1, IMP
>  #define FEAT_AA64EL2           ID_AA64PFR0_EL1, EL2, IMP
>  #define FEAT_AA64EL3           ID_AA64PFR0_EL1, EL3, IMP
> +#define FEAT_SEL2              ID_AA64PFR0_EL1, SEL2, IMP
>  #define FEAT_AIE               ID_AA64MMFR3_EL1, AIE, IMP
>  #define FEAT_S2POE             ID_AA64MMFR3_EL1, S2POE, IMP
>  #define FEAT_S1POE             ID_AA64MMFR3_EL1, S1POE, IMP
> @@ -202,6 +203,8 @@ struct reg_feat_map_desc {
>  #define FEAT_ASID2             ID_AA64MMFR4_EL1, ASID2, IMP
>  #define FEAT_MEC               ID_AA64MMFR3_EL1, MEC, IMP
>  #define FEAT_HAFT              ID_AA64MMFR1_EL1, HAFDBS, HAFT
> +#define FEAT_HDBSS             ID_AA64MMFR1_EL1, HAFDBS, HDBSS
> +#define FEAT_HPDS2             ID_AA64MMFR1_EL1, HPDS, HPDS2
>  #define FEAT_BTI               ID_AA64PFR1_EL1, BT, IMP
>  #define FEAT_ExS               ID_AA64MMFR0_EL1, EXS, IMP
>  #define FEAT_IESB              ID_AA64MMFR2_EL1, IESB, IMP
> @@ -219,6 +222,7 @@ struct reg_feat_map_desc {
>  #define FEAT_FGT2              ID_AA64MMFR0_EL1, FGT, FGT2
>  #define FEAT_MTPMU             ID_AA64DFR0_EL1, MTPMU, IMP
>  #define FEAT_HCX               ID_AA64MMFR1_EL1, HCX, IMP
> +#define FEAT_S2PIE             ID_AA64MMFR3_EL1, S2PIE, IMP
>
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
> @@ -362,6 +366,28 @@ static bool feat_pmuv3p9(struct kvm *kvm)
>         return check_pmu_revision(kvm, V3P9);
>  }
>
> +#define has_feat_s2tgran(k, s)                                         \
> +  ((kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, TGRAN##s) && \
> +    kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN##s, IMP))                     || \
> +   kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, IMP))
> +
> +static bool feat_lpa2(struct kvm *kvm)
> +{
> +       return ((kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT)    ||
> +                !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP))     &&
> +               (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT)   ||
> +                !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))    &&
> +               (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4_2, 52_BIT)  ||
> +                !has_feat_s2tgran(kvm, 4))                             &&
> +               (kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16_2, 52_BIT) ||
> +                !has_feat_s2tgran(kvm, 16)));
> +}
> +
> +static bool feat_vmid16(struct kvm *kvm)
> +{
> +       return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
> +}
> +
>  static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
>  {
>         /* This is purely academic: AArch32 and NV are mutually exclusive */
> @@ -1168,6 +1194,44 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
>  static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
>                               mdcr_el2_feat_map, FEAT_AA64EL2);
>
> +static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
> +       NEEDS_FEAT(VTCR_EL2_HDBSS, FEAT_HDBSS),
> +       NEEDS_FEAT(VTCR_EL2_HAFT, FEAT_HAFT),
> +       NEEDS_FEAT(VTCR_EL2_TL0         |
> +                  VTCR_EL2_TL1         |
> +                  VTCR_EL2_AssuredOnly |
> +                  VTCR_EL2_GCSH,
> +                  FEAT_THE),
> +       NEEDS_FEAT(VTCR_EL2_D128, FEAT_D128),
> +       NEEDS_FEAT(VTCR_EL2_S2POE, FEAT_S2POE),
> +       NEEDS_FEAT(VTCR_EL2_S2PIE, FEAT_S2PIE),
> +       NEEDS_FEAT(VTCR_EL2_SL2         |
> +                  VTCR_EL2_DS,
> +                  feat_lpa2),
> +       NEEDS_FEAT(VTCR_EL2_NSA         |
> +                  VTCR_EL2_NSW,
> +                  FEAT_SEL2),
> +       NEEDS_FEAT(VTCR_EL2_HWU62       |
> +                  VTCR_EL2_HWU61       |
> +                  VTCR_EL2_HWU60       |
> +                  VTCR_EL2_HWU59,
> +                  FEAT_HPDS2),
> +       NEEDS_FEAT(VTCR_EL2_HD, ID_AA64MMFR1_EL1, HAFDBS, DBM),
> +       NEEDS_FEAT(VTCR_EL2_HA, ID_AA64MMFR1_EL1, HAFDBS, AF),
> +       NEEDS_FEAT(VTCR_EL2_VS, feat_vmid16),
> +       NEEDS_FEAT(VTCR_EL2_PS          |
> +                  VTCR_EL2_TG0         |
> +                  VTCR_EL2_SH0         |
> +                  VTCR_EL2_ORGN0       |
> +                  VTCR_EL2_IRGN0       |
> +                  VTCR_EL2_SL0         |
> +                  VTCR_EL2_T0SZ,
> +                  FEAT_AA64EL1),
> +};
> +
> +static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
> +                             vtcr_el2_feat_map, FEAT_AA64EL2);
> +
>  static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>                                   int map_size, u64 resx, const char *str)
>  {
> @@ -1211,6 +1275,7 @@ void __init check_feature_map(void)
>         check_reg_desc(&tcr2_el2_desc);
>         check_reg_desc(&sctlr_el1_desc);
>         check_reg_desc(&mdcr_el2_desc);
> +       check_reg_desc(&vtcr_el2_desc);
>  }
>
>  static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
> @@ -1425,6 +1490,10 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
>                 *res0 = compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
>                 *res1 = MDCR_EL2_RES1;
>                 break;
> +       case VTCR_EL2:
> +               *res0 = compute_reg_res0_bits(kvm, &vtcr_el2_desc, 0, 0);
> +               *res1 = VTCR_EL2_RES1;
> +               break;
>         default:
>                 WARN_ON_ONCE(1);
>                 *res0 = *res1 = 0;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index e1ef8930c97b3..606cebcaa7c09 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1719,8 +1719,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>         set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
>
>         /* VTCR_EL2 */
> -       res0 = GENMASK(63, 32) | GENMASK(30, 20);
> -       res1 = BIT(31);
> +       get_reg_fixed_bits(kvm, VTCR_EL2, &res0, &res1);
>         set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
>
>         /* VMPIDR_EL2 */
> --
> 2.47.3
>

