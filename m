Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CED76F2F9
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 20:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjHCStp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 14:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbjHCStU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 14:49:20 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488CF358B
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 11:48:51 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-63cf7cce5fbso8249766d6.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 11:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691088528; x=1691693328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tbNHE93nYjXEA/O+xALVAEDc6FnXESddWS3lWiWLV0=;
        b=6VFzvdxm3YrleojZUDMcow5FlyLkuGEPWo7uL1Sub4U4LzVMQhi5UpSPEaYtXxQig6
         R78lgZrOqqK6yg0QQv/JfRTYg+AsYws7jCkd8Bg1iujIIi9/A8JGaIKa3nySYUYxYXMD
         fDeqWcFIbb7KgTxygJUFLUFd9FltJ7Sx1WpUt7PJDnRkqFqEAYX3UY0X49kRyzwn5sdP
         I37qBWtWNXQq7xllL7dbKsCaawao2B5L/YEZK2kvud+xkjOMxt2YCSPKhd52vD+CcmjX
         qsvwDpR8y8XyjjIEENEG/wD83xbRHVmg+fosa7E0VP5fHwabw7hE0ggbCtQWbEI9pBLv
         f8mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691088528; x=1691693328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tbNHE93nYjXEA/O+xALVAEDc6FnXESddWS3lWiWLV0=;
        b=WWIf4Ux0Jd5jbMmXaLy+TsqwdO7uaD66wX1bz1k0JBo2U720vHVljp+m75DKIHSyKy
         o3zEIMzwwGkle0W7w9Bq7NUx8gJgC5T3KEKRmbe0C7+qJHpXGvfSbNMJYHSvNj6KaLtB
         2/F32V1vrEEBD7RTwcbjHs/HGbdJakIv/acleBHFGm6WXDBtCjgUHKpQKPsJayfFEqoV
         IEeGit/XEnqY2ypcKUuNHcq/+yCqmbKV6yCPP1tI6QZKxK4WUt61EpOBM26fKQlm97YI
         Q9HPamKUVsJsiUHjAjNGysChH0uHBPtIvhum7v7UEFcVE9BXKMDbxKOrU/lTmwU0ShZc
         q22Q==
X-Gm-Message-State: ABy/qLa3jQxIh0yDDb+PAKNR2pV7iv9GtG6+wjZ/3TyWwsb8mAYBvajq
        aKL7htEQiz+GdLXnvx9GieRdxN3yK36ZpscrkrIDsQ==
X-Google-Smtp-Source: APBJJlHVHOlFaAc7QLzwJ5MQyhcxQ7uez6gZPgXw7RdtP68eZ2qt3tpg4x+z+Z2XW9dTV2WAxlrUtvM5KRnWu0hSBto=
X-Received: by 2002:a05:6214:3011:b0:63d:a05:256a with SMTP id
 ke17-20020a056214301100b0063d0a05256amr21855102qvb.8.1691088527629; Thu, 03
 Aug 2023 11:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230803-ppc_tlbilxlpid-v3-1-ca84739bfd73@google.com> <31b387c5-c6a4-2911-b337-b7af6a15c29e@csgroup.eu>
In-Reply-To: <31b387c5-c6a4-2911-b337-b7af6a15c29e@csgroup.eu>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 3 Aug 2023 11:48:36 -0700
Message-ID: <CAKwvOdm7ftWse5LVwM_0b_Zk_H-qavXsjsSyUmd0onZzvYcasw@mail.gmail.com>
Subject: Re: [PATCH v3] powerpc/inst: add PPC_TLBILX_LPID
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
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

On Thu, Aug 3, 2023 at 11:47=E2=80=AFAM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 03/08/2023 =C3=A0 20:33, Nick Desaulniers a =C3=A9crit :
> > Clang didn't recognize the instruction tlbilxlpid. This was fixed in
> > clang-18 [0] then backported to clang-17 [1].  To support clang-16 and
> > older, rather than using that instruction bare in inline asm, add it to
> > ppc-opcode.h and use that macro as is done elsewhere for other
> > instructions.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1891
> > Link: https://github.com/llvm/llvm-project/issues/64080
> > Link: https://github.com/llvm/llvm-project/commit/53648ac1d0c953ae6d008=
864dd2eddb437a92468 [0]
> > Link: https://github.com/llvm/llvm-project-release-prs/commit/0af7e5e54=
a8c7ac665773ac1ada328713e8338f5 [1]
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/llvm/202307211945.TSPcyOhh-lkp@intel.co=
m/
> > Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>
> Not sure why you changed the order of #includes , nevertheless

