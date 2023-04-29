Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA0D6F2220
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 03:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347241AbjD2Bgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 21:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjD2Bgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 21:36:47 -0400
Received: from cstnet.cn (smtp80.cstnet.cn [159.226.251.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B4822134
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 18:36:44 -0700 (PDT)
Received: from [192.168.0.120] (unknown [61.165.33.195])
        by APP-01 (Coremail) with SMTP id qwCowACXd4APc0xki0KeDA--.14011S2;
        Sat, 29 Apr 2023 09:29:51 +0800 (CST)
Message-ID: <e641970b-ec32-2037-c7ea-92ce48841d4e@iscas.ac.cn>
Date:   Sat, 29 Apr 2023 09:29:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 01/19] target/riscv: Refactor some of the generic
 vector functionality
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org,
        liweiwei@iscas.ac.cn
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
 <20230428144757.57530-2-lawrence.hunter@codethink.co.uk>
From:   Weiwei Li <liweiwei@iscas.ac.cn>
In-Reply-To: <20230428144757.57530-2-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: qwCowACXd4APc0xki0KeDA--.14011S2
X-Coremail-Antispam: 1UD129KBjvAXoWfJrWUKF1xuw48GFyfXFyUGFg_yoW8Cr4xWo
        Z3Jw4Svr48Xw1fur98Wr1xXFy2qFWjvw4UJF4UGrWqg3WfKF4YkrWUKws7AF43Jw4Y9F1U
        Xas2ya1xAa92krZ8n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYd7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
        JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8JV
        W8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JULyCJUUUUU=
X-Originating-IP: [61.165.33.195]
X-CM-SenderInfo: 5olzvxxzhlqxpvfd2hldfou0/
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2023/4/28 22:47, Lawrence Hunter wrote:
> From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
>
> Take some functions/macros out of `vector_helper` and put them in a new
> module called `vector_internals`. This ensures they can be used by both
> vector and vector-crypto helpers (latter implemented in proceeding
> commits).
>
> Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> ---

Reviewed-by: Weiwei Li <liweiwei@iscas.ac.cn>

Weiwei Li

>   target/riscv/meson.build        |   1 +
>   target/riscv/vector_helper.c    | 201 +-------------------------------
>   target/riscv/vector_internals.c |  81 +++++++++++++
>   target/riscv/vector_internals.h | 182 +++++++++++++++++++++++++++++
>   4 files changed, 265 insertions(+), 200 deletions(-)
>   create mode 100644 target/riscv/vector_internals.c
>   create mode 100644 target/riscv/vector_internals.h
>
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index 5dee37a242f..a94fc3f5982 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -16,6 +16,7 @@ riscv_ss.add(files(
>     'gdbstub.c',
>     'op_helper.c',
>     'vector_helper.c',
> +  'vector_internals.c',
>     'bitmanip_helper.c',
>     'translate.c',
>     'm128_helper.c',
> diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
> index 2423affe37f..27fefef10ec 100644
> --- a/target/riscv/vector_helper.c
> +++ b/target/riscv/vector_helper.c
> @@ -26,6 +26,7 @@
>   #include "fpu/softfloat.h"
>   #include "tcg/tcg-gvec-desc.h"
>   #include "internals.h"
> +#include "vector_internals.h"
>   #include <math.h>
>   
>   target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
> @@ -75,68 +76,6 @@ target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
>       return vl;
>   }
>   
> -/*
> - * Note that vector data is stored in host-endian 64-bit chunks,
> - * so addressing units smaller than that needs a host-endian fixup.
> - */
> -#if HOST_BIG_ENDIAN
> -#define H1(x)   ((x) ^ 7)
> -#define H1_2(x) ((x) ^ 6)
> -#define H1_4(x) ((x) ^ 4)
> -#define H2(x)   ((x) ^ 3)
> -#define H4(x)   ((x) ^ 1)
> -#define H8(x)   ((x))
> -#else
> -#define H1(x)   (x)
> -#define H1_2(x) (x)
> -#define H1_4(x) (x)
> -#define H2(x)   (x)
> -#define H4(x)   (x)
> -#define H8(x)   (x)
> -#endif
> -
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
>   /*
>    * Get the maximum number of elements can be operated.
>    *
> @@ -155,21 +94,6 @@ static inline uint32_t vext_max_elems(uint32_t desc, uint32_t log2_esz)
>       return scale < 0 ? vlenb >> -scale : vlenb << scale;
>   }
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
>   static inline target_ulong adjust_addr(CPURISCVState *env, target_ulong addr)
>   {
>       return (addr & env->cur_pmmask) | env->cur_pmbase;
> @@ -202,20 +126,6 @@ static void probe_pages(CPURISCVState *env, target_ulong addr,
>       }
>   }
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
>   static inline void vext_set_elem_mask(void *v0, int index,
>                                         uint8_t value)
>   {
> @@ -225,18 +135,6 @@ static inline void vext_set_elem_mask(void *v0, int index,
>       ((uint64_t *)v0)[idx] = deposit64(old, pos, 1, value);
>   }
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
>   /* elements operations for load and store */
>   typedef void vext_ldst_elem_fn(CPURISCVState *env, target_ulong addr,
>                                  uint32_t idx, void *vd, uintptr_t retaddr);
> @@ -739,18 +637,11 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
>    *** Vector Integer Arithmetic Instructions
>    */
>   
> -/* expand macro args before macro */
> -#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
> -
>   /* (TD, T1, T2, TX1, TX2) */
>   #define OP_SSS_B int8_t, int8_t, int8_t, int8_t, int8_t
>   #define OP_SSS_H int16_t, int16_t, int16_t, int16_t, int16_t
>   #define OP_SSS_W int32_t, int32_t, int32_t, int32_t, int32_t
>   #define OP_SSS_D int64_t, int64_t, int64_t, int64_t, int64_t
> -#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
> -#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
> -#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
> -#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
>   #define OP_SUS_B int8_t, uint8_t, int8_t, uint8_t, int8_t
>   #define OP_SUS_H int16_t, uint16_t, int16_t, uint16_t, int16_t
>   #define OP_SUS_W int32_t, uint32_t, int32_t, uint32_t, int32_t
> @@ -774,16 +665,6 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
>   #define NOP_UUU_H uint16_t, uint16_t, uint32_t, uint16_t, uint32_t
>   #define NOP_UUU_W uint32_t, uint32_t, uint64_t, uint32_t, uint64_t
>   
> -/* operation of two vector elements */
> -typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
> -
> -#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
> -static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
> -{                                                               \
> -    TX1 s1 = *((T1 *)vs1 + HS1(i));                             \
> -    TX2 s2 = *((T2 *)vs2 + HS2(i));                             \
> -    *((TD *)vd + HD(i)) = OP(s2, s1);                           \
> -}
>   #define DO_SUB(N, M) (N - M)
>   #define DO_RSUB(N, M) (M - N)
>   
> @@ -796,40 +677,6 @@ RVVCALL(OPIVV2, vsub_vv_h, OP_SSS_H, H2, H2, H2, DO_SUB)
>   RVVCALL(OPIVV2, vsub_vv_w, OP_SSS_W, H4, H4, H4, DO_SUB)
>   RVVCALL(OPIVV2, vsub_vv_d, OP_SSS_D, H8, H8, H8, DO_SUB)
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
>   GEN_VEXT_VV(vadd_vv_b, 1)
>   GEN_VEXT_VV(vadd_vv_h, 2)
>   GEN_VEXT_VV(vadd_vv_w, 4)
> @@ -839,18 +686,6 @@ GEN_VEXT_VV(vsub_vv_h, 2)
>   GEN_VEXT_VV(vsub_vv_w, 4)
>   GEN_VEXT_VV(vsub_vv_d, 8)
>   
> -typedef void opivx2_fn(void *vd, target_long s1, void *vs2, int i);
> -
> -/*
> - * (T1)s1 gives the real operator type.
> - * (TX1)(T1)s1 expands the operator type of widen or narrow operations.
> - */
> -#define OPIVX2(NAME, TD, T1, T2, TX1, TX2, HD, HS2, OP)             \
> -static void do_##NAME(void *vd, target_long s1, void *vs2, int i)   \
> -{                                                                   \
> -    TX2 s2 = *((T2 *)vs2 + HS2(i));                                 \
> -    *((TD *)vd + HD(i)) = OP(s2, (TX1)(T1)s1);                      \
> -}
>   
>   RVVCALL(OPIVX2, vadd_vx_b, OP_SSS_B, H1, H1, DO_ADD)
>   RVVCALL(OPIVX2, vadd_vx_h, OP_SSS_H, H2, H2, DO_ADD)
> @@ -865,40 +700,6 @@ RVVCALL(OPIVX2, vrsub_vx_h, OP_SSS_H, H2, H2, DO_RSUB)
>   RVVCALL(OPIVX2, vrsub_vx_w, OP_SSS_W, H4, H4, DO_RSUB)
>   RVVCALL(OPIVX2, vrsub_vx_d, OP_SSS_D, H8, H8, DO_RSUB)
>   
> -static void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
> -                       CPURISCVState *env, uint32_t desc,
> -                       opivx2_fn fn, uint32_t esz)
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
> -        fn(vd, s1, vs2, i);
> -    }
> -    env->vstart = 0;
> -    /* set tail elements to 1s */
> -    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
> -}
> -
> -/* generate the helpers for OPIVX */
> -#define GEN_VEXT_VX(NAME, ESZ)                            \
> -void HELPER(NAME)(void *vd, void *v0, target_ulong s1,    \
> -                  void *vs2, CPURISCVState *env,          \
> -                  uint32_t desc)                          \
> -{                                                         \
> -    do_vext_vx(vd, v0, s1, vs2, env, desc,                \
> -               do_##NAME, ESZ);                           \
> -}
> -
>   GEN_VEXT_VX(vadd_vx_b, 1)
>   GEN_VEXT_VX(vadd_vx_h, 2)
>   GEN_VEXT_VX(vadd_vx_w, 4)
> diff --git a/target/riscv/vector_internals.c b/target/riscv/vector_internals.c
> new file mode 100644
> index 00000000000..9cf5c17cdea
> --- /dev/null
> +++ b/target/riscv/vector_internals.c
> @@ -0,0 +1,81 @@
> +/*
> + * RISC-V Vector Extension Internals
> + *
> + * Copyright (c) 2020 T-Head Semiconductor Co., Ltd. All rights reserved.
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
> +
> +void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
> +                CPURISCVState *env, uint32_t desc,
> +                opivx2_fn fn, uint32_t esz)
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
> +        fn(vd, s1, vs2, i);
> +    }
> +    env->vstart = 0;
> +    /* set tail elements to 1s */
> +    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
> +}
> diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
> new file mode 100644
> index 00000000000..749d138bebe
> --- /dev/null
> +++ b/target/riscv/vector_internals.h
> @@ -0,0 +1,182 @@
> +/*
> + * RISC-V Vector Extension Internals
> + *
> + * Copyright (c) 2020 T-Head Semiconductor Co., Ltd. All rights reserved.
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
> +#ifndef TARGET_RISCV_VECTOR_INTERNALS_H
> +#define TARGET_RISCV_VECTOR_INTERNALS_H
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
> + * Note that vector data is stored in host-endian 64-bit chunks,
> + * so addressing units smaller than that needs a host-endian fixup.
> + */
> +#if HOST_BIG_ENDIAN
> +#define H1(x)   ((x) ^ 7)
> +#define H1_2(x) ((x) ^ 6)
> +#define H1_4(x) ((x) ^ 4)
> +#define H2(x)   ((x) ^ 3)
> +#define H4(x)   ((x) ^ 1)
> +#define H8(x)   ((x))
> +#else
> +#define H1(x)   (x)
> +#define H1_2(x) (x)
> +#define H1_4(x) (x)
> +#define H2(x)   (x)
> +#define H4(x)   (x)
> +#define H8(x)   (x)
> +#endif
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
> +/* expand macro args before macro */
> +#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
> +
> +/* (TD, T1, T2, TX1, TX2) */
> +#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
> +#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
> +#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
> +#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
> +
> +/* operation of two vector elements */
> +typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
> +
> +#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
> +static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
> +{                                                               \
> +    TX1 s1 = *((T1 *)vs1 + HS1(i));                             \
> +    TX2 s2 = *((T2 *)vs2 + HS2(i));                             \
> +    *((TD *)vd + HD(i)) = OP(s2, s1);                           \
> +}
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
> +typedef void opivx2_fn(void *vd, target_long s1, void *vs2, int i);
> +
> +/*
> + * (T1)s1 gives the real operator type.
> + * (TX1)(T1)s1 expands the operator type of widen or narrow operations.
> + */
> +#define OPIVX2(NAME, TD, T1, T2, TX1, TX2, HD, HS2, OP)             \
> +static void do_##NAME(void *vd, target_long s1, void *vs2, int i)   \
> +{                                                                   \
> +    TX2 s2 = *((T2 *)vs2 + HS2(i));                                 \
> +    *((TD *)vd + HD(i)) = OP(s2, (TX1)(T1)s1);                      \
> +}
> +
> +void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
> +                CPURISCVState *env, uint32_t desc,
> +                opivx2_fn fn, uint32_t esz);
> +
> +/* generate the helpers for OPIVX */
> +#define GEN_VEXT_VX(NAME, ESZ)                            \
> +void HELPER(NAME)(void *vd, void *v0, target_ulong s1,    \
> +                  void *vs2, CPURISCVState *env,          \
> +                  uint32_t desc)                          \
> +{                                                         \
> +    do_vext_vx(vd, v0, s1, vs2, env, desc,                \
> +               do_##NAME, ESZ);                           \
> +}
> +
> +#endif /* TARGET_RISCV_VECTOR_INTERNALS_H */

