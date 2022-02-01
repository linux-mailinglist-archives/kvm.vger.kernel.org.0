Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A534A6032
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 16:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbiBAPdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 10:33:10 -0500
Received: from foss.arm.com ([217.140.110.172]:47290 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbiBAPdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 10:33:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 757CA113E;
        Tue,  1 Feb 2022 07:33:09 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9296D3F40C;
        Tue,  1 Feb 2022 07:33:08 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:33:17 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool 4/5] Makefile: Mark stack as not executable
Message-ID: <YflSrmdG7OPdGDI7@monolith.localdoman>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
 <e90b5826343e0e5858db015df44e4eaa332bd938.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e90b5826343e0e5858db015df44e4eaa332bd938.1642457047.git.martin.b.radev@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Martin,

On Tue, Jan 18, 2022 at 12:12:02AM +0200, Martin Radev wrote:
> This patch modifies CFLAGS to mark the stack explicitly
> as not executable.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> ---
>  Makefile | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index f251147..09ef282 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -380,8 +380,11 @@ DEFINES	+= -D_GNU_SOURCE
>  DEFINES	+= -DKVMTOOLS_VERSION='"$(KVMTOOLS_VERSION)"'
>  DEFINES	+= -DBUILD_ARCH='"$(ARCH)"'
>  
> +# The stack doesn't need to be executable
> +SECURITY_HARDENINGS := -z noexecstack
> +
>  KVM_INCLUDE := include
> -CFLAGS	+= $(CPPFLAGS) $(DEFINES) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g
> +CFLAGS	+= $(CPPFLAGS) $(DEFINES) $(SECURITY_HARDENINGS) -I$(KVM_INCLUDE) -I$(ARCH_INCLUDE) -O2 -fno-strict-aliasing -g

I used scanelf to check that the final binary has the stack marked as
executable. For arm and arm64 I got this:

$ scanelf -e lkvm
 TYPE   STK/REL/PTL FILE
ET_DYN RW- R-- RW- lkvm

which as far as I can tell means the stack is not executable.

For x86:

$ scanelf -e lkvm
 TYPE   STK/REL/PTL FILE
ET_DYN RWX R-- RW- vm

which means the stack is executable. Digging further, it looks like there
are two objects which are missing the .note.GNU-stack section,
x86/bios/entry.o and x86/bios/bios-rom.o. I suggest you try to fix the
source files for those two objects before adding the flag to gcc. I used
the Gentoo wiki [1] to diagnose the problem, in case it's useful to you.

[1] https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart

Thanks,
Alex

>  
>  WARNINGS += -Wall
>  WARNINGS += -Wformat=2
> @@ -582,4 +585,4 @@ ifneq ($(MAKECMDGOALS),clean)
>  
>  KVMTOOLS-VERSION-FILE:
>  	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
> -endif
> \ No newline at end of file
> +endif
> -- 
> 2.25.1
> 
