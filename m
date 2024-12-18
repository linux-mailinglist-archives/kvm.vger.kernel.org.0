Return-Path: <kvm+bounces-34026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80ADF9F5C48
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 02:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84A14165DE3
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0696C35972;
	Wed, 18 Dec 2024 01:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vgt0qNE1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8852FC0E;
	Wed, 18 Dec 2024 01:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734485637; cv=none; b=XkQ1G080iKJyvYxZTCHxuIYPeFZJ3uC8tznL/Dn8FmWcu/w6/hHh67d48444dSgvprGnjsHdGjf8HyvT4tnDnReOAH/61F2lJRbl/Ns724E/HQDd7exj7lxzigHdd82XOQXE5vhwLr5JikB4AtS9uwQZguuH4s1YRT1CT4/2lQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734485637; c=relaxed/simple;
	bh=141rpD/qoeuv5N69LII1Jtk7fgdeQ1Ku7fTGETtrtLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iOIe2sTMsbsHoJU3ZpCImRZKhcFyGKPhaaOe7KeUPDX3gmzxoLHvqYHOUTUKKAf70jTLM7kLjIHcD3W+kEy9PilsEfmZ4G8P9M8Q009Z82h14EY2Qwbw3gcRjBMz/7MN9/NNhvGXI00gdS/pxO1hzyZqxBjqzdMNToAbfsLIqIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vgt0qNE1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734485635; x=1766021635;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=141rpD/qoeuv5N69LII1Jtk7fgdeQ1Ku7fTGETtrtLE=;
  b=Vgt0qNE1SRIE1SkWQ7kQcNyT3x2PxA/M6E6dkcpS6Bzi6LLymHo4MZRj
   JizWWpAQqk2DKaW1qQfJB9GLIHFEczvN/+biCamN/CgYXhAkhBzPy5NK/
   syOL5BJMBCmDxOlLoenU6mP2j56FyGP39fglDuzM3JWqtVUXah4tqwANa
   72VQAIEOGny5Iw40kA5DfeAdufVBL96W0mwV4ZzwNIJznr/6pIvdrsZuW
   3SxXJ7Ubglnaul+x0am6PSoEUqR6rTMM3g1s9Ano7o5OHJWORj6rb86tR
   DaDXcy1/+cH2JDV1faHPm1z9IEriWVJW0SoKmEltAXScu3eVH4a7RZYYF
   A==;
X-CSE-ConnectionGUID: 8StGa63HTuWQRuSok7luGQ==
X-CSE-MsgGUID: OSIk03VfQhSX7Kx2x2aMNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="46354441"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="46354441"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 17:33:54 -0800
X-CSE-ConnectionGUID: bCatL3rVSqqWKTKMl9i41g==
X-CSE-MsgGUID: 9BKVwxVGTR2DtbYdFxN75A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,243,1728975600"; 
   d="scan'208";a="97767003"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 17:33:50 -0800
Message-ID: <7b097d2c-6490-4fc8-987c-7383d19b4b3c@linux.intel.com>
Date: Wed, 18 Dec 2024 09:33:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] KVM: TDX: Add a place holder to handle TDX VM exit
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-2-binbin.wu@linux.intel.com>
 <28930ac3-f4af-4d93-a766-11a5fedb321e@intel.com>
 <25a042e8-c39a-443c-a2e4-10f515b1f2af@linux.intel.com>
 <646990e1-cce6-4040-af40-6d80e0cd954a@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <646990e1-cce6-4040-af40-6d80e0cd954a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/16/2024 12:37 PM, Xiaoyao Li wrote:
> On 12/16/2024 8:54 AM, Binbin Wu wrote:
>>
>>
>>
>> On 12/13/2024 4:57 PM, Xiaoyao Li wrote:
>>> On 12/1/2024 11:53 AM, Binbin Wu wrote:
> ...
>>>
>>>>   }
>>>>     void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>>>> @@ -1135,6 +1215,88 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>>>>       return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
>>>>   }
>>>>   +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>>>> +{
>>>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>>>> +    u64 vp_enter_ret = tdx->vp_enter_ret;
>>>> +    union vmx_exit_reason exit_reason;
>>>> +
>>>> +    if (fastpath != EXIT_FASTPATH_NONE)
>>>> +        return 1;
>>>> +
>>>> +    /*
>>>> +     * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
>>>> +     * TDX_SEAMCALL_VMFAILINVALID.
>>>> +     */
>>>> +    if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
>>>> +        KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
>>>> +        goto unhandled_exit;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * Without off-TD debug enabled, failed_vmentry case must have
>>>> +     * TDX_NON_RECOVERABLE set.
>>>> +     */
>>>
>>> This comment is confusing. I'm not sure why it is put here. Below code does nothing with exit_reason.failed_vmentry.
>>
>> Because when failed_vmentry occurs, vp_enter_ret will have
>> TDX_NON_RECOVERABLE set, so it will be handled below.
>
> The words somehow is confusing, which to me is implying something like:
>
>     WARN_ON(!debug_td() && exit_reason.failed_vmentry &&
>                 !(vp_enter_ret & TDX_NON_RECOVERABLE))
The comment tried to say that the failed_vmentry case is also covered by
TDX_NON_RECOVERABLE since currently off-TD debug is not supported yet.
Since it's causing confusion, I'd like to add the code the handle the
failed_vmentry separately and aligned to VMX by using KVM_EXIT_FAIL_ENTRY
as suggested below.

>
> Besides, VMX returns KVM_EXIT_FAIL_ENTRY for vm-entry failure. So the question is why TDX cannot do it same way?
>
>>>
>>>> +    if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE))) {
>>>> +        /* Triple fault is non-recoverable. */
>>>> +        if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_TRIPLE_FAULT)))
>>>> +            return tdx_handle_triple_fault(vcpu);
>>>> +
>>>> +        kvm_pr_unimpl("TD vp_enter_ret 0x%llx, hkid 0x%x hkid pa 0x%llx\n",
>>>> +                  vp_enter_ret, to_kvm_tdx(vcpu->kvm)->hkid,
>>>> +                  set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
>>>
>>> It indeed needs clarification for the need of "hkid" and "hkid pa". Especially the "hkdi pa", which is the result of applying HKID of the current TD to a physical address 0. I cannot think of any reason why we need such info.
>> Yes, set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid) should be removed.
>> I didn't notice it.
>
> don't forget to justify why HKID is useful here. To me, HKID can be dropped as well.
OK.

>
>> Thanks!
>>
>>
>>>
>>>> +        goto unhandled_exit;
>>>> +    }
>>>> +
>>>> +    /* From now, the seamcall status should be TDX_SUCCESS. */
>>>> +    WARN_ON_ONCE((vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
>>>
>>> Is there any case that TDX_SUCCESS with additional non-zero information in the lower 32-bits? I thought TDX_SUCCESS is a whole 64- bit status code.
>> TDX status code uses the upper 32-bits.
>>
>> When the status code is TDX_SUCCESS and has a valid VMX exit reason, the lower
>> 32-bit is the VMX exit reason.
>>
>> You can refer to the TDX module ABI spec or interface_function_completion_status.json
>> from the intel-tdx-module-1.5-abi-table for details.
>>
>
> I see. (I asked a silly question that I even missed the normal Exit case)
>
>


