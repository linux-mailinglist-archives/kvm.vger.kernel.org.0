Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F388368274A
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 09:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjAaIq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 03:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjAaIqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 03:46:15 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F174B755
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 00:42:18 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u5so9385526pfm.10
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 00:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QCf7Gk9CER9TWykUKPKE3uoStZNM4xMJ4HlA3aUUy/0=;
        b=PIGIv+QT6Tcw0pdKxDeDj70Nap7gwxtMtZ1HaWM625UXPMA5Hpbk7Z9His8VZC+5Gz
         QG8u3EG3stDN8xxsQ2nF1PfP85vwpSwLs3AqkxTC8BaWWRBPTmIbAFKZl6Hg4jgvFs5i
         mS1zfordJBrRShBB4GrTCJeolXPC3njm4kg0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QCf7Gk9CER9TWykUKPKE3uoStZNM4xMJ4HlA3aUUy/0=;
        b=s6f42n5CTM8Q7m7DIJDf+Z4HrJgvjuHywGxkDow28ILog1uS/2/KwqPd8Ep7ThblxJ
         KtQUvcnLtaKItAGLLogG6Rupuy2bjd0a7Mq4QUlP0Jgc7u2t96v4OgYckdOGWn58CF4Q
         4vIKdYDPUiy7fCDJWRoeGVhcnwhQq7W8950dCsUzZCIDw8CLCYoZdifa7kBWKPhivnWJ
         cQR6Kk5YKM1DAqF2Robb0IXMraNI5FVCYr/ZCLKOlcU6qGx6vOtXxSKjWTPM+KltZHJF
         4+Fjtqrc5cVx8IaoS9Amo9yiMWyTSIxKon/tSF+KFHh7u5zA9Wtue0D0zU/2cwQ++R3v
         cWJQ==
X-Gm-Message-State: AFqh2kqMj+JvX2JOz9AwDINAUz1c0Sg+xMSDkGoxyc0zn16MjiJlVZt7
        M/qmZXOB+escXBlqMsjS1QEbyFse5/vv5ofr/MWG
X-Google-Smtp-Source: AMrXdXszFabjY+wcSz9JtpixIdGjJb0a3PP/mXva2CxGh2plpw5ZvmZWOtSfnd7Z4hwO6O/meJS7najdjrX6RAvJJs4=
X-Received: by 2002:a63:1011:0:b0:4c7:ef33:bbe1 with SMTP id
 f17-20020a631011000000b004c7ef33bbe1mr5876108pgl.73.1675154529449; Tue, 31
 Jan 2023 00:42:09 -0800 (PST)
MIME-Version: 1.0
References: <20230128082847.3055316-1-apatel@ventanamicro.com>
In-Reply-To: <20230128082847.3055316-1-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 31 Jan 2023 00:41:58 -0800
Message-ID: <CAOnJCUKQwKpEPYgTG7OQtRDsmHBPpLYLPg5v6XM7AZqsrYupRA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] RISC-V: KVM: Fix privilege mode setting in kvm_riscv_vcpu_trap_redirect()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 12:28 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The kvm_riscv_vcpu_trap_redirect() should set guest privilege mode
> to supervisor mode because guest traps/interrupts are always handled
> in virtual supervisor mode.
>
> Fixes: 9f7013265112 ("RISC-V: KVM: Handle MMIO exits for VCPU")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_exit.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index c9f741ab26f5..af7c4bc07929 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -160,6 +160,9 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>
>         /* Set Guest PC to Guest exception vector */
>         vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
> +
> +       /* Set Guest privilege mode to supervisor */
> +       vcpu->arch.guest_context.sstatus |= SR_SPP;
>  }
>
>  /*
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
