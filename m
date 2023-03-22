Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B856C400C
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCVByd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCVByc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:54:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B74199DE
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6690F61EFB
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 01:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B715AC433EF
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 01:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679450069;
        bh=f7Mp35XmkzylH25o2u7PhfQj/YdnUpEiqx06nYjPifA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k6bZOs3ucQ5jSmTcubMLFqvtHxZtx0w3v1o/TKG2ZIqxFpx3TqsJFxY/aEyPJflJB
         YXnc3Am+Ued4U7iShEHxteAlP985aKG+rtJEn77wXdjOinn2cWg0S2d3WOGI91+UeF
         Uwc6XdAihXyaeLhjF+Sdjod1Dxl35DvmDkqMXWMi289NgG3i5fAAfw6zbSY8u0xcvt
         iCajjrkaKmKMyWWSpDq88K39dyb6E5FZrnC7DAsK86WOqbWOGNiLYf4Tv3yofcGk2g
         xcotIgA9jRVBBahJiDSZnHb/niIh8y6Gl/dc29kuYdIi5b5p+SVXwiZBwAoNvQqogZ
         jJvLFgcWaHDjg==
Received: by mail-ed1-f42.google.com with SMTP id cy23so66968174edb.12
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:54:29 -0700 (PDT)
X-Gm-Message-State: AO0yUKW5zEg05quYLTcxEumAb64dARA21jwXv8a9fImL9XB4AzY68O/r
        fVJKwYzjVHuDs9uTs8SvVQw5Dh3PZ7d4ybNa5pA=
X-Google-Smtp-Source: AK7set/PtD02jJXDERpfP/jnTM4/xGy93+0zgaS94/tZtJU6pU9nlQgl9O2IjazCz/3LSsY0PPzVQGWLqMWp1aAcbh4=
X-Received: by 2002:a17:907:2c66:b0:931:faf0:3db1 with SMTP id
 ib6-20020a1709072c6600b00931faf03db1mr348567ejc.4.1679450067903; Tue, 21 Mar
 2023 18:54:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113538.10878-1-andy.chiu@sifive.com> <20230317113538.10878-9-andy.chiu@sifive.com>
In-Reply-To: <20230317113538.10878-9-andy.chiu@sifive.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Wed, 22 Mar 2023 09:54:16 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSSbbQ_ec0GA7w9KMT4VPUV2vX=rF8LLKjGevfsytaSRA@mail.gmail.com>
Message-ID: <CAJF2gTSSbbQ_ec0GA7w9KMT4VPUV2vX=rF8LLKjGevfsytaSRA@mail.gmail.com>
Subject: Re: [PATCH -next v15 08/19] riscv: Introduce struct/helpers to
 save/restore per-task Vector state
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 7:37=E2=80=AFPM Andy Chiu <andy.chiu@sifive.com> wr=
ote:
>
> From: Greentime Hu <greentime.hu@sifive.com>
>
> Add vector state context struct to be added later in thread_struct. And
> prepare low-level helper functions to save/restore vector contexts.
>
> This include Vector Regfile and CSRs holding dynamic configuration state
> (vstart, vl, vtype, vcsr). The Vec Register width could be implementation
> defined, but same for all processes, so that is saved separately.
>
> This is not yet wired into final thread_struct - will be done when
> __switch_to actually starts doing this in later patches.
>
> Given the variable (and potentially large) size of regfile, they are
> saved in dynamically allocated memory, pointed to by datap pointer in
> __riscv_v_ext_state.
>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  arch/riscv/include/asm/vector.h      | 97 ++++++++++++++++++++++++++++
>  arch/riscv/include/uapi/asm/ptrace.h | 17 +++++
>  2 files changed, 114 insertions(+)
>
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index 18448e24d77b..c7143b7d64d1 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -10,8 +10,10 @@
>
>  #ifdef CONFIG_RISCV_ISA_V
>
> +#include <linux/stringify.h>
>  #include <asm/hwcap.h>
>  #include <asm/csr.h>
> +#include <asm/asm.h>
>
>  extern unsigned long riscv_v_vsize;
>  void riscv_v_setup_vsize(void);
> @@ -21,6 +23,26 @@ static __always_inline bool has_vector(void)
>         return riscv_has_extension_likely(RISCV_ISA_EXT_v);
>  }
>
> +static inline void __riscv_v_vstate_clean(struct pt_regs *regs)
> +{
> +       regs->status =3D (regs->status & ~SR_VS) | SR_VS_CLEAN;
> +}
> +
> +static inline void riscv_v_vstate_off(struct pt_regs *regs)
> +{
> +       regs->status =3D (regs->status & ~SR_VS) | SR_VS_OFF;
> +}
> +
> +static inline void riscv_v_vstate_on(struct pt_regs *regs)
> +{
> +       regs->status =3D (regs->status & ~SR_VS) | SR_VS_INITIAL;
> +}
> +
> +static inline bool riscv_v_vstate_query(struct pt_regs *regs)
> +{
> +       return (regs->status & SR_VS) !=3D 0;
> +}
> +
>  static __always_inline void riscv_v_enable(void)
>  {
>         csr_set(CSR_SSTATUS, SR_VS);
> @@ -31,11 +53,86 @@ static __always_inline void riscv_v_disable(void)
>         csr_clear(CSR_SSTATUS, SR_VS);
>  }
>
> +static __always_inline void __vstate_csr_save(struct __riscv_v_ext_state=
 *dest)
