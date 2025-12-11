Return-Path: <kvm+bounces-65774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81789CB6293
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7CA6330014F8
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0502D29AA;
	Thu, 11 Dec 2025 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qmFfHlUW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35D22D1319
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765462442; cv=pass; b=j/Ftk7b6a+t9DkV/u+3RxSsde/tNF5F0DTMISF96C11Cor2s4sCDtk6YCeLDct4oWA8EGCLfhlBu0MChvpQdg/cOhkUsosm0r89WVvjDnJ18EaM/cA+eY1FOlY26c+kwZTUa/Pn1cNkVe4+yUXUpN/OGNQV7/hJRdJjC7K7/uoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765462442; c=relaxed/simple;
	bh=HOmO7w9wX12Y3tO2vwswa40uELHQ7sGeubZv38Za8VA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrCJd+W1rBbGemrt2o9JkxUfO4TpxXLpjz2QiMzvz81DTLd/29iCuE3sZvADJN+U472qIgFXRwE58BILlwl306kiV9cZ3zDblfqAHxCrtpsEJA0KUmyUPnd4c8rq1SfaPemhUfNnkBO7M2lGtUbaHFyH3+HD8kIT5iqwvmgf6KU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qmFfHlUW; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ee147baf7bso424601cf.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:14:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765462440; cv=none;
        d=google.com; s=arc-20240605;
        b=OzGUYq87T4o8XoQf7x85WzIzFErVgsfPuZ1MYLQAHUgNTYMGxJ/2PP2d92Pj8bKMbu
         e14elHMk7FspvJ4iNHfIAoItOFblSZZZQkrjBgbq1YRvB2pe7vl9TkKd5AB2Lr7MVW1X
         cLC/4Z1FA7jAmUeiTgw3kEzO3BjXTITBNQ7V3IEESjqvHdVHa6gazfiCpTkTBkMtwC47
         Sgx4N86TFYsm61k8WW201rAqu2ldPQWhTi1p0V3d1Ngpg8p8VBNuxZ9VCzjimsqPA3Xz
         cRHwWtTLFKKSnESrpxDRPk7/9MO5qWIU5GeepjY3PAg8ABvsCuZ+yZouX4JeLUAPr18b
         cyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DbriQ0SkVMvNN6P53laWKo2APdvbpd18INbzHTP59Xc=;
        fh=UTDbe4simY4XBkJgOac4yLIh3W7Tr70M4QV9HLh5B3U=;
        b=XvZSwTh8qQh0TzWnxwPb8grmw2jESMA6JkS+KesuicNNKML8AWRJnf7haD+djuw1v6
         x0afr8qjeVFor3wR6L81mvU5kPKptbf5IdBhNBP9aYqYFDKR4YZB8THq2w8+L3uF+D0W
         gBMERMsi6l52qqyBYETp5ib0uvlJnEYjVkzx47u6eBKy3c75ptgNjMRiwLAbnUzp5T4E
         IDTsTOmgLjmwcO8sa0GFBtodKnlW7f2JU/IryALmsQ6uK5rMlJPZDPRcTYL3eTm6zGLS
         U5BytJfxGkmBqXVH6BHxER7Mmmq08I8VU4IOne8QC8P7RFA34tO8fnkDeKybuCOnZaqD
         QVRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765462440; x=1766067240; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DbriQ0SkVMvNN6P53laWKo2APdvbpd18INbzHTP59Xc=;
        b=qmFfHlUWvr+aqqg3oPSDOng2K/TOycwi5dkHvEMDFVFgy/y92A6fb6hae9mNgr2+Qj
         cQgZMhaWA2G3J6UWVyn3zNt8Ke62H1HRE0t/DoTVFrirtKH7fOmDcGwv/kaOh8INzDB0
         JlQgS7NbACPY10LbTvym/7BiVnf6XqxWNAv/r4/iEhZn37ExehBSuSlEYBI38Lu+HKTs
         vHui7E14fpNsXbmcnJRbfcsNLrDjCnNdtoWztFJv16o1fxTpBVNgV5HYFDvwXAZoBgJ2
         g2DKRiJg4O/M+gmAoGJeaCECztR4mFTqj4Ay9LbYnTAWWtWHrPIJtJjJIvGPoM7EK7Rq
         2Ryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765462440; x=1766067240;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbriQ0SkVMvNN6P53laWKo2APdvbpd18INbzHTP59Xc=;
        b=Ej4VkxE5FbZznr3xO06F28NWaHXRNy0Ezv6WvBHZ998Qkc+2INszrfsS0dx57hzv5f
         cpKiJCUnnIG3MLgYnsxnpo84a0CTk7C/h+SKxyL50loQCjX7JPC5VLjLhHWehGXDH5T7
         gLU8V2JKqNl9Wtu6EQUDA8xGJt3Dnqq+HzT1l+r9dcsa519Wmn0xn6+FISGIqoVn79Kn
         PHk+ZYLuEZA9SHDeuT1vuRP7us0gZDwAlgM8OKC2J0+Eofrc619Kf7lVlw2Ehd5I2/II
         ki3FSrbEfVkCoZt16ZsAQcNKxDPS+rWQ7tQfxR9FUOyIwXMhzBK3kpjNWEZiEmFTkRDN
         XTEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDTPseOZAs4bkjvVsHUguPfn4tkF3mXgzVD+OJD7OW7tHTirOqzjTGB/BGtaVgzro1Ecc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/RSycTQhILscAKKXGeMJUFLbXwIY/oa8sOiSmhKJ0NH1PmAbl
	lwSWNQiAUAVtiX+Scv3O+dyzcMUOgfQ74E0jhJ3QZS0xESVn2WM4pc7CEOPlgY/Af/TiHLF85QJ
	8eELwu+ZwjtMYw44aX7btjXL+2v08a4e7yuRXPjes
