Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040517235CF
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 05:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbjFFDgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 23:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjFFDgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 23:36:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EB712D
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 20:36:06 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51494659d49so8359008a12.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 20:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1686022564; x=1688614564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUqX+2D4UADNAnE5VNi8IzDCC2+p85PEOTxe1Lq/hFU=;
        b=KeCTaUaqyvYUgcGh9Zm0Hm3vuyjwteBFSzc8aIBwTCTdoQSK04Ly+jmYankF2BOZot
         Qb0gPYFa8cQIxLpFAefSHAW1sLi0hW6LLWjBnjLMXm7kDVFNb/MA8BZ9Gl+sTuWis6+O
         Satqe7rRHKU7cAP1EFJdrJVkRk5yZgPUAcJ7kHZZAqCJa2tznpdlq696xo8tMKyI0iby
         pQpYEeW3AvjOjizZ3GKQAPzj4OQl1EvqNOtfwb6efQ+K0EsIfj/DVhzqgnR/SIiybjt9
         CMjWoxfizEYsNGxQy4mv3gJmnUezliQLHcpPPhtzPl/BVpXvP6pG9H/LCyw9xs8AA6Zq
         cczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686022564; x=1688614564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUqX+2D4UADNAnE5VNi8IzDCC2+p85PEOTxe1Lq/hFU=;
        b=atiiOOK6r2iHy6px7nirlzGp2AA5TIh/H+CI2RPPKC2lqYknaGdqBfhg3vdY0lgJuO
         7ywPTM9oSr+rrygQj134nJGrqEM3sfi1FGFjqgBzoW6uq2Qk43qOFy14Yr/YCM1O5iYL
         SCqGzWhfdLx+/Zy3wMrgoXBOqk8cELGD7Dr3eh4fzU8JBHXa++alzmZfpeHUKBAjUsfM
         xXAJee4C51sqwg+jBkZLteBzvsaZyBVFmiFWMFXwgt0sRjoF/XZ6qv4Yo0zldD6lTZaG
         t6EC7BFB5ZCe+QRse3tyze4+uPN5cpOIT4eax5vn5sFUY4fvWZmZ8NFo3qT7/hlMBuU7
         wOaw==
X-Gm-Message-State: AC+VfDzttDAEWN4Djzpn2zP68PhdK3HjFr3xM+zxoLe9qCtuCx7mvRBz
        UYEiBl3TOvbMvsQ05kfdH3SWRsEGTLKgp84Smj77tQ==
X-Google-Smtp-Source: ACHHUZ7TIEuHBGm5angfypxdJbD4jmGVMdTZAY/Haceb/BUnC4lLnOQ4gKuBq3EcGpS4bRQVFHPBAfZrv5JJxSHXzLI=
X-Received: by 2002:a17:907:9404:b0:977:cdd6:6a5c with SMTP id
 dk4-20020a170907940400b00977cdd66a5cmr651234ejc.10.1686022564445; Mon, 05 Jun
 2023 20:36:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230520150116.7451-1-waylingII@gmail.com>
In-Reply-To: <20230520150116.7451-1-waylingII@gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 6 Jun 2023 09:05:53 +0530
Message-ID: <CAAhSdy1H7MWLRCct=Q_Sa=g+MfcFCU7OVAFaL0tQyMDp6GT8DQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Redirect AMO load/store misaligned traps to guest
To:     wchen <waylingii@gmail.com>
Cc:     atishp@atishpatra.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 20, 2023 at 8:31=E2=80=AFPM wchen <waylingii@gmail.com> wrote:
>
> The M-mode redirects an unhandled misaligned trap back
> to S-mode when not delegating it to VS-mode(hedeleg).
> However, KVM running in HS-mode terminates the VS-mode
> software when back from M-mode.
> The KVM should redirect the trap back to VS-mode, and
> let VS-mode trap handler decide the next step.
> Here is a way to handle misaligned traps in KVM,
> not only directing them to VS-mode or terminate it.
>
> Signed-off-by: wchen <waylingII@gmail.com>

Queued this patch for 6.5

Thanks,
Anup

> ---
>  arch/riscv/include/asm/csr.h | 2 ++
>  arch/riscv/kvm/vcpu_exit.c   | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index b6acb7ed1..917814a0f 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -82,7 +82,9 @@
>  #define EXC_INST_ACCESS                1
>  #define EXC_INST_ILLEGAL       2
>  #define EXC_BREAKPOINT         3
> +#define EXC_LOAD_MISALIGNED    4
>  #define EXC_LOAD_ACCESS                5
> +#define EXC_STORE_MISALIGNED   6
>  #define EXC_STORE_ACCESS       7
>  #define EXC_SYSCALL            8
>  #define EXC_HYPERVISOR_SYSCALL 9
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 4ea101a73..2415722c0 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -183,6 +183,8 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct=
 kvm_run *run,
>         run->exit_reason =3D KVM_EXIT_UNKNOWN;
>         switch (trap->scause) {
>         case EXC_INST_ILLEGAL:
> +       case EXC_LOAD_MISALIGNED:
> +       case EXC_STORE_MISALIGNED:
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
>                         kvm_riscv_vcpu_trap_redirect(vcpu, trap);
>                         ret =3D 1;
> --
> 2.34.1
>
