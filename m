Return-Path: <kvm+bounces-57897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F69BB7FA30
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0714D1C06E5E
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D953397DE;
	Wed, 17 Sep 2025 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PaKh6p2E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2094132BC16;
	Wed, 17 Sep 2025 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116911; cv=none; b=B32WwM+SMDx/4aYbKhHfwgkoJvN8iZhgyhvcp10GcXqmpr6IFc/z248C4Sfec6bfSgCcFaq+cF8939OhXkkTDwCAzJuzGhaaWq6R9MDerymU4lOGBgJSPhLuZFYL22HyMgE4EgtU+iiQ8cXJPVbeFHBV+aOk3j6sddyb9oxaJio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116911; c=relaxed/simple;
	bh=SEe5+uZs6+q18rVODuGjO9ywt5qG9ngtyXTRJAArBo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pqORC7a0LwfLD2bOH3c99+ypeY8+gsfWz1fhym7dC5wIApm3NfYDsL4J0OvC8c64Uj2YjZoyvEYz1rzvK3T30Z01jw21H4n+4Hu5IorOKg2eJH7N0rRAoi4/BhTc3kYge2J5GXRMxlNXXDlxvFadN829QwCImSMC+jTLo6UPj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PaKh6p2E; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758116909; x=1789652909;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SEe5+uZs6+q18rVODuGjO9ywt5qG9ngtyXTRJAArBo0=;
  b=PaKh6p2EagQQNuDFHLSwOajGZ8qREpncWuPYFzbu0YGJ92RhCP5R/guL
   N0W1B35CE8G+qOHg8zyEF5BqpsatJdQhXMbHxdmhY+vpEV7+8snh9hmH0
   85+ogXKgPTUW/Ki9GfPscStgYpDTJ4NfR/CvsoN5obKx45e+rgdEoMCWH
   l9tClxzVgdNzujirLvkysGTXTz+/cyysfN6Y6HTy8fOiR0LTvjm/KvBD5
   ieaAfFZKc0HuZeDQSJGA6UJKS4VP6BvNXrf+C3u67Z1rNs2e9HfSm5h+N
   04u99S+1RdXuiSeBr22GgVhJhvVEWoZtDsSp8gvK1svBKP1HqSSxBMtcW
   A==;
X-CSE-ConnectionGUID: nTCTfvPzQbWc6Jb8y9NqOQ==
X-CSE-MsgGUID: WcgDSBjqSHe4ijD3sHHaVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60373260"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60373260"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 06:48:28 -0700
X-CSE-ConnectionGUID: az/vML4+RtWr+ehkYnJVaQ==
X-CSE-MsgGUID: SgUMY2tCSciovAZon0AKpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,272,1751266800"; 
   d="scan'208";a="175662374"
Received: from alorchar-mobl.amr.corp.intel.com (HELO [10.125.81.45]) ([10.125.81.45])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 06:48:23 -0700
Message-ID: <5036681a-57ed-4fa2-ac0a-bfe235a17e2a@linux.intel.com>
Date: Wed, 17 Sep 2025 06:48:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/5] x86/boot, KVM: Move VMXON/VMXOFF handling from
 KVM to CPU lifecycle
To: Sean Christopherson <seanjc@google.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-pm@vger.kernel.org, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, pavel@kernel.org, brgerst@gmail.com,
 david.kaplan@amd.com, peterz@infradead.org, andrew.cooper3@citrix.com,
 kprateek.nayak@amd.com, chao.gao@intel.com, rick.p.edgecombe@intel.com,
 dan.j.williams@intel.com
References: <20250909182828.1542362-1-xin@zytor.com>
 <aMLakCwFW1YEWFG4@google.com>
 <0387b08a-a8b0-4632-abfc-6b8189ded6b4@linux.intel.com>
 <aMmkZlWl4TiS2qm8@google.com>
Content-Language: en-US
From: Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <aMmkZlWl4TiS2qm8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/2025 10:54 AM, Sean Christopherson wrote:
  what the problem is with having VMXON unconditionally enabled?
> 
> Unlike say EFER.SVME, VMXON fundamentally changes CPU behavior.  E.g. blocks INIT,

blocking INIT is clearly a thing, and both KVM and this patch series deal with that by vmxoff before offline/kexec/etc cases

> activates VMCS caches (which aren't cleared by VMXOFF on pre-SPR CPUs, and AFAIK
> Intel hasn't even publicly committed to that behavior for SPR+),

the VMCS caches aren't great for sure -- which is why the behavior of having vmx on all the time and only
vmxoff at a "fatal to execution" point (offline, kexec, ..) is making life simpler, by not dealing
with this at runtime


 > restricts allowed> CR0 and CR4 values, raises questions about ucode patch updates, triggers unique
> flows in SMI/RSM, prevents Intel PT from tracing on certain CPUs, and probably a
> few other things I'm forgetting.

I went through a similar mental list and my conclusion was a bit different.
The behavior changes are minor at best ..
And yes there are a few things different in microcode -- but the reality is that every day millions of
servers and laptops/etc all run with vmxon (by virtue of running KVM or other virtualization)
all day long, day in day out -- and it is not causing any issues at all.

An argument that any supposed behavior change is unacceptable also implies virtualization
itself would run into that same argument... and a LOT of the world runs virtualized.



