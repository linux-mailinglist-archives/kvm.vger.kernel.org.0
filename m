Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED21277D684
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 01:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbjHOXKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 19:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240576AbjHOXKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 19:10:35 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F9E10E5
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:10:30 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b9cdbf682eso89351971fa.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692141028; x=1692745828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iYwtstFirp41vwCCUjVqMeie3Pe8uoTs5ZfGEWJPAk=;
        b=T6mgaj3mGj89ox6pLjMfVVFK4AjpTPyoCysIemUGILS2VA4on6qRjgAA4DAS54mTg3
         GReAcdU5NTlHIqZaKuIxmG4QcCnANtpQi+AZdHwjJ63LWsPBBSxeG3njMVCrJ6/N5JPl
         pnCm6KiKBou3kAV++IeVyhuO+D66t8cT3i3EbT2+pX6TMGrn4PkWMFH0+yQWT4CRMjmb
         nXT1BXxDiYdVYXmT+d7AzgUK794NA4vgQADoXPe6/GZ+fGATKjVYQbxP6JXC6uPA+19Q
         rYQ3QAmdhwtW1OVBRstMeROlMCm4tl/tJtjp5UE8Qs53kasU5FtCQuwzU4xrMktFeIca
         RvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692141028; x=1692745828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7iYwtstFirp41vwCCUjVqMeie3Pe8uoTs5ZfGEWJPAk=;
        b=NLFa9Q9b8TyRNCbHPatekSwAZtbSNkojaFxzCYzFToGeZkl2a4A8jSRERuG0vz/F5V
         uBRO5pyBTnZAGqAN0d/rZj2xj9K3UTi4dqV0gaqr/XGQGyE1XEzG76VDNAkfZQrp0D4S
         ZD5g5/c7qcsHYzru0fr18w23sZ15RwU28E9uLSZjU+622O//BMaBJqNybWMup6jtRyZb
         TB4GmBtc7KtABBxKcSAL3eEcfK4fswFVtKGk7sk1SDswIwPRua2L0yTjCUFzmfS27ze6
         U/34quYgWs71eij2DIBkrEZ9WRzZ9rfJpatddOn6CEh3wxKrVc7LJ9qkQTT3/wIYMzu1
         qhbQ==
X-Gm-Message-State: AOJu0Yy1T8yZ6Y1Teo6FDXZ9FBZ6AxdxsxLUIs+Wf2dB0w8iWFk2Eglp
        wKKoS4lX22wEVaVlOksXihA7lVPv6kqDBfuUAkE83A==
X-Google-Smtp-Source: AGHT+IGT9FhnC0Wh4paf8wQ7jyh2tfgmhtDVA15WAUoHO+vC/6ROhhbzOngy9Iw8Zqpdk84fgUlnrXpe4TYwXUexjCI=
X-Received: by 2002:a2e:7c16:0:b0:2b7:4078:13e0 with SMTP id
 x22-20020a2e7c16000000b002b7407813e0mr140245ljc.43.1692141028166; Tue, 15 Aug
 2023 16:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-23-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-23-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 16:10:15 -0700
