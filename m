Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC34687FD0
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjBBOV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjBBOV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:21:57 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5218890392
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:21:52 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id mf7so6385168ejc.6
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PkD2MQwZZ/HPGzVEk3tkKfeG5TRns7YUxQTD9N5rtgc=;
        b=OObrxQ22U0CnhivQFkihbLNQWydQTSsjpACydDlOsuFz8B46YmGdK/i9oTTEJVxGaj
         Psg8wL3pd6vyUbOiLgceJEVTof72aFq25J29Zn3LhWH6ZEXMTDBkuIaiaHiP2e887jId
         tPOtqt52QZHyLU/19AUNbpHY3e8BsvfdA/e4zpDQDdZkqYQM6JGmNl1XaTkHqs/+MMj2
         RWF3tZAA/IbwcuAzYgNpuoEbEqJHCPVw50tckQgBGH+965MSYVLRoDHdRmoS/TgM/i30
         vaMxG+kRlZoS+yI3Z5j9jvPLSx1uXKsvuRnT9bBBeLj/g4BqSTiIpkIYqBdw3k4OCOmT
         62mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PkD2MQwZZ/HPGzVEk3tkKfeG5TRns7YUxQTD9N5rtgc=;
        b=inCwC5O9+NVi6Q/pIu+w/CrhKCS83HK2WTumDg51qHn1i5ojxcv+tMUqiZx6AIocMU
         h9WRXqNYzQmdu2rWtIyKdaczbYnQ4P9DgSwr20iURGZkDziia5j79d0wArl702yoqXkP
         P9TlrLyneOW5kAGyxx7GC1C/wuf7/9w7Ao3uiYpqDZphRw8MhRPXqfQVXA+Dtlrh3MNp
         JX5My6/dqb2NnnEijM86kUFmR0++yY4ANcN/AeU7RjnN5L2ZjFtugVmSVNcmqoZNAeWj
         FT6vTXcqszEAFzqkugcA4LU+oAWYtZTwR6fZ06V8XwQjntuLO73mJBn41s7lgI5lkk3g
         GfwQ==
X-Gm-Message-State: AO0yUKU6lkbMHtG0qHDKHy4wPu1wRMIqlHqG/L5btUChJo7HrvXA2T79
        KXk1D3lvg6TSApP5IQZID4jwKT39tGaP+//EtrrJ7/5o1d4IoG8y
X-Google-Smtp-Source: AK7set9OecVq2Dg9ShjDFMFWBOhLTek0Exr8OefdPduAgMA7n+We1BJgPb+2FWUN2ReB4McNhm+v2mrytq4t5zTO0mc=
X-Received: by 2002:a17:906:71d3:b0:84d:28da:f3a with SMTP id
 i19-20020a17090671d300b0084d28da0f3amr1802532ejk.76.1675347711395; Thu, 02
 Feb 2023 06:21:51 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk> <20230202124230.295997-8-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230202124230.295997-8-lawrence.hunter@codethink.co.uk>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 15:21:40 +0100
