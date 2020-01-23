Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2524146CE7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 16:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAWPc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 10:32:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:14235 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgAWPc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 10:32:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 07:32:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="427845964"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jan 2020 07:32:24 -0800
Date:   Thu, 23 Jan 2020 07:32:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Benjamin Thiel <b.thiel@posteo.de>
Cc:     X86 ML <x86@kernel.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/cpu: Move prototype for get_umwait_control_msr() to
 global location
Message-ID: <20200123153224.GA13178@linux.intel.com>
References: <20200123140113.8447-1-b.thiel@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123140113.8447-1-b.thiel@posteo.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 23, 2020 at 03:01:13PM +0100, Benjamin Thiel wrote:
> .. in order to fix a -Wmissing-prototype warning.
> 
> No functional change.
> 
> Signed-off-by: Benjamin Thiel <b.thiel@posteo.de>
> ---
>  arch/x86/include/asm/mwait.h | 2 ++
>  arch/x86/kernel/cpu/umwait.c | 1 +
>  arch/x86/kvm/vmx/vmx.c       | 1 +
>  arch/x86/kvm/vmx/vmx.h       | 2 --
>  4 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
> index 9d5252c9685c..83b296ffc85a 100644
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -23,6 +23,8 @@
>  #define MWAITX_MAX_LOOPS		((u32)-1)
>  #define MWAITX_DISABLE_CSTATES		0xf0
>  
> +extern u32 get_umwait_control_msr(void);

Nit: extern isn't needed on function declarations.  It shouldn't have been
added in the VMX code, but I'm guessing the author saw the externs on the
vmx_msr_index and host_efer variables and followed suite.  Since there is
no existing precedent in mwait.h, now would be a good time to drop it.

> +
>  static inline void __monitor(const void *eax, unsigned long ecx,
>  			     unsigned long edx)
>  {
> diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
> index c222f283b456..300e3fd5ade3 100644
> --- a/arch/x86/kernel/cpu/umwait.c
> +++ b/arch/x86/kernel/cpu/umwait.c
> @@ -4,6 +4,7 @@
>  #include <linux/cpu.h>
>  
>  #include <asm/msr.h>
> +#include <asm/mwait.h>
>  
>  #define UMWAIT_C02_ENABLE	0
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e3394c839dea..25ddfd3d6bb0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -44,6 +44,7 @@
>  #include <asm/spec-ctrl.h>
>  #include <asm/virtext.h>
>  #include <asm/vmx.h>
> +#include <asm/mwait.h>

Please maintain the alphabetical ordering of these includes.

>  
>  #include "capabilities.h"
>  #include "cpuid.h"
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index a4f7f737c5d4..db947076bf68 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -14,8 +14,6 @@
>  extern const u32 vmx_msr_index[];
>  extern u64 host_efer;
>  
> -extern u32 get_umwait_control_msr(void);
> -
>  #define MSR_TYPE_R	1
>  #define MSR_TYPE_W	2
>  #define MSR_TYPE_RW	3
> -- 
> 2.17.1
> 
