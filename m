Return-Path: <kvm+bounces-33376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A429EA607
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 03:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E258328499A
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 02:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C938F1C242C;
	Tue, 10 Dec 2024 02:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L7G+jiN1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C662A1A2550;
	Tue, 10 Dec 2024 02:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733799125; cv=none; b=KbzWGeHqYbXthq3th+IDYNmR0uTtAZcND7t2J3Cq0sU2ZRAneZpbdLd1lbtqd3/ES6egDB2VMRyCbWgIk8e1U2yBnaW7yCL66kjtNzlCJoUyg1SGkV6ue/MVmaL2PIF+B4qLh5ldf/J8ndkprAHYovavPRJQYHf8upBNp3qAc1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733799125; c=relaxed/simple;
	bh=ClVyDaGFj9M5uw6bBVAR3oour6eApQIS+xBoSBMZ04o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gfQKbVzI/If4fYNQ0wSX5IBamdz6j2YY/YWEO6SRlHlGMt4MkGTI2Yn9JB9bsWfWozrpgyFmvbXoCxWDx+LikG55ydEjZWC+6jjuj0qhZSFuTkE6y4vDH6oEvw33G2ExoMqr/x2cQLMwbkhKYaL8MxiRQ4hW/XugrNYDURu/I7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L7G+jiN1; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733799123; x=1765335123;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ClVyDaGFj9M5uw6bBVAR3oour6eApQIS+xBoSBMZ04o=;
  b=L7G+jiN19/LpTblCnYB6Ye4hOTLy/49ybSs4fEsqZPArkO4ipDWAFBZ2
   zEwObFudTbZe2w3kzCNQjZrliQMJ+LpuhxsbG8IKRF9fmJnACcQ1+IpyZ
   sGYaVSi6NZQdeVT8xW4Yh1ffYT7CpHguA20nXWASoN9gjR2WC5lzhxuNk
   T2PbX77dUPzy9WU5nQJDO1BLvorbVk43q8vde5sSGEQXdXAFpWS/Dkaq7
   vWsT8Gjp/ZV1cJ3sZQr+uIU6npmyFyuO6Fm64WmpLORB/HvzZO8mHDKkW
   C/d8BzWHPViE9ux9zi8KXoqoyR09w94iUY6YVvCHtQvr1wlwuKcEVoJjd
   w==;
X-CSE-ConnectionGUID: BGWl7ZvIRaunOKfkpVOVzQ==
X-CSE-MsgGUID: Mtj+xeS3RUOxtDtHLvzbkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="38055956"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="38055956"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 18:52:02 -0800
X-CSE-ConnectionGUID: +CoZqUtaQHGGb0XWyvOLdA==
X-CSE-MsgGUID: SLv2HwdASUSPMuRAGRpwfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="95078689"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 18:51:59 -0800
Message-ID: <e8163ac4-59cd-4beb-bb92-44aa2d7702ab@linux.intel.com>
Date: Tue, 10 Dec 2024 10:51:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
 <Z1bmUCEdoZ87wIMn@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z1bmUCEdoZ87wIMn@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/9/2024 8:45 PM, Chao Gao wrote:
