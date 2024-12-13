Return-Path: <kvm+bounces-33715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B949F082A
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB013188B085
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2951B3932;
	Fri, 13 Dec 2024 09:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G3JEszPU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766E41B21A6;
	Fri, 13 Dec 2024 09:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734082858; cv=none; b=KVunKgHK2r7vfb7MXI+tVvL+tnSU5LQpxdYBM4Gh9kiDsa+TaUPLi0+KzYzCvD75ki2OPZ5JJbJHwccPTxy5X2zcDlm1/tKtXFQ0d1rQuuiMKERj/YEG1cHiPOiA/FdfMHzyLfKPAgZzpslscmJTexEgINtjEOb/mf7uaypGSIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734082858; c=relaxed/simple;
	bh=J8uEGXAMi3YY0F+tyr8ALgZHMklBAPU3Mc8yWWTc/NU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qkR6PjDyCt7xFx8tOrqd2Xk+1ZUDKYT6ES52XQwtDD6MJXl8YAFatHXBPwM1o0GN/vhHZH6JX9NCjyf9aiijp+0geuW2FSLczABj7B5UnxukhsBtz9/fULgKpOQdUZX+CuulEpRUup+R28Jw9uEgfcfOx0szS6RP2bEsCOW5pTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G3JEszPU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734082856; x=1765618856;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J8uEGXAMi3YY0F+tyr8ALgZHMklBAPU3Mc8yWWTc/NU=;
  b=G3JEszPUDTdQzhn/bYfT7sw0L/NjcN3FlNE0LTcUc/L+86xOgC1ZWCfJ
   Iqtl+eAjB+YjKREfBygTdMPCLm/6t035dxUybnJTfWT80rDqgV6DufQuB
   S6hwBgRSlB8ZnOwxikykUkDPmgKAZ/OLCEWdYokVl0sY0oe4DErxC+b0X
   mQw6RzDPF+p9Twh4KC0fciCvf6j0KcvORFY7b8hUSlxUGNxgrRg23TK8u
   ROEOkq/I33eJF8o7feDpDBASgLxxOP3h9UDMP/9uHtlc7VU+K6KZu8n75
   Bwm2b6iHKtcBFyCyjIMuzyGxkKE+aDXfLxz71TuGMIKedlS8Y9jY3qU++
   g==;
