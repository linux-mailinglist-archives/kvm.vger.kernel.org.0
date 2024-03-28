Return-Path: <kvm+bounces-12964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E848B88F727
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74ABBB21A98
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 05:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6FB45951;
	Thu, 28 Mar 2024 05:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aej5HGLk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5313D304;
	Thu, 28 Mar 2024 05:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711603477; cv=none; b=HIKzsOJxeRrvk3PilAHtHzRNHcloKJYXvr8umThhATsI4NadZ0MXmMfVbG0JlpWk1dJU7/Su1K3TmMLjSWSH+OYJxamsYNvhl+lolMucHdEpYpW/ulXQk2+cCoqfEnJpmumP2jR082GixlmwjtiTN9dlzZcScBxPM+UFthQduAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711603477; c=relaxed/simple;
	bh=yw8GtftqZAvBx8gq5uIPgpQrdVhodSjj57djQ9gazmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LRmJiN0eSlAWXOGzfXg1/wAjFjBCbCdfwha3VUvZQ7PHz2gKDRYTEGp2UVkyBSb+jZnGQYcEoNKkynnZW30+R2GyDPEj9KXsAco58gtm9TSC77YsIgpNgBdlR3NrzWZi+ytkOvO648JFKibp22S79R01roatmfTDQ62KkxmhXJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aej5HGLk; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711603475; x=1743139475;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yw8GtftqZAvBx8gq5uIPgpQrdVhodSjj57djQ9gazmw=;
  b=aej5HGLkC7WNktrTgwapzJ25tmYqLhx/oekmXP2Y6p/GU0GRcNG0VmDs
   QAy1toxoH9qhN4JfbRBDEcBGiqda/vWoP8fK+YI86dlWBBfZxF4neIQDy
   P7ZKLv9QzLFVqb6RqEcSAeB7LcaOlVI3eiGw8qYLOed1TFVolqOqFKuhU
   b+ye1/2KO3CYBVwZEOmCKlN9PrvchyIyQU5sGCP/ITDU4Msor1rAFHMs5
   ny1smJuF7WoBOLTVf21zGWZNXLKAzNF/2iLTXAemg9o+fsTy8aE2BUlt5
   mlTCTDgqQsrmi1cWKlXXVdiM/dwYZ2d2QU7SLJ4l8WMR+j5ZAXGcC7ZZo
   w==;
X-CSE-ConnectionGUID: +AvnARNfRDCEr4oVfXFxYw==
X-CSE-MsgGUID: qnhfdNPxTLa47TH7sQHCSA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6602122"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6602122"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 22:24:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21179122"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 22:24:30 -0700
Message-ID: <94fb2094-d8ee-4bcc-a65d-489dc777b024@linux.intel.com>
Date: Thu, 28 Mar 2024 13:24:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 069/130] KVM: TDX: Require TDP MMU and mmio caching
 for TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f6a80dd212e8c3fd14b40049eed33187008cf35a.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f6a80dd212e8c3fd14b40049eed33187008cf35a.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
> support for TDX isn't implemented.  TDX requires KVM mmio caching.

Can you add some description about why TDX requires mmio caching in the 
changelog?


>   Disable
> TDX support when TDP MMU or mmio caching aren't supported.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c  |  1 +
>   arch/x86/kvm/vmx/main.c | 13 +++++++++++++
>   2 files changed, 14 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0e0321ad9ca2..b8d6ce02e66d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -104,6 +104,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>    * If the hardware supports that we don't need to do shadow paging.
>    */
>   bool tdp_enabled = false;
> +EXPORT_SYMBOL_GPL(tdp_enabled);
>   
>   static bool __ro_after_init tdp_mmu_allowed;
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 076a471d9aea..54df6653193e 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -3,6 +3,7 @@
>   
>   #include "x86_ops.h"
>   #include "vmx.h"
> +#include "mmu.h"
>   #include "nested.h"
>   #include "pmu.h"
>   #include "tdx.h"
> @@ -36,6 +37,18 @@ static __init int vt_hardware_setup(void)
>   	if (ret)
>   		return ret;
>   
> +	/* TDX requires KVM TDP MMU. */
> +	if (enable_tdx && !tdp_enabled) {
> +		enable_tdx = false;
> +		pr_warn_ratelimited("TDX requires TDP MMU.  Please enable TDP MMU for TDX.\n");
> +	}
> +
> +	/* TDX requires MMIO caching. */
> +	if (enable_tdx && !enable_mmio_caching) {
> +		enable_tdx = false;
> +		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
> +	}
> +
>   	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
>   	if (enable_tdx)
>   		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,


