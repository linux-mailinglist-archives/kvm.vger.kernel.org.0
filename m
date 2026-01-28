Return-Path: <kvm+bounces-69443-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEcTMc+hemnu8gEAu9opvQ
	(envelope-from <kvm+bounces-69443-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:54:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA99AA0E3
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:54:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC2BC3019B94
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2603345757;
	Wed, 28 Jan 2026 23:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lrr1nAbR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5380833B6E0;
	Wed, 28 Jan 2026 23:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769644482; cv=none; b=PQf9XNnNwmqPdLK01HthJ3Jag4JeUao351yEBUbcR2LwliZZm5U1MhQsKEDpxsEDUoQZdLdl0C+nOCq3o34oi4pjg5jlSmsUN0t35/vZiAS/ux58NVy0oxy9lVnMhBg5haAOeGEyBrbtoYmuk1M4tWwR15gbrPqTHmulHRM1O1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769644482; c=relaxed/simple;
	bh=0Cps4VFJ+P+DErVNWpvKHm3iAAy6qEtS67CdVWyN6oI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J/Eppx6cEb/cO/YtK+3fpqrgm1LR30vnXcRUssjV0/D3uCYsqH4Pg75n+SsTrHnMBAi06lY5to2Chqcsg3zFUPzfaS2dwMb7bB57h4KoNGQMfMpM0g/qEbp+kHwDomqQ8rG5ukpECk6pKEBchhC/uwkpV3L9ZqpdSO5qnzWvjK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lrr1nAbR; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769644481; x=1801180481;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0Cps4VFJ+P+DErVNWpvKHm3iAAy6qEtS67CdVWyN6oI=;
  b=Lrr1nAbR6v2XDulcdGsxkER0z1vUoJZ8NMugAN9F1NzZs1A7hdOY//Yu
   4rbfw6Dsv/TyQCee7Pc2cVASnXvkzHQm9nuQJ3abbyUQ/nP2lz1ZVgrOd
   QCTKaSHrQVgsXYjxw66kw05PzlkkBBp+NRwxoTu9yina0LyKoMMbqJJFO
   eIz0Pv147g+aXI6HgUUMYeFoKcCMpn8b2a0VCUfIw7ln/w3N5cj1uavBc
   k2w+i78BOS+0spg49oOSglh7VYSYZN1cITcqYsBWG+zi/h1iUWMxlmfGm
   xN31W4nG3A2iF+hREUZixnMqZcAzuRO06SqpMeqbMOqNkiWr+oZZNIQLb
   A==;
X-CSE-ConnectionGUID: HhWRVrkfR02ccO3Vslz0KA==
X-CSE-MsgGUID: y8autz/1Taqi6lWMaShsyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="70774998"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70774998"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:54:40 -0800
X-CSE-ConnectionGUID: sG4t/9zyQ9SSLWRMcMXrIw==
X-CSE-MsgGUID: MSApCQ3MSUmS7ixGrnbxNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="212951292"
Received: from kcaccard-desk.amr.corp.intel.com (HELO [10.125.109.190]) ([10.125.109.190])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:54:39 -0800
Message-ID: <b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com>
Date: Wed, 28 Jan 2026 15:54:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
To: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc: reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com,
 dan.j.williams@intel.com, yilun.xu@linux.intel.com, sagis@google.com,
 vannapurve@google.com, paulmck@kernel.org, nik.borisov@suse.com,
 zhenzhong.duan@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com,
 kas@kernel.org, dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-9-chao.gao@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260123145645.90444-9-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-69443-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[seamldr.info:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6DA99AA0E3
X-Rspamd-Action: no action

On 1/23/26 06:55, Chao Gao wrote:
> P-SEAMLDR returns its information e.g., version and supported features, in
> response to the SEAMLDR.INFO SEAMCALL.
> 
> This information is useful for userspace. For example, the admin can decide
> which TDX module versions are compatible with the P-SEAMLDR according to
> the P-SEAMLDR version.
> 
> Add and export seamldr_get_info() which retrieves P-SEAMLDR information by

I don't need to know what the function name is. That's in the code.

> invoking SEAMLDR.INFO SEAMCALL in preparation for exposing P-SEAMLDR
> version and other necessary information to userspace.

I also want to know what spec you are getting this out of.

I think it's also worth calling out that there are SEAMLDR calls for both:

	SEAMLDR_INFO
and
	SEAMLDR_SEAMINFO

Which is astonishingly confusing. Please have mercy on folks that are
looking through the docs for the first time and explain this.

> diff --git a/arch/x86/include/asm/seamldr.h b/arch/x86/include/asm/seamldr.h
> new file mode 100644
> index 000000000000..d1e9f6e16e8d
> --- /dev/null
> +++ b/arch/x86/include/asm/seamldr.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_SEAMLDR_H
> +#define _ASM_X86_SEAMLDR_H
> +
> +#include <linux/types.h>
> +
> +struct seamldr_info {

/*
 * This called the "SEAMLDR_INFO" data structure and is defined
 * in "SEAM Loader (SEAMLDR) Interface Specification".
 */


> +	u32	version;
> +	u32	attributes;
> +	u32	vendor_id;
> +	u32	build_date;
> +	u16	build_num;
> +	u16	minor_version;
> +	u16	major_version;
> +	u16	update_version;
> +	u8	reserved0[4];

Why not label this:

	u32	acm_x2apicid: /* unused by kernel */

?

> +	u32	num_remaining_updates;
> +	u8	reserved1[224];
> +} __packed;
> +
> +#ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
> +const struct seamldr_info *seamldr_get_info(void);
> +#else
> +static inline const struct seamldr_info *seamldr_get_info(void) { return NULL; }
> +#endif
> +
> +#endif
> diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
> index b99d73f7bb08..6a83ae405fac 100644
> --- a/arch/x86/virt/vmx/tdx/seamldr.c
> +++ b/arch/x86/virt/vmx/tdx/seamldr.c
> @@ -9,9 +9,16 @@
>  #include <linux/irqflags.h>
>  #include <linux/types.h>
>  
> +#include <asm/seamldr.h>
> +
>  #include "seamcall.h"
>  
> -static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
> +/* P-SEAMLDR SEAMCALL leaf function */
> +#define P_SEAMLDR_INFO			0x8000000000000000


/*
 * The SEAMLDR.INFO documentation requires
 * this to be aligned to a 256-byte boundary.
 */
> +static struct seamldr_info seamldr_info __aligned(256);
> +
> +static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
>  {
>  	unsigned long flags;
>  	u64 vmcs;
> @@ -54,3 +61,11 @@ static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
>  	WARN_ONCE(1, "Failed to save/restore the current VMCS");
>  	return -EIO;
>  }
> +
> +const struct seamldr_info *seamldr_get_info(void)
> +{
> +	struct tdx_module_args args = { .rcx = __pa(&seamldr_info) };
> +
> +	return seamldr_call(P_SEAMLDR_INFO, &args) ? NULL : &seamldr_info;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");

I'd also prefer a

	BUILD_BUG_ON(sizeof(struct seamldr_info) != 2048);

just as a sanity check. It doesn't cost anything and it makes sure that
as you muck around with reserved fields and padding that there's at
least one check making sure it's OK.

