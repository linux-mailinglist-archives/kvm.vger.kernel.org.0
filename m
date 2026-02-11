Return-Path: <kvm+bounces-70822-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oF0/HXrZi2kXcAAAu9opvQ
	(envelope-from <kvm+bounces-70822-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 02:20:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 148C8120711
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 02:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6921E305A94B
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B115283CAF;
	Wed, 11 Feb 2026 01:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hwMCsbgx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3231E19E819
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 01:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770772851; cv=none; b=FHdpZdXOEFUGMN5N9MIbJFJDR5FLOgojIDW4XokBPPDpvYtvxrIHMRYkWkPJagPsZ2yPwNtiT09r6xbMcsRlzLKW3kGPQDhs9cx51rF43924Jh7O8yE96JUhu+47hkgheTFpDF8+kPqkh2dsp7xCBDHl00LelDXnt8v6JdXKuIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770772851; c=relaxed/simple;
	bh=GTJC25ubz4XMOvaytpHcgA3JefEcbnyIuSceu7bzkh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VMuhGwS49TcrXgW4zpcBd9AiUaeLDR5fJk4JerYc1qwcg6DfLtS/Hct3NDZBc3STRa0LHJPIx7/DnNTvYKUI6tkrtXpY57ZYMnwaKXm8VEVHooaQnwZXSFoCazA946e/ZlqaSj/D9L5bCexylyucdLWTabvg/ck9F5RdiAr3+lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hwMCsbgx; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770772851; x=1802308851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GTJC25ubz4XMOvaytpHcgA3JefEcbnyIuSceu7bzkh0=;
  b=hwMCsbgx3+WFGsIdA2B4zjV2HssD2lnTzwZUZY/IvT8glUIAZr7NepiI
   hzQSfRDywnmnkDsT3bZlNoWrtKlQJyCg8RgkJ852Lo7W/jT60cOyaCagu
   fwyowdgWX5D660Ci8G5+HfTP+PCr/mUuyXJuHWmTkTh5CN/As6AIBUsd2
   ++DAalAU/8CMm0bax7dSkSZD+TIOMdk+s7Kd3WtEIsuEKdNktEuMCva+B
   ZUgqNOff3c0TXNx5Zky3AXot6wnNYwRYKfOeHgfyh5DGHnVVeIHbVKOkB
   cOLSSNwXwEZ8hlfTbhN3zFThHpe0nvoPJ3mOdr2GnG8bGl6VKAsguxae4
   A==;
X-CSE-ConnectionGUID: vWpaZnc+RoapqItJKOXr6w==
X-CSE-MsgGUID: yT+OmUpjT2KJg/tRn7qt1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71957646"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71957646"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 17:20:50 -0800
X-CSE-ConnectionGUID: x3ugIfgWSiqXZxL5GCPuIw==
X-CSE-MsgGUID: yTiJBFF5TpyEMDoF7T9GsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216596815"
Received: from qianm-mobl2.ccr.corp.intel.com (HELO [10.238.1.184]) ([10.238.1.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 17:20:47 -0800
Message-ID: <4e523f23-a84a-4a93-95fe-c1c00442e2c2@linux.intel.com>
Date: Wed, 11 Feb 2026 09:20:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 11/11] target/i386: Disable guest PEBS capability when
 not enabled
To: "Chen, Zide" <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-12-zide.chen@intel.com>
 <576b57e3-92df-4a35-ba7c-00bf12833313@linux.intel.com>
 <488a2ea7-062d-4561-89ec-f053af234cdd@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <488a2ea7-062d-4561-89ec-f053af234cdd@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70822-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 148C8120711
X-Rspamd-Action: no action


On 2/11/2026 3:05 AM, Chen, Zide wrote:
>
> On 2/9/2026 11:30 PM, Mi, Dapeng wrote:
>> On 1/29/2026 7:09 AM, Zide Chen wrote:
>>> When PMU is disabled, guest CPUID must not advertise Debug Store
>>> support.  Clear both CPUID.01H:EDX[21] (DS) and CPUID.01H:ECX[2]
>>> (DS64) in this case.
>>>
>>> Set IA32_MISC_ENABLE[12] (PEBS_UNAVAILABLE) when Debug Store is not
>>> exposed to the guest.
>>>
>>> Note: Do not infer that PEBS is unsupported from
>>> IA32_PERF_CAPABILITIES[11:8] (PEBS_FMT) being 0.  A value of 0 is a
>>> valid PEBS record format on some CPUs.
>>>
>>> Signed-off-by: Zide Chen <zide.chen@intel.com>
>>> ---
>>> V2:
>>> - New patch.
>>>
>>>  target/i386/cpu.c | 6 ++++++
>>>  target/i386/cpu.h | 1 +
>>>  2 files changed, 7 insertions(+)
>>>
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index ec6f49916de3..445361ab7a06 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -9180,6 +9180,10 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
>>>          env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
>>>      }
>>>  
>>> +    if (!(env->features[FEAT_1_EDX] & CPUID_DTS)) {
>>> +        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
>>> +    }
>>> +
>>>      memset(env->dr, 0, sizeof(env->dr));
>>>      env->dr[6] = DR6_FIXED_1;
>>>      env->dr[7] = DR7_FIXED_1;
>>> @@ -9474,6 +9478,8 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>>>              env->features[FEAT_1_ECX] &= ~CPUID_EXT_PDCM;
>>>          }
>>>  
>>> +        env->features[FEAT_1_ECX] &= ~CPUID_EXT_DTES64;
>>> +        env->features[FEAT_1_EDX] &= ~CPUID_DTS;
>> Strictly speaking, we need to check BTS as well before clearing DS. BTS
>> also depends on DS.
> But BTS is already unconditionally disabled from the guest in patch 1/11.

Yes, but from code logic, it's incomplete. We need to check both PEBS and
BTS are unavailable, and then disable DS.


>
>
>>>          env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_LBR;
>>>      }
>>>  
>>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>>> index 5ab107dfa29f..0fecf561173e 100644
>>> --- a/target/i386/cpu.h
>>> +++ b/target/i386/cpu.h
>>> @@ -483,6 +483,7 @@ typedef enum X86Seg {
>>>  /* Indicates good rep/movs microcode on some processors: */
>>>  #define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)
>>>  #define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
>>> +#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL  (1ULL << 12)
>>>  #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
>>>  #define MSR_IA32_MISC_ENABLE_DEFAULT    (MSR_IA32_MISC_ENABLE_FASTSTRING     |\
>>>                                           MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)

