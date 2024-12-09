Return-Path: <kvm+bounces-33278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2199E896D
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 04:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36B23163EB6
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 03:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7155FEED;
	Mon,  9 Dec 2024 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SIuHLZl6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC014A02;
	Mon,  9 Dec 2024 03:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733713728; cv=none; b=C7J36poZ+bpwdIKjAczdNIAmMbNv5Vr4BIxFXVRDrMafpzk5gxyksE5HthlKM3dHEDZFzCJTdszbSHZ08FESqy21jlEnAh/PIF1YKEIvB2l7mNuhSpU6YTzR6RHwOl0fAilBRLMc2yHrit41UnduQCp3i4AGVgzMIdK/1VYB8Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733713728; c=relaxed/simple;
	bh=uQK9V0rMGTgeh0DBk7wkMKb3QxKcI2GfeBJ+ftibZWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X8pm/nTylT0MKAKISEDaZwBn0hIt2UYUFrshdONvZ9wmqE4Xdt2u/Zt3WyJbhcDCKlat5ZUyI4lpjgKmAFU4j4si7KDQIFp5KBtT11dotzl+4/iRI0jSLgqxsx5L7Q/WamCL9cXJto59vkhcOA7sBhqIJHKRPMefa7UnxUFCl04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SIuHLZl6; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733713726; x=1765249726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uQK9V0rMGTgeh0DBk7wkMKb3QxKcI2GfeBJ+ftibZWk=;
  b=SIuHLZl6fjtqik/neQGCmzacr37uLD7Kry6+s96B53GGmdQOE/ydsOE3
   9L3hHAqXAXzGoVKSdH7cgFfBhM5MQxX6zbuOMJEpyBimKyNSuDglq7l48
   IQLkX/aHm1mVe6dgxub7R0hN2CDsK8KL9MuYklZ16VecM958lFCBTsnIH
   VLmrmlK0c43UrwQANCGi2UC+fjiyPlQM7mHzlF9Vjj3Mm9Pxr+k/ek3P2
   YNLbuAlbPKLvzU9e+JhYP3ZcBR4RY2/K4sTe4tW6LnODCPYQ5bw1A6k6/
   1h9JwAqt0uzxovhkDu3B5aKtVo1gZGI4Ddh4dUSivTIQ41ezYtEYLovC5
   g==;
X-CSE-ConnectionGUID: 1CILAclCTWydVd8vv/K0hA==
X-CSE-MsgGUID: 6pPvIu2rS3WGE7HQ+F91Vw==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="37676968"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="37676968"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 19:08:45 -0800
X-CSE-ConnectionGUID: nlnamHtmQHeVsAFp7qFAYg==
X-CSE-MsgGUID: FKKfB5UFSsy39T3MsinCvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="99888378"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 19:08:41 -0800
Message-ID: <814d3dff-c168-4c68-ba25-30b282a37420@linux.intel.com>
Date: Mon, 9 Dec 2024 11:08:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-4-binbin.wu@linux.intel.com>
 <Z1ZcvCmAPvBOr4Vt@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z1ZcvCmAPvBOr4Vt@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/9/2024 10:58 AM, Chao Gao wrote:
> On Sun, Dec 01, 2024 at 11:53:52AM +0800, Binbin Wu wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Handle KVM hypercall for TDX according to TDX Guest-Host Communication
>> Interface (GHCI) specification.
>>
>> The TDX GHCI specification defines the ABI for the guest TD to issue
>> hypercalls.   When R10 is non-zero, it indicates the TDG.VP.VMCALL is
>> vendor-specific.  KVM uses R10 as KVM hypercall number and R11-R14
>> as 4 arguments, while the error code is returned in R10.  Follow the
>> ABI and handle the KVM hypercall for TDX.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> Hypercalls exit to userspace breakout:
>> - Renamed from "KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL" to
>>   "KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL".
>> - Update the change log.
>> - Rebased on Sean's "Prep KVM hypercall handling for TDX" patch set.
>>   https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
>> - Use the right register (i.e. R10) to set the return code after returning
>>   back from userspace.
>> ---
>> arch/x86/kvm/vmx/tdx.c | 31 +++++++++++++++++++++++++++++++
>> 1 file changed, 31 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 19fd8a5dabd0..4cc55b120ab0 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -957,8 +957,39 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
>> 	return 0;
>> }
>>
>> +
>> +static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>> +{
>> +	kvm_r10_write(vcpu, vcpu->run->hypercall.ret);
> Use tdvmcall_set_return_code() here? it would be more self-explanatory.
Yes, it's better.
Thanks!

>
>> +	return 1;
>> +}
>> +
>> +static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>> +{
>> +	int r;
>> +
>> +	/*
>> +	 * ABI for KVM tdvmcall argument:
>> +	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
>> +	 * Non-zero leaf number (R10 != 0) is defined to indicate
>> +	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
>> +	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
>> +	 * number.
>> +	 *
>> +	 * R10: KVM hypercall number
>> +	 * arguments: R11, R12, R13, R14.
>> +	 */
>> +	r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0,
> note r10-14 are not declared in this function.
__kvm_emulate_hypercall() is a macro, so these will be replaced by
kvm_{r10, r11, r12, r13, r14}_read().


>
>> +				    complete_hypercall_exit);
>> +
>> +	return r > 0;
>> +}
>> +
>> static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>> {
>> +	if (tdvmcall_exit_type(vcpu))
>> +		return tdx_emulate_vmcall(vcpu);
>> +
>> 	switch (tdvmcall_leaf(vcpu)) {
>> 	default:
>> 		break;
>> -- 
>> 2.46.0
>>


