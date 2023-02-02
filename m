Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655EF688021
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjBBO3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBBO3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:29:21 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DCB44B2
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:29:19 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id be12so2184334edb.4
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J/KshAgycDFR262NirTWMpA7IYyDq5dPRxB8Xfwd4YY=;
        b=Bgdy6gQ3N2aKAeMPzcScO6PZO2Y1Tw5zMUSTvLt4vK8O0LAwDhkXPzjh7HlkjU2q1x
         BDPgZHvo0gg3dSlU38VmNnNFhSTQ+KL2xMUK44HDbXQIR6iGkUCgJZViJ0SqFhR2YEgY
         gbNdJ0jSMirHFIFMrWFbTCy5vX3HPW2jKzq7z6jX9QT7stVgjBkShirs/YCG98ivKVz7
         Wlzxn2oMFcxUs6+xl8fx2QMIa+KKMzNzzWbVRJKEzpjUeUTiVXbIlJJI5vjMgaWChjUm
         LVpG67jN1Gx/ufjZX92WhK0OHez+NZFhTNdCfJ+SyP8YbQtNDPps0Q497/6+K6Zk1AeU
         5QbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J/KshAgycDFR262NirTWMpA7IYyDq5dPRxB8Xfwd4YY=;
        b=P1TyBnh7HHvP+Meh6bXeXTCIIh3z8pWfY5dkqyP/bC39hdri7lBWEvkch8uqqsOVmC
         ta9yRjfqj8C/Iydkl43u2COhQ3GX8GsBBQj8hPwsPjR1L9iLSkhTG/HHHKYBZlY8KI6m
         qX6j4wfDIAmR8Ew41ysqx9QisGR540/3VvJ8jnAc/La1OXljlKGCcFPEB5QAmzpqpKug
         gQzJCvo11k/hMApDGqp29PomFk5yn+u1L4veJksnhDg1189J95aAENQvdGKGAflyHGRm
         S2h/liLLcHAhDIz+QQ9ZQrfDoo8tdIBD/oyyBbhiHfMxcuVf3Htvoop9PJnsbHKAae/z
         bNog==
X-Gm-Message-State: AO0yUKVDepKdD6ttjeqUZVdMUTK6wegqpeP7CpkAFFcaDmkppg2eMwnF
        ZmufA7VrX0DDV7Wly3wCvyfUpV1ZW9TuhXYxpG+lhg==
X-Google-Smtp-Source: AK7set+aXTDYV7wFKByKnT/AoyMIOXBWAgau8kmhI7L9pb3HEk2ywMgTPYY156SvfN78GPHIu37UDRqUqT9Kct5MHE0=
X-Received: by 2002:a05:6402:1e8c:b0:48e:bad6:720c with SMTP id
 f12-20020a0564021e8c00b0048ebad6720cmr2056180edf.2.1675348157630; Thu, 02 Feb
 2023 06:29:17 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk> <20230202124230.295997-10-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230202124230.295997-10-lawrence.hunter@codethink.co.uk>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 15:29:06 +0100
