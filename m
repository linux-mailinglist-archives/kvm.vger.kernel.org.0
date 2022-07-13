Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26C6572CFB
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 07:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiGMFVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 01:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiGMFVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 01:21:45 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA47D5142
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 22:21:44 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id u41so3753079uau.8
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 22:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vx256KJJiy4GAxziPvpGduO7+kk9llM5mlHOsqsyTsY=;
        b=HRx/2HrUp0jYG3DuQUIN1Mh65hLM42qMkJXk6yQoJ2FV1ppeBjmZvkBdhNsHgon5/y
         5zDd5psyQd/DLRLRT4yVMCdeKt6Ib/MAATvfTOoDfmpB89oYKKHexSLI8vmFqiRcVv52
         6T4NFg3ZeIHL2vcvROwAxb1oucN/kQbd8J6r4WcGBS3TPLd2KeUzDps5eLWMNk7HpUXI
         v81tFqh0hC1Dzfsd7ykRg4bxi8lG8Pj+HD4aWvGRX7ATYhHekL9yF8/rNk1NfryIulr9
         d/LxmH0fo276V1tuK+7hAgqo8vMW3HFAtGk7UCgcC7I7i3DOBTpMbaYSymmKQeTsAkF0
         PuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vx256KJJiy4GAxziPvpGduO7+kk9llM5mlHOsqsyTsY=;
        b=jcI9ixl1AGxw0+jkg6sb7oxW3bEQvb60MGluwiV+CycVryPHOMqGC+LmzCMIK/i2jt
         fBfZuQjJ/11DXQQf8wqOK8DOgHYKNze3kN9dt/nnTy/9RDuIZfmFubol25Ahe15NPBZs
         x4BrWFrcEDYxzrscJ3v0Ul5VSBLjyptokj9+ySWo/gDvWm+NO85qFyURMvSLUtQmPpf+
         6QnbqakIHmZeVsIIg3eNGH1VltkqgulPCMt6Xyz8z7E8gBe6NXIkCkb01AxTKwaLRF3V
         V2icb4QtQCgYGhcXvIRLcTps2EQZ2VOUNUEaV3l89YdS2zZEBYcUHE4ByfckoyO+yQyv
         a4Rw==
X-Gm-Message-State: AJIora9cgEFvmj+XzbWyuH3Wf/9+P/Sio35KZNFu8OX251gxLVjdZIhN
        RI0itybKrHFNK0jjJinQ4dDCdojwR7apox1Wbd+uYA==
X-Google-Smtp-Source: AGRyM1unE/D2X0jTwXxbEl8cU3yp3vvCaXX1RmVmlplb8qoBuvYidy1oAZdyTkmEweRaEIKE0Qlu2gOs+hXptuRZ7qs=
X-Received: by 2002:a9f:2c8f:0:b0:373:7d08:106e with SMTP id
 w15-20020a9f2c8f000000b003737d08106emr441172uaj.37.1657689703040; Tue, 12 Jul
 2022 22:21:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-10-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-10-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 12 Jul 2022 22:21:25 -0700
Message-ID: <CAAeT=Fz-qGbTQ2PTG6xuS-uo_ANnuxQQt47fy_wP3sdsM10Fgw@mail.gmail.com>
Subject: Re: [PATCH 09/19] KVM: arm64: vgic-v3: Make the userspace accessors
 use sysreg API
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The vgic-v3 sysreg accessors have been ignored as the rest of the
> sysreg internal API was avolving, and are stuck with the .access

Nit: s/avolving/evolving/ ?


