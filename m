Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D802E5743FF
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 06:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiGNE6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 00:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237675AbiGNE5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 00:57:53 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE25D5F98
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 21:43:43 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id a184so487311vsa.1
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 21:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CC8ma0I/yKcFtcwzZTYPpavoOcCdTiLVctElv53aEp4=;
        b=HFVmVR3R2e4P+LA6LAajl9bQqT+fbST+HoGMue0JFUYDYN4dTQkExtSYqTSvMK+S87
         81AdH0dy7+CRfqVlIEoldw9T1Sr5K+FPn2k7LTu9Gtln/42zNGUDgbKSLv27m2uw+qNM
         ZuguIbz1UwZO/24nrswHAI1CGaFeNGSGxPAieSWSxOlHZrKC+8hHv0JPdEPCxmKSeqyJ
         /Xm2XAaaLdaFWJPR9K1mb12Z6x1yRYoINxIDDQQTvm3pKShj8o+S0WYymvZPyJa6iKDF
         FUjFaFFfMk6FHyFIDZHRloOGqUiLTDZHCuixLYcEcYV3QFI3Ts479sPi/c0ecnd/Netq
         +hLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CC8ma0I/yKcFtcwzZTYPpavoOcCdTiLVctElv53aEp4=;
        b=sBpGravDfmAipcUjbi3PdPpyBV/JRG58HVZVZte/Ha/xva1j8VFFOJVKm26wEZ5vtQ
         IcpIUlNuyUsRxkAftoP5hG5SORPnx2uNFzeUSGeVlsQFabzfic1utowZi0wjN0nBVfqG
         3RZ3481JxZvXsb21tR8G34+qk9QtkPtIE+J0dTwPouJNQzVG2slDmetFaCGtp8hNpFKD
         vBNCWAX7KtkyY2T7qY46ftf89lbq0Vo4BobRAD/ixmtO2Y7BcBY9GebicCoeMOehUrwY
         4VqfnZzQvfeu5q2er2Wy9GmtIJ+ttj5z5VyVD1geTR7ZBNQeC/cmHi3RFCvmZ7ccZzeB
         cguA==
X-Gm-Message-State: AJIora/j2rurOX9nEdhqsD3Z1WfJCGHhDR1qO8VZE3nw+2CLhNpItHF3
        arDXo82F4X4X+HPHn70YJkz9ULEb92gpgARtBC4BoQ==
X-Google-Smtp-Source: AGRyM1smHGyMSsB3BIrtUB2s8kgDZPXptz9yEcssqJGDWdArFXCBnoEDdctdhEDhI/rFnpAU6PZnpL7t6CUQZSQ9muM=
X-Received: by 2002:a67:f5c9:0:b0:357:515d:a6ea with SMTP id
 t9-20020a67f5c9000000b00357515da6eamr2769699vso.51.1657773823034; Wed, 13 Jul
 2022 21:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-14-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-14-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 13 Jul 2022 21:43:27 -0700
Message-ID: <CAAeT=Fx9CbiJStMJcQ=-iwoLhAQGcwPbW==b0yHxkd3hmcXjiQ@mail.gmail.com>
Subject: Re: [PATCH 13/19] KVM: arm64: vgic-v2: Consolidate userspace access
 for MMIO registers
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Align the GICv2 MMIO accesses from userspace with the way the GICv3
> code is now structured.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 40 ++++++++++++---------------
>  1 file changed, 18 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 925875722027..ddead333c232 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -348,17 +348,18 @@ bool lock_all_vcpus(struct kvm *kvm)
>   *
>   * @dev:      kvm device handle
>   * @attr:     kvm device attribute
> - * @reg:      address the value is read or written
>   * @is_write: true if userspace is writing a register
>   */
>  static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>                                     struct kvm_device_attr *attr,
> -                                   u32 *reg, bool is_write)
> +                                   bool is_write)
>  {
> +       u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
>         struct vgic_reg_attr reg_attr;
>         gpa_t addr;
>         struct kvm_vcpu *vcpu;
>         int ret;
> +       u32 val;
>
>         ret = vgic_v2_parse_attr(dev, attr, &reg_attr);
>         if (ret)
> @@ -367,6 +368,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>         vcpu = reg_attr.vcpu;
>         addr = reg_attr.addr;
>
> +       if (is_write)
> +               if (get_user(val, uaddr))
> +                       return -EFAULT;
> +
>         mutex_lock(&dev->kvm->lock);
>
>         ret = vgic_init(dev->kvm);
> @@ -380,10 +385,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>
>         switch (attr->group) {
>         case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> -               ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
> +               ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &val);
>                 break;
>         case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -               ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
> +               ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &val);
>                 break;
>         default:
>                 ret = -EINVAL;
> @@ -393,6 +398,11 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>         unlock_all_vcpus(dev->kvm);
>  out:
>         mutex_unlock(&dev->kvm->lock);
> +
> +       if (!ret && !is_write)
> +               if (put_user(val, uaddr))
> +                       ret = -EFAULT;
> +
>         return ret;
>  }
>
> @@ -407,15 +417,8 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
>
>         switch (attr->group) {
>         case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
> -               u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> -               u32 reg;
> -
> -               if (get_user(reg, uaddr))
> -                       return -EFAULT;
> -
> -               return vgic_v2_attr_regs_access(dev, attr, &reg, true);
> -       }
> +       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> +               return vgic_v2_attr_regs_access(dev, attr, true);
>         }
>
>         return -ENXIO;
> @@ -432,15 +435,8 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
>
>         switch (attr->group) {
>         case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
> -               u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> -               u32 reg = 0;
> -
> -               ret = vgic_v2_attr_regs_access(dev, attr, &reg, false);
> -               if (ret)
> -                       return ret;
> -               return put_user(reg, uaddr);
> -       }
> +       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> +               return vgic_v2_attr_regs_access(dev, attr, false);
>         }
>
>         return -ENXIO;

For vgic_v2_{set,get}_attr(), perhaps it might be even simpler
to call vgic_{set,get}_common_attr() from the "default" case
of "switch (attr->group)".
This is not directly related to this patch though:)

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji
