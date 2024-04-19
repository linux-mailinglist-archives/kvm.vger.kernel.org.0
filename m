Return-Path: <kvm+bounces-15183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDBA8AA6FD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 04:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A618328306B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 02:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C1F7494;
	Fri, 19 Apr 2024 02:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TBL2myTo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980DC137E;
	Fri, 19 Apr 2024 02:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713494026; cv=none; b=jPYoZPoVv8bMqpYPN/pfXBa4ak68MlFnhvaIpIvFpa43DJ5xQysRasDvGN83C6ael9dwKiufTPbhXZXdNmOdTuHCwz757dRk7+D7x5jWAwzWMVIqn8qryn2hwZRafLS/84Ztotz8Z9yQTC/P7HiOySrROs3FXLTeU0IR/aW0Fzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713494026; c=relaxed/simple;
	bh=2wIhKyVav/6pmMUaeB/ndew7d5QjwaWfJyhDVU1jIHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XSFA4irfDbdCn+jWHcXRcOSuOQ3sVOH3Z4ItSYXdlTwm6AuJdCldIkexe/HBblO1mtrPBSlfyLC0Fy7H3pEFfZOhBbfTn7nIshXfNlqYaL4Rk6enLFT8tVFnkkcoAIKUgR527QoXNT9Cw+G6+LOvuzXxqzl53AwPllCyd19vcGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TBL2myTo; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713494024; x=1745030024;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2wIhKyVav/6pmMUaeB/ndew7d5QjwaWfJyhDVU1jIHU=;
  b=TBL2myToGfCdXgLfZoXVl4ubrkWLRDNbA6/WgR+cX8ymehEdx1v0KYkN
   fZzQeHGXvv5Pumk9G7ok8pepRNte3YQaWO4OIGwVsy5/T9KA1W5CjHJeg
   0tRZzuIOWDuESW6xZeXHIvH3iCBFiNHQGDDCc0lRLZ9tvT4DPWc6MkQ/5
   Uj5u6Sw0j50u3o7qbyf3pHXq70N0/O33Rp4TMTz62xSjtzOCtTXp21QF/
   AF72b+ks2nIfXDJLnYXsa/SZ5mv4vW/f1BNIyLxvExlrEl7xMOHMauDEL
   XLI2e0Q9oXjP0omf+Yw+52Gl4LS8z3p6axg4/iqszHIdp3N6IXG4ZhmEs
   w==;
X-CSE-ConnectionGUID: bsE9WiQISEqCZwOLZJ9pNw==
X-CSE-MsgGUID: CEhCkaGRRUmPbPGKip8zZQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9003502"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="9003502"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 19:33:44 -0700
X-CSE-ConnectionGUID: CqasudqxRLCQuA3e+VqL5Q==
X-CSE-MsgGUID: sgCaoODlTh2JdEssWqKUIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54106958"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 19:33:40 -0700
Message-ID: <fac35db2-f796-4d9e-86d4-77f171b6e38e@linux.intel.com>
Date: Fri, 19 Apr 2024 10:33:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 111/130] KVM: TDX: Implement callbacks for MSR
 operations for TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implements set_msr/get_msr/has_emulated_msr methods for TDX to handle
> hypercall from guest TD for paravirtualized rdmsr and wrmsr.  The TDX
> module virtualizes MSRs.  For some MSRs, it injects #VE to the guest TD
> upon RDMSR or WRMSR.  The exact list of such MSRs are defined in the spec.
>
> Upon #VE, the guest TD may execute hypercalls,
> TDG.VP.VMCALL<INSTRUCTION.RDMSR> and TDG.VP.VMCALL<INSTRUCTION.WRMSR>,
> which are defined in GHCI (Guest-Host Communication Interface) so that the
> host VMM (e.g. KVM) can virtualize the MSRs.
>
> There are three classes of MSRs virtualization.
> - non-configurable: TDX module directly virtualizes it. VMM can't
>    configure. the value set by KVM_SET_MSR_INDEX_LIST is ignored.
> - configurable: TDX module directly virtualizes it. VMM can configure at
>    the VM creation time.  The value set by KVM_SET_MSR_INDEX_LIST is used.
> - #VE case
>    Guest TD would issue TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR> and
>    VMM handles the MSR hypercall. The value set by KVM_SET_MSR_INDEX_LIST
>    is used.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
[...]
> +
> +bool tdx_has_emulated_msr(u32 index, bool write)
> +{
> +	switch (index) {
> +	case MSR_IA32_UCODE_REV:
> +	case MSR_IA32_ARCH_CAPABILITIES:
> +	case MSR_IA32_POWER_CTL:
> +	case MSR_IA32_CR_PAT:
> +	case MSR_IA32_TSC_DEADLINE:
> +	case MSR_IA32_MISC_ENABLE:
> +	case MSR_PLATFORM_INFO:
> +	case MSR_MISC_FEATURES_ENABLES:
> +	case MSR_IA32_MCG_CAP:
> +	case MSR_IA32_MCG_STATUS:
It not about this patch directly.

Intel SDM says:
"An attempt to write to IA32_MCG_STATUS with any value other than 0 
would result in #GP".

But in set_msr_mce(), IA32_MCG_STATUS is set without any check.
Should it be checked against 0 if it is not host_initiated？



