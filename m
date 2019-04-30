Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF2100C4
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 22:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfD3U1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 16:27:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:12882 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfD3U1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 16:27:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 13:27:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="295904727"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga004.jf.intel.com with ESMTP; 30 Apr 2019 13:27:04 -0700
Date:   Tue, 30 Apr 2019 13:27:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     nadav.amit@gmail.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Disable cache before relocating
 local APIC
Message-ID: <20190430202704.GB4523@linux.intel.com>
References: <20190430122701.41069-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430122701.41069-1-nadav.amit@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 30, 2019 at 05:27:01AM -0700, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> According to the SDM, during initialization, the BSP "Switches to
> protected mode and ensures that the APIC address space is mapped to the
> strong uncacheable (UC) memory type."
> 
> This requirement is not followed when the tests relocate the APIC. Set
> the cache-disable flag while the APIC base is reprogrammed. According
> to the SDM, the MTRRs should be modified as well, but it seems somewhat
> complicated to do that and probably unnecessary.

Alternatively, what about defining ALTERNATE_APIC_BASE to a sane value
that is guaranteed to be UC (assuming BIOS isn't being mean)?  Maybe a
use well-known address, e.g. 0xfed40000 from the TPM, so as to avoid any
other unwanted side effects.

> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/x86/processor.h | 1 +
>  x86/apic.c          | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 916e67d..59137da 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -29,6 +29,7 @@
>  #define X86_CR0_TS     0x00000008
>  #define X86_CR0_WP     0x00010000
>  #define X86_CR0_AM     0x00040000
> +#define X86_CR0_CD     0x40000000
>  #define X86_CR0_PG     0x80000000
>  #define X86_CR3_PCID_MASK 0x00000fff
>  #define X86_CR4_TSD    0x00000004
> diff --git a/x86/apic.c b/x86/apic.c
> index de5990c..de4a181 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -165,8 +165,13 @@ static void test_apicbase(void)
>  {
>      u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
>      u32 lvr = apic_read(APIC_LVR);
> +    u64 cr0 = read_cr0();
>      u64 value;
>  
> +    /* Disable caching to prevent the APIC from being cacheable */
> +    write_cr0(cr0 | X86_CR0_CD);
> +    asm volatile ("wbinvd" ::: "memory");
> +
>      wrmsr(MSR_IA32_APICBASE, orig_apicbase & ~(APIC_EN | APIC_EXTD));
>      wrmsr(MSR_IA32_APICBASE, ALTERNATE_APIC_BASE | APIC_BSP | APIC_EN);
>  
> @@ -186,6 +191,8 @@ static void test_apicbase(void)
>      wrmsr(MSR_IA32_APICBASE, orig_apicbase);
>      apic_write(APIC_SPIV, 0x1ff);
>  
> +    write_cr0(cr0);
> +
>      report_prefix_pop();
>  }
>  
> -- 
> 2.17.1
> 
