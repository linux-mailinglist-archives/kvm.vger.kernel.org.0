Return-Path: <kvm+bounces-25892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8B996C2A1
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 17:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01A812821C6
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 15:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD651DFE0C;
	Wed,  4 Sep 2024 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jcLtqobK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEA815E90;
	Wed,  4 Sep 2024 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725464270; cv=none; b=UOg69f7xni8sXPs9OGKTvn36DP9Jl3+hkSwbO5DlL/HgncVrFtV1TOlxRb8Lt6FhQIFggq5RHzC/Nx5RhUvxQb3U8N/3dGYiVNRAGsozMIfKxMYlaBRXtgzWnXOPBXIvOLgbk04+0MGInQb0zEJxjxS7r44L8T8W7l8xNjX/reA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725464270; c=relaxed/simple;
	bh=o4A1J2rVqtIEMgu5fk3LdG2K/f51sRUmPcSsWXxAmH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SQB4U4XvSX/eWOewLT8sHz4Ie7ItYwgsiqwsyBBWECrgkUxiSe1FWiYYm0CuP4MubiauvVed2Zfa7TKzN6/Rp6JqycyU88zeU+G8PpWNJRey6cV5NopXBI99S9wtDqwe47OCiU2dyFiQ/SPk25TFzqZ8V0VpGKeWay/sSTU57K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jcLtqobK; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725464269; x=1757000269;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o4A1J2rVqtIEMgu5fk3LdG2K/f51sRUmPcSsWXxAmH0=;
  b=jcLtqobKpUTvT8FLj9aZDOibuGpjOPfbpcVh2p1pnTTdjp6XNlPOHiqm
   IFHEBJL2eT7y6Pjjb+2A5T4HLVCHApwTo9puEHvE0gkxFywB8mLGlqZnq
   cvf2MCCq+0+SPV1vq98MC4zRoWhPTB1PQj8xAtf/TCSpew4QGip5oNvXJ
   LpHd3fPae+54n7FEeq4wbG6Toe3YcDQTDrNQdYFGwzFbjQTHBDDGhew/N
   aLRp23zfFotAWxWLNW5DTk05JDbTUPx0ofp03CjQcRwp4/JFyFvhL+ceY
   oXGTEif6sq+AO+ui4B7wHxy8hPXGFZPF5sdIl1oWwnnqCRh8L6WAd1Z5y
   Q==;
X-CSE-ConnectionGUID: JQmz5fUMTHi6DHICgYLLaw==
X-CSE-MsgGUID: c1vAdHtKSqOThU7SvXnxwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="46665167"
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="46665167"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 08:37:48 -0700
X-CSE-ConnectionGUID: aQ0D3A4ZQxOdRVHRRSSsDA==
X-CSE-MsgGUID: htX7Sf0oSJmdw8BINlpyjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="65302869"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.26.196])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 08:37:44 -0700
Message-ID: <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
Date: Wed, 4 Sep 2024 18:37:37 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20240904030751.117579-21-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/09/24 06:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
> KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.
> 
> Documentation for the API is added in another patch:
> "Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)"
> 
> For the purpose of attestation, a measurement must be made of the TDX VM
> initial state. This is referred to as TD Measurement Finalization, and
> uses SEAMCALL TDH.MR.FINALIZE, after which:
> 1. The VMM adding TD private pages with arbitrary content is no longer
>    allowed
> 2. The TDX VM is runnable
> 
> Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>  - Added premapped check.
>  - Update for the wrapper functions for SEAMCALLs. (Sean)
>  - Add check if nr_premapped is zero.  If not, return error.
>  - Use KVM_BUG_ON() in tdx_td_finalizer() for consistency.
>  - Change tdx_td_finalizemr() to take struct kvm_tdx_cmd *cmd and return error
>    (Adrian)
>  - Handle TDX_OPERAND_BUSY case (Adrian)
>  - Updates from seamcall overhaul (Kai)
>  - Rename error->hw_error
> 
> v18:
>  - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
> 
> v15:
>  - removed unconditional tdx_track() by tdx_flush_tlb_current() that
>    does tdx_track().
> ---
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/vmx/tdx.c          | 28 ++++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 789d1d821b4f..0b4827e39458 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -932,6 +932,7 @@ enum kvm_tdx_cmd_id {
>  	KVM_TDX_INIT_VM,
>  	KVM_TDX_INIT_VCPU,
>  	KVM_TDX_INIT_MEM_REGION,
> +	KVM_TDX_FINALIZE_VM,
>  	KVM_TDX_GET_CPUID,
>  
>  	KVM_TDX_CMD_NR_MAX,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 796d1a495a66..3083a66bb895 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1257,6 +1257,31 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
>  	ept_sync_global();
>  }
>  
> +static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +	/*
> +	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
> +	 * TDH.MEM.PAGE.ADD().
> +	 */
> +	if (atomic64_read(&kvm_tdx->nr_premapped))
> +		return -EINVAL;
> +
> +	cmd->hw_error = tdh_mr_finalize(kvm_tdx);
> +	if ((cmd->hw_error & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY)
> +		return -EAGAIN;
> +	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
> +		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
> +		return -EIO;
> +	}
> +
> +	kvm_tdx->finalized = true;
> +	return 0;
> +}

Isaku was going to lock the mmu.  Seems like the change got lost.
To protect against racing with KVM_PRE_FAULT_MEMORY,
KVM_TDX_INIT_MEM_REGION, tdx_sept_set_private_spte() etc
e.g. Rename tdx_td_finalizemr to __tdx_td_finalizemr and add:

static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
{
	int ret;

	write_lock(&kvm->mmu_lock);
	ret = __tdx_td_finalizemr(kvm, cmd);
	write_unlock(&kvm->mmu_lock);

	return ret;
}

> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -1281,6 +1306,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_TDX_INIT_VM:
>  		r = tdx_td_init(kvm, &tdx_cmd);
>  		break;
> +	case KVM_TDX_FINALIZE_VM:
> +		r = tdx_td_finalizemr(kvm, &tdx_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;


