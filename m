Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14BE687F43
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 14:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjBBNx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 08:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBBNxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 08:53:25 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7526233C3
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 05:53:22 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id lu11so6178444ejb.3
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 05:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lRWOiKEIx4sC6D3oxMDk9TP0VHck4I+tZSIoPNsqoc4=;
        b=NXhMzdRnBSL2EezBJLEpN7LdPv7I/+EoDoGr57TQ/ZuilhC5Ep6QwlE+FbcCutydGU
         iLT4LYMybhvXZjOAqPqkdYeDcSu7eBiEx6S4B4MSCT77PkCOcAwkvThxNSvysOZoCTZl
         jSFfkJzbv/dqptJbNlQS4idGX6O2e+Gzo43rNjSypmA7LFn4kIpkR8TzxiImCDLtxwVb
         dsDcQPrk4DZzVM0HedjvwswuOLGfGvERrfafOVU+9deUyMl9bZXZHayWjMCoBi885R5h
         Sq09wpnUSJI3sUlJhhj3SZ/DAnfWiMj5GDDSV3HOZLKJ+F19v2WfA2tASyIEaHzlZT1Y
         MUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lRWOiKEIx4sC6D3oxMDk9TP0VHck4I+tZSIoPNsqoc4=;
        b=rKscdcL1h24nCpCSFOahUKHKnoRqpU41K5j6MNWYd0AL03EXH8MHgUqqBLMPfKIWUE
         XIiNDuO71sgHbtpkw3ITCw6b30bhkbBOFJqMm/xrzsODP/dMForPVNOolYS0pHXmSQly
         aNn0lExJyMjAqCunIm7dZ/eF5ueUKQWK+Ymm8HZFCPHCaxZ4q/e//uCnM1JkcLYi2918
         21E+ZKZsbPqvXIL9TIpPxQGcZTobu4GHZF4hDAlh3+C1LmfwA9uN6ka4NRhiIVkurTji
         sE6Rk6ZZncMhGXOEZs/ikXttKqShF0/Xwr0yKHVcI6/13VP5ULW7MtVGcKxbFFrt/3BO
         9ScQ==
X-Gm-Message-State: AO0yUKUGHKXGIFypbTgIx0Jzn8t+eOn/pfDIsLtw1zV3P70L2oqGguLi
        ZRFfn/TGrPStWfkacNCz6wQ2siO1lPDaEh5nz3gonQ==
X-Google-Smtp-Source: AK7set8uz666imyz15CSL1dfiXf6mAd72KCbAeRSvX0JNkMuHCIkdA4hqYwubFpB5PbsJ49RwZWnOxlG7nUfJLU3kTw=
X-Received: by 2002:a17:906:71d3:b0:84d:28da:f3a with SMTP id
 i19-20020a17090671d300b0084d28da0f3amr1773701ejk.76.1675346001173; Thu, 02
 Feb 2023 05:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk> <20230202124230.295997-3-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230202124230.295997-3-lawrence.hunter@codethink.co.uk>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 14:53:10 +0100
Message-ID: <CAAeLtUC4DZTKOK3k7FWG3Y7hm5pJmyE3AjXoUHJ-VQvAtg=FMQ@mail.gmail.com>
Subject: Re: [PATCH 02/39] target/riscv: Add vclmul.vv decoding, translation
 and execution support
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        Max Chou <max.chou@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Feb 2023 at 13:42, Lawrence Hunter
<lawrence.hunter@codethink.co.uk> wrote:
>

Given that this is a non-trivial change, the commit message seems a bit brief?

> Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> Co-authored-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> Co-authored-by: Max Chou <max.chou@sifive.com>
> Signed-off-by: Max Chou <max.chou@sifive.com>
> Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
> ---
>  target/riscv/helper.h                      |   3 +
>  target/riscv/insn32.decode                 |   3 +
>  target/riscv/insn_trans/trans_rvzvkb.c.inc |  41 +++++++
>  target/riscv/meson.build                   |   4 +-
>  target/riscv/translate.c                   |   1 +
>  target/riscv/vcrypto_helper.c              |  23 ++++
>  target/riscv/vector_helper.c               | 120 +--------------------
>  target/riscv/vector_internals.c            |  39 +++++++
>  target/riscv/vector_internals.h            | 116 ++++++++++++++++++++
>  9 files changed, 230 insertions(+), 120 deletions(-)
>  create mode 100644 target/riscv/insn_trans/trans_rvzvkb.c.inc
>  create mode 100644 target/riscv/vcrypto_helper.c
>  create mode 100644 target/riscv/vector_internals.c
>  create mode 100644 target/riscv/vector_internals.h
>
> diff --git a/target/riscv/helper.h b/target/riscv/helper.h
> index 227c7122ef..e9127c9ccb 100644
> --- a/target/riscv/helper.h
> +++ b/target/riscv/helper.h
> @@ -1136,3 +1136,6 @@ DEF_HELPER_FLAGS_1(aes64im, TCG_CALL_NO_RWG_SE, tl, tl)
>
>  DEF_HELPER_FLAGS_3(sm4ed, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
>  DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
> +
> +/* Vector crypto functions */
> +DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
> diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
> index b7e7613ea2..5ddee69d60 100644
> --- a/target/riscv/insn32.decode
> +++ b/target/riscv/insn32.decode
> @@ -890,3 +890,6 @@ sm3p1       00 01000 01001 ..... 001 ..... 0010011 @r2
>  # *** RV32 Zksed Standard Extension ***
>  sm4ed       .. 11000 ..... ..... 000 ..... 0110011 @k_aes
>  sm4ks       .. 11010 ..... ..... 000 ..... 0110011 @k_aes
> +
> +# *** RV64 Zvkb vector crypto extension ***
> +vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
> diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> new file mode 100644
> index 0000000000..fb1995f737
> --- /dev/null
> +++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> @@ -0,0 +1,41 @@
> +#define GEN_VV_MASKED_TRANS(NAME, CHECK)                               \
> +static bool trans_##NAME(DisasContext *s, arg_rmrr * a)                \
> +{                                                                      \
> +    if (CHECK(s, a)) {                                                 \
> +        uint32_t data = 0;                                             \
> +        TCGLabel *over = gen_new_label();                              \
> +        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);              \
> +        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);     \
> +                                                                       \
> +        data = FIELD_DP32(data, VDATA, VM, a->vm);                     \
> +        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                 \
> +        data = FIELD_DP32(data, VDATA, VTA, s->vta);                   \
> +        data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s); \
> +        data = FIELD_DP32(data, VDATA, VMA, s->vma);                   \
> +                                                                       \
> +        tcg_gen_gvec_4_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, 0),         \
> +                           vreg_ofs(s, a->rs1),                        \
> +                           vreg_ofs(s, a->rs2), cpu_env,               \
> +                           s->cfg_ptr->vlen / 8,                       \
> +                           s->cfg_ptr->vlen / 8, data,                 \
> +                           gen_helper_##NAME);                         \
> +                                                                       \
> +        mark_vs_dirty(s);                                              \
> +        gen_set_label(over);                                           \
> +        return true;                                                   \
> +    }                                                                  \
> +    return false;                                                      \
> +}

This largely duplicates GEN_OPIVV_TRANS(NAME, CHECK).
Please refactor and share the common part into an 'opivv_trans' that
can be reused.

I would expect the common part to have the following signature:
   static bool opivv_trans(DisasContext *s, arg_rmrr *a,
gen_helper_gvec_4_ptr *fn)

> +
> +static bool zvkb_vv_check(DisasContext *s, arg_rmrr *a)
> +{
> +    return opivv_check(s, a) &&
> +           s->cfg_ptr->ext_zvkb == true;
> +}
> +
> +static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
> +{
> +    return zvkb_vv_check(s, a) && s->sew == MO_64;
> +}
> +
> +GEN_VV_MASKED_TRANS(vclmul_vv, vclmul_vv_check)
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index ba25164d74..5313b01e5f 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -15,10 +15,12 @@ riscv_ss.add(files(
>    'gdbstub.c',
>    'op_helper.c',
>    'vector_helper.c',
> +  'vector_internals.c',
>    'bitmanip_helper.c',
>    'translate.c',
>    'm128_helper.c',
> -  'crypto_helper.c'
> +  'crypto_helper.c',
> +  'vcrypto_helper.c'
>  ))
>  riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
>
> diff --git a/target/riscv/translate.c b/target/riscv/translate.c
> index df38db7553..71684c10f3 100644
> --- a/target/riscv/translate.c
> +++ b/target/riscv/translate.c
> @@ -1063,6 +1063,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
>  #include "insn_trans/trans_rvzawrs.c.inc"
>  #include "insn_trans/trans_rvzfh.c.inc"
>  #include "insn_trans/trans_rvk.c.inc"
> +#include "insn_trans/trans_rvzvkb.c.inc"
>  #include "insn_trans/trans_privileged.c.inc"
>  #include "insn_trans/trans_svinval.c.inc"
>  #include "insn_trans/trans_xventanacondops.c.inc"
> diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
> new file mode 100644
> index 0000000000..8a11e56754
> --- /dev/null
> +++ b/target/riscv/vcrypto_helper.c
> @@ -0,0 +1,23 @@
> +#include "qemu/osdep.h"
> +#include "qemu/host-utils.h"
> +#include "qemu/bitops.h"
> +#include "cpu.h"
> +#include "exec/memop.h"
> +#include "exec/exec-all.h"
> +#include "exec/helper-proto.h"
> +#include "tcg/tcg-gvec-desc.h"
> +#include "internals.h"
> +#include "vector_internals.h"
> +
> +static void do_vclmul_vv(void *vd, void *vs1, void *vs2, int i)
> +{
> +    uint64_t result = 0;
> +    for (int j = 63; j >= 0; j--) {
> +        if ((((uint64_t *)vs1)[i] >> j) & 1) {

Why reverse the order we evaluate the bits here?
The spec has:

foreach (i from 0 to (width - 1)) {
      if y[i] == 1 then result = result ^ (x << i);
}

> +            result ^= (((uint64_t *)vs2)[i] << j);
> +        }
> +    }
> +    ((uint64_t *)vd)[i] = result;
> +}
> +
> +GEN_VEXT_VV(vclmul_vv, 8)

