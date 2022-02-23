Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA13B4C0A51
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 04:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbiBWDho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 22:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiBWDhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 22:37:43 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0B613EBC
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 19:37:15 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2d68d519a33so195720197b3.7
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 19:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/iZxI5gJtmmVE2EU9ERKSSqKXLjBqX4XWhFsi12fm4=;
        b=iMqGMltcaywF4JIrOBiSfBrO1ZiTpm42kZ8q96IXPD5P8wyMFaebGsFazuGUrLW8/M
         saOIHcsTHJlWkpFpUC6TbGA3KpXDYMQZm0eKYNi8Cmc0lEjYhTvC4/QLjpIVxgiIgYFH
         6d5BR6Wkf9oa82BMhVEKs8uf98U5ebixJldT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/iZxI5gJtmmVE2EU9ERKSSqKXLjBqX4XWhFsi12fm4=;
        b=XYkFu6F5AN2olGRbY8DEHdUllMn4ROOpp7wLeJEk/wZZbCzUaW2eZmd1QBTRr7aAq3
         ehjwp56EY2BhDfsYeMkGFrLJvOTvUP/bRXQyq+tH9kl6OLG4VzrjfpIkKwjiJ2ngCL7F
         fDjo1S5iD/KxvDPkZyRdnEtj5LVRTNaNwYeKj1EXQXXKZMsON2R9empGM37M2qEpkhoM
         //X5lDul3R8JpsUG91t8o5ejCy73j2Z5sqCntiO69YIj/lHIf5A8+4N3iVoCmY+1sXDY
         pIuvyff3sSkDhcrHu/MRZgxOw4o92+V9yQ7aRdBWa6/zgDD1zcOoT13k2ImeaIPDGNCS
         86gg==
X-Gm-Message-State: AOAM533x5N+2p0WhNYNSX6AsROTvKoAjrSVsjAnufu9vwYYD0YZpQyCz
        2ekULC5lL+6csvqi8cBZsxdtAboUTPArlxyUewtb
X-Google-Smtp-Source: ABdhPJwqkv4mz6cACdKoD4/liTLQr04AC/Mb4V7+BAD2dA4iqOmCk161chEgGlKc//pVQVvyiNh6L9G7xcUCR8QN460=
X-Received: by 2002:a81:844c:0:b0:2d6:920b:f959 with SMTP id
 u73-20020a81844c000000b002d6920bf959mr26893176ywf.443.1645587434737; Tue, 22
 Feb 2022 19:37:14 -0800 (PST)
MIME-Version: 1.0
References: <20220201082227.361967-1-apatel@ventanamicro.com> <20220201082227.361967-7-apatel@ventanamicro.com>
In-Reply-To: <20220201082227.361967-7-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 22 Feb 2022 19:37:04 -0800
Message-ID: <CAOnJCUJ_13oZqLhmcwO4tx+OsnL1YdR-y_FyNAmd=_+9rGAFLw@mail.gmail.com>
Subject: Re: [PATCH 6/6] RISC-V: KVM: Implement SBI HSM suspend call
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 1, 2022 at 12:24 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The SBI v0.3 specification extends SBI HSM extension by adding SBI HSM
> suspend call and related HART states. This patch extends the KVM RISC-V
> HSM implementation to provide KVM guest a minimal SBI HSM suspend call
> which is equivalent to a WFI instruction.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_sbi_hsm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> index 1ac4b2e8e4ec..239dec0a628a 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -61,6 +61,8 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
>                 return -EINVAL;
>         if (!target_vcpu->arch.power_off)
>                 return SBI_HSM_STATE_STARTED;
> +       else if (vcpu->stat.generic.blocking)
> +               return SBI_HSM_STATE_SUSPENDED;
>         else
>                 return SBI_HSM_STATE_STOPPED;
>  }
> @@ -91,6 +93,18 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                         ret = 0;
>                 }
>                 break;
> +       case SBI_EXT_HSM_HART_SUSPEND:
> +               switch (cp->a0) {
> +               case SBI_HSM_SUSPEND_RET_DEFAULT:
> +                       kvm_riscv_vcpu_wfi(vcpu);
> +                       break;
> +               case SBI_HSM_SUSPEND_NON_RET_DEFAULT:
> +                       ret = -EOPNOTSUPP;
> +                       break;
> +               default:
> +                       ret = -EINVAL;
> +               }
> +               break;
>         default:
>                 ret = -EOPNOTSUPP;
>         }
> --
> 2.25.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
