Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6786F2291
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 05:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjD2DHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 23:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjD2DHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 23:07:16 -0400
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9FAE1B9
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 20:07:14 -0700 (PDT)
Received: from [192.168.0.120] (unknown [61.165.33.195])
        by APP-05 (Coremail) with SMTP id zQCowACHj8+_iUxkodxKGw--.49230S2;
        Sat, 29 Apr 2023 11:06:40 +0800 (CST)
Message-ID: <5f35016c-a207-22d9-f13a-ba6985d7a299@iscas.ac.cn>
Date:   Sat, 29 Apr 2023 11:06:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 06/19] target/riscv: Refactor translation of
 vector-widening instruction
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
 <20230428144757.57530-7-lawrence.hunter@codethink.co.uk>
From:   Weiwei Li <liweiwei@iscas.ac.cn>
In-Reply-To: <20230428144757.57530-7-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: zQCowACHj8+_iUxkodxKGw--.49230S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWF13ur4rtFWfCw1xuF1Utrb_yoWrXFWxpw
        1UKF4DWr1jg3WrKa18ArZ7AFnagF15WayakrWvqa1Fva4rJws09rW2qwsxKr47Kas0gw18
        Cw1rZF4xAr13JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
        n2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
        Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
        AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUShFxUUUUU=
X-Originating-IP: [61.165.33.195]
X-CM-SenderInfo: 5olzvxxzhlqxpvfd2hldfou0/
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2023/4/28 22:47, Lawrence Hunter wrote:
> From: Dickon Hood <dickon.hood@codethink.co.uk>
>
> Zvbb (implemented in later commit) has a widening instruction, which
> requires an extra check on the enabled extensions.  Refactor
> GEN_OPIVX_WIDEN_TRANS() to take a check function to avoid reimplementing
> it.
>
> Signed-off-by: Dickon Hood <dickon.hood@codethink.co.uk>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---

Reviewed-by: Weiwei Li <liweiwei@iscas.ac.cn>

Weiwei Li

>   target/riscv/insn_trans/trans_rvv.c.inc | 52 +++++++++++--------------
>   1 file changed, 23 insertions(+), 29 deletions(-)
>
> diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
> index 21731b784ec..2c2a097b76d 100644
> --- a/target/riscv/insn_trans/trans_rvv.c.inc
> +++ b/target/riscv/insn_trans/trans_rvv.c.inc
> @@ -1526,30 +1526,24 @@ static bool opivx_widen_check(DisasContext *s, arg_rmrr *a)
>              vext_check_ds(s, a->rd, a->rs2, a->vm);
>   }
>   
> -static bool do_opivx_widen(DisasContext *s, arg_rmrr *a,
> -                           gen_helper_opivx *fn)
> -{
> -    if (opivx_widen_check(s, a)) {
> -        return opivx_trans(a->rd, a->rs1, a->rs2, a->vm, fn, s);
> -    }
> -    return false;
> +#define GEN_OPIVX_WIDEN_TRANS(NAME, CHECK) \
> +static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                    \
> +{                                                                         \
> +    if (CHECK(s, a)) {                                                    \
> +        static gen_helper_opivx * const fns[3] = {                        \
> +            gen_helper_##NAME##_b,                                        \
> +            gen_helper_##NAME##_h,                                        \
> +            gen_helper_##NAME##_w                                         \
> +        };                                                                \
> +        return opivx_trans(a->rd, a->rs1, a->rs2, a->vm, fns[s->sew], s); \
> +    }                                                                     \
> +    return false;                                                         \
>   }
>   
> -#define GEN_OPIVX_WIDEN_TRANS(NAME) \
> -static bool trans_##NAME(DisasContext *s, arg_rmrr *a)       \
> -{                                                            \
> -    static gen_helper_opivx * const fns[3] = {               \
> -        gen_helper_##NAME##_b,                               \
> -        gen_helper_##NAME##_h,                               \
> -        gen_helper_##NAME##_w                                \
> -    };                                                       \
> -    return do_opivx_widen(s, a, fns[s->sew]);                \
> -}
> -
> -GEN_OPIVX_WIDEN_TRANS(vwaddu_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwadd_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwsubu_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwsub_vx)
> +GEN_OPIVX_WIDEN_TRANS(vwaddu_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwadd_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwsubu_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwsub_vx, opivx_widen_check)
>   
>   /* WIDEN OPIVV with WIDEN */
>   static bool opiwv_widen_check(DisasContext *s, arg_rmrr *a)
> @@ -1997,9 +1991,9 @@ GEN_OPIVX_TRANS(vrem_vx, opivx_check)
>   GEN_OPIVV_WIDEN_TRANS(vwmul_vv, opivv_widen_check)
>   GEN_OPIVV_WIDEN_TRANS(vwmulu_vv, opivv_widen_check)
>   GEN_OPIVV_WIDEN_TRANS(vwmulsu_vv, opivv_widen_check)
> -GEN_OPIVX_WIDEN_TRANS(vwmul_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwmulu_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwmulsu_vx)
> +GEN_OPIVX_WIDEN_TRANS(vwmul_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwmulu_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwmulsu_vx, opivx_widen_check)
>   
>   /* Vector Single-Width Integer Multiply-Add Instructions */
>   GEN_OPIVV_TRANS(vmacc_vv, opivv_check)
> @@ -2015,10 +2009,10 @@ GEN_OPIVX_TRANS(vnmsub_vx, opivx_check)
>   GEN_OPIVV_WIDEN_TRANS(vwmaccu_vv, opivv_widen_check)
>   GEN_OPIVV_WIDEN_TRANS(vwmacc_vv, opivv_widen_check)
>   GEN_OPIVV_WIDEN_TRANS(vwmaccsu_vv, opivv_widen_check)
> -GEN_OPIVX_WIDEN_TRANS(vwmaccu_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwmacc_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwmaccsu_vx)
> -GEN_OPIVX_WIDEN_TRANS(vwmaccus_vx)
> +GEN_OPIVX_WIDEN_TRANS(vwmaccu_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwmacc_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwmaccsu_vx, opivx_widen_check)
> +GEN_OPIVX_WIDEN_TRANS(vwmaccus_vx, opivx_widen_check)
>   
>   /* Vector Integer Merge and Move Instructions */
>   static bool trans_vmv_v_v(DisasContext *s, arg_vmv_v_v *a)

