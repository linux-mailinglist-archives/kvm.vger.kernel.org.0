Return-Path: <kvm+bounces-7640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C413844E9A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D0701F29F67
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5EE4A2E;
	Thu,  1 Feb 2024 01:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f0EMCGNt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DB51FD7;
	Thu,  1 Feb 2024 01:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706750306; cv=none; b=Fcy+1BQu01v4/v99nGNvRIA5toGqoPPhk02P7n3+JAt818GaJ1huB3g9j/9bucMqHNtJyqACGWhsTlCVAkJ4ywB+x3G5Z9/w7RXr0iUMpRF/OAIl86U2jBhgZgx4sATDPlNJQdTNIlOGF00j3JVDBpqqmwWkW85M59X8mHbzXss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706750306; c=relaxed/simple;
	bh=XNofIviOY14fT2/jWKz29tEsY3addidH4rW3dZuP+yE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPQ6Oibu1b0u1UX3aWD9ckeWnrmlZTpCVJN/nC3MzTHw1DPr3vFKM+KnW+j8/8aduEVCUFN/VsjssUqGz5D8eJhWHOdJ1fBXF6Exn42R/JytxDH2q4RlxEwlaeFmyFyNsyRcznZAUm0kCgk5sO9AiG+jKq0kvK+Mz8LJBLk9Kb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f0EMCGNt; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706750305; x=1738286305;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XNofIviOY14fT2/jWKz29tEsY3addidH4rW3dZuP+yE=;
  b=f0EMCGNt8knBVS2Ku17loYLQ60eSNM3Of1HFk97b0ngGUpN4piBDrESY
   jcUlXVMYwI/MpZtjagvEfrCPjWCoOncnhc1u8MYlYYjljmoln4dZIf8vs
   SQqr+aND6YYYS+tOtX+MzaKX71NEi8zJ9BlV0r+aY/a0NYsGji+1sLL7u
   dSKTKl+V8ULpgZYDARXRddBCB8Jx1/bV+DolwW2T40qZvI7HVwOJLklRS
   ncf1J5j+nkoTKcrijeGjxUSsO9qeZRu18SwoM5edeOXbtHApbKsDdYgrj
   o3gIa9zVPu9ogqD2DlKXbsrhWhcZJo9YtH8dHlmjCVV0AaDWU8skeQaCH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10534977"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="10534977"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:18:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="4233208"
Received: from hlhunt-860g9.amr.corp.intel.com (HELO desk) ([10.251.15.168])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:18:22 -0800
Date: Wed, 31 Jan 2024 17:18:11 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v6 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20240201011811.752qyub52fhciaxr@desk>
References: <20240123-delay-verw-v6-0-a8206baca7d3@linux.intel.com>
 <20240123-delay-verw-v6-1-a8206baca7d3@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123-delay-verw-v6-1-a8206baca7d3@linux.intel.com>

On Tue, Jan 23, 2024 at 11:41:01PM -0800, Pawan Gupta wrote:
> MDS mitigation requires clearing the CPU buffers before returning to
> user. This needs to be done late in the exit-to-user path. Current
> location of VERW leaves a possibility of kernel data ending up in CPU
> buffers for memory accesses done after VERW such as:
> 
>   1. Kernel data accessed by an NMI between VERW and return-to-user can
>      remain in CPU buffers since NMI returning to kernel does not
>      execute VERW to clear CPU buffers.
>   2. Alyssa reported that after VERW is executed,
>      CONFIG_GCC_PLUGIN_STACKLEAK=y scrubs the stack used by a system
>      call. Memory accesses during stack scrubbing can move kernel stack
>      contents into CPU buffers.
>   3. When caller saved registers are restored after a return from
>      function executing VERW, the kernel stack accesses can remain in
>      CPU buffers(since they occur after VERW).
> 
> To fix this VERW needs to be moved very late in exit-to-user path.
> 
> In preparation for moving VERW to entry/exit asm code, create macros
> that can be used in asm. Also make VERW patching depend on a new feature
> flag X86_FEATURE_CLEAR_CPU_BUF.
> 
> Reported-by: Alyssa Milburn <alyssa.milburn@intel.com>
> Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/entry/entry.S               | 22 ++++++++++++++++++++++
>  arch/x86/include/asm/cpufeatures.h   |  2 +-
>  arch/x86/include/asm/nospec-branch.h | 15 +++++++++++++++
>  3 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
> index 8c8d38f0cb1d..bd8e77c5a375 100644
> --- a/arch/x86/entry/entry.S
> +++ b/arch/x86/entry/entry.S
> @@ -6,6 +6,9 @@
>  #include <linux/export.h>
>  #include <linux/linkage.h>
>  #include <asm/msr-index.h>
> +#include <asm/unwind_hints.h>
> +#include <asm/segment.h>
> +#include <asm/cache.h>
>  
>  .pushsection .noinstr.text, "ax"
>  
> @@ -20,3 +23,22 @@ SYM_FUNC_END(entry_ibpb)
>  EXPORT_SYMBOL_GPL(entry_ibpb);
>  
>  .popsection
> +
> +/*
> + * Defines the VERW operand that is disguised as entry code so that
> + * it can be referenced with KPTI enabled. This ensures VERW can be
> + * used late in exit-to-user path after page tables are switched.
> + */
> +.pushsection .entry.text, "ax"
> +
> +.align L1_CACHE_BYTES, 0xcc
> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> +	UNWIND_HINT_UNDEFINED
> +	ANNOTATE_NOENDBR
> +	.word __KERNEL_DS
> +.align L1_CACHE_BYTES, 0xcc
> +SYM_CODE_END(mds_verw_sel);
> +/* For KVM */
> +EXPORT_SYMBOL_GPL(mds_verw_sel);

I realized this needs an extern:

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 0a8fa023a804..9daf92071f77 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -550,6 +550,8 @@ DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
 DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
 
+extern u16 mds_verw_sel;
+
 #include <asm/segment.h>
 
 /**

