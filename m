Return-Path: <kvm+bounces-55084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D7FB2D169
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 03:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF51A7A96DD
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB15239E63;
	Wed, 20 Aug 2025 01:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjOpfZNh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4532384A35;
	Wed, 20 Aug 2025 01:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755653471; cv=none; b=L4XaPPmz83FOkL31DAQGdXGhp05ns+wy17EUliwx95X2cakB3kgzOb5dcU+evVpvJCTvCFy62so9ymXwrpTF72JrM6Za0cDlfavHTmAy/hemN0BaTD3TwdGYVZhwqRSEqhCb1as9OJ3JPWzeL5hK3+6ca1Hp4J0dOeUotTaXeNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755653471; c=relaxed/simple;
	bh=hPEKBbCOd3a0Z6vF81IsM5EYiUpnvTJYYmrfXW+FmGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tLhfO8W/J1Yf/01qL71n32MsqheePROi4jDGzvXTFaEom4DKvXhndjAVLfTteXczrUuzcDtGdaibweiFzgYQIpD+F5C7jnm9HX6AhdQzLlxtAYBi7mF/JBsHAruokd8rK+0sGivzzuEUqJJf8EvS9SKuSBv42KeG2CoL4C133xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjOpfZNh; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755653468; x=1787189468;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hPEKBbCOd3a0Z6vF81IsM5EYiUpnvTJYYmrfXW+FmGc=;
  b=gjOpfZNh+uRWxlVEnaxfYQKvH0ofwGcZC6yXxKV6Euqmzcq5wbALBCqx
   pEqR2vtoT54jj2j7iiXSZR7K07MywruJhsZZiOtm2iyALICJgr883pRrq
   +Fctay3lYlNjbMFm1j0flSVk7Pf2KfIDVivFKmrWXDL1j83hxSEAK+7CB
   BI9aOLH5TrBJAj8+/sbTBKnGwrxt306ECQuy7B+azWcD11SWyVi+1eeDs
   NmN9OGOZHlHnx8q7E9xqBzqyC97ZAt/ZMNNhfa7leD8sdBDZzFN6ZjMHw
   PcE+Hy+r7vL6RQIzBPfxLfpO/gZcBQnoQYyqhZosqCTDgYpa9k/uGgZYw
   Q==;
X-CSE-ConnectionGUID: m38egWaFRWWPwlYN6rIflQ==
X-CSE-MsgGUID: D7OtNJkZQSW4M6962v0acg==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="80503843"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="80503843"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 18:31:08 -0700
X-CSE-ConnectionGUID: uz38ZCu9SKywdtLvNGzngg==
X-CSE-MsgGUID: 3ugJFCZVRGiGlCrpNy/SGg==
X-ExtLoop1: 1
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 18:31:04 -0700
Message-ID: <f59e7fe1-b0e1-4f0d-b4da-cf485d8f9914@intel.com>
Date: Wed, 20 Aug 2025 09:31:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Chao Gao <chao.gao@intel.com>,
 Len Brown <len.brown@intel.com>, Kai Huang <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yan Y Zhao <yan.y.zhao@intel.com>, Ira Weiny <ira.weiny@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
 <20250816144436.83718-2-adrian.hunter@intel.com>
 <aKMzEYR4t4Btd7kC@google.com>
 <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
 <968d2750-cbd6-47cb-b2fc-d0894662dafc@intel.com>
 <fb858e9d16762fbc9c44ef357c670c475f559709.camel@intel.com>
 <aKUKVdonFGwUZI_k@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aKUKVdonFGwUZI_k@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/20/2025 7:35 AM, Sean Christopherson wrote:
> On Tue, Aug 19, 2025, Rick P Edgecombe wrote:
>> On Tue, 2025-08-19 at 10:38 +0300, Adrian Hunter wrote:
>>> On 18/08/2025 21:49, Edgecombe, Rick P wrote:
>>>> Attn: Binbin, Xiaoyao
>>>>
>>>> On Mon, 2025-08-18 at 07:05 -0700, Sean Christopherson wrote:
>>>>> NAK.
>>>>>
>>>>> Fix the guest, or wherever else in the pile there are issues.  KVM is NOT carrying
>>>>> hack-a-fixes to workaround buggy software/firmware.  Been there, done that.
>>>>
>>>> Yes, I would have thought we should have at least had a TDX module change option
>>>> for this.
>>>
>>> That would not help with existing TDX Modules, and would possibly require
>>> a guest opt-in, which would not help with existing guests.  Hence, to start
>>> with disabling the feature first, and look for another solution second.
>>
>> I think you have the priorities wrong. There are only so many kludges we can ask
>> KVM to take. Across all the changes people want for TDX, do you think not having
>> to update the TDX module, backport a guest fix or even just adjust qemu args is
>> more important the other stuff?
> 
> I'm especially sensitive to fudging around _bugs_ in other pieces of the stack.
> KVM has been burned badly, multiple times, by hacking around issues elsewhere.
> There are inevitably cases where throwing something into KVM is the least awful
> choice (usually because it's the only feasible choise), but this ain't one of
> those cases.
> 
>> TDX support is still very early. We need to think about long term sustainable
>> solutions. So a fix that doesn't support existing TDX modules or guests (the
>> intel_idle fix is also in this category anyway) should absolutely be on the
>> table.
>>
>>>
>>> In the MWAIT case, Sean has rejected supporting MSR_PKG_CST_CONFIG_CONTROL
>>> even for VMX, because it is an optional MSR, so altering intel_idle is
>>> being proposed.
> 
> No, I rejected support MSR_PKG_CST_CONFIG_CONTROL _in KVM_ because I don't see
> any reason to shove information into KVM.  AFAICT, it's not an "architectural"
> MSR, and all of KVM's existing handling of truly uarch/model-specific MSRs is
> painful and ugly.

E.g., for MSR_IA32_POWER_CTL (I don't know why it has _IA32_ in the 
name, it seems to me not an architectural MSR), KVM chose to just 
emulate the read/write of it as NOP to workaround the issue that guest 
driver will access it after MWAIT is allowed natively for the guest.

TDX allowed the same workaround by returning true for MSR_IA32_POWER_CTL 
in tdx_has_emulated_msr(). So that when td guest requests emulation from 
KVM on #VE, the workaround can come into play. But with #VE reduction 
enabled by the TD guest, no #VE anymore but #GP.

It seems we cannot remove the workaround because that will break the 
existing guests who rely on the workaround.

> And userspace (e.g. QEMU) could support emulate MSR_PKG_CST_CONFIG_CONTROL (and
> any other MSRs of that nature) via MSR filters.  I doubt the MSR is accessed
> outside of boot paths, so the cost of a userspace exit should be a non-issue.
> Of course, QEMU probably can't provide useful/accurate information.
> 
> One option if there is a super strong need to do so would be to add a "disable
> exits" capability to let the guest read package c-state MSRs, but that has
> obvious downsides and would still just be fudging around a flawed driver.

I have thought about this option as well. Unfortunately there are WRITE 
case in the driver, and we cannot simply pass through WRITE.

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8dbf19aa66ef..c254aa26ff22 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4120,6 +4120,15 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>                  vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
>                  vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
>          }
> +       if (kvm_package_cstate_in_guest(vcpu->kvm)) {
> +               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_CST_CONFIG_CONTROL, MSR_TYPE_R);
> +               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C2_RESIDENCY, MSR_TYPE_R);
> +               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C3_RESIDENCY, MSR_TYPE_R);
> +               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C6_RESIDENCY, MSR_TYPE_R);
> +               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C8_RESIDENCY, MSR_TYPE_R);
> +               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C9_RESIDENCY, MSR_TYPE_R);
> +               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C10_RESIDENCY, MSR_TYPE_R);
> +       }
>          if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
>                  vmx_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R);
>                  vmx_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);