X-Gm-Gg: AY/fxX4sFTGVgW+DEFtukgYKkqvTREqPSwzhdKmOiiw0VXzYgcnE/0cHfdvstspCnGg
	7RGsYg/zsTuHB344IE06FOkjcNL5LCITJ2jM2/f0ms9D2Z5otN4i9XX9Q9GhpJ1egZAeaFu7f+n
	KsOwA/FEnOeq2Q4+/h+dbPXDBBot+ZKrW4ib7AYtuJjZAsY0aA02WiyrLeOPG4jigXQ8mey0Lkn
	iEQa66xzogv5crFCd3OH5GzOVH1JTbcpdY3ywD3s+n+GwfjnKsTRhkWoFLMiiYA+XD4O25b
X-Google-Smtp-Source: AGHT+IHsR5PweMeVDYCfFKFjDQpdQaAflU2RyEDDm5BFseo6Sjuat6mmlH3xwySmJNO3hwq7ZAvO0aIfX0lj5pQvCmM=
X-Received: by 2002:a05:622a:2a18:b0:4f1:bee9:f24a with SMTP id
 d75a77b69052e-4f1bee9f407mr9010731cf.0.1765462439165; Thu, 11 Dec 2025
 06:13:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-4-maz@kernel.org>
In-Reply-To: <20251210173024.561160-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:13:22 +0000
X-Gm-Features: AQt7F2rr9PtjIIiHtnFsFtlWwu7AuIjaSq1NTTsgICgihl-4XDKmWFGJmdfGQpU
Message-ID: <CA+EHjTyJFZttD4jTH=q_T28BwMR2CDdYSyH7G-WTQvULyjy-Tw@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] arm64: Convert VTCR_EL2 to sysreg infratructure
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

In subject: infratructure -> infrastructure


On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> Our definition of VTCR_EL2 is both partial (tons of fields are
> missing) and totally inconsistent (some constants are shifted,
> some are not). They are also expressed in terms of TCR, which is
> rather inconvenient.
>
> Replace the ad-hoc definitions with the the generated version.

Duplicate "the"

> This results in a bunch of additional changes to make the code
> with the unshifted nature of generated enumerations.
>
> The register data was extracted from the BSD licenced AARCHMRS
> (AARCHMRS_OPENSOURCE_A_profile_FAT-2025-09_ASL0).
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

After checking the bits against the spec, and with the nits above:

Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad

