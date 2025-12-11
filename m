Return-Path: <kvm+bounces-65776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B61FCCB62F7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 38ADB301B488
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE83E555;
	Thu, 11 Dec 2025 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQ5Xg4IY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1051315D27
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463445; cv=pass; b=BzrcEZPZLdsXIg5ANgrbckvn2bWDafUAYjOlrRFp7WucB3BVvY/KJQJ2gLiSxUnquoRBtuTxe9BRQRIzNCtfUiNfoTIBtDFys246TuewyGjJncKboftTXRdPr9Rq4tiQCtw3wbZY2QmhodjhV0lgvukW/oL+6oQ93jge/OFh28M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463445; c=relaxed/simple;
	bh=JFjzYzXKwQSP6iSsNRz75EAq2acEDG9Cc+XM1pWcsDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gutv8ekBiyMLqN938RrilajjvnMDlpJzmTuxFweNWB/epJiWCgv9heVEXrMonqeYDlyBtfzFeMKP+DqP+h6z10XK1hkbFl700szK44dtxFkHFv70OeQdD286InjcUuyEgbW3rTrE95VGZNaG2b+RDh5ODld+oLlMld7JSWK8cms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQ5Xg4IY; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4edb8d6e98aso628071cf.0
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:30:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765463441; cv=none;
        d=google.com; s=arc-20240605;
        b=W4mMXAcgmDf33AzOY0d0obUvp98zym6kgN+MuUq4K0VnYsAlWjwHd5LQAzOFhr4iCE
         k3tae17rukOfZ3Xp/ZApmTwPO5r8NYxMcovpr73cbgmcnmpIfJIvejlVqVRUK9lmHftq
         l1s2iPPIlZQXQ/V4aUSzGwagwLjgWAWalG2dvNsgTNlgLFmh4e05PujQJykFs5079CAW
         eXsiuX8iBwZKDOo2fokvoochk33Tbte3lRs9kWHjaj3yFBg/XWHF55tEdfVWxDxSTmwH
         1rCTFdD6J9z6f4BpxP3YR68yqN3iKHE5lNnaxXVt0+cG4OMpUyi1KjsnrLThMRLbj8yR
         Mzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CXKK+XMOV+BG1j0Dmg65GZuKWhjmotSC6I9z/HN+0TE=;
        fh=hg39gY90MS3J+CSXJ09EQVnJ6sg03zMO8aPDkH16z/8=;
        b=C8r1TAnUGsapnByDHlGK6oCRYr2zsF+bkhRSB01roZU1MqFFFgmTxHgfD/PrvKqzJM
         ys8S8kkuoOSONW1k6voN1TlVBofghMQYeKlKeUUHwEFj4+0iayGJ6siHqz3MrYzCr9nS
         YoVLrFFkuMUq97OrLFjpi55YwveiJK1VW5J/18+H+5yLMwZl0ylWP8a7T1kxsMerVczA
         zjx4vN583xDoZ29/TSr/kyc+i/PKq7ryOih+PxOuw8Z2EiAveCoFVazVjsM+UHxSXFo6
         cvRuu1sKBWLvSMDtPSUn3zGeUpFbGSlOS/YG73ObH6tcbJ09z4AD7PniIqbHKCSkWSFu
         9O8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765463441; x=1766068241; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CXKK+XMOV+BG1j0Dmg65GZuKWhjmotSC6I9z/HN+0TE=;
        b=CQ5Xg4IYQaCAqzmBrTZgSwe0fb849ayC8ZtLpmOuJ7ViW2YysqcSODVBizb7wkhVT1
         6o4R3OU9DU9MupnYmCXqnvkkfzXwg/zyT6Bt4xWySC1ZYgHrEG4Srf/9FqLV9MwB9ZMM
         ijYTs7+5mrnAkO3CV32kvx53JxYhq0cCO+Nvp/lXJSSv3AKcUE3kDXr4s7BEQCBX8PyX
         wI9VkDdMEJ+6YimF1yYwxnr9Zek+ZlslwzE4nBoVXUep2jRFMCOGrpxU3fp32BmN5hjF
         6OT1P0BsNqoVWR5XAMA9y/ejUVgyCOco0mOCALIi6G0NBFPA89CSe4OWaLb6Hc1V7bHW
         lSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765463441; x=1766068241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CXKK+XMOV+BG1j0Dmg65GZuKWhjmotSC6I9z/HN+0TE=;
        b=GKHh1IMCRrzq4homoTjwjHHokx7iFxZ8EY0sOVZXOTkakrHDaJydmc/vVctZYyZ0KO
         fmnU3JSga5ocOKC4+lG+YQmlaGXHIYvbbhRUac7kkGzGI8EcVc6s7C4Vge3xAwGZ3mhz
         cwDGJyGOl6o9LkF2zKAoW3eAcRj8RuLHRUkw00NQTxn1LKkyXA8tmzdLUNjIrL5bVzG4
         L8qGFmGx/burxcO1Gfkwf9AiU5XiEGI8QrBOJtVJu6b2sPMisTk4NROJ0l17gNX8kiI2
         H3ngEFEbtEC2YQZYAcBnOe2eYHXI7wDB2t5pgaSz6E8JYYpRzzCzt74hFf4Ks+yJ+sCy
         URIA==
