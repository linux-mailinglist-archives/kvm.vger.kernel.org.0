Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D682496BF6
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 12:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiAVLO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 06:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiAVLO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 06:14:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C26FC06173B
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 03:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F23B81B9A
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 11:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7B6C004E1
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 11:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642850061;
        bh=dikOTUKGGj4j8zqQpWcygEiwWqA8JvaotxjHs5GZn4Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GnvOoVevpUrVm1pbxdgVVKjrad6kWlVYpZeFQuppE5kd10e4n5KDooXXYb4fTJtaz
         AtQ/ZCV4Zr1JiHnN68EjcUbfkM/MTC3VinhusATeZkvuenMLN0nvQHClyvSc+774Js
         FA62oq4HxjcYB2mXK9z83BWesdci9BdjTRJyECodLIoSNSJ5+OfCtl9bAg3IrA1kzn
         2pX+PMtzw3hch56sZmY4qPAivmNi0oEM4UaHSG8UAN0kEOQT2TpI20C6738A7GpXXN
         p23k646PB/9f37iTyNFGw7H6QEm9jWT2/4x+xfpKo5vTG2enj6hORo6mTl7damaq6l
         DFDCwCrTBo9Jg==
Received: by mail-wr1-f44.google.com with SMTP id v13so4432135wrv.10
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 03:14:21 -0800 (PST)
X-Gm-Message-State: AOAM5323zmJrNLJu7qCjW5kCV1rdiRF4xb0OfDy/01SpdBIAG/YovzKO
        32Kfr+sca9/1pZ19hhgQMrBObtXglRgbSRseeW8=
X-Google-Smtp-Source: ABdhPJzyBFyif7w+EIZOfNZ/jx+IazO5AtERm3pyZnyB747+mnCUC45C6riTOAm//7XXndr2aJkcIMM+Hqk0weVDkIk=
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr7299630wrm.417.1642850060047;
 Sat, 22 Jan 2022 03:14:20 -0800 (PST)
MIME-Version: 1.0
References: <20220122103912.795026-1-maz@kernel.org>
In-Reply-To: <20220122103912.795026-1-maz@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 22 Jan 2022 12:14:08 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEmNpTGtZU=ZkOTpYpG7bdaubUx3-Zzpf-D1unjk43AYQ@mail.gmail.com>
Message-ID: <CAMj1kXEmNpTGtZU=ZkOTpYpG7bdaubUx3-Zzpf-D1unjk43AYQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Restrict SEIS workaround to known
 broken systems
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 22 Jan 2022 at 11:39, Marc Zyngier <maz@kernel.org> wrote:
>
> Contrary to what df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3
> locally generated SErrors") was asserting, there is at least one other
> system out there (Cavium ThunderX2) implementing SEIS, and not in
> an obviously broken way.
>
> So instead of imposing the M1 workaround on an innocent bystander,
> let's limit it to the two known broken Apple implementations.
>
> Fixes: df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors")
> Reported-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thanks for the fix.

Tested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>

One nit below.

> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c |  3 +++
>  arch/arm64/kvm/vgic/vgic-v3.c   | 17 +++++++++++++++--
>  2 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 20db2f281cf2..4fb419f7b8b6 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -983,6 +983,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>         val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
>         /* IDbits */
>         val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
> +       /* SEIS */
> +       if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK)
> +               val |= BIT(ICC_CTLR_EL1_SEIS_SHIFT);
>         /* A3V */
>         val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
>         /* EOImode */
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 78cf674c1230..d34a795f730c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -609,6 +609,18 @@ static int __init early_gicv4_enable(char *buf)
>  }
>  early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>
> +static struct midr_range broken_seis[] = {

Can this be const?

> +       MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
> +       MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
> +       {},
> +};
> +
> +static bool vgic_v3_broken_seis(void)
> +{
> +       return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) &&
> +               is_midr_in_range_list(read_cpuid_id(), broken_seis));
> +}
> +
>  /**
>   * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
>   * @info:      pointer to the GIC description
> @@ -676,9 +688,10 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>                 group1_trap = true;
>         }
>
> -       if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) {
> -               kvm_info("GICv3 with locally generated SEI\n");
> +       if (vgic_v3_broken_seis()) {
> +               kvm_info("GICv3 with broken locally generated SEI\n");
>
> +               kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_SEIS_MASK;
>                 group0_trap = true;
>                 group1_trap = true;
>                 if (ich_vtr_el2 & ICH_VTR_TDS_MASK)
> --
> 2.34.1
>
