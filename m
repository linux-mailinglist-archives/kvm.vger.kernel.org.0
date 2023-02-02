Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C350B688025
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjBBObN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBBObM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:31:12 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCF7712F0
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:31:09 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw12so6526376ejc.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mOYw0Av35BMUzh2hzkJWlgpYAOCt2oHeMXkMdNbxYVQ=;
        b=YLg8WMRNp7WtxwnLFm8wid1nN9TkjKohYo7/ur7uImGEQ9RYM7bq/xqujWl55c96ig
         HCPIRePNtndo0f+u6yxTMa1e2bh02WZYI1k11n3XrpBav5gt0JX+bNH3M14c2npZjeld
         FmDZ44chmzn8yU66DNNCOKvZ3kMGSXLUe52oMrIWmRq1dV5AMR4WIrJy/AdX66lYaQfk
         z0lVEekHmtBX7NTsLiNQWvJ9/UOLv3wzPvsZEC2/TRAY0x9cjdD6R22fHKSKmcQUOIeq
         eCuJ12/SDzg/vh/3o5vaAzuUEzO48CxylJg8YBscniyXmzWqmMLSEPsxlwFBpTEDVDZO
         SPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mOYw0Av35BMUzh2hzkJWlgpYAOCt2oHeMXkMdNbxYVQ=;
        b=VGukE4ARzqkafpLfTMiy3PfuUrvwAVJhAHkM5a6X6ysuH7HwE7dAF5QEfynz83IdDa
         a8RnkO66kvCbkSrkwyFpzGNkBBA2gpRn5solsH06sv4meqpbrkXM1Dn4L0uAomYiiHb6
         Q+NOquJdGQl/JGtJ/KM0QOs8DwpMeTzVUQkOSM1Pw/tvIf7CPlDIMkPBrzrauQV6aNt9
         xsvUYighyngxis5Aw9bPxgISEO/ktls+aIgsAvutE9a7BOGmmB1wcy/kOC1wkPgOpQWX
         Z/ZwagYAnJt44w3h8II7i6SwhVzZ8mNYdg1CIzT2R56591VRablqQFzyppqbeIX79Ait
         bEdg==
X-Gm-Message-State: AO0yUKVps+QD5KjZF5WR/1uBqbc2CdaVxd5gidY2sckxTsde38yvBC9o
        PexaSnaCLAeUcJ0iRn2jNqA6iXXjoFrfxccpN8nZ4w==
X-Google-Smtp-Source: AK7set/SekZJXZTng4TrQ4XkBvKfKvskGpVM4s4AJw0QkB8y5f4s1MBJxoXlfFxmXx77eYXrk68nBZBSrxLkEOLFoAg=
X-Received: by 2002:a17:906:85c7:b0:878:581b:63ee with SMTP id
 i7-20020a17090685c700b00878581b63eemr1713866ejy.244.1675348268146; Thu, 02
 Feb 2023 06:31:08 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
 <20230202124230.295997-7-lawrence.hunter@codethink.co.uk> <CAAeLtUA188Tdq4rROAWNqNkMSOXVT0BWQX669L6fyt5oM5knZg@mail.gmail.com>
In-Reply-To: <CAAeLtUA188Tdq4rROAWNqNkMSOXVT0BWQX669L6fyt5oM5knZg@mail.gmail.com>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 15:30:57 +0100
Message-ID: <CAAeLtUDcpyWkKgAo2Lk0ZoHcdyEeVARYkh05Ps27wbOzDF0sHA@mail.gmail.com>
Subject: Re: [PATCH 06/39] target/riscv: Add vrol.[vv,vx] and vror.[vv,vx,vi]
 decoding, translation and execution support
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

