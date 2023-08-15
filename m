Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB56277D672
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 00:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbjHOWwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 18:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240530AbjHOWvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 18:51:50 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C0A2121
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:51:43 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2bad7499bdcso51045661fa.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 15:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692139902; x=1692744702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NB4kFVYk0VzDJYVvftDfK9K6NvUawMTsvoAjbvdMEwE=;
        b=xgWSsZ+yzfnrNepdJd9XBKptt8IBaaOIWpyliBOfk98/gDqM9hqn9IAINYWKyqDXCe
         a2QTw3wHr5LMwxBfCU1r6nCgSLENTlW8JdZfS4VagOKwwYkDrk+TBQg3EpfbYB6fxmMf
         F76IQ6ckGv3M002Dx4RQpwQYxHhZTGVJd3ORJpcCQ/eeK0HZSqd7lesUi6By5wdPwE+J
         qO5CqsVaeO+If0rjYqooqIma7c/sN0NISzN8Ei7W9dov7u6f5YzUDWPWtz/d/mCooMTk
         X6foepwXAFMnsBL4ynSB6O1IdNv3qZISsU04Jr7QfVVm2I+5FONp11ovhipWeeN2B1qO
         s1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692139902; x=1692744702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NB4kFVYk0VzDJYVvftDfK9K6NvUawMTsvoAjbvdMEwE=;
        b=bRljaCQq+EDiI/yWi2v5QIQqFzjrcKdsaPfvW7zOFiNFooBNy11HL+hUmohlCS/AbV
         BV4IxKnfOeo1cdoRP/ZUmLXFsxCBbu6aXyMpASingIbOGIGiG5KnxjoultWLsGEZkW7i
         tt3XIlQti2g1P09JAR5MUO08OMZMpxoJ7Vx6aEmVzEDZfa2/4+h1CuLKIdzFde6PX5RA
         TrdfB1H24g8aLt/2HbjIZi8UPlgTsIvXffj/gATkCYq+5oWkJk37ZWt7fMaqMT4x+IkO
         3QztU0uhTB3btX9s79ATdIfwt4MvJ2TAbjfd9hBw9B+l1Lm4wjcMerMsoXLI2rFJFEWf
         R2iw==
X-Gm-Message-State: AOJu0YyKoVlegxEtFHUHzJcYqVe0+X6PDorToZsu/WS5mYHznRZQIHn5
        XiUfAYCY3KSAwm5hHTMhLk/yCJ/oz+ZUbVCFLv0K/g==
X-Google-Smtp-Source: AGHT+IF424AIaaDGP3mEmWADXxKvMafTTEVIEC9y2GodBdWM1nxssfIaf+VbQh6Lw5rZ3EFxI3eKZ6tBBfbeDYUnH8A=
X-Received: by 2002:a2e:9915:0:b0:2b6:e0d3:45b7 with SMTP id
 v21-20020a2e9915000000b002b6e0d345b7mr113089lji.14.1692139902024; Tue, 15 Aug
 2023 15:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-21-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-21-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 15:51:29 -0700
