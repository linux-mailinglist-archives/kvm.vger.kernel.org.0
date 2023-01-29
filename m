Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBE967FEF1
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 13:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbjA2Mh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 07:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbjA2MhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 07:37:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B852201C
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:37:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id u21so8551169edv.3
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sNkvgNjalEbUIW9jrQqtpgRzQ5YzLgOG7GublAOFwsM=;
        b=o2c8vo5zXmMwTV06YADgWiDYGz0h9vEml5wucGFEaQCV7ii0Wu2c83Xvyl5mXncu6b
         MRnGVYOP+C4qkuonWw8bv732H/UoF3FEHfO6Qwmwk+YwtxzDO3YtlD73Z279ldNmfFpB
         7UppRVY+/fT87JbLI+4tNNfMOJERptPy92gnlha6RolZVWL6agnwz5tN95d3iMqlKcfz
         5h36uRFFyV23MY/gPR9nXJj++fPG/CaIcgp78WJomtr14Q8RTFEFm0jwYeYDu5//e6j1
         jzejPLi19rK29iYDIXA/cnbNAUYdIsYpgFIR118O2ALbv9V/hW+gUFGX7cB0n4SCEm/g
         EdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sNkvgNjalEbUIW9jrQqtpgRzQ5YzLgOG7GublAOFwsM=;
        b=vP/6oXntC7auy1BzdhOBOBDey01WjBdKtA8XGA9s/VCoWbmIQ/17RbeJC7bBK3b3tX
         atMzk0lKBnyUWr3i+IX/VhlnanEHyfYWTQKa3sR+DfIskjuQMrX9q8b+FJQ7kPoGjaUX
         4Z3EKX9AMpFNM/HVpzGxkepyLMi5nXwIskSawDiJ1ZCD8stxPT6HAQ+In7vmf66I+wu2
         LnpZb3gb7y55laMJL1t2pfhQ0eiYOYq+XFLFUGV3E2miycpiCkzJu1nZKr+hRmhpLMBi
         KT7rXDZzA6JXaQRPsYW8vxMEwfENKePxS8vJ3PHGrHPT8RDT3jejTbLoMlJQA0begNQw
         LR3g==
X-Gm-Message-State: AFqh2kow14wYdUPa4hhQCA9vs+cCOSnBKX6wOp6EiXb9nW4KhpgQMmBE
        NIuYz5UYCfl95LfYDkc0on/90r1ZSF1EV+Ucm4NAHw==
X-Google-Smtp-Source: AMrXdXtzn6th6VcLei3QJ9jR5iiYz4v5EBRiUR59/fz3Bm6vT7Cz3sy14GjFMJfzfqcdsE4ZUwX5taSDXwtMUnQAEyA=
X-Received: by 2002:aa7:de99:0:b0:499:376e:6b34 with SMTP id
 j25-20020aa7de99000000b00499376e6b34mr7737774edv.10.1674995843169; Sun, 29
 Jan 2023 04:37:23 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-11-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-11-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 29 Jan 2023 18:07:12 +0530
Message-ID: <CAAhSdy0HG_0DZVLDF3Rvbofx-4P_2z7Tp+hGJ7VwgTH-u6uLGA@mail.gmail.com>
Subject: Re: [PATCH v3 10/14] RISC-V: KVM: Disable all hpmcounter access for
 VS/VU mode
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> Any guest must not get access to any hpmcounter including cycle/instret
> without any checks. We achieve that by disabling all the bits except TM
> bit in hcounteren.
>
> However, instret and cycle access for guest user space can be enabled
> upon explicit request (via ONE REG) or on first trap from VU mode
> to maintain ABI requirement in the future. This patch doesn't support
> that as ONE REG interface is not settled yet.
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 58c5489..c5d400f 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -49,7 +49,8 @@ int kvm_arch_hardware_enable(void)
>         hideleg |= (1UL << IRQ_VS_EXT);
>         csr_write(CSR_HIDELEG, hideleg);
>
> -       csr_write(CSR_HCOUNTEREN, -1UL);
> +       /* VS should access only the time counter directly. Everything else should trap */
> +       csr_write(CSR_HCOUNTEREN, 0x02);
>
>         csr_write(CSR_HVIP, 0);
>
> --
> 2.25.1
>
