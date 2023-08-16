Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4D077D6FE
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 02:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240781AbjHPAT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 20:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240782AbjHPATB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 20:19:01 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB601FE8
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:19:00 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2bad7499bdcso51818511fa.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692145138; x=1692749938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hINCttDAw/0V7xDMIG5wHPGqwxMTIWA7EUWR2DNmLvo=;
        b=XbDebR8ruRacGaEk+2WQ1N9hAOSkJvKh32WzyHtQ/fQMTOzxf6s4o0Ku7tjj/cgAwg
         dTS87NuV6/xn1O/aZHyemYx+huwVCLA/zqDEND+uYPn8NUGHed6Q4Ff+PjmHonj3aEnn
         Wu0t3iNHxZBqXjDy7wgbms6EEcsFLmDS/8Ki5cRqH6q9ox6Ql01/3cw3xDrI0Q8orvEq
         JXENyFCVcoQzdq3z1i5UCS9K9TyiPf7YC0bAoYju/qWp3XChgYtQsIMvii5FisRtKQ7Q
         DU73wvKTNrCmxRfCMqx5rwvUNerbpQBnPEVu1trDiJVOt9FVc8hcLtrOrbSobbO8Gi0Y
         +P8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692145138; x=1692749938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hINCttDAw/0V7xDMIG5wHPGqwxMTIWA7EUWR2DNmLvo=;
        b=JwjsmTYwMdc+Yje25CPIgYCHDypSuMsdnjZEHkqUJcvLAqqHKcvUTsXv/VquJFDSmX
         kF0kfqankWMsL0px278Iu9qb22u/EmDwWYMEgCRNfw+9PVo1lKX9ueBq4+7y/wLRepJ3
         1B5RhDWiWNTQDfDEurphssmEqyaQGsOMtbSr2TQNvhnh9J9lRRKVZ8hqKU5AXpd7F+D/
         N55QCEKQNAPrIeddBhu2PI3KLYiipTQtJGADHOH4IAQA2X1SgyK6CyAS6v8eRyWQDCf9
         N3XUE6r4sgiTJ5WNzb4WiEKBqWbcA5O0M/8Wfw1u6ikR3xojgkyU2sl+oxDLNRXvN+0f
         4y6w==
X-Gm-Message-State: AOJu0Yx8v3p90ERmFDXYxNUu+KlAgVu9Lz3z5EHe8fn06Hzx3QGASXs9
        1DZXX1gRr9zxCovgN+a9wNmvxhdiqjZ3+8dmZDsmZw==
X-Google-Smtp-Source: AGHT+IGkjpFMkGQKMRmISTvNZHl5aLAZA9AI3EMoWh0IWJC16T0/N6JKkE+we2BsQrPEXZIxpvrKGGbgFMSs8+DTyyE=
X-Received: by 2002:a2e:80c7:0:b0:2b6:cbba:1307 with SMTP id
 r7-20020a2e80c7000000b002b6cbba1307mr285788ljg.0.1692145138257; Tue, 15 Aug
 2023 17:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-29-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-29-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 17:18:45 -0700
