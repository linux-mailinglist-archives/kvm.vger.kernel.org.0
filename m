Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B9F17AF40
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 20:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgCET62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 14:58:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:36686 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgCET62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 14:58:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 11:58:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="439708418"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 05 Mar 2020 11:58:26 -0800
Date:   Thu, 5 Mar 2020 11:58:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
Subject: Re: [PATCH v2 2/7] KVM: x86: Add helpers to perform CPUID-based
 guest vendor check
Message-ID: <20200305195826.GP11500@linux.intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <20200305013437.8578-3-sean.j.christopherson@intel.com>
 <b752a4d4-b469-1a1f-c064-bf98a0467d49@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b752a4d4-b469-1a1f-c064-bf98a0467d49@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 11:48:20AM +0800, Xiaoyao Li wrote:
> On 3/5/2020 9:34 AM, Sean Christopherson wrote:
> >Add helpers to provide CPUID-based guest vendor checks, i.e. to do the
> >ugly register comparisons.  Use the new helpers to check for an AMD
> >guest vendor in guest_cpuid_is_amd() as well as in the existing emulator
> >flows.
> >
> >Using the new helpers fixes a _very_ theoretical bug where
> >guest_cpuid_is_amd() would get a false positive on a non-AMD virtual CPU
> >with a vendor string beginning with "Auth" due to the previous logic
> >only checking EBX.  It also fixes a marginally less theoretically bug
> >where guest_cpuid_is_amd() would incorrectly return false for a guest
> >CPU with "AMDisbetter!" as its vendor string.
> >
> >Fixes: a0c0feb57992c ("KVM: x86: reserve bit 8 of non-leaf PDPEs and PML4Es in 64-bit mode on AMD")
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/include/asm/kvm_emulate.h | 24 ++++++++++++++++++++
> >  arch/x86/kvm/cpuid.h               |  2 +-
> >  arch/x86/kvm/emulate.c             | 36 +++++++-----------------------
> >  3 files changed, 33 insertions(+), 29 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> >index bf5f5e476f65..2754972c36e6 100644
> >--- a/arch/x86/include/asm/kvm_emulate.h
> >+++ b/arch/x86/include/asm/kvm_emulate.h
> >@@ -393,6 +393,30 @@ struct x86_emulate_ctxt {
> >  #define X86EMUL_CPUID_VENDOR_GenuineIntel_ecx 0x6c65746e
> >  #define X86EMUL_CPUID_VENDOR_GenuineIntel_edx 0x49656e69
> >+static inline bool is_guest_vendor_intel(u32 ebx, u32 ecx, u32 edx)
> >+{
> >+	return ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx &&
> >+	       ecx == X86EMUL_CPUID_VENDOR_GenuineIntel_ecx &&
> >+	       edx == X86EMUL_CPUID_VENDOR_GenuineIntel_edx;
> >+}
> >+
> >+static inline bool is_guest_vendor_amd(u32 ebx, u32 ecx, u32 edx)
> >+{
> >+	return (ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx &&
> >+		ecx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx &&
> >+		edx == X86EMUL_CPUID_VENDOR_AuthenticAMD_edx) ||
> >+	       (ebx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ebx &&
> >+		ecx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ecx &&
> >+		edx == X86EMUL_CPUID_VENDOR_AMDisbetterI_edx);
> >+}
> >+
> >+static inline bool is_guest_vendor_hygon(u32 ebx, u32 ecx, u32 edx)
> >+{
> >+	return ebx == X86EMUL_CPUID_VENDOR_HygonGenuine_ebx &&
> >+	       ecx == X86EMUL_CPUID_VENDOR_HygonGenuine_ecx &&
> >+	       edx == X86EMUL_CPUID_VENDOR_HygonGenuine_edx;
> >+}
> >+
> 
> Why not define those in cpuid.h ?
> And also move X86EMUL_CPUID_VENDOR_* to cpuid.h and remove the "EMUL"
> prefix.

To avoid pulling cpuid.h into the emulator.  Ideally, the emulator would
only use KVM APIs defined in kvm_emulate.h.  Obviously that's a bit of a
pipe dream at the moment :-)

  #include <linux/kvm_host.h>
  #include "kvm_cache_regs.h"
  #include <asm/kvm_emulate.h>
  #include <linux/stringify.h>
  #include <asm/fpu/api.h>
  #include <asm/debugreg.h>
  #include <asm/nospec-branch.h>

  #include "x86.h"
  #include "tss.h"
  #include "mmu.h"
  #include "pmu.h"

