Return-Path: <kvm+bounces-43321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DAC0A89195
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 03:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D04E61899F6E
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 01:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC68F20010A;
	Tue, 15 Apr 2025 01:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QjkYHVr/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED8E552;
	Tue, 15 Apr 2025 01:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744681790; cv=none; b=d3bDM2aEYSK2OayJ/m8x8MvJVyCpGvqzx8YfLeM3lhrggpP7dNjuzh3Egvp+W80p4nwNddiqv9uNPGxNSBI+b9WitZoQDz1NZQ7YTuXZDjwuS4wwSy2Ch27BQKzGUFlzbrWczRX1zBsK4ajWPTHsIgaFji/Ui0T3gxTpWBOKjXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744681790; c=relaxed/simple;
	bh=lXraKbXdGYRiaA2c3nWO0O4y2vkLQF8MT/B2jHkIbeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvGlRr/S7fy2pEf0FHpELoXbeHiq++T2TmHuK1rjAEm5dRXwTMQYXIux1XANPYBcCc8Z0VIxrNV20PDNGHGI6qQsvX75KgElQeiEiR5do9Lf81k71RIXX2ph/kZxwcNMdSzHy9H4SiU5o8wBGA/7nvX4thwan0jd82auSKDBqHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QjkYHVr/; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744681787; x=1776217787;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lXraKbXdGYRiaA2c3nWO0O4y2vkLQF8MT/B2jHkIbeg=;
  b=QjkYHVr/sumppZZWGCeQR0zSCwp8T2l8jpV3cKL+ugL50RJ73epu5u22
   gUhhnyLvYvxRPB+mcF3UHi6eKS97UYwSTakjBoSZh1Ku2aKCZSEyzztGV
   Lmce+An5iPpxNRjy1/KncmdnX9xgIC5mfXG8N551WDVLHh8yCHMuvm2Wn
   MBpR9K07E2ABwKLR/xrADWfJFxrw4KGzhcpOXdPUfjoqWLOgNHP+VGnfZ
   VHKkCDwgajS7a/9DATbT5JcfahTjlXbgNnSpH679jKTbr1YyspGBgiai9
   18llhfxa6ufXBtI6jnmwUiIQNfnusl043RVuRGUy2FMjRG9u8+L6bIwsC
   g==;
