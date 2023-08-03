Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80E376F0AF
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 19:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjHCRdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 13:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbjHCRcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 13:32:55 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF152110
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 10:32:52 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-447576e24e1so447216137.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 10:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691083972; x=1691688772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72h1vSD+Gc7oxbDzRN4MWCfdaXi7NAc6IXTkZaqvVg4=;
        b=tTyyvMp5vOdRW2mdAvBQBi99WPmURpo41StkHq5tlTZ6bqF7oEAmRm3dz1zS7x3Z/C
         +cb+MrDauBBJXS2qfkcWaKseMq74s2AC1qmHfLxWsoHUIURILddgHVTLEGk/vB0Y1yn/
         M5Amrq/SY1zQmz0RoyWYcJmGA0UtYEyDUxU4Comj0sNgNLOLcWdI0O01vVDMsctFnW5W
         BTZdj/x8QTU4vUu1SWR/O8RlXHKeI8wpGpwBA2MxufltbuRJseCE6Db4274YxZhVx9Q9
         w365eX3RTokW5QbT07mKCGCkkTuSzqvPWisZNiu9pSy6QNE4fj5txB9hgkg6gQCCoBkp
         ozVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691083972; x=1691688772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72h1vSD+Gc7oxbDzRN4MWCfdaXi7NAc6IXTkZaqvVg4=;
        b=eNNClzwHBYYe6g0Y84byLFlgm9k9+vUNfDb83SJRqXLiSY9wu3QZk8hLKtma0VWUIc
         ezr84y16Fk+l4srzuDpV15vE3RjcnCTAHR/Axh4ZTmQ3nTTZhFgR4gmah3V8njmRr8HG
         iMwgaypn6Od824P6nz+2s1oBKVPKdhr1mzz6SYGWpwFoL4BOleI1EEDyTb1zdYw2CAFk
         0FGWmJ4/0d6Lj70gH5enULjITCpTb9Cch2XhL5MFjTQJoW7LhfZqcprfhufO86q6qTwr
         Vn1Dv19+uhz4M5AvZ9fnafK+EF9yhVkSBzTYYhXccQdalqeO2G/h3XVKwkcW17uEhteQ
         7HuQ==
X-Gm-Message-State: ABy/qLbE+ncaXej2AGYjW1w5CQ9dX4HQGMd8xZQEMEj9c0VNz0TAq+LW
        kX2yPYVUJF6ns2Me564kg7HO1kOfXVwTRFdc5nWn0Q==
X-Google-Smtp-Source: APBJJlEv8LYxVtcN3IWdatxyUj8MBicI/X51xRQ5cbz+ciVkP5fj605ez5Ocv9nOXp/7M1O/S3ixeQGC38TDQz3Nk1E=
X-Received: by 2002:a05:6102:3bc2:b0:447:55e6:15e7 with SMTP id
 a2-20020a0561023bc200b0044755e615e7mr5333218vsv.11.1691083971886; Thu, 03 Aug
 2023 10:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230803-ppc_tlbilxlpid-v1-1-84a1bc5cf963@google.com>
In-Reply-To: <20230803-ppc_tlbilxlpid-v1-1-84a1bc5cf963@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 3 Aug 2023 10:32:40 -0700
Message-ID: <CAKwvOd=t=n+mo_73MSrHOC9GLHHvH_p4nAA4nZfmJULiH3GZ2g@mail.gmail.com>
Subject: Re: [PATCH] powerpc/inst: add PPC_TLBILX_LPID
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 3, 2023 at 10:00=E2=80=AFAM <ndesaulniers@google.com> wrote:
>
> Clang didn't recognize the instruction tlbilxlpid. This was fixed in
> clang-18 [0] then backported to clang-17 [1].  To support clang-16 and
> older, rather than using that instruction bare in inline asm, add it to
> ppc-opcode.h and use that macro as is done elsewhere for other
> instructions.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1891
> Link: https://github.com/llvm/llvm-project/issues/64080
> Link: https://github.com/llvm/llvm-project/commit/53648ac1d0c953ae6d00886=
4dd2eddb437a92468 [0]
> Link: https://github.com/llvm/llvm-project-release-prs/commit/0af7e5e54a8=
c7ac665773ac1ada328713e8338f5 [1]
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/llvm/202307211945.TSPcyOhh-lkp@intel.com/
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/powerpc/include/asm/ppc-opcode.h |  4 +++-
>  arch/powerpc/kvm/e500mc.c             | 10 +++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include=
/asm/ppc-opcode.h
> index ef6972aa33b9..72f184e06bec 100644
> --- a/arch/powerpc/include/asm/ppc-opcode.h
> +++ b/arch/powerpc/include/asm/ppc-opcode.h
> @@ -397,7 +397,8 @@
>  #define PPC_RAW_RFCI                   (0x4c000066)
>  #define PPC_RAW_RFDI                   (0x4c00004e)
>  #define PPC_RAW_RFMCI                  (0x4c00004c)
> -#define PPC_RAW_TLBILX(t, a, b)                (0x7c000024 | __PPC_T_TLB=
(t) |  __PPC_RA0(a) | __PPC_RB(b))
> +#define PPC_RAW_TLBILX_LPID (0x7c000024)

