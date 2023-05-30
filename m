Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E010716A10
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjE3QwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjE3Qv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C59C5
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCDE63024
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 16:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F0FC433EF
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685465516;
        bh=/Gy03ZF3ZHFei176bqQktd+JC64WhLRtmKlNUKh29Zw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Fes/vBTAxy1gh72Y/lffJ86z2RvBWA9tV620BzRu1i2j5dGFIO0e0b2aWxEuowlhp
         8DN7iVzWGkVosE2xDxr54FPmFr3lLYJtCvMnH4tAVCPdfgQReNvgq/PVP9ZHFXz3DK
         /Oy1LAddsJM63HlWwasb/qsYtk9cC9ot7dNPQhVvDG8nGvJAbCpTvdBmZC5/RX/2qx
         NoPFhNe1ewMmtaaG/Jh9vyvpfrSHITNFkYbGQ9PyT8ipBSQVPVKLsY2xYDjtKiBgR/
         RhBA0Saw0PC+nwYV++BwpgRkThBJZCcWP5F4mIIREqTGAWa49s7CYEPDE+oykAtYy0
         rLXIRUaJUUDVA==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-4f3edc05aa5so5264396e87.3
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:51:56 -0700 (PDT)
X-Gm-Message-State: AC+VfDxqBt5f/T1l2ojnAtPupLYAsJFau9Em058undhV4yut0Xv0L6iW
        +kBqkQSjuB95l9FCCrqEyyGyuFoi+y4BV37lqD8=
X-Google-Smtp-Source: ACHHUZ7vwP9yqqeQhSciB4UvaCzxf76iVICXvxuN4ocPpEoyCrjrl5+iN1bOowQOfpaKvNACGk9jOIfFu7pmGmxnlQI=
X-Received: by 2002:ac2:442e:0:b0:4f3:8196:80c8 with SMTP id
 w14-20020ac2442e000000b004f3819680c8mr969532lfl.1.1685465514510; Tue, 30 May
 2023 09:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230518161949.11203-1-andy.chiu@sifive.com> <20230518161949.11203-12-andy.chiu@sifive.com>
In-Reply-To: <20230518161949.11203-12-andy.chiu@sifive.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Wed, 31 May 2023 00:51:43 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTQz8kOkHUBqh50PBLTBY0-MTBGLJbuC7-YavCMz=V31Q@mail.gmail.com>
Message-ID: <CAJF2gTTQz8kOkHUBqh50PBLTBY0-MTBGLJbuC7-YavCMz=V31Q@mail.gmail.com>
Subject: Re: [PATCH -next v20 11/26] riscv: Allocate user's vector context in
 the first-use trap
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Mattias Nissler <mnissler@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 12:21=E2=80=AFAM Andy Chiu <andy.chiu@sifive.com> w=
rote:
>
> Vector unit is disabled by default for all user processes. Thus, a
> process will take a trap (illegal instruction) into kernel at the first
> time when it uses Vector. Only after then, the kernel allocates V
> context and starts take care of the context for that user process.
>
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@lina=
ro.org
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
> Hey Heiko and Conor, I am dropping you guys' A-b, T-b, and R-b because I
> added a check in riscv_v_first_use_handler().
>
> Changelog v20:
>  - move has_vector() into vector.c for better code readibility
>  - check elf_hwcap in the first-use trap because it might get turned off
>    if cores have different VLENs.
>
> Changelog v18:
>  - Add blank lines (Heiko)
>  - Return immediately in insn_is_vector() if an insn matches (Heiko)
> ---
>  arch/riscv/include/asm/insn.h   | 29 ++++++++++
>  arch/riscv/include/asm/vector.h |  2 +
>  arch/riscv/kernel/traps.c       | 26 ++++++++-
>  arch/riscv/kernel/vector.c      | 95 +++++++++++++++++++++++++++++++++
>  4 files changed, 150 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.=
h
> index 8d5c84f2d5ef..4e1505cef8aa 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -137,6 +137,26 @@
>  #define RVG_OPCODE_JALR                0x67
>  #define RVG_OPCODE_JAL         0x6f
>  #define RVG_OPCODE_SYSTEM      0x73
> +#define RVG_SYSTEM_CSR_OFF     20
> +#define RVG_SYSTEM_CSR_MASK    GENMASK(12, 0)
> +
> +/* parts of opcode for RVF, RVD and RVQ */
> +#define RVFDQ_FL_FS_WIDTH_OFF  12
> +#define RVFDQ_FL_FS_WIDTH_MASK GENMASK(3, 0)
> +#define RVFDQ_FL_FS_WIDTH_W    2
> +#define RVFDQ_FL_FS_WIDTH_D    3
> +#define RVFDQ_LS_FS_WIDTH_Q    4
> +#define RVFDQ_OPCODE_FL                0x07
> +#define RVFDQ_OPCODE_FS                0x27
> +
> +/* parts of opcode for RVV */
> +#define RVV_OPCODE_VECTOR      0x57
> +#define RVV_VL_VS_WIDTH_8      0
> +#define RVV_VL_VS_WIDTH_16     5
> +#define RVV_VL_VS_WIDTH_32     6
> +#define RVV_VL_VS_WIDTH_64     7
> +#define RVV_OPCODE_VL          RVFDQ_OPCODE_FL
> +#define RVV_OPCODE_VS          RVFDQ_OPCODE_FS
>
>  /* parts of opcode for RVC*/
>  #define RVC_OPCODE_C0          0x0
> @@ -304,6 +324,15 @@ static __always_inline bool riscv_insn_is_branch(u32=
 code)