Message-ID: <CAAeLtUCG7DEwGAwEPjmH3tvacX5P4t6eAO5_pb4o2nKc3bwN8A@mail.gmail.com>
Subject: Re: [PATCH 09/39] target/riscv: Add vandn.[vv,vx,vi] decoding,
 translation and execution support
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
> From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
>
> Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> ---
>  target/riscv/helper.h                      |  9 +++++++++
>  target/riscv/insn32.decode                 |  3 +++
>  target/riscv/insn_trans/trans_rvzvkb.c.inc |  5 +++++
>  target/riscv/vcrypto_helper.c              | 19 +++++++++++++++++++
>  4 files changed, 36 insertions(+)
>
> diff --git a/target/riscv/helper.h b/target/riscv/helper.h
> index c980d52828..5de615ea78 100644
> --- a/target/riscv/helper.h
> +++ b/target/riscv/helper.h
> @@ -1171,3 +1171,12 @@ DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
>  DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
>  DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
>  DEF_HELPER_5(vbrev8_v_d, void, ptr, ptr, ptr, env, i32)
> +
> +DEF_HELPER_6(vandn_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_6(vandn_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_6(vandn_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_6(vandn_vv_d, void, ptr, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_6(vandn_vx_b, void, ptr, ptr, tl, ptr, env, i32)
> +DEF_HELPER_6(vandn_vx_h, void, ptr, ptr, tl, ptr, env, i32)
> +DEF_HELPER_6(vandn_vx_w, void, ptr, ptr, tl, ptr, env, i32)
> +DEF_HELPER_6(vandn_vx_d, void, ptr, ptr, tl, ptr, env, i32)
> diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
> index 342199abc0..d6f5e4d198 100644
> --- a/target/riscv/insn32.decode
> +++ b/target/riscv/insn32.decode
> @@ -904,3 +904,6 @@ vror_vi         010100 . ..... ..... 011 ..... 1010111 @r_vm
>  vror_vi2        010101 . ..... ..... 011 ..... 1010111 @r_vm
>  vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
>  vrev8_v         010010 . ..... 01001 010 ..... 1010111 @r2_vm
> +vandn_vi        000001 . ..... ..... 011 ..... 1010111 @r_vm
> +vandn_vv        000001 . ..... ..... 000 ..... 1010111 @r_vm
> +vandn_vx        000001 . ..... ..... 100 ..... 1010111 @r_vm
> diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> index 18b362db92..a973b27bdd 100644
> --- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
> +++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> @@ -147,6 +147,11 @@ static bool trans_##NAME(DisasContext *s, arg_rmr * a)                 \
>      return false;                                                      \
>  }
>
> +
> +GEN_OPIVV_TRANS(vandn_vv, zvkb_vv_check)
> +GEN_OPIVX_TRANS(vandn_vx, zvkb_vx_check)
> +GEN_OPIVI_TRANS(vandn_vi, IMM_SX, vandn_vx, zvkb_vx_check)

I don't see any reason why this shouldn't have gvec support (after
all, it is a andc with the arguments inverted) with something like
this:

static void gen_andn_i64(TCGv_i64 ret, TCGv_i64 arg1, TCGv_i64 arg2)
{
    tcg_gen_andc_i64(ret, arg1, arg2);
}

static void gen_andn_vec(unsigned vece, TCGv_vec r, TCGv_vec a, TCGv_vec b)
{
    tcg_gen_andc_vec(vece, r, b, a);
}

static void tcg_gen_gvec_andn(unsigned vece, uint32_t dofs, uint32_t aofs,
                       uint32_t bofs, uint32_t oprsz, uint32_t maxsz)
{
    static const GVecGen3 g = {
        .fni8 = gen_andn_i64,
        .fniv = gen_andn_vec,
        .fno = gen_helper_vec_andn,
        .prefer_i64 = TCG_TARGET_REG_BITS == 64,
    };

    if (aofs == bofs) {
        tcg_gen_gvec_dup_imm(MO_64, dofs, oprsz, maxsz, 0);
    } else {
        tcg_gen_gvec_3(dofs, aofs, bofs, oprsz, maxsz, &g);
    }
}

static void tcg_gen_gvec_andns(unsigned vece, uint32_t dofs, uint32_t aofs,
                               TCGv_i64 c, uint32_t oprsz, uint32_t maxsz)
{
    static const GVecGen2s g = {
        .fni8 = gen_andn_i64,
        .fniv = gen_andn_vec,
        .fno = gen_helper_vec_andns,
        .prefer_i64 = TCG_TARGET_REG_BITS == 64,
    };

    tcg_gen_gvec_2s(dofs, aofs, oprsz, maxsz, c, &g);
}

static void tcg_gen_gvec_andni(unsigned vece, uint32_t dofs, uint32_t aofs,
                               int64_t c, uint32_t oprsz, uint32_t maxsz)
{
    TCGv_i64 tmp = tcg_constant_i64(c);
    tcg_gen_gvec_andns(vece, dofs, aofs, tmp, oprsz, maxsz);
}

/* vandn.v[vxi] */
GEN_OPIVV_GVEC_TRANS_CHECK(vandn_vv, andn, zvkb_check_vv)
GEN_OPIVX_GVEC_TRANS_CHECK(vandn_vx, andns, zvkb_check_vx)
GEN_OPIVI_GVEC_TRANS_CHECK(vandn_vi, IMM_SX, vandn_vx, andni, zvkb_check_vi)

> +
>  static bool vxrev8_check(DisasContext *s, arg_rmr *a)
>  {
>      return s->cfg_ptr->ext_zvkb == true && vext_check_isa_ill(s) &&
> diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
> index b09fe5fa2a..900e68dfb0 100644
> --- a/target/riscv/vcrypto_helper.c
> +++ b/target/riscv/vcrypto_helper.c
> @@ -135,3 +135,22 @@ GEN_VEXT_V(vrev8_v_b, 1)
>  GEN_VEXT_V(vrev8_v_h, 2)
>  GEN_VEXT_V(vrev8_v_w, 4)
>  GEN_VEXT_V(vrev8_v_d, 8)
> +
> +#define DO_ANDN(a, b) ((b) & ~(a))
> +RVVCALL(OPIVV2, vandn_vv_b, OP_UUU_B, H1, H1, H1, DO_ANDN)
> +RVVCALL(OPIVV2, vandn_vv_h, OP_UUU_H, H2, H2, H2, DO_ANDN)
> +RVVCALL(OPIVV2, vandn_vv_w, OP_UUU_W, H4, H4, H4, DO_ANDN)
> +RVVCALL(OPIVV2, vandn_vv_d, OP_UUU_D, H8, H8, H8, DO_ANDN)
> +GEN_VEXT_VV(vandn_vv_b, 1)
> +GEN_VEXT_VV(vandn_vv_h, 2)
> +GEN_VEXT_VV(vandn_vv_w, 4)
> +GEN_VEXT_VV(vandn_vv_d, 8)
> +
> +RVVCALL(OPIVX2, vandn_vx_b, OP_UUU_B, H1, H1, DO_ANDN)
> +RVVCALL(OPIVX2, vandn_vx_h, OP_UUU_H, H2, H2, DO_ANDN)
> +RVVCALL(OPIVX2, vandn_vx_w, OP_UUU_W, H4, H4, DO_ANDN)
> +RVVCALL(OPIVX2, vandn_vx_d, OP_UUU_D, H8, H8, DO_ANDN)
> +GEN_VEXT_VX(vandn_vx_b, 1)
> +GEN_VEXT_VX(vandn_vx_h, 2)
> +GEN_VEXT_VX(vandn_vx_w, 4)
> +GEN_VEXT_VX(vandn_vx_d, 8)
> --
> 2.39.1
>