Message-ID: <CAAdAUtgFUkwuRZTwXe3E2MkFYV4e8zjgUYjJAP_JLeYWtN9H4g@mail.gmail.com>
Subject: Re: [PATCH v4 20/28] KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
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
> Implement the trap forwarding for traps described by HFGxTR_EL2,
> reusing the Fine Grained Traps infrastructure previously implemented.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 71 +++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 0da9d92ed921..0e34797515b6 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -938,6 +938,7 @@ static DEFINE_XARRAY(sr_forward_xa);
>
>  enum fgt_group_id {
>         __NO_FGT_GROUP__,
> +       HFGxTR_GROUP,
>
>         /* Must be last */
>         __NR_FGT_GROUP_IDS__
> @@ -956,6 +957,69 @@ enum fgt_group_id {
>         }
>
>  static const struct encoding_to_trap_config encoding_to_fgt[] __initcons=
t =3D {
> +       /* HFGRTR_EL2, HFGWTR_EL2 */
> +       SR_FGT(SYS_TPIDR2_EL0,          HFGxTR, nTPIDR2_EL0, 0),
> +       SR_FGT(SYS_SMPRI_EL1,           HFGxTR, nSMPRI_EL1, 0),
> +       SR_FGT(SYS_ACCDATA_EL1,         HFGxTR, nACCDATA_EL1, 0),
> +       SR_FGT(SYS_ERXADDR_EL1,         HFGxTR, ERXADDR_EL1, 1),
> +       SR_FGT(SYS_ERXPFGCDN_EL1,       HFGxTR, ERXPFGCDN_EL1, 1),
> +       SR_FGT(SYS_ERXPFGCTL_EL1,       HFGxTR, ERXPFGCTL_EL1, 1),
> +       SR_FGT(SYS_ERXPFGF_EL1,         HFGxTR, ERXPFGF_EL1, 1),
> +       SR_FGT(SYS_ERXMISC0_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXMISC1_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXMISC2_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXMISC3_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXSTATUS_EL1,       HFGxTR, ERXSTATUS_EL1, 1),
> +       SR_FGT(SYS_ERXCTLR_EL1,         HFGxTR, ERXCTLR_EL1, 1),
> +       SR_FGT(SYS_ERXFR_EL1,           HFGxTR, ERXFR_EL1, 1),
> +       SR_FGT(SYS_ERRSELR_EL1,         HFGxTR, ERRSELR_EL1, 1),
> +       SR_FGT(SYS_ERRIDR_EL1,          HFGxTR, ERRIDR_EL1, 1),
> +       SR_FGT(SYS_ICC_IGRPEN0_EL1,     HFGxTR, ICC_IGRPENn_EL1, 1),
> +       SR_FGT(SYS_ICC_IGRPEN1_EL1,     HFGxTR, ICC_IGRPENn_EL1, 1),
> +       SR_FGT(SYS_VBAR_EL1,            HFGxTR, VBAR_EL1, 1),
> +       SR_FGT(SYS_TTBR1_EL1,           HFGxTR, TTBR1_EL1, 1),
> +       SR_FGT(SYS_TTBR0_EL1,           HFGxTR, TTBR0_EL1, 1),
> +       SR_FGT(SYS_TPIDR_EL0,           HFGxTR, TPIDR_EL0, 1),
> +       SR_FGT(SYS_TPIDRRO_EL0,         HFGxTR, TPIDRRO_EL0, 1),
> +       SR_FGT(SYS_TPIDR_EL1,           HFGxTR, TPIDR_EL1, 1),
> +       SR_FGT(SYS_TCR_EL1,             HFGxTR, TCR_EL1, 1),
> +       SR_FGT(SYS_SCXTNUM_EL0,         HFGxTR, SCXTNUM_EL0, 1),
> +       SR_FGT(SYS_SCXTNUM_EL1,         HFGxTR, SCXTNUM_EL1, 1),
> +       SR_FGT(SYS_SCTLR_EL1,           HFGxTR, SCTLR_EL1, 1),
> +       SR_FGT(SYS_REVIDR_EL1,          HFGxTR, REVIDR_EL1, 1),
> +       SR_FGT(SYS_PAR_EL1,             HFGxTR, PAR_EL1, 1),
> +       SR_FGT(SYS_MPIDR_EL1,           HFGxTR, MPIDR_EL1, 1),
> +       SR_FGT(SYS_MIDR_EL1,            HFGxTR, MIDR_EL1, 1),
> +       SR_FGT(SYS_MAIR_EL1,            HFGxTR, MAIR_EL1, 1),
> +       SR_FGT(SYS_LORSA_EL1,           HFGxTR, LORSA_EL1, 1),
> +       SR_FGT(SYS_LORN_EL1,            HFGxTR, LORN_EL1, 1),
> +       SR_FGT(SYS_LORID_EL1,           HFGxTR, LORID_EL1, 1),
> +       SR_FGT(SYS_LOREA_EL1,           HFGxTR, LOREA_EL1, 1),
> +       SR_FGT(SYS_LORC_EL1,            HFGxTR, LORC_EL1, 1),
> +       SR_FGT(SYS_ISR_EL1,             HFGxTR, ISR_EL1, 1),
> +       SR_FGT(SYS_FAR_EL1,             HFGxTR, FAR_EL1, 1),
> +       SR_FGT(SYS_ESR_EL1,             HFGxTR, ESR_EL1, 1),
> +       SR_FGT(SYS_DCZID_EL0,           HFGxTR, DCZID_EL0, 1),
> +       SR_FGT(SYS_CTR_EL0,             HFGxTR, CTR_EL0, 1),
> +       SR_FGT(SYS_CSSELR_EL1,          HFGxTR, CSSELR_EL1, 1),
> +       SR_FGT(SYS_CPACR_EL1,           HFGxTR, CPACR_EL1, 1),
> +       SR_FGT(SYS_CONTEXTIDR_EL1,      HFGxTR, CONTEXTIDR_EL1, 1),
> +       SR_FGT(SYS_CLIDR_EL1,           HFGxTR, CLIDR_EL1, 1),
> +       SR_FGT(SYS_CCSIDR_EL1,          HFGxTR, CCSIDR_EL1, 1),
> +       SR_FGT(SYS_APIBKEYLO_EL1,       HFGxTR, APIBKey, 1),
> +       SR_FGT(SYS_APIBKEYHI_EL1,       HFGxTR, APIBKey, 1),
> +       SR_FGT(SYS_APIAKEYLO_EL1,       HFGxTR, APIAKey, 1),
> +       SR_FGT(SYS_APIAKEYHI_EL1,       HFGxTR, APIAKey, 1),
> +       SR_FGT(SYS_APGAKEYLO_EL1,       HFGxTR, APGAKey, 1),
> +       SR_FGT(SYS_APGAKEYHI_EL1,       HFGxTR, APGAKey, 1),
> +       SR_FGT(SYS_APDBKEYLO_EL1,       HFGxTR, APDBKey, 1),
> +       SR_FGT(SYS_APDBKEYHI_EL1,       HFGxTR, APDBKey, 1),
> +       SR_FGT(SYS_APDAKEYLO_EL1,       HFGxTR, APDAKey, 1),
> +       SR_FGT(SYS_APDAKEYHI_EL1,       HFGxTR, APDAKey, 1),
> +       SR_FGT(SYS_AMAIR_EL1,           HFGxTR, AMAIR_EL1, 1),
> +       SR_FGT(SYS_AIDR_EL1,            HFGxTR, AIDR_EL1, 1),
> +       SR_FGT(SYS_AFSR1_EL1,           HFGxTR, AFSR1_EL1, 1),
> +       SR_FGT(SYS_AFSR0_EL1,           HFGxTR, AFSR0_EL1, 1),
>  };
>
>  static union trap_config get_trap_config(u32 sysreg)
> @@ -1160,6 +1224,13 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>         case __NO_FGT_GROUP__:
>                 break;
>
> +       case HFGxTR_GROUP:
> +               if (is_read)
> +                       val =3D sanitised_sys_reg(vcpu, HFGRTR_EL2);
> +               else
> +                       val =3D sanitised_sys_reg(vcpu, HFGWTR_EL2);
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