X-CSE-ConnectionGUID: 57cuT/xOS1y7J6cuN11KDQ==
X-CSE-MsgGUID: 6v4gq7MnR3mXhbCA/s83Bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51948982"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51948982"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 01:40:56 -0800
X-CSE-ConnectionGUID: TcIQ1h52QQyvlcNXhZN7kg==
X-CSE-MsgGUID: BzGj08GXQTuWAsSdSebWCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119749396"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 01:40:52 -0800
Message-ID: <dfe4c078-e7f9-44ee-8320-a189ea2ce51b@intel.com>
Date: Fri, 13 Dec 2024 17:40:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-6-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241201035358.2193078-6-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/2024 11:53 AM, Binbin Wu wrote:
> Convert TDG.VP.VMCALL<ReportFatalError> to KVM_EXIT_SYSTEM_EVENT with
> a new type KVM_SYSTEM_EVENT_TDX_FATAL and forward it to userspace for
> handling.
> 
> TD guest can use TDG.VP.VMCALL<ReportFatalError> to report the fatal
> error it has experienced.  This hypercall is special because TD guest
> is requesting a termination with the error information, KVM needs to
> forward the hypercall to userspace anyway, KVM doesn't do sanity checks
> and let userspace decide what to do.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> Hypercalls exit to userspace breakout:
> - New added.
>    Implement one of the hypercalls need to exit to userspace for handling after
>    reverting "KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL", which tries to resolve
>    Sean's comment.
>    https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
> - Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
> ---
>   Documentation/virt/kvm/api.rst |  8 ++++++
>   arch/x86/kvm/vmx/tdx.c         | 50 ++++++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h       |  1 +
>   3 files changed, 59 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index edc070c6e19b..bb39da72c647 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6815,6 +6815,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
>     #define KVM_SYSTEM_EVENT_WAKEUP         4
>     #define KVM_SYSTEM_EVENT_SUSPEND        5
>     #define KVM_SYSTEM_EVENT_SEV_TERM       6
> +  #define KVM_SYSTEM_EVENT_TDX_FATAL      7
>   			__u32 type;
>                           __u32 ndata;
>                           __u64 data[16];
> @@ -6841,6 +6842,13 @@ Valid values for 'type' are:
>      reset/shutdown of the VM.
>    - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
>      The guest physical address of the guest's GHCB is stored in `data[0]`.
> + - KVM_SYSTEM_EVENT_TDX_FATAL -- an TDX guest requested termination.
> +   The error codes of the guest's GHCI is stored in `data[0]`.
> +   If the bit 63 of `data[0]` is set, it indicates there is TD specified
> +   additional information provided in a page, which is shared memory. The
> +   guest physical address of the information page is stored in `data[1]`.
> +   An optional error message is provided by `data[2]` ~ `data[9]`, which is
> +   byte sequence, LSB filled first. Typically, ASCII code(0x20-0x7e) is filled.
>    - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
>      KVM has recognized a wakeup event. Userspace may honor this event by
>      marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 553f4cbe0693..a79f9ca962d1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1093,6 +1093,54 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg_mask = kvm_rcx_read(vcpu);
> +	u64* opt_regs;
> +
> +	/*
> +	 * Skip sanity checks and let userspace decide what to do if sanity
> +	 * checks fail.
> +	 */
> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
> +	vcpu->run->system_event.ndata = 10;
> +	/* Error codes. */
> +	vcpu->run->system_event.data[0] = tdvmcall_a0_read(vcpu);
> +	/* GPA of additional information page. */
> +	vcpu->run->system_event.data[1] = tdvmcall_a1_read(vcpu);
> +	/* Information passed via registers (up to 64 bytes). */
> +	opt_regs = &vcpu->run->system_event.data[2];
> +
> +#define COPY_REG(REG, MASK)						\
> +	do {								\
> +		if (reg_mask & MASK)					\
> +			*opt_regs = kvm_ ## REG ## _read(vcpu);		\
> +		else							\
> +			*opt_regs = 0;					\
> +		opt_regs++;						\

I'm not sure if we need to skip the "opt_regs++" the corresponding 
register is not set valid in reg_mask. And maintain ndata to actual 
valid number instead of hardcoding it to 10.

> +	} while (0)
> +
> +	/* The order is defined in GHCI. */
> +	COPY_REG(r14, BIT_ULL(14));
> +	COPY_REG(r15, BIT_ULL(15));
> +	COPY_REG(rbx, BIT_ULL(3));
> +	COPY_REG(rdi, BIT_ULL(7));
> +	COPY_REG(rsi, BIT_ULL(6));
> +	COPY_REG(r8, BIT_ULL(8));
> +	COPY_REG(r9, BIT_ULL(9));
> +	COPY_REG(rdx, BIT_ULL(2));
> +
> +	/*
> +	 * Set the status code according to GHCI spec, although the vCPU may
> +	 * not return back to guest.
> +	 */
> +	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
> +
> +	/* Forward request to userspace. */
> +	return 0;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	if (tdvmcall_exit_type(vcpu))
> @@ -1101,6 +1149,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   	switch (tdvmcall_leaf(vcpu)) {
>   	case TDVMCALL_MAP_GPA:
>   		return tdx_map_gpa(vcpu);
> +	case TDVMCALL_REPORT_FATAL_ERROR:
> +		return tdx_report_fatal_error(vcpu);
>   	default:
>   		break;
>   	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 637efc055145..c173c8dfcf83 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -375,6 +375,7 @@ struct kvm_run {
>   #define KVM_SYSTEM_EVENT_WAKEUP         4
>   #define KVM_SYSTEM_EVENT_SUSPEND        5
>   #define KVM_SYSTEM_EVENT_SEV_TERM       6
> +#define KVM_SYSTEM_EVENT_TDX_FATAL      7
>   			__u32 type;
>   			__u32 ndata;
>   			union {


