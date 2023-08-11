Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318747785B0
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 05:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjHKDAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 23:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjHKDA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 23:00:28 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190C92D61
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:00:26 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1bbaa549c82so1363892fac.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691722825; x=1692327625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTJGjUqBapxVhvCdXTD7P0bpdJMZ6O+lPqjyCa3v71k=;
        b=vXUpok/T4f4PicGTiPoHq0EFJXLr816p6np/CAF2Fem9nUUCJHwpzYQVEP7RPcMPjo
         Q4i/Dn1zeqa3iSlR1qEjFIsygsGZwEEnKsCSVMJQmIY46rB7hSi8sTwOlMOuCd4oYaKf
         kbjawAhkXylXMh+tBuh6IifYtEh3fdNPs+0R/yW4IxbQXZqaH4Se7HKYpR6caGaaDayu
         aL/Il2WNNYBgFppcbfE1WgR+m2VzO684OKxMiOPdZO5RPgnIxN082GrXF+m3NafLYEGr
         MFt9e1CausCM+qw7QvEnprT/PkY0jEOOq3JwSQrA69QwnxTcrLrKkGri/QqG3S3attQD
         K6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691722825; x=1692327625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTJGjUqBapxVhvCdXTD7P0bpdJMZ6O+lPqjyCa3v71k=;
        b=gBlji/C7kMtswdJW/7S8bzTiTPKfLg+NkR6tCUCiV/0wFef3H0fKAQHCXB7LAEenXI
         NuKe84QFZDeZFZ8MncT+ZiFWVEnWoEleN2p7m1fgB0L1dcoMW0f2vkQOXecAJwl8XmU3
         lLJCecYqiHzatmAplWdy4KyOP3+tHpE93GtJDglh0h7/mffFA5F6zMJ+DfLboeNnmJla
         uAWp1oEsBYm7d3BH0p48nmDy0rjzWT/IqtYODdTso860LYBMMMddZi9iTFQ4etWJM928
         35wsNUx59QwPBvu02xsDH0I5ZctAzTnPd3YCPpOu9hjjpdZ6ZVMZuwL6rRDt9r606DtD
         qlfg==
X-Gm-Message-State: AOJu0YyN6wcorDwroVIZJrmG2VfnT/EU7u2tP1l+S/D2aa0XHDk9UlCB
        bF94KAdFjo3WNmdcxO+osRjdLeIvvz59/tqU2e65HQ==
X-Google-Smtp-Source: AGHT+IE4r9r52XP5QQyIa4kV7mjGBry+BkkZDTXNKGDTQSHIV8fdVgVCuEWMJzUei7+pxt1jhVKap2356aVv9pLNv/4=
X-Received: by 2002:a05:6870:7394:b0:1b7:4655:2ac9 with SMTP id
 z20-20020a056870739400b001b746552ac9mr719081oam.6.1691722825262; Thu, 10 Aug
 2023 20:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-7-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-7-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 10 Aug 2023 20:00:12 -0700
Message-ID: <CAAdAUthK6O6u3ZGePpGOqU1eVtfGfxd_0cBpm5LyvjAUzpnhRw@mail.gmail.com>
Subject: Re: [PATCH v3 06/27] arm64: Add debug registers affected by HDFGxTR_EL2
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> The HDFGxTR_EL2 registers trap a (huge) set of debug and trace
> related registers. Add their encodings (and only that, because
> we really don't care about what these registers actually do at
> this stage).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 76 +++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 76289339b43b..bb5a0877a210 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -194,6 +194,82 @@
>  #define SYS_DBGDTRTX_EL0               sys_reg(2, 3, 0, 5, 0)
>  #define SYS_DBGVCR32_EL2               sys_reg(2, 4, 0, 7, 0)
>
> +#define SYS_BRBINF_EL1(n)              sys_reg(2, 1, 8, (n & 15), (((n &=
 16) >> 2) | 0))
