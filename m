Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9256F2217
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 03:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347272AbjD2Bbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 21:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjD2Bbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 21:31:53 -0400
X-Greylist: delayed 104 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Apr 2023 18:31:50 PDT
Received: from cstnet.cn (smtp80.cstnet.cn [159.226.251.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A10810F9
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 18:31:50 -0700 (PDT)
Received: from [192.168.0.120] (unknown [61.165.33.195])
        by APP-01 (Coremail) with SMTP id qwCowACXn3t6c0xkRm6eDA--.9836S2;
        Sat, 29 Apr 2023 09:31:39 +0800 (CST)
Message-ID: <e32ff194-cca3-75c5-4847-d14634090917@iscas.ac.cn>
Date:   Sat, 29 Apr 2023 09:31:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 02/19] target/riscv: Refactor vector-vector translation
 macro
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
 <20230428144757.57530-3-lawrence.hunter@codethink.co.uk>
From:   Weiwei Li <liweiwei@iscas.ac.cn>
In-Reply-To: <20230428144757.57530-3-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: qwCowACXn3t6c0xkRm6eDA--.9836S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWfuryUJF43Zry3Kr1UAwb_yoW5KF1xpF
        1rKrW5XrWDJ3WfA3yFqr4UArsIvFs5uw1Y9ws7tws5urWDGr4DZFWDtr4093y2yrs3WF10
        y3W7AFy3uasIyaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
        4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVWkMxAIw28IcxkI7VAKI48JMx
        C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
        wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
        vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
        0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
        W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbNzVUUUUUU==
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
> Refactor the non SEW-specific stuff out of `GEN_OPIVV_TRANS` into
> function `opivv_trans` (similar to `opivi_trans`). `opivv_trans` will be
> used in proceeding vector-crypto commits.
>
> Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
> ---

Reviewed-by: Weiwei Li <liweiwei@iscas.ac.cn>

Weiwei Li

>   target/riscv/insn_trans/trans_rvv.c.inc | 62 +++++++++++++------------
>   1 file changed, 32 insertions(+), 30 deletions(-)
>
> diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
> index f2e3d385152..4106bd69949 100644
> --- a/target/riscv/insn_trans/trans_rvv.c.inc
> +++ b/target/riscv/insn_trans/trans_rvv.c.inc
> @@ -1643,38 +1643,40 @@ GEN_OPIWX_WIDEN_TRANS(vwadd_wx)
>   GEN_OPIWX_WIDEN_TRANS(vwsubu_wx)
>   GEN_OPIWX_WIDEN_TRANS(vwsub_wx)
>   
> +static bool opivv_trans(uint32_t vd, uint32_t vs1, uint32_t vs2, uint32_t vm,
> +                        gen_helper_gvec_4_ptr *fn, DisasContext *s)
> +{
> +    uint32_t data = 0;
> +    TCGLabel *over = gen_new_label();
> +    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
> +    tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
> +
> +    data = FIELD_DP32(data, VDATA, VM, vm);
> +    data = FIELD_DP32(data, VDATA, LMUL, s->lmul);
> +    data = FIELD_DP32(data, VDATA, VTA, s->vta);
> +    data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);
> +    data = FIELD_DP32(data, VDATA, VMA, s->vma);
> +    tcg_gen_gvec_4_ptr(vreg_ofs(s, vd), vreg_ofs(s, 0), vreg_ofs(s, vs1),
> +                       vreg_ofs(s, vs2), cpu_env, s->cfg_ptr->vlen / 8,
> +                       s->cfg_ptr->vlen / 8, data, fn);
> +    mark_vs_dirty(s);
> +    gen_set_label(over);
> +    return true;
> +}
> +
>   /* Vector Integer Add-with-Carry / Subtract-with-Borrow Instructions */
>   /* OPIVV without GVEC IR */
> -#define GEN_OPIVV_TRANS(NAME, CHECK)                               \
> -static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
> -{                                                                  \
> -    if (CHECK(s, a)) {                                             \
> -        uint32_t data = 0;                                         \
> -        static gen_helper_gvec_4_ptr * const fns[4] = {            \
> -            gen_helper_##NAME##_b, gen_helper_##NAME##_h,          \
> -            gen_helper_##NAME##_w, gen_helper_##NAME##_d,          \
> -        };                                                         \
> -        TCGLabel *over = gen_new_label();                          \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
> -        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
> -                                                                   \
> -        data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> -        data = FIELD_DP32(data, VDATA, LMUL, s->lmul);             \
> -        data = FIELD_DP32(data, VDATA, VTA, s->vta);               \
> -        data =                                                     \
> -            FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);\
> -        data = FIELD_DP32(data, VDATA, VMA, s->vma);               \
> -        tcg_gen_gvec_4_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, 0),     \
> -                           vreg_ofs(s, a->rs1),                    \
> -                           vreg_ofs(s, a->rs2), cpu_env,           \
> -                           s->cfg_ptr->vlen / 8,                   \
> -                           s->cfg_ptr->vlen / 8, data,             \
> -                           fns[s->sew]);                           \
> -        mark_vs_dirty(s);                                          \
> -        gen_set_label(over);                                       \
> -        return true;                                               \
> -    }                                                              \
> -    return false;                                                  \
> +#define GEN_OPIVV_TRANS(NAME, CHECK)                                     \
> +static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                   \
> +{                                                                        \
> +    if (CHECK(s, a)) {                                                   \
> +        static gen_helper_gvec_4_ptr * const fns[4] = {                  \
> +            gen_helper_##NAME##_b, gen_helper_##NAME##_h,                \
> +            gen_helper_##NAME##_w, gen_helper_##NAME##_d,                \
> +        };                                                               \
> +        return opivv_trans(a->rd, a->rs1, a->rs2, a->vm, fns[s->sew], s);\
> +    }                                                                    \
> +    return false;                                                        \
>   }
>   
>   /*

