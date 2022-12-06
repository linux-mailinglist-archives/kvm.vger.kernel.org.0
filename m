Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DA1643C44
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 05:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiLFEaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 23:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLFE34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 23:29:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A454BC3A;
        Mon,  5 Dec 2022 20:29:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55C9BB81698;
        Tue,  6 Dec 2022 04:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEC4C43148;
        Tue,  6 Dec 2022 04:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670300991;
        bh=XUnacoeF5yXfIeKrKNdeKKCmSBmbmdDPu8G2Ol5gSpc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gWamiKgz3VX+Yw09lHLA2LxW9F/qImjf7t0OXzmBnx9kch+P3JYNo5Xf9LhM2v0O7
         QXwxLpEGrUFQxFBI+iduC/plOWI5cII82rMdiUMJbOeucaFerIDjfE9aZHFZPyVhN1
         NaMLY5AdRFj1tkyeHwNsqXOyKmy3C1tZPvBm1qRwmB/pTOR16xXTGvVPdPu68TOgRh
         Al91UTzbiVmPiLp9tYoIAL8vcMCQRlRpue4+ySyRyQGi6Px0TnikLNZwqwkwxihnWG
         99tyEBZx/tI9rLP/nD+3yzA/wz1VraLTPHJPRsggTORzHDiA5QTgvrV+5fLqZpPOmj
         /f6OywaNZDR8Q==
Received: by mail-ed1-f50.google.com with SMTP id e13so18611569edj.7;
        Mon, 05 Dec 2022 20:29:50 -0800 (PST)
X-Gm-Message-State: ANoB5pliq0jUlnlmRJxgu4br8AL/0vR2C7TGWe0JdPgzBNQbD1J7GRr3
        td4nhsBbcTww4F/63jfka1UUD1PmpXhnaqoRo4I=
X-Google-Smtp-Source: AA0mqf7YBSxN94Yi+YLxbPof3lmR+Ui+89LqMINsb4Z+Pc4tmQ0myAlsKfQfI8ytUrwf302j2H8gh0mS7Xd5wONewss=
X-Received: by 2002:a05:6402:1117:b0:46b:6da7:e8a9 with SMTP id
 u23-20020a056402111700b0046b6da7e8a9mr28571704edv.401.1670300989129; Mon, 05
 Dec 2022 20:29:49 -0800 (PST)
MIME-Version: 1.0
References: <20221204174632.3677-1-jszhang@kernel.org> <20221204174632.3677-11-jszhang@kernel.org>
 <CAJF2gTR5VW0m=czqF2cQOcX5Vstow6EsuT044_E4WLo-NeVCOg@mail.gmail.com> <Y44M5vHaqglLvL3c@xhacker>
In-Reply-To: <Y44M5vHaqglLvL3c@xhacker>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 6 Dec 2022 12:29:37 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQW2GP6X-tOyt=4qN-vYGcBbbFeSvnmGXBq2T1Bm226FA@mail.gmail.com>
Message-ID: <CAJF2gTQW2GP6X-tOyt=4qN-vYGcBbbFeSvnmGXBq2T1Bm226FA@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] riscv: alternative: patch alternatives in the vDSO
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 5, 2022 at 11:33 PM Jisheng Zhang <jszhang@kernel.org> wrote:
>
> On Mon, Dec 05, 2022 at 09:56:37AM +0800, Guo Ren wrote:
> > Are there any patches that depend on it? Any existing utilization? My
> > first idea is to let __vdso_flush_icache use it, the standard
> > implementation is so heavy for user space JIT scenario, maybe vendors
> > could give a custom one.
>
> Hi Guo,
>
> the 11th patch of swtiching cpu_relax() to riscv_has_extension_likely()
> depends on this patch, the gettimeofday implementation calls cpu_relax()
> which may use ZIHINTPAUSE extension, so we need to patch vDSO.
Oh, I missed that. Thx.

Reviewed-by: Guo Ren <guoren@kernel.org>

