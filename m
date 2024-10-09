Return-Path: <kvm+bounces-28249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B05996F1D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6398B28768E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC231A0B12;
	Wed,  9 Oct 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPtoK/NM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713EC1A00D2;
	Wed,  9 Oct 2024 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486092; cv=none; b=XLFLEuXZhGdLGVyRD4PpdRs8hRptVCCCR8UakHTWYbtvVi/DlI8zuSNW8hbJXzpWcct4AucORzjP9QhDjmEjLvoLMSWdSxNve20NDC8VxDzt/tzhw8m0dNWuSAgaB34U3XfhQcxcObvZjzfgVFEEQ+jaMhyAz9Ebc8FiZMaOQ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486092; c=relaxed/simple;
	bh=fVRTwtcaoT0WmKjrFpk1DDIfYhMFQjs89fQ0qX3twgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lXQ4bPvO8LuJW7xIrdLlLHeHWelsqLf9pEs/3eGOJyVqrk6ICp7tQe+sMNqjDuAyEwpsLQNF2GQvFQod0T46bp6V7gXwt5z6fvSpFbDUBl46sA5OWantnIuiDWF6TyeZqWBZSCwbBE+xM7WJjP3Rn0BC6ael6w9mT4CH9DbL5Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPtoK/NM; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728486091; x=1760022091;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fVRTwtcaoT0WmKjrFpk1DDIfYhMFQjs89fQ0qX3twgY=;
  b=SPtoK/NMn//+oNsyOxMG2mxlq+qcm/F/CbaIOFNJun219dNq9Ln2ZVJl
   qzqka2KQpefRkFAwPmIRFO/cfPGQT8V5C8nKiOOQHHcjxf7k/RvJvNlFu
   DUY2dTr1O1eLqR6dDXWPAhWAWl9UsU8hTkOt8XIb9BQSI+NeQQXjucEie
   sKJBX4NSUGLJMU8slfFbfN4Fy3EVfKJ7SmCeiOnR1ZRYkgkzluv6HDxL3
   lxntuDsQ1MKiduGdEKkY0ogYGEfwN4WPD8ce0FvlSmTY64/CcBi7rHO7f
   xbIHAc7R63kOJ43wPwmqLJryfd+uBF2VSL2wIugq/8vgUAC0kXgUW+VUW
   g==;
X-CSE-ConnectionGUID: lAl/6/KGSxOhTYmB6kv0ZA==
X-CSE-MsgGUID: thc+uxylSjWR94dy78v2WQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="27740355"
X-IronPort-AV: E=Sophos;i="6.11,190,1725346800"; 
   d="scan'208";a="27740355"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 08:01:30 -0700
X-CSE-ConnectionGUID: vlgJ5M3jTiOZj4mbfcBUhw==
X-CSE-MsgGUID: 9mYwFaXSTPav/TcJ9Syvdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,190,1725346800"; 
   d="scan'208";a="81297872"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 08:01:26 -0700
Message-ID: <1a200cd3-ad73-4a53-bc48-661f7d022ac0@intel.com>
Date: Wed, 9 Oct 2024 18:01:19 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
To: Yuan Yao <yuan.yao@linux.intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/08/24 11:00, Yuan Yao wrote:
> On Mon, Aug 12, 2024 at 03:48:13PM -0700, Rick Edgecombe wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> TD guest vcpu needs TDX specific initialization before running.  Repurpose
>> KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
>> KVM_TDX_INIT_VCPU, and implement the callback for it.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> ---

<SNIP>

>> @@ -884,6 +930,149 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>>  	return r;
>>  }
>>
>> +/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
>> +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>> +{

<SNIP>

>> +	if (modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)
>> +		err = tdh_vp_init_apicid(tdx, vcpu_rcx, vcpu->vcpu_id);
>> +	else
>> +		err = tdh_vp_init(tdx, vcpu_rcx);
> 
> This can cause incorrect topology information to guest
> silently:
> 
> A user space VMM uses "-smp 8,threads=4,cores=2" but doesn't
> pass any 0x1f leaf data to KVM, means no 0x1f value to TDX
> module for this TD. The topology TD guest observed is:
> 
> Thread(s) per core:                 2
> Core(s) per socket:                 4
> 
> I suggest to use tdh_vp_init_apicid() only when 0x1f is
> valid. This will disable the 0x1f/0xb topology feature per
> the spec, but leaf 0x1/0x4 still are available to present
> right topology in this example. It presents correct topology
> information to guest if user space VMM doesn't use 0x1f for
> simple topology and run on TDX module w/ FEATURES0_TOPOLOGY.

tdh_vp_init_apicid() passes x2APIC ID to TDH.VP.INIT which
is one of the steps for the TDX Module to support topology
information for the guest i.e. CPUID leaf 0xB and CPUID leaf 0x1F.

If the host VMM does not provide CPUID leaf 0x1F values
(i.e. the values are 0), then the TDX Module will use native
values for both CPUID leaf 0x1F and CPUID leaf 0xB.

To get 0x1F/0xB the guest must also opt-in by setting
TDCS.TD_CTLS.ENUM_TOPOLOGY to 1.  AFAICT currently Linux
does not do that.

In the tdh_vp_init() case, topology information will not be
supported.

If topology information is not supported CPUID leaf 0xB and
CPUID leaf 0x1F will #VE, and a Linux guest will return zeros.

So, yes, it seems like tdh_vp_init_apicid() should only
be called if there is non-zero CPUID leaf 0x1F values provided
by host VMM. e.g. add a helper function

bool tdx_td_enum_topology(struct kvm_cpuid2 *cpuid)
{
	const struct tdx_sys_info_features *modinfo = &tdx_sysinfo->features;
	const struct kvm_cpuid_entry2 *entry;

	if (!(modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM))
		return false;

	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x1f, 0);
	if (!entry)
		return false;

	return entry->eax || entry->ebx || entry->ecx || entry->edx;
}