Message-ID: <CAAdAUtgrUDeZCuRmUo0hJc9tZSzkesWQ+rwyu+cy8VMd=N6jeA@mail.gmail.com>
Subject: Re: [PATCH v4 22/28] KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
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

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> ... and finally, the Debug version of FGT, with its *enormous*
> list of trapped registers.
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h |  11 +
>  arch/arm64/kvm/emulate-nested.c  | 474 +++++++++++++++++++++++++++++++
>  2 files changed, 485 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 809bc86acefd..d229f238c3b6 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -358,6 +358,17 @@
>  #define __HFGITR_EL2_MASK      GENMASK(54, 0)
>  #define __HFGITR_EL2_nMASK     GENMASK(56, 55)
>
> +#define __HDFGRTR_EL2_RES0     (BIT(49) | BIT(42) | GENMASK(39, 38) |  \
> +                                GENMASK(21, 20) | BIT(8))
> +#define __HDFGRTR_EL2_MASK     ~__HDFGRTR_EL2_nMASK
> +#define __HDFGRTR_EL2_nMASK    GENMASK(62, 59)
> +
> +#define __HDFGWTR_EL2_RES0     (BIT(63) | GENMASK(59, 58) | BIT(51) | BI=
T(47) | \
> +                                BIT(43) | GENMASK(40, 38) | BIT(34) | BI=
T(30) | \
> +                                BIT(22) | BIT(9) | BIT(6))
> +#define __HDFGWTR_EL2_MASK     ~__HDFGWTR_EL2_nMASK
> +#define __HDFGWTR_EL2_nMASK    GENMASK(62, 60)
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK     (~UL(0xf))
>  /*
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index a1a7792db412..c9662f9a345e 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -939,6 +939,8 @@ static DEFINE_XARRAY(sr_forward_xa);
>  enum fgt_group_id {
>         __NO_FGT_GROUP__,
>         HFGxTR_GROUP,
> +       HDFGRTR_GROUP,
> +       HDFGWTR_GROUP,
>         HFGITR_GROUP,
>
>         /* Must be last */
> @@ -1125,6 +1127,470 @@ static const struct encoding_to_trap_config encod=
ing_to_fgt[] __initconst =3D {
>         SR_FGT(SYS_IC_IVAU,             HFGITR, ICIVAU, 1),
>         SR_FGT(SYS_IC_IALLU,            HFGITR, ICIALLU, 1),
>         SR_FGT(SYS_IC_IALLUIS,          HFGITR, ICIALLUIS, 1),
> +       /* HDFGRTR_EL2 */
> +       SR_FGT(SYS_PMBIDR_EL1,          HDFGRTR, PMBIDR_EL1, 1),
> +       SR_FGT(SYS_PMSNEVFR_EL1,        HDFGRTR, nPMSNEVFR_EL1, 0),
> +       SR_FGT(SYS_BRBINF_EL1(0),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(1),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(2),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(3),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(4),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(5),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(6),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(7),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(8),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(9),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(10),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(11),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(12),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(13),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(14),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(15),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(16),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(17),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(18),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(19),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(20),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(21),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(22),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(23),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(24),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(25),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(26),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(27),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(28),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(29),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(30),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINF_EL1(31),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBINFINJ_EL1,       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(0),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(1),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(2),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(3),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(4),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(5),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(6),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(7),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(8),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(9),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(10),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(11),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(12),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(13),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(14),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(15),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(16),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(17),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(18),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(19),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(20),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(21),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(22),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(23),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(24),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(25),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(26),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(27),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(28),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(29),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(30),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRC_EL1(31),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBSRCINJ_EL1,       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(0),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(1),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(2),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(3),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(4),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(5),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(6),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(7),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(8),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(9),       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(10),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(11),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(12),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(13),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(14),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(15),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(16),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(17),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(18),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(19),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(20),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(21),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(22),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(23),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(24),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(25),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(26),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(27),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(28),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(29),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(30),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGT_EL1(31),      HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTGTINJ_EL1,       HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBTS_EL1,           HDFGRTR, nBRBDATA, 0),
> +       SR_FGT(SYS_BRBCR_EL1,           HDFGRTR, nBRBCTL, 0),
> +       SR_FGT(SYS_BRBFCR_EL1,          HDFGRTR, nBRBCTL, 0),
> +       SR_FGT(SYS_BRBIDR0_EL1,         HDFGRTR, nBRBIDR, 0),
> +       SR_FGT(SYS_PMCEID0_EL0,         HDFGRTR, PMCEIDn_EL0, 1),
> +       SR_FGT(SYS_PMCEID1_EL0,         HDFGRTR, PMCEIDn_EL0, 1),
> +       SR_FGT(SYS_PMUSERENR_EL0,       HDFGRTR, PMUSERENR_EL0, 1),
> +       SR_FGT(SYS_TRBTRG_EL1,          HDFGRTR, TRBTRG_EL1, 1),
> +       SR_FGT(SYS_TRBSR_EL1,           HDFGRTR, TRBSR_EL1, 1),
> +       SR_FGT(SYS_TRBPTR_EL1,          HDFGRTR, TRBPTR_EL1, 1),
> +       SR_FGT(SYS_TRBMAR_EL1,          HDFGRTR, TRBMAR_EL1, 1),
> +       SR_FGT(SYS_TRBLIMITR_EL1,       HDFGRTR, TRBLIMITR_EL1, 1),
> +       SR_FGT(SYS_TRBIDR_EL1,          HDFGRTR, TRBIDR_EL1, 1),
> +       SR_FGT(SYS_TRBBASER_EL1,        HDFGRTR, TRBBASER_EL1, 1),
> +       SR_FGT(SYS_TRCVICTLR,           HDFGRTR, TRCVICTLR, 1),
> +       SR_FGT(SYS_TRCSTATR,            HDFGRTR, TRCSTATR, 1),
> +       SR_FGT(SYS_TRCSSCSR(0),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSSCSR(1),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSSCSR(2),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSSCSR(3),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSSCSR(4),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSSCSR(5),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSSCSR(6),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSSCSR(7),         HDFGRTR, TRCSSCSRn, 1),
> +       SR_FGT(SYS_TRCSEQSTR,           HDFGRTR, TRCSEQSTR, 1),
> +       SR_FGT(SYS_TRCPRGCTLR,          HDFGRTR, TRCPRGCTLR, 1),
> +       SR_FGT(SYS_TRCOSLSR,            HDFGRTR, TRCOSLSR, 1),
> +       SR_FGT(SYS_TRCIMSPEC(0),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCIMSPEC(1),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCIMSPEC(2),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCIMSPEC(3),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCIMSPEC(4),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCIMSPEC(5),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCIMSPEC(6),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCIMSPEC(7),        HDFGRTR, TRCIMSPECn, 1),
> +       SR_FGT(SYS_TRCDEVARCH,          HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCDEVID,            HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR0,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR1,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR2,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR3,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR4,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR5,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR6,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR7,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR8,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR9,             HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR10,            HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR11,            HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR12,            HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCIDR13,            HDFGRTR, TRCID, 1),
> +       SR_FGT(SYS_TRCCNTVR(0),         HDFGRTR, TRCCNTVRn, 1),
> +       SR_FGT(SYS_TRCCNTVR(1),         HDFGRTR, TRCCNTVRn, 1),
> +       SR_FGT(SYS_TRCCNTVR(2),         HDFGRTR, TRCCNTVRn, 1),
> +       SR_FGT(SYS_TRCCNTVR(3),         HDFGRTR, TRCCNTVRn, 1),
> +       SR_FGT(SYS_TRCCLAIMCLR,         HDFGRTR, TRCCLAIM, 1),
> +       SR_FGT(SYS_TRCCLAIMSET,         HDFGRTR, TRCCLAIM, 1),
> +       SR_FGT(SYS_TRCAUXCTLR,          HDFGRTR, TRCAUXCTLR, 1),
> +       SR_FGT(SYS_TRCAUTHSTATUS,       HDFGRTR, TRCAUTHSTATUS, 1),
> +       SR_FGT(SYS_TRCACATR(0),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(1),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(2),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(3),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(4),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(5),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(6),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(7),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(8),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(9),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(10),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(11),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(12),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(13),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(14),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACATR(15),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(0),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(1),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(2),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(3),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(4),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(5),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(6),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(7),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(8),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(9),          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(10),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(11),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(12),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(13),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(14),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCACVR(15),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCBBCTLR,           HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCCCTLR,           HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCCTLR0,        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCCTLR1,        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(0),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(1),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(2),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(3),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(4),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(5),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(6),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCIDCVR(7),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTCTLR(0),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTCTLR(1),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTCTLR(2),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTCTLR(3),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTRLDVR(0),      HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTRLDVR(1),      HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTRLDVR(2),      HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCNTRLDVR(3),      HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCCONFIGR,          HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCEVENTCTL0R,       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCEVENTCTL1R,       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCEXTINSELR(0),     HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCEXTINSELR(1),     HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCEXTINSELR(2),     HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCEXTINSELR(3),     HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCQCTLR,            HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(2),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(3),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(4),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(5),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(6),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(7),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(8),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(9),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(10),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(11),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(12),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(13),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(14),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(15),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(16),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(17),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(18),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(19),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(20),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(21),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(22),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(23),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(24),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(25),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(26),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(27),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(28),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(29),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(30),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSCTLR(31),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCRSR,              HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSEQEVR(0),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSEQEVR(1),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSEQEVR(2),        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSEQRSTEVR,        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(0),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(1),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(2),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(3),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(4),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(5),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(6),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSCCR(7),         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(0),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(1),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(2),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(3),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(4),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(5),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(6),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSSPCICR(7),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSTALLCTLR,        HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCSYNCPR,           HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCTRACEIDR,         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCTSCTLR,           HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVIIECTLR,         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVIPCSSCTLR,       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVISSCTLR,         HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCCTLR0,       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCCTLR1,       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(0),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(1),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(2),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(3),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(4),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(5),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(6),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_TRCVMIDCVR(7),       HDFGRTR, TRC, 1),
> +       SR_FGT(SYS_PMSLATFR_EL1,        HDFGRTR, PMSLATFR_EL1, 1),
> +       SR_FGT(SYS_PMSIRR_EL1,          HDFGRTR, PMSIRR_EL1, 1),
> +       SR_FGT(SYS_PMSIDR_EL1,          HDFGRTR, PMSIDR_EL1, 1),
> +       SR_FGT(SYS_PMSICR_EL1,          HDFGRTR, PMSICR_EL1, 1),
> +       SR_FGT(SYS_PMSFCR_EL1,          HDFGRTR, PMSFCR_EL1, 1),
> +       SR_FGT(SYS_PMSEVFR_EL1,         HDFGRTR, PMSEVFR_EL1, 1),
> +       SR_FGT(SYS_PMSCR_EL1,           HDFGRTR, PMSCR_EL1, 1),
> +       SR_FGT(SYS_PMBSR_EL1,           HDFGRTR, PMBSR_EL1, 1),
> +       SR_FGT(SYS_PMBPTR_EL1,          HDFGRTR, PMBPTR_EL1, 1),
> +       SR_FGT(SYS_PMBLIMITR_EL1,       HDFGRTR, PMBLIMITR_EL1, 1),
> +       SR_FGT(SYS_PMMIR_EL1,           HDFGRTR, PMMIR_EL1, 1),
> +       SR_FGT(SYS_PMSELR_EL0,          HDFGRTR, PMSELR_EL0, 1),
> +       SR_FGT(SYS_PMOVSCLR_EL0,        HDFGRTR, PMOVS, 1),
> +       SR_FGT(SYS_PMOVSSET_EL0,        HDFGRTR, PMOVS, 1),
> +       SR_FGT(SYS_PMINTENCLR_EL1,      HDFGRTR, PMINTEN, 1),
> +       SR_FGT(SYS_PMINTENSET_EL1,      HDFGRTR, PMINTEN, 1),
> +       SR_FGT(SYS_PMCNTENCLR_EL0,      HDFGRTR, PMCNTEN, 1),
> +       SR_FGT(SYS_PMCNTENSET_EL0,      HDFGRTR, PMCNTEN, 1),
> +       SR_FGT(SYS_PMCCNTR_EL0,         HDFGRTR, PMCCNTR_EL0, 1),
> +       SR_FGT(SYS_PMCCFILTR_EL0,       HDFGRTR, PMCCFILTR_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(0),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(1),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(2),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(3),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(4),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(5),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(6),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(7),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(8),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(9),   HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(10),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(11),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(12),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(13),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(14),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(15),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(16),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(17),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(18),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(19),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(20),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(21),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(22),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(23),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(24),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(25),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(26),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(27),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(28),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(29),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVTYPERn_EL0(30),  HDFGRTR, PMEVTYPERn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(0),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(1),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(2),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(3),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(4),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(5),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(6),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(7),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(8),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(9),    HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(10),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(11),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(12),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(13),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(14),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(15),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(16),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(17),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(18),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(19),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(20),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(21),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(22),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(23),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(24),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(25),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(26),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(27),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(28),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(29),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_PMEVCNTRn_EL0(30),   HDFGRTR, PMEVCNTRn_EL0, 1),
> +       SR_FGT(SYS_OSDLR_EL1,           HDFGRTR, OSDLR_EL1, 1),
> +       SR_FGT(SYS_OSECCR_EL1,          HDFGRTR, OSECCR_EL1, 1),
> +       SR_FGT(SYS_OSLSR_EL1,           HDFGRTR, OSLSR_EL1, 1),
> +       SR_FGT(SYS_DBGPRCR_EL1,         HDFGRTR, DBGPRCR_EL1, 1),
> +       SR_FGT(SYS_DBGAUTHSTATUS_EL1,   HDFGRTR, DBGAUTHSTATUS_EL1, 1),
> +       SR_FGT(SYS_DBGCLAIMSET_EL1,     HDFGRTR, DBGCLAIM, 1),
> +       SR_FGT(SYS_DBGCLAIMCLR_EL1,     HDFGRTR, DBGCLAIM, 1),
> +       SR_FGT(SYS_MDSCR_EL1,           HDFGRTR, MDSCR_EL1, 1),
> +       /*
> +        * The trap bits capture *64* debug registers per bit, but the
> +        * ARM ARM only describes the encoding for the first 16, and
> +        * we don't really support more than that anyway.
> +        */
> +       SR_FGT(SYS_DBGWVRn_EL1(0),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(1),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(2),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(3),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(4),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(5),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(6),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(7),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(8),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(9),      HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(10),     HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(11),     HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(12),     HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(13),     HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(14),     HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWVRn_EL1(15),     HDFGRTR, DBGWVRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(0),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(1),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(2),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(3),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(4),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(5),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(6),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(7),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(8),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(9),      HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(10),     HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(11),     HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(12),     HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(13),     HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(14),     HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGWCRn_EL1(15),     HDFGRTR, DBGWCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(0),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(1),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(2),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(3),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(4),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(5),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(6),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(7),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(8),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(9),      HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(10),     HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(11),     HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(12),     HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(13),     HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(14),     HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBVRn_EL1(15),     HDFGRTR, DBGBVRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(0),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(1),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(2),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(3),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(4),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(5),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(6),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(7),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(8),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(9),      HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(10),     HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(11),     HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(12),     HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(13),     HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(14),     HDFGRTR, DBGBCRn_EL1, 1),
> +       SR_FGT(SYS_DBGBCRn_EL1(15),     HDFGRTR, DBGBCRn_EL1, 1),
> +       /*
> +        * HDFGWTR_EL2
> +        *
> +        * Although HDFGRTR_EL2 and HDFGWTR_EL2 registers largely
> +        * overlap in their bit assignment, there are a number of bits
> +        * that are RES0 on one side, and an actual trap bit on the
> +        * other.  The policy chosen here is to describe all the
> +        * read-side mappings, and only the write-side mappings that
> +        * differ from the read side, and the trap handler will pick
> +        * the correct shadow register based on the access type.
> +        */
> +       SR_FGT(SYS_TRFCR_EL1,           HDFGWTR, TRFCR_EL1, 1),
> +       SR_FGT(SYS_TRCOSLAR,            HDFGWTR, TRCOSLAR, 1),
> +       SR_FGT(SYS_PMCR_EL0,            HDFGWTR, PMCR_EL0, 1),
> +       SR_FGT(SYS_PMSWINC_EL0,         HDFGWTR, PMSWINC_EL0, 1),
> +       SR_FGT(SYS_OSLAR_EL1,           HDFGWTR, OSLAR_EL1, 1),
>  };
>
>  static union trap_config get_trap_config(u32 sysreg)
> @@ -1336,6 +1802,14 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>                         val =3D sanitised_sys_reg(vcpu, HFGWTR_EL2);
>                 break;
>
> +       case HDFGRTR_GROUP:
> +       case HDFGWTR_GROUP:
> +               if (is_read)
> +                       val =3D sanitised_sys_reg(vcpu, HDFGRTR_EL2);
> +               else
> +                       val =3D sanitised_sys_reg(vcpu, HDFGWTR_EL2);
> +               break;
> +
>         case HFGITR_GROUP:
>                 val =3D sanitised_sys_reg(vcpu, HFGITR_EL2);
>                 break;
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
