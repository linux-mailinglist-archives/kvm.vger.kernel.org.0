Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48826C6B42
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 15:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjCWOkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 10:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCWOj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 10:39:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52820E062
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D16E9B82160
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962F3C4339C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679582394;
        bh=lua44hM4YFySxeEf07E/HtVW96EyEvu078Bigk4hPR4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nLWkr/eYKXSnqX/bQNSMMJzIphYye47U8zK8tMTmZWoAj+i1z1Sy6yDU5FfPPwqon
         yUFk3Z6NvBwr7yNf6QCN/rW7eXdnVcHAppZTETcK+p/4D8agEpPfIcH4fHcLzt7Fyc
         6AUZXVZz8gQsYVFVYFRknkUhtRULC9QOtBHuzjWGOVwtRS+luyYGQ/oDMOxvzwy+Up
         qY6KYRppJd3vpG7chDk3tk1BLsLFjW8kVrhE1G3zVXRqjsMW7dJ7gafG0HvojPArDR
         lc3746BGhwUiQ9rx3BzY6/36rr7TECKdeQHuD4GGuBe8/+DZmIB13r+ZpPnnUYq/6r
         r1CtgEpHjwVQw==
Received: by mail-ed1-f50.google.com with SMTP id b20so54633091edd.1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 07:39:54 -0700 (PDT)
X-Gm-Message-State: AO0yUKXOY8aYBw4+BykhQpPpBYUa2sIe9l8pT33+zOq+tNEASl+W1SqI
        l1sK7+3BxpQ22YEN2nnNc9/COJkKW4SbXydQBbk=
X-Google-Smtp-Source: AK7set+7j0NmRcad5evSxm04cqkFWUH+5wx6VDQnJh2jP3Luw7ItRdc8ixiHJpB2ZDx2aQp5AoHZSiVDTNVUW+Yx5J0=
X-Received: by 2002:a50:950b:0:b0:4fd:939:56ca with SMTP id
 u11-20020a50950b000000b004fd093956camr5639544eda.5.1679582392777; Thu, 23 Mar
 2023 07:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113538.10878-1-andy.chiu@sifive.com> <20230317113538.10878-15-andy.chiu@sifive.com>
In-Reply-To: <20230317113538.10878-15-andy.chiu@sifive.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Thu, 23 Mar 2023 22:39:41 +0800
X-Gmail-Original-Message-ID: <CAJF2gTR6YXJhvnjtMvej0JvPSOOO3K-jHgS-nkSxe06aXT66=g@mail.gmail.com>
Message-ID: <CAJF2gTR6YXJhvnjtMvej0JvPSOOO3K-jHgS-nkSxe06aXT66=g@mail.gmail.com>
Subject: Re: [PATCH -next v15 14/19] riscv: signal: Report signal frame size
 to userspace via auxv
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        Zong Li <zong.li@sifive.com>,
        Nick Knight <nick.knight@sifive.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 7:37=E2=80=AFPM Andy Chiu <andy.chiu@sifive.com> wr=
