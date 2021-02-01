Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D93830B0CB
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 20:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhBATu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 14:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbhBATtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 14:49:13 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5CFC06174A;
        Mon,  1 Feb 2021 11:48:33 -0800 (PST)
Received: from zn.tnic (p200300ec2f06fe00e55f3102cc5eb27e.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:fe00:e55f:3102:cc5e:b27e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 26BD61EC0253;
        Mon,  1 Feb 2021 20:48:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1612208910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lOkZrEeAn9oVnNn743NqAyVIKQ3k9/Lp3V74SDhkd64=;
        b=EM+rZpLJ9tNc2VbuYUaopFlP03mUsRMmq8qq/pgZ3JJsI6Y/KowJvU44oGPkeeGAD2qPsa
        j3K801BVFENduL2KRFMJ4dbHjY93xQqSdkCzV0oRKi2WduQAxPNz6//O0rJUMn7L41a83g
        pwy9/FLLvDRay4tdxWs6a0Sjt8mlIoM=
Date:   Mon, 1 Feb 2021 20:48:28 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v4 07/15] x86/paravirt: switch time pvops functions to
 use static_call()
Message-ID: <20210201194828.GB14590@zn.tnic>
References: <20210120135555.32594-1-jgross@suse.com>
 <20210120135555.32594-8-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210120135555.32594-8-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 02:55:47PM +0100, Juergen Gross wrote:
> The time pvops functions are the only ones left which might be
> used in 32-bit mode and which return a 64-bit value.
> 
> Switch them to use the static_call() mechanism instead of pvops, as
> this allows quite some simplification of the pvops implementation.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V4:
> - drop paravirt_time.h again
> - don't move Hyper-V code (Michael Kelley)
> ---
>  arch/x86/Kconfig                      |  1 +
>  arch/x86/include/asm/mshyperv.h       |  2 +-
>  arch/x86/include/asm/paravirt.h       | 17 ++++++++++++++---
>  arch/x86/include/asm/paravirt_types.h |  6 ------
>  arch/x86/kernel/cpu/vmware.c          |  5 +++--
>  arch/x86/kernel/kvm.c                 |  2 +-
>  arch/x86/kernel/kvmclock.c            |  2 +-
>  arch/x86/kernel/paravirt.c            | 16 ++++++++++++----
>  arch/x86/kernel/tsc.c                 |  2 +-
>  arch/x86/xen/time.c                   | 11 ++++-------
>  drivers/clocksource/hyperv_timer.c    |  5 +++--
>  drivers/xen/time.c                    |  2 +-
>  12 files changed, 42 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 21f851179ff0..7ccd4a80788c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -771,6 +771,7 @@ if HYPERVISOR_GUEST
>  
>  config PARAVIRT
>  	bool "Enable paravirtualization code"
> +	depends on HAVE_STATIC_CALL
>  	help
>  	  This changes the kernel so it can modify itself when it is run
>  	  under a hypervisor, potentially improving performance significantly
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
> index 30f76b966857..b4ee331d29a7 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -63,7 +63,7 @@ typedef int (*hyperv_fill_flush_list_func)(
>  static __always_inline void hv_setup_sched_clock(void *sched_clock)
>  {
>  #ifdef CONFIG_PARAVIRT
> -	pv_ops.time.sched_clock = sched_clock;
> +	paravirt_set_sched_clock(sched_clock);
>  #endif
>  }
>  
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 4abf110e2243..1e45b46fae84 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -15,11 +15,22 @@
>  #include <linux/bug.h>
>  #include <linux/types.h>
>  #include <linux/cpumask.h>
> +#include <linux/static_call_types.h>
>  #include <asm/frame.h>
>  
> -static inline unsigned long long paravirt_sched_clock(void)
> +u64 dummy_steal_clock(int cpu);
> +u64 dummy_sched_clock(void);
> +
> +DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
> +DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);

Did you build this before sending?

I'm test-applying this on rc6 + tip/master so I probably am using a
different tree so it looks like something has changed in the meantime.
-rc6 has a couple of Xen changes which made applying those to need some
wiggling in...

Maybe you should redo them ontop of tip/master. That is, *if* they're
going to eventually go through tip. The diffstat has Xen stuff too so we
might need some synchronization here what goes where how...

./arch/x86/include/asm/paravirt.h:24:1: warning: data definition has no type or storage class
   24 | DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
      | ^~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/paravirt.h:24:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_CALL’ [-Werror=implicit-int]
./arch/x86/include/asm/paravirt.h:24:1: warning: parameter names (without types) in function declaration
./arch/x86/include/asm/paravirt.h:25:1: warning: data definition has no type or storage class
   25 | DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);
      | ^~~~~~~~~~~~~~~~~~~
./arch/x86/include/asm/paravirt.h:25:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_CALL’ [-Werror=implicit-int]
./arch/x86/include/asm/paravirt.h:25:1: warning: parameter names (without types) in function declaration
./arch/x86/include/asm/paravirt.h: In function ‘paravirt_sched_clock’:
./arch/x86/include/asm/paravirt.h:33:9: error: implicit declaration of function ‘static_call’ [-Werror=implicit-function-declaration]
   33 |  return static_call(pv_sched_clock)();
      |         ^~~~~~~~~~~
./arch/x86/include/asm/paravirt.h:33:21: error: ‘pv_sched_clock’ undeclared (first use in this function); did you mean ‘dummy_sched_clock’?
   33 |  return static_call(pv_sched_clock)();
      |                     ^~~~~~~~~~~~~~
      |                     dummy_sched_clock
./arch/x86/include/asm/paravirt.h:33:21: note: each undeclared identifier is reported only once for each function it appears in
./arch/x86/include/asm/paravirt.h: In function ‘paravirt_steal_clock’:
./arch/x86/include/asm/paravirt.h:47:21: error: ‘pv_steal_clock’ undeclared (first use in this function); did you mean ‘dummy_steal_clock’?
   47 |  return static_call(pv_steal_clock)(cpu);
      |                     ^~~~~~~~~~~~~~
      |                     dummy_steal_clock
cc1: some warnings being treated as errors
make[1]: *** [scripts/Makefile.build:117: arch/x86/kernel/asm-offsets.s] Error 1
make: *** [Makefile:1200: prepare0] Error 2

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