Habit to sort; can drop if maintaining git blame is more important
than cleaning that up.

>
> Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>
> > ---
> > Changes in v3:
> > - left comment @ https://github.com/linuxppc/issues/issues/350#issuecom=
ment-1664417212
> > - restore PPC_RAW_TLBILX previous definition
> > - fix comment style
> > - Link to v2: https://lore.kernel.org/r/20230803-ppc_tlbilxlpid-v2-1-21=
1ffa1df194@google.com
> >
> > Changes in v2:
> > - add 2 missing tabs to PPC_RAW_TLBILX_LPID
> > - Link to v1: https://lore.kernel.org/r/20230803-ppc_tlbilxlpid-v1-1-84=
a1bc5cf963@google.com
> > ---
> >   arch/powerpc/include/asm/ppc-opcode.h |  2 ++
> >   arch/powerpc/kvm/e500mc.c             | 11 ++++++++---
> >   2 files changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/inclu=
de/asm/ppc-opcode.h
> > index ef6972aa33b9..005601243dda 100644
> > --- a/arch/powerpc/include/asm/ppc-opcode.h
> > +++ b/arch/powerpc/include/asm/ppc-opcode.h
> > @@ -397,6 +397,7 @@
> >   #define PPC_RAW_RFCI                        (0x4c000066)
> >   #define PPC_RAW_RFDI                        (0x4c00004e)
> >   #define PPC_RAW_RFMCI                       (0x4c00004c)
> > +#define PPC_RAW_TLBILX_LPID          (0x7c000024)
> >   #define PPC_RAW_TLBILX(t, a, b)             (0x7c000024 | __PPC_T_TLB=
(t) |  __PPC_RA0(a) | __PPC_RB(b))
> >   #define PPC_RAW_WAIT_v203           (0x7c00007c)
> >   #define PPC_RAW_WAIT(w, p)          (0x7c00003c | __PPC_WC(w) | __PPC=
_PL(p))
> > @@ -616,6 +617,7 @@
> >   #define PPC_TLBILX(t, a, b) stringify_in_c(.long PPC_RAW_TLBILX(t, a,=
 b))
> >   #define PPC_TLBILX_ALL(a, b)        PPC_TLBILX(0, a, b)
> >   #define PPC_TLBILX_PID(a, b)        PPC_TLBILX(1, a, b)
> > +#define PPC_TLBILX_LPID              stringify_in_c(.long PPC_RAW_TLBI=
LX_LPID)
> >   #define PPC_TLBILX_VA(a, b) PPC_TLBILX(3, a, b)
> >   #define PPC_WAIT_v203               stringify_in_c(.long PPC_RAW_WAIT=
_v203)
> >   #define PPC_WAIT(w, p)              stringify_in_c(.long PPC_RAW_WAIT=
(w, p))
> > diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
> > index d58df71ace58..7c09c000c330 100644
> > --- a/arch/powerpc/kvm/e500mc.c
> > +++ b/arch/powerpc/kvm/e500mc.c
> > @@ -16,10 +16,11 @@
> >   #include <linux/miscdevice.h>
> >   #include <linux/module.h>
> >
> > -#include <asm/reg.h>
> >   #include <asm/cputable.h>
> > -#include <asm/kvm_ppc.h>
> >   #include <asm/dbell.h>
> > +#include <asm/kvm_ppc.h>
> > +#include <asm/ppc-opcode.h>
> > +#include <asm/reg.h>
> >
> >   #include "booke.h"
> >   #include "e500.h"
> > @@ -92,7 +93,11 @@ void kvmppc_e500_tlbil_all(struct kvmppc_vcpu_e500 *=
vcpu_e500)
> >
> >       local_irq_save(flags);
> >       mtspr(SPRN_MAS5, MAS5_SGS | get_lpid(&vcpu_e500->vcpu));
> > -     asm volatile("tlbilxlpid");
> > +     /*
> > +      * clang-17 and older could not assemble tlbilxlpid.
> > +      * https://github.com/ClangBuiltLinux/linux/issues/1891
> > +      */
> > +     asm volatile (PPC_TLBILX_LPID);
> >       mtspr(SPRN_MAS5, 0);
> >       local_irq_restore(flags);
> >   }
> >
> > ---
> > base-commit: 7bafbd4027ae86572f308c4ddf93120c90126332
> > change-id: 20230803-ppc_tlbilxlpid-cfdbf4fd4f7f
> >
> > Best regards,



--=20
Thanks,
~Nick Desaulniers
