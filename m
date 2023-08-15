Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6A77D678
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 00:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbjHOW4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 18:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbjHOWzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 18:55:55 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FB1198E
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:55:53 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4fe15bfb1adso9561691e87.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692140152; x=1692744952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTukk6ly/+sORPoMtSDsDZciyyq6ESes2DLJ8TIteB8=;
        b=Ka5djAZoagOXKIi+v8MzsuF4PdS3w9hEqjCnem96OQfChEfnZSFmIXoL6eXTnx73SI
         Vmi2kAeqJavLG/JGNLCgEXjKjMhhEPdW6PlihM98+9D8u5JmlpKiLPAC5vkCZxtGbWEo
         eNFpX+r1hFp+q12X94uUnHL3JpcusSubUX9mb9PJoEnoshPgW3jU8ZVvyOzFxy6+jg9P
         v2QeAzNZK1W4gdUBi731hFQy+FzA25atXuLZKZbpDlTP+IyL/N4TMDLhY5K5M6DKm5VA
         ArGXb4K3XJSBCwC4roheDoXpyvaR+9ZH7okQU6Dyr4qvKbSuUaJQ+QI0NzMACzGus8nJ
         7cBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692140152; x=1692744952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tTukk6ly/+sORPoMtSDsDZciyyq6ESes2DLJ8TIteB8=;
        b=Pcm6sXIR3FPO6pUP7FsQb+yZFeWF+yht4USuxasOSQU8VVdXgRWsVWT7bjuShS2Pm5
         WbU1WRcx4hNWkP0yilMyJcSBDbfare7KwySHM8o8/KukbJnVkl1qqmA0vFGke9yLrf4x
         T33A5/L8ASfE2AFv866MPOZdswmURmqs0AADH4CUSzozbA12gSs6AdaWnfqPMUKqrJ1X
         FhX7H/p46e74WrwfxIrAovIpGCuskhmB2XJZnEIgKqRIkN3qhyo/V9Qf9XXwCVN7raBx
         AYJgKfc9R1hDzHTROnydquz4KLz6vOTGBM2PekzEsJYZA+6OCFk1aNegs70IGwLU4w9h
         fbsg==
X-Gm-Message-State: AOJu0Ywnp9NKqzpqUNxoZQXvoTi9HfmYuKn4iC3sxgByTHhMKqfNPNN9
        awjAF1Tuj2R1svPRPmgkoW/iv1tq3nTuN7pODhyYqg==
X-Google-Smtp-Source: AGHT+IFwEI6ali+AcNDvSHwpp5lWxI6ngMSBC405DeHglrGeXMEMD/1vlYHYPLRcAKIqknLh3xCUkL1kH/ggj+WjEbE=
X-Received: by 2002:a2e:3516:0:b0:2b6:9ed5:bf15 with SMTP id
 z22-20020a2e3516000000b002b69ed5bf15mr112191ljz.23.1692140152086; Tue, 15 Aug
 2023 15:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-22-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-22-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 15:55:39 -0700