This should go through the RVVCALL macro (may need refactoring into a
different header file) from vector_helper.c.
You could then easily (and without the gratuitous casting and repeated
array-accesses) express this as:

/* vclmul.vv */
static uint64_t clmul64(uint64_t x, uint64_t y)
{
    target_ulong result = 0;
    const unsigned int elem_width = 64;

    for (unsigned int i = 0; i < elem_width; ++i)
        if ((y >> i) & 1)
            result ^= (x << i);

    return result;
}

RVVCALL(OPIVV2, vclmul_vv_d, OP_UUU_D, H8, H8, H8, clmul64)
GEN_VEXT_VV(vclmul_vv_d, 8)

> diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
> index 00de879787..def1b21414 100644
> --- a/target/riscv/vector_helper.c
> +++ b/target/riscv/vector_helper.c
> @@ -26,6 +26,7 @@
>  #include "fpu/softfloat.h"
>  #include "tcg/tcg-gvec-desc.h"
>  #include "internals.h"
> +#include "vector_internals.h"
>  #include <math.h>
>
>  target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
> @@ -95,48 +96,6 @@ target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
>  #define H8(x)   (x)
>  #endif
>
> -static inline uint32_t vext_nf(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, NF);
> -}
> -
> -static inline uint32_t vext_vm(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VM);
> -}
> -
> -/*
> - * Encode LMUL to lmul as following:
> - *     LMUL    vlmul    lmul
> - *      1       000       0
> - *      2       001       1
> - *      4       010       2
> - *      8       011       3
> - *      -       100       -
> - *     1/8      101      -3
> - *     1/4      110      -2
> - *     1/2      111      -1
> - */
> -static inline int32_t vext_lmul(uint32_t desc)
> -{
> -    return sextract32(FIELD_EX32(simd_data(desc), VDATA, LMUL), 0, 3);
> -}
> -
> -static inline uint32_t vext_vta(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VTA);
> -}
> -
> -static inline uint32_t vext_vma(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VMA);
> -}
> -
> -static inline uint32_t vext_vta_all_1s(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VTA_ALL_1S);
> -}
> -

Please refactor in a standalone patch in the series.

