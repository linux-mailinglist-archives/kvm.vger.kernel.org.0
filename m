Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5540D77964C
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 19:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbjHKRke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 13:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236789AbjHKRkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 13:40:33 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC9A30DE
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 10:40:32 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-5607cdb0959so1518431eaf.2
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 10:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691775632; x=1692380432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOtlYSZgeiijyItPMeigs6OhNr2NGQsx1KFHsLqIaG8=;
        b=27O3stW8bCTVVB2vY0F+yB33b4/PAyJkPwBMgjCfVCsH7OkVsdlXWAPV+RVKqyL8fm
         qOYghNr3xuGXJQ534skcPYijnybI2FR4cp3uP3RlS6jt0Q9jZZqrMXVOiDwyhrxgiElG
         EpUTrYZ6ZQf0PtJpZMsMV3OqmxnZbyaE35mb2qIUY95ACmhNEt0j/fofKOqXuY7H5DJp
         yX6gmfSeDXTf6Vu+UMQW2R1d3smSZFhd6mDhCUcr1aFEBuqU8Rgm0y9vfvm0xWm4hkb2
         wme+/i16iR686y8jWiQHq9qHYOyNJp9x+SlUgwoqomCnJsQRzxAcBVJj1IxwT2X1Jg6l
         qrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691775632; x=1692380432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dOtlYSZgeiijyItPMeigs6OhNr2NGQsx1KFHsLqIaG8=;
        b=eEr6BTjdAzJknvfFVrTiMR251xbj35xObm92iTg+s0cMC2R0+KJwhPv9x1awviIVkp
         Z4gv1Yf7Gt2pA0b0najsEoYwVLKT62hUur03b51kkY5b8aJSyEDM87DSZoMRrOVrPtkX
         //kq6EME+jIwS0xfivRc8O277lez5nQtggtbdMoy60/mkNy0wmGsLDQKpgQt3mA1SFIp
         w+MTMrXni+8fN++TCtHX97lh0bS1YiEEJFkaLNZdW2+uwYMM1BXm3SPZVekphsAy7iC2
         8foSjgzQNYs3rBa99zyGxJ9tipstTMRFOQVxRfTXMdg1CpKJdYxshHZbU4MoP6Y32w2C
         HwoA==
X-Gm-Message-State: AOJu0YxGC/sQIrWQZaLtlOEv2m7AEUnrPh9Q2RM7VdbZFyabDNlboe1q
        +UlmQ99gBFghOGOwDG80knQeQqgPOgSfrCByMSOcEg==
X-Google-Smtp-Source: AGHT+IGrPdqjjmuzKKjgmseqrlaiV6HLzrmiZwW4eAv/hrhZ5H8Pg3Oq2tlW75x2GsrvU4lQHJTwZcgbfu7rWqAH+vc=
X-Received: by 2002:a4a:8002:0:b0:566:fd3b:4329 with SMTP id
 x2-20020a4a8002000000b00566fd3b4329mr1441317oof.7.1691775631786; Fri, 11 Aug
 2023 10:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-14-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-14-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 11 Aug 2023 10:40:20 -0700
Message-ID: <CAAdAUtgpd=nBz41Ug8Z-bt2riehBa3R=THop0vjXpc0oAzQntw@mail.gmail.com>
Subject: Re: [PATCH v3 13/27] KVM: arm64: Restructure FGT register switching
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

