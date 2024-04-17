Return-Path: <kvm+bounces-14965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD728A8371
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA2FF28369A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799CA13D53C;
	Wed, 17 Apr 2024 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EgcWtPD7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0299313C903;
	Wed, 17 Apr 2024 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358307; cv=none; b=crGLDIdhWEtJqW0areS5LWxsICr6GJadjQjXVfZS4ObsOBuTvJmpy1Soj3T7NZr5Xbn79sChQh9DkxKnDPij18UBA1ajp44y964Uf+xIkNPqNqrZW1JlOCNnemhPIVr2VcvDYO8QMoyytlW1qpnudWGLJxyQj0OoGlvUBp+UTIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358307; c=relaxed/simple;
	bh=53+5LWkyS0ZfwyWP0xPMc/S61dcHe3RvRLXOb+KTEXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dUiQfDGy01qy65SbNRChKIqqXZ4rtqGtF+qXo7P1inXTAu5TdJ4dIeLjIIERkkReE6YkBgw2MMEjj1fn7ZHHP1+ebCo0t/Xwx2fQw53lKQAB1nF6IEnuhbDlf6Q2kwzGziUqhDTNjB06OjEDQ/NJ77utDXRekbEfLWKe3N/H7HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EgcWtPD7; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713358306; x=1744894306;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=53+5LWkyS0ZfwyWP0xPMc/S61dcHe3RvRLXOb+KTEXk=;
  b=EgcWtPD7WSepVwcvdI+EexdESCJXCpV7RezE32SzAzkQpFm41mkdz40Y
   e9WBNezs9u0DyeU7Xg91K2PelQi1EUjE6zJ9UkuzfVEczlciQ0+6hK7Ed
   J1Xb/ZR87EnXsJs4W9U4gmgNJ7HtqG6zoKadvv66sZW1bliBK70y1qeHi
   sLS+6ZVtufHY/bOqUxJK0FEgRP+ILHoOOAj58347wMBTRok2BxMBLqroW
   YVzHYWZ78ZlqmNwmagYQB7J+2gtUfyHQm1A/tZhV3Ce7RUjYgvfjGNYwS
   ufY7+bnZ85z/Re6Xq3PF/a8iLjGkqt9rzHm1cqiKu5yFCvvrVMpQXBYXr
   w==;
X-CSE-ConnectionGUID: mSb5NtdzTIGP0l5sjN2mEg==
X-CSE-MsgGUID: ZVd8KhbtSmyjy66vlqvxdQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="11788914"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="11788914"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 05:51:45 -0700
X-CSE-ConnectionGUID: 33DQN6LFQ7K6CaiXj8y+eg==
X-CSE-MsgGUID: QC8MLkq9Tx2SptHM9BCRag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="22494324"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 05:51:42 -0700
Message-ID: <00bb2871-8020-4d60-bdb6-d2cebe79d543@linux.intel.com>
Date: Wed, 17 Apr 2024 20:51:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 109/130] KVM: TDX: Handle TDX PV port io hypercall
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4f4aaf292008608a8717e9553c3315ee02f66b20.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4f4aaf292008608a8717e9553c3315ee02f66b20.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Wire up TDX PV port IO hypercall to the KVM backend function.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> v18:
> - Fix out case to set R10 and R11 correctly when user space handled port
>    out.
> ---
>   arch/x86/kvm/vmx/tdx.c | 67 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 67 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index a2caf2ae838c..55fc6cc6c816 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1152,6 +1152,71 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
>   	return kvm_emulate_halt_noskip(vcpu);
>   }
>   
> +static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
> +{
> +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
> +	tdvmcall_set_return_val(vcpu, 0);
> +	return 1;
> +}
> +
> +static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	unsigned long val = 0;
> +	int ret;
> +
> +	WARN_ON_ONCE(vcpu->arch.pio.count != 1);
> +
> +	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
> +					 vcpu->arch.pio.port, &val, 1);
> +	WARN_ON_ONCE(!ret);
> +
> +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
> +	tdvmcall_set_return_val(vcpu, val);
> +
> +	return 1;
> +}
> +
> +static int tdx_emulate_io(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	unsigned long val = 0;
> +	unsigned int port;
> +	int size, ret;
> +	bool write;
> +
> +	++vcpu->stat.io_exits;
> +
> +	size = tdvmcall_a0_read(vcpu);
> +	write = tdvmcall_a1_read(vcpu);
> +	port = tdvmcall_a2_read(vcpu);
> +
> +	if (size != 1 && size != 2 && size != 4) {
> +		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
> +		return 1;
> +	}
> +
> +	if (write) {
> +		val = tdvmcall_a3_read(vcpu);
> +		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
> +
> +		/* No need for a complete_userspace_io callback. */
I am confused about the comment.

The code below sets the complete_userspace_io callback for write case,
i.e. tdx_complete_pio_out().

> +		vcpu->arch.pio.count = 0;
> +	} else
> +		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
> +
> +	if (ret)
> +		tdvmcall_set_return_val(vcpu, val);
> +	else {
> +		if (write)
> +			vcpu->arch.complete_userspace_io = tdx_complete_pio_out;
> +		else
> +			vcpu->arch.complete_userspace_io = tdx_complete_pio_in;
> +	}
> +
> +	return ret;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	if (tdvmcall_exit_type(vcpu))
> @@ -1162,6 +1227,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_emulate_cpuid(vcpu);
>   	case EXIT_REASON_HLT:
>   		return tdx_emulate_hlt(vcpu);
> +	case EXIT_REASON_IO_INSTRUCTION:
> +		return tdx_emulate_io(vcpu);
>   	default:
>   		break;
>   	}