On Thu, 2 Feb 2023 at 15:13, Philipp Tomsich <philipp.tomsich@vrull.eu> wrote:
>
> On Thu, 2 Feb 2023 at 13:42, Lawrence Hunter
> <lawrence.hunter@codethink.co.uk> wrote:
> >
> > From: Dickon Hood <dickon.hood@codethink.co.uk>
> >
> > Add an initial implementation of the vrol.* and vror.* instructions,
> > with mappings between the RISC-V instructions and their internal TCG
> > accelerated implmentations.
> >
> > There are some missing ror helpers, so I've bodged it by converting them
> > to rols.
> >
> > Co-authored-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> > Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> > Signed-off-by: Dickon Hood <dickon.hood@codethink.co.uk>
> > ---
> >  target/riscv/helper.h                      | 20 ++++++++
> >  target/riscv/insn32.decode                 |  6 +++
> >  target/riscv/insn_trans/trans_rvzvkb.c.inc | 20 ++++++++
> >  target/riscv/vcrypto_helper.c              | 58 ++++++++++++++++++++++
> >  target/riscv/vector_helper.c               | 45 -----------------
> >  target/riscv/vector_internals.h            | 52 +++++++++++++++++++
> >  6 files changed, 156 insertions(+), 45 deletions(-)
> >
> > diff --git a/target/riscv/helper.h b/target/riscv/helper.h
> > index 32f1179e29..e5b6b3360f 100644
> > --- a/target/riscv/helper.h
> > +++ b/target/riscv/helper.h
> > @@ -1142,3 +1142,23 @@ DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
> >  DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
> >  DEF_HELPER_6(vclmulh_vv, void, ptr, ptr, ptr, ptr, env, i32)
> >  DEF_HELPER_6(vclmulh_vx, void, ptr, ptr, tl, ptr, env, i32)
> > +
> > +DEF_HELPER_6(vror_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
> > +DEF_HELPER_6(vror_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
> > +DEF_HELPER_6(vror_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
> > +DEF_HELPER_6(vror_vv_d, void, ptr, ptr, ptr, ptr, env, i32)
> > +
> > +DEF_HELPER_6(vror_vx_b, void, ptr, ptr, tl, ptr, env, i32)
> > +DEF_HELPER_6(vror_vx_h, void, ptr, ptr, tl, ptr, env, i32)
> > +DEF_HELPER_6(vror_vx_w, void, ptr, ptr, tl, ptr, env, i32)
> > +DEF_HELPER_6(vror_vx_d, void, ptr, ptr, tl, ptr, env, i32)
> > +
> > +DEF_HELPER_6(vrol_vv_b, void, ptr, ptr, ptr, ptr, env, i32)
> > +DEF_HELPER_6(vrol_vv_h, void, ptr, ptr, ptr, ptr, env, i32)
> > +DEF_HELPER_6(vrol_vv_w, void, ptr, ptr, ptr, ptr, env, i32)
> > +DEF_HELPER_6(vrol_vv_d, void, ptr, ptr, ptr, ptr, env, i32)
> > +
> > +DEF_HELPER_6(vrol_vx_b, void, ptr, ptr, tl, ptr, env, i32)
> > +DEF_HELPER_6(vrol_vx_h, void, ptr, ptr, tl, ptr, env, i32)
> > +DEF_HELPER_6(vrol_vx_w, void, ptr, ptr, tl, ptr, env, i32)
> > +DEF_HELPER_6(vrol_vx_d, void, ptr, ptr, tl, ptr, env, i32)
> > diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
> > index b4d88dd1cb..725f907ad1 100644
> > --- a/target/riscv/insn32.decode
> > +++ b/target/riscv/insn32.decode
> > @@ -896,3 +896,9 @@ vclmul_vv       001100 . ..... ..... 010 ..... 1010111 @r_vm
> >  vclmul_vx       001100 . ..... ..... 110 ..... 1010111 @r_vm
> >  vclmulh_vv      001101 . ..... ..... 010 ..... 1010111 @r_vm
> >  vclmulh_vx      001101 . ..... ..... 110 ..... 1010111 @r_vm
> > +vrol_vv         010101 . ..... ..... 000 ..... 1010111 @r_vm
> > +vrol_vx         010101 . ..... ..... 100 ..... 1010111 @r_vm
> > +vror_vv         010100 . ..... ..... 000 ..... 1010111 @r_vm
> > +vror_vx         010100 . ..... ..... 100 ..... 1010111 @r_vm
> > +vror_vi         010100 . ..... ..... 011 ..... 1010111 @r_vm
> > +vror_vi2        010101 . ..... ..... 011 ..... 1010111 @r_vm
>
> We have only a single vror_vi instruction... and it has a 6bit immediate.
> There's no need to deviate from the spec. Just write it as follows:
> %imm_z6   26:1 15:5
> @r2_zimm6  ..... . vm:1 ..... ..... ... ..... .......  &rmrr %rs2
> rs1=%imm_z6 %rd
> vror_vi         01010. . ..... ..... 011 ..... 1010111 @r2_zimm6
>
> > diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> > index 533141e559..d2a7a92d42 100644
> > --- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
> > +++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> > @@ -95,3 +95,23 @@ static bool vclmul_vx_check(DisasContext *s, arg_rmrr *a)
> >
> >  GEN_VX_MASKED_TRANS(vclmul_vx, vclmul_vx_check)
> >  GEN_VX_MASKED_TRANS(vclmulh_vx, vclmul_vx_check)
> > +
> > +GEN_OPIVV_TRANS(vror_vv, zvkb_vv_check)
> > +GEN_OPIVX_TRANS(vror_vx, zvkb_vx_check)
> > +GEN_OPIVV_TRANS(vrol_vv, zvkb_vv_check)
> > +GEN_OPIVX_TRANS(vrol_vx, zvkb_vx_check)
> > +
> > +GEN_OPIVI_TRANS(vror_vi, IMM_TRUNC_SEW, vror_vx, zvkb_vx_check)
>
> Please introduce a IMM_ZIMM6 that integrates with the extract_imm as follows:
>     case IMM_ZIMM6:
>         return extract64(imm, 0, 6);
>
> > +
> > +/*
> > + * Immediates are 5b long, and we need six for the rotate-immediate.  The
> > + * decision has been taken to remove the vrol.vi instruction -- you can
> > + * emulate it with a ror, after all -- and use the bottom bit of the funct6
> > + * part of the opcode to encode the extra bit.  I've chosen to implement it
> > + * like this because it's easy and reasonably clean.
> > + */
> > +static bool trans_vror_vi2(DisasContext *s, arg_rmrr *a)
> > +{
> > +    a->rs1 += 32;
> > +    return trans_vror_vi(s, a);
> > +}
>
> As discussed above, please handle this in a single trans_vror_vi:
>    GEN_OPIVI_GVEC_TRANS_CHECK(vror_vi, IMM_ZIMM6, vror_vx, rotri, zvkb_check_vi)

On the second pass over these patches, here's how we can use gvec
support for both vror and vrol:

/* Synthesize a rotate-right from a negate(shift-amount) + rotate-left */
static void tcg_gen_gvec_rotrs(unsigned vece, uint32_t dofs, uint32_t aofs,
                       TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz)
{
    TCGv_i32 tmp = tcg_temp_new_i32();
    tcg_gen_neg_i32(tmp, shift);
    tcg_gen_gvec_rotls(vece, dofs, aofs, tmp, oprsz, maxsz);
    tcg_temp_free_i32(tmp);
}

/* vrol.v[vx] */
GEN_OPIVV_GVEC_TRANS_CHECK(vrol_vv, rotlv, zvkb_check_vv)
GEN_OPIVX_GVEC_SHIFT_TRANS_CHECK(vrol_vx, rotls, zvkb_check_vx)

/* vror.v[vxi] */
GEN_OPIVV_GVEC_TRANS_CHECK(vror_vv, rotrv, zvkb_check_vv)
GEN_OPIVX_GVEC_SHIFT_TRANS_CHECK(vror_vx, rotrs, zvkb_check_vx)
GEN_OPIVI_GVEC_TRANS_CHECK(vror_vi, IMM_ZIMM6, vror_vx, rotri, zvkb_check_vi)


> > diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
> > index 46e2e510c5..7ec75c5589 100644
> > --- a/target/riscv/vcrypto_helper.c
> > +++ b/target/riscv/vcrypto_helper.c
> > @@ -57,3 +57,61 @@ GEN_VEXT_VV(vclmul_vv, 8)
> >  GEN_VEXT_VX(vclmul_vx, 8)
> >  GEN_VEXT_VV(vclmulh_vv, 8)
> >  GEN_VEXT_VX(vclmulh_vx, 8)
> > +
> > +/*
> > + *  Looks a mess, but produces reasonable (aarch32) code on clang:
> > + * https://godbolt.org/z/jchjsTda8
> > + */
> > +#define DO_ROR(x, n)                       \
> > +    ((x >> (n & ((sizeof(x) << 3) - 1))) | \
> > +     (x << ((sizeof(x) << 3) - (n & ((sizeof(x) << 3) - 1)))))
> > +#define DO_ROL(x, n)                       \
> > +    ((x << (n & ((sizeof(x) << 3) - 1))) | \
> > +     (x >> ((sizeof(x) << 3) - (n & ((sizeof(x) << 3) - 1)))))
> > +
> > +RVVCALL(OPIVV2, vror_vv_b, OP_UUU_B, H1, H1, H1, DO_ROR)
> > +RVVCALL(OPIVV2, vror_vv_h, OP_UUU_H, H2, H2, H2, DO_ROR)
> > +RVVCALL(OPIVV2, vror_vv_w, OP_UUU_W, H4, H4, H4, DO_ROR)
> > +RVVCALL(OPIVV2, vror_vv_d, OP_UUU_D, H8, H8, H8, DO_ROR)
>
> Indeed, this is a mess: we already have ror8/16/32/64 available.
> Why not the following?
>
> /* vror.vv */
> GEN_VEXT_SHIFT_VV(vror_vv_b, uint8_t,  uint8_t,  H1, H1, ror8,  0x7)
> GEN_VEXT_SHIFT_VV(vror_vv_h, uint16_t, uint16_t, H2, H2, ror16, 0xf)
> GEN_VEXT_SHIFT_VV(vror_vv_w, uint32_t, uint32_t, H4, H4, ror32, 0x1f)
> GEN_VEXT_SHIFT_VV(vror_vv_d, uint64_t, uint64_t, H8, H8, ror64, 0x3f)
>
> > +GEN_VEXT_VV(vror_vv_b, 1)
> > +GEN_VEXT_VV(vror_vv_h, 2)
> > +GEN_VEXT_VV(vror_vv_w, 4)
> > +GEN_VEXT_VV(vror_vv_d, 8)
> > +
> > +/*
> > + * There's a missing tcg_gen_gvec_rotrs() helper function.
> > + */
> > +#define GEN_VEXT_VX_RTOL(NAME, ESZ)                                      \
> > +void HELPER(NAME)(void *vd, void *v0, target_ulong s1, void *vs2,        \
> > +                  CPURISCVState *env, uint32_t desc)                     \
> > +{                                                                        \
> > +    do_vext_vx(vd, v0, (ESZ << 3) - s1, vs2, env, desc, do_##NAME, ESZ); \
> > +}
> > +
> > +/* DO_ROL because GEN_VEXT_VX_RTOL() converts from R to L */
> > +RVVCALL(OPIVX2, vror_vx_b, OP_UUU_B, H1, H1, DO_ROL)
> > +RVVCALL(OPIVX2, vror_vx_h, OP_UUU_H, H2, H2, DO_ROL)
> > +RVVCALL(OPIVX2, vror_vx_w, OP_UUU_W, H4, H4, DO_ROL)
> > +RVVCALL(OPIVX2, vror_vx_d, OP_UUU_D, H8, H8, DO_ROL)
>
> Same applies as above:
> /* vror.vx */
> GEN_VEXT_SHIFT_VX(vror_vx_b, uint8_t,  uint8_t,  H1, H1, ror8,  0x7)
> GEN_VEXT_SHIFT_VX(vror_vx_h, uint16_t, uint16_t, H2, H2, ror16, 0xf)
> GEN_VEXT_SHIFT_VX(vror_vx_w, uint32_t, uint32_t, H4, H4, ror32, 0x1f)
> GEN_VEXT_SHIFT_VX(vror_vx_d, uint64_t, uint64_t, H8, H8, ror64, 0x3f)
>
> > +GEN_VEXT_VX_RTOL(vror_vx_b, 1)
> > +GEN_VEXT_VX_RTOL(vror_vx_h, 2)
> > +GEN_VEXT_VX_RTOL(vror_vx_w, 4)
> > +GEN_VEXT_VX_RTOL(vror_vx_d, 8)
> > +
> > +RVVCALL(OPIVV2, vrol_vv_b, OP_UUU_B, H1, H1, H1, DO_ROL)
> > +RVVCALL(OPIVV2, vrol_vv_h, OP_UUU_H, H2, H2, H2, DO_ROL)
> > +RVVCALL(OPIVV2, vrol_vv_w, OP_UUU_W, H4, H4, H4, DO_ROL)
> > +RVVCALL(OPIVV2, vrol_vv_d, OP_UUU_D, H8, H8, H8, DO_ROL)
> > +GEN_VEXT_VV(vrol_vv_b, 1)
> > +GEN_VEXT_VV(vrol_vv_h, 2)
> > +GEN_VEXT_VV(vrol_vv_w, 4)
> > +GEN_VEXT_VV(vrol_vv_d, 8)
> > +
> > +RVVCALL(OPIVX2, vrol_vx_b, OP_UUU_B, H1, H1, DO_ROL)
> > +RVVCALL(OPIVX2, vrol_vx_h, OP_UUU_H, H2, H2, DO_ROL)
> > +RVVCALL(OPIVX2, vrol_vx_w, OP_UUU_W, H4, H4, DO_ROL)
> > +RVVCALL(OPIVX2, vrol_vx_d, OP_UUU_D, H8, H8, DO_ROL)
> > +GEN_VEXT_VX(vrol_vx_b, 1)
> > +GEN_VEXT_VX(vrol_vx_h, 2)
> > +GEN_VEXT_VX(vrol_vx_w, 4)
> > +GEN_VEXT_VX(vrol_vx_d, 8)
> > diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
> > index ab470092f6..ff7b03cbe3 100644
> > --- a/target/riscv/vector_helper.c
> > +++ b/target/riscv/vector_helper.c
> > @@ -76,26 +76,6 @@ target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
> >      return vl;
> >  }
> >
> > -/*
> > - * Note that vector data is stored in host-endian 64-bit chunks,
> > - * so addressing units smaller than that needs a host-endian fixup.
> > - */
> > -#if HOST_BIG_ENDIAN
> > -#define H1(x)   ((x) ^ 7)
> > -#define H1_2(x) ((x) ^ 6)
> > -#define H1_4(x) ((x) ^ 4)
> > -#define H2(x)   ((x) ^ 3)
> > -#define H4(x)   ((x) ^ 1)
> > -#define H8(x)   ((x))
> > -#else
> > -#define H1(x)   (x)
> > -#define H1_2(x) (x)
> > -#define H1_4(x) (x)
> > -#define H2(x)   (x)
> > -#define H4(x)   (x)
> > -#define H8(x)   (x)
> > -#endif
> > -
> >  /*
> >   * Get the maximum number of elements can be operated.
> >   *
> > @@ -683,18 +663,11 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
> >   *** Vector Integer Arithmetic Instructions
> >   */
> >
> > -/* expand macro args before macro */
> > -#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
> > -
> >  /* (TD, T1, T2, TX1, TX2) */
> >  #define OP_SSS_B int8_t, int8_t, int8_t, int8_t, int8_t
> >  #define OP_SSS_H int16_t, int16_t, int16_t, int16_t, int16_t
> >  #define OP_SSS_W int32_t, int32_t, int32_t, int32_t, int32_t
> >  #define OP_SSS_D int64_t, int64_t, int64_t, int64_t, int64_t
> > -#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
> > -#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
> > -#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
> > -#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
> >  #define OP_SUS_B int8_t, uint8_t, int8_t, uint8_t, int8_t
> >  #define OP_SUS_H int16_t, uint16_t, int16_t, uint16_t, int16_t
> >  #define OP_SUS_W int32_t, uint32_t, int32_t, uint32_t, int32_t
> > @@ -718,14 +691,6 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
> >  #define NOP_UUU_H uint16_t, uint16_t, uint32_t, uint16_t, uint32_t
> >  #define NOP_UUU_W uint32_t, uint32_t, uint64_t, uint32_t, uint64_t
> >
> > -
> > -#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
> > -static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
> > -{                                                               \
> > -    TX1 s1 = *((T1 *)vs1 + HS1(i));                             \
> > -    TX2 s2 = *((T2 *)vs2 + HS2(i));                             \
> > -    *((TD *)vd + HD(i)) = OP(s2, s1);                           \
> > -}
> >  #define DO_SUB(N, M) (N - M)
> >  #define DO_RSUB(N, M) (M - N)
> >
> > @@ -747,16 +712,6 @@ GEN_VEXT_VV(vsub_vv_h, 2)
> >  GEN_VEXT_VV(vsub_vv_w, 4)
> >  GEN_VEXT_VV(vsub_vv_d, 8)
> >
> > -/*
> > - * (T1)s1 gives the real operator type.
> > - * (TX1)(T1)s1 expands the operator type of widen or narrow operations.
> > - */
> > -#define OPIVX2(NAME, TD, T1, T2, TX1, TX2, HD, HS2, OP)             \
> > -static void do_##NAME(void *vd, target_long s1, void *vs2, int i)   \
> > -{                                                                   \
> > -    TX2 s2 = *((T2 *)vs2 + HS2(i));                                 \
> > -    *((TD *)vd + HD(i)) = OP(s2, (TX1)(T1)s1);                      \
> > -}
> >
> >  RVVCALL(OPIVX2, vadd_vx_b, OP_SSS_B, H1, H1, DO_ADD)
> >  RVVCALL(OPIVX2, vadd_vx_h, OP_SSS_H, H2, H2, DO_ADD)
> > diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_internals.h
> > index 49529d2379..a0fbac7bf3 100644
> > --- a/target/riscv/vector_internals.h
> > +++ b/target/riscv/vector_internals.h
> > @@ -28,6 +28,26 @@ static inline uint32_t vext_nf(uint32_t desc)
> >      return FIELD_EX32(simd_data(desc), VDATA, NF);
> >  }
> >
> > +/*
> > + * Note that vector data is stored in host-endian 64-bit chunks,
> > + * so addressing units smaller than that needs a host-endian fixup.
> > + */
> > +#if HOST_BIG_ENDIAN
> > +#define H1(x)   ((x) ^ 7)
> > +#define H1_2(x) ((x) ^ 6)
> > +#define H1_4(x) ((x) ^ 4)
> > +#define H2(x)   ((x) ^ 3)
> > +#define H4(x)   ((x) ^ 1)
> > +#define H8(x)   ((x))
> > +#else
> > +#define H1(x)   (x)
> > +#define H1_2(x) (x)
> > +#define H1_4(x) (x)
> > +#define H2(x)   (x)
> > +#define H4(x)   (x)
> > +#define H8(x)   (x)
> > +#endif
> > +
> >  /*
> >   * Encode LMUL to lmul as following:
> >   *     LMUL    vlmul    lmul
> > @@ -96,9 +116,30 @@ static inline uint32_t vext_get_total_elems(CPURISCVState *env, uint32_t desc,
> >  void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
> >                         uint32_t tot);
> >
> > +/*
> > + *** Vector Integer Arithmetic Instructions
> > + */
> > +
> > +/* expand macro args before macro */
> > +#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
> > +
> > +/* (TD, T1, T2, TX1, TX2) */
> > +#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
> > +#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
> > +#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
> > +#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
> > +
> >  /* operation of two vector elements */
> >  typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
> >
> > +#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
> > +static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
> > +{                                                               \
> > +    TX1 s1 = *((T1 *)vs1 + HS1(i));                             \
> > +    TX2 s2 = *((T2 *)vs2 + HS2(i));                             \
> > +    *((TD *)vd + HD(i)) = OP(s2, s1);                           \
> > +}
> > +
> >  void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
> >                  CPURISCVState *env, uint32_t desc,
> >                  opivv2_fn *fn, uint32_t esz);
> > @@ -115,6 +156,17 @@ void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
> >
> >  typedef void opivx2_fn(void *vd, target_long s1, void *vs2, int i);
> >
> > +/*
> > + * (T1)s1 gives the real operator type.
> > + * (TX1)(T1)s1 expands the operator type of widen or narrow operations.
> > + */
> > +#define OPIVX2(NAME, TD, T1, T2, TX1, TX2, HD, HS2, OP)             \
> > +static void do_##NAME(void *vd, target_long s1, void *vs2, int i)   \
> > +{                                                                   \
> > +    TX2 s2 = *((T2 *)vs2 + HS2(i));                                 \
> > +    *((TD *)vd + HD(i)) = OP(s2, (TX1)(T1)s1);                      \
> > +}
> > +
> >  void do_vext_vx(void *vd, void *v0, target_long s1, void *vs2,
> >                  CPURISCVState *env, uint32_t desc,
> >                  opivx2_fn fn, uint32_t esz);
>
> Again: refactoring needs to go into a separate patch.
>
> > --
> > 2.39.1
> >