On Tue, Aug 8, 2023 at 4:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> As we're about to majorly extend the handling of FGT registers,
> restructure the code to actually save/restore the registers
> as required. This is made easy thanks to the previous addition
> of the EL2 registers, allowing us to use the host context for
> this purpose.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h        | 21 ++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 56 +++++++++++++------------
>  2 files changed, 50 insertions(+), 27 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 028049b147df..85908aa18908 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -333,6 +333,27 @@
>                                  BIT(18) |              \
>                                  GENMASK(16, 15))
>
> +/*
> + * FGT register definitions
> + *
> + * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
> + * We're not using the generated masks as they are usually ahead of
> + * the published ARM ARM, which we use as a reference.
> + *
> + * Once we get to a point where the two describe the same thing, we'll
> + * merge the definitions. One day.
> + */
> +#define __HFGRTR_EL2_RES0      (GENMASK(63, 56) | GENMASK(53, 51))
> +#define __HFGRTR_EL2_MASK      GENMASK(49, 0)
> +#define __HFGRTR_EL2_nMASK     (GENMASK(55, 54) | BIT(50))
> +
> +#define __HFGWTR_EL2_RES0      (GENMASK(63, 56) | GENMASK(53, 51) |    \
> +                                BIT(46) | BIT(42) | BIT(40) | BIT(28) | =
\
> +                                GENMASK(26, 25) | BIT(21) | BIT(18) |  \
> +                                GENMASK(15, 14) | GENMASK(10, 9) | BIT(2=
))
> +#define __HFGWTR_EL2_MASK      GENMASK(49, 0)
> +#define __HFGWTR_EL2_nMASK     (GENMASK(55, 54) | BIT(50))
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK     (~UL(0xf))
>  /*
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 4bddb8541bec..e096b16e85fd 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -70,20 +70,19 @@ static inline void __activate_traps_fpsimd32(struct k=
vm_vcpu *vcpu)
>         }
>  }
>
> -static inline bool __hfgxtr_traps_required(void)
> -{
> -       if (cpus_have_final_cap(ARM64_SME))
> -               return true;
> -
> -       if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -               return true;
>
> -       return false;
> -}
>
> -static inline void __activate_traps_hfgxtr(void)
> +static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm_cpu_context *hctxt =3D &this_cpu_ptr(&kvm_host_data)->=
host_ctxt;
>         u64 r_clr =3D 0, w_clr =3D 0, r_set =3D 0, w_set =3D 0, tmp;
> +       u64 r_val, w_val;
> +
> +       if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +               return;
> +
> +       ctxt_sys_reg(hctxt, HFGRTR_EL2) =3D read_sysreg_s(SYS_HFGRTR_EL2)=
;
> +       ctxt_sys_reg(hctxt, HFGWTR_EL2) =3D read_sysreg_s(SYS_HFGWTR_EL2)=
;
>
>         if (cpus_have_final_cap(ARM64_SME)) {
>                 tmp =3D HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_E=
L0_MASK;
> @@ -98,26 +97,31 @@ static inline void __activate_traps_hfgxtr(void)
>         if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>                 w_set |=3D HFGxTR_EL2_TCR_EL1_MASK;
>
> -       sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> -       sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
> +
> +       /* The default is not to trap anything but ACCDATA_EL1 */
> +       r_val =3D __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> +       r_val |=3D r_set;
> +       r_val &=3D ~r_clr;
> +
> +       w_val =3D __HFGWTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> +       w_val |=3D w_set;
> +       w_val &=3D ~w_clr;
> +
> +       write_sysreg_s(r_val, SYS_HFGRTR_EL2);
> +       write_sysreg_s(w_val, SYS_HFGWTR_EL2);
>  }
>
> -static inline void __deactivate_traps_hfgxtr(void)
> +static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
> -       u64 r_clr =3D 0, w_clr =3D 0, r_set =3D 0, w_set =3D 0, tmp;
> +       struct kvm_cpu_context *hctxt =3D &this_cpu_ptr(&kvm_host_data)->=
host_ctxt;
>
> -       if (cpus_have_final_cap(ARM64_SME)) {
> -               tmp =3D HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_E=
L0_MASK;
> +       if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +               return;
>
> -               r_set |=3D tmp;
> -               w_set |=3D tmp;
> -       }
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>
> -       if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -               w_clr |=3D HFGxTR_EL2_TCR_EL1_MASK;
>
> -       sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> -       sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
>  }
>
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> @@ -145,8 +149,7 @@ static inline void __activate_traps_common(struct kvm=
_vcpu *vcpu)
>         vcpu->arch.mdcr_el2_host =3D read_sysreg(mdcr_el2);
>         write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>
> -       if (__hfgxtr_traps_required())
> -               __activate_traps_hfgxtr();
> +       __activate_traps_hfgxtr(vcpu);
>  }
>
>  static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> @@ -162,8 +165,7 @@ static inline void __deactivate_traps_common(struct k=
vm_vcpu *vcpu)
>                 vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
>         }
>
> -       if (__hfgxtr_traps_required())
> -               __deactivate_traps_hfgxtr();
> +       __deactivate_traps_hfgxtr(vcpu);
>  }
>
>  static inline void ___activate_traps(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
