Return-Path: <kvm+bounces-33831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 638549F27B4
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 02:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A10CE188552A
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 01:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A052F9DA;
	Mon, 16 Dec 2024 01:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PwIp8/TV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEAF3232;
	Mon, 16 Dec 2024 01:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734311317; cv=none; b=MfV8WdFt8awP4HN31G3J12es/X/mdQ+nz8pNqce/F0I4P7esulFsE2IRrB5di/TmBNFEwgBKGpqzbNA/dFr5Fv0PMW34MxxX7xwFNAJtFtMPaEFrErFvEonflybwbvg6MzpgjKtU288we/8P/1GDNTWsxCPscUfrwRd9+8UYtAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734311317; c=relaxed/simple;
	bh=fA1zxkZy55Xbl5aDRt3PnVnaE7uEwwg7jkSWYAyiOOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1aZMnxgXCwKpi8lO4oelsmUNMl9IqwmKTdruYiVhA4Yvez4n0ov2VC/kDqo/aRKvebX46WWQF+qxEkurByi8499HOZLRq9sR5iNdDHJFZv2qiMZeslah43XwfjIsGuSqspvD+WAbnWA2s8bQxVrIi9gz6bMoPVmxFLS6YHVCSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PwIp8/TV; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734311317; x=1765847317;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fA1zxkZy55Xbl5aDRt3PnVnaE7uEwwg7jkSWYAyiOOc=;
  b=PwIp8/TVhcq4xzbaGLwEV398YCuEzP7ezXi1A3Iov4x1lmChYeCB+xOs
   mPELvyiDUBZdXDcxU63DQKaIcDWup3IXSyO0KHVt703E+FOoG3P1+zM9E
   SsTrqKL7ViPEK3H2lQGp+1eAsfKci9JN7CS4Vp3ivbog3r6Ro5MKi8aWf
   om4YxE69zzUSp/QBYt5sgXi57IYtPbO19N1LY0PHLB64qd9nPDf6OHrG2
   0n6qISiUVeR/955It4oHaFmS0d5w+Cun4OviZuorrYCbROTzZaUpbFp7l
   Qa3jHvL+Z7CUQjf84aPFKJ6KwXdLqJfBGBe0usrKcAGNGLw3P0OkuaIHv
   w==;
X-CSE-ConnectionGUID: gnS8trVlQnWn+oAI8MeGNg==
X-CSE-MsgGUID: 9hblDb/5Txa3VBeGRQZZuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11287"; a="34599495"
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="34599495"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 17:08:36 -0800
X-CSE-ConnectionGUID: EoD++NoBTUOY9MX5XJvTlg==
X-CSE-MsgGUID: PrCzXibAQdKvcNv1LyBh2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="96925577"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 17:08:32 -0800
Message-ID: <692aacc1-809f-449d-8f67-8e8e7ede8c8d@linux.intel.com>
Date: Mon, 16 Dec 2024 09:08:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
 <d3adecc6-b2b9-42ba-8c0f-bd66407e61f0@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d3adecc6-b2b9-42ba-8c0f-bd66407e61f0@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/13/2024 5:32 PM, Xiaoyao Li wrote:
> On 12/1/2024 11:53 AM, Binbin Wu wrote:
>
[...]
>> +
>> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>> +{
>> +    struct vcpu_tdx * tdx = to_tdx(vcpu);
>> +    u64 gpa = tdvmcall_a0_read(vcpu);
>
> We can use kvm_r12_read() directly, which is more intuitive. And we can drop the MACRO for a0/a1/a2/a3 accessors in patch 022.
I am neutral about it.


>
>> +    u64 size = tdvmcall_a1_read(vcpu);
>> +    u64 ret;
>> +
>> +    /*
>> +     * Converting TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE requires
>> +     * userspace to enable KVM_CAP_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
>> +     * bit set.  If not, the error code is not defined in GHCI for TDX, use
>> +     * TDVMCALL_STATUS_INVALID_OPERAND for this case.
>> +     */
>> +    if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>> +        ret = TDVMCALL_STATUS_INVALID_OPERAND;
>> +        goto error;
>> +    }
>> +
>> +    if (gpa + size <= gpa || !kvm_vcpu_is_legal_gpa(vcpu, gpa) ||
>> +        !kvm_vcpu_is_legal_gpa(vcpu, gpa + size -1) ||
>> +        (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
>> +         vt_is_tdx_private_gpa(vcpu->kvm, gpa + size -1))) {
>> +        ret = TDVMCALL_STATUS_INVALID_OPERAND;
>> +        goto error;
>> +    }
>> +
>> +    if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(size)) {
>> +        ret = TDVMCALL_STATUS_ALIGN_ERROR;
>> +        goto error;
>> +    }
>> +
>> +    tdx->map_gpa_end = gpa + size;
>> +    tdx->map_gpa_next = gpa;
>> +
>> +    __tdx_map_gpa(tdx);
>> +    /* Forward request to userspace. */
>> +    return 0;
>
> Maybe let __tdx_map_gpa() return a int to decide whether it needs to return to userspace and
>
>     return __tdx_map_gpa(tdx);
>
> ?

To save one line of code and the comment?
Because MapGPA always goes to userspace, I don't want to make a function return
a int that is a fixed value.
And if the multiple comments bother you, I think the comments can be removed.

>
>
>> +
>> +error:
>> +    tdvmcall_set_return_code(vcpu, ret);
>> +    kvm_r11_write(vcpu, gpa);
>> +    return 1;
>> +}
>> +
>>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>>   {
>>       if (tdvmcall_exit_type(vcpu))
>>           return tdx_emulate_vmcall(vcpu);
>>         switch (tdvmcall_leaf(vcpu)) {
>> +    case TDVMCALL_MAP_GPA:
>> +        return tdx_map_gpa(vcpu);
>>       default:
>>           break;
>>       }
>> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>> index 1abc94b046a0..bfae70887695 100644
>> --- a/arch/x86/kvm/vmx/tdx.h
>> +++ b/arch/x86/kvm/vmx/tdx.h
>> @@ -71,6 +71,9 @@ struct vcpu_tdx {
>>         enum tdx_prepare_switch_state prep_switch_state;
>>       u64 msr_host_kernel_gs_base;
>> +
>> +    u64 map_gpa_next;
>> +    u64 map_gpa_end;
>>   };
>>     void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
>


