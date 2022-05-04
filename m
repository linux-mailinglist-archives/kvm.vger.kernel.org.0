Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CD9519567
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 04:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343944AbiEDCSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 22:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343833AbiEDCSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 22:18:24 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47D92A703
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 19:14:49 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id w187so209068ybe.2
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 19:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cI3EnEiByhbyzhbmPT2Do41vovNa54bp0yAEgXmkBD8=;
        b=mmI6KLpp+c3z+QrHZdFKRJi6VoSF3GbpLtggCsIulsB7AubvolFrXmPGCEXTxlZANN
         f3DhMSm2PnbBoAetcz8hC4H9bKeaHz8TGfKNNSG94OErYzJkMD2FdlSJfm7Xj0+v6vUA
         nsviC93U75RbKSwrPBpYDtKRlXaAU8h4VESOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cI3EnEiByhbyzhbmPT2Do41vovNa54bp0yAEgXmkBD8=;
        b=fM5r6uiWJcfz5TMobbMcuLXCW0FGTQMKSLXG7mUlmX7j/uPHMiqLkSv6dEcgScH01f
         8o5WAOs/GmorVF1G7gWuQw5ImW2eP2PCxvOBZubLJlZIQ306iALMj+oe/8+dCOeZmDW6
         JOs6Jm9QAFftJGM+XEuLM28OHTF5hmEKHTt+np5fIBCLFf8xMVvwwmCNJqV2RvmCbOqq
         2p5216G3RIN3TEIP0/jK0XnL5tJdDdmkIkaIgh/vtT37sB6iKZl1HEu2E0/qNM+safar
         G9VwzkPCP8pw8QOb3KsFllZRUIJzaaRk7b3DNEWmo3B/qNiaxja/ub9F9olNBYvm6hZU
         td9g==
X-Gm-Message-State: AOAM531p98O2Nl2X7Y/1G5+jFW/QBet0FQbw9iA74WcQNZqdsu9FO5WZ
        aGcHxLs2K1y0OOlLWWhkITaO2hAodGNLzgBNzeTm
X-Google-Smtp-Source: ABdhPJzutpVfXiertcAqEmQCd3u67RbEUlBKorJvKcoQ99nnjZTFxngHiLoSZ+nRRmPEImrirNk0UXweW8E5SV84HvY=
X-Received: by 2002:a25:9247:0:b0:645:ddd5:a182 with SMTP id
 e7-20020a259247000000b00645ddd5a182mr16046065ybo.289.1651630489026; Tue, 03
 May 2022 19:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com> <20220420112450.155624-4-apatel@ventanamicro.com>
In-Reply-To: <20220420112450.155624-4-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 3 May 2022 19:14:38 -0700
Message-ID: <CAOnJCU+sDbJERnrcTUiLowvpfRDJ=-YPkc2dxzbfsD+qFBMUKw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] RISC-V: KVM: Treat SBI HFENCE calls as NOPs
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> We should treat SBI HFENCE calls as NOPs until nested virtualization
> is supported by KVM RISC-V. This will help us test booting a hypervisor
> under KVM RISC-V.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_sbi_replace.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> index 0f217365c287..3c1dcd38358e 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -117,7 +117,11 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>         case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
>         case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
>         case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
> -       /* TODO: implement for nested hypervisor case */
> +               /*
> +                * Until nested virtualization is implemented, the
> +                * SBI HFENCE calls should be treated as NOPs
> +                */
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
