Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16B150B558
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383225AbiDVKks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiDVKkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:40:47 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D7A554F8D
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 03:37:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CF881576;
        Fri, 22 Apr 2022 03:37:54 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBA063F766;
        Fri, 22 Apr 2022 03:37:52 -0700 (PDT)
Date:   Fri, 22 Apr 2022 11:37:48 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v2 kvmtool 0/5] Fix few small issues in virtio code
Message-ID: <YmKFfN0k8fXQmsdl@monolith.localdoman>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <YioRnsym4HmOSgjl@monolith.localdoman>
 <20220311112321.2f71b6bd@donnerap.cambridge.arm.com>
 <Yi926JwV50u86yRB@monolith.localdoman>
 <YkBcuwMi7gPy9Wew@sisu-ThinkPad-E14-Gen-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkBcuwMi7gPy9Wew@sisu-ThinkPad-E14-Gen-2>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Sun, Mar 27, 2022 at 03:46:51PM +0300, Martin Radev wrote:
> Thanks for the explanation and suggestion.
> Is this better?

Looks good to me, please send it as a separate patch in the next iteration
of the series.

Thanks,
Alex

> 
> From 4ed0d9d3d3c39eb5b23b04227c3fee53b77d9aa5 Mon Sep 17 00:00:00 2001
> From: Martin Radev <martin.b.radev@gmail.com>
> Date: Fri, 25 Mar 2022 23:25:42 +0200
> Subject: kvmtool: Have stack be not executable on x86
> 
> This patch fixes an issue of having the stack be executable
> for x86 builds by ensuring that the two objects bios-rom.o
> and entry.o have the section .note.GNU-stack.
> 
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  x86/bios/bios-rom.S | 5 +++++
>  x86/bios/entry.S    | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/x86/bios/bios-rom.S b/x86/bios/bios-rom.S
> index 3269ce9..d1c8b25 100644
> --- a/x86/bios/bios-rom.S
> +++ b/x86/bios/bios-rom.S
> @@ -10,3 +10,8 @@
>  GLOBAL(bios_rom)
>  	.incbin "x86/bios/bios.bin"
>  END(bios_rom)
> +
> +/*
> + * Add this section to ensure final binary has a non-executable stack.
> + */
> +.section .note.GNU-stack,"",@progbits
> diff --git a/x86/bios/entry.S b/x86/bios/entry.S
> index 85056e9..1b71f89 100644
> --- a/x86/bios/entry.S
> +++ b/x86/bios/entry.S
> @@ -90,3 +90,8 @@ GLOBAL(__locals)
>  #include "local.S"
>  
>  END(__locals)
> +
> +/*
> + * Add this section to ensure final binary has a non-executable stack.
> + */
> +.section .note.GNU-stack,"",@progbits
> -- 
> 2.25.1
> 
> On Mon, Mar 14, 2022 at 05:11:08PM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Fri, Mar 11, 2022 at 11:23:21AM +0000, Andre Przywara wrote:
> > > On Thu, 10 Mar 2022 14:56:30 +0000
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > > 
> > > Hi,
> > > 
> > > > Hi Martin,
> > > > 
> > > > On Fri, Mar 04, 2022 at 01:10:45AM +0200, Martin Radev wrote:
> > > > > Hello everyone,
> > > > >   
> > > > [..]
> > > > > The Makefile change is kept in its original form because I didn't understand
> > > > > if there is an issue with it on aarch64.  
> > > > 
> > > > I'll try to explain it better. According to this blogpost about executable
> > > > stacks [1], gcc marks the stack as executable automatically for assembly
> > > > (.S) files. C files have their stack mark as non-executable by default. If
> > > > any of the object files have the stack executable, then the resulting
> > > > binary also has the stack marked as executable (obviously).
> > > > 
> > > > To mark the stack as non-executable in assembly files, the empty section
> > > > .note.GNU-stack must be present in the file. This is a marking to tell
> > > > the linker that the final executable does not require an executable stack.
> > > > When the linker finds this section, it will create a PT_GNU_STACK empty
> > > > segment in the final executable. This segment tells Linux to mark the stack
> > > > as non-executable when it loads the binary.
> > > 
> > > Ah, many thanks for the explanation, that makes sense.
> > > 
> > > > The only assembly files that kvmtool compiles into objects are the x86
> > > > files x86/bios/entry.S and x86/bios/bios-rom.S; the other architectures are
> > > > not affected by this. I haven't found any instances where these files (and
> > > > the other files they are including) do a call/jmp to something on the
> > > > stack, so I've added the .note.GNU-Stack section to the files:
> > > 
> > > Yes, looks that the same to me, actually the assembly looks more like
> > > marshalling arguments than actual code, so we should be safe.
> > > 
> > > Alex, can you send this as a proper patch. It should be somewhat
> > > independent of Martin's series, code-wise, so at least it should apply and
> > > build.
> > 
> > Martin, would you like to pick up the diff and turn it into a proper patch? You
> > don't need to credit me as the author, you can just add a Suggested-by:
> > Alexandru Elisei <alexandru.elisei@arm.com> tag in the commit message. Or do you
> > want me to turn this into a patch? If I do, I'll add a Reported-by: Martin Radev
> > <martin.b.radev@gmail.com> tag to it.
> > 
> > I don't have a preference, I am asking because you were the first person who
> > discovered and tried to fix this.
> > 
> > Thanks,
> > Alex
> > 
> > > 
> > > Cheers,
> > > Andre
> > > 
> > > > 
> > > > diff --git a/x86/bios/bios-rom.S b/x86/bios/bios-rom.S
> > > > index 3269ce9793ae..571029fc157e 100644
> > > > --- a/x86/bios/bios-rom.S
> > > > +++ b/x86/bios/bios-rom.S
> > > > @@ -10,3 +10,6 @@
> > > >  GLOBAL(bios_rom)
> > > >         .incbin "x86/bios/bios.bin"
> > > >  END(bios_rom)
> > > > +
> > > > +# Mark the stack as non-executable.
> > > > +.section .note.GNU-stack,"",@progbits
> > > > diff --git a/x86/bios/entry.S b/x86/bios/entry.S
> > > > index 85056e9816c4..4d5bb663a25d 100644
> > > > --- a/x86/bios/entry.S
> > > > +++ b/x86/bios/entry.S
> > > > @@ -90,3 +90,6 @@ GLOBAL(__locals)
> > > >  #include "local.S"
> > > > 
> > > >  END(__locals)
> > > > +
> > > > +# Mark the stack as non-executable.
> > > > +.section .note.GNU-stack,"",@progbits
> > > > 
> > > > which makes the final executable have a non-executable stack. Did some very
> > > > *light* testing by booting a guest, and everything looked right to me.
> > > > 
> > > > [1] https://www.airs.com/blog/archives/518
> > > > 
> > > > Thanks,
> > > > Alex
> > > > 
> > > > > 
> > > > > Martin Radev (5):
> > > > >   kvmtool: Add WARN_ONCE macro
> > > > >   virtio: Sanitize config accesses
> > > > >   virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
> > > > >   Makefile: Mark stack as not executable
> > > > >   mmio: Sanitize addr and len
> > > > > 
> > > > >  Makefile                |  7 +++--
> > > > >  include/kvm/util.h      | 10 +++++++
> > > > >  include/kvm/virtio-9p.h |  1 +
> > > > >  include/kvm/virtio.h    |  3 ++-
> > > > >  mmio.c                  |  4 +++
> > > > >  virtio/9p.c             | 27 ++++++++++++++-----
> > > > >  virtio/balloon.c        | 10 ++++++-
> > > > >  virtio/blk.c            | 10 ++++++-
> > > > >  virtio/console.c        | 10 ++++++-
> > > > >  virtio/mmio.c           | 44 +++++++++++++++++++++++++-----
> > > > >  virtio/net.c            | 12 +++++++--
> > > > >  virtio/pci.c            | 59 ++++++++++++++++++++++++++++++++++++++---
> > > > >  virtio/rng.c            |  8 +++++-
> > > > >  virtio/scsi.c           | 10 ++++++-
> > > > >  virtio/vsock.c          | 10 ++++++-
> > > > >  15 files changed, 199 insertions(+), 26 deletions(-)
> > > > > 
> > > > > -- 
> > > > > 2.25.1
> > > > >   
> > > 
