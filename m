Return-Path: <kvm+bounces-7648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C8B844EEA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7A711C24BEF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF0912E5F;
	Thu,  1 Feb 2024 01:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hxYJD/rL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E785EAE3;
	Thu,  1 Feb 2024 01:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706752655; cv=none; b=OsPASRRyMcERj5rdh5J3kl3nWBhe5Xm1KeHdyKtcmVuldj0Ayn1qn6Xc2M30SSbiTu4juR6mokih7d5FztwTynNkzaA6R9CuE/Uvq2LTq1w/Ca/wS1phzUHqtcqf+jCh3FUCRPSgbLve7heKIlVdhQbYykvuQDBTUXzEukjQFuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706752655; c=relaxed/simple;
	bh=ntPLv7GhCXDRjysAd8J9WhbQvJEwCo5yWUs1jbfxMoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IDuoS8UmgufJmOc8WY+YPkFLDx2XmevGr7iDZ0EaNIEl5W2hIHy5uk/ZyyK1+uygS+IO1rzbQ8k9ldhBuJlJF/TliFGO9/TjQSDi/TFHLjXYpXtrQJ5Q9/TxpayA5ZHzmQK5nsex9FpcsL+cXsZkRyIpcEA/t2ERtPndodqT7CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hxYJD/rL; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706752653; x=1738288653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ntPLv7GhCXDRjysAd8J9WhbQvJEwCo5yWUs1jbfxMoE=;
  b=hxYJD/rL7nQdr/h2kd4T/MYAjILzYko8N7S53aU90XZ6QIhkKMIF1UH8
   dW9V+iU7gwH/pc68pes2dSwsJqSwdWM0wn+FRvt69LnhBQtM/7aauumFA
   Dr7NFmUwVxuIh5GG/sp2q4KT2Xmp/0vKC8T64+dIHg70846tPwRu6hlPl
   peP3/VPhWr1erv+hzlZ4rWs9bW+GO8YVNMqYRg6MiLpx7tsulpnKK8z0e
   81c5wx6aZZ0YDJ+vvLk5OExFlC8KSjrbxXSVilnZD/qyiKZdyFJG9ieNN
   M0lp7Yfj7ATkF5tpwWLX3VqMVXdfsstNLk1N0w6FKfHlvPCMUDByI35vT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="394229031"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="394229031"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="4375413"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa004.jf.intel.com with ESMTP; 31 Jan 2024 17:57:31 -0800
Date: Thu, 1 Feb 2024 09:57:29 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v18 001/121] x86/virt/tdx: Export TDX KeyID information
Message-ID: <20240201015729.6n5uavy7rxdjtqwc@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <fed47cd35b32ee66f7ec55bdda6ccab12c139e85.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fed47cd35b32ee66f7ec55bdda6ccab12c139e85.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:37PM -0800, isaku.yamahata@intel.com wrote:
> From: Kai Huang <kai.huang@intel.com>
>
> Each TDX guest must be protected by its own unique TDX KeyID.  KVM will
> need to tell the TDX module the unique KeyID for a TDX guest when KVM
> creates it.
>
> Export the TDX KeyID range that can be used by TDX guests for KVM to
> use.  KVM can then manage these KeyIDs and assign one for each TDX guest
> when it is created.
>
> Each TDX guest has a root control structure called "Trust Domain Root"
> (TDR).  Unlike the rest of the TDX guest, the TDR is protected by the
> TDX global KeyID.  When tearing down the TDR, KVM will need to pass the
> TDX global KeyID explicitly to the TDX module to flush cache associated
> to the TDR.
>
> Also export the TDX global KeyID for KVM to tear down the TDR.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

The variables exported by this patch are used first time in patch 18 IIUC...
So how about move this one just before the patch 18 ?

> ---
>  arch/x86/include/asm/tdx.h  |  5 +++++
>  arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++---
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 4595fbe4639b..4e219fc2e8ee 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -88,6 +88,11 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
>
>  #ifdef CONFIG_INTEL_TDX_HOST
> +
> +extern u32 tdx_global_keyid;
> +extern u32 tdx_guest_keyid_start;
> +extern u32 tdx_nr_guest_keyids;
> +
>  u64 __seamcall(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 06fbd0b9ea29..14e068ee2640 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -39,9 +39,14 @@
>  #include <asm/mce.h>
>  #include "tdx.h"
>
> -static u32 tdx_global_keyid __ro_after_init;
> -static u32 tdx_guest_keyid_start __ro_after_init;
> -static u32 tdx_nr_guest_keyids __ro_after_init;
> +u32 tdx_global_keyid __ro_after_init;
> +EXPORT_SYMBOL_GPL(tdx_global_keyid);
> +
> +u32 tdx_guest_keyid_start __ro_after_init;
> +EXPORT_SYMBOL_GPL(tdx_guest_keyid_start);
> +
> +u32 tdx_nr_guest_keyids __ro_after_init;
> +EXPORT_SYMBOL_GPL(tdx_nr_guest_keyids);
>
>  static DEFINE_PER_CPU(bool, tdx_lp_initialized);
>
> --
> 2.25.1
>
>

