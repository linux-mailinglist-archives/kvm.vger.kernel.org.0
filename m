Return-Path: <kvm+bounces-70887-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YJIqMwHBjGkmswAAu9opvQ
	(envelope-from <kvm+bounces-70887-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 18:48:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB8E126B65
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 18:48:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08986301BC14
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56AEE350D53;
	Wed, 11 Feb 2026 17:48:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C1121256C;
	Wed, 11 Feb 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770832106; cv=none; b=MSNOjCECu07UV2bXuY0ognFQv7OPy0chyJ4mBQZfNw+MYOh5jBka199GrpvEGEjDzG8788/dmidLKfd/gmLP36gsHNRFhKtk5gzIIRplDfHL+X7rEdkdBdqNo2bJR9BJnDm0rRArln2SMgsd03IOB/hCT2Jo1Y7YOotEhZrcTtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770832106; c=relaxed/simple;
	bh=HiDwOpryc1Zs2Xpfkiv6AuHEMuKv5wzn2Z6TFqFtAy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nzLb0Osv4wzZ6bVyy1DvNKKnlyUmdlHF5PtadCCJ/F1K9c/0++KR+AdgtmyKUF/IChToDxMg9vvBDUYLbznKTaMX1sPT+/Sqs0hTcCYcI7x5nzrnSm2ROmXxBy/qV8SW463s/Xkp8amuaK1Ns1UlHEby3Uh3SU6HRXlJ0aFdp7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4300E339;
	Wed, 11 Feb 2026 09:48:18 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 092143F63F;
	Wed, 11 Feb 2026 09:48:17 -0800 (PST)
Message-ID: <fd528a50-50c9-4376-9486-7b8eb3f026aa@arm.com>
Date: Wed, 11 Feb 2026 17:48:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/19] x86/resctrl: Add plza_capable in rdt_resource
 data structure
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <7b7507eac245988473e7b769a559bd193321e046.1769029977.git.babu.moger@amd.com>
 <a212711a-7af1-4daa-86e7-124ae15a9521@arm.com>
 <ed2d089b-0249-4f1a-8da2-5e61d5d1158f@intel.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <ed2d089b-0249-4f1a-8da2-5e61d5d1158f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ben.horgan@arm.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70887-lists,kvm=lfdr.de];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,arm.com:mid]
X-Rspamd-Queue-Id: 3EB8E126B65
X-Rspamd-Action: no action

Hi Babu, Reinette,

On 2/11/26 16:54, Reinette Chatre wrote:
> Hi Ben,
> 
> On 2/11/26 7:19 AM, Ben Horgan wrote:
>> Hi Babu,
>>
>> On 1/21/26 21:12, Babu Moger wrote:
>>> Add plza_capable field to the rdt_resource structure to indicate whether
>>> Privilege Level Zero Association (PLZA) is supported for that resource
>>> type.
>>>
>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>> ---
>>>  arch/x86/kernel/cpu/resctrl/core.c     | 6 ++++++
>>>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 5 +++++
>>>  include/linux/resctrl.h                | 3 +++
>>>  3 files changed, 14 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index 2de3140dd6d1..e41fe5fa3f30 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -295,6 +295,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>>>  
>>>  	r->alloc_capable = true;
>>>  
>>> +	if (rdt_cpu_has(X86_FEATURE_PLZA))
>>> +		r->plza_capable = true;
>>> +
>>>  	return true;
>>>  }
>>>  
>>> @@ -314,6 +317,9 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
>>>  	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
>>>  		r->cache.arch_has_sparse_bitmasks = ecx.split.noncont;
>>>  	r->alloc_capable = true;
>>> +
>>> +	if (rdt_cpu_has(X86_FEATURE_PLZA))
>>> +		r->plza_capable = true;
>>>  }
>>>  
>>>  static void rdt_get_cdp_config(int level)
>>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> index 885026468440..540e1e719d7f 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> @@ -229,6 +229,11 @@ bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
>>>  	return rdt_resources_all[l].cdp_enabled;
>>>  }
>>>  
>>> +bool resctrl_arch_get_plza_capable(enum resctrl_res_level l)
>>> +{
>>> +	return rdt_resources_all[l].r_resctrl.plza_capable;
>>> +}
>>> +
>>>  void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
>>>  {
>>>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>>> index 63d74c0dbb8f..ae252a0e6d92 100644
>>> --- a/include/linux/resctrl.h
>>> +++ b/include/linux/resctrl.h
>>> @@ -319,6 +319,7 @@ struct resctrl_mon {
>>>   * @name:		Name to use in "schemata" file.
>>>   * @schema_fmt:		Which format string and parser is used for this schema.
>>>   * @cdp_capable:	Is the CDP feature available on this resource
>>> + * @plza_capable:	Is Privilege Level Zero Association capable?
>>>   */
>>>  struct rdt_resource {
>>>  	int			rid;
>>> @@ -334,6 +335,7 @@ struct rdt_resource {
>>>  	char			*name;
>>>  	enum resctrl_schema_fmt	schema_fmt;
>>>  	bool			cdp_capable;
>>> +	bool			plza_capable;
>>
>> Why are you making plza a resource property? Certainly for MPAM we'd
>> want this to be global across resources and I see above that you are
>> just checking a cpu property rather then anything per resource.
> 
> I agree. For reference: https://lore.kernel.org/lkml/6fe647ce-2e65-45dd-9c79-d1c2cb0991fe@intel.com/

Ah, didn't mean to duplicate. Glad we agree.

> > One possible concern for MPAM related to this caught my eye. From
> https://lore.kernel.org/lkml/20260203214342.584712-10-ben.horgan@arm.com/ :
> 
> 	If an SMCU is not shared with other cpus then it is implementation
> 	defined whether the configuration from MPAMSM_EL1 is used or that from
> 	the appropriate MPAMy_ELx. As we set the same, PMG_D and PARTID_D,
> 	configuration for MPAM0_EL1, MPAM1_EL1 and MPAMSM_EL1 the resulting
> 	configuration is the same regardless.
> 
> I admit that I am not yet comfortable with the MPAM register usages ... but from
> above it sounds to me as though if resctrl associates different CLOSID/PARTID and
> RMID/PMG with a task to be used at different privilege levels as planned with this
> work then the mapping to MPAM0_EL1 and MPAM1_EL1 may be easy but MPAMSM_EL1 may be
> difficult?

Thanks for bringing this up. The kernel has limited usage of the SMCU.
The SMCU performs matrix and simd instructions for the cpu. In the
kernel these are just used for save/restore of the simd/matrix register
state at context switch and possibly in the future usage could be
extended in a similar way to old style simd, neon, and be guarded by
something like neon_begin(), neon_end(). If we wish to use kernel
specific pmg/partids for those load/stores we can copy the MPAM1_EL1
configuration into MPAMSM_EL1. (Then it doesn't matter if the
configuration from MPAMSM_EL1 or MPAM1_EL1 is used.) This is analogous
to how we copy MPAM1_EL1 to MPAM2_EL2 to provide a configuration for the
kvm nvhe hypervisor.
See:
https://lore.kernel.org/kvmarm/9a8a163e-887a-45fc-aae5-45e564360c8b@arm.com/T/#m23281370dbcdaca98482769de1eae496afadc3b0

> 
> 
> Reinette
> 
> 

Thanks,

Ben


