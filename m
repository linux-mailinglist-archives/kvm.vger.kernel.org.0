Return-Path: <kvm+bounces-69329-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +MhiDv+ueWnayQEAu9opvQ
	(envelope-from <kvm+bounces-69329-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:38:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0AB9D776
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BEBEC3016286
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 06:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F39335549;
	Wed, 28 Jan 2026 06:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixjSigY9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA55221F1C;
	Wed, 28 Jan 2026 06:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769582328; cv=none; b=N2MCeKI+vmKJddfopm0h4qpRfQ6Ucl6Nr6xqmAQp1ao7L8isV2R0TG4rvmUOKp5I8JAjVlL1bMD+ZJduhIzREd+FdXq44VQzmREF7J8tzwfjgx5hGD+N+Y0zyGT3DXkPfd4WndMEHKcVy8Rpn47EFeU/4XuhAmUnuQW/rq+vx3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769582328; c=relaxed/simple;
	bh=01udh5m7XfU/YSuKGZba1QVK13n4mcDm9i4gsTeixnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7gmbNU4MuBbimFWeJglns4WkAC8mQu24HnxwBy8q2aIrRx3HCHanCv/jIyinO85wCV4Gs3PF6/EIJ6I/HKc5e08rtfoLcqVxJCXptru5AUP6cv0BC9Zz+eeyrYc0dYHGeiKOvRnFcDxU8Gs85akpYzkoU/gNYmPz0Nli3CkitU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixjSigY9; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769582328; x=1801118328;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=01udh5m7XfU/YSuKGZba1QVK13n4mcDm9i4gsTeixnw=;
  b=ixjSigY99sPKslrIx9OwBlLkCrkHhBwJ8s6tEYMLzaeKDkCYgWi+nyqG
   uqsAFa+qg0xpkHkDum50lvIwoce/aRIwWZBa/tN9sUpquW0k+ciYTeEf8
   I75AFU7TdqgkVBdVgl+U0Fd35VVd48tMoFQGHUddhaYjPjXNWu6Vd7TjQ
   3PBg5bTmy3WnYBIvCMStW6owh6gX+K04ETSPgatxObYGNEUoaKzaLDBXt
   P9oxekOeflVcRd+NgU87uQ0G56nkQ2l+FAuxUOlTgvnJq+dyQh8cyhZxF
   tM5xEwpPVBcU0HxXyz3thxgclctxMaJMz4L0REqAKgZJEwqIki2VmmfET
   A==;
X-CSE-ConnectionGUID: SWeDq2TgRdu3Mk4402b8vA==
X-CSE-MsgGUID: hPknH3YzRBygJR+2zGVyag==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="74415691"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="74415691"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:38:47 -0800
X-CSE-ConnectionGUID: DZTJRim7QWi4V9kCgvJv3g==
X-CSE-MsgGUID: ht2Ip1f+QIeko5cTbLLV+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208255381"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:38:42 -0800
Message-ID: <28f6ab70-94c9-46c0-bd64-7688cc1604d3@linux.intel.com>
Date: Wed, 28 Jan 2026 14:38:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-8-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260123145645.90444-8-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:url,intel.com:dkim,linux.intel.com:mid];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69329-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: DB0AB9D776
X-Rspamd-Action: no action



On 1/23/2026 10:55 PM, Chao Gao wrote:
> Software needs to talk with P-SEAMLDR via P-SEAMLDR SEAMCALLs. So, add a
> wrapper for P-SEAMLDR SEAMCALLs.
> 
> Save and restore the current VMCS using VMPTRST and VMPTRLD instructions
> to avoid breaking KVM. Doing so is because P-SEAMLDR SEAMCALLs would
> invalidate the current VMCS as documented in Intel® Trust Domain CPU
> Architectural Extensions (May 2021 edition) Chapter 2.3 [1]:
> 
>   SEAMRET from the P-SEAMLDR clears the current VMCS structure pointed
>   to by the current-VMCS pointer. A VMM that invokes the P-SEAMLDR using
>   SEAMCALL must reload the current-VMCS, if required, using the VMPTRLD
>   instruction.
> 
> Disable interrupts to prevent KVM code from interfering with P-SEAMLDR
> SEAMCALLs. For example, if a vCPU is scheduled before the current VMCS is
> restored, it may encounter an invalid current VMCS, causing its VMX
> instruction to fail. Additionally, if KVM sends IPIs to invalidate a
> current VMCS and the invalidation occurs right after the current VMCS is
> saved, that VMCS will be reloaded after P-SEAMLDR SEAMCALLs, leading to
> unexpected behavior.
> 
> NMIs are not a problem, as the only scenario where instructions relying on
> the current-VMCS are used is during guest PMI handling in KVM. This occurs
> immediately after VM exits with IRQ and NMI disabled, ensuring no
> interference with P-SEAMLDR SEAMCALLs.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Link: https://cdrdv2.intel.com/v1/dl/getContent/733582 # [1]

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Two nits below.

> ---
> v2:
>  - don't create a new, inferior framework to save/restore VMCS
>  - use human-friendly language, just "current VMCS" rather than
>    SDM term "current-VMCS pointer"
>  - don't mix guard() with goto
> ---
>  arch/x86/virt/vmx/tdx/Makefile     |  1 +
>  arch/x86/virt/vmx/tdx/seamldr.c    | 56 ++++++++++++++++++++++++++++++
>  drivers/virt/coco/tdx-host/Kconfig | 10 ++++++
>  3 files changed, 67 insertions(+)
>  create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c
> 
> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> index 90da47eb85ee..26aea3531c36 100644
> --- a/arch/x86/virt/vmx/tdx/Makefile
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -1,2 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-y += seamcall.o tdx.o
> +obj-$(CONFIG_INTEL_TDX_MODULE_UPDATE) += seamldr.o
> diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
> new file mode 100644
> index 000000000000..b99d73f7bb08
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/seamldr.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright(c) 2025 Intel Corporation.

Update to 2026?

> + *
> + * Intel TDX module runtime update
> + */
> +#define pr_fmt(fmt)	"seamldr: " fmt
> +
> +#include <linux/irqflags.h>
> +#include <linux/types.h>
> +
> +#include "seamcall.h"
> +
> +static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
> +{
> +	unsigned long flags;
> +	u64 vmcs;
> +	int ret;
> +
> +	if (!is_seamldr_call(fn))
> +		return -EINVAL;
> +
> +	/*
> +	 * SEAMRET from P-SEAMLDR invalidates the current VMCS.  Save/restore
> +	 * the VMCS across P-SEAMLDR SEAMCALLs to avoid clobbering KVM state.
> +	 * Disable interrupts as KVM is allowed to do VMREAD/VMWRITE in IRQ
> +	 * context (but not NMI context).
> +	 */
> +	local_irq_save(flags);
> +
> +	asm goto("1: vmptrst %0\n\t"
> +		 _ASM_EXTABLE(1b, %l[error])
> +		 : "=m" (vmcs) : : "cc" : error);
> +
> +	ret = seamldr_prerr(fn, args);
> +
> +	/*
> +	 * Restore the current VMCS pointer.  VMPTSTR "returns" all ones if the

s/VMPTSTR/VMPTRST 


