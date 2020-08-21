Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1B324D73E
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 16:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHUOV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 10:21:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:39777 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgHUOVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 10:21:55 -0400
IronPort-SDR: RYBFxo43V9OCfLWwuYS2wd+yxyJGyLUXn8jFFO95Xi5xXoozxa3Gr9C8OCDZOG8IVjBMaGRr1L
 cOmSRsWuwseA==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="219829720"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="219829720"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 07:21:54 -0700
IronPort-SDR: M+Z82+vyGp8GThVTfRmbQOBAlpJvnXxiQQ3VPmH+j+Vsu9ynFvIXBIeusHkdQfGtvBS0zPIeNM
 eg51kE/JvygQ==
X-IronPort-AV: E=Sophos;i="5.76,337,1592895600"; 
   d="scan'208";a="442360716"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 07:21:54 -0700
Date:   Fri, 21 Aug 2020 07:21:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] x86/entry/64: Do not use RDPID in paranoid entry to
 accomodate KVM
Message-ID: <20200821142152.GA6330@sjchrist-ice>
References: <20200821105229.18938-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821105229.18938-1-pbonzini@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 06:52:29AM -0400, Paolo Bonzini wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Don't use RDPID in the paranoid entry flow, as it can consume a KVM
> guest's MSR_TSC_AUX value if an NMI arrives during KVM's run loop.
> 
> In general, the kernel does not need TSC_AUX because it can just use
> __this_cpu_read(cpu_number) to read the current processor id.  It can
> also just block preemption and thread migration at its will, therefore
> it has no need for the atomic rdtsc+vgetcpu provided by RDTSCP.  For this
> reason, as a performance optimization, KVM loads the guest's TSC_AUX when
> a CPU first enters its run loop.  On AMD's SVM, it doesn't restore the
> host's value until the CPU exits the run loop; VMX is even more aggressive
> and defers restoring the host's value until the CPU returns to userspace.
> 
> This optimization obviously relies on the kernel not consuming TSC_AUX,
> which falls apart if an NMI arrives during the run loop and uses RDPID.
> Removing it would be painful, as both SVM and VMX would need to context
> switch the MSR on every VM-Enter (for a cost of 2x WRMSR), whereas using
> LSL instead RDPID is a minor blip.
> 
> Both SAVE_AND_SET_GSBASE and GET_PERCPU_BASE are only used in paranoid entry,
> therefore the patch can just remove the RDPID alternative.
> 
> Fixes: eaad981291ee3 ("x86/entry/64: Introduce the FIND_PERCPU_BASE macro")
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Chang Seok Bae <chang.seok.bae@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
> Debugged-by: Tom Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/entry/calling.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
> index 98e4d8886f11..ae9b0d4615b3 100644
> --- a/arch/x86/entry/calling.h
> +++ b/arch/x86/entry/calling.h
> @@ -374,12 +374,14 @@ For 32-bit we have the following conventions - kernel is built with
>   * Fetch the per-CPU GSBASE value for this processor and put it in @reg.
>   * We normally use %gs for accessing per-CPU data, but we are setting up
>   * %gs here and obviously can not use %gs itself to access per-CPU data.
> + *
> + * Do not use RDPID, because KVM loads guest's TSC_AUX on vm-entry and
> + * may not restore the host's value until the CPU returns to userspace.
> + * Thus the kernel would consume a guest's TSC_AUX if an NMI arrives
> + * while running KVM's run loop.
>   */
>  .macro GET_PERCPU_BASE reg:req
> -	ALTERNATIVE \
> -		"LOAD_CPU_AND_NODE_SEG_LIMIT \reg", \
> -		"RDPID	\reg", \

This was the only user of the RDPID macro, I assume we want to yank that out
as well?

> -		X86_FEATURE_RDPID
> +	LOAD_CPU_AND_NODE_SEG_LIMIT \reg
>  	andq	$VDSO_CPUNODE_MASK, \reg
>  	movq	__per_cpu_offset(, \reg, 8), \reg
>  .endm
> -- 
> 2.26.2
> 