Message-ID: <CAAeLtUD1YXcAb3e3Ht-3_-53_ehxpXCkEQSDauUsN4pJMuYmig@mail.gmail.com>
Subject: Re: [PATCH 07/39] target/riscv: Add vbrev8.v decoding, translation
 and execution support
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        William Salmon <will.salmon@codethink.co.uk>
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
> From: William Salmon <will.salmon@codethink.co.uk>
>
> Co-authored-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> Signed-off-by: William Salmon <will.salmon@codethink.co.uk>
> ---
>  include/qemu/bitops.h                      | 32 +++++++++++++++++
>  target/riscv/helper.h                      |  5 +++
>  target/riscv/insn32.decode                 |  1 +
>  target/riscv/insn_trans/trans_rvzvkb.c.inc | 39 ++++++++++++++++++++
>  target/riscv/vcrypto_helper.c              | 10 ++++++
>  target/riscv/vector_helper.c               | 41 ---------------------
>  target/riscv/vector_internals.h            | 42 ++++++++++++++++++++++
>  7 files changed, 129 insertions(+), 41 deletions(-)
>
> diff --git a/include/qemu/bitops.h b/include/qemu/bitops.h
> index 03213ce952..dfce1cb10c 100644
> --- a/include/qemu/bitops.h
> +++ b/include/qemu/bitops.h
> @@ -618,4 +618,36 @@ static inline uint64_t half_unshuffle64(uint64_t x)
>      return x;
>  }
>
> +static inline uint8_t reverse_bits_byte(uint8_t x)
> +{
> +    x = (((x & 0b10101010) >> 1) | ((x & 0b01010101) << 1));
> +    x = (((x & 0b11001100) >> 2) | ((x & 0b00110011) << 2));
> +    return ((x & 0b11110000) >> 4) | ((x & 0b00001111) << 4);
> +}
> +
> +static inline uint16_t reverse_bits_byte_2(uint16_t x)
> +{
> +    return (uint16_t)reverse_bits_byte(x & 0xFF) | \
> +       (uint16_t)reverse_bits_byte((x >> 8) & 0xFF) << 8;
> +}
> +
> +static inline uint32_t reverse_bits_byte_4(uint32_t x)
> +{
> +    return (uint32_t)reverse_bits_byte(x & 0xFF) | \
> +       (uint32_t)reverse_bits_byte((x >> 8) & 0xFF) << 8 | \
> +       (uint32_t)reverse_bits_byte((x >> 16) & 0xFF) << 16 | \
> +       (uint32_t)reverse_bits_byte((x >> 24) & 0xFF) << 24;
> +}
> +
> +static inline uint64_t reverse_bits_byte_8(uint64_t x)
> +{
> +    return (uint64_t)reverse_bits_byte(x & 0xFF) | \
> +       (uint64_t)reverse_bits_byte((x >> 8) & 0xFF) << 8 | \
> +       (uint64_t)reverse_bits_byte((x >> 16) & 0xFF) << 16 | \
> +       (uint64_t)reverse_bits_byte((x >> 24) & 0xFF) << 24 | \
> +       (uint64_t)reverse_bits_byte((x >> 32) & 0xFF) << 32 | \
> +       (uint64_t)reverse_bits_byte((x >> 40) & 0xFF) << 40 | \
> +       (uint64_t)reverse_bits_byte((x >> 48) & 0xFF) << 48 | \
> +       (uint64_t)reverse_bits_byte((x >> 56) & 0xFF) << 56;
> +}


Why split this up into individual functions?
You can do the following (OPIVV1 will take care of extending this to a
uint64_t and then truncating the result again):

/* vbrev8.v */
static uint64_t brev8(uint64_t val)
{
    val = ((val & 0x5555555555555555ull) << 1)
        | ((val & 0xAAAAAAAAAAAAAAAAull) >> 1);
    val = ((val & 0x3333333333333333ull) << 2)
        | ((val & 0xCCCCCCCCCCCCCCCCull) >> 2);
    val = ((val & 0x0F0F0F0F0F0F0F0Full) << 4)
        | ((val & 0xF0F0F0F0F0F0F0F0ull) >> 4);

    return val;
}

RVVCALL(OPIVV1, vbrev8_v_b, OP_UU_B, H1, H1, brev8)
RVVCALL(OPIVV1, vbrev8_v_h, OP_UU_H, H2, H2, brev8)
RVVCALL(OPIVV1, vbrev8_v_w, OP_UU_W, H4, H4, brev8)
RVVCALL(OPIVV1, vbrev8_v_d, OP_UU_D, H8, H8, brev8)

