Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD67277D557
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbjHOVno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbjHOVnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:43:11 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205C51986
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:43:09 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b9cdba1228so94150591fa.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135480; x=1692740280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2sctgT1wH5Lqd22f2ABBD1VTVZmhMkvIYU6kWCycPRk=;
        b=P6yS/Oship2+laIp1vQDVshDF65dM7QWRYRwA+QxQiC01Qfrb8blZ3KvdhlDRFUGOB
         IPD4FFOt06Id1lK86Mql+NQp//CsGoY8orbHidKhtgt0yetRRBcyv8L3gQ0e7L9X6UTD
         U8m/R9xZJhGlKwVJGIiOPZhf5NYu+aChlNXm6SOliWpskPoRoAQ1aXd05uT2/H3hYnlr
         0XTPNuEjJY+XWWrEGCUrkp1qRyVks6I59ZZb3YqbJTI8pF81HFVTe69+wypoBPG5UIvK
         3dVkJnXX34BVx2rzpc8OVEaAOAJ/t5TJiuZE3R0P6eeNUzeyvdWB50YN3Ta1vEAarXcE
         5u+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135480; x=1692740280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2sctgT1wH5Lqd22f2ABBD1VTVZmhMkvIYU6kWCycPRk=;
        b=IwMthClBuKuZcbuJ72K/k97k9PLhd77CECOie9ifkDs4VKlGSpLFWpysUA3ZMqFudk
         1bhLh/uhnLBtSa+Rk7rp1dnnyaa0Yg8B7Pa25WWOQfLanDO5RanbWRKLfdH2eYgNcX9r
         ZNAANAZgpZ/texR9CPex0ByCDYYHSYxv3wUQDbvCjOBm/fphtRb+yFsbTA7Xy/nIRING
         i8mozPaMb6OxFUoDOCKzlGTPGSzsYf7oEetd/MxWbpvW7OYR0mF3A7MNmQiaDB4aGIp7
         QikC6FcFN3CutBdxsfg2el1DgIVDrV6F5me7HKx2WX0p5nURtFxzHHdTZM7/GeEALe2W
         5JAw==
X-Gm-Message-State: AOJu0Yw5CR6U/ca1dWg3NTk67/Az6V/3dRR1g+QlKRjK3FULgj49l3OP
        xSlevUDALvdx34LJKffcjke+vL9jtpXiQ8ePEKkXMg==
X-Google-Smtp-Source: AGHT+IGp0L/yrcrV48vsek16cyxTRdl2libYjq/OLgadlLJR8aFfojIWhdVF3nWpzahzdffTL+V0fO+a587WPL/YkYg=
X-Received: by 2002:a05:651c:14a:b0:2b9:5695:d10d with SMTP id
 c10-20020a05651c014a00b002b95695d10dmr1426ljd.36.1692135479942; Tue, 15 Aug
 2023 14:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-16-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-16-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 14:37:47 -0700
