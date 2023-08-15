Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D312077D62F
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 00:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbjHOWeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 18:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240466AbjHOWdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 18:33:42 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2043212C
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:33:32 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b9d3dacb33so92045201fa.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692138811; x=1692743611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OKZ0FVv3oMQAku3AZaR+FM9KCHIwuzbz5I8y+PZno8=;
        b=JgM4cAiCMOGSmNKjuwAdMuHJnX4w7+kq0nyhuHvNusxpP8AJa0MERWFQBTl02k5LjO
         JKbZW1w2jcKbuSBEgnifNB8kkdWBkHTqRc1O4jAN4A0njltVJvKEqq/9N7QiC66yhWed
         IVk73Kf8O8DdGJvywNrmGqo3/7EfQsXsCrE/0plA+t3w/hsHBF/G9gJOnhk1HAuVRrvI
         kyVfEz1Vz0oPXTY6SSoFfmfj/TXKrgfk6lkO2/bbO4nJlP3j6jR2sr5fxdsowh3e+Vnk
         ML3Q+AIoJfFQk61zSoPaZ+kF5cSHz4xle7ZrDZl/J4qqsp5vptFULVmLAoGgu1nJgJVQ
         nDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692138811; x=1692743611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7OKZ0FVv3oMQAku3AZaR+FM9KCHIwuzbz5I8y+PZno8=;
        b=WSEm7OaAagb5VjPbkB/L76JVUlZjtFyebBj1+aKvRtSN2xRzhUpGNxwpBFqKwJ/9Uh
         ZrC+cUGkyWh1tYr9zi3Iq6RPSsgERzm39PXsCyjkRvQlX2ZmE2ptQHkzLkVlbY3N0TKr
         5kFSPgGE4ICgzKGazwqe7eBYKvMEh+/Y13pZuFBmuCHazk9KUvIO/M3dGMUSEuYTPbtc
         98nl7us67Jm7MDt0MFY1H5sElMOSH2izxNcdO1+RnxPdLzOQNKtIcq3ieaKqbiq/zyEk
         Muhf+zXLDSDNcLDEYEhDcrfzkbGBwUzUw7xqOodqoNMZRjbsZPr5AePK720zHlC5K+RG
         u9lA==
X-Gm-Message-State: AOJu0YyWYmgXSWQy1+Jzkbm7Zt5YbpsPhdpa6xwklQLgnzbvgoSVW/rZ
        /qb7yhlQ9wGH6B1vszm6es1i7jr+XKbcI8zU9g4t+A==
X-Google-Smtp-Source: AGHT+IHZy4ogD7V7F6r8bJEphlXqd6ZbNeWRKcNlJZ2qtHwCPnPD2bRwVmDRJHE++Uzghe3diNIueuBw1ArBBD2rwQA=
X-Received: by 2002:a2e:9450:0:b0:2b6:a804:4cc with SMTP id
 o16-20020a2e9450000000b002b6a80404ccmr64245ljh.53.1692138810993; Tue, 15 Aug
 2023 15:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-18-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-18-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 15:33:18 -0700
Message-ID: <CAAdAUtjG3aR9EFu05Zk9wGUzAsJyH5-8Q-G3+n13Q17NcXLyGg@mail.gmail.com>
Subject: Re: [PATCH v4 17/28] KVM: arm64: nv: Add trap forwarding for MDCR_EL2
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_75_100,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 15, 2023 at 11:46=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Describe the MDCR_EL2 register, and associate it with all the sysregs
> it allows to trap.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 268 ++++++++++++++++++++++++++++++++
>  1 file changed, 268 insertions(+)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 975a30ef874a..241e44eeed6d 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -67,6 +67,18 @@ enum cgt_group_id {
>         CGT_HCR_TTLBIS,
>         CGT_HCR_TTLBOS,
>
> +       CGT_MDCR_TPMCR,
> +       CGT_MDCR_TPM,
> +       CGT_MDCR_TDE,
> +       CGT_MDCR_TDA,
> +       CGT_MDCR_TDOSA,
> +       CGT_MDCR_TDRA,
> +       CGT_MDCR_E2PB,
> +       CGT_MDCR_TPMS,
> +       CGT_MDCR_TTRF,
> +       CGT_MDCR_E2TB,
> +       CGT_MDCR_TDCC,
> +
>         /*
>          * Anything after this point is a combination of coarse trap
>          * controls, which must all be evaluated to decide what to do.
> @@ -80,6 +92,11 @@ enum cgt_group_id {
>         CGT_HCR_TPU_TICAB,
>         CGT_HCR_TPU_TOCU,
>         CGT_HCR_NV1_nNV2_ENSCXT,
> +       CGT_MDCR_TPM_TPMCR,
> +       CGT_MDCR_TDE_TDA,
> +       CGT_MDCR_TDE_TDOSA,
> +       CGT_MDCR_TDE_TDRA,
> +       CGT_MDCR_TDCC_TDE_TDA,
>
>         /*
>          * Anything after this point requires a callback evaluating a
> @@ -260,6 +277,72 @@ static const struct trap_bits coarse_trap_bits[] =3D=
 {
>                 .mask           =3D HCR_TTLBOS,
>                 .behaviour      =3D BEHAVE_FORWARD_ANY,
>         },
> +       [CGT_MDCR_TPMCR] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TPMCR,
> +               .mask           =3D MDCR_EL2_TPMCR,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TPM] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TPM,
> +               .mask           =3D MDCR_EL2_TPM,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TDE] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TDE,
> +               .mask           =3D MDCR_EL2_TDE,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TDA] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TDA,
> +               .mask           =3D MDCR_EL2_TDA,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TDOSA] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TDOSA,
> +               .mask           =3D MDCR_EL2_TDOSA,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TDRA] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TDRA,
> +               .mask           =3D MDCR_EL2_TDRA,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_E2PB] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D 0,
> +               .mask           =3D BIT(MDCR_EL2_E2PB_SHIFT),
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TPMS] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TPMS,
> +               .mask           =3D MDCR_EL2_TPMS,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TTRF] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TTRF,
> +               .mask           =3D MDCR_EL2_TTRF,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_E2TB] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D 0,
> +               .mask           =3D BIT(MDCR_EL2_E2TB_SHIFT),
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_MDCR_TDCC] =3D {
> +               .index          =3D MDCR_EL2,
> +               .value          =3D MDCR_EL2_TDCC,
> +               .mask           =3D MDCR_EL2_TDCC,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
>  };
>
>  #define MCB(id, ...)                                           \
> @@ -277,6 +360,11 @@ static const enum cgt_group_id *coarse_control_combo=
[] =3D {
>         MCB(CGT_HCR_TPU_TICAB,          CGT_HCR_TPU, CGT_HCR_TICAB),
>         MCB(CGT_HCR_TPU_TOCU,           CGT_HCR_TPU, CGT_HCR_TOCU),
>         MCB(CGT_HCR_NV1_nNV2_ENSCXT,    CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT)=
,
> +       MCB(CGT_MDCR_TPM_TPMCR,         CGT_MDCR_TPM, CGT_MDCR_TPMCR),
> +       MCB(CGT_MDCR_TDE_TDA,           CGT_MDCR_TDE, CGT_MDCR_TDA),
> +       MCB(CGT_MDCR_TDE_TDOSA,         CGT_MDCR_TDE, CGT_MDCR_TDOSA),
> +       MCB(CGT_MDCR_TDE_TDRA,          CGT_MDCR_TDE, CGT_MDCR_TDRA),
> +       MCB(CGT_MDCR_TDCC_TDE_TDA,      CGT_MDCR_TDCC, CGT_MDCR_TDE, CGT_=
MDCR_TDA),
>  };
>
>  typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *=
);
> @@ -609,6 +697,186 @@ static const struct encoding_to_trap_config encodin=
g_to_cgt[] __initconst =3D {
>         SR_TRAP(SYS_ERXPFGF_EL1,        CGT_HCR_nFIEN),
>         SR_TRAP(SYS_ERXPFGCTL_EL1,      CGT_HCR_nFIEN),
>         SR_TRAP(SYS_ERXPFGCDN_EL1,      CGT_HCR_nFIEN),
> +       SR_TRAP(SYS_PMCR_EL0,           CGT_MDCR_TPM_TPMCR),
> +       SR_TRAP(SYS_PMCNTENSET_EL0,     CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMCNTENCLR_EL0,     CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMOVSSET_EL0,       CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMOVSCLR_EL0,       CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMCEID0_EL0,        CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMCEID1_EL0,        CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMXEVTYPER_EL0,     CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMSWINC_EL0,        CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMSELR_EL0,         CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMXEVCNTR_EL0,      CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMCCNTR_EL0,        CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMUSERENR_EL0,      CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMINTENSET_EL1,     CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMINTENCLR_EL1,     CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMMIR_EL1,          CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(0),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(1),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(2),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(3),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(4),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(5),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(6),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(7),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(8),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(9),   CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(10),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(11),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(12),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(13),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(14),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(15),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(16),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(17),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(18),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(19),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(20),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(21),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(22),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(23),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(24),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(25),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(26),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(27),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(28),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(29),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVCNTRn_EL0(30),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(0),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(1),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(2),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(3),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(4),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(5),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(6),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(7),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(8),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(9),  CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(10), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(11), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(12), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(13), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(14), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(15), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(16), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(17), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(18), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(19), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(20), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(21), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(22), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(23), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(24), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(25), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(26), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(27), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(28), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(29), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMEVTYPERn_EL0(30), CGT_MDCR_TPM),
> +       SR_TRAP(SYS_PMCCFILTR_EL0,      CGT_MDCR_TPM),
> +       SR_TRAP(SYS_MDCCSR_EL0,         CGT_MDCR_TDCC_TDE_TDA),
> +       SR_TRAP(SYS_MDCCINT_EL1,        CGT_MDCR_TDCC_TDE_TDA),
> +       SR_TRAP(SYS_OSDTRRX_EL1,        CGT_MDCR_TDCC_TDE_TDA),
> +       SR_TRAP(SYS_OSDTRTX_EL1,        CGT_MDCR_TDCC_TDE_TDA),
> +       SR_TRAP(SYS_DBGDTR_EL0,         CGT_MDCR_TDCC_TDE_TDA),
> +       /*
> +        * Also covers DBGDTRRX_EL0, which has the same encoding as
> +        * SYS_DBGDTRTX_EL0...
> +        */
> +       SR_TRAP(SYS_DBGDTRTX_EL0,       CGT_MDCR_TDCC_TDE_TDA),
> +       SR_TRAP(SYS_MDSCR_EL1,          CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_OSECCR_EL1,         CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(0),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(1),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(2),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(3),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(4),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(5),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(6),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(7),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(8),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(9),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(10),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(11),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(12),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(13),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(14),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBVRn_EL1(15),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(0),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(1),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(2),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(3),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(4),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(5),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(6),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(7),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(8),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(9),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(10),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(11),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(12),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(13),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(14),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGBCRn_EL1(15),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(0),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(1),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(2),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(3),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(4),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(5),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(6),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(7),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(8),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(9),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(10),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(11),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(12),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(13),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(14),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWVRn_EL1(15),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(0),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(1),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(2),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(3),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(4),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(5),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(6),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(7),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(8),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(9),     CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(10),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(11),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(12),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(13),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGWCRn_EL1(14),    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGCLAIMSET_EL1,    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGCLAIMCLR_EL1,    CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_DBGAUTHSTATUS_EL1,  CGT_MDCR_TDE_TDA),
> +       SR_TRAP(SYS_OSLAR_EL1,          CGT_MDCR_TDE_TDOSA),
> +       SR_TRAP(SYS_OSLSR_EL1,          CGT_MDCR_TDE_TDOSA),
> +       SR_TRAP(SYS_OSDLR_EL1,          CGT_MDCR_TDE_TDOSA),
> +       SR_TRAP(SYS_DBGPRCR_EL1,        CGT_MDCR_TDE_TDOSA),
> +       SR_TRAP(SYS_MDRAR_EL1,          CGT_MDCR_TDE_TDRA),
> +       SR_TRAP(SYS_PMBLIMITR_EL1,      CGT_MDCR_E2PB),
> +       SR_TRAP(SYS_PMBPTR_EL1,         CGT_MDCR_E2PB),
> +       SR_TRAP(SYS_PMBSR_EL1,          CGT_MDCR_E2PB),
> +       SR_TRAP(SYS_PMSCR_EL1,          CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_PMSEVFR_EL1,        CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_PMSFCR_EL1,         CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_PMSICR_EL1,         CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_PMSIDR_EL1,         CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_PMSIRR_EL1,         CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_PMSLATFR_EL1,       CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_PMSNEVFR_EL1,       CGT_MDCR_TPMS),
> +       SR_TRAP(SYS_TRFCR_EL1,          CGT_MDCR_TTRF),
> +       SR_TRAP(SYS_TRBBASER_EL1,       CGT_MDCR_E2TB),
> +       SR_TRAP(SYS_TRBLIMITR_EL1,      CGT_MDCR_E2TB),
> +       SR_TRAP(SYS_TRBMAR_EL1,         CGT_MDCR_E2TB),
> +       SR_TRAP(SYS_TRBPTR_EL1,         CGT_MDCR_E2TB),
> +       SR_TRAP(SYS_TRBSR_EL1,          CGT_MDCR_E2TB),
> +       SR_TRAP(SYS_TRBTRG_EL1,         CGT_MDCR_E2TB),
>  };
>
>  static DEFINE_XARRAY(sr_forward_xa);
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
