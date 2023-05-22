Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D0C70B40D
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 06:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjEVETf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 00:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjEVETe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 00:19:34 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44A9B0
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 21:19:32 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-510ddeab704so7132838a12.3
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 21:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1684729171; x=1687321171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6R0fGdLfiHWfeeg/+UnqTOnxxWH1sRAWs2bXSs9TBw=;
        b=AMrduyX6ySJBNshvdWqmfu1vyyl7oisPkSgZ/EhcHcuD5cllHjjy//BlgByXaKeW1p
         b0CUwgUOYZQw6IWByrHcYKERB6Kd9eeTHUTcrBJnNwo3fkode1Ki4a+DC8eGm7IU0Xd5
         /Z4QCDbSx/FtmdhzLt8VA7dFo5iV0j/2NMU/gTyayjWTxVOknF9OaUiqI6zCPIza/99d
         ughlcDI1Y6ppCWcw7IetQxslk95u1qC9v6zg3lrtzCZJwL1woJwsEV6wi7vWhW0GS6+X
         q7SrRFVdGTZlKEkFtiNijvCFqbR4zXyJRgHmf6HGEtpFgw3FAPLsob2yV6tRtaJImeBz
         a70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684729171; x=1687321171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6R0fGdLfiHWfeeg/+UnqTOnxxWH1sRAWs2bXSs9TBw=;
        b=ZImOm2kkxmlCjCTf66FYfPri8Bf6c5Y2sWung/OIJ1WG9skozwPl0HupV2bHjfEob/
         VKrgmxFQuVyNXN7kslf+hzTnYHi2GpiVzKEa/kAHcpE+2a46vYy8EOAFpwizDKZVr8af
         ejkZh/sSlVy2H2b7n9vFMkSHBC1RJ2FsrvD1jzCAKmnRMILHfUKGnuMkGUQiTZHid/M+
         CgtKFc+5/h3OZeae0swmUWUxqT4ig4KHn6uI9ZK/UE+r0d+oe0P+zbq5YwxBwyx141Uc
         jeiFRo7e5Zlu2Fy9QaVOUiOVUOdVN+yly9P6g82lUM8ZQKUq5i95qQ1M4L58lnBw0vnc
         o9Zw==
X-Gm-Message-State: AC+VfDzdiDhzdtCHH7dM9AXBQzxhuFJhRm3IKwVBTdFIBjE52QlT3Ctt
        jgApYEjTrlc9ceIlryJ6RTuMuz+7RKv+2sjJPVm6aQ==
X-Google-Smtp-Source: ACHHUZ7NgkgksygczrfupwMkXnUqAluuVB0P7LKIp1C0lMYIW/KgaJuQIBHrgYroxsmbFQbE/bffLHrweqg6g02WL+M=
X-Received: by 2002:a05:6402:b0f:b0:50b:f8f7:f8d8 with SMTP id
 bm15-20020a0564020b0f00b0050bf8f7f8d8mr7003523edb.36.1684729171031; Sun, 21
 May 2023 21:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230520150116.7451-1-waylingII@gmail.com>
In-Reply-To: <20230520150116.7451-1-waylingII@gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 22 May 2023 09:49:19 +0530
Message-ID: <CAAhSdy0Z+YRPQLQ-PXmrHCTYpAqi+NBV-uJquBxYdMt55SRdZg@mail.gmail.com>
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

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
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