X-Forwarded-Encrypted: i=1; AJvYcCXCAn5ZxafTu3VBrNu+w128Tz7LNRANgzx4v1BFwugZW7uVIyoNOgoCK81pCHRj04WHhQM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvGdAtLHuTyIt0XU/c/jb3OKF+4aXkVZYCOOfa9XgCNIIORrgC
	S6r38UtYQ9LGEwgNJXWPPn2Kjb3Bjn9VlYbyeG71kq83LqmZHs6DINL0Nc/PBMSof5XA0e6LgeZ
	WMp60kSqD8D0g2xLWVsVFz01QrxluDwwP7dV1NZad
X-Gm-Gg: AY/fxX6llSithQlSb+PcCCrlcboEL6WsJTeAddKkYBX9IiCOiGw7AB9vbgQd12kKoN/
	ZF15LctfI4WDHnuzHKtRDC/7xP+v0FXScYatVtPIbo/JOsS1Tsosx4NTy8P8DphV1/bVEccdvGF
	Jrh1grg19MzBtRoB54IG1l9r3jom7cNxeS3IkTpaKRSOqtVGo4kdSbrmeRdpcP+piWENmArB6+r
	ZhwWSBTT65z8EQwKKBcHExylrbI44xXLn1jXngCqFCtt9a9LdJW487/O6kLR5UNrY3KpXQD
X-Google-Smtp-Source: AGHT+IHOTRmzXfJZ1LxuUaQCR8PjN6XcJs7sQ/sZlzHzbcwman+GYjtDsYLbkyW9r2wgCAu14xGlJhBPAApNgAZIVaM=
X-Received: by 2002:a05:622a:a:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4f1bee1ac37mr9103321cf.19.1765463440630; Thu, 11 Dec 2025
 06:30:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-5-maz@kernel.org>
In-Reply-To: <20251210173024.561160-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:30:03 +0000
X-Gm-Features: AQt7F2pDHRhtoAmbiPDRAiv1SfNZGM-FeRtbrSAxL2i7eJPuZsyFVaRGyD0DPvo
Message-ID: <CA+EHjTy2=NjAOwG32_Aj2akEDS8yo92nTMmd_rkUPABDAAcdAA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
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
> None of the registers we manage in the feature dependency infrastructure
> so far has any RES1 bit. This is about to change, as VTCR_EL2 has
> its bit 31 being RES1.
>
> In order to not fail the consistency checks by not describing a bit,
> add RES1 bits to the set of immutable bits. This requires some extra
> surgery for the FGT handling, as we now need to track RES1 bits there
> as well.
>
> There are no RES1 FGT bits *yet*. Watch this space.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>


Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad

> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/config.c           | 25 +++++++-------
>  arch/arm64/kvm/emulate-nested.c   | 55 +++++++++++++++++--------------
>  3 files changed, 45 insertions(+), 36 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac7f970c78830..b552a1e03848c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -638,6 +638,7 @@ struct fgt_masks {
>         u64             mask;
>         u64             nmask;
>         u64             res0;
> +       u64             res1;
>  };
>
>  extern struct fgt_masks hfgrtr_masks;
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 24bb3f36e9d59..3845b188551b6 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -16,14 +16,14 @@
>   */
>  struct reg_bits_to_feat_map {
>         union {
> -               u64     bits;
> -               u64     *res0p;
> +               u64              bits;
> +               struct fgt_masks *masks;
>         };
>
>  #define        NEVER_FGU       BIT(0)  /* Can trap, but never UNDEF */
>  #define        CALL_FUNC       BIT(1)  /* Needs to evaluate tons of crap */
>  #define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
> -#define        RES0_POINTER    BIT(3)  /* Pointer to RES0 value instead of bits */
> +#define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>
>         unsigned long   flags;
>
> @@ -92,8 +92,8 @@ struct reg_feat_map_desc {
>  #define NEEDS_FEAT_FIXED(m, ...)                       \
>         __NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
>
> -#define NEEDS_FEAT_RES0(p, ...)                                \
> -       __NEEDS_FEAT_FLAG(p, RES0_POINTER, res0p, __VA_ARGS__)
> +#define NEEDS_FEAT_MASKS(p, ...)                               \
> +       __NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
>
>  /*
>   * Declare the dependency between a set of bits and a set of features,
> @@ -109,19 +109,20 @@ struct reg_feat_map_desc {
>  #define DECLARE_FEAT_MAP(n, r, m, f)                                   \
>         struct reg_feat_map_desc n = {                                  \
>                 .name                   = #r,                           \
> -               .feat_map               = NEEDS_FEAT(~r##_RES0, f),     \
> +               .feat_map               = NEEDS_FEAT(~(r##_RES0 |       \
> +                                                      r##_RES1), f),   \
>                 .bit_feat_map           = m,                            \
>                 .bit_feat_map_sz        = ARRAY_SIZE(m),                \
>         }
>
>  /*
>   * Specialised version of the above for FGT registers that have their
> - * RES0 masks described as struct fgt_masks.
> + * RESx masks described as struct fgt_masks.
>   */
>  #define DECLARE_FEAT_MAP_FGT(n, msk, m, f)                             \
>         struct reg_feat_map_desc n = {                                  \
>                 .name                   = #msk,                         \
> -               .feat_map               = NEEDS_FEAT_RES0(&msk.res0, f),\
> +               .feat_map               = NEEDS_FEAT_MASKS(&msk, f),    \
>                 .bit_feat_map           = m,                            \
>                 .bit_feat_map_sz        = ARRAY_SIZE(m),                \
>         }
> @@ -1168,21 +1169,21 @@ static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
>                               mdcr_el2_feat_map, FEAT_AA64EL2);
>
>  static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
> -                                 int map_size, u64 res0, const char *str)
> +                                 int map_size, u64 resx, const char *str)
>  {
>         u64 mask = 0;
>
>         for (int i = 0; i < map_size; i++)
>                 mask |= map[i].bits;
>
> -       if (mask != ~res0)
> +       if (mask != ~resx)
>                 kvm_err("Undefined %s behaviour, bits %016llx\n",
> -                       str, mask ^ ~res0);
> +                       str, mask ^ ~resx);
>  }
>
>  static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
>  {
> -       return map->flags & RES0_POINTER ? ~(*map->res0p) : map->bits;
> +       return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask) : map->bits;
>  }
>
>  static void __init check_reg_desc(const struct reg_feat_map_desc *r)
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 834f13fb1fb7d..75d49f83342a5 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2105,23 +2105,24 @@ static u32 encoding_next(u32 encoding)
>  }
>
>  #define FGT_MASKS(__n, __m)                                            \
> -       struct fgt_masks __n = { .str = #__m, .res0 = __m, }
> -
> -FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
> -FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
> -FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
> -FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
> -FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
> -FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
> -FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2_RES0);
> -FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2_RES0);
> -FGT_MASKS(hfgitr2_masks, HFGITR2_EL2_RES0);
> -FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2_RES0);
> -FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2_RES0);
> +       struct fgt_masks __n = { .str = #__m, .res0 = __m ## _RES0, .res1 = __m ## _RES1 }
> +
> +FGT_MASKS(hfgrtr_masks, HFGRTR_EL2);
> +FGT_MASKS(hfgwtr_masks, HFGWTR_EL2);
> +FGT_MASKS(hfgitr_masks, HFGITR_EL2);
> +FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2);
> +FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2);
> +FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2);
> +FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2);
> +FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
> +FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
> +FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
> +FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
>
>  static __init bool aggregate_fgt(union trap_config tc)
>  {
>         struct fgt_masks *rmasks, *wmasks;
> +       u64 rresx, wresx;
>
>         switch (tc.fgt) {
>         case HFGRTR_GROUP:
> @@ -2154,24 +2155,27 @@ static __init bool aggregate_fgt(union trap_config tc)
>                 break;
>         }
>
> +       rresx = rmasks->res0 | rmasks->res1;
> +       if (wmasks)
> +               wresx = wmasks->res0 | wmasks->res1;
> +
>         /*
>          * A bit can be reserved in either the R or W register, but
>          * not both.
>          */
> -       if ((BIT(tc.bit) & rmasks->res0) &&
> -           (!wmasks || (BIT(tc.bit) & wmasks->res0)))
> +       if ((BIT(tc.bit) & rresx) && (!wmasks || (BIT(tc.bit) & wresx)))
>                 return false;
>
>         if (tc.pol)
> -               rmasks->mask |= BIT(tc.bit) & ~rmasks->res0;
> +               rmasks->mask |= BIT(tc.bit) & ~rresx;
>         else
> -               rmasks->nmask |= BIT(tc.bit) & ~rmasks->res0;
> +               rmasks->nmask |= BIT(tc.bit) & ~rresx;
>
>         if (wmasks) {
>                 if (tc.pol)
> -                       wmasks->mask |= BIT(tc.bit) & ~wmasks->res0;
> +                       wmasks->mask |= BIT(tc.bit) & ~wresx;
>                 else
> -                       wmasks->nmask |= BIT(tc.bit) & ~wmasks->res0;
> +                       wmasks->nmask |= BIT(tc.bit) & ~wresx;
>         }
>
>         return true;
> @@ -2180,7 +2184,6 @@ static __init bool aggregate_fgt(union trap_config tc)
>  static __init int check_fgt_masks(struct fgt_masks *masks)
>  {
>         unsigned long duplicate = masks->mask & masks->nmask;
> -       u64 res0 = masks->res0;
>         int ret = 0;
>
>         if (duplicate) {
> @@ -2194,10 +2197,14 @@ static __init int check_fgt_masks(struct fgt_masks *masks)
>                 ret = -EINVAL;
>         }
>
> -       masks->res0 = ~(masks->mask | masks->nmask);
> -       if (masks->res0 != res0)
> -               kvm_info("Implicit %s = %016llx, expecting %016llx\n",
> -                        masks->str, masks->res0, res0);
> +       if ((masks->res0 | masks->res1 | masks->mask | masks->nmask) != GENMASK(63, 0) ||
> +           (masks->res0 & masks->res1)  || (masks->res0 & masks->mask) ||
> +           (masks->res0 & masks->nmask) || (masks->res1 & masks->mask)  ||
> +           (masks->res1 & masks->nmask) || (masks->mask & masks->nmask)) {
> +               kvm_info("Inconsistent masks for %s (%016llx, %016llx, %016llx, %016llx)\n",
> +                        masks->str, masks->res0, masks->res1, masks->mask, masks->nmask);
> +               masks->res0 = ~(masks->res1 | masks->mask | masks->nmask);
> +       }
>
>         return ret;
>  }
> --
> 2.47.3
>

