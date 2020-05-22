Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9985D1DE0F6
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgEVHbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:31:14 -0400
Received: from elvis.franken.de ([193.175.24.41]:34215 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728854AbgEVHbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:31:13 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jc28x-0003HE-00; Fri, 22 May 2020 09:30:59 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id BD7EFC0155; Fri, 22 May 2020 09:27:43 +0200 (CEST)
Date:   Fri, 22 May 2020 09:27:43 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Huacai Chen <chenhc@lemote.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Cercueil <paul@crapouillou.net>,
        Zhou Yanjie <zhouyanjie@zoho.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Liangliang Huang <huanglllzu@gmail.com>,
        =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>, YunQiang Su <syq@debian.org>,
        Zou Wei <zou_wei@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Kamal Dasu <kdasu.kdev@gmail.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 03/13] mips: Add MIPS Release 5 support
Message-ID: <20200522072743.GA7331@alpha.franken.de>
References: <20200521140725.29571-1-Sergey.Semin@baikalelectronics.ru>
 <20200521140725.29571-4-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521140725.29571-4-Sergey.Semin@baikalelectronics.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 21, 2020 at 05:07:14PM +0300, Serge Semin wrote:
> There are five MIPS32/64 architecture releases currently available:
> from 1 to 6 except fourth one, which was intentionally skipped.
> Three of them can be called as major: 1st, 2nd and 6th, that not only
> have some system level alterations, but also introduced significant
> core/ISA level updates. The rest of the MIPS architecture releases are
> minor.
> 
> Even though they don't have as much ISA/system/core level changes
> as the major ones with respect to the previous releases, they still
> provide a set of updates (I'd say they were intended to be the
> intermediate releases before a major one) that might be useful for the
> kernel and user-level code, when activated by the kernel or compiler.
> In particular the following features were introduced or ended up being
> available at/after MIPS32/64 Release 5 architecture:
> + the last release of the misaligned memory access instructions,
> + virtualisation - VZ ASE - is optional component of the arch,
> + SIMD - MSA ASE - is optional component of the arch,
> + DSP ASE is optional component of the arch,
> + CP0.Status.FR=1 for CP1.FIR.F64=1 (pure 64-bit FPU general registers)
>   must be available if FPU is implemented,
> + CP1.FIR.Has2008 support is required so CP1.FCSR.{ABS2008,NAN2008} bits
>   are available.
> + UFR/UNFR aliases to access CP0.Status.FR from user-space by means of
>   ctc1/cfc1 instructions (enabled by CP0.Config5.UFR),
> + CP0.COnfig5.LLB=1 and eretnc instruction are implemented to without
>   accidentally clearing LL-bit when returning from an interrupt,
>   exception, or error trap,
> + XPA feature together with extended versions of CPx registers is
>   introduced, which needs to have mfhc0/mthc0 instructions available.
> 
> So due to these changes GNU GCC provides an extended instructions set
> support for MIPS32/64 Release 5 by default like eretnc/mfhc0/mthc0. Even
> though the architecture alteration isn't that big, it still worth to be
> taken into account by the kernel software. Finally we can't deny that
> some optimization/limitations might be found in future and implemented
> on some level in kernel or compiler. In this case having even
> intermediate MIPS architecture releases support would be more than
> useful.
> 
> So the most of the changes provided by this commit can be split into
> either compile- or runtime configs related. The compile-time related
> changes are caused by adding the new CONFIG_CPU_MIPS32_R5/CONFIG_CPU_MIPSR5
> configs and concern the code activating MIPSR2 or MIPSR6 already
> implemented features (like eretnc/LLbit, mthc0/mfhc0). In addition
> CPU_HAS_MSA can be now freely enabled for MIPS32/64 release 5 based
> platforms as this is done for CPU_MIPS32_R6 CPUs. The runtime changes
> concerns the features which are handled with respect to the MIPS ISA
> revision detected at run-time by means of CP0.Config.{AT,AR} bits. Alas
> these fields can be used to detect either r1 or r2 or r6 releases.
> But since we know which CPUs in fact support the R5 arch, we can manually
> set MIPS_CPU_ISA_M32R5/MIPS_CPU_ISA_M64R5 bit of c->isa_level and then
> use cpu_has_mips32r5/cpu_has_mips64r5 where it's appropriate.
> 
> Since XPA/EVA provide too complex alterationss and to have them used with
> MIPS32 Release 2 charged kernels (for compatibility with current platform
> configs) they are left to be setup as a separate kernel configs.
> 
> Co-developed-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Signed-off-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Paul Burton <paulburton@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> ---
>  arch/mips/Kconfig                    | 56 +++++++++++++++++++++++++---
>  arch/mips/Makefile                   |  2 +
>  arch/mips/include/asm/asmmacro.h     | 18 +++++----
>  arch/mips/include/asm/compiler.h     |  5 +++
>  arch/mips/include/asm/cpu-features.h | 27 ++++++++++----
>  arch/mips/include/asm/cpu-info.h     |  2 +-
>  arch/mips/include/asm/cpu-type.h     |  7 +++-
>  arch/mips/include/asm/cpu.h          | 10 +++--
>  arch/mips/include/asm/fpu.h          |  4 +-
>  arch/mips/include/asm/hazards.h      |  8 ++--
>  arch/mips/include/asm/module.h       |  4 ++
>  arch/mips/include/asm/stackframe.h   |  2 +-
>  arch/mips/include/asm/switch_to.h    |  8 ++--
>  arch/mips/kernel/cpu-probe.c         | 17 +++++++++
>  arch/mips/kernel/entry.S             |  6 +--
>  arch/mips/kernel/proc.c              |  4 ++
>  arch/mips/kernel/r4k_fpu.S           | 14 +++----
>  arch/mips/kvm/vz.c                   |  6 +--
>  arch/mips/lib/csum_partial.S         |  6 ++-
>  arch/mips/mm/c-r4k.c                 |  7 ++--
>  arch/mips/mm/sc-mips.c               |  7 ++--
>  21 files changed, 163 insertions(+), 57 deletions(-)

applied to mips-next. I've changed the two /* fall through */ by fallthrough;
while appliny. Running checkpatch would have caught that ;-)

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
