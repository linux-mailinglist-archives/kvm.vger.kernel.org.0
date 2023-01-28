Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EF567F561
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 08:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbjA1HJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 02:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbjA1HJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 02:09:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D839283954
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:09:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC77606A0
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 07:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB54C4339E
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 07:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674889771;
        bh=qJThY7YRiVSuNivcV0ILDJW5OwSM/MJ4pv8XOsXc6dk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mds+xA37E8kRpu4vHJJXUm0j/D8D5E0nD5+eHg00dKoA51mVWFgPrcbrtINusRV6N
         FuiAwdcY5978See3nllrqaeHnQVQBZ1WHFw/LfFgb5SSGafLZ4um06bLUSydn6r8H1
         U0snIC7P3/3QUAdZjlBmn94WlZE2fgyd6meb0JApkehuASVnRW49c38FsW5YmZ9YOW
         kWPZ8XZEOGGeAKupQmKGSYhVjmge8VgAcbsk5g9Nd4rgWbnwVC1VOUTiUR2Nuv4qs8
         gUpmeA8rySilM67g6iB3Tl1JzG+GQosZzd67u0TRM9eor1BpwvayPjDWLnnRviwyuT
         KLeOWOZ/eIEsg==
Received: by mail-ed1-f44.google.com with SMTP id x10so6547085edd.10
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 23:09:31 -0800 (PST)
X-Gm-Message-State: AFqh2kr/nEiO+fAQvm0zNmfzsiv6KjvT4RhX879IfZXB0y5vpbI8zd2G
        ZZYu5sCJot1HUtus37EUP52L+8RKXkUuL9iZyLc=
X-Google-Smtp-Source: AMrXdXugvUr0SATK9iPUumiyHbSFs/2xyipGCcI/X1Gy3iqXqmW3lzC+KhXQR4oqpVtlha3AUV4zGYHMI7rxW9SM75k=
X-Received: by 2002:a05:6402:488:b0:499:c343:30e3 with SMTP id
 k8-20020a056402048800b00499c34330e3mr6630035edv.4.1674889769910; Fri, 27 Jan
 2023 23:09:29 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-3-andy.chiu@sifive.com>
 <Y9GgKiF8q2k9eRdh@spud>
In-Reply-To: <Y9GgKiF8q2k9eRdh@spud>
From:   Guo Ren <guoren@kernel.org>
Date:   Sat, 28 Jan 2023 15:09:18 +0800
X-Gmail-Original-Message-ID: <CAJF2gTS11DcKuSBRQfn9AkU0YP=ry-FV=cH=Au5m3Us=1gVTQQ@mail.gmail.com>
Message-ID: <CAJF2gTS11DcKuSBRQfn9AkU0YP=ry-FV=cH=Au5m3Us=1gVTQQ@mail.gmail.com>
Subject: Re: [PATCH -next v13 02/19] riscv: Extending cpufeature.c to detect V-extension
To:     Conor Dooley <conor@kernel.org>
Cc:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko@sntech.de>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dao Lu <daolu@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Tsukasa OI <research_trasio@irq.a4lg.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 5:33 AM Conor Dooley <conor@kernel.org> wrote:
>
> On Wed, Jan 25, 2023 at 02:20:39PM +0000, Andy Chiu wrote:
> > From: Guo Ren <ren_guo@c-sky.com>
> >
> > Add V-extension into riscv_isa_ext_keys array and detect it with isa
> > string parsing.
> >
> > Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > ---
> >  arch/riscv/include/asm/hwcap.h      |  4 ++++
> >  arch/riscv/include/asm/vector.h     | 26 ++++++++++++++++++++++++++
> >  arch/riscv/include/uapi/asm/hwcap.h |  1 +
> >  arch/riscv/kernel/cpufeature.c      | 12 ++++++++++++
> >  4 files changed, 43 insertions(+)
> >  create mode 100644 arch/riscv/include/asm/vector.h
> >
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > index 57439da71c77..f413db6118e5 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -35,6 +35,7 @@ extern unsigned long elf_hwcap;
> >  #define RISCV_ISA_EXT_m              ('m' - 'a')
> >  #define RISCV_ISA_EXT_s              ('s' - 'a')
> >  #define RISCV_ISA_EXT_u              ('u' - 'a')
> > +#define RISCV_ISA_EXT_v              ('v' - 'a')
> >
> >  /*
> >   * Increse this to higher value as kernel support more ISA extensions.
> > @@ -73,6 +74,7 @@ static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
> >  enum riscv_isa_ext_key {
> >       RISCV_ISA_EXT_KEY_FPU,          /* For 'F' and 'D' */
> >       RISCV_ISA_EXT_KEY_SVINVAL,
> > +     RISCV_ISA_EXT_KEY_VECTOR,       /* For 'V' */
>
> That's obvious surely, no?
>
> >       RISCV_ISA_EXT_KEY_ZIHINTPAUSE,
> >       RISCV_ISA_EXT_KEY_MAX,
> >  };
> > @@ -95,6 +97,8 @@ static __always_inline int riscv_isa_ext2key(int num)
>
> You should probably check out Jisheng's series that deletes whole
> sections of this code, including this whole function.
> https://lore.kernel.org/all/20230115154953.831-3-jszhang@kernel.org/T/#u
Has that patch merged? It could be solved during the rebase for-next naturally.

>
>
> > @@ -256,6 +257,17 @@ void __init riscv_fill_hwcap(void)
> >               elf_hwcap &= ~COMPAT_HWCAP_ISA_F;
> >       }
> >
> > +     if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
> > +#ifndef CONFIG_RISCV_ISA_V
> > +             /*
> > +              * ISA string in device tree might have 'v' flag, but
> > +              * CONFIG_RISCV_ISA_V is disabled in kernel.
> > +              * Clear V flag in elf_hwcap if CONFIG_RISCV_ISA_V is disabled.
> > +              */
> > +             elf_hwcap &= ~COMPAT_HWCAP_ISA_V;
> > +#endif
       if (elf_hwcap & COMPAT_HWCAP_ISA_V && !IS_ENABLED(CONFIG_RISCV_ISA_V)) {

right?
>
> I know that a later patch in this series calls rvv_enable() here, which
> I'll comment on there, but I'd rather see IS_ENABLED as opposed to
> ifdefs in C files where possible.
>
> Thanks,
> Conor.
>


-- 
Best Regards
 Guo Ren