>
> Thanks
>
> >
> > On Mon, Dec 5, 2022 at 1:57 AM Jisheng Zhang <jszhang@kernel.org> wrote:
> > >
> > > Make it possible to use alternatives in the vDSO, so that better
> > > implementations can be used if possible.
> > >
> > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > ---
> > >  arch/riscv/include/asm/vdso.h     |  4 ++++
> > >  arch/riscv/kernel/alternative.c   | 25 +++++++++++++++++++++++++
> > >  arch/riscv/kernel/vdso.c          |  5 -----
> > >  arch/riscv/kernel/vdso/vdso.lds.S |  7 +++++++
> > >  4 files changed, 36 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
> > > index af981426fe0f..b6ff7473fb8a 100644
> > > --- a/arch/riscv/include/asm/vdso.h
> > > +++ b/arch/riscv/include/asm/vdso.h
> > > @@ -28,8 +28,12 @@
> > >  #define COMPAT_VDSO_SYMBOL(base, name)                                         \
> > >         (void __user *)((unsigned long)(base) + compat__vdso_##name##_offset)
> > >
> > > +extern char compat_vdso_start[], compat_vdso_end[];
> > > +
> > >  #endif /* CONFIG_COMPAT */
> > >
> > > +extern char vdso_start[], vdso_end[];
> > > +
> > >  #endif /* !__ASSEMBLY__ */
> > >
> > >  #endif /* CONFIG_MMU */
> > > diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
> > > index 9d88375624b5..eaf7ddaba54c 100644
> > > --- a/arch/riscv/kernel/alternative.c
> > > +++ b/arch/riscv/kernel/alternative.c
> > > @@ -11,7 +11,9 @@
> > >  #include <linux/cpu.h>
> > >  #include <linux/uaccess.h>
> > >  #include <asm/alternative.h>
> > > +#include <asm/module.h>
> > >  #include <asm/sections.h>
> > > +#include <asm/vdso.h>
> > >  #include <asm/vendorid_list.h>
> > >  #include <asm/sbi.h>
> > >  #include <asm/csr.h>
> > > @@ -187,6 +189,27 @@ static void __init_or_module _apply_alternatives(struct alt_entry *begin,
> > >                                 stage);
> > >  }
> > >
> > > +static void __init apply_vdso_alternatives(void)
> > > +{
> > > +       const struct elf64_hdr *hdr;
> > > +       const struct elf64_shdr *shdr;
> > > +       const struct elf64_shdr *alt;
> > > +       struct alt_entry *begin, *end;
> > > +
> > > +       hdr = (struct elf64_hdr *)vdso_start;
> > > +       shdr = (void *)hdr + hdr->e_shoff;
> > > +       alt = find_section(hdr, shdr, ".alternative");
> > > +       if (!alt)
> > > +               return;
> > > +
> > > +       begin = (void *)hdr + alt->sh_offset,
> > > +       end = (void *)hdr + alt->sh_offset + alt->sh_size,
> > > +
> > > +       _apply_alternatives((struct alt_entry *)begin,
> > > +                           (struct alt_entry *)end,
> > > +                           RISCV_ALTERNATIVES_BOOT);
> > > +}
> > > +
> > >  void __init apply_boot_alternatives(void)
> > >  {
> > >         /* If called on non-boot cpu things could go wrong */
> > > @@ -195,6 +218,8 @@ void __init apply_boot_alternatives(void)
> > >         _apply_alternatives((struct alt_entry *)__alt_start,
> > >                             (struct alt_entry *)__alt_end,
> > >                             RISCV_ALTERNATIVES_BOOT);
> > > +
> > > +       apply_vdso_alternatives();
> > >  }
> > >
> > >  /*
> > > diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
> > > index 123d05255fcf..1f47bc6566cf 100644
> > > --- a/arch/riscv/kernel/vdso.c
> > > +++ b/arch/riscv/kernel/vdso.c
> > > @@ -22,11 +22,6 @@ struct vdso_data {
> > >  };
> > >  #endif
> > >
> > > -extern char vdso_start[], vdso_end[];
> > > -#ifdef CONFIG_COMPAT
> > > -extern char compat_vdso_start[], compat_vdso_end[];
> > > -#endif
> > > -
> > >  enum vvar_pages {
> > >         VVAR_DATA_PAGE_OFFSET,
> > >         VVAR_TIMENS_PAGE_OFFSET,
> > > diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
> > > index 150b1a572e61..4a0606633290 100644
> > > --- a/arch/riscv/kernel/vdso/vdso.lds.S
> > > +++ b/arch/riscv/kernel/vdso/vdso.lds.S
> > > @@ -40,6 +40,13 @@ SECTIONS
> > >         . = 0x800;
> > >         .text           : { *(.text .text.*) }          :text
> > >
> > > +       . = ALIGN(4);
> > > +       .alternative : {
> > > +               __alt_start = .;
> > > +               *(.alternative)
> > > +               __alt_end = .;
> > > +       }
> > > +
> > >         .data           : {
> > >                 *(.got.plt) *(.got)
> > >                 *(.data .data.* .gnu.linkonce.d.*)
> > > --
> > > 2.37.2
> > >
> >
> >
> > --
> > Best Regards
> >  Guo Ren



-- 
Best Regards
 Guo Ren