ote:
>
> From: Vincent Chen <vincent.chen@sifive.com>
>
> The vector register belongs to the signal context. They need to be stored
> and restored as entering and leaving the signal handler. According to the
> V-extension specification, the maximum length of the vector registers can
> be 2^(XLEN-1). Hence, if userspace refers to the MINSIGSTKSZ to create a
> sigframe, it may not be enough. To resolve this problem, this patch refer=
s
> to the commit 94b07c1f8c39c
> ("arm64: signal: Report signal frame size to userspace via auxv") to enab=
le
> userspace to know the minimum required sigframe size through the auxiliar=
y
> vector and use it to allocate enough memory for signal context.
>
> Note that auxv always reports size of the sigframe as if V exists for
> all starting processes, whenever the kernel has CONFIG_RISCV_ISA_V. The
> reason is that users usually reference this value to allocate an
> alternative signal stack, and the user may use V anytime. So the user
> must reserve a space for V-context in sigframe in case that the signal
> handler invokes after the kernel allocating V.
>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  arch/riscv/include/asm/elf.h         |  9 +++++++++
>  arch/riscv/include/asm/processor.h   |  2 ++
>  arch/riscv/include/uapi/asm/auxvec.h |  1 +
>  arch/riscv/kernel/signal.c           | 20 +++++++++++++++-----
>  4 files changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
> index 30e7d2455960..ca23c4f6c440 100644
> --- a/arch/riscv/include/asm/elf.h
> +++ b/arch/riscv/include/asm/elf.h
> @@ -105,6 +105,15 @@ do {                                                =
               \
>                 get_cache_size(3, CACHE_TYPE_UNIFIED));         \
>         NEW_AUX_ENT(AT_L3_CACHEGEOMETRY,                        \
>                 get_cache_geometry(3, CACHE_TYPE_UNIFIED));     \
> +       /*                                                       \
> +        * Should always be nonzero unless there's a kernel bug. \
> +        * If we haven't determined a sensible value to give to  \
> +        * userspace, omit the entry:                            \
> +        */                                                      \
> +       if (likely(signal_minsigstksz))                          \
> +               NEW_AUX_ENT(AT_MINSIGSTKSZ, signal_minsigstksz); \
> +       else                                                     \
> +               NEW_AUX_ENT(AT_IGNORE, 0);                       \
>  } while (0)
>  #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
>  struct linux_binprm;
> diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/asm/=
processor.h
> index f0ddf691ac5e..38ded8c5f207 100644
> --- a/arch/riscv/include/asm/processor.h
> +++ b/arch/riscv/include/asm/processor.h
> @@ -7,6 +7,7 @@
>  #define _ASM_RISCV_PROCESSOR_H
>
>  #include <linux/const.h>
> +#include <linux/cache.h>
>
>  #include <vdso/processor.h>
>
> @@ -81,6 +82,7 @@ int riscv_of_parent_hartid(struct device_node *node, un=
signed long *hartid);
>  extern void riscv_fill_hwcap(void);
>  extern int arch_dup_task_struct(struct task_struct *dst, struct task_str=
uct *src);
>
> +extern unsigned long signal_minsigstksz __ro_after_init;
>  #endif /* __ASSEMBLY__ */
>
>  #endif /* _ASM_RISCV_PROCESSOR_H */
> diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/ua=
pi/asm/auxvec.h
> index fb187a33ce58..10aaa83db89e 100644
> --- a/arch/riscv/include/uapi/asm/auxvec.h
> +++ b/arch/riscv/include/uapi/asm/auxvec.h
> @@ -35,5 +35,6 @@
>
>  /* entries in ARCH_DLINFO */
>  #define AT_VECTOR_SIZE_ARCH    9
> +#define AT_MINSIGSTKSZ         51
>
>  #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
> diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
> index 55d2215d18ea..d2d9232498ca 100644
> --- a/arch/riscv/kernel/signal.c
> +++ b/arch/riscv/kernel/signal.c
> @@ -21,6 +21,8 @@
>  #include <asm/vector.h>
>  #include <asm/csr.h>
>
> +unsigned long signal_minsigstksz __ro_after_init;
> +
>  extern u32 __user_rt_sigreturn[2];
>  static size_t riscv_v_sc_size __ro_after_init;
>
> @@ -195,7 +197,7 @@ static long restore_sigcontext(struct pt_regs *regs,
>         return err;
>  }
>
> -static size_t get_rt_frame_size(void)
> +static size_t get_rt_frame_size(bool cal_all)
>  {
>         struct rt_sigframe __user *frame;
>         size_t frame_size;
> @@ -203,8 +205,10 @@ static size_t get_rt_frame_size(void)
>
>         frame_size =3D sizeof(*frame);
>
> -       if (has_vector() && riscv_v_vstate_query(task_pt_regs(current)))
> -               total_context_size +=3D riscv_v_sc_size;
> +       if (has_vector()) {
> +               if (cal_all || riscv_v_vstate_query(task_pt_regs(current)=
))
> +                       total_context_size +=3D riscv_v_sc_size;
> +       }
>         /*
>          * Preserved a __riscv_ctx_hdr for END signal context header if a=
n
>          * extension uses __riscv_extra_ext_header
> @@ -224,7 +228,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
>         struct rt_sigframe __user *frame;
>         struct task_struct *task;
>         sigset_t set;
> -       size_t frame_size =3D get_rt_frame_size();
> +       size_t frame_size =3D get_rt_frame_size(false);
>
>         /* Always make any pending restarted system calls return -EINTR *=
/
>         current->restart_block.fn =3D do_no_restart_syscall;
> @@ -320,7 +324,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigse=
t_t *set,
>  {
>         struct rt_sigframe __user *frame;
>         long err =3D 0;
> -       size_t frame_size =3D get_rt_frame_size();
> +       size_t frame_size =3D get_rt_frame_size(false);
>
>         frame =3D get_sigframe(ksig, regs, frame_size);
>         if (!access_ok(frame, frame_size))
> @@ -483,4 +487,10 @@ void __init init_rt_signal_env(void)
>  {
>         riscv_v_sc_size =3D sizeof(struct __riscv_ctx_hdr) +
>                           sizeof(struct __sc_riscv_v_state) + riscv_v_vsi=
ze;
> +       /*
> +        * Determine the stack space required for guaranteed signal deliv=
ery.
> +        * The signal_minsigstksz will be populated into the AT_MINSIGSTK=
SZ entry
> +        * in the auxiliary array at process startup.
> +        */
> +       signal_minsigstksz =3D get_rt_frame_size(true);
>  }
> --
> 2.17.1
>
Reviewed-by: Guo Ren <guoren@kernel.org>

--=20
Best Regards
 Guo Ren
