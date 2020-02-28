Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0254D173F2A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 19:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgB1SFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 13:05:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:55851 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1SFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 13:05:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 10:05:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,496,1574150400"; 
   d="scan'208";a="272728236"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 28 Feb 2020 10:05:03 -0800
Date:   Fri, 28 Feb 2020 10:05:03 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, jianjay.zhou@huawei.com
Subject: Re: [PATCH] KVM: Remove unecessary asm/kvm_host.h includes
Message-ID: <20200228180503.GH2329@linux.intel.com>
References: <20200226155558.175021-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226155558.175021-1-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/unecessary/unnecessary

On Wed, Feb 26, 2020 at 10:55:58AM -0500, Peter Xu wrote:
> linux/kvm_host.h and asm/kvm_host.h have a dependency in that the asm
> header should be included first, then we can define arch-specific
> macros in asm/ header and use "#ifndef" in linux/ header to define the
> generic value of the macro.  One example is KVM_MAX_VCPU_ID.
> 
> Now in many C files we've got both the headers included, and
> linux/kvm_host.h is included even earlier.  It's working only because
> in linux/kvm_host.h we also included asm/kvm_host.h anyway so the
> explicit inclusion of asm/kvm_host.h in the C files are meaningless.

I'd prefer to word this much more strongly, i.e. there is no "should"
about it, including asm/kvm_host.h in linux/kvm_host.h is deliberate, 
it's not serendipitous.

```
Remove includes of asm/kvm_host.h from files that already include
linux/kvm_host.h to make it more obvious that there is no ordering issue
between the two headers.  linux/kvm_host.h includes asm/kvm_host.h to
pick up architecture specific settings, and this will never change, i.e.
including asm/kvm_host.h after linux/kvm_host.h may seem problematic,
but in practice is simply redundant.
```

As for the change itself, I'm indifferent.

> To avoid the confusion, remove the asm/ header if the linux/ header is
> included.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/arm/kvm/coproc.c                | 1 -
>  arch/arm64/kvm/fpsimd.c              | 1 -
>  arch/arm64/kvm/guest.c               | 1 -
>  arch/arm64/kvm/hyp/switch.c          | 1 -
>  arch/arm64/kvm/sys_regs.c            | 1 -
>  arch/arm64/kvm/sys_regs_generic_v8.c | 1 -
>  arch/powerpc/kvm/book3s_64_vio.c     | 1 -
>  arch/powerpc/kvm/book3s_64_vio_hv.c  | 1 -
>  arch/powerpc/kvm/book3s_hv.c         | 1 -
>  arch/powerpc/kvm/mpic.c              | 1 -
>  arch/powerpc/kvm/powerpc.c           | 1 -
>  arch/powerpc/kvm/timing.h            | 1 -
>  arch/s390/kvm/intercept.c            | 1 -
>  arch/x86/kvm/mmu/page_track.c        | 1 -
>  virt/kvm/arm/psci.c                  | 1 -
>  15 files changed, 15 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 07745ee022a1..f0c09049ee99 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -10,7 +10,6 @@
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
>  #include <asm/kvm_arm.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_mmu.h>
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 525010504f9d..e329a36b2bee 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -11,7 +11,6 @@
>  #include <linux/kvm_host.h>
>  #include <asm/fpsimd.h>
>  #include <asm/kvm_asm.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
>  
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2bd92301d32f..23ebe51410f0 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -25,7 +25,6 @@
>  #include <asm/kvm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
> -#include <asm/kvm_host.h>
>  #include <asm/sigcontext.h>
>  
>  #include "trace.h"
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index dfe8dd172512..f3e0ab961565 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -17,7 +17,6 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3e909b117f0c..b95f7b7743c8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -22,7 +22,6 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_emulate.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/perf_event.h>
> diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
> index 2b4a3e2d1b89..9cb6b4c8355a 100644
> --- a/arch/arm64/kvm/sys_regs_generic_v8.c
> +++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> @@ -12,7 +12,6 @@
>  #include <asm/cputype.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/sysreg.h>
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index ee6c103bb7d5..50555ad1db93 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -27,7 +27,6 @@
>  #include <asm/hvcall.h>
>  #include <asm/synch.h>
>  #include <asm/ppc-opcode.h>
> -#include <asm/kvm_host.h>
>  #include <asm/udbg.h>
>  #include <asm/iommu.h>
>  #include <asm/tce.h>
> diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
> index ab6eeb8e753e..6fcaf1fa8e02 100644
> --- a/arch/powerpc/kvm/book3s_64_vio_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
> @@ -24,7 +24,6 @@
>  #include <asm/hvcall.h>
>  #include <asm/synch.h>
>  #include <asm/ppc-opcode.h>
> -#include <asm/kvm_host.h>
>  #include <asm/udbg.h>
>  #include <asm/iommu.h>
>  #include <asm/tce.h>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2cefd071b848..f065d6956342 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -72,7 +72,6 @@
>  #include <asm/xics.h>
>  #include <asm/xive.h>
>  #include <asm/hw_breakpoint.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_book3s_uvmem.h>
>  #include <asm/ultravisor.h>
>  
> diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
> index fe312c160d97..23e9c2bd9f27 100644
> --- a/arch/powerpc/kvm/mpic.c
> +++ b/arch/powerpc/kvm/mpic.c
> @@ -32,7 +32,6 @@
>  #include <linux/uaccess.h>
>  #include <asm/mpic.h>
>  #include <asm/kvm_para.h>
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_ppc.h>
>  #include <kvm/iodev.h>
>  
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 1af96fb5dc6f..c1f23cb4206c 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -32,7 +32,6 @@
>  #include <asm/plpar_wrappers.h>
>  #endif
>  #include <asm/ultravisor.h>
> -#include <asm/kvm_host.h>
>  
>  #include "timing.h"
>  #include "irq.h"
> diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
> index ace65f9fed30..feef7885ba82 100644
> --- a/arch/powerpc/kvm/timing.h
> +++ b/arch/powerpc/kvm/timing.h
> @@ -10,7 +10,6 @@
>  #define __POWERPC_KVM_EXITTIMING_H__
>  
>  #include <linux/kvm_host.h>
> -#include <asm/kvm_host.h>
>  
>  #ifdef CONFIG_KVM_EXIT_TIMING
>  void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu);
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index a389fa85cca2..3655196f1c03 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -12,7 +12,6 @@
>  #include <linux/errno.h>
>  #include <linux/pagemap.h>
>  
> -#include <asm/kvm_host.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/irq.h>
>  #include <asm/sysinfo.h>
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 3521e2d176f2..0713778b8e12 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -14,7 +14,6 @@
>  #include <linux/kvm_host.h>
>  #include <linux/rculist.h>
>  
> -#include <asm/kvm_host.h>
>  #include <asm/kvm_page_track.h>
>  
>  #include "mmu.h"
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 17e2bdd4b76f..14a162e295a9 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -12,7 +12,6 @@
>  
>  #include <asm/cputype.h>
>  #include <asm/kvm_emulate.h>
> -#include <asm/kvm_host.h>
>  
>  #include <kvm/arm_psci.h>
>  #include <kvm/arm_hypercalls.h>
> -- 
> 2.24.1
> 