>         (RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_=
7_6_OFF) | \
>         (RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
>
> +#define RVG_EXTRACT_SYSTEM_CSR(x) \
> +       ({typeof(x) x_ =3D (x); RV_X(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_C=
SR_MASK); })
> +
> +#define RVFDQ_EXTRACT_FL_FS_WIDTH(x) \
> +       ({typeof(x) x_ =3D (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
> +                                  RVFDQ_FL_FS_WIDTH_MASK); })
> +
> +#define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
> +
>  /*
>   * Get the immediate from a J-type instruction.
>   *
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index ce6a75e9cf62..8e56da67b5cf 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -21,6 +21,7 @@
>
>  extern unsigned long riscv_v_vsize;
>  int riscv_v_setup_vsize(void);
> +bool riscv_v_first_use_handler(struct pt_regs *regs);
>
>  static __always_inline bool has_vector(void)
>  {
> @@ -165,6 +166,7 @@ struct pt_regs;
>
>  static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
>  static __always_inline bool has_vector(void) { return false; }
> +static inline bool riscv_v_first_use_handler(struct pt_regs *regs) { ret=
urn false; }
>  static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return f=
alse; }
>  #define riscv_v_vsize (0)
>  #define riscv_v_vstate_save(task, regs)                do {} while (0)
> diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> index 8c258b78c925..05ffdcd1424e 100644
> --- a/arch/riscv/kernel/traps.c
> +++ b/arch/riscv/kernel/traps.c
> @@ -26,6 +26,7 @@
>  #include <asm/ptrace.h>
>  #include <asm/syscall.h>
>  #include <asm/thread_info.h>
> +#include <asm/vector.h>
>
>  int show_unhandled_signals =3D 1;
>
> @@ -145,8 +146,29 @@ DO_ERROR_INFO(do_trap_insn_misaligned,
>         SIGBUS, BUS_ADRALN, "instruction address misaligned");
>  DO_ERROR_INFO(do_trap_insn_fault,
>         SIGSEGV, SEGV_ACCERR, "instruction access fault");
> -DO_ERROR_INFO(do_trap_insn_illegal,
> -       SIGILL, ILL_ILLOPC, "illegal instruction");
> +
> +asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_=
regs *regs)
> +{
> +       if (user_mode(regs)) {
> +               irqentry_enter_from_user_mode(regs);
> +
> +               local_irq_enable();
> +
> +               if (!riscv_v_first_use_handler(regs))
> +                       do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc=
,
> +                                     "Oops - illegal instruction");
> +
> +               irqentry_exit_to_user_mode(regs);
> +       } else {
> +               irqentry_state_t state =3D irqentry_nmi_enter(regs);
> +
> +               do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
> +                             "Oops - illegal instruction");
> +
> +               irqentry_nmi_exit(regs, state);
> +       }
> +}
> +
>  DO_ERROR_INFO(do_trap_load_fault,
>         SIGSEGV, SEGV_ACCERR, "load access fault");
>  #ifndef CONFIG_RISCV_M_MODE
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 120f1ce9abf9..0080798e8d2e 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -4,10 +4,19 @@
>   * Author: Andy Chiu <andy.chiu@sifive.com>
>   */
>  #include <linux/export.h>
> +#include <linux/sched/signal.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
>
> +#include <asm/thread_info.h>
> +#include <asm/processor.h>
> +#include <asm/insn.h>
>  #include <asm/vector.h>
>  #include <asm/csr.h>
>  #include <asm/elf.h>
> +#include <asm/ptrace.h>
>  #include <asm/bug.h>
>
>  unsigned long riscv_v_vsize __read_mostly;
> @@ -34,3 +43,89 @@ int riscv_v_setup_vsize(void)
>
>         return 0;
>  }
> +
> +static bool insn_is_vector(u32 insn_buf)
> +{
> +       u32 opcode =3D insn_buf & __INSN_OPCODE_MASK;
> +       u32 width, csr;
> +
> +       /*
> +        * All V-related instructions, including CSR operations are 4-Byt=
e. So,
> +        * do not handle if the instruction length is not 4-Byte.
> +        */
> +       if (unlikely(GET_INSN_LENGTH(insn_buf) !=3D 4))
> +               return false;
> +
> +       switch (opcode) {
> +       case RVV_OPCODE_VECTOR:
> +               return true;
> +       case RVV_OPCODE_VL:
> +       case RVV_OPCODE_VS:
> +               width =3D RVV_EXRACT_VL_VS_WIDTH(insn_buf);
> +               if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_VL=
_VS_WIDTH_16 ||
> +                   width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV_V=
L_VS_WIDTH_64)
> +                       return true;
> +
> +               break;
> +       case RVG_OPCODE_SYSTEM:
> +               csr =3D RVG_EXTRACT_SYSTEM_CSR(insn_buf);
> +               if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
> +                   (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
> +static int riscv_v_thread_zalloc(void)
> +{
> +       void *datap;
> +
> +       datap =3D kzalloc(riscv_v_vsize, GFP_KERNEL);
> +       if (!datap)
> +               return -ENOMEM;
> +
> +       current->thread.vstate.datap =3D datap;
> +       memset(&current->thread.vstate, 0, offsetof(struct __riscv_v_ext_=
state,
> +                                                   datap));
> +       return 0;
> +}
> +
> +bool riscv_v_first_use_handler(struct pt_regs *regs)
> +{
> +       u32 __user *epc =3D (u32 __user *)regs->epc;
> +       u32 insn =3D (u32)regs->badaddr;
> +
> +       /* Do not handle if V is not supported, or disabled */
> +       if (!has_vector() || !(elf_hwcap & COMPAT_HWCAP_ISA_V))
> +               return false;
> +
> +       /* If V has been enabled then it is not the first-use trap */
> +       if (riscv_v_vstate_query(regs))
> +               return false;
> +
> +       /* Get the instruction */
> +       if (!insn) {
> +               if (__get_user(insn, epc))
> +                       return false;
> +       }

As spec has said:
4.1.11 Supervisor Trap Value (stval) Register
...
On an illegal instruction trap, stval may be written with the rst XLEN
or ILEN bits of the faulting
instruction as described below.

So
u32 insn =3D (u32)regs->badaddr;
is enough.

Do you need an ALTERNATIVE fixup here?

> +
> +       /* Filter out non-V instructions */
> +       if (!insn_is_vector(insn))
> +               return false;
> +
> +       /* Sanity check. datap should be null by the time of the first-us=
e trap */
> +       WARN_ON(current->thread.vstate.datap);
> +
> +       /*
> +        * Now we sure that this is a V instruction. And it executes in t=
he
> +        * context where VS has been off. So, try to allocate the user's =
V
> +        * context and resume execution.
> +        */
> +       if (riscv_v_thread_zalloc()) {
> +               force_sig(SIGKILL);
> +               return true;
> +       }
> +       riscv_v_vstate_on(regs);
> +       return true;
> +}
> --
> 2.17.1
>


--=20
Best Regards
 Guo Ren