> +#define SYS_BRBINFINJ_EL1              sys_reg(2, 1, 9, 1, 0)
> +#define SYS_BRBSRC_EL1(n)              sys_reg(2, 1, 8, (n & 15), (((n &=
 16) >> 2) | 1))
> +#define SYS_BRBSRCINJ_EL1              sys_reg(2, 1, 9, 1, 1)
> +#define SYS_BRBTGT_EL1(n)              sys_reg(2, 1, 8, (n & 15), (((n &=
 16) >> 2) | 2))
> +#define SYS_BRBTGTINJ_EL1              sys_reg(2, 1, 9, 1, 2)
> +#define SYS_BRBTS_EL1                  sys_reg(2, 1, 9, 0, 2)
> +
> +#define SYS_BRBCR_EL1                  sys_reg(2, 1, 9, 0, 0)
> +#define SYS_BRBFCR_EL1                 sys_reg(2, 1, 9, 0, 1)
> +#define SYS_BRBIDR0_EL1                        sys_reg(2, 1, 9, 2, 0)
> +
> +#define SYS_TRCITECR_EL1               sys_reg(3, 0, 1, 2, 3)
> +#define SYS_TRCACATR(m)                        sys_reg(2, 1, 2, ((m & 7)=
 << 1), (2 | (m >> 3)))
> +#define SYS_TRCACVR(m)                 sys_reg(2, 1, 2, ((m & 7) << 1), =
(0 | (m >> 3)))
> +#define SYS_TRCAUTHSTATUS              sys_reg(2, 1, 7, 14, 6)
> +#define SYS_TRCAUXCTLR                 sys_reg(2, 1, 0, 6, 0)
> +#define SYS_TRCBBCTLR                  sys_reg(2, 1, 0, 15, 0)
> +#define SYS_TRCCCCTLR                  sys_reg(2, 1, 0, 14, 0)
> +#define SYS_TRCCIDCCTLR0               sys_reg(2, 1, 3, 0, 2)
> +#define SYS_TRCCIDCCTLR1               sys_reg(2, 1, 3, 1, 2)
> +#define SYS_TRCCIDCVR(m)               sys_reg(2, 1, 3, ((m & 7) << 1), =
0)
> +#define SYS_TRCCLAIMCLR                        sys_reg(2, 1, 7, 9, 6)
> +#define SYS_TRCCLAIMSET                        sys_reg(2, 1, 7, 8, 6)
> +#define SYS_TRCCNTCTLR(m)              sys_reg(2, 1, 0, (4 | (m & 3)), 5=
)
> +#define SYS_TRCCNTRLDVR(m)             sys_reg(2, 1, 0, (0 | (m & 3)), 5=
)
> +#define SYS_TRCCNTVR(m)                        sys_reg(2, 1, 0, (8 | (m =
& 3)), 5)
> +#define SYS_TRCCONFIGR                 sys_reg(2, 1, 0, 4, 0)
> +#define SYS_TRCDEVARCH                 sys_reg(2, 1, 7, 15, 6)
> +#define SYS_TRCDEVID                   sys_reg(2, 1, 7, 2, 7)
> +#define SYS_TRCEVENTCTL0R              sys_reg(2, 1, 0, 8, 0)
> +#define SYS_TRCEVENTCTL1R              sys_reg(2, 1, 0, 9, 0)
> +#define SYS_TRCEXTINSELR(m)            sys_reg(2, 1, 0, (8 | (m & 3)), 4=
)
> +#define SYS_TRCIDR0                    sys_reg(2, 1, 0, 8, 7)
> +#define SYS_TRCIDR10                   sys_reg(2, 1, 0, 2, 6)
> +#define SYS_TRCIDR11                   sys_reg(2, 1, 0, 3, 6)
> +#define SYS_TRCIDR12                   sys_reg(2, 1, 0, 4, 6)
> +#define SYS_TRCIDR13                   sys_reg(2, 1, 0, 5, 6)
> +#define SYS_TRCIDR1                    sys_reg(2, 1, 0, 9, 7)
> +#define SYS_TRCIDR2                    sys_reg(2, 1, 0, 10, 7)
> +#define SYS_TRCIDR3                    sys_reg(2, 1, 0, 11, 7)
> +#define SYS_TRCIDR4                    sys_reg(2, 1, 0, 12, 7)
> +#define SYS_TRCIDR5                    sys_reg(2, 1, 0, 13, 7)
> +#define SYS_TRCIDR6                    sys_reg(2, 1, 0, 14, 7)
> +#define SYS_TRCIDR7                    sys_reg(2, 1, 0, 15, 7)
> +#define SYS_TRCIDR8                    sys_reg(2, 1, 0, 0, 6)
> +#define SYS_TRCIDR9                    sys_reg(2, 1, 0, 1, 6)
> +#define SYS_TRCIMSPEC(m)               sys_reg(2, 1, 0, (m & 7), 7)
> +#define SYS_TRCITEEDCR                 sys_reg(2, 1, 0, 2, 1)
> +#define SYS_TRCOSLSR                   sys_reg(2, 1, 1, 1, 4)
> +#define SYS_TRCPRGCTLR                 sys_reg(2, 1, 0, 1, 0)
> +#define SYS_TRCQCTLR                   sys_reg(2, 1, 0, 1, 1)
> +#define SYS_TRCRSCTLR(m)               sys_reg(2, 1, 1, (m & 15), (0 | (=
m >> 4)))
> +#define SYS_TRCRSR                     sys_reg(2, 1, 0, 10, 0)
> +#define SYS_TRCSEQEVR(m)               sys_reg(2, 1, 0, (m & 3), 4)
> +#define SYS_TRCSEQRSTEVR               sys_reg(2, 1, 0, 6, 4)
> +#define SYS_TRCSEQSTR                  sys_reg(2, 1, 0, 7, 4)
> +#define SYS_TRCSSCCR(m)                        sys_reg(2, 1, 1, (m & 7),=
 2)
