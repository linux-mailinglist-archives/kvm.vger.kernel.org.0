Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0B256D3B0
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 06:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiGKEQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 00:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGKEQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 00:16:37 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D95018E11
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 21:16:36 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id o12so2214393ljc.3
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 21:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yokId+kL1XsUAJzXfOxjC7q00UnhVLg0heLq8/CzKNw=;
        b=ZY8Gy+sHLWu8VAYvzEiXRTHT9tuRT7ejaosM1Xw4V3DhLlBw2Af9kiToQwGhgSSWL6
         KuXNkb0i3epNJ4ykkbpocsM2Tan54xsOLECsVy2OIHB0MDmQHKuyDj4aNVG50X/8xmKQ
         4000H37gmgWprf0OeYatZ3qFHZy2hCNnwnbgrE3CgKaSoVtEfndEHG8fCC89B+ZYZ6a+
         n+7N82T0k1KIxO5Jf2nqYhS60Dvv08dfX1qs5sGDQU/HCLb48UqkPYxTkhG2IYioaaBf
         R04SIhoyxkSEoa+ocCn+6DXlkhYEpailJNgOLnS+Vi9bm+K4Bxz9aN8chbL6rkgeH9zz
         mV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yokId+kL1XsUAJzXfOxjC7q00UnhVLg0heLq8/CzKNw=;
        b=KaNu61+7f8FMlseQr10OCZxgRQoDyOoD/M67dJWXTbhRj7HycYEGj5fzObeRxcdPb4
         kLMDXvItLF478wXyksPfH0/2IjIA33Itzrk4WBUnyKrd2wpApUxajkADyNLa8NadPsFX
         x94Rpej90AOr2cw9bJMbI2lasbkPrfwNtYX119CDkutcSMmVfHT8U5ilRxwvSE4w5Xyw
         gsbKrB6M1VW0PdpQ3Elw3jq+QFfTVla2cBupvitEix229j6dHozV0NpxCNJQ461GZQmh
         2CrgAA5KdW+mouKHaU6cyqvv+ZofsPAhqaCMMbSh0hOHv7kr+saO46B9isxGT7FctYha
         Di6g==
X-Gm-Message-State: AJIora+Fos3QwdXSTEMtgDK1iF1miJgDK0ti+AGV9TzrDhV/xU0KPxLU
        PBA0QnIPkVcaZomyYKbxP1GxFy/c66oL0MMUZFaCgQ==
X-Google-Smtp-Source: AGRyM1uUtWel5vfmZuYAD/gK8/SRSmF+9d0yqlY3PAatmC3KkMAUQM6LA2GseceFzLwP7ShlE/BzxDKqkbySrYf7Apw=
X-Received: by 2002:a2e:9dd3:0:b0:25d:4ee0:f55d with SMTP id
 x19-20020a2e9dd3000000b0025d4ee0f55dmr8524188ljj.266.1657512994653; Sun, 10
 Jul 2022 21:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220710151105.687193-1-apatel@ventanamicro.com>
In-Reply-To: <20220710151105.687193-1-apatel@ventanamicro.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 11 Jul 2022 09:46:19 +0530
Message-ID: <CAK9=C2UjJ8eqXSBzsbpdUn9E=5_6Zp2NAnHts_FaGpxWxN-Krw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bmeng.cn@gmail.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
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

On Sun, Jul 10, 2022 at 8:41 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The kvm_riscv_check_vcpu_requests() is called with SRCU read lock held
> and for KVM_REQ_SLEEP request it will block the VCPU without releasing
> SRCU read lock. This causes KVM ioctls (such as KVM_IOEVENTFD) from
> other VCPUs of the same Guest/VM to hang/deadlock if there is any
> synchronize_srcu() or synchronize_srcu_expedited() in the path.
>
> To fix the above in kvm_riscv_check_vcpu_requests(), we should do SRCU
> read unlock before blocking the VCPU and do SRCU read lock after VCPU
> wakeup.
>
> Fixes: cce69aff689e ("RISC-V: KVM: Implement VCPU interrupts and
> requests handling")
> Reported-by: Bin Meng <bmeng.cn@gmail.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Thanks everyone for providing Tested-by and Reviewed-by.

I have queued this patch for 5.19-rcX fixes.

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b7a433c54d0f..5d271b597613 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -845,9 +845,11 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>
>         if (kvm_request_pending(vcpu)) {
>                 if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
> +                       kvm_vcpu_srcu_read_unlock(vcpu);
>                         rcuwait_wait_event(wait,
>                                 (!vcpu->arch.power_off) && (!vcpu->arch.pause),
>                                 TASK_INTERRUPTIBLE);
> +                       kvm_vcpu_srcu_read_lock(vcpu);
>
>                         if (vcpu->arch.power_off || vcpu->arch.pause) {
>                                 /*
> --
> 2.34.1
>