Message-ID: <CAAdAUthEwRSBFPkn9-iAMq5+KstAuG8TCm7O5Tc2VNN9PWcxjA@mail.gmail.com>
Subject: Re: [PATCH v4 21/28] KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
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
        UPPERCASE_50_75,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
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
> Similarly, implement the trap forwarding for instructions affected
> by HFGITR_EL2.
>
> Note that the TLBI*nXS instructions should be affected by HCRX_EL2,
> which will be dealt with down the line. Also, ERET* and SVC traps
> are handled separately.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h |   4 ++
>  arch/arm64/kvm/emulate-nested.c  | 109 +++++++++++++++++++++++++++++++
>  2 files changed, 113 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 85908aa18908..809bc86acefd 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -354,6 +354,10 @@
>  #define __HFGWTR_EL2_MASK      GENMASK(49, 0)
>  #define __HFGWTR_EL2_nMASK     (GENMASK(55, 54) | BIT(50))
>
> +#define __HFGITR_EL2_RES0      GENMASK(63, 57)
> +#define __HFGITR_EL2_MASK      GENMASK(54, 0)
> +#define __HFGITR_EL2_nMASK     GENMASK(56, 55)
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK     (~UL(0xf))
>  /*
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 0e34797515b6..a1a7792db412 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -939,6 +939,7 @@ static DEFINE_XARRAY(sr_forward_xa);
>  enum fgt_group_id {
>         __NO_FGT_GROUP__,
>         HFGxTR_GROUP,
> +       HFGITR_GROUP,
>
>         /* Must be last */
>         __NR_FGT_GROUP_IDS__
> @@ -1020,6 +1021,110 @@ static const struct encoding_to_trap_config encod=
ing_to_fgt[] __initconst =3D {
>         SR_FGT(SYS_AIDR_EL1,            HFGxTR, AIDR_EL1, 1),
>         SR_FGT(SYS_AFSR1_EL1,           HFGxTR, AFSR1_EL1, 1),
>         SR_FGT(SYS_AFSR0_EL1,           HFGxTR, AFSR0_EL1, 1),
> +       /* HFGITR_EL2 */
> +       SR_FGT(OP_BRB_IALL,             HFGITR, nBRBIALL, 0),
> +       SR_FGT(OP_BRB_INJ,              HFGITR, nBRBINJ, 0),
> +       SR_FGT(SYS_DC_CVAC,             HFGITR, DCCVAC, 1),
> +       SR_FGT(SYS_DC_CGVAC,            HFGITR, DCCVAC, 1),
> +       SR_FGT(SYS_DC_CGDVAC,           HFGITR, DCCVAC, 1),
> +       SR_FGT(OP_CPP_RCTX,             HFGITR, CPPRCTX, 1),
> +       SR_FGT(OP_DVP_RCTX,             HFGITR, DVPRCTX, 1),
> +       SR_FGT(OP_CFP_RCTX,             HFGITR, CFPRCTX, 1),
> +       SR_FGT(OP_TLBI_VAALE1,          HFGITR, TLBIVAALE1, 1),
> +       SR_FGT(OP_TLBI_VALE1,           HFGITR, TLBIVALE1, 1),
> +       SR_FGT(OP_TLBI_VAAE1,           HFGITR, TLBIVAAE1, 1),
> +       SR_FGT(OP_TLBI_ASIDE1,          HFGITR, TLBIASIDE1, 1),
> +       SR_FGT(OP_TLBI_VAE1,            HFGITR, TLBIVAE1, 1),
> +       SR_FGT(OP_TLBI_VMALLE1,         HFGITR, TLBIVMALLE1, 1),
> +       SR_FGT(OP_TLBI_RVAALE1,         HFGITR, TLBIRVAALE1, 1),
> +       SR_FGT(OP_TLBI_RVALE1,          HFGITR, TLBIRVALE1, 1),
> +       SR_FGT(OP_TLBI_RVAAE1,          HFGITR, TLBIRVAAE1, 1),
> +       SR_FGT(OP_TLBI_RVAE1,           HFGITR, TLBIRVAE1, 1),
> +       SR_FGT(OP_TLBI_RVAALE1IS,       HFGITR, TLBIRVAALE1IS, 1),
> +       SR_FGT(OP_TLBI_RVALE1IS,        HFGITR, TLBIRVALE1IS, 1),
> +       SR_FGT(OP_TLBI_RVAAE1IS,        HFGITR, TLBIRVAAE1IS, 1),
> +       SR_FGT(OP_TLBI_RVAE1IS,         HFGITR, TLBIRVAE1IS, 1),
> +       SR_FGT(OP_TLBI_VAALE1IS,        HFGITR, TLBIVAALE1IS, 1),
> +       SR_FGT(OP_TLBI_VALE1IS,         HFGITR, TLBIVALE1IS, 1),
> +       SR_FGT(OP_TLBI_VAAE1IS,         HFGITR, TLBIVAAE1IS, 1),
> +       SR_FGT(OP_TLBI_ASIDE1IS,        HFGITR, TLBIASIDE1IS, 1),
> +       SR_FGT(OP_TLBI_VAE1IS,          HFGITR, TLBIVAE1IS, 1),
> +       SR_FGT(OP_TLBI_VMALLE1IS,       HFGITR, TLBIVMALLE1IS, 1),
> +       SR_FGT(OP_TLBI_RVAALE1OS,       HFGITR, TLBIRVAALE1OS, 1),
> +       SR_FGT(OP_TLBI_RVALE1OS,        HFGITR, TLBIRVALE1OS, 1),
> +       SR_FGT(OP_TLBI_RVAAE1OS,        HFGITR, TLBIRVAAE1OS, 1),
> +       SR_FGT(OP_TLBI_RVAE1OS,         HFGITR, TLBIRVAE1OS, 1),
> +       SR_FGT(OP_TLBI_VAALE1OS,        HFGITR, TLBIVAALE1OS, 1),
> +       SR_FGT(OP_TLBI_VALE1OS,         HFGITR, TLBIVALE1OS, 1),
> +       SR_FGT(OP_TLBI_VAAE1OS,         HFGITR, TLBIVAAE1OS, 1),
> +       SR_FGT(OP_TLBI_ASIDE1OS,        HFGITR, TLBIASIDE1OS, 1),
> +       SR_FGT(OP_TLBI_VAE1OS,          HFGITR, TLBIVAE1OS, 1),
> +       SR_FGT(OP_TLBI_VMALLE1OS,       HFGITR, TLBIVMALLE1OS, 1),
> +       /* FIXME: nXS variants must be checked against HCRX_EL2.FGTnXS */
> +       SR_FGT(OP_TLBI_VAALE1NXS,       HFGITR, TLBIVAALE1, 1),
> +       SR_FGT(OP_TLBI_VALE1NXS,        HFGITR, TLBIVALE1, 1),
> +       SR_FGT(OP_TLBI_VAAE1NXS,        HFGITR, TLBIVAAE1, 1),
> +       SR_FGT(OP_TLBI_ASIDE1NXS,       HFGITR, TLBIASIDE1, 1),
> +       SR_FGT(OP_TLBI_VAE1NXS,         HFGITR, TLBIVAE1, 1),
> +       SR_FGT(OP_TLBI_VMALLE1NXS,      HFGITR, TLBIVMALLE1, 1),
> +       SR_FGT(OP_TLBI_RVAALE1NXS,      HFGITR, TLBIRVAALE1, 1),
> +       SR_FGT(OP_TLBI_RVALE1NXS,       HFGITR, TLBIRVALE1, 1),
> +       SR_FGT(OP_TLBI_RVAAE1NXS,       HFGITR, TLBIRVAAE1, 1),
> +       SR_FGT(OP_TLBI_RVAE1NXS,        HFGITR, TLBIRVAE1, 1),
> +       SR_FGT(OP_TLBI_RVAALE1ISNXS,    HFGITR, TLBIRVAALE1IS, 1),
> +       SR_FGT(OP_TLBI_RVALE1ISNXS,     HFGITR, TLBIRVALE1IS, 1),
> +       SR_FGT(OP_TLBI_RVAAE1ISNXS,     HFGITR, TLBIRVAAE1IS, 1),
> +       SR_FGT(OP_TLBI_RVAE1ISNXS,      HFGITR, TLBIRVAE1IS, 1),
> +       SR_FGT(OP_TLBI_VAALE1ISNXS,     HFGITR, TLBIVAALE1IS, 1),
> +       SR_FGT(OP_TLBI_VALE1ISNXS,      HFGITR, TLBIVALE1IS, 1),
> +       SR_FGT(OP_TLBI_VAAE1ISNXS,      HFGITR, TLBIVAAE1IS, 1),
> +       SR_FGT(OP_TLBI_ASIDE1ISNXS,     HFGITR, TLBIASIDE1IS, 1),
> +       SR_FGT(OP_TLBI_VAE1ISNXS,       HFGITR, TLBIVAE1IS, 1),
> +       SR_FGT(OP_TLBI_VMALLE1ISNXS,    HFGITR, TLBIVMALLE1IS, 1),
> +       SR_FGT(OP_TLBI_RVAALE1OSNXS,    HFGITR, TLBIRVAALE1OS, 1),
> +       SR_FGT(OP_TLBI_RVALE1OSNXS,     HFGITR, TLBIRVALE1OS, 1),
> +       SR_FGT(OP_TLBI_RVAAE1OSNXS,     HFGITR, TLBIRVAAE1OS, 1),
> +       SR_FGT(OP_TLBI_RVAE1OSNXS,      HFGITR, TLBIRVAE1OS, 1),
> +       SR_FGT(OP_TLBI_VAALE1OSNXS,     HFGITR, TLBIVAALE1OS, 1),
> +       SR_FGT(OP_TLBI_VALE1OSNXS,      HFGITR, TLBIVALE1OS, 1),
> +       SR_FGT(OP_TLBI_VAAE1OSNXS,      HFGITR, TLBIVAAE1OS, 1),
> +       SR_FGT(OP_TLBI_ASIDE1OSNXS,     HFGITR, TLBIASIDE1OS, 1),
> +       SR_FGT(OP_TLBI_VAE1OSNXS,       HFGITR, TLBIVAE1OS, 1),
> +       SR_FGT(OP_TLBI_VMALLE1OSNXS,    HFGITR, TLBIVMALLE1OS, 1),
> +       SR_FGT(OP_AT_S1E1WP,            HFGITR, ATS1E1WP, 1),
> +       SR_FGT(OP_AT_S1E1RP,            HFGITR, ATS1E1RP, 1),
> +       SR_FGT(OP_AT_S1E0W,             HFGITR, ATS1E0W, 1),
> +       SR_FGT(OP_AT_S1E0R,             HFGITR, ATS1E0R, 1),
> +       SR_FGT(OP_AT_S1E1W,             HFGITR, ATS1E1W, 1),
> +       SR_FGT(OP_AT_S1E1R,             HFGITR, ATS1E1R, 1),
> +       SR_FGT(SYS_DC_ZVA,              HFGITR, DCZVA, 1),
> +       SR_FGT(SYS_DC_GVA,              HFGITR, DCZVA, 1),
> +       SR_FGT(SYS_DC_GZVA,             HFGITR, DCZVA, 1),
> +       SR_FGT(SYS_DC_CIVAC,            HFGITR, DCCIVAC, 1),
> +       SR_FGT(SYS_DC_CIGVAC,           HFGITR, DCCIVAC, 1),
> +       SR_FGT(SYS_DC_CIGDVAC,          HFGITR, DCCIVAC, 1),
> +       SR_FGT(SYS_DC_CVADP,            HFGITR, DCCVADP, 1),
> +       SR_FGT(SYS_DC_CGVADP,           HFGITR, DCCVADP, 1),
> +       SR_FGT(SYS_DC_CGDVADP,          HFGITR, DCCVADP, 1),
> +       SR_FGT(SYS_DC_CVAP,             HFGITR, DCCVAP, 1),
> +       SR_FGT(SYS_DC_CGVAP,            HFGITR, DCCVAP, 1),
> +       SR_FGT(SYS_DC_CGDVAP,           HFGITR, DCCVAP, 1),
> +       SR_FGT(SYS_DC_CVAU,             HFGITR, DCCVAU, 1),
> +       SR_FGT(SYS_DC_CISW,             HFGITR, DCCISW, 1),
> +       SR_FGT(SYS_DC_CIGSW,            HFGITR, DCCISW, 1),
> +       SR_FGT(SYS_DC_CIGDSW,           HFGITR, DCCISW, 1),
> +       SR_FGT(SYS_DC_CSW,              HFGITR, DCCSW, 1),
> +       SR_FGT(SYS_DC_CGSW,             HFGITR, DCCSW, 1),
> +       SR_FGT(SYS_DC_CGDSW,            HFGITR, DCCSW, 1),
> +       SR_FGT(SYS_DC_ISW,              HFGITR, DCISW, 1),
> +       SR_FGT(SYS_DC_IGSW,             HFGITR, DCISW, 1),
> +       SR_FGT(SYS_DC_IGDSW,            HFGITR, DCISW, 1),
> +       SR_FGT(SYS_DC_IVAC,             HFGITR, DCIVAC, 1),
> +       SR_FGT(SYS_DC_IGVAC,            HFGITR, DCIVAC, 1),
> +       SR_FGT(SYS_DC_IGDVAC,           HFGITR, DCIVAC, 1),
> +       SR_FGT(SYS_IC_IVAU,             HFGITR, ICIVAU, 1),
> +       SR_FGT(SYS_IC_IALLU,            HFGITR, ICIALLU, 1),
> +       SR_FGT(SYS_IC_IALLUIS,          HFGITR, ICIALLUIS, 1),
>  };
>
>  static union trap_config get_trap_config(u32 sysreg)
> @@ -1231,6 +1336,10 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>                         val =3D sanitised_sys_reg(vcpu, HFGWTR_EL2);
>                 break;
>
> +       case HFGITR_GROUP:
> +               val =3D sanitised_sys_reg(vcpu, HFGITR_EL2);
> +               break;
> +
>         case __NR_FGT_GROUP_IDS__:
>                 /* Something is really wrong, bail out */
>                 WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