> +#define SYS_TRCSSCSR(m)                        sys_reg(2, 1, 1, (8 | (m =
& 7)), 2)
> +#define SYS_TRCSSPCICR(m)              sys_reg(2, 1, 1, (m & 7), 3)
> +#define SYS_TRCSTALLCTLR               sys_reg(2, 1, 0, 11, 0)
> +#define SYS_TRCSTATR                   sys_reg(2, 1, 0, 3, 0)
> +#define SYS_TRCSYNCPR                  sys_reg(2, 1, 0, 13, 0)
> +#define SYS_TRCTRACEIDR                        sys_reg(2, 1, 0, 0, 1)
> +#define SYS_TRCTSCTLR                  sys_reg(2, 1, 0, 12, 0)
> +#define SYS_TRCVICTLR                  sys_reg(2, 1, 0, 0, 2)
> +#define SYS_TRCVIIECTLR                        sys_reg(2, 1, 0, 1, 2)
> +#define SYS_TRCVIPCSSCTLR              sys_reg(2, 1, 0, 3, 2)
> +#define SYS_TRCVISSCTLR                        sys_reg(2, 1, 0, 2, 2)
> +#define SYS_TRCVMIDCCTLR0              sys_reg(2, 1, 3, 2, 2)
> +#define SYS_TRCVMIDCCTLR1              sys_reg(2, 1, 3, 3, 2)
> +#define SYS_TRCVMIDCVR(m)              sys_reg(2, 1, 3, ((m & 7) << 1), =
1)
> +
> +/* ETM */
> +#define SYS_TRCOSLAR                   sys_reg(2, 1, 1, 0, 4)
> +
>  #define SYS_MIDR_EL1                   sys_reg(3, 0, 0, 0, 0)
>  #define SYS_MPIDR_EL1                  sys_reg(3, 0, 0, 0, 5)
>  #define SYS_REVIDR_EL1                 sys_reg(3, 0, 0, 0, 6)
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
