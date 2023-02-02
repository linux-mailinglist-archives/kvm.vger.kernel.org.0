Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3303D687FD8
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 15:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjBBOWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 09:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjBBOWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 09:22:53 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731EE8E4B6
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 06:22:52 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bk15so6359078ejb.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 06:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GMHBIIDL+Gs5g5qmJb2qZUmw9eyGCtQHrGm48e3o9xY=;
        b=JW/RVPmTKJyBS1XqlsRBPfFRVgpOX6p6bhKp+6xb+BzxAfUngxj2qjuYmrZvoJjQuI
         MeGbR5kPc/I6YwRI1e6QSLpua91pwRrY0VyI7HkidR+0f/e9YbuOb9KKpMKKzVuExxEY
         7B6ovizcoJtQBUqMBtRITot78H6iNPFM51um9nKYXMYkZXVzQtHYmyZoKKiX6tf7O/fg
         iBmDnkr83mSEbRCbr9uC4CUwX5T6ZE2YwokXMbLTsE3i/jJZuyL6QLvWmAY+Oy6Q7aCu
         5P7GeFz4umk/uuwlJyTYGDAIjy6Qgbbgm1V78cWeztKHWTd/7EcterMv0RhIxhPGn5XD
         naDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GMHBIIDL+Gs5g5qmJb2qZUmw9eyGCtQHrGm48e3o9xY=;
        b=LdOeT2yBnjqma8KE8GqoqndT/k6B1dIemmfMFgkpVqHdGZMHTwk4tFaDJyRR2B28Wr
         xtx3CRRff6hUMCxqCDpxahViAN51AVn3a7HNXrs9NjUOpVHW0ov6kDtw6yMHWEXsY3/y
         WuD5gl83s+bDh+gbAoI8VQBeIRgOwpbq1/rr75sNOc6gMmv1mf4r5iXEHc5SUVApi83S
         IrGuAZRacxMH8Gxzg5cc2M+AE1mXazrDqmo1Cwo7dU2wLslhO0ioacsD8BorcoHWpNOs
         JxduelpKQdUrkdGYGrNeU48yc/VObNkvp7hL9J9NqfRANux/C1P3hpf1KiklB+lTgrMo
         qyUQ==
X-Gm-Message-State: AO0yUKWAmGYJKw/lD+8s6dwdceWZ3ed5kHgCPhsgPMjk49lhOdm5WWg9
        EBWhjrT9l8Vg6xpgogXKvz+nqBeoN0NTUFe+c24InQ==
X-Google-Smtp-Source: AK7set8XWWJz0QoVSo7kS5uMirIKtCFwdi0jfNCM84qu503GS/hC1UGfXcKeilaEm5xDqqBq7Dn+6HwqRC8emOKlBj0=
X-Received: by 2002:a17:906:2bdb:b0:878:6f08:39ec with SMTP id
 n27-20020a1709062bdb00b008786f0839ecmr2028727ejg.233.1675347770951; Thu, 02
 Feb 2023 06:22:50 -0800 (PST)
MIME-Version: 1.0
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk> <20230202124230.295997-9-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230202124230.295997-9-lawrence.hunter@codethink.co.uk>
From:   Philipp Tomsich <philipp.tomsich@vrull.eu>
Date:   Thu, 2 Feb 2023 15:22:39 +0100
Message-ID: <CAAeLtUCZ2ECiVJnS=sxQd69Kq-2UxRELQB+pQAjXxNLSWPiLxQ@mail.gmail.com>
Subject: Re: [PATCH 08/39] target/riscv: Add vrev8.v decoding, translation and
 execution support
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
>  target/riscv/helper.h                      |  4 ++++
>  target/riscv/insn32.decode                 |  1 +
>  target/riscv/insn_trans/trans_rvzvkb.c.inc |  1 +
>  target/riscv/vcrypto_helper.c              | 10 ++++++++++
>  4 files changed, 16 insertions(+)
>
> diff --git a/target/riscv/helper.h b/target/riscv/helper.h
> index c94627d8a4..c980d52828 100644
> --- a/target/riscv/helper.h
> +++ b/target/riscv/helper.h
> @@ -1163,6 +1163,10 @@ DEF_HELPER_6(vrol_vx_h, void, ptr, ptr, tl, ptr, env, i32)
>  DEF_HELPER_6(vrol_vx_w, void, ptr, ptr, tl, ptr, env, i32)
>  DEF_HELPER_6(vrol_vx_d, void, ptr, ptr, tl, ptr, env, i32)
>
> +DEF_HELPER_5(vrev8_v_b, void, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_5(vrev8_v_h, void, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_5(vrev8_v_w, void, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_5(vrev8_v_d, void, ptr, ptr, ptr, env, i32)
>  DEF_HELPER_5(vbrev8_v_b, void, ptr, ptr, ptr, env, i32)
>  DEF_HELPER_5(vbrev8_v_h, void, ptr, ptr, ptr, env, i32)
>  DEF_HELPER_5(vbrev8_v_w, void, ptr, ptr, ptr, env, i32)
> diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
> index 782632a165..342199abc0 100644
> --- a/target/riscv/insn32.decode
> +++ b/target/riscv/insn32.decode
> @@ -903,3 +903,4 @@ vror_vx         010100 . ..... ..... 100 ..... 1010111 @r_vm
>  vror_vi         010100 . ..... ..... 011 ..... 1010111 @r_vm
>  vror_vi2        010101 . ..... ..... 011 ..... 1010111 @r_vm
>  vbrev8_v        010010 . ..... 01000 010 ..... 1010111 @r2_vm
> +vrev8_v         010010 . ..... 01001 010 ..... 1010111 @r2_vm
> diff --git a/target/riscv/insn_trans/trans_rvzvkb.c.inc b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> index 591980459a..18b362db92 100644
> --- a/target/riscv/insn_trans/trans_rvzvkb.c.inc
> +++ b/target/riscv/insn_trans/trans_rvzvkb.c.inc
> @@ -154,3 +154,4 @@ static bool vxrev8_check(DisasContext *s, arg_rmr *a)
>  }
>
>  GEN_OPIV_TRANS(vbrev8_v, vxrev8_check)
> +GEN_OPIV_TRANS(vrev8_v, vxrev8_check)
> diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
> index 303a656141..b09fe5fa2a 100644
> --- a/target/riscv/vcrypto_helper.c
> +++ b/target/riscv/vcrypto_helper.c
> @@ -125,3 +125,13 @@ GEN_VEXT_V(vbrev8_v_b, 1)
>  GEN_VEXT_V(vbrev8_v_h, 2)
>  GEN_VEXT_V(vbrev8_v_w, 4)
>  GEN_VEXT_V(vbrev8_v_d, 8)
> +
> +#define DO_VREV8_B(a) (a)
> +RVVCALL(OPIVV1, vrev8_v_b, OP_UU_B, H1, H1, DO_VREV8_B)

Let's call it what it is: "DO_COPY" or "DO_IDENTITY" ...

> +RVVCALL(OPIVV1, vrev8_v_h, OP_UU_H, H2, H2, bswap16)
> +RVVCALL(OPIVV1, vrev8_v_w, OP_UU_W, H4, H4, bswap32)
> +RVVCALL(OPIVV1, vrev8_v_d, OP_UU_D, H8, H8, bswap64)
> +GEN_VEXT_V(vrev8_v_b, 1)
> +GEN_VEXT_V(vrev8_v_h, 2)
> +GEN_VEXT_V(vrev8_v_w, 4)
> +GEN_VEXT_V(vrev8_v_d, 8)
> --
> 2.39.1
>