>  /*
>   * Get the maximum number of elements can be operated.
>   *
> @@ -155,21 +114,6 @@ static inline uint32_t vext_max_elems(uint32_t desc, uint32_t log2_esz)
>      return scale < 0 ? vlenb >> -scale : vlenb << scale;
>  }
>
> -/*
> - * Get number of total elements, including prestart, body and tail elements.
> - * Note that when LMUL < 1, the tail includes the elements past VLMAX that
> - * are held in the same vector register.
> - */
> -static inline uint32_t vext_get_total_elems(CPURISCVState *env, uint32_t desc,
> -                                            uint32_t esz)
> -{
> -    uint32_t vlenb = simd_maxsz(desc);
> -    uint32_t sew = 1 << FIELD_EX64(env->vtype, VTYPE, VSEW);
> -    int8_t emul = ctzl(esz) - ctzl(sew) + vext_lmul(desc) < 0 ? 0 :
> -                  ctzl(esz) - ctzl(sew) + vext_lmul(desc);
> -    return (vlenb << emul) / esz;
> -}
> -
>  static inline target_ulong adjust_addr(CPURISCVState *env, target_ulong addr)
>  {
>      return (addr & env->cur_pmmask) | env->cur_pmbase;
> @@ -202,20 +146,6 @@ static void probe_pages(CPURISCVState *env, target_ulong addr,
>      }
>  }
>
> -/* set agnostic elements to 1s */
> -static void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
> -                              uint32_t tot)
> -{
> -    if (is_agnostic == 0) {
> -        /* policy undisturbed */
> -        return;
> -    }
> -    if (tot - cnt == 0) {
> -        return;
> -    }
> -    memset(base + cnt, -1, tot - cnt);
> -}
> -
>  static inline void vext_set_elem_mask(void *v0, int index,
>                                        uint8_t value)
>  {
> @@ -225,18 +155,6 @@ static inline void vext_set_elem_mask(void *v0, int index,
>      ((uint64_t *)v0)[idx] = deposit64(old, pos, 1, value);
>  }
>
> -/*
> - * Earlier designs (pre-0.9) had a varying number of bits
> - * per mask value (MLEN). In the 0.9 design, MLEN=1.
> - * (Section 4.5)
> - */
> -static inline int vext_elem_mask(void *v0, int index)
> -{
> -    int idx = index / 64;
> -    int pos = index  % 64;
> -    return (((uint64_t *)v0)[idx] >> pos) & 1;
> -}
> -
>  /* elements operations for load and store */
>  typedef void vext_ldst_elem_fn(CPURISCVState *env, target_ulong addr,
>                                 uint32_t idx, void *vd, uintptr_t retaddr);
> @@ -800,8 +718,6 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
>  #define NOP_UUU_H uint16_t, uint16_t, uint32_t, uint16_t, uint32_t
>  #define NOP_UUU_W uint32_t, uint32_t, uint64_t, uint32_t, uint64_t
>
> -/* operation of two vector elements */
> -typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
>
>  #define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
>  static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
> @@ -822,40 +738,6 @@ RVVCALL(OPIVV2, vsub_vv_h, OP_SSS_H, H2, H2, H2, DO_SUB)
>  RVVCALL(OPIVV2, vsub_vv_w, OP_SSS_W, H4, H4, H4, DO_SUB)
>  RVVCALL(OPIVV2, vsub_vv_d, OP_SSS_D, H8, H8, H8, DO_SUB)
>
> -static void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
> -                       CPURISCVState *env, uint32_t desc,
> -                       opivv2_fn *fn, uint32_t esz)
> -{
> -    uint32_t vm = vext_vm(desc);
> -    uint32_t vl = env->vl;
> -    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
> -    uint32_t vta = vext_vta(desc);
> -    uint32_t vma = vext_vma(desc);
> -    uint32_t i;
> -
> -    for (i = env->vstart; i < vl; i++) {
> -        if (!vm && !vext_elem_mask(v0, i)) {
> -            /* set masked-off elements to 1s */
> -            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
> -            continue;
> -        }
> -        fn(vd, vs1, vs2, i);
> -    }
> -    env->vstart = 0;
> -    /* set tail elements to 1s */
> -    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
> -}
> -
> -/* generate the helpers for OPIVV */
> -#define GEN_VEXT_VV(NAME, ESZ)                            \
> -void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
> -                  void *vs2, CPURISCVState *env,          \
> -                  uint32_t desc)                          \
> -{                                                         \
> -    do_vext_vv(vd, v0, vs1, vs2, env, desc,               \
> -               do_##NAME, ESZ);                           \
> -}
> -
>  GEN_VEXT_VV(vadd_vv_b, 1)
>  GEN_VEXT_VV(vadd_vv_h, 2)
>  GEN_VEXT_VV(vadd_vv_w, 4)
> diff --git a/target/riscv/vector_internals.c b/target/riscv/vector_internals.c
> new file mode 100644
> index 0000000000..a264797882
> --- /dev/null
> +++ b/target/riscv/vector_internals.c
> @@ -0,0 +1,39 @@
> +#include "vector_internals.h"
> +
> +/* set agnostic elements to 1s */
> +void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
> +                       uint32_t tot)
> +{
> +    if (is_agnostic == 0) {
> +        /* policy undisturbed */
> +        return;
> +    }
> +    if (tot - cnt == 0) {
> +        return ;
> +    }
> +    memset(base + cnt, -1, tot - cnt);
> +}
> +
> +void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
> +                CPURISCVState *env, uint32_t desc,
> +                opivv2_fn *fn, uint32_t esz)
> +{
> +    uint32_t vm = vext_vm(desc);
> +    uint32_t vl = env->vl;
> +    uint32_t total_elems = vext_get_total_elems(env, desc, esz);
> +    uint32_t vta = vext_vta(desc);
> +    uint32_t vma = vext_vma(desc);
> +    uint32_t i;
> +
> +    for (i = env->vstart; i < vl; i++) {
> +        if (!vm && !vext_elem_mask(v0, i)) {
> +            /* set masked-off elements to 1s */
> +            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
> +            continue;
> +        }
> +        fn(vd, vs1, vs2, i);
> +    }
> +    env->vstart = 0;
> +    /* set tail elements to 1s */
> +    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
> +}
> diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
> new file mode 100644
> index 0000000000..f61803acc0
> --- /dev/null
> +++ b/target/riscv/vector_internals.h
> @@ -0,0 +1,116 @@
> +/*
> + * RISC-V Vector Extension Internals
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2 or later, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef TARGET_RISCV_VECTOR_INTERNAL_H
> +#define TARGET_RISCV_VECTOR_INTERNAL_H
> +
> +#include "qemu/osdep.h"
> +#include "qemu/bitops.h"
> +#include "cpu.h"
> +#include "tcg/tcg-gvec-desc.h"
> +#include "internals.h"
> +
> +static inline uint32_t vext_nf(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, NF);
> +}
> +
> +/*
> + * Encode LMUL to lmul as following:
> + *     LMUL    vlmul    lmul
> + *      1       000       0
> + *      2       001       1
> + *      4       010       2
> + *      8       011       3
> + *      -       100       -
> + *     1/8      101      -3
> + *     1/4      110      -2
> + *     1/2      111      -1
> + */
> +static inline int32_t vext_lmul(uint32_t desc)
> +{
> +    return sextract32(FIELD_EX32(simd_data(desc), VDATA, LMUL), 0, 3);
> +}
> +
> +static inline uint32_t vext_vm(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VM);
> +}
> +
> +static inline uint32_t vext_vma(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VMA);
> +}
> +
> +static inline uint32_t vext_vta(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VTA);
> +}
> +
> +static inline uint32_t vext_vta_all_1s(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VTA_ALL_1S);
> +}
> +
> +/*
> + * Earlier designs (pre-0.9) had a varying number of bits
> + * per mask value (MLEN). In the 0.9 design, MLEN=1.
> + * (Section 4.5)
> + */
> +static inline int vext_elem_mask(void *v0, int index)
> +{
> +    int idx = index / 64;
> +    int pos = index  % 64;
> +    return (((uint64_t *)v0)[idx] >> pos) & 1;
> +}
> +
> +/*
> + * Get number of total elements, including prestart, body and tail elements.
> + * Note that when LMUL < 1, the tail includes the elements past VLMAX that
> + * are held in the same vector register.
> + */
> +static inline uint32_t vext_get_total_elems(CPURISCVState *env, uint32_t desc,
> +                                            uint32_t esz)
> +{
> +    uint32_t vlenb = simd_maxsz(desc);
> +    uint32_t sew = 1 << FIELD_EX64(env->vtype, VTYPE, VSEW);
> +    int8_t emul = ctzl(esz) - ctzl(sew) + vext_lmul(desc) < 0 ? 0 :
> +                  ctzl(esz) - ctzl(sew) + vext_lmul(desc);
> +    return (vlenb << emul) / esz;
> +}
> +
> +/* set agnostic elements to 1s */
> +void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
> +                       uint32_t tot);
> +
> +/* operation of two vector elements */
> +typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
> +
> +void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
> +                CPURISCVState *env, uint32_t desc,
> +                opivv2_fn *fn, uint32_t esz);
> +
> +/* generate the helpers for OPIVV */
> +#define GEN_VEXT_VV(NAME, ESZ)                            \
> +void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
> +                  void *vs2, CPURISCVState *env,          \
> +                  uint32_t desc)                          \
> +{                                                         \
> +    do_vext_vv(vd, v0, vs1, vs2, env, desc,               \
> +               do_##NAME, ESZ);                           \
> +}
> +
> +#endif /* TARGET_RISCV_VECTOR_INTERNAL_H */

Again: please split the refactoring off into a separate patch.


> --
> 2.39.1
>
