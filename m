Return-Path: <kvm+bounces-50948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A04AEAE87
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 07:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 538B21C20769
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 05:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5271E0DBA;
	Fri, 27 Jun 2025 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UPMsTKpL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C164A0C;
	Fri, 27 Jun 2025 05:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751002893; cv=none; b=p/l7yyRR3TedpziiH/ziiVZYL93qf/UaC5+an81srDtjyQvhwaBbKcBlQLPt1gVxbdx7M1zvvAFQisyhJtZS5NwPV3+ZETHTRmKrAEf280kOC7BC1nihdr8++pc5IaLVo6Ta49gfCYZejQ62vDRf48LMAnE3DiE97Mb2XgQ/zfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751002893; c=relaxed/simple;
	bh=dUm1yrHhH24CENQYmfpWDm2x5uhPiAm3sLBZRyUUA0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FllLf6EJLWIratYo6Obz8kT/1TAv0XIXghz3gj0t+fcPsGSrB8Rfu0mFjl1nkFfeoD69a5JVnHd+v1PfOSlPrVDayA028HPVidlDFed/CxFYoN+79TXdPIdS+7ogk9kQ9AgdqX4W3iPI1gROF5qX3KOx7u9qNmvZg7jQyxfrLcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UPMsTKpL; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751002892; x=1782538892;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dUm1yrHhH24CENQYmfpWDm2x5uhPiAm3sLBZRyUUA0k=;
  b=UPMsTKpLoU+aQqHHFXziuD4OEEpxNSEmFmF717ROtxMyPscmTT0RXNVe
   mH16fVC/XaGCUCmZeH/VmZnAYr/y5rcdSzgkY4hv0hpVfopbQkODNbRuH
   DMzi5399r4IkVmEOQgwXQRbFa9R7CtI7KTPOeEOjvMzjYD5fEkhF1paGt
   ZjuS4+sHo1nbirQROhD/fkjTge99zjlPmJTxAh7I94esqptx2hBTHhmIt
   Djnu+uE5K2NvCBOXpHb1B2MpGtcDo4ti+CyJJvYmGP6AJxy1ootGF+6OH
   hyptYdyTL9AFmzODZ5XwRTPQrBoSS5j55gAhrYt/Doz3t9ArIc7ZRUMP/
   A==;
X-CSE-ConnectionGUID: u3Zd68ruShaEQr1giRXypg==
X-CSE-MsgGUID: r4e9Wag+QBO9++ZI1h3qSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53182613"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="53182613"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 22:41:32 -0700
X-CSE-ConnectionGUID: PxZkQBxTTY2I18IgDbybEw==
X-CSE-MsgGUID: FVMUb/POSQaRwjPra/uBzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="189914632"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 22:41:28 -0700
Message-ID: <67bd4e2f-24a8-49d8-80af-feaca6926e45@intel.com>
Date: Fri, 27 Jun 2025 13:41:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Sean Christopherson <seanjc@google.com>,
 Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
 x86@kernel.org, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
 Jim Mattson <jmattson@google.com>
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
 <aF1S2EIJWN47zLDG@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aF1S2EIJWN47zLDG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/2025 10:02 PM, Sean Christopherson wrote:
> +Jim
> 
> For the scope, "KVM: x86:"
> 
> On Thu, Jun 26, 2025, Alexandre Chartre wrote:
>> KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
>> However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
>> so it makes no sense to emulate it on AMD.
>>
>> The AMD documentation specifies that this MSR is not defined on
>> the AMD architecture. So emulating this MSR on AMD can even cause
>> issues (like Windows BSOD) as the guest OS might not expect this
>> MSR to exist on such architecture.
>>
>> Signed-off-by: Alexandre Chartre<alexandre.chartre@oracle.com>
>> ---
>>
>> A similar patch was submitted some years ago but it looks like it felt
>> through the cracks:
>> https://lore.kernel.org/kvm/20190307093143.77182-1- 
>> xiaoyao.li@linux.intel.com/
> It didn't fall through the cracks, we deliberately elected to emulate the MSR in
> common code so that KVM's advertised CPUID support would match KVM's emulation.
> 
>    On Thu, 2019-03-07 at 19:15 +0100, Paolo Bonzini wrote:
>    > On 07/03/19 18:37, Sean Christopherson wrote:
>    > > On Thu, Mar 07, 2019 at 05:31:43PM +0800, Xiaoyao Li wrote:
>    > > > At present, we report F(ARCH_CAPABILITIES) for x86 arch(both vmx and svm)
>    > > > unconditionally, but we only emulate this MSR in vmx. It will cause #GP
>    > > > while guest kernel rdmsr(MSR_IA32_ARCH_CAPABILITIES) in an AMD host.
>    > > >
>    > > > Since MSR IA32_ARCH_CAPABILITIES is an intel-specific MSR, it makes no
>    > > > sense to emulate it in svm. Thus this patch chooses to only emulate it
>    > > > for vmx, and moves the related handling to vmx related files.
>    > >
>    > > What about emulating the MSR on an AMD host for testing purpsoes?  It
>    > > might be a useful way for someone without Intel hardware to test spectre
>    > > related flows.
>    > >
>    > > In other words, an alternative to restricting emulation of the MSR to
>    > > Intel CPUS would be to move MSR_IA32_ARCH_CAPABILITIES handling into
>    > > kvm_{get,set}_msr_common().  Guest access to MSR_IA32_ARCH_CAPABILITIES
>    > > is gated by X86_FEATURE_ARCH_CAPABILITIES in the guest's CPUID, e.g.
>    > > RDMSR will naturally #GP fault if userspace passes through the host's
>    > > CPUID on a non-Intel system.
>    >
>    > This is also better because it wouldn't change the guest ABI for AMD
>    > processors.  Dropping CPUID flags is generally not a good idea.
>    >
>    > Paolo
> 
> I don't necessarily disagree about emulating ARCH_CAPABILITIES being pointless,
> but Paolo's point about not changing ABI for existing setups still stands.  This
> has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KVM: x86: Emulate
> MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back to when KVM
> enumerated support without emulating the MSR (commit 1eaafe91a0df ("kvm: x86:
> IA32_ARCH_CAPABILITIES is always supported").
> 
> And it's not like KVM is forcing userspace to enumerate support for
> ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate support.  So
> while I completely agree KVM's behavior is odd and annoying for userspace to deal
> with, this is probably something that should be addressed in userspace.
> 
>> I am resurecting this change because some recent Windows updates (like OS Build
>> 26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUPPORTED PROCESSOR)
>> just because the ARCH_CAPABILITIES is available.

Isn't it the Windows bugs? I think it is incorrect to assume AMD will 
never implement ARCH_CAPABILITIES.


