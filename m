Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A93EEB8C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 22:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbfKDVsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 16:48:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:20152 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730159AbfKDVsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 16:48:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:48:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="226887119"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 04 Nov 2019 13:48:51 -0800
Date:   Mon, 4 Nov 2019 13:48:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Message-ID: <20191104214851.GD5960@linux.intel.com>
References: <157290058655.2477.5193340480187879024.stgit@naples-babu.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157290058655.2477.5193340480187879024.stgit@naples-babu.amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 04, 2019 at 08:50:51PM +0000, Moger, Babu wrote:
> AMD 2nd generation EPYC processors support the UMIP (User-Mode
> Instruction Prevention) feature. So, rename X86_INTEL_UMIP to
> generic X86_UMIP and modify the text to cover both Intel and AMD.

There's a similar comment in the umip.c documentation that needs to be
updated, and a grammatical error that can be opportunistically fixed, i.e.

 * The feature User-Mode Instruction Prevention present in recent Intel
 * processor

to 

 * The feature User-Mode Instruction Prevention present in recent x86
 * processors


IMO, the whole opening paragraph of the umip.c docs is weirdly worded and
could be rewritten to something similar to the Kconfig help text, e.g.

 * User-Mode Instruction Prevention is a security feature present in recent x86
 * processors that, when enabled, prevents a group of instructions (SGDT, SIDT,
 * SLDT, SMSW and STR) from being run in user mode by issuing a general
 * protection fault if the instruction is executed with CPL > 0.

> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v2:
>   Learned that for the hardware that support UMIP, we dont need to
>   emulate. Removed the emulation related code and just submitting
>   the config changes.
> 
>  arch/x86/Kconfig                         |    8 ++++----
>  arch/x86/include/asm/disabled-features.h |    2 +-
>  arch/x86/include/asm/umip.h              |    4 ++--
>  arch/x86/kernel/Makefile                 |    2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d6e1faa28c58..821b7cebff31 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1880,13 +1880,13 @@ config X86_SMAP
>  
>  	  If unsure, say Y.
>  
> -config X86_INTEL_UMIP
> +config X86_UMIP
>  	def_bool y
> -	depends on CPU_SUP_INTEL
> -	prompt "Intel User Mode Instruction Prevention" if EXPERT
> +	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
> +	prompt "User Mode Instruction Prevention" if EXPERT
>  	---help---
>  	  The User Mode Instruction Prevention (UMIP) is a security

Maybe opportunistically drop "The"?

> -	  feature in newer Intel processors. If enabled, a general
> +	  feature in newer x86 processors. If enabled, a general
>  	  protection fault is issued if the SGDT, SLDT, SIDT, SMSW
>  	  or STR instructions are executed in user mode. These instructions
>  	  unnecessarily expose information about the hardware state.
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index a5ea841cc6d2..8e1d0bb46361 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -22,7 +22,7 @@
>  # define DISABLE_SMAP	(1<<(X86_FEATURE_SMAP & 31))
>  #endif
>  
> -#ifdef CONFIG_X86_INTEL_UMIP
> +#ifdef CONFIG_X86_UMIP
>  # define DISABLE_UMIP	0
>  #else
>  # define DISABLE_UMIP	(1<<(X86_FEATURE_UMIP & 31))
> diff --git a/arch/x86/include/asm/umip.h b/arch/x86/include/asm/umip.h
> index db43f2a0d92c..aeed98c3c9e1 100644
> --- a/arch/x86/include/asm/umip.h
> +++ b/arch/x86/include/asm/umip.h
> @@ -4,9 +4,9 @@
>  #include <linux/types.h>
>  #include <asm/ptrace.h>
>  
> -#ifdef CONFIG_X86_INTEL_UMIP
> +#ifdef CONFIG_X86_UMIP
>  bool fixup_umip_exception(struct pt_regs *regs);
>  #else
>  static inline bool fixup_umip_exception(struct pt_regs *regs) { return false; }
> -#endif  /* CONFIG_X86_INTEL_UMIP */
> +#endif  /* CONFIG_X86_UMIP */
>  #endif  /* _ASM_X86_UMIP_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 3578ad248bc9..52ce1e239525 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -134,7 +134,7 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
>  obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
>  obj-$(CONFIG_TRACING)			+= tracepoint.o
>  obj-$(CONFIG_SCHED_MC_PRIO)		+= itmt.o
> -obj-$(CONFIG_X86_INTEL_UMIP)		+= umip.o
> +obj-$(CONFIG_X86_UMIP)			+= umip.o
>  
>  obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
>  obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
> 