>> +/*
>> + * Split into chunks and check interrupt pending between chunks.  This allows
>> + * for timely injection of interrupts to prevent issues with guest lockup
>> + * detection.
> Would it cause any problems if an (intra-host or inter-host) migration happens
> between chunks?
>
> My understanding is that KVM would lose track of the progress if
> map_gpa_next/end are not migrated. I'm not sure if KVM should expose the
> state or prevent migration in the middle. Or, we can let the userspace VMM
> cut the range into chunks, making it the userspace VMM's responsibility to
> ensure necessary state is migrated.
>
> I am not asking to fix this issue right now. I just want to ensure this issue
> can be solved in a clean way when we start to support migration.
How about:
Before exiting to userspace, KVM always sets the start GPA to r11 and set
return code to TDVMCALL_STATUS_RETRY.
- If userspace finishes the part, the complete_userspace_io() callback will
   be called and the return code will be set to TDVMCALL_STATUS_SUCCESS.
- If the live migration interrupts the MapGAP in the userspace, and
   complete_userspace_io() is not called, when the vCPU resumes from migration,
   TDX guest will see the return code is TDVMCALL_STATUS_RETRY with the failed
   GPA, and it can retry the MapGAP with the failed GAP.


>
>> + */
>> +#define TDX_MAP_GPA_MAX_LEN (2 * 1024 * 1024)
>> +static void __tdx_map_gpa(struct vcpu_tdx * tdx);
>> +
>> +static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_tdx * tdx = to_tdx(vcpu);
>> +
>> +	if(vcpu->run->hypercall.ret) {
>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +		kvm_r11_write(vcpu, tdx->map_gpa_next);
> s/kvm_r11_write/tdvmcall_set_return_val
>
> please fix other call sites in this patch.

I didn't use tdvmcall_set_return_val() because it's used for TDVMCALL
like MMIO, PIO, etc..., which has a return value.
For MapGPA, it's part of error information returned to TDX guest.
So, I used the raw register name version.

Let's see if others also think tdvmcall_set_return_val() is more clear
for this case.

>
>> +		return 1;
>> +	}
>> +
>> +	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
>> +	if (tdx->map_gpa_next >= tdx->map_gpa_end) {
>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
>> +		return 1;
>> +	}
>> +
>> +	/*
>> +	 * Stop processing the remaining part if there is pending interrupt.
>> +	 * Skip checking pending virtual interrupt (reflected by
>> +	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall because
>> +	 * if guest disabled interrupt, it's OK not returning back to guest
>> +	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
>> +	 * immediately after STI or MOV/POP SS.
>> +	 */
>> +	if (pi_has_pending_interrupt(vcpu) ||
>> +	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>> +		kvm_r11_write(vcpu, tdx->map_gpa_next);
>> +		return 1;
>> +	}
>> +
>> +	__tdx_map_gpa(tdx);
>> +	/* Forward request to userspace. */
>> +	return 0;
>> +}
>> +
>> +static void __tdx_map_gpa(struct vcpu_tdx * tdx)
>> +{
>> +	u64 gpa = tdx->map_gpa_next;
>> +	u64 size = tdx->map_gpa_end - tdx->map_gpa_next;
>> +
>> +	if(size > TDX_MAP_GPA_MAX_LEN)
>> +		size = TDX_MAP_GPA_MAX_LEN;
>> +
>> +	tdx->vcpu.run->exit_reason       = KVM_EXIT_HYPERCALL;
>> +	tdx->vcpu.run->hypercall.nr      = KVM_HC_MAP_GPA_RANGE;
>> +	tdx->vcpu.run->hypercall.args[0] = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
>> +	tdx->vcpu.run->hypercall.args[1] = size / PAGE_SIZE;
>> +	tdx->vcpu.run->hypercall.args[2] = vt_is_tdx_private_gpa(tdx->vcpu.kvm, gpa) ?
>> +					   KVM_MAP_GPA_RANGE_ENCRYPTED :
>> +					   KVM_MAP_GPA_RANGE_DECRYPTED;
>> +	tdx->vcpu.run->hypercall.flags   = KVM_EXIT_HYPERCALL_LONG_MODE;
>> +
>> +	tdx->vcpu.arch.complete_userspace_io = tdx_complete_vmcall_map_gpa;
>> +}
>> +
>> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_tdx * tdx = to_tdx(vcpu);
>> +	u64 gpa = tdvmcall_a0_read(vcpu);
>> +	u64 size = tdvmcall_a1_read(vcpu);
>> +	u64 ret;
>> +
>> +	/*
>> +	 * Converting TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE requires
>> +	 * userspace to enable KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
>> +	 * bit set.  If not, the error code is not defined in GHCI for TDX, use
>> +	 * TDVMCALL_STATUS_INVALID_OPERAND for this case.
>> +	 */
>> +	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>> +		ret = TDVMCALL_STATUS_INVALID_OPERAND;
>> +		goto error;
>> +	}
>> +
>> +	if (gpa + size <= gpa || !kvm_vcpu_is_legal_gpa(vcpu, gpa) ||
>> +	    !kvm_vcpu_is_legal_gpa(vcpu, gpa + size -1) ||
>> +	    (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
>> +	     vt_is_tdx_private_gpa(vcpu->kvm, gpa + size -1))) {
>> +		ret = TDVMCALL_STATUS_INVALID_OPERAND;
>> +		goto error;
>> +	}
>> +
>> +	if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(size)) {
>> +		ret = TDVMCALL_STATUS_ALIGN_ERROR;
>> +		goto error;
>> +	}
>> +
>> +	tdx->map_gpa_end = gpa + size;
>> +	tdx->map_gpa_next = gpa;
>> +
>> +	__tdx_map_gpa(tdx);
>> +	/* Forward request to userspace. */
>> +	return 0;
>> +
>> +error:
>> +	tdvmcall_set_return_code(vcpu, ret);
>> +	kvm_r11_write(vcpu, gpa);
>> +	return 1;
>> +}
>> +
>> static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>> {
>> 	if (tdvmcall_exit_type(vcpu))
>> 		return tdx_emulate_vmcall(vcpu);
>>
>> 	switch (tdvmcall_leaf(vcpu)) {
>> +	case TDVMCALL_MAP_GPA:
>> +		return tdx_map_gpa(vcpu);
>> 	default:
>> 		break;
>> 	}
>> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>> index 1abc94b046a0..bfae70887695 100644
>> --- a/arch/x86/kvm/vmx/tdx.h
>> +++ b/arch/x86/kvm/vmx/tdx.h
>> @@ -71,6 +71,9 @@ struct vcpu_tdx {
>>
>> 	enum tdx_prepare_switch_state prep_switch_state;
>> 	u64 msr_host_kernel_gs_base;
>> +
>> +	u64 map_gpa_next;
>> +	u64 map_gpa_end;
>> };
>>
>> void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
>> -- 
>> 2.46.0
>>


