Return-Path: <kvm+bounces-14278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 169AE8A1CCD
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 854351F24327
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A351BED6C;
	Thu, 11 Apr 2024 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cx/UTL2q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA2943ADA;
	Thu, 11 Apr 2024 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712853564; cv=none; b=QYHcRA2tTqU6rGx+PVM3peO7vCAatvCUpkLvx2nVDqHZydpVoGAvhw5cXQyqtgLusUUp+KOZz8cQvemuu4wFifr/nxURi5Evihw4ccNDjDa28zSbyKR9kguoVDrL0YcB/eJqVd9vXjpe2O8TImFaBogRm40RzgNu+HbaVW5EipM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712853564; c=relaxed/simple;
	bh=PWmjccZkSJXuxx9lT+7Acx5QZuHRZr9OGDvcIRNXG9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ehjyopkho8M7qH/ZVq2BzSBlNbGOg0QyWmcI2R41cFNnJdAl7DhcEAYKmJ8eqrM4crrCWooPAfqGgc6SYTriyuMkdj0JGMjGSsQqFlGSbugGy28FqWj4vKBMRLn7jPHtxfLvERFIfCRe2g1VTgBDhEigoiHVj3sT7UiTmXdVrac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cx/UTL2q; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712853562; x=1744389562;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PWmjccZkSJXuxx9lT+7Acx5QZuHRZr9OGDvcIRNXG9E=;
  b=cx/UTL2q7h9VdIjV+yQ7rf6qoVIRcW2nkbVNtKMYoJNoqG7zmr6UmAL5
   KKYaFvxALysfDroqIcl2Zl8Q8G5OG60XAPMGy9pBl7Eim5Oc7uAY1ypyv
   5JvfA3J+KB+8HY6kmd7PtHR0TL8Qx7SNQFCepU/Y0h++NGstRMQmYNtcG
   8QHZX7jFWPfnq4z92ax3rFsXyOIAMxopv+gfoQF0aYnuTx5lLD9dfguAt
   saopHAKeW7oIjM/ve65NPm09RC3Qu4BsQBdv4suaBoc1Ln3CtU89ru6LT
   DK9BXqZUyj4RpgCFrEUpKteY+9W1pmskE4te/X1XdD+0MrYktvaQcv2XS
   Q==;
X-CSE-ConnectionGUID: 3238KIjDRx25DqRSZrsIww==
X-CSE-MsgGUID: J6qkCiaARWSudogiOth7NQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="25789947"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25789947"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 09:39:21 -0700
X-CSE-ConnectionGUID: ojrizVxnSCCBXMY+bzMywA==
X-CSE-MsgGUID: BWNOhvUhQaOMIIs4rQHKgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25735575"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.215.66])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 09:39:18 -0700
Message-ID: <f3381541-822b-4e94-93f7-699afc6aa6a3@intel.com>
Date: Thu, 11 Apr 2024 19:39:11 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 076/130] KVM: TDX: Finalize VM initialization
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Edgecombe, Rick P"
 <rick.p.edgecombe@intel.com>
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <e3c862ae9c78bda2988768c1038fec100bb372cf.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <e3c862ae9c78bda2988768c1038fec100bb372cf.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/02/24 10:26, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To protect the initial contents of the guest TD, the TDX module measures
> the guest TD during the build process as SHA-384 measurement.  The
> measurement of the guest TD contents needs to be completed to make the
> guest TD ready to run.
> 
> Add a new subcommand, KVM_TDX_FINALIZE_VM, for VM-scoped
> KVM_MEMORY_ENCRYPT_OP to finalize the measurement and mark the TDX VM ready
> to run.

Perhaps a spruced up commit message would be:

<BEGIN>
Add a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.

Documentation for the API is added in another patch:
"Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)"

For the purpose of attestation, a measurement must be made of the TDX VM
initial state. This is referred to as TD Measurement Finalization, and
uses SEAMCALL TDH.MR.FINALIZE, after which:
1. The VMM adding TD private pages with arbitrary content is no longer
   allowed
2. The TDX VM is runnable
<END>

History:

This code is essentially unchanged from V1, as below.
Except for V5, the code has never had any comments.
Paolo's comment from then still appears unaddressed.

V19:		Unchanged
V18:		Undoes change of V17
V17:		Also change tools/arch/x86/include/uapi/asm/kvm.h
V16:		Unchanged
V15:		Undoes change of V10
V11-V14:	Unchanged
V10:		Adds a hack (related to TDH_MEM_TRACK)
		that was later removed in V15
V6-V9:		Unchanged
V5		Broke out the code into a separate patch and
		received its only comments, which were from Paolo:

	"Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
	Note however that errors should be passed back in the struct."
		
	This presumably refers to struct kvm_tdx_cmd which has an "error"
	member, but that is not updated by tdx_td_finalizemr()

V4 was a cut-down series and the code was not present
V3 introduced WARN_ON_ONCE for the error condition
V2 accommodated renaming the seamcall function and ID

Outstanding:

1. Address Paolo's comment about the error code
2. Is WARN_ON sensible?

Final note:

It might be possible to make TD Measurement Finalization
transparent to the user space VMM and forego another API, but it seems
doubtful that would really make anything much simpler.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> v18:
> - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
> 
> v14 -> v15:
> - removed unconditional tdx_track() by tdx_flush_tlb_current() that
>   does tdx_track().
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/vmx/tdx.c          | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 34167404020c..c160f60189d1 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -573,6 +573,7 @@ enum kvm_tdx_cmd_id {
>  	KVM_TDX_INIT_VM,
>  	KVM_TDX_INIT_VCPU,
>  	KVM_TDX_EXTEND_MEMORY,
> +	KVM_TDX_FINALIZE_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3cfba63a7762..6aff3f7e2488 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1400,6 +1400,24 @@ static int tdx_extend_memory(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	return ret;
>  }
>  
> +static int tdx_td_finalizemr(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err;
> +
> +	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	err = tdh_mr_finalize(kvm_tdx->tdr_pa);
> +	if (WARN_ON_ONCE(err)) {

Is a failed SEAMCALL really something to WARN over?

> +		pr_tdx_error(TDH_MR_FINALIZE, err, NULL);

As per Paolo, error code is not returned in struct kvm_tdx_cmd

> +		return -EIO;
> +	}
> +
> +	kvm_tdx->finalized = true;
> +	return 0;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -1422,6 +1440,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_TDX_EXTEND_MEMORY:
>  		r = tdx_extend_memory(kvm, &tdx_cmd);
>  		break;
> +	case KVM_TDX_FINALIZE_VM:
> +		r = tdx_td_finalizemr(kvm);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;


