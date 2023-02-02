Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24AD687F7D
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjBBOEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBBOEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:04:09 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED2E298DB
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:04:07 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id m2so6204043ejb.8
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6fy6ME76fsE2GltQoliTq9PmNQ1hERDS3fixqxq9DQ0=;
        b=KKsvtvCHBWmwHLcKBvUSp3JdVY3xI2y3uMhDz1mGTnL351dTnVcNYvn5Tqr0SuLLgU
         pyVFr9ISWY5/2z8AXbgjuh4BtrxoyzSAcYIjB3BnJpfY1fVloH1Ukbr4TqiZXjwSbkGE
         L4nj1+x6KdyW5SBA4+ny8RKO0tuAHGc/GD5xVhg53BdPDOPfqwKau6wqeSRcaEskduoN
         2OM3wR9eXXkNz57YkI91jVY6YJWxE0H+4zRgV/2HRa1DT0eIM/vD8YuJoBgJPW3e90ih
         RccxrrrwY1/hixv8SQI81qibWvA66SHfKnX9pKlwbMgU70qVOE5SlKbCbhgDdRhBuMny
         FxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6fy6ME76fsE2GltQoliTq9PmNQ1hERDS3fixqxq9DQ0=;
        b=WeVpcg+QRJ3Urk3UHXrSKKnOmRpu3M4XLVOju0lOH7vf4gd/X2GjvLUXRQ4o30Wymt
         8otV9HygkgKp117e13KvXZvC39VIN6P9GXqNF14EmjtaYV+pTAN4SRONtefpmNUsrBSC
         4zMEEupSgS4FHJYwcE6/F/I+k2iONICK1yYVzyx+9A5qWsZmsNv74BGIQBPFv/JwATt9
         947bU//ZdP9juszQImxgrdyWgZwyS3WjVjTfdgZfiFvzshvNH1ETV3o2sNTf5aw8WMFC
         92EWE7MNorAeT9twCBtxcSbrRXHYmLHwyywdtFH9q2T0TWkaWm+SMV3PHJzhNU0PJOfT
         U9Cg==
X-Gm-Message-State: AO0yUKWbDwxKDw9NH8RxZJFetGDMsKB0ud2g0l9TrzYk1yXgQTHehPRP
        jiuIZ3qqsvf2lG6NlwxYQPO4wp/RGMeKtWyM9FtBJQ==
X-Google-Smtp-Source: AK7set/383oNBJ7S5z0YobbUohJMaKCMjncS+ajExqVzb+0S8m13Ye5hm9wXSaLELI+cTEmZGR39lKEf9bXZIfU7e00=
X-Received: by 2002:a17:906:b001:b0:878:4cc7:ed23 with SMTP id
 v1-20020a170906b00100b008784cc7ed23mr2066707ejy.14.1675346646374; Thu, 02 Feb
 2023 06:04:06 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk> <20230202124230.295997-5-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230202124230.295997-5-lawrence.hunter@codethink.co.uk>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 15:03:55 +0100
Message-ID: <CAAeLtUDaL2_6ftqQtFZ5fRfyJbwbv=QXc7hTwQSf+w3QCG1c3Q@mail.gmail.com>
Subject: Re: [PATCH 04/39] target/riscv: Add vclmulh.vv decoding, translation
 and execution support
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
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
> Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
> ---
>  target/riscv/helper.h                      |  1 +
>  target/riscv/insn32.decode                 |  1 +
>  target/riscv/insn_trans/trans_rvzvkb.c.inc |  1 +
>  target/riscv/vcrypto_helper.c              | 12 ++++++++++++
>  4 files changed, 15 insertions(+)
>
> diff --git a/target/riscv/helper.h b/target/riscv/helper.h
> index 6c786ef6f3..a155272701 100644
> --- a/target/riscv/helper.h
> +++ b/target/riscv/helper.h
> @@ -1140,3 +1140,4 @@ DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
>  /* Vector crypto functions */
>  DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
>  DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
> +DEF_HELPER_6(vclmulh_vv, void, ptr, ptr, ptr, ptr, env, i32)
> diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
> index 4a7421354d..e26ea1df08 100644
> --- a/target/riscv/insn32.decode
> +++ b/target/riscv/insn32.decode
> @@ -894,3 +894,4 @@ sm4ks       .. 11010 ..... ..... 000 ..... 0110011 @k_aes
>  # *** RV64 Zvkb vector crypto extension ***
>  vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
>  vclmul_vx       001100 . ..... ..... 110 ..... 1010111 @r_vm
> +vclmulh_vv      001101 . ..... ..... 010 ..... 1010111 @r_vm
> diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> index 6e8b81136c..19ce4c7431 100644
> --- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
> +++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> @@ -39,6 +39,7 @@ static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
>  }
>
>  GEN_VV_MASKED_TRANS(vclmul_vv, vclmul_vv_check)
> +GEN_VV_MASKED_TRANS(vclmulh_vv, vclmul_vv_check)
>
>  #define GEN_VX_MASKED_TRANS(NAME, CHECK)                                \
>  static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                  \
> diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
> index c453d348ad..022b941131 100644
> --- a/target/riscv/vcrypto_helper.c
> +++ b/target/riscv/vcrypto_helper.c
> @@ -31,5 +31,17 @@ static void do_vclmul_vx(void *vd, target_long rs1, void *vs2, int i)
>      ((uint64_t *)vd)[i] = result;
>  }
>
> +static void do_vclmulh_vv(void *vd, void *vs1, void *vs2, int i)
> +{
> +    __uint128_t result = 0;
> +    for (int j = 63; j >= 0; j--) {
> +        if ((((uint64_t *)vs1)[i] >> j) & 1) {
> +            result ^= (((__uint128_t)(((uint64_t *)vs2)[i])) << j);

Why are we computing a 128 bit result, if we reduce it to 64b bits anyway?

> +        }
> +    }
> +    ((uint64_t *)vd)[i] = (result >> 64);
> +}

Please simplify in the same way as for clmul (i.e. a single function
that computes uint64 x uint64 -> uint64 ... and 2 calls to the RVVCALL
generator for OPIVV2 and OPIVX2):

static uint64_t clmulh64(uint64_t x, uint64_t y)
{
    target_ulong result = 0;
    const unsigned int elem_width = 64;

    for (unsigned int i = 1; i < elem_width; ++i)
        if ((y >> i) & 1)
            result ^= (x >> (elem_width - i));

    return result;
}

/* vclmulh.vv */
RVVCALL(OPIVV2, vclmulh_vv_d, OP_UUU_D, H8, H8, H8, clmulh64)
GEN_VEXT_VV(vclmulh_vv_d, 8)

/* vclmulh.vx */
RVVCALL(OPIVX2, vclmulh_vx_d, OP_UUU_D, H8, H8, clmulh64)
GEN_VEXT_VX(vclmulh_vx_d, 8)


> +
>  GEN_VEXT_VV(vclmul_vv, 8)
>  GEN_VEXT_VX(vclmul_vx, 8)
> +GEN_VEXT_VV(vclmulh_vv, 8)
> --
> 2.39.1
>
