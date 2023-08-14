Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E2677BECE
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjHNRTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjHNRTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:19:12 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F066E6A
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:19:11 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b9bf52cd08so67216761fa.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692033550; x=1692638350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkOCc1UnVqEdtYIvDZQGF3UZeTk4v9/essnibGCTT3k=;
        b=ye7/GP/1AAUJE6h+ADrqtIXItl89N9ZQO6L69KSwjAc+A0GK+VWbzfX7DuC8w82pX0
         7sYzN5soH7ESFuJMRbpBd+2c20o/2JBuec1OSMBn76f+vxpK9iU04CFNuQuXlkACYSx7
         7yZoVeYymbxUMfMBr+B9mHXNBuad61ur+sbO5gd3vOLnCrJegk1Vc8796u6CEXUGv0/o
         lYRZo3ZEqCbGukPcfh1fULGwISZsXbyxfjFIqeSzZ6Ex7qVzcy70xaqdZyoTJbF98nM2
         ITbUnVvqKvbPW8oKhzVncD5dQhr/fddvYh+gl4sa0GcXYmadwyPEusmFema4KJWhH2hm
         ERHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692033550; x=1692638350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VkOCc1UnVqEdtYIvDZQGF3UZeTk4v9/essnibGCTT3k=;
        b=FaM2wggmt+XUZW1HGQiYLAjx/PzQCabqmk7Ln7vGhaMZFVqPVJjACs3xQaTyPHq+X/
         FGi57zvzUqTTq3HSZMLqjMH9LAUn/xe3WHg43+A2j0EaBBao+drG+Z5sh3dWByFu+Xnh
         Thz0RRz3AQeSByZPcsrUwaw6aKyfGK/1fZix9mpjXknQ5cB7xZhD01Qwp8ZQRX7p4VuH
         VQw5tap7zmm886p3vtSk6NkAkSA/DyrWFKkraKfk53ITuTKVkBOJAUiikojTlDCkl0KU
         z8kGvFYaMINDnAfxivAJ2Ds7nQeDNjVQo3R/KVBsVc92ZxxJ4v+1ckLbXexqxvum36yw
         LX7g==
X-Gm-Message-State: AOJu0YyMMzW9l808yARtVMyKxJyIFwYG6OzUs8E6gbcGtyStWdbWSUH/
        fww1loCqDc4SE1Wypm0rdcQDaRP0jXVK6vPQl813GQ==
X-Google-Smtp-Source: AGHT+IHMBlcXyCB0LLH7DNuuz96NEnTLRmp9fpUbSgLkji1mDQhaGBice4ewAvqhzRVYlrpUQbK8QFPcRdBsTqYYb5w=
X-Received: by 2002:a2e:860e:0:b0:2b6:e12f:267 with SMTP id
 a14-20020a2e860e000000b002b6e12f0267mr7212014lji.5.1692033549538; Mon, 14 Aug
 2023 10:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-20-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-20-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 14 Aug 2023 10:18:57 -0700