> method (which is normally reserved to the guest's own access)
> for the userspace accesses (which should use the .set/.get_user()
> methods).
>
> Catch up with the program and repaint all the accessors so that
> they fit into the normal userspace model, and plug the result into
> the helpers that have been introduced earlier.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic-sys-reg-v3.c | 453 ++++++++++++++++++-------------
>  1 file changed, 257 insertions(+), 196 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 8c56e285fde9..2ca172cdc5c4 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -10,254 +10,331 @@
>  #include "vgic/vgic.h"
>  #include "sys_regs.h"
>
> -static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r)
> +static int set_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 val)
>  {
>         u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
>         struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
>         struct vgic_vmcr vmcr;
> +
> +       vgic_get_vmcr(vcpu, &vmcr);
> +
> +       /*
> +        * Disallow restoring VM state if not supported by this
> +        * hardware.
> +        */
> +       host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
> +                        ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
> +       if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
> +               return -EINVAL;
> +
> +       vgic_v3_cpu->num_pri_bits = host_pri_bits;
> +
> +       host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
> +               ICC_CTLR_EL1_ID_BITS_SHIFT;
> +       if (host_id_bits > vgic_v3_cpu->num_id_bits)
> +               return -EINVAL;
> +
> +       vgic_v3_cpu->num_id_bits = host_id_bits;
> +
> +       host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
> +                     ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
> +       seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
> +               ICC_CTLR_EL1_SEIS_SHIFT;
> +       if (host_seis != seis)
> +               return -EINVAL;
> +
> +       host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
> +                    ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
> +       a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
> +       if (host_a3v != a3v)
> +               return -EINVAL;
> +
> +       /*
> +        * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
> +        * The vgic_set_vmcr() will convert to ICH_VMCR layout.
> +        */
> +       vmcr.cbpr = (val & ICC_CTLR_EL1_CBPR_MASK) >> ICC_CTLR_EL1_CBPR_SHIFT;
> +       vmcr.eoim = (val & ICC_CTLR_EL1_EOImode_MASK) >> ICC_CTLR_EL1_EOImode_SHIFT;
> +       vgic_set_vmcr(vcpu, &vmcr);
> +
> +       return 0;
> +}
> +
> +static int get_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 *valp)
> +{
> +       struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> +       struct vgic_vmcr vmcr;
>         u64 val;
>
>         vgic_get_vmcr(vcpu, &vmcr);
> -       if (p->is_write) {
> -               val = p->regval;
> -
> -               /*
> -                * Disallow restoring VM state if not supported by this
> -                * hardware.
> -                */
> -               host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
> -                                ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
> -               if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
> -                       return false;
> -
> -               vgic_v3_cpu->num_pri_bits = host_pri_bits;
> -
> -               host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
> -                               ICC_CTLR_EL1_ID_BITS_SHIFT;
> -               if (host_id_bits > vgic_v3_cpu->num_id_bits)
> -                       return false;
> -
> -               vgic_v3_cpu->num_id_bits = host_id_bits;
> -
> -               host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
> -                            ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
> -               seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
> -                       ICC_CTLR_EL1_SEIS_SHIFT;
> -               if (host_seis != seis)
> -                       return false;
> -
> -               host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
> -                           ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
> -               a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
> -               if (host_a3v != a3v)
> -                       return false;
> -
> -               /*
> -                * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
> -                * The vgic_set_vmcr() will convert to ICH_VMCR layout.
> -                */
> -               vmcr.cbpr = (val & ICC_CTLR_EL1_CBPR_MASK) >> ICC_CTLR_EL1_CBPR_SHIFT;
> -               vmcr.eoim = (val & ICC_CTLR_EL1_EOImode_MASK) >> ICC_CTLR_EL1_EOImode_SHIFT;
> -               vgic_set_vmcr(vcpu, &vmcr);
> -       } else {
> -               val = 0;
> -               val |= (vgic_v3_cpu->num_pri_bits - 1) <<
> -                       ICC_CTLR_EL1_PRI_BITS_SHIFT;
> -               val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
> -               val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> -                       ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
> -                       ICC_CTLR_EL1_SEIS_SHIFT;
> -               val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> -                       ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
> -                       ICC_CTLR_EL1_A3V_SHIFT;
> -               /*
> -                * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
> -                * Extract it directly using ICC_CTLR_EL1 reg definitions.
> -                */
> -               val |= (vmcr.cbpr << ICC_CTLR_EL1_CBPR_SHIFT) & ICC_CTLR_EL1_CBPR_MASK;
> -               val |= (vmcr.eoim << ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
> -
> -               p->regval = val;
> -       }
> +       val = 0;
> +       val |= (vgic_v3_cpu->num_pri_bits - 1) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
> +       val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
> +       val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> +                ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
> +               ICC_CTLR_EL1_SEIS_SHIFT;
> +       val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> +                ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
> +               ICC_CTLR_EL1_A3V_SHIFT;
> +       /*
> +        * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
> +        * Extract it directly using ICC_CTLR_EL1 reg definitions.
> +        */
> +       val |= (vmcr.cbpr << ICC_CTLR_EL1_CBPR_SHIFT) & ICC_CTLR_EL1_CBPR_MASK;
> +       val |= (vmcr.eoim << ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
> +
> +       *valp = val;
>
> -       return true;
> +       return 0;
>  }
>
> -static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                          const struct sys_reg_desc *r)
> +static int set_gic_pmr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                      u64 val)
>  {
>         struct vgic_vmcr vmcr;
>
>         vgic_get_vmcr(vcpu, &vmcr);
> -       if (p->is_write) {
> -               vmcr.pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
> -               vgic_set_vmcr(vcpu, &vmcr);
> -       } else {
> -               p->regval = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
> -       }
> +       vmcr.pmr = (val & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
> +       vgic_set_vmcr(vcpu, &vmcr);
>
> -       return true;
> +       return 0;
>  }
>
> -static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r)
> +static int get_gic_pmr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                      u64 *val)
>  {
>         struct vgic_vmcr vmcr;
>
>         vgic_get_vmcr(vcpu, &vmcr);
> -       if (p->is_write) {
> -               vmcr.bpr = (p->regval & ICC_BPR0_EL1_MASK) >>
> -                           ICC_BPR0_EL1_SHIFT;
> -               vgic_set_vmcr(vcpu, &vmcr);
> -       } else {
> -               p->regval = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) &
> -                            ICC_BPR0_EL1_MASK;
> -       }
> +       *val = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
>
> -       return true;
> +       return 0;
>  }
>
> -static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r)
> +static int set_gic_bpr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 val)
>  {
>         struct vgic_vmcr vmcr;
>
> -       if (!p->is_write)
> -               p->regval = 0;
> +       vgic_get_vmcr(vcpu, &vmcr);
> +       vmcr.bpr = (val & ICC_BPR0_EL1_MASK) >> ICC_BPR0_EL1_SHIFT;
> +       vgic_set_vmcr(vcpu, &vmcr);
> +
> +       return 0;
> +}
> +
> +static int get_gic_bpr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 *val)
> +{
> +       struct vgic_vmcr vmcr;
>
>         vgic_get_vmcr(vcpu, &vmcr);
> -       if (!vmcr.cbpr) {
> -               if (p->is_write) {
> -                       vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
> -                                    ICC_BPR1_EL1_SHIFT;
> -                       vgic_set_vmcr(vcpu, &vmcr);
> -               } else {
> -                       p->regval = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
> -                                    ICC_BPR1_EL1_MASK;
> -               }
> -       } else {
> -               if (!p->is_write)
> -                       p->regval = min((vmcr.bpr + 1), 7U);
> -       }
> +       *val = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) & ICC_BPR0_EL1_MASK;
>
> -       return true;
> +       return 0;
>  }
>
> -static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                             const struct sys_reg_desc *r)
> +static int set_gic_bpr1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 val)
>  {
>         struct vgic_vmcr vmcr;
>
>         vgic_get_vmcr(vcpu, &vmcr);
> -       if (p->is_write) {
> -               vmcr.grpen0 = (p->regval & ICC_IGRPEN0_EL1_MASK) >>
> -                              ICC_IGRPEN0_EL1_SHIFT;
> +       if (!vmcr.cbpr) {
> +               vmcr.abpr = (val & ICC_BPR1_EL1_MASK) >> ICC_BPR1_EL1_SHIFT;
>                 vgic_set_vmcr(vcpu, &vmcr);
> -       } else {
> -               p->regval = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) &
> -                            ICC_IGRPEN0_EL1_MASK;
>         }
>
> -       return true;
> +       return 0;
>  }
>
> -static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                             const struct sys_reg_desc *r)
> +static int get_gic_bpr1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 *val)
>  {
>         struct vgic_vmcr vmcr;
>
>         vgic_get_vmcr(vcpu, &vmcr);
> -       if (p->is_write) {
> -               vmcr.grpen1 = (p->regval & ICC_IGRPEN1_EL1_MASK) >>
> -                              ICC_IGRPEN1_EL1_SHIFT;
> -               vgic_set_vmcr(vcpu, &vmcr);
> -       } else {
> -               p->regval = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
> -                            ICC_IGRPEN1_EL1_MASK;
> -       }
> +       if (!vmcr.cbpr)
> +               *val = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) & ICC_BPR1_EL1_MASK;
> +       else
> +               *val = min((vmcr.bpr + 1), 7U);
> +
> +
> +       return 0;
> +}
> +
> +static int set_gic_grpen0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                         u64 val)
> +{
> +       struct vgic_vmcr vmcr;
> +
> +       vgic_get_vmcr(vcpu, &vmcr);
> +       vmcr.grpen0 = (val & ICC_IGRPEN0_EL1_MASK) >> ICC_IGRPEN0_EL1_SHIFT;
> +       vgic_set_vmcr(vcpu, &vmcr);
> +
> +       return 0;
> +}
> +
> +static int get_gic_grpen0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                         u64 *val)
> +{
> +       struct vgic_vmcr vmcr;
> +
> +       vgic_get_vmcr(vcpu, &vmcr);
> +       *val = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) & ICC_IGRPEN0_EL1_MASK;
>
> -       return true;
> +       return 0;
>  }
>
> -static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
> -                                  struct sys_reg_params *p, u8 apr, u8 idx)
> +static int set_gic_grpen1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                         u64 val)
> +{
> +       struct vgic_vmcr vmcr;
> +
> +       vgic_get_vmcr(vcpu, &vmcr);
> +       vmcr.grpen1 = (val & ICC_IGRPEN1_EL1_MASK) >> ICC_IGRPEN1_EL1_SHIFT;
> +       vgic_set_vmcr(vcpu, &vmcr);
> +
> +       return 0;
> +}
> +
> +static int get_gic_grpen1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                         u64 *val)
> +{
> +       struct vgic_vmcr vmcr;
> +
> +       vgic_get_vmcr(vcpu, &vmcr);
> +       *val = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) & ICC_IGRPEN1_EL1_MASK;
> +
> +       return 0;
> +}
> +
> +static void set_apr_reg(struct kvm_vcpu *vcpu, u64 val, u8 apr, u8 idx)
>  {
>         struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> -       uint32_t *ap_reg;
>
>         if (apr)
> -               ap_reg = &vgicv3->vgic_ap1r[idx];
> +               vgicv3->vgic_ap1r[idx] = val;
>         else
> -               ap_reg = &vgicv3->vgic_ap0r[idx];
> +               vgicv3->vgic_ap0r[idx] = val;
> +}
> +
> +static u64 get_apr_reg(struct kvm_vcpu *vcpu, u8 apr, u8 idx)
> +{
> +       struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>
> -       if (p->is_write)
> -               *ap_reg = p->regval;
> +       if (apr)
> +               return vgicv3->vgic_ap1r[idx];
>         else
> -               p->regval = *ap_reg;
> +               return vgicv3->vgic_ap0r[idx];
> +}
> +
> +static int set_gic_ap0r(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 val)
> +
> +{
> +       u8 idx = r->Op2 & 3;
> +
> +       if (idx > vgic_v3_max_apr_idx(vcpu))
> +               return -EINVAL;
> +
> +       set_apr_reg(vcpu, val, 0, idx);
> +       return 0;
>  }
>
> -static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r, u8 apr)
> +static int get_gic_ap0r(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 *val)
>  {
>         u8 idx = r->Op2 & 3;
>
>         if (idx > vgic_v3_max_apr_idx(vcpu))
> -               goto err;
> +               return -EINVAL;
>
> -       vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> -       return true;
> -err:
> -       if (!p->is_write)
> -               p->regval = 0;
> +       *val = get_apr_reg(vcpu, 0, idx);
>
> -       return false;
> +       return 0;
>  }
>
> -static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r)
> +static int set_gic_ap1r(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 val)
> +
> +{
> +       u8 idx = r->Op2 & 3;
> +
> +       if (idx > vgic_v3_max_apr_idx(vcpu))
> +               return -EINVAL;
> +
> +       set_apr_reg(vcpu, val, 1, idx);
> +       return 0;
> +}
>
> +static int get_gic_ap1r(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                       u64 *val)
>  {
> -       return access_gic_aprn(vcpu, p, r, 0);
> +       u8 idx = r->Op2 & 3;
> +
> +       if (idx > vgic_v3_max_apr_idx(vcpu))
> +               return -EINVAL;
> +
> +       *val = get_apr_reg(vcpu, 1, idx);
> +
> +       return 0;
>  }
>
> -static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                           const struct sys_reg_desc *r)
> +static int set_gic_sre(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                      u64 val)
>  {
> -       return access_gic_aprn(vcpu, p, r, 1);
> +       /* Validate SRE bit */
> +       if (!(val & ICC_SRE_EL1_SRE))
> +               return -EINVAL;
> +
> +       return 0;
>  }
>
> -static bool access_gic_sre(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -                          const struct sys_reg_desc *r)
> +static int get_gic_sre(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +                      u64 *val)
>  {
>         struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
>
>         /* Validate SRE bit */

I don't think this comment is needed here because this
function doesn't validate the bit (I believe the comment
was just for the write case).

Otherwise,

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji
