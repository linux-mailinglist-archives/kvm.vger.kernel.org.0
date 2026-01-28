Return-Path: <kvm+bounces-69331-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOHvId2xeWkEygEAu9opvQ
	(envelope-from <kvm+bounces-69331-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:51:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0F99D868
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 11739300D742
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 06:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0393358BA;
	Wed, 28 Jan 2026 06:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LjGyRfdW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29BA330B3A;
	Wed, 28 Jan 2026 06:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769583058; cv=none; b=YiX9a8QjlgNUzF4k8K+Dlrs5bRsMRiZz0MV3m6+keb06GbuSMSHDvxhnAoiSdlCJtBPiniWGX1muIcsoqHNVmzihGFVjIISeuQ1uocJedlvFFpVCDxzThHEpjCEhdU0jHRNaV2L9xjtFrD2P40nSmtFSJA/l+aQBI/ItiNXgf5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769583058; c=relaxed/simple;
	bh=gzN16H435P71a1hFvbzPcNWJPMvuFh1t8O7DMR3D2vQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XR7uxDOF7tj9XGxqhA/149xVu54SHcsT8xLL+LCD4oE+I8NoEu5QicEY7h6Lr9CQwLOLaNc6EEU/VG812eIxC+pyYpps+n2yalrkBY86aq00fkJle7kxOA/gamENxv0qMI6apMiqjLUPHFHs+4kbMtolLl6ffofhj6cyJpqRNAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LjGyRfdW; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769583056; x=1801119056;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gzN16H435P71a1hFvbzPcNWJPMvuFh1t8O7DMR3D2vQ=;
  b=LjGyRfdWnczUFXs/i5qL6FnzxebgMUvqfFWtyHayrTKzFyfhyy9Wfllt
   LTBPgOgNcUb5ncTb2rA96m+62aG5i42or+nHGSEbuTrcnrHTQpDxgSE+o
   uzLWAdSTrTA+AyakLzIlvPlUNFXyu/MGMAs0Uum6U2P+vgDpKxXWu+ezT
   MSAuMZf1/kV8otIFOv48KuoetZk2tJSzfqPLU2ll9JvHI5GgfWpN2a48e
   szFGLy8lMtJioizxm2dsAzSdjKrVkQd/tZoNNH8jK70580a9gFRzWQWov
   vqIHS40Zvi7urE4HV/I5qVWpz38bnFPAHj6PEe9Jnl9wL02TyRLtWG0in
   Q==;
X-CSE-ConnectionGUID: 4CFIkAO8RZWiJYRp9BZPgw==
X-CSE-MsgGUID: +SrNhhsXRouZrck8kX9s3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="58361151"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="58361151"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:50:55 -0800
X-CSE-ConnectionGUID: bM+WCizAQIa5E73sYAQT/g==
X-CSE-MsgGUID: PPfEoJHAQO6KhehHhtx8Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208543927"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:50:50 -0800
Message-ID: <f3979c69-226a-49df-b836-9a53ed79cbc7@linux.intel.com>
Date: Wed, 28 Jan 2026 14:50:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
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
 <20260123145645.90444-9-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260123145645.90444-9-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,intel.com:email,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69331-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 8B0F99D868
X-Rspamd-Action: no action



On 1/23/2026 10:55 PM, Chao Gao wrote:
> P-SEAMLDR returns its information e.g., version and supported features, in
> response to the SEAMLDR.INFO SEAMCALL.
> 
> This information is useful for userspace. For example, the admin can decide
> which TDX module versions are compatible with the P-SEAMLDR according to
> the P-SEAMLDR version.
> 
> Add and export seamldr_get_info() which retrieves P-SEAMLDR information by
> invoking SEAMLDR.INFO SEAMCALL in preparation for exposing P-SEAMLDR
> version and other necessary information to userspace.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

[...]

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
> +
> +static struct seamldr_info seamldr_info __aligned(256);
> +
> +static inline int seamldr_call(u64 fn, struct tdx_module_args *args)

No need to tag the local function with inline.

>  {
>  	unsigned long flags;
>  	u64 vmcs;
> @@ -54,3 +61,11 @@ static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
>  	WARN_ONCE(1, "Failed to save/restore the current VMCS");
>  	return -EIO;
>  }


