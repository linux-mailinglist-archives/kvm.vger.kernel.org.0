Return-Path: <kvm+bounces-55910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F71AB388B4
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 19:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C1737A261D
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 17:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFB42BD5AD;
	Wed, 27 Aug 2025 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKUMPvsp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03A921FF55;
	Wed, 27 Aug 2025 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756316000; cv=none; b=stuYgQxy8TZf61vB3K2uixpOgCJsA3G3gKf/0XNXUOWP9XrLl5svN08LBY13Mfuy56ZedK8Au7QiIBWa5P7rRhq3G+Hyq9X0UHaSUvM5LhBSxSm3HsprRq7AlKe5dgb9Isb7wEtLCzC66nhWA2fv7AQ4djPExrzXLBvwHW38Iac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756316000; c=relaxed/simple;
	bh=g+/6ZtHJDmZfMFxft7oCojR4vCKnCFZ5ArCa316JrNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a247sDs5KrTpa7Xpna4ewFbmdEY5C4WKXWygSN23crNsoWWaoid954km7wjwFAA8naTVe71FZWTONfvp+Wz16thunjlMun0hdp3huHHqe124R+N79x8065VDVtmMquoxt6q8kOXIguZM6OyAlxHlVrwpQsy72WvujpK/mSIBY18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKUMPvsp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756315999; x=1787851999;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g+/6ZtHJDmZfMFxft7oCojR4vCKnCFZ5ArCa316JrNs=;
  b=oKUMPvspD5OJNI1IgKSdHkfuV+7piXBDo2+BYpsS+1v9y4qg74bEvL4S
   khLoVm93Hfsy9AB7x5fnopxaEoBIYbnEC/Qqa0nT84g/Kl6WKECFgi9rP
   EhS4CIWxIMWp7jjdvhOiN+YF6tu7dr4t4OVM+Qa30kCr0vIKVhCxHTNuW
   967Wm2XYF6040/epYLK0DLAPmqEuUM4pkfZTlsg1lduTBBV1zlaa3Tg8F
   bsqXJr3KQtbHoiZOG3GE0hwItI0nsaDNMn2ShykDNvlo+WBCnAo4lrmsO
   aamR3JdazObUCPMB0YDjvGRWoXkbHESXB1rOCA/mTUMxqvUIqnRb/3F34
   A==;
X-CSE-ConnectionGUID: rQTNLiKKRE2YbzNgQXoGLA==
X-CSE-MsgGUID: AyJ2I5EPTmOxEOCEdnzMCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81168032"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81168032"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 10:33:18 -0700
X-CSE-ConnectionGUID: v3iCVrRRTluWWd8DLiAShw==
X-CSE-MsgGUID: 0pnn7pMCRCG7wXus0/AtSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169493995"
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO [10.125.109.56]) ([10.125.109.56])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 10:33:17 -0700
Message-ID: <720bc7ac-7e81-4ad9-8cc5-29ac540be283@intel.com>
Date: Wed, 27 Aug 2025 10:33:15 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/20] x86/cea: Export an API to get per CPU exception
 stacks for KVM to use
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
 hch@infradead.org
References: <20250821223630.984383-1-xin@zytor.com>
 <20250821223630.984383-5-xin@zytor.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250821223630.984383-5-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 15:36, Xin Li (Intel) wrote:
> FRED introduced new fields in the host-state area of the VMCS for
> stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
> corresponding to per CPU exception stacks for #DB, NMI and #DF.
> KVM must populate these each time a vCPU is loaded onto a CPU.
> 
> Convert the __this_cpu_ist_{top,bottom}_va() macros into real
> functions and export __this_cpu_ist_top_va().
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>

Nit: I wouldn't use Suggested-by unless the person basically asked for
the *entire* patch. Christoph and I were asking for specific bits of
this, but neither of us asked for this patch as a whole.

