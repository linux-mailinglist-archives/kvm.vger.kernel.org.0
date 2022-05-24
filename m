Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C647B5324F8
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 10:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiEXILj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 04:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiEXILh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 04:11:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D19BDF25
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 01:11:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADE131FB;
        Tue, 24 May 2022 01:11:35 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFC0D3F66F;
        Tue, 24 May 2022 01:11:34 -0700 (PDT)
Date:   Tue, 24 May 2022 09:11:50 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Dao Lu <daolu@rivosinc.com>
Cc:     will@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool] Fixes: 0febaae00bb6 ("Add asm/kernel.h for
 riscv")
Message-ID: <YoyTRncQ2geRtMDn@monolith.localdoman>
References: <20220520180946.104214-1-daolu@rivosinc.com>
 <YotUdkD2LIKqhYKq@monolith.localdoman>
 <YotVCkpajnskhQm9@monolith.localdoman>
 <CAKh7v-Rm3Mtid7KymrbSwwVRoC=S1J0f4CSCbpHXmi1SA45omA@mail.gmail.com>
 <You2EZ0xBWD29suJ@monolith.localdoman>
 <CAKh7v-Rnbs1uOGcDrB6a3+MFKbZX1_-4tgWJH-EKp_Wxd76D=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKh7v-Rnbs1uOGcDrB6a3+MFKbZX1_-4tgWJH-EKp_Wxd76D=Q@mail.gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, May 23, 2022 at 12:15:55PM -0700, Dao Lu wrote:
> Hi Alex,
> 
> After talking with my colleague I have some additional questions about
> what number we want to put there, as of now there is already a patch
> that will increase the range in Kconfig to 2-512:
> 
> https://lore.kernel.org/lkml/CAOnJCUJrN4frY_OdQzO-yr5CrDLvj=ge9KY2d=XnGvAF-uQNvQ@mail.gmail.com/T/
> 
> It seems like a moving target and as riscv develops we kinda expect
> this number will grow further. Do you think it is ok for me to at
> least set it to 512, if not 4096 at this time?

It's up to you in the end, I'm not familiar with the riscv architecture.

NR_CPUS is only used at the moment when creating a cpumask, where it
represents the maximum number of bits in the bitmask (bits, not bytes). So
NR_CPUS=512 means that the cpumask will contain 8 unsigned longs, while with
4096 it will contain 64 unsigned longs.

Cpumasks are only used by the arm64 code so far, so the value that you
choose won't affect existing code.

Thanks,
Alex

> 
> Thanks,
> Dao
> 
> On Mon, May 23, 2022 at 9:27 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> > On Mon, May 23, 2022 at 09:04:04AM -0700, Dao Lu wrote:
> > > Hi Alex,
> > >
> > > Thanks for pointing that out - I wasn't sure where the number came
> > > from so I basically copied from the arm one just so the compilation
> > > can pass.
> >
> > I see, I was worried that I was looking in the wrong place.
> >
> > >
> > > I am happy to fix up the number to 32 and add the compile error
> > > message to the commit message like you said - would something like
> > > this work?
> > > -------
> > > Fixes the following compilation issue:
> > >
> > > include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file
> > > or directory
> > >     5 | #include "asm/kernel.h"
> > > -------
> >
> > Sounds good, thanks:
> > Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > With the error message added:
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > Thanks,
> > Alex
> >
> > > Thanks,
> > > Dao
> > >
> > > On Mon, May 23, 2022 at 2:33 AM Alexandru Elisei
> > > <alexandru.elisei@arm.com> wrote:
> > > >
> > > > Adding the kvmtool maintainers, I just noticed that they were missing.
> > > >
> > > > On Mon, May 23, 2022 at 10:31:34AM +0100, Alexandru Elisei wrote:
> > > > > Hi,
> > > > >
> > > > > When I started working on the heterogeneous PMU series, support for the
> > > > > riscv architecture wasn't merged in kvmtool, and after riscv was merged I
> > > > > missed adding the header file.
> > > > >
> > > > > This indeed fixes this compilation error:
> > > > >
> > > > > In file included from include/linux/rbtree.h:32,
> > > > >                  from include/kvm/devices.h:4,
> > > > >                  from include/kvm/pci.h:10,
> > > > >                  from include/kvm/vfio.h:6,
> > > > >                  from include/kvm/kvm-config.h:5,
> > > > >                  from include/kvm/kvm.h:6:
> > > > > include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file or directory
> > > > >     5 | #include "asm/kernel.h"
> > > > >       |          ^~~~~~~~~~~~~~
> > > > > cc1: all warnings being treated as errors
> > > > > compilation terminated.
> > > > > make: *** [Makefile:484: builtin-balloon.o] Error 1
> > > > >
> > > > > Would be nice to include it in the commit message, so people googling for
> > > > > that exact error message can come across this commit.
> > > > >
> > > > > On Fri, May 20, 2022 at 11:09:46AM -0700, Dao Lu wrote:
> > > > > > Signed-off-by: Dao Lu <daolu@rivosinc.com>
> > > > > > ---
> > > > > >  riscv/include/asm/kernel.h | 8 ++++++++
> > > > > >  1 file changed, 8 insertions(+)
> > > > > >  create mode 100644 riscv/include/asm/kernel.h
> > > > > >
> > > > > > diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
> > > > > > new file mode 100644
> > > > > > index 0000000..a2a8d9e
> > > > > > --- /dev/null
> > > > > > +++ b/riscv/include/asm/kernel.h
> > > > > > @@ -0,0 +1,8 @@
> > > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > > +
> > > > > > +#ifndef __ASM_KERNEL_H
> > > > > > +#define __ASM_KERNEL_H
> > > > > > +
> > > > > > +#define NR_CPUS    4096
> > > > >
> > > > > In arch/riscv/Kconfig I see this:
> > > > >
> > > > > config NR_CPUS
> > > > >       int "Maximum number of CPUs (2-32)"
> > > > >       range 2 32
> > > > >       depends on SMP
> > > > >       default "8"
> > > > >
> > > > > Would you mind explaining where the 4096 number of CPUs comes from?
> > > > >
> > > > > Thanks,
> > > > > Alex
> > > > >
> > > > > > +
> > > > > > +#endif /* __ASM_KERNEL_H */
> > > > > > --
> > > > > > 2.36.0
> > > > > >