> ---
>  arch/arm64/include/asm/kvm_arm.h | 52 +++++++----------------------
>  arch/arm64/include/asm/sysreg.h  |  1 -
>  arch/arm64/kvm/hyp/pgtable.c     |  8 ++---
>  arch/arm64/kvm/nested.c          |  8 ++---
>  arch/arm64/tools/sysreg          | 57 ++++++++++++++++++++++++++++++++
>  5 files changed, 76 insertions(+), 50 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index e500600e4b9b8..dfdbd2b65db9e 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -124,37 +124,7 @@
>  #define TCR_EL2_MASK   (TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
>                          TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
>
> -/* VTCR_EL2 Registers bits */
> -#define VTCR_EL2_DS            TCR_EL2_DS
> -#define VTCR_EL2_RES1          (1U << 31)
> -#define VTCR_EL2_HD            (1 << 22)
> -#define VTCR_EL2_HA            (1 << 21)
> -#define VTCR_EL2_PS_SHIFT      TCR_EL2_PS_SHIFT
> -#define VTCR_EL2_PS_MASK       TCR_EL2_PS_MASK
> -#define VTCR_EL2_TG0_MASK      TCR_TG0_MASK
> -#define VTCR_EL2_TG0_4K                TCR_TG0_4K
> -#define VTCR_EL2_TG0_16K       TCR_TG0_16K
> -#define VTCR_EL2_TG0_64K       TCR_TG0_64K
> -#define VTCR_EL2_SH0_MASK      TCR_SH0_MASK
> -#define VTCR_EL2_SH0_INNER     TCR_SH0_INNER
> -#define VTCR_EL2_ORGN0_MASK    TCR_ORGN0_MASK
> -#define VTCR_EL2_ORGN0_WBWA    TCR_ORGN0_WBWA
> -#define VTCR_EL2_IRGN0_MASK    TCR_IRGN0_MASK
> -#define VTCR_EL2_IRGN0_WBWA    TCR_IRGN0_WBWA
> -#define VTCR_EL2_SL0_SHIFT     6
> -#define VTCR_EL2_SL0_MASK      (3 << VTCR_EL2_SL0_SHIFT)
> -#define VTCR_EL2_T0SZ_MASK     0x3f
> -#define VTCR_EL2_VS_SHIFT      19
> -#define VTCR_EL2_VS_8BIT       (0 << VTCR_EL2_VS_SHIFT)
> -#define VTCR_EL2_VS_16BIT      (1 << VTCR_EL2_VS_SHIFT)
> -
> -#define VTCR_EL2_T0SZ(x)       TCR_T0SZ(x)
> -
>  /*
> - * We configure the Stage-2 page tables to always restrict the IPA space to be
> - * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
> - * not known to exist and will break with this configuration.
> - *
>   * The VTCR_EL2 is configured per VM and is initialised in kvm_init_stage2_mmu.
>   *
>   * Note that when using 4K pages, we concatenate two first level page tables
> @@ -162,9 +132,6 @@
>   *
>   */
>
> -#define VTCR_EL2_COMMON_BITS   (VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
> -                                VTCR_EL2_IRGN0_WBWA | VTCR_EL2_RES1)
> -
>  /*
>   * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
>   * Interestingly, it depends on the page size.
> @@ -196,30 +163,35 @@
>   */
>  #ifdef CONFIG_ARM64_64K_PAGES
>
> -#define VTCR_EL2_TGRAN                 VTCR_EL2_TG0_64K
> +#define VTCR_EL2_TGRAN                 64K
>  #define VTCR_EL2_TGRAN_SL0_BASE                3UL
>
>  #elif defined(CONFIG_ARM64_16K_PAGES)
>
> -#define VTCR_EL2_TGRAN                 VTCR_EL2_TG0_16K
> +#define VTCR_EL2_TGRAN                 16K
>  #define VTCR_EL2_TGRAN_SL0_BASE                3UL
>
>  #else  /* 4K */
>
> -#define VTCR_EL2_TGRAN                 VTCR_EL2_TG0_4K
> +#define VTCR_EL2_TGRAN                 4K
>  #define VTCR_EL2_TGRAN_SL0_BASE                2UL
>
>  #endif
>
>  #define VTCR_EL2_LVLS_TO_SL0(levels)   \
> -       ((VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))) << VTCR_EL2_SL0_SHIFT)
> +       FIELD_PREP(VTCR_EL2_SL0, (VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))))
>  #define VTCR_EL2_SL0_TO_LVLS(sl0)      \
>         ((sl0) + 4 - VTCR_EL2_TGRAN_SL0_BASE)
>  #define VTCR_EL2_LVLS(vtcr)            \
> -       VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
> +       VTCR_EL2_SL0_TO_LVLS(FIELD_GET(VTCR_EL2_SL0, (vtcr)))
> +
> +#define VTCR_EL2_FLAGS (SYS_FIELD_PREP_ENUM(VTCR_EL2, SH0, INNER)          | \
> +                        SYS_FIELD_PREP_ENUM(VTCR_EL2, ORGN0, WBWA)         | \
> +                        SYS_FIELD_PREP_ENUM(VTCR_EL2, IRGN0, WBWA)         | \
> +                        SYS_FIELD_PREP_ENUM(VTCR_EL2, TG0, VTCR_EL2_TGRAN) | \
> +                        VTCR_EL2_RES1)
>
> -#define VTCR_EL2_FLAGS                 (VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN)
> -#define VTCR_EL2_IPA(vtcr)             (64 - ((vtcr) & VTCR_EL2_T0SZ_MASK))
> +#define VTCR_EL2_IPA(vtcr)             (64 - FIELD_GET(VTCR_EL2_T0SZ, (vtcr)))
>
>  /*
>   * ARM VMSAv8-64 defines an algorithm for finding the translation table
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index c231d2a3e5159..acad7a7621b9e 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -516,7 +516,6 @@
>  #define SYS_TTBR1_EL2                  sys_reg(3, 4, 2, 0, 1)
>  #define SYS_TCR_EL2                    sys_reg(3, 4, 2, 0, 2)
>  #define SYS_VTTBR_EL2                  sys_reg(3, 4, 2, 1, 0)
> -#define SYS_VTCR_EL2                   sys_reg(3, 4, 2, 1, 2)
>
>  #define SYS_HAFGRTR_EL2                        sys_reg(3, 4, 3, 1, 6)
>  #define SYS_SPSR_EL2                   sys_reg(3, 4, 4, 0, 0)
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 947ac1a951a5b..e0bd6a0172729 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -583,8 +583,8 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>         u64 vtcr = VTCR_EL2_FLAGS;
>         s8 lvls;
>
> -       vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
> -       vtcr |= VTCR_EL2_T0SZ(phys_shift);
> +       vtcr |= FIELD_PREP(VTCR_EL2_PS, kvm_get_parange(mmfr0));
> +       vtcr |= FIELD_PREP(VTCR_EL2_T0SZ, (UL(64) - phys_shift));
>         /*
>          * Use a minimum 2 level page table to prevent splitting
>          * host PMD huge pages at stage2.
> @@ -624,9 +624,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>                 vtcr |= VTCR_EL2_DS;
>
>         /* Set the vmid bits */
> -       vtcr |= (get_vmid_bits(mmfr1) == 16) ?
> -               VTCR_EL2_VS_16BIT :
> -               VTCR_EL2_VS_8BIT;
> +       vtcr |= (get_vmid_bits(mmfr1) == 16) ? VTCR_EL2_VS : 0;
>
>         return vtcr;
>  }
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 911fc99ed99d9..e1ef8930c97b3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -377,7 +377,7 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
>  {
>         wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
>
> -       switch (vtcr & VTCR_EL2_TG0_MASK) {
> +       switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
>         case VTCR_EL2_TG0_4K:
>                 wi->pgshift = 12;        break;
>         case VTCR_EL2_TG0_16K:
> @@ -513,7 +513,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
>
>         lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
>
> -       switch (vtcr & VTCR_EL2_TG0_MASK) {
> +       switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
>         case VTCR_EL2_TG0_4K:
>                 ttl = (TLBI_TTL_TG_4K << 2);
>                 break;
> @@ -530,7 +530,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
>
>  again:
>         /* Iteratively compute the block sizes for a particular granule size */
> -       switch (vtcr & VTCR_EL2_TG0_MASK) {
> +       switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
>         case VTCR_EL2_TG0_4K:
>                 if      (sz < SZ_4K)    sz = SZ_4K;
>                 else if (sz < SZ_2M)    sz = SZ_2M;
> @@ -593,7 +593,7 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
>
>         if (!max_size) {
>                 /* Compute the maximum extent of the invalidation */
> -               switch (mmu->tlb_vtcr & VTCR_EL2_TG0_MASK) {
> +               switch (FIELD_GET(VTCR_EL2_TG0_MASK, mmu->tlb_vtcr)) {
>                 case VTCR_EL2_TG0_4K:
>                         max_size = SZ_1G;
>                         break;
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 9d388f87d9a13..6f43b2ae5993b 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4400,6 +4400,63 @@ Field    56:12   BADDR
>  Res0   11:0
>  EndSysreg
>
> +Sysreg VTCR_EL2        3       4       2       1       2
> +Res0   63:46
> +Field  45      HDBSS
> +Field  44      HAFT
> +Res0   43:42
> +Field  41      TL0
> +Field  40      GCSH
> +Res0   39
> +Field  38      D128
> +Field  37      S2POE
> +Field  36      S2PIE
> +Field  35      TL1
> +Field  34      AssuredOnly
> +Field  33      SL2
> +Field  32      DS
> +Res1   31
> +Field  30      NSA
> +Field  29      NSW
> +Field  28      HWU62
> +Field  27      HWU61
> +Field  26      HWU60
> +Field  25      HWU59
> +Res0   24:23
> +Field  22      HD
> +Field  21      HA
> +Res0   20
> +Enum   19      VS
> +       0b0     8BIT
> +       0b1     16BIT
> +EndEnum
> +Field  18:16   PS
> +Enum   15:14   TG0
> +       0b00    4K
> +       0b01    64K
> +       0b10    16K
> +EndEnum
> +Enum   13:12   SH0
> +       0b00    NONE
> +       0b01    OUTER
> +       0b11    INNER
> +EndEnum
> +Enum   11:10   ORGN0
> +       0b00    NC
> +       0b01    WBWA
> +       0b10    WT
> +       0b11    WBnWA
> +EndEnum
> +Enum   9:8     IRGN0
> +       0b00    NC
> +       0b01    WBWA
> +       0b10    WT
> +       0b11    WBnWA
> +EndEnum
> +Field  7:6     SL0
> +Field  5:0     T0SZ
> +EndSysreg
> +
>  Sysreg GCSCR_EL2       3       4       2       5       0
>  Fields GCSCR_ELx
>  EndSysreg
> --
> 2.47.3
>