> diff --git a/arch/x86/coco/sev/sev-nmi.c b/arch/x86/coco/sev/sev-nmi.c
> index d8dfaddfb367..73e34ad7a1a9 100644
> --- a/arch/x86/coco/sev/sev-nmi.c
> +++ b/arch/x86/coco/sev/sev-nmi.c
> @@ -30,7 +30,7 @@ static __always_inline bool on_vc_stack(struct pt_regs *regs)
>  	if (ip_within_syscall_gap(regs))
>  		return false;
>  
> -	return ((sp >= __this_cpu_ist_bottom_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
> +	return ((sp >= __this_cpu_ist_bottom_va(ESTACK_VC)) && (sp < __this_cpu_ist_top_va(ESTACK_VC)));
>  }

This rename is one of those things that had me scratching my head for a
minute. It wasn't obvious at _all_ why the VC=>ESTACK_VC "rename" is
necessary.

This needs to have been mentioned in the changelog.

Better yet would have been to do this in a separate patch because a big
chunk of this patch is just rename noise.

>  /*
> @@ -82,7 +82,7 @@ void noinstr __sev_es_ist_exit(void)
>  	/* Read IST entry */
>  	ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
>  
> -	if (WARN_ON(ist == __this_cpu_ist_top_va(VC)))
> +	if (WARN_ON(ist == __this_cpu_ist_top_va(ESTACK_VC)))
>  		return;
>  
>  	/* Read back old IST entry and write it to the TSS */
> diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
> index c3b4acbde0d8..88b6bc518a5a 100644
> --- a/arch/x86/coco/sev/vc-handle.c
> +++ b/arch/x86/coco/sev/vc-handle.c
> @@ -859,7 +859,7 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>  
>  static __always_inline bool is_vc2_stack(unsigned long sp)
>  {
> -	return (sp >= __this_cpu_ist_bottom_va(VC2) && sp < __this_cpu_ist_top_va(VC2));
> +	return (sp >= __this_cpu_ist_bottom_va(ESTACK_VC2) && sp < __this_cpu_ist_top_va(ESTACK_VC2));
>  }
>  
>  static __always_inline bool vc_from_invalid_context(struct pt_regs *regs)
> diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
> index 462fc34f1317..8e17f0ca74e6 100644
> --- a/arch/x86/include/asm/cpu_entry_area.h
> +++ b/arch/x86/include/asm/cpu_entry_area.h
> @@ -46,7 +46,7 @@ struct cea_exception_stacks {
>   * The exception stack ordering in [cea_]exception_stacks
>   */
>  enum exception_stack_ordering {
> -	ESTACK_DF,
> +	ESTACK_DF = 0,
>  	ESTACK_NMI,
>  	ESTACK_DB,
>  	ESTACK_MCE,

Is this really required? I thought the first enum was always 0? Is this
just trying to ensure that ESTACKS_MEMBERS() defines a matching number
of N_EXCEPTION_STACKS stacks?

If that's the case, shouldn't this be represented with a BUILD_BUG_ON()?

> @@ -58,18 +58,15 @@ enum exception_stack_ordering {
>  #define CEA_ESTACK_SIZE(st)					\
>  	sizeof(((struct cea_exception_stacks *)0)->st## _stack)
>  
> -#define CEA_ESTACK_BOT(ceastp, st)				\
> -	((unsigned long)&(ceastp)->st## _stack)
> -
> -#define CEA_ESTACK_TOP(ceastp, st)				\
> -	(CEA_ESTACK_BOT(ceastp, st) + CEA_ESTACK_SIZE(st))
> -
>  #define CEA_ESTACK_OFFS(st)					\
>  	offsetof(struct cea_exception_stacks, st## _stack)
>  
>  #define CEA_ESTACK_PAGES					\
>  	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
>  
> +extern unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack);
> +extern unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack);
> +
>  #endif
>  
>  #ifdef CONFIG_X86_32
> @@ -144,10 +141,4 @@ static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
>  	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
>  }
>  
> -#define __this_cpu_ist_top_va(name)					\
> -	CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
> -
> -#define __this_cpu_ist_bottom_va(name)					\
> -	CEA_ESTACK_BOT(__this_cpu_read(cea_exception_stacks), name)
> -
>  #endif
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 34a054181c4d..cb14919f92da 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2307,12 +2307,12 @@ static inline void setup_getcpu(int cpu)
>  static inline void tss_setup_ist(struct tss_struct *tss)
>  {
>  	/* Set up the per-CPU TSS IST stacks */
> -	tss->x86_tss.ist[IST_INDEX_DF] = __this_cpu_ist_top_va(DF);
> -	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(NMI);
> -	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(DB);
> -	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(MCE);
> +	tss->x86_tss.ist[IST_INDEX_DF] = __this_cpu_ist_top_va(ESTACK_DF);
> +	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(ESTACK_NMI);
> +	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(ESTACK_DB);
> +	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(ESTACK_MCE);

If you respin this, please vertically align these.

> +/*
> + * FRED introduced new fields in the host-state area of the VMCS for
> + * stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
> + * corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
> + * populate these each time a vCPU is loaded onto a CPU.
> + *
> + * Called from entry code, so must be noinstr.
> + */
> +noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
> +{
> +	unsigned long base = (unsigned long)&(__this_cpu_read(cea_exception_stacks)->DF_stack);
> +	return base + EXCEPTION_STKSZ + stack * (EXCEPTION_STKSZ + PAGE_SIZE);
> +}
> +EXPORT_SYMBOL(__this_cpu_ist_top_va);
> +
> +noinstr unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack)
> +{
> +	unsigned long base = (unsigned long)&(__this_cpu_read(cea_exception_stacks)->DF_stack);
> +	return base + stack * (EXCEPTION_STKSZ + PAGE_SIZE);
> +}

These are basically treating 'struct exception_stacks' like an array.
There's no type safety or anything here. It's just an open-coded array
access.

Also, starting with ->DF_stack is a bit goofy looking. It's not obvious
(or enforced) that it is stack #0 or at the beginning of the structure.

Shouldn't we be _trying_ to make this look like:

	struct cea_exception_stacks *s;
	s = __this_cpu_read(cea_exception_stacks);

	return &s[stack_nr].stack;

?

Where 'cea_exception_stacks' is an actual array:

	struct cea_exception_stacks[N_EXCEPTION_STACKS];

which might need to be embedded in a larger structure to get the
'IST_top_guard' without wasting allocating space for an extra full stack.

>  static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
>  
>  static __always_inline unsigned int cea_offset(unsigned int cpu)
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 998bd807fc7b..1804eb86cc14 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -671,7 +671,7 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  		 * and then double-fault, though, because we're likely to
>  		 * break the console driver and lose most of the stack dump.
>  		 */
> -		call_on_stack(__this_cpu_ist_top_va(DF) - sizeof(void*),
> +		call_on_stack(__this_cpu_ist_top_va(ESTACK_DF) - sizeof(void*),
>  			      handle_stack_overflow,
>  			      ASM_CALL_ARG3,
>  			      , [arg1] "r" (regs), [arg2] "r" (address), [arg3] "r" (&info));


