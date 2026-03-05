Return-Path: <kvm+bounces-72806-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHz+A35TqWmG5QAAu9opvQ
	(envelope-from <kvm+bounces-72806-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:57:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC7820F22A
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:57:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B3A2B309F1F0
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 09:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF5537D131;
	Thu,  5 Mar 2026 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k3P3VNtS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF5E37D104;
	Thu,  5 Mar 2026 09:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772704318; cv=none; b=qqcf5LiJNgn59GmiiPUXkb2eoaxD6tz2qq4lfkkuzMqK+keInP1iEJqf6TkIHiVz/5FMb3vcu5rfNvNGbJ65R+O7txHYNya1fTxSLnWHEIHGcM1B00go8amSP4ihoopc7iJE0CKk3U2X1otBaD2P4BQTUo1+ErNZnaH6Wba0yJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772704318; c=relaxed/simple;
	bh=zp4FFxPi6pgI4LJZ5uwFWt2ywTFgDFCzmK9zFR8zjxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQKwhBVQlUpvZssxEKTU0lp9NokDS4MbkcEpaU6pPXt2rrlI846H6oAn8lp3+2p1CZMJGptrNPpV5efyTdA06ReGd3B2EzUSrIgTOl20xJCp8NRqqu+rKt6NCRghmphNhCJN4jeKF+c4rZax4R+dxgkqq+ov1QWsuak8EbwyqDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k3P3VNtS; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772704317; x=1804240317;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zp4FFxPi6pgI4LJZ5uwFWt2ywTFgDFCzmK9zFR8zjxc=;
  b=k3P3VNtSG3WOyYWaaT8h/l450jycxm0hVCHLHEoQWZjh7BrqTqQnRsMJ
   9nBW4+3yBsGIsM5L88YzsiWVcL0RFazxBbSOmodQlOXsn8XBW8mco3Tr7
   vxtX0SXLXc0BCLNUMw7aUCzKRSNGDGxvXX1dJvPwGNzMwQX9x3pL9Gvhp
   CRvPlvGwWHQJ7869wUwcOz67XdeYncc9TSaRu5Tl/gKpWVy4wzxBfCGw4
   ruFuiTfgOYrdkfT0hsspQtcVX9QKRGm8Sa1slOJaKYOYL7jjDmH5q01EH
   /zjEuoZfxN5BKTFWG7DPbct1WvzQgIyQd44iOeIo+SvnMZexzkKOvkTHl
   w==;
X-CSE-ConnectionGUID: G5qq7sjMRjKLHdYWUO2lkg==
X-CSE-MsgGUID: pC7Tj5L1TJaWAVaaPaMrwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73835677"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="73835677"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:51:56 -0800
X-CSE-ConnectionGUID: snOXf1u7RoyMhsKC2alj2A==
X-CSE-MsgGUID: +OSw9++LRpqZFcK8bSUBcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="223313513"
Received: from unknown (HELO [10.238.1.83]) ([10.238.1.83])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:51:50 -0800
Message-ID: <3caf28a6-41a7-4d2d-8aca-11963e503b5d@linux.intel.com>
Date: Thu, 5 Mar 2026 17:51:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/24] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 tony.lindgren@linux.intel.com, Farrah Chen <farrah.chen@intel.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-5-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260212143606.534586-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7AC7820F22A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[26];
	TAGGED_FROM(0.00)[bounces-72806-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:url,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.intel.com:mid]
X-Rspamd-Action: no action



On 2/12/2026 10:35 PM, Chao Gao wrote:
> The TDX architecture uses the "SEAMCALL" instruction to communicate with
> SEAM mode software. Right now, the only SEAM mode software that the kernel
> communicates with is the TDX module. But, there is actually another
> component that runs in SEAM mode but it is separate from the TDX module:
> the persistent SEAM loader or "P-SEAMLDR". Right now, the only component
> that communicates with it is the BIOS which loads the TDX module itself at
> boot. But, to support updating the TDX module, the kernel now needs to be
> able to talk to it.
> 
> P-SEAMLDR SEAMCALLs differ from TDX Module SEAMCALLs in areas such as
> concurrency requirements. Add a P-SEAMLDR wrapper to handle these
> differences and prepare for implementing concrete functions.
> 
> Note that unlike P-SEAMLDR, there is also a non-persistent SEAM loader
> ("NP-SEAMLDR"). This is an authenticated code module (ACM) that is not
> callable at runtime. Only BIOS launches it to load P-SEAMLDR at boot;
> the kernel does not interact with it.
> 
> For details of P-SEAMLDR SEAMCALLs, see Intel® Trust Domain CPU
> Architectural Extensions, Revision 343754-002, Chapter 2.3 "INSTRUCTION
> SET REFERENCE".
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Link: https://cdrdv2.intel.com/v1/dl/getContent/733582 # [1]

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
> v4:
>  - Give more background about P-SEAMLDR in changelog [Dave]
>  - Don't handle P-SEAMLDR's "no_entropy" error [Dave]
>  - Assume current VMCS is preserved across P-SEAMLDR calls [Dave]
>  - I'm not adding Reviewed-by tags as the code has changed significantly.
> v2:
>  - don't create a new, inferior framework to save/restore VMCS
>  - use human-friendly language, just "current VMCS" rather than
>    SDM term "current-VMCS pointer"
>  - don't mix guard() with goto
> ---
>  arch/x86/virt/vmx/tdx/Makefile  |  2 +-
>  arch/x86/virt/vmx/tdx/seamldr.c | 27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c
> 
> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> index 90da47eb85ee..d1dbc5cc5697 100644
> --- a/arch/x86/virt/vmx/tdx/Makefile
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-y += seamcall.o tdx.o
> +obj-y += seamcall.o seamldr.o tdx.o
> diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
> new file mode 100644
> index 000000000000..fb59b3e2aa37
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/seamldr.c
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * P-SEAMLDR support for TDX Module management features like runtime updates
> + *
> + * Copyright (C) 2025 Intel Corporation
> + */
> +#define pr_fmt(fmt)	"seamldr: " fmt
> +
> +#include <linux/spinlock.h>
> +
> +#include "seamcall_internal.h"
> +
> +/*
> + * Serialize P-SEAMLDR calls since the hardware only allows a single CPU to
> + * interact with P-SEAMLDR simultaneously.
> + */
> +static DEFINE_RAW_SPINLOCK(seamldr_lock);
> +
> +static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
> +{
> +	/*
> +	 * Serialize P-SEAMLDR calls and disable interrupts as the calls
> +	 * can be made from IRQ context.
> +	 */
> +	guard(raw_spinlock_irqsave)(&seamldr_lock);
> +	return seamcall_prerr(fn, args);
> +}