> +{
> +       asm volatile (
> +               "csrr   %0, " __stringify(CSR_VSTART) "\n\t"
> +               "csrr   %1, " __stringify(CSR_VTYPE) "\n\t"
> +               "csrr   %2, " __stringify(CSR_VL) "\n\t"
> +               "csrr   %3, " __stringify(CSR_VCSR) "\n\t"
> +               : "=3Dr" (dest->vstart), "=3Dr" (dest->vtype), "=3Dr" (de=
st->vl),
> +                 "=3Dr" (dest->vcsr) : :);
> +}
> +
> +static __always_inline void __vstate_csr_restore(struct __riscv_v_ext_st=
ate *src)
> +{
> +       asm volatile (
> +               ".option push\n\t"
> +               ".option arch, +v\n\t"
> +               "vsetvl  x0, %2, %1\n\t"
> +               ".option pop\n\t"
> +               "csrw   " __stringify(CSR_VSTART) ", %0\n\t"
> +               "csrw   " __stringify(CSR_VCSR) ", %3\n\t"
> +               : : "r" (src->vstart), "r" (src->vtype), "r" (src->vl),
> +                   "r" (src->vcsr) :);
> +}
> +
> +static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *sav=
e_to,
> +                                        void *datap)
> +{
> +       unsigned long vl;
> +
> +       riscv_v_enable();
> +       __vstate_csr_save(save_to);
> +       asm volatile (
> +               ".option push\n\t"
> +               ".option arch, +v\n\t"
> +               "vsetvli        %0, x0, e8, m8, ta, ma\n\t"
> +               "vse8.v         v0, (%1)\n\t"
> +               "add            %1, %1, %0\n\t"
> +               "vse8.v         v8, (%1)\n\t"
> +               "add            %1, %1, %0\n\t"
> +               "vse8.v         v16, (%1)\n\t"
> +               "add            %1, %1, %0\n\t"
> +               "vse8.v         v24, (%1)\n\t"
> +               ".option pop\n\t"
> +               : "=3D&r" (vl) : "r" (datap) : "memory");
> +       riscv_v_disable();
> +}
> +
> +static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *=
restore_from,
> +                                           void *datap)
> +{
> +       unsigned long vl;
> +
> +       riscv_v_enable();
> +       asm volatile (
> +               ".option push\n\t"
> +               ".option arch, +v\n\t"
> +               "vsetvli        %0, x0, e8, m8, ta, ma\n\t"
> +               "vle8.v         v0, (%1)\n\t"
> +               "add            %1, %1, %0\n\t"
> +               "vle8.v         v8, (%1)\n\t"
> +               "add            %1, %1, %0\n\t"
> +               "vle8.v         v16, (%1)\n\t"
> +               "add            %1, %1, %0\n\t"
> +               "vle8.v         v24, (%1)\n\t"
> +               ".option pop\n\t"
> +               : "=3D&r" (vl) : "r" (datap) : "memory");
> +       __vstate_csr_restore(restore_from);
> +       riscv_v_disable();
> +}
> +
>  #else /* ! CONFIG_RISCV_ISA_V  */
>
> +struct pt_regs;
> +
>  static __always_inline bool has_vector(void) { return false; }
> +static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return f=
alse; }
>  #define riscv_v_vsize (0)
>  #define riscv_v_setup_vsize()                  do {} while (0)
> +#define riscv_v_vstate_off(regs)               do {} while (0)
> +#define riscv_v_vstate_on(regs)                        do {} while (0)
>
>  #endif /* CONFIG_RISCV_ISA_V */
>
> diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/ua=
pi/asm/ptrace.h
> index 882547f6bd5c..586786d023c4 100644
> --- a/arch/riscv/include/uapi/asm/ptrace.h
> +++ b/arch/riscv/include/uapi/asm/ptrace.h
> @@ -77,6 +77,23 @@ union __riscv_fp_state {
>         struct __riscv_q_ext_state q;
>  };
>
> +struct __riscv_v_ext_state {
> +       unsigned long vstart;
> +       unsigned long vl;
> +       unsigned long vtype;
> +       unsigned long vcsr;
> +       void *datap;
> +       /*
> +        * In signal handler, datap will be set a correct user stack offs=
et
> +        * and vector registers will be copied to the address of datap
> +        * pointer.
> +        *
> +        * In ptrace syscall, datap will be set to zero and the vector
> +        * registers will be copied to the address right after this
> +        * structure.
> +        */
> +};
> +
>  #endif /* __ASSEMBLY__ */
>
>  #endif /* _UAPI_ASM_RISCV_PTRACE_H */
Reviewed-by: Guo Ren <guoren@kernel.org>

> --
> 2.17.1
>


--=20
Best Regards
 Guo Ren
