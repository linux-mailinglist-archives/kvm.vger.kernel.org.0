Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F2438AA8E
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 13:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhETLPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 07:15:17 -0400
Received: from foss.arm.com ([217.140.110.172]:47082 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239675AbhETLMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 07:12:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4236311D4;
        Thu, 20 May 2021 04:11:25 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.235])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D94AC3F719;
        Thu, 20 May 2021 04:11:21 -0700 (PDT)
Date:   Thu, 20 May 2021 12:11:19 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Joe Richey <joerichey94@gmail.com>
Cc:     trivial@kernel.org, Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [PATCH 0/6] Don't use BIT() macro in UAPI headers
Message-ID: <20210520111119.GC17233@C02TD0UTHF1T.local>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, May 20, 2021 at 03:43:37AM -0700, Joe Richey wrote:
> From: Joe Richey <joerichey@google.com>
> 
> The BIT(n) macro is used in the kernel as an alias for (1 << n).
> However, it is not defined in the UAPI headers, which means that any
> UAPI header files must be careful not to use it, or else the user
> will get a linker error. 

Beware that the common definition of BIT() (in include/vdso/bits.h) is:

| #define BIT(nr)                 (UL(1) << (nr))

That UL() can be important if `nr` is ever greater than bits per int.

> For example, compiling the following program:
> 
>     #include <sys/auxv.h>
>     #include <asm/hwcap2.h>
> 
>     // Detect if FSGSBASE instructions are enabled
>     int main() {
>         unsigned long val = getauxval(AT_HWCAP2);
>         return !(val & HWCAP2_FSGSBASE);
>     }
> 
> Results in the following likner error:
> 
>     /usr/bin/ld: /tmp/cceFpAdR.o: in function `main':
>     gs.c:(.text+0x21): undefined reference to `BIT'
> 
> This patch series changes all UAPI uses of BIT() to just be open-coded.

In include/uapi/linux/const.h we have an equivaleint _BITUL() macro,
which I think should be used in preference of open-coding this (and is
already used in a number of uapi headers).

> However, there really should be a check for this in checkpatch.pl
> Currently, the script actually _encourages_ users to use the BIT macro
> even if adding things to UAPI.

I think having something that suggests s/BIT()/_BITUL()/ under uapi
would be good.

Thanks,
Mark.

> 
> Running `rg "BIT\(" **/uapi/**` shows no more usage of BIT() in any
> UAPI headers. Tested by building a basic kernel. Changes are trivial.
> 
> Joe Richey (6):
>   x86/elf: Don't use BIT() macro in UAPI headers
>   KVM: X86: Don't use BIT() macro in UAPI headers
>   drivers: firmware: psci: Don't use BIT() macro in UAPI headers
>   uacce: Don't use BIT() macro in UAPI headers
>   media: vicodec: Don't use BIT() macro in UAPI headers
>   tools headers UAPI: Sync pkt_sched.h with the kernel sources
> 
>  arch/x86/include/uapi/asm/hwcap2.h   |   2 +-
>  include/uapi/linux/kvm.h             |   4 +-
>  include/uapi/linux/psci.h            |   2 +-
>  include/uapi/linux/v4l2-controls.h   |  22 ++---
>  include/uapi/misc/uacce/uacce.h      |   2 +-
>  tools/include/uapi/linux/kvm.h       |   4 +-
>  tools/include/uapi/linux/pkt_sched.h | 122 ++++++++++++++++++++++++---
>  7 files changed, 130 insertions(+), 28 deletions(-)
> 
> -- 
> 2.31.1
> 