> >  enum x86_intercept_stage {
> >  	X86_ICTP_NONE = 0,   /* Allow zero-init to not match anything */
> >  	X86_ICPT_PRE_EXCEPT,
> >diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> >index 7366c618aa04..13eb3e92c6a9 100644
> >--- a/arch/x86/kvm/cpuid.h
> >+++ b/arch/x86/kvm/cpuid.h
> >@@ -145,7 +145,7 @@ static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
> >  	struct kvm_cpuid_entry2 *best;
> >  	best = kvm_find_cpuid_entry(vcpu, 0, 0);
> >-	return best && best->ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx;
> >+	return best && is_guest_vendor_amd(best->ebx, best->ecx, best->edx);
> >  }
> >  static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
> >diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> >index dd19fb3539e0..9cf303984fe5 100644
> >--- a/arch/x86/kvm/emulate.c
> >+++ b/arch/x86/kvm/emulate.c
> >@@ -2712,9 +2712,7 @@ static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
> >  	eax = ecx = 0;
> >  	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
> >-	return ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx
> >-		&& ecx == X86EMUL_CPUID_VENDOR_GenuineIntel_ecx
> >-		&& edx == X86EMUL_CPUID_VENDOR_GenuineIntel_edx;
> >+	return is_guest_vendor_intel(ebx, ecx, edx);
> >  }
> >  static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
> >@@ -2733,34 +2731,16 @@ static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
> >  	ecx = 0x00000000;
> >  	ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
> >  	/*
> >-	 * Intel ("GenuineIntel")
> >-	 * remark: Intel CPUs only support "syscall" in 64bit
> >-	 * longmode. Also an 64bit guest with a
> >-	 * 32bit compat-app running will #UD !! While this
> >-	 * behaviour can be fixed (by emulating) into AMD
> >-	 * response - CPUs of AMD can't behave like Intel.
> >+	 * remark: Intel CPUs only support "syscall" in 64bit longmode. Also a
> >+	 * 64bit guest with a 32bit compat-app running will #UD !! While this
> >+	 * behaviour can be fixed (by emulating) into AMD response - CPUs of
> >+	 * AMD can't behave like Intel.
> >  	 */
> >-	if (ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx &&
> >-	    ecx == X86EMUL_CPUID_VENDOR_GenuineIntel_ecx &&
> >-	    edx == X86EMUL_CPUID_VENDOR_GenuineIntel_edx)
> >+	if (is_guest_vendor_intel(ebx, ecx, edx))
> >  		return false;
> >-	/* AMD ("AuthenticAMD") */
> >-	if (ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx &&
> >-	    ecx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx &&
> >-	    edx == X86EMUL_CPUID_VENDOR_AuthenticAMD_edx)
> >-		return true;
> >-
> >-	/* AMD ("AMDisbetter!") */
> >-	if (ebx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ebx &&
> >-	    ecx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ecx &&
> >-	    edx == X86EMUL_CPUID_VENDOR_AMDisbetterI_edx)
> >-		return true;
> >-
> >-	/* Hygon ("HygonGenuine") */
> >-	if (ebx == X86EMUL_CPUID_VENDOR_HygonGenuine_ebx &&
> >-	    ecx == X86EMUL_CPUID_VENDOR_HygonGenuine_ecx &&
> >-	    edx == X86EMUL_CPUID_VENDOR_HygonGenuine_edx)
> >+	if (is_guest_vendor_amd(ebx, ecx, edx) ||
> >+	    is_guest_vendor_hygon(ebx, ecx, edx))
> >  		return true;
> >  	/*
> >
> 