>
>  #endif
> diff --git a/target/riscv/helper.h b/target/riscv/helper.h
> index e5b6b3360f..c94627d8a4 100644
> --- a/target/riscv/helper.h
> +++ b/target/riscv/helper.h
> @@ -1162,3 +1162,8 @@ DEF_HELPER_6(vrol_vx_b, void, ptr, ptr, tl, ptr, env, i32)
>  DEF_HELPER_6(vrol_vx_h, void, ptr, ptr, tl, ptr, env, i32)
>  DEF_HELPER_6(vrol_vx_w, void, ptr, ptr, tl, ptr, env, i32)
>  DEF_HELPER_6(vrol_vx_d, void, ptr, ptr, tl, ptr, env, i32)
> +
> +DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_5(vbrev8_v_d, void, ptr, ptr, ptr, env, i32)
> diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
> index 725f907ad1..782632a165 100644
> --- a/target/riscv/insn32.decode
> +++ b/target/riscv/insn32.decode
> @@ -902,3 +902,4 @@ vror_vv         010100 . ..... ..... 000 ..... 1010111 @r_vm
>  vror_vx         010100 . ..... ..... 100 ..... 1010111 @r_vm
>  vror_vi         010100 . ..... ..... 011 ..... 1010111 @r_vm
>  vror_vi2        010101 . ..... ..... 011 ..... 1010111 @r_vm
> +vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
> diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> index d2a7a92d42..591980459a 100644
> --- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
> +++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> @@ -115,3 +115,42 @@ static bool trans_vror_vi2(DisasContext *s, arg_rmrr *a)
>      a->rs1 += 32;
>      return trans_vror_vi(s, a);
>  }
> +
> +#define GEN_OPIV_TRANS(NAME, CHECK)                                    \
> +static bool trans_##NAME(DisasContext *s, arg_rmr * a)                 \
> +{                                                                      \
> +    if (CHECK(s, a)) {                                                 \
> +        uint32_t data = 0;                                             \
> +        static gen_helper_gvec_3_ptr * const fns[4] = {                \
> +            gen_helper_##NAME##_b,                                     \
> +            gen_helper_##NAME##_h,                                     \
> +            gen_helper_##NAME##_w,                                     \
> +            gen_helper_##NAME##_d,                                     \
> +        };                                                             \
> +        TCGLabel *over = gen_new_label();                              \
> +        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);              \
> +        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);     \
> +                                                                       \
> +        data = FIELD_DP32(data, VDATA, VM, a->vm);                     \
> +        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                 \
> +        data = FIELD_DP32(data, VDATA, VTA, s->vta);                   \
> +        data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s); \
> +        data = FIELD_DP32(data, VDATA, VMA, s->vma);                   \
> +        tcg_gen_gvec_3_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, 0),         \
> +                           vreg_ofs(s, a->rs2), cpu_env,               \
> +                           s->cfg_ptr->vlen / 8, s->cfg_ptr->vlen / 8, \
> +                           data, fns[s->sew]);                         \
> +        mark_vs_dirty(s);                                              \
> +        gen_set_label(over);                                           \
> +        return true;                                                   \
> +    }                                                                  \
> +    return false;                                                      \
> +}
> +
> +static bool vxrev8_check(DisasContext *s, arg_rmr *a)
> +{
> +    return s->cfg_ptr->ext_zvkb == true && vext_check_isa_ill(s) &&
> +           vext_check_ss(s, a->rd, a->rs2, a->vm);
> +}
> +
> +GEN_OPIV_TRANS(vbrev8_v, vxrev8_check)
> diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
> index 7ec75c5589..303a656141 100644
> --- a/target/riscv/vcrypto_helper.c
> +++ b/target/riscv/vcrypto_helper.c
> @@ -1,6 +1,7 @@
>  #include "qemu/osdep.h"
>  #include "qemu/host-utils.h"
>  #include "qemu/bitops.h"
> +#include "qemu/bswap.h"
>  #include "cpu.h"
>  #include "exec/memop.h"
>  #include "exec/exec-all.h"
> @@ -115,3 +116,12 @@ GEN_VEXT_VX(vrol_vx_b, 1)
>  GEN_VEXT_VX(vrol_vx_h, 2)
>  GEN_VEXT_VX(vrol_vx_w, 4)
>  GEN_VEXT_VX(vrol_vx_d, 8)
> +
> +RVVCALL(OPIVV1, vbrev8_v_b, OP_UU_B, H1, H1, reverse_bits_byte)
> +RVVCALL(OPIVV1, vbrev8_v_h, OP_UU_H, H2, H2, reverse_bits_byte_2)
> +RVVCALL(OPIVV1, vbrev8_v_w, OP_UU_W, H4, H4, reverse_bits_byte_4)
> +RVVCALL(OPIVV1, vbrev8_v_d, OP_UU_D, H8, H8, reverse_bits_byte_8)

See above how a single brev8 function can be used here.

