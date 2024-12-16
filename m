Return-Path: <kvm+bounces-33832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BB09F27B7
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 02:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EACF81655E2
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 01:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FEF2F9D6;
	Mon, 16 Dec 2024 01:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CqROzveY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B794E182;
	Mon, 16 Dec 2024 01:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734311660; cv=none; b=XkCAfmOHUsZr97BKmSg7lt224AHjpRhpZpveJhSsYEUlNqvcx6IT24bWDykGYMGiSGKNIJdLP3PVgZHk3ZvpV2cMD8DqcApqIIMIoRTo2MWEJJspH9Ysb6qPFXFizXbRZlDqdPyy+Rg7yKppzW1P2SpOOhkV1MlOvFa4IT2Xu3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734311660; c=relaxed/simple;
	bh=Wsyztbl9KcpVre6EEeU2EPXB8B4ODVbnbg7vuAqPwf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dXBod8bVtq//0Qx//orZghs+jxsKQVbPtj10TdTkk4HO7I5UyuZ1X/RFECSfF0Jx7V6SlnCB/+1KJ4WyDA2hRwzt3RfOh7QuLAcJl8KPYXglYOO4zpC7tYvfifqyfctsN2XHZ68K0J5xX7oPgQUB/VvxlIHzBhuh19ECzUr1dw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CqROzveY; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734311659; x=1765847659;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wsyztbl9KcpVre6EEeU2EPXB8B4ODVbnbg7vuAqPwf0=;
  b=CqROzveY/R9ahOnmj9knfMTeZIsOU9Y2GFNFJfvouXjpREc3lJKwVJCn
   2Nx3V9o/v63ihvpNEXpVtrj0SxAwZcWGVqKe0lWQvB0CFAmYmTduKO774
   gRz0HVeQ7nzfzIJPRKts90+T2n8m4Wpw5mCaV8cJjexYsJgnhtXx67WXV
   iuyaGK0mhk7RaGyGCL3qaCOuBsffBvj0zUlt6K46YImA3K3ztoT3p6weD
   QDDkM2ApMd36ABvEaF3+zONeP3hxjNveF7g+vb0bQ4qVbfxWcxgNZlXwD
   RasWZIYCwUTjmwsUBtfe5wG5lBE1KPmcGEdKX5LrQunI1t9FPr5L3ziIi
   A==;
X-CSE-ConnectionGUID: HctYq7DBR3GsMi1vt0YYFQ==
X-CSE-MsgGUID: 20PMjCc8QOSIUNPWYN65Pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11287"; a="22270610"
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="22270610"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 17:14:17 -0800
X-CSE-ConnectionGUID: /TW0921wQhqXpaMWjUT1dQ==
X-CSE-MsgGUID: ldYB+vS2RYa5Q/UOsBmSrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101623199"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 17:14:14 -0800
Message-ID: <82a916da-0053-46c6-abfe-faf170cb5a8c@linux.intel.com>
Date: Mon, 16 Dec 2024 09:14:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-6-binbin.wu@linux.intel.com>
 <dfe4c078-e7f9-44ee-8320-a189ea2ce51b@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <dfe4c078-e7f9-44ee-8320-a189ea2ce51b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/13/2024 5:40 PM, Xiaoyao Li wrote:
> On 12/1/2024 11:53 AM, Binbin Wu wrote:
>> Convert TDG.VP.VMCALL<ReportFatalError> to KVM_EXIT_SYSTEM_EVENT with
>> a new type KVM_SYSTEM_EVENT_TDX_FATAL and forward it to userspace for
>> handling.
>>
>> TD guest can use TDG.VP.VMCALL<ReportFatalError> to report the fatal
>> error it has experienced.  This hypercall is special because TD guest
>> is requesting a termination with the error information, KVM needs to
>> forward the hypercall to userspace anyway, KVM doesn't do sanity checks
>> and let userspace decide what to do.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> Hypercalls exit to userspace breakout:
>> - New added.
>>    Implement one of the hypercalls need to exit to userspace for handling after
>>    reverting "KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL", which tries to resolve
>>    Sean's comment.
>>    https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
>> - Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
>> ---
>>   Documentation/virt/kvm/api.rst |  8 ++++++
>>   arch/x86/kvm/vmx/tdx.c         | 50 ++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h       |  1 +
>>   3 files changed, 59 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index edc070c6e19b..bb39da72c647 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6815,6 +6815,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
>>     #define KVM_SYSTEM_EVENT_WAKEUP         4
>>     #define KVM_SYSTEM_EVENT_SUSPEND        5
>>     #define KVM_SYSTEM_EVENT_SEV_TERM       6
>> +  #define KVM_SYSTEM_EVENT_TDX_FATAL      7
>>               __u32 type;
>>                           __u32 ndata;
>>                           __u64 data[16];
>> @@ -6841,6 +6842,13 @@ Valid values for 'type' are:
>>      reset/shutdown of the VM.
>>    - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
>>      The guest physical address of the guest's GHCB is stored in `data[0]`.
>> + - KVM_SYSTEM_EVENT_TDX_FATAL -- an TDX guest requested termination.
>> +   The error codes of the guest's GHCI is stored in `data[0]`.
>> +   If the bit 63 of `data[0]` is set, it indicates there is TD specified
>> +   additional information provided in a page, which is shared memory. The
>> +   guest physical address of the information page is stored in `data[1]`.
>> +   An optional error message is provided by `data[2]` ~ `data[9]`, which is
>> +   byte sequence, LSB filled first. Typically, ASCII code(0x20-0x7e) is filled.
>>    - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
>>      KVM has recognized a wakeup event. Userspace may honor this event by
>>      marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 553f4cbe0693..a79f9ca962d1 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1093,6 +1093,54 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>>       return 1;
>>   }
>>   +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
>> +{
>> +    u64 reg_mask = kvm_rcx_read(vcpu);
>> +    u64* opt_regs;
>> +
>> +    /*
>> +     * Skip sanity checks and let userspace decide what to do if sanity
>> +     * checks fail.
>> +     */
>> +    vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>> +    vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
>> +    vcpu->run->system_event.ndata = 10;
>> +    /* Error codes. */
>> +    vcpu->run->system_event.data[0] = tdvmcall_a0_read(vcpu);
>> +    /* GPA of additional information page. */
>> +    vcpu->run->system_event.data[1] = tdvmcall_a1_read(vcpu);
>> +    /* Information passed via registers (up to 64 bytes). */
>> +    opt_regs = &vcpu->run->system_event.data[2];
>> +
>> +#define COPY_REG(REG, MASK)                        \
>> +    do {                                \
>> +        if (reg_mask & MASK)                    \
>> +            *opt_regs = kvm_ ## REG ## _read(vcpu);        \
>> +        else                            \
>> +            *opt_regs = 0;                    \
>> +        opt_regs++;                        \
>
> I'm not sure if we need to skip the "opt_regs++" the corresponding register is not set valid in reg_mask. And maintain ndata to actual valid number instead of hardcoding it to 10.
Yes, it's better.

>
>> +    } while (0)
>> +
>> +    /* The order is defined in GHCI. */
>> +    COPY_REG(r14, BIT_ULL(14));
>> +    COPY_REG(r15, BIT_ULL(15));
>> +    COPY_REG(rbx, BIT_ULL(3));
>> +    COPY_REG(rdi, BIT_ULL(7));
>> +    COPY_REG(rsi, BIT_ULL(6));
>> +    COPY_REG(r8, BIT_ULL(8));
>> +    COPY_REG(r9, BIT_ULL(9));
>> +    COPY_REG(rdx, BIT_ULL(2));
>> +
>> +    /*
>> +     * Set the status code according to GHCI spec, although the vCPU may
>> +     * not return back to guest.
>> +     */
>> +    tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
>> +
>> +    /* Forward request to userspace. */
>> +    return 0;
>> +}
>> +
>>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>>   {
>>       if (tdvmcall_exit_type(vcpu))
>> @@ -1101,6 +1149,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>>       switch (tdvmcall_leaf(vcpu)) {
>>       case TDVMCALL_MAP_GPA:
>>           return tdx_map_gpa(vcpu);
>> +    case TDVMCALL_REPORT_FATAL_ERROR:
>> +        return tdx_report_fatal_error(vcpu);
>>       default:
>>           break;
>>       }
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 637efc055145..c173c8dfcf83 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -375,6 +375,7 @@ struct kvm_run {
>>   #define KVM_SYSTEM_EVENT_WAKEUP         4
>>   #define KVM_SYSTEM_EVENT_SUSPEND        5
>>   #define KVM_SYSTEM_EVENT_SEV_TERM       6
>> +#define KVM_SYSTEM_EVENT_TDX_FATAL      7
>>               __u32 type;
>>               __u32 ndata;
>>               union {
>
>


