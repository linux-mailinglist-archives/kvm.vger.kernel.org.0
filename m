Return-Path: <kvm+bounces-26240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF35973682
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C5332876D3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058A418FC72;
	Tue, 10 Sep 2024 11:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZfaKzm8m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D9718C003;
	Tue, 10 Sep 2024 11:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725969306; cv=none; b=qwwdeK4pQ4fq64l2Ryr9h686w3clpXs9RoC6F+a1XEPMGxKIr1Nha5DPV1N0YqRZfRiafKn1hqo8M/gy0m/ZTBG3aPbu0YEw/YOIgHFckhKZrTvBTqOqAz5VNmrAgxDLOOU4+/a8buyldWwgquCFY/IYAJKyyTrseYowQzQ3Vx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725969306; c=relaxed/simple;
	bh=eah5Sen1l0Aw0ayjvsVeKGFBQX7863WPYIJIOytk2U4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BzDHkRul1KHLVDERhRRI5J66b8hywh1txTJHJTHKQiX5lIwTTjv9Aegk37QgHb5txmqnC8LbmI6VT1Kk9/RwkEjE+tdu0L+h+7CIOCMJBdo64uykcOwhnxm1g+pYhE44/WVTkAquVgXuArGhMothpjFWMOoqosSOcqU3PlALwEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZfaKzm8m; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725969304; x=1757505304;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eah5Sen1l0Aw0ayjvsVeKGFBQX7863WPYIJIOytk2U4=;
  b=ZfaKzm8mWeWxMKl2Xvp2C/LjSoiX82RG5NEJzuuz1y/bokZIkX2Uh4JI
   ECZmlsmlXv0C0PiQRcGxRwEcPR4EKXbfjbJvdX+LNDUUwM8P47ry55Vci
   I4B3jTEIECHjbP3PjRJMDTD+ChSWJ5JheKHmmtgavyb3Qo5IP2aD7Gt49
   8jd8wVSn3WqClTFbxxyuNSlfoxlN+r7jopE0j2jJoaF5MoMxVO9ckjywi
   aUZU9+WmK8AEe4/zbJ3byd8uJSw7FF/I+Duc3QMUdJgLhOGUg1gi1Pvsg
   AqXHh4NGSuUvSnSSRHmd9Haoj5RD4+ZSKl583QMAISVWHOOTfBHyl+Qf4
   Q==;
X-CSE-ConnectionGUID: umelgkIqTLGV2UKQfXJ8PQ==
X-CSE-MsgGUID: 3/1ZZbgOTBqYU+3yjkHwEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24525206"
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="24525206"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 04:55:04 -0700
X-CSE-ConnectionGUID: a5ta+mteSUGBdy9s1uL/9w==
X-CSE-MsgGUID: +Me8vOSjRhqQMxh0Ue2FBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="71990261"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 04:55:00 -0700
Message-ID: <88eb6d03-2fb4-49cf-944a-6ec64bf83ac8@intel.com>
Date: Tue, 10 Sep 2024 14:54:54 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
To: Paolo Bonzini <pbonzini@redhat.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
 <acf52e41-e78c-479d-9736-419a86002982@redhat.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <acf52e41-e78c-479d-9736-419a86002982@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/09/24 13:25, Paolo Bonzini wrote:
> On 9/4/24 05:07, Rick Edgecombe wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Add a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
>> KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.
>>
>> Documentation for the API is added in another patch:
>> "Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)"
>>
>> For the purpose of attestation, a measurement must be made of the TDX VM
>> initial state. This is referred to as TD Measurement Finalization, and
>> uses SEAMCALL TDH.MR.FINALIZE, after which:
>> 1. The VMM adding TD private pages with arbitrary content is no longer
>>     allowed
>> 2. The TDX VM is runnable
>>
>> Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> ---
>> TDX MMU part 2 v1:
>>   - Added premapped check.
>>   - Update for the wrapper functions for SEAMCALLs. (Sean)
>>   - Add check if nr_premapped is zero.  If not, return error.
>>   - Use KVM_BUG_ON() in tdx_td_finalizer() for consistency.
>>   - Change tdx_td_finalizemr() to take struct kvm_tdx_cmd *cmd and return error
>>     (Adrian)
>>   - Handle TDX_OPERAND_BUSY case (Adrian)
>>   - Updates from seamcall overhaul (Kai)
>>   - Rename error->hw_error
>>
>> v18:
>>   - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
>>
>> v15:
>>   - removed unconditional tdx_track() by tdx_flush_tlb_current() that
>>     does tdx_track().
>> ---
>>   arch/x86/include/uapi/asm/kvm.h |  1 +
>>   arch/x86/kvm/vmx/tdx.c          | 28 ++++++++++++++++++++++++++++
>>   2 files changed, 29 insertions(+)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 789d1d821b4f..0b4827e39458 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -932,6 +932,7 @@ enum kvm_tdx_cmd_id {
>>       KVM_TDX_INIT_VM,
>>       KVM_TDX_INIT_VCPU,
>>       KVM_TDX_INIT_MEM_REGION,
>> +    KVM_TDX_FINALIZE_VM,
>>       KVM_TDX_GET_CPUID,
>>         KVM_TDX_CMD_NR_MAX,
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 796d1a495a66..3083a66bb895 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1257,6 +1257,31 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
>>       ept_sync_global();
>>   }
>>   +static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>> +{
>> +    struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>> +
>> +    if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
>> +        return -EINVAL;
>> +    /*
>> +     * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
>> +     * TDH.MEM.PAGE.ADD().
>> +     */
>> +    if (atomic64_read(&kvm_tdx->nr_premapped))
>> +        return -EINVAL;
> 
> I suggest moving all of patch 16, plus the
> 
> +    WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
> +    atomic64_dec(&kvm_tdx->nr_premapped);
> 
> lines of patch 19, into this patch.
> 
>> +    cmd->hw_error = tdh_mr_finalize(kvm_tdx);
>> +    if ((cmd->hw_error & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY)
>> +        return -EAGAIN;
>> +    if (KVM_BUG_ON(cmd->hw_error, kvm)) {
>> +        pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
>> +        return -EIO;
>> +    }
>> +
>> +    kvm_tdx->finalized = true;
>> +    return 0;
> 
> This should also set pre_fault_allowed to true.

Ideally, need to ensure it is not possible for another CPU
to see kvm_tdx->finalized==false and pre_fault_allowed==true

Perhaps also, to document the dependency, return an error if
pre_fault_allowed is true in tdx_mem_page_record_premap_cnt().