Message-ID: <CAAdAUtgcAjk87Zn45xbHCL-bK2aF8gm-XYGDKj7FvXags81q9A@mail.gmail.com>
Subject: Re: [PATCH v4 15/28] KVM: arm64: nv: Add trap forwarding for HCR_EL2
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_75_100,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Describe the HCR_EL2 register, and associate it with all the sysregs
> it allows to trap.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 488 ++++++++++++++++++++++++++++++++
>  1 file changed, 488 insertions(+)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index d5837ed0077c..975a30ef874a 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -38,12 +38,48 @@ enum cgt_group_id {
>          * on their own instead of being part of a combination of
>          * trap controls.
>          */
> +       CGT_HCR_TID1,
> +       CGT_HCR_TID2,
> +       CGT_HCR_TID3,
> +       CGT_HCR_IMO,
> +       CGT_HCR_FMO,
> +       CGT_HCR_TIDCP,
> +       CGT_HCR_TACR,
> +       CGT_HCR_TSW,
> +       CGT_HCR_TPC,
> +       CGT_HCR_TPU,
> +       CGT_HCR_TTLB,
> +       CGT_HCR_TVM,
> +       CGT_HCR_TDZ,
> +       CGT_HCR_TRVM,
> +       CGT_HCR_TLOR,
> +       CGT_HCR_TERR,
> +       CGT_HCR_APK,
> +       CGT_HCR_NV,
> +       CGT_HCR_NV_nNV2,
> +       CGT_HCR_NV1_nNV2,
> +       CGT_HCR_AT,
> +       CGT_HCR_nFIEN,
> +       CGT_HCR_TID4,
> +       CGT_HCR_TICAB,
> +       CGT_HCR_TOCU,
> +       CGT_HCR_ENSCXT,
> +       CGT_HCR_TTLBIS,
> +       CGT_HCR_TTLBOS,
>
>         /*
>          * Anything after this point is a combination of coarse trap
>          * controls, which must all be evaluated to decide what to do.
>          */
>         __MULTIPLE_CONTROL_BITS__,
> +       CGT_HCR_IMO_FMO =3D __MULTIPLE_CONTROL_BITS__,
> +       CGT_HCR_TID2_TID4,
> +       CGT_HCR_TTLB_TTLBIS,
> +       CGT_HCR_TTLB_TTLBOS,
> +       CGT_HCR_TVM_TRVM,
> +       CGT_HCR_TPU_TICAB,
> +       CGT_HCR_TPU_TOCU,
> +       CGT_HCR_NV1_nNV2_ENSCXT,
>
>         /*
>          * Anything after this point requires a callback evaluating a
> @@ -56,6 +92,174 @@ enum cgt_group_id {
>  };
>
>  static const struct trap_bits coarse_trap_bits[] =3D {
> +       [CGT_HCR_TID1] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TID1,
> +               .mask           =3D HCR_TID1,
> +               .behaviour      =3D BEHAVE_FORWARD_READ,
> +       },
> +       [CGT_HCR_TID2] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TID2,
> +               .mask           =3D HCR_TID2,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TID3] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TID3,
> +               .mask           =3D HCR_TID3,
> +               .behaviour      =3D BEHAVE_FORWARD_READ,
> +       },
> +       [CGT_HCR_IMO] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_IMO,
> +               .mask           =3D HCR_IMO,
> +               .behaviour      =3D BEHAVE_FORWARD_WRITE,
> +       },
> +       [CGT_HCR_FMO] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_FMO,
> +               .mask           =3D HCR_FMO,
> +               .behaviour      =3D BEHAVE_FORWARD_WRITE,
> +       },
> +       [CGT_HCR_TIDCP] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TIDCP,
> +               .mask           =3D HCR_TIDCP,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TACR] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TACR,
> +               .mask           =3D HCR_TACR,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TSW] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TSW,
> +               .mask           =3D HCR_TSW,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TPC] =3D { /* Also called TCPC when FEAT_DPB is implemen=
ted */
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TPC,
> +               .mask           =3D HCR_TPC,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TPU] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TPU,
> +               .mask           =3D HCR_TPU,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TTLB] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TTLB,
> +               .mask           =3D HCR_TTLB,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TVM] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TVM,
> +               .mask           =3D HCR_TVM,
> +               .behaviour      =3D BEHAVE_FORWARD_WRITE,
> +       },
> +       [CGT_HCR_TDZ] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TDZ,
> +               .mask           =3D HCR_TDZ,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TRVM] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TRVM,
> +               .mask           =3D HCR_TRVM,
> +               .behaviour      =3D BEHAVE_FORWARD_READ,
> +       },
> +       [CGT_HCR_TLOR] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TLOR,
> +               .mask           =3D HCR_TLOR,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TERR] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TERR,
> +               .mask           =3D HCR_TERR,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_APK] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D 0,
> +               .mask           =3D HCR_APK,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_NV] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_NV,
> +               .mask           =3D HCR_NV,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_NV_nNV2] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_NV,
> +               .mask           =3D HCR_NV | HCR_NV2,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_NV1_nNV2] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_NV | HCR_NV1,
> +               .mask           =3D HCR_NV | HCR_NV1 | HCR_NV2,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_AT] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_AT,
> +               .mask           =3D HCR_AT,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_nFIEN] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D 0,
> +               .mask           =3D HCR_FIEN,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TID4] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TID4,
> +               .mask           =3D HCR_TID4,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TICAB] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TICAB,
> +               .mask           =3D HCR_TICAB,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TOCU] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TOCU,
> +               .mask           =3D HCR_TOCU,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_ENSCXT] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D 0,
> +               .mask           =3D HCR_ENSCXT,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TTLBIS] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TTLBIS,
> +               .mask           =3D HCR_TTLBIS,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
> +       [CGT_HCR_TTLBOS] =3D {
> +               .index          =3D HCR_EL2,
> +               .value          =3D HCR_TTLBOS,
> +               .mask           =3D HCR_TTLBOS,
> +               .behaviour      =3D BEHAVE_FORWARD_ANY,
> +       },
>  };
>
>  #define MCB(id, ...)                                           \
> @@ -65,6 +269,14 @@ static const struct trap_bits coarse_trap_bits[] =3D =
{
>                 }
>
>  static const enum cgt_group_id *coarse_control_combo[] =3D {
> +       MCB(CGT_HCR_IMO_FMO,            CGT_HCR_IMO, CGT_HCR_FMO),
> +       MCB(CGT_HCR_TID2_TID4,          CGT_HCR_TID2, CGT_HCR_TID4),
> +       MCB(CGT_HCR_TTLB_TTLBIS,        CGT_HCR_TTLB, CGT_HCR_TTLBIS),
> +       MCB(CGT_HCR_TTLB_TTLBOS,        CGT_HCR_TTLB, CGT_HCR_TTLBOS),
> +       MCB(CGT_HCR_TVM_TRVM,           CGT_HCR_TVM, CGT_HCR_TRVM),
> +       MCB(CGT_HCR_TPU_TICAB,          CGT_HCR_TPU, CGT_HCR_TICAB),
> +       MCB(CGT_HCR_TPU_TOCU,           CGT_HCR_TPU, CGT_HCR_TOCU),
> +       MCB(CGT_HCR_NV1_nNV2_ENSCXT,    CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT)=
,
>  };
>
>  typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *=
);
> @@ -121,6 +333,282 @@ struct encoding_to_trap_config {
>   * re-injected in the nested hypervisor.
>   */
>  static const struct encoding_to_trap_config encoding_to_cgt[] __initcons=
t =3D {
> +       SR_TRAP(SYS_REVIDR_EL1,         CGT_HCR_TID1),
> +       SR_TRAP(SYS_AIDR_EL1,           CGT_HCR_TID1),
> +       SR_TRAP(SYS_SMIDR_EL1,          CGT_HCR_TID1),
> +       SR_TRAP(SYS_CTR_EL0,            CGT_HCR_TID2),
> +       SR_TRAP(SYS_CCSIDR_EL1,         CGT_HCR_TID2_TID4),
> +       SR_TRAP(SYS_CCSIDR2_EL1,        CGT_HCR_TID2_TID4),
> +       SR_TRAP(SYS_CLIDR_EL1,          CGT_HCR_TID2_TID4),
> +       SR_TRAP(SYS_CSSELR_EL1,         CGT_HCR_TID2_TID4),
> +       SR_RANGE_TRAP(SYS_ID_PFR0_EL1,
> +                     sys_reg(3, 0, 0, 7, 7), CGT_HCR_TID3),
> +       SR_TRAP(SYS_ICC_SGI0R_EL1,      CGT_HCR_IMO_FMO),
> +       SR_TRAP(SYS_ICC_ASGI1R_EL1,     CGT_HCR_IMO_FMO),
> +       SR_TRAP(SYS_ICC_SGI1R_EL1,      CGT_HCR_IMO_FMO),
> +       SR_RANGE_TRAP(sys_reg(3, 0, 11, 0, 0),
> +                     sys_reg(3, 0, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 1, 11, 0, 0),
> +                     sys_reg(3, 1, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 2, 11, 0, 0),
> +                     sys_reg(3, 2, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 3, 11, 0, 0),
> +                     sys_reg(3, 3, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 4, 11, 0, 0),
> +                     sys_reg(3, 4, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 5, 11, 0, 0),
> +                     sys_reg(3, 5, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 6, 11, 0, 0),
> +                     sys_reg(3, 6, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 7, 11, 0, 0),
> +                     sys_reg(3, 7, 11, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 0, 15, 0, 0),
> +                     sys_reg(3, 0, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 1, 15, 0, 0),
> +                     sys_reg(3, 1, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 2, 15, 0, 0),
> +                     sys_reg(3, 2, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 3, 15, 0, 0),
> +                     sys_reg(3, 3, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 4, 15, 0, 0),
> +                     sys_reg(3, 4, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 5, 15, 0, 0),
> +                     sys_reg(3, 5, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 6, 15, 0, 0),
> +                     sys_reg(3, 6, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_RANGE_TRAP(sys_reg(3, 7, 15, 0, 0),
> +                     sys_reg(3, 7, 15, 15, 7), CGT_HCR_TIDCP),
> +       SR_TRAP(SYS_ACTLR_EL1,          CGT_HCR_TACR),
> +       SR_TRAP(SYS_DC_ISW,             CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_CSW,             CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_CISW,            CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_IGSW,            CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_IGDSW,           CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_CGSW,            CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_CGDSW,           CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_CIGSW,           CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_CIGDSW,          CGT_HCR_TSW),
> +       SR_TRAP(SYS_DC_CIVAC,           CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CVAC,            CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CVAP,            CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CVADP,           CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_IVAC,            CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CIGVAC,          CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CIGDVAC,         CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_IGVAC,           CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_IGDVAC,          CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CGVAC,           CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CGDVAC,          CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CGVAP,           CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CGDVAP,          CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CGVADP,          CGT_HCR_TPC),
> +       SR_TRAP(SYS_DC_CGDVADP,         CGT_HCR_TPC),
> +       SR_TRAP(SYS_IC_IVAU,            CGT_HCR_TPU_TOCU),
> +       SR_TRAP(SYS_IC_IALLU,           CGT_HCR_TPU_TOCU),
> +       SR_TRAP(SYS_IC_IALLUIS,         CGT_HCR_TPU_TICAB),
> +       SR_TRAP(SYS_DC_CVAU,            CGT_HCR_TPU_TOCU),
> +       SR_TRAP(OP_TLBI_RVAE1,          CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVAAE1,         CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVALE1,         CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVAALE1,        CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VMALLE1,        CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VAE1,           CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_ASIDE1,         CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VAAE1,          CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VALE1,          CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VAALE1,         CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVAE1NXS,       CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVAAE1NXS,      CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVALE1NXS,      CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVAALE1NXS,     CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VMALLE1NXS,     CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VAE1NXS,        CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_ASIDE1NXS,      CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VAAE1NXS,       CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VALE1NXS,       CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_VAALE1NXS,      CGT_HCR_TTLB),
> +       SR_TRAP(OP_TLBI_RVAE1IS,        CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_RVAAE1IS,       CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_RVALE1IS,       CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_RVAALE1IS,      CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VMALLE1IS,      CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VAE1IS,         CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_ASIDE1IS,       CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VAAE1IS,        CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VALE1IS,        CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VAALE1IS,       CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_RVAE1ISNXS,     CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_RVAAE1ISNXS,    CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_RVALE1ISNXS,    CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_RVAALE1ISNXS,   CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VMALLE1ISNXS,   CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VAE1ISNXS,      CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_ASIDE1ISNXS,    CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VAAE1ISNXS,     CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VALE1ISNXS,     CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VAALE1ISNXS,    CGT_HCR_TTLB_TTLBIS),
> +       SR_TRAP(OP_TLBI_VMALLE1OS,      CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VAE1OS,         CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_ASIDE1OS,       CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VAAE1OS,        CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VALE1OS,        CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VAALE1OS,       CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVAE1OS,        CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVAAE1OS,       CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVALE1OS,       CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVAALE1OS,      CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VMALLE1OSNXS,   CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VAE1OSNXS,      CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_ASIDE1OSNXS,    CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VAAE1OSNXS,     CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VALE1OSNXS,     CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_VAALE1OSNXS,    CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVAE1OSNXS,     CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVAAE1OSNXS,    CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVALE1OSNXS,    CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(OP_TLBI_RVAALE1OSNXS,   CGT_HCR_TTLB_TTLBOS),
> +       SR_TRAP(SYS_SCTLR_EL1,          CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_TTBR0_EL1,          CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_TTBR1_EL1,          CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_TCR_EL1,            CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_ESR_EL1,            CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_FAR_EL1,            CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_AFSR0_EL1,          CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_AFSR1_EL1,          CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_MAIR_EL1,           CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_AMAIR_EL1,          CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_CONTEXTIDR_EL1,     CGT_HCR_TVM_TRVM),
> +       SR_TRAP(SYS_DC_ZVA,             CGT_HCR_TDZ),
> +       SR_TRAP(SYS_DC_GVA,             CGT_HCR_TDZ),
> +       SR_TRAP(SYS_DC_GZVA,            CGT_HCR_TDZ),
> +       SR_TRAP(SYS_LORSA_EL1,          CGT_HCR_TLOR),
> +       SR_TRAP(SYS_LOREA_EL1,          CGT_HCR_TLOR),
> +       SR_TRAP(SYS_LORN_EL1,           CGT_HCR_TLOR),
> +       SR_TRAP(SYS_LORC_EL1,           CGT_HCR_TLOR),
> +       SR_TRAP(SYS_LORID_EL1,          CGT_HCR_TLOR),
> +       SR_TRAP(SYS_ERRIDR_EL1,         CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERRSELR_EL1,        CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXADDR_EL1,        CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXCTLR_EL1,        CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXFR_EL1,          CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXMISC0_EL1,       CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXMISC1_EL1,       CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXMISC2_EL1,       CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXMISC3_EL1,       CGT_HCR_TERR),
> +       SR_TRAP(SYS_ERXSTATUS_EL1,      CGT_HCR_TERR),
> +       SR_TRAP(SYS_APIAKEYLO_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APIAKEYHI_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APIBKEYLO_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APIBKEYHI_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APDAKEYLO_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APDAKEYHI_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APDBKEYLO_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APDBKEYHI_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APGAKEYLO_EL1,      CGT_HCR_APK),
> +       SR_TRAP(SYS_APGAKEYHI_EL1,      CGT_HCR_APK),
> +       /* All _EL2 registers */
> +       SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
> +                     sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
> +       /* Skip the SP_EL1 encoding... */
> +       SR_RANGE_TRAP(sys_reg(3, 4, 4, 1, 1),
> +                     sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
> +       SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
> +                     sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
> +       /* All _EL02, _EL12 registers */
> +       SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
> +                     sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
> +       SR_RANGE_TRAP(sys_reg(3, 5, 12, 0, 0),
> +                     sys_reg(3, 5, 14, 15, 7), CGT_HCR_NV),
> +       SR_TRAP(OP_AT_S1E2R,            CGT_HCR_NV),
> +       SR_TRAP(OP_AT_S1E2W,            CGT_HCR_NV),
> +       SR_TRAP(OP_AT_S12E1R,           CGT_HCR_NV),
> +       SR_TRAP(OP_AT_S12E1W,           CGT_HCR_NV),
> +       SR_TRAP(OP_AT_S12E0R,           CGT_HCR_NV),
> +       SR_TRAP(OP_AT_S12E0W,           CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2E1,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2E1,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2LE1,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2LE1,      CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVAE2,          CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVALE2,         CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE2,          CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VAE2,           CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE1,          CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VALE2,          CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VMALLS12E1,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2E1NXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2E1NXS,    CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2LE1NXS,    CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2LE1NXS,   CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVAE2NXS,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVALE2NXS,      CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE2NXS,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VAE2NXS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE1NXS,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VALE2NXS,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VMALLS12E1NXS,  CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2E1IS,      CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2E1IS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2LE1IS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2LE1IS,    CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVAE2IS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVALE2IS,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE2IS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VAE2IS,         CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE1IS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VALE2IS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VMALLS12E1IS,   CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2E1ISNXS,   CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2E1ISNXS,  CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2LE1ISNXS,  CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2LE1ISNXS, CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVAE2ISNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVALE2ISNXS,    CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE2ISNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VAE2ISNXS,      CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE1ISNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VALE2ISNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VMALLS12E1ISNXS,CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE2OS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VAE2OS,         CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE1OS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VALE2OS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VMALLS12E1OS,   CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2E1OS,      CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2E1OS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2LE1OS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2LE1OS,    CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVAE2OS,        CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVALE2OS,       CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE2OSNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VAE2OSNXS,      CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_ALLE1OSNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VALE2OSNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_VMALLS12E1OSNXS,CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2E1OSNXS,   CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2E1OSNXS,  CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_IPAS2LE1OSNXS,  CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RIPAS2LE1OSNXS, CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVAE2OSNXS,     CGT_HCR_NV),
> +       SR_TRAP(OP_TLBI_RVALE2OSNXS,    CGT_HCR_NV),
> +       SR_TRAP(OP_CPP_RCTX,            CGT_HCR_NV),
> +       SR_TRAP(OP_DVP_RCTX,            CGT_HCR_NV),
> +       SR_TRAP(OP_CFP_RCTX,            CGT_HCR_NV),
> +       SR_TRAP(SYS_SP_EL1,             CGT_HCR_NV_nNV2),
> +       SR_TRAP(SYS_VBAR_EL1,           CGT_HCR_NV1_nNV2),
> +       SR_TRAP(SYS_ELR_EL1,            CGT_HCR_NV1_nNV2),
> +       SR_TRAP(SYS_SPSR_EL1,           CGT_HCR_NV1_nNV2),
> +       SR_TRAP(SYS_SCXTNUM_EL1,        CGT_HCR_NV1_nNV2_ENSCXT),
> +       SR_TRAP(SYS_SCXTNUM_EL0,        CGT_HCR_ENSCXT),
> +       SR_TRAP(OP_AT_S1E1R,            CGT_HCR_AT),
> +       SR_TRAP(OP_AT_S1E1W,            CGT_HCR_AT),
> +       SR_TRAP(OP_AT_S1E0R,            CGT_HCR_AT),
> +       SR_TRAP(OP_AT_S1E0W,            CGT_HCR_AT),
> +       SR_TRAP(OP_AT_S1E1RP,           CGT_HCR_AT),
> +       SR_TRAP(OP_AT_S1E1WP,           CGT_HCR_AT),
> +       SR_TRAP(SYS_ERXPFGF_EL1,        CGT_HCR_nFIEN),
> +       SR_TRAP(SYS_ERXPFGCTL_EL1,      CGT_HCR_nFIEN),
> +       SR_TRAP(SYS_ERXPFGCDN_EL1,      CGT_HCR_nFIEN),
>  };
>
>  static DEFINE_XARRAY(sr_forward_xa);
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