Message-ID: <CAAdAUtisngOHtV0sjo3FB7oO5cw=q--Qjs0Oi57EbN6_ojnWsQ@mail.gmail.com>
Subject: Re: [PATCH v4 28/28] KVM: arm64: nv: Add support for HCRX_EL2
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> HCRX_EL2 has an interesting effect on HFGITR_EL2, as it conditions
> the traps of TLBI*nXS.
>
> Expand the FGT support to add a new Fine Grained Filter that will
> get checked when the instruction gets trapped, allowing the shadow
> register to override the trap as needed.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h        |  5 ++
>  arch/arm64/include/asm/kvm_host.h       |  1 +
>  arch/arm64/kvm/emulate-nested.c         | 94 ++++++++++++++++---------
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++-
>  arch/arm64/kvm/nested.c                 |  3 +-
>  arch/arm64/kvm/sys_regs.c               |  2 +
>  6 files changed, 83 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index d229f238c3b6..137f732789c9 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -369,6 +369,11 @@
>  #define __HDFGWTR_EL2_MASK     ~__HDFGWTR_EL2_nMASK
>  #define __HDFGWTR_EL2_nMASK    GENMASK(62, 60)
>
> +/* Similar definitions for HCRX_EL2 */
> +#define __HCRX_EL2_RES0                (GENMASK(63, 16) | GENMASK(13, 12=
))
> +#define __HCRX_EL2_MASK                (0)
> +#define __HCRX_EL2_nMASK       (GENMASK(15, 14) | GENMASK(4, 0))
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK     (~UL(0xf))
>  /*
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index cb1c5c54cedd..93c541111dea 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -380,6 +380,7 @@ enum vcpu_sysreg {
>         CPTR_EL2,       /* Architectural Feature Trap Register (EL2) */
>         HSTR_EL2,       /* Hypervisor System Trap Register */
>         HACR_EL2,       /* Hypervisor Auxiliary Control Register */
> +       HCRX_EL2,       /* Extended Hypervisor Configuration Register */
>         TTBR0_EL2,      /* Translation Table Base Register 0 (EL2) */
>         TTBR1_EL2,      /* Translation Table Base Register 1 (EL2) */
>         TCR_EL2,        /* Translation Control Register (EL2) */
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index c9662f9a345e..1cc606c16416 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -426,11 +426,13 @@ static const complex_condition_check ccc[] =3D {
>   * [13:10]     enum fgt_group_id (4 bits)
>   * [19:14]     bit number in the FGT register (6 bits)
>   * [20]                trap polarity (1 bit)
> - * [62:21]     Unused (42 bits)
> + * [25:21]     FG filter (5 bits)
> + * [62:26]     Unused (37 bits)
>   * [63]                RES0 - Must be zero, as lost on insertion in the =
xarray
>   */
>  #define TC_CGT_BITS    10
>  #define TC_FGT_BITS    4
> +#define TC_FGF_BITS    5
>
>  union trap_config {
>         u64     val;
> @@ -439,7 +441,8 @@ union trap_config {
>                 unsigned long   fgt:TC_FGT_BITS; /* Fine Grained Trap id =
*/
>                 unsigned long   bit:6;           /* Bit number */
>                 unsigned long   pol:1;           /* Polarity */
> -               unsigned long   unused:42;       /* Unused, should be zer=
o */
> +               unsigned long   fgf:TC_FGF_BITS; /* Fine Grained Filter *=
/
> +               unsigned long   unused:37;       /* Unused, should be zer=
o */
>                 unsigned long   mbz:1;           /* Must Be Zero */
>         };
>  };
> @@ -947,7 +950,15 @@ enum fgt_group_id {
>         __NR_FGT_GROUP_IDS__
>  };
>
> -#define SR_FGT(sr, g, b, p)                                    \
> +enum fg_filter_id {
> +       __NO_FGF__,
> +       HCRX_FGTnXS,
> +
> +       /* Must be last */
> +       __NR_FG_FILTER_IDS__
> +};
> +
> +#define SR_FGF(sr, g, b, p, f)                                 \
>         {                                                       \
>                 .encoding       =3D sr,                           \
>                 .end            =3D sr,                           \
> @@ -955,10 +966,13 @@ enum fgt_group_id {
>                         .fgt =3D g ## _GROUP,                     \
>                         .bit =3D g ## _EL2_ ## b ## _SHIFT,       \
>                         .pol =3D p,                               \
> +                       .fgf =3D f,                               \
>                 },                                              \
>                 .line =3D __LINE__,                               \
>         }
>
> +#define SR_FGT(sr, g, b, p)    SR_FGF(sr, g, b, p, __NO_FGF__)
> +
>  static const struct encoding_to_trap_config encoding_to_fgt[] __initcons=
t =3D {
>         /* HFGRTR_EL2, HFGWTR_EL2 */
>         SR_FGT(SYS_TPIDR2_EL0,          HFGxTR, nTPIDR2_EL0, 0),
> @@ -1062,37 +1076,37 @@ static const struct encoding_to_trap_config encod=
ing_to_fgt[] __initconst =3D {
>         SR_FGT(OP_TLBI_ASIDE1OS,        HFGITR, TLBIASIDE1OS, 1),
>         SR_FGT(OP_TLBI_VAE1OS,          HFGITR, TLBIVAE1OS, 1),
>         SR_FGT(OP_TLBI_VMALLE1OS,       HFGITR, TLBIVMALLE1OS, 1),
> -       /* FIXME: nXS variants must be checked against HCRX_EL2.FGTnXS */
> -       SR_FGT(OP_TLBI_VAALE1NXS,       HFGITR, TLBIVAALE1, 1),
> -       SR_FGT(OP_TLBI_VALE1NXS,        HFGITR, TLBIVALE1, 1),
> -       SR_FGT(OP_TLBI_VAAE1NXS,        HFGITR, TLBIVAAE1, 1),
> -       SR_FGT(OP_TLBI_ASIDE1NXS,       HFGITR, TLBIASIDE1, 1),
> -       SR_FGT(OP_TLBI_VAE1NXS,         HFGITR, TLBIVAE1, 1),
> -       SR_FGT(OP_TLBI_VMALLE1NXS,      HFGITR, TLBIVMALLE1, 1),
> -       SR_FGT(OP_TLBI_RVAALE1NXS,      HFGITR, TLBIRVAALE1, 1),
> -       SR_FGT(OP_TLBI_RVALE1NXS,       HFGITR, TLBIRVALE1, 1),
> -       SR_FGT(OP_TLBI_RVAAE1NXS,       HFGITR, TLBIRVAAE1, 1),
> -       SR_FGT(OP_TLBI_RVAE1NXS,        HFGITR, TLBIRVAE1, 1),
> -       SR_FGT(OP_TLBI_RVAALE1ISNXS,    HFGITR, TLBIRVAALE1IS, 1),
> -       SR_FGT(OP_TLBI_RVALE1ISNXS,     HFGITR, TLBIRVALE1IS, 1),
> -       SR_FGT(OP_TLBI_RVAAE1ISNXS,     HFGITR, TLBIRVAAE1IS, 1),
> -       SR_FGT(OP_TLBI_RVAE1ISNXS,      HFGITR, TLBIRVAE1IS, 1),
> -       SR_FGT(OP_TLBI_VAALE1ISNXS,     HFGITR, TLBIVAALE1IS, 1),
> -       SR_FGT(OP_TLBI_VALE1ISNXS,      HFGITR, TLBIVALE1IS, 1),
> -       SR_FGT(OP_TLBI_VAAE1ISNXS,      HFGITR, TLBIVAAE1IS, 1),
> -       SR_FGT(OP_TLBI_ASIDE1ISNXS,     HFGITR, TLBIASIDE1IS, 1),
> -       SR_FGT(OP_TLBI_VAE1ISNXS,       HFGITR, TLBIVAE1IS, 1),
> -       SR_FGT(OP_TLBI_VMALLE1ISNXS,    HFGITR, TLBIVMALLE1IS, 1),
> -       SR_FGT(OP_TLBI_RVAALE1OSNXS,    HFGITR, TLBIRVAALE1OS, 1),
> -       SR_FGT(OP_TLBI_RVALE1OSNXS,     HFGITR, TLBIRVALE1OS, 1),
> -       SR_FGT(OP_TLBI_RVAAE1OSNXS,     HFGITR, TLBIRVAAE1OS, 1),
> -       SR_FGT(OP_TLBI_RVAE1OSNXS,      HFGITR, TLBIRVAE1OS, 1),
> -       SR_FGT(OP_TLBI_VAALE1OSNXS,     HFGITR, TLBIVAALE1OS, 1),
> -       SR_FGT(OP_TLBI_VALE1OSNXS,      HFGITR, TLBIVALE1OS, 1),
> -       SR_FGT(OP_TLBI_VAAE1OSNXS,      HFGITR, TLBIVAAE1OS, 1),
> -       SR_FGT(OP_TLBI_ASIDE1OSNXS,     HFGITR, TLBIASIDE1OS, 1),
> -       SR_FGT(OP_TLBI_VAE1OSNXS,       HFGITR, TLBIVAE1OS, 1),
> -       SR_FGT(OP_TLBI_VMALLE1OSNXS,    HFGITR, TLBIVMALLE1OS, 1),
> +       /* nXS variants must be checked against HCRX_EL2.FGTnXS */
> +       SR_FGF(OP_TLBI_VAALE1NXS,       HFGITR, TLBIVAALE1, 1, HCRX_FGTnX=
S),
> +       SR_FGF(OP_TLBI_VALE1NXS,        HFGITR, TLBIVALE1, 1, HCRX_FGTnXS=
),
> +       SR_FGF(OP_TLBI_VAAE1NXS,        HFGITR, TLBIVAAE1, 1, HCRX_FGTnXS=
),
> +       SR_FGF(OP_TLBI_ASIDE1NXS,       HFGITR, TLBIASIDE1, 1, HCRX_FGTnX=
S),
> +       SR_FGF(OP_TLBI_VAE1NXS,         HFGITR, TLBIVAE1, 1, HCRX_FGTnXS)=
,
> +       SR_FGF(OP_TLBI_VMALLE1NXS,      HFGITR, TLBIVMALLE1, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_RVAALE1NXS,      HFGITR, TLBIRVAALE1, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_RVALE1NXS,       HFGITR, TLBIRVALE1, 1, HCRX_FGTnX=
S),
> +       SR_FGF(OP_TLBI_RVAAE1NXS,       HFGITR, TLBIRVAAE1, 1, HCRX_FGTnX=
S),
> +       SR_FGF(OP_TLBI_RVAE1NXS,        HFGITR, TLBIRVAE1, 1, HCRX_FGTnXS=
),
> +       SR_FGF(OP_TLBI_RVAALE1ISNXS,    HFGITR, TLBIRVAALE1IS, 1, HCRX_FG=
TnXS),
> +       SR_FGF(OP_TLBI_RVALE1ISNXS,     HFGITR, TLBIRVALE1IS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_RVAAE1ISNXS,     HFGITR, TLBIRVAAE1IS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_RVAE1ISNXS,      HFGITR, TLBIRVAE1IS, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_VAALE1ISNXS,     HFGITR, TLBIVAALE1IS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_VALE1ISNXS,      HFGITR, TLBIVALE1IS, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_VAAE1ISNXS,      HFGITR, TLBIVAAE1IS, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_ASIDE1ISNXS,     HFGITR, TLBIASIDE1IS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_VAE1ISNXS,       HFGITR, TLBIVAE1IS, 1, HCRX_FGTnX=
S),
> +       SR_FGF(OP_TLBI_VMALLE1ISNXS,    HFGITR, TLBIVMALLE1IS, 1, HCRX_FG=
TnXS),
> +       SR_FGF(OP_TLBI_RVAALE1OSNXS,    HFGITR, TLBIRVAALE1OS, 1, HCRX_FG=
TnXS),
> +       SR_FGF(OP_TLBI_RVALE1OSNXS,     HFGITR, TLBIRVALE1OS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_RVAAE1OSNXS,     HFGITR, TLBIRVAAE1OS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_RVAE1OSNXS,      HFGITR, TLBIRVAE1OS, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_VAALE1OSNXS,     HFGITR, TLBIVAALE1OS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_VALE1OSNXS,      HFGITR, TLBIVALE1OS, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_VAAE1OSNXS,      HFGITR, TLBIVAAE1OS, 1, HCRX_FGTn=
XS),
> +       SR_FGF(OP_TLBI_ASIDE1OSNXS,     HFGITR, TLBIASIDE1OS, 1, HCRX_FGT=
nXS),
> +       SR_FGF(OP_TLBI_VAE1OSNXS,       HFGITR, TLBIVAE1OS, 1, HCRX_FGTnX=
S),
> +       SR_FGF(OP_TLBI_VMALLE1OSNXS,    HFGITR, TLBIVMALLE1OS, 1, HCRX_FG=
TnXS),
>         SR_FGT(OP_AT_S1E1WP,            HFGITR, ATS1E1WP, 1),
>         SR_FGT(OP_AT_S1E1RP,            HFGITR, ATS1E1RP, 1),
>         SR_FGT(OP_AT_S1E0W,             HFGITR, ATS1E0W, 1),
> @@ -1622,6 +1636,7 @@ int __init populate_nv_trap_config(void)
>         BUILD_BUG_ON(sizeof(union trap_config) !=3D sizeof(void *));
>         BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
>         BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
> +       BUILD_BUG_ON(__NR_FG_FILTER_IDS__ > BIT(TC_FGF_BITS));
>
>         for (int i =3D 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
>                 const struct encoding_to_trap_config *cgt =3D &encoding_t=
o_cgt[i];
> @@ -1812,6 +1827,17 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>
>         case HFGITR_GROUP:
>                 val =3D sanitised_sys_reg(vcpu, HFGITR_EL2);
> +               switch (tc.fgf) {
> +                       u64 tmp;
> +
> +               case __NO_FGF__:
> +                       break;
> +
> +               case HCRX_FGTnXS:
> +                       tmp =3D sanitised_sys_reg(vcpu, HCRX_EL2);
> +                       if (tmp & HCRX_EL2_FGTnXS)
> +                               tc.fgt =3D __NO_FGT_GROUP__;
> +               }
>                 break;
>
>         case __NR_FGT_GROUP_IDS__:
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 060c5a0409e5..3acf6d77e324 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -197,8 +197,19 @@ static inline void __activate_traps_common(struct kv=
m_vcpu *vcpu)
>         vcpu->arch.mdcr_el2_host =3D read_sysreg(mdcr_el2);
>         write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>
> -       if (cpus_have_final_cap(ARM64_HAS_HCX))
> -               write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
> +       if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> +               u64 hcrx =3D HCRX_GUEST_FLAGS;
> +               if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +                       u64 clr =3D 0, set =3D 0;
> +
> +                       compute_clr_set(vcpu, HCRX_EL2, clr, set);
> +
> +                       hcrx |=3D set;
> +                       hcrx &=3D ~clr;
> +               }
> +
> +               write_sysreg_s(hcrx, SYS_HCRX_EL2);
> +       }
>
>         __activate_traps_hfgxtr(vcpu);
>  }
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 3facd8918ae3..042695a210ce 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -117,7 +117,8 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct =
sys_reg_params *p,
>                 break;
>
>         case SYS_ID_AA64MMFR1_EL1:
> -               val &=3D (NV_FTR(MMFR1, PAN)      |
> +               val &=3D (NV_FTR(MMFR1, HCX)      |
> +                       NV_FTR(MMFR1, PAN)      |
>                         NV_FTR(MMFR1, LO)       |
>                         NV_FTR(MMFR1, HPDS)     |
>                         NV_FTR(MMFR1, VH)       |
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9556896311db..e92ec810d449 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2372,6 +2372,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>         EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
>         EL2_REG(HACR_EL2, access_rw, reset_val, 0),
>
> +       EL2_REG(HCRX_EL2, access_rw, reset_val, 0),
> +
>         EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
>         EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
>         EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
