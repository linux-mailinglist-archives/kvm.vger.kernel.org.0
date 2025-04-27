Return-Path: <kvm+bounces-44515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D311A9E233
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 11:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFC607AE465
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C0324C08D;
	Sun, 27 Apr 2025 09:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzRwLoAR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB89246335
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 09:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745746952; cv=none; b=WgjjHPRneCboAA2noHfVZhf5WNOoOnJ5i2wgEwK8YrgPQVWiDCMaBWSWZ0JDjwyzgA5DvHBj74XzGqjfi97B7ee2m6uE2I2IFraMcFI0QzqM4d3o1EHlXt2Oci2OmRH1W+T9AZNhQTztWRPtyOjRBbWCSBygR4OrhgTV1qzeu+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745746952; c=relaxed/simple;
	bh=20rtXIKpVHePMp/s5NOBXpbrgNMBI6Ac2g1H+IRiiLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TQ3/FjFvek3Gcfada5ej35yb32p8JceJ5Bd8FocMnYlx9nmCDuWn8sbn1nRRDRxHyTWdC8O2Z0zpTY7qm7OeX7wek8xmcijZvA4jyohm5YYq3IgLa/He7gVvOU1xaWr3gw5UNwvAy1JqFqkeNXUlxDl9r07cau6s6g+Wv3rxPGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzRwLoAR; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745746951; x=1777282951;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=20rtXIKpVHePMp/s5NOBXpbrgNMBI6Ac2g1H+IRiiLA=;
  b=mzRwLoARF/GixZC5883T6oChLDXV2EOTQfrfC1aNAjvL0x0Uo56at6eD
   tn8FB3ERg4U5DJY5mKV9zzIAclInXsvHHiDoeI0wpNcF154RHaz6KLgyr
   AIrgLm1oB4LCQ9kHcDnEID+V2LpGkBYHDroFzNY0JPvA5U6P+suwLERet
   gOansteTXcrGBKqoHo8vu6O4KKK+Qoq4bAN4RN9KxrfUUKl85mQkypGGd
   pMgayiSkvBk/5KJIFwmILuKCn7GLavu2slV+k5G6PGY+SH48c+fuASw2q
   DX24gapo64791ns2deZe/pEnxzdzc8BB/5ClIK+R38cS5yaJib3+gp3Py
   g==;
X-CSE-ConnectionGUID: M4tB6PhTR86p9CkvvwVrhA==
X-CSE-MsgGUID: MHR1Kr+CQZuQY02a4Q5HyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47438873"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="47438873"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 02:42:30 -0700
X-CSE-ConnectionGUID: zj6lZ3H8QjOQTMsxinQBnw==
X-CSE-MsgGUID: tMiRphQHRkWlAdVlJsZJiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="133759400"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 02:42:27 -0700
Message-ID: <4ee686a3-6970-4560-b0ad-00329d773148@linux.intel.com>
Date: Sun, 27 Apr 2025 17:42:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] target/i386: Support
 VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Zide Chen <zide.chen@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>,
 Mingwei Zhang <mizhang@google.com>, Das Sandipan <Sandipan.Das@amd.com>,
 Shukla Manali <Manali.Shukla@amd.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
 <20250324123712.34096-4-dapeng1.mi@linux.intel.com>
 <aA3w2PiRuNOMKwdM@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aA3w2PiRuNOMKwdM@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/27/2025 4:54 PM, Zhao Liu wrote:
>> @@ -4212,7 +4213,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>>              VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>>              VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
>>              VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
>> -            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
>> +            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
>> +            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
>>          .features[FEAT_VMX_MISC] =
>>              MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
>>              MSR_VMX_MISC_VMWRITE_VMEXIT,
>> @@ -4368,7 +4370,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>>              VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>>              VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
>>              VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
>> -            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
>> +            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
>> +            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
>>          .features[FEAT_VMX_MISC] =
>>              MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
>>              MSR_VMX_MISC_VMWRITE_VMEXIT,
>> @@ -4511,7 +4514,8 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>>              VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>>              VMX_VM_EXIT_ACK_INTR_ON_EXIT | VMX_VM_EXIT_SAVE_IA32_PAT |
>>              VMX_VM_EXIT_LOAD_IA32_PAT | VMX_VM_EXIT_SAVE_IA32_EFER |
>> -            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER,
>> +            VMX_VM_EXIT_LOAD_IA32_EFER | VMX_VM_EXIT_SAVE_VMX_PREEMPTION_TIMER |
>> +            VMX_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
>>          .features[FEAT_VMX_MISC] =
>>              MSR_VMX_MISC_STORE_LMA | MSR_VMX_MISC_ACTIVITY_HLT |
>>              MSR_VMX_MISC_VMWRITE_VMEXIT,
> Instead of modifying SPR's CPU model directly, we should introduce a new
> version (SapphireRapids-v4), like Skylake-Server-v4 enables
> "vmx-eptp-switching".

Sure. Let me have a look this.


>