> +GEN_VEXT_V(vbrev8_v_b, 1)
> +GEN_VEXT_V(vbrev8_v_h, 2)
> +GEN_VEXT_V(vbrev8_v_w, 4)
> +GEN_VEXT_V(vbrev8_v_d, 8)
> diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
> index ff7b03cbe3..07da4b5e16 100644
> --- a/target/riscv/vector_helper.c
> +++ b/target/riscv/vector_helper.c
> @@ -3437,12 +3437,6 @@ RVVCALL(OPFVF3, vfwnmsac_vf_w, WOP_UUU_W, H8, H4, fwnmsac32)
>  GEN_VEXT_VF(vfwnmsac_vf_h, 4)
>  GEN_VEXT_VF(vfwnmsac_vf_w, 8)
>
> -/* Vector Floating-Point Square-Root Instruction */
> -/* (TD, T2, TX2) */
> -#define OP_UU_H uint16_t, uint16_t, uint16_t
> -#define OP_UU_W uint32_t, uint32_t, uint32_t
> -#define OP_UU_D uint64_t, uint64_t, uint64_t
> -
>  #define OPFVV1(NAME, TD, T2, TX2, HD, HS2, OP)        \
>  static void do_##NAME(void *vd, void *vs2, int i,      \
>          CPURISCVState *env)                            \
> @@ -4134,41 +4128,6 @@ GEN_VEXT_CMP_VF(vmfge_vf_h, uint16_t, H2, vmfge16)
>  GEN_VEXT_CMP_VF(vmfge_vf_w, uint32_t, H4, vmfge32)
>  GEN_VEXT_CMP_VF(vmfge_vf_d, uint64_t, H8, vmfge64)
>
> -/* Vector Floating-Point Classify Instruction */
> -#define OPIVV1(NAME, TD, T2, TX2, HD, HS2, OP)         \
> -static void do_##NAME(void *vd, void *vs2, int i)      \
> -{                                                      \
> -    TX2 s2 = *((T2 *)vs2 + HS2(i));                    \
> -    *((TD *)vd + HD(i)) = OP(s2);                      \
> -}
> -
> -#define GEN_VEXT_V(NAME, ESZ)                          \
> -void HELPER(NAME)(void *vd, void *v0, void *vs2,       \
> -                  CPURISCVState *env, uint32_t desc)   \
> -{                                                      \
> -    uint32_t vm = vext_vm(desc);                       \
> -    uint32_t vl = env->vl;                             \
> -    uint32_t total_elems =                             \
> -        vext_get_total_elems(env, desc, ESZ);          \
> -    uint32_t vta = vext_vta(desc);                     \
> -    uint32_t vma = vext_vma(desc);                     \
> -    uint32_t i;                                        \
> -                                                       \
> -    for (i = env->vstart; i < vl; i++) {               \
> -        if (!vm && !vext_elem_mask(v0, i)) {           \
> -            /* set masked-off elements to 1s */        \
> -            vext_set_elems_1s(vd, vma, i * ESZ,        \
> -                              (i + 1) * ESZ);          \
> -            continue;                                  \
> -        }                                              \
> -        do_##NAME(vd, vs2, i);                         \
> -    }                                                  \
> -    env->vstart = 0;                                   \
> -    /* set tail elements to 1s */                      \
> -    vext_set_elems_1s(vd, vta, vl * ESZ,               \
> -                      total_elems * ESZ);              \
> -}
> -
>  target_ulong fclass_h(uint64_t frs1)
>  {
>      float16 f = frs1;
> diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
> index a0fbac7bf3..f1f16453dc 100644
> --- a/target/riscv/vector_internals.h
> +++ b/target/riscv/vector_internals.h
> @@ -123,12 +123,54 @@ void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
>  /* expand macro args before macro */
>  #define RVVCALL(macro, ...)  macro(__VA_ARGS__)
>
> +/* Vector Floating-Point Square-Root Instruction */
> +/* (TD, T2, TX2) */
> +#define OP_UU_B uint8_t, uint8_t, uint8_t
> +#define OP_UU_H uint16_t, uint16_t, uint16_t
> +#define OP_UU_W uint32_t, uint32_t, uint32_t
> +#define OP_UU_D uint64_t, uint64_t, uint64_t
> +
>  /* (TD, T1, T2, TX1, TX2) */
>  #define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
>  #define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
>  #define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
>  #define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
>
> +/* Vector Floating-Point Classify Instruction */
> +#define OPIVV1(NAME, TD, T2, TX2, HD, HS2, OP)         \
> +static void do_##NAME(void *vd, void *vs2, int i)      \
> +{                                                      \
> +    TX2 s2 = *((T2 *)vs2 + HS2(i));                    \
> +    *((TD *)vd + HD(i)) = OP(s2);                      \
> +}
> +
> +#define GEN_VEXT_V(NAME, ESZ)                          \
> +void HELPER(NAME)(void *vd, void *v0, void *vs2,       \
> +                  CPURISCVState *env, uint32_t desc)   \
> +{                                                      \
> +    uint32_t vm = vext_vm(desc);                       \
> +    uint32_t vl = env->vl;                             \
> +    uint32_t total_elems =                             \
> +        vext_get_total_elems(env, desc, ESZ);          \
> +    uint32_t vta = vext_vta(desc);                     \
> +    uint32_t vma = vext_vma(desc);                     \
> +    uint32_t i;                                        \
> +                                                       \
> +    for (i = env->vstart; i < vl; i++) {               \
> +        if (!vm && !vext_elem_mask(v0, i)) {           \
> +            /* set masked-off elements to 1s */        \
> +            vext_set_elems_1s(vd, vma, i * ESZ,        \
> +                              (i + 1) * ESZ);          \
> +            continue;                                  \
> +        }                                              \
> +        do_##NAME(vd, vs2, i);                         \
> +    }                                                  \
> +    env->vstart = 0;                                   \
> +    /* set tail elements to 1s */                      \
> +    vext_set_elems_1s(vd, vta, vl * ESZ,               \
> +                      total_elems * ESZ);              \
> +}
> +

My usual gripe about not mixing the refactoring in with the feature
patches applies...

>  /* operation of two vector elements */
>  typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
>
> --
> 2.39.1
>