Message-ID: <CAAdAUtiaewy_xAnS2gm-6YhOq=ednvj0_VO=Ld4+UY+9E5BF8w@mail.gmail.com>
Subject: Re: [PATCH v3 19/27] KVM: arm64: nv: Add fine grained trap forwarding infrastructure
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
> Fine Grained Traps are fun. Not.
>
> Implement the fine grained trap forwarding, reusing the Coarse Grained
> Traps infrastructure previously implemented.
>
> Each sysreg/instruction inserted in the xarray gets a FGT group
> (vaguely equivalent to a register number), a bit number in that register,
> and a polarity.
>
> It is then pretty easy to check the FGT state at handling time, just
> like we do for the coarse version (it is just faster).
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 78 ++++++++++++++++++++++++++++++++-
>  1 file changed, 77 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index cd0544c3577e..af75c2775638 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -928,6 +928,27 @@ static const struct encoding_to_trap_config encoding=
_to_cgt[] __initconst =3D {
>
>  static DEFINE_XARRAY(sr_forward_xa);
>
> +enum fgt_group_id {
> +       __NO_FGT_GROUP__,
> +
> +       /* Must be last */
> +       __NR_FGT_GROUP_IDS__
> +};
> +
> +#define SR_FGT(sr, g, b, p)                                    \
> +       {                                                       \
> +               .encoding       =3D sr,                           \
> +               .end            =3D sr,                           \
> +               .tc             =3D {                             \
> +                       .fgt =3D g ## _GROUP,                     \
> +                       .bit =3D g ## _EL2_ ## b ## _SHIFT,       \
> +                       .pol =3D p,                               \
> +               },                                              \
> +       }
> +
> +static const struct encoding_to_trap_config encoding_to_fgt[] __initcons=
t =3D {
> +};
> +
>  static union trap_config get_trap_config(u32 sysreg)
>  {
>         return (union trap_config) {
> @@ -941,6 +962,7 @@ int __init populate_nv_trap_config(void)
>
>         BUILD_BUG_ON(sizeof(union trap_config) !=3D sizeof(void *));
>         BUILD_BUG_ON(__NR_TRAP_GROUP_IDS__ > BIT(TC_CGT_BITS));
> +       BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
>
>         for (int i =3D 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
>                 const struct encoding_to_trap_config *cgt =3D &encoding_t=
o_cgt[i];
> @@ -963,6 +985,34 @@ int __init populate_nv_trap_config(void)
>         kvm_info("nv: %ld coarse grained trap handlers\n",
>                  ARRAY_SIZE(encoding_to_cgt));
>
> +       if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +               goto check_mcb;
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
> +               const struct encoding_to_trap_config *fgt =3D &encoding_t=
o_fgt[i];
> +               union trap_config tc;
> +
> +               tc =3D get_trap_config(fgt->encoding);
> +
> +               if (tc.fgt) {
> +                       kvm_err("Duplicate FGT for (%d, %d, %d, %d, %d)\n=
",
> +                               sys_reg_Op0(fgt->encoding),
> +                               sys_reg_Op1(fgt->encoding),
> +                               sys_reg_CRn(fgt->encoding),
> +                               sys_reg_CRm(fgt->encoding),
> +                               sys_reg_Op2(fgt->encoding));
> +                       ret =3D -EINVAL;
> +               }
> +
> +               tc.val |=3D fgt->tc.val;
> +               xa_store(&sr_forward_xa, fgt->encoding,
> +                        xa_mk_value(tc.val), GFP_KERNEL);
> +       }
> +
> +       kvm_info("nv: %ld fine grained trap handlers\n",
> +                ARRAY_SIZE(encoding_to_fgt));
> +
> +check_mcb:
>         for (int id =3D __MULTIPLE_CONTROL_BITS__;
>              id < (__COMPLEX_CONDITIONS__ - 1);
>              id++) {
> @@ -1031,13 +1081,26 @@ static enum trap_behaviour compute_trap_behaviour=
(struct kvm_vcpu *vcpu,
>         return __do_compute_trap_behaviour(vcpu, tc.cgt, b);
>  }
>
> +static bool check_fgt_bit(u64 val, const union trap_config tc)
> +{
> +       return ((val >> tc.bit) & 1) =3D=3D tc.pol;
> +}
> +
> +#define sanitised_sys_reg(vcpu, reg)                   \
> +       ({                                              \
> +               u64 __val;                              \
> +               __val =3D __vcpu_sys_reg(vcpu, reg);      \
> +               __val &=3D ~__ ## reg ## _RES0;           \
> +               (__val);                                \
> +       })
> +
>  bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  {
>         union trap_config tc;
>         enum trap_behaviour b;
>         bool is_read;
>         u32 sysreg;
> -       u64 esr;
> +       u64 esr, val;
>
>         if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
>                 return false;
> @@ -1060,6 +1123,19 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>         if (!tc.val)
>                 return false;
>
> +       switch ((enum fgt_group_id)tc.fgt) {
> +       case __NO_FGT_GROUP__:
> +               break;
> +
> +       case __NR_FGT_GROUP_IDS__:
> +               /* Something is really wrong, bail out */
> +               WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
> +               return false;

Do we need a default clause here to catch unexpected tc.fgt values?

> +       }
> +
> +       if (tc.fgt !=3D __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
> +               goto inject;
> +
>         b =3D compute_trap_behaviour(vcpu, tc);
>
>         if (((b & BEHAVE_FORWARD_READ) && is_read) ||
> --
> 2.34.1
>
>

Thanks,
Jing