X-CSE-ConnectionGUID: Z4FTA/I+QqmxdxpGHZhfRA==
X-CSE-MsgGUID: E3BDWLzpR+mFfeHEjkRJmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="33786037"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="33786037"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:49:47 -0700
X-CSE-ConnectionGUID: 6IoTLRUjRgO96cvwmF0tFw==
X-CSE-MsgGUID: c1qKzYpBTOeWrETvkV5KJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="134955131"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:49:41 -0700
Message-ID: <98408cbc-4244-4617-864d-c87a3b28b3af@intel.com>
Date: Tue, 15 Apr 2025 09:49:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 mikko.ylinen@linux.intel.com, linux-kernel@vger.kernel.org
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250402001557.173586-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/2/2025 8:15 AM, Binbin Wu wrote:
> Handle TDVMCALL for GetQuote to generate a TD-Quote.
> 
> GetQuote is a doorbell-like interface used by TDX guests to request VMM
> to generate a TD-Quote signed by a service hosting TD-Quoting Enclave
> operating on the host.  A TDX guest passes a TD Report (TDREPORT_STRUCT) in
> a shared-memory area as parameter.  Host VMM can access it and queue the
> operation for a service hosting TD-Quoting enclave.  When completed, the
> Quote is returned via the same shared-memory area.
> 
> KVM forwards the request to userspace VMM (e.g., QEMU) and userspace VMM
> queues the operation asynchronously.  After the TDVMCALL is returned and
> back to TDX guest, TDX guest can poll the status field of the shared-memory
> area.
> 
> Add KVM_EXIT_TDX_GET_QUOTE as a new exit reason to userspace and forward
> the request after some sanity checks.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Mikko Ylinen <mikko.ylinen@linux.intel.com>
> ---
>   Documentation/virt/kvm/api.rst | 19 ++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.c         | 35 ++++++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h       |  7 +++++++
>   3 files changed, 61 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index b61371f45e78..90aa7a328dc8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7162,6 +7162,25 @@ The valid value for 'flags' is:
>     - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
>       in VMCS. It would run into unknown result if resume the target VM.
>   
> +::
> +
> +		/* KVM_EXIT_TDX_GET_QUOTE */
> +		struct tdx_get_quote {
> +			__u64 ret;
> +			__u64 gpa;
> +			__u64 size;
> +		};
> +
> +If the exit reason is KVM_EXIT_TDX_GET_QUOTE, then it indicates that a TDX
> +guest has requested to generate a TD-Quote signed by a service hosting
> +TD-Quoting Enclave operating on the host. The 'gpa' field and 'size' specify
> +the guest physical address and size of a shared-memory buffer, in which the
> +TDX guest passes a TD report. When completed, the generated quote is returned
> +via the same buffer. The 'ret' field represents the return value. The userspace
> +should update the return value before resuming the vCPU according to TDX GHCI
> +spec. It's an asynchronous request. After the TDVMCALL is returned and back to
> +TDX guest, TDX guest can poll the status field of the shared-memory area.
> +
>   ::
>   
>   		/* Fix the size of the union. */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..535200446c21 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1463,6 +1463,39 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int tdx_complete_get_quote(struct kvm_vcpu *vcpu)
> +{
> +	tdvmcall_set_return_code(vcpu, vcpu->run->tdx_get_quote.ret);
> +	return 1;
> +}
> +
> +static int tdx_get_quote(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	u64 gpa = tdx->vp_enter_args.r12;
> +	u64 size = tdx->vp_enter_args.r13;
> +
> +	/* The buffer must be shared memory. */
> +	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) || size == 0) {
> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> +		return 1;
> +	}
> +
> +	if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(size)) {
> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_ALIGN_ERROR);
> +		return 1;
> +	}
> +
> +	vcpu->run->exit_reason = KVM_EXIT_TDX_GET_QUOTE;
> +	vcpu->run->tdx_get_quote.gpa = gpa;
> +	vcpu->run->tdx_get_quote.size = size;
> +
> +	vcpu->arch.complete_userspace_io = tdx_complete_get_quote;
> +
> +	return 0;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	switch (tdvmcall_leaf(vcpu)) {
> @@ -1472,6 +1505,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_report_fatal_error(vcpu);
>   	case TDVMCALL_GET_TD_VM_CALL_INFO:
>   		return tdx_get_td_vm_call_info(vcpu);
> +	case TDVMCALL_GET_QUOTE:
> +		return tdx_get_quote(vcpu);
>   	default:
>   		break;
>   	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c6988e2c68d5..eca86b7f0cbc 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -178,6 +178,7 @@ struct kvm_xen_exit {
>   #define KVM_EXIT_NOTIFY           37
>   #define KVM_EXIT_LOONGARCH_IOCSR  38
>   #define KVM_EXIT_MEMORY_FAULT     39
> +#define KVM_EXIT_TDX_GET_QUOTE    41

Number 40 is skipped and I was told internally the reason is mentioned 
in cover letter

     Note that AMD has taken 40 for KVM_EXIT_SNP_REQ_CERTS in the
     patch [4] under review, to avoid conflict, use number 41 for
     KVM_EXIT_TDX_GET_QUOTE and number 42 for
     KVM_EXIT_TDX_SETUP_EVENT_NOTIFY.

I think we shouldn't give up number 40 unless this series depends on AMD 
one or it's agreement that AMD one will be queued/merged earlier.

>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -447,6 +448,12 @@ struct kvm_run {
>   			__u64 gpa;
>   			__u64 size;
>   		} memory_fault;
> +		/* KVM_EXIT_TDX_GET_QUOTE */
> +		struct {
> +			__u64 ret;
> +			__u64 gpa;
> +			__u64 size;
> +		} tdx_get_quote;
>   		/* Fix the size of the union. */
>   		char padding[256];
>   	};