^ missing two tabs.

I'm also having issues with b4 and my external mailer setting the From
header correctly.  To test up local modifications to b4, I'm going to
send a v2.

> +#define PPC_RAW_TLBILX(t, a, b)                (PPC_RAW_TLBILX_LPID | __=
PPC_T_TLB(t) | __PPC_RA0(a) | __PPC_RB(b))
>  #define PPC_RAW_WAIT_v203              (0x7c00007c)
>  #define PPC_RAW_WAIT(w, p)             (0x7c00003c | __PPC_WC(w) | __PPC=
_PL(p))
>  #define PPC_RAW_TLBIE(lp, a)           (0x7c000264 | ___PPC_RB(a) | ___P=
PC_RS(lp))
> @@ -616,6 +617,7 @@
>  #define PPC_TLBILX(t, a, b)    stringify_in_c(.long PPC_RAW_TLBILX(t, a,=
 b))
>  #define PPC_TLBILX_ALL(a, b)   PPC_TLBILX(0, a, b)
>  #define PPC_TLBILX_PID(a, b)   PPC_TLBILX(1, a, b)
> +#define PPC_TLBILX_LPID                stringify_in_c(.long PPC_RAW_TLBI=
LX_LPID)
>  #define PPC_TLBILX_VA(a, b)    PPC_TLBILX(3, a, b)
>  #define PPC_WAIT_v203          stringify_in_c(.long PPC_RAW_WAIT_v203)
>  #define PPC_WAIT(w, p)         stringify_in_c(.long PPC_RAW_WAIT(w, p))
> diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
> index d58df71ace58..dc054b8b5032 100644
> --- a/arch/powerpc/kvm/e500mc.c
> +++ b/arch/powerpc/kvm/e500mc.c
> @@ -16,10 +16,11 @@
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
>
> -#include <asm/reg.h>
>  #include <asm/cputable.h>
> -#include <asm/kvm_ppc.h>
>  #include <asm/dbell.h>
> +#include <asm/kvm_ppc.h>
> +#include <asm/ppc-opcode.h>
> +#include <asm/reg.h>
>
>  #include "booke.h"
>  #include "e500.h"
> @@ -92,7 +93,10 @@ void kvmppc_e500_tlbil_all(struct kvmppc_vcpu_e500 *vc=
pu_e500)
>
>         local_irq_save(flags);
>         mtspr(SPRN_MAS5, MAS5_SGS | get_lpid(&vcpu_e500->vcpu));
> -       asm volatile("tlbilxlpid");
> +       /* clang-17 and older could not assemble tlbilxlpid.
> +        * https://github.com/ClangBuiltLinux/linux/issues/1891
> +        */
> +       asm volatile (PPC_TLBILX_LPID);
>         mtspr(SPRN_MAS5, 0);
>         local_irq_restore(flags);
>  }
>
> ---
> base-commit: 7bafbd4027ae86572f308c4ddf93120c90126332
> change-id: 20230803-ppc_tlbilxlpid-cfdbf4fd4f7f
>
> Best regards,
> --
> Nick Desaulniers <ndesaulniers@google.com>
>


--=20
Thanks,
~Nick Desaulniers
