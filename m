Return-Path: <kvm+bounces-7645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26111844ED4
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08779B26EB4
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC054568D;
	Thu,  1 Feb 2024 01:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eYkLfk0d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C312566F;
	Thu,  1 Feb 2024 01:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706752037; cv=none; b=ZKcWLvAJ0vptlJHqzkBngeQHhIIHHULAbFD1/NnCvBTfAr9GF4QpKkNiPGST85pCs8LYGsXf1+3R13YpTOhb6RBKksdhS0AiT1tWx4TdayVrRusNbxDxqhyrv/pN+x7PjUU03J2YTcouEYB+gRwctdiZIyDrF7cO8UqR/FPkA2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706752037; c=relaxed/simple;
	bh=t1rkSBJW7ooxEkZOpku+320sY/tVftuAP+A+QZK0C90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmAC0Qn8LDYR+UBxmLhjpYNMeEQykyGfNHF2q41ebDiCDiHlZuUE0DnPKyLO+VgBYgdpIM/C/Zk/sFJIU3ouWwoFGDu45uaU5p17stLyK8lDneLiK/mca725A0+m8+L4plHY17wO6puhtDtJYwrtZgFbrn1xWq4fgtRzVxIHpDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eYkLfk0d; arc=none smtp.client-ip=134.134.136.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706752035; x=1738288035;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t1rkSBJW7ooxEkZOpku+320sY/tVftuAP+A+QZK0C90=;
  b=eYkLfk0d+97ebkqjaok79lmln7O92qD7lU41+FF3r8OgGhjiwhgqzTTw
   /vyP8nHxEvCK07ETa3JwcL708pDw1/vK0Wjx0soTy+i4busf+eE8hocQe
   lRfYDuasrLyGdWRSfa8VVZ+oLgOh45S1yBKDvL7nqSaJv/1ZTz1BuJlYN
   jztvcL6RYmWDPOxwOBSOMptHrKfmpmPjjvqmTFjxOOpWi7T47BKAauQ/S
   xYGaLXVNIM7Q9V9F1RyeHDFYpCw4G3/vxYVhiVRLdXJhX1UGo7pUxWbOf
   R/Ip8Kbo4Xeof+BiRtL4OiCgnQpuk2lfpZRCa4OtQ0WVOeP2ExcZsuqPd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="468014432"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="468014432"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:47:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="738280345"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="738280345"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga003.jf.intel.com with ESMTP; 31 Jan 2024 17:47:10 -0800
Date: Thu, 1 Feb 2024 09:47:09 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v18 016/121] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Message-ID: <20240201014709.5gstyulmsjn7cnff@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <0375033d320c599deee675c4232543c73233ce8b.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0375033d320c599deee675c4232543c73233ce8b.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:52PM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add helper functions to print out errors from the TDX module in a uniform
> manner.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> v18:
> - Added Reviewed-by Binbin.
> ---
>  arch/x86/kvm/Makefile        |  2 +-
>  arch/x86/kvm/vmx/tdx_error.c | 21 +++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx_ops.h   |  5 +++++
>  3 files changed, 27 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kvm/vmx/tdx_error.c
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 5b85ef84b2e9..44b0594da877 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -24,7 +24,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>
>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>  kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
> -kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/tdx_error.o
>
>  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
>  			   svm/sev.o
> diff --git a/arch/x86/kvm/vmx/tdx_error.c b/arch/x86/kvm/vmx/tdx_error.c
> new file mode 100644
> index 000000000000..42fcabe1f6c7
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_error.c
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* functions to record TDX SEAMCALL error */
> +
> +#include <linux/kernel.h>
> +#include <linux/bug.h>
> +
> +#include "tdx_ops.h"
> +
> +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out)
> +{
> +	if (!out) {
> +		pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
> +				   op, error_code);
> +		return;
> +	}
> +
> +#define MSG	\
> +	"SEAMCALL (0x%016llx) failed: 0x%016llx RCX 0x%016llx RDX 0x%016llx R8 0x%016llx R9 0x%016llx R10 0x%016llx R11 0x%016llx\n"
> +	pr_err_ratelimited(MSG, op, error_code, out->rcx, out->rdx, out->r8,
> +			   out->r9, out->r10, out->r11);
> +}
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index f4c16e5265f0..cd12e9c2a421 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -10,6 +10,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/asm.h>
>  #include <asm/kvm_host.h>
> +#include <asm/tdx.h>

Just not sure the reason of this #include here, compile fine w/o it.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>
>  #include "tdx_errno.h"
>  #include "tdx_arch.h"
> @@ -47,6 +48,10 @@ static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
>  	return ret;
>  }
>
> +#ifdef CONFIG_INTEL_TDX_HOST
> +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
> +#endif
> +
>  static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
>  {
>  	struct tdx_module_args in = {
> --
> 2.25.1
>
>

